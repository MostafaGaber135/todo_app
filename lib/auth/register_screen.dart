import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_theme.dart';
import 'package:todo_app/auth/login_screen.dart';
import 'package:todo_app/auth/user_provider.dart';
import 'package:todo_app/firebase_functions.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/tabs/settings/settings_provider.dart';
import 'package:todo_app/widgets/custom_elevated_button.dart';
import 'package:todo_app/widgets/custom_text_form_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static const String routeName = '/register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  String passwordPattern =
      r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
  String namePattern = r'^[A-Za-z\s]{2,50}$';
  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.register,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: settingsProvider.isDark
                      ? AppTheme.white
                      : AppTheme.backgroundColorBottomNavigationBar,
                ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextFormField(
                  controller: nameController,
                  hintText: AppLocalizations.of(context)!.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.pleaseEnterYourName;
                    } else if (!validateName(value)) {
                      return AppLocalizations.of(context)!.enteraValidName;
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomTextFormField(
                  controller: emailController,
                  hintText: AppLocalizations.of(context)!.email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.pleaseEnterYourEmail;
                    } else if (!validateEmail(value)) {
                      return AppLocalizations.of(context)!.enteraValidEmail;
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomTextFormField(
                  controller: passwordController,
                  hintText: AppLocalizations.of(context)!.password,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!
                          .pleaseEnterYourPassword;
                    } else if (!validatePassword(value)) {
                      return AppLocalizations.of(context)!.enteraValidPassword;
                    }
                    return null;
                  },
                  isPassword: true,
                ),
                const SizedBox(
                  height: 32,
                ),
                CustomElevatedButton(
                  label: AppLocalizations.of(context)!.register,
                  onPressed: register,
                ),
                const SizedBox(
                  height: 8,
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pushReplacementNamed(
                    LoginScreen.routeName,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.alreadyHaveAnAccount,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void register() {
    if (formKey.currentState!.validate()) {
      FirebaseFunctions.register(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
      ).then(
        (user) {
          if (!mounted) return;
          Provider.of<UserProvider>(
            context,
            listen: false,
          ).updateUser(user);
          Navigator.of(context).pushReplacementNamed(
            HomeScreen.routeName,
          );
          Fluttertoast.showToast(
            msg: "Account created successfully!",
            backgroundColor: AppTheme.green,
          );
        },
      ).catchError(
        (error) {
          String? message;
          if (error is FirebaseAuthException) {
            message = error.message;
          }

          Fluttertoast.showToast(
            msg: message ?? "Something went wrong",
            backgroundColor: AppTheme.red,
          );
        },
      );
    }
  }

  bool validateEmail(String email) {
    RegExp regex = RegExp(emailPattern);
    return regex.hasMatch(email);
  }

  bool validatePassword(String password) {
    RegExp regex = RegExp(passwordPattern);
    return regex.hasMatch(password);
  }

  bool validateName(String name) {
    RegExp regex = RegExp(namePattern);
    return regex.hasMatch(name);
  }
}

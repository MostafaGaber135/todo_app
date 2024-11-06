import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_theme.dart';
import 'package:todo_app/auth/forgot_password.dart';
import 'package:todo_app/auth/register_screen.dart';
import 'package:todo_app/auth/user_provider.dart';
import 'package:todo_app/firebase_functions.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:todo_app/tabs/settings/settings_provider.dart';
import 'package:todo_app/widgets/custom_elevated_button.dart';
import 'package:todo_app/widgets/custom_text_form_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  String passwordPattern =
      r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.login,
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
                  label: AppLocalizations.of(context)!.login,
                  onPressed: login,
                ),
                const SizedBox(
                  height: 8,
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pushReplacementNamed(
                    RegisterScreen.routeName,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.donthaveaccount,
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pushReplacementNamed(
                    ForgotPassword.routeName,
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.forgotPassowrd,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login() {
    if (formKey.currentState!.validate()) {
      FirebaseFunctions.login(
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
            msg: AppLocalizations.of(context)!.loginSuccessful,
            backgroundColor: AppTheme.green,
          );
        },
      ).catchError((error) {
        String? message;
        if (error is FirebaseAuthException) {
          message = error.message;
        }

        if (!mounted) return;
        Fluttertoast.showToast(
          msg: message ?? AppLocalizations.of(context)!.somethingWentWrong,
          backgroundColor: AppTheme.red,
        );
      });
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
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/auth/login_screen.dart';
import 'package:todo_app/app_theme.dart';
import 'package:todo_app/tabs/settings/settings_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/widgets/custom_elevated_button.dart';
import 'package:todo_app/widgets/custom_text_form_field.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});
  static const String routeName = '/forgot-password';
  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  String passwordPattern =
      r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _validateAndSubmit() async {
    if (_validateAndSave()) {
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: emailController.text);
        if (!mounted) return;
        Fluttertoast.showToast(
          msg: AppLocalizations.of(context)!.passwordResetEmailSent,
          backgroundColor: AppTheme.green,
        );
      } catch (error) {
        String? message;
        if (!mounted) return;
        Fluttertoast.showToast(
          msg: message ?? AppLocalizations.of(context)!.somethingWentWrong,
          backgroundColor: AppTheme.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(
            AppLocalizations.of(context)!.forgotPassowrd,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color:
                      settingsProvider.isDark ? AppTheme.white : AppTheme.black,
                ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            right: 20,
            left: 20,
          ),
          child: Form(
            key: _formKey,
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
                CustomElevatedButton(
                    label: AppLocalizations.of(context)!.submit,
                    onPressed: _validateAndSubmit),
                const SizedBox(height: 16.0),
                GestureDetector(
                  onTap: _navigateToSignIn,
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.haveAnAccount,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: settingsProvider.isDark
                                      ? AppTheme.white
                                      : AppTheme.black,
                                ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        AppLocalizations.of(context)!.login,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validateEmail(String email) {
    RegExp regex = RegExp(emailPattern);
    return regex.hasMatch(email);
  }

  void _navigateToSignIn() {
    Navigator.of(context).pushReplacementNamed(
      LoginScreen.routeName,
    );
  }
}

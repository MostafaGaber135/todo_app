import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/auth/login_screen.dart';
import 'package:todo_app/app_theme.dart';
import 'package:todo_app/tabs/settings/settings_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/widgets/custom_elevated_button.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});
  static const String routeName = '/forgot-password';
  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

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
                TextFormField(
                  style: TextStyle(
                    color: settingsProvider.isDark
                        ? AppTheme.white
                        : AppTheme.black,
                  ),
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.email,
                    labelStyle: const TextStyle(
                      color: AppTheme.primary,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppTheme.primary,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppTheme.primary,
                      ),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppTheme.primary,
                      ),
                    ),
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppLocalizations.of(context)!.pleaseEnterYourEmail;
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return AppLocalizations.of(context)!.enteraValidEmail;
                    }
                    return null;
                  },
                  onSaved: (value) => emailController.text = value!,
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

  void _navigateToSignIn() {
    Navigator.of(context).pushReplacementNamed(
      LoginScreen.routeName,
    );
  }
}

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
import 'package:todo_app/widgets/custom_elevated_button.dart';
import 'package:todo_app/widgets/custom_text_form_field.dart';

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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Login',
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
                  hintText: 'Email',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!validateEmail(value)) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomTextFormField(
                  controller: passwordController,
                  hintText: 'Password',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    } else if (!validatePassword(value)) {
                      return 'Enter a valid password';
                    }
                    return null;
                  },
                  isPassword: true,
                ),
                const SizedBox(
                  height: 32,
                ),
                CustomElevatedButton(
                  label: 'Login',
                  onPressed: login,
                ),
                const SizedBox(
                  height: 8,
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pushReplacementNamed(
                    RegisterScreen.routeName,
                  ),
                  child: const Text(
                    "Don't have an account!",
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pushReplacementNamed(
                    ForgotPassword.routeName,
                  ),
                  child: const Text(
                    "Forgot password?",
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
            msg: "Login successful!",
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
}

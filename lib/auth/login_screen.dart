import 'package:flutter/material.dart';
import 'package:todo_app/auth/register_screen.dart';
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
                      if (value == null || value.trim().length < 5) {
                        return 'Email can not be less than 5 characters';
                      } else {
                        return null;
                      }
                    }),
                const SizedBox(
                  height: 16,
                ),
                CustomTextFormField(
                  controller: passwordController,
                  hintText: 'Password',
                  validator: (value) {
                    if (value == null || value.trim().length < 8) {
                      return 'Password can not be less than 8 characters';
                    } else {
                      return null;
                    }
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void login() {
    if (formKey.currentState!.validate()) {}
  }
}

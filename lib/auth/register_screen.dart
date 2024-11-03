import 'package:flutter/material.dart';
import 'package:todo_app/auth/login_screen.dart';
import 'package:todo_app/widgets/custom_elevated_button.dart';
import 'package:todo_app/widgets/custom_text_form_field.dart';

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
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Register',
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
                    hintText: 'Name',
                    validator: (value) {
                      if (value == null || value.trim().length < 4) {
                        return 'Name can not be less than 5 characters';
                      } else {
                        return null;
                      }
                    }),
                const SizedBox(
                  height: 16,
                ),
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
                  label: 'Register',
                  onPressed: register,
                ),
                const SizedBox(
                  height: 8,
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pushReplacementNamed(
                    LoginScreen.routeName,
                  ),
                  child: const Text(
                    "Already have an account!",
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
    if (formKey.currentState!.validate()) {}
  }
}

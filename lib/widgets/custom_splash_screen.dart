import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_theme.dart';
import 'package:todo_app/auth/login_screen.dart';
import 'package:todo_app/tabs/settings/settings_provider.dart';

class CustomSplashScreen extends StatelessWidget {
  const CustomSplashScreen({super.key});
  static const String routeName = '/splash';
  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    Timer(
        const Duration(
          seconds: 3,
        ), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    });
    return Scaffold(
      backgroundColor: settingsProvider.isDark
          ? AppTheme.backgroundDark
          : AppTheme.backgroundLight,
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
        ),
      ),
    );
  }
}

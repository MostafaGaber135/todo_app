import 'package:flutter/material.dart';
import 'package:todo/screens/home_screen.dart';
import 'package:todo/widgets/custom_splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        CustomSplashScreen.routeName: (_) => const CustomSplashScreen(),
        HomeScreen.routeName: (_) => const HomeScreen(),
      },
      initialRoute: CustomSplashScreen.routeName,
      home: const CustomSplashScreen(),
    );
  }
}

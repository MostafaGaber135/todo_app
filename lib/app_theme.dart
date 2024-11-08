import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0XFF5D9CEC);
  static const Color backgroundLight = Color(0XFFDFECDB);
  static const Color backgroundDark = Color(0XFF060E1E);
  static const Color black = Color(0XFF363636);
  static const Color white = Color(0XFFFFFFFF);
  static const Color grey = Color(0XFFC8C9CB);
  static const Color green = Color(0XFF61E757);
  static const Color red = Color(0XFFEC4B4B);
  static const Color backgroundColorBottomNavigationBar = Color(0XFF141922);

  static const Color lightGrey = Color(0XFFDBDBDB);
  static const Color mediumGrey = Color(0XFF707070);
  static const Color darkGrey = Color(0XFF303030);
  static const Color greyTranslucent = Color(0XFFA9A9A9);
  static const Color greyLightTransparent = Color(0XFFCDCACA);
  static const Color offWhite = Color(0XFFFFFFFF);

  static const Color backgroundAlt1 = Color(0XFF200E32);
  static const Color backgroundAlt2 = Color(0XFF3E4A59);
  static const Color backgroundAccent = Color(0XFF56D7BC);
  static const Color blueAccent = Color(0XFF3598DB);
  static const Color darkAccent = Color(0XFF383838);

  static ThemeData lightTheme = ThemeData(
    primaryColor: primary,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      centerTitle: true,
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: WidgetStateProperty.all(
          black,
        ),
      ),
    ),
    scaffoldBackgroundColor: backgroundLight,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: white,
      selectedItemColor: primary,
      unselectedItemColor: grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: white,
      shape: CircleBorder(
        side: BorderSide(
          width: 4,
          color: white,
        ),
      ),
    ),
    textTheme: const TextTheme(
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
      ),
      headlineLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        fontFamily: 'Poppins',
      ),
      bodyLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        fontFamily: 'Roboto',
      ),
      bodyMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        fontFamily: 'Poppins',
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontFamily: 'Inter',
      ),
      labelMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        fontFamily: 'Inter',
      ),
      labelSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        fontFamily: 'Inter',
      ),
      headlineSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        fontFamily: 'Poppins',
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primary,
      ),
    ),
  );
  static ThemeData darkTheme = ThemeData(
    primaryColor: primary,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      centerTitle: true,
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconColor: WidgetStateProperty.all(
          white,
        ),
      ),
    ),
    iconTheme: const IconThemeData(
      color: white,
    ),
    scaffoldBackgroundColor: backgroundDark,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: backgroundColorBottomNavigationBar,
      selectedItemColor: primary,
      unselectedItemColor: grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: white,
      shape: CircleBorder(
        side: BorderSide(
          width: 4,
          color: backgroundColorBottomNavigationBar,
        ),
      ),
    ),
    textTheme: const TextTheme(
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
      ),
      headlineLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        fontFamily: 'Poppins',
      ),
      bodyLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        fontFamily: 'Roboto',
      ),
      bodyMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        fontFamily: 'Poppins',
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        fontFamily: 'Roboto',
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontFamily: 'Inter',
      ),
      labelMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        fontFamily: 'Inter',
      ),
      labelSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        fontFamily: 'Inter',
      ),
      headlineSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        fontFamily: 'Poppins',
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primary,
      ),
    ),
  );
}

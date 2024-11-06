import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/app_theme.dart';

class SettingsProvider with ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;
  String languageCode = 'en';

  SettingsProvider() {
    _loadSettings();
  }

  bool get isDark => themeMode == ThemeMode.dark;

  Color get backgroundColor => isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight;

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    String? savedLanguageCode = prefs.getString('languageCode');
    String? savedThemeMode = prefs.getString('themeMode');

    if (savedLanguageCode != null) {
      languageCode = savedLanguageCode;
    }
    themeMode = (savedThemeMode == 'dark') ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> changeTheme(ThemeMode selectedTheme) async {
    themeMode = selectedTheme;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', selectedTheme == ThemeMode.dark ? 'dark' : 'light');
    notifyListeners();
  }

  Future<void> changeLanguage(String selectedLanguage) async {
    if (selectedLanguage == languageCode) return;
    languageCode = selectedLanguage;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', selectedLanguage);
    notifyListeners();
  }
}

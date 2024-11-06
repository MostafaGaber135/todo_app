import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/app_theme.dart';
import 'package:todo_app/auth/login_screen.dart';
import 'package:todo_app/auth/user_provider.dart';
import 'package:todo_app/firebase_functions.dart';
import 'package:todo_app/tabs/settings/language.dart';
import 'package:todo_app/tabs/tasks/tasks_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_app/tabs/settings/settings_provider.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  List<Language> languages = [
    Language(
      name: 'English',
      code: 'en',
    ),
    Language(
      name: 'العربية',
      code: 'ar',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.logout,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  onPressed: () {
                    FirebaseFunctions.logout();
                    Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
                    Provider.of<TasksProvider>(context, listen: false).resetData();
                    Provider.of<UserProvider>(context, listen: false).updateUser(null);
                  },
                  icon: const Icon(
                    Icons.logout_outlined,
                    size: 28,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.darkMode,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Switch(
                  value: settingsProvider.isDark,
                  onChanged: (isDark) => settingsProvider.changeTheme(
                    isDark ? ThemeMode.dark : ThemeMode.light,
                  ),
                  activeTrackColor: AppTheme.grey,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.language,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton<Language>(
                    value: languages.firstWhere(
                      (language) => language.code == settingsProvider.languageCode,
                    ),
                    items: languages
                        .map((language) => DropdownMenuItem(
                              value: language,
                              child: Text(
                                language.name,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ))
                        .toList(),
                    onChanged: (selectedLanguage) {
                      if (selectedLanguage != null) {
                        settingsProvider.changeLanguage(selectedLanguage.code);
                      }
                    },
                    borderRadius: BorderRadius.circular(20),
                    dropdownColor: settingsProvider.isDark ? AppTheme.primary : AppTheme.primary,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: settingsProvider.isDark ? AppTheme.white : AppTheme.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

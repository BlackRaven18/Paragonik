import 'package:flutter/material.dart';
import 'package:paragonik/data/services/settings_service.dart';

class ThemeNotifier extends ChangeNotifier {
  final SettingsService _settingsService = SettingsService.instance;
  late ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  ThemeNotifier() {
    _themeMode = _settingsService.getThemeMode();
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    _settingsService.setThemeMode(_themeMode);
    notifyListeners();
  }
}

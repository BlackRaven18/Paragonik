import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleNotifier extends ChangeNotifier {
  Locale _locale = const Locale('pl');

  Locale get locale => _locale;

  static const String _languageCodeKey = 'language_code';

  Future<void> setLocale(Locale newLocale) async {
    if (_locale == newLocale) return;

    _locale = newLocale;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageCodeKey, newLocale.languageCode);
  }

  Future<void> loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguageCode = prefs.getString(_languageCodeKey);

    if (savedLanguageCode != null) {
      _locale = Locale(savedLanguageCode);
    }
    notifyListeners();
  }
}

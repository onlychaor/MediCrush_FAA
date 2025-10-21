import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  static const String _userNameKey = 'user_name';
  Locale _locale = const Locale('en'); // Default to English
  String _userName = 'MediCrush User';

  Locale get locale => _locale;
  String get userName => _userName;

  // Supported languages
  static const List<Locale> supportedLocales = [
    Locale('en'), // English
    Locale('vi'), // Vietnamese
    Locale('fr'), // French
  ];

  // Language display names
  static const Map<String, String> languageNames = {
    'en': 'English',
    'vi': 'Tiếng Việt',
    'fr': 'Français',
  };

  // Initialize and load saved language preference
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString(_languageKey);
    final savedUserName = prefs.getString(_userNameKey);
    
    if (savedLanguage != null) {
      _locale = Locale(savedLanguage);
    }
    if (savedUserName != null && savedUserName.trim().isNotEmpty) {
      _userName = savedUserName.trim();
    }
    notifyListeners();
  }

  // Change language
  Future<void> changeLanguage(String languageCode) async {
    if (_locale.languageCode != languageCode) {
      _locale = Locale(languageCode);
      // Save preference
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);
      notifyListeners();
    }
  }

  Future<void> updateUserName(String name) async {
    final newName = name.trim();
    if (newName.isEmpty || newName == _userName) return;
    _userName = newName;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, _userName);
    notifyListeners();
  }

  // Get current language name
  String getCurrentLanguageName() {
    return languageNames[_locale.languageCode] ?? 'Unknown';
  }

  // Get language name by code
  static String getLanguageName(String code) {
    return languageNames[code] ?? 'Unknown';
  }
}


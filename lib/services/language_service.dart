import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  Locale _locale = const Locale('vi'); // Default to Vietnamese

  Locale get locale => _locale;

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
    
    if (savedLanguage != null) {
      _locale = Locale(savedLanguage);
      notifyListeners();
    }
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

  // Get current language name
  String getCurrentLanguageName() {
    return languageNames[_locale.languageCode] ?? 'Unknown';
  }

  // Get language name by code
  static String getLanguageName(String code) {
    return languageNames[code] ?? 'Unknown';
  }
}


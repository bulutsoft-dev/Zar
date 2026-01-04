import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for managing app language/locale
class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'app_language';
  Locale _locale = const Locale('tr'); // Default to Turkish
  
  Locale get locale => _locale;
  
  LanguageProvider() {
    _loadLanguage();
  }
  
  /// Load saved language preference
  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey) ?? 'tr';
    _locale = Locale(languageCode);
    notifyListeners();
  }
  
  /// Set new language
  Future<void> setLanguage(String languageCode) async {
    if (_locale.languageCode == languageCode) return;
    
    _locale = Locale(languageCode);
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
  }
  
  /// Toggle between Turkish and English
  Future<void> toggleLanguage() async {
    final newLanguage = _locale.languageCode == 'tr' ? 'en' : 'tr';
    await setLanguage(newLanguage);
  }
  
  /// Check if current language is Turkish
  bool get isTurkish => _locale.languageCode == 'tr';
  
  /// Check if current language is English
  bool get isEnglish => _locale.languageCode == 'en';
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for managing app language/locale
class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'app_language';
  static const String _firstLaunchKey = 'first_launch_completed';
  Locale _locale = const Locale('tr'); // Default to Turkish
  bool _isFirstLaunch = true;
  
  Locale get locale => _locale;
  bool get isFirstLaunch => _isFirstLaunch;
  
  LanguageProvider() {
    _loadLanguage();
  }
  
  /// Load saved language preference
  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey) ?? 'tr';
    _isFirstLaunch = !(prefs.getBool(_firstLaunchKey) ?? false);
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
  
  /// Mark first launch as completed
  Future<void> completeFirstLaunch() async {
    _isFirstLaunch = false;
    notifyListeners();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstLaunchKey, true);
  }
  
  /// Toggle between languages (cycles through Turkish, English, German)
  Future<void> toggleLanguage() async {
    String newLanguage;
    switch (_locale.languageCode) {
      case 'tr':
        newLanguage = 'en';
        break;
      case 'en':
        newLanguage = 'de';
        break;
      case 'de':
        newLanguage = 'tr';
        break;
      default:
        newLanguage = 'tr';
    }
    await setLanguage(newLanguage);
  }
  
  /// Check if current language is Turkish
  bool get isTurkish => _locale.languageCode == 'tr';
  
  /// Check if current language is English
  bool get isEnglish => _locale.languageCode == 'en';
  
  /// Check if current language is German
  bool get isGerman => _locale.languageCode == 'de';
  
  /// Get current language name
  String get currentLanguageName {
    switch (_locale.languageCode) {
      case 'tr':
        return 'Türkçe';
      case 'en':
        return 'English';
      case 'de':
        return 'Deutsch';
      default:
        return 'Türkçe';
    }
  }
}

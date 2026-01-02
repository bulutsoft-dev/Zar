import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

/// Provider for managing app theme
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = true;
  late SharedPreferences _prefs;
  
  ThemeProvider() {
    _loadTheme();
  }
  
  bool get isDarkMode => _isDarkMode;
  
  Future<void> _loadTheme() async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode = _prefs.getBool(AppConstants.storageKeyTheme) ?? true;
    notifyListeners();
  }
  
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _prefs.setBool(AppConstants.storageKeyTheme, _isDarkMode);
    notifyListeners();
  }
  
  ThemeData get themeData {
    return _isDarkMode ? darkTheme : lightTheme;
  }
  
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(0xFFE94560),
      scaffoldBackgroundColor: const Color(0xFF1A1A2E),
      useMaterial3: true,
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          letterSpacing: 1.2,
          color: Colors.white,
        ),
      ),
    );
  }
  
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: const Color(0xFFE94560),
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      useMaterial3: true,
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
          color: Color(0xFF1A1A2E),
        ),
        bodyLarge: TextStyle(
          letterSpacing: 1.2,
          color: Color(0xFF1A1A2E),
        ),
      ),
    );
  }
}

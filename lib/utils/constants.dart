/// Application constants
class AppConstants {
  // App info - These are overridden by localization in UI
  static const String appName = 'ZAR PRO';
  static const String companyName = 'Bulutsoft';
  static const String appSubtitle = 'PROFESYONEL';
  
  // Session settings
  static const int maxRollHistory = 50;
  static const int maxSavedSessions = 100;
  
  // Animation settings
  static const int rollAnimationTicks = 15;
  static const Duration rollAnimationDuration = Duration(milliseconds: 80);
  static const Duration shakeAnimationDuration = Duration(milliseconds: 500);
  
  // UI settings
  static const double borderRadiusSharp = 0.0;
  static const int minDiceCount = 1;
  static const int maxDiceCount = 6;
  
  // Storage keys
  static const String storageKeySessions = 'saved_sessions';
  static const String storageKeyTheme = 'theme_mode';
}

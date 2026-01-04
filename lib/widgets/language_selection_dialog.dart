import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../utils/app_colors.dart';
import 'package:zar/l10n/app_localizations.dart';

/// Dialog for selecting app language on first launch or from menu
class LanguageSelectionDialog extends StatelessWidget {
  final bool isFirstLaunch;
  
  const LanguageSelectionDialog({
    super.key,
    this.isFirstLaunch = false,
  });

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // For first launch, use Turkish translations as default before selection
    final l10n = AppLocalizations.of(context);
    
    return WillPopScope(
      onWillPop: () async => !isFirstLaunch, // Prevent dismissal on first launch
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      AppColors.secondaryDark,
                      AppColors.accentDark,
                    ]
                  : [
                      AppColors.secondaryLight,
                      AppColors.accentLight,
                    ],
            ),
            border: Border.all(
              color: AppColors.highlightColor.withOpacity(0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.highlightColor.withOpacity(0.3),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.highlightColor, AppColors.neonPurple],
                    ),
                    borderRadius: BorderRadius.circular(0),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.highlightColor.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.language,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Title
                Text(
                  l10n?.selectLanguage ?? 'Dil Seç / Select Language / Sprache wählen',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textDark,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                
                // Description
                Text(
                  l10n?.selectLanguageDesc ?? 'Lütfen tercih ettiğiniz dili seçin',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? Colors.white.withOpacity(0.7)
                        : AppColors.textDark.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                
                // Language options
                _buildLanguageOption(
                  context: context,
                  languageProvider: languageProvider,
                  languageCode: 'tr',
                  languageName: 'Türkçe',
                  flag: '🇹🇷',
                  isDark: isDark,
                ),
                const SizedBox(height: 12),
                _buildLanguageOption(
                  context: context,
                  languageProvider: languageProvider,
                  languageCode: 'en',
                  languageName: 'English',
                  flag: '🇬🇧',
                  isDark: isDark,
                ),
                const SizedBox(height: 12),
                _buildLanguageOption(
                  context: context,
                  languageProvider: languageProvider,
                  languageCode: 'de',
                  languageName: 'Deutsch',
                  flag: '🇩🇪',
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required LanguageProvider languageProvider,
    required String languageCode,
    required String languageName,
    required String flag,
    required bool isDark,
  }) {
    final isSelected = languageProvider.locale.languageCode == languageCode;
    
    return GestureDetector(
      onTap: () async {
        HapticFeedback.selectionClick();
        await languageProvider.setLanguage(languageCode);
        
        if (isFirstLaunch) {
          await languageProvider.completeFirstLaunch();
        }
        
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [AppColors.highlightColor, AppColors.neonPurple],
                )
              : null,
          color: isSelected
              ? null
              : isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.05),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : isDark
                    ? Colors.white.withOpacity(0.2)
                    : Colors.black.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.highlightColor.withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Text(
              flag,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                languageName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : isDark
                          ? Colors.white
                          : AppColors.textDark,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}

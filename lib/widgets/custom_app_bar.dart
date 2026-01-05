import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/session_provider.dart';
import '../providers/language_provider.dart';
import '../services/ad_service.dart';
import '../utils/app_colors.dart';
import '../screens/saved_sessions_screen.dart';
import '../screens/settings_screen.dart';
import '../widgets/app_dialog.dart';
import '../widgets/language_selection_dialog.dart';
import 'package:zar/l10n/app_localizations.dart';

/// Custom app bar widget with navigation and theme controls
class CustomAppBar extends StatelessWidget {
  final VoidCallback? onNewGamePressed;
  final VoidCallback? onHistoryPressed;
  
  const CustomAppBar({
    super.key,
    this.onNewGamePressed,
    this.onHistoryPressed,
  });
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final sessionProvider = Provider.of<SessionProvider>(context);
    final isDark = themeProvider.isDarkMode;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark 
            ? AppColors.secondaryDark.withOpacity(0.5)
            : AppColors.secondaryLight,
        border: Border(
          bottom: BorderSide(
            color: isDark 
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo and title
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.highlightColor, AppColors.neonPurple],
                    ),
                    borderRadius: BorderRadius.circular(0),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.highlightColor.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.casino,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    l10n.appName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textDark,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Action buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // New Game button
              if (sessionProvider.hasActiveSession)
                _buildIconButton(
                  icon: Icons.stop_circle_outlined,
                  onPressed: () => _showEndSessionDialog(context),
                  isDark: isDark,
                  tooltip: l10n.endGame,
                )
              else
                _buildIconButton(
                  icon: Icons.play_circle_outline,
                  onPressed: onNewGamePressed,
                  isDark: isDark,
                  tooltip: l10n.newGameButton,
                ),
              const SizedBox(width: 4),
              // History button (only visible when session is active)
              if (sessionProvider.hasActiveSession && onHistoryPressed != null)
                _buildIconButton(
                  icon: Icons.history,
                  onPressed: onHistoryPressed,
                  isDark: isDark,
                  tooltip: l10n.historyButton,
                ),
              // Saved sessions button
              _buildIconButton(
                icon: Icons.folder_outlined,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SavedSessionsScreen(),
                    ),
                  );
                },
                isDark: isDark,
                tooltip: l10n.savedGamesButton,
              ),
              const SizedBox(width: 4),
              // Language selector button
              _buildLanguageButton(context, isDark),
              const SizedBox(width: 4),
              // Menu button (replaced theme toggle and bulutsoft branding)
              _buildIconButton(
                icon: Icons.menu,
                onPressed: () {
                  HapticFeedback.selectionClick();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
                isDark: isDark,
                tooltip: l10n.menuButton,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback? onPressed,
    required bool isDark,
    String? tooltip,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: isDark ? Colors.white : AppColors.textDark,
        size: 22,
      ),
      tooltip: tooltip,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(
        minWidth: 40,
        minHeight: 40,
      ),
    );
  }
  
  Widget _buildLanguageButton(BuildContext context, bool isDark) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        showDialog(
          context: context,
          builder: (context) => const LanguageSelectionDialog(isFirstLaunch: false),
        );
      },
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 40,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Center(
          child: Text(
            languageProvider.locale.languageCode.toUpperCase(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textDark,
            ),
          ),
        ),
      ),
    );
  }

  
  void _showEndSessionDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    final TextEditingController nameController = TextEditingController(
      text: sessionProvider.currentSession?.name ?? '',
    );
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (context) => AppDialog(
        title: l10n.endGameTitle,
        icon: Icons.stop_circle_outlined,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.endGameQuestion,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white.withOpacity(0.8) : AppColors.textDark,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              style: TextStyle(
                color: isDark ? Colors.white : AppColors.textDark,
              ),
              decoration: InputDecoration(
                labelText: l10n.gameName,
                labelStyle: TextStyle(
                  color: isDark
                      ? Colors.white.withOpacity(0.6)
                      : AppColors.textDark.withOpacity(0.6),
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(
                    color: isDark
                        ? Colors.white.withOpacity(0.3)
                        : AppColors.textDark.withOpacity(0.3),
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide(color: AppColors.highlightColor),
                ),
              ),
            ),
          ],
        ),
        actions: [
          AppTextButton(
            onPressed: () {
              sessionProvider.clearCurrentSession();
              Navigator.pop(context);
              AppSnackBar.show(
                context: context,
                message: l10n.gameDeletedWithoutSaving,
                icon: Icons.delete_outline,
              );
            },
            text: l10n.dontSave,
          ),
          AppButton(
            onPressed: () async {
              await sessionProvider.saveCurrentSession(
                customName: nameController.text,
              );
              if (context.mounted) {
                Navigator.pop(context);
                AppSnackBar.show(
                  context: context,
                  message: l10n.gameSaved,
                  isSuccess: true,
                );
              }
              // Session kaydedildikten sonra interstitial reklam göster
              await AdService.showInterstitialAd();
            },
            text: l10n.save,
            icon: Icons.save,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/session_provider.dart';
import '../providers/language_provider.dart';
import '../services/ad_service.dart';
import '../utils/app_colors.dart';
import '../widgets/app_dialog.dart';
import '../widgets/language_selection_dialog.dart';
import '../widgets/banner_ad_widget.dart';
import 'saved_sessions_screen.dart';
import 'how_to_use_screen.dart';
import 'package:zar/l10n/app_localizations.dart';

/// Settings and menu screen with all app functionality
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final sessionProvider = Provider.of<SessionProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    AppColors.primaryDark,
                    AppColors.secondaryDark,
                    AppColors.accentDark,
                  ]
                : [
                    AppColors.primaryLight,
                    AppColors.accentLight,
                    AppColors.secondaryLight,
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App bar
              _buildAppBar(context, isDark),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bulutsoft Card
                      _buildBulutsoftCard(context, isDark),
                      const SizedBox(height: 24),
                      
                      // Game section
                      _buildSectionTitle(l10n.game, Icons.casino, isDark),
                      const SizedBox(height: 12),
                      _buildMenuItem(
                        context: context,
                        icon: Icons.play_circle_outline,
                        title: l10n.newGame,
                        subtitle: l10n.newGameDesc,
                        isDark: isDark,
                        onTap: () => _showNewGameDialog(context),
                      ),
                      if (sessionProvider.hasActiveSession)
                        _buildMenuItem(
                          context: context,
                          icon: Icons.stop_circle_outlined,
                          title: l10n.endGame,
                          subtitle: l10n.endGameDesc,
                          isDark: isDark,
                          onTap: () => _showEndSessionDialog(context, sessionProvider),
                        ),
                      _buildMenuItem(
                        context: context,
                        icon: Icons.folder_outlined,
                        title: l10n.savedGames,
                        subtitle: l10n.savedGamesDesc,
                        isDark: isDark,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SavedSessionsScreen(),
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Appearance section
                      _buildSectionTitle(l10n.appearance, Icons.palette, isDark),
                      const SizedBox(height: 12),
                      _buildThemeToggle(context, themeProvider, isDark),
                      const SizedBox(height: 8),
                      _buildLanguageSelector(context, languageProvider, isDark),
                      
                      const SizedBox(height: 24),
                      
                      // Help section
                      _buildSectionTitle(l10n.help, Icons.help_outline, isDark),
                      const SizedBox(height: 12),
                      _buildMenuItem(
                        context: context,
                        icon: Icons.menu_book,
                        title: l10n.howToUse,
                        subtitle: l10n.howToUseDesc,
                        isDark: isDark,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HowToUseScreen(),
                            ),
                          );
                        },
                      ),
                      _buildMenuItem(
                        context: context,
                        icon: Icons.info_outline,
                        title: l10n.about,
                        subtitle: l10n.aboutDesc,
                        isDark: isDark,
                        onTap: () => _showAboutDialog(context, isDark),
                      ),
                      
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              
              // Banner Ad
              const BannerAdWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      padding: const EdgeInsets.all(16),
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
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDark ? Colors.white : AppColors.textDark,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.highlightColor, AppColors.neonPurple],
              ),
              borderRadius: BorderRadius.circular(0),
            ),
            child: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            l10n.menu,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulutsoftCard(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.highlightColor,
            AppColors.neonPurple,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.highlightColor.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(0),
                ),
                child: const Icon(
                  Icons.cloud,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.companyName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.softwareSolutions,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(0),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.favorite,
                  color: AppColors.goldColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.bulutsoftCard,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, bool isDark) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.highlightColor,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white.withOpacity(0.7) : AppColors.textDark.withOpacity(0.7),
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      Colors.white.withOpacity(0.08),
                      Colors.white.withOpacity(0.04),
                    ]
                  : [
                      Colors.black.withOpacity(0.04),
                      Colors.black.withOpacity(0.02),
                    ],
            ),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.highlightColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Icon(
                  icon,
                  color: AppColors.highlightColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? Colors.white.withOpacity(0.5)
                            : AppColors.textDark.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: isDark
                    ? Colors.white.withOpacity(0.3)
                    : AppColors.textDark.withOpacity(0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeToggle(BuildContext context, ThemeProvider themeProvider, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  Colors.white.withOpacity(0.08),
                  Colors.white.withOpacity(0.04),
                ]
              : [
                  Colors.black.withOpacity(0.04),
                  Colors.black.withOpacity(0.02),
                ],
        ),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.highlightColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(0),
            ),
            child: Icon(
              isDark ? Icons.dark_mode : Icons.light_mode,
              color: AppColors.highlightColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.theme,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isDark ? l10n.darkThemeActive : l10n.lightThemeActive,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? Colors.white.withOpacity(0.5)
                        : AppColors.textDark.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isDark,
            onChanged: (value) {
              HapticFeedback.selectionClick();
              themeProvider.toggleTheme();
            },
            activeColor: AppColors.highlightColor,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context, LanguageProvider languageProvider, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        showDialog(
          context: context,
          builder: (context) => const LanguageSelectionDialog(),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [
                    Colors.white.withOpacity(0.08),
                    Colors.white.withOpacity(0.04),
                  ]
                : [
                    Colors.black.withOpacity(0.04),
                    Colors.black.withOpacity(0.02),
                  ],
          ),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.highlightColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(0),
              ),
              child: Icon(
                Icons.language,
                color: AppColors.highlightColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.language,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    languageProvider.currentLanguageName,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? Colors.white.withOpacity(0.5)
                          : AppColors.textDark.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: isDark
                  ? Colors.white.withOpacity(0.3)
                  : AppColors.textDark.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }

  void _showNewGameDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NewGameSetupScreen(fromSettings: true),
      ),
    );
  }

  void _showEndSessionDialog(BuildContext context, SessionProvider sessionProvider) {
    final l10n = AppLocalizations.of(context)!;
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
              Navigator.pop(context); // Close settings screen too
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
              await sessionProvider.saveCurrentSession(customName: nameController.text);
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.pop(context); // Close settings screen too
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

  void _showAboutDialog(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) => AppDialog(
        title: l10n.aboutTitle,
        icon: Icons.info_outline,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.highlightColor, AppColors.neonPurple],
                    ),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: const Icon(Icons.casino, color: Colors.white, size: 32),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.appName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textDark,
                      ),
                    ),
                    Text(
                      l10n.version,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? Colors.white.withOpacity(0.5)
                            : AppColors.textDark.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              l10n.aboutDescription,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white.withOpacity(0.7) : AppColors.textDark,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.highlightColor.withOpacity(0.1),
                border: Border.all(
                  color: AppColors.highlightColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.cloud, color: AppColors.highlightColor, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.developedBy,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white.withOpacity(0.7) : AppColors.textDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          AppButton(
            onPressed: () => Navigator.pop(context),
            text: l10n.ok,
          ),
        ],
      ),
    );
  }
}

/// Screen for setting up a new game with player selection
class NewGameSetupScreen extends StatefulWidget {
  final bool fromSettings;
  
  const NewGameSetupScreen({
    super.key,
    this.fromSettings = false,
  });

  @override
  State<NewGameSetupScreen> createState() => _NewGameSetupScreenState();
}

class _NewGameSetupScreenState extends State<NewGameSetupScreen> {
  int playerCount = 1;
  final List<TextEditingController> nameControllers = [];
  final int maxPlayers = 8;

  @override
  void initState() {
    super.initState();
    _updateControllers();
  }

  void _updateControllers() {
    while (nameControllers.length < playerCount) {
      nameControllers.add(TextEditingController());
    }
    while (nameControllers.length > playerCount) {
      nameControllers.removeLast().dispose();
    }
  }

  @override
  void dispose() {
    for (var controller in nameControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final sessionProvider = Provider.of<SessionProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    AppColors.primaryDark,
                    AppColors.secondaryDark,
                    AppColors.accentDark,
                  ]
                : [
                    AppColors.primaryLight,
                    AppColors.accentLight,
                    AppColors.secondaryLight,
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App bar
              Container(
                padding: const EdgeInsets.all(16),
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
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: isDark ? Colors.white : AppColors.textDark,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.highlightColor, AppColors.neonPurple],
                        ),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: const Icon(
                        Icons.group_add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      l10n.newGameTitle,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Player count selector
                      _buildSectionTitle(l10n.playerCount, Icons.people, isDark),
                      const SizedBox(height: 12),
                      _buildPlayerCountSelector(context, isDark),
                      const SizedBox(height: 24),

                      // Player names
                      if (playerCount > 0) ...[
                        _buildSectionTitle(l10n.playerNames, Icons.person, isDark),
                        const SizedBox(height: 4),
                        Text(
                          l10n.playerNamesHint,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? Colors.white.withOpacity(0.5)
                                : AppColors.textDark.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...List.generate(playerCount, (index) => _buildPlayerNameField(context, index, isDark)),
                      ],
                    ],
                  ),
                ),
              ),

              // Start button
              Container(
                padding: const EdgeInsets.all(20),
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    
                    // Get player names
                    List<String>? playerNames;
                    if (playerCount > 0) {
                      playerNames = nameControllers.map((c) => c.text.trim()).toList();
                    }

                    // Start the game
                    sessionProvider.startNewSession(playerNames: playerNames);

                    // Show success message and go back
                    Navigator.pop(context); // Close new game screen
                    if (widget.fromSettings) {
                      Navigator.pop(context); // Close settings screen only if coming from settings
                    }
                    
                    AppSnackBar.show(
                      context: context,
                      message: playerCount > 0
                          ? l10n.gameStartedWithPlayers(playerCount)
                          : l10n.gameStarted,
                      isSuccess: true,
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.highlightColor, AppColors.neonPurple],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.highlightColor.withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 2,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.play_arrow, color: Colors.white, size: 28),
                        const SizedBox(width: 12),
                        Text(
                          l10n.startGame,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, bool isDark) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.highlightColor,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white.withOpacity(0.7) : AppColors.textDark.withOpacity(0.7),
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerCountSelector(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  Colors.white.withOpacity(0.08),
                  Colors.white.withOpacity(0.04),
                ]
              : [
                  Colors.black.withOpacity(0.04),
                  Colors.black.withOpacity(0.02),
                ],
        ),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  if (playerCount > 0) {
                    HapticFeedback.selectionClick();
                    setState(() {
                      playerCount--;
                      _updateControllers();
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: playerCount > 0
                        ? AppColors.highlightColor.withOpacity(0.2)
                        : (isDark
                            ? Colors.white.withOpacity(0.05)
                            : Colors.black.withOpacity(0.05)),
                    border: Border.all(
                      color: playerCount > 0
                          ? AppColors.highlightColor.withOpacity(0.5)
                          : (isDark
                              ? Colors.white.withOpacity(0.1)
                              : Colors.black.withOpacity(0.1)),
                    ),
                  ),
                  child: Icon(
                    Icons.remove,
                    color: playerCount > 0
                        ? AppColors.highlightColor
                        : (isDark
                            ? Colors.white.withOpacity(0.3)
                            : AppColors.textDark.withOpacity(0.3)),
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.highlightColor, AppColors.neonPurple],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.highlightColor.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '$playerCount',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              GestureDetector(
                onTap: () {
                  if (playerCount < maxPlayers) {
                    HapticFeedback.selectionClick();
                    setState(() {
                      playerCount++;
                      _updateControllers();
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: playerCount < maxPlayers
                        ? AppColors.highlightColor.withOpacity(0.2)
                        : (isDark
                            ? Colors.white.withOpacity(0.05)
                            : Colors.black.withOpacity(0.05)),
                    border: Border.all(
                      color: playerCount < maxPlayers
                          ? AppColors.highlightColor.withOpacity(0.5)
                          : (isDark
                              ? Colors.white.withOpacity(0.1)
                              : Colors.black.withOpacity(0.1)),
                    ),
                  ),
                  child: Icon(
                    Icons.add,
                    color: playerCount < maxPlayers
                        ? AppColors.highlightColor
                        : (isDark
                            ? Colors.white.withOpacity(0.3)
                            : AppColors.textDark.withOpacity(0.3)),
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            playerCount == 0
                ? l10n.singlePlayerMode
                : l10n.playersCount(playerCount),
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? Colors.white.withOpacity(0.6)
                  : AppColors.textDark.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerNameField(BuildContext context, int index, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: nameControllers[index],
        style: TextStyle(
          color: isDark ? Colors.white : AppColors.textDark,
        ),
        decoration: InputDecoration(
          labelText: l10n.player(index + 1),
          hintText: l10n.player(index + 1),
          labelStyle: TextStyle(
            color: isDark
                ? Colors.white.withOpacity(0.6)
                : AppColors.textDark.withOpacity(0.6),
          ),
          hintStyle: TextStyle(
            color: isDark
                ? Colors.white.withOpacity(0.3)
                : AppColors.textDark.withOpacity(0.3),
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.highlightColor.withOpacity(0.8),
                  AppColors.neonPurple.withOpacity(0.8),
                ],
              ),
            ),
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          filled: true,
          fillColor: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.black.withOpacity(0.03),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(
              color: isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.1),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: AppColors.highlightColor),
          ),
        ),
      ),
    );
  }
}

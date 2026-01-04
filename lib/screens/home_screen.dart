import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:math';
import '../providers/theme_provider.dart';
import '../providers/session_provider.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../widgets/dice_widget.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/app_dialog.dart';
import '../widgets/banner_ad_widget.dart';
import 'history_screen.dart';
import 'settings_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Main home screen with dice rolling
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int numberOfDice = 1;
  List<int> diceValues = [1];
  final Random random = Random();
  bool isRolling = false;
  late AnimationController _shakeController;
  
  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: AppConstants.shakeAnimationDuration,
      vsync: this,
    );
  }
  
  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }
  
  void rollDice() {
    if (isRolling) return;
    
    setState(() {
      isRolling = true;
    });
    
    _shakeController.repeat();
    HapticFeedback.mediumImpact();
    
    // Animate the roll
    Timer.periodic(AppConstants.rollAnimationDuration, (timer) {
      if (timer.tick >= AppConstants.rollAnimationTicks) {
        timer.cancel();
        _shakeController.stop();
        _shakeController.reset();
        
        // Add to session if active
        final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
        if (sessionProvider.hasActiveSession) {
          sessionProvider.addRoll(diceValues);
        }
        
        setState(() {
          isRolling = false;
        });
        
        HapticFeedback.heavyImpact();
      } else {
        setState(() {
          diceValues = List.generate(numberOfDice, (_) => random.nextInt(6) + 1);
        });
      }
    });
  }
  
  void updateNumberOfDice(int count) {
    HapticFeedback.selectionClick();
    setState(() {
      numberOfDice = count;
      diceValues = List.generate(numberOfDice, (_) => 1);
    });
  }
  
  int get totalValue => diceValues.fold(0, (sum, value) => sum + value);
  
  void _startNewGame() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NewGameSetupScreen(),
      ),
    );
  }
  
  void _showHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HistoryScreen(),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
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
              // Custom App Bar
              CustomAppBar(
                onNewGamePressed: _startNewGame,
                onHistoryPressed: sessionProvider.hasActiveSession ? _showHistory : null,
              ),
              const SizedBox(height: 16),
              
              // Session indicator
              if (sessionProvider.hasActiveSession)
                _buildSessionIndicator(isDark, sessionProvider),
              
              // Dice count selector
              _buildDiceSelector(isDark),
              const SizedBox(height: 16),
              
              // Total value display
              _buildTotalDisplay(isDark),
              
              // Dice display area
              Expanded(
                child: Center(
                  child: AnimatedBuilder(
                    animation: _shakeController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: isRolling
                            ? Offset(
                                sin(_shakeController.value * 2 * pi * 4) * 8,
                                cos(_shakeController.value * 2 * pi * 3) * 8,
                              )
                            : Offset.zero,
                        child: child,
                      );
                    },
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 20,
                      runSpacing: 20,
                      children: diceValues.asMap().entries.map((entry) {
                        return DiceWidget(
                          value: entry.value,
                          isRolling: isRolling,
                          index: entry.key,
                          isDarkMode: isDark,
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              
              // Roll button
              _buildRollButton(isDark),
              const SizedBox(height: 16),
              
              // Banner reklam
              const BannerAdWidget(),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSessionIndicator(bool isDark, SessionProvider sessionProvider) {
    final l10n = AppLocalizations.of(context)!;
    final currentPlayer = sessionProvider.currentPlayer;
    final hasPlayers = sessionProvider.hasPlayers;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  AppColors.neonPurple.withOpacity(0.3),
                  AppColors.highlightColor.withOpacity(0.2),
                ]
              : [
                  AppColors.neonPurple.withOpacity(0.1),
                  AppColors.highlightLight.withOpacity(0.1),
                ],
        ),
        borderRadius: BorderRadius.circular(0),
        border: Border.all(
          color: AppColors.highlightColor.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            hasPlayers ? Icons.person : Icons.play_circle_filled,
            color: AppColors.highlightColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (hasPlayers && currentPlayer != null) ...[
                  Text(
                    l10n.turn(currentPlayer.name),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.goldColor,
                    ),
                  ),
                  Text(
                    '${l10n.rollsCount(sessionProvider.currentSession?.totalRolls ?? 0)} • ${l10n.playersCount(sessionProvider.currentPlayers.length)}',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark 
                          ? Colors.white.withOpacity(0.6)
                          : AppColors.textDark.withOpacity(0.6),
                    ),
                  ),
                ] else ...[
                  Text(
                    sessionProvider.currentSession?.name ?? l10n.game,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textDark,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    l10n.rollsCount(sessionProvider.currentSession?.totalRolls ?? 0),
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark 
                          ? Colors.white.withOpacity(0.6)
                          : AppColors.textDark.withOpacity(0.6),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (hasPlayers)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.highlightColor, AppColors.neonPurple],
                ),
              ),
              child: Text(
                '${(sessionProvider.currentSession?.currentPlayerIndex ?? 0) + 1}/${sessionProvider.currentPlayers.length}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildDiceSelector(bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.05),
                ]
              : [
                  Colors.black.withOpacity(0.05),
                  Colors.black.withOpacity(0.02),
                ],
        ),
        borderRadius: BorderRadius.circular(0),
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
              Icon(
                Icons.tune,
                color: isDark 
                    ? Colors.white.withOpacity(0.7)
                    : AppColors.textDark.withOpacity(0.7),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                l10n.diceCount,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark 
                      ? Colors.white.withOpacity(0.7)
                      : AppColors.textDark.withOpacity(0.7),
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(6, (index) {
              int count = index + 1;
              bool isSelected = numberOfDice == count;
              return GestureDetector(
                onTap: () {
                  if (!isRolling) {
                    updateNumberOfDice(count);
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              AppColors.highlightColor,
                              AppColors.neonPurple,
                            ],
                          )
                        : null,
                    color: isSelected 
                        ? null 
                        : isDark
                            ? Colors.white.withOpacity(0.1)
                            : Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(0),
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
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '$count',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? Colors.white
                            : isDark
                                ? Colors.white.withOpacity(0.6)
                                : AppColors.textDark.withOpacity(0.6),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTotalDisplay(bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  AppColors.goldColor.withOpacity(0.2),
                  AppColors.highlightColor.withOpacity(0.1),
                ]
              : [
                  AppColors.goldColor.withOpacity(0.1),
                  AppColors.highlightLight.withOpacity(0.05),
                ],
        ),
        borderRadius: BorderRadius.circular(0),
        border: Border.all(
          color: AppColors.goldColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star,
            color: AppColors.goldColor.withOpacity(0.8),
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            l10n.total,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark 
                  ? Colors.white.withOpacity(0.7)
                  : AppColors.textDark.withOpacity(0.7),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(width: 16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: Text(
              '$totalValue',
              key: ValueKey<int>(totalValue),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.goldColor,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRollButton(bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: GestureDetector(
        onTap: isRolling ? null : rollDice,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            gradient: isRolling
                ? LinearGradient(
                    colors: isDark
                        ? [
                            AppColors.accentDark.withOpacity(0.5),
                            AppColors.secondaryDark.withOpacity(0.5),
                          ]
                        : [
                            AppColors.accentLight.withOpacity(0.5),
                            AppColors.secondaryLight.withOpacity(0.5),
                          ],
                  )
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.highlightColor,
                      AppColors.neonPurple,
                    ],
                  ),
            borderRadius: BorderRadius.circular(0),
            boxShadow: isRolling
                ? null
                : [
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
              Icon(
                isRolling ? Icons.hourglass_top : Icons.casino,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                isRolling ? l10n.rolling : l10n.rollDice,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

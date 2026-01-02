import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/session_provider.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import '../screens/saved_sessions_screen.dart';

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppConstants.appName,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.textDark,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        'by ${AppConstants.companyName}',
                        style: TextStyle(
                          fontSize: 9,
                          color: isDark 
                              ? Colors.white.withOpacity(0.5)
                              : AppColors.textDark.withOpacity(0.5),
                          letterSpacing: 1,
                        ),
                      ),
                    ],
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
                  tooltip: 'Oyunu Bitir',
                )
              else
                _buildIconButton(
                  icon: Icons.play_circle_outline,
                  onPressed: onNewGamePressed,
                  isDark: isDark,
                  tooltip: 'Yeni Oyun',
                ),
              const SizedBox(width: 4),
              // History button (only visible when session is active)
              if (sessionProvider.hasActiveSession && onHistoryPressed != null)
                _buildIconButton(
                  icon: Icons.history,
                  onPressed: onHistoryPressed,
                  isDark: isDark,
                  tooltip: 'Geçmiş',
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
                tooltip: 'Kayıtlı Oyunlar',
              ),
              const SizedBox(width: 4),
              // Theme toggle
              _buildIconButton(
                icon: isDark ? Icons.light_mode : Icons.dark_mode,
                onPressed: () {
                  themeProvider.toggleTheme();
                  HapticFeedback.selectionClick();
                },
                isDark: isDark,
                tooltip: isDark ? 'Açık Tema' : 'Koyu Tema',
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
  
  void _showEndSessionDialog(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    final TextEditingController nameController = TextEditingController(
      text: sessionProvider.currentSession?.name ?? '',
    );
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: const Text('Oyunu Bitir'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Bu oyunu kaydetmek istiyor musunuz?'),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Oyun Adı',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              sessionProvider.clearCurrentSession();
              Navigator.pop(context);
            },
            child: const Text('Kaydetme'),
          ),
          ElevatedButton(
            onPressed: () {
              sessionProvider.saveCurrentSession(
                customName: nameController.text,
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Oyun kaydedildi!')),
              );
            },
            child: const Text('Kaydet'),
          ),
        ],
      ),
    );
  }
}

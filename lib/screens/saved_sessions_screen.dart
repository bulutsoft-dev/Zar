import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/theme_provider.dart';
import '../providers/session_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/app_dialog.dart';
import 'session_detail_screen.dart';

/// Screen showing all saved game sessions
class SavedSessionsScreen extends StatelessWidget {
  const SavedSessionsScreen({super.key});
  
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
                        Icons.folder,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Kayıtlı Oyunlar',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : AppColors.textDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Sessions list
              Expanded(
                child: sessionProvider.savedSessions.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.folder_open,
                              size: 80,
                              color: isDark 
                                  ? Colors.white.withOpacity(0.3)
                                  : AppColors.textDark.withOpacity(0.3),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Henüz kayıtlı oyun yok',
                              style: TextStyle(
                                fontSize: 18,
                                color: isDark 
                                    ? Colors.white.withOpacity(0.7)
                                    : AppColors.textDark.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Oyun bittiğinde kaydet butonuna basın',
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark 
                                    ? Colors.white.withOpacity(0.5)
                                    : AppColors.textDark.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: sessionProvider.savedSessions.length,
                        itemBuilder: (context, index) {
                          final session = sessionProvider.savedSessions[index];
                          return _buildSessionCard(
                            context,
                            session,
                            isDark,
                            sessionProvider,
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSessionCard(
    BuildContext context,
    dynamic session,
    bool isDark,
    SessionProvider sessionProvider,
  ) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    final hasPlayers = session.players.isNotEmpty;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
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
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SessionDetailScreen(
                sessionId: session.id,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.highlightColor,
                          AppColors.neonPurple,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: const Icon(
                      Icons.casino,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          session.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.textDark,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: isDark 
                                  ? Colors.white.withOpacity(0.5)
                                  : AppColors.textDark.withOpacity(0.5),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              dateFormat.format(session.createdAt),
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark 
                                    ? Colors.white.withOpacity(0.5)
                                    : AppColors.textDark.withOpacity(0.5),
                              ),
                            ),
                            if (hasPlayers) ...[
                              const SizedBox(width: 12),
                              Icon(
                                Icons.group,
                                size: 14,
                                color: AppColors.highlightColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${session.players.length} oyuncu',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.highlightColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: isDark 
                          ? Colors.white.withOpacity(0.7)
                          : AppColors.textDark.withOpacity(0.7),
                    ),
                    onPressed: () => _showDeleteDialog(
                      context,
                      session,
                      sessionProvider,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Stats
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat(
                    'Atışlar',
                    '${session.totalRolls}',
                    Icons.casino,
                    isDark,
                  ),
                  Container(
                    width: 1,
                    height: 30,
                    color: isDark 
                        ? Colors.white.withOpacity(0.2)
                        : Colors.black.withOpacity(0.2),
                  ),
                  _buildStat(
                    'Toplam',
                    '${session.grandTotal}',
                    Icons.star,
                    isDark,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildStat(String label, String value, IconData icon, bool isDark) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.goldColor,
          size: 20,
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : AppColors.textDark,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isDark 
                    ? Colors.white.withOpacity(0.6)
                    : AppColors.textDark.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  void _showDeleteDialog(
    BuildContext context,
    dynamic session,
    SessionProvider sessionProvider,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (context) => AppDialog(
        title: 'Oyunu Sil',
        icon: Icons.delete_outline,
        iconColor: Colors.red,
        content: Text(
          '"${session.name}" oyununu silmek istediğinizden emin misiniz?\n\nBu işlem geri alınamaz.',
          style: TextStyle(
            fontSize: 16,
            color: isDark ? Colors.white.withOpacity(0.8) : AppColors.textDark,
            height: 1.5,
          ),
        ),
        actions: [
          AppTextButton(
            onPressed: () => Navigator.pop(context),
            text: 'İptal',
          ),
          AppButton(
            onPressed: () {
              sessionProvider.deleteSession(session.id);
              Navigator.pop(context);
              AppSnackBar.show(
                context: context,
                message: 'Oyun silindi',
                icon: Icons.delete,
              );
            },
            text: 'Sil',
            icon: Icons.delete,
          ),
        ],
      ),
    );
  }
}

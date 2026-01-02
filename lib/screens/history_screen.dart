import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/theme_provider.dart';
import '../providers/session_provider.dart';
import '../utils/app_colors.dart';

/// Screen showing history of current session
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final sessionProvider = Provider.of<SessionProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final session = sessionProvider.currentSession;
    
    if (session == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Geçmiş'),
          backgroundColor: isDark ? AppColors.secondaryDark : AppColors.secondaryLight,
        ),
        body: Center(
          child: Text(
            'Aktif oyun yok',
            style: TextStyle(
              fontSize: 18,
              color: isDark ? Colors.white.withOpacity(0.7) : AppColors.textDark,
            ),
          ),
        ),
      );
    }
    
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            session.name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.textDark,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${session.totalRolls} atış',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark 
                                  ? Colors.white.withOpacity(0.6)
                                  : AppColors.textDark.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Summary stats
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [
                            AppColors.highlightColor.withOpacity(0.2),
                            AppColors.neonPurple.withOpacity(0.1),
                          ]
                        : [
                            AppColors.highlightLight.withOpacity(0.1),
                            AppColors.neonPurple.withOpacity(0.05),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(0),
                  border: Border.all(
                    color: AppColors.highlightColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      'Toplam Atış',
                      '${session.totalRolls}',
                      Icons.casino,
                      isDark,
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: isDark 
                          ? Colors.white.withOpacity(0.2)
                          : Colors.black.withOpacity(0.2),
                    ),
                    _buildStatItem(
                      'Genel Toplam',
                      '${session.grandTotal}',
                      Icons.star,
                      isDark,
                    ),
                  ],
                ),
              ),
              
              // History list
              Expanded(
                child: session.rolls.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history,
                              size: 64,
                              color: isDark 
                                  ? Colors.white.withOpacity(0.3)
                                  : AppColors.textDark.withOpacity(0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Henüz atış yok',
                              style: TextStyle(
                                fontSize: 18,
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
                        itemCount: session.rolls.length,
                        reverse: true,
                        itemBuilder: (context, index) {
                          final roll = session.rolls[session.rolls.length - 1 - index];
                          final rollNumber = session.rolls.length - index;
                          return _buildRollCard(roll, rollNumber, isDark);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildStatItem(String label, String value, IconData icon, bool isDark) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.goldColor,
          size: 28,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.textDark,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark 
                ? Colors.white.withOpacity(0.6)
                : AppColors.textDark.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
  
  Widget _buildRollCard(dynamic roll, int rollNumber, bool isDark) {
    final timeFormat = DateFormat('HH:mm:ss');
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          // Roll number badge
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.highlightColor,
                  AppColors.neonPurple,
                ],
              ),
              borderRadius: BorderRadius.circular(0),
            ),
            child: Center(
              child: Text(
                '#$rollNumber',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Roll details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ...roll.values.map((v) => Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withOpacity(0.2)
                                : Colors.black.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(0),
                          ),
                          child: Text(
                            '$v',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : AppColors.textDark,
                            ),
                          ),
                        )),
                  ],
                ),
                const SizedBox(height: 8),
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
                      timeFormat.format(roll.timestamp),
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
          ),
          // Total
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.goldColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(0),
              border: Border.all(
                color: AppColors.goldColor.withOpacity(0.5),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                const Text(
                  'TOPLAM',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.goldColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${roll.total}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.goldColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

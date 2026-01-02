import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/theme_provider.dart';
import '../providers/session_provider.dart';
import '../utils/app_colors.dart';
import '../models/player.dart';
import '../models/game_session.dart';

/// Screen showing details of a saved session
class SessionDetailScreen extends StatefulWidget {
  final String sessionId;
  
  const SessionDetailScreen({
    super.key,
    required this.sessionId,
  });
  
  @override
  State<SessionDetailScreen> createState() => _SessionDetailScreenState();
}

class _SessionDetailScreenState extends State<SessionDetailScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = null;
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final sessionProvider = Provider.of<SessionProvider>(context, listen: false);
    final session = sessionProvider.savedSessions.firstWhere(
      (s) => s.id == widget.sessionId,
    );
    
    if (session.players.isNotEmpty) {
      _tabController?.dispose();
      _tabController = TabController(
        length: session.players.length + 1, // +1 for "All" tab
        vsync: this,
      );
    }
  }
  
  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final sessionProvider = Provider.of<SessionProvider>(context);
    final isDark = themeProvider.isDarkMode;
    
    final session = sessionProvider.savedSessions.firstWhere(
      (s) => s.id == widget.sessionId,
    );
    
    final hasPlayers = session.players.isNotEmpty;
    
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
                            '${DateFormat('dd/MM/yyyy HH:mm').format(session.createdAt)}${hasPlayers ? ' • ${session.players.length} oyuncu' : ''}',
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
              
              // Player scoreboard (if there are players)
              if (hasPlayers)
                _buildPlayerScoreboard(session, isDark),
              
              // Player tabs (if there are players)
              if (hasPlayers && _tabController != null) ...[
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.black.withOpacity(0.03),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.1)
                          : Colors.black.withOpacity(0.1),
                    ),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    indicatorColor: AppColors.highlightColor,
                    indicatorWeight: 3,
                    labelColor: AppColors.highlightColor,
                    unselectedLabelColor: isDark
                        ? Colors.white.withOpacity(0.5)
                        : AppColors.textDark.withOpacity(0.5),
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    tabs: [
                      const Tab(text: 'Tümü'),
                      ...session.players.map((p) => Tab(text: p.name)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
              
              // History list
              Expanded(
                child: hasPlayers && _tabController != null
                    ? TabBarView(
                        controller: _tabController,
                        children: [
                          // All rolls
                          _buildRollsList(session.rolls, session, isDark, showPlayer: true),
                          // Player-specific rolls
                          ...session.players.map((player) => _buildPlayerRollsList(
                            session,
                            player,
                            isDark,
                          )),
                        ],
                      )
                    : _buildRollsList(session.rolls, session, isDark),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildPlayerScoreboard(GameSession session, bool isDark) {
    // Sort players by total score
    final sortedPlayers = List<Player>.from(session.players)
      ..sort((a, b) => session.getPlayerTotal(b.id).compareTo(session.getPlayerTotal(a.id)));
    
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.goldColor.withOpacity(0.15),
            AppColors.highlightColor.withOpacity(0.1),
          ],
        ),
        border: Border.all(
          color: AppColors.goldColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.leaderboard, color: AppColors.goldColor, size: 20),
              const SizedBox(width: 8),
              Text(
                'Skor Tablosu',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textDark,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...sortedPlayers.asMap().entries.map((entry) {
            final index = entry.key;
            final player = entry.value;
            final total = session.getPlayerTotal(player.id);
            final rollCount = session.getPlayerRollCount(player.id);
            final isFirst = index == 0 && total > 0;
            
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                gradient: isFirst
                    ? const LinearGradient(
                        colors: [AppColors.highlightColor, AppColors.neonPurple],
                      )
                    : null,
                color: isFirst
                    ? null
                    : isDark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.black.withOpacity(0.03),
                border: isFirst
                    ? null
                    : Border.all(
                        color: isDark
                            ? Colors.white.withOpacity(0.1)
                            : Colors.black.withOpacity(0.1),
                      ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isFirst
                          ? Colors.white.withOpacity(0.2)
                          : AppColors.highlightColor.withOpacity(0.2),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isFirst ? Colors.white : AppColors.highlightColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          player.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isFirst
                                ? Colors.white
                                : isDark
                                    ? Colors.white
                                    : AppColors.textDark,
                          ),
                        ),
                        Text(
                          '$rollCount atış',
                          style: TextStyle(
                            fontSize: 11,
                            color: isFirst
                                ? Colors.white.withOpacity(0.7)
                                : isDark
                                    ? Colors.white.withOpacity(0.5)
                                    : AppColors.textDark.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isFirst)
                    Icon(Icons.emoji_events, color: AppColors.goldColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '$total',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isFirst ? Colors.white : AppColors.goldColor,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
  
  Widget _buildPlayerRollsList(GameSession session, Player player, bool isDark) {
    final playerRolls = session.getRollsForPlayer(player.id);
    final playerTotal = session.getPlayerTotal(player.id);
    
    return Column(
      children: [
        // Player stats
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.goldColor.withOpacity(0.2),
                AppColors.highlightColor.withOpacity(0.1),
              ],
            ),
            border: Border.all(
              color: AppColors.goldColor.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Icon(Icons.person, color: AppColors.goldColor, size: 24),
                  const SizedBox(height: 4),
                  Text(
                    player.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textDark,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '${playerRolls.length}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textDark,
                    ),
                  ),
                  Text(
                    'Atış',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? Colors.white.withOpacity(0.6)
                          : AppColors.textDark.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '$playerTotal',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.goldColor,
                    ),
                  ),
                  Text(
                    'Toplam',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? Colors.white.withOpacity(0.6)
                          : AppColors.textDark.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Player rolls
        Expanded(
          child: _buildRollsList(playerRolls, session, isDark, startIndex: 1),
        ),
      ],
    );
  }
  
  Widget _buildRollsList(List<dynamic> rolls, GameSession session, bool isDark, {bool showPlayer = false, int startIndex = 0}) {
    if (rolls.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              size: 64,
              color: isDark 
                  ? Colors.white.withOpacity(0.3)
                  : AppColors.textDark.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Atış bilgisi bulunamadı',
              style: TextStyle(
                fontSize: 18,
                color: isDark 
                    ? Colors.white.withOpacity(0.5)
                    : AppColors.textDark.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: rolls.length,
      reverse: true,
      itemBuilder: (context, index) {
        final roll = rolls[rolls.length - 1 - index];
        final rollNumber = startIndex == 0 
            ? session.rolls.indexOf(roll) + 1
            : rolls.length - index;
        return _buildRollCard(roll, rollNumber, isDark, showPlayer: showPlayer);
      },
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
  
  Widget _buildRollCard(dynamic roll, int rollNumber, bool isDark, {bool showPlayer = false}) {
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
                if (showPlayer && roll.playerName != null) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 14,
                        color: AppColors.highlightColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        roll.playerName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.highlightColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                ],
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    ...roll.values.map((v) => Container(
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

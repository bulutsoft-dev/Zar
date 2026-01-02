import 'dart:convert';
import 'player.dart';

/// Model representing a single dice roll
class DiceRoll {
  final List<int> values;
  final DateTime timestamp;
  final String? playerId;
  final String? playerName;
  
  DiceRoll({
    required this.values,
    required this.timestamp,
    this.playerId,
    this.playerName,
  });
  
  int get total => values.fold(0, (sum, value) => sum + value);
  
  Map<String, dynamic> toJson() {
    return {
      'values': values,
      'timestamp': timestamp.toIso8601String(),
      'playerId': playerId,
      'playerName': playerName,
    };
  }
  
  factory DiceRoll.fromJson(Map<String, dynamic> json) {
    return DiceRoll(
      values: List<int>.from(json['values']),
      timestamp: DateTime.parse(json['timestamp']),
      playerId: json['playerId'],
      playerName: json['playerName'],
    );
  }
}

/// Model representing a game session
class GameSession {
  final String id;
  String name;
  final DateTime createdAt;
  DateTime updatedAt;
  final List<DiceRoll> rolls;
  final List<Player> players;
  int currentPlayerIndex;
  
  GameSession({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.rolls,
    this.players = const [],
    this.currentPlayerIndex = 0,
  });
  
  int get totalRolls => rolls.length;
  
  int get grandTotal => rolls.fold(0, (sum, roll) => sum + roll.total);
  
  Player? get currentPlayer => 
      players.isNotEmpty && currentPlayerIndex < players.length 
          ? players[currentPlayerIndex] 
          : null;
  
  void nextPlayer() {
    if (players.isNotEmpty) {
      currentPlayerIndex = (currentPlayerIndex + 1) % players.length;
    }
  }
  
  /// Get rolls for a specific player
  List<DiceRoll> getRollsForPlayer(String playerId) {
    return rolls.where((roll) => roll.playerId == playerId).toList();
  }
  
  /// Get total for a specific player
  int getPlayerTotal(String playerId) {
    return getRollsForPlayer(playerId).fold(0, (sum, roll) => sum + roll.total);
  }
  
  /// Get roll count for a specific player
  int getPlayerRollCount(String playerId) {
    return getRollsForPlayer(playerId).length;
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'rolls': rolls.map((r) => r.toJson()).toList(),
      'players': players.map((p) => p.toJson()).toList(),
      'currentPlayerIndex': currentPlayerIndex,
    };
  }
  
  factory GameSession.fromJson(Map<String, dynamic> json) {
    return GameSession(
      id: json['id'],
      name: json['name'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      rolls: (json['rolls'] as List)
          .map((r) => DiceRoll.fromJson(r))
          .toList(),
      players: json['players'] != null 
          ? (json['players'] as List)
              .map((p) => Player.fromJson(p))
              .toList()
          : [],
      currentPlayerIndex: json['currentPlayerIndex'] ?? 0,
    );
  }
  
  String toJsonString() => jsonEncode(toJson());
  
  factory GameSession.fromJsonString(String jsonString) {
    return GameSession.fromJson(jsonDecode(jsonString));
  }
}

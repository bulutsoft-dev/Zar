import 'dart:convert';

/// Model representing a single dice roll
class DiceRoll {
  final List<int> values;
  final DateTime timestamp;
  
  DiceRoll({
    required this.values,
    required this.timestamp,
  });
  
  int get total => values.fold(0, (sum, value) => sum + value);
  
  Map<String, dynamic> toJson() {
    return {
      'values': values,
      'timestamp': timestamp.toIso8601String(),
    };
  }
  
  factory DiceRoll.fromJson(Map<String, dynamic> json) {
    return DiceRoll(
      values: List<int>.from(json['values']),
      timestamp: DateTime.parse(json['timestamp']),
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
  
  GameSession({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.rolls,
  });
  
  int get totalRolls => rolls.length;
  
  int get grandTotal => rolls.fold(0, (sum, roll) => sum + roll.total);
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'rolls': rolls.map((r) => r.toJson()).toList(),
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
    );
  }
  
  String toJsonString() => jsonEncode(toJson());
  
  factory GameSession.fromJsonString(String jsonString) {
    return GameSession.fromJson(jsonDecode(jsonString));
  }
}

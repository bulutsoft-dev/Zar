/// Model representing a player in the game
class Player {
  final String id;
  String name;
  final int order;

  Player({
    required this.id,
    required this.name,
    required this.order,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'order': order,
    };
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      name: json['name'],
      order: json['order'],
    );
  }
}

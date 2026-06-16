import 'package:uuid/uuid.dart';

class Player {
  final String id;
  final String name;

  Player({required this.id, required this.name});

  Player copyWith({String? name}) => Player(id: id, name: name ?? this.name);

  factory Player.create(String name) => Player(id: const Uuid().v4(), name: name);

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
  factory Player.fromJson(Map<String, dynamic> json) =>
      Player(id: json['id'] as String, name: json['name'] as String);
}

class FarawayGame {
  final String id;
  final DateTime createdAt;
  final List<Player> players;
  final Map<String, List<int?>> scores; // playerId → liste de numberOfRows scores
  final int numberOfRows;
  final bool writable;

  FarawayGame({
    required this.id,
    required this.createdAt,
    required this.players,
    required this.scores,
    required this.numberOfRows,
    required this.writable,
  });

  FarawayGame copyWith({
    List<Player>? players,
    Map<String, List<int?>>? scores,
    bool? writable,
  }) =>
      FarawayGame(
        id: id,
        createdAt: createdAt,
        players: players ?? this.players,
        scores: scores ?? this.scores,
        numberOfRows: numberOfRows,
        writable: writable ?? this.writable,
      );

  int? playerTotal(String playerId) {
    final s = scores[playerId];
    if (s == null || s.every((v) => v == null)) return null;
    return s.fold(0, (sum, v) => sum! + (v ?? 0));
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'numberOfRows': numberOfRows,
        'players': players.map((p) => p.toJson()).toList(),
        'scores': scores.map((k, v) => MapEntry(k, v)),
        'writable': writable,
      };

  factory FarawayGame.fromJson(Map<String, dynamic> json) => FarawayGame(
        id: json['id'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        numberOfRows: json['numberOfRows'] as int,
        players: (json['players'] as List).map((p) => Player.fromJson(p as Map<String, dynamic>)).toList(),
        scores: (json['scores'] as Map<String, dynamic>).map(
          (k, v) => MapEntry(k, (v as List).map((e) => e as int?).toList()),
        ),
        writable: json['writable'] as bool,
      );
}

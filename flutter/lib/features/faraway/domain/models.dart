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

const farawayNumberOfRows = 9;

class FarawayGame {
  final String id;
  final DateTime createdAt;
  final String gameType;
  final List<Player> players;
  final Map<String, List<int?>> scores; // playerId → liste de scores
  final bool finished;

  FarawayGame({
    required this.id,
    required this.createdAt,
    this.gameType = 'faraway',
    required this.players,
    required this.scores,
    required this.finished,
  });

  FarawayGame copyWith({
    List<Player>? players,
    Map<String, List<int?>>? scores,
    bool? finished,
  }) =>
      FarawayGame(
        id: id,
        createdAt: createdAt,
        gameType: gameType,
        players: players ?? this.players,
        scores: scores ?? this.scores,
        finished: finished ?? this.finished,
      );

  int? playerTotal(String playerId) {
    final s = scores[playerId];
    if (s == null || s.every((v) => v == null)) return null;
    return s.fold(0, (sum, v) => sum! + (v ?? 0));
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'gameType': gameType,
        'players': players.map((p) => p.toJson()).toList(),
        'scores': scores.map((k, v) => MapEntry(k, v)),
        'finished': finished,
      };

  factory FarawayGame.fromJson(Map<String, dynamic> json) => FarawayGame(
        id: json['id'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        gameType: json['gameType'] as String? ?? 'faraway',
        players: (json['players'] as List).map((p) => Player.fromJson(p as Map<String, dynamic>)).toList(),
        scores: (json['scores'] as Map<String, dynamic>).map(
          (k, v) => MapEntry(k, (v as List).map((e) => e as int?).toList()),
        ),
        // rétrocompat : anciens exports utilisaient 'writable'
        finished: json['finished'] as bool? ?? !(json['writable'] as bool? ?? true),
      );
}

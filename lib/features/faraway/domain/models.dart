import '../../../core/models/player.dart';
export '../../../core/models/player.dart';

const farawayNumberOfRows = 9;

class FarawayGame {
  final String id;
  final DateTime createdAt;
  final String gameType;
  final List<Player> players;
  final Map<String, List<int?>> scores;
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
        players: (json['players'] as List)
            .map((p) => Player.fromJson(p as Map<String, dynamic>))
            .toList(),
        scores: (json['scores'] as Map<String, dynamic>).map(
          (k, v) => MapEntry(k, (v as List).map((e) => e as int?).toList()),
        ),
        finished: json['finished'] as bool? ?? !(json['writable'] as bool? ?? true),
      );
}

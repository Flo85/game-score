import '../../../core/models/player.dart';
export '../../../core/models/player.dart';

class GenericGame {
  final String id;
  final String name;
  final DateTime createdAt;
  final List<Player> players;
  final Map<String, List<int?>> scores; // playerId → score par manche
  final bool finished;

  GenericGame({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.players,
    required this.scores,
    required this.finished,
  });

  int get numberOfRounds => scores.values.isEmpty ? 0 : scores.values.first.length;

  GenericGame copyWith({
    String? name,
    List<Player>? players,
    Map<String, List<int?>>? scores,
    bool? finished,
  }) =>
      GenericGame(
        id: id,
        name: name ?? this.name,
        createdAt: createdAt,
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
        'name': name,
        'createdAt': createdAt.toIso8601String(),
        'gameType': 'generic',
        'players': players.map((p) => p.toJson()).toList(),
        'scores': scores.map((k, v) => MapEntry(k, v)),
        'finished': finished,
      };

  factory GenericGame.fromJson(Map<String, dynamic> json) => GenericGame(
        id: json['id'] as String,
        name: json['name'] as String? ?? '',
        createdAt: DateTime.parse(json['createdAt'] as String),
        players: (json['players'] as List)
            .map((p) => Player.fromJson(p as Map<String, dynamic>))
            .toList(),
        scores: (json['scores'] as Map<String, dynamic>).map(
          (k, v) => MapEntry(k, (v as List).map((e) => e as int?).toList()),
        ),
        finished: json['finished'] as bool? ?? false,
      );
}

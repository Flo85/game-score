import '../../../core/models/player.dart';
export '../../../core/models/player.dart';

enum VictoryType { highestScore, lowestScore }

class Team {
  final String id;
  final String name;
  const Team({required this.id, required this.name});
  Team copyWith({String? name}) => Team(id: id, name: name ?? this.name);
  Map<String, dynamic> toJson() => {'id': id, 'name': name};
  factory Team.fromJson(Map<String, dynamic> j) => Team(id: j['id'] as String, name: j['name'] as String);
}

class GenericGame {
  final String id;
  final String name;
  final DateTime createdAt;
  final List<Player> players;
  final Map<String, List<int?>> scores; // playerId → score par manche
  final bool finished;
  final List<String> winnerIds;
  final VictoryType victoryType;
  final List<Team> teams;
  final Map<String, String> playerTeams; // playerId → teamId

  bool get hasTeams => teams.isNotEmpty;

  GenericGame({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.players,
    required this.scores,
    required this.finished,
    this.winnerIds = const [],
    this.victoryType = VictoryType.highestScore,
    this.teams = const [],
    this.playerTeams = const {},
  });

  int get numberOfRounds => scores.values.isEmpty ? 0 : scores.values.first.length;

  List<Player> playersForTeam(String teamId) =>
      players.where((p) => playerTeams[p.id] == teamId).toList();

  int? teamTotal(String teamId) {
    final members = playersForTeam(teamId);
    if (members.isEmpty) return null;
    final totals = members.map((p) => playerTotal(p.id)).whereType<int>();
    if (totals.isEmpty) return null;
    return totals.fold(0, (a, b) => (a ?? 0) + b);
  }

  GenericGame copyWith({
    String? name,
    List<Player>? players,
    Map<String, List<int?>>? scores,
    bool? finished,
    List<String>? winnerIds,
    VictoryType? victoryType,
    List<Team>? teams,
    Map<String, String>? playerTeams,
  }) =>
      GenericGame(
        id: id,
        name: name ?? this.name,
        createdAt: createdAt,
        players: players ?? this.players,
        scores: scores ?? this.scores,
        finished: finished ?? this.finished,
        winnerIds: winnerIds ?? this.winnerIds,
        victoryType: victoryType ?? this.victoryType,
        teams: teams ?? this.teams,
        playerTeams: playerTeams ?? this.playerTeams,
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
        'victory_type': victoryType.name,
        'winner_ids': winnerIds,
        'teams': teams.map((t) => t.toJson()).toList(),
        'player_teams': playerTeams,
      };

  factory GenericGame.fromJson(Map<String, dynamic> json) {
    List<String> winnerIds = [];
    if (json['winner_ids'] is List) {
      winnerIds = (json['winner_ids'] as List).cast<String>();
    } else if (json['winner_id'] is String) {
      winnerIds = [json['winner_id'] as String];
    }
    final teams = (json['teams'] as List? ?? [])
        .map((t) => Team.fromJson(t as Map<String, dynamic>))
        .toList();
    final playerTeams = (json['player_teams'] as Map<String, dynamic>? ?? {})
        .map((k, v) => MapEntry(k, v as String));
    return GenericGame(
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
      victoryType: VictoryType.values.asNameMap()[json['victory_type'] as String? ?? ''] ?? VictoryType.highestScore,
      winnerIds: winnerIds,
      teams: teams,
      playerTeams: playerTeams,
    );
  }
}

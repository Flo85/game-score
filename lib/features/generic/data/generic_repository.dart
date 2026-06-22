import 'dart:convert';
import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../domain/models.dart';

class GenericRepository {
  final AppDatabase _db;

  GenericRepository(this._db);

  Stream<List<GenericGame>> watchHistory() =>
      _db.watchGamesByType('generic').asyncMap((rows) async {
        final games = <GenericGame>[];
        for (final row in rows) {
          final gp = await _db.getGamePlayers(row.id);
          games.add(_rowToGame(row, gp));
        }
        return games;
      });

  Future<GenericGame?> loadGame(String id) async {
    final row = await _db.getGame(id);
    if (row == null) return null;
    final gp = await _db.getGamePlayers(id);
    return _rowToGame(row, gp);
  }

  Future<void> saveGame(GenericGame game) async {
    await _db.upsertGame(GamesCompanion(
      id: Value(game.id),
      createdAt: Value(game.createdAt),
      gameType: const Value('generic'),
      name: Value(game.name),
      finished: Value(game.finished),
      winnerId: Value(game.winnerIds.isEmpty ? null : game.winnerIds.join(',')),
      victoryType: Value(game.victoryType.name),
    ));

    await _db.replaceGamePlayers(
      game.id,
      game.players.asMap().entries.map((e) {
        final player = e.value;
        final scores = game.scores[player.id] ?? [];
        return GamePlayersCompanion(
          gameId: Value(game.id),
          playerId: Value(player.id),
          playerName: Value(player.name),
          position: Value(e.key),
          scoresJson: Value(jsonEncode(scores)),
        );
      }).toList(),
    );
  }

  Future<void> deleteGame(String id) => _db.deleteGame(id);

  GenericGame _rowToGame(Game row, List<GamePlayer> gp) {
    final players = gp.map((r) => Player(id: r.playerId, name: r.playerName)).toList();
    final scores = {
      for (final r in gp)
        r.playerId: (jsonDecode(r.scoresJson) as List).map((e) => e as int?).toList(),
    };
    return GenericGame(
      id: row.id,
      name: row.name ?? '',
      createdAt: row.createdAt,
      players: players,
      scores: scores,
      finished: row.finished,
      winnerIds: row.winnerId?.split(',').where((s) => s.isNotEmpty).toList() ?? [],
      victoryType: VictoryType.values.asNameMap()[row.victoryType ?? ''] ?? VictoryType.highestScore,
    );
  }

  static List<String> computeWinner(GenericGame game) {
    if (game.players.isEmpty) return [];
    final lowest = game.victoryType == VictoryType.lowestScore;
    int? best;
    for (final p in game.players) {
      final scores = game.scores[p.id] ?? [];
      if (scores.every((v) => v == null)) continue;
      final total = scores.whereType<int>().fold(0, (a, b) => a + b);
      if (best == null || (lowest ? total < best : total > best)) best = total;
    }
    if (best == null) return [];
    return game.players.where((p) {
      final scores = game.scores[p.id] ?? [];
      if (scores.every((v) => v == null)) return false;
      return scores.whereType<int>().fold(0, (a, b) => a + b) == best;
    }).map((p) => p.id).toList();
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/database/app_database.dart';
import '../domain/models.dart';

class FarawayRepository {
  final AppDatabase _db;

  FarawayRepository(this._db);

  Stream<List<FarawayGame>> watchHistory() =>
      _db.watchAllGames().asyncMap((rows) async {
        final games = <FarawayGame>[];
        for (final row in rows) {
          final gp = await _db.getGamePlayers(row.id);
          games.add(_rowToGame(row, gp));
        }
        return games;
      });

  Future<FarawayGame?> loadGame(String id) async {
    final row = await _db.getGame(id);
    if (row == null) return null;
    final gp = await _db.getGamePlayers(id);
    return _rowToGame(row, gp);
  }

  Future<void> saveGame(FarawayGame game) async {
    await _db.upsertGame(GamesCompanion(
      id: Value(game.id),
      createdAt: Value(game.createdAt),
      gameType: Value(game.gameType),
      finished: Value(game.finished),
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

  Future<String?> exportHistory() async {
    final games = await watchHistory().first;
    if (games.isEmpty) return null;

    final json = jsonEncode(games.map((g) => g.toJson()).toList());
    final timestamp = DateTime.now().toIso8601String().substring(0, 19).replaceAll(':', '-');
    final fileName = 'faraway-history-$timestamp.json';

    final dir = await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsString(json);

    return file.path;
  }

  FarawayGame _rowToGame(Game row, List<GamePlayer> gp) {
    final players = gp.map((r) => Player(id: r.playerId, name: r.playerName)).toList();

    final scores = {
      for (final r in gp)
        r.playerId: (jsonDecode(r.scoresJson) as List).map((e) => e as int?).toList(),
    };

    return FarawayGame(
      id: row.id,
      createdAt: row.createdAt,
      gameType: row.gameType,
      players: players,
      scores: scores,
      finished: row.finished,
    );
  }
}

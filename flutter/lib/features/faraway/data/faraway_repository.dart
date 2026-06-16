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
      _db.watchAllGames().map((rows) => rows.map(_rowToGame).toList());

  Future<FarawayGame?> loadGame(String id) async {
    final row = await _db.getGame(id);
    return row != null ? _rowToGame(row) : null;
  }

  Future<void> saveGame(FarawayGame game) => _db.upsertGame(
        GamesCompanion(
          id: Value(game.id),
          createdAt: Value(game.createdAt),
          numberOfRows: Value(game.numberOfRows),
          writable: Value(game.writable),
          playersJson: Value(jsonEncode(game.players.map((p) => p.toJson()).toList())),
          scoresJson: Value(jsonEncode(game.scores)),
        ),
      );

  Future<void> deleteGame(String id) => _db.deleteGame(id);

  Future<String?> exportHistory() async {
    final games = await _db.watchAllGames().first;
    if (games.isEmpty) return null;

    final json = jsonEncode(games.map((g) => _rowToGame(g).toJson()).toList());
    final timestamp = DateTime.now().toIso8601String().substring(0, 19).replaceAll(':', '-');
    final fileName = 'faraway-history-$timestamp.json';

    final dir = await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsString(json);

    return file.path;
  }

  FarawayGame _rowToGame(Game row) {
    final players = (jsonDecode(row.playersJson) as List)
        .map((p) => Player.fromJson(p as Map<String, dynamic>))
        .toList();
    final scores = (jsonDecode(row.scoresJson) as Map<String, dynamic>).map(
      (k, v) => MapEntry(k, (v as List).map((e) => e as int?).toList()),
    );
    return FarawayGame(
      id: row.id,
      createdAt: row.createdAt,
      numberOfRows: row.numberOfRows,
      players: players,
      scores: scores,
      writable: row.writable,
    );
  }
}

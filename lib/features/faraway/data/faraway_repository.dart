import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/app_database.dart';
import '../domain/models.dart';

class FarawayRepository {
  final AppDatabase _db;

  FarawayRepository(this._db);

  Stream<List<FarawayGame>> watchHistory() =>
      _db.watchGamesByType('faraway').asyncMap((rows) async {
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

  // Retourne le nombre de parties importées
  Future<int> importHistory(String filePath) async {
    final raw = jsonDecode(await File(filePath).readAsString()) as List;

    // Charger les joueurs du carnet indexés par nom (insensible à la casse)
    final savedRows = await _db.watchSavedPlayers().first;
    final nameToSaved = <String, SavedPlayer>{
      for (final p in savedRows) p.name.toLowerCase(): p,
    };

    var imported = 0;

    for (final gameJson in raw) {
      final game = FarawayGame.fromJson(gameJson as Map<String, dynamic>);

      // Ignorer les parties déjà présentes
      final existing = await _db.getGame(game.id);
      if (existing != null) continue;

      // Résoudre les IDs joueurs
      final idRemap = <String, String>{};
      final resolvedPlayers = <Player>[];

      for (final player in game.players) {
        final key = player.name.toLowerCase();
        if (nameToSaved.containsKey(key)) {
          // Joueur existant dans le carnet → utiliser son ID
          final saved = nameToSaved[key]!;
          idRemap[player.id] = saved.id;
          resolvedPlayers.add(Player(id: saved.id, name: saved.name));
        } else {
          // Nouveau joueur → créer dans le carnet
          final newId = const Uuid().v4();
          await _db.upsertSavedPlayer(
            SavedPlayersCompanion(id: Value(newId), name: Value(player.name)),
          );
          final newSaved = SavedPlayer(id: newId, name: player.name);
          nameToSaved[key] = newSaved;
          idRemap[player.id] = newId;
          resolvedPlayers.add(Player(id: newId, name: player.name));
        }
      }

      // Remapper les clés de scores
      final remappedScores = <String, List<int?>>{};
      game.scores.forEach((oldId, scores) {
        remappedScores[idRemap[oldId] ?? oldId] = scores;
      });

      await saveGame(game.copyWith(players: resolvedPlayers, scores: remappedScores));
      imported++;
    }

    return imported;
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

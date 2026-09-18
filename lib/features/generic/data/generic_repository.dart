import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
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
    await _db.transaction(() async {
      await _db.upsertGame(GamesCompanion(
        id: Value(game.id),
        createdAt: Value(game.createdAt),
        gameType: const Value('generic'),
        name: Value(game.name),
        finished: Value(game.finished),
        winnerId: Value(game.winnerIds.isEmpty ? null : game.winnerIds.join(',')),
        victoryType: Value(game.victoryType.name),
        teamsJson: Value(game.teams.isEmpty ? null : jsonEncode(game.teams.map((t) => t.toJson()).toList())),
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
            teamId: Value(game.playerTeams[player.id]),
          );
        }).toList(),
      );
    });
  }

  Future<void> deleteGame(String id) => _db.deleteGame(id);


  Future<int> importHistoryFromJson(List<Map<String, dynamic>> raw) async {
    final savedRows = await _db.watchSavedPlayers().first;
    final nameToSaved = <String, SavedPlayer>{
      for (final p in savedRows) p.name.toLowerCase(): p,
    };
    var imported = 0;
    for (final gameJson in raw) {
      final game = GenericGame.fromJson(gameJson);
      final existing = await _db.getGame(game.id);
      if (existing != null) continue;
      final idRemap = <String, String>{};
      final resolvedPlayers = <Player>[];
      for (final player in game.players) {
        final key = player.name.toLowerCase();
        if (nameToSaved.containsKey(key)) {
          final saved = nameToSaved[key]!;
          idRemap[player.id] = saved.id;
          resolvedPlayers.add(Player(id: saved.id, name: saved.name));
        } else {
          final newId = const Uuid().v4();
          await _db.upsertSavedPlayer(SavedPlayersCompanion(id: Value(newId), name: Value(player.name)));
          final newSaved = SavedPlayer(id: newId, name: player.name);
          nameToSaved[key] = newSaved;
          idRemap[player.id] = newId;
          resolvedPlayers.add(Player(id: newId, name: player.name));
        }
      }
      final remappedScores = <String, List<int?>>{};
      game.scores.forEach((oldId, scores) {
        remappedScores[idRemap[oldId] ?? oldId] = scores;
      });
      final resolved = game.copyWith(players: resolvedPlayers, scores: remappedScores);
      final winnerIds = resolved.winnerIds.isNotEmpty
          ? resolved.winnerIds.map((id) => idRemap[id] ?? id).toList()
          : GenericRepository.computeWinner(resolved);
      await saveGame(resolved.copyWith(winnerIds: winnerIds));
      imported++;
    }
    return imported;
  }

  GenericGame _rowToGame(Game row, List<GamePlayer> gp) {
    final players = gp.map((r) => Player(id: r.playerId, name: r.playerName)).toList();
    final scores = {
      for (final r in gp)
        r.playerId: (jsonDecode(r.scoresJson) as List).map((e) => e as int?).toList(),
    };
    final teams = row.teamsJson == null ? <Team>[] :
        (jsonDecode(row.teamsJson!) as List).map((t) => Team.fromJson(t as Map<String, dynamic>)).toList();
    final playerTeams = {
      for (final r in gp) if (r.teamId != null) r.playerId: r.teamId!,
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
      teams: teams,
      playerTeams: playerTeams,
    );
  }

  static List<String> computeWinner(GenericGame game) {
    if (game.players.isEmpty) return [];
    final lowest = game.victoryType == VictoryType.lowestScore;

    if (game.hasTeams) {
      int? best;
      for (final team in game.teams) {
        final total = game.teamTotal(team.id);
        if (total == null) continue;
        if (best == null || (lowest ? total < best : total > best)) best = total;
      }
      if (best == null) return [];
      final winningTeams = game.teams.where((t) => game.teamTotal(t.id) == best).map((t) => t.id).toSet();
      return game.players.where((p) => winningTeams.contains(game.playerTeams[p.id])).map((p) => p.id).toList();
    }

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

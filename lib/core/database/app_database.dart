import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class Games extends Table {
  TextColumn get id => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get gameType => text().withDefault(const Constant('faraway'))();
  TextColumn get name => text().nullable()(); // nom personnalisé pour les jeux génériques
  BoolColumn get finished => boolean()();
  TextColumn get winnerId => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class GamePlayers extends Table {
  TextColumn get gameId => text().references(Games, #id, onDelete: KeyAction.cascade)();
  TextColumn get playerId => text()(); // id du carnet si joueur enregistré, uuid temporaire sinon
  TextColumn get playerName => text()(); // snapshot du nom au moment de la partie
  IntColumn get position => integer()(); // ordre dans la partie
  TextColumn get scoresJson => text().withDefault(const Constant('[]'))(); // scores du joueur

  @override
  Set<Column> get primaryKey => {gameId, position};
}

class SavedPlayers extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Games, GamePlayers, SavedPlayers])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(games, games.winnerId);
          }
        },
      );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'faraway_game');
  }

  // ── Games ────────────────────────────────────────────────────────────────────

  Stream<List<Game>> watchAllGames() =>
      (select(games)..orderBy([(g) => OrderingTerm.desc(g.createdAt)])).watch();

  Stream<List<Game>> watchGamesByType(String type) =>
      (select(games)
            ..where((g) => g.gameType.equals(type))
            ..orderBy([(g) => OrderingTerm.desc(g.createdAt)]))
          .watch();

  Future<Game?> getGame(String id) =>
      (select(games)..where((g) => g.id.equals(id))).getSingleOrNull();

  Future<void> upsertGame(GamesCompanion game) =>
      into(games).insertOnConflictUpdate(game);

  Future<void> deleteGame(String id) =>
      (delete(games)..where((g) => g.id.equals(id))).go();

  // ── GamePlayers ───────────────────────────────────────────────────────────────

  Future<void> replaceGamePlayers(String gameId, List<GamePlayersCompanion> rows) async {
    await (delete(gamePlayers)..where((gp) => gp.gameId.equals(gameId))).go();
    await batch((b) => b.insertAll(gamePlayers, rows));
  }

  Future<List<GamePlayer>> getGamePlayers(String gameId) =>
      (select(gamePlayers)
            ..where((gp) => gp.gameId.equals(gameId))
            ..orderBy([(gp) => OrderingTerm.asc(gp.position)]))
          .get();

  // ── Stats joueur (optimisées SQL) ────────────────────────────────────────────

  Future<int> countPlayerGames(String playerId, String gameType) async {
    final query = customSelect(
      'SELECT COUNT(*) AS c FROM game_players gp '
      'JOIN games g ON g.id = gp.game_id '
      'WHERE gp.player_id = ? AND g.finished = 1 AND g.game_type = ?',
      variables: [Variable.withString(playerId), Variable.withString(gameType)],
      readsFrom: {gamePlayers, games},
    );
    final row = await query.getSingle();
    return row.read<int>('c');
  }

  Future<int> countPlayerWins(String playerId, String gameType) async {
    final query = customSelect(
      'SELECT COUNT(*) AS c FROM games '
      'WHERE winner_id = ? AND finished = 1 AND game_type = ?',
      variables: [Variable.withString(playerId), Variable.withString(gameType)],
      readsFrom: {games},
    );
    final row = await query.getSingle();
    return row.read<int>('c');
  }

  // ── SavedPlayers ──────────────────────────────────────────────────────────────

  Stream<List<SavedPlayer>> watchSavedPlayers() =>
      (select(savedPlayers)..orderBy([(p) => OrderingTerm.asc(p.name)])).watch();

  Future<void> upsertSavedPlayer(SavedPlayersCompanion player) =>
      into(savedPlayers).insertOnConflictUpdate(player);

  Future<void> deleteSavedPlayer(String id) =>
      (delete(savedPlayers)..where((p) => p.id.equals(id))).go();
}

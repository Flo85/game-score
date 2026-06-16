import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class Games extends Table {
  TextColumn get id => text()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get gameType => text().withDefault(const Constant('faraway'))();
  BoolColumn get finished => boolean()();

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
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'faraway_game');
  }

  // ── Games ────────────────────────────────────────────────────────────────────

  Stream<List<Game>> watchAllGames() =>
      (select(games)..orderBy([(g) => OrderingTerm.desc(g.createdAt)])).watch();

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

  // ── SavedPlayers ──────────────────────────────────────────────────────────────

  Stream<List<SavedPlayer>> watchSavedPlayers() =>
      (select(savedPlayers)..orderBy([(p) => OrderingTerm.asc(p.name)])).watch();

  Future<void> upsertSavedPlayer(SavedPlayersCompanion player) =>
      into(savedPlayers).insertOnConflictUpdate(player);

  Future<void> deleteSavedPlayer(String id) =>
      (delete(savedPlayers)..where((p) => p.id.equals(id))).go();
}

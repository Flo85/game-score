import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class Games extends Table {
  TextColumn get id => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get numberOfRows => integer().withDefault(const Constant(9))();
  BoolColumn get writable => boolean()();
  TextColumn get playersJson => text()();
  TextColumn get scoresJson => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class SavedPlayers extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Games, SavedPlayers])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) await m.createTable(savedPlayers);
    },
  );

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

  // ── SavedPlayers ──────────────────────────────────────────────────────────────

  Stream<List<SavedPlayer>> watchSavedPlayers() =>
      (select(savedPlayers)..orderBy([(p) => OrderingTerm.asc(p.name)])).watch();

  Future<void> upsertSavedPlayer(SavedPlayersCompanion player) =>
      into(savedPlayers).insertOnConflictUpdate(player);

  Future<void> deleteSavedPlayer(String id) =>
      (delete(savedPlayers)..where((p) => p.id.equals(id))).go();
}

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class Games extends Table {
  TextColumn get id => text()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get numberOfRows => integer().withDefault(const Constant(9))();
  BoolColumn get writable => boolean()();
  // players et scores stockés en JSON pour rester proche de l'existant
  TextColumn get playersJson => text()();
  TextColumn get scoresJson => text()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Games])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'faraway_game');
  }

  Stream<List<Game>> watchAllGames() =>
      (select(games)..orderBy([(g) => OrderingTerm.desc(g.createdAt)])).watch();

  Future<Game?> getGame(String id) =>
      (select(games)..where((g) => g.id.equals(id))).getSingleOrNull();

  Future<void> upsertGame(GamesCompanion game) =>
      into(games).insertOnConflictUpdate(game);

  Future<void> deleteGame(String id) =>
      (delete(games)..where((g) => g.id.equals(id))).go();
}

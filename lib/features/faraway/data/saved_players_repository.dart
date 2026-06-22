import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/app_database.dart';
import '../domain/models.dart';

class SavedPlayersRepository {
  final AppDatabase _db;

  SavedPlayersRepository(this._db);

  Stream<List<Player>> watchAll() => _db
      .watchSavedPlayers()
      .map((rows) => rows.map((r) => Player(id: r.id, name: r.name)).toList());

  Future<List<Player>> getAll() async {
    final rows = await _db.watchSavedPlayers().first;
    return rows.map((r) => Player(id: r.id, name: r.name)).toList();
  }

  Future<void> save(String name) => _db.upsertSavedPlayer(
        SavedPlayersCompanion(id: Value(const Uuid().v4()), name: Value(name)),
      );

  Future<void> addPlayer(Player player) => _db.upsertSavedPlayer(
        SavedPlayersCompanion(id: Value(player.id), name: Value(player.name)),
      );

  Future<void> rename(String id, String name) => _db.upsertSavedPlayer(
        SavedPlayersCompanion(id: Value(id), name: Value(name)),
      );

  Future<void> delete(String id) => _db.deleteSavedPlayer(id);
}

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../core/database/app_database.dart';
import '../data/faraway_repository.dart';
import 'models.dart';

part 'providers.g.dart';

const _numberOfRows = 9;

// ── Database & Repository ──────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) => AppDatabase();

@Riverpod(keepAlive: true)
FarawayRepository farawayRepository(Ref ref) =>
    FarawayRepository(ref.watch(appDatabaseProvider));

// ── Historique (stream réactif) ────────────────────────────────────────────────

@riverpod
Stream<List<FarawayGame>> gameHistory(Ref ref) =>
    ref.watch(farawayRepositoryProvider).watchHistory();

// ── Partie en cours ────────────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
class CurrentGame extends _$CurrentGame {
  @override
  FarawayGame? build() => null;

  Future<void> newGame(List<Player> players) async {
    final repo = ref.read(farawayRepositoryProvider);
    final game = FarawayGame(
      id: const Uuid().v4(),
      createdAt: DateTime.now(),
      players: players,
      scores: {for (final p in players) p.id: List.filled(_numberOfRows, null)},
      numberOfRows: _numberOfRows,
      writable: true,
    );
    await repo.saveGame(game);
    state = game;
  }

  Future<void> loadGame(String id) async {
    final game = await ref.read(farawayRepositoryProvider).loadGame(id);
    state = game;
  }

  void setScore(String playerId, int row, int? value) {
    final game = state;
    if (game == null || !game.writable) return;

    final newScores = Map<String, List<int?>>.from(
      game.scores.map((k, v) => MapEntry(k, List<int?>.from(v))),
    );
    newScores[playerId]?[row] = value;

    state = game.copyWith(scores: newScores);
    _autosave();
  }

  void updatePlayerName(String playerId, String name) {
    final game = state;
    if (game == null) return;

    final newPlayers = game.players
        .map((p) => p.id == playerId ? p.copyWith(name: name) : p)
        .toList();

    state = game.copyWith(players: newPlayers);
    _autosave();
  }

  Future<void> endGame() async {
    final game = state;
    if (game == null) return;
    state = game.copyWith(writable: false);
    await ref.read(farawayRepositoryProvider).saveGame(state!);
  }

  void reset() => state = null;

  void _autosave() {
    final game = state;
    if (game == null) return;
    ref.read(farawayRepositoryProvider).saveGame(game);
  }
}

// ── Setup (liste de joueurs avant la partie) ───────────────────────────────────

@riverpod
class SetupPlayers extends _$SetupPlayers {
  @override
  List<Player> build() => [
        Player.create('Joueur 1'),
        Player.create('Joueur 2'),
      ];

  void add() {
    if (state.length >= 7) return;
    state = [...state, Player.create('Joueur ${state.length + 1}')];
  }

  void remove(String id) => state = state.where((p) => p.id != id).toList();

  void rename(String id, String name) {
    state = state.map((p) => p.id == id ? p.copyWith(name: name) : p).toList();
  }

  void reorder(int from, int to) {
    final list = [...state];
    final moved = list.removeAt(from);
    list.insert(to, moved);
    state = list;
  }
}

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../features/faraway/domain/providers.dart' show appDatabaseProvider;
import '../data/generic_repository.dart';
import 'models.dart';

export '../../../features/faraway/domain/providers.dart' show savedPlayersListProvider, savedPlayersRepositoryProvider;

part 'providers.g.dart';

@Riverpod(keepAlive: true)
GenericRepository genericRepository(Ref ref) =>
    GenericRepository(ref.watch(appDatabaseProvider));

@Riverpod(keepAlive: true)
class CurrentGenericGame extends _$CurrentGenericGame {
  @override
  GenericGame? build() => null;

  Future<void> newGame(String name, List<Player> players) async {
    final game = GenericGame(
      id: const Uuid().v4(),
      name: name,
      createdAt: DateTime.now(),
      players: players,
      scores: {for (final p in players) p.id: []},
      finished: false,
    );
    await ref.read(genericRepositoryProvider).saveGame(game);
    state = game;
  }

  Future<void> loadGame(String id) async {
    final game = await ref.read(genericRepositoryProvider).loadGame(id);
    state = game;
  }

  void addRound() {
    final game = state;
    if (game == null || game.finished) return;
    final newScores = game.scores.map((k, v) => MapEntry(k, [...v, null]));
    state = game.copyWith(scores: newScores);
    _autosave();
  }

  void setScore(String playerId, int round, int? value) {
    final game = state;
    if (game == null || game.finished) return;
    final newScores = Map<String, List<int?>>.from(
      game.scores.map((k, v) => MapEntry(k, List<int?>.from(v))),
    );
    newScores[playerId]?[round] = value;
    state = game.copyWith(scores: newScores);
    _autosave();
  }

  Future<void> endGame() async {
    final game = state;
    if (game == null) return;
    state = game.copyWith(finished: true);
    await ref.read(genericRepositoryProvider).saveGame(state!);
  }

  void reset() => state = null;

  void _autosave() {
    final game = state;
    if (game == null) return;
    ref.read(genericRepositoryProvider).saveGame(game);
  }
}

@riverpod
Stream<List<GenericGame>> genericGameHistory(Ref ref) =>
    ref.watch(genericRepositoryProvider).watchHistory();

@riverpod
class GenericSetupName extends _$GenericSetupName {
  @override
  String build() => '';

  void set(String name) => state = name;
}

@riverpod
class GenericSetupPlayers extends _$GenericSetupPlayers {
  @override
  List<Player> build() => [Player.create('Joueur 1'), Player.create('Joueur 2')];

  void add() => state = [...state, Player.create('Joueur ${state.length + 1}')];

  void addPlayer(Player player) => state = [...state, Player.create(player.name)];

  void remove(String id) => state = state.where((p) => p.id != id).toList();

  void rename(String id, String name) =>
      state = state.map((p) => p.id == id ? p.copyWith(name: name) : p).toList();

  void setPlayer(String slotId, Player savedPlayer) =>
      state = state.map((p) => p.id == slotId ? savedPlayer : p).toList();

  void reorder(int from, int to) {
    final list = [...state];
    final moved = list.removeAt(from);
    list.insert(to, moved);
    state = list;
  }
}

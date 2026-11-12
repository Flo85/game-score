import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_score/core/models/player.dart';
import 'package:game_score/features/faraway/data/saved_players_repository.dart';
import 'package:game_score/features/faraway/domain/providers.dart';
import 'package:game_score/l10n/app_localizations.dart';
import 'package:game_score/presentation/widgets/player_picker.dart';
import 'package:game_score/presentation/widgets/setup_player_list.dart';

final _saved = [
  Player(id: 'a', name: 'Alice'),
  Player(id: 'b', name: 'Bob'),
  Player(id: 'c', name: 'Chloe'),
  Player(id: 'd', name: 'David'),
  Player(id: 'e', name: 'Emma'),
  Player(id: 'f', name: 'Farid'),
  Player(id: 'g', name: 'Gina'),
  Player(id: 'h', name: 'Hugo'),
];

Widget _app(ProviderContainer container) => UncontrolledProviderScope(
  container: container,
  child: MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('fr'),
    home: Scaffold(
      body: Consumer(
        builder: (context, ref, _) {
          ref.watch(setupPlayersProvider);
          return Column(
            children: [
              PlayerQuickPicker(
                gameType: 'faraway',
                playersProvider: setupPlayersProvider,
                maxPlayers: 7,
                onAdd: ref.read(setupPlayersProvider.notifier).addPlayer,
                onRemove: ref.read(setupPlayersProvider.notifier).removeByName,
              ),
              TextButton(
                onPressed: () => showPlayerPickerSheet(
                  context,
                  gameType: 'faraway',
                  playersProvider: setupPlayersProvider,
                  maxPlayers: 7,
                  onAdd: ref.read(setupPlayersProvider.notifier).addPlayer,
                  onRemove: ref
                      .read(setupPlayersProvider.notifier)
                      .removeByName,
                ),
                child: const Text('plus'),
              ),
            ],
          );
        },
      ),
    ),
  ),
);

void main() {
  late ProviderContainer container;
  final created = <Player>[];

  setUp(() {
    created.clear();
    container = ProviderContainer(
      overrides: [
        savedPlayersListProvider.overrideWith((ref) => Stream.value(_saved)),
        playerGameCountsProvider(
          'faraway',
        ).overrideWith((ref) => Stream.value({'h': 9, 'g': 5})),
        savedPlayersRepositoryProvider.overrideWithValue(_FakeRepo(created)),
      ],
    );
  });
  tearDown(() => container.dispose());

  testWidgets('chips sorted by frequency, capped at 6, with a label', (
    tester,
  ) async {
    await tester.pumpWidget(_app(container));
    await tester.pumpAndSettle();

    final labels = tester
        .widgetList<FilterChip>(find.byType(FilterChip))
        .map((c) => (c.label as Text).data)
        .toList();
    expect(labels, ['Hugo', 'Gina', 'Alice', 'Bob', 'Chloe', 'David']);
    expect(find.text('Joueurs fréquents'), findsOneWidget);
  });

  testWidgets('tap adds the saved player, tap again removes', (tester) async {
    await tester.pumpWidget(_app(container));
    await tester.pumpAndSettle();
    expect(container.read(setupPlayersProvider), isEmpty);

    await tester.tap(find.text('Hugo'));
    await tester.pump();
    final players = container.read(setupPlayersProvider);
    expect(players.length, 1);
    expect(players.first.name, 'Hugo');
    expect(players.first.id, 'h');

    await tester.tap(find.text('Hugo'));
    await tester.pump();
    expect(
      container.read(setupPlayersProvider).where((p) => p.name == 'Hugo'),
      isEmpty,
    );
  });

  testWidgets('chips are disabled once 7 players are selected', (tester) async {
    await tester.pumpWidget(_app(container));
    await tester.pumpAndSettle();

    final notifier = container.read(setupPlayersProvider.notifier);
    for (final p in _saved.take(7)) {
      notifier.addPlayer(p);
    }
    await tester.pump();

    final hugo = tester.widget<FilterChip>(
      find.widgetWithText(FilterChip, 'Hugo'),
    );
    expect(hugo.selected, isFalse);
    expect(hugo.onSelected, isNull);
    final david = tester.widget<FilterChip>(
      find.widgetWithText(FilterChip, 'David'),
    );
    expect(david.onSelected, isNotNull);

    notifier.addPlayer(Player(id: 'x', name: 'Extra'));
    expect(container.read(setupPlayersProvider).length, 7);
  });

  testWidgets('setup list: empty hint, numbered rows, remove', (tester) async {
    final removed = <String>[];
    Widget list(List<Player> players) => MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('fr'),
      home: Scaffold(
        body: SetupPlayerList(
          players: players,
          onReorder: (_, _) {},
          onRemove: removed.add,
        ),
      ),
    );

    await tester.pumpWidget(list([]));
    expect(find.text('Ajoutez au moins un joueur'), findsOneWidget);

    await tester.pumpWidget(
      list([Player(id: 'a', name: 'Alice'), Player(id: 'b', name: 'Bob')]),
    );
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.close).last);
    expect(removed, ['b']);
  });

  testWidgets('picker sheet lists everyone, filters, creates', (tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(_app(container));
    await tester.pumpAndSettle();

    await tester.tap(find.text('plus'));
    await tester.pumpAndSettle();
    expect(find.byType(CheckboxListTile), findsNWidgets(8));

    await tester.enterText(find.byType(TextField), 'zo');
    await tester.pump();
    expect(find.byType(CheckboxListTile), findsNothing);
    await tester.tap(find.text('Créer « zo »'));
    await tester.pumpAndSettle();
    expect(created.single.name, 'zo');
    expect(
      container.read(setupPlayersProvider).any((p) => p.name == 'zo'),
      isTrue,
    );
  });

  testWidgets('sheet: Enter creates a new player and keeps the field ready', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(_app(container));
    await tester.pumpAndSettle();

    await tester.tap(find.text('plus'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '  Zoe ');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(created.single.name, 'Zoe');
    expect(container.read(setupPlayersProvider).single.name, 'Zoe');
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      '',
    );
  });

  testWidgets(
    'sheet: Enter on an existing name adds it once, never duplicates',
    (tester) async {
      tester.view.physicalSize = const Size(800, 2400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(_app(container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('plus'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), ' alice ');
      expect(find.textContaining('Créer'), findsNothing);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(container.read(setupPlayersProvider).map((p) => p.id), ['a']);
      expect(created, isEmpty);

      await tester.enterText(find.byType(TextField), 'ALICE');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      expect(container.read(setupPlayersProvider).length, 1);
      expect(created, isEmpty);
    },
  );
}

class _FakeRepo implements SavedPlayersRepository {
  final List<Player> created;
  _FakeRepo(this.created);

  @override
  Future<List<Player>> getAll() async => _saved;

  @override
  Future<void> addPlayer(Player player) async => created.add(player);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

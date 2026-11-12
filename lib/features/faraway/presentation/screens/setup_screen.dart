import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../presentation/widgets/player_picker.dart';
import '../../../../presentation/widgets/setup_player_list.dart';
import '../../../../presentation/widgets/start_fab.dart';
import '../../domain/providers.dart';
import '../../../../presentation/screens/history_screen.dart';
import 'game_screen.dart';
import 'saved_players_screen.dart';

class SetupScreen extends ConsumerWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final players = ref.watch(setupPlayersProvider);
    final notifier = ref.read(setupPlayersProvider.notifier);
    final isMaxReached = players.length >= 7;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.people_outline),
            tooltip: l.playerBook,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SavedPlayersScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: l.history,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryScreen(initialFilter: GameFilter.faraway)),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset('assets/images/logo-faraway.png', width: double.infinity, fit: BoxFit.fitWidth),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(
              l.newGame,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              l.playersCounter(players.length, 7),
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          PlayerQuickPicker(
            gameType: 'faraway',
            playersProvider: setupPlayersProvider,
            maxPlayers: 7,
            onAdd: notifier.addPlayer,
            onRemove: notifier.removeByName,
          ),
          Expanded(
            child: SetupPlayerList(
              players: players,
              onReorder: notifier.reorder,
              onRemove: notifier.remove,
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (!isMaxReached) ...[
            FloatingActionButton(
              heroTag: 'addPlayer',
              onPressed: () => showPlayerPickerSheet(
                context,
                gameType: 'faraway',
                playersProvider: setupPlayersProvider,
                maxPlayers: 7,
                onAdd: notifier.addPlayer,
                onRemove: notifier.removeByName,
              ),
              child: const Icon(Icons.add),
            ),
            const SizedBox(width: 12),
          ],
          StartFab(
            active: players.isNotEmpty,
            label: l.start,
            onPressed: () async {
              await ref.read(currentGameProvider.notifier).newGame(players);
              if (context.mounted) {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const GameScreen()));
              }
            },
          ),
        ],
      ),
    );
  }
}

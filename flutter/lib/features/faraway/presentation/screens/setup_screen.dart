import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/providers.dart';
import 'game_screen.dart';
import 'history_screen.dart';

class SetupScreen extends ConsumerWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = ref.watch(setupPlayersProvider);
    final notifier = ref.read(setupPlayersProvider.notifier);
    final isMaxReached = players.length >= 7;

    final isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: isLandscape ? const Text('Faraway — Nouvelle partie') : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Historique',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            ),
          ),
          TextButton(
            onPressed: players.isEmpty
                ? null
                : () async {
                    await ref.read(currentGameProvider.notifier).newGame(players);
                    if (context.mounted) {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const GameScreen()));
                    }
                  },
            child: const Text('Commencer'),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!isLandscape) ...[
            Image.asset('assets/images/logo-faraway.png', width: double.infinity, fit: BoxFit.fitWidth),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Text(
                'Nouvelle partie',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
            ),
          ],
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              'Maximum de 7 joueurs',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ReorderableListView.builder(
              itemCount: players.length,
              onReorderItem: notifier.reorder,
              buildDefaultDragHandles: false,
              itemBuilder: (context, i) {
                final player = players[i];
                return ListTile(
                  key: ValueKey(player.id),
                  title: TextFormField(
                    initialValue: player.name,
                    decoration: InputDecoration(labelText: 'Joueur ${i + 1}'),
                    onChanged: (v) => notifier.rename(player.id, v),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => notifier.remove(player.id),
                      ),
                      ReorderableDragStartListener(
                        index: i,
                        child: const Icon(Icons.drag_handle),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: isMaxReached
          ? null
          : FloatingActionButton(
              onPressed: notifier.add,
              child: const Icon(Icons.add),
            ),
    );
  }
}

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

    return Scaffold(
      appBar: AppBar(title: const Text('Faraway — Nouvelle partie')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Image.asset('assets/images/logo-faraway.png', height: 80),
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FilledButton(
                  onPressed: players.isEmpty
                      ? null
                      : () async {
                          await ref.read(currentGameProvider.notifier).newGame(players);
                          if (context.mounted) {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const GameScreen()));
                          }
                        },
                  child: const Text('Commencer la partie'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HistoryScreen()),
                  ),
                  child: const Text('Historique'),
                ),
              ],
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

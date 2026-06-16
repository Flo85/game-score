import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models.dart';
import '../../domain/providers.dart';
import 'game_screen.dart';
import 'history_screen.dart';
import 'saved_players_screen.dart';

class SetupScreen extends ConsumerWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = ref.watch(setupPlayersProvider);
    final notifier = ref.read(setupPlayersProvider.notifier);
    final savedPlayers = ref.watch(savedPlayersListProvider).asData?.value ?? [];
    final isMaxReached = players.length >= 7;
    final isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: isLandscape ? const Text('Faraway — Nouvelle partie') : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.people_outline),
            tooltip: 'Carnet de joueurs',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SavedPlayersScreen()),
            ),
          ),
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
                  title: _PlayerNameField(
                    player: player,
                    index: i,
                    savedPlayers: savedPlayers,
                    currentPlayers: players,
                    onChanged: (name) {
                      // Si le nom ne correspond plus au joueur du carnet, on détache l'id
                      final isSavedPlayer = savedPlayers.any((s) => s.id == player.id);
                      if (isSavedPlayer && name != player.name) {
                        notifier.setPlayer(player.id, Player.create(name));
                      } else {
                        notifier.rename(player.id, name);
                      }
                    },
                    onSavedPlayerSelected: (saved) => notifier.setPlayer(player.id, saved),
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

// ── Champ nom avec autocomplete ───────────────────────────────────────────────

class _PlayerNameField extends StatelessWidget {
  final Player player;
  final int index;
  final List<Player> savedPlayers;
  final List<Player> currentPlayers;
  final ValueChanged<String> onChanged;
  final ValueChanged<Player> onSavedPlayerSelected;

  const _PlayerNameField({
    required this.player,
    required this.index,
    required this.savedPlayers,
    required this.currentPlayers,
    required this.onChanged,
    required this.onSavedPlayerSelected,
  });

  @override
  Widget build(BuildContext context) {
    final takenNames = currentPlayers
        .where((p) => p.id != player.id)
        .map((p) => p.name.toLowerCase())
        .toSet();

    return Autocomplete<Player>(
      initialValue: TextEditingValue(text: player.name),
      displayStringForOption: (p) => p.name,
      optionsBuilder: (value) {
        final query = value.text.toLowerCase();
        if (query.isEmpty) return [];
        return savedPlayers.where(
          (p) => p.name.toLowerCase().contains(query) && !takenNames.contains(p.name.toLowerCase()),
        );
      },
      onSelected: onSavedPlayerSelected,
      fieldViewBuilder: (context, controller, focusNode, _) {
        focusNode.addListener(() {
          if (focusNode.hasFocus) {
            controller.selection = TextSelection(
              baseOffset: 0,
              extentOffset: controller.text.length,
            );
          } else {
            final trimmed = controller.text.trim();
            if (trimmed != controller.text) {
              controller.text = trimmed;
              onChanged(trimmed);
            }
          }
        });
        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(labelText: 'Joueur ${index + 1}'),
          textCapitalization: TextCapitalization.words,
          onChanged: onChanged,
        );
      },
    );
  }
}

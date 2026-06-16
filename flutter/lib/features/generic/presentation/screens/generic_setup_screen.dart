import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/faraway/presentation/screens/saved_players_screen.dart';
import '../../domain/models.dart';
import '../../domain/providers.dart';
import 'generic_game_screen.dart';
import 'generic_history_screen.dart';

class GenericSetupScreen extends ConsumerWidget {
  const GenericSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = ref.watch(genericSetupPlayersProvider);
    final notifier = ref.read(genericSetupPlayersProvider.notifier);
    final savedPlayers = ref.watch(savedPlayersListProvider).asData?.value ?? [];
    final gameName = ref.watch(genericSetupNameProvider);
    final canStart = players.isNotEmpty && gameName.trim().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
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
              MaterialPageRoute(builder: (_) => const GenericHistoryScreen()),
            ),
          ),
          TextButton(
            onPressed: canStart
                ? () async {
                    final trimmedPlayers = players
                        .map((p) => p.copyWith(name: p.name.trim()))
                        .toList();
                    await ref
                        .read(currentGenericGameProvider.notifier)
                        .newGame(gameName.trim(), trimmedPlayers);
                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const GenericGameScreen()),
                      );
                    }
                  }
                : null,
            child: const Text('Commencer'),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(
              'Nouvelle partie',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Nom du jeu',
                hintText: 'ex : Uno, Catan, Skyjo…',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
              onChanged: (v) => ref.read(genericSetupNameProvider.notifier).set(v),
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
      floatingActionButton: FloatingActionButton(
        onPressed: notifier.add,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ── Champ nom avec autocomplete (identique au setup Faraway) ──────────────────

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
          (p) =>
              p.name.toLowerCase().contains(query) &&
              !takenNames.contains(p.name.toLowerCase()),
        );
      },
      onSelected: onSavedPlayerSelected,
      fieldViewBuilder: (context, controller, focusNode, _) {
        focusNode.addListener(() {
          if (focusNode.hasFocus) {
            controller.selection =
                TextSelection(baseOffset: 0, extentOffset: controller.text.length);
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

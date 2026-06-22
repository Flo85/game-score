import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/models.dart';
import '../../domain/providers.dart';
import 'game_screen.dart';
import 'history_screen.dart';
import 'saved_players_screen.dart';

class SetupScreen extends ConsumerWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final players = ref.watch(setupPlayersProvider);
    final notifier = ref.read(setupPlayersProvider.notifier);
    final savedPlayers = ref.watch(savedPlayersListProvider).asData?.value ?? [];
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
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            ),
          ),
          TextButton(
            onPressed: players.length < 2 || players.any((p) => p.name.trim().isEmpty)
                ? null
                : () async {
                    await ref.read(currentGameProvider.notifier).newGame(players);
                    if (context.mounted) {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const GameScreen()));
                    }
                  },
            child: Text(l.start),
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
              l.maxPlayers,
              style: const TextStyle(color: Colors.grey),
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
                    onChanged: (name) => notifier.rename(player.id, name),
                    onSavedPlayerSelected: (saved) => notifier.rename(player.id, saved.name),
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

class _PlayerNameField extends StatefulWidget {
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
  State<_PlayerNameField> createState() => _PlayerNameFieldState();
}

class _PlayerNameFieldState extends State<_PlayerNameField> {
  bool _initialized = false;
  FocusNode? _focusNode;
  TextEditingController? _controller;

  void _onFocusChange() {
    final focusNode = _focusNode!;
    final controller = _controller!;
    if (focusNode.hasFocus) {
      controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: controller.text.length,
      );
    } else {
      final trimmed = controller.text.trim();
      if (trimmed != controller.text) {
        controller.text = trimmed;
        widget.onChanged(trimmed);
      }
    }
  }

  @override
  void dispose() {
    _focusNode?.removeListener(_onFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final takenNames = widget.currentPlayers
        .where((p) => p.id != widget.player.id)
        .map((p) => p.name.toLowerCase())
        .toSet();

    return Autocomplete<Player>(
      displayStringForOption: (p) => p.name,
      optionsBuilder: (value) {
        final query = value.text.toLowerCase();
        if (query.isEmpty) return [];
        return widget.savedPlayers.where(
          (p) =>
              p.name.toLowerCase().startsWith(query) &&
              !takenNames.contains(p.name.toLowerCase()),
        );
      },
      onSelected: widget.onSavedPlayerSelected,
      fieldViewBuilder: (context, controller, focusNode, _) {
        if (!_initialized) {
          _initialized = true;
          _controller = controller;
          _focusNode = focusNode;
          controller.text = widget.player.name;
          focusNode.addListener(_onFocusChange);
        }
        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(labelText: AppLocalizations.of(context).playerIndex(widget.index + 1)),
          textCapitalization: TextCapitalization.words,
          onChanged: widget.onChanged,
        );
      },
    );
  }
}

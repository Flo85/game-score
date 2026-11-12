import 'package:flutter/material.dart';
import '../../core/models/player.dart';
import '../../l10n/app_localizations.dart';

class SetupPlayerList extends StatelessWidget {
  final List<Player> players;
  final ReorderCallback onReorder;
  final ValueChanged<String> onRemove;

  const SetupPlayerList({
    super.key,
    required this.players,
    required this.onReorder,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (players.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context).addAtLeastOnePlayer,
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }

    return ReorderableListView.builder(
      itemCount: players.length,
      onReorderItem: onReorder,
      buildDefaultDragHandles: false,
      padding: const EdgeInsets.only(bottom: 160),
      itemBuilder: (context, i) {
        final player = players[i];
        return ListTile(
          key: ValueKey(player.id),
          leading: CircleAvatar(
            radius: 14,
            child: Text('${i + 1}', style: const TextStyle(fontSize: 13)),
          ),
          title: Text(player.name),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => onRemove(player.id),
              ),
              ReorderableDragStartListener(
                index: i,
                child: const Icon(Icons.drag_handle),
              ),
            ],
          ),
        );
      },
    );
  }
}

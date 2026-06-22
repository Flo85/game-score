import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../presentation/screens/player_stats_screen.dart';
import '../../domain/models.dart';
import '../../domain/providers.dart';

class SavedPlayersScreen extends ConsumerWidget {
  const SavedPlayersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playersAsync = ref.watch(savedPlayersListProvider);
    final repo = ref.read(savedPlayersRepositoryProvider);

    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.playerBook)),
      body: playersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.errorMessage(e.toString()))),
        data: (players) {
          if (players.isEmpty) {
            return Center(child: Text(l.noPlayersRecorded));
          }
          return ListView.builder(
            itemCount: players.length,
            itemBuilder: (context, i) {
              final player = players[i];
              return ListTile(
                title: Text(player.name),
                subtitle: _PlayerStatsSummary(playerId: player.id),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => _showRenameDialog(context, player, players, repo.rename),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _showDeleteDialog(context, player, repo.delete),
                    ),
                  ],
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PlayerStatsScreen(player: player)),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final players = playersAsync.asData?.value ?? [];
          _showAddDialog(context, players, repo.save);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context, List<Player> existing, Future<void> Function(String) onAdd) async {
    final l = AppLocalizations.of(context);
    final controller = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => _NameDialog(
        title: l.addPlayer,
        confirmLabel: l.add,
        controller: controller,
        existingNames: existing.map((p) => p.name).toList(),
      ),
    );
    if (confirmed == true && controller.text.trim().isNotEmpty) {
      await onAdd(controller.text.trim());
    }
  }

  Future<void> _showRenameDialog(BuildContext context, Player player, List<Player> existing, Future<void> Function(String, String) onRename) async {
    final l = AppLocalizations.of(context);
    final controller = TextEditingController(text: player.name);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => _NameDialog(
        title: l.rename,
        confirmLabel: l.rename,
        controller: controller,
        existingNames: existing.where((p) => p.id != player.id).map((p) => p.name).toList(),
      ),
    );
    if (confirmed == true && controller.text.trim().isNotEmpty) {
      await onRename(player.id, controller.text.trim());
    }
  }

  Future<void> _showDeleteDialog(BuildContext context, Player player, Future<void> Function(String) onDelete) async {
    final l = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.deletePlayerQuestion(player.name)),
        content: Text(l.irreversible),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l.delete),
          ),
        ],
      ),
    );
    if (confirmed == true) await onDelete(player.id);
  }
}

// ── Dialogue de saisie de nom avec validation doublon ─────────────────────────

class _NameDialog extends StatefulWidget {
  final String title;
  final String confirmLabel;
  final TextEditingController controller;
  final List<String> existingNames;

  const _NameDialog({
    required this.title,
    required this.confirmLabel,
    required this.controller,
    required this.existingNames,
  });

  @override
  State<_NameDialog> createState() => _NameDialogState();
}

class _NameDialogState extends State<_NameDialog> {
  String? _error;

  void _validate(String value) {
    final trimmed = value.trim();
    final isDuplicate = widget.existingNames
        .any((n) => n.toLowerCase() == trimmed.toLowerCase());
    setState(() {
      _error = isDuplicate ? AppLocalizations.of(context).duplicateName : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: widget.controller,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context).playerNameHint,
          errorText: _error,
        ),
        onChanged: _validate,
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text(AppLocalizations.of(context).cancel)),
        TextButton(
          onPressed: _error == null ? () => Navigator.pop(context, true) : null,
          child: Text(widget.confirmLabel),
        ),
      ],
    );
  }
}

// ── Résumé stats dans le carnet ───────────────────────────────────────────────

class _PlayerStatsSummary extends ConsumerWidget {
  final String playerId;
  const _PlayerStatsSummary({required this.playerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(playerCarnetSummaryProvider(playerId));
    return summaryAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (s) {
        if (s.games == 0) return const SizedBox.shrink();
        final l = AppLocalizations.of(context);
        return Text('${l.gamesCount(s.games)} · ${l.winsCount(s.wins)}');
      },
    );
  }
}

// ── Bottom sheet de sélection ─────────────────────────────────────────────────

Future<List<Player>?> showPlayerPickerSheet(BuildContext context, WidgetRef ref, List<Player> alreadySelected) {
  return showModalBottomSheet<List<Player>>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _PlayerPickerSheet(alreadySelected: alreadySelected),
  );
}

class _PlayerPickerSheet extends ConsumerStatefulWidget {
  final List<Player> alreadySelected;

  const _PlayerPickerSheet({required this.alreadySelected});

  @override
  ConsumerState<_PlayerPickerSheet> createState() => _PlayerPickerSheetState();
}

class _PlayerPickerSheetState extends ConsumerState<_PlayerPickerSheet> {
  late final Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.alreadySelected.map((p) => p.id).toSet();
  }

  @override
  Widget build(BuildContext context) {
    final playersAsync = ref.watch(savedPlayersListProvider);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      builder: (_, scrollController) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context).playerBook, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                TextButton(
                  onPressed: () {
                    final allPlayers = (playersAsync.asData?.value ?? [])
                        .where((p) => _selected.contains(p.id))
                        .toList();
                    Navigator.pop(context, allPlayers);
                  },
                  child: Text(AppLocalizations.of(context).add),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: playersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(AppLocalizations.of(context).errorMessage(e.toString()))),
              data: (players) {
                if (players.isEmpty) {
                  return Center(child: Text(AppLocalizations.of(context).noPlayersRecorded));
                }
                return ListView.builder(
                  controller: scrollController,
                  itemCount: players.length,
                  itemBuilder: (_, i) {
                    final player = players[i];
                    final isSelected = _selected.contains(player.id);
                    return CheckboxListTile(
                      title: Text(player.name),
                      value: isSelected,
                      onChanged: (_) => setState(() {
                        isSelected ? _selected.remove(player.id) : _selected.add(player.id);
                      }),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

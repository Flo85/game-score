import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../presentation/screens/player_stats_screen.dart';
import '../../domain/models.dart';
import '../../domain/providers.dart';

enum _GameFilter { all, faraway, generic }
enum _SortBy { name, wins, games }

class SavedPlayersScreen extends ConsumerStatefulWidget {
  const SavedPlayersScreen({super.key});

  @override
  ConsumerState<SavedPlayersScreen> createState() => _SavedPlayersScreenState();
}

class _SavedPlayersScreenState extends ConsumerState<SavedPlayersScreen> {
  _GameFilter _filter = _GameFilter.all;
  _SortBy _sortBy = _SortBy.name;

  String get _gameType => switch (_filter) {
        _GameFilter.all => 'all',
        _GameFilter.faraway => 'faraway',
        _GameFilter.generic => 'generic',
      };

  @override
  Widget build(BuildContext context) {
    final playersAsync = ref.watch(savedPlayersListProvider);
    final repo = ref.read(savedPlayersRepositoryProvider);
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.playerBook)),
      body: Column(
        children: [
          _FilterSortBar(
            filter: _filter,
            sortBy: _sortBy,
            onFilterChanged: (f) => setState(() => _filter = f),
            onSortChanged: (s) => setState(() => _sortBy = s),
          ),
          const Divider(height: 1),
          Expanded(
            child: playersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text(l.errorMessage(e.toString()))),
              data: (players) {
                if (players.isEmpty) return Center(child: Text(l.noPlayersRecorded));
                return _SortedPlayerList(
                  players: players,
                  gameType: _gameType,
                  sortBy: _sortBy,
                  repo: repo,
                );
              },
            ),
          ),
        ],
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
}

// ── Barre filtre + tri ────────────────────────────────────────────────────────

class _FilterSortBar extends StatelessWidget {
  final _GameFilter filter;
  final _SortBy sortBy;
  final ValueChanged<_GameFilter> onFilterChanged;
  final ValueChanged<_SortBy> onSortChanged;

  const _FilterSortBar({
    required this.filter,
    required this.sortBy,
    required this.onFilterChanged,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Row(
        children: [
          Expanded(
            child: _LabeledDropdown<_GameFilter>(
              label: l.filterByGame,
              value: filter,
              items: [
                DropdownMenuItem(value: _GameFilter.all, child: Text(l.allGames)),
                DropdownMenuItem(value: _GameFilter.faraway, child: Text(l.farawayGame)),
                DropdownMenuItem(value: _GameFilter.generic, child: Text(l.genericGame)),
              ],
              onChanged: (v) { if (v != null) onFilterChanged(v); },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _LabeledDropdown<_SortBy>(
              label: l.sortBy,
              value: sortBy,
              items: [
                DropdownMenuItem(value: _SortBy.name, child: Text(l.sortByName)),
                DropdownMenuItem(value: _SortBy.wins, child: Text(l.sortByWins)),
                DropdownMenuItem(value: _SortBy.games, child: Text(l.sortByGames)),
              ],
              onChanged: (v) { if (v != null) onSortChanged(v); },
            ),
          ),
        ],
      ),
    );
  }
}

class _LabeledDropdown<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const _LabeledDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 2),
        DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            value: value,
            isExpanded: true,
            isDense: true,
            items: items,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

// ── Liste triée (charge les stats pour le tri) ────────────────────────────────

class _SortedPlayerList extends ConsumerWidget {
  final List<Player> players;
  final String gameType;
  final _SortBy sortBy;
  final dynamic repo;

  const _SortedPlayerList({
    required this.players,
    required this.gameType,
    required this.sortBy,
    required this.repo,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (sortBy == _SortBy.name) {
      return _buildList(context, ref, players);
    }

    // Pour trier par victoires ou parties, on charge toutes les stats
    final statsFutures = players.map((p) => ref.watch(playerStatsByGameProvider(p.id, gameType))).toList();
    final allLoaded = statsFutures.every((a) => a.hasValue);

    if (!allLoaded) return const Center(child: CircularProgressIndicator());

    final withStats = List.generate(players.length, (i) => (player: players[i], stats: statsFutures[i].value!));
    final sorted = [...withStats]..sort((a, b) {
      final primary = sortBy == _SortBy.wins
          ? b.stats.wins.compareTo(a.stats.wins)
          : b.stats.games.compareTo(a.stats.games);
      if (primary != 0) return primary;
      return a.player.name.toLowerCase().compareTo(b.player.name.toLowerCase());
    });

    return _buildList(context, ref, sorted.map((e) => e.player).toList());
  }

  Widget _buildList(BuildContext context, WidgetRef ref, List<Player> sorted) {
    final l = AppLocalizations.of(context);
    return ListView.builder(
      itemCount: sorted.length,
      itemBuilder: (context, i) {
        final player = sorted[i];
        return ListTile(
          title: Text(player.name),
          subtitle: _PlayerStatsSummary(playerId: player.id, gameType: gameType),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => _showRenameDialog(context, ref, player, players),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _showDeleteDialog(context, player),
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
  }

  Future<void> _showRenameDialog(BuildContext context, WidgetRef ref, Player player, List<Player> all) async {
    final l = AppLocalizations.of(context);
    final controller = TextEditingController(text: player.name);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => _NameDialog(
        title: l.rename,
        confirmLabel: l.rename,
        controller: controller,
        existingNames: all.where((p) => p.id != player.id).map((p) => p.name).toList(),
      ),
    );
    if (confirmed == true && controller.text.trim().isNotEmpty) {
      await repo.rename(player.id, controller.text.trim());
    }
  }

  Future<void> _showDeleteDialog(BuildContext context, Player player) async {
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
    if (confirmed == true) await repo.delete(player.id);
  }
}

// ── Résumé stats dans le carnet ───────────────────────────────────────────────

class _PlayerStatsSummary extends ConsumerWidget {
  final String playerId;
  final String gameType;
  const _PlayerStatsSummary({required this.playerId, required this.gameType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(playerStatsByGameProvider(playerId, gameType));
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
    final isDuplicate = widget.existingNames.any((n) => n.toLowerCase() == trimmed.toLowerCase());
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
                if (players.isEmpty) return Center(child: Text(AppLocalizations.of(context).noPlayersRecorded));
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

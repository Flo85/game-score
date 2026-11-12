import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderListenable;
import '../../core/models/player.dart';
import '../../features/faraway/domain/providers.dart';
import '../../l10n/app_localizations.dart';

const _kMaxChips = 6;

typedef PlayersSource = ProviderListenable<List<Player>>;

String _key(String name) => name.trim().toLowerCase();

bool _canAddPlayer(List<Player> current, int? maxPlayers) =>
    maxPlayers == null || current.length < maxPlayers;

bool _isSelected(List<Player> current, Player saved) =>
    current.any((p) => _key(p.name) == _key(saved.name));

List<Player> _sortByFrequency(List<Player> players, Map<String, int> counts) {
  final sorted = [...players];
  sorted.sort((a, b) {
    final byCount = (counts[b.id] ?? 0).compareTo(counts[a.id] ?? 0);
    return byCount != 0 ? byCount : _key(a.name).compareTo(_key(b.name));
  });
  return sorted;
}

Future<void> _createAndAdd(
  WidgetRef ref,
  String name,
  ValueChanged<Player> onAdd,
) async {
  final player = Player.create(name.trim());
  await ref.read(savedPlayersRepositoryProvider).addPlayer(player);
  onAdd(player);
}

// ── Chips d'ajout rapide ──────────────────────────────────────────────────────

class PlayerQuickPicker extends ConsumerWidget {
  final String gameType;
  final PlayersSource playersProvider;
  final int? maxPlayers;
  final ValueChanged<Player> onAdd;
  final ValueChanged<String> onRemove;

  const PlayerQuickPicker({
    super.key,
    required this.gameType,
    required this.playersProvider,
    required this.onAdd,
    required this.onRemove,
    this.maxPlayers,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved =
        ref.watch(savedPlayersListProvider).asData?.value ?? const <Player>[];
    final countsAsync = ref.watch(playerGameCountsProvider(gameType));
    if (saved.isEmpty || (countsAsync.isLoading && !countsAsync.hasValue)) {
      return const SizedBox.shrink();
    }

    final current = ref.watch(playersProvider);
    final sorted = _sortByFrequency(saved, countsAsync.value ?? const {});
    final shown = sorted.take(_kMaxChips).toList();
    final canAdd = _canAddPlayer(current, maxPlayers);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context).frequentPlayers,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final p in shown) _chip(p, _isSelected(current, p), canAdd),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(Player p, bool selected, bool canAdd) => FilterChip(
    label: Text(p.name),
    selected: selected,
    visualDensity: VisualDensity.compact,
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    onSelected: selected
        ? (_) => onRemove(p.name)
        : canAdd
        ? (_) => onAdd(p)
        : null,
  );
}

// ── Pop-up avec tous les joueurs du carnet ────────────────────────────────────

Future<void> showPlayerPickerSheet(
  BuildContext context, {
  required String gameType,
  required PlayersSource playersProvider,
  required ValueChanged<Player> onAdd,
  required ValueChanged<String> onRemove,
  int? maxPlayers,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _PlayerPickerSheet(
      gameType: gameType,
      playersProvider: playersProvider,
      maxPlayers: maxPlayers,
      onAdd: onAdd,
      onRemove: onRemove,
    ),
  );
}

class _PlayerPickerSheet extends ConsumerStatefulWidget {
  final String gameType;
  final PlayersSource playersProvider;
  final int? maxPlayers;
  final ValueChanged<Player> onAdd;
  final ValueChanged<String> onRemove;

  const _PlayerPickerSheet({
    required this.gameType,
    required this.playersProvider,
    required this.maxPlayers,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  ConsumerState<_PlayerPickerSheet> createState() => _PlayerPickerSheetState();
}

class _PlayerPickerSheetState extends ConsumerState<_PlayerPickerSheet> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _searchController.text.trim();
    if (name.isEmpty) return;
    final current = ref.read(widget.playersProvider);
    if (!_canAddPlayer(current, widget.maxPlayers)) return;
    final key = _key(name);
    if (current.any((p) => _key(p.name) == key)) return;
    final saved =
        ref.read(savedPlayersListProvider).asData?.value ?? const <Player>[];
    final match = saved.where((p) => _key(p.name) == key).firstOrNull;
    if (match != null) {
      widget.onAdd(match);
    } else {
      await _createAndAdd(ref, name, widget.onAdd);
    }
    if (mounted) setState(_searchController.clear);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final saved =
        ref.watch(savedPlayersListProvider).asData?.value ?? const <Player>[];
    final counts =
        ref.watch(playerGameCountsProvider(widget.gameType)).asData?.value ??
        const <String, int>{};
    final current = ref.watch(widget.playersProvider);
    final canAdd = _canAddPlayer(current, widget.maxPlayers);

    final rawQuery = _searchController.text.trim();
    final query = rawQuery.toLowerCase();
    final filtered = _sortByFrequency(
      saved,
      counts,
    ).where((p) => query.isEmpty || _key(p.name).contains(query)).toList();
    final nameTaken =
        saved.any((p) => _key(p.name) == query) ||
        current.any((p) => _key(p.name) == query);
    final showCreate = query.isNotEmpty && !nameTaken;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l.addPlayer,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l.done),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: l.searchPlayer,
                  prefixIcon: const Icon(Icons.search),
                  isDense: true,
                  border: const OutlineInputBorder(),
                ),
                onChanged: (_) => setState(() {}),
                onEditingComplete: _submit,
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  if (showCreate)
                    ListTile(
                      leading: const Icon(Icons.person_add_alt),
                      title: Text(l.createPlayerNamed(rawQuery)),
                      enabled: canAdd,
                      onTap: _submit,
                    ),
                  for (final p in filtered) _row(p, current, counts, canAdd, l),
                  if (filtered.isEmpty && !showCreate)
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(child: Text(l.noPlayersRecorded)),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(
    Player p,
    List<Player> current,
    Map<String, int> counts,
    bool canAdd,
    AppLocalizations l,
  ) {
    final selected = _isSelected(current, p);
    final games = counts[p.id] ?? 0;
    return CheckboxListTile(
      title: Text(p.name),
      subtitle: games > 0 ? Text(l.gamesCount(games)) : null,
      value: selected,
      onChanged: selected
          ? (_) => widget.onRemove(p.name)
          : canAdd
          ? (_) => widget.onAdd(p)
          : null,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../../features/faraway/presentation/screens/saved_players_screen.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../presentation/widgets/start_fab.dart';
import '../../domain/models.dart';
import '../../domain/providers.dart';
import '../../../../presentation/screens/history_screen.dart';
import 'generic_game_screen.dart';

class GenericSetupScreen extends ConsumerWidget {
  const GenericSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final players = ref.watch(genericSetupPlayersProvider);
    final notifier = ref.read(genericSetupPlayersProvider.notifier);
    final savedPlayers = ref.watch(savedPlayersListProvider).asData?.value ?? [];
    final gameName = ref.watch(genericSetupNameProvider);
    final victoryType = ref.watch(genericSetupVictoryTypeProvider);
    final setupRounds = ref.watch(genericSetupRoundsProvider);
    final existingGameNames = ref.watch(genericGameHistoryProvider)
        .asData?.value
        .map((g) => g.name)
        .toSet()
        .toList() ?? [];
    final setupTeams = ref.watch(genericSetupTeamsProvider);
    final setupPlayerTeams = ref.watch(genericSetupPlayerTeamsProvider);
    final teamsConfigured = setupTeams.isNotEmpty &&
        players.every((p) => setupPlayerTeams.containsKey(p.id));
    final canStart = players.length >= 2 &&
        gameName.trim().isNotEmpty &&
        players.every((p) => p.name.trim().isNotEmpty) &&
        (setupTeams.isEmpty || teamsConfigured);

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
              MaterialPageRoute(builder: (_) => const HistoryScreen(initialFilter: GameFilter.generic)),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(
              l.newGame,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Autocomplete<String>(
              optionsBuilder: (value) {
                final query = value.text.toLowerCase();
                if (query.isEmpty) return const [];
                return existingGameNames.where(
                  (name) => name.toLowerCase().startsWith(query),
                );
              },
              onSelected: (name) => ref.read(genericSetupNameProvider.notifier).set(name),
              fieldViewBuilder: (context, controller, focusNode, _) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: l.gameName,
                    hintText: l.gameNameHint,
                    border: const OutlineInputBorder(),
                  ),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (v) => ref.read(genericSetupNameProvider.notifier).set(v),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Text(l.victoryType, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
            child: SegmentedButton<VictoryType>(
              segments: [
                ButtonSegment(value: VictoryType.highestScore, label: Text(l.highestScore)),
                ButtonSegment(value: VictoryType.lowestScore, label: Text(l.lowestScore)),
              ],
              selected: {victoryType},
              onSelectionChanged: (s) => ref.read(genericSetupVictoryTypeProvider.notifier).set(s.first),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: TextField(
              decoration: InputDecoration(
                labelText: l.numberOfRounds,
                hintText: l.numberOfRoundsHint,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (v) {
                final n = int.tryParse(v);
                ref.read(genericSetupRoundsProvider.notifier).set(n != null && n > 0 ? n : null);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: _TeamsButton(
              setupTeams: setupTeams,
              teamsConfigured: teamsConfigured,
              players: players,
              setupPlayerTeams: setupPlayerTeams,
              onResult: (result) {
                ref.read(genericSetupTeamsProvider.notifier).set(result.teams);
                ref.read(genericSetupPlayerTeamsProvider.notifier).set(result.playerTeams);
              },
            ),
          ),
          Expanded(
            child: ReorderableListView.builder(
              itemCount: players.length,
              onReorderItem: notifier.reorder,
              buildDefaultDragHandles: false,
              padding: const EdgeInsets.only(bottom: 160),
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
                    autofocus: i == players.length - 1 && player.name.isEmpty && i > 1,
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'addPlayer',
            onPressed: notifier.add,
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 12),
          StartFab(
            active: canStart,
            label: l.start,
            onPressed: () async {
              await ref
                  .read(currentGenericGameProvider.notifier)
                  .newGame(gameName.trim(), players, victoryType,
                      rounds: setupRounds ?? 1,
                      teams: setupTeams,
                      playerTeams: setupPlayerTeams);
              if (context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GenericGameScreen()),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

// ── Champ nom avec autocomplete (identique au setup Faraway) ──────────────────

class _PlayerNameField extends StatefulWidget {
  final Player player;
  final int index;
  final List<Player> savedPlayers;
  final List<Player> currentPlayers;
  final ValueChanged<String> onChanged;
  final ValueChanged<Player> onSavedPlayerSelected;
  final bool autofocus;

  const _PlayerNameField({
    required this.player,
    required this.index,
    required this.savedPlayers,
    required this.currentPlayers,
    required this.onChanged,
    required this.onSavedPlayerSelected,
    this.autofocus = false,
  });

  @override
  State<_PlayerNameField> createState() => _PlayerNameFieldState();
}

class _PlayerNameFieldState extends State<_PlayerNameField> {
  bool _initialized = false;
  FocusNode? _focusNode;
  TextEditingController? _controller;
  void _onFocusChange(BuildContext fieldContext) {
    final focusNode = _focusNode!;
    final controller = _controller!;
    if (focusNode.hasFocus) {
      controller.selection = TextSelection(
        baseOffset: 0,
        extentOffset: controller.text.length,
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!fieldContext.mounted) return;
        Scrollable.ensureVisible(
          fieldContext,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
        );
      });
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
    _focusNode?.removeListener(() {});
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
          focusNode.addListener(() => _onFocusChange(context));
          if (widget.autofocus) {
            WidgetsBinding.instance.addPostFrameCallback((_) => focusNode.requestFocus());
          }
        }
        return TextField(
          controller: controller,
          focusNode: focusNode,
          autofocus: false,
          decoration: InputDecoration(labelText: AppLocalizations.of(context).playerIndex(widget.index + 1)),
          textCapitalization: TextCapitalization.words,
          onChanged: widget.onChanged,
        );
      },
    );
  }
}

// ── Bouton équipes ────────────────────────────────────────────────────────────

class _TeamsButton extends StatelessWidget {
  final List<Team> setupTeams;
  final bool teamsConfigured;
  final List<Player> players;
  final Map<String, String> setupPlayerTeams;
  final void Function(({List<Team> teams, Map<String, String> playerTeams})) onResult;

  const _TeamsButton({
    required this.setupTeams,
    required this.teamsConfigured,
    required this.players,
    required this.setupPlayerTeams,
    required this.onResult,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final hasTeams = setupTeams.isNotEmpty;

    final chipColor = hasTeams
        ? (teamsConfigured
            ? const Color(0xFF43A047)
            : Theme.of(context).colorScheme.error)
        : Colors.grey.shade500;

    final chipLabel = hasTeams
        ? (teamsConfigured
            ? '${setupTeams.length} ${l.teams.toLowerCase()} ✓'
            : l.teamsIncomplete)
        : l.teamsOff;

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(48),
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      onPressed: () async {
        final result = await showDialog<({List<Team> teams, Map<String, String> playerTeams})?>(
          context: context,
          builder: (ctx) => _TeamsDialog(
            players: players,
            initialTeams: setupTeams,
            initialPlayerTeams: setupPlayerTeams,
          ),
        );
        if (result != null) onResult(result);
      },
      child: Row(
        children: [
          Icon(hasTeams ? Icons.group : Icons.group_outlined,
              size: 20, color: Theme.of(context).colorScheme.onSurface),
          const SizedBox(width: 10),
          Text(l.teams,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: chipColor.withAlpha(30),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: chipColor, width: 1),
            ),
            child: Text(
              chipLabel,
              style: TextStyle(fontSize: 12, color: chipColor, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Couleurs d'équipes ────────────────────────────────────────────────────────

const _kTeamColors = [
  Color(0xFF1E88E5),
  Color(0xFF43A047),
  Color(0xFFE53935),
  Color(0xFFFF8F00),
  Color(0xFF8E24AA),
];

Color _teamColor(int index) => _kTeamColors[index % _kTeamColors.length];

// ── Dialog gestion des équipes ────────────────────────────────────────────────

class _TeamsDialog extends StatefulWidget {
  final List<Player> players;
  final List<Team> initialTeams;
  final Map<String, String> initialPlayerTeams;

  const _TeamsDialog({
    required this.players,
    required this.initialTeams,
    required this.initialPlayerTeams,
  });

  @override
  State<_TeamsDialog> createState() => _TeamsDialogState();
}

class _TeamsDialogState extends State<_TeamsDialog> {
  List<Team> _teams = [];
  Map<String, String> _playerTeams = {};
  Map<String, TextEditingController> _nameControllers = {};
  String? _selectedPlayerId;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _teams = List.from(widget.initialTeams);
    _playerTeams = Map.from(widget.initialPlayerTeams);
    _nameControllers = {for (final t in _teams) t.id: TextEditingController(text: t.name)};
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      if (_teams.isEmpty) _addTeam();
      if (_teams.length == 1) _addTeam();
    }
  }

  @override
  void dispose() {
    for (final c in _nameControllers.values) { c.dispose(); }
    super.dispose();
  }

  void _addTeam() {
    final n = _teams.length + 1;
    final l = AppLocalizations.of(context);
    final team = Team(id: const Uuid().v4(), name: '${l.team} $n');
    setState(() {
      _teams.add(team);
      _nameControllers[team.id] = TextEditingController(text: team.name);
    });
  }

  void _assign(String playerId, String? teamId) {
    setState(() {
      if (teamId == null) {
        _playerTeams.remove(playerId);
      } else {
        _playerTeams[playerId] = teamId;
      }
      _selectedPlayerId = null;
    });
  }

  void _tapPlayer(String playerId) {
    setState(() {
      _selectedPlayerId = _selectedPlayerId == playerId ? null : playerId;
    });
  }

  List<Player> _playersForTeam(String teamId) =>
      widget.players.where((p) => _playerTeams[p.id] == teamId).toList();

  List<Player> get _unassigned =>
      widget.players.where((p) => !_playerTeams.containsKey(p.id)).toList();

  bool get _allAssigned => widget.players.every((p) => _playerTeams.containsKey(p.id));

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final hasSelected = _selectedPlayerId != null;

    return AlertDialog(
      title: Text(l.teams),
      contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Zones d'équipes scrollables horizontalement ────────────
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._teams.asMap().entries.map((e) {
                      final i = e.key;
                      final team = e.value;
                      final color = _teamColor(i);
                      return _TeamZone(
                        team: team,
                        color: color,
                        players: _playersForTeam(team.id),
                        allPlayers: widget.players,
                        canRemove: _teams.length > 2,
                        nameController: _nameControllers[team.id]!,
                        hasSelectedPlayer: hasSelected,
                        selectedPlayerId: _selectedPlayerId,
                        onNameChanged: (v) => setState(() {
                          _teams[i] = team.copyWith(name: v);
                        }),
                        onRemove: () => setState(() {
                          _teams.removeWhere((t) => t.id == team.id);
                          _nameControllers.remove(team.id)?.dispose();
                          _playerTeams.removeWhere((_, v) => v == team.id);
                        }),
                        onDrop: (playerId) => _assign(playerId, team.id),
                        onPlayerTap: (playerId) {
                          if (hasSelected && _selectedPlayerId != playerId) {
                            _assign(_selectedPlayerId!, team.id);
                          } else {
                            _tapPlayer(playerId);
                          }
                        },
                        onZoneTap: () {
                          if (hasSelected) _assign(_selectedPlayerId!, team.id);
                        },
                      );
                    }),
                    Padding(
                      padding: const EdgeInsets.only(left: 4, top: 4),
                      child: TextButton.icon(
                        onPressed: _addTeam,
                        icon: const Icon(Icons.add, size: 16),
                        label: Text(l.addTeam),
                        style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                      ),
                    ),
                  ],
                ),
              ),
              // ── Joueurs non assignés (toujours visible) ────────────────
              const Divider(height: 20),
              Text(l.assignPlayers, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 8),
              DragTarget<String>(
                onAcceptWithDetails: (d) => _assign(d.data, null),
                builder: (_, candidates, __) {
                  final isEmpty = _unassigned.isEmpty;
                  return GestureDetector(
                    onTap: () {
                      if (_selectedPlayerId != null) _assign(_selectedPlayerId!, null);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: candidates.isNotEmpty ? Colors.grey.withAlpha(40) : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: candidates.isNotEmpty
                              ? Colors.grey
                              : isEmpty
                                  ? Colors.grey.withAlpha(60)
                                  : Colors.transparent,
                          width: candidates.isNotEmpty ? 1.5 : 1,
                        ),
                      ),
                      child: isEmpty
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person_remove_outlined, size: 16, color: Colors.grey.shade400),
                                const SizedBox(width: 6),
                                Text(l.removeFromTeam, style: TextStyle(color: Colors.grey.shade400, fontSize: 13)),
                              ],
                            )
                          : Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _unassigned.map((p) {
                                final idx = widget.players.indexOf(p);
                                final name = p.name.isEmpty ? AppLocalizations.of(context).playerIndex(idx + 1) : p.name;
                                return _PlayerChip(
                                  player: p,
                                  displayName: name,
                                  color: Colors.grey.shade600,
                                  isSelected: _selectedPlayerId == p.id,
                                  onTap: () => _tapPlayer(p.id),
                                );
                              }).toList(),
                            ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
      actions: [
        if (widget.initialTeams.isNotEmpty)
          TextButton(
            onPressed: () => Navigator.pop(context, (teams: <Team>[], playerTeams: <String, String>{})),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l.removeTeams),
          ),
        const Spacer(),
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: Text(l.cancel),
        ),
        TextButton(
          onPressed: !_allAssigned ? null : () {
            final usedTeamIds = _playerTeams.values.toSet();
            final activeTeams = _teams.where((t) => usedTeamIds.contains(t.id)).toList();
            Navigator.pop(context, (teams: activeTeams, playerTeams: _playerTeams));
          },
          child: Text(l.confirm),
        ),
      ],
    );
  }
}

// ── Zone d'équipe ─────────────────────────────────────────────────────────────

class _TeamZone extends StatelessWidget {
  final Team team;
  final Color color;
  final List<Player> players;
  final List<Player> allPlayers;
  final bool canRemove;
  final TextEditingController nameController;
  final bool hasSelectedPlayer;
  final String? selectedPlayerId;
  final ValueChanged<String> onNameChanged;
  final VoidCallback onRemove;
  final ValueChanged<String> onDrop;
  final ValueChanged<String> onPlayerTap;
  final VoidCallback onZoneTap;

  const _TeamZone({
    required this.team,
    required this.color,
    required this.players,
    required this.allPlayers,
    required this.canRemove,
    required this.nameController,
    required this.hasSelectedPlayer,
    required this.selectedPlayerId,
    required this.onNameChanged,
    required this.onRemove,
    required this.onDrop,
    required this.onPlayerTap,
    required this.onZoneTap,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      onAcceptWithDetails: (d) => onDrop(d.data),
      builder: (_, candidates, __) {
        final highlighted = candidates.isNotEmpty || hasSelectedPlayer;
        return GestureDetector(
          onTap: onZoneTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 130,
            margin: const EdgeInsets.only(right: 8, bottom: 4),
            decoration: BoxDecoration(
              color: color.withAlpha(highlighted ? 35 : 15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: highlighted ? color : color.withAlpha(80),
                width: highlighted ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // En-tête équipe
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withAlpha(30),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: nameController,
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: color),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onChanged: onNameChanged,
                        ),
                      ),
                      if (canRemove)
                        GestureDetector(
                          onTap: onRemove,
                          child: Icon(Icons.close, size: 14, color: color.withAlpha(180)),
                        ),
                    ],
                  ),
                ),
                // Joueurs dans l'équipe
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: players.isEmpty
                      ? Center(
                          child: Icon(Icons.person_add_outlined, size: 22, color: color.withAlpha(80)),
                        )
                      : Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: players.map((p) {
                            final idx = allPlayers.indexOf(p);
                            final name = p.name.isEmpty ? AppLocalizations.of(context).playerIndex(idx + 1) : p.name;
                            return _PlayerChip(
                              player: p,
                              displayName: name,
                              color: color,
                              isSelected: selectedPlayerId == p.id,
                              onTap: () => onPlayerTap(p.id),
                            );
                          }).toList(),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Chip joueur draggable ─────────────────────────────────────────────────────

class _PlayerChip extends StatelessWidget {
  final Player player;
  final String displayName;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlayerChip({
    required this.player,
    required this.displayName,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Draggable<String>(
      data: player.id,
      feedback: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(20),
        child: _chipContent(filled: true),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: _chipContent()),
      child: GestureDetector(
        onTap: onTap,
        child: _chipContent(filled: isSelected),
      ),
    );
  }

  Widget _chipContent({bool filled = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: filled ? color : color.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        displayName,
        style: TextStyle(
          fontSize: 13,
          color: filled ? Colors.white : color,
          fontWeight: filled ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}

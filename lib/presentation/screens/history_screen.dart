import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/faraway/domain/providers.dart';
import '../../features/faraway/presentation/screens/game_screen.dart';
import '../../features/generic/domain/providers.dart';
import '../../features/generic/presentation/screens/generic_game_screen.dart';
import '../../l10n/app_localizations.dart';

enum GameFilter { all, faraway, generic }

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key, this.initialFilter = GameFilter.all});

  final GameFilter initialFilter;

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  late GameFilter _filter;

  @override
  void initState() {
    super.initState();
    _filter = widget.initialFilter;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final farawayAsync = ref.watch(gameHistoryProvider);
    final genericAsync = ref.watch(genericGameHistoryProvider);

    final isLoading = farawayAsync.isLoading || genericAsync.isLoading;
    final error = farawayAsync.error ?? genericAsync.error;

    final farawayGames = farawayAsync.asData?.value ?? [];
    final genericGames = genericAsync.asData?.value ?? [];

    final entries = [
      if (_filter != GameFilter.generic)
        ...farawayGames.map((g) => _Entry.faraway(g, l)),
      if (_filter != GameFilter.faraway)
        ...genericGames.map((g) => _Entry.generic(g, l)),
    ]..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Scaffold(
      appBar: AppBar(
        title: Text(l.history),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<GameFilter>(
                value: _filter,
                items: [
                  DropdownMenuItem(value: GameFilter.all, child: Text(l.allGames)),
                  DropdownMenuItem(value: GameFilter.faraway, child: Text(l.farawayGame)),
                  DropdownMenuItem(value: GameFilter.generic, child: Text(l.freeGame)),
                ],
                onChanged: (v) { if (v != null) setState(() => _filter = v); },
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text(AppLocalizations.of(context).errorMessage(error.toString())))
              : entries.isEmpty
                  ? Center(child: Text(l.noGamesRecorded))
                  : ListView.builder(
                      itemCount: entries.length,
                      itemBuilder: (context, i) => _EntryTile(entry: entries[i]),
                    ),
    );
  }
}

// ── Modèle unifié ─────────────────────────────────────────────────────────────

class _Entry {
  final String id;
  final String title;
  final String subtitle;
  final bool finished;
  final DateTime createdAt;
  final String gameType;

  const _Entry({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.finished,
    required this.createdAt,
    required this.gameType,
  });

  factory _Entry.faraway(dynamic game, AppLocalizations l) {
    final date = (game.createdAt as DateTime).toLocal();
    final dateStr = _fmt(date);
    final finished = game.finished as bool;
    final playerCount = (game.players as List).length;
    return _Entry(
      id: game.id as String,
      title: 'Faraway',
      subtitle: '$dateStr · ${l.playersCount(playerCount)}${finished ? '' : l.inProgress}',
      finished: finished,
      createdAt: game.createdAt as DateTime,
      gameType: 'faraway',
    );
  }

  factory _Entry.generic(dynamic game, AppLocalizations l) {
    final date = (game.createdAt as DateTime).toLocal();
    final dateStr = _fmt(date);
    final finished = game.finished as bool;
    final playerCount = (game.players as List).length;
    return _Entry(
      id: game.id as String,
      title: '${game.name as String} (${l.freeGame})',
      subtitle: '$dateStr · ${l.playersCount(playerCount)}${finished ? '' : l.inProgress}',
      finished: finished,
      createdAt: game.createdAt as DateTime,
      gameType: 'generic',
    );
  }

  static String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year} '
      '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
}

// ── Tuile ─────────────────────────────────────────────────────────────────────

class _EntryTile extends ConsumerWidget {
  final _Entry entry;
  const _EntryTile({required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return ListTile(
      title: Text(entry.title),
      subtitle: Text(entry.subtitle),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        onPressed: () => _confirmDelete(context, ref, l),
      ),
      onTap: () => _open(context, ref),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, AppLocalizations l) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.deleteGameQuestion),
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
    if (confirmed == true) {
      if (entry.gameType == 'faraway') {
        await ref.read(farawayRepositoryProvider).deleteGame(entry.id);
      } else {
        await ref.read(genericRepositoryProvider).deleteGame(entry.id);
      }
    }
  }

  Future<void> _open(BuildContext context, WidgetRef ref) async {
    if (entry.gameType == 'faraway') {
      await ref.read(currentGameProvider.notifier).loadGame(entry.id);
      if (context.mounted) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const GameScreen()));
      }
    } else {
      await ref.read(currentGenericGameProvider.notifier).loadGame(entry.id);
      if (context.mounted) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const GenericGameScreen()));
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/player.dart';
import '../../features/faraway/domain/providers.dart';
import '../../features/generic/domain/providers.dart' show genericPlayerStatsProvider;

class PlayerStatsScreen extends ConsumerWidget {
  final Player player;

  const PlayerStatsScreen({super.key, required this.player});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final farawayAsync = ref.watch(farawayPlayerStatsProvider(player.id));
    final genericAsync = ref.watch(genericPlayerStatsProvider(player.id));

    return Scaffold(
      appBar: AppBar(title: Text(player.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionTitle('Jeu générique'),
          genericAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Erreur : $e'),
            data: (stats) => stats.gamesPlayed == 0
                ? const _EmptyStats()
                : Column(
                    children: [
                      _StatTile('Parties jouées', '${stats.gamesPlayed}'),
                      _StatTile('Victoires', '${stats.wins}'),
                    ],
                  ),
          ),
          const SizedBox(height: 24),
          _SectionTitle('Faraway'),
          farawayAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Erreur : $e'),
            data: (stats) => stats.gamesPlayed == 0
                ? const _EmptyStats()
                : Column(
                    children: [
                      _StatTile('Parties jouées', '${stats.gamesPlayed}'),
                      _StatTile('Victoires', '${stats.wins}'),
                      _StatTile('Score moyen', stats.averageScore.toStringAsFixed(1)),
                      _StatTile('Meilleur score', '${stats.bestScore}'),
                      _StatTile('Pire score', '${stats.worstScore}'),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      );
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  const _StatTile(this.label, this.value);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 16)),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      );
}

class _EmptyStats extends StatelessWidget {
  const _EmptyStats();

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Text('Aucune partie terminée', style: TextStyle(color: Colors.grey)),
      );
}

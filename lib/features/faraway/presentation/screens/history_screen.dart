import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/providers.dart';
import 'game_screen.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(gameHistoryProvider);
    final repo = ref.read(farawayRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Exporter en JSON',
            onPressed: () async {
              final path = await repo.exportHistory();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(path != null
                        ? 'Fichier enregistré dans Téléchargements'
                        : 'Aucune partie à exporter'),
                    backgroundColor: path != null ? Colors.green : Colors.orange,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Erreur : $e')),
        data: (games) {
          if (games.isEmpty) {
            return const Center(child: Text('Aucune partie enregistrée'));
          }
          return ListView.builder(
            itemCount: games.length,
            itemBuilder: (context, i) {
              final game = games[i];
              final date = game.createdAt.toLocal();
              final label =
                  'Partie du ${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} '
                  '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

              return ListTile(
                title: Text(label),
                subtitle: Text('${game.players.length} joueurs${game.finished ? '' : ' — en cours'}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Supprimer la partie ?'),
                        content: const Text('Cette action est irréversible.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('Annuler'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            style: TextButton.styleFrom(foregroundColor: Colors.red),
                            child: const Text('Supprimer'),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true) {
                      await ref.read(farawayRepositoryProvider).deleteGame(game.id);
                    }
                  },
                ),
                onTap: () async {
                  await ref.read(currentGameProvider.notifier).loadGame(game.id);
                  if (context.mounted) {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const GameScreen()));
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

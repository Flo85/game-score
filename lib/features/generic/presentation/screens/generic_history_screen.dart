import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/providers.dart';
import 'generic_game_screen.dart';

class GenericHistoryScreen extends ConsumerWidget {
  const GenericHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(genericGameHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Historique')),
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
                  '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} '
                  '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

              return ListTile(
                title: Text(game.name),
                subtitle: Text('$label · ${game.players.length} joueurs${game.finished ? '' : ' — en cours'}'),
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
                      await ref.read(genericRepositoryProvider).deleteGame(game.id);
                    }
                  },
                ),
                onTap: () async {
                  await ref.read(currentGenericGameProvider.notifier).loadGame(game.id);
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const GenericGameScreen()),
                    );
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

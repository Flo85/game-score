import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/providers.dart';
import 'generic_game_screen.dart';

class GenericHistoryScreen extends ConsumerWidget {
  const GenericHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final historyAsync = ref.watch(genericGameHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l.history)),
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l.errorMessage(e.toString()))),
        data: (games) {
          if (games.isEmpty) {
            return Center(child: Text(l.noGamesRecorded));
          }
          return ListView.builder(
            itemCount: games.length,
            itemBuilder: (context, i) {
              final game = games[i];
              final date = game.createdAt.toLocal();
              final dateStr =
                  '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} '
                  '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
              final ll = AppLocalizations.of(context);

              return ListTile(
                title: Text(game.name),
                subtitle: Text('$dateStr · ${ll.playersCount(game.players.length)}${game.finished ? '' : ll.inProgress}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) {
                        final lll = AppLocalizations.of(ctx);
                        return AlertDialog(
                          title: Text(lll.deleteGameQuestion),
                          content: Text(lll.irreversible),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: Text(lll.cancel),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              style: TextButton.styleFrom(foregroundColor: Colors.red),
                              child: Text(lll.delete),
                            ),
                          ],
                        );
                      },
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

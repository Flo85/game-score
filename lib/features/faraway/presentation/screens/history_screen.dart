import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/providers.dart';
import 'game_screen.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final historyAsync = ref.watch(gameHistoryProvider);
    final repo = ref.read(farawayRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.history),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            tooltip: l.importJson,
            onPressed: () async {
              final result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['json'],
              );
              if (result == null || result.files.single.path == null) return;
              if (!context.mounted) return;
              try {
                final count = await repo.importHistory(result.files.single.path!);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(count > 0
                          ? AppLocalizations.of(context).importedGames(count)
                          : AppLocalizations.of(context).noNewGame),
                      backgroundColor: count > 0 ? Colors.green : Colors.orange,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.of(context).importError(e.toString())),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: l.exportJson,
            onPressed: () async {
              final path = await repo.exportHistory();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(path != null
                        ? AppLocalizations.of(context).fileSaved
                        : AppLocalizations.of(context).noGameToExport),
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
                title: Text(ll.gameFromDate(dateStr)),
                subtitle: Text(
                  '${ll.playersCount(game.players.length)}${game.finished ? '' : ll.inProgress}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(ll.deleteGameQuestion),
                        content: Text(ll.irreversible),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: Text(ll.cancel),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            style: TextButton.styleFrom(foregroundColor: Colors.red),
                            child: Text(ll.delete),
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

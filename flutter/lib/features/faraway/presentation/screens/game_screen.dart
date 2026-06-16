import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/providers.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(currentGameProvider);
    if (game == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final notifier = ref.read(currentGameProvider.notifier);
    final players = game.players;
    final writable = game.writable;

    return Scaffold(
      appBar: AppBar(title: const Text('Feuille de score')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(Theme.of(context).colorScheme.primaryContainer),
                  columns: [
                    const DataColumn(label: Text('#')),
                    ...players.map(
                      (p) => DataColumn(
                        label: SizedBox(
                          width: 80,
                          child: TextFormField(
                            initialValue: p.name,
                            enabled: writable,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(border: InputBorder.none),
                            onChanged: (v) => notifier.updatePlayerName(p.id, v),
                          ),
                        ),
                      ),
                    ),
                  ],
                  rows: [
                    // Lignes de score 1 à numberOfRows
                    ...List.generate(game.numberOfRows, (rowIndex) {
                      final isLastRow = rowIndex == game.numberOfRows - 1;
                      return DataRow(
                        color: isLastRow
                            ? WidgetStateProperty.all(Theme.of(context).colorScheme.secondaryContainer)
                            : null,
                        cells: [
                          DataCell(
                            isLastRow
                                ? const Icon(Icons.church, size: 20)
                                : Text(
                                    '${rowIndex + 1}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                          ),
                          ...players.map((p) {
                            final score = game.scores[p.id]?[rowIndex];
                            return DataCell(
                              SizedBox(
                                width: 64,
                                child: TextFormField(
                                  initialValue: score?.toString() ?? '',
                                  enabled: writable,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(border: InputBorder.none),
                                  onChanged: (v) {
                                    final parsed = int.tryParse(v);
                                    notifier.setScore(p.id, rowIndex, parsed);
                                  },
                                ),
                              ),
                            );
                          }),
                        ],
                      );
                    }),
                    // Ligne total
                    DataRow(
                      color: WidgetStateProperty.all(Theme.of(context).colorScheme.tertiaryContainer),
                      cells: [
                        const DataCell(Text('T', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                        ...players.map(
                          (p) => DataCell(
                            Text(
                              game.playerTotal(p.id)?.toString() ?? '',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton(
              onPressed: writable ? () async {
                await notifier.endGame();
                if (context.mounted) Navigator.pop(context);
              } : null,
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
              child: const Text('Partie terminée'),
            ),
          ),
        ],
      ),
    );
  }
}

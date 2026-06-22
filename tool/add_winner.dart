import 'dart:convert';
import 'dart:io';

void main() async {
  final input = File(r'C:\Users\flo_n\Downloads\faraway-history-converted-fixed.json');
  final output = File(r'C:\Users\flo_n\Downloads\faraway-history-converted-fixed.json');

  final raw = jsonDecode(await input.readAsString()) as List;

  final updated = raw.map((game) {
    final g = game as Map<String, dynamic>;
    final players = (g['players'] as List).cast<Map<String, dynamic>>();
    final scores = (g['scores'] as Map<String, dynamic>);

    String? winnerId;
    int best = -1;
    for (final player in players) {
      final id = player['id'] as String;
      final total = ((scores[id] as List?) ?? [])
          .whereType<int>()
          .fold(0, (a, b) => a + b);
      if (total > best) {
        best = total;
        winnerId = id;
      }
    }

    return {...g, 'winner_id': winnerId};
  }).toList();

  const encoder = JsonEncoder.withIndent('  ');
  await output.writeAsString(encoder.convert(updated));
  print('Fichier mis à jour : ${output.path}');
}

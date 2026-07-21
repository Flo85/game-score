import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/faraway/domain/providers.dart';
import '../../features/generic/domain/providers.dart';
import '../../l10n/app_localizations.dart';

class ImportExportScreen extends ConsumerWidget {
  const ImportExportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.importExport)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _ActionTile(
            icon: Icons.download,
            label: l.exportJson,
            description: l.exportAllDescription,
            onTap: () => _exportAll(context, ref),
          ),
          const Divider(height: 32),
          _ActionTile(
            icon: Icons.upload_file,
            label: l.importJson,
            description: l.importAllDescription,
            onTap: () => _importAll(context, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _exportAll(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    try {
      final farawayGames = await ref.read(farawayRepositoryProvider).watchHistory().first;
      final genericGames = await ref.read(genericRepositoryProvider).watchHistory().first;
      if (farawayGames.isEmpty && genericGames.isEmpty) {
        if (context.mounted) _snack(context, l.noGameToExport, false);
        return;
      }
      final all = [
        ...farawayGames.map((g) => g.toJson()),
        ...genericGames.map((g) => g.toJson()),
      ];
      final json = jsonEncode(all);
      final timestamp = DateTime.now().toIso8601String().substring(0, 19).replaceAll(':', '-');
      final bytes = utf8.encode(json);
      final path = await FilePicker.platform.saveFile(
        fileName: 'gamescore-$timestamp.json',
        bytes: bytes,
      );
      if (context.mounted) {
        _snack(context, path != null ? l.fileSaved : l.noGameToExport, path != null);
      }
    } catch (e) {
      if (context.mounted) _snack(context, l.importError(e.toString()), false, error: true);
    }
  }

  Future<void> _importAll(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result == null || result.files.single.path == null) return;
    if (!context.mounted) return;
    try {
      final raw = jsonDecode(await File(result.files.single.path!).readAsString()) as List;
      final farawayJson = raw.where((g) => (g as Map)['gameType'] == 'faraway').cast<Map<String, dynamic>>().toList();
      final genericJson = raw.where((g) => (g as Map)['gameType'] == 'generic').cast<Map<String, dynamic>>().toList();

      int count = 0;
      if (farawayJson.isNotEmpty) {
        count += await ref.read(farawayRepositoryProvider).importHistoryFromJson(farawayJson);
      }
      if (genericJson.isNotEmpty) {
        count += await ref.read(genericRepositoryProvider).importHistoryFromJson(genericJson);
      }
      if (context.mounted) {
        _snack(context, count > 0 ? l.importedGames(count) : l.noNewGame, count > 0);
      }
    } catch (e) {
      if (context.mounted) _snack(context, l.importError(e.toString()), false, error: true);
    }
  }

  void _snack(BuildContext context, String message, bool success, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: error ? Colors.red : success ? Colors.green : Colors.orange,
    ));
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Icon(icon, size: 32),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(description),
        contentPadding: EdgeInsets.zero,
        onTap: onTap,
      );
}

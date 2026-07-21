import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/locale_provider.dart';
import '../../features/faraway/presentation/screens/history_screen.dart';
import '../../features/faraway/presentation/screens/saved_players_screen.dart';
import '../../features/faraway/presentation/screens/setup_screen.dart';
import '../../features/generic/presentation/screens/generic_history_screen.dart';
import '../../features/generic/presentation/screens/generic_setup_screen.dart';
import '../../l10n/app_localizations.dart';
import 'import_export_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l.appTitle)),
      drawer: const _AppDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                l.chooseGame,
                style: const TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              _GenericGameCard(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GenericSetupScreen()),
                ),
              ),
              const SizedBox(height: 16),
              _GameCard(
                image: 'assets/images/logo-faraway.png',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SetupScreen()),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Drawer ────────────────────────────────────────────────────────────────────

class _AppDrawer extends ConsumerWidget {
  const _AppDrawer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final localeAsync = ref.watch(localeProvider);
    final currentLocale = localeAsync.when(
      data: (v) => v?.languageCode ?? 'en',
      error: (_, __) => 'en',
      loading: () => 'en',
    );

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
            child: Text(
              l.appTitle,
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700),
            ),
          ),

          // ── Joueurs ──────────────────────────────────────────────────────
          ListTile(
            leading: const Icon(Icons.people_outline),
            title: Text(l.playerBook),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SavedPlayersScreen()));
            },
          ),

          const Divider(),

          // ── Historiques ──────────────────────────────────────────────────
          ListTile(
            leading: const Icon(Icons.history),
            title: Text(l.farawayHistory),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: Text(l.genericHistory),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const GenericHistoryScreen()));
            },
          ),

          const Divider(),

          // ── Import / Export ──────────────────────────────────────────────
          ListTile(
            leading: const Icon(Icons.import_export),
            title: Text(l.importExport),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ImportExportScreen()));
            },
          ),

          const Divider(),

          // ── Langue ───────────────────────────────────────────────────────
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l.language),
            trailing: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: currentLocale,
                items: const [
                  DropdownMenuItem(value: 'fr', child: Text('Français')),
                  DropdownMenuItem(value: 'en', child: Text('English')),
                ],
                onChanged: (code) {
                  if (code != null) ref.read(localeProvider.notifier).setLocale(Locale(code));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Cartes jeux ───────────────────────────────────────────────────────────────

class _GameCard extends StatelessWidget {
  final String image;
  final VoidCallback onTap;

  const _GameCard({required this.image, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        child: Image.asset(image, fit: BoxFit.cover),
      ),
    );
  }
}

class _GenericGameCard extends StatelessWidget {
  final VoidCallback onTap;

  const _GenericGameCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Row(
            children: [
              Icon(Icons.casino_outlined,
                  size: 40, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.freeGame,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(l.freeGameSubtitle,
                        style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

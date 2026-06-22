import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/locale_provider.dart';
import '../../features/faraway/presentation/screens/setup_screen.dart';
import '../../features/generic/presentation/screens/generic_setup_screen.dart';
import '../../l10n/app_localizations.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          _LanguageDropdown(),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                l.appTitle,
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
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

class _LanguageDropdown extends ConsumerWidget {
  const _LanguageDropdown();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeAsync = ref.watch(localeProvider);
    final current = localeAsync.when(
      data: (v) => v?.languageCode ?? 'en',
      error: (_, __) => 'en',
      loading: () => 'en',
    );

    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: current,
        items: const [
          DropdownMenuItem(value: 'fr', child: Text('Français')),
          DropdownMenuItem(value: 'en', child: Text('English')),
        ],
        onChanged: (code) {
          if (code != null) {
            ref.read(localeProvider.notifier).setLocale(Locale(code));
          }
        },
      ),
    );
  }
}

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

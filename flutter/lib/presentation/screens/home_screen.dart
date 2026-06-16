import 'package:flutter/material.dart';
import '../../features/faraway/presentation/screens/setup_screen.dart';
import '../../features/generic/presentation/screens/generic_setup_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Text(
                'Game Score',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Choisissez un jeu',
                style: TextStyle(color: Colors.grey),
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
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Jeu libre',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    SizedBox(height: 2),
                    Text('Score par manche, n\'importe quel jeu',
                        style: TextStyle(color: Colors.grey, fontSize: 13)),
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

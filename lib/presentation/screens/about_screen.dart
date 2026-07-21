import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/app_localizations.dart';

const _kofiUrl = 'https://ko-fi.com/floriannerriere';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  PackageInfo? _info;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((info) {
      if (mounted) setState(() => _info = info);
    });
  }

  Future<void> _openKofi() async {
    await launchUrl(Uri.parse(_kofiUrl), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final version = _info == null
        ? '…'
        : '${_info!.version} (${_info!.buildNumber})';

    return Scaffold(
      appBar: AppBar(title: Text(l.about)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const SizedBox(height: 16),
          Center(
            child: Image.asset('assets/images/app-icon.png', width: 80, height: 80),
          ),
          const SizedBox(height: 16),
          Text(
            l.appTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            '${l.version} $version',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 16),
          Text(
            l.developedBy,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 32),
          OutlinedButton.icon(
            onPressed: _openKofi,
            icon: const Text('☕', style: TextStyle(fontSize: 18)),
            label: Text(l.supportOnKofi),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF29ABE0),
              side: const BorderSide(color: Color(0xFF29ABE0)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}

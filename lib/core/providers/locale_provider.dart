import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'locale_provider.g.dart';

const _kLocaleKey = 'selected_locale';

@Riverpod(keepAlive: true)
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Future<Locale?> build() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_kLocaleKey);
    if (code != null) return Locale(code);
    // Pas de préférence sauvegardée : utiliser la langue du système si supportée, sinon français
    final systemCode = WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    return Locale(systemCode == 'fr' ? 'fr' : 'en');
  }

  Future<void> setLocale(Locale? locale) async {
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove(_kLocaleKey);
    } else {
      await prefs.setString(_kLocaleKey, locale.languageCode);
    }
    state = AsyncValue.data(locale);
  }
}

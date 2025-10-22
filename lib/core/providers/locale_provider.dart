import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider für die aktuelle Sprache
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('de')); // Default Deutsch

  void setLocale(Locale locale) {
    state = locale;
  }
}

// Provider für verfügbare Sprachen
final supportedLocalesProvider = Provider<List<Locale>>((ref) {
  return const [
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('pt'),
  ];
});

// Helper für Sprachinformationen
class LanguageInfo {
  final String flag;
  final String name;
  final Locale locale;

  const LanguageInfo({
    required this.flag,
    required this.name,
    required this.locale,
  });
}

final languageInfoProvider = Provider<List<LanguageInfo>>((ref) {
  return const [
    LanguageInfo(flag: '🇩🇪', name: 'Deutsch', locale: Locale('de')),
    LanguageInfo(flag: '🇺🇸', name: 'English', locale: Locale('en')),
    LanguageInfo(flag: '🇪🇸', name: 'Español', locale: Locale('es')),
    LanguageInfo(flag: '🇫🇷', name: 'Français', locale: Locale('fr')),
    LanguageInfo(flag: '🇵🇹', name: 'Português', locale: Locale('pt')),
  ];
});

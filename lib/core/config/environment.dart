import 'package:flutter/foundation.dart';

class Environment {
  static const String dev = 'dev';
  static const String prod = 'prod';

  static String get current =>
      const String.fromEnvironment('ENV', defaultValue: dev);

  static String get apiBaseUrl {
    switch (current) {
      case prod:
        return 'https://europe-west1-brivida-7d98d.cloudfunctions.net';
      case dev:
      default:
        return 'https://europe-west1-brivida-7d98d.cloudfunctions.net';
    }
  }

  static String get stripePublishableKey {
    return const String.fromEnvironment(
      'STRIPE_PUBLISHABLE_KEY',
      defaultValue: '',
    );
  }

  static bool get isProduction => current == prod;
  static bool get isDevelopment => current == dev;

  static bool get useFirebaseEmulators =>
      const bool.fromEnvironment('USE_FIREBASE_EMULATORS', defaultValue: false);

  /// True when the app is compiled in Flutter's debug mode.
  static bool get isDebugBuild => kDebugMode;

  /// Mock data and relaxed debug tooling are only allowed when running a
  /// development environment build in debug mode.
  static bool get allowMockData =>
      isDevelopment && isDebugBuild && useFirebaseEmulators;
}

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter/foundation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'core/services/firebase_provider.dart';
import 'core/services/app_initialization_service.dart';
import 'core/services/crashlytics_service.dart';
import 'core/utils/debug_logger.dart';
import 'app/app.dart';

// Conditional import for web plugins
import 'web_plugin_registrant.dart';

Future<void> main() async {
  try {
    DebugLogger.debug('🚀 BRIVIDA: Starting app initialization...');

    DebugLogger.debug('📱 BRIVIDA: Ensuring widgets binding...');
    WidgetsFlutterBinding.ensureInitialized();
    DebugLogger.debug('✅ BRIVIDA: Widgets binding initialized successfully');

    // Register web plugins for Flutter Web
    if (kIsWeb) {
      DebugLogger.debug('🌐 BRIVIDA: Running on web - registering plugins...');
      try {
        registerPlugins();
        DebugLogger.debug('✅ BRIVIDA: Web plugins registered successfully');
      } catch (e, stackTrace) {
        DebugLogger.error(
            '❌ BRIVIDA: Failed to register web plugins', e, stackTrace);
      }
    } else {
      DebugLogger.debug('📱 BRIVIDA: Running on mobile platform');
    }

    // Initialize EasyLocalization
    DebugLogger.debug('🌍 BRIVIDA: Initializing EasyLocalization...');
    try {
      await EasyLocalization.ensureInitialized();
      DebugLogger.debug('✅ BRIVIDA: EasyLocalization initialized successfully');
    } catch (e, stackTrace) {
      DebugLogger.error(
          '❌ BRIVIDA: Failed to initialize EasyLocalization', e, stackTrace);
      rethrow;
    }

    // Load environment variables
    DebugLogger.debug('⚙️ BRIVIDA: Loading environment variables...');
    try {
      await dotenv.load(fileName: '.env');
      DebugLogger.debug('✅ BRIVIDA: Environment variables loaded successfully');
      DebugLogger.debug(
          '🔑 BRIVIDA: Available env keys: ${dotenv.env.keys.toList()}');
    } catch (e, stackTrace) {
      DebugLogger.error('❌ BRIVIDA: Failed to load .env file', e, stackTrace);
      rethrow;
    }

    // Set Stripe publishable key - only for mobile platforms
    if (!kIsWeb) {
      DebugLogger.debug('💳 BRIVIDA: Setting up Stripe for mobile...');
      try {
        final stripeKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'];
        DebugLogger.debug(
            '🔑 BRIVIDA: Stripe key from env: ${stripeKey?.substring(0, 10)}...');
        if (stripeKey != null && stripeKey.isNotEmpty) {
          Stripe.publishableKey = stripeKey;
          DebugLogger.debug(
              '✅ BRIVIDA: Stripe publishable key set successfully');
        } else {
          DebugLogger.warning(
              '⚠️ BRIVIDA: STRIPE_PUBLISHABLE_KEY not found in .env file');
        }
      } catch (e, stackTrace) {
        DebugLogger.error('❌ BRIVIDA: Failed to set Stripe key', e, stackTrace);
      }
    } else {
      DebugLogger.debug('💳 BRIVIDA: Skipping Stripe setup for web platform');
    }

    // Initialize Firebase
    DebugLogger.debug('🔥 BRIVIDA: Initializing Firebase...');
    try {
      final options = FirebaseBootstrap.options;
      DebugLogger.debug('🔧 BRIVIDA: Firebase options: ${options.toString()}');
      await Firebase.initializeApp(options: options);
      DebugLogger.debug('✅ BRIVIDA: Firebase initialized successfully');
    } catch (e, stackTrace) {
      DebugLogger.error(
          '❌ BRIVIDA: Failed to initialize Firebase', e, stackTrace);
      rethrow;
    }

    // Initialize Crashlytics
    DebugLogger.debug('📊 BRIVIDA: Initializing Crashlytics...');
    try {
      await CrashlyticsService.initialize();
      DebugLogger.debug('✅ BRIVIDA: Crashlytics initialized successfully');
    } catch (e, stackTrace) {
      DebugLogger.error(
          '❌ BRIVIDA: Failed to initialize Crashlytics', e, stackTrace);
      // Don't rethrow - crashlytics failure shouldn't prevent app startup
    }

    // Initialize app services and mock data
    DebugLogger.debug('🎭 BRIVIDA: Initializing app services...');
    try {
      await AppInitializationService.initialize();
      DebugLogger.debug('✅ BRIVIDA: App services initialized successfully');
    } catch (e, stackTrace) {
      DebugLogger.error(
          '❌ BRIVIDA: Failed to initialize app services', e, stackTrace);
      // Don't rethrow - app should still work without mock data
    }

    DebugLogger.debug('🎨 BRIVIDA: Creating app widget...');
    try {
      final app = EasyLocalization(
        supportedLocales: const [
          Locale('de'),
          Locale('en'),
          Locale('es'),
          Locale('fr'),
          Locale('pt'),
        ],
        path: 'assets/i18n',
        fallbackLocale: const Locale('en'),
        child: const ProviderScope(child: BrividaApp()),
      );
      DebugLogger.debug('✅ BRIVIDA: App widget created successfully');

      DebugLogger.debug('🏃 BRIVIDA: Running app...');
      runApp(app);
      DebugLogger.debug('✅ BRIVIDA: App started successfully');
    } catch (e, stackTrace) {
      DebugLogger.error(
          '❌ BRIVIDA: Failed to create/run app widget', e, stackTrace);
      rethrow;
    }
  } catch (e, stackTrace) {
    DebugLogger.fatal('💥 BRIVIDA: CRITICAL ERROR in main()', e, stackTrace);
    rethrow;
  }
}

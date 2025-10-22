import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../firebase_options_dev.dart' as dev;
import '../../firebase_options_prod.dart' as prod;
import '../utils/debug_logger.dart';

class FirebaseBootstrap {
  static FirebaseOptions get options {
    try {
      DebugLogger.debug('🔥 FIREBASE: Getting Firebase options...');

      final env = dotenv.maybeGet('ENV') ?? 'dev';
      DebugLogger.debug('🔧 FIREBASE: Environment detected: $env');

      FirebaseOptions selectedOptions;
      if (env == 'prod') {
        DebugLogger.debug('🏭 FIREBASE: Using production Firebase options');
        selectedOptions = prod.DefaultFirebaseOptions.currentPlatform;
      } else {
        DebugLogger.debug('🧪 FIREBASE: Using development Firebase options');
        selectedOptions = dev.DefaultFirebaseOptions.currentPlatform;
      }

      DebugLogger.debug(
          '🔧 FIREBASE: Selected options project ID: ${selectedOptions.projectId}');
      DebugLogger.debug(
          '🔧 FIREBASE: Selected options API key: ${selectedOptions.apiKey.substring(0, 10)}...');
      DebugLogger.debug(
          '🔧 FIREBASE: Selected options app ID: ${selectedOptions.appId}');

      return selectedOptions;
    } catch (e, stackTrace) {
      DebugLogger.error(
          '❌ FIREBASE: Error getting Firebase options', e, stackTrace);

      // Fallback to dev options
      DebugLogger.warning('🔄 FIREBASE: Falling back to dev options...');
      return dev.DefaultFirebaseOptions.currentPlatform;
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import '../config/environment.dart';
import '../utils/debug_logger.dart';
import '../services/mock_data_service.dart';

class AppInitializationService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static bool _emulatorsConfigured = false;

  /// Initializes the app with necessary services and mock data
  static Future<void> initialize() async {
    DebugLogger.debug('🚀 APP: Starting app initialization...');

    try {
      if (Environment.useFirebaseEmulators) {
        await _configureFirebaseEmulators();
      }

      // Wait for Firebase Auth to be ready
      await _waitForAuthInitialization();

      // Initialize mock data in debug/dev builds
      if (Environment.allowMockData) {
        DebugLogger.debug(
          '🎭 APP: Development mode detected, initializing mock data...',
        );
        await _ensureDebugAuthUser();
        await MockDataService.initializeMockData(
          enableLiveLocationSimulation: true,
        );
        await MockDataService.createMockProProfiles();
      } else if (Environment.useFirebaseEmulators) {
        DebugLogger.debug(
          '🧪 APP: Firebase emulators enabled without mock data seeding',
        );
      } else {
        DebugLogger.debug('🏭 APP: Production mode, skipping mock data');
      }

      DebugLogger.debug('✅ APP: App initialization completed successfully');
    } catch (e, stackTrace) {
      DebugLogger.error('❌ APP: Failed to initialize app', e, stackTrace);
      // Don't rethrow - app should still work without mock data
    }
  }

  /// Waits for Firebase Auth to complete its initialization
  static Future<void> _waitForAuthInitialization() async {
    DebugLogger.debug('⏳ APP: Waiting for Firebase Auth initialization...');

    // Firebase Auth is typically ready immediately, but we'll add a small delay
    // to ensure all Firebase services are properly initialized
    await Future.delayed(const Duration(milliseconds: 500));

    DebugLogger.debug('✅ APP: Firebase Auth ready', {
      'currentUser': _auth.currentUser?.uid,
      'isSignedIn': _auth.currentUser != null,
    });
  }

  /// Clears all mock data (useful for testing)
  static Future<void> clearMockData() async {
    if (!Environment.allowMockData) {
      DebugLogger.warning(
        '⚠️ APP: Mock data tools disabled (set USE_FIREBASE_EMULATORS=true to enable)',
      );
      return;
    }

    DebugLogger.debug('🗑️ APP: Clearing mock data...');
    try {
      await MockDataService.clearMockData();
      DebugLogger.debug('✅ APP: Mock data cleared successfully');
    } catch (e, stackTrace) {
      DebugLogger.error('❌ APP: Failed to clear mock data', e, stackTrace);
    }
  }

  /// Initializes mock data after successful authentication (development only)
  static Future<void> initializeMockDataAfterAuth() async {
    if (!Environment.allowMockData) return;

    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      DebugLogger.debug(
        '🔐 APP: No authenticated user for post-auth mock data initialization',
      );
      return;
    }

    DebugLogger.debug(
      '🎭 APP: Initializing mock data after authentication...',
      {'uid': currentUser.uid, 'email': currentUser.email},
    );

    try {
      await MockDataService.initializeMockData(
        enableLiveLocationSimulation: true,
      );
      await MockDataService.createMockProProfiles();
      DebugLogger.debug('✅ APP: Post-auth mock data initialization completed');
    } catch (e, stackTrace) {
      DebugLogger.error(
        '❌ APP: Failed to initialize mock data after auth',
        e,
        stackTrace,
      );
    }
  }

  /// Reinitializes mock data (useful for development)
  static Future<void> reinitializeMockData() async {
    if (!Environment.allowMockData) {
      DebugLogger.warning(
        '⚠️ APP: Mock data tools disabled (set USE_FIREBASE_EMULATORS=true to enable)',
      );
      return;
    }

    DebugLogger.debug('🔄 APP: Reinitializing mock data...');
    try {
      await clearMockData();
      await Future.delayed(const Duration(milliseconds: 1000)); // Wait a bit
      await MockDataService.initializeMockData(
        enableLiveLocationSimulation: true,
      );
      await MockDataService.createMockProProfiles();
      DebugLogger.debug('✅ APP: Mock data reinitialized successfully');
    } catch (e, stackTrace) {
      DebugLogger.error(
        '❌ APP: Failed to reinitialize mock data',
        e,
        stackTrace,
      );
    }
  }

  static Future<void> _configureFirebaseEmulators() async {
    if (_emulatorsConfigured) {
      DebugLogger.debug('🧪 APP: Firebase emulators already configured');
      return;
    }

    final host = _resolveEmulatorHost();

    DebugLogger.debug('🧪 APP: Configuring Firebase emulators...', {
      'host': host,
    });

    try {
      await FirebaseAuth.instance.useAuthEmulator(host, 9099);
      FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
      FirebaseFunctions.instance.useFunctionsEmulator(host, 5001);
      FirebaseFunctions.instanceFor(
        region: 'europe-west1',
      ).useFunctionsEmulator(host, 5001);
      FirebaseStorage.instance.useStorageEmulator(host, 9199);

      _emulatorsConfigured = true;

      DebugLogger.debug('✅ APP: Firebase emulators configured', {
        'host': host,
        'authPort': 9099,
        'firestorePort': 8080,
        'functionsPort': 5001,
        'storagePort': 9199,
      });
    } catch (e, stackTrace) {
      DebugLogger.error(
        '❌ APP: Failed to configure Firebase emulators',
        e,
        stackTrace,
      );
    }
  }

  static String _resolveEmulatorHost() {
    if (kIsWeb) {
      return 'localhost';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return '10.0.2.2';
      default:
        return 'localhost';
    }
  }

  /// Ensures that a Firebase user is available when running in debug mode so
  /// that Firestore writes for mock data pass security rules.
  static Future<void> _ensureDebugAuthUser() async {
    if (_auth.currentUser != null) {
      DebugLogger.debug('🔐 APP: Debug user already signed in');
      return;
    }

    try {
      DebugLogger.debug('🔐 APP: Signing in anonymously for debug mock data');
      await _auth.signInAnonymously();
      DebugLogger.debug('✅ APP: Anonymous debug sign-in successful', {
        'uid': _auth.currentUser?.uid,
      });
    } catch (e, stackTrace) {
      DebugLogger.error(
        '❌ APP: Failed to perform anonymous debug sign-in',
        e,
        stackTrace,
      );
    }
  }
}

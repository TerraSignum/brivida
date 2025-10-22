import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/debug_logger.dart';

/// Crashlytics error reporting service
class CrashlyticsService {
  static FirebaseCrashlytics? _crashlytics;

  /// Initialize Crashlytics with user context
  static Future<void> initialize() async {
    if (kDebugMode) {
      // Disable Crashlytics in debug mode for development
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
      return;
    }

    _crashlytics = FirebaseCrashlytics.instance;

    // Enable collection for release builds
    await _crashlytics!.setCrashlyticsCollectionEnabled(true);

    // Set up Flutter error handling
    FlutterError.onError = _crashlytics!.recordFlutterFatalError;

    // Set up Dart error handling
    PlatformDispatcher.instance.onError = (error, stack) {
      _crashlytics!.recordError(error, stack, fatal: true);
      return true;
    };
  }

  /// Set user identifier for crash reports
  static Future<void> setUserIdentifier(String userId) async {
    if (_crashlytics == null || kDebugMode) return;

    try {
      await _crashlytics!.setUserIdentifier(userId);
    } catch (e) {
      // Don't fail the app if crashlytics fails
      DebugLogger.log('Failed to set Crashlytics user ID: $e');
    }
  }

  /// Set custom key-value pairs for crash context
  static Future<void> setCustomKey(String key, String value) async {
    if (_crashlytics == null || kDebugMode) return;

    try {
      await _crashlytics!.setCustomKey(key, value);
    } catch (e) {
      DebugLogger.log('Failed to set Crashlytics custom key: $e');
    }
  }

  /// Record non-fatal error
  static Future<void> recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    bool fatal = false,
    String? reason,
    Map<String, dynamic>? context,
  }) async {
    if (_crashlytics == null || kDebugMode) {
      // In debug mode, just print the error
      DebugLogger.log('Crashlytics Error: $exception');
      if (stackTrace != null) {
        DebugLogger.log('Stack trace: $stackTrace');
      }
      return;
    }

    try {
      // Add context information
      if (context != null) {
        for (final entry in context.entries) {
          await _crashlytics!.setCustomKey(entry.key, entry.value.toString());
        }
      }

      await _crashlytics!.recordError(
        exception,
        stackTrace,
        fatal: fatal,
        reason: reason,
      );
    } catch (e) {
      DebugLogger.log('Failed to record error to Crashlytics: $e');
    }
  }

  /// Record Flutter error specifically
  static Future<void> recordFlutterError(
      FlutterErrorDetails errorDetails) async {
    if (_crashlytics == null || kDebugMode) return;

    try {
      await _crashlytics!.recordFlutterError(errorDetails);
    } catch (e) {
      DebugLogger.log('Failed to record Flutter error: $e');
    }
  }

  /// Log message to Crashlytics
  static Future<void> log(String message) async {
    if (_crashlytics == null || kDebugMode) {
      DebugLogger.log('Crashlytics Log: $message');
      return;
    }

    try {
      await _crashlytics!.log(message);
    } catch (e) {
      DebugLogger.log('Failed to log to Crashlytics: $e');
    }
  }

  /// Check if crash reporting is enabled
  static Future<bool> isCrashlyticsCollectionEnabled() async {
    if (_crashlytics == null) return false;

    try {
      return _crashlytics!.isCrashlyticsCollectionEnabled;
    } catch (e) {
      return false;
    }
  }

  /// Force send unsent crash reports
  static Future<void> sendUnsentReports() async {
    if (_crashlytics == null || kDebugMode) return;

    try {
      await _crashlytics!.sendUnsentReports();
    } catch (e) {
      DebugLogger.log('Failed to send unsent reports: $e');
    }
  }

  /// Check if unsent reports are available
  static Future<bool> checkForUnsentReports() async {
    if (_crashlytics == null || kDebugMode) return false;

    try {
      return await _crashlytics!.checkForUnsentReports();
    } catch (e) {
      return false;
    }
  }

  /// Delete unsent reports
  static Future<void> deleteUnsentReports() async {
    if (_crashlytics == null || kDebugMode) return;

    try {
      await _crashlytics!.deleteUnsentReports();
    } catch (e) {
      DebugLogger.log('Failed to delete unsent reports: $e');
    }
  }
}

/// Provider for Crashlytics service
final crashlyticsServiceProvider = Provider<CrashlyticsService>((ref) {
  return CrashlyticsService();
});

/// Error handler mixin for controllers
mixin CrashlyticsErrorHandler {
  /// Handle error with automatic Crashlytics reporting
  Future<void> handleError(
    dynamic error,
    StackTrace? stackTrace, {
    String? operation,
    Map<String, dynamic>? context,
    bool fatal = false,
  }) async {
    // Enhanced context
    final enhancedContext = <String, dynamic>{
      'operation': operation ?? 'unknown',
      'timestamp': DateTime.now().toIso8601String(),
      'error_type': error.runtimeType.toString(),
      ...?context,
    };

    // Record to Crashlytics
    await CrashlyticsService.recordError(
      error,
      stackTrace,
      fatal: fatal,
      reason: operation,
      context: enhancedContext,
    );

    // Log operation context
    await CrashlyticsService.log('Error in $operation: ${error.toString()}');
  }
}

/// Extension for User to add Crashlytics context
extension UserCrashlytics on User {
  /// Set user context in Crashlytics
  Future<void> setCrashlyticsContext() async {
    await CrashlyticsService.setUserIdentifier(uid);
    await CrashlyticsService.setCustomKey('user_email', email ?? 'unknown');
    await CrashlyticsService.setCustomKey(
        'user_verified', emailVerified.toString());

    // Add custom claims if available
    final idTokenResult = await getIdTokenResult();
    final claims = idTokenResult.claims;
    if (claims != null) {
      await CrashlyticsService.setCustomKey(
          'user_role', claims['role'] ?? 'unknown');
      await CrashlyticsService.setCustomKey(
          'user_verified_pro', (claims['verified'] ?? false).toString());
    }
  }
}

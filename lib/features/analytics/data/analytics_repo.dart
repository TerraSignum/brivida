import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'dart:io' show Platform;
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/analytics.dart';
import '../../../core/utils/debug_logger.dart';

/// Repository for analytics event tracking and management
class AnalyticsRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAnalytics _analytics;
  final FirebaseAuth _auth;

  String? _sessionId;
  String? _appVersion;
  bool? _analyticsOptOut;

  AnalyticsRepository({
    FirebaseFirestore? firestore,
    FirebaseAnalytics? analytics,
    FirebaseAuth? auth,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _analytics = analytics ?? FirebaseAnalytics.instance,
       _auth = auth ?? FirebaseAuth.instance;

  /// Initialize analytics session and get app version
  Future<void> initSession() async {
    _sessionId ??= const Uuid().v4();

    if (_appVersion == null) {
      final packageInfo = await PackageInfo.fromPlatform();
      _appVersion = packageInfo.version;
    }

    // Check user's analytics opt-out preference
    await _updateOptOutStatus();
  }

  /// Update the analytics opt-out status from Firestore
  Future<void> _updateOptOutStatus() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();
        if (userDoc.exists) {
          _analyticsOptOut =
              userDoc.data()?['analyticsOptOut'] as bool? ?? false;
        }
      } catch (e) {
        DebugLogger.warning('⚠️ ANALYTICS: Error checking opt-out status: $e');
        _analyticsOptOut = false;
      }
    } else {
      _analyticsOptOut = false; // Allow anonymous tracking
    }
  }

  /// Track an analytics event (client-side)
  Future<void> track(String name, {Map<String, Object?>? props}) async {
    // Ensure session is initialized
    if (_sessionId == null || _appVersion == null) {
      await initSession();
    }

    // Check if user has opted out
    if (_analyticsOptOut == true) {
      DebugLogger.info('🚫 ANALYTICS: Event $name skipped - user opted out');
      return;
    }

    // Validate event name
    if (!AnalyticsEventNames.clientEvents.contains(name)) {
      DebugLogger.warning('⚠️ ANALYTICS: Invalid event name: $name');
      return;
    }

    // Sanitize props
    final sanitizedProps = _sanitizeProps(props ?? {});

    try {
      // Get current user info
      final user = _auth.currentUser;
      String? userRole;

      if (user != null) {
        final idTokenResult = await user.getIdTokenResult();
        userRole = idTokenResult.claims?['role'] as String?;
      }

      // Create analytics event
      final event = AnalyticsEvent(
        id: '', // Will be set by Firestore
        uid: user?.uid,
        role: userRole,
        ts: DateTime.now(),
        src: 'client',
        name: name,
        props: sanitizedProps,
        context: _buildClientContext(),
        sessionId: _sessionId!,
      );

      // Write to Firestore
      await _firestore.collection('analyticsEvents').add(event.toFirestore());

      // Also send to Firebase Analytics
      await _analytics.logEvent(
        name: name,
        parameters: _sanitizePropsForFirebaseAnalytics(sanitizedProps),
      );

      DebugLogger.debug(
        '📊 ANALYTICS: Tracked $name with ${sanitizedProps.length} props',
      );
    } catch (e) {
      DebugLogger.error('❌ ANALYTICS: Error tracking event $name: $e');
    }
  }

  /// Build client context information
  Map<String, Object?> _buildClientContext() {
    String platform;
    if (Platform.isAndroid) {
      platform = 'android';
    } else if (Platform.isIOS) {
      platform = 'ios';
    } else {
      platform = 'web';
    }

    return {
      'platform': platform,
      'appVersion': _appVersion ?? 'unknown',
      // Note: IP and UA hashing only done server-side
    };
  }

  /// Sanitize properties for client events
  Map<String, Object?> _sanitizeProps(Map<String, Object?> props) {
    final sanitized = <String, Object?>{};

    for (final entry in props.entries) {
      final key = entry.key;
      final value = entry.value;

      // Check if key is whitelisted
      if (!AnalyticsEventProps.allowedKeys.contains(key)) {
        DebugLogger.warning(
          '⚠️ ANALYTICS: Skipping non-whitelisted prop: $key',
        );
        continue;
      }

      // Validate value constraints
      if (value is String) {
        if (value.length > 120) {
          DebugLogger.warning(
            '⚠️ ANALYTICS: String too long for prop $key, truncating',
          );
          sanitized[key] = value.substring(0, 120);
        } else if (_containsPII(value)) {
          DebugLogger.warning(
            '⚠️ ANALYTICS: Skipping prop $key - contains PII',
          );
          continue;
        } else {
          sanitized[key] = value;
        }
      } else if (value is num || value is bool) {
        sanitized[key] = value;
      } else if (value == null) {
        sanitized[key] = null;
      } else {
        DebugLogger.warning('⚠️ ANALYTICS: Skipping prop $key - invalid type');
      }
    }

    // Limit to 20 properties max
    if (sanitized.length > 20) {
      DebugLogger.warning('⚠️ ANALYTICS: Too many props, limiting to 20');
      final limited = <String, Object?>{};
      var count = 0;
      for (final entry in sanitized.entries) {
        if (count >= 20) break;
        limited[entry.key] = entry.value;
        count++;
      }
      return limited;
    }

    return sanitized;
  }

  /// Sanitize props specifically for Firebase Analytics (different constraints)
  Map<String, Object> _sanitizePropsForFirebaseAnalytics(
    Map<String, Object?> props,
  ) {
    final sanitized = <String, Object>{};

    for (final entry in props.entries) {
      final value = entry.value;
      if (value != null) {
        if (value is String || value is num || value is bool) {
          sanitized[entry.key] = value;
        }
      }
    }

    return sanitized;
  }

  /// Check if a string contains potential PII
  bool _containsPII(String value) {
    final lowerValue = value.toLowerCase();

    // Check for email pattern
    if (RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)) {
      return true;
    }

    // Check for phone number pattern
    if (RegExp(r'^\+?[\d\s\-\(\)]{10,}$').hasMatch(value.replaceAll(' ', ''))) {
      return true;
    }

    // Check for common PII keywords
    const piiKeywords = ['email', 'phone', 'address', 'name', 'street', 'city'];
    for (final keyword in piiKeywords) {
      if (lowerValue.contains(keyword)) {
        return true;
      }
    }

    return false;
  }

  /// Hash a job ID for analytics (client-side pseudonymization)
  String hashJobId(String jobId) {
    final bytes = utf8.encode('${jobId}brivida_salt_client');
    final digest = sha256.convert(bytes);
    return digest.toString().substring(0, 16); // First 16 chars for brevity
  }

  /// Set user's analytics opt-out preference
  Future<void> setAnalyticsOptOut(bool optOut) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore.collection('users').doc(user.uid).update({
        'analyticsOptOut': optOut,
      });

      _analyticsOptOut = optOut;

      // Also update Firebase Analytics
      await _analytics.setAnalyticsCollectionEnabled(!optOut);

      DebugLogger.debug('📊 ANALYTICS: Opt-out set to $optOut');
    } catch (e) {
      DebugLogger.error('❌ ANALYTICS: Error setting opt-out: $e');
      rethrow;
    }
  }

  /// Get user's current analytics opt-out preference
  Future<bool> getAnalyticsOptOut() async {
    if (_analyticsOptOut != null) {
      return _analyticsOptOut!;
    }

    await _updateOptOutStatus();
    return _analyticsOptOut ?? false;
  }

  /// Get analytics events for admin (with pagination)
  Stream<List<AnalyticsEvent>> getEvents({
    DateTime? startDate,
    DateTime? endDate,
    int limit = 100,
    DocumentSnapshot? startAfter,
  }) {
    Query query = _firestore
        .collection('analyticsEvents')
        .orderBy('ts', descending: true);

    if (startDate != null) {
      query = query.where(
        'ts',
        isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
      );
    }

    if (endDate != null) {
      query = query.where(
        'ts',
        isLessThanOrEqualTo: Timestamp.fromDate(endDate),
      );
    }

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    query = query.limit(limit);

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => AnalyticsEvent.fromFirestore(doc))
          .toList();
    });
  }

  /// Get daily analytics KPIs
  Stream<List<AnalyticsDaily>> getDailyKpis({
    DateTime? startDate,
    DateTime? endDate,
    int limit = 30,
  }) {
    Query query = _firestore
        .collection('analyticsDaily')
        .orderBy(FieldPath.documentId, descending: true);

    if (startDate != null) {
      final startDateStr = _formatDateId(startDate);
      query = query.where(
        FieldPath.documentId,
        isGreaterThanOrEqualTo: startDateStr,
      );
    }

    if (endDate != null) {
      final endDateStr = _formatDateId(endDate);
      query = query.where(
        FieldPath.documentId,
        isLessThanOrEqualTo: endDateStr,
      );
    }

    query = query.limit(limit);

    return query.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => AnalyticsDaily.fromFirestore(doc))
          .toList();
    });
  }

  /// Format date for Firestore document ID (yyyyMMdd)
  String _formatDateId(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}'
        '${date.month.toString().padLeft(2, '0')}'
        '${date.day.toString().padLeft(2, '0')}';
  }

  /// Convenience methods for common events

  Future<void> trackAuth(String eventType) async {
    await track(eventType);
  }

  Future<void> trackJobCreated({
    required double sizeM2,
    required int servicesCount,
  }) async {
    await track(
      AnalyticsEventNames.jobCreated,
      props: {
        AnalyticsEventProps.sizeM2: sizeM2,
        AnalyticsEventProps.servicesCount: servicesCount,
      },
    );
  }

  Future<void> trackLeadCreated(String jobId) async {
    await track(
      AnalyticsEventNames.leadCreated,
      props: {AnalyticsEventProps.jobIdHash: hashJobId(jobId)},
    );
  }

  Future<void> trackLeadAccepted(String jobId) async {
    await track(
      AnalyticsEventNames.leadAccepted,
      props: {AnalyticsEventProps.jobIdHash: hashJobId(jobId)},
    );
  }

  Future<void> trackChatMessage(int messageLength) async {
    await track(
      AnalyticsEventNames.chatMsgSent,
      props: {AnalyticsEventProps.messageLength: messageLength},
    );
  }

  Future<void> trackCalendarEvent(String eventType) async {
    await track(
      AnalyticsEventNames.calendarEventSaved,
      props: {AnalyticsEventProps.eventType: eventType},
    );
  }

  Future<void> trackPaymentCheckout(double amountEur) async {
    await track(
      AnalyticsEventNames.paymentCheckoutOpened,
      props: {AnalyticsEventProps.amountEur: amountEur},
    );
  }

  Future<void> trackAdminServicePurchaseSuccess() async {
    await track(AnalyticsEventNames.adminServicePurchaseSuccess);
  }

  Future<void> trackReview(double rating) async {
    await track(
      AnalyticsEventNames.reviewSubmitted,
      props: {AnalyticsEventProps.rating: rating},
    );
  }

  Future<void> trackPushNotification(
    String eventType, {
    String? notificationType,
  }) async {
    await track(
      eventType,
      props: {
        if (notificationType != null)
          AnalyticsEventProps.pushType: notificationType,
      },
    );
  }
}

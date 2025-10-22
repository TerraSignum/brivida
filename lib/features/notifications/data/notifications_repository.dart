import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:brivida_app/core/models/notification.dart';
import 'package:brivida_app/core/exceptions/app_exceptions.dart';
import '../../../core/utils/debug_logger.dart';

/// Repository for managing notifications and FCM
class NotificationsRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseMessaging _messaging;

  NotificationsRepository({
    FirebaseFirestore? firestore,
    FirebaseAuth? auth,
    FirebaseMessaging? messaging,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _messaging = messaging ?? FirebaseMessaging.instance;

  /// Collection references
  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');

  CollectionReference<Map<String, dynamic>> get _notificationsCollection =>
      _firestore.collection('notifications');

  /// Get current user
  User? get _currentUser => _auth.currentUser;

  /// Ensure FCM token is saved for current user
  Future<String?> ensureFcmTokenSaved() async {
    if (_currentUser == null) return null;

    try {
      // Request permission for notifications
      final settings = await _messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus != AuthorizationStatus.authorized) {
        throw const AppException.forbidden(
          message: 'Notification permission denied',
        );
      }

      // Get FCM token
      final token = await _messaging.getToken();
      if (token == null) return null;

      // Save token to user document
      await _usersCollection.doc(_currentUser!.uid).update({
        'fcmToken': token,
        'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
      });

      return token;
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException.unknown(message: e.toString());
    }
  }

  /// Watch notifications inbox for current user
  Stream<List<AppNotification>> watchInbox({int? limit}) {
    if (_currentUser == null) {
      return Stream.value([]);
    }

    Query<Map<String, dynamic>> query = _notificationsCollection
        .where('uid', isEqualTo: _currentUser!.uid)
        .orderBy('createdAt', descending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return AppNotification.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  /// Get paginated notifications
  Future<List<AppNotification>> getNotifications({
    int? limit,
    DocumentSnapshot? startAfter,
    bool? unreadOnly,
  }) async {
    if (_currentUser == null) {
      throw const AppException.notAuthenticated();
    }

    try {
      Query<Map<String, dynamic>> query = _notificationsCollection
          .where('uid', isEqualTo: _currentUser!.uid)
          .orderBy('createdAt', descending: true);

      if (unreadOnly == true) {
        query = query.where('read', isEqualTo: false);
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final snapshot = await query.get();

      return snapshot.docs.map((doc) {
        return AppNotification.fromFirestore(doc.data(), doc.id);
      }).toList();
    } on FirebaseException catch (e) {
      throw AppException.fromFirestore(e);
    } catch (e) {
      throw AppException.unknown(message: e.toString());
    }
  }

  /// Mark notification as read
  Future<void> markRead(String notificationId) async {
    if (_currentUser == null) {
      throw const AppException.notAuthenticated();
    }

    try {
      await _notificationsCollection.doc(notificationId).update({
        'read': true,
      });
    } on FirebaseException catch (e) {
      throw AppException.fromFirestore(e);
    } catch (e) {
      throw AppException.unknown(message: e.toString());
    }
  }

  /// Mark all notifications as read for current user
  Future<void> markAllRead() async {
    if (_currentUser == null) {
      throw const AppException.notAuthenticated();
    }

    try {
      // Get all unread notifications
      final unreadNotifications = await _notificationsCollection
          .where('uid', isEqualTo: _currentUser!.uid)
          .where('read', isEqualTo: false)
          .get();

      // Update all in batch
      final batch = _firestore.batch();
      for (final doc in unreadNotifications.docs) {
        batch.update(doc.reference, {'read': true});
      }

      await batch.commit();
    } on FirebaseException catch (e) {
      throw AppException.fromFirestore(e);
    } catch (e) {
      throw AppException.unknown(message: e.toString());
    }
  }

  /// Get unread notification count
  Future<int> getUnreadCount() async {
    if (_currentUser == null) return 0;

    try {
      final snapshot = await _notificationsCollection
          .where('uid', isEqualTo: _currentUser!.uid)
          .where('read', isEqualTo: false)
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e) {
      return 0; // Return 0 on error
    }
  }

  /// Stream unread notification count
  Stream<int> watchUnreadCount() {
    if (_currentUser == null) {
      return Stream.value(0);
    }

    return _notificationsCollection
        .where('uid', isEqualTo: _currentUser!.uid)
        .where('read', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  /// Load notification preferences for current user
  Future<NotificationPreferences> loadPreferences() async {
    if (_currentUser == null) {
      return const NotificationPreferences();
    }

    try {
      final doc = await _usersCollection.doc(_currentUser!.uid).get();
      if (!doc.exists) {
        return const NotificationPreferences();
      }

      final data = doc.data()!;
      final prefsData = data['notificationPrefs'] as Map<String, dynamic>?;

      if (prefsData == null) {
        return const NotificationPreferences();
      }

      return NotificationPreferences.fromJson(prefsData);
    } on FirebaseException catch (e) {
      throw AppException.fromFirestore(e);
    } catch (e) {
      throw AppException.unknown(message: e.toString());
    }
  }

  /// Save notification preferences for current user
  Future<void> savePreferences(NotificationPreferences preferences) async {
    if (_currentUser == null) {
      throw const AppException.notAuthenticated();
    }

    try {
      await _usersCollection.doc(_currentUser!.uid).update({
        'notificationPrefs': preferences.toJson(),
      });
    } on FirebaseException catch (e) {
      throw AppException.fromFirestore(e);
    } catch (e) {
      throw AppException.unknown(message: e.toString());
    }
  }

  /// Check if it's currently quiet hours for a user
  Future<bool> isQuietHours([String? userId]) async {
    final uid = userId ?? _currentUser?.uid;
    if (uid == null) return false;

    try {
      final prefs = await loadPreferences();
      return prefs.quietHours.isQuietNow;
    } catch (e) {
      return false; // Return false on error
    }
  }

  /// Delete notification
  Future<void> deleteNotification(String notificationId) async {
    if (_currentUser == null) {
      throw const AppException.notAuthenticated();
    }

    try {
      // Verify notification belongs to current user
      final doc = await _notificationsCollection.doc(notificationId).get();
      if (!doc.exists) {
        throw const AppException.notFound(resource: 'Notification');
      }

      final data = doc.data()!;
      if (data['uid'] != _currentUser!.uid) {
        throw const AppException.forbidden();
      }

      await _notificationsCollection.doc(notificationId).delete();
    } on FirebaseException catch (e) {
      throw AppException.fromFirestore(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException.unknown(message: e.toString());
    }
  }

  /// Delete all notifications for current user
  Future<void> deleteAllNotifications() async {
    if (_currentUser == null) {
      throw const AppException.notAuthenticated();
    }

    try {
      // Get all notifications for user
      final notifications = await _notificationsCollection
          .where('uid', isEqualTo: _currentUser!.uid)
          .get();

      // Delete all in batch
      final batch = _firestore.batch();
      for (final doc in notifications.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } on FirebaseException catch (e) {
      throw AppException.fromFirestore(e);
    } catch (e) {
      throw AppException.unknown(message: e.toString());
    }
  }

  /// Create a notification for testing purposes
  Future<void> createTestNotification() async {
    if (_currentUser == null) {
      throw const AppException.notAuthenticated();
    }

    try {
      final notification = AppNotification(
        firestoreId: '',
        uid: _currentUser!.uid,
        type: NotificationType.chatMessage,
        title: 'Test Notification',
        body: 'This is a test notification to verify the system works.',
        data: {
          'route': '/notifications',
          'testId': DateTime.now().millisecondsSinceEpoch.toString(),
        },
        createdAt: DateTime.now(),
      );

      await _notificationsCollection.add(notification.toFirestore());
    } on FirebaseException catch (e) {
      throw AppException.fromFirestore(e);
    } catch (e) {
      throw AppException.unknown(message: e.toString());
    }
  }

  /// Setup FCM background message handler
  static void setupBackgroundMessageHandler() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  /// Initialize FCM for the app
  Future<void> initializeFCM() async {
    try {
      // Request permission
      await _messaging.requestPermission();

      // Configure foreground message handling
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Configure message opened app handling
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

      // Handle initial message if app was opened from notification
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleMessageOpenedApp(initialMessage);
      }

      // Ensure token is saved
      await ensureFcmTokenSaved();
    } catch (e) {
      throw AppException.unknown(message: e.toString());
    }
  }

  /// Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    // This will be handled by the UI to show in-app banners
    // The message is already in the inbox via Cloud Functions
  }

  /// Handle message that opened the app
  void _handleMessageOpenedApp(RemoteMessage message) {
    final data = message.data;
    final route = data['route'];

    if (route != null) {
      // This will be handled by the navigation service
      // For now, we just log it
      DebugLogger.log('Should navigate to: $route');
    }
  }
}

/// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background messages
  // The inbox entry is already created by Cloud Functions
  DebugLogger.log('Handling background message: ${message.messageId}');
}

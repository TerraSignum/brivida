import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brivida_app/core/models/notification.dart';
import 'package:brivida_app/core/utils/debug_logger.dart';
import 'package:brivida_app/features/notifications/data/notifications_repository.dart';
import 'package:brivida_app/app/router.dart';

/// Service for handling FCM messages
class NotificationService {
  static final _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  /// Initialize FCM message handling
  static Future<void> initialize() async {
    DebugLogger.debug('🔔 Notifications: Initializing FCM...');
    // Request permission for notifications
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle message that opened app
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // Handle initial message if app was opened from notification
    final initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageOpenedApp(initialMessage);
    }

    // Set background message handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Ensure token is saved for current user (if logged in)
    try {
      final repo = NotificationsRepository();
      await repo.ensureFcmTokenSaved();
    } catch (e) {
      DebugLogger.warning('🔔 Notifications: Could not save FCM token: $e');
    }

    // Persist on token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      DebugLogger.debug('🔔 Notifications: FCM token refreshed');
      try {
        final repo = NotificationsRepository();
        await repo.ensureFcmTokenSaved();
      } catch (e) {
        DebugLogger.warning(
          '🔔 Notifications: Failed to persist refreshed token: $e',
        );
      }
    });
  }

  /// Handle foreground messages (show in-app notification)
  static void _handleForegroundMessage(RemoteMessage message) {
    DebugLogger.debug(
      '📱 Foreground message received: ${message.notification?.title}',
    );

    // Show in-app banner or handle differently
    final notification = message.notification;
    if (notification != null) {
      // This would show an in-app banner (for now we log)
      DebugLogger.debug('Title: ${notification.title}');
      DebugLogger.debug('Body: ${notification.body}');
    }
  }

  /// Handle message that opened the app
  static void _handleMessageOpenedApp(RemoteMessage message) {
    DebugLogger.debug('🚀 App opened from notification: ${message.messageId}');

    final data = message.data;
    final route = data['route'];
    final relatedId = data['related_id'];

    DebugLogger.debug('Notifications route: $route');
    DebugLogger.debug('Notifications relatedId: $relatedId');

    if (route != null) {
      navigateToRoute(route, relatedId: relatedId);
    }
  }

  /// Navigate to specific route based on notification
  static void navigateToRoute(String route, {String? relatedId}) {
    DebugLogger.debug('🧭 Navigating to: $route (ID: $relatedId)');

    try {
      final path = resolveRoutePath(route, relatedId: relatedId);
      appRouter.go(path);
    } catch (e, st) {
      DebugLogger.error('❌ Navigation from notification failed', e, st);
    }
  }

  @visibleForTesting
  static String resolveRoutePath(String route, {String? relatedId}) {
    if (route.startsWith('/')) {
      return route;
    }

    switch (route) {
      case 'notifications':
        return '/notifications';
      case 'home':
        return '/home';
      case 'settings':
        return '/settings';
      case 'jobs_detail':
      case 'job_detail':
        return relatedId != null ? '/jobs/$relatedId' : '/jobs';
      case 'job_feed':
        return '/job-feed';
      case 'leads':
        return '/leads';
      case 'chat':
        return relatedId != null ? '/chat/$relatedId' : '/chats';
      case 'payouts':
        return '/payouts';
      case 'payout_detail':
        return relatedId != null ? '/payouts/$relatedId' : '/payouts';
      case 'finance':
      case 'payments':
        return '/finance';
      case 'dispute_detail':
      case 'disputes_detail':
        return relatedId != null ? '/disputes/$relatedId' : '/home';
      case 'calendar':
        return '/calendar';
      case 'pro_offers':
      case 'offers':
        return '/pro/offers';
      case 'admin_dashboard':
        return '/admin';
      case 'admin_services':
        return '/admin/services';
      case 'admin_pro':
      case 'admin_pro_detail':
        return relatedId != null ? '/admin/pro/$relatedId' : '/admin';
      case 'admin_analytics':
        return '/admin/analytics';
      case 'admin_system':
        return '/admin/system';
      default:
        return '/home';
    }
  }

  /// Show in-app notification banner
  static void showInAppNotification(
    BuildContext context, {
    required String title,
    required String body,
    NotificationType? type,
    VoidCallback? onTap,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(body),
          ],
        ),
        backgroundColor: _getNotificationColor(type),
        behavior: SnackBarBehavior.floating,
        action: onTap != null
            ? SnackBarAction(
                label: 'Anzeigen',
                textColor: Colors.white,
                onPressed: onTap,
              )
            : null,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Get color for notification type
  static Color _getNotificationColor(NotificationType? type) {
    if (type == null) return Colors.blue;

    switch (type) {
      case NotificationType.leadNew:
      case NotificationType.jobAssigned:
        return Colors.green;
      case NotificationType.leadDeclined:
      case NotificationType.jobCancelled:
        return Colors.red;
      case NotificationType.paymentCaptured:
      case NotificationType.paymentReleased:
        return Colors.teal;
      case NotificationType.paymentRefunded:
      case NotificationType.disputeOpened:
        return Colors.orange;
      case NotificationType.reminder24h:
      case NotificationType.reminder1h:
        return Colors.purple;
      case NotificationType.chatMessage:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}

/// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  DebugLogger.debug('🌙 Background message received: ${message.messageId}');

  // The notification is already created in Firestore by Cloud Functions
  // We don't need to do anything here for the inbox

  // Could trigger local analytics or other background tasks
}

/// Provider for notification service
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

/// Controls whether the notification initialization should run.
final notificationInitializationEnabledProvider = Provider<bool>((ref) {
  return true;
});

/// Widget to initialize notifications
class NotificationInitializer extends ConsumerStatefulWidget {
  final Widget child;

  const NotificationInitializer({super.key, required this.child});

  @override
  ConsumerState<NotificationInitializer> createState() =>
      _NotificationInitializerState();
}

class _NotificationInitializerState
    extends ConsumerState<NotificationInitializer> {
  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    try {
      final isEnabled = ref.read(notificationInitializationEnabledProvider);
      if (!isEnabled) {
        DebugLogger.log('⚠️ Notifications initialization skipped (disabled).');
        return;
      }
      await NotificationService.initialize();
      DebugLogger.log('✅ Notifications initialized successfully');
    } catch (e) {
      DebugLogger.log('❌ Failed to initialize notifications: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

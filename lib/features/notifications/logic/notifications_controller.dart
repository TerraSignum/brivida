import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brivida_app/core/models/notification.dart';
import 'package:brivida_app/features/notifications/data/notifications_repository.dart';

/// Provider for notifications repository
final notificationsRepositoryProvider =
    Provider<NotificationsRepository>((ref) {
  return NotificationsRepository();
});

/// Provider for notification preferences controller
final preferencesControllerProvider = StateNotifierProvider<
    PreferencesController, AsyncValue<NotificationPreferences>>((ref) {
  final repository = ref.watch(notificationsRepositoryProvider);
  return PreferencesController(repository);
});

/// Provider for notification preferences
final preferencesProvider =
    FutureProvider<NotificationPreferences>((ref) async {
  final repository = ref.watch(notificationsRepositoryProvider);
  return repository.loadPreferences();
});

/// Controller for notification preferences
class PreferencesController
    extends StateNotifier<AsyncValue<NotificationPreferences>> {
  final NotificationsRepository _repository;

  PreferencesController(this._repository) : super(const AsyncValue.loading()) {
    _loadPreferences();
  }

  /// Load preferences
  Future<void> _loadPreferences() async {
    try {
      final preferences = await _repository.loadPreferences();
      state = AsyncValue.data(preferences);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  /// Toggle notification type
  Future<void> toggleNotificationType(NotificationType type) async {
    if (!state.hasValue) return;

    try {
      final currentPreferences = state.value!;
      NotificationPreferences updatedPreferences;

      switch (type) {
        case NotificationType.leadNew:
          updatedPreferences =
              currentPreferences.copyWith(leadNew: !currentPreferences.leadNew);
          break;
        case NotificationType.leadAccepted:
        case NotificationType.leadDeclined:
          updatedPreferences = currentPreferences.copyWith(
              leadStatus: !currentPreferences.leadStatus);
          break;
        case NotificationType.jobAssigned:
        case NotificationType.jobChanged:
        case NotificationType.jobCancelled:
          updatedPreferences = currentPreferences.copyWith(
              jobAssigned: !currentPreferences.jobAssigned);
          break;
        case NotificationType.reminder24h:
          updatedPreferences = currentPreferences.copyWith(
              jobReminder24h: !currentPreferences.jobReminder24h);
          break;
        case NotificationType.reminder1h:
          updatedPreferences = currentPreferences.copyWith(
              jobReminder1h: !currentPreferences.jobReminder1h);
          break;
        case NotificationType.paymentCaptured:
        case NotificationType.paymentReleased:
        case NotificationType.paymentRefunded:
          updatedPreferences =
              currentPreferences.copyWith(payment: !currentPreferences.payment);
          break;
        case NotificationType.disputeOpened:
        case NotificationType.disputeResponse:
        case NotificationType.disputeDecision:
          updatedPreferences =
              currentPreferences.copyWith(dispute: !currentPreferences.dispute);
          break;
        case NotificationType.chatMessage:
          // Chat is always enabled
          return;
      }

      await _repository.savePreferences(updatedPreferences);
      state = AsyncValue.data(updatedPreferences);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  /// Update quiet hours
  Future<void> updateQuietHours(String? startTime, String? endTime) async {
    if (!state.hasValue) return;

    try {
      final currentPreferences = state.value!;
      final currentQuietHours = currentPreferences.quietHours;

      final updatedQuietHours = currentQuietHours.copyWith(
        start: startTime ?? currentQuietHours.start,
        end: endTime ?? currentQuietHours.end,
      );

      final updatedPreferences = currentPreferences.copyWith(
        quietHours: updatedQuietHours,
      );

      await _repository.savePreferences(updatedPreferences);
      state = AsyncValue.data(updatedPreferences);
    } catch (error, stack) {
      state = AsyncValue.error(error, stack);
    }
  }

  /// Refresh preferences
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await _loadPreferences();
  }
}

/// Provider for notifications controller
final notificationsControllerProvider = StateNotifierProvider<
    NotificationsController, AsyncValue<List<AppNotification>>>((ref) {
  final repository = ref.watch(notificationsRepositoryProvider);
  return NotificationsController(repository);
});

/// Provider for unread notifications count
final unreadNotificationsCountProvider = StreamProvider<int>((ref) {
  final repository = ref.watch(notificationsRepositoryProvider);
  return repository.watchUnreadCount();
});

/// Provider for notification preferences
final notificationPreferencesProvider = StateNotifierProvider<
    NotificationPreferencesController,
    AsyncValue<NotificationPreferences>>((ref) {
  final repository = ref.watch(notificationsRepositoryProvider);
  return NotificationPreferencesController(repository);
});

/// Provider for notifications inbox stream
final notificationsInboxProvider = StreamProvider<List<AppNotification>>((ref) {
  final repository = ref.watch(notificationsRepositoryProvider);
  return repository.watchInbox(limit: 50);
});

/// Controller for notifications state and operations
class NotificationsController
    extends StateNotifier<AsyncValue<List<AppNotification>>> {
  final NotificationsRepository _repository;

  NotificationsController(this._repository)
      : super(const AsyncValue.loading()) {
    _loadInitialNotifications();
  }

  /// Load initial notifications
  Future<void> _loadInitialNotifications() async {
    try {
      final notifications = await _repository.getNotifications(limit: 50);
      state = AsyncValue.data(notifications);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// Mark notification as read
  Future<void> markRead(String notificationId) async {
    try {
      await _repository.markRead(notificationId);

      // Update local state
      if (state.hasValue) {
        final updatedNotifications = state.value!.map((notification) {
          if (notification.firestoreId == notificationId) {
            return notification.copyWith(read: true);
          }
          return notification;
        }).toList();

        state = AsyncValue.data(updatedNotifications);
      }
    } catch (e) {
      // Handle error but don't update state
      rethrow;
    }
  }

  /// Mark all notifications as read
  Future<void> markAllRead() async {
    try {
      await _repository.markAllRead();

      // Update local state
      if (state.hasValue) {
        final updatedNotifications = state.value!.map((notification) {
          return notification.copyWith(read: true);
        }).toList();

        state = AsyncValue.data(updatedNotifications);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Delete notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _repository.deleteNotification(notificationId);

      // Update local state
      if (state.hasValue) {
        final updatedNotifications = state.value!
            .where((notification) => notification.firestoreId != notificationId)
            .toList();

        state = AsyncValue.data(updatedNotifications);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Delete all notifications
  Future<void> deleteAllNotifications() async {
    try {
      await _repository.deleteAllNotifications();
      state = const AsyncValue.data([]);
    } catch (e) {
      rethrow;
    }
  }

  /// Refresh notifications
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await _loadInitialNotifications();
  }

  /// Load more notifications (pagination)
  Future<void> loadMore() async {
    if (!state.hasValue || state.value!.isEmpty) return;

    try {
      // For now, just refresh - pagination would need DocumentSnapshot
      await refresh();
    } catch (e) {
      // Don't update state on error
    }
  }

  /// Create test notification
  Future<void> createTestNotification() async {
    try {
      await _repository.createTestNotification();
      await refresh(); // Refresh to show the new notification
    } catch (e) {
      rethrow;
    }
  }

  /// Initialize FCM
  Future<void> initializeFCM() async {
    try {
      await _repository.initializeFCM();
    } catch (e) {
      rethrow;
    }
  }

  /// Ensure FCM token is saved
  Future<String?> ensureFcmTokenSaved() async {
    try {
      return await _repository.ensureFcmTokenSaved();
    } catch (e) {
      rethrow;
    }
  }
}

/// Controller for notification preferences
class NotificationPreferencesController
    extends StateNotifier<AsyncValue<NotificationPreferences>> {
  final NotificationsRepository _repository;

  NotificationPreferencesController(this._repository)
      : super(const AsyncValue.loading()) {
    _loadPreferences();
  }

  /// Load preferences
  Future<void> _loadPreferences() async {
    try {
      final preferences = await _repository.loadPreferences();
      state = AsyncValue.data(preferences);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// Update preferences
  Future<void> updatePreferences(NotificationPreferences preferences) async {
    try {
      await _repository.savePreferences(preferences);
      state = AsyncValue.data(preferences);
    } catch (e) {
      // Keep old state on error
      rethrow;
    }
  }

  /// Toggle specific notification type
  Future<void> toggleNotificationType(
      NotificationType type, bool enabled) async {
    if (!state.hasValue) return;

    final currentPrefs = state.value!;
    NotificationPreferences updatedPrefs;

    switch (type) {
      case NotificationType.leadNew:
        updatedPrefs = currentPrefs.copyWith(leadNew: enabled);
        break;
      case NotificationType.leadAccepted:
      case NotificationType.leadDeclined:
        updatedPrefs = currentPrefs.copyWith(leadStatus: enabled);
        break;
      case NotificationType.jobAssigned:
      case NotificationType.jobChanged:
      case NotificationType.jobCancelled:
        updatedPrefs = currentPrefs.copyWith(jobAssigned: enabled);
        break;
      case NotificationType.reminder24h:
        updatedPrefs = currentPrefs.copyWith(jobReminder24h: enabled);
        break;
      case NotificationType.reminder1h:
        updatedPrefs = currentPrefs.copyWith(jobReminder1h: enabled);
        break;
      case NotificationType.paymentCaptured:
      case NotificationType.paymentReleased:
      case NotificationType.paymentRefunded:
        updatedPrefs = currentPrefs.copyWith(payment: enabled);
        break;
      case NotificationType.disputeOpened:
      case NotificationType.disputeResponse:
      case NotificationType.disputeDecision:
        updatedPrefs = currentPrefs.copyWith(dispute: enabled);
        break;
      case NotificationType.chatMessage:
        // Chat is always enabled
        return;
    }

    await updatePreferences(updatedPrefs);
  }

  /// Update quiet hours
  Future<void> updateQuietHours(QuietHours quietHours) async {
    if (!state.hasValue) return;

    final updatedPrefs = state.value!.copyWith(quietHours: quietHours);
    await updatePreferences(updatedPrefs);
  }

  /// Toggle in-app only mode
  Future<void> toggleInAppOnly(bool inAppOnly) async {
    if (!state.hasValue) return;

    final updatedPrefs = state.value!.copyWith(inAppOnly: inAppOnly);
    await updatePreferences(updatedPrefs);
  }

  /// Refresh preferences
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await _loadPreferences();
  }
}

/// Provider for checking if it's currently quiet hours
final isQuietHoursProvider = FutureProvider<bool>((ref) async {
  final repository = ref.watch(notificationsRepositoryProvider);
  return repository.isQuietHours();
});

/// Provider to get notification by ID
final notificationProvider = FutureProvider.family<AppNotification?, String>(
    (ref, notificationId) async {
  final repository = ref.watch(notificationsRepositoryProvider);
  final notifications = await repository.getNotifications();

  try {
    return notifications.firstWhere((n) => n.firestoreId == notificationId);
  } catch (e) {
    return null;
  }
});

/// Provider for notification statistics
final notificationStatsProvider =
    FutureProvider<NotificationStats>((ref) async {
  final repository = ref.watch(notificationsRepositoryProvider);

  final unreadCount = await repository.getUnreadCount();
  final allNotifications = await repository.getNotifications(limit: 100);

  final todayNotifications = allNotifications.where((n) {
    final now = DateTime.now();
    final notificationDate = n.createdAt;
    return notificationDate.year == now.year &&
        notificationDate.month == now.month &&
        notificationDate.day == now.day;
  }).length;

  return NotificationStats(
    totalCount: allNotifications.length,
    unreadCount: unreadCount,
    todayCount: todayNotifications,
  );
});

/// Notification statistics model
class NotificationStats {
  final int totalCount;
  final int unreadCount;
  final int todayCount;

  const NotificationStats({
    required this.totalCount,
    required this.unreadCount,
    required this.todayCount,
  });
}

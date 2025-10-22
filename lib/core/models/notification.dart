import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brivida_app/core/i18n/app_localizations.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

/// Enum for notification types
enum NotificationType {
  @JsonValue('lead_new')
  leadNew,
  @JsonValue('lead_accepted')
  leadAccepted,
  @JsonValue('lead_declined')
  leadDeclined,
  @JsonValue('job_assigned')
  jobAssigned,
  @JsonValue('job_changed')
  jobChanged,
  @JsonValue('job_cancelled')
  jobCancelled,
  @JsonValue('reminder_24h')
  reminder24h,
  @JsonValue('reminder_1h')
  reminder1h,
  @JsonValue('payment_captured')
  paymentCaptured,
  @JsonValue('payment_released')
  paymentReleased,
  @JsonValue('payment_refunded')
  paymentRefunded,
  @JsonValue('dispute_opened')
  disputeOpened,
  @JsonValue('dispute_response')
  disputeResponse,
  @JsonValue('dispute_decision')
  disputeDecision,
  @JsonValue('chat_message')
  chatMessage,
}

extension NotificationTypeExt on NotificationType {
  String displayName(AppLocalizations l10n) {
    switch (this) {
      case NotificationType.leadNew:
        return l10n.notificationTypeLeadNew;
      case NotificationType.leadAccepted:
        return l10n.notificationTypeLeadAccepted;
      case NotificationType.leadDeclined:
        return l10n.notificationTypeLeadDeclined;
      case NotificationType.jobAssigned:
        return l10n.notificationTypeJobAssigned;
      case NotificationType.jobChanged:
        return l10n.notificationTypeJobChanged;
      case NotificationType.jobCancelled:
        return l10n.notificationTypeJobCancelled;
      case NotificationType.reminder24h:
        return l10n.notificationTypeReminder24h;
      case NotificationType.reminder1h:
        return l10n.notificationTypeReminder1h;
      case NotificationType.paymentCaptured:
        return l10n.notificationTypePaymentCaptured;
      case NotificationType.paymentReleased:
        return l10n.notificationTypePaymentReleased;
      case NotificationType.paymentRefunded:
        return l10n.notificationTypePaymentRefunded;
      case NotificationType.disputeOpened:
        return l10n.notificationTypeDisputeOpened;
      case NotificationType.disputeResponse:
        return l10n.notificationTypeDisputeResponse;
      case NotificationType.disputeDecision:
        return l10n.notificationTypeDisputeDecision;
      case NotificationType.chatMessage:
        return l10n.notificationTypeChatMessage;
    }
  }

  String get iconName {
    switch (this) {
      case NotificationType.leadNew:
        return 'work';
      case NotificationType.leadAccepted:
        return 'check_circle';
      case NotificationType.leadDeclined:
        return 'cancel';
      case NotificationType.jobAssigned:
        return 'assignment';
      case NotificationType.jobChanged:
        return 'edit';
      case NotificationType.jobCancelled:
        return 'event_busy';
      case NotificationType.reminder24h:
      case NotificationType.reminder1h:
        return 'alarm';
      case NotificationType.paymentCaptured:
      case NotificationType.paymentReleased:
        return 'payment';
      case NotificationType.paymentRefunded:
        return 'money_off';
      case NotificationType.disputeOpened:
      case NotificationType.disputeResponse:
      case NotificationType.disputeDecision:
        return 'gavel';
      case NotificationType.chatMessage:
        return 'message';
    }
  }

  String get name {
    switch (this) {
      case NotificationType.leadNew:
        return 'lead_new';
      case NotificationType.leadAccepted:
        return 'lead_accepted';
      case NotificationType.leadDeclined:
        return 'lead_declined';
      case NotificationType.jobAssigned:
        return 'job_assigned';
      case NotificationType.jobChanged:
        return 'job_changed';
      case NotificationType.jobCancelled:
        return 'job_cancelled';
      case NotificationType.reminder24h:
        return 'reminder_24h';
      case NotificationType.reminder1h:
        return 'reminder_1h';
      case NotificationType.paymentCaptured:
        return 'payment_captured';
      case NotificationType.paymentReleased:
        return 'payment_released';
      case NotificationType.paymentRefunded:
        return 'payment_refunded';
      case NotificationType.disputeOpened:
        return 'dispute_opened';
      case NotificationType.disputeResponse:
        return 'dispute_response';
      case NotificationType.disputeDecision:
        return 'dispute_decision';
      case NotificationType.chatMessage:
        return 'chat_message';
    }
  }
}

/// Notification preferences for users
@freezed
abstract class NotificationPreferences with _$NotificationPreferences {
  const NotificationPreferences._();

  const factory NotificationPreferences({
    @Default(true) bool leadNew,
    @Default(true) bool leadStatus,
    @Default(true) bool jobAssigned,
    @Default(true) bool jobReminder24h,
    @Default(true) bool jobReminder1h,
    @Default(true) bool payment,
    @Default(true) bool dispute,
    @Default(false) bool inAppOnly,
    @Default(QuietHours()) QuietHours quietHours,
  }) = _NotificationPreferences;

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesFromJson(json);

  /// Check if notification type is enabled
  bool isTypeEnabled(NotificationType type) {
    switch (type) {
      case NotificationType.leadNew:
        return leadNew;
      case NotificationType.leadAccepted:
      case NotificationType.leadDeclined:
        return leadStatus;
      case NotificationType.jobAssigned:
      case NotificationType.jobChanged:
      case NotificationType.jobCancelled:
        return jobAssigned;
      case NotificationType.reminder24h:
        return jobReminder24h;
      case NotificationType.reminder1h:
        return jobReminder1h;
      case NotificationType.paymentCaptured:
      case NotificationType.paymentReleased:
      case NotificationType.paymentRefunded:
        return payment;
      case NotificationType.disputeOpened:
      case NotificationType.disputeResponse:
      case NotificationType.disputeDecision:
        return dispute;
      case NotificationType.chatMessage:
        return true; // Chat is always enabled
    }
  }

  /// Convert to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'leadNew': leadNew,
      'leadStatus': leadStatus,
      'jobAssigned': jobAssigned,
      'jobReminder24h': jobReminder24h,
      'jobReminder1h': jobReminder1h,
      'payment': payment,
      'dispute': dispute,
      'inAppOnly': inAppOnly,
      'quietHours': {
        'start': quietHours.start,
        'end': quietHours.end,
        'timezone': quietHours.timezone,
      },
    };
  }
}

/// Quiet hours configuration
@freezed
abstract class QuietHours with _$QuietHours {
  const factory QuietHours({
    @Default('22:00') String start,
    @Default('07:00') String end,
    @Default('Atlantic/Madeira') String timezone,
  }) = _QuietHours;

  factory QuietHours.fromJson(Map<String, dynamic> json) =>
      _$QuietHoursFromJson(json);
}

/// Extension for quiet hours logic
extension QuietHoursExt on QuietHours {
  /// Check if current time is within quiet hours
  bool get isQuietNow {
    final now = DateTime.now();

    // Parse start and end times
    final startParts = start.split(':');
    final endParts = end.split(':');

    final startHour = int.parse(startParts[0]);
    final startMinute = int.parse(startParts[1]);
    final endHour = int.parse(endParts[0]);
    final endMinute = int.parse(endParts[1]);

    final startTime = DateTime(
      now.year,
      now.month,
      now.day,
      startHour,
      startMinute,
    );
    var endTime = DateTime(now.year, now.month, now.day, endHour, endMinute);

    // If end time is before start time, it means it's for the next day
    if (endTime.isBefore(startTime)) {
      endTime = endTime.add(const Duration(days: 1));
    }

    // Check if current time is within quiet hours
    if (endTime.day > startTime.day) {
      // Quiet hours span midnight
      return now.isAfter(startTime) ||
          now.isBefore(
            DateTime(now.year, now.month, now.day, endHour, endMinute),
          );
    } else {
      // Quiet hours within same day
      return now.isAfter(startTime) && now.isBefore(endTime);
    }
  }
}

/// In-app notification model
@freezed
abstract class AppNotification with _$AppNotification {
  const AppNotification._();

  const factory AppNotification({
    required String firestoreId,
    required String uid,
    required NotificationType type,
    required String title,
    required String body,
    @Default({}) Map<String, dynamic> data,
    @Default(false) bool read,
    required DateTime createdAt,
  }) = _AppNotification;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);

  /// Create from Firestore document
  factory AppNotification.fromFirestore(Map<String, dynamic> data, String id) {
    return AppNotification.fromJson({
      ...data,
      'firestoreId': id,
      'type': data['type'] ?? 'chat_message',
      'createdAt':
          (data['createdAt'] as Timestamp?)?.toDate().toIso8601String() ??
          DateTime.now().toIso8601String(),
    });
  }

  /// Convert to Firestore format
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('firestoreId');

    // Convert DateTime to Timestamp
    json['createdAt'] = Timestamp.fromDate(createdAt);

    return json;
  }
}

/// Extension for notification logic
extension AppNotificationExt on AppNotification {
  /// Get deeplink route from data
  String? get deeplinkRoute => data['route'] as String?;

  /// Get related entity ID
  String? get entityId {
    return data['jobId'] as String? ??
        data['leadId'] as String? ??
        data['paymentId'] as String? ??
        data['disputeId'] as String? ??
        data['chatId'] as String?;
  }

  /// Check if notification is recent (within 24 hours)
  bool get isRecent {
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    return difference.inHours < 24;
  }

  /// Get formatted time string
  String get timeString {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 1) {
      return 'Jetzt';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      // Format as date
      return '${createdAt.day}.${createdAt.month}.${createdAt.year}';
    }
  }
}

/// Request to create a notification
@freezed
abstract class NotificationRequest with _$NotificationRequest {
  const factory NotificationRequest({
    required String uid,
    required NotificationType type,
    required String title,
    required String body,
    @Default({}) Map<String, dynamic> data,
  }) = _NotificationRequest;

  factory NotificationRequest.fromJson(Map<String, dynamic> json) =>
      _$NotificationRequestFromJson(json);
}

/// FCM message payload
@freezed
abstract class FCMMessage with _$FCMMessage {
  const factory FCMMessage({
    required String token,
    required String title,
    required String body,
    @Default({}) Map<String, String> data,
    String? imageUrl,
  }) = _FCMMessage;

  factory FCMMessage.fromJson(Map<String, dynamic> json) =>
      _$FCMMessageFromJson(json);
}

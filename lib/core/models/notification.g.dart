// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationPreferences _$NotificationPreferencesFromJson(
  Map<String, dynamic> json,
) => _NotificationPreferences(
  leadNew: json['leadNew'] as bool? ?? true,
  leadStatus: json['leadStatus'] as bool? ?? true,
  jobAssigned: json['jobAssigned'] as bool? ?? true,
  jobReminder24h: json['jobReminder24h'] as bool? ?? true,
  jobReminder1h: json['jobReminder1h'] as bool? ?? true,
  payment: json['payment'] as bool? ?? true,
  dispute: json['dispute'] as bool? ?? true,
  inAppOnly: json['inAppOnly'] as bool? ?? false,
  quietHours: json['quietHours'] == null
      ? const QuietHours()
      : QuietHours.fromJson(json['quietHours'] as Map<String, dynamic>),
);

Map<String, dynamic> _$NotificationPreferencesToJson(
  _NotificationPreferences instance,
) => <String, dynamic>{
  'leadNew': instance.leadNew,
  'leadStatus': instance.leadStatus,
  'jobAssigned': instance.jobAssigned,
  'jobReminder24h': instance.jobReminder24h,
  'jobReminder1h': instance.jobReminder1h,
  'payment': instance.payment,
  'dispute': instance.dispute,
  'inAppOnly': instance.inAppOnly,
  'quietHours': instance.quietHours,
};

_QuietHours _$QuietHoursFromJson(Map<String, dynamic> json) => _QuietHours(
  start: json['start'] as String? ?? '22:00',
  end: json['end'] as String? ?? '07:00',
  timezone: json['timezone'] as String? ?? 'Atlantic/Madeira',
);

Map<String, dynamic> _$QuietHoursToJson(_QuietHours instance) =>
    <String, dynamic>{
      'start': instance.start,
      'end': instance.end,
      'timezone': instance.timezone,
    };

_AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) =>
    _AppNotification(
      firestoreId: json['firestoreId'] as String,
      uid: json['uid'] as String,
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      title: json['title'] as String,
      body: json['body'] as String,
      data: json['data'] as Map<String, dynamic>? ?? const {},
      read: json['read'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$AppNotificationToJson(_AppNotification instance) =>
    <String, dynamic>{
      'firestoreId': instance.firestoreId,
      'uid': instance.uid,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'title': instance.title,
      'body': instance.body,
      'data': instance.data,
      'read': instance.read,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$NotificationTypeEnumMap = {
  NotificationType.leadNew: 'lead_new',
  NotificationType.leadAccepted: 'lead_accepted',
  NotificationType.leadDeclined: 'lead_declined',
  NotificationType.jobAssigned: 'job_assigned',
  NotificationType.jobChanged: 'job_changed',
  NotificationType.jobCancelled: 'job_cancelled',
  NotificationType.reminder24h: 'reminder_24h',
  NotificationType.reminder1h: 'reminder_1h',
  NotificationType.paymentCaptured: 'payment_captured',
  NotificationType.paymentReleased: 'payment_released',
  NotificationType.paymentRefunded: 'payment_refunded',
  NotificationType.disputeOpened: 'dispute_opened',
  NotificationType.disputeResponse: 'dispute_response',
  NotificationType.disputeDecision: 'dispute_decision',
  NotificationType.chatMessage: 'chat_message',
};

_NotificationRequest _$NotificationRequestFromJson(Map<String, dynamic> json) =>
    _NotificationRequest(
      uid: json['uid'] as String,
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      title: json['title'] as String,
      body: json['body'] as String,
      data: json['data'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$NotificationRequestToJson(
  _NotificationRequest instance,
) => <String, dynamic>{
  'uid': instance.uid,
  'type': _$NotificationTypeEnumMap[instance.type]!,
  'title': instance.title,
  'body': instance.body,
  'data': instance.data,
};

_FCMMessage _$FCMMessageFromJson(Map<String, dynamic> json) => _FCMMessage(
  token: json['token'] as String,
  title: json['title'] as String,
  body: json['body'] as String,
  data:
      (json['data'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const {},
  imageUrl: json['imageUrl'] as String?,
);

Map<String, dynamic> _$FCMMessageToJson(_FCMMessage instance) =>
    <String, dynamic>{
      'token': instance.token,
      'title': instance.title,
      'body': instance.body,
      'data': instance.data,
      'imageUrl': instance.imageUrl,
    };

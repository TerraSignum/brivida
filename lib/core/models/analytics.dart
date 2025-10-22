// Analytics data models for events and daily aggregations
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'analytics.freezed.dart';
part 'analytics.g.dart';

/// Raw analytics event stored in Firestore
@freezed
abstract class AnalyticsEvent with _$AnalyticsEvent {
  const AnalyticsEvent._();

  const factory AnalyticsEvent({
    required String id,
    String? uid, // nullable for events before login
    String? role, // customer|pro|admin|null
    required DateTime ts,
    required String src, // client|server
    required String name,
    required Map<String, Object?> props,
    required Map<String, Object?> context,
    required String sessionId,
  }) = _AnalyticsEvent;

  factory AnalyticsEvent.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsEventFromJson(json);

  factory AnalyticsEvent.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AnalyticsEvent(
      id: doc.id,
      uid: data['uid'] as String?,
      role: data['role'] as String?,
      ts: (data['ts'] as Timestamp).toDate(),
      src: data['src'] as String,
      name: data['name'] as String,
      props: Map<String, Object?>.from(data['props'] as Map),
      context: Map<String, Object?>.from(data['context'] as Map),
      sessionId: data['sessionId'] as String,
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      'uid': uid,
      'role': role,
      'ts': Timestamp.fromDate(ts),
      'src': src,
      'name': name,
      'props': props,
      'context': context,
      'sessionId': sessionId,
    };
  }
}

/// Daily aggregated analytics KPIs
@freezed
abstract class AnalyticsDaily with _$AnalyticsDaily {
  const factory AnalyticsDaily({
    required String date, // yyyyMMdd format
    required AnalyticsKpis kpis,
    required DateTime updatedAt,
  }) = _AnalyticsDaily;

  factory AnalyticsDaily.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsDailyFromJson(json);

  factory AnalyticsDaily.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AnalyticsDaily(
      date: doc.id,
      kpis: AnalyticsKpis.fromJson(data['kpis'] as Map<String, dynamic>),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }
}

/// Key performance indicators for daily aggregation
@freezed
abstract class AnalyticsKpis with _$AnalyticsKpis {
  const factory AnalyticsKpis({
    @Default(0) int jobsCreated,
    @Default(0) int leadsCreated,
    @Default(0) int leadsAccepted,
    @Default(0.0) double paymentsCapturedEur,
    @Default(0.0) double paymentsReleasedEur,
    @Default(0.0) double refundsEur,
    @Default(0) int chatMessages,
    @Default(0) int activePros,
    @Default(0) int activeCustomers,
    @Default(0) int newUsers,
    @Default(0) int disputesOpened,
    @Default(0) int disputesResolved,
    @Default(0.0) double avgRating,
    @Default(0) int ratingsCount,
    @Default(0) int pushDelivered,
    @Default(0) int pushOpened,
    @Default(0.0) double pushOpenRate,
  }) = _AnalyticsKpis;

  factory AnalyticsKpis.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsKpisFromJson(json);
}

/// Export request for analytics data
@freezed
abstract class AnalyticsExportRequest with _$AnalyticsExportRequest {
  const factory AnalyticsExportRequest({
    required String type, // 'events' | 'daily'
    String? dateFrom,
    String? dateTo,
  }) = _AnalyticsExportRequest;

  factory AnalyticsExportRequest.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsExportRequestFromJson(json);
}

/// Context information for analytics events
@freezed
abstract class AnalyticsContext with _$AnalyticsContext {
  const factory AnalyticsContext({
    required String platform, // android|ios|web|server
    required String appVersion,
    String? ipHash, // server-side only
    String? uaHash, // server-side only
  }) = _AnalyticsContext;

  factory AnalyticsContext.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsContextFromJson(json);
}

/// Whitelisted event names for client-side tracking
class AnalyticsEventNames {
  // Auth events
  static const String loginSuccess = 'login_success';
  static const String signupSuccess = 'signup_success';

  // Job events
  static const String jobCreated = 'job_created';
  static const String jobUpdated = 'job_updated';
  static const String jobAssigned = 'job_assigned';

  // Lead events
  static const String leadCreated = 'lead_created';
  static const String leadAccepted = 'lead_accepted';
  static const String leadDeclined = 'lead_declined';

  // Chat events
  static const String chatMsgSent = 'chat_msg_sent';

  // Calendar events
  static const String calendarEventSaved = 'calendar_event_saved';
  static const String calendarConflictHard = 'calendar_conflict_hard';

  // Payment events
  static const String paymentCheckoutOpened = 'payment_checkout_opened';
  static const String paymentCaptured = 'payment_captured';
  static const String paymentReleased = 'payment_released';
  static const String paymentRefunded = 'payment_refunded';
  static const String adminServicePurchaseSuccess =
      'admin_service_purchase_success';

  // Dispute events
  static const String disputeOpened = 'dispute_opened';
  static const String disputeResolved = 'dispute_resolved';

  // Review events
  static const String reviewSubmitted = 'review_submitted';

  // Push notification events
  static const String pushDelivered = 'push_delivered';
  static const String pushOpened = 'push_opened';

  // Server-only events
  static const String transferCreated = 'transfer_created';
  static const String adminSetFlag = 'admin_set_flag';
  static const String adminExportCsv = 'admin_export_csv';
  static const String adminRecalcHealth = 'admin_recalc_health';
  static const String pushSent = 'push_sent';
  static const String pushSuppressed = 'push_suppressed_quiet_hours';

  /// All allowed client event names
  static const Set<String> clientEvents = {
    loginSuccess,
    signupSuccess,
    jobCreated,
    jobUpdated,
    jobAssigned,
    leadCreated,
    leadAccepted,
    leadDeclined,
    chatMsgSent,
    calendarEventSaved,
    calendarConflictHard,
    paymentCheckoutOpened,
    adminServicePurchaseSuccess,
    reviewSubmitted,
    pushDelivered,
    pushOpened,
  };

  /// All allowed server event names
  static const Set<String> serverEvents = {
    paymentCaptured,
    paymentReleased,
    paymentRefunded,
    disputeOpened,
    disputeResolved,
    transferCreated,
    adminSetFlag,
    adminExportCsv,
    adminRecalcHealth,
    pushSent,
    pushSuppressed,
  };
}

/// Whitelisted property keys for events
class AnalyticsEventProps {
  // Job properties
  static const String sizeM2 = 'sizeM2';
  static const String servicesCount = 'servicesCount';
  static const String jobType = 'jobType';

  // Payment properties
  static const String amountEur = 'amountEur';
  static const String amountNet = 'amountNet';

  // Chat properties
  static const String messageLength = 'length';

  // Calendar properties
  static const String eventType = 'eventType';
  static const String minutesGap = 'minutes_gap';

  // Review properties
  static const String rating = 'rating';

  // Push properties
  static const String pushType = 'pushType';

  // Dispute properties
  static const String disputeReason = 'reason';
  static const String disputeOutcome = 'outcome';

  // Admin properties
  static const String adminFlag = 'flag';
  static const String exportKind = 'kind';

  // Job hash (client-side pseudonymized)
  static const String jobIdHash = 'jobIdHash';

  /// All allowed property keys
  static const Set<String> allowedKeys = {
    sizeM2,
    servicesCount,
    jobType,
    amountEur,
    amountNet,
    messageLength,
    eventType,
    minutesGap,
    rating,
    pushType,
    disputeReason,
    disputeOutcome,
    adminFlag,
    exportKind,
    jobIdHash,
  };
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment.freezed.dart';
part 'payment.g.dart';

@freezed
abstract class Payment with _$Payment {
  const factory Payment({
    String? id,
    required String jobId,
    required String customerUid,
    String? connectedAccountId,
    required double amountGross,
    required String currency,
    @Default(PaymentStatus.pending) PaymentStatus status,
    @TimestampConverter() DateTime? escrowHoldUntil,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? capturedAt,
    @TimestampConverter() DateTime? transferredAt,
    String? stripePaymentIntentId,
    String? stripeChargeId,
    String? transferId,
    double? platformFee,
    double? totalRefunded,
    @TimestampConverter() DateTime? lastRefundedAt,
    bool? autoReleased,
  }) = _Payment;

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);

  // Firestore conversion helper
  factory Payment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Payment(
      id: doc.id,
      jobId: data['jobId'] as String,
      customerUid: data['customerUid'] as String,
      connectedAccountId: data['connectedAccountId'] as String?,
      amountGross: (data['amountGross'] as num).toDouble(),
      currency: data['currency'] as String? ?? 'EUR',
      status: PaymentStatus.values.firstWhere(
        (s) => s.name == data['status'],
        orElse: () => PaymentStatus.pending,
      ),
      escrowHoldUntil: (data['escrowHoldUntil'] as Timestamp?)?.toDate(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      capturedAt: (data['capturedAt'] as Timestamp?)?.toDate(),
      transferredAt: (data['transferredAt'] as Timestamp?)?.toDate(),
      stripePaymentIntentId: data['stripePaymentIntentId'] as String?,
      stripeChargeId: data['stripeChargeId'] as String?,
      transferId: data['transferId'] as String?,
      platformFee: (data['platformFee'] as num?)?.toDouble(),
      totalRefunded: (data['totalRefunded'] as num?)?.toDouble(),
      lastRefundedAt: (data['lastRefundedAt'] as Timestamp?)?.toDate(),
      autoReleased: data['autoReleased'] as bool?,
    );
  }
}

@freezed
abstract class Transfer with _$Transfer {
  const factory Transfer({
    String? id,
    required String paymentId,
    required String jobId,
    String? proUid, // Added for PG-12: Pro user ID for security & queries
    required String connectedAccountId,
    required double amountNet,
    @Default(0.0) double platformFee,
    double? amountGross, // Added for PG-12: Total amount from customer
    required String currency,
    @Default(TransferStatus.pending) TransferStatus status,
    @Default(false) bool manualRelease,
    String? releasedBy,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? completedAt,
    @TimestampConverter()
    DateTime? releasedAt, // Added for PG-12: When transfer was released
    String? stripeTransferId,
  }) = _Transfer;

  factory Transfer.fromJson(Map<String, dynamic> json) =>
      _$TransferFromJson(json);
}

@freezed
abstract class Refund with _$Refund {
  const factory Refund({
    String? id,
    required String paymentId,
    required String jobId,
    required double amount,
    required String currency,
    @Default('requested_by_customer') String reason,
    @Default(RefundStatus.completed) RefundStatus status,
    String? requestedBy,
    @TimestampConverter() DateTime? createdAt,
    String? stripeRefundId,
  }) = _Refund;

  factory Refund.fromJson(Map<String, dynamic> json) => _$RefundFromJson(json);
}

enum PaymentStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('captured')
  captured,
  @JsonValue('transferred')
  transferred,
  @JsonValue('refunded')
  refunded,
  @JsonValue('failed')
  failed,
  @JsonValue('cancelled')
  cancelled,
}

enum TransferStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('completed')
  completed,
  @JsonValue('failed')
  failed,
}

enum RefundStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('completed')
  completed,
  @JsonValue('failed')
  failed,
}

// Timestamp converter for Firestore
class TimestampConverter implements JsonConverter<DateTime?, Object?> {
  const TimestampConverter();

  @override
  DateTime? fromJson(Object? json) {
    if (json == null) return null;
    if (json is Timestamp) return json.toDate();
    if (json is String) return DateTime.parse(json);
    if (json is int) return DateTime.fromMillisecondsSinceEpoch(json);
    return null;
  }

  @override
  Object? toJson(DateTime? object) {
    if (object == null) return null;
    return Timestamp.fromDate(object);
  }
}

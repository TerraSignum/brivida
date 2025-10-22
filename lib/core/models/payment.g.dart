// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Payment _$PaymentFromJson(Map<String, dynamic> json) => _Payment(
  id: json['id'] as String?,
  jobId: json['jobId'] as String,
  customerUid: json['customerUid'] as String,
  connectedAccountId: json['connectedAccountId'] as String?,
  amountGross: (json['amountGross'] as num).toDouble(),
  currency: json['currency'] as String,
  status:
      $enumDecodeNullable(_$PaymentStatusEnumMap, json['status']) ??
      PaymentStatus.pending,
  escrowHoldUntil: const TimestampConverter().fromJson(json['escrowHoldUntil']),
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  capturedAt: const TimestampConverter().fromJson(json['capturedAt']),
  transferredAt: const TimestampConverter().fromJson(json['transferredAt']),
  stripePaymentIntentId: json['stripePaymentIntentId'] as String?,
  stripeChargeId: json['stripeChargeId'] as String?,
  transferId: json['transferId'] as String?,
  platformFee: (json['platformFee'] as num?)?.toDouble(),
  totalRefunded: (json['totalRefunded'] as num?)?.toDouble(),
  lastRefundedAt: const TimestampConverter().fromJson(json['lastRefundedAt']),
  autoReleased: json['autoReleased'] as bool?,
);

Map<String, dynamic> _$PaymentToJson(_Payment instance) => <String, dynamic>{
  'id': instance.id,
  'jobId': instance.jobId,
  'customerUid': instance.customerUid,
  'connectedAccountId': instance.connectedAccountId,
  'amountGross': instance.amountGross,
  'currency': instance.currency,
  'status': _$PaymentStatusEnumMap[instance.status]!,
  'escrowHoldUntil': const TimestampConverter().toJson(
    instance.escrowHoldUntil,
  ),
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'capturedAt': const TimestampConverter().toJson(instance.capturedAt),
  'transferredAt': const TimestampConverter().toJson(instance.transferredAt),
  'stripePaymentIntentId': instance.stripePaymentIntentId,
  'stripeChargeId': instance.stripeChargeId,
  'transferId': instance.transferId,
  'platformFee': instance.platformFee,
  'totalRefunded': instance.totalRefunded,
  'lastRefundedAt': const TimestampConverter().toJson(instance.lastRefundedAt),
  'autoReleased': instance.autoReleased,
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.captured: 'captured',
  PaymentStatus.transferred: 'transferred',
  PaymentStatus.refunded: 'refunded',
  PaymentStatus.failed: 'failed',
  PaymentStatus.cancelled: 'cancelled',
};

_Transfer _$TransferFromJson(Map<String, dynamic> json) => _Transfer(
  id: json['id'] as String?,
  paymentId: json['paymentId'] as String,
  jobId: json['jobId'] as String,
  proUid: json['proUid'] as String?,
  connectedAccountId: json['connectedAccountId'] as String,
  amountNet: (json['amountNet'] as num).toDouble(),
  platformFee: (json['platformFee'] as num?)?.toDouble() ?? 0.0,
  amountGross: (json['amountGross'] as num?)?.toDouble(),
  currency: json['currency'] as String,
  status:
      $enumDecodeNullable(_$TransferStatusEnumMap, json['status']) ??
      TransferStatus.pending,
  manualRelease: json['manualRelease'] as bool? ?? false,
  releasedBy: json['releasedBy'] as String?,
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  completedAt: const TimestampConverter().fromJson(json['completedAt']),
  releasedAt: const TimestampConverter().fromJson(json['releasedAt']),
  stripeTransferId: json['stripeTransferId'] as String?,
);

Map<String, dynamic> _$TransferToJson(_Transfer instance) => <String, dynamic>{
  'id': instance.id,
  'paymentId': instance.paymentId,
  'jobId': instance.jobId,
  'proUid': instance.proUid,
  'connectedAccountId': instance.connectedAccountId,
  'amountNet': instance.amountNet,
  'platformFee': instance.platformFee,
  'amountGross': instance.amountGross,
  'currency': instance.currency,
  'status': _$TransferStatusEnumMap[instance.status]!,
  'manualRelease': instance.manualRelease,
  'releasedBy': instance.releasedBy,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'completedAt': const TimestampConverter().toJson(instance.completedAt),
  'releasedAt': const TimestampConverter().toJson(instance.releasedAt),
  'stripeTransferId': instance.stripeTransferId,
};

const _$TransferStatusEnumMap = {
  TransferStatus.pending: 'pending',
  TransferStatus.completed: 'completed',
  TransferStatus.failed: 'failed',
};

_Refund _$RefundFromJson(Map<String, dynamic> json) => _Refund(
  id: json['id'] as String?,
  paymentId: json['paymentId'] as String,
  jobId: json['jobId'] as String,
  amount: (json['amount'] as num).toDouble(),
  currency: json['currency'] as String,
  reason: json['reason'] as String? ?? 'requested_by_customer',
  status:
      $enumDecodeNullable(_$RefundStatusEnumMap, json['status']) ??
      RefundStatus.completed,
  requestedBy: json['requestedBy'] as String?,
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  stripeRefundId: json['stripeRefundId'] as String?,
);

Map<String, dynamic> _$RefundToJson(_Refund instance) => <String, dynamic>{
  'id': instance.id,
  'paymentId': instance.paymentId,
  'jobId': instance.jobId,
  'amount': instance.amount,
  'currency': instance.currency,
  'reason': instance.reason,
  'status': _$RefundStatusEnumMap[instance.status]!,
  'requestedBy': instance.requestedBy,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'stripeRefundId': instance.stripeRefundId,
};

const _$RefundStatusEnumMap = {
  RefundStatus.pending: 'pending',
  RefundStatus.completed: 'completed',
  RefundStatus.failed: 'failed',
};

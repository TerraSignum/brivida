// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dispute.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Evidence _$EvidenceFromJson(Map<String, dynamic> json) => _Evidence(
  type: $enumDecode(_$EvidenceTypeEnumMap, json['type']),
  path: json['path'] as String?,
  text: json['text'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$EvidenceToJson(_Evidence instance) => <String, dynamic>{
  'type': _$EvidenceTypeEnumMap[instance.type]!,
  'path': instance.path,
  'text': instance.text,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$EvidenceTypeEnumMap = {
  EvidenceType.image: 'image',
  EvidenceType.text: 'text',
  EvidenceType.audio: 'audio',
};

_DisputeAuditEntry _$DisputeAuditEntryFromJson(Map<String, dynamic> json) =>
    _DisputeAuditEntry(
      by: json['by'] as String,
      action: json['action'] as String,
      note: json['note'] as String?,
      at: DateTime.parse(json['at'] as String),
    );

Map<String, dynamic> _$DisputeAuditEntryToJson(_DisputeAuditEntry instance) =>
    <String, dynamic>{
      'by': instance.by,
      'action': instance.action,
      'note': instance.note,
      'at': instance.at.toIso8601String(),
    };

_Dispute _$DisputeFromJson(Map<String, dynamic> json) => _Dispute(
  id: json['id'] as String,
  jobId: json['jobId'] as String,
  paymentId: json['paymentId'] as String,
  customerUid: json['customerUid'] as String,
  proUid: json['proUid'] as String,
  status: $enumDecode(_$DisputeStatusEnumMap, json['status']),
  reason: $enumDecode(_$DisputeReasonEnumMap, json['reason']),
  description: json['description'] as String,
  requestedAmount: (json['requestedAmount'] as num).toDouble(),
  awardedAmount: (json['awardedAmount'] as num?)?.toDouble(),
  openedAt: DateTime.parse(json['openedAt'] as String),
  deadlineProResponse: DateTime.parse(json['deadlineProResponse'] as String),
  deadlineDecision: DateTime.parse(json['deadlineDecision'] as String),
  resolvedAt: json['resolvedAt'] == null
      ? null
      : DateTime.parse(json['resolvedAt'] as String),
  evidence:
      (json['evidence'] as List<dynamic>?)
          ?.map((e) => Evidence.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  proResponse:
      (json['proResponse'] as List<dynamic>?)
          ?.map((e) => Evidence.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  audit:
      (json['audit'] as List<dynamic>?)
          ?.map((e) => DisputeAuditEntry.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$DisputeToJson(_Dispute instance) => <String, dynamic>{
  'id': instance.id,
  'jobId': instance.jobId,
  'paymentId': instance.paymentId,
  'customerUid': instance.customerUid,
  'proUid': instance.proUid,
  'status': _$DisputeStatusEnumMap[instance.status]!,
  'reason': _$DisputeReasonEnumMap[instance.reason]!,
  'description': instance.description,
  'requestedAmount': instance.requestedAmount,
  'awardedAmount': instance.awardedAmount,
  'openedAt': instance.openedAt.toIso8601String(),
  'deadlineProResponse': instance.deadlineProResponse.toIso8601String(),
  'deadlineDecision': instance.deadlineDecision.toIso8601String(),
  'resolvedAt': instance.resolvedAt?.toIso8601String(),
  'evidence': instance.evidence,
  'proResponse': instance.proResponse,
  'audit': instance.audit,
};

const _$DisputeStatusEnumMap = {
  DisputeStatus.open: 'open',
  DisputeStatus.awaitingPro: 'awaiting_pro',
  DisputeStatus.underReview: 'under_review',
  DisputeStatus.resolvedRefundFull: 'resolved_refund_full',
  DisputeStatus.resolvedRefundPartial: 'resolved_refund_partial',
  DisputeStatus.resolvedNoRefund: 'resolved_no_refund',
  DisputeStatus.cancelled: 'cancelled',
  DisputeStatus.expired: 'expired',
};

const _$DisputeReasonEnumMap = {
  DisputeReason.noShow: 'no_show',
  DisputeReason.poorQuality: 'poor_quality',
  DisputeReason.damage: 'damage',
  DisputeReason.overcharge: 'overcharge',
  DisputeReason.other: 'other',
};

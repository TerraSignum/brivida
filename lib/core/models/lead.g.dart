// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lead.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Lead _$LeadFromJson(Map<String, dynamic> json) => _Lead(
  id: json['id'] as String?,
  jobId: json['jobId'] as String,
  customerUid: json['customerUid'] as String,
  proUid: json['proUid'] as String,
  message: json['message'] as String? ?? '',
  status:
      $enumDecodeNullable(_$LeadStatusEnumMap, json['status']) ??
      LeadStatus.pending,
  acceptedAt: const TimestampConverter().fromJson(json['acceptedAt']),
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
);

Map<String, dynamic> _$LeadToJson(_Lead instance) => <String, dynamic>{
  'id': instance.id,
  'jobId': instance.jobId,
  'customerUid': instance.customerUid,
  'proUid': instance.proUid,
  'message': instance.message,
  'status': _$LeadStatusEnumMap[instance.status]!,
  'acceptedAt': const TimestampConverter().toJson(instance.acceptedAt),
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
};

const _$LeadStatusEnumMap = {
  LeadStatus.pending: 'pending',
  LeadStatus.accepted: 'accepted',
  LeadStatus.declined: 'declined',
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReviewModeration _$ReviewModerationFromJson(Map<String, dynamic> json) =>
    _ReviewModeration(
      status: $enumDecode(_$ReviewModerationStatusEnumMap, json['status']),
      reason: json['reason'] as String?,
      adminUid: json['adminUid'] as String?,
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ReviewModerationToJson(_ReviewModeration instance) =>
    <String, dynamic>{
      'status': _$ReviewModerationStatusEnumMap[instance.status]!,
      'reason': instance.reason,
      'adminUid': instance.adminUid,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$ReviewModerationStatusEnumMap = {
  ReviewModerationStatus.visible: 'visible',
  ReviewModerationStatus.hidden: 'hidden',
  ReviewModerationStatus.flagged: 'flagged',
};

_Review _$ReviewFromJson(Map<String, dynamic> json) => _Review(
  firestoreId: json['firestoreId'] as String,
  jobId: json['jobId'] as String,
  paymentId: json['paymentId'] as String,
  customerUid: json['customerUid'] as String,
  proUid: json['proUid'] as String,
  rating: (json['rating'] as num).toInt(),
  comment: json['comment'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  moderation: ReviewModeration.fromJson(
    json['moderation'] as Map<String, dynamic>,
  ),
  customerDisplayName: json['customerDisplayName'] as String?,
  customerInitials: json['customerInitials'] as String?,
);

Map<String, dynamic> _$ReviewToJson(_Review instance) => <String, dynamic>{
  'firestoreId': instance.firestoreId,
  'jobId': instance.jobId,
  'paymentId': instance.paymentId,
  'customerUid': instance.customerUid,
  'proUid': instance.proUid,
  'rating': instance.rating,
  'comment': instance.comment,
  'createdAt': instance.createdAt.toIso8601String(),
  'moderation': instance.moderation,
  'customerDisplayName': instance.customerDisplayName,
  'customerInitials': instance.customerInitials,
};

_RatingAggregate _$RatingAggregateFromJson(Map<String, dynamic> json) =>
    _RatingAggregate(
      average: (json['average'] as num?)?.toDouble() ?? 0.0,
      count: (json['count'] as num?)?.toInt() ?? 0,
      distribution:
          (json['distribution'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(int.parse(k), (e as num).toInt()),
          ) ??
          const {},
    );

Map<String, dynamic> _$RatingAggregateToJson(_RatingAggregate instance) =>
    <String, dynamic>{
      'average': instance.average,
      'count': instance.count,
      'distribution': instance.distribution.map(
        (k, e) => MapEntry(k.toString(), e),
      ),
    };

_ReviewSubmissionRequest _$ReviewSubmissionRequestFromJson(
  Map<String, dynamic> json,
) => _ReviewSubmissionRequest(
  jobId: json['jobId'] as String,
  paymentId: json['paymentId'] as String,
  rating: (json['rating'] as num).toInt(),
  comment: json['comment'] as String,
);

Map<String, dynamic> _$ReviewSubmissionRequestToJson(
  _ReviewSubmissionRequest instance,
) => <String, dynamic>{
  'jobId': instance.jobId,
  'paymentId': instance.paymentId,
  'rating': instance.rating,
  'comment': instance.comment,
};

_ReviewModerationRequest _$ReviewModerationRequestFromJson(
  Map<String, dynamic> json,
) => _ReviewModerationRequest(
  reviewId: json['reviewId'] as String,
  action: $enumDecode(_$ReviewModerationStatusEnumMap, json['action']),
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$ReviewModerationRequestToJson(
  _ReviewModerationRequest instance,
) => <String, dynamic>{
  'reviewId': instance.reviewId,
  'action': _$ReviewModerationStatusEnumMap[instance.action]!,
  'reason': instance.reason,
};

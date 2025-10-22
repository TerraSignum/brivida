// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Job _$JobFromJson(Map<String, dynamic> json) => _Job(
  id: json['id'] as String?,
  customerUid: json['customerUid'] as String,
  assignedProUid: json['assignedProUid'] as String?,
  addressCity: json['addressCity'] as String?,
  addressDistrict: json['addressDistrict'] as String?,
  addressHint: json['addressHint'] as String?,
  hasPrivateLocation: json['hasPrivateLocation'] as bool? ?? false,
  sizeM2: (json['sizeM2'] as num).toDouble(),
  rooms: (json['rooms'] as num).toInt(),
  services: (json['services'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  window: JobWindow.fromJson(json['window'] as Map<String, dynamic>),
  budget: (json['budget'] as num).toDouble(),
  notes: json['notes'] as String? ?? '',
  status:
      $enumDecodeNullable(_$JobStatusEnumMap, json['status']) ?? JobStatus.open,
  visibleTo:
      (json['visibleTo'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  category:
      $enumDecodeNullable(_$JobCategoryEnumMap, json['category']) ??
      JobCategory.m,
  baseHours: (json['baseHours'] as num?)?.toDouble() ?? 3.0,
  extras:
      (json['extras'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  extrasHours: (json['extrasHours'] as num?)?.toDouble() ?? 0.0,
  materialProvidedByPro: json['materialProvidedByPro'] as bool? ?? false,
  materialFeeEur: (json['materialFeeEur'] as num?)?.toDouble() ?? 7.0,
  isExpress: json['isExpress'] as bool? ?? false,
  recurrence:
      json['recurrence'] as Map<String, dynamic>? ??
      const {'type': 'none', 'intervalDays': 0},
  occurrenceIndex: (json['occurrenceIndex'] as num?)?.toInt() ?? 1,
  parentJobId: json['parentJobId'] as String?,
  extraServices:
      (json['extraServices'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  materialsRequired: json['materialsRequired'] as bool? ?? false,
  checklist:
      (json['checklist'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  completedPhotos:
      (json['completedPhotos'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
  paymentId: json['paymentId'] as String?,
  transferId: json['transferId'] as String?,
  paymentStatus:
      $enumDecodeNullable(_$PaymentStatusEnumMap, json['paymentStatus']) ??
      PaymentStatus.none,
  paymentCreatedAt: const TimestampConverter().fromJson(
    json['paymentCreatedAt'],
  ),
  paymentCompletedAt: const TimestampConverter().fromJson(
    json['paymentCompletedAt'],
  ),
  paidAmount: (json['paidAmount'] as num?)?.toDouble(),
  currency: json['currency'] as String?,
  escrowReleased: json['escrowReleased'] as bool?,
  escrowReleasedAt: const TimestampConverter().fromJson(
    json['escrowReleasedAt'],
  ),
);

Map<String, dynamic> _$JobToJson(_Job instance) => <String, dynamic>{
  'id': instance.id,
  'customerUid': instance.customerUid,
  'assignedProUid': instance.assignedProUid,
  'addressCity': instance.addressCity,
  'addressDistrict': instance.addressDistrict,
  'addressHint': instance.addressHint,
  'hasPrivateLocation': instance.hasPrivateLocation,
  'sizeM2': instance.sizeM2,
  'rooms': instance.rooms,
  'services': instance.services,
  'window': instance.window,
  'budget': instance.budget,
  'notes': instance.notes,
  'status': _$JobStatusEnumMap[instance.status]!,
  'visibleTo': instance.visibleTo,
  'category': _$JobCategoryEnumMap[instance.category]!,
  'baseHours': instance.baseHours,
  'extras': instance.extras,
  'extrasHours': instance.extrasHours,
  'materialProvidedByPro': instance.materialProvidedByPro,
  'materialFeeEur': instance.materialFeeEur,
  'isExpress': instance.isExpress,
  'recurrence': instance.recurrence,
  'occurrenceIndex': instance.occurrenceIndex,
  'parentJobId': instance.parentJobId,
  'extraServices': instance.extraServices,
  'materialsRequired': instance.materialsRequired,
  'checklist': instance.checklist,
  'completedPhotos': instance.completedPhotos,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
  'paymentId': instance.paymentId,
  'transferId': instance.transferId,
  'paymentStatus': _$PaymentStatusEnumMap[instance.paymentStatus]!,
  'paymentCreatedAt': const TimestampConverter().toJson(
    instance.paymentCreatedAt,
  ),
  'paymentCompletedAt': const TimestampConverter().toJson(
    instance.paymentCompletedAt,
  ),
  'paidAmount': instance.paidAmount,
  'currency': instance.currency,
  'escrowReleased': instance.escrowReleased,
  'escrowReleasedAt': const TimestampConverter().toJson(
    instance.escrowReleasedAt,
  ),
};

const _$JobStatusEnumMap = {
  JobStatus.open: 'open',
  JobStatus.assigned: 'assigned',
  JobStatus.completed: 'completed',
  JobStatus.cancelled: 'cancelled',
};

const _$JobCategoryEnumMap = {
  JobCategory.s: 'S',
  JobCategory.m: 'M',
  JobCategory.l: 'L',
  JobCategory.xl: 'XL',
  JobCategory.gt250: 'GT250',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.none: 'none',
  PaymentStatus.pending: 'pending',
  PaymentStatus.captured: 'captured',
  PaymentStatus.transferred: 'transferred',
  PaymentStatus.refunded: 'refunded',
  PaymentStatus.failed: 'failed',
};

_GeoLocation _$GeoLocationFromJson(Map<String, dynamic> json) => _GeoLocation(
  lat: (json['lat'] as num).toDouble(),
  lng: (json['lng'] as num).toDouble(),
);

Map<String, dynamic> _$GeoLocationToJson(_GeoLocation instance) =>
    <String, dynamic>{'lat': instance.lat, 'lng': instance.lng};

_JobPrivate _$JobPrivateFromJson(Map<String, dynamic> json) => _JobPrivate(
  jobId: json['jobId'] as String,
  addressText: json['addressText'] as String,
  addressFormatted: json['addressFormatted'] as String,
  location: GeoLocation.fromJson(json['location'] as Map<String, dynamic>),
  entranceNotes: json['entranceNotes'] as String?,
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
);

Map<String, dynamic> _$JobPrivateToJson(_JobPrivate instance) =>
    <String, dynamic>{
      'jobId': instance.jobId,
      'addressText': instance.addressText,
      'addressFormatted': instance.addressFormatted,
      'location': instance.location,
      'entranceNotes': instance.entranceNotes,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };

_JobWindow _$JobWindowFromJson(Map<String, dynamic> json) => _JobWindow(
  start: DateTime.parse(json['start'] as String),
  end: DateTime.parse(json['end'] as String),
);

Map<String, dynamic> _$JobWindowToJson(_JobWindow instance) =>
    <String, dynamic>{
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
    };

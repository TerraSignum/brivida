// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CalendarLocation _$CalendarLocationFromJson(Map<String, dynamic> json) =>
    _CalendarLocation(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      address: json['address'] as String,
    );

Map<String, dynamic> _$CalendarLocationToJson(_CalendarLocation instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
      'address': instance.address,
    };

_CalendarEvent _$CalendarEventFromJson(Map<String, dynamic> json) =>
    _CalendarEvent(
      id: json['id'] as String?,
      ownerUid: json['ownerUid'] as String,
      type: $enumDecode(_$EventTypeEnumMap, json['type']),
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      start: DateTime.parse(json['start'] as String),
      end: DateTime.parse(json['end'] as String),
      rrule: json['rrule'] as String?,
      location: json['location'] == null
          ? null
          : CalendarLocation.fromJson(json['location'] as Map<String, dynamic>),
      bufferBefore: (json['bufferBefore'] as num?)?.toInt() ?? 0,
      bufferAfter: (json['bufferAfter'] as num?)?.toInt() ?? 0,
      visibility:
          $enumDecodeNullable(_$EventVisibilityEnumMap, json['visibility']) ??
          EventVisibility.busy,
      jobId: json['jobId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CalendarEventToJson(_CalendarEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ownerUid': instance.ownerUid,
      'type': _$EventTypeEnumMap[instance.type]!,
      'title': instance.title,
      'description': instance.description,
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
      'rrule': instance.rrule,
      'location': instance.location,
      'bufferBefore': instance.bufferBefore,
      'bufferAfter': instance.bufferAfter,
      'visibility': _$EventVisibilityEnumMap[instance.visibility]!,
      'jobId': instance.jobId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$EventTypeEnumMap = {
  EventType.job: 'job',
  EventType.private: 'private',
  EventType.availability: 'availability',
};

const _$EventVisibilityEnumMap = {
  EventVisibility.private: 'private',
  EventVisibility.busy: 'busy',
};

_ConflictResult _$ConflictResultFromJson(Map<String, dynamic> json) =>
    _ConflictResult(
      hasConflict: json['hasConflict'] as bool,
      isHard: json['isHard'] as bool,
      message: json['message'] as String?,
      code:
          $enumDecodeNullable(_$CalendarConflictCodeEnumMap, json['code']) ??
          CalendarConflictCode.unknown,
      conflictingEvent: json['conflictingEvent'] == null
          ? null
          : CalendarEvent.fromJson(
              json['conflictingEvent'] as Map<String, dynamic>,
            ),
      missingMinutes: (json['missingMinutes'] as num?)?.toInt(),
      actualGapMinutes: (json['actualGapMinutes'] as num?)?.toInt(),
      requiredGapMinutes: (json['requiredGapMinutes'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ConflictResultToJson(_ConflictResult instance) =>
    <String, dynamic>{
      'hasConflict': instance.hasConflict,
      'isHard': instance.isHard,
      'message': instance.message,
      'code': _$CalendarConflictCodeEnumMap[instance.code]!,
      'conflictingEvent': instance.conflictingEvent,
      'missingMinutes': instance.missingMinutes,
      'actualGapMinutes': instance.actualGapMinutes,
      'requiredGapMinutes': instance.requiredGapMinutes,
    };

const _$CalendarConflictCodeEnumMap = {
  CalendarConflictCode.directOverlap: 'directOverlap',
  CalendarConflictCode.insufficientGap: 'insufficientGap',
  CalendarConflictCode.softGap: 'softGap',
  CalendarConflictCode.validationError: 'validationError',
  CalendarConflictCode.etaFallback: 'etaFallback',
  CalendarConflictCode.unknown: 'unknown',
};

_EtaRequest _$EtaRequestFromJson(Map<String, dynamic> json) => _EtaRequest(
  origin: CalendarLocation.fromJson(json['origin'] as Map<String, dynamic>),
  destination: CalendarLocation.fromJson(
    json['destination'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$EtaRequestToJson(_EtaRequest instance) =>
    <String, dynamic>{
      'origin': instance.origin,
      'destination': instance.destination,
    };

_EtaResult _$EtaResultFromJson(Map<String, dynamic> json) => _EtaResult(
  minutes: (json['minutes'] as num).toInt(),
  fromCache: json['fromCache'] as bool? ?? false,
);

Map<String, dynamic> _$EtaResultToJson(_EtaResult instance) =>
    <String, dynamic>{
      'minutes': instance.minutes,
      'fromCache': instance.fromCache,
    };

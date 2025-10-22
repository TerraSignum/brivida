import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'calendar_event.freezed.dart';
part 'calendar_event.g.dart';

enum EventType { job, private, availability }

enum EventVisibility { private, busy }

enum CalendarConflictCode {
  directOverlap,
  insufficientGap,
  softGap,
  validationError,
  etaFallback,
  unknown,
}

@freezed
abstract class CalendarLocation with _$CalendarLocation {
  const factory CalendarLocation({
    required double lat,
    required double lng,
    required String address, // Human-readable address
  }) = _CalendarLocation;

  factory CalendarLocation.fromJson(Map<String, dynamic> json) =>
      _$CalendarLocationFromJson(json);
}

@freezed
abstract class CalendarEvent with _$CalendarEvent {
  const factory CalendarEvent({
    String? id,
    required String ownerUid,
    required EventType type,
    @Default('') String title, // Event title/name
    String? description, // Optional description
    required DateTime start,
    required DateTime end,
    String? rrule, // RRULE string for recurring events
    CalendarLocation? location,
    @Default(0) int bufferBefore, // Minutes
    @Default(0) int bufferAfter, // Minutes
    @Default(EventVisibility.busy) EventVisibility visibility,
    String? jobId, // Required for job events
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _CalendarEvent;

  factory CalendarEvent.fromJson(Map<String, dynamic> json) =>
      _$CalendarEventFromJson(json);

  factory CalendarEvent.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final startTimestamp = (data['start'] as Timestamp?)?.toDate();
    final endTimestamp = (data['end'] as Timestamp?)?.toDate();
    final createdTimestamp = (data['createdAt'] as Timestamp?)?.toDate();
    final updatedTimestamp = (data['updatedAt'] as Timestamp?)?.toDate();
    return CalendarEvent.fromJson({
      ...data,
      'id': doc.id,
      'start': (startTimestamp ?? DateTime.now()).toIso8601String(),
      'end': (endTimestamp ?? DateTime.now()).toIso8601String(),
      'createdAt': (createdTimestamp ?? DateTime.now()).toIso8601String(),
      'updatedAt': updatedTimestamp?.toIso8601String(),
    });
  }
}

extension CalendarEventFirestore on CalendarEvent {
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id'); // Don't store ID in the document
    // Convert DateTime to Timestamp
    json['start'] = Timestamp.fromDate(start);
    json['end'] = Timestamp.fromDate(end);
    json['createdAt'] = Timestamp.fromDate(createdAt);
    if (updatedAt != null) {
      json['updatedAt'] = Timestamp.fromDate(updatedAt!);
    }
    return json;
  }
}

// Helper class for conflict detection
@freezed
abstract class ConflictResult with _$ConflictResult {
  const factory ConflictResult({
    required bool hasConflict,
    required bool isHard, // true = blocking, false = warning
    String? message,
    @Default(CalendarConflictCode.unknown) CalendarConflictCode code,
    CalendarEvent? conflictingEvent,
    int? missingMinutes, // How many minutes short for buffer/ETA
    int? actualGapMinutes,
    int? requiredGapMinutes,
  }) = _ConflictResult;

  factory ConflictResult.fromJson(Map<String, dynamic> json) =>
      _$ConflictResultFromJson(json);
}

// Helper class for ETA calculations
@freezed
abstract class EtaRequest with _$EtaRequest {
  const factory EtaRequest({
    required CalendarLocation origin,
    required CalendarLocation destination,
  }) = _EtaRequest;

  factory EtaRequest.fromJson(Map<String, dynamic> json) =>
      _$EtaRequestFromJson(json);
}

@freezed
abstract class EtaResult with _$EtaResult {
  const factory EtaResult({
    required int minutes,
    @Default(false) bool fromCache,
  }) = _EtaResult;

  factory EtaResult.fromJson(Map<String, dynamic> json) =>
      _$EtaResultFromJson(json);
}

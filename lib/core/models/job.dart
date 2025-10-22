import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'job.freezed.dart';
part 'job.g.dart';

// PG-17/18: Job category enums
enum JobCategory {
  @JsonValue('S')
  s,
  @JsonValue('M')
  m,
  @JsonValue('L')
  l,
  @JsonValue('XL')
  xl,
  @JsonValue('GT250')
  gt250,
}

enum RecurrenceType {
  @JsonValue('none')
  none,
  @JsonValue('weekly')
  weekly,
  @JsonValue('biweekly')
  biweekly,
  @JsonValue('monthly')
  monthly,
}

@freezed
abstract class Job with _$Job {
  const factory Job({
    String? id,
    required String customerUid,
    String? assignedProUid,

    // PG-14: Public address fields (visible to all)
    String? addressCity,
    String? addressDistrict,
    String? addressHint,
    @Default(false) bool hasPrivateLocation,

    // PG-17/18: Enhanced job fields
    required double sizeM2,
    required int rooms,
    required List<String> services,
    required JobWindow window,
    required double budget,
    @Default('') String notes,
    @Default(JobStatus.open) JobStatus status,
    @Default([]) List<String> visibleTo,

    // PG-17/18: New pricing and service fields
    @Default(JobCategory.m) JobCategory category,
    @Default(3.0) double baseHours,
    @Default([]) List<String> extras, // ExtraId strings
    @Default(0.0) double extrasHours,
    @Default(false) bool materialProvidedByPro,
    @Default(7.0) double materialFeeEur,
    @Default(false) bool isExpress,

    // PG-17: Recurring jobs
    @Default({'type': 'none', 'intervalDays': 0})
    Map<String, dynamic> recurrence,
    @Default(1) int occurrenceIndex,
    String? parentJobId, // For recurring instances
    // PG-17: Extra features
    @Default([]) List<String> extraServices,
    @Default(false) bool materialsRequired,
    @Default([]) List<String> checklist,
    @Default([]) List<String> completedPhotos, // Storage URLs
    // Timestamps
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,

    // Payment-related fields
    String? paymentId,
    String? transferId,
    @Default(PaymentStatus.none) PaymentStatus paymentStatus,
    @TimestampConverter() DateTime? paymentCreatedAt,
    @TimestampConverter() DateTime? paymentCompletedAt,
    double? paidAmount,
    String? currency,
    bool? escrowReleased,
    @TimestampConverter() DateTime? escrowReleasedAt,
  }) = _Job;

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);
}

@freezed
abstract class GeoLocation with _$GeoLocation {
  const factory GeoLocation({required double lat, required double lng}) =
      _GeoLocation;

  factory GeoLocation.fromJson(Map<String, dynamic> json) =>
      _$GeoLocationFromJson(json);
}

// NEW PG-14: Private job location data
@freezed
abstract class JobPrivate with _$JobPrivate {
  const factory JobPrivate({
    required String jobId,
    required String addressText,
    required String addressFormatted,
    required GeoLocation location,
    String? entranceNotes,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
  }) = _JobPrivate;

  factory JobPrivate.fromJson(Map<String, dynamic> json) =>
      _$JobPrivateFromJson(json);
}

@freezed
abstract class JobWindow with _$JobWindow {
  const factory JobWindow({
    @TimestampConverter() required DateTime start,
    @TimestampConverter() required DateTime end,
  }) = _JobWindow;

  factory JobWindow.fromJson(Map<String, dynamic> json) =>
      _$JobWindowFromJson(json);
}

enum JobStatus {
  @JsonValue('open')
  open,
  @JsonValue('assigned')
  assigned,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

enum PaymentStatus {
  @JsonValue('none')
  none,
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

import 'package:freezed_annotation/freezed_annotation.dart';
import 'job.dart'; // Import for TimestampConverter

part 'lead.freezed.dart';
part 'lead.g.dart';

@freezed
abstract class Lead with _$Lead {
  const factory Lead({
    String? id,
    required String jobId,
    required String customerUid,
    required String proUid,
    @Default('') String message,
    @Default(LeadStatus.pending) LeadStatus status,
    @TimestampConverter() DateTime? acceptedAt,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
  }) = _Lead;

  factory Lead.fromJson(Map<String, dynamic> json) => _$LeadFromJson(json);
}

enum LeadStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('accepted')
  accepted,
  @JsonValue('declined')
  declined,
}

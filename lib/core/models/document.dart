import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'document.freezed.dart';
part 'document.g.dart';

enum DocumentType {
  @JsonValue('id_card')
  idCard,
  @JsonValue('passport')
  passport,
  @JsonValue('drivers_license')
  driversLicense,
  @JsonValue('criminal_record')
  criminalRecord,
  @JsonValue('insurance_certificate')
  insuranceCertificate,
  @JsonValue('training_certificate')
  trainingCertificate,
  @JsonValue('business_license')
  businessLicense,
  @JsonValue('tax_certificate')
  taxCertificate,
}

enum DocumentStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('reviewing')
  reviewing,
  @JsonValue('approved')
  approved,
  @JsonValue('rejected')
  rejected,
  @JsonValue('expired')
  expired,
}

/// PG-17: Document verification model for pro identity and credentials
@freezed
abstract class Document with _$Document {
  const factory Document({
    String? id,
    required String proUid,
    required DocumentType type,
    required String fileName,
    required String storageUrl,
    String? storagePath,
    @Default(DocumentStatus.pending) DocumentStatus status,
    String? rejectionReason,
    DateTime? expiryDate,

    // Review metadata
    String? reviewedBy,
    @TimestampConverter() DateTime? reviewedAt,
    String? reviewNotes,

    // Upload metadata
    @Default(0) int fileSize,
    String? mimeType,
    @TimestampConverter() DateTime? uploadedAt,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
  }) = _Document;

  factory Document.fromJson(Map<String, dynamic> json) =>
      _$DocumentFromJson(json);
}

/// Timestamp converter for Firestore
class TimestampConverter implements JsonConverter<DateTime?, Object?> {
  const TimestampConverter();

  @override
  DateTime? fromJson(Object? json) {
    if (json is Timestamp) {
      return json.toDate();
    }
    if (json is String) {
      return DateTime.tryParse(json);
    }
    return null;
  }

  @override
  Object? toJson(DateTime? object) {
    return object != null ? Timestamp.fromDate(object) : null;
  }
}

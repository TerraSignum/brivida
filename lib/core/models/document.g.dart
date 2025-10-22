// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Document _$DocumentFromJson(Map<String, dynamic> json) => _Document(
  id: json['id'] as String?,
  proUid: json['proUid'] as String,
  type: $enumDecode(_$DocumentTypeEnumMap, json['type']),
  fileName: json['fileName'] as String,
  storageUrl: json['storageUrl'] as String,
  storagePath: json['storagePath'] as String?,
  status:
      $enumDecodeNullable(_$DocumentStatusEnumMap, json['status']) ??
      DocumentStatus.pending,
  rejectionReason: json['rejectionReason'] as String?,
  expiryDate: json['expiryDate'] == null
      ? null
      : DateTime.parse(json['expiryDate'] as String),
  reviewedBy: json['reviewedBy'] as String?,
  reviewedAt: const TimestampConverter().fromJson(json['reviewedAt']),
  reviewNotes: json['reviewNotes'] as String?,
  fileSize: (json['fileSize'] as num?)?.toInt() ?? 0,
  mimeType: json['mimeType'] as String?,
  uploadedAt: const TimestampConverter().fromJson(json['uploadedAt']),
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
);

Map<String, dynamic> _$DocumentToJson(_Document instance) => <String, dynamic>{
  'id': instance.id,
  'proUid': instance.proUid,
  'type': _$DocumentTypeEnumMap[instance.type]!,
  'fileName': instance.fileName,
  'storageUrl': instance.storageUrl,
  'storagePath': instance.storagePath,
  'status': _$DocumentStatusEnumMap[instance.status]!,
  'rejectionReason': instance.rejectionReason,
  'expiryDate': instance.expiryDate?.toIso8601String(),
  'reviewedBy': instance.reviewedBy,
  'reviewedAt': const TimestampConverter().toJson(instance.reviewedAt),
  'reviewNotes': instance.reviewNotes,
  'fileSize': instance.fileSize,
  'mimeType': instance.mimeType,
  'uploadedAt': const TimestampConverter().toJson(instance.uploadedAt),
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
};

const _$DocumentTypeEnumMap = {
  DocumentType.idCard: 'id_card',
  DocumentType.passport: 'passport',
  DocumentType.driversLicense: 'drivers_license',
  DocumentType.criminalRecord: 'criminal_record',
  DocumentType.insuranceCertificate: 'insurance_certificate',
  DocumentType.trainingCertificate: 'training_certificate',
  DocumentType.businessLicense: 'business_license',
  DocumentType.taxCertificate: 'tax_certificate',
};

const _$DocumentStatusEnumMap = {
  DocumentStatus.pending: 'pending',
  DocumentStatus.reviewing: 'reviewing',
  DocumentStatus.approved: 'approved',
  DocumentStatus.rejected: 'rejected',
  DocumentStatus.expired: 'expired',
};

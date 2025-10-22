// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PayoutFilter _$PayoutFilterFromJson(Map<String, dynamic> json) =>
    _PayoutFilter(
      from: json['from'] == null
          ? null
          : DateTime.parse(json['from'] as String),
      to: json['to'] == null ? null : DateTime.parse(json['to'] as String),
      status: json['status'] as String?,
    );

Map<String, dynamic> _$PayoutFilterToJson(_PayoutFilter instance) =>
    <String, dynamic>{
      'from': instance.from?.toIso8601String(),
      'to': instance.to?.toIso8601String(),
      'status': instance.status,
    };

_ExportRequest _$ExportRequestFromJson(Map<String, dynamic> json) =>
    _ExportRequest(
      from: json['from'] == null
          ? null
          : DateTime.parse(json['from'] as String),
      to: json['to'] == null ? null : DateTime.parse(json['to'] as String),
      kind: json['kind'] as String? ?? 'transfers',
    );

Map<String, dynamic> _$ExportRequestToJson(_ExportRequest instance) =>
    <String, dynamic>{
      'from': instance.from?.toIso8601String(),
      'to': instance.to?.toIso8601String(),
      'kind': instance.kind,
    };

_ExportResult _$ExportResultFromJson(Map<String, dynamic> json) =>
    _ExportResult(
      downloadUrl: json['downloadUrl'] as String,
      filename: json['filename'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );

Map<String, dynamic> _$ExportResultToJson(_ExportResult instance) =>
    <String, dynamic>{
      'downloadUrl': instance.downloadUrl,
      'filename': instance.filename,
      'expiresAt': instance.expiresAt.toIso8601String(),
    };

_TransferStats _$TransferStatsFromJson(Map<String, dynamic> json) =>
    _TransferStats(
      totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
      totalAmountNet: (json['totalAmountNet'] as num?)?.toDouble() ?? 0.0,
      totalAmountGross: (json['totalAmountGross'] as num?)?.toDouble() ?? 0.0,
      totalPlatformFees: (json['totalPlatformFees'] as num?)?.toDouble() ?? 0.0,
      pendingCount: (json['pendingCount'] as num?)?.toInt() ?? 0,
      completedCount: (json['completedCount'] as num?)?.toInt() ?? 0,
      failedCount: (json['failedCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$TransferStatsToJson(_TransferStats instance) =>
    <String, dynamic>{
      'totalCount': instance.totalCount,
      'totalAmountNet': instance.totalAmountNet,
      'totalAmountGross': instance.totalAmountGross,
      'totalPlatformFees': instance.totalPlatformFees,
      'pendingCount': instance.pendingCount,
      'completedCount': instance.completedCount,
      'failedCount': instance.failedCount,
    };

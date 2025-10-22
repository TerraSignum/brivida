// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HealthScore _$HealthScoreFromJson(Map<String, dynamic> json) => _HealthScore(
  score: (json['score'] as num?)?.toDouble() ?? 0.0,
  noShowRate: (json['noShowRate'] as num?)?.toDouble() ?? 0.0,
  cancelRate: (json['cancelRate'] as num?)?.toDouble() ?? 0.0,
  avgResponseMins: (json['avgResponseMins'] as num?)?.toDouble() ?? 0.0,
  inAppRatio: (json['inAppRatio'] as num?)?.toDouble() ?? 0.0,
  ratingAvg: (json['ratingAvg'] as num?)?.toDouble() ?? 0.0,
  ratingCount: (json['ratingCount'] as num?)?.toInt() ?? 0,
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$HealthScoreToJson(_HealthScore instance) =>
    <String, dynamic>{
      'score': instance.score,
      'noShowRate': instance.noShowRate,
      'cancelRate': instance.cancelRate,
      'avgResponseMins': instance.avgResponseMins,
      'inAppRatio': instance.inAppRatio,
      'ratingAvg': instance.ratingAvg,
      'ratingCount': instance.ratingCount,
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

_ProFlags _$ProFlagsFromJson(Map<String, dynamic> json) => _ProFlags(
  softBanned: json['softBanned'] as bool? ?? false,
  hardBanned: json['hardBanned'] as bool? ?? false,
  notes: json['notes'] as String? ?? '',
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$ProFlagsToJson(_ProFlags instance) => <String, dynamic>{
  'softBanned': instance.softBanned,
  'hardBanned': instance.hardBanned,
  'notes': instance.notes,
  'updatedAt': instance.updatedAt?.toIso8601String(),
};

_AbuseEvent _$AbuseEventFromJson(Map<String, dynamic> json) => _AbuseEvent(
  id: json['id'] as String,
  type: $enumDecode(_$AbuseEventTypeEnumMap, json['type']),
  userUid: json['userUid'] as String,
  jobId: json['jobId'] as String?,
  weight: (json['weight'] as num?)?.toDouble() ?? 1.0,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  description: json['description'] as String?,
  reportedBy: json['reportedBy'] as String?,
);

Map<String, dynamic> _$AbuseEventToJson(_AbuseEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$AbuseEventTypeEnumMap[instance.type]!,
      'userUid': instance.userUid,
      'jobId': instance.jobId,
      'weight': instance.weight,
      'createdAt': instance.createdAt?.toIso8601String(),
      'description': instance.description,
      'reportedBy': instance.reportedBy,
    };

const _$AbuseEventTypeEnumMap = {
  AbuseEventType.contactDrop: 'contactDrop',
  AbuseEventType.offPlatform: 'offPlatform',
  AbuseEventType.spam: 'spam',
  AbuseEventType.abuse: 'abuse',
  AbuseEventType.noShow: 'noShow',
  AbuseEventType.lateCancel: 'lateCancel',
};

_AdminLog _$AdminLogFromJson(Map<String, dynamic> json) => _AdminLog(
  id: json['id'] as String,
  actorUid: json['actorUid'] as String,
  action: $enumDecode(_$AdminActionEnumMap, json['action']),
  targetType: json['targetType'] as String,
  targetId: json['targetId'] as String,
  before: json['before'] as Map<String, dynamic>?,
  after: json['after'] as Map<String, dynamic>?,
  notes: json['notes'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$AdminLogToJson(_AdminLog instance) => <String, dynamic>{
  'id': instance.id,
  'actorUid': instance.actorUid,
  'action': _$AdminActionEnumMap[instance.action]!,
  'targetType': instance.targetType,
  'targetId': instance.targetId,
  'before': instance.before,
  'after': instance.after,
  'notes': instance.notes,
  'createdAt': instance.createdAt?.toIso8601String(),
};

const _$AdminActionEnumMap = {
  AdminAction.setFlag: 'setFlag',
  AdminAction.addBadge: 'addBadge',
  AdminAction.removeBadge: 'removeBadge',
  AdminAction.recalcHealth: 'recalcHealth',
  AdminAction.exportCsv: 'exportCsv',
  AdminAction.banUser: 'banUser',
  AdminAction.unbanUser: 'unbanUser',
  AdminAction.verifyUser: 'verifyUser',
  AdminAction.moderateDispute: 'moderateDispute',
};

_AdminKpiData _$AdminKpiDataFromJson(Map<String, dynamic> json) =>
    _AdminKpiData(
      activePros: (json['activePros'] as num?)?.toInt() ?? 0,
      openDisputes: (json['openDisputes'] as num?)?.toInt() ?? 0,
      capturedPayments24h:
          (json['capturedPayments24h'] as num?)?.toDouble() ?? 0.0,
      refunds24h: (json['refunds24h'] as num?)?.toDouble() ?? 0.0,
      newUsers24h: (json['newUsers24h'] as num?)?.toInt() ?? 0,
      completedJobs24h: (json['completedJobs24h'] as num?)?.toInt() ?? 0,
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$AdminKpiDataToJson(_AdminKpiData instance) =>
    <String, dynamic>{
      'activePros': instance.activePros,
      'openDisputes': instance.openDisputes,
      'capturedPayments24h': instance.capturedPayments24h,
      'refunds24h': instance.refunds24h,
      'newUsers24h': instance.newUsers24h,
      'completedJobs24h': instance.completedJobs24h,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
    };

_AdminFilter _$AdminFilterFromJson(Map<String, dynamic> json) => _AdminFilter(
  dateFrom: json['dateFrom'] == null
      ? null
      : DateTime.parse(json['dateFrom'] as String),
  dateTo: json['dateTo'] == null
      ? null
      : DateTime.parse(json['dateTo'] as String),
  status: json['status'] as String?,
  searchQuery: json['searchQuery'] as String?,
  sortBy: json['sortBy'] as String?,
  sortAsc: json['sortAsc'] as bool? ?? false,
);

Map<String, dynamic> _$AdminFilterToJson(_AdminFilter instance) =>
    <String, dynamic>{
      'dateFrom': instance.dateFrom?.toIso8601String(),
      'dateTo': instance.dateTo?.toIso8601String(),
      'status': instance.status,
      'searchQuery': instance.searchQuery,
      'sortBy': instance.sortBy,
      'sortAsc': instance.sortAsc,
    };

_ExportResult _$ExportResultFromJson(Map<String, dynamic> json) =>
    _ExportResult(
      downloadUrl: json['downloadUrl'] as String,
      fileName: json['fileName'] as String,
      expiresInMinutes: (json['expiresInMinutes'] as num?)?.toInt() ?? 60,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ExportResultToJson(_ExportResult instance) =>
    <String, dynamic>{
      'downloadUrl': instance.downloadUrl,
      'fileName': instance.fileName,
      'expiresInMinutes': instance.expiresInMinutes,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

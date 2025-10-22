// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AnalyticsEvent _$AnalyticsEventFromJson(Map<String, dynamic> json) =>
    _AnalyticsEvent(
      id: json['id'] as String,
      uid: json['uid'] as String?,
      role: json['role'] as String?,
      ts: DateTime.parse(json['ts'] as String),
      src: json['src'] as String,
      name: json['name'] as String,
      props: json['props'] as Map<String, dynamic>,
      context: json['context'] as Map<String, dynamic>,
      sessionId: json['sessionId'] as String,
    );

Map<String, dynamic> _$AnalyticsEventToJson(_AnalyticsEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'role': instance.role,
      'ts': instance.ts.toIso8601String(),
      'src': instance.src,
      'name': instance.name,
      'props': instance.props,
      'context': instance.context,
      'sessionId': instance.sessionId,
    };

_AnalyticsDaily _$AnalyticsDailyFromJson(Map<String, dynamic> json) =>
    _AnalyticsDaily(
      date: json['date'] as String,
      kpis: AnalyticsKpis.fromJson(json['kpis'] as Map<String, dynamic>),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$AnalyticsDailyToJson(_AnalyticsDaily instance) =>
    <String, dynamic>{
      'date': instance.date,
      'kpis': instance.kpis,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_AnalyticsKpis _$AnalyticsKpisFromJson(
  Map<String, dynamic> json,
) => _AnalyticsKpis(
  jobsCreated: (json['jobsCreated'] as num?)?.toInt() ?? 0,
  leadsCreated: (json['leadsCreated'] as num?)?.toInt() ?? 0,
  leadsAccepted: (json['leadsAccepted'] as num?)?.toInt() ?? 0,
  paymentsCapturedEur: (json['paymentsCapturedEur'] as num?)?.toDouble() ?? 0.0,
  paymentsReleasedEur: (json['paymentsReleasedEur'] as num?)?.toDouble() ?? 0.0,
  refundsEur: (json['refundsEur'] as num?)?.toDouble() ?? 0.0,
  chatMessages: (json['chatMessages'] as num?)?.toInt() ?? 0,
  activePros: (json['activePros'] as num?)?.toInt() ?? 0,
  activeCustomers: (json['activeCustomers'] as num?)?.toInt() ?? 0,
  newUsers: (json['newUsers'] as num?)?.toInt() ?? 0,
  disputesOpened: (json['disputesOpened'] as num?)?.toInt() ?? 0,
  disputesResolved: (json['disputesResolved'] as num?)?.toInt() ?? 0,
  avgRating: (json['avgRating'] as num?)?.toDouble() ?? 0.0,
  ratingsCount: (json['ratingsCount'] as num?)?.toInt() ?? 0,
  pushDelivered: (json['pushDelivered'] as num?)?.toInt() ?? 0,
  pushOpened: (json['pushOpened'] as num?)?.toInt() ?? 0,
  pushOpenRate: (json['pushOpenRate'] as num?)?.toDouble() ?? 0.0,
);

Map<String, dynamic> _$AnalyticsKpisToJson(_AnalyticsKpis instance) =>
    <String, dynamic>{
      'jobsCreated': instance.jobsCreated,
      'leadsCreated': instance.leadsCreated,
      'leadsAccepted': instance.leadsAccepted,
      'paymentsCapturedEur': instance.paymentsCapturedEur,
      'paymentsReleasedEur': instance.paymentsReleasedEur,
      'refundsEur': instance.refundsEur,
      'chatMessages': instance.chatMessages,
      'activePros': instance.activePros,
      'activeCustomers': instance.activeCustomers,
      'newUsers': instance.newUsers,
      'disputesOpened': instance.disputesOpened,
      'disputesResolved': instance.disputesResolved,
      'avgRating': instance.avgRating,
      'ratingsCount': instance.ratingsCount,
      'pushDelivered': instance.pushDelivered,
      'pushOpened': instance.pushOpened,
      'pushOpenRate': instance.pushOpenRate,
    };

_AnalyticsExportRequest _$AnalyticsExportRequestFromJson(
  Map<String, dynamic> json,
) => _AnalyticsExportRequest(
  type: json['type'] as String,
  dateFrom: json['dateFrom'] as String?,
  dateTo: json['dateTo'] as String?,
);

Map<String, dynamic> _$AnalyticsExportRequestToJson(
  _AnalyticsExportRequest instance,
) => <String, dynamic>{
  'type': instance.type,
  'dateFrom': instance.dateFrom,
  'dateTo': instance.dateTo,
};

_AnalyticsContext _$AnalyticsContextFromJson(Map<String, dynamic> json) =>
    _AnalyticsContext(
      platform: json['platform'] as String,
      appVersion: json['appVersion'] as String,
      ipHash: json['ipHash'] as String?,
      uaHash: json['uaHash'] as String?,
    );

Map<String, dynamic> _$AnalyticsContextToJson(_AnalyticsContext instance) =>
    <String, dynamic>{
      'platform': instance.platform,
      'appVersion': instance.appVersion,
      'ipHash': instance.ipHash,
      'uaHash': instance.uaHash,
    };

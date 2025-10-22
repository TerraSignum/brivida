import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'admin.freezed.dart';
part 'admin.g.dart';

// ========================================
// HEALTH SCORE & BADGES
// ========================================

@freezed
abstract class HealthScore with _$HealthScore {
  const HealthScore._();

  const factory HealthScore({
    @Default(0.0) double score, // 0-100
    @Default(0.0) double noShowRate, // 0-1
    @Default(0.0) double cancelRate, // 0-1
    @Default(0.0) double avgResponseMins, // Minutes
    @Default(0.0) double inAppRatio, // 0-1
    @Default(0.0) double ratingAvg, // 0-5
    @Default(0) int ratingCount,
    DateTime? updatedAt,
  }) = _HealthScore;

  factory HealthScore.fromJson(Map<String, dynamic> json) =>
      _$HealthScoreFromJson(json);

  // Firestore conversion helpers
  factory HealthScore.fromFirestore(Map<String, dynamic> data) {
    return HealthScore(
      score: (data['score'] as num?)?.toDouble() ?? 0.0,
      noShowRate: (data['noShowRate'] as num?)?.toDouble() ?? 0.0,
      cancelRate: (data['cancelRate'] as num?)?.toDouble() ?? 0.0,
      avgResponseMins: (data['avgResponseMins'] as num?)?.toDouble() ?? 0.0,
      inAppRatio: (data['inAppRatio'] as num?)?.toDouble() ?? 0.0,
      ratingAvg: (data['ratingAvg'] as num?)?.toDouble() ?? 0.0,
      ratingCount: (data['ratingCount'] as num?)?.toInt() ?? 0,
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'score': score,
      'noShowRate': noShowRate,
      'cancelRate': cancelRate,
      'avgResponseMins': avgResponseMins,
      'inAppRatio': inAppRatio,
      'ratingAvg': ratingAvg,
      'ratingCount': ratingCount,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }
}

enum ProBadge {
  verified,
  topRated,
  fastResponder,
  reliable,
  premium;

  String get displayName {
    switch (this) {
      case ProBadge.verified:
        return 'Verifiziert';
      case ProBadge.topRated:
        return 'Top-Bewertet';
      case ProBadge.fastResponder:
        return 'Schnell-Antwortend';
      case ProBadge.reliable:
        return 'Zuverlässig';
      case ProBadge.premium:
        return 'Premium';
    }
  }

  String get description {
    switch (this) {
      case ProBadge.verified:
        return 'ID und Qualifikationen verifiziert';
      case ProBadge.topRated:
        return 'Durchschnittlich 4.8+ Sterne, 20+ Bewertungen';
      case ProBadge.fastResponder:
        return 'Antwortet binnen 15 Minuten';
      case ProBadge.reliable:
        return 'Weniger als 2% No-Shows';
      case ProBadge.premium:
        return 'Premium-Service Partner';
    }
  }

  int get rankingBoost {
    switch (this) {
      case ProBadge.verified:
        return 5;
      case ProBadge.topRated:
        return 5;
      case ProBadge.fastResponder:
        return 3;
      case ProBadge.reliable:
        return 3;
      case ProBadge.premium:
        return 10;
    }
  }
}

extension ProBadgeList on List<ProBadge> {
  int get totalRankingBoost =>
      fold(0, (currentSum, badge) => currentSum + badge.rankingBoost);
}

@freezed
abstract class ProFlags with _$ProFlags {
  const ProFlags._();

  const factory ProFlags({
    @Default(false) bool softBanned,
    @Default(false) bool hardBanned,
    @Default('') String notes,
    DateTime? updatedAt,
  }) = _ProFlags;

  factory ProFlags.fromJson(Map<String, dynamic> json) =>
      _$ProFlagsFromJson(json);

  factory ProFlags.fromFirestore(Map<String, dynamic> data) {
    return ProFlags(
      softBanned: data['softBanned'] as bool? ?? false,
      hardBanned: data['hardBanned'] as bool? ?? false,
      notes: data['notes'] as String? ?? '',
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'softBanned': softBanned,
      'hardBanned': hardBanned,
      'notes': notes,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }
}

// ========================================
// ABUSE EVENTS
// ========================================

enum AbuseEventType {
  contactDrop,
  offPlatform,
  spam,
  abuse,
  noShow,
  lateCancel;

  String get displayName {
    switch (this) {
      case AbuseEventType.contactDrop:
        return 'Kontakt abgebrochen';
      case AbuseEventType.offPlatform:
        return 'Off-Platform Kommunikation';
      case AbuseEventType.spam:
        return 'Spam';
      case AbuseEventType.abuse:
        return 'Missbrauch';
      case AbuseEventType.noShow:
        return 'Nicht erschienen';
      case AbuseEventType.lateCancel:
        return 'Kurzfristige Absage';
    }
  }

  double get defaultWeight {
    switch (this) {
      case AbuseEventType.contactDrop:
        return 0.5;
      case AbuseEventType.offPlatform:
        return 0.3;
      case AbuseEventType.spam:
        return 1.0;
      case AbuseEventType.abuse:
        return 2.0;
      case AbuseEventType.noShow:
        return 1.5;
      case AbuseEventType.lateCancel:
        return 0.8;
    }
  }
}

@freezed
abstract class AbuseEvent with _$AbuseEvent {
  const AbuseEvent._();

  const factory AbuseEvent({
    required String id,
    required AbuseEventType type,
    required String userUid,
    String? jobId,
    @Default(1.0) double weight,
    DateTime? createdAt,
    String? description,
    String? reportedBy, // Admin UID who created this
  }) = _AbuseEvent;

  factory AbuseEvent.fromJson(Map<String, dynamic> json) =>
      _$AbuseEventFromJson(json);

  factory AbuseEvent.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AbuseEvent(
      id: doc.id,
      type: AbuseEventType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => AbuseEventType.abuse,
      ),
      userUid: data['userUid'] as String,
      jobId: data['jobId'] as String?,
      weight: (data['weight'] as num?)?.toDouble() ?? 1.0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
      description: data['description'] as String?,
      reportedBy: data['reportedBy'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'type': type.name,
      'userUid': userUid,
      'jobId': jobId,
      'weight': weight,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'description': description,
      'reportedBy': reportedBy,
    };
  }
}

// ========================================
// ADMIN LOGS
// ========================================

enum AdminAction {
  setFlag,
  addBadge,
  removeBadge,
  recalcHealth,
  exportCsv,
  banUser,
  unbanUser,
  verifyUser,
  moderateDispute;

  String get displayName {
    switch (this) {
      case AdminAction.setFlag:
        return 'Flag gesetzt';
      case AdminAction.addBadge:
        return 'Badge vergeben';
      case AdminAction.removeBadge:
        return 'Badge entfernt';
      case AdminAction.recalcHealth:
        return 'Health-Score neu berechnet';
      case AdminAction.exportCsv:
        return 'CSV Export';
      case AdminAction.banUser:
        return 'User gebannt';
      case AdminAction.unbanUser:
        return 'Ban aufgehoben';
      case AdminAction.verifyUser:
        return 'User verifiziert';
      case AdminAction.moderateDispute:
        return 'Dispute moderiert';
    }
  }
}

@freezed
abstract class AdminLog with _$AdminLog {
  const AdminLog._();

  const factory AdminLog({
    required String id,
    required String actorUid, // Admin who performed action
    required AdminAction action,
    required String targetType, // user|job|payment|dispute
    required String targetId,
    Map<String, dynamic>? before,
    Map<String, dynamic>? after,
    String? notes,
    DateTime? createdAt,
  }) = _AdminLog;

  factory AdminLog.fromJson(Map<String, dynamic> json) =>
      _$AdminLogFromJson(json);

  factory AdminLog.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AdminLog(
      id: doc.id,
      actorUid: data['actorUid'] as String,
      action: AdminAction.values.firstWhere(
        (e) => e.name == data['action'],
        orElse: () => AdminAction.setFlag,
      ),
      targetType: data['targetType'] as String,
      targetId: data['targetId'] as String,
      before: data['before'] as Map<String, dynamic>?,
      after: data['after'] as Map<String, dynamic>?,
      notes: data['notes'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'actorUid': actorUid,
      'action': action.name,
      'targetType': targetType,
      'targetId': targetId,
      'before': before,
      'after': after,
      'notes': notes,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
    };
  }
}

// ========================================
// ADMIN DASHBOARD DATA
// ========================================

@freezed
abstract class AdminKpiData with _$AdminKpiData {
  const factory AdminKpiData({
    @Default(0) int activePros,
    @Default(0) int openDisputes,
    @Default(0.0) double capturedPayments24h,
    @Default(0.0) double refunds24h,
    @Default(0) int newUsers24h,
    @Default(0) int completedJobs24h,
    DateTime? lastUpdated,
  }) = _AdminKpiData;

  factory AdminKpiData.fromJson(Map<String, dynamic> json) =>
      _$AdminKpiDataFromJson(json);
}

@freezed
abstract class AdminFilter with _$AdminFilter {
  const factory AdminFilter({
    DateTime? dateFrom,
    DateTime? dateTo,
    String? status,
    String? searchQuery,
    String? sortBy,
    @Default(false) bool sortAsc,
  }) = _AdminFilter;

  factory AdminFilter.fromJson(Map<String, dynamic> json) =>
      _$AdminFilterFromJson(json);
}

// ========================================
// EXPORT DATA
// ========================================

enum ExportType {
  jobs,
  payments,
  disputes,
  users,
  abuseEvents;

  String get displayName {
    switch (this) {
      case ExportType.jobs:
        return 'Jobs';
      case ExportType.payments:
        return 'Zahlungen';
      case ExportType.disputes:
        return 'Disputes';
      case ExportType.users:
        return 'Nutzer';
      case ExportType.abuseEvents:
        return 'Abuse Events';
    }
  }
}

@freezed
abstract class ExportResult with _$ExportResult {
  const factory ExportResult({
    required String downloadUrl,
    required String fileName,
    @Default(60) int expiresInMinutes,
    DateTime? createdAt,
  }) = _ExportResult;

  factory ExportResult.fromJson(Map<String, dynamic> json) =>
      _$ExportResultFromJson(json);
}

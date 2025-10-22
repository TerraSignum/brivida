import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'dispute.freezed.dart';
part 'dispute.g.dart';

enum DisputeStatus {
  @JsonValue('open')
  open,
  @JsonValue('awaiting_pro')
  awaitingPro,
  @JsonValue('under_review')
  underReview,
  @JsonValue('resolved_refund_full')
  resolvedRefundFull,
  @JsonValue('resolved_refund_partial')
  resolvedRefundPartial,
  @JsonValue('resolved_no_refund')
  resolvedNoRefund,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('expired')
  expired,
}

enum DisputeReason {
  @JsonValue('no_show')
  noShow,
  @JsonValue('poor_quality')
  poorQuality,
  @JsonValue('damage')
  damage,
  @JsonValue('overcharge')
  overcharge,
  @JsonValue('other')
  other,
}

enum EvidenceType {
  @JsonValue('image')
  image,
  @JsonValue('text')
  text,
  @JsonValue('audio')
  audio,
}

@freezed
abstract class Evidence with _$Evidence {
  const factory Evidence({
    required EvidenceType type,
    String? path,
    String? text,
    required DateTime createdAt,
  }) = _Evidence;

  factory Evidence.fromJson(Map<String, dynamic> json) =>
      _$EvidenceFromJson(json);
}

@freezed
abstract class DisputeAuditEntry with _$DisputeAuditEntry {
  const factory DisputeAuditEntry({
    required String by, // 'system' | 'customer' | 'pro' | 'admin'
    required String action,
    String? note,
    required DateTime at,
  }) = _DisputeAuditEntry;

  factory DisputeAuditEntry.fromJson(Map<String, dynamic> json) =>
      _$DisputeAuditEntryFromJson(json);
}

@freezed
abstract class Dispute with _$Dispute {
  const Dispute._();

  const factory Dispute({
    required String id,
    required String jobId,
    required String paymentId,
    required String customerUid,
    required String proUid,
    required DisputeStatus status,
    required DisputeReason reason,
    required String description,
    required double requestedAmount,
    double? awardedAmount,
    required DateTime openedAt,
    required DateTime deadlineProResponse,
    required DateTime deadlineDecision,
    DateTime? resolvedAt,
    @Default([]) List<Evidence> evidence,
    @Default([]) List<Evidence> proResponse,
    @Default([]) List<DisputeAuditEntry> audit,
  }) = _Dispute;

  factory Dispute.fromJson(Map<String, dynamic> json) =>
      _$DisputeFromJson(json);

  factory Dispute.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Dispute.fromJson({
      'id': doc.id,
      ...data,
      'openedAt': (data['openedAt'] as Timestamp).toDate().toIso8601String(),
      'deadlineProResponse':
          (data['deadlineProResponse'] as Timestamp).toDate().toIso8601String(),
      'deadlineDecision':
          (data['deadlineDecision'] as Timestamp).toDate().toIso8601String(),
      'resolvedAt': data['resolvedAt'] != null
          ? (data['resolvedAt'] as Timestamp).toDate().toIso8601String()
          : null,
      'evidence': (data['evidence'] as List?)
              ?.map((e) => {
                    ...e,
                    'createdAt': (e['createdAt'] as Timestamp)
                        .toDate()
                        .toIso8601String(),
                  })
              .toList() ??
          [],
      'proResponse': (data['proResponse'] as List?)
              ?.map((e) => {
                    ...e,
                    'createdAt': (e['createdAt'] as Timestamp)
                        .toDate()
                        .toIso8601String(),
                  })
              .toList() ??
          [],
      'audit': (data['audit'] as List?)
              ?.map((e) => {
                    ...e,
                    'at': (e['at'] as Timestamp).toDate().toIso8601String(),
                  })
              .toList() ??
          [],
    });
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    return {
      ...json,
      'openedAt': Timestamp.fromDate(openedAt),
      'deadlineProResponse': Timestamp.fromDate(deadlineProResponse),
      'deadlineDecision': Timestamp.fromDate(deadlineDecision),
      'resolvedAt': resolvedAt != null ? Timestamp.fromDate(resolvedAt!) : null,
      'evidence': evidence
          .map((e) => {
                ...e.toJson(),
                'createdAt': Timestamp.fromDate(e.createdAt),
              })
          .toList(),
      'proResponse': proResponse
          .map((e) => {
                ...e.toJson(),
                'createdAt': Timestamp.fromDate(e.createdAt),
              })
          .toList(),
      'audit': audit
          .map((e) => {
                ...e.toJson(),
                'at': Timestamp.fromDate(e.at),
              })
          .toList(),
    };
  }
}

// Helper extensions for UI
extension DisputeStatusExtension on DisputeStatus {
  String get displayName {
    switch (this) {
      case DisputeStatus.open:
        return 'Open';
      case DisputeStatus.awaitingPro:
        return 'Awaiting Pro Response';
      case DisputeStatus.underReview:
        return 'Under Review';
      case DisputeStatus.resolvedRefundFull:
        return 'Resolved - Full Refund';
      case DisputeStatus.resolvedRefundPartial:
        return 'Resolved - Partial Refund';
      case DisputeStatus.resolvedNoRefund:
        return 'Resolved - No Refund';
      case DisputeStatus.cancelled:
        return 'Cancelled';
      case DisputeStatus.expired:
        return 'Expired';
    }
  }

  bool get isResolved {
    return [
      DisputeStatus.resolvedRefundFull,
      DisputeStatus.resolvedRefundPartial,
      DisputeStatus.resolvedNoRefund,
      DisputeStatus.cancelled,
      DisputeStatus.expired,
    ].contains(this);
  }

  bool get canAddEvidence {
    return [
      DisputeStatus.open,
      DisputeStatus.awaitingPro,
      DisputeStatus.underReview,
    ].contains(this);
  }
}

extension DisputeReasonExtension on DisputeReason {
  String get displayName {
    switch (this) {
      case DisputeReason.noShow:
        return 'No Show';
      case DisputeReason.poorQuality:
        return 'Poor Quality';
      case DisputeReason.damage:
        return 'Damage';
      case DisputeReason.overcharge:
        return 'Overcharge';
      case DisputeReason.other:
        return 'Other';
    }
  }
}

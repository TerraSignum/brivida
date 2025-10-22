import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents an individual checklist item within a job completion submission.
class JobCompletionChecklistItem {
  const JobCompletionChecklistItem({
    required this.label,
    required this.completed,
  });

  final String label;
  final bool completed;

  Map<String, dynamic> toMap() => {'label': label, 'completed': completed};

  factory JobCompletionChecklistItem.fromMap(Map<String, dynamic> map) {
    return JobCompletionChecklistItem(
      label: map['label']?.toString() ?? '',
      completed: map['completed'] == true,
    );
  }

  JobCompletionChecklistItem copyWith({String? label, bool? completed}) {
    return JobCompletionChecklistItem(
      label: label ?? this.label,
      completed: completed ?? this.completed,
    );
  }
}

/// Firestore document representing a job completion submission.
class JobCompletion {
  const JobCompletion({
    required this.jobId,
    required this.submittedByUid,
    required this.submittedByRole,
    required this.status,
    required this.checklist,
    required this.photoUrls,
    required this.note,
    required this.submittedAt,
    this.updatedAt,
    this.approvedAt,
    this.approvedByUid,
  });

  final String jobId;
  final String submittedByUid;
  final String submittedByRole;
  final String status; // draft | submitted | approved
  final List<JobCompletionChecklistItem> checklist;
  final List<String> photoUrls;
  final String note;
  final DateTime submittedAt;
  final DateTime? updatedAt;
  final DateTime? approvedAt;
  final String? approvedByUid;

  bool get isApproved => status == 'approved';
  bool get isSubmitted => status == 'submitted' || status == 'approved';

  Map<String, dynamic> toMap() {
    return {
      'jobId': jobId,
      'submittedByUid': submittedByUid,
      'submittedByRole': submittedByRole,
      'status': status,
      'checklist': checklist.map((item) => item.toMap()).toList(),
      'photoUrls': photoUrls,
      'note': note,
      'submittedAt': Timestamp.fromDate(submittedAt),
      if (updatedAt != null) 'updatedAt': Timestamp.fromDate(updatedAt!),
      if (approvedAt != null) 'approvedAt': Timestamp.fromDate(approvedAt!),
      if (approvedByUid != null) 'approvedByUid': approvedByUid,
    };
  }

  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is num) {
      return DateTime.fromMillisecondsSinceEpoch(value.toInt());
    }
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  factory JobCompletion.fromMap(
    Map<String, dynamic> map, {
    required String jobId,
  }) {
    final checklistData = map['checklist'] as List<dynamic>? ?? const [];
    final photoData = map['photoUrls'] as List<dynamic>? ?? const [];

    return JobCompletion(
      jobId: jobId,
      submittedByUid: map['submittedByUid']?.toString() ?? '',
      submittedByRole: map['submittedByRole']?.toString() ?? 'pro',
      status: map['status']?.toString() ?? 'draft',
      checklist: checklistData
          .map(
            (entry) => JobCompletionChecklistItem.fromMap(
              Map<String, dynamic>.from(entry as Map),
            ),
          )
          .toList(),
      photoUrls: photoData.map((entry) => entry.toString()).toList(),
      note: map['note']?.toString() ?? '',
      submittedAt: _toDate(map['submittedAt']) ?? DateTime.now(),
      updatedAt: _toDate(map['updatedAt']),
      approvedAt: _toDate(map['approvedAt']),
      approvedByUid: map['approvedByUid']?.toString(),
    );
  }

  JobCompletion copyWith({
    String? status,
    List<JobCompletionChecklistItem>? checklist,
    List<String>? photoUrls,
    String? note,
    DateTime? updatedAt,
    DateTime? approvedAt,
    String? approvedByUid,
  }) {
    return JobCompletion(
      jobId: jobId,
      submittedByUid: submittedByUid,
      submittedByRole: submittedByRole,
      status: status ?? this.status,
      checklist: checklist ?? this.checklist,
      photoUrls: photoUrls ?? this.photoUrls,
      note: note ?? this.note,
      submittedAt: submittedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      approvedAt: approvedAt ?? this.approvedAt,
      approvedByUid: approvedByUid ?? this.approvedByUid,
    );
  }

  @override
  String toString() {
    return 'JobCompletion(status: $status, submittedByUid: $submittedByUid, checklist: ${checklist.length})';
  }
}

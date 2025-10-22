import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import '../../../core/models/admin.dart';
import '../../../core/models/dispute.dart';
import '../../../core/models/payment.dart';
import '../../../core/utils/debug_logger.dart';

class AdminRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instanceFor(
    region: 'europe-west1',
  );

  // ========================================
  // KPI DATA FETCHING
  // ========================================

  Future<AdminKpiData> getKpiData() async {
    try {
      DebugLogger.debug('🔥 ADMIN_REPO: Fetching KPI data...');

      final now = DateTime.now();
      final yesterday = now.subtract(const Duration(days: 1));

      // Parallel queries for better performance
      final results = await Future.wait([
        _getActiveProsCount(),
        _getOpenDisputesCount(),
        _getCapturedPayments24h(yesterday),
        _getRefunds24h(yesterday),
        _getNewUsers24h(yesterday),
        _getCompletedJobs24h(yesterday),
      ]);

      final kpiData = AdminKpiData(
        activePros: results[0] as int,
        openDisputes: results[1] as int,
        capturedPayments24h: results[2] as double,
        refunds24h: results[3] as double,
        newUsers24h: results[4] as int,
        completedJobs24h: results[5] as int,
        lastUpdated: now,
      );

      DebugLogger.debug('✅ ADMIN_REPO: KPI data fetched successfully');
      return kpiData;
    } catch (e) {
      DebugLogger.error('❌ ADMIN_REPO: Error fetching KPI data: $e');
      rethrow;
    }
  }

  Future<int> _getActiveProsCount() async {
    final query = await _firestore
        .collection('proProfiles')
        .where('isActive', isEqualTo: true)
        .count()
        .get();
    return query.count ?? 0;
  }

  Future<int> _getOpenDisputesCount() async {
    final query = await _firestore
        .collection('disputes')
        .where('status', whereIn: ['open', 'awaiting_pro', 'under_review'])
        .count()
        .get();
    return query.count ?? 0;
  }

  Future<double> _getCapturedPayments24h(DateTime since) async {
    final query = await _firestore
        .collection('payments')
        .where('status', isEqualTo: 'captured')
        .where('capturedAt', isGreaterThan: Timestamp.fromDate(since))
        .get();

    double total = 0.0;
    for (final doc in query.docs) {
      final data = doc.data();
      total += (data['amountGross'] as num?)?.toDouble() ?? 0.0;
    }
    return total;
  }

  Future<double> _getRefunds24h(DateTime since) async {
    final query = await _firestore
        .collection('refunds')
        .where('createdAt', isGreaterThan: Timestamp.fromDate(since))
        .get();

    double total = 0.0;
    for (final doc in query.docs) {
      final data = doc.data();
      total += (data['amount'] as num?)?.toDouble() ?? 0.0;
    }
    return total;
  }

  Future<int> _getNewUsers24h(DateTime since) async {
    final query = await _firestore
        .collection('users')
        .where('createdAt', isGreaterThan: Timestamp.fromDate(since))
        .count()
        .get();
    return query.count ?? 0;
  }

  Future<int> _getCompletedJobs24h(DateTime since) async {
    final query = await _firestore
        .collection('jobs')
        .where('status', isEqualTo: 'completed')
        .where('completedAt', isGreaterThan: Timestamp.fromDate(since))
        .count()
        .get();
    return query.count ?? 0;
  }

  // ========================================
  // DISPUTE MANAGEMENT
  // ========================================

  Stream<List<Dispute>> getDisputesStream({String? statusFilter}) {
    try {
      DebugLogger.debug(
        '🔥 ADMIN_REPO: Getting disputes stream with filter: $statusFilter',
      );

      Query query = _firestore
          .collection('disputes')
          .orderBy('openedAt', descending: true);

      if (statusFilter != null && statusFilter.isNotEmpty) {
        query = query.where('status', isEqualTo: statusFilter);
      }

      return query.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) => Dispute.fromFirestore(doc)).toList();
      });
    } catch (e) {
      DebugLogger.error('❌ ADMIN_REPO: Error getting disputes stream: $e');
      rethrow;
    }
  }

  Future<List<Dispute>> getDisputes({
    String? statusFilter,
    DateTime? dateFrom,
    DateTime? dateTo,
    int limit = 100,
  }) async {
    try {
      DebugLogger.debug('🔥 ADMIN_REPO: Fetching disputes with filters...');

      Query query = _firestore
          .collection('disputes')
          .orderBy('openedAt', descending: true);

      if (statusFilter != null && statusFilter.isNotEmpty) {
        query = query.where('status', isEqualTo: statusFilter);
      }

      if (dateFrom != null) {
        query = query.where(
          'openedAt',
          isGreaterThanOrEqualTo: Timestamp.fromDate(dateFrom),
        );
      }

      if (dateTo != null) {
        query = query.where(
          'openedAt',
          isLessThanOrEqualTo: Timestamp.fromDate(dateTo),
        );
      }

      query = query.limit(limit);

      final snapshot = await query.get();
      final disputes = snapshot.docs
          .map((doc) => Dispute.fromFirestore(doc))
          .toList();

      DebugLogger.debug('✅ ADMIN_REPO: Fetched ${disputes.length} disputes');
      return disputes;
    } catch (e) {
      DebugLogger.error('❌ ADMIN_REPO: Error fetching disputes: $e');
      rethrow;
    }
  }

  // ========================================
  // PAYMENT MANAGEMENT
  // ========================================

  Stream<List<Payment>> getPaymentsStream() {
    try {
      DebugLogger.debug('🔥 ADMIN_REPO: Getting payments stream...');

      return _firestore
          .collection('payments')
          .orderBy('createdAt', descending: true)
          .limit(100)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) => Payment.fromFirestore(doc))
                .toList();
          });
    } catch (e) {
      DebugLogger.error('❌ ADMIN_REPO: Error getting payments stream: $e');
      rethrow;
    }
  }

  Future<List<Payment>> getPayments({
    DateTime? dateFrom,
    DateTime? dateTo,
    String? status,
    int limit = 100,
  }) async {
    try {
      DebugLogger.debug('🔥 ADMIN_REPO: Fetching payments with filters...');

      Query query = _firestore
          .collection('payments')
          .orderBy('createdAt', descending: true);

      if (status != null && status.isNotEmpty) {
        query = query.where('status', isEqualTo: status);
      }

      if (dateFrom != null) {
        query = query.where(
          'createdAt',
          isGreaterThanOrEqualTo: Timestamp.fromDate(dateFrom),
        );
      }

      if (dateTo != null) {
        query = query.where(
          'createdAt',
          isLessThanOrEqualTo: Timestamp.fromDate(dateTo),
        );
      }

      query = query.limit(limit);

      final snapshot = await query.get();
      final payments = snapshot.docs
          .map((doc) => Payment.fromFirestore(doc))
          .toList();

      DebugLogger.debug('✅ ADMIN_REPO: Fetched ${payments.length} payments');
      return payments;
    } catch (e) {
      DebugLogger.error('❌ ADMIN_REPO: Error fetching payments: $e');
      rethrow;
    }
  }

  // ========================================
  // PRO MANAGEMENT
  // ========================================

  Future<List<Map<String, dynamic>>> getPros({
    String? searchQuery,
    String? sortBy,
    bool sortAsc = true,
    int limit = 50,
  }) async {
    try {
      DebugLogger.debug(
        '🔥 ADMIN_REPO: Fetching pros with search: $searchQuery',
      );

      Query query = _firestore.collection('proProfiles');

      // Basic ordering (can be enhanced with proper search later)
      if (sortBy == 'healthScore') {
        query = query.orderBy('health.score', descending: !sortAsc);
      } else {
        query = query.orderBy('createdAt', descending: !sortAsc);
      }

      query = query.limit(limit);

      final snapshot = await query.get();
      List<Map<String, dynamic>> pros = [];

      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        // Add document ID and process data
        final proData = {
          'uid': doc.id,
          ...data,
          'health': data['health'] != null
              ? HealthScore.fromFirestore(
                  data['health'] as Map<String, dynamic>,
                )
              : const HealthScore(),
          'flags': data['flags'] != null
              ? ProFlags.fromFirestore(data['flags'] as Map<String, dynamic>)
              : const ProFlags(),
          'badges':
              (data['badges'] as List<dynamic>?)
                  ?.map(
                    (badge) => ProBadge.values.firstWhere(
                      (e) => e.name == badge,
                      orElse: () => ProBadge.verified,
                    ),
                  )
                  .toList() ??
              <ProBadge>[],
        };

        // Apply search filter if provided
        if (searchQuery == null || searchQuery.isEmpty) {
          pros.add(proData);
        } else {
          final name = (proData['name'] as String? ?? '').toLowerCase();
          final email = (proData['email'] as String? ?? '').toLowerCase();
          final search = searchQuery.toLowerCase();

          if (name.contains(search) || email.contains(search)) {
            pros.add(proData);
          }
        }
      }

      DebugLogger.debug('✅ ADMIN_REPO: Fetched ${pros.length} pros');
      return pros;
    } catch (e) {
      DebugLogger.error('❌ ADMIN_REPO: Error fetching pros: $e');
      rethrow;
    }
  }

  // ========================================
  // ADMIN ACTIONS (via Cloud Functions)
  // ========================================

  Future<void> setProFlags({
    required String proUid,
    bool? softBanned,
    bool? hardBanned,
    String? notes,
  }) async {
    try {
      DebugLogger.debug('🔥 ADMIN_REPO: Setting flags for pro: $proUid');

      final callable = _functions.httpsCallable('setFlagsCF');
      await callable.call({
        'proUid': proUid,
        if (softBanned != null) 'softBanned': softBanned,
        if (hardBanned != null) 'hardBanned': hardBanned,
        if (notes != null) 'notes': notes,
      });

      DebugLogger.debug('✅ ADMIN_REPO: Flags set successfully');
    } catch (e) {
      DebugLogger.error('❌ ADMIN_REPO: Error setting flags: $e');
      rethrow;
    }
  }

  Future<void> addBadge({
    required String proUid,
    required ProBadge badge,
  }) async {
    try {
      DebugLogger.debug(
        '🔥 ADMIN_REPO: Adding badge ${badge.name} to pro: $proUid',
      );

      final callable = _functions.httpsCallable('addBadgeCF');
      await callable.call({'proUid': proUid, 'badge': badge.name});

      DebugLogger.debug('✅ ADMIN_REPO: Badge added successfully');
    } catch (e) {
      DebugLogger.error('❌ ADMIN_REPO: Error adding badge: $e');
      rethrow;
    }
  }

  Future<void> removeBadge({
    required String proUid,
    required ProBadge badge,
  }) async {
    try {
      DebugLogger.debug(
        '🔥 ADMIN_REPO: Removing badge ${badge.name} from pro: $proUid',
      );

      final callable = _functions.httpsCallable('removeBadgeCF');
      await callable.call({'proUid': proUid, 'badge': badge.name});

      DebugLogger.debug('✅ ADMIN_REPO: Badge removed successfully');
    } catch (e) {
      DebugLogger.error('❌ ADMIN_REPO: Error removing badge: $e');
      rethrow;
    }
  }

  Future<void> recalculateHealth({required String proUid}) async {
    try {
      DebugLogger.debug('🔥 ADMIN_REPO: Recalculating health for pro: $proUid');

      final callable = _functions.httpsCallable('recalcHealthCF');
      await callable.call({'proUid': proUid});

      DebugLogger.debug('✅ ADMIN_REPO: Health recalculated successfully');
    } catch (e) {
      DebugLogger.error('❌ ADMIN_REPO: Error recalculating health: $e');
      rethrow;
    }
  }

  // ========================================
  // CSV EXPORTS
  // ========================================

  Future<ExportResult> exportCsv({
    required ExportType type,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    try {
      DebugLogger.debug('🔥 ADMIN_REPO: Exporting CSV for ${type.name}');

      final callable = _functions.httpsCallable('exportCsvCF');
      final result = await callable.call({
        'kind': type.name,
        if (dateFrom != null) 'dateFrom': dateFrom.toIso8601String(),
        if (dateTo != null) 'dateTo': dateTo.toIso8601String(),
      });

      final exportResult = ExportResult.fromJson(
        result.data as Map<String, dynamic>,
      );

      DebugLogger.debug(
        '✅ ADMIN_REPO: CSV export created: ${exportResult.fileName}',
      );
      return exportResult;
    } catch (e) {
      DebugLogger.error('❌ ADMIN_REPO: Error exporting CSV: $e');
      rethrow;
    }
  }

  // ========================================
  // ABUSE EVENTS
  // ========================================

  Future<void> createAbuseEvent({
    required String userUid,
    required AbuseEventType type,
    String? jobId,
    double? weight,
    String? description,
  }) async {
    try {
      DebugLogger.log('🔥 ADMIN_REPO: Creating abuse event for user: $userUid');

      await _firestore.collection('abuseEvents').add({
        'type': type.name,
        'userUid': userUid,
        'jobId': jobId,
        'weight': weight ?? type.defaultWeight,
        'description': description,
        'createdAt': FieldValue.serverTimestamp(),
      });

      DebugLogger.log('✅ ADMIN_REPO: Abuse event created successfully');
    } catch (e) {
      DebugLogger.log('❌ ADMIN_REPO: Error creating abuse event: $e');
      rethrow;
    }
  }

  Stream<List<AbuseEvent>> getAbuseEventsStream({String? userUid}) {
    try {
      DebugLogger.log(
        '🔥 ADMIN_REPO: Getting abuse events stream for user: $userUid',
      );

      Query query = _firestore
          .collection('abuseEvents')
          .orderBy('createdAt', descending: true);

      if (userUid != null) {
        query = query.where('userUid', isEqualTo: userUid);
      }

      return query.limit(100).snapshots().map((snapshot) {
        return snapshot.docs
            .map((doc) => AbuseEvent.fromFirestore(doc))
            .toList();
      });
    } catch (e) {
      DebugLogger.log('❌ ADMIN_REPO: Error getting abuse events stream: $e');
      rethrow;
    }
  }

  // ========================================
  // ADMIN LOGS
  // ========================================

  Stream<List<AdminLog>> getAdminLogsStream({int limit = 50}) {
    try {
      DebugLogger.log('🔥 ADMIN_REPO: Getting admin logs stream...');

      return _firestore
          .collection('adminLogs')
          .orderBy('createdAt', descending: true)
          .limit(limit)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) => AdminLog.fromFirestore(doc))
                .toList();
          });
    } catch (e) {
      DebugLogger.log('❌ ADMIN_REPO: Error getting admin logs stream: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getProProfile(String proUid) async {
    try {
      DebugLogger.log('🔥 ADMIN_REPO: Fetching pro profile: $proUid');

      final doc = await _firestore.collection('proProfiles').doc(proUid).get();

      if (!doc.exists) {
        DebugLogger.log('⚠️ ADMIN_REPO: Pro profile not found: $proUid');
        return null;
      }

      final data = doc.data()!;
      DateTime? createdAt;
      final createdAtRaw = data['createdAt'];
      if (createdAtRaw is Timestamp) {
        createdAt = createdAtRaw.toDate();
      } else if (createdAtRaw is DateTime) {
        createdAt = createdAtRaw;
      } else if (createdAtRaw is String) {
        createdAt = DateTime.tryParse(createdAtRaw);
      }

      DateTime? updatedAt;
      final updatedAtRaw = data['updatedAt'];
      if (updatedAtRaw is Timestamp) {
        updatedAt = updatedAtRaw.toDate();
      } else if (updatedAtRaw is DateTime) {
        updatedAt = updatedAtRaw;
      } else if (updatedAtRaw is String) {
        updatedAt = DateTime.tryParse(updatedAtRaw);
      }

      return {
        'uid': doc.id,
        ...data,
        if (createdAt != null) 'createdAt': createdAt,
        if (updatedAt != null) 'updatedAt': updatedAt,
        'health': data['health'] != null
            ? HealthScore.fromFirestore(data['health'] as Map<String, dynamic>)
            : const HealthScore(),
        'flags': data['flags'] != null
            ? ProFlags.fromFirestore(data['flags'] as Map<String, dynamic>)
            : const ProFlags(),
        'badges':
            (data['badges'] as List<dynamic>?)
                ?.map(
                  (badge) => ProBadge.values.firstWhere(
                    (e) => e.name == badge,
                    orElse: () => ProBadge.verified,
                  ),
                )
                .toList() ??
            <ProBadge>[],
      };
    } catch (e) {
      DebugLogger.log('❌ ADMIN_REPO: Error fetching pro profile: $e');
      rethrow;
    }
  }

  // ========================================
  // DATA RETENTION & GDPR COMPLIANCE
  // ========================================

  /// Get current retention configuration
  Future<Map<String, dynamic>?> getRetentionConfig() async {
    try {
      DebugLogger.log('🔥 ADMIN_REPO: Fetching retention configuration...');

      final doc = await _firestore
          .collection('adminSettings')
          .doc('retention')
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        DebugLogger.log('✅ ADMIN_REPO: Retention config fetched successfully');
        return data;
      } else {
        DebugLogger.log(
          'ℹ️ ADMIN_REPO: No retention config found, using defaults',
        );
        return null;
      }
    } catch (e) {
      DebugLogger.log('❌ ADMIN_REPO: Error fetching retention config: $e');
      rethrow;
    }
  }

  /// Update retention configuration
  Future<void> updateRetentionConfig({
    required int jobsPrivateRetentionMonths,
    required int chatRetentionMonths,
    required int disputeRetentionMonths,
  }) async {
    try {
      DebugLogger.log('🔥 ADMIN_REPO: Updating retention configuration...');

      final callable = _functions.httpsCallable('updateRetentionConfigCF');
      await callable.call({
        'jobsPrivateRetentionMonths': jobsPrivateRetentionMonths,
        'chatRetentionMonths': chatRetentionMonths,
        'disputeRetentionMonths': disputeRetentionMonths,
      });

      DebugLogger.log(
        '✅ ADMIN_REPO: Retention configuration updated successfully',
      );
    } catch (e) {
      DebugLogger.log('❌ ADMIN_REPO: Error updating retention config: $e');
      rethrow;
    }
  }

  /// Trigger manual data retention cleanup
  Future<Map<String, dynamic>> triggerDataRetention() async {
    try {
      DebugLogger.log(
        '🔥 ADMIN_REPO: Triggering manual data retention cleanup...',
      );

      final callable = _functions.httpsCallable('triggerDataRetentionCF');
      final result = await callable.call();

      DebugLogger.log('✅ ADMIN_REPO: Data retention cleanup completed');
      return result.data as Map<String, dynamic>;
    } catch (e) {
      DebugLogger.log('❌ ADMIN_REPO: Error triggering data retention: $e');
      rethrow;
    }
  }

  // ========================================
  // LEGAL VERSION MANAGEMENT
  // ========================================

  Future<void> updateLegalVersions({
    String? termsVersion,
    String? privacyVersion,
  }) async {
    try {
      DebugLogger.debug('🔥 ADMIN_REPO: Updating legal versions...');

      final callable = _functions.httpsCallable('updateLegalVersions');
      final Map<String, dynamic> data = {};

      if (termsVersion != null) {
        data['termsVersion'] = termsVersion;
      }
      if (privacyVersion != null) {
        data['privacyVersion'] = privacyVersion;
      }

      await callable.call(data);

      DebugLogger.debug('✅ ADMIN_REPO: Legal versions updated successfully');
    } catch (e) {
      DebugLogger.error('❌ ADMIN_REPO: Error updating legal versions: $e');
      rethrow;
    }
  }
}

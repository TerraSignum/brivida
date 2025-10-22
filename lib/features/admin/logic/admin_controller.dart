import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/models/admin.dart';
import '../../../core/models/dispute.dart';
import '../../../core/models/payment.dart';
import '../../../core/utils/debug_logger.dart';
import '../data/admin_repo.dart';

// ========================================
// PROVIDERS
// ========================================

final adminRepoProvider = Provider<AdminRepository>((ref) {
  return AdminRepository();
});

final adminControllerProvider =
    StateNotifierProvider<AdminController, AdminState>((ref) {
      return AdminController(ref.read(adminRepoProvider));
    });

final kpiDataProvider = FutureProvider<AdminKpiData>((ref) {
  return ref.read(adminRepoProvider).getKpiData();
});

final disputesStreamProvider = StreamProvider<List<Dispute>>((ref) {
  return ref.read(adminRepoProvider).getDisputesStream();
});

final paymentsStreamProvider = StreamProvider<List<Payment>>((ref) {
  return ref.read(adminRepoProvider).getPaymentsStream();
});

// ========================================
// ADMIN STATE
// ========================================

class AdminState {
  final bool isLoading;
  final String? error;
  final AdminKpiData? kpiData;
  final List<Map<String, dynamic>> pros;
  final AdminFilter filter;

  const AdminState({
    this.isLoading = false,
    this.error,
    this.kpiData,
    this.pros = const [],
    this.filter = const AdminFilter(),
  });

  AdminState copyWith({
    bool? isLoading,
    String? error,
    AdminKpiData? kpiData,
    List<Map<String, dynamic>>? pros,
    AdminFilter? filter,
  }) {
    return AdminState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      kpiData: kpiData ?? this.kpiData,
      pros: pros ?? this.pros,
      filter: filter ?? this.filter,
    );
  }
}

// ========================================
// ADMIN CONTROLLER
// ========================================

class AdminController extends StateNotifier<AdminState> {
  final AdminRepository _repo;

  AdminController(this._repo) : super(const AdminState()) {
    loadPros();
  }

  Future<void> loadKpiData() async {
    try {
      DebugLogger.debug('🔥 ADMIN_CONTROLLER: Loading KPI data...');
      state = state.copyWith(isLoading: true, error: null);

      final kpiData = await _repo.getKpiData();
      state = state.copyWith(isLoading: false, kpiData: kpiData);

      DebugLogger.debug('✅ ADMIN_CONTROLLER: KPI data loaded successfully');
    } catch (e) {
      DebugLogger.error('❌ ADMIN_CONTROLLER: Error loading KPI data: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadPros({
    String? searchQuery,
    String? sortBy,
    bool sortAsc = true,
  }) async {
    try {
      DebugLogger.debug('🔥 ADMIN_CONTROLLER: Loading pros...');
      state = state.copyWith(isLoading: true, error: null);

      final pros = await _repo.getPros(
        searchQuery: searchQuery,
        sortBy: sortBy,
        sortAsc: sortAsc,
      );

      state = state.copyWith(isLoading: false, pros: pros);

      DebugLogger.debug('✅ ADMIN_CONTROLLER: Loaded ${pros.length} pros');
    } catch (e) {
      DebugLogger.error('❌ ADMIN_CONTROLLER: Error loading pros: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> searchPros(String query) async {
    await loadPros(searchQuery: query);
  }

  Future<void> setProFlags({
    required String proUid,
    bool? softBanned,
    bool? hardBanned,
    String? notes,
  }) async {
    try {
      DebugLogger.debug('🔥 ADMIN_CONTROLLER: Setting flags for pro: $proUid');

      await _repo.setProFlags(
        proUid: proUid,
        softBanned: softBanned,
        hardBanned: hardBanned,
        notes: notes,
      );

      // Reload pros to see updated flags
      await loadPros();

      DebugLogger.debug('✅ ADMIN_CONTROLLER: Flags set successfully');
    } catch (e) {
      DebugLogger.error('❌ ADMIN_CONTROLLER: Error setting flags: $e');
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> addBadge({
    required String proUid,
    required ProBadge badge,
  }) async {
    try {
      DebugLogger.debug(
        '🔥 ADMIN_CONTROLLER: Adding badge ${badge.name} to pro: $proUid',
      );

      await _repo.addBadge(proUid: proUid, badge: badge);

      // Reload pros to see updated badges
      await loadPros();

      DebugLogger.debug('✅ ADMIN_CONTROLLER: Badge added successfully');
    } catch (e) {
      DebugLogger.error('❌ ADMIN_CONTROLLER: Error adding badge: $e');
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> removeBadge({
    required String proUid,
    required ProBadge badge,
  }) async {
    try {
      DebugLogger.debug(
        '🔥 ADMIN_CONTROLLER: Removing badge ${badge.name} from pro: $proUid',
      );

      await _repo.removeBadge(proUid: proUid, badge: badge);

      // Reload pros to see updated badges
      await loadPros();

      DebugLogger.debug('✅ ADMIN_CONTROLLER: Badge removed successfully');
    } catch (e) {
      DebugLogger.error('❌ ADMIN_CONTROLLER: Error removing badge: $e');
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updateLegalVersions({
    String? termsVersion,
    String? privacyVersion,
  }) async {
    try {
      DebugLogger.debug('🔥 ADMIN_CONTROLLER: Updating legal versions');

      await _repo.updateLegalVersions(
        termsVersion: termsVersion,
        privacyVersion: privacyVersion,
      );

      DebugLogger.debug(
        '✅ ADMIN_CONTROLLER: Legal versions updated successfully',
      );
    } catch (e) {
      DebugLogger.error(
        '❌ ADMIN_CONTROLLER: Error updating legal versions: $e',
      );
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  Future<void> recalculateHealth({required String proUid}) async {
    try {
      DebugLogger.debug(
        '🔥 ADMIN_CONTROLLER: Recalculating health for pro: $proUid',
      );

      await _repo.recalculateHealth(proUid: proUid);

      // Reload pros to see updated health score
      await loadPros();

      DebugLogger.debug('✅ ADMIN_CONTROLLER: Health recalculated successfully');
    } catch (e) {
      DebugLogger.error('❌ ADMIN_CONTROLLER: Error recalculating health: $e');
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> exportCsv(ExportType type) async {
    try {
      DebugLogger.debug('🔥 ADMIN_CONTROLLER: Exporting CSV: ${type.name}');

      final result = await _repo.exportCsv(type: type);

      final uri = Uri.tryParse(result.downloadUrl);
      if (uri == null) {
        DebugLogger.warning(
          '⚠️ ADMIN_CONTROLLER: Invalid CSV download URL received',
          result.downloadUrl,
        );
        return;
      }

      final canOpen = await canLaunchUrl(uri);
      if (!canOpen) {
        DebugLogger.warning(
          '⚠️ ADMIN_CONTROLLER: Unable to launch CSV download URL',
          result.downloadUrl,
        );
        return;
      }

      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        DebugLogger.warning(
          '⚠️ ADMIN_CONTROLLER: Failed to open CSV download URL',
          result.downloadUrl,
        );
        return;
      }

      DebugLogger.debug(
        '✅ ADMIN_CONTROLLER: CSV exported and download launched: ${result.fileName}',
      );
    } catch (e) {
      DebugLogger.error('❌ ADMIN_CONTROLLER: Error exporting CSV: $e');
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> createAbuseEvent({
    required String userUid,
    required AbuseEventType type,
    String? jobId,
    double? weight,
    String? description,
  }) async {
    try {
      DebugLogger.log(
        '🔥 ADMIN_CONTROLLER: Creating abuse event for user: $userUid',
      );

      await _repo.createAbuseEvent(
        userUid: userUid,
        type: type,
        jobId: jobId,
        weight: weight,
        description: description,
      );

      DebugLogger.log('✅ ADMIN_CONTROLLER: Abuse event created successfully');
    } catch (e) {
      DebugLogger.log('❌ ADMIN_CONTROLLER: Error creating abuse event: $e');
      state = state.copyWith(error: e.toString());
    }
  }
}

// ========================================
// PRO DETAIL PROVIDERS
// ========================================

final proDetailProvider = FutureProvider.family<Map<String, dynamic>?, String>((
  ref,
  proUid,
) {
  return ref.read(adminRepoProvider).getProProfile(proUid);
});

final abuseEventsProvider = StreamProvider.family<List<AbuseEvent>, String>((
  ref,
  userUid,
) {
  return ref.read(adminRepoProvider).getAbuseEventsStream(userUid: userUid);
});

final adminLogsProvider = StreamProvider<List<AdminLog>>((ref) {
  return ref.read(adminRepoProvider).getAdminLogsStream();
});

// ========================================
// HEALTH SCORE HELPERS
// ========================================

extension HealthScoreHelper on HealthScore {
  Color get scoreColor {
    if (score >= 80) return const Color(0xFF4CAF50); // Green
    if (score >= 60) return const Color(0xFFFF9800); // Orange
    if (score >= 40) return const Color(0xFFFF5722); // Red-Orange
    return const Color(0xFFF44336); // Red
  }

  String get scoreGrade {
    if (score >= 90) return 'A+';
    if (score >= 80) return 'A';
    if (score >= 70) return 'B';
    if (score >= 60) return 'C';
    if (score >= 50) return 'D';
    return 'F';
  }

  List<String> get recommendations {
    final suggestions = <String>[];

    if (noShowRate > 0.05) {
      suggestions.add(
        'No-Show Rate reduzieren (aktuell ${(noShowRate * 100).toStringAsFixed(1)}%)',
      );
    }

    if (cancelRate > 0.10) {
      suggestions.add(
        'Absage-Rate reduzieren (aktuell ${(cancelRate * 100).toStringAsFixed(1)}%)',
      );
    }

    if (avgResponseMins > 60) {
      suggestions.add(
        'Antwortzeit verbessern (aktuell ${avgResponseMins.toStringAsFixed(0)} Min)',
      );
    }

    if (inAppRatio < 0.8) {
      suggestions.add(
        'Kommunikation in der App halten (aktuell ${(inAppRatio * 100).toStringAsFixed(1)}%)',
      );
    }

    if (ratingAvg < 4.0) {
      suggestions.add(
        'Bewertungen verbessern (aktuell ${ratingAvg.toStringAsFixed(1)}/5)',
      );
    }

    if (ratingCount < 10) {
      suggestions.add('Mehr Bewertungen sammeln (aktuell $ratingCount)');
    }

    if (suggestions.isEmpty) {
      suggestions.add('Weiter so! Alle Metriken sind gut.');
    }

    return suggestions;
  }
}

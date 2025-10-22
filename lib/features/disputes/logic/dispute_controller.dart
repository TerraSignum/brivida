import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:typed_data';
import '../../../core/models/dispute.dart';
import '../data/disputes_repo.dart';
import '../../../core/config/admin_whitelist.dart';
import '../../../core/utils/debug_logger.dart';

// Repository provider
final disputesRepositoryProvider = Provider<DisputesRepository>((ref) {
  return DisputesRepository();
});

// Current user disputes stream
final myDisputesProvider = StreamProvider<List<Dispute>>((ref) {
  final repo = ref.watch(disputesRepositoryProvider);
  return repo.listMyDisputes();
});

// All disputes for admin
final allDisputesProvider =
    StreamProvider.family<List<Dispute>, DisputeStatus?>((ref, statusFilter) {
      final repo = ref.watch(disputesRepositoryProvider);
      return repo.listAllDisputes(statusFilter: statusFilter);
    });

// Single dispute provider
final disputeProvider = StreamProvider.family<Dispute?, String>((ref, caseId) {
  final repo = ref.watch(disputesRepositoryProvider);
  return repo.watchDispute(caseId);
});

// Dispute controller for managing dispute operations
class DisputeController extends StateNotifier<AsyncValue<void>> {
  DisputeController(this._repo) : super(const AsyncValue.data(null));

  final DisputesRepository _repo;

  Future<String?> openDispute({
    required String jobId,
    required String paymentId,
    required DisputeReason reason,
    required String description,
    required double requestedAmount,
    List<dynamic>? mediaFiles,
    List<String>? fileNames,
  }) async {
    try {
      DebugLogger.log('🎮 DISPUTE CONTROLLER: Opening dispute');
      state = const AsyncValue.loading();

      final caseId = await _repo.openDispute(
        jobId: jobId,
        paymentId: paymentId,
        reason: reason,
        description: description,
        requestedAmount: requestedAmount,
        webFiles: mediaFiles?.cast<Uint8List>(),
        fileNames: fileNames,
      );

      state = const AsyncValue.data(null);
      DebugLogger.log('✅ DISPUTE CONTROLLER: Dispute opened with ID: $caseId');
      return caseId;
    } catch (e, stackTrace) {
      DebugLogger.log('❌ DISPUTE CONTROLLER: Error opening dispute: $e');
      state = AsyncValue.error(e, stackTrace);
      return null;
    }
  }

  Future<bool> addEvidence({
    required String caseId,
    required String role, // 'customer' or 'pro'
    String? text,
    List<dynamic>? mediaFiles,
    List<String>? fileNames,
  }) async {
    try {
      DebugLogger.log('🎮 DISPUTE CONTROLLER: Adding evidence to case $caseId');
      state = const AsyncValue.loading();

      if (role == 'customer') {
        await _repo.addCustomerEvidence(
          caseId: caseId,
          text: text,
          webFiles: mediaFiles?.cast<Uint8List>(),
          fileNames: fileNames,
        );
      } else if (role == 'pro') {
        await _repo.addProResponse(
          caseId: caseId,
          text: text,
          webFiles: mediaFiles?.cast<Uint8List>(),
          fileNames: fileNames,
        );
      }

      state = const AsyncValue.data(null);
      DebugLogger.log('✅ DISPUTE CONTROLLER: Evidence added successfully');
      return true;
    } catch (e, stackTrace) {
      DebugLogger.log('❌ DISPUTE CONTROLLER: Error adding evidence: $e');
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  Future<bool> resolveDispute({
    required String caseId,
    required String decision,
    double? amount,
  }) async {
    try {
      DebugLogger.log('🎮 DISPUTE CONTROLLER: Resolving dispute $caseId');
      state = const AsyncValue.loading();

      await _repo.resolveDispute(
        caseId: caseId,
        decision: decision,
        amount: amount,
      );

      state = const AsyncValue.data(null);
      DebugLogger.log('✅ DISPUTE CONTROLLER: Dispute resolved successfully');
      return true;
    } catch (e, stackTrace) {
      DebugLogger.log('❌ DISPUTE CONTROLLER: Error resolving dispute: $e');
      state = AsyncValue.error(e, stackTrace);
      return false;
    }
  }

  Future<String?> getEvidenceUrl(String path) async {
    try {
      return await _repo.getEvidenceDownloadUrl(path);
    } catch (e) {
      DebugLogger.log('❌ DISPUTE CONTROLLER: Error getting evidence URL: $e');
      return null;
    }
  }

  Future<bool> checkActiveDisputes(String jobId) async {
    try {
      return await _repo.hasActiveDisputes(jobId);
    } catch (e) {
      DebugLogger.log(
        '❌ DISPUTE CONTROLLER: Error checking active disputes: $e',
      );
      return false;
    }
  }
}

// Controller provider
final disputeControllerProvider =
    StateNotifierProvider<DisputeController, AsyncValue<void>>((ref) {
      final repo = ref.watch(disputesRepositoryProvider);
      return DisputeController(repo);
    });

// Helper to check if user is admin
final isAdminProvider = FutureProvider<bool>((ref) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final idTokenResult = await user.getIdTokenResult();
    final claims = idTokenResult.claims;

    return claims?['role'] == 'admin' || AdminWhitelist.contains(user.email);
  } catch (e) {
    DebugLogger.log('❌ DISPUTE CONTROLLER: Error checking admin status: $e');
    return false;
  }
});

// Helper to get user role
final userRoleProvider = FutureProvider<String?>((ref) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final idTokenResult = await user.getIdTokenResult();
    final claims = idTokenResult.claims;

    final role = claims?['role'] as String?;
    if (role == 'admin' || AdminWhitelist.contains(user.email)) {
      return 'admin';
    }
    return role;
  } catch (e) {
    DebugLogger.log('❌ DISPUTE CONTROLLER: Error getting user role: $e');
    return null;
  }
});

import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/document.dart';
import '../data/documents_repository.dart';

/// Controller for document verification logic and state
class DocumentsController extends StateNotifier<AsyncValue<List<Document>>> {
  DocumentsController(this._repository) : super(const AsyncValue.loading());

  final DocumentsRepository _repository;
  String? _currentProUid;

  /// Load documents for current Pro user
  void loadDocuments(String proUid) {
    if (_currentProUid != proUid) {
      _currentProUid = proUid;
      // Reset state when switching users
      state = const AsyncValue.loading();
    }

    // Subscribe to real-time updates
    _repository.getDocumentsStream(proUid).listen(
      (documents) {
        if (mounted) {
          state = AsyncValue.data(documents);
        }
      },
      onError: (error, stackTrace) {
        if (mounted) {
          state = AsyncValue.error(error, stackTrace);
        }
      },
    );
  }

  /// Upload new document
  Future<Document> uploadDocument({
    required String proUid,
    required DocumentType type,
    required File file,
    required String fileName,
  }) async {
    try {
      final document = await _repository.uploadDocument(
        proUid: proUid,
        type: type,
        file: file,
        originalFileName: fileName,
      );

      // Document will be automatically updated via stream
      return document;
    } catch (e) {
      rethrow;
    }
  }

  /// Delete document
  Future<void> deleteDocument(String documentId) async {
    try {
      await _repository.deleteDocument(documentId);
      // Document will be automatically removed via stream
    } catch (e) {
      rethrow;
    }
  }

  /// Get verification summary
  Future<Map<String, dynamic>> getVerificationSummary(String proUid) async {
    return _repository.getVerificationSummary(proUid);
  }

  /// Check if user is fully verified
  Future<bool> isFullyVerified(String proUid) async {
    return _repository.isFullyVerified(proUid);
  }

  /// Update document status (admin only)
  Future<void> updateDocumentStatus({
    required String documentId,
    required DocumentStatus status,
    String? rejectionReason,
    String? reviewerUid,
  }) async {
    try {
      await _repository.updateDocumentStatus(
        documentId: documentId,
        status: status,
        rejectionReason: rejectionReason,
        reviewerUid: reviewerUid,
      );
    } catch (e) {
      rethrow;
    }
  }
}

/// Provider for DocumentsController
final documentsControllerProvider =
    StateNotifierProvider<DocumentsController, AsyncValue<List<Document>>>(
        (ref) {
  final repository = ref.watch(documentsRepositoryProvider);
  return DocumentsController(repository);
});

/// Provider for documents stream by status (for admin)
final documentsByStatusProvider = StreamProvider.family
    .autoDispose<List<Document>, DocumentStatus>((ref, status) {
  final repository = ref.watch(documentsRepositoryProvider);
  return repository.getDocumentsByStatus(status);
});

/// Provider for verification summary
final verificationSummaryProvider = FutureProvider.family
    .autoDispose<Map<String, dynamic>, String>((ref, proUid) {
  final repository = ref.watch(documentsRepositoryProvider);
  return repository.getVerificationSummary(proUid);
});

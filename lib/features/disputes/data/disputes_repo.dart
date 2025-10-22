import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import '../../../core/models/dispute.dart';
import '../../../core/utils/debug_logger.dart';

class DisputesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection reference
  CollectionReference<Map<String, dynamic>> get _disputesCollection =>
      _firestore.collection('disputes');

  // Open a new dispute
  Future<String> openDispute({
    required String jobId,
    required String paymentId,
    required DisputeReason reason,
    required String description,
    required double requestedAmount,
    List<File>? mediaFiles,
    List<Uint8List>? webFiles,
    List<String>? fileNames,
  }) async {
    try {
      DebugLogger.debug('📋 DISPUTES DEBUG: Opening dispute for job $jobId');

      // Upload media files first if any
      List<String> mediaPaths = [];
      if (mediaFiles != null && mediaFiles.isNotEmpty) {
        for (int i = 0; i < mediaFiles.length; i++) {
          final path = await _uploadMedia(
            file: mediaFiles[i],
            caseId:
                'temp_${const Uuid().v4()}', // Will be updated after case creation
          );
          mediaPaths.add(path);
        }
      } else if (webFiles != null && webFiles.isNotEmpty) {
        for (int i = 0; i < webFiles.length; i++) {
          final path = await _uploadWebMedia(
            data: webFiles[i],
            fileName: fileNames?[i] ?? 'file_$i',
            caseId: 'temp_${const Uuid().v4()}',
          );
          mediaPaths.add(path);
        }
      }

      // Call Cloud Function to create dispute
      final callable = _functions.httpsCallable('openDispute');
      final result = await callable.call({
        'jobId': jobId,
        'paymentId': paymentId,
        'reason': reason.name,
        'description': description,
        'requestedAmount': requestedAmount,
        'mediaPaths': mediaPaths,
      });

      final caseId = result.data['caseId'] as String;
      DebugLogger.debug(
          '✅ DISPUTES DEBUG: Dispute opened with case ID: $caseId');

      // Update media paths with actual case ID if any were uploaded
      if (mediaPaths.isNotEmpty) {
        await _updateMediaPaths(mediaPaths, caseId);
      }

      return caseId;
    } catch (e, stackTrace) {
      DebugLogger.error('❌ DISPUTES DEBUG: Error opening dispute: $e');
      DebugLogger.error('📍 DISPUTES DEBUG: Stack trace: $stackTrace');
      rethrow;
    }
  }

  // Add evidence to existing dispute
  Future<void> addCustomerEvidence({
    required String caseId,
    String? text,
    List<File>? mediaFiles,
    List<Uint8List>? webFiles,
    List<String>? fileNames,
  }) async {
    try {
      DebugLogger.debug(
          '📋 DISPUTES DEBUG: Adding customer evidence to case $caseId');

      // Upload media files
      List<String> mediaPaths = [];
      if (mediaFiles != null && mediaFiles.isNotEmpty) {
        for (int i = 0; i < mediaFiles.length; i++) {
          final path = await _uploadMedia(
            file: mediaFiles[i],
            caseId: caseId,
          );
          mediaPaths.add(path);
        }
      } else if (webFiles != null && webFiles.isNotEmpty) {
        for (int i = 0; i < webFiles.length; i++) {
          final path = await _uploadWebMedia(
            data: webFiles[i],
            fileName: fileNames?[i] ?? 'file_$i',
            caseId: caseId,
          );
          mediaPaths.add(path);
        }
      }

      // Call Cloud Function to add evidence
      final callable = _functions.httpsCallable('addEvidence');
      await callable.call({
        'caseId': caseId,
        'role': 'customer',
        'text': text,
        'mediaPaths': mediaPaths,
      });

      DebugLogger.debug(
          '✅ DISPUTES DEBUG: Customer evidence added successfully');
    } catch (e, stackTrace) {
      DebugLogger.error('❌ DISPUTES DEBUG: Error adding customer evidence: $e');
      DebugLogger.error('📍 DISPUTES DEBUG: Stack trace: $stackTrace');
      rethrow;
    }
  }

  // Add pro response to dispute
  Future<void> addProResponse({
    required String caseId,
    String? text,
    List<File>? mediaFiles,
    List<Uint8List>? webFiles,
    List<String>? fileNames,
  }) async {
    try {
      DebugLogger.debug(
          '📋 DISPUTES DEBUG: Adding pro response to case $caseId');

      // Upload media files
      List<String> mediaPaths = [];
      if (mediaFiles != null && mediaFiles.isNotEmpty) {
        for (int i = 0; i < mediaFiles.length; i++) {
          final path = await _uploadMedia(
            file: mediaFiles[i],
            caseId: caseId,
          );
          mediaPaths.add(path);
        }
      } else if (webFiles != null && webFiles.isNotEmpty) {
        for (int i = 0; i < webFiles.length; i++) {
          final path = await _uploadWebMedia(
            data: webFiles[i],
            fileName: fileNames?[i] ?? 'file_$i',
            caseId: caseId,
          );
          mediaPaths.add(path);
        }
      }

      // Call Cloud Function to add response
      final callable = _functions.httpsCallable('addEvidence');
      await callable.call({
        'caseId': caseId,
        'role': 'pro',
        'text': text,
        'mediaPaths': mediaPaths,
      });

      DebugLogger.debug('✅ DISPUTES DEBUG: Pro response added successfully');
    } catch (e, stackTrace) {
      DebugLogger.error('❌ DISPUTES DEBUG: Error adding pro response: $e');
      DebugLogger.error('📍 DISPUTES DEBUG: Stack trace: $stackTrace');
      rethrow;
    }
  }

  // Admin resolve dispute
  Future<void> resolveDispute({
    required String caseId,
    required String
        decision, // 'refund_full', 'refund_partial', 'no_refund', 'cancelled'
    double? amount,
  }) async {
    try {
      DebugLogger.debug(
          '📋 DISPUTES DEBUG: Resolving dispute $caseId with decision: $decision');

      final callable = _functions.httpsCallable('resolveDispute');
      await callable.call({
        'caseId': caseId,
        'decision': decision,
        'amount': amount,
      });

      DebugLogger.debug('✅ DISPUTES DEBUG: Dispute resolved successfully');
    } catch (e, stackTrace) {
      DebugLogger.error('❌ DISPUTES DEBUG: Error resolving dispute: $e');
      DebugLogger.error('📍 DISPUTES DEBUG: Stack trace: $stackTrace');
      rethrow;
    }
  }

  // Watch single dispute
  Stream<Dispute?> watchDispute(String caseId) {
    try {
      DebugLogger.debug('📋 DISPUTES DEBUG: Watching dispute $caseId');

      return _disputesCollection.doc(caseId).snapshots().map((snapshot) {
        if (!snapshot.exists) return null;
        return Dispute.fromFirestore(snapshot);
      });
    } catch (e, stackTrace) {
      DebugLogger.error('❌ DISPUTES DEBUG: Error watching dispute: $e');
      DebugLogger.error('📍 DISPUTES DEBUG: Stack trace: $stackTrace');
      rethrow;
    }
  }

  // List disputes for current user
  Stream<List<Dispute>> listMyDisputes() {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        DebugLogger.error('❌ DISPUTES DEBUG: No authenticated user');
        return Stream.value([]);
      }

      DebugLogger.log('📋 DISPUTES DEBUG: Listing disputes for user ${currentUser.uid}');

      return _disputesCollection
          .where(Filter.or(
            Filter('customerUid', isEqualTo: currentUser.uid),
            Filter('proUid', isEqualTo: currentUser.uid),
          ))
          .orderBy('openedAt', descending: true)
          .snapshots()
          .map((snapshot) =>
              snapshot.docs.map((doc) => Dispute.fromFirestore(doc)).toList());
    } catch (e, stackTrace) {
      DebugLogger.log('❌ DISPUTES DEBUG: Error listing disputes: $e');
      DebugLogger.log('📍 DISPUTES DEBUG: Stack trace: $stackTrace');
      return Stream.value([]);
    }
  }

  // List all disputes for admin
  Stream<List<Dispute>> listAllDisputes({DisputeStatus? statusFilter}) {
    try {
      DebugLogger.log('📋 DISPUTES DEBUG: Listing all disputes for admin');

      Query<Map<String, dynamic>> query = _disputesCollection;

      if (statusFilter != null) {
        query = query.where('status', isEqualTo: statusFilter.name);
      }

      return query.orderBy('openedAt', descending: true).snapshots().map(
          (snapshot) =>
              snapshot.docs.map((doc) => Dispute.fromFirestore(doc)).toList());
    } catch (e, stackTrace) {
      DebugLogger.log('❌ DISPUTES DEBUG: Error listing all disputes: $e');
      DebugLogger.log('📍 DISPUTES DEBUG: Stack trace: $stackTrace');
      return Stream.value([]);
    }
  }

  // Get dispute by ID
  Future<Dispute?> getDispute(String caseId) async {
    try {
      DebugLogger.log('📋 DISPUTES DEBUG: Getting dispute $caseId');

      final doc = await _disputesCollection.doc(caseId).get();
      if (!doc.exists) return null;

      return Dispute.fromFirestore(doc);
    } catch (e, stackTrace) {
      DebugLogger.log('❌ DISPUTES DEBUG: Error getting dispute: $e');
      DebugLogger.log('📍 DISPUTES DEBUG: Stack trace: $stackTrace');
      rethrow;
    }
  }

  // Check if job has active disputes
  Future<bool> hasActiveDisputes(String jobId) async {
    try {
      DebugLogger.log('📋 DISPUTES DEBUG: Checking active disputes for job $jobId');

      final snapshot = await _disputesCollection
          .where('jobId', isEqualTo: jobId)
          .where('status', whereIn: ['open', 'awaiting_pro', 'under_review'])
          .limit(1)
          .get();

      final hasActive = snapshot.docs.isNotEmpty;
      DebugLogger.log('📋 DISPUTES DEBUG: Job $jobId has active disputes: $hasActive');

      return hasActive;
    } catch (e, stackTrace) {
      DebugLogger.log('❌ DISPUTES DEBUG: Error checking active disputes: $e');
      DebugLogger.log('📍 DISPUTES DEBUG: Stack trace: $stackTrace');
      return false;
    }
  }

  // Private helper methods
  Future<String> _uploadMedia({
    required File file,
    required String caseId,
  }) async {
    try {
      final uuid = const Uuid().v4();
      final extension = file.path.split('.').last;
      final path = 'disputes_media/$caseId/$uuid.$extension';

      DebugLogger.log('📁 DISPUTES DEBUG: Uploading file to $path');

      final ref = _storage.ref().child(path);
      await ref.putFile(file);

      DebugLogger.log('✅ DISPUTES DEBUG: File uploaded successfully');
      return path;
    } catch (e, stackTrace) {
      DebugLogger.log('❌ DISPUTES DEBUG: Error uploading file: $e');
      DebugLogger.log('📍 DISPUTES DEBUG: Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<String> _uploadWebMedia({
    required Uint8List data,
    required String fileName,
    required String caseId,
  }) async {
    try {
      final uuid = const Uuid().v4();
      final extension = fileName.split('.').last;
      final path = 'disputes_media/$caseId/$uuid.$extension';

      DebugLogger.log('📁 DISPUTES DEBUG: Uploading web file to $path');

      final ref = _storage.ref().child(path);
      await ref.putData(data);

      DebugLogger.log('✅ DISPUTES DEBUG: Web file uploaded successfully');
      return path;
    } catch (e, stackTrace) {
      DebugLogger.log('❌ DISPUTES DEBUG: Error uploading web file: $e');
      DebugLogger.log('📍 DISPUTES DEBUG: Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<void> _updateMediaPaths(List<String> oldPaths, String caseId) async {
    try {
      DebugLogger.log('📁 DISPUTES DEBUG: Updating media paths for case $caseId');

      for (final oldPath in oldPaths) {
        final oldRef = _storage.ref().child(oldPath);
        final data = await oldRef.getData();

        final newPath = oldPath.replaceFirst(RegExp(r'temp_[^/]+'), caseId);
        final newRef = _storage.ref().child(newPath);

        await newRef.putData(data!);
        await oldRef.delete();

        DebugLogger.log('📁 DISPUTES DEBUG: Moved $oldPath to $newPath');
      }
    } catch (e, stackTrace) {
      DebugLogger.log('❌ DISPUTES DEBUG: Error updating media paths: $e');
      DebugLogger.log('📍 DISPUTES DEBUG: Stack trace: $stackTrace');
      // Don't rethrow - this is cleanup, not critical
    }
  }

  // Get download URL for evidence
  Future<String> getEvidenceDownloadUrl(String path) async {
    try {
      DebugLogger.log('📁 DISPUTES DEBUG: Getting download URL for $path');

      final ref = _storage.ref().child(path);
      final url = await ref.getDownloadURL();

      DebugLogger.log('✅ DISPUTES DEBUG: Download URL obtained');
      return url;
    } catch (e, stackTrace) {
      DebugLogger.log('❌ DISPUTES DEBUG: Error getting download URL: $e');
      DebugLogger.log('📍 DISPUTES DEBUG: Stack trace: $stackTrace');
      rethrow;
    }
  }
}

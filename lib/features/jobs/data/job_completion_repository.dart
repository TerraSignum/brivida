import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/utils/debug_logger.dart';
import '../models/job_completion.dart';

class JobCompletionRepository {
  JobCompletionRepository({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    FirebaseAuth? auth,
    Uuid? uuid,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _storage = storage ?? FirebaseStorage.instance,
       _auth = auth ?? FirebaseAuth.instance,
       _uuid = uuid ?? const Uuid();

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final FirebaseAuth _auth;
  final Uuid _uuid;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('jobCompletions');

  DocumentReference<Map<String, dynamic>> _doc(String jobId) =>
      _collection.doc(jobId);

  Stream<JobCompletion?> watchCompletion(String jobId) {
    DebugLogger.debug('📡 JOB_COMPLETION: Watching completion doc', {
      'jobId': jobId,
    });
    return _doc(jobId).snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        return null;
      }
      final data = snapshot.data()!;
      return JobCompletion.fromMap(data, jobId: jobId);
    });
  }

  Future<String> uploadPhoto(String jobId, File file) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'unauthenticated',
        message: 'User must be signed in to upload completion photos',
      );
    }

    final photoId = _uuid.v4();
    final storageRef = _storage.ref().child(
      'job_completion/$jobId/$photoId.jpg',
    );

    try {
      DebugLogger.debug('📸 JOB_COMPLETION: Uploading photo', {
        'jobId': jobId,
        'photoId': photoId,
        'uid': user.uid,
      });
      final uploadTask = storageRef.putFile(
        file,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      await uploadTask.whenComplete(() {});
      final url = await storageRef.getDownloadURL();
      DebugLogger.debug('✅ JOB_COMPLETION: Photo uploaded', {
        'jobId': jobId,
        'photoId': photoId,
      });
      return url;
    } catch (error, stackTrace) {
      DebugLogger.error(
        '❌ JOB_COMPLETION: Failed to upload photo',
        error,
        stackTrace,
      );
      rethrow;
    }
  }

  Future<void> submitCompletion({
    required String jobId,
    required List<JobCompletionChecklistItem> checklist,
    required List<String> photoUrls,
    required String note,
    required String role,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'unauthenticated',
        message: 'User must be signed in to submit completion',
      );
    }

    final payload = {
      'jobId': jobId,
      'submittedByUid': user.uid,
      'submittedByRole': role,
      'checklist': checklist.map((item) => item.toMap()).toList(),
      'photoUrls': photoUrls,
      'note': note,
      'status': 'submitted',
      'submittedAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'approvedAt': null,
      'approvedByUid': null,
    };

    try {
      DebugLogger.database('set', 'jobCompletions', {
        'jobId': jobId,
        'uid': user.uid,
        'status': 'submitted',
        'photos': photoUrls.length,
        'checklistCount': checklist.length,
      });
      await _doc(jobId).set(payload, SetOptions(merge: true));
      DebugLogger.debug('✅ JOB_COMPLETION: Submission stored', {
        'jobId': jobId,
        'uid': user.uid,
      });
    } catch (error, stackTrace) {
      DebugLogger.error(
        '❌ JOB_COMPLETION: Failed to submit completion',
        error,
        stackTrace,
      );
      rethrow;
    }
  }

  Future<void> approveCompletion(String jobId) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'unauthenticated',
        message: 'User must be signed in to approve completion',
      );
    }

    final payload = {
      'status': 'approved',
      'approvedAt': FieldValue.serverTimestamp(),
      'approvedByUid': user.uid,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    try {
      DebugLogger.database('update', 'jobCompletions', {
        'jobId': jobId,
        'uid': user.uid,
        'status': 'approved',
      });
      await _doc(jobId).set(payload, SetOptions(merge: true));
      DebugLogger.debug('✅ JOB_COMPLETION: Approval stored', {
        'jobId': jobId,
        'uid': user.uid,
      });
    } catch (error, stackTrace) {
      DebugLogger.error(
        '❌ JOB_COMPLETION: Failed to approve completion',
        error,
        stackTrace,
      );
      rethrow;
    }
  }
}

final jobCompletionRepositoryProvider = Provider<JobCompletionRepository>((
  ref,
) {
  return JobCompletionRepository(
    firestore: FirebaseFirestore.instance,
    storage: FirebaseStorage.instance,
    auth: FirebaseAuth.instance,
  );
});

final jobCompletionProvider = StreamProvider.autoDispose
    .family<JobCompletion?, String>((ref, jobId) {
      final repo = ref.watch(jobCompletionRepositoryProvider);
      return repo.watchCompletion(jobId);
    });

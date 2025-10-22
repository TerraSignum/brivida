import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/document.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/utils/debug_logger.dart';

/// Repository for document upload, verification and management
class DocumentsRepository {
  DocumentsRepository({
    required this.firestore,
    required this.storage,
  });

  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  /// Upload document file to Firebase Storage and create Firestore record
  Future<Document> uploadDocument({
    required String proUid,
    required DocumentType type,
    required File file,
    required String originalFileName,
  }) async {
    try {
      // Generate unique storage path
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = originalFileName.split('.').last;
      final storageFileName = '${type.name}_$timestamp.$extension';
      final storagePath = 'documents/$proUid/$storageFileName';

      // Upload file to Firebase Storage
      final storageRef = storage.ref().child(storagePath);
      final uploadTask = await storageRef.putFile(
        file,
        SettableMetadata(
          contentType: _getContentType(extension),
          customMetadata: {
            'proUid': proUid,
            'documentType': type.name,
            'originalName': originalFileName,
          },
        ),
      );

      // Get download URL
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      // Create document record in Firestore
      final docRef = firestore.collection('documents').doc();
      final document = Document(
        id: docRef.id,
        proUid: proUid,
        type: type,
        fileName: originalFileName,
        storageUrl: downloadUrl,
        storagePath: storagePath,
        status: DocumentStatus.reviewing,
        uploadedAt: DateTime.now(),
      );

      await docRef.set(document.toJson());

      return document;
    } catch (e) {
      throw Exception('Failed to upload document: $e');
    }
  }

  /// Upload document from bytes (for web platform)
  Future<Document> uploadDocumentFromBytes({
    required String proUid,
    required DocumentType type,
    required Uint8List bytes,
    required String fileName,
  }) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final extension = fileName.split('.').last;
      final storageFileName = '${type.name}_$timestamp.$extension';
      final storagePath = 'documents/$proUid/$storageFileName';

      final storageRef = storage.ref().child(storagePath);
      final uploadTask = await storageRef.putData(
        bytes,
        SettableMetadata(
          contentType: _getContentType(extension),
          customMetadata: {
            'proUid': proUid,
            'documentType': type.name,
            'originalName': fileName,
          },
        ),
      );

      final downloadUrl = await uploadTask.ref.getDownloadURL();

      final docRef = firestore.collection('documents').doc();
      final document = Document(
        id: docRef.id,
        proUid: proUid,
        type: type,
        fileName: fileName,
        storageUrl: downloadUrl,
        storagePath: storagePath,
        status: DocumentStatus.reviewing,
        uploadedAt: DateTime.now(),
      );

      await docRef.set(document.toJson());

      return document;
    } catch (e) {
      throw Exception('Failed to upload document from bytes: $e');
    }
  }

  /// Get all documents for a Pro user
  Stream<List<Document>> getDocumentsStream(String proUid) {
    return firestore
        .collection('documents')
        .where('proUid', isEqualTo: proUid)
        .orderBy('uploadedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Document.fromJson({...data, 'id': doc.id});
      }).toList();
    });
  }

  /// Get documents by status for admin review
  Stream<List<Document>> getDocumentsByStatus(DocumentStatus status) {
    return firestore
        .collection('documents')
        .where('status', isEqualTo: status.name)
        .orderBy('uploadedAt')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Document.fromJson({...data, 'id': doc.id});
      }).toList();
    });
  }

  /// Update document status (admin only via Cloud Function)
  Future<void> updateDocumentStatus({
    required String documentId,
    required DocumentStatus status,
    String? rejectionReason,
    String? reviewerUid,
  }) async {
    final updates = <String, dynamic>{
      'status': status.name,
      'reviewedAt': FieldValue.serverTimestamp(),
    };

    if (rejectionReason != null) {
      updates['rejectionReason'] = rejectionReason;
    }

    if (reviewerUid != null) {
      updates['reviewerUid'] = reviewerUid;
    }

    await firestore.collection('documents').doc(documentId).update(updates);
  }

  /// Delete document and its file from storage
  Future<void> deleteDocument(String documentId) async {
    final docSnapshot =
        await firestore.collection('documents').doc(documentId).get();

    if (!docSnapshot.exists) {
      throw Exception('Document not found');
    }

    final document = Document.fromJson({
      ...docSnapshot.data()!,
      'id': docSnapshot.id,
    });

    // Delete file from Storage if path exists
    if (document.storagePath != null) {
      try {
        await storage.ref().child(document.storagePath!).delete();
      } catch (e) {
        // File might already be deleted, continue with Firestore deletion
        DebugLogger.log('Warning: Could not delete storage file: $e');
      }
    }

    // Delete Firestore document
    await firestore.collection('documents').doc(documentId).delete();
  }

  /// Check if Pro user has all required documents approved
  Future<bool> isFullyVerified(String proUid) async {
    final requiredTypes = [
      DocumentType.idCard,
      DocumentType.criminalRecord,
      DocumentType.insuranceCertificate,
    ];

    final snapshot = await firestore
        .collection('documents')
        .where('proUid', isEqualTo: proUid)
        .where('status', isEqualTo: DocumentStatus.approved.name)
        .get();

    final approvedTypes = snapshot.docs
        .map((doc) => DocumentType.values.byName(doc.data()['type']))
        .toSet();

    return requiredTypes.every((type) => approvedTypes.contains(type));
  }

  /// Get verification summary for Pro user
  Future<Map<String, dynamic>> getVerificationSummary(String proUid) async {
    final snapshot = await firestore
        .collection('documents')
        .where('proUid', isEqualTo: proUid)
        .get();

    final documents = snapshot.docs.map((doc) {
      final data = doc.data();
      return Document.fromJson({...data, 'id': doc.id});
    }).toList();

    final requiredTypes = [
      DocumentType.idCard,
      DocumentType.criminalRecord,
      DocumentType.insuranceCertificate,
    ];

    final approvedCount = documents
        .where((doc) =>
            requiredTypes.contains(doc.type) &&
            doc.status == DocumentStatus.approved)
        .length;

    final pendingCount = documents
        .where((doc) =>
            requiredTypes.contains(doc.type) &&
            doc.status == DocumentStatus.reviewing)
        .length;

    final rejectedCount = documents
        .where((doc) =>
            requiredTypes.contains(doc.type) &&
            doc.status == DocumentStatus.rejected)
        .length;

    return {
      'isFullyVerified': approvedCount == requiredTypes.length,
      'totalRequired': requiredTypes.length,
      'approvedCount': approvedCount,
      'pendingCount': pendingCount,
      'rejectedCount': rejectedCount,
      'documents': documents,
    };
  }

  /// Helper method to determine content type from file extension
  String _getContentType(String extension) {
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'pdf':
        return 'application/pdf';
      default:
        return 'application/octet-stream';
    }
  }
}

/// Provider for DocumentsRepository
final documentsRepositoryProvider = Provider<DocumentsRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final storage = ref.watch(firebaseStorageProvider);

  return DocumentsRepository(
    firestore: firestore,
    storage: storage,
  );
});

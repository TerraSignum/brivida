import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/models/legal.dart';
import '../../../core/utils/debug_logger.dart';
import '../data/legal_repo.dart';

/// Service for handling legal version migrations and user consent updates
class LegalMigrationService {
  LegalMigrationService(this._legalRepo, this._firestore);

  final LegalRepository _legalRepo;
  final FirebaseFirestore _firestore;

  /// Check if user needs to accept updated legal documents
  Future<LegalMigrationResult> checkForRequiredUpdates(String userId) async {
    DebugLogger.enter('LegalMigrationService.checkForRequiredUpdates', {
      'userId': userId,
    });

    try {
      // Get current versions
      final currentVersions = await _legalRepo.getCurrentVersions();
      DebugLogger.debug('Current versions: $currentVersions');

      // Get user's consented versions
      final userConsentDoc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('consent')
          .doc('legal')
          .get();

      if (!userConsentDoc.exists) {
        // User has never consented - needs full acceptance
        return LegalMigrationResult(
          requiresUpdate: true,
          outdatedDocuments: LegalDocType.values.toSet(),
          currentVersions: currentVersions,
          userVersions: {},
        );
      }

      final userData = userConsentDoc.data()!;
      final userVersions = <LegalDocType, String>{
        LegalDocType.tos: userData['tosVersion'] ?? '',
        LegalDocType.privacy: userData['privacyVersion'] ?? '',
        LegalDocType.refund: userData['refundVersion'] ?? '',
        LegalDocType.guidelines: userData['guidelinesVersion'] ?? '',
      };

      // Check for outdated documents
      final outdatedDocuments = <LegalDocType>{};
      for (final docType in LegalDocType.values) {
        final currentVersion = currentVersions[docType];
        final userVersion = userVersions[docType];

        if (currentVersion != null && userVersion != currentVersion) {
          outdatedDocuments.add(docType);
        }
      }

      return LegalMigrationResult(
        requiresUpdate: outdatedDocuments.isNotEmpty,
        outdatedDocuments: outdatedDocuments,
        currentVersions: currentVersions,
        userVersions: userVersions,
      );
    } catch (e, stackTrace) {
      DebugLogger.error('Failed to check legal updates', e, stackTrace);
      rethrow;
    } finally {
      DebugLogger.exit(
        'LegalMigrationService.checkForRequiredUpdates',
        'completed',
      );
    }
  }

  /// Update user consent with new versions
  Future<void> updateConsent({
    required String userId,
    required Set<LegalDocType> documentsToUpdate,
    required Map<LegalDocType, String> newVersions,
    required SupportedLanguage language,
  }) async {
    DebugLogger.enter('LegalMigrationService.updateConsent', {
      'userId': userId,
      'documentsCount': documentsToUpdate.length,
      'language': language.name,
    });

    try {
      final consentRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('consent')
          .doc('legal');

      final updateData = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
        'consentedLang': language.name,
      };

      // Add version updates
      for (final docType in documentsToUpdate) {
        final version = newVersions[docType];
        if (version != null) {
          switch (docType) {
            case LegalDocType.tos:
              updateData['tosVersion'] = version;
              updateData['tosAcceptedAt'] = FieldValue.serverTimestamp();
              break;
            case LegalDocType.privacy:
              updateData['privacyVersion'] = version;
              updateData['privacyAcceptedAt'] = FieldValue.serverTimestamp();
              break;
            case LegalDocType.refund:
              updateData['refundVersion'] = version;
              updateData['refundAcceptedAt'] = FieldValue.serverTimestamp();
              break;
            case LegalDocType.guidelines:
              updateData['guidelinesVersion'] = version;
              updateData['guidelinesAcceptedAt'] = FieldValue.serverTimestamp();
              break;
            case LegalDocType.impressum:
              updateData['impressumVersion'] = version;
              updateData['impressumAcceptedAt'] = FieldValue.serverTimestamp();
              break;
          }
        }
      }

      // Use set with merge to handle the case where the consent document
      // does not yet exist. update() would fail if the doc is missing.
      await consentRef.set(updateData, SetOptions(merge: true));

      DebugLogger.debug('Legal consent updated successfully');
    } catch (e, stackTrace) {
      DebugLogger.error('Failed to update consent', e, stackTrace);
      rethrow;
    } finally {
      DebugLogger.exit('LegalMigrationService.updateConsent', 'completed');
    }
  }

  /// Create migration audit log entry
  Future<void> logMigration({
    required String userId,
    required Set<LegalDocType> migratedDocuments,
    required Map<LegalDocType, String> fromVersions,
    required Map<LegalDocType, String> toVersions,
  }) async {
    try {
      final migrationLog = {
        'userId': userId,
        'migratedDocuments': migratedDocuments.map((e) => e.name).toList(),
        'fromVersions': fromVersions.map((k, v) => MapEntry(k.name, v)),
        'toVersions': toVersions.map((k, v) => MapEntry(k.name, v)),
        'migratedAt': FieldValue.serverTimestamp(),
        'userAgent': 'brivida_app',
      };

      await _firestore.collection('legalMigrations').add(migrationLog);
    } catch (e) {
      // Don't fail the migration if audit logging fails
      DebugLogger.warning('Failed to log migration: $e');
    }
  }
}

/// Result of legal migration check
class LegalMigrationResult {
  const LegalMigrationResult({
    required this.requiresUpdate,
    required this.outdatedDocuments,
    required this.currentVersions,
    required this.userVersions,
  });

  final bool requiresUpdate;
  final Set<LegalDocType> outdatedDocuments;
  final Map<LegalDocType, String> currentVersions;
  final Map<LegalDocType, String> userVersions;

  /// Get human-readable description of what needs updating
  String getUpdateDescription() {
    if (!requiresUpdate) return 'Alle rechtlichen Dokumente sind aktuell';

    final docNames = outdatedDocuments.map((doc) {
      switch (doc) {
        case LegalDocType.tos:
          return 'Nutzungsbedingungen';
        case LegalDocType.privacy:
          return 'Datenschutzrichtlinie';
        case LegalDocType.refund:
          return 'Rückerstattungsrichtlinie';
        case LegalDocType.guidelines:
          return 'Community-Richtlinien';
        case LegalDocType.impressum:
          return 'Impressum';
      }
    }).toList();

    if (docNames.length == 1) {
      return '${docNames.first} wurde aktualisiert';
    } else {
      return '${docNames.length} rechtliche Dokumente wurden aktualisiert';
    }
  }

  /// Check if critical documents (ToS, Privacy) need updates
  bool get hasCriticalUpdates {
    return outdatedDocuments.contains(LegalDocType.tos) ||
        outdatedDocuments.contains(LegalDocType.privacy);
  }
}

/// Provider for LegalMigrationService
final legalMigrationServiceProvider = Provider<LegalMigrationService>((ref) {
  final legalRepo = ref.watch(legalRepositoryProvider);
  return LegalMigrationService(legalRepo, FirebaseFirestore.instance);
});

/// Provider to check if current user needs legal updates
final userLegalStatusProvider = FutureProvider<LegalMigrationResult?>((
  ref,
) async {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) return null;

  final migrationService = ref.watch(legalMigrationServiceProvider);
  return migrationService.checkForRequiredUpdates(user.uid);
});

/// Stream provider for real-time legal status updates
final userLegalStatusStreamProvider = StreamProvider<LegalMigrationResult?>((
  ref,
) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) return Stream.value(null);

  // Watch for changes in legal versions config
  return FirebaseFirestore.instance
      .collection('config')
      .doc('legalVersions')
      .snapshots()
      .asyncMap((_) async {
        final migrationService = ref.watch(legalMigrationServiceProvider);
        return migrationService.checkForRequiredUpdates(user.uid);
      });
});

/// Provider for Firebase Auth state changes
final authStateChangesProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

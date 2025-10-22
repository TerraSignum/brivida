import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/models/legal.dart';
import '../../../core/services/cloud_function_names.dart';
import '../../../core/utils/debug_logger.dart';

final legalRepositoryProvider = Provider<LegalRepository>((ref) {
  return LegalRepository();
});

class LegalRepository {
  static final _logger = Logger('LegalRepository');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instanceFor(
    region: 'europe-west1',
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ========================================
  // LEGAL DOCUMENTS
  // ========================================

  /// Get current legal document versions from Firestore
  Future<Map<LegalDocType, String>> getCurrentVersions() async {
    DebugLogger.enter('LegalRepository.getCurrentVersions', {});
    DebugLogger.startTimer('getCurrentVersions');

    try {
      // Get versions from Firestore config collection
      final versionsDoc = await _firestore
          .collection('config')
          .doc('legalVersions')
          .get();

      if (!versionsDoc.exists) {
        // Return default versions if config doesn't exist
        return {
          LegalDocType.tos: 'v1.0',
          LegalDocType.privacy: 'v1.0',
          LegalDocType.refund: 'v1.0',
          LegalDocType.guidelines: 'v1.0',
        };
      }

      final data = versionsDoc.data()!;
      return {
        LegalDocType.tos: data['termsVersion'] ?? 'v1.0',
        LegalDocType.privacy: data['privacyVersion'] ?? 'v1.0',
        LegalDocType.refund: data['refundVersion'] ?? 'v1.0',
        LegalDocType.guidelines: data['guidelinesVersion'] ?? 'v1.0',
      };
    } catch (e, stackTrace) {
      DebugLogger.error('❌ Failed to get current versions', e, stackTrace);
      // Return default versions on error
      return {
        LegalDocType.tos: 'v1.0',
        LegalDocType.privacy: 'v1.0',
        LegalDocType.refund: 'v1.0',
        LegalDocType.guidelines: 'v1.0',
      };
    } finally {
      DebugLogger.stopTimer('getCurrentVersions');
      DebugLogger.exit('LegalRepository.getCurrentVersions', 'completed');
    }
  }

  /// Get specific legal document by type, language and version
  Future<LegalDocument?> getLegalDoc({
    required LegalDocType type,
    required SupportedLanguage lang,
    String? version,
  }) async {
    DebugLogger.enter('LegalRepository.getLegalDoc', {
      'type': type.name,
      'lang': lang.name,
      'version': version ?? 'latest',
    });
    DebugLogger.startTimer('getLegalDoc');

    try {
      _logger.info(
        '📄 Getting legal document: ${type.name}_${lang.name}_${version ?? 'latest'}',
      );

      DebugLogger.database('query', 'legalDocs', {
        'type': type.name,
        'lang': lang.name,
        'version': version,
        'isActive': true,
      });

      Query query = _firestore
          .collection('legalDocs')
          .where('type', isEqualTo: type.name)
          .where('lang', isEqualTo: lang.name)
          .where('isActive', isEqualTo: true);

      if (version != null) {
        query = query.where('version', isEqualTo: version);
        DebugLogger.debug('🎯 Querying specific version: $version');
      } else {
        // Get latest version
        query = query.orderBy('publishedAt', descending: true).limit(1);
        DebugLogger.debug('🎯 Querying latest version');
      }

      var snapshot = await query.get();
      DebugLogger.debug(
        '📊 Initial query result: ${snapshot.docs.length} documents',
      );

      // If no results with 'lang', try 'language' field (server convention)
      if (snapshot.docs.isEmpty) {
        _logger.info('📄 Retrying with language field instead of lang');
        DebugLogger.debug('🔄 Fallback query with language field');

        DebugLogger.database('fallback_query', 'legalDocs', {
          'type': type.name,
          'language': lang.name,
          'version': version,
          'isActive': true,
        });

        query = _firestore
            .collection('legalDocs')
            .where('type', isEqualTo: type.name)
            .where('language', isEqualTo: lang.name)
            .where('isActive', isEqualTo: true);

        if (version != null) {
          query = query.where('version', isEqualTo: version);
        } else {
          query = query.orderBy('publishedAt', descending: true).limit(1);
        }

        snapshot = await query.get();
        DebugLogger.debug(
          '📊 Fallback query result: ${snapshot.docs.length} documents',
        );
      }

      if (snapshot.docs.isEmpty) {
        _logger.warning(
          '📄 No legal document found for ${type.name}_${lang.name}',
        );
        DebugLogger.warning('❌ No documents found after both queries');
        DebugLogger.stopTimer('getLegalDoc');
        DebugLogger.exit('LegalRepository.getLegalDoc', null);
        return null;
      }

      final doc = snapshot.docs.first;
      DebugLogger.debug('📄 Found document: ${doc.id}');

      final legalDoc = LegalDocument.fromFirestore(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );

      _logger.info('✅ Legal document retrieved: ${legalDoc.firestoreId}');
      DebugLogger.performance(
        'getLegalDoc',
        DebugLogger.stopTimer('getLegalDoc')!,
      );
      DebugLogger.exit('LegalRepository.getLegalDoc', legalDoc.firestoreId);
      return legalDoc;
    } catch (error) {
      _logger.severe('❌ Error getting legal document', error);
      rethrow;
    }
  }

  /// Get latest version of a document type for a language
  Future<String?> getLatestVersion({
    required LegalDocType type,
    required SupportedLanguage lang,
  }) async {
    try {
      final doc = await getLegalDoc(type: type, lang: lang);
      return doc?.version;
    } catch (error) {
      _logger.severe('❌ Error getting latest version', error);
      return null;
    }
  }

  /// Get all documents for a specific type across all languages
  Future<List<LegalDocument>> getDocumentsByType(LegalDocType type) async {
    try {
      _logger.info('📄 Getting all documents for type: ${type.name}');

      final snapshot = await _firestore
          .collection('legalDocs')
          .where('type', isEqualTo: type.name)
          .where('isActive', isEqualTo: true)
          .orderBy('publishedAt', descending: true)
          .get();

      final documents = snapshot.docs
          .map((doc) => LegalDocument.fromFirestore(doc.data(), doc.id))
          .toList();

      _logger.info(
        '✅ Retrieved ${documents.length} documents for ${type.name}',
      );
      return documents;
    } catch (error) {
      _logger.severe('❌ Error getting documents by type', error);
      rethrow;
    }
  }

  /// Stream of legal documents for real-time updates
  Stream<List<LegalDocument>> streamLegalDocs({
    LegalDocType? type,
    SupportedLanguage? lang,
  }) {
    try {
      Query query = _firestore
          .collection('legalDocs')
          .where('isActive', isEqualTo: true);

      if (type != null) {
        query = query.where('type', isEqualTo: type.name);
      }

      if (lang != null) {
        query = query.where('lang', isEqualTo: lang.name);
      }

      return query
          .orderBy('publishedAt', descending: true)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map(
                  (doc) => LegalDocument.fromFirestore(
                    doc.data() as Map<String, dynamic>,
                    doc.id,
                  ),
                )
                .toList(),
          );
    } catch (error) {
      _logger.severe('❌ Error streaming legal docs', error);
      rethrow;
    }
  }

  // ========================================
  // USER CONSENT
  // ========================================

  /// Get user's consent record
  Future<UserConsent?> getUserConsent(String uid) async {
    DebugLogger.enter('LegalRepository.getUserConsent', {'uid': uid});
    DebugLogger.startTimer('getUserConsent');

    try {
      _logger.info('👤 Getting user consent for: $uid');

      // Try Firestore first
      try {
        DebugLogger.debug('🔍 Attempting Firestore query for consent');
        DebugLogger.database('get', 'userConsents', {'uid': uid});

        final doc = await _firestore.collection('userConsents').doc(uid).get();

        if (doc.exists) {
          DebugLogger.debug('✅ Found consent in Firestore');
          final consent = UserConsent.fromFirestore(doc.data()!, uid);
          _logger.info(
            '✅ User consent retrieved from Firestore: TOS ${consent.tosVersion}, Privacy ${consent.privacyVersion}',
          );

          DebugLogger.performance(
            'getUserConsent',
            DebugLogger.stopTimer('getUserConsent')!,
          );
          DebugLogger.exit(
            'LegalRepository.getUserConsent',
            'firestore_success',
          );
          return consent;
        } else {
          DebugLogger.debug('📭 No consent document found in Firestore');
        }
      } catch (firestoreError) {
        DebugLogger.warning(
          '⚠️ Firestore error, checking local storage',
          firestoreError,
        );
        _logger.warning(
          '⚠️ Firestore unavailable, checking local storage: $firestoreError',
        );
      }

      // Fallback to local storage
      try {
        DebugLogger.debug('🔍 Attempting local storage fallback');
        final prefs = await SharedPreferences.getInstance();
        final storageKey = 'user_consent_$uid';
        DebugLogger.cache('get', storageKey);

        final consentJson = prefs.getString(storageKey);

        if (consentJson != null) {
          DebugLogger.debug('✅ Found consent in local storage');
          final consentData = jsonDecode(consentJson);
          final consent = UserConsent.fromJson(consentData);
          _logger.info(
            '✅ User consent retrieved from local storage: TOS ${consent.tosVersion}, Privacy ${consent.privacyVersion}',
          );

          DebugLogger.performance(
            'getUserConsent',
            DebugLogger.stopTimer('getUserConsent')!,
          );
          DebugLogger.exit(
            'LegalRepository.getUserConsent',
            'local_storage_success',
          );
          return consent;
        } else {
          DebugLogger.debug('📭 No consent found in local storage');
        }
      } catch (localError) {
        DebugLogger.warning('⚠️ Local storage error', localError);
        _logger.warning('⚠️ Error reading from local storage: $localError');
      }

      _logger.info('👤 No consent record found for user: $uid');
      DebugLogger.warning('❌ No consent found in any storage method');
      DebugLogger.stopTimer('getUserConsent');
      DebugLogger.exit('LegalRepository.getUserConsent', null);
      return null;
    } catch (error) {
      DebugLogger.error('❌ Critical error in getUserConsent', error);
      _logger.severe('❌ Error getting user consent', error);
      DebugLogger.stopTimer('getUserConsent');
      DebugLogger.exit('LegalRepository.getUserConsent', 'error');
      rethrow;
    }
  }

  /// Save user consent (client-side)
  Future<void> saveConsent({
    required String uid,
    required String tosVersion,
    required String privacyVersion,
    required String consentedIp,
    required SupportedLanguage consentedLang,
    String? impressumVersion,
  }) async {
    try {
      _logger.info('📝 Saving user consent for: $uid');

      final consent = UserConsent(
        uid: uid,
        tosVersion: tosVersion,
        privacyVersion: privacyVersion,
        consentedAt: DateTime.now(),
        consentedIp: consentedIp,
        consentedLang: consentedLang,
        impressumVersion: impressumVersion,
        lastUpdated: DateTime.now(),
        needsReConsent: false,
      );

      await _firestore
          .collection('userConsents')
          .doc(uid)
          .set(consent.toFirestore());

      _logger.info('✅ User consent saved successfully');
    } catch (error) {
      _logger.severe('❌ Error saving user consent', error);
      rethrow;
    }
  }

  /// Save user consent via Cloud Function (with audit logging)
  Future<void> saveConsentSecure({
    required String tosVersion,
    required String privacyVersion,
    required SupportedLanguage consentedLang,
    String? impressumVersion,
  }) async {
    DebugLogger.enter('LegalRepository.saveConsentSecure', {
      'tosVersion': tosVersion,
      'privacyVersion': privacyVersion,
      'consentedLang': consentedLang.name,
      'impressumVersion': impressumVersion,
    });
    DebugLogger.startTimer('saveConsentSecure');

    try {
      _logger.info('🔒 Saving user consent via Cloud Function');

      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        DebugLogger.error('❌ No authenticated user for consent saving');
        throw Exception('User must be authenticated to save consent');
      }

      DebugLogger.debug('👤 Authenticated user: ${currentUser.uid}');

      final callable = _functions.httpsCallable(
        CloudFunctionNames.setUserConsentCF,
      );

      final payload = {
        'tosVersion': tosVersion,
        'privacyVersion': privacyVersion,
        'consentedLang': consentedLang.name,
        'impressumVersion': impressumVersion,
      };

      DebugLogger.apiCall('POST', 'setUserConsentCF', payload);

      final result = await callable.call(payload);

      DebugLogger.apiResponse('setUserConsentCF', 200, result.data);

      if (result.data['success'] == true) {
        _logger.info('✅ User consent saved securely via Cloud Function');
        DebugLogger.debug('✅ Cloud Function success response received');
      } else {
        DebugLogger.error(
          '❌ Cloud Function returned error',
          result.data['message'],
        );
        throw Exception(
          'Cloud Function returned error: ${result.data['message']}',
        );
      }
    } catch (error) {
      DebugLogger.warning(
        '⚠️ Cloud Function failed, attempting local fallback',
        error,
      );
      _logger.warning(
        '⚠️ Cloud Function failed, trying local fallback: $error',
      );

      // Fallback to local storage when Cloud Function fails
      try {
        DebugLogger.debug('🔄 Initiating local fallback for consent saving');
        await _saveConsentLocal(
          tosVersion: tosVersion,
          privacyVersion: privacyVersion,
          consentedLang: consentedLang,
          impressumVersion: impressumVersion,
        );
        _logger.info('✅ User consent saved locally as fallback');
        DebugLogger.debug('✅ Local fallback successful');
        DebugLogger.performance(
          'saveConsentSecure',
          DebugLogger.stopTimer('saveConsentSecure')!,
        );
        DebugLogger.exit(
          'LegalRepository.saveConsentSecure',
          'local_fallback_success',
        );
      } catch (localError) {
        DebugLogger.error('❌ Local fallback also failed', localError);
        _logger.severe(
          '❌ Both Cloud Function and local fallback failed',
          localError,
        );
        DebugLogger.stopTimer('saveConsentSecure');
        DebugLogger.exit('LegalRepository.saveConsentSecure', 'both_failed');
        rethrow;
      }
    }

    DebugLogger.performance(
      'saveConsentSecure',
      DebugLogger.stopTimer('saveConsentSecure')!,
    );
    DebugLogger.exit(
      'LegalRepository.saveConsentSecure',
      'cloud_function_success',
    );
  }

  /// Local fallback for saving consent when Cloud Functions are unavailable
  Future<void> _saveConsentLocal({
    required String tosVersion,
    required String privacyVersion,
    required SupportedLanguage consentedLang,
    String? impressumVersion,
  }) async {
    DebugLogger.enter('LegalRepository._saveConsentLocal', {
      'tosVersion': tosVersion,
      'privacyVersion': privacyVersion,
      'consentedLang': consentedLang.name,
      'impressumVersion': impressumVersion,
    });
    DebugLogger.startTimer('saveConsentLocal');

    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      DebugLogger.error('❌ No authenticated user for local consent saving');
      throw Exception('User must be authenticated to save consent');
    }

    _logger.info('💾 Saving consent locally for user: ${currentUser.uid}');
    DebugLogger.debug('👤 Local save for user: ${currentUser.uid}');

    DebugLogger.debug('🔧 Building UserConsent object');
    final consentData = UserConsent(
      uid: currentUser.uid,
      tosVersion: tosVersion,
      privacyVersion: privacyVersion,
      impressumVersion: impressumVersion,
      consentedAt: DateTime.now(),
      consentedIp: await getUserIpAddress(),
      consentedLang: consentedLang,
      needsReConsent: false,
    );

    DebugLogger.debug('📦 Serializing consent data');
    // Store locally using SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final consentJson = jsonEncode(consentData.toJson());

    final storageKey = 'user_consent_${currentUser.uid}';
    DebugLogger.cache('set', storageKey, 'consent_data');

    await prefs.setString(storageKey, consentJson);

    // Try to persist to Firestore directly as a best-effort fallback
    try {
      DebugLogger.debug('☁️ Syncing consent fallback to Firestore');
      await _firestore
          .collection('userConsents')
          .doc(currentUser.uid)
          .set(consentData.toFirestore(), SetOptions(merge: true));
      DebugLogger.debug('✅ Firestore fallback sync successful');
    } catch (firestoreError, firestoreStack) {
      DebugLogger.warning(
        '⚠️ Firestore fallback sync failed',
        firestoreError,
        firestoreStack,
      );
    }

    _logger.info('✅ Consent saved to local storage');
    DebugLogger.performance(
      'saveConsentLocal',
      DebugLogger.stopTimer('saveConsentLocal')!,
    );
    DebugLogger.exit('LegalRepository._saveConsentLocal', 'success');
  }

  /// Check compliance status for a user
  Future<LegalComplianceStatus> checkCompliance({
    required String uid,
    required SupportedLanguage lang,
  }) async {
    try {
      _logger.info('🔍 Checking legal compliance for user: $uid');

      // Get user's current consent
      final userConsent = await getUserConsent(uid);

      // Get latest document versions
      final latestTos = await getLatestVersion(
        type: LegalDocType.tos,
        lang: lang,
      );
      final latestPrivacy = await getLatestVersion(
        type: LegalDocType.privacy,
        lang: lang,
      );

      if (userConsent == null) {
        // No consent at all
        return const LegalComplianceStatus(
          hasValidConsent: false,
          needsReConsent: true,
          missingDocuments: ['tos', 'privacy'],
          outdatedDocuments: [],
        );
      }

      final outdatedDocs = <String>[];
      if (latestTos != null && userConsent.tosVersion != latestTos) {
        outdatedDocs.add('tos');
      }
      if (latestPrivacy != null &&
          userConsent.privacyVersion != latestPrivacy) {
        outdatedDocs.add('privacy');
      }

      final needsReConsent =
          outdatedDocs.isNotEmpty || userConsent.needsReConsent;

      final status = LegalComplianceStatus(
        hasValidConsent: true,
        needsReConsent: needsReConsent,
        missingDocuments: [],
        outdatedDocuments: outdatedDocs,
        currentTosVersion: userConsent.tosVersion,
        currentPrivacyVersion: userConsent.privacyVersion,
        latestTosVersion: latestTos,
        latestPrivacyVersion: latestPrivacy,
      );

      _logger.info(
        '✅ Compliance check complete: ${status.canProceed ? 'COMPLIANT' : 'NEEDS ACTION'}',
      );
      return status;
    } catch (error) {
      _logger.severe('❌ Error checking compliance', error);
      rethrow;
    }
  }

  /// Stream user consent for real-time updates
  Stream<UserConsent?> streamUserConsent(String uid) {
    try {
      return _firestore.collection('userConsents').doc(uid).snapshots().map((
        doc,
      ) {
        if (!doc.exists) return null;
        return UserConsent.fromFirestore(doc.data()!, uid);
      });
    } catch (error) {
      _logger.severe('❌ Error streaming user consent', error);
      rethrow;
    }
  }

  // ========================================
  // ADMIN FUNCTIONS
  // ========================================

  /// Publish new legal document (admin only - via Cloud Function)
  Future<void> publishLegalDoc({
    required LegalDocType type,
    required String version,
    required SupportedLanguage lang,
    required String content,
    String? previousVersion,
  }) async {
    try {
      _logger.info(
        '📤 Publishing legal document: ${type.name}_${lang.name}_$version',
      );

      final callable = _functions.httpsCallable(
        CloudFunctionNames.publishLegalDocumentCF,
      );

      final result = await callable.call({
        'type': type.name,
        'version': version,
        'lang': lang.name,
        'content': content,
        'previousVersion': previousVersion,
      });

      if (result.data['success'] == true) {
        _logger.info('✅ Legal document published successfully');
      } else {
        throw Exception(
          'Cloud Function returned error: ${result.data['message']}',
        );
      }
    } catch (error) {
      _logger.severe('❌ Error publishing legal document', error);
      rethrow;
    }
  }

  /// Get legal statistics for admin dashboard
  Future<LegalStatistics> getLegalStatistics() async {
    try {
      _logger.info('📊 Getting legal statistics');

      final callable = _functions.httpsCallable(
        CloudFunctionNames.getLegalStatsCF,
      );
      final result = await callable.call();

      if (result.data['success'] == true) {
        final stats = LegalStatistics.fromJson(result.data['statistics']);
        _logger.info('✅ Legal statistics retrieved');
        return stats;
      } else {
        throw Exception(
          'Cloud Function returned error: ${result.data['message']}',
        );
      }
    } catch (error) {
      _logger.severe('❌ Error getting legal statistics', error);
      rethrow;
    }
  }

  // ========================================
  // UTILITIES
  // ========================================

  /// Get user's IP address for consent tracking
  Future<String> getUserIpAddress() async {
    try {
      // This would typically use a service to get the real IP
      // For now, return a placeholder
      return Platform.isAndroid ? 'android-client' : 'ios-client';
    } catch (error) {
      _logger.warning('⚠️ Could not get IP address, using fallback');
      return 'unknown-client';
    }
  }

  /// Get system language for consent
  SupportedLanguage getSystemLanguage() {
    try {
      final locale = Platform.localeName.split('_').first.toLowerCase();

      switch (locale) {
        case 'de':
          return SupportedLanguage.de;
        case 'pt':
          return SupportedLanguage.pt;
        case 'en':
          return SupportedLanguage.en;
        case 'es':
          return SupportedLanguage.es;
        case 'fr':
          return SupportedLanguage.fr;
        default:
          return SupportedLanguage.en; // Default to English
      }
    } catch (error) {
      _logger.warning('⚠️ Could not detect system language, using English');
      return SupportedLanguage.en;
    }
  }
}

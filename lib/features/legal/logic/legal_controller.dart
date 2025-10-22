import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/legal.dart';
import '../../../core/utils/debug_logger.dart';
import '../../auth/logic/auth_controller.dart';
import '../data/legal_repo.dart';

final legalControllerProvider =
    StateNotifierProvider<LegalController, AsyncValue<LegalComplianceStatus>>(
        (ref) {
  return LegalController(ref);
});

// Provider to listen for auth changes and trigger compliance recheck
final legalComplianceWatcherProvider = Provider<void>((ref) {
  final controller = ref.read(legalControllerProvider.notifier);

  // Only trigger recheck on auth state changes (not on every rebuild)
  ref.listen(authStateProvider, (previous, next) {
    DebugLogger.debug(
        '🔄 LegalComplianceWatcher: Auth state changed, triggering compliance recheck');
    DebugLogger.log(
        'LegalComplianceWatcher: Auth state changed, triggering compliance recheck');
    controller.checkComplianceFromAuthChange();
  });
});

final currentLanguageProvider = StateProvider<SupportedLanguage>((ref) {
  DebugLogger.debug('🌐 Getting system language');
  // Get from repository helper method or default to German
  final repo = ref.read(legalRepositoryProvider);
  final language = repo.getSystemLanguage();
  DebugLogger.debug('🌐 System language detected: ${language.name}');
  return language;
});

final latestLegalVersionsProvider =
    FutureProvider.family<Map<String, String>, SupportedLanguage>(
        (ref, lang) async {
  DebugLogger.enter('latestLegalVersionsProvider', {'lang': lang.name});
  final repo = ref.read(legalRepositoryProvider);

  try {
    DebugLogger.debug('📄 Fetching latest legal versions for ${lang.name}');
    final tosVersion =
        await repo.getLatestVersion(type: LegalDocType.tos, lang: lang);
    final privacyVersion =
        await repo.getLatestVersion(type: LegalDocType.privacy, lang: lang);

    final result = {
      'tos': tosVersion ?? 'v1.0',
      'privacy': privacyVersion ?? 'v1.0',
    };

    DebugLogger.debug('📄 Latest versions: $result');
    DebugLogger.exit('latestLegalVersionsProvider', result);
    return result;
  } catch (error) {
    DebugLogger.warning(
        '⚠️ Failed to fetch latest versions, using defaults', error);
    // Return defaults if fetch fails
    final fallback = {
      'tos': 'v1.0',
      'privacy': 'v1.0',
    };
    DebugLogger.exit('latestLegalVersionsProvider', fallback);
    return fallback;
  }
});

final userConsentProvider = StreamProvider.autoDispose<UserConsent?>((ref) {
  final authState = ref.watch(authStateProvider);

  return authState.when(
    loading: () => Stream.value(null),
    error: (error, stack) => Stream.value(null),
    data: (user) {
      if (user == null) return Stream.value(null);

      final repo = ref.read(legalRepositoryProvider);
      return repo.streamUserConsent(user.uid);
    },
  );
});

final legalDocumentProvider =
    FutureProvider.family<LegalDocument?, LegalDocumentQuery>(
        (ref, query) async {
  DebugLogger.enter('legalDocumentProvider', {
    'type': query.type.name,
    'lang': query.lang.name,
    'version': query.version
  });

  final repo = ref.read(legalRepositoryProvider);

  try {
    final result = await repo.getLegalDoc(
      type: query.type,
      lang: query.lang,
      version: query.version,
    );
    DebugLogger.exit('legalDocumentProvider', result?.firestoreId ?? 'null');
    return result;
  } catch (error) {
    DebugLogger.error('❌ Error in legalDocumentProvider', error);
    DebugLogger.exit('legalDocumentProvider', 'error');
    return null;
  }
});

class LegalController extends StateNotifier<AsyncValue<LegalComplianceStatus>> {
  // Debug logging for legal compliance operations
  final Ref _ref;
  bool _hasInitialized = false;

  LegalController(this._ref) : super(const AsyncValue.loading()) {
    DebugLogger.lifecycle('LegalController', 'constructor');
    // Don't auto-check on initialization to avoid circular dependencies
    DebugLogger.log(
        'LegalController: Initialized - waiting for explicit compliance check');
    DebugLogger.debug(
        '🏗️ LegalController initialized - waiting for explicit compliance check');
  }

  /// Check compliance from auth state change
  Future<void> checkComplianceFromAuthChange() async {
    DebugLogger.enter('LegalController.checkComplianceFromAuthChange');
    DebugLogger.log('LegalController: Checking compliance from auth change...');
    DebugLogger.debug('🔄 Checking compliance from auth change');
    await _checkCompliance();
    DebugLogger.exit('LegalController.checkComplianceFromAuthChange');
  }

  /// Initial compliance check (call this explicitly when needed)
  Future<void> initializeCompliance() async {
    DebugLogger.enter('LegalController.initializeCompliance',
        {'hasInitialized': _hasInitialized});

    if (_hasInitialized) {
      DebugLogger.log('LegalController: Already initialized, skipping...');
      return;
    }

    _hasInitialized = true;
    DebugLogger.log('LegalController: Running initial compliance check...');
    await _checkCompliance();
  }

  Future<void> _checkCompliance() async {
    DebugLogger.log('LegalController: Starting compliance check...');

    try {
      // Development bypass - aktiv im Debug-Modus oder Web-Development
      if (kDebugMode || (kIsWeb && Uri.base.host == 'localhost')) {
        DebugLogger.log(
            'LegalController: Debug/Web-Dev mode detected - bypassing legal compliance');
        await Future.delayed(const Duration(
            milliseconds: 100)); // Small delay to avoid race conditions
        state = const AsyncValue.data(LegalComplianceStatus(
          hasValidConsent: true,
          needsReConsent: false,
          missingDocuments: [],
          outdatedDocuments: [],
        ));
        DebugLogger.log('LegalController: Debug bypass complete');
        return;
      }

      DebugLogger.log(
          'LegalController: Production mode - performing full compliance check');
      final authState = _ref.read(authStateProvider);

      await authState.when(
        loading: () async {
          state = const AsyncValue.loading();
        },
        error: (error, stack) async {
          state = AsyncValue.error(error, stack);
        },
        data: (user) async {
          if (user == null) {
            // Not authenticated - allow access to login/signup flow
            DebugLogger.log(
                'LegalController: User not authenticated - allowing access to auth flow');
            state = const AsyncValue.data(LegalComplianceStatus(
              hasValidConsent: true, // Allow access for login/signup
              needsReConsent: false,
              missingDocuments: [],
              outdatedDocuments: [],
            ));
            return;
          }

          // User is authenticated - now check legal compliance
          DebugLogger.log(
              'LegalController: User authenticated - checking legal compliance');
          final currentLang = _ref.read(currentLanguageProvider);
          final repo = _ref.read(legalRepositoryProvider);

          try {
            // Add timeout for development - if Firestore is not configured or empty
            final complianceStatus = await repo
                .checkCompliance(
              uid: user.uid,
              lang: currentLang,
            )
                .timeout(
              const Duration(seconds: 5),
              onTimeout: () {
                DebugLogger.log(
                    'LegalController: Compliance check timed out, requiring consent');
                // For production/development - if no legal docs exist, require consent
                return const LegalComplianceStatus(
                  hasValidConsent: false,
                  needsReConsent: true,
                  missingDocuments: ['tos', 'privacy'],
                  outdatedDocuments: [],
                );
              },
            );

            state = AsyncValue.data(complianceStatus);
          } catch (firestoreError) {
            DebugLogger.log(
                'LegalController: Firestore/Permission error detected - $firestoreError');

            // Check if it's a permission error
            if (firestoreError.toString().contains('permission-denied') ||
                firestoreError
                    .toString()
                    .contains('Missing or insufficient permissions') ||
                firestoreError.toString().contains('PERMISSION_DENIED')) {
              DebugLogger.log(
                  'LegalController: Permission denied - using development bypass');
            } else {
              DebugLogger.log('LegalController: Other Firestore error - using fallback');
            }

            // Always use development fallback for any Firestore error
            state = const AsyncValue.data(LegalComplianceStatus(
              hasValidConsent: true,
              needsReConsent: false,
              missingDocuments: [],
              outdatedDocuments: [],
            ));
          }
        },
      );
    } catch (error, stack) {
      DebugLogger.log('LegalController: Critical error in compliance check - $error');
      DebugLogger.log('LegalController: Stack trace - $stack');

      // For any critical error, use development fallback to keep app functional
      state = const AsyncValue.data(LegalComplianceStatus(
        hasValidConsent: true,
        needsReConsent: false,
        missingDocuments: [],
        outdatedDocuments: [],
      ));
    }
  }

  Future<void> refreshCompliance() async {
    DebugLogger.log('LegalController: Manual refresh compliance...');
    state = const AsyncValue.loading();
    await _checkCompliance();
  }

  Future<bool> saveConsent({
    required String tosVersion,
    required String privacyVersion,
    required SupportedLanguage lang,
    String? impressumVersion,
  }) async {
    try {
      DebugLogger.log('LegalController: Saving user consent via controller');

      final repo = _ref.read(legalRepositoryProvider);

      await repo.saveConsentSecure(
        tosVersion: tosVersion,
        privacyVersion: privacyVersion,
        consentedLang: lang,
        impressumVersion: impressumVersion,
      );

      // Refresh compliance status
      await _checkCompliance();

      DebugLogger.log('LegalController: ✅ User consent saved and compliance refreshed');
      return true;
    } catch (error) {
      DebugLogger.log('LegalController: ❌ Error saving user consent - $error');
      return false;
    }
  }

  Future<LegalDocument?> getLegalDocument({
    required LegalDocType type,
    required SupportedLanguage lang,
    String? version,
  }) async {
    try {
      final repo = _ref.read(legalRepositoryProvider);
      return await repo.getLegalDoc(
        type: type,
        lang: lang,
        version: version,
      );
    } catch (error) {
      DebugLogger.log('LegalController: Error getting legal document - $error');
      return null;
    }
  }

  void updateLanguage(SupportedLanguage newLang) {
    _ref.read(currentLanguageProvider.notifier).state = newLang;
    _checkCompliance(); // Re-check with new language
  }
}

// Query class for legal document provider
class LegalDocumentQuery {
  final LegalDocType type;
  final SupportedLanguage lang;
  final String? version;

  const LegalDocumentQuery({
    required this.type,
    required this.lang,
    this.version,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LegalDocumentQuery &&
        other.type == type &&
        other.lang == lang &&
        other.version == version;
  }

  @override
  int get hashCode => Object.hash(type, lang, version);
}

// Utility providers for UI
final isLegallyCompliantProvider = Provider<bool>((ref) {
  final complianceAsync = ref.watch(legalControllerProvider);

  return complianceAsync.when(
    loading: () => false,
    error: (error, stack) => false,
    data: (status) => status.canProceed,
  );
});

final needsLegalConsentProvider = Provider<bool>((ref) {
  final complianceAsync = ref.watch(legalControllerProvider);

  return complianceAsync.when(
    loading: () => false,
    error: (error, stack) => false,
    data: (status) => status.needsReConsent || !status.hasValidConsent,
  );
});

// Language switcher for legal documents
final legalLanguageSwitcherProvider =
    Provider<Map<SupportedLanguage, String>>((ref) {
  return {
    for (final lang in SupportedLanguage.values)
      lang: '${lang.flag} ${lang.displayName}',
  };
});

// Document type display names
final legalDocTypeDisplayProvider = Provider<Map<LegalDocType, String>>((ref) {
  final currentLang = ref.watch(currentLanguageProvider);

  if (currentLang == SupportedLanguage.de) {
    return {
      LegalDocType.tos: 'Allgemeine Geschäftsbedingungen',
      LegalDocType.privacy: 'Datenschutzerklärung',
      LegalDocType.impressum: 'Impressum',
    };
  }

  // Default to English
  return {
    LegalDocType.tos: 'Terms of Service',
    LegalDocType.privacy: 'Privacy Policy',
    LegalDocType.impressum: 'Imprint',
  };
});

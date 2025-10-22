import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'legal.freezed.dart';
part 'legal.g.dart';

// ========================================
// LEGAL DOCUMENT TYPES & ENUMS
// ========================================

enum LegalDocType {
  tos,
  privacy,
  impressum,
  guidelines,
  refund;

  String get displayName {
    switch (this) {
      case LegalDocType.tos:
        return 'Terms of Service';
      case LegalDocType.privacy:
        return 'Privacy Policy';
      case LegalDocType.impressum:
        return 'Impressum';
      case LegalDocType.guidelines:
        return 'Guidelines';
      case LegalDocType.refund:
        return 'Refund Policy';
    }
  }

  String get displayNameLocalized {
    switch (this) {
      case LegalDocType.tos:
        return 'Allgemeine Geschäftsbedingungen';
      case LegalDocType.privacy:
        return 'Datenschutzerklärung';
      case LegalDocType.impressum:
        return 'Impressum';
      case LegalDocType.guidelines:
        return 'Nutzungsrichtlinien';
      case LegalDocType.refund:
        return 'Rückerstattungsrichtlinien';
    }
  }
}

enum SupportedLanguage {
  de,
  pt,
  en,
  es,
  fr;

  String get displayName {
    switch (this) {
      case SupportedLanguage.de:
        return 'Deutsch';
      case SupportedLanguage.pt:
        return 'Português';
      case SupportedLanguage.en:
        return 'English';
      case SupportedLanguage.es:
        return 'Español';
      case SupportedLanguage.fr:
        return 'Français';
    }
  }

  String get flag {
    switch (this) {
      case SupportedLanguage.de:
        return '🇩🇪';
      case SupportedLanguage.pt:
        return '🇵🇹';
      case SupportedLanguage.en:
        return '🇬🇧';
      case SupportedLanguage.es:
        return '🇪🇸';
      case SupportedLanguage.fr:
        return '🇫🇷';
    }
  }
}

// ========================================
// LEGAL DOCUMENT MODEL
// ========================================

@freezed
abstract class LegalDocument with _$LegalDocument {
  const LegalDocument._();

  const factory LegalDocument({
    required String id,
    required LegalDocType type,
    required String version,
    required SupportedLanguage lang,
    required String content,
    required DateTime publishedAt,
    @Default(true) bool isActive,
    String? title, // Document title
    String? previousVersion,
    String? publishedBy, // Admin UID
  }) = _LegalDocument;

  factory LegalDocument.fromJson(Map<String, dynamic> json) =>
      _$LegalDocumentFromJson(json);

  // Firestore conversion helpers
  factory LegalDocument.fromFirestore(Map<String, dynamic> data, String docId) {
    return LegalDocument(
      id: docId,
      type: LegalDocType.values.firstWhere(
        (t) => t.name == data['type'],
        orElse: () => LegalDocType.tos,
      ),
      version: data['version'] ?? 'v1.0',
      lang: SupportedLanguage.values.firstWhere(
        (l) => l.name == data['lang'],
        orElse: () => SupportedLanguage.de,
      ),
      content: data['content'] ?? '',
      publishedAt:
          (data['publishedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isActive: data['isActive'] ?? true,
      title: data['title'],
      previousVersion: data['previousVersion'],
      publishedBy: data['publishedBy'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'type': type.name,
      'version': version,
      'lang': lang.name,
      'content': content,
      'publishedAt': Timestamp.fromDate(publishedAt),
      'isActive': isActive,
      'previousVersion': previousVersion,
      'publishedBy': publishedBy,
    };
  }

  // Generate document ID for Firestore
  String get firestoreId => '${type.name}_${lang.name}_$version';

  // Check if this is the latest version for this type/language
  bool isLatestVersion(List<LegalDocument> allDocs) {
    final sameTypeLang = allDocs
        .where((doc) => doc.type == type && doc.lang == lang && doc.isActive)
        .toList();

    if (sameTypeLang.isEmpty) return true;

    // Sort by version (assuming semantic versioning)
    sameTypeLang.sort((a, b) => _compareVersions(b.version, a.version));

    return sameTypeLang.first.version == version;
  }

  // Simple version comparison (v1.0, v1.1, v2.0, etc.)
  static int _compareVersions(String version1, String version2) {
    final v1Parts =
        version1.replaceFirst('v', '').split('.').map(int.parse).toList();
    final v2Parts =
        version2.replaceFirst('v', '').split('.').map(int.parse).toList();

    for (int i = 0; i < v1Parts.length && i < v2Parts.length; i++) {
      if (v1Parts[i] != v2Parts[i]) {
        return v1Parts[i].compareTo(v2Parts[i]);
      }
    }

    return v1Parts.length.compareTo(v2Parts.length);
  }
}

// ========================================
// USER CONSENT MODEL
// ========================================

@freezed
abstract class UserConsent with _$UserConsent {
  const UserConsent._();

  const factory UserConsent({
    required String uid,
    required String tosVersion,
    required String privacyVersion,
    required DateTime consentedAt,
    required String consentedIp,
    required SupportedLanguage consentedLang,
    String? impressumVersion,
    DateTime? lastUpdated,
    @Default(false) bool needsReConsent,
  }) = _UserConsent;

  factory UserConsent.fromJson(Map<String, dynamic> json) =>
      _$UserConsentFromJson(json);

  // Firestore conversion helpers
  factory UserConsent.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserConsent(
      uid: uid,
      tosVersion: data['tosVersion'] ?? 'v1.0',
      privacyVersion: data['privacyVersion'] ?? 'v1.0',
      consentedAt:
          (data['consentedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      consentedIp: data['consentedIp'] ?? 'unknown',
      consentedLang: SupportedLanguage.values.firstWhere(
        (l) => l.name == data['consentedLang'],
        orElse: () => SupportedLanguage.de,
      ),
      impressumVersion: data['impressumVersion'],
      lastUpdated: (data['lastUpdated'] as Timestamp?)?.toDate(),
      needsReConsent: data['needsReConsent'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'tosVersion': tosVersion,
      'privacyVersion': privacyVersion,
      'consentedAt': Timestamp.fromDate(consentedAt),
      'consentedIp': consentedIp,
      'consentedLang': consentedLang.name,
      'impressumVersion': impressumVersion,
      'lastUpdated':
          lastUpdated != null ? Timestamp.fromDate(lastUpdated!) : null,
      'needsReConsent': needsReConsent,
    };
  }

  // Check if user needs to re-consent based on latest versions
  bool needsUpdate(String latestTosVersion, String latestPrivacyVersion) {
    return tosVersion != latestTosVersion ||
        privacyVersion != latestPrivacyVersion ||
        needsReConsent;
  }

  // Create updated consent with new versions
  UserConsent updateVersions({
    required String newTosVersion,
    required String newPrivacyVersion,
    required String newIp,
    String? newImpressumVersion,
  }) {
    return copyWith(
      tosVersion: newTosVersion,
      privacyVersion: newPrivacyVersion,
      impressumVersion: newImpressumVersion ?? impressumVersion,
      consentedAt: DateTime.now(),
      consentedIp: newIp,
      lastUpdated: DateTime.now(),
      needsReConsent: false,
    );
  }
}

// ========================================
// LEGAL COMPLIANCE HELPER
// ========================================

@freezed
abstract class LegalComplianceStatus with _$LegalComplianceStatus {
  const LegalComplianceStatus._();

  const factory LegalComplianceStatus({
    required bool hasValidConsent,
    required bool needsReConsent,
    required List<String> missingDocuments,
    required List<String> outdatedDocuments,
    String? currentTosVersion,
    String? currentPrivacyVersion,
    String? latestTosVersion,
    String? latestPrivacyVersion,
  }) = _LegalComplianceStatus;

  factory LegalComplianceStatus.fromJson(Map<String, dynamic> json) =>
      _$LegalComplianceStatusFromJson(json);

  // Check if user can proceed with app usage
  bool get canProceed =>
      hasValidConsent && !needsReConsent && missingDocuments.isEmpty;

  // Get user-friendly message about compliance status
  String get statusMessage {
    if (canProceed) {
      return 'Legal compliance up-to-date';
    }

    if (needsReConsent) {
      return 'Please accept updated terms and privacy policy';
    }

    if (missingDocuments.isNotEmpty) {
      return 'Please accept terms of service and privacy policy';
    }

    if (outdatedDocuments.isNotEmpty) {
      return 'Please accept updated legal documents';
    }

    return 'Legal compliance check required';
  }
}

// ========================================
// LEGAL STATISTICS FOR ADMIN
// ========================================

@freezed
abstract class LegalStatistics with _$LegalStatistics {
  const LegalStatistics._();

  const factory LegalStatistics({
    required int totalUsers,
    required int usersWithConsent,
    required int usersNeedingReConsent,
    required Map<String, int> consentByVersion,
    required Map<String, int> consentByLanguage,
    required DateTime lastUpdated,
  }) = _LegalStatistics;

  factory LegalStatistics.fromJson(Map<String, dynamic> json) =>
      _$LegalStatisticsFromJson(json);

  // Calculate consent percentage
  double get consentPercentage {
    if (totalUsers == 0) return 0.0;
    return (usersWithConsent / totalUsers) * 100;
  }

  // Get users needing attention
  int get usersNeedingAttention => usersNeedingReConsent;

  // Most common consent language
  String get mostCommonLanguage {
    if (consentByLanguage.isEmpty) return 'de';

    final sortedEntries = consentByLanguage.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedEntries.first.key;
  }
}

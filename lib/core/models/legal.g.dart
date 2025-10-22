// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'legal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LegalDocument _$LegalDocumentFromJson(Map<String, dynamic> json) =>
    _LegalDocument(
      id: json['id'] as String,
      type: $enumDecode(_$LegalDocTypeEnumMap, json['type']),
      version: json['version'] as String,
      lang: $enumDecode(_$SupportedLanguageEnumMap, json['lang']),
      content: json['content'] as String,
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
      title: json['title'] as String?,
      previousVersion: json['previousVersion'] as String?,
      publishedBy: json['publishedBy'] as String?,
    );

Map<String, dynamic> _$LegalDocumentToJson(_LegalDocument instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$LegalDocTypeEnumMap[instance.type]!,
      'version': instance.version,
      'lang': _$SupportedLanguageEnumMap[instance.lang]!,
      'content': instance.content,
      'publishedAt': instance.publishedAt.toIso8601String(),
      'isActive': instance.isActive,
      'title': instance.title,
      'previousVersion': instance.previousVersion,
      'publishedBy': instance.publishedBy,
    };

const _$LegalDocTypeEnumMap = {
  LegalDocType.tos: 'tos',
  LegalDocType.privacy: 'privacy',
  LegalDocType.impressum: 'impressum',
  LegalDocType.guidelines: 'guidelines',
  LegalDocType.refund: 'refund',
};

const _$SupportedLanguageEnumMap = {
  SupportedLanguage.de: 'de',
  SupportedLanguage.pt: 'pt',
  SupportedLanguage.en: 'en',
  SupportedLanguage.es: 'es',
  SupportedLanguage.fr: 'fr',
};

_UserConsent _$UserConsentFromJson(Map<String, dynamic> json) => _UserConsent(
  uid: json['uid'] as String,
  tosVersion: json['tosVersion'] as String,
  privacyVersion: json['privacyVersion'] as String,
  consentedAt: DateTime.parse(json['consentedAt'] as String),
  consentedIp: json['consentedIp'] as String,
  consentedLang: $enumDecode(_$SupportedLanguageEnumMap, json['consentedLang']),
  impressumVersion: json['impressumVersion'] as String?,
  lastUpdated: json['lastUpdated'] == null
      ? null
      : DateTime.parse(json['lastUpdated'] as String),
  needsReConsent: json['needsReConsent'] as bool? ?? false,
);

Map<String, dynamic> _$UserConsentToJson(_UserConsent instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'tosVersion': instance.tosVersion,
      'privacyVersion': instance.privacyVersion,
      'consentedAt': instance.consentedAt.toIso8601String(),
      'consentedIp': instance.consentedIp,
      'consentedLang': _$SupportedLanguageEnumMap[instance.consentedLang]!,
      'impressumVersion': instance.impressumVersion,
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
      'needsReConsent': instance.needsReConsent,
    };

_LegalComplianceStatus _$LegalComplianceStatusFromJson(
  Map<String, dynamic> json,
) => _LegalComplianceStatus(
  hasValidConsent: json['hasValidConsent'] as bool,
  needsReConsent: json['needsReConsent'] as bool,
  missingDocuments: (json['missingDocuments'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  outdatedDocuments: (json['outdatedDocuments'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  currentTosVersion: json['currentTosVersion'] as String?,
  currentPrivacyVersion: json['currentPrivacyVersion'] as String?,
  latestTosVersion: json['latestTosVersion'] as String?,
  latestPrivacyVersion: json['latestPrivacyVersion'] as String?,
);

Map<String, dynamic> _$LegalComplianceStatusToJson(
  _LegalComplianceStatus instance,
) => <String, dynamic>{
  'hasValidConsent': instance.hasValidConsent,
  'needsReConsent': instance.needsReConsent,
  'missingDocuments': instance.missingDocuments,
  'outdatedDocuments': instance.outdatedDocuments,
  'currentTosVersion': instance.currentTosVersion,
  'currentPrivacyVersion': instance.currentPrivacyVersion,
  'latestTosVersion': instance.latestTosVersion,
  'latestPrivacyVersion': instance.latestPrivacyVersion,
};

_LegalStatistics _$LegalStatisticsFromJson(Map<String, dynamic> json) =>
    _LegalStatistics(
      totalUsers: (json['totalUsers'] as num).toInt(),
      usersWithConsent: (json['usersWithConsent'] as num).toInt(),
      usersNeedingReConsent: (json['usersNeedingReConsent'] as num).toInt(),
      consentByVersion: Map<String, int>.from(json['consentByVersion'] as Map),
      consentByLanguage: Map<String, int>.from(
        json['consentByLanguage'] as Map,
      ),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$LegalStatisticsToJson(_LegalStatistics instance) =>
    <String, dynamic>{
      'totalUsers': instance.totalUsers,
      'usersWithConsent': instance.usersWithConsent,
      'usersNeedingReConsent': instance.usersNeedingReConsent,
      'consentByVersion': instance.consentByVersion,
      'consentByLanguage': instance.consentByLanguage,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };

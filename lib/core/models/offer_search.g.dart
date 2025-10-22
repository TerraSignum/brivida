// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer_search.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OfferSearchFilter _$OfferSearchFilterFromJson(Map<String, dynamic> json) =>
    _OfferSearchFilter(
      when: DateTime.parse(json['when'] as String),
      durationHours: (json['durationHours'] as num?)?.toDouble() ?? 2.0,
      geo: OfferLocation.fromJson(json['geo'] as Map<String, dynamic>),
      radiusKm: (json['radiusKm'] as num?)?.toInt() ?? 25,
      recurring: json['recurring'] as bool? ?? false,
      extras: json['extras'] == null
          ? const OfferExtras()
          : const OfferExtrasConverter().fromJson(
              json['extras'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$OfferSearchFilterToJson(_OfferSearchFilter instance) =>
    <String, dynamic>{
      'when': instance.when.toIso8601String(),
      'durationHours': instance.durationHours,
      'geo': instance.geo,
      'radiusKm': instance.radiusKm,
      'recurring': instance.recurring,
      'extras': const OfferExtrasConverter().toJson(instance.extras),
    };

_OfferSearchResult _$OfferSearchResultFromJson(Map<String, dynamic> json) =>
    _OfferSearchResult(
      offerId: json['offerId'] as String,
      proId: json['proId'] as String,
      title: json['title'] as String,
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0.0,
      window: OfferWindow.fromJson(json['window'] as Map<String, dynamic>),
      supports: OfferSupports.fromJson(
        json['supports'] as Map<String, dynamic>,
      ),
      pro: OfferSummaryPro.fromJson(json['pro'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OfferSearchResultToJson(_OfferSearchResult instance) =>
    <String, dynamic>{
      'offerId': instance.offerId,
      'proId': instance.proId,
      'title': instance.title,
      'distanceKm': instance.distanceKm,
      'window': instance.window,
      'supports': instance.supports,
      'pro': instance.pro,
    };

_OfferWindow _$OfferWindowFromJson(Map<String, dynamic> json) =>
    _OfferWindow(from: json['from'] as String, to: json['to'] as String);

Map<String, dynamic> _$OfferWindowToJson(_OfferWindow instance) =>
    <String, dynamic>{'from': instance.from, 'to': instance.to};

_OfferSupports _$OfferSupportsFromJson(Map<String, dynamic> json) =>
    _OfferSupports(
      acceptsRecurring: json['acceptsRecurring'] as bool? ?? false,
      extras: json['extras'] == null
          ? const OfferExtras()
          : const OfferExtrasConverter().fromJson(
              json['extras'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$OfferSupportsToJson(_OfferSupports instance) =>
    <String, dynamic>{
      'acceptsRecurring': instance.acceptsRecurring,
      'extras': const OfferExtrasConverter().toJson(instance.extras),
    };

_OfferSummaryPro _$OfferSummaryProFromJson(Map<String, dynamic> json) =>
    _OfferSummaryPro(
      displayName: json['displayName'] as String,
      username: json['username'] as String? ?? '',
      isVerified: json['isVerified'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      jobsDone: (json['jobsDone'] as num?)?.toInt() ?? 0,
      photoUrl: json['photoUrl'] as String?,
    );

Map<String, dynamic> _$OfferSummaryProToJson(_OfferSummaryPro instance) =>
    <String, dynamic>{
      'displayName': instance.displayName,
      'username': instance.username,
      'isVerified': instance.isVerified,
      'rating': instance.rating,
      'jobsDone': instance.jobsDone,
      'photoUrl': instance.photoUrl,
    };

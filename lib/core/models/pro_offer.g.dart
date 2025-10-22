// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pro_offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProOffer _$ProOfferFromJson(Map<String, dynamic> json) => _ProOffer(
  id: json['id'] as String?,
  proId: json['proId'] as String,
  title: json['title'] as String,
  weekdays:
      (json['weekdays'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const <int>[],
  timeFrom: json['timeFrom'] as String,
  timeTo: json['timeTo'] as String,
  minHours: (json['minHours'] as num?)?.toInt() ?? 2,
  maxHours: (json['maxHours'] as num?)?.toInt() ?? 8,
  acceptsRecurring: json['acceptsRecurring'] as bool? ?? false,
  extras: json['extras'] == null
      ? const OfferExtras()
      : const OfferExtrasConverter().fromJson(
          json['extras'] as Map<String, dynamic>,
        ),
  geoCenter: OfferLocation.fromJson(json['geoCenter'] as Map<String, dynamic>),
  serviceRadiusKm: (json['serviceRadiusKm'] as num?)?.toInt() ?? 15,
  notes: json['notes'] as String? ?? '',
  isActive: json['isActive'] as bool? ?? true,
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
);

Map<String, dynamic> _$ProOfferToJson(_ProOffer instance) => <String, dynamic>{
  'id': instance.id,
  'proId': instance.proId,
  'title': instance.title,
  'weekdays': instance.weekdays,
  'timeFrom': instance.timeFrom,
  'timeTo': instance.timeTo,
  'minHours': instance.minHours,
  'maxHours': instance.maxHours,
  'acceptsRecurring': instance.acceptsRecurring,
  'extras': const OfferExtrasConverter().toJson(instance.extras),
  'geoCenter': instance.geoCenter,
  'serviceRadiusKm': instance.serviceRadiusKm,
  'notes': instance.notes,
  'isActive': instance.isActive,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
};

_OfferLocation _$OfferLocationFromJson(Map<String, dynamic> json) =>
    _OfferLocation(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );

Map<String, dynamic> _$OfferLocationToJson(_OfferLocation instance) =>
    <String, dynamic>{'lat': instance.lat, 'lng': instance.lng};

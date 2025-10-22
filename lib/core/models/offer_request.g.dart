// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OfferRequest _$OfferRequestFromJson(Map<String, dynamic> json) =>
    _OfferRequest(
      id: json['id'] as String?,
      customerId: json['customerId'] as String,
      offerId: json['offerId'] as String,
      proId: json['proId'] as String,
      job: OfferRequestJob.fromJson(json['job'] as Map<String, dynamic>),
      price: OfferRequestPrice.fromJson(json['price'] as Map<String, dynamic>),
      status:
          $enumDecodeNullable(_$OfferRequestStatusEnumMap, json['status']) ??
          OfferRequestStatus.pending,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      expiresAt: const TimestampConverter().fromJson(json['expiresAt']),
      chatId: json['chatId'] as String?,
    );

Map<String, dynamic> _$OfferRequestToJson(_OfferRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'customerId': instance.customerId,
      'offerId': instance.offerId,
      'proId': instance.proId,
      'job': instance.job,
      'price': instance.price,
      'status': _$OfferRequestStatusEnumMap[instance.status]!,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'expiresAt': const TimestampConverter().toJson(instance.expiresAt),
      'chatId': instance.chatId,
    };

const _$OfferRequestStatusEnumMap = {
  OfferRequestStatus.pending: 'pending',
  OfferRequestStatus.accepted: 'accepted',
  OfferRequestStatus.declined: 'declined',
  OfferRequestStatus.expired: 'expired',
};

_OfferRequestJob _$OfferRequestJobFromJson(Map<String, dynamic> json) =>
    _OfferRequestJob(
      address: json['address'] as String,
      geo: json['geo'] == null
          ? null
          : OfferLocation.fromJson(json['geo'] as Map<String, dynamic>),
      start: const TimestampConverter().fromJson(json['start']),
      durationH: (json['durationH'] as num?)?.toDouble() ?? 0,
      extras:
          (json['extras'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as bool),
          ) ??
          const <String, bool>{},
      recurring: json['recurring'] as String? ?? 'once',
    );

Map<String, dynamic> _$OfferRequestJobToJson(_OfferRequestJob instance) =>
    <String, dynamic>{
      'address': instance.address,
      'geo': instance.geo,
      'start': const TimestampConverter().toJson(instance.start),
      'durationH': instance.durationH,
      'extras': instance.extras,
      'recurring': instance.recurring,
    };

_OfferRequestPrice _$OfferRequestPriceFromJson(Map<String, dynamic> json) =>
    _OfferRequestPrice(
      hourly: (json['hourly'] as num?)?.toDouble() ?? 0.0,
      estimatedTotal: (json['estimatedTotal'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$OfferRequestPriceToJson(_OfferRequestPrice instance) =>
    <String, dynamic>{
      'hourly': instance.hourly,
      'estimatedTotal': instance.estimatedTotal,
    };

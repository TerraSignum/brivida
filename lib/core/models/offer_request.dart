import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'pro_offer.dart';

part 'offer_request.freezed.dart';
part 'offer_request.g.dart';

@freezed
abstract class OfferRequest with _$OfferRequest {
  const factory OfferRequest({
    String? id,
    required String customerId,
    required String offerId,
    required String proId,
    required OfferRequestJob job,
    required OfferRequestPrice price,
    @Default(OfferRequestStatus.pending) OfferRequestStatus status,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? expiresAt,
    String? chatId,
  }) = _OfferRequest;

  factory OfferRequest.fromJson(Map<String, dynamic> json) =>
      _$OfferRequestFromJson(json);
}

@freezed
abstract class OfferRequestJob with _$OfferRequestJob {
  const factory OfferRequestJob({
    required String address,
    OfferLocation? geo,
    @TimestampConverter() DateTime? start,
    @Default(0) double durationH,
    @Default(<String, bool>{}) Map<String, bool> extras,
    @Default('once') String recurring,
  }) = _OfferRequestJob;

  factory OfferRequestJob.fromJson(Map<String, dynamic> json) =>
      _$OfferRequestJobFromJson(json);
}

@freezed
abstract class OfferRequestPrice with _$OfferRequestPrice {
  const factory OfferRequestPrice({
    @Default(0.0) double hourly,
    @Default(0.0) double estimatedTotal,
  }) = _OfferRequestPrice;

  factory OfferRequestPrice.fromJson(Map<String, dynamic> json) =>
      _$OfferRequestPriceFromJson(json);
}

enum OfferRequestStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('accepted')
  accepted,
  @JsonValue('declined')
  declined,
  @JsonValue('expired')
  expired,
}

class TimestampConverter implements JsonConverter<DateTime?, Object?> {
  const TimestampConverter();

  @override
  DateTime? fromJson(Object? json) {
    if (json == null) {
      return null;
    }
    if (json is Timestamp) {
      return json.toDate();
    }
    if (json is String) {
      return DateTime.tryParse(json);
    }
    if (json is int) {
      return DateTime.fromMillisecondsSinceEpoch(json);
    }
    return null;
  }

  @override
  Object? toJson(DateTime? object) {
    if (object == null) {
      return null;
    }
    return Timestamp.fromDate(object);
  }
}

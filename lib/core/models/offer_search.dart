import 'package:freezed_annotation/freezed_annotation.dart';

import 'pro_offer.dart';

part 'offer_search.freezed.dart';
part 'offer_search.g.dart';

@freezed
abstract class OfferSearchFilter with _$OfferSearchFilter {
  const factory OfferSearchFilter({
    required DateTime when,
    @Default(2.0) double durationHours,
    required OfferLocation geo,
    @Default(25) int radiusKm,
    @Default(false) bool recurring,
    @OfferExtrasConverter() @Default(OfferExtras()) OfferExtras extras,
  }) = _OfferSearchFilter;

  factory OfferSearchFilter.fromJson(Map<String, dynamic> json) =>
      _$OfferSearchFilterFromJson(json);

  @override
  @JsonKey(name: 'durationH')
  double get durationHours;
}

@freezed
abstract class OfferSearchResult with _$OfferSearchResult {
  const factory OfferSearchResult({
    required String offerId,
    required String proId,
    required String title,
    @Default(0.0) double distanceKm,
    required OfferWindow window,
    required OfferSupports supports,
    required OfferSummaryPro pro,
  }) = _OfferSearchResult;

  factory OfferSearchResult.fromJson(Map<String, dynamic> json) =>
      _$OfferSearchResultFromJson(json);
}

@freezed
abstract class OfferWindow with _$OfferWindow {
  const factory OfferWindow({required String from, required String to}) =
      _OfferWindow;

  factory OfferWindow.fromJson(Map<String, dynamic> json) =>
      _$OfferWindowFromJson(json);
}

@freezed
abstract class OfferSupports with _$OfferSupports {
  const factory OfferSupports({
    @Default(false) bool acceptsRecurring,
    @OfferExtrasConverter() @Default(OfferExtras()) OfferExtras extras,
  }) = _OfferSupports;

  factory OfferSupports.fromJson(Map<String, dynamic> json) =>
      _$OfferSupportsFromJson(json);

  @override
  @JsonKey(name: 'recurring')
  bool get acceptsRecurring;
}

@freezed
abstract class OfferSummaryPro with _$OfferSummaryPro {
  const factory OfferSummaryPro({
    required String displayName,
    @Default('') String username,
    @Default(false) bool isVerified,
    @Default(0.0) double rating,
    @Default(0) int jobsDone,
    String? photoUrl,
  }) = _OfferSummaryPro;

  factory OfferSummaryPro.fromJson(Map<String, dynamic> json) =>
      _$OfferSummaryProFromJson(json);
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pro_offer.freezed.dart';
part 'pro_offer.g.dart';

@freezed
abstract class ProOffer with _$ProOffer {
  const factory ProOffer({
    String? id,
    required String proId,
    required String title,
    @Default(<int>[]) List<int> weekdays,
    required String timeFrom,
    required String timeTo,
    @Default(2) int minHours,
    @Default(8) int maxHours,
    @Default(false) bool acceptsRecurring,
    @OfferExtrasConverter() @Default(OfferExtras()) OfferExtras extras,
    required OfferLocation geoCenter,
    @Default(15) int serviceRadiusKm,
    @Default('') String notes,
    @Default(true) bool isActive,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
  }) = _ProOffer;

  factory ProOffer.fromJson(Map<String, dynamic> json) =>
      _$ProOfferFromJson(json);
}

@freezed
abstract class OfferLocation with _$OfferLocation {
  const factory OfferLocation({required double lat, required double lng}) =
      _OfferLocation;

  factory OfferLocation.fromJson(Map<String, dynamic> json) =>
      _$OfferLocationFromJson(json);
}

@freezed
abstract class OfferExtras with _$OfferExtras {
  const factory OfferExtras({
    @Default(false) bool windowsInside,
    @Default(false) bool windowsInOut,
    @Default(false) bool kitchenDeep,
    @Default(false) bool bathroomDeep,
    @Default(false) bool laundry,
    @Default(false) bool ironingLight,
    @Default(false) bool ironingFull,
    @Default(false) bool balcony,
    @Default(false) bool organization,
  }) = _OfferExtras;

  const OfferExtras._();

  factory OfferExtras.fromJson(Map<String, dynamic> json) {
    final normalized = Map<String, dynamic>.from(json);
    _mergeLegacyFlag(normalized, 'windows_inside', ['windows_in']);
    _mergeLegacyFlag(normalized, 'ironing_light', ['ironing_small']);
    _mergeLegacyFlag(normalized, 'ironing_full', ['ironing_large']);
    return _OfferExtras(
      windowsInside: _readBool(normalized, 'windows_inside'),
      windowsInOut: _readBool(normalized, 'windows_in_out'),
      kitchenDeep: _readBool(normalized, 'kitchen_deep'),
      bathroomDeep: _readBool(normalized, 'bathroom_deep'),
      laundry: _readBool(normalized, 'laundry'),
      ironingLight: _readBool(normalized, 'ironing_light'),
      ironingFull: _readBool(normalized, 'ironing_full'),
      balcony: _readBool(normalized, 'balcony'),
      organization: _readBool(normalized, 'organization'),
    );
  }

  Map<String, dynamic> toJson() => {
    'windows_inside': windowsInside,
    'windows_in_out': windowsInOut,
    'kitchen_deep': kitchenDeep,
    'bathroom_deep': bathroomDeep,
    'laundry': laundry,
    'ironing_light': ironingLight,
    'ironing_full': ironingFull,
    'balcony': balcony,
    'organization': organization,
  };

  List<String> get selectedIds => [
    if (windowsInside) 'windows_inside',
    if (windowsInOut) 'windows_in_out',
    if (kitchenDeep) 'kitchen_deep',
    if (bathroomDeep) 'bathroom_deep',
    if (laundry) 'laundry',
    if (ironingLight) 'ironing_light',
    if (ironingFull) 'ironing_full',
    if (balcony) 'balcony',
    if (organization) 'organization',
  ];

  static void _mergeLegacyFlag(
    Map<String, dynamic> json,
    String primaryKey,
    List<String> fallbacks,
  ) {
    if (json.containsKey(primaryKey)) {
      return;
    }
    for (final candidate in fallbacks) {
      if (json.containsKey(candidate)) {
        json[primaryKey] = json[candidate];
        return;
      }
    }
  }

  static bool _readBool(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    if (value is String) {
      final lower = value.toLowerCase().trim();
      return lower == 'true' || lower == '1' || lower == 'yes';
    }
    return false;
  }
}

class OfferExtrasConverter
    implements JsonConverter<OfferExtras, Map<String, dynamic>> {
  const OfferExtrasConverter();

  @override
  OfferExtras fromJson(Map<String, dynamic> json) {
    return OfferExtras.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(OfferExtras object) {
    return object.toJson();
  }
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

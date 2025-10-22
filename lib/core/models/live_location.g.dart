// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LiveLocation _$LiveLocationFromJson(Map<String, dynamic> json) =>
    _LiveLocation(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      accuracy: (json['accuracy'] as num?)?.toDouble(),
      heading: (json['heading'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$LiveLocationToJson(_LiveLocation instance) =>
    <String, dynamic>{
      'lat': instance.lat,
      'lng': instance.lng,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'accuracy': instance.accuracy,
      'heading': instance.heading,
    };

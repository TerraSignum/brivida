// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'live_location.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LiveLocation {

 double get lat; double get lng; DateTime get updatedAt; double? get accuracy; double? get heading;
/// Create a copy of LiveLocation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LiveLocationCopyWith<LiveLocation> get copyWith => _$LiveLocationCopyWithImpl<LiveLocation>(this as LiveLocation, _$identity);

  /// Serializes this LiveLocation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LiveLocation&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy)&&(identical(other.heading, heading) || other.heading == heading));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,lng,updatedAt,accuracy,heading);

@override
String toString() {
  return 'LiveLocation(lat: $lat, lng: $lng, updatedAt: $updatedAt, accuracy: $accuracy, heading: $heading)';
}


}

/// @nodoc
abstract mixin class $LiveLocationCopyWith<$Res>  {
  factory $LiveLocationCopyWith(LiveLocation value, $Res Function(LiveLocation) _then) = _$LiveLocationCopyWithImpl;
@useResult
$Res call({
 double lat, double lng, DateTime updatedAt, double? accuracy, double? heading
});




}
/// @nodoc
class _$LiveLocationCopyWithImpl<$Res>
    implements $LiveLocationCopyWith<$Res> {
  _$LiveLocationCopyWithImpl(this._self, this._then);

  final LiveLocation _self;
  final $Res Function(LiveLocation) _then;

/// Create a copy of LiveLocation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lat = null,Object? lng = null,Object? updatedAt = null,Object? accuracy = freezed,Object? heading = freezed,}) {
  return _then(_self.copyWith(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,accuracy: freezed == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as double?,heading: freezed == heading ? _self.heading : heading // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [LiveLocation].
extension LiveLocationPatterns on LiveLocation {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LiveLocation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LiveLocation() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LiveLocation value)  $default,){
final _that = this;
switch (_that) {
case _LiveLocation():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LiveLocation value)?  $default,){
final _that = this;
switch (_that) {
case _LiveLocation() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double lat,  double lng,  DateTime updatedAt,  double? accuracy,  double? heading)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LiveLocation() when $default != null:
return $default(_that.lat,_that.lng,_that.updatedAt,_that.accuracy,_that.heading);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double lat,  double lng,  DateTime updatedAt,  double? accuracy,  double? heading)  $default,) {final _that = this;
switch (_that) {
case _LiveLocation():
return $default(_that.lat,_that.lng,_that.updatedAt,_that.accuracy,_that.heading);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double lat,  double lng,  DateTime updatedAt,  double? accuracy,  double? heading)?  $default,) {final _that = this;
switch (_that) {
case _LiveLocation() when $default != null:
return $default(_that.lat,_that.lng,_that.updatedAt,_that.accuracy,_that.heading);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LiveLocation implements LiveLocation {
  const _LiveLocation({required this.lat, required this.lng, required this.updatedAt, this.accuracy, this.heading});
  factory _LiveLocation.fromJson(Map<String, dynamic> json) => _$LiveLocationFromJson(json);

@override final  double lat;
@override final  double lng;
@override final  DateTime updatedAt;
@override final  double? accuracy;
@override final  double? heading;

/// Create a copy of LiveLocation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LiveLocationCopyWith<_LiveLocation> get copyWith => __$LiveLocationCopyWithImpl<_LiveLocation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LiveLocationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LiveLocation&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy)&&(identical(other.heading, heading) || other.heading == heading));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,lng,updatedAt,accuracy,heading);

@override
String toString() {
  return 'LiveLocation(lat: $lat, lng: $lng, updatedAt: $updatedAt, accuracy: $accuracy, heading: $heading)';
}


}

/// @nodoc
abstract mixin class _$LiveLocationCopyWith<$Res> implements $LiveLocationCopyWith<$Res> {
  factory _$LiveLocationCopyWith(_LiveLocation value, $Res Function(_LiveLocation) _then) = __$LiveLocationCopyWithImpl;
@override @useResult
$Res call({
 double lat, double lng, DateTime updatedAt, double? accuracy, double? heading
});




}
/// @nodoc
class __$LiveLocationCopyWithImpl<$Res>
    implements _$LiveLocationCopyWith<$Res> {
  __$LiveLocationCopyWithImpl(this._self, this._then);

  final _LiveLocation _self;
  final $Res Function(_LiveLocation) _then;

/// Create a copy of LiveLocation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lat = null,Object? lng = null,Object? updatedAt = null,Object? accuracy = freezed,Object? heading = freezed,}) {
  return _then(_LiveLocation(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,accuracy: freezed == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as double?,heading: freezed == heading ? _self.heading : heading // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on

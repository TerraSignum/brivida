// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pro_offer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProOffer {

 String? get id; String get proId; String get title; List<int> get weekdays; String get timeFrom; String get timeTo; int get minHours; int get maxHours; bool get acceptsRecurring;@OfferExtrasConverter() OfferExtras get extras; OfferLocation get geoCenter; int get serviceRadiusKm; String get notes; bool get isActive;@TimestampConverter() DateTime? get createdAt;@TimestampConverter() DateTime? get updatedAt;
/// Create a copy of ProOffer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProOfferCopyWith<ProOffer> get copyWith => _$ProOfferCopyWithImpl<ProOffer>(this as ProOffer, _$identity);

  /// Serializes this ProOffer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProOffer&&(identical(other.id, id) || other.id == id)&&(identical(other.proId, proId) || other.proId == proId)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.weekdays, weekdays)&&(identical(other.timeFrom, timeFrom) || other.timeFrom == timeFrom)&&(identical(other.timeTo, timeTo) || other.timeTo == timeTo)&&(identical(other.minHours, minHours) || other.minHours == minHours)&&(identical(other.maxHours, maxHours) || other.maxHours == maxHours)&&(identical(other.acceptsRecurring, acceptsRecurring) || other.acceptsRecurring == acceptsRecurring)&&(identical(other.extras, extras) || other.extras == extras)&&(identical(other.geoCenter, geoCenter) || other.geoCenter == geoCenter)&&(identical(other.serviceRadiusKm, serviceRadiusKm) || other.serviceRadiusKm == serviceRadiusKm)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,proId,title,const DeepCollectionEquality().hash(weekdays),timeFrom,timeTo,minHours,maxHours,acceptsRecurring,extras,geoCenter,serviceRadiusKm,notes,isActive,createdAt,updatedAt);

@override
String toString() {
  return 'ProOffer(id: $id, proId: $proId, title: $title, weekdays: $weekdays, timeFrom: $timeFrom, timeTo: $timeTo, minHours: $minHours, maxHours: $maxHours, acceptsRecurring: $acceptsRecurring, extras: $extras, geoCenter: $geoCenter, serviceRadiusKm: $serviceRadiusKm, notes: $notes, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ProOfferCopyWith<$Res>  {
  factory $ProOfferCopyWith(ProOffer value, $Res Function(ProOffer) _then) = _$ProOfferCopyWithImpl;
@useResult
$Res call({
 String? id, String proId, String title, List<int> weekdays, String timeFrom, String timeTo, int minHours, int maxHours, bool acceptsRecurring,@OfferExtrasConverter() OfferExtras extras, OfferLocation geoCenter, int serviceRadiusKm, String notes, bool isActive,@TimestampConverter() DateTime? createdAt,@TimestampConverter() DateTime? updatedAt
});


$OfferExtrasCopyWith<$Res> get extras;$OfferLocationCopyWith<$Res> get geoCenter;

}
/// @nodoc
class _$ProOfferCopyWithImpl<$Res>
    implements $ProOfferCopyWith<$Res> {
  _$ProOfferCopyWithImpl(this._self, this._then);

  final ProOffer _self;
  final $Res Function(ProOffer) _then;

/// Create a copy of ProOffer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? proId = null,Object? title = null,Object? weekdays = null,Object? timeFrom = null,Object? timeTo = null,Object? minHours = null,Object? maxHours = null,Object? acceptsRecurring = null,Object? extras = null,Object? geoCenter = null,Object? serviceRadiusKm = null,Object? notes = null,Object? isActive = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,proId: null == proId ? _self.proId : proId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,weekdays: null == weekdays ? _self.weekdays : weekdays // ignore: cast_nullable_to_non_nullable
as List<int>,timeFrom: null == timeFrom ? _self.timeFrom : timeFrom // ignore: cast_nullable_to_non_nullable
as String,timeTo: null == timeTo ? _self.timeTo : timeTo // ignore: cast_nullable_to_non_nullable
as String,minHours: null == minHours ? _self.minHours : minHours // ignore: cast_nullable_to_non_nullable
as int,maxHours: null == maxHours ? _self.maxHours : maxHours // ignore: cast_nullable_to_non_nullable
as int,acceptsRecurring: null == acceptsRecurring ? _self.acceptsRecurring : acceptsRecurring // ignore: cast_nullable_to_non_nullable
as bool,extras: null == extras ? _self.extras : extras // ignore: cast_nullable_to_non_nullable
as OfferExtras,geoCenter: null == geoCenter ? _self.geoCenter : geoCenter // ignore: cast_nullable_to_non_nullable
as OfferLocation,serviceRadiusKm: null == serviceRadiusKm ? _self.serviceRadiusKm : serviceRadiusKm // ignore: cast_nullable_to_non_nullable
as int,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of ProOffer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OfferExtrasCopyWith<$Res> get extras {
  
  return $OfferExtrasCopyWith<$Res>(_self.extras, (value) {
    return _then(_self.copyWith(extras: value));
  });
}/// Create a copy of ProOffer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OfferLocationCopyWith<$Res> get geoCenter {
  
  return $OfferLocationCopyWith<$Res>(_self.geoCenter, (value) {
    return _then(_self.copyWith(geoCenter: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProOffer].
extension ProOfferPatterns on ProOffer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProOffer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProOffer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProOffer value)  $default,){
final _that = this;
switch (_that) {
case _ProOffer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProOffer value)?  $default,){
final _that = this;
switch (_that) {
case _ProOffer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String proId,  String title,  List<int> weekdays,  String timeFrom,  String timeTo,  int minHours,  int maxHours,  bool acceptsRecurring, @OfferExtrasConverter()  OfferExtras extras,  OfferLocation geoCenter,  int serviceRadiusKm,  String notes,  bool isActive, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProOffer() when $default != null:
return $default(_that.id,_that.proId,_that.title,_that.weekdays,_that.timeFrom,_that.timeTo,_that.minHours,_that.maxHours,_that.acceptsRecurring,_that.extras,_that.geoCenter,_that.serviceRadiusKm,_that.notes,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String proId,  String title,  List<int> weekdays,  String timeFrom,  String timeTo,  int minHours,  int maxHours,  bool acceptsRecurring, @OfferExtrasConverter()  OfferExtras extras,  OfferLocation geoCenter,  int serviceRadiusKm,  String notes,  bool isActive, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ProOffer():
return $default(_that.id,_that.proId,_that.title,_that.weekdays,_that.timeFrom,_that.timeTo,_that.minHours,_that.maxHours,_that.acceptsRecurring,_that.extras,_that.geoCenter,_that.serviceRadiusKm,_that.notes,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String proId,  String title,  List<int> weekdays,  String timeFrom,  String timeTo,  int minHours,  int maxHours,  bool acceptsRecurring, @OfferExtrasConverter()  OfferExtras extras,  OfferLocation geoCenter,  int serviceRadiusKm,  String notes,  bool isActive, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ProOffer() when $default != null:
return $default(_that.id,_that.proId,_that.title,_that.weekdays,_that.timeFrom,_that.timeTo,_that.minHours,_that.maxHours,_that.acceptsRecurring,_that.extras,_that.geoCenter,_that.serviceRadiusKm,_that.notes,_that.isActive,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProOffer implements ProOffer {
  const _ProOffer({this.id, required this.proId, required this.title, final  List<int> weekdays = const <int>[], required this.timeFrom, required this.timeTo, this.minHours = 2, this.maxHours = 8, this.acceptsRecurring = false, @OfferExtrasConverter() this.extras = const OfferExtras(), required this.geoCenter, this.serviceRadiusKm = 15, this.notes = '', this.isActive = true, @TimestampConverter() this.createdAt, @TimestampConverter() this.updatedAt}): _weekdays = weekdays;
  factory _ProOffer.fromJson(Map<String, dynamic> json) => _$ProOfferFromJson(json);

@override final  String? id;
@override final  String proId;
@override final  String title;
 final  List<int> _weekdays;
@override@JsonKey() List<int> get weekdays {
  if (_weekdays is EqualUnmodifiableListView) return _weekdays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weekdays);
}

@override final  String timeFrom;
@override final  String timeTo;
@override@JsonKey() final  int minHours;
@override@JsonKey() final  int maxHours;
@override@JsonKey() final  bool acceptsRecurring;
@override@JsonKey()@OfferExtrasConverter() final  OfferExtras extras;
@override final  OfferLocation geoCenter;
@override@JsonKey() final  int serviceRadiusKm;
@override@JsonKey() final  String notes;
@override@JsonKey() final  bool isActive;
@override@TimestampConverter() final  DateTime? createdAt;
@override@TimestampConverter() final  DateTime? updatedAt;

/// Create a copy of ProOffer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProOfferCopyWith<_ProOffer> get copyWith => __$ProOfferCopyWithImpl<_ProOffer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProOfferToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProOffer&&(identical(other.id, id) || other.id == id)&&(identical(other.proId, proId) || other.proId == proId)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._weekdays, _weekdays)&&(identical(other.timeFrom, timeFrom) || other.timeFrom == timeFrom)&&(identical(other.timeTo, timeTo) || other.timeTo == timeTo)&&(identical(other.minHours, minHours) || other.minHours == minHours)&&(identical(other.maxHours, maxHours) || other.maxHours == maxHours)&&(identical(other.acceptsRecurring, acceptsRecurring) || other.acceptsRecurring == acceptsRecurring)&&(identical(other.extras, extras) || other.extras == extras)&&(identical(other.geoCenter, geoCenter) || other.geoCenter == geoCenter)&&(identical(other.serviceRadiusKm, serviceRadiusKm) || other.serviceRadiusKm == serviceRadiusKm)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,proId,title,const DeepCollectionEquality().hash(_weekdays),timeFrom,timeTo,minHours,maxHours,acceptsRecurring,extras,geoCenter,serviceRadiusKm,notes,isActive,createdAt,updatedAt);

@override
String toString() {
  return 'ProOffer(id: $id, proId: $proId, title: $title, weekdays: $weekdays, timeFrom: $timeFrom, timeTo: $timeTo, minHours: $minHours, maxHours: $maxHours, acceptsRecurring: $acceptsRecurring, extras: $extras, geoCenter: $geoCenter, serviceRadiusKm: $serviceRadiusKm, notes: $notes, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ProOfferCopyWith<$Res> implements $ProOfferCopyWith<$Res> {
  factory _$ProOfferCopyWith(_ProOffer value, $Res Function(_ProOffer) _then) = __$ProOfferCopyWithImpl;
@override @useResult
$Res call({
 String? id, String proId, String title, List<int> weekdays, String timeFrom, String timeTo, int minHours, int maxHours, bool acceptsRecurring,@OfferExtrasConverter() OfferExtras extras, OfferLocation geoCenter, int serviceRadiusKm, String notes, bool isActive,@TimestampConverter() DateTime? createdAt,@TimestampConverter() DateTime? updatedAt
});


@override $OfferExtrasCopyWith<$Res> get extras;@override $OfferLocationCopyWith<$Res> get geoCenter;

}
/// @nodoc
class __$ProOfferCopyWithImpl<$Res>
    implements _$ProOfferCopyWith<$Res> {
  __$ProOfferCopyWithImpl(this._self, this._then);

  final _ProOffer _self;
  final $Res Function(_ProOffer) _then;

/// Create a copy of ProOffer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? proId = null,Object? title = null,Object? weekdays = null,Object? timeFrom = null,Object? timeTo = null,Object? minHours = null,Object? maxHours = null,Object? acceptsRecurring = null,Object? extras = null,Object? geoCenter = null,Object? serviceRadiusKm = null,Object? notes = null,Object? isActive = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_ProOffer(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,proId: null == proId ? _self.proId : proId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,weekdays: null == weekdays ? _self._weekdays : weekdays // ignore: cast_nullable_to_non_nullable
as List<int>,timeFrom: null == timeFrom ? _self.timeFrom : timeFrom // ignore: cast_nullable_to_non_nullable
as String,timeTo: null == timeTo ? _self.timeTo : timeTo // ignore: cast_nullable_to_non_nullable
as String,minHours: null == minHours ? _self.minHours : minHours // ignore: cast_nullable_to_non_nullable
as int,maxHours: null == maxHours ? _self.maxHours : maxHours // ignore: cast_nullable_to_non_nullable
as int,acceptsRecurring: null == acceptsRecurring ? _self.acceptsRecurring : acceptsRecurring // ignore: cast_nullable_to_non_nullable
as bool,extras: null == extras ? _self.extras : extras // ignore: cast_nullable_to_non_nullable
as OfferExtras,geoCenter: null == geoCenter ? _self.geoCenter : geoCenter // ignore: cast_nullable_to_non_nullable
as OfferLocation,serviceRadiusKm: null == serviceRadiusKm ? _self.serviceRadiusKm : serviceRadiusKm // ignore: cast_nullable_to_non_nullable
as int,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of ProOffer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OfferExtrasCopyWith<$Res> get extras {
  
  return $OfferExtrasCopyWith<$Res>(_self.extras, (value) {
    return _then(_self.copyWith(extras: value));
  });
}/// Create a copy of ProOffer
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OfferLocationCopyWith<$Res> get geoCenter {
  
  return $OfferLocationCopyWith<$Res>(_self.geoCenter, (value) {
    return _then(_self.copyWith(geoCenter: value));
  });
}
}


/// @nodoc
mixin _$OfferLocation {

 double get lat; double get lng;
/// Create a copy of OfferLocation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OfferLocationCopyWith<OfferLocation> get copyWith => _$OfferLocationCopyWithImpl<OfferLocation>(this as OfferLocation, _$identity);

  /// Serializes this OfferLocation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OfferLocation&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,lng);

@override
String toString() {
  return 'OfferLocation(lat: $lat, lng: $lng)';
}


}

/// @nodoc
abstract mixin class $OfferLocationCopyWith<$Res>  {
  factory $OfferLocationCopyWith(OfferLocation value, $Res Function(OfferLocation) _then) = _$OfferLocationCopyWithImpl;
@useResult
$Res call({
 double lat, double lng
});




}
/// @nodoc
class _$OfferLocationCopyWithImpl<$Res>
    implements $OfferLocationCopyWith<$Res> {
  _$OfferLocationCopyWithImpl(this._self, this._then);

  final OfferLocation _self;
  final $Res Function(OfferLocation) _then;

/// Create a copy of OfferLocation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lat = null,Object? lng = null,}) {
  return _then(_self.copyWith(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [OfferLocation].
extension OfferLocationPatterns on OfferLocation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OfferLocation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OfferLocation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OfferLocation value)  $default,){
final _that = this;
switch (_that) {
case _OfferLocation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OfferLocation value)?  $default,){
final _that = this;
switch (_that) {
case _OfferLocation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double lat,  double lng)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OfferLocation() when $default != null:
return $default(_that.lat,_that.lng);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double lat,  double lng)  $default,) {final _that = this;
switch (_that) {
case _OfferLocation():
return $default(_that.lat,_that.lng);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double lat,  double lng)?  $default,) {final _that = this;
switch (_that) {
case _OfferLocation() when $default != null:
return $default(_that.lat,_that.lng);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OfferLocation implements OfferLocation {
  const _OfferLocation({required this.lat, required this.lng});
  factory _OfferLocation.fromJson(Map<String, dynamic> json) => _$OfferLocationFromJson(json);

@override final  double lat;
@override final  double lng;

/// Create a copy of OfferLocation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OfferLocationCopyWith<_OfferLocation> get copyWith => __$OfferLocationCopyWithImpl<_OfferLocation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OfferLocationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OfferLocation&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,lng);

@override
String toString() {
  return 'OfferLocation(lat: $lat, lng: $lng)';
}


}

/// @nodoc
abstract mixin class _$OfferLocationCopyWith<$Res> implements $OfferLocationCopyWith<$Res> {
  factory _$OfferLocationCopyWith(_OfferLocation value, $Res Function(_OfferLocation) _then) = __$OfferLocationCopyWithImpl;
@override @useResult
$Res call({
 double lat, double lng
});




}
/// @nodoc
class __$OfferLocationCopyWithImpl<$Res>
    implements _$OfferLocationCopyWith<$Res> {
  __$OfferLocationCopyWithImpl(this._self, this._then);

  final _OfferLocation _self;
  final $Res Function(_OfferLocation) _then;

/// Create a copy of OfferLocation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lat = null,Object? lng = null,}) {
  return _then(_OfferLocation(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$OfferExtras {

 bool get windowsInside; bool get windowsInOut; bool get kitchenDeep; bool get bathroomDeep; bool get laundry; bool get ironingLight; bool get ironingFull; bool get balcony; bool get organization;
/// Create a copy of OfferExtras
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OfferExtrasCopyWith<OfferExtras> get copyWith => _$OfferExtrasCopyWithImpl<OfferExtras>(this as OfferExtras, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OfferExtras&&(identical(other.windowsInside, windowsInside) || other.windowsInside == windowsInside)&&(identical(other.windowsInOut, windowsInOut) || other.windowsInOut == windowsInOut)&&(identical(other.kitchenDeep, kitchenDeep) || other.kitchenDeep == kitchenDeep)&&(identical(other.bathroomDeep, bathroomDeep) || other.bathroomDeep == bathroomDeep)&&(identical(other.laundry, laundry) || other.laundry == laundry)&&(identical(other.ironingLight, ironingLight) || other.ironingLight == ironingLight)&&(identical(other.ironingFull, ironingFull) || other.ironingFull == ironingFull)&&(identical(other.balcony, balcony) || other.balcony == balcony)&&(identical(other.organization, organization) || other.organization == organization));
}


@override
int get hashCode => Object.hash(runtimeType,windowsInside,windowsInOut,kitchenDeep,bathroomDeep,laundry,ironingLight,ironingFull,balcony,organization);

@override
String toString() {
  return 'OfferExtras(windowsInside: $windowsInside, windowsInOut: $windowsInOut, kitchenDeep: $kitchenDeep, bathroomDeep: $bathroomDeep, laundry: $laundry, ironingLight: $ironingLight, ironingFull: $ironingFull, balcony: $balcony, organization: $organization)';
}


}

/// @nodoc
abstract mixin class $OfferExtrasCopyWith<$Res>  {
  factory $OfferExtrasCopyWith(OfferExtras value, $Res Function(OfferExtras) _then) = _$OfferExtrasCopyWithImpl;
@useResult
$Res call({
 bool windowsInside, bool windowsInOut, bool kitchenDeep, bool bathroomDeep, bool laundry, bool ironingLight, bool ironingFull, bool balcony, bool organization
});




}
/// @nodoc
class _$OfferExtrasCopyWithImpl<$Res>
    implements $OfferExtrasCopyWith<$Res> {
  _$OfferExtrasCopyWithImpl(this._self, this._then);

  final OfferExtras _self;
  final $Res Function(OfferExtras) _then;

/// Create a copy of OfferExtras
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? windowsInside = null,Object? windowsInOut = null,Object? kitchenDeep = null,Object? bathroomDeep = null,Object? laundry = null,Object? ironingLight = null,Object? ironingFull = null,Object? balcony = null,Object? organization = null,}) {
  return _then(_self.copyWith(
windowsInside: null == windowsInside ? _self.windowsInside : windowsInside // ignore: cast_nullable_to_non_nullable
as bool,windowsInOut: null == windowsInOut ? _self.windowsInOut : windowsInOut // ignore: cast_nullable_to_non_nullable
as bool,kitchenDeep: null == kitchenDeep ? _self.kitchenDeep : kitchenDeep // ignore: cast_nullable_to_non_nullable
as bool,bathroomDeep: null == bathroomDeep ? _self.bathroomDeep : bathroomDeep // ignore: cast_nullable_to_non_nullable
as bool,laundry: null == laundry ? _self.laundry : laundry // ignore: cast_nullable_to_non_nullable
as bool,ironingLight: null == ironingLight ? _self.ironingLight : ironingLight // ignore: cast_nullable_to_non_nullable
as bool,ironingFull: null == ironingFull ? _self.ironingFull : ironingFull // ignore: cast_nullable_to_non_nullable
as bool,balcony: null == balcony ? _self.balcony : balcony // ignore: cast_nullable_to_non_nullable
as bool,organization: null == organization ? _self.organization : organization // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [OfferExtras].
extension OfferExtrasPatterns on OfferExtras {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OfferExtras value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OfferExtras() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OfferExtras value)  $default,){
final _that = this;
switch (_that) {
case _OfferExtras():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OfferExtras value)?  $default,){
final _that = this;
switch (_that) {
case _OfferExtras() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool windowsInside,  bool windowsInOut,  bool kitchenDeep,  bool bathroomDeep,  bool laundry,  bool ironingLight,  bool ironingFull,  bool balcony,  bool organization)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OfferExtras() when $default != null:
return $default(_that.windowsInside,_that.windowsInOut,_that.kitchenDeep,_that.bathroomDeep,_that.laundry,_that.ironingLight,_that.ironingFull,_that.balcony,_that.organization);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool windowsInside,  bool windowsInOut,  bool kitchenDeep,  bool bathroomDeep,  bool laundry,  bool ironingLight,  bool ironingFull,  bool balcony,  bool organization)  $default,) {final _that = this;
switch (_that) {
case _OfferExtras():
return $default(_that.windowsInside,_that.windowsInOut,_that.kitchenDeep,_that.bathroomDeep,_that.laundry,_that.ironingLight,_that.ironingFull,_that.balcony,_that.organization);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool windowsInside,  bool windowsInOut,  bool kitchenDeep,  bool bathroomDeep,  bool laundry,  bool ironingLight,  bool ironingFull,  bool balcony,  bool organization)?  $default,) {final _that = this;
switch (_that) {
case _OfferExtras() when $default != null:
return $default(_that.windowsInside,_that.windowsInOut,_that.kitchenDeep,_that.bathroomDeep,_that.laundry,_that.ironingLight,_that.ironingFull,_that.balcony,_that.organization);case _:
  return null;

}
}

}

/// @nodoc


class _OfferExtras extends OfferExtras {
  const _OfferExtras({this.windowsInside = false, this.windowsInOut = false, this.kitchenDeep = false, this.bathroomDeep = false, this.laundry = false, this.ironingLight = false, this.ironingFull = false, this.balcony = false, this.organization = false}): super._();
  

@override@JsonKey() final  bool windowsInside;
@override@JsonKey() final  bool windowsInOut;
@override@JsonKey() final  bool kitchenDeep;
@override@JsonKey() final  bool bathroomDeep;
@override@JsonKey() final  bool laundry;
@override@JsonKey() final  bool ironingLight;
@override@JsonKey() final  bool ironingFull;
@override@JsonKey() final  bool balcony;
@override@JsonKey() final  bool organization;

/// Create a copy of OfferExtras
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OfferExtrasCopyWith<_OfferExtras> get copyWith => __$OfferExtrasCopyWithImpl<_OfferExtras>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OfferExtras&&(identical(other.windowsInside, windowsInside) || other.windowsInside == windowsInside)&&(identical(other.windowsInOut, windowsInOut) || other.windowsInOut == windowsInOut)&&(identical(other.kitchenDeep, kitchenDeep) || other.kitchenDeep == kitchenDeep)&&(identical(other.bathroomDeep, bathroomDeep) || other.bathroomDeep == bathroomDeep)&&(identical(other.laundry, laundry) || other.laundry == laundry)&&(identical(other.ironingLight, ironingLight) || other.ironingLight == ironingLight)&&(identical(other.ironingFull, ironingFull) || other.ironingFull == ironingFull)&&(identical(other.balcony, balcony) || other.balcony == balcony)&&(identical(other.organization, organization) || other.organization == organization));
}


@override
int get hashCode => Object.hash(runtimeType,windowsInside,windowsInOut,kitchenDeep,bathroomDeep,laundry,ironingLight,ironingFull,balcony,organization);

@override
String toString() {
  return 'OfferExtras(windowsInside: $windowsInside, windowsInOut: $windowsInOut, kitchenDeep: $kitchenDeep, bathroomDeep: $bathroomDeep, laundry: $laundry, ironingLight: $ironingLight, ironingFull: $ironingFull, balcony: $balcony, organization: $organization)';
}


}

/// @nodoc
abstract mixin class _$OfferExtrasCopyWith<$Res> implements $OfferExtrasCopyWith<$Res> {
  factory _$OfferExtrasCopyWith(_OfferExtras value, $Res Function(_OfferExtras) _then) = __$OfferExtrasCopyWithImpl;
@override @useResult
$Res call({
 bool windowsInside, bool windowsInOut, bool kitchenDeep, bool bathroomDeep, bool laundry, bool ironingLight, bool ironingFull, bool balcony, bool organization
});




}
/// @nodoc
class __$OfferExtrasCopyWithImpl<$Res>
    implements _$OfferExtrasCopyWith<$Res> {
  __$OfferExtrasCopyWithImpl(this._self, this._then);

  final _OfferExtras _self;
  final $Res Function(_OfferExtras) _then;

/// Create a copy of OfferExtras
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? windowsInside = null,Object? windowsInOut = null,Object? kitchenDeep = null,Object? bathroomDeep = null,Object? laundry = null,Object? ironingLight = null,Object? ironingFull = null,Object? balcony = null,Object? organization = null,}) {
  return _then(_OfferExtras(
windowsInside: null == windowsInside ? _self.windowsInside : windowsInside // ignore: cast_nullable_to_non_nullable
as bool,windowsInOut: null == windowsInOut ? _self.windowsInOut : windowsInOut // ignore: cast_nullable_to_non_nullable
as bool,kitchenDeep: null == kitchenDeep ? _self.kitchenDeep : kitchenDeep // ignore: cast_nullable_to_non_nullable
as bool,bathroomDeep: null == bathroomDeep ? _self.bathroomDeep : bathroomDeep // ignore: cast_nullable_to_non_nullable
as bool,laundry: null == laundry ? _self.laundry : laundry // ignore: cast_nullable_to_non_nullable
as bool,ironingLight: null == ironingLight ? _self.ironingLight : ironingLight // ignore: cast_nullable_to_non_nullable
as bool,ironingFull: null == ironingFull ? _self.ironingFull : ironingFull // ignore: cast_nullable_to_non_nullable
as bool,balcony: null == balcony ? _self.balcony : balcony // ignore: cast_nullable_to_non_nullable
as bool,organization: null == organization ? _self.organization : organization // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

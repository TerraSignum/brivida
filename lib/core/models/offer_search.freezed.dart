// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'offer_search.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OfferSearchFilter {

 DateTime get when; double get durationHours; OfferLocation get geo; int get radiusKm; bool get recurring;@OfferExtrasConverter() OfferExtras get extras;
/// Create a copy of OfferSearchFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OfferSearchFilterCopyWith<OfferSearchFilter> get copyWith => _$OfferSearchFilterCopyWithImpl<OfferSearchFilter>(this as OfferSearchFilter, _$identity);

  /// Serializes this OfferSearchFilter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OfferSearchFilter&&(identical(other.when, when) || other.when == when)&&(identical(other.durationHours, durationHours) || other.durationHours == durationHours)&&(identical(other.geo, geo) || other.geo == geo)&&(identical(other.radiusKm, radiusKm) || other.radiusKm == radiusKm)&&(identical(other.recurring, recurring) || other.recurring == recurring)&&(identical(other.extras, extras) || other.extras == extras));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,when,durationHours,geo,radiusKm,recurring,extras);

@override
String toString() {
  return 'OfferSearchFilter(when: $when, durationHours: $durationHours, geo: $geo, radiusKm: $radiusKm, recurring: $recurring, extras: $extras)';
}


}

/// @nodoc
abstract mixin class $OfferSearchFilterCopyWith<$Res>  {
  factory $OfferSearchFilterCopyWith(OfferSearchFilter value, $Res Function(OfferSearchFilter) _then) = _$OfferSearchFilterCopyWithImpl;
@useResult
$Res call({
 DateTime when, double durationHours, OfferLocation geo, int radiusKm, bool recurring,@OfferExtrasConverter() OfferExtras extras
});


$OfferLocationCopyWith<$Res> get geo;$OfferExtrasCopyWith<$Res> get extras;

}
/// @nodoc
class _$OfferSearchFilterCopyWithImpl<$Res>
    implements $OfferSearchFilterCopyWith<$Res> {
  _$OfferSearchFilterCopyWithImpl(this._self, this._then);

  final OfferSearchFilter _self;
  final $Res Function(OfferSearchFilter) _then;

/// Create a copy of OfferSearchFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? when = null,Object? durationHours = null,Object? geo = null,Object? radiusKm = null,Object? recurring = null,Object? extras = null,}) {
  return _then(_self.copyWith(
when: null == when ? _self.when : when // ignore: cast_nullable_to_non_nullable
as DateTime,durationHours: null == durationHours ? _self.durationHours : durationHours // ignore: cast_nullable_to_non_nullable
as double,geo: null == geo ? _self.geo : geo // ignore: cast_nullable_to_non_nullable
as OfferLocation,radiusKm: null == radiusKm ? _self.radiusKm : radiusKm // ignore: cast_nullable_to_non_nullable
as int,recurring: null == recurring ? _self.recurring : recurring // ignore: cast_nullable_to_non_nullable
as bool,extras: null == extras ? _self.extras : extras // ignore: cast_nullable_to_non_nullable
as OfferExtras,
  ));
}
/// Create a copy of OfferSearchFilter
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OfferLocationCopyWith<$Res> get geo {
  
  return $OfferLocationCopyWith<$Res>(_self.geo, (value) {
    return _then(_self.copyWith(geo: value));
  });
}/// Create a copy of OfferSearchFilter
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OfferExtrasCopyWith<$Res> get extras {
  
  return $OfferExtrasCopyWith<$Res>(_self.extras, (value) {
    return _then(_self.copyWith(extras: value));
  });
}
}


/// Adds pattern-matching-related methods to [OfferSearchFilter].
extension OfferSearchFilterPatterns on OfferSearchFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OfferSearchFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OfferSearchFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OfferSearchFilter value)  $default,){
final _that = this;
switch (_that) {
case _OfferSearchFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OfferSearchFilter value)?  $default,){
final _that = this;
switch (_that) {
case _OfferSearchFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime when,  double durationHours,  OfferLocation geo,  int radiusKm,  bool recurring, @OfferExtrasConverter()  OfferExtras extras)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OfferSearchFilter() when $default != null:
return $default(_that.when,_that.durationHours,_that.geo,_that.radiusKm,_that.recurring,_that.extras);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime when,  double durationHours,  OfferLocation geo,  int radiusKm,  bool recurring, @OfferExtrasConverter()  OfferExtras extras)  $default,) {final _that = this;
switch (_that) {
case _OfferSearchFilter():
return $default(_that.when,_that.durationHours,_that.geo,_that.radiusKm,_that.recurring,_that.extras);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime when,  double durationHours,  OfferLocation geo,  int radiusKm,  bool recurring, @OfferExtrasConverter()  OfferExtras extras)?  $default,) {final _that = this;
switch (_that) {
case _OfferSearchFilter() when $default != null:
return $default(_that.when,_that.durationHours,_that.geo,_that.radiusKm,_that.recurring,_that.extras);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OfferSearchFilter implements OfferSearchFilter {
  const _OfferSearchFilter({required this.when, this.durationHours = 2.0, required this.geo, this.radiusKm = 25, this.recurring = false, @OfferExtrasConverter() this.extras = const OfferExtras()});
  factory _OfferSearchFilter.fromJson(Map<String, dynamic> json) => _$OfferSearchFilterFromJson(json);

@override final  DateTime when;
@override@JsonKey() final  double durationHours;
@override final  OfferLocation geo;
@override@JsonKey() final  int radiusKm;
@override@JsonKey() final  bool recurring;
@override@JsonKey()@OfferExtrasConverter() final  OfferExtras extras;

/// Create a copy of OfferSearchFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OfferSearchFilterCopyWith<_OfferSearchFilter> get copyWith => __$OfferSearchFilterCopyWithImpl<_OfferSearchFilter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OfferSearchFilterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OfferSearchFilter&&(identical(other.when, when) || other.when == when)&&(identical(other.durationHours, durationHours) || other.durationHours == durationHours)&&(identical(other.geo, geo) || other.geo == geo)&&(identical(other.radiusKm, radiusKm) || other.radiusKm == radiusKm)&&(identical(other.recurring, recurring) || other.recurring == recurring)&&(identical(other.extras, extras) || other.extras == extras));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,when,durationHours,geo,radiusKm,recurring,extras);

@override
String toString() {
  return 'OfferSearchFilter(when: $when, durationHours: $durationHours, geo: $geo, radiusKm: $radiusKm, recurring: $recurring, extras: $extras)';
}


}

/// @nodoc
abstract mixin class _$OfferSearchFilterCopyWith<$Res> implements $OfferSearchFilterCopyWith<$Res> {
  factory _$OfferSearchFilterCopyWith(_OfferSearchFilter value, $Res Function(_OfferSearchFilter) _then) = __$OfferSearchFilterCopyWithImpl;
@override @useResult
$Res call({
 DateTime when, double durationHours, OfferLocation geo, int radiusKm, bool recurring,@OfferExtrasConverter() OfferExtras extras
});


@override $OfferLocationCopyWith<$Res> get geo;@override $OfferExtrasCopyWith<$Res> get extras;

}
/// @nodoc
class __$OfferSearchFilterCopyWithImpl<$Res>
    implements _$OfferSearchFilterCopyWith<$Res> {
  __$OfferSearchFilterCopyWithImpl(this._self, this._then);

  final _OfferSearchFilter _self;
  final $Res Function(_OfferSearchFilter) _then;

/// Create a copy of OfferSearchFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? when = null,Object? durationHours = null,Object? geo = null,Object? radiusKm = null,Object? recurring = null,Object? extras = null,}) {
  return _then(_OfferSearchFilter(
when: null == when ? _self.when : when // ignore: cast_nullable_to_non_nullable
as DateTime,durationHours: null == durationHours ? _self.durationHours : durationHours // ignore: cast_nullable_to_non_nullable
as double,geo: null == geo ? _self.geo : geo // ignore: cast_nullable_to_non_nullable
as OfferLocation,radiusKm: null == radiusKm ? _self.radiusKm : radiusKm // ignore: cast_nullable_to_non_nullable
as int,recurring: null == recurring ? _self.recurring : recurring // ignore: cast_nullable_to_non_nullable
as bool,extras: null == extras ? _self.extras : extras // ignore: cast_nullable_to_non_nullable
as OfferExtras,
  ));
}

/// Create a copy of OfferSearchFilter
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OfferLocationCopyWith<$Res> get geo {
  
  return $OfferLocationCopyWith<$Res>(_self.geo, (value) {
    return _then(_self.copyWith(geo: value));
  });
}/// Create a copy of OfferSearchFilter
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OfferExtrasCopyWith<$Res> get extras {
  
  return $OfferExtrasCopyWith<$Res>(_self.extras, (value) {
    return _then(_self.copyWith(extras: value));
  });
}
}


/// @nodoc
mixin _$OfferSearchResult {

 String get offerId; String get proId; String get title; double get distanceKm; OfferWindow get window; OfferSupports get supports; OfferSummaryPro get pro;
/// Create a copy of OfferSearchResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OfferSearchResultCopyWith<OfferSearchResult> get copyWith => _$OfferSearchResultCopyWithImpl<OfferSearchResult>(this as OfferSearchResult, _$identity);

  /// Serializes this OfferSearchResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OfferSearchResult&&(identical(other.offerId, offerId) || other.offerId == offerId)&&(identical(other.proId, proId) || other.proId == proId)&&(identical(other.title, title) || other.title == title)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.window, window) || other.window == window)&&(identical(other.supports, supports) || other.supports == supports)&&(identical(other.pro, pro) || other.pro == pro));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,offerId,proId,title,distanceKm,window,supports,pro);

@override
String toString() {
  return 'OfferSearchResult(offerId: $offerId, proId: $proId, title: $title, distanceKm: $distanceKm, window: $window, supports: $supports, pro: $pro)';
}


}

/// @nodoc
abstract mixin class $OfferSearchResultCopyWith<$Res>  {
  factory $OfferSearchResultCopyWith(OfferSearchResult value, $Res Function(OfferSearchResult) _then) = _$OfferSearchResultCopyWithImpl;
@useResult
$Res call({
 String offerId, String proId, String title, double distanceKm, OfferWindow window, OfferSupports supports, OfferSummaryPro pro
});


$OfferWindowCopyWith<$Res> get window;$OfferSupportsCopyWith<$Res> get supports;$OfferSummaryProCopyWith<$Res> get pro;

}
/// @nodoc
class _$OfferSearchResultCopyWithImpl<$Res>
    implements $OfferSearchResultCopyWith<$Res> {
  _$OfferSearchResultCopyWithImpl(this._self, this._then);

  final OfferSearchResult _self;
  final $Res Function(OfferSearchResult) _then;

/// Create a copy of OfferSearchResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? offerId = null,Object? proId = null,Object? title = null,Object? distanceKm = null,Object? window = null,Object? supports = null,Object? pro = null,}) {
  return _then(_self.copyWith(
offerId: null == offerId ? _self.offerId : offerId // ignore: cast_nullable_to_non_nullable
as String,proId: null == proId ? _self.proId : proId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,distanceKm: null == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double,window: null == window ? _self.window : window // ignore: cast_nullable_to_non_nullable
as OfferWindow,supports: null == supports ? _self.supports : supports // ignore: cast_nullable_to_non_nullable
as OfferSupports,pro: null == pro ? _self.pro : pro // ignore: cast_nullable_to_non_nullable
as OfferSummaryPro,
  ));
}
/// Create a copy of OfferSearchResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OfferWindowCopyWith<$Res> get window {
  
  return $OfferWindowCopyWith<$Res>(_self.window, (value) {
    return _then(_self.copyWith(window: value));
  });
}/// Create a copy of OfferSearchResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OfferSupportsCopyWith<$Res> get supports {
  
  return $OfferSupportsCopyWith<$Res>(_self.supports, (value) {
    return _then(_self.copyWith(supports: value));
  });
}/// Create a copy of OfferSearchResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OfferSummaryProCopyWith<$Res> get pro {
  
  return $OfferSummaryProCopyWith<$Res>(_self.pro, (value) {
    return _then(_self.copyWith(pro: value));
  });
}
}


/// Adds pattern-matching-related methods to [OfferSearchResult].
extension OfferSearchResultPatterns on OfferSearchResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OfferSearchResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OfferSearchResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OfferSearchResult value)  $default,){
final _that = this;
switch (_that) {
case _OfferSearchResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OfferSearchResult value)?  $default,){
final _that = this;
switch (_that) {
case _OfferSearchResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String offerId,  String proId,  String title,  double distanceKm,  OfferWindow window,  OfferSupports supports,  OfferSummaryPro pro)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OfferSearchResult() when $default != null:
return $default(_that.offerId,_that.proId,_that.title,_that.distanceKm,_that.window,_that.supports,_that.pro);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String offerId,  String proId,  String title,  double distanceKm,  OfferWindow window,  OfferSupports supports,  OfferSummaryPro pro)  $default,) {final _that = this;
switch (_that) {
case _OfferSearchResult():
return $default(_that.offerId,_that.proId,_that.title,_that.distanceKm,_that.window,_that.supports,_that.pro);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String offerId,  String proId,  String title,  double distanceKm,  OfferWindow window,  OfferSupports supports,  OfferSummaryPro pro)?  $default,) {final _that = this;
switch (_that) {
case _OfferSearchResult() when $default != null:
return $default(_that.offerId,_that.proId,_that.title,_that.distanceKm,_that.window,_that.supports,_that.pro);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OfferSearchResult implements OfferSearchResult {
  const _OfferSearchResult({required this.offerId, required this.proId, required this.title, this.distanceKm = 0.0, required this.window, required this.supports, required this.pro});
  factory _OfferSearchResult.fromJson(Map<String, dynamic> json) => _$OfferSearchResultFromJson(json);

@override final  String offerId;
@override final  String proId;
@override final  String title;
@override@JsonKey() final  double distanceKm;
@override final  OfferWindow window;
@override final  OfferSupports supports;
@override final  OfferSummaryPro pro;

/// Create a copy of OfferSearchResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OfferSearchResultCopyWith<_OfferSearchResult> get copyWith => __$OfferSearchResultCopyWithImpl<_OfferSearchResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OfferSearchResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OfferSearchResult&&(identical(other.offerId, offerId) || other.offerId == offerId)&&(identical(other.proId, proId) || other.proId == proId)&&(identical(other.title, title) || other.title == title)&&(identical(other.distanceKm, distanceKm) || other.distanceKm == distanceKm)&&(identical(other.window, window) || other.window == window)&&(identical(other.supports, supports) || other.supports == supports)&&(identical(other.pro, pro) || other.pro == pro));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,offerId,proId,title,distanceKm,window,supports,pro);

@override
String toString() {
  return 'OfferSearchResult(offerId: $offerId, proId: $proId, title: $title, distanceKm: $distanceKm, window: $window, supports: $supports, pro: $pro)';
}


}

/// @nodoc
abstract mixin class _$OfferSearchResultCopyWith<$Res> implements $OfferSearchResultCopyWith<$Res> {
  factory _$OfferSearchResultCopyWith(_OfferSearchResult value, $Res Function(_OfferSearchResult) _then) = __$OfferSearchResultCopyWithImpl;
@override @useResult
$Res call({
 String offerId, String proId, String title, double distanceKm, OfferWindow window, OfferSupports supports, OfferSummaryPro pro
});


@override $OfferWindowCopyWith<$Res> get window;@override $OfferSupportsCopyWith<$Res> get supports;@override $OfferSummaryProCopyWith<$Res> get pro;

}
/// @nodoc
class __$OfferSearchResultCopyWithImpl<$Res>
    implements _$OfferSearchResultCopyWith<$Res> {
  __$OfferSearchResultCopyWithImpl(this._self, this._then);

  final _OfferSearchResult _self;
  final $Res Function(_OfferSearchResult) _then;

/// Create a copy of OfferSearchResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? offerId = null,Object? proId = null,Object? title = null,Object? distanceKm = null,Object? window = null,Object? supports = null,Object? pro = null,}) {
  return _then(_OfferSearchResult(
offerId: null == offerId ? _self.offerId : offerId // ignore: cast_nullable_to_non_nullable
as String,proId: null == proId ? _self.proId : proId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,distanceKm: null == distanceKm ? _self.distanceKm : distanceKm // ignore: cast_nullable_to_non_nullable
as double,window: null == window ? _self.window : window // ignore: cast_nullable_to_non_nullable
as OfferWindow,supports: null == supports ? _self.supports : supports // ignore: cast_nullable_to_non_nullable
as OfferSupports,pro: null == pro ? _self.pro : pro // ignore: cast_nullable_to_non_nullable
as OfferSummaryPro,
  ));
}

/// Create a copy of OfferSearchResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OfferWindowCopyWith<$Res> get window {
  
  return $OfferWindowCopyWith<$Res>(_self.window, (value) {
    return _then(_self.copyWith(window: value));
  });
}/// Create a copy of OfferSearchResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OfferSupportsCopyWith<$Res> get supports {
  
  return $OfferSupportsCopyWith<$Res>(_self.supports, (value) {
    return _then(_self.copyWith(supports: value));
  });
}/// Create a copy of OfferSearchResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OfferSummaryProCopyWith<$Res> get pro {
  
  return $OfferSummaryProCopyWith<$Res>(_self.pro, (value) {
    return _then(_self.copyWith(pro: value));
  });
}
}


/// @nodoc
mixin _$OfferWindow {

 String get from; String get to;
/// Create a copy of OfferWindow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OfferWindowCopyWith<OfferWindow> get copyWith => _$OfferWindowCopyWithImpl<OfferWindow>(this as OfferWindow, _$identity);

  /// Serializes this OfferWindow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OfferWindow&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,from,to);

@override
String toString() {
  return 'OfferWindow(from: $from, to: $to)';
}


}

/// @nodoc
abstract mixin class $OfferWindowCopyWith<$Res>  {
  factory $OfferWindowCopyWith(OfferWindow value, $Res Function(OfferWindow) _then) = _$OfferWindowCopyWithImpl;
@useResult
$Res call({
 String from, String to
});




}
/// @nodoc
class _$OfferWindowCopyWithImpl<$Res>
    implements $OfferWindowCopyWith<$Res> {
  _$OfferWindowCopyWithImpl(this._self, this._then);

  final OfferWindow _self;
  final $Res Function(OfferWindow) _then;

/// Create a copy of OfferWindow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? from = null,Object? to = null,}) {
  return _then(_self.copyWith(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OfferWindow].
extension OfferWindowPatterns on OfferWindow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OfferWindow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OfferWindow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OfferWindow value)  $default,){
final _that = this;
switch (_that) {
case _OfferWindow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OfferWindow value)?  $default,){
final _that = this;
switch (_that) {
case _OfferWindow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String from,  String to)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OfferWindow() when $default != null:
return $default(_that.from,_that.to);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String from,  String to)  $default,) {final _that = this;
switch (_that) {
case _OfferWindow():
return $default(_that.from,_that.to);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String from,  String to)?  $default,) {final _that = this;
switch (_that) {
case _OfferWindow() when $default != null:
return $default(_that.from,_that.to);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OfferWindow implements OfferWindow {
  const _OfferWindow({required this.from, required this.to});
  factory _OfferWindow.fromJson(Map<String, dynamic> json) => _$OfferWindowFromJson(json);

@override final  String from;
@override final  String to;

/// Create a copy of OfferWindow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OfferWindowCopyWith<_OfferWindow> get copyWith => __$OfferWindowCopyWithImpl<_OfferWindow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OfferWindowToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OfferWindow&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,from,to);

@override
String toString() {
  return 'OfferWindow(from: $from, to: $to)';
}


}

/// @nodoc
abstract mixin class _$OfferWindowCopyWith<$Res> implements $OfferWindowCopyWith<$Res> {
  factory _$OfferWindowCopyWith(_OfferWindow value, $Res Function(_OfferWindow) _then) = __$OfferWindowCopyWithImpl;
@override @useResult
$Res call({
 String from, String to
});




}
/// @nodoc
class __$OfferWindowCopyWithImpl<$Res>
    implements _$OfferWindowCopyWith<$Res> {
  __$OfferWindowCopyWithImpl(this._self, this._then);

  final _OfferWindow _self;
  final $Res Function(_OfferWindow) _then;

/// Create a copy of OfferWindow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? from = null,Object? to = null,}) {
  return _then(_OfferWindow(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$OfferSupports {

 bool get acceptsRecurring;@OfferExtrasConverter() OfferExtras get extras;
/// Create a copy of OfferSupports
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OfferSupportsCopyWith<OfferSupports> get copyWith => _$OfferSupportsCopyWithImpl<OfferSupports>(this as OfferSupports, _$identity);

  /// Serializes this OfferSupports to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OfferSupports&&(identical(other.acceptsRecurring, acceptsRecurring) || other.acceptsRecurring == acceptsRecurring)&&(identical(other.extras, extras) || other.extras == extras));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,acceptsRecurring,extras);

@override
String toString() {
  return 'OfferSupports(acceptsRecurring: $acceptsRecurring, extras: $extras)';
}


}

/// @nodoc
abstract mixin class $OfferSupportsCopyWith<$Res>  {
  factory $OfferSupportsCopyWith(OfferSupports value, $Res Function(OfferSupports) _then) = _$OfferSupportsCopyWithImpl;
@useResult
$Res call({
 bool acceptsRecurring,@OfferExtrasConverter() OfferExtras extras
});


$OfferExtrasCopyWith<$Res> get extras;

}
/// @nodoc
class _$OfferSupportsCopyWithImpl<$Res>
    implements $OfferSupportsCopyWith<$Res> {
  _$OfferSupportsCopyWithImpl(this._self, this._then);

  final OfferSupports _self;
  final $Res Function(OfferSupports) _then;

/// Create a copy of OfferSupports
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? acceptsRecurring = null,Object? extras = null,}) {
  return _then(_self.copyWith(
acceptsRecurring: null == acceptsRecurring ? _self.acceptsRecurring : acceptsRecurring // ignore: cast_nullable_to_non_nullable
as bool,extras: null == extras ? _self.extras : extras // ignore: cast_nullable_to_non_nullable
as OfferExtras,
  ));
}
/// Create a copy of OfferSupports
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OfferExtrasCopyWith<$Res> get extras {
  
  return $OfferExtrasCopyWith<$Res>(_self.extras, (value) {
    return _then(_self.copyWith(extras: value));
  });
}
}


/// Adds pattern-matching-related methods to [OfferSupports].
extension OfferSupportsPatterns on OfferSupports {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OfferSupports value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OfferSupports() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OfferSupports value)  $default,){
final _that = this;
switch (_that) {
case _OfferSupports():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OfferSupports value)?  $default,){
final _that = this;
switch (_that) {
case _OfferSupports() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool acceptsRecurring, @OfferExtrasConverter()  OfferExtras extras)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OfferSupports() when $default != null:
return $default(_that.acceptsRecurring,_that.extras);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool acceptsRecurring, @OfferExtrasConverter()  OfferExtras extras)  $default,) {final _that = this;
switch (_that) {
case _OfferSupports():
return $default(_that.acceptsRecurring,_that.extras);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool acceptsRecurring, @OfferExtrasConverter()  OfferExtras extras)?  $default,) {final _that = this;
switch (_that) {
case _OfferSupports() when $default != null:
return $default(_that.acceptsRecurring,_that.extras);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OfferSupports implements OfferSupports {
  const _OfferSupports({this.acceptsRecurring = false, @OfferExtrasConverter() this.extras = const OfferExtras()});
  factory _OfferSupports.fromJson(Map<String, dynamic> json) => _$OfferSupportsFromJson(json);

@override@JsonKey() final  bool acceptsRecurring;
@override@JsonKey()@OfferExtrasConverter() final  OfferExtras extras;

/// Create a copy of OfferSupports
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OfferSupportsCopyWith<_OfferSupports> get copyWith => __$OfferSupportsCopyWithImpl<_OfferSupports>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OfferSupportsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OfferSupports&&(identical(other.acceptsRecurring, acceptsRecurring) || other.acceptsRecurring == acceptsRecurring)&&(identical(other.extras, extras) || other.extras == extras));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,acceptsRecurring,extras);

@override
String toString() {
  return 'OfferSupports(acceptsRecurring: $acceptsRecurring, extras: $extras)';
}


}

/// @nodoc
abstract mixin class _$OfferSupportsCopyWith<$Res> implements $OfferSupportsCopyWith<$Res> {
  factory _$OfferSupportsCopyWith(_OfferSupports value, $Res Function(_OfferSupports) _then) = __$OfferSupportsCopyWithImpl;
@override @useResult
$Res call({
 bool acceptsRecurring,@OfferExtrasConverter() OfferExtras extras
});


@override $OfferExtrasCopyWith<$Res> get extras;

}
/// @nodoc
class __$OfferSupportsCopyWithImpl<$Res>
    implements _$OfferSupportsCopyWith<$Res> {
  __$OfferSupportsCopyWithImpl(this._self, this._then);

  final _OfferSupports _self;
  final $Res Function(_OfferSupports) _then;

/// Create a copy of OfferSupports
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? acceptsRecurring = null,Object? extras = null,}) {
  return _then(_OfferSupports(
acceptsRecurring: null == acceptsRecurring ? _self.acceptsRecurring : acceptsRecurring // ignore: cast_nullable_to_non_nullable
as bool,extras: null == extras ? _self.extras : extras // ignore: cast_nullable_to_non_nullable
as OfferExtras,
  ));
}

/// Create a copy of OfferSupports
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OfferExtrasCopyWith<$Res> get extras {
  
  return $OfferExtrasCopyWith<$Res>(_self.extras, (value) {
    return _then(_self.copyWith(extras: value));
  });
}
}


/// @nodoc
mixin _$OfferSummaryPro {

 String get displayName; String get username; bool get isVerified; double get rating; int get jobsDone; String? get photoUrl;
/// Create a copy of OfferSummaryPro
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OfferSummaryProCopyWith<OfferSummaryPro> get copyWith => _$OfferSummaryProCopyWithImpl<OfferSummaryPro>(this as OfferSummaryPro, _$identity);

  /// Serializes this OfferSummaryPro to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OfferSummaryPro&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.username, username) || other.username == username)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.jobsDone, jobsDone) || other.jobsDone == jobsDone)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,displayName,username,isVerified,rating,jobsDone,photoUrl);

@override
String toString() {
  return 'OfferSummaryPro(displayName: $displayName, username: $username, isVerified: $isVerified, rating: $rating, jobsDone: $jobsDone, photoUrl: $photoUrl)';
}


}

/// @nodoc
abstract mixin class $OfferSummaryProCopyWith<$Res>  {
  factory $OfferSummaryProCopyWith(OfferSummaryPro value, $Res Function(OfferSummaryPro) _then) = _$OfferSummaryProCopyWithImpl;
@useResult
$Res call({
 String displayName, String username, bool isVerified, double rating, int jobsDone, String? photoUrl
});




}
/// @nodoc
class _$OfferSummaryProCopyWithImpl<$Res>
    implements $OfferSummaryProCopyWith<$Res> {
  _$OfferSummaryProCopyWithImpl(this._self, this._then);

  final OfferSummaryPro _self;
  final $Res Function(OfferSummaryPro) _then;

/// Create a copy of OfferSummaryPro
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? displayName = null,Object? username = null,Object? isVerified = null,Object? rating = null,Object? jobsDone = null,Object? photoUrl = freezed,}) {
  return _then(_self.copyWith(
displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,jobsDone: null == jobsDone ? _self.jobsDone : jobsDone // ignore: cast_nullable_to_non_nullable
as int,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OfferSummaryPro].
extension OfferSummaryProPatterns on OfferSummaryPro {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OfferSummaryPro value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OfferSummaryPro() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OfferSummaryPro value)  $default,){
final _that = this;
switch (_that) {
case _OfferSummaryPro():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OfferSummaryPro value)?  $default,){
final _that = this;
switch (_that) {
case _OfferSummaryPro() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String displayName,  String username,  bool isVerified,  double rating,  int jobsDone,  String? photoUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OfferSummaryPro() when $default != null:
return $default(_that.displayName,_that.username,_that.isVerified,_that.rating,_that.jobsDone,_that.photoUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String displayName,  String username,  bool isVerified,  double rating,  int jobsDone,  String? photoUrl)  $default,) {final _that = this;
switch (_that) {
case _OfferSummaryPro():
return $default(_that.displayName,_that.username,_that.isVerified,_that.rating,_that.jobsDone,_that.photoUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String displayName,  String username,  bool isVerified,  double rating,  int jobsDone,  String? photoUrl)?  $default,) {final _that = this;
switch (_that) {
case _OfferSummaryPro() when $default != null:
return $default(_that.displayName,_that.username,_that.isVerified,_that.rating,_that.jobsDone,_that.photoUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OfferSummaryPro implements OfferSummaryPro {
  const _OfferSummaryPro({required this.displayName, this.username = '', this.isVerified = false, this.rating = 0.0, this.jobsDone = 0, this.photoUrl});
  factory _OfferSummaryPro.fromJson(Map<String, dynamic> json) => _$OfferSummaryProFromJson(json);

@override final  String displayName;
@override@JsonKey() final  String username;
@override@JsonKey() final  bool isVerified;
@override@JsonKey() final  double rating;
@override@JsonKey() final  int jobsDone;
@override final  String? photoUrl;

/// Create a copy of OfferSummaryPro
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OfferSummaryProCopyWith<_OfferSummaryPro> get copyWith => __$OfferSummaryProCopyWithImpl<_OfferSummaryPro>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OfferSummaryProToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OfferSummaryPro&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.username, username) || other.username == username)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.jobsDone, jobsDone) || other.jobsDone == jobsDone)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,displayName,username,isVerified,rating,jobsDone,photoUrl);

@override
String toString() {
  return 'OfferSummaryPro(displayName: $displayName, username: $username, isVerified: $isVerified, rating: $rating, jobsDone: $jobsDone, photoUrl: $photoUrl)';
}


}

/// @nodoc
abstract mixin class _$OfferSummaryProCopyWith<$Res> implements $OfferSummaryProCopyWith<$Res> {
  factory _$OfferSummaryProCopyWith(_OfferSummaryPro value, $Res Function(_OfferSummaryPro) _then) = __$OfferSummaryProCopyWithImpl;
@override @useResult
$Res call({
 String displayName, String username, bool isVerified, double rating, int jobsDone, String? photoUrl
});




}
/// @nodoc
class __$OfferSummaryProCopyWithImpl<$Res>
    implements _$OfferSummaryProCopyWith<$Res> {
  __$OfferSummaryProCopyWithImpl(this._self, this._then);

  final _OfferSummaryPro _self;
  final $Res Function(_OfferSummaryPro) _then;

/// Create a copy of OfferSummaryPro
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? displayName = null,Object? username = null,Object? isVerified = null,Object? rating = null,Object? jobsDone = null,Object? photoUrl = freezed,}) {
  return _then(_OfferSummaryPro(
displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,jobsDone: null == jobsDone ? _self.jobsDone : jobsDone // ignore: cast_nullable_to_non_nullable
as int,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

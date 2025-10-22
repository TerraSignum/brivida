// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'offer_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OfferRequest {

 String? get id; String get customerId; String get offerId; String get proId; OfferRequestJob get job; OfferRequestPrice get price; OfferRequestStatus get status;@TimestampConverter() DateTime? get createdAt;@TimestampConverter() DateTime? get expiresAt; String? get chatId;
/// Create a copy of OfferRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OfferRequestCopyWith<OfferRequest> get copyWith => _$OfferRequestCopyWithImpl<OfferRequest>(this as OfferRequest, _$identity);

  /// Serializes this OfferRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OfferRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.offerId, offerId) || other.offerId == offerId)&&(identical(other.proId, proId) || other.proId == proId)&&(identical(other.job, job) || other.job == job)&&(identical(other.price, price) || other.price == price)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.chatId, chatId) || other.chatId == chatId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,customerId,offerId,proId,job,price,status,createdAt,expiresAt,chatId);

@override
String toString() {
  return 'OfferRequest(id: $id, customerId: $customerId, offerId: $offerId, proId: $proId, job: $job, price: $price, status: $status, createdAt: $createdAt, expiresAt: $expiresAt, chatId: $chatId)';
}


}

/// @nodoc
abstract mixin class $OfferRequestCopyWith<$Res>  {
  factory $OfferRequestCopyWith(OfferRequest value, $Res Function(OfferRequest) _then) = _$OfferRequestCopyWithImpl;
@useResult
$Res call({
 String? id, String customerId, String offerId, String proId, OfferRequestJob job, OfferRequestPrice price, OfferRequestStatus status,@TimestampConverter() DateTime? createdAt,@TimestampConverter() DateTime? expiresAt, String? chatId
});


$OfferRequestJobCopyWith<$Res> get job;$OfferRequestPriceCopyWith<$Res> get price;

}
/// @nodoc
class _$OfferRequestCopyWithImpl<$Res>
    implements $OfferRequestCopyWith<$Res> {
  _$OfferRequestCopyWithImpl(this._self, this._then);

  final OfferRequest _self;
  final $Res Function(OfferRequest) _then;

/// Create a copy of OfferRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? customerId = null,Object? offerId = null,Object? proId = null,Object? job = null,Object? price = null,Object? status = null,Object? createdAt = freezed,Object? expiresAt = freezed,Object? chatId = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,offerId: null == offerId ? _self.offerId : offerId // ignore: cast_nullable_to_non_nullable
as String,proId: null == proId ? _self.proId : proId // ignore: cast_nullable_to_non_nullable
as String,job: null == job ? _self.job : job // ignore: cast_nullable_to_non_nullable
as OfferRequestJob,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as OfferRequestPrice,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OfferRequestStatus,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,chatId: freezed == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of OfferRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OfferRequestJobCopyWith<$Res> get job {
  
  return $OfferRequestJobCopyWith<$Res>(_self.job, (value) {
    return _then(_self.copyWith(job: value));
  });
}/// Create a copy of OfferRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OfferRequestPriceCopyWith<$Res> get price {
  
  return $OfferRequestPriceCopyWith<$Res>(_self.price, (value) {
    return _then(_self.copyWith(price: value));
  });
}
}


/// Adds pattern-matching-related methods to [OfferRequest].
extension OfferRequestPatterns on OfferRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OfferRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OfferRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OfferRequest value)  $default,){
final _that = this;
switch (_that) {
case _OfferRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OfferRequest value)?  $default,){
final _that = this;
switch (_that) {
case _OfferRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String customerId,  String offerId,  String proId,  OfferRequestJob job,  OfferRequestPrice price,  OfferRequestStatus status, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? expiresAt,  String? chatId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OfferRequest() when $default != null:
return $default(_that.id,_that.customerId,_that.offerId,_that.proId,_that.job,_that.price,_that.status,_that.createdAt,_that.expiresAt,_that.chatId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String customerId,  String offerId,  String proId,  OfferRequestJob job,  OfferRequestPrice price,  OfferRequestStatus status, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? expiresAt,  String? chatId)  $default,) {final _that = this;
switch (_that) {
case _OfferRequest():
return $default(_that.id,_that.customerId,_that.offerId,_that.proId,_that.job,_that.price,_that.status,_that.createdAt,_that.expiresAt,_that.chatId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String customerId,  String offerId,  String proId,  OfferRequestJob job,  OfferRequestPrice price,  OfferRequestStatus status, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? expiresAt,  String? chatId)?  $default,) {final _that = this;
switch (_that) {
case _OfferRequest() when $default != null:
return $default(_that.id,_that.customerId,_that.offerId,_that.proId,_that.job,_that.price,_that.status,_that.createdAt,_that.expiresAt,_that.chatId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OfferRequest implements OfferRequest {
  const _OfferRequest({this.id, required this.customerId, required this.offerId, required this.proId, required this.job, required this.price, this.status = OfferRequestStatus.pending, @TimestampConverter() this.createdAt, @TimestampConverter() this.expiresAt, this.chatId});
  factory _OfferRequest.fromJson(Map<String, dynamic> json) => _$OfferRequestFromJson(json);

@override final  String? id;
@override final  String customerId;
@override final  String offerId;
@override final  String proId;
@override final  OfferRequestJob job;
@override final  OfferRequestPrice price;
@override@JsonKey() final  OfferRequestStatus status;
@override@TimestampConverter() final  DateTime? createdAt;
@override@TimestampConverter() final  DateTime? expiresAt;
@override final  String? chatId;

/// Create a copy of OfferRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OfferRequestCopyWith<_OfferRequest> get copyWith => __$OfferRequestCopyWithImpl<_OfferRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OfferRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OfferRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.customerId, customerId) || other.customerId == customerId)&&(identical(other.offerId, offerId) || other.offerId == offerId)&&(identical(other.proId, proId) || other.proId == proId)&&(identical(other.job, job) || other.job == job)&&(identical(other.price, price) || other.price == price)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.chatId, chatId) || other.chatId == chatId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,customerId,offerId,proId,job,price,status,createdAt,expiresAt,chatId);

@override
String toString() {
  return 'OfferRequest(id: $id, customerId: $customerId, offerId: $offerId, proId: $proId, job: $job, price: $price, status: $status, createdAt: $createdAt, expiresAt: $expiresAt, chatId: $chatId)';
}


}

/// @nodoc
abstract mixin class _$OfferRequestCopyWith<$Res> implements $OfferRequestCopyWith<$Res> {
  factory _$OfferRequestCopyWith(_OfferRequest value, $Res Function(_OfferRequest) _then) = __$OfferRequestCopyWithImpl;
@override @useResult
$Res call({
 String? id, String customerId, String offerId, String proId, OfferRequestJob job, OfferRequestPrice price, OfferRequestStatus status,@TimestampConverter() DateTime? createdAt,@TimestampConverter() DateTime? expiresAt, String? chatId
});


@override $OfferRequestJobCopyWith<$Res> get job;@override $OfferRequestPriceCopyWith<$Res> get price;

}
/// @nodoc
class __$OfferRequestCopyWithImpl<$Res>
    implements _$OfferRequestCopyWith<$Res> {
  __$OfferRequestCopyWithImpl(this._self, this._then);

  final _OfferRequest _self;
  final $Res Function(_OfferRequest) _then;

/// Create a copy of OfferRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? customerId = null,Object? offerId = null,Object? proId = null,Object? job = null,Object? price = null,Object? status = null,Object? createdAt = freezed,Object? expiresAt = freezed,Object? chatId = freezed,}) {
  return _then(_OfferRequest(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,customerId: null == customerId ? _self.customerId : customerId // ignore: cast_nullable_to_non_nullable
as String,offerId: null == offerId ? _self.offerId : offerId // ignore: cast_nullable_to_non_nullable
as String,proId: null == proId ? _self.proId : proId // ignore: cast_nullable_to_non_nullable
as String,job: null == job ? _self.job : job // ignore: cast_nullable_to_non_nullable
as OfferRequestJob,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as OfferRequestPrice,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OfferRequestStatus,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,chatId: freezed == chatId ? _self.chatId : chatId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of OfferRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OfferRequestJobCopyWith<$Res> get job {
  
  return $OfferRequestJobCopyWith<$Res>(_self.job, (value) {
    return _then(_self.copyWith(job: value));
  });
}/// Create a copy of OfferRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OfferRequestPriceCopyWith<$Res> get price {
  
  return $OfferRequestPriceCopyWith<$Res>(_self.price, (value) {
    return _then(_self.copyWith(price: value));
  });
}
}


/// @nodoc
mixin _$OfferRequestJob {

 String get address; OfferLocation? get geo;@TimestampConverter() DateTime? get start; double get durationH; Map<String, bool> get extras; String get recurring;
/// Create a copy of OfferRequestJob
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OfferRequestJobCopyWith<OfferRequestJob> get copyWith => _$OfferRequestJobCopyWithImpl<OfferRequestJob>(this as OfferRequestJob, _$identity);

  /// Serializes this OfferRequestJob to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OfferRequestJob&&(identical(other.address, address) || other.address == address)&&(identical(other.geo, geo) || other.geo == geo)&&(identical(other.start, start) || other.start == start)&&(identical(other.durationH, durationH) || other.durationH == durationH)&&const DeepCollectionEquality().equals(other.extras, extras)&&(identical(other.recurring, recurring) || other.recurring == recurring));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,address,geo,start,durationH,const DeepCollectionEquality().hash(extras),recurring);

@override
String toString() {
  return 'OfferRequestJob(address: $address, geo: $geo, start: $start, durationH: $durationH, extras: $extras, recurring: $recurring)';
}


}

/// @nodoc
abstract mixin class $OfferRequestJobCopyWith<$Res>  {
  factory $OfferRequestJobCopyWith(OfferRequestJob value, $Res Function(OfferRequestJob) _then) = _$OfferRequestJobCopyWithImpl;
@useResult
$Res call({
 String address, OfferLocation? geo,@TimestampConverter() DateTime? start, double durationH, Map<String, bool> extras, String recurring
});


$OfferLocationCopyWith<$Res>? get geo;

}
/// @nodoc
class _$OfferRequestJobCopyWithImpl<$Res>
    implements $OfferRequestJobCopyWith<$Res> {
  _$OfferRequestJobCopyWithImpl(this._self, this._then);

  final OfferRequestJob _self;
  final $Res Function(OfferRequestJob) _then;

/// Create a copy of OfferRequestJob
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? address = null,Object? geo = freezed,Object? start = freezed,Object? durationH = null,Object? extras = null,Object? recurring = null,}) {
  return _then(_self.copyWith(
address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,geo: freezed == geo ? _self.geo : geo // ignore: cast_nullable_to_non_nullable
as OfferLocation?,start: freezed == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime?,durationH: null == durationH ? _self.durationH : durationH // ignore: cast_nullable_to_non_nullable
as double,extras: null == extras ? _self.extras : extras // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,recurring: null == recurring ? _self.recurring : recurring // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of OfferRequestJob
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OfferLocationCopyWith<$Res>? get geo {
    if (_self.geo == null) {
    return null;
  }

  return $OfferLocationCopyWith<$Res>(_self.geo!, (value) {
    return _then(_self.copyWith(geo: value));
  });
}
}


/// Adds pattern-matching-related methods to [OfferRequestJob].
extension OfferRequestJobPatterns on OfferRequestJob {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OfferRequestJob value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OfferRequestJob() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OfferRequestJob value)  $default,){
final _that = this;
switch (_that) {
case _OfferRequestJob():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OfferRequestJob value)?  $default,){
final _that = this;
switch (_that) {
case _OfferRequestJob() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String address,  OfferLocation? geo, @TimestampConverter()  DateTime? start,  double durationH,  Map<String, bool> extras,  String recurring)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OfferRequestJob() when $default != null:
return $default(_that.address,_that.geo,_that.start,_that.durationH,_that.extras,_that.recurring);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String address,  OfferLocation? geo, @TimestampConverter()  DateTime? start,  double durationH,  Map<String, bool> extras,  String recurring)  $default,) {final _that = this;
switch (_that) {
case _OfferRequestJob():
return $default(_that.address,_that.geo,_that.start,_that.durationH,_that.extras,_that.recurring);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String address,  OfferLocation? geo, @TimestampConverter()  DateTime? start,  double durationH,  Map<String, bool> extras,  String recurring)?  $default,) {final _that = this;
switch (_that) {
case _OfferRequestJob() when $default != null:
return $default(_that.address,_that.geo,_that.start,_that.durationH,_that.extras,_that.recurring);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OfferRequestJob implements OfferRequestJob {
  const _OfferRequestJob({required this.address, this.geo, @TimestampConverter() this.start, this.durationH = 0, final  Map<String, bool> extras = const <String, bool>{}, this.recurring = 'once'}): _extras = extras;
  factory _OfferRequestJob.fromJson(Map<String, dynamic> json) => _$OfferRequestJobFromJson(json);

@override final  String address;
@override final  OfferLocation? geo;
@override@TimestampConverter() final  DateTime? start;
@override@JsonKey() final  double durationH;
 final  Map<String, bool> _extras;
@override@JsonKey() Map<String, bool> get extras {
  if (_extras is EqualUnmodifiableMapView) return _extras;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_extras);
}

@override@JsonKey() final  String recurring;

/// Create a copy of OfferRequestJob
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OfferRequestJobCopyWith<_OfferRequestJob> get copyWith => __$OfferRequestJobCopyWithImpl<_OfferRequestJob>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OfferRequestJobToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OfferRequestJob&&(identical(other.address, address) || other.address == address)&&(identical(other.geo, geo) || other.geo == geo)&&(identical(other.start, start) || other.start == start)&&(identical(other.durationH, durationH) || other.durationH == durationH)&&const DeepCollectionEquality().equals(other._extras, _extras)&&(identical(other.recurring, recurring) || other.recurring == recurring));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,address,geo,start,durationH,const DeepCollectionEquality().hash(_extras),recurring);

@override
String toString() {
  return 'OfferRequestJob(address: $address, geo: $geo, start: $start, durationH: $durationH, extras: $extras, recurring: $recurring)';
}


}

/// @nodoc
abstract mixin class _$OfferRequestJobCopyWith<$Res> implements $OfferRequestJobCopyWith<$Res> {
  factory _$OfferRequestJobCopyWith(_OfferRequestJob value, $Res Function(_OfferRequestJob) _then) = __$OfferRequestJobCopyWithImpl;
@override @useResult
$Res call({
 String address, OfferLocation? geo,@TimestampConverter() DateTime? start, double durationH, Map<String, bool> extras, String recurring
});


@override $OfferLocationCopyWith<$Res>? get geo;

}
/// @nodoc
class __$OfferRequestJobCopyWithImpl<$Res>
    implements _$OfferRequestJobCopyWith<$Res> {
  __$OfferRequestJobCopyWithImpl(this._self, this._then);

  final _OfferRequestJob _self;
  final $Res Function(_OfferRequestJob) _then;

/// Create a copy of OfferRequestJob
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? address = null,Object? geo = freezed,Object? start = freezed,Object? durationH = null,Object? extras = null,Object? recurring = null,}) {
  return _then(_OfferRequestJob(
address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,geo: freezed == geo ? _self.geo : geo // ignore: cast_nullable_to_non_nullable
as OfferLocation?,start: freezed == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime?,durationH: null == durationH ? _self.durationH : durationH // ignore: cast_nullable_to_non_nullable
as double,extras: null == extras ? _self._extras : extras // ignore: cast_nullable_to_non_nullable
as Map<String, bool>,recurring: null == recurring ? _self.recurring : recurring // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of OfferRequestJob
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OfferLocationCopyWith<$Res>? get geo {
    if (_self.geo == null) {
    return null;
  }

  return $OfferLocationCopyWith<$Res>(_self.geo!, (value) {
    return _then(_self.copyWith(geo: value));
  });
}
}


/// @nodoc
mixin _$OfferRequestPrice {

 double get hourly; double get estimatedTotal;
/// Create a copy of OfferRequestPrice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OfferRequestPriceCopyWith<OfferRequestPrice> get copyWith => _$OfferRequestPriceCopyWithImpl<OfferRequestPrice>(this as OfferRequestPrice, _$identity);

  /// Serializes this OfferRequestPrice to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OfferRequestPrice&&(identical(other.hourly, hourly) || other.hourly == hourly)&&(identical(other.estimatedTotal, estimatedTotal) || other.estimatedTotal == estimatedTotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hourly,estimatedTotal);

@override
String toString() {
  return 'OfferRequestPrice(hourly: $hourly, estimatedTotal: $estimatedTotal)';
}


}

/// @nodoc
abstract mixin class $OfferRequestPriceCopyWith<$Res>  {
  factory $OfferRequestPriceCopyWith(OfferRequestPrice value, $Res Function(OfferRequestPrice) _then) = _$OfferRequestPriceCopyWithImpl;
@useResult
$Res call({
 double hourly, double estimatedTotal
});




}
/// @nodoc
class _$OfferRequestPriceCopyWithImpl<$Res>
    implements $OfferRequestPriceCopyWith<$Res> {
  _$OfferRequestPriceCopyWithImpl(this._self, this._then);

  final OfferRequestPrice _self;
  final $Res Function(OfferRequestPrice) _then;

/// Create a copy of OfferRequestPrice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hourly = null,Object? estimatedTotal = null,}) {
  return _then(_self.copyWith(
hourly: null == hourly ? _self.hourly : hourly // ignore: cast_nullable_to_non_nullable
as double,estimatedTotal: null == estimatedTotal ? _self.estimatedTotal : estimatedTotal // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [OfferRequestPrice].
extension OfferRequestPricePatterns on OfferRequestPrice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OfferRequestPrice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OfferRequestPrice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OfferRequestPrice value)  $default,){
final _that = this;
switch (_that) {
case _OfferRequestPrice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OfferRequestPrice value)?  $default,){
final _that = this;
switch (_that) {
case _OfferRequestPrice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double hourly,  double estimatedTotal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OfferRequestPrice() when $default != null:
return $default(_that.hourly,_that.estimatedTotal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double hourly,  double estimatedTotal)  $default,) {final _that = this;
switch (_that) {
case _OfferRequestPrice():
return $default(_that.hourly,_that.estimatedTotal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double hourly,  double estimatedTotal)?  $default,) {final _that = this;
switch (_that) {
case _OfferRequestPrice() when $default != null:
return $default(_that.hourly,_that.estimatedTotal);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OfferRequestPrice implements OfferRequestPrice {
  const _OfferRequestPrice({this.hourly = 0.0, this.estimatedTotal = 0.0});
  factory _OfferRequestPrice.fromJson(Map<String, dynamic> json) => _$OfferRequestPriceFromJson(json);

@override@JsonKey() final  double hourly;
@override@JsonKey() final  double estimatedTotal;

/// Create a copy of OfferRequestPrice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OfferRequestPriceCopyWith<_OfferRequestPrice> get copyWith => __$OfferRequestPriceCopyWithImpl<_OfferRequestPrice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OfferRequestPriceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OfferRequestPrice&&(identical(other.hourly, hourly) || other.hourly == hourly)&&(identical(other.estimatedTotal, estimatedTotal) || other.estimatedTotal == estimatedTotal));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hourly,estimatedTotal);

@override
String toString() {
  return 'OfferRequestPrice(hourly: $hourly, estimatedTotal: $estimatedTotal)';
}


}

/// @nodoc
abstract mixin class _$OfferRequestPriceCopyWith<$Res> implements $OfferRequestPriceCopyWith<$Res> {
  factory _$OfferRequestPriceCopyWith(_OfferRequestPrice value, $Res Function(_OfferRequestPrice) _then) = __$OfferRequestPriceCopyWithImpl;
@override @useResult
$Res call({
 double hourly, double estimatedTotal
});




}
/// @nodoc
class __$OfferRequestPriceCopyWithImpl<$Res>
    implements _$OfferRequestPriceCopyWith<$Res> {
  __$OfferRequestPriceCopyWithImpl(this._self, this._then);

  final _OfferRequestPrice _self;
  final $Res Function(_OfferRequestPrice) _then;

/// Create a copy of OfferRequestPrice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hourly = null,Object? estimatedTotal = null,}) {
  return _then(_OfferRequestPrice(
hourly: null == hourly ? _self.hourly : hourly // ignore: cast_nullable_to_non_nullable
as double,estimatedTotal: null == estimatedTotal ? _self.estimatedTotal : estimatedTotal // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on

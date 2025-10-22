// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lead.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Lead {

 String? get id; String get jobId; String get customerUid; String get proUid; String get message; LeadStatus get status;@TimestampConverter() DateTime? get acceptedAt;@TimestampConverter() DateTime? get createdAt;@TimestampConverter() DateTime? get updatedAt;
/// Create a copy of Lead
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeadCopyWith<Lead> get copyWith => _$LeadCopyWithImpl<Lead>(this as Lead, _$identity);

  /// Serializes this Lead to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Lead&&(identical(other.id, id) || other.id == id)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.customerUid, customerUid) || other.customerUid == customerUid)&&(identical(other.proUid, proUid) || other.proUid == proUid)&&(identical(other.message, message) || other.message == message)&&(identical(other.status, status) || other.status == status)&&(identical(other.acceptedAt, acceptedAt) || other.acceptedAt == acceptedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,jobId,customerUid,proUid,message,status,acceptedAt,createdAt,updatedAt);

@override
String toString() {
  return 'Lead(id: $id, jobId: $jobId, customerUid: $customerUid, proUid: $proUid, message: $message, status: $status, acceptedAt: $acceptedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $LeadCopyWith<$Res>  {
  factory $LeadCopyWith(Lead value, $Res Function(Lead) _then) = _$LeadCopyWithImpl;
@useResult
$Res call({
 String? id, String jobId, String customerUid, String proUid, String message, LeadStatus status,@TimestampConverter() DateTime? acceptedAt,@TimestampConverter() DateTime? createdAt,@TimestampConverter() DateTime? updatedAt
});




}
/// @nodoc
class _$LeadCopyWithImpl<$Res>
    implements $LeadCopyWith<$Res> {
  _$LeadCopyWithImpl(this._self, this._then);

  final Lead _self;
  final $Res Function(Lead) _then;

/// Create a copy of Lead
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? jobId = null,Object? customerUid = null,Object? proUid = null,Object? message = null,Object? status = null,Object? acceptedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,customerUid: null == customerUid ? _self.customerUid : customerUid // ignore: cast_nullable_to_non_nullable
as String,proUid: null == proUid ? _self.proUid : proUid // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LeadStatus,acceptedAt: freezed == acceptedAt ? _self.acceptedAt : acceptedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Lead].
extension LeadPatterns on Lead {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Lead value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Lead() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Lead value)  $default,){
final _that = this;
switch (_that) {
case _Lead():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Lead value)?  $default,){
final _that = this;
switch (_that) {
case _Lead() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String jobId,  String customerUid,  String proUid,  String message,  LeadStatus status, @TimestampConverter()  DateTime? acceptedAt, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Lead() when $default != null:
return $default(_that.id,_that.jobId,_that.customerUid,_that.proUid,_that.message,_that.status,_that.acceptedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String jobId,  String customerUid,  String proUid,  String message,  LeadStatus status, @TimestampConverter()  DateTime? acceptedAt, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Lead():
return $default(_that.id,_that.jobId,_that.customerUid,_that.proUid,_that.message,_that.status,_that.acceptedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String jobId,  String customerUid,  String proUid,  String message,  LeadStatus status, @TimestampConverter()  DateTime? acceptedAt, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Lead() when $default != null:
return $default(_that.id,_that.jobId,_that.customerUid,_that.proUid,_that.message,_that.status,_that.acceptedAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Lead implements Lead {
  const _Lead({this.id, required this.jobId, required this.customerUid, required this.proUid, this.message = '', this.status = LeadStatus.pending, @TimestampConverter() this.acceptedAt, @TimestampConverter() this.createdAt, @TimestampConverter() this.updatedAt});
  factory _Lead.fromJson(Map<String, dynamic> json) => _$LeadFromJson(json);

@override final  String? id;
@override final  String jobId;
@override final  String customerUid;
@override final  String proUid;
@override@JsonKey() final  String message;
@override@JsonKey() final  LeadStatus status;
@override@TimestampConverter() final  DateTime? acceptedAt;
@override@TimestampConverter() final  DateTime? createdAt;
@override@TimestampConverter() final  DateTime? updatedAt;

/// Create a copy of Lead
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeadCopyWith<_Lead> get copyWith => __$LeadCopyWithImpl<_Lead>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeadToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Lead&&(identical(other.id, id) || other.id == id)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.customerUid, customerUid) || other.customerUid == customerUid)&&(identical(other.proUid, proUid) || other.proUid == proUid)&&(identical(other.message, message) || other.message == message)&&(identical(other.status, status) || other.status == status)&&(identical(other.acceptedAt, acceptedAt) || other.acceptedAt == acceptedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,jobId,customerUid,proUid,message,status,acceptedAt,createdAt,updatedAt);

@override
String toString() {
  return 'Lead(id: $id, jobId: $jobId, customerUid: $customerUid, proUid: $proUid, message: $message, status: $status, acceptedAt: $acceptedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$LeadCopyWith<$Res> implements $LeadCopyWith<$Res> {
  factory _$LeadCopyWith(_Lead value, $Res Function(_Lead) _then) = __$LeadCopyWithImpl;
@override @useResult
$Res call({
 String? id, String jobId, String customerUid, String proUid, String message, LeadStatus status,@TimestampConverter() DateTime? acceptedAt,@TimestampConverter() DateTime? createdAt,@TimestampConverter() DateTime? updatedAt
});




}
/// @nodoc
class __$LeadCopyWithImpl<$Res>
    implements _$LeadCopyWith<$Res> {
  __$LeadCopyWithImpl(this._self, this._then);

  final _Lead _self;
  final $Res Function(_Lead) _then;

/// Create a copy of Lead
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? jobId = null,Object? customerUid = null,Object? proUid = null,Object? message = null,Object? status = null,Object? acceptedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Lead(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,customerUid: null == customerUid ? _self.customerUid : customerUid // ignore: cast_nullable_to_non_nullable
as String,proUid: null == proUid ? _self.proUid : proUid // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LeadStatus,acceptedAt: freezed == acceptedAt ? _self.acceptedAt : acceptedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

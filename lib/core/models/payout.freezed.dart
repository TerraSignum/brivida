// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payout.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PayoutFilter {

 DateTime? get from; DateTime? get to; String? get status;
/// Create a copy of PayoutFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PayoutFilterCopyWith<PayoutFilter> get copyWith => _$PayoutFilterCopyWithImpl<PayoutFilter>(this as PayoutFilter, _$identity);

  /// Serializes this PayoutFilter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PayoutFilter&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,from,to,status);

@override
String toString() {
  return 'PayoutFilter(from: $from, to: $to, status: $status)';
}


}

/// @nodoc
abstract mixin class $PayoutFilterCopyWith<$Res>  {
  factory $PayoutFilterCopyWith(PayoutFilter value, $Res Function(PayoutFilter) _then) = _$PayoutFilterCopyWithImpl;
@useResult
$Res call({
 DateTime? from, DateTime? to, String? status
});




}
/// @nodoc
class _$PayoutFilterCopyWithImpl<$Res>
    implements $PayoutFilterCopyWith<$Res> {
  _$PayoutFilterCopyWithImpl(this._self, this._then);

  final PayoutFilter _self;
  final $Res Function(PayoutFilter) _then;

/// Create a copy of PayoutFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? from = freezed,Object? to = freezed,Object? status = freezed,}) {
  return _then(_self.copyWith(
from: freezed == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime?,to: freezed == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PayoutFilter].
extension PayoutFilterPatterns on PayoutFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PayoutFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PayoutFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PayoutFilter value)  $default,){
final _that = this;
switch (_that) {
case _PayoutFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PayoutFilter value)?  $default,){
final _that = this;
switch (_that) {
case _PayoutFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime? from,  DateTime? to,  String? status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PayoutFilter() when $default != null:
return $default(_that.from,_that.to,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime? from,  DateTime? to,  String? status)  $default,) {final _that = this;
switch (_that) {
case _PayoutFilter():
return $default(_that.from,_that.to,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime? from,  DateTime? to,  String? status)?  $default,) {final _that = this;
switch (_that) {
case _PayoutFilter() when $default != null:
return $default(_that.from,_that.to,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PayoutFilter implements PayoutFilter {
  const _PayoutFilter({this.from, this.to, this.status});
  factory _PayoutFilter.fromJson(Map<String, dynamic> json) => _$PayoutFilterFromJson(json);

@override final  DateTime? from;
@override final  DateTime? to;
@override final  String? status;

/// Create a copy of PayoutFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PayoutFilterCopyWith<_PayoutFilter> get copyWith => __$PayoutFilterCopyWithImpl<_PayoutFilter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PayoutFilterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PayoutFilter&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,from,to,status);

@override
String toString() {
  return 'PayoutFilter(from: $from, to: $to, status: $status)';
}


}

/// @nodoc
abstract mixin class _$PayoutFilterCopyWith<$Res> implements $PayoutFilterCopyWith<$Res> {
  factory _$PayoutFilterCopyWith(_PayoutFilter value, $Res Function(_PayoutFilter) _then) = __$PayoutFilterCopyWithImpl;
@override @useResult
$Res call({
 DateTime? from, DateTime? to, String? status
});




}
/// @nodoc
class __$PayoutFilterCopyWithImpl<$Res>
    implements _$PayoutFilterCopyWith<$Res> {
  __$PayoutFilterCopyWithImpl(this._self, this._then);

  final _PayoutFilter _self;
  final $Res Function(_PayoutFilter) _then;

/// Create a copy of PayoutFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? from = freezed,Object? to = freezed,Object? status = freezed,}) {
  return _then(_PayoutFilter(
from: freezed == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime?,to: freezed == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ExportRequest {

 DateTime? get from; DateTime? get to; String get kind;
/// Create a copy of ExportRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExportRequestCopyWith<ExportRequest> get copyWith => _$ExportRequestCopyWithImpl<ExportRequest>(this as ExportRequest, _$identity);

  /// Serializes this ExportRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportRequest&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.kind, kind) || other.kind == kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,from,to,kind);

@override
String toString() {
  return 'ExportRequest(from: $from, to: $to, kind: $kind)';
}


}

/// @nodoc
abstract mixin class $ExportRequestCopyWith<$Res>  {
  factory $ExportRequestCopyWith(ExportRequest value, $Res Function(ExportRequest) _then) = _$ExportRequestCopyWithImpl;
@useResult
$Res call({
 DateTime? from, DateTime? to, String kind
});




}
/// @nodoc
class _$ExportRequestCopyWithImpl<$Res>
    implements $ExportRequestCopyWith<$Res> {
  _$ExportRequestCopyWithImpl(this._self, this._then);

  final ExportRequest _self;
  final $Res Function(ExportRequest) _then;

/// Create a copy of ExportRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? from = freezed,Object? to = freezed,Object? kind = null,}) {
  return _then(_self.copyWith(
from: freezed == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime?,to: freezed == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime?,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ExportRequest].
extension ExportRequestPatterns on ExportRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExportRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExportRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExportRequest value)  $default,){
final _that = this;
switch (_that) {
case _ExportRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExportRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ExportRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime? from,  DateTime? to,  String kind)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExportRequest() when $default != null:
return $default(_that.from,_that.to,_that.kind);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime? from,  DateTime? to,  String kind)  $default,) {final _that = this;
switch (_that) {
case _ExportRequest():
return $default(_that.from,_that.to,_that.kind);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime? from,  DateTime? to,  String kind)?  $default,) {final _that = this;
switch (_that) {
case _ExportRequest() when $default != null:
return $default(_that.from,_that.to,_that.kind);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExportRequest implements ExportRequest {
  const _ExportRequest({this.from, this.to, this.kind = 'transfers'});
  factory _ExportRequest.fromJson(Map<String, dynamic> json) => _$ExportRequestFromJson(json);

@override final  DateTime? from;
@override final  DateTime? to;
@override@JsonKey() final  String kind;

/// Create a copy of ExportRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExportRequestCopyWith<_ExportRequest> get copyWith => __$ExportRequestCopyWithImpl<_ExportRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExportRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExportRequest&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.kind, kind) || other.kind == kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,from,to,kind);

@override
String toString() {
  return 'ExportRequest(from: $from, to: $to, kind: $kind)';
}


}

/// @nodoc
abstract mixin class _$ExportRequestCopyWith<$Res> implements $ExportRequestCopyWith<$Res> {
  factory _$ExportRequestCopyWith(_ExportRequest value, $Res Function(_ExportRequest) _then) = __$ExportRequestCopyWithImpl;
@override @useResult
$Res call({
 DateTime? from, DateTime? to, String kind
});




}
/// @nodoc
class __$ExportRequestCopyWithImpl<$Res>
    implements _$ExportRequestCopyWith<$Res> {
  __$ExportRequestCopyWithImpl(this._self, this._then);

  final _ExportRequest _self;
  final $Res Function(_ExportRequest) _then;

/// Create a copy of ExportRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? from = freezed,Object? to = freezed,Object? kind = null,}) {
  return _then(_ExportRequest(
from: freezed == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime?,to: freezed == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime?,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ExportResult {

 String get downloadUrl; String get filename; DateTime get expiresAt;
/// Create a copy of ExportResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExportResultCopyWith<ExportResult> get copyWith => _$ExportResultCopyWithImpl<ExportResult>(this as ExportResult, _$identity);

  /// Serializes this ExportResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportResult&&(identical(other.downloadUrl, downloadUrl) || other.downloadUrl == downloadUrl)&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,downloadUrl,filename,expiresAt);

@override
String toString() {
  return 'ExportResult(downloadUrl: $downloadUrl, filename: $filename, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class $ExportResultCopyWith<$Res>  {
  factory $ExportResultCopyWith(ExportResult value, $Res Function(ExportResult) _then) = _$ExportResultCopyWithImpl;
@useResult
$Res call({
 String downloadUrl, String filename, DateTime expiresAt
});




}
/// @nodoc
class _$ExportResultCopyWithImpl<$Res>
    implements $ExportResultCopyWith<$Res> {
  _$ExportResultCopyWithImpl(this._self, this._then);

  final ExportResult _self;
  final $Res Function(ExportResult) _then;

/// Create a copy of ExportResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? downloadUrl = null,Object? filename = null,Object? expiresAt = null,}) {
  return _then(_self.copyWith(
downloadUrl: null == downloadUrl ? _self.downloadUrl : downloadUrl // ignore: cast_nullable_to_non_nullable
as String,filename: null == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ExportResult].
extension ExportResultPatterns on ExportResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExportResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExportResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExportResult value)  $default,){
final _that = this;
switch (_that) {
case _ExportResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExportResult value)?  $default,){
final _that = this;
switch (_that) {
case _ExportResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String downloadUrl,  String filename,  DateTime expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExportResult() when $default != null:
return $default(_that.downloadUrl,_that.filename,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String downloadUrl,  String filename,  DateTime expiresAt)  $default,) {final _that = this;
switch (_that) {
case _ExportResult():
return $default(_that.downloadUrl,_that.filename,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String downloadUrl,  String filename,  DateTime expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _ExportResult() when $default != null:
return $default(_that.downloadUrl,_that.filename,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExportResult implements ExportResult {
  const _ExportResult({required this.downloadUrl, required this.filename, required this.expiresAt});
  factory _ExportResult.fromJson(Map<String, dynamic> json) => _$ExportResultFromJson(json);

@override final  String downloadUrl;
@override final  String filename;
@override final  DateTime expiresAt;

/// Create a copy of ExportResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExportResultCopyWith<_ExportResult> get copyWith => __$ExportResultCopyWithImpl<_ExportResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExportResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExportResult&&(identical(other.downloadUrl, downloadUrl) || other.downloadUrl == downloadUrl)&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,downloadUrl,filename,expiresAt);

@override
String toString() {
  return 'ExportResult(downloadUrl: $downloadUrl, filename: $filename, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$ExportResultCopyWith<$Res> implements $ExportResultCopyWith<$Res> {
  factory _$ExportResultCopyWith(_ExportResult value, $Res Function(_ExportResult) _then) = __$ExportResultCopyWithImpl;
@override @useResult
$Res call({
 String downloadUrl, String filename, DateTime expiresAt
});




}
/// @nodoc
class __$ExportResultCopyWithImpl<$Res>
    implements _$ExportResultCopyWith<$Res> {
  __$ExportResultCopyWithImpl(this._self, this._then);

  final _ExportResult _self;
  final $Res Function(_ExportResult) _then;

/// Create a copy of ExportResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? downloadUrl = null,Object? filename = null,Object? expiresAt = null,}) {
  return _then(_ExportResult(
downloadUrl: null == downloadUrl ? _self.downloadUrl : downloadUrl // ignore: cast_nullable_to_non_nullable
as String,filename: null == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$TransferStats {

 int get totalCount; double get totalAmountNet; double get totalAmountGross; double get totalPlatformFees; int get pendingCount; int get completedCount; int get failedCount;
/// Create a copy of TransferStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransferStatsCopyWith<TransferStats> get copyWith => _$TransferStatsCopyWithImpl<TransferStats>(this as TransferStats, _$identity);

  /// Serializes this TransferStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransferStats&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.totalAmountNet, totalAmountNet) || other.totalAmountNet == totalAmountNet)&&(identical(other.totalAmountGross, totalAmountGross) || other.totalAmountGross == totalAmountGross)&&(identical(other.totalPlatformFees, totalPlatformFees) || other.totalPlatformFees == totalPlatformFees)&&(identical(other.pendingCount, pendingCount) || other.pendingCount == pendingCount)&&(identical(other.completedCount, completedCount) || other.completedCount == completedCount)&&(identical(other.failedCount, failedCount) || other.failedCount == failedCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalCount,totalAmountNet,totalAmountGross,totalPlatformFees,pendingCount,completedCount,failedCount);

@override
String toString() {
  return 'TransferStats(totalCount: $totalCount, totalAmountNet: $totalAmountNet, totalAmountGross: $totalAmountGross, totalPlatformFees: $totalPlatformFees, pendingCount: $pendingCount, completedCount: $completedCount, failedCount: $failedCount)';
}


}

/// @nodoc
abstract mixin class $TransferStatsCopyWith<$Res>  {
  factory $TransferStatsCopyWith(TransferStats value, $Res Function(TransferStats) _then) = _$TransferStatsCopyWithImpl;
@useResult
$Res call({
 int totalCount, double totalAmountNet, double totalAmountGross, double totalPlatformFees, int pendingCount, int completedCount, int failedCount
});




}
/// @nodoc
class _$TransferStatsCopyWithImpl<$Res>
    implements $TransferStatsCopyWith<$Res> {
  _$TransferStatsCopyWithImpl(this._self, this._then);

  final TransferStats _self;
  final $Res Function(TransferStats) _then;

/// Create a copy of TransferStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalCount = null,Object? totalAmountNet = null,Object? totalAmountGross = null,Object? totalPlatformFees = null,Object? pendingCount = null,Object? completedCount = null,Object? failedCount = null,}) {
  return _then(_self.copyWith(
totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,totalAmountNet: null == totalAmountNet ? _self.totalAmountNet : totalAmountNet // ignore: cast_nullable_to_non_nullable
as double,totalAmountGross: null == totalAmountGross ? _self.totalAmountGross : totalAmountGross // ignore: cast_nullable_to_non_nullable
as double,totalPlatformFees: null == totalPlatformFees ? _self.totalPlatformFees : totalPlatformFees // ignore: cast_nullable_to_non_nullable
as double,pendingCount: null == pendingCount ? _self.pendingCount : pendingCount // ignore: cast_nullable_to_non_nullable
as int,completedCount: null == completedCount ? _self.completedCount : completedCount // ignore: cast_nullable_to_non_nullable
as int,failedCount: null == failedCount ? _self.failedCount : failedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TransferStats].
extension TransferStatsPatterns on TransferStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransferStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransferStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransferStats value)  $default,){
final _that = this;
switch (_that) {
case _TransferStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransferStats value)?  $default,){
final _that = this;
switch (_that) {
case _TransferStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalCount,  double totalAmountNet,  double totalAmountGross,  double totalPlatformFees,  int pendingCount,  int completedCount,  int failedCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransferStats() when $default != null:
return $default(_that.totalCount,_that.totalAmountNet,_that.totalAmountGross,_that.totalPlatformFees,_that.pendingCount,_that.completedCount,_that.failedCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalCount,  double totalAmountNet,  double totalAmountGross,  double totalPlatformFees,  int pendingCount,  int completedCount,  int failedCount)  $default,) {final _that = this;
switch (_that) {
case _TransferStats():
return $default(_that.totalCount,_that.totalAmountNet,_that.totalAmountGross,_that.totalPlatformFees,_that.pendingCount,_that.completedCount,_that.failedCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalCount,  double totalAmountNet,  double totalAmountGross,  double totalPlatformFees,  int pendingCount,  int completedCount,  int failedCount)?  $default,) {final _that = this;
switch (_that) {
case _TransferStats() when $default != null:
return $default(_that.totalCount,_that.totalAmountNet,_that.totalAmountGross,_that.totalPlatformFees,_that.pendingCount,_that.completedCount,_that.failedCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransferStats implements TransferStats {
  const _TransferStats({this.totalCount = 0, this.totalAmountNet = 0.0, this.totalAmountGross = 0.0, this.totalPlatformFees = 0.0, this.pendingCount = 0, this.completedCount = 0, this.failedCount = 0});
  factory _TransferStats.fromJson(Map<String, dynamic> json) => _$TransferStatsFromJson(json);

@override@JsonKey() final  int totalCount;
@override@JsonKey() final  double totalAmountNet;
@override@JsonKey() final  double totalAmountGross;
@override@JsonKey() final  double totalPlatformFees;
@override@JsonKey() final  int pendingCount;
@override@JsonKey() final  int completedCount;
@override@JsonKey() final  int failedCount;

/// Create a copy of TransferStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransferStatsCopyWith<_TransferStats> get copyWith => __$TransferStatsCopyWithImpl<_TransferStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransferStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransferStats&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.totalAmountNet, totalAmountNet) || other.totalAmountNet == totalAmountNet)&&(identical(other.totalAmountGross, totalAmountGross) || other.totalAmountGross == totalAmountGross)&&(identical(other.totalPlatformFees, totalPlatformFees) || other.totalPlatformFees == totalPlatformFees)&&(identical(other.pendingCount, pendingCount) || other.pendingCount == pendingCount)&&(identical(other.completedCount, completedCount) || other.completedCount == completedCount)&&(identical(other.failedCount, failedCount) || other.failedCount == failedCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalCount,totalAmountNet,totalAmountGross,totalPlatformFees,pendingCount,completedCount,failedCount);

@override
String toString() {
  return 'TransferStats(totalCount: $totalCount, totalAmountNet: $totalAmountNet, totalAmountGross: $totalAmountGross, totalPlatformFees: $totalPlatformFees, pendingCount: $pendingCount, completedCount: $completedCount, failedCount: $failedCount)';
}


}

/// @nodoc
abstract mixin class _$TransferStatsCopyWith<$Res> implements $TransferStatsCopyWith<$Res> {
  factory _$TransferStatsCopyWith(_TransferStats value, $Res Function(_TransferStats) _then) = __$TransferStatsCopyWithImpl;
@override @useResult
$Res call({
 int totalCount, double totalAmountNet, double totalAmountGross, double totalPlatformFees, int pendingCount, int completedCount, int failedCount
});




}
/// @nodoc
class __$TransferStatsCopyWithImpl<$Res>
    implements _$TransferStatsCopyWith<$Res> {
  __$TransferStatsCopyWithImpl(this._self, this._then);

  final _TransferStats _self;
  final $Res Function(_TransferStats) _then;

/// Create a copy of TransferStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalCount = null,Object? totalAmountNet = null,Object? totalAmountGross = null,Object? totalPlatformFees = null,Object? pendingCount = null,Object? completedCount = null,Object? failedCount = null,}) {
  return _then(_TransferStats(
totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,totalAmountNet: null == totalAmountNet ? _self.totalAmountNet : totalAmountNet // ignore: cast_nullable_to_non_nullable
as double,totalAmountGross: null == totalAmountGross ? _self.totalAmountGross : totalAmountGross // ignore: cast_nullable_to_non_nullable
as double,totalPlatformFees: null == totalPlatformFees ? _self.totalPlatformFees : totalPlatformFees // ignore: cast_nullable_to_non_nullable
as double,pendingCount: null == pendingCount ? _self.pendingCount : pendingCount // ignore: cast_nullable_to_non_nullable
as int,completedCount: null == completedCount ? _self.completedCount : completedCount // ignore: cast_nullable_to_non_nullable
as int,failedCount: null == failedCount ? _self.failedCount : failedCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HealthScore {

 double get score;// 0-100
 double get noShowRate;// 0-1
 double get cancelRate;// 0-1
 double get avgResponseMins;// Minutes
 double get inAppRatio;// 0-1
 double get ratingAvg;// 0-5
 int get ratingCount; DateTime? get updatedAt;
/// Create a copy of HealthScore
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthScoreCopyWith<HealthScore> get copyWith => _$HealthScoreCopyWithImpl<HealthScore>(this as HealthScore, _$identity);

  /// Serializes this HealthScore to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthScore&&(identical(other.score, score) || other.score == score)&&(identical(other.noShowRate, noShowRate) || other.noShowRate == noShowRate)&&(identical(other.cancelRate, cancelRate) || other.cancelRate == cancelRate)&&(identical(other.avgResponseMins, avgResponseMins) || other.avgResponseMins == avgResponseMins)&&(identical(other.inAppRatio, inAppRatio) || other.inAppRatio == inAppRatio)&&(identical(other.ratingAvg, ratingAvg) || other.ratingAvg == ratingAvg)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,score,noShowRate,cancelRate,avgResponseMins,inAppRatio,ratingAvg,ratingCount,updatedAt);

@override
String toString() {
  return 'HealthScore(score: $score, noShowRate: $noShowRate, cancelRate: $cancelRate, avgResponseMins: $avgResponseMins, inAppRatio: $inAppRatio, ratingAvg: $ratingAvg, ratingCount: $ratingCount, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $HealthScoreCopyWith<$Res>  {
  factory $HealthScoreCopyWith(HealthScore value, $Res Function(HealthScore) _then) = _$HealthScoreCopyWithImpl;
@useResult
$Res call({
 double score, double noShowRate, double cancelRate, double avgResponseMins, double inAppRatio, double ratingAvg, int ratingCount, DateTime? updatedAt
});




}
/// @nodoc
class _$HealthScoreCopyWithImpl<$Res>
    implements $HealthScoreCopyWith<$Res> {
  _$HealthScoreCopyWithImpl(this._self, this._then);

  final HealthScore _self;
  final $Res Function(HealthScore) _then;

/// Create a copy of HealthScore
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? score = null,Object? noShowRate = null,Object? cancelRate = null,Object? avgResponseMins = null,Object? inAppRatio = null,Object? ratingAvg = null,Object? ratingCount = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,noShowRate: null == noShowRate ? _self.noShowRate : noShowRate // ignore: cast_nullable_to_non_nullable
as double,cancelRate: null == cancelRate ? _self.cancelRate : cancelRate // ignore: cast_nullable_to_non_nullable
as double,avgResponseMins: null == avgResponseMins ? _self.avgResponseMins : avgResponseMins // ignore: cast_nullable_to_non_nullable
as double,inAppRatio: null == inAppRatio ? _self.inAppRatio : inAppRatio // ignore: cast_nullable_to_non_nullable
as double,ratingAvg: null == ratingAvg ? _self.ratingAvg : ratingAvg // ignore: cast_nullable_to_non_nullable
as double,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [HealthScore].
extension HealthScorePatterns on HealthScore {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HealthScore value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HealthScore() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HealthScore value)  $default,){
final _that = this;
switch (_that) {
case _HealthScore():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HealthScore value)?  $default,){
final _that = this;
switch (_that) {
case _HealthScore() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double score,  double noShowRate,  double cancelRate,  double avgResponseMins,  double inAppRatio,  double ratingAvg,  int ratingCount,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HealthScore() when $default != null:
return $default(_that.score,_that.noShowRate,_that.cancelRate,_that.avgResponseMins,_that.inAppRatio,_that.ratingAvg,_that.ratingCount,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double score,  double noShowRate,  double cancelRate,  double avgResponseMins,  double inAppRatio,  double ratingAvg,  int ratingCount,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _HealthScore():
return $default(_that.score,_that.noShowRate,_that.cancelRate,_that.avgResponseMins,_that.inAppRatio,_that.ratingAvg,_that.ratingCount,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double score,  double noShowRate,  double cancelRate,  double avgResponseMins,  double inAppRatio,  double ratingAvg,  int ratingCount,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _HealthScore() when $default != null:
return $default(_that.score,_that.noShowRate,_that.cancelRate,_that.avgResponseMins,_that.inAppRatio,_that.ratingAvg,_that.ratingCount,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HealthScore extends HealthScore {
  const _HealthScore({this.score = 0.0, this.noShowRate = 0.0, this.cancelRate = 0.0, this.avgResponseMins = 0.0, this.inAppRatio = 0.0, this.ratingAvg = 0.0, this.ratingCount = 0, this.updatedAt}): super._();
  factory _HealthScore.fromJson(Map<String, dynamic> json) => _$HealthScoreFromJson(json);

@override@JsonKey() final  double score;
// 0-100
@override@JsonKey() final  double noShowRate;
// 0-1
@override@JsonKey() final  double cancelRate;
// 0-1
@override@JsonKey() final  double avgResponseMins;
// Minutes
@override@JsonKey() final  double inAppRatio;
// 0-1
@override@JsonKey() final  double ratingAvg;
// 0-5
@override@JsonKey() final  int ratingCount;
@override final  DateTime? updatedAt;

/// Create a copy of HealthScore
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HealthScoreCopyWith<_HealthScore> get copyWith => __$HealthScoreCopyWithImpl<_HealthScore>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HealthScoreToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HealthScore&&(identical(other.score, score) || other.score == score)&&(identical(other.noShowRate, noShowRate) || other.noShowRate == noShowRate)&&(identical(other.cancelRate, cancelRate) || other.cancelRate == cancelRate)&&(identical(other.avgResponseMins, avgResponseMins) || other.avgResponseMins == avgResponseMins)&&(identical(other.inAppRatio, inAppRatio) || other.inAppRatio == inAppRatio)&&(identical(other.ratingAvg, ratingAvg) || other.ratingAvg == ratingAvg)&&(identical(other.ratingCount, ratingCount) || other.ratingCount == ratingCount)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,score,noShowRate,cancelRate,avgResponseMins,inAppRatio,ratingAvg,ratingCount,updatedAt);

@override
String toString() {
  return 'HealthScore(score: $score, noShowRate: $noShowRate, cancelRate: $cancelRate, avgResponseMins: $avgResponseMins, inAppRatio: $inAppRatio, ratingAvg: $ratingAvg, ratingCount: $ratingCount, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$HealthScoreCopyWith<$Res> implements $HealthScoreCopyWith<$Res> {
  factory _$HealthScoreCopyWith(_HealthScore value, $Res Function(_HealthScore) _then) = __$HealthScoreCopyWithImpl;
@override @useResult
$Res call({
 double score, double noShowRate, double cancelRate, double avgResponseMins, double inAppRatio, double ratingAvg, int ratingCount, DateTime? updatedAt
});




}
/// @nodoc
class __$HealthScoreCopyWithImpl<$Res>
    implements _$HealthScoreCopyWith<$Res> {
  __$HealthScoreCopyWithImpl(this._self, this._then);

  final _HealthScore _self;
  final $Res Function(_HealthScore) _then;

/// Create a copy of HealthScore
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? score = null,Object? noShowRate = null,Object? cancelRate = null,Object? avgResponseMins = null,Object? inAppRatio = null,Object? ratingAvg = null,Object? ratingCount = null,Object? updatedAt = freezed,}) {
  return _then(_HealthScore(
score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,noShowRate: null == noShowRate ? _self.noShowRate : noShowRate // ignore: cast_nullable_to_non_nullable
as double,cancelRate: null == cancelRate ? _self.cancelRate : cancelRate // ignore: cast_nullable_to_non_nullable
as double,avgResponseMins: null == avgResponseMins ? _self.avgResponseMins : avgResponseMins // ignore: cast_nullable_to_non_nullable
as double,inAppRatio: null == inAppRatio ? _self.inAppRatio : inAppRatio // ignore: cast_nullable_to_non_nullable
as double,ratingAvg: null == ratingAvg ? _self.ratingAvg : ratingAvg // ignore: cast_nullable_to_non_nullable
as double,ratingCount: null == ratingCount ? _self.ratingCount : ratingCount // ignore: cast_nullable_to_non_nullable
as int,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$ProFlags {

 bool get softBanned; bool get hardBanned; String get notes; DateTime? get updatedAt;
/// Create a copy of ProFlags
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProFlagsCopyWith<ProFlags> get copyWith => _$ProFlagsCopyWithImpl<ProFlags>(this as ProFlags, _$identity);

  /// Serializes this ProFlags to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProFlags&&(identical(other.softBanned, softBanned) || other.softBanned == softBanned)&&(identical(other.hardBanned, hardBanned) || other.hardBanned == hardBanned)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,softBanned,hardBanned,notes,updatedAt);

@override
String toString() {
  return 'ProFlags(softBanned: $softBanned, hardBanned: $hardBanned, notes: $notes, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ProFlagsCopyWith<$Res>  {
  factory $ProFlagsCopyWith(ProFlags value, $Res Function(ProFlags) _then) = _$ProFlagsCopyWithImpl;
@useResult
$Res call({
 bool softBanned, bool hardBanned, String notes, DateTime? updatedAt
});




}
/// @nodoc
class _$ProFlagsCopyWithImpl<$Res>
    implements $ProFlagsCopyWith<$Res> {
  _$ProFlagsCopyWithImpl(this._self, this._then);

  final ProFlags _self;
  final $Res Function(ProFlags) _then;

/// Create a copy of ProFlags
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? softBanned = null,Object? hardBanned = null,Object? notes = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
softBanned: null == softBanned ? _self.softBanned : softBanned // ignore: cast_nullable_to_non_nullable
as bool,hardBanned: null == hardBanned ? _self.hardBanned : hardBanned // ignore: cast_nullable_to_non_nullable
as bool,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProFlags].
extension ProFlagsPatterns on ProFlags {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProFlags value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProFlags() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProFlags value)  $default,){
final _that = this;
switch (_that) {
case _ProFlags():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProFlags value)?  $default,){
final _that = this;
switch (_that) {
case _ProFlags() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool softBanned,  bool hardBanned,  String notes,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProFlags() when $default != null:
return $default(_that.softBanned,_that.hardBanned,_that.notes,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool softBanned,  bool hardBanned,  String notes,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ProFlags():
return $default(_that.softBanned,_that.hardBanned,_that.notes,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool softBanned,  bool hardBanned,  String notes,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ProFlags() when $default != null:
return $default(_that.softBanned,_that.hardBanned,_that.notes,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProFlags extends ProFlags {
  const _ProFlags({this.softBanned = false, this.hardBanned = false, this.notes = '', this.updatedAt}): super._();
  factory _ProFlags.fromJson(Map<String, dynamic> json) => _$ProFlagsFromJson(json);

@override@JsonKey() final  bool softBanned;
@override@JsonKey() final  bool hardBanned;
@override@JsonKey() final  String notes;
@override final  DateTime? updatedAt;

/// Create a copy of ProFlags
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProFlagsCopyWith<_ProFlags> get copyWith => __$ProFlagsCopyWithImpl<_ProFlags>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProFlagsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProFlags&&(identical(other.softBanned, softBanned) || other.softBanned == softBanned)&&(identical(other.hardBanned, hardBanned) || other.hardBanned == hardBanned)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,softBanned,hardBanned,notes,updatedAt);

@override
String toString() {
  return 'ProFlags(softBanned: $softBanned, hardBanned: $hardBanned, notes: $notes, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ProFlagsCopyWith<$Res> implements $ProFlagsCopyWith<$Res> {
  factory _$ProFlagsCopyWith(_ProFlags value, $Res Function(_ProFlags) _then) = __$ProFlagsCopyWithImpl;
@override @useResult
$Res call({
 bool softBanned, bool hardBanned, String notes, DateTime? updatedAt
});




}
/// @nodoc
class __$ProFlagsCopyWithImpl<$Res>
    implements _$ProFlagsCopyWith<$Res> {
  __$ProFlagsCopyWithImpl(this._self, this._then);

  final _ProFlags _self;
  final $Res Function(_ProFlags) _then;

/// Create a copy of ProFlags
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? softBanned = null,Object? hardBanned = null,Object? notes = null,Object? updatedAt = freezed,}) {
  return _then(_ProFlags(
softBanned: null == softBanned ? _self.softBanned : softBanned // ignore: cast_nullable_to_non_nullable
as bool,hardBanned: null == hardBanned ? _self.hardBanned : hardBanned // ignore: cast_nullable_to_non_nullable
as bool,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$AbuseEvent {

 String get id; AbuseEventType get type; String get userUid; String? get jobId; double get weight; DateTime? get createdAt; String? get description; String? get reportedBy;
/// Create a copy of AbuseEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AbuseEventCopyWith<AbuseEvent> get copyWith => _$AbuseEventCopyWithImpl<AbuseEvent>(this as AbuseEvent, _$identity);

  /// Serializes this AbuseEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AbuseEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.userUid, userUid) || other.userUid == userUid)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.description, description) || other.description == description)&&(identical(other.reportedBy, reportedBy) || other.reportedBy == reportedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,userUid,jobId,weight,createdAt,description,reportedBy);

@override
String toString() {
  return 'AbuseEvent(id: $id, type: $type, userUid: $userUid, jobId: $jobId, weight: $weight, createdAt: $createdAt, description: $description, reportedBy: $reportedBy)';
}


}

/// @nodoc
abstract mixin class $AbuseEventCopyWith<$Res>  {
  factory $AbuseEventCopyWith(AbuseEvent value, $Res Function(AbuseEvent) _then) = _$AbuseEventCopyWithImpl;
@useResult
$Res call({
 String id, AbuseEventType type, String userUid, String? jobId, double weight, DateTime? createdAt, String? description, String? reportedBy
});




}
/// @nodoc
class _$AbuseEventCopyWithImpl<$Res>
    implements $AbuseEventCopyWith<$Res> {
  _$AbuseEventCopyWithImpl(this._self, this._then);

  final AbuseEvent _self;
  final $Res Function(AbuseEvent) _then;

/// Create a copy of AbuseEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? userUid = null,Object? jobId = freezed,Object? weight = null,Object? createdAt = freezed,Object? description = freezed,Object? reportedBy = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AbuseEventType,userUid: null == userUid ? _self.userUid : userUid // ignore: cast_nullable_to_non_nullable
as String,jobId: freezed == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String?,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,reportedBy: freezed == reportedBy ? _self.reportedBy : reportedBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AbuseEvent].
extension AbuseEventPatterns on AbuseEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AbuseEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AbuseEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AbuseEvent value)  $default,){
final _that = this;
switch (_that) {
case _AbuseEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AbuseEvent value)?  $default,){
final _that = this;
switch (_that) {
case _AbuseEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  AbuseEventType type,  String userUid,  String? jobId,  double weight,  DateTime? createdAt,  String? description,  String? reportedBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AbuseEvent() when $default != null:
return $default(_that.id,_that.type,_that.userUid,_that.jobId,_that.weight,_that.createdAt,_that.description,_that.reportedBy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  AbuseEventType type,  String userUid,  String? jobId,  double weight,  DateTime? createdAt,  String? description,  String? reportedBy)  $default,) {final _that = this;
switch (_that) {
case _AbuseEvent():
return $default(_that.id,_that.type,_that.userUid,_that.jobId,_that.weight,_that.createdAt,_that.description,_that.reportedBy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  AbuseEventType type,  String userUid,  String? jobId,  double weight,  DateTime? createdAt,  String? description,  String? reportedBy)?  $default,) {final _that = this;
switch (_that) {
case _AbuseEvent() when $default != null:
return $default(_that.id,_that.type,_that.userUid,_that.jobId,_that.weight,_that.createdAt,_that.description,_that.reportedBy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AbuseEvent extends AbuseEvent {
  const _AbuseEvent({required this.id, required this.type, required this.userUid, this.jobId, this.weight = 1.0, this.createdAt, this.description, this.reportedBy}): super._();
  factory _AbuseEvent.fromJson(Map<String, dynamic> json) => _$AbuseEventFromJson(json);

@override final  String id;
@override final  AbuseEventType type;
@override final  String userUid;
@override final  String? jobId;
@override@JsonKey() final  double weight;
@override final  DateTime? createdAt;
@override final  String? description;
@override final  String? reportedBy;

/// Create a copy of AbuseEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AbuseEventCopyWith<_AbuseEvent> get copyWith => __$AbuseEventCopyWithImpl<_AbuseEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AbuseEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AbuseEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.userUid, userUid) || other.userUid == userUid)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.description, description) || other.description == description)&&(identical(other.reportedBy, reportedBy) || other.reportedBy == reportedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,userUid,jobId,weight,createdAt,description,reportedBy);

@override
String toString() {
  return 'AbuseEvent(id: $id, type: $type, userUid: $userUid, jobId: $jobId, weight: $weight, createdAt: $createdAt, description: $description, reportedBy: $reportedBy)';
}


}

/// @nodoc
abstract mixin class _$AbuseEventCopyWith<$Res> implements $AbuseEventCopyWith<$Res> {
  factory _$AbuseEventCopyWith(_AbuseEvent value, $Res Function(_AbuseEvent) _then) = __$AbuseEventCopyWithImpl;
@override @useResult
$Res call({
 String id, AbuseEventType type, String userUid, String? jobId, double weight, DateTime? createdAt, String? description, String? reportedBy
});




}
/// @nodoc
class __$AbuseEventCopyWithImpl<$Res>
    implements _$AbuseEventCopyWith<$Res> {
  __$AbuseEventCopyWithImpl(this._self, this._then);

  final _AbuseEvent _self;
  final $Res Function(_AbuseEvent) _then;

/// Create a copy of AbuseEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? userUid = null,Object? jobId = freezed,Object? weight = null,Object? createdAt = freezed,Object? description = freezed,Object? reportedBy = freezed,}) {
  return _then(_AbuseEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AbuseEventType,userUid: null == userUid ? _self.userUid : userUid // ignore: cast_nullable_to_non_nullable
as String,jobId: freezed == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String?,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,reportedBy: freezed == reportedBy ? _self.reportedBy : reportedBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AdminLog {

 String get id; String get actorUid;// Admin who performed action
 AdminAction get action; String get targetType;// user|job|payment|dispute
 String get targetId; Map<String, dynamic>? get before; Map<String, dynamic>? get after; String? get notes; DateTime? get createdAt;
/// Create a copy of AdminLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminLogCopyWith<AdminLog> get copyWith => _$AdminLogCopyWithImpl<AdminLog>(this as AdminLog, _$identity);

  /// Serializes this AdminLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminLog&&(identical(other.id, id) || other.id == id)&&(identical(other.actorUid, actorUid) || other.actorUid == actorUid)&&(identical(other.action, action) || other.action == action)&&(identical(other.targetType, targetType) || other.targetType == targetType)&&(identical(other.targetId, targetId) || other.targetId == targetId)&&const DeepCollectionEquality().equals(other.before, before)&&const DeepCollectionEquality().equals(other.after, after)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,actorUid,action,targetType,targetId,const DeepCollectionEquality().hash(before),const DeepCollectionEquality().hash(after),notes,createdAt);

@override
String toString() {
  return 'AdminLog(id: $id, actorUid: $actorUid, action: $action, targetType: $targetType, targetId: $targetId, before: $before, after: $after, notes: $notes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $AdminLogCopyWith<$Res>  {
  factory $AdminLogCopyWith(AdminLog value, $Res Function(AdminLog) _then) = _$AdminLogCopyWithImpl;
@useResult
$Res call({
 String id, String actorUid, AdminAction action, String targetType, String targetId, Map<String, dynamic>? before, Map<String, dynamic>? after, String? notes, DateTime? createdAt
});




}
/// @nodoc
class _$AdminLogCopyWithImpl<$Res>
    implements $AdminLogCopyWith<$Res> {
  _$AdminLogCopyWithImpl(this._self, this._then);

  final AdminLog _self;
  final $Res Function(AdminLog) _then;

/// Create a copy of AdminLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? actorUid = null,Object? action = null,Object? targetType = null,Object? targetId = null,Object? before = freezed,Object? after = freezed,Object? notes = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,actorUid: null == actorUid ? _self.actorUid : actorUid // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as AdminAction,targetType: null == targetType ? _self.targetType : targetType // ignore: cast_nullable_to_non_nullable
as String,targetId: null == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String,before: freezed == before ? _self.before : before // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,after: freezed == after ? _self.after : after // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminLog].
extension AdminLogPatterns on AdminLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminLog value)  $default,){
final _that = this;
switch (_that) {
case _AdminLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminLog value)?  $default,){
final _that = this;
switch (_that) {
case _AdminLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String actorUid,  AdminAction action,  String targetType,  String targetId,  Map<String, dynamic>? before,  Map<String, dynamic>? after,  String? notes,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminLog() when $default != null:
return $default(_that.id,_that.actorUid,_that.action,_that.targetType,_that.targetId,_that.before,_that.after,_that.notes,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String actorUid,  AdminAction action,  String targetType,  String targetId,  Map<String, dynamic>? before,  Map<String, dynamic>? after,  String? notes,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _AdminLog():
return $default(_that.id,_that.actorUid,_that.action,_that.targetType,_that.targetId,_that.before,_that.after,_that.notes,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String actorUid,  AdminAction action,  String targetType,  String targetId,  Map<String, dynamic>? before,  Map<String, dynamic>? after,  String? notes,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AdminLog() when $default != null:
return $default(_that.id,_that.actorUid,_that.action,_that.targetType,_that.targetId,_that.before,_that.after,_that.notes,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminLog extends AdminLog {
  const _AdminLog({required this.id, required this.actorUid, required this.action, required this.targetType, required this.targetId, final  Map<String, dynamic>? before, final  Map<String, dynamic>? after, this.notes, this.createdAt}): _before = before,_after = after,super._();
  factory _AdminLog.fromJson(Map<String, dynamic> json) => _$AdminLogFromJson(json);

@override final  String id;
@override final  String actorUid;
// Admin who performed action
@override final  AdminAction action;
@override final  String targetType;
// user|job|payment|dispute
@override final  String targetId;
 final  Map<String, dynamic>? _before;
@override Map<String, dynamic>? get before {
  final value = _before;
  if (value == null) return null;
  if (_before is EqualUnmodifiableMapView) return _before;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _after;
@override Map<String, dynamic>? get after {
  final value = _after;
  if (value == null) return null;
  if (_after is EqualUnmodifiableMapView) return _after;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  String? notes;
@override final  DateTime? createdAt;

/// Create a copy of AdminLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminLogCopyWith<_AdminLog> get copyWith => __$AdminLogCopyWithImpl<_AdminLog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminLogToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminLog&&(identical(other.id, id) || other.id == id)&&(identical(other.actorUid, actorUid) || other.actorUid == actorUid)&&(identical(other.action, action) || other.action == action)&&(identical(other.targetType, targetType) || other.targetType == targetType)&&(identical(other.targetId, targetId) || other.targetId == targetId)&&const DeepCollectionEquality().equals(other._before, _before)&&const DeepCollectionEquality().equals(other._after, _after)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,actorUid,action,targetType,targetId,const DeepCollectionEquality().hash(_before),const DeepCollectionEquality().hash(_after),notes,createdAt);

@override
String toString() {
  return 'AdminLog(id: $id, actorUid: $actorUid, action: $action, targetType: $targetType, targetId: $targetId, before: $before, after: $after, notes: $notes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AdminLogCopyWith<$Res> implements $AdminLogCopyWith<$Res> {
  factory _$AdminLogCopyWith(_AdminLog value, $Res Function(_AdminLog) _then) = __$AdminLogCopyWithImpl;
@override @useResult
$Res call({
 String id, String actorUid, AdminAction action, String targetType, String targetId, Map<String, dynamic>? before, Map<String, dynamic>? after, String? notes, DateTime? createdAt
});




}
/// @nodoc
class __$AdminLogCopyWithImpl<$Res>
    implements _$AdminLogCopyWith<$Res> {
  __$AdminLogCopyWithImpl(this._self, this._then);

  final _AdminLog _self;
  final $Res Function(_AdminLog) _then;

/// Create a copy of AdminLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? actorUid = null,Object? action = null,Object? targetType = null,Object? targetId = null,Object? before = freezed,Object? after = freezed,Object? notes = freezed,Object? createdAt = freezed,}) {
  return _then(_AdminLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,actorUid: null == actorUid ? _self.actorUid : actorUid // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as AdminAction,targetType: null == targetType ? _self.targetType : targetType // ignore: cast_nullable_to_non_nullable
as String,targetId: null == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String,before: freezed == before ? _self._before : before // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,after: freezed == after ? _self._after : after // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$AdminKpiData {

 int get activePros; int get openDisputes; double get capturedPayments24h; double get refunds24h; int get newUsers24h; int get completedJobs24h; DateTime? get lastUpdated;
/// Create a copy of AdminKpiData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminKpiDataCopyWith<AdminKpiData> get copyWith => _$AdminKpiDataCopyWithImpl<AdminKpiData>(this as AdminKpiData, _$identity);

  /// Serializes this AdminKpiData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminKpiData&&(identical(other.activePros, activePros) || other.activePros == activePros)&&(identical(other.openDisputes, openDisputes) || other.openDisputes == openDisputes)&&(identical(other.capturedPayments24h, capturedPayments24h) || other.capturedPayments24h == capturedPayments24h)&&(identical(other.refunds24h, refunds24h) || other.refunds24h == refunds24h)&&(identical(other.newUsers24h, newUsers24h) || other.newUsers24h == newUsers24h)&&(identical(other.completedJobs24h, completedJobs24h) || other.completedJobs24h == completedJobs24h)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activePros,openDisputes,capturedPayments24h,refunds24h,newUsers24h,completedJobs24h,lastUpdated);

@override
String toString() {
  return 'AdminKpiData(activePros: $activePros, openDisputes: $openDisputes, capturedPayments24h: $capturedPayments24h, refunds24h: $refunds24h, newUsers24h: $newUsers24h, completedJobs24h: $completedJobs24h, lastUpdated: $lastUpdated)';
}


}

/// @nodoc
abstract mixin class $AdminKpiDataCopyWith<$Res>  {
  factory $AdminKpiDataCopyWith(AdminKpiData value, $Res Function(AdminKpiData) _then) = _$AdminKpiDataCopyWithImpl;
@useResult
$Res call({
 int activePros, int openDisputes, double capturedPayments24h, double refunds24h, int newUsers24h, int completedJobs24h, DateTime? lastUpdated
});




}
/// @nodoc
class _$AdminKpiDataCopyWithImpl<$Res>
    implements $AdminKpiDataCopyWith<$Res> {
  _$AdminKpiDataCopyWithImpl(this._self, this._then);

  final AdminKpiData _self;
  final $Res Function(AdminKpiData) _then;

/// Create a copy of AdminKpiData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activePros = null,Object? openDisputes = null,Object? capturedPayments24h = null,Object? refunds24h = null,Object? newUsers24h = null,Object? completedJobs24h = null,Object? lastUpdated = freezed,}) {
  return _then(_self.copyWith(
activePros: null == activePros ? _self.activePros : activePros // ignore: cast_nullable_to_non_nullable
as int,openDisputes: null == openDisputes ? _self.openDisputes : openDisputes // ignore: cast_nullable_to_non_nullable
as int,capturedPayments24h: null == capturedPayments24h ? _self.capturedPayments24h : capturedPayments24h // ignore: cast_nullable_to_non_nullable
as double,refunds24h: null == refunds24h ? _self.refunds24h : refunds24h // ignore: cast_nullable_to_non_nullable
as double,newUsers24h: null == newUsers24h ? _self.newUsers24h : newUsers24h // ignore: cast_nullable_to_non_nullable
as int,completedJobs24h: null == completedJobs24h ? _self.completedJobs24h : completedJobs24h // ignore: cast_nullable_to_non_nullable
as int,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminKpiData].
extension AdminKpiDataPatterns on AdminKpiData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminKpiData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminKpiData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminKpiData value)  $default,){
final _that = this;
switch (_that) {
case _AdminKpiData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminKpiData value)?  $default,){
final _that = this;
switch (_that) {
case _AdminKpiData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int activePros,  int openDisputes,  double capturedPayments24h,  double refunds24h,  int newUsers24h,  int completedJobs24h,  DateTime? lastUpdated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminKpiData() when $default != null:
return $default(_that.activePros,_that.openDisputes,_that.capturedPayments24h,_that.refunds24h,_that.newUsers24h,_that.completedJobs24h,_that.lastUpdated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int activePros,  int openDisputes,  double capturedPayments24h,  double refunds24h,  int newUsers24h,  int completedJobs24h,  DateTime? lastUpdated)  $default,) {final _that = this;
switch (_that) {
case _AdminKpiData():
return $default(_that.activePros,_that.openDisputes,_that.capturedPayments24h,_that.refunds24h,_that.newUsers24h,_that.completedJobs24h,_that.lastUpdated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int activePros,  int openDisputes,  double capturedPayments24h,  double refunds24h,  int newUsers24h,  int completedJobs24h,  DateTime? lastUpdated)?  $default,) {final _that = this;
switch (_that) {
case _AdminKpiData() when $default != null:
return $default(_that.activePros,_that.openDisputes,_that.capturedPayments24h,_that.refunds24h,_that.newUsers24h,_that.completedJobs24h,_that.lastUpdated);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminKpiData implements AdminKpiData {
  const _AdminKpiData({this.activePros = 0, this.openDisputes = 0, this.capturedPayments24h = 0.0, this.refunds24h = 0.0, this.newUsers24h = 0, this.completedJobs24h = 0, this.lastUpdated});
  factory _AdminKpiData.fromJson(Map<String, dynamic> json) => _$AdminKpiDataFromJson(json);

@override@JsonKey() final  int activePros;
@override@JsonKey() final  int openDisputes;
@override@JsonKey() final  double capturedPayments24h;
@override@JsonKey() final  double refunds24h;
@override@JsonKey() final  int newUsers24h;
@override@JsonKey() final  int completedJobs24h;
@override final  DateTime? lastUpdated;

/// Create a copy of AdminKpiData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminKpiDataCopyWith<_AdminKpiData> get copyWith => __$AdminKpiDataCopyWithImpl<_AdminKpiData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminKpiDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminKpiData&&(identical(other.activePros, activePros) || other.activePros == activePros)&&(identical(other.openDisputes, openDisputes) || other.openDisputes == openDisputes)&&(identical(other.capturedPayments24h, capturedPayments24h) || other.capturedPayments24h == capturedPayments24h)&&(identical(other.refunds24h, refunds24h) || other.refunds24h == refunds24h)&&(identical(other.newUsers24h, newUsers24h) || other.newUsers24h == newUsers24h)&&(identical(other.completedJobs24h, completedJobs24h) || other.completedJobs24h == completedJobs24h)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activePros,openDisputes,capturedPayments24h,refunds24h,newUsers24h,completedJobs24h,lastUpdated);

@override
String toString() {
  return 'AdminKpiData(activePros: $activePros, openDisputes: $openDisputes, capturedPayments24h: $capturedPayments24h, refunds24h: $refunds24h, newUsers24h: $newUsers24h, completedJobs24h: $completedJobs24h, lastUpdated: $lastUpdated)';
}


}

/// @nodoc
abstract mixin class _$AdminKpiDataCopyWith<$Res> implements $AdminKpiDataCopyWith<$Res> {
  factory _$AdminKpiDataCopyWith(_AdminKpiData value, $Res Function(_AdminKpiData) _then) = __$AdminKpiDataCopyWithImpl;
@override @useResult
$Res call({
 int activePros, int openDisputes, double capturedPayments24h, double refunds24h, int newUsers24h, int completedJobs24h, DateTime? lastUpdated
});




}
/// @nodoc
class __$AdminKpiDataCopyWithImpl<$Res>
    implements _$AdminKpiDataCopyWith<$Res> {
  __$AdminKpiDataCopyWithImpl(this._self, this._then);

  final _AdminKpiData _self;
  final $Res Function(_AdminKpiData) _then;

/// Create a copy of AdminKpiData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activePros = null,Object? openDisputes = null,Object? capturedPayments24h = null,Object? refunds24h = null,Object? newUsers24h = null,Object? completedJobs24h = null,Object? lastUpdated = freezed,}) {
  return _then(_AdminKpiData(
activePros: null == activePros ? _self.activePros : activePros // ignore: cast_nullable_to_non_nullable
as int,openDisputes: null == openDisputes ? _self.openDisputes : openDisputes // ignore: cast_nullable_to_non_nullable
as int,capturedPayments24h: null == capturedPayments24h ? _self.capturedPayments24h : capturedPayments24h // ignore: cast_nullable_to_non_nullable
as double,refunds24h: null == refunds24h ? _self.refunds24h : refunds24h // ignore: cast_nullable_to_non_nullable
as double,newUsers24h: null == newUsers24h ? _self.newUsers24h : newUsers24h // ignore: cast_nullable_to_non_nullable
as int,completedJobs24h: null == completedJobs24h ? _self.completedJobs24h : completedJobs24h // ignore: cast_nullable_to_non_nullable
as int,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$AdminFilter {

 DateTime? get dateFrom; DateTime? get dateTo; String? get status; String? get searchQuery; String? get sortBy; bool get sortAsc;
/// Create a copy of AdminFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminFilterCopyWith<AdminFilter> get copyWith => _$AdminFilterCopyWithImpl<AdminFilter>(this as AdminFilter, _$identity);

  /// Serializes this AdminFilter to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminFilter&&(identical(other.dateFrom, dateFrom) || other.dateFrom == dateFrom)&&(identical(other.dateTo, dateTo) || other.dateTo == dateTo)&&(identical(other.status, status) || other.status == status)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.sortBy, sortBy) || other.sortBy == sortBy)&&(identical(other.sortAsc, sortAsc) || other.sortAsc == sortAsc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dateFrom,dateTo,status,searchQuery,sortBy,sortAsc);

@override
String toString() {
  return 'AdminFilter(dateFrom: $dateFrom, dateTo: $dateTo, status: $status, searchQuery: $searchQuery, sortBy: $sortBy, sortAsc: $sortAsc)';
}


}

/// @nodoc
abstract mixin class $AdminFilterCopyWith<$Res>  {
  factory $AdminFilterCopyWith(AdminFilter value, $Res Function(AdminFilter) _then) = _$AdminFilterCopyWithImpl;
@useResult
$Res call({
 DateTime? dateFrom, DateTime? dateTo, String? status, String? searchQuery, String? sortBy, bool sortAsc
});




}
/// @nodoc
class _$AdminFilterCopyWithImpl<$Res>
    implements $AdminFilterCopyWith<$Res> {
  _$AdminFilterCopyWithImpl(this._self, this._then);

  final AdminFilter _self;
  final $Res Function(AdminFilter) _then;

/// Create a copy of AdminFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dateFrom = freezed,Object? dateTo = freezed,Object? status = freezed,Object? searchQuery = freezed,Object? sortBy = freezed,Object? sortAsc = null,}) {
  return _then(_self.copyWith(
dateFrom: freezed == dateFrom ? _self.dateFrom : dateFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,dateTo: freezed == dateTo ? _self.dateTo : dateTo // ignore: cast_nullable_to_non_nullable
as DateTime?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,searchQuery: freezed == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String?,sortBy: freezed == sortBy ? _self.sortBy : sortBy // ignore: cast_nullable_to_non_nullable
as String?,sortAsc: null == sortAsc ? _self.sortAsc : sortAsc // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminFilter].
extension AdminFilterPatterns on AdminFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminFilter value)  $default,){
final _that = this;
switch (_that) {
case _AdminFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminFilter value)?  $default,){
final _that = this;
switch (_that) {
case _AdminFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime? dateFrom,  DateTime? dateTo,  String? status,  String? searchQuery,  String? sortBy,  bool sortAsc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminFilter() when $default != null:
return $default(_that.dateFrom,_that.dateTo,_that.status,_that.searchQuery,_that.sortBy,_that.sortAsc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime? dateFrom,  DateTime? dateTo,  String? status,  String? searchQuery,  String? sortBy,  bool sortAsc)  $default,) {final _that = this;
switch (_that) {
case _AdminFilter():
return $default(_that.dateFrom,_that.dateTo,_that.status,_that.searchQuery,_that.sortBy,_that.sortAsc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime? dateFrom,  DateTime? dateTo,  String? status,  String? searchQuery,  String? sortBy,  bool sortAsc)?  $default,) {final _that = this;
switch (_that) {
case _AdminFilter() when $default != null:
return $default(_that.dateFrom,_that.dateTo,_that.status,_that.searchQuery,_that.sortBy,_that.sortAsc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminFilter implements AdminFilter {
  const _AdminFilter({this.dateFrom, this.dateTo, this.status, this.searchQuery, this.sortBy, this.sortAsc = false});
  factory _AdminFilter.fromJson(Map<String, dynamic> json) => _$AdminFilterFromJson(json);

@override final  DateTime? dateFrom;
@override final  DateTime? dateTo;
@override final  String? status;
@override final  String? searchQuery;
@override final  String? sortBy;
@override@JsonKey() final  bool sortAsc;

/// Create a copy of AdminFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminFilterCopyWith<_AdminFilter> get copyWith => __$AdminFilterCopyWithImpl<_AdminFilter>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminFilterToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminFilter&&(identical(other.dateFrom, dateFrom) || other.dateFrom == dateFrom)&&(identical(other.dateTo, dateTo) || other.dateTo == dateTo)&&(identical(other.status, status) || other.status == status)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.sortBy, sortBy) || other.sortBy == sortBy)&&(identical(other.sortAsc, sortAsc) || other.sortAsc == sortAsc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dateFrom,dateTo,status,searchQuery,sortBy,sortAsc);

@override
String toString() {
  return 'AdminFilter(dateFrom: $dateFrom, dateTo: $dateTo, status: $status, searchQuery: $searchQuery, sortBy: $sortBy, sortAsc: $sortAsc)';
}


}

/// @nodoc
abstract mixin class _$AdminFilterCopyWith<$Res> implements $AdminFilterCopyWith<$Res> {
  factory _$AdminFilterCopyWith(_AdminFilter value, $Res Function(_AdminFilter) _then) = __$AdminFilterCopyWithImpl;
@override @useResult
$Res call({
 DateTime? dateFrom, DateTime? dateTo, String? status, String? searchQuery, String? sortBy, bool sortAsc
});




}
/// @nodoc
class __$AdminFilterCopyWithImpl<$Res>
    implements _$AdminFilterCopyWith<$Res> {
  __$AdminFilterCopyWithImpl(this._self, this._then);

  final _AdminFilter _self;
  final $Res Function(_AdminFilter) _then;

/// Create a copy of AdminFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dateFrom = freezed,Object? dateTo = freezed,Object? status = freezed,Object? searchQuery = freezed,Object? sortBy = freezed,Object? sortAsc = null,}) {
  return _then(_AdminFilter(
dateFrom: freezed == dateFrom ? _self.dateFrom : dateFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,dateTo: freezed == dateTo ? _self.dateTo : dateTo // ignore: cast_nullable_to_non_nullable
as DateTime?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,searchQuery: freezed == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String?,sortBy: freezed == sortBy ? _self.sortBy : sortBy // ignore: cast_nullable_to_non_nullable
as String?,sortAsc: null == sortAsc ? _self.sortAsc : sortAsc // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ExportResult {

 String get downloadUrl; String get fileName; int get expiresInMinutes; DateTime? get createdAt;
/// Create a copy of ExportResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExportResultCopyWith<ExportResult> get copyWith => _$ExportResultCopyWithImpl<ExportResult>(this as ExportResult, _$identity);

  /// Serializes this ExportResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportResult&&(identical(other.downloadUrl, downloadUrl) || other.downloadUrl == downloadUrl)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.expiresInMinutes, expiresInMinutes) || other.expiresInMinutes == expiresInMinutes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,downloadUrl,fileName,expiresInMinutes,createdAt);

@override
String toString() {
  return 'ExportResult(downloadUrl: $downloadUrl, fileName: $fileName, expiresInMinutes: $expiresInMinutes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ExportResultCopyWith<$Res>  {
  factory $ExportResultCopyWith(ExportResult value, $Res Function(ExportResult) _then) = _$ExportResultCopyWithImpl;
@useResult
$Res call({
 String downloadUrl, String fileName, int expiresInMinutes, DateTime? createdAt
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
@pragma('vm:prefer-inline') @override $Res call({Object? downloadUrl = null,Object? fileName = null,Object? expiresInMinutes = null,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
downloadUrl: null == downloadUrl ? _self.downloadUrl : downloadUrl // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,expiresInMinutes: null == expiresInMinutes ? _self.expiresInMinutes : expiresInMinutes // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String downloadUrl,  String fileName,  int expiresInMinutes,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExportResult() when $default != null:
return $default(_that.downloadUrl,_that.fileName,_that.expiresInMinutes,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String downloadUrl,  String fileName,  int expiresInMinutes,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _ExportResult():
return $default(_that.downloadUrl,_that.fileName,_that.expiresInMinutes,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String downloadUrl,  String fileName,  int expiresInMinutes,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ExportResult() when $default != null:
return $default(_that.downloadUrl,_that.fileName,_that.expiresInMinutes,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExportResult implements ExportResult {
  const _ExportResult({required this.downloadUrl, required this.fileName, this.expiresInMinutes = 60, this.createdAt});
  factory _ExportResult.fromJson(Map<String, dynamic> json) => _$ExportResultFromJson(json);

@override final  String downloadUrl;
@override final  String fileName;
@override@JsonKey() final  int expiresInMinutes;
@override final  DateTime? createdAt;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExportResult&&(identical(other.downloadUrl, downloadUrl) || other.downloadUrl == downloadUrl)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.expiresInMinutes, expiresInMinutes) || other.expiresInMinutes == expiresInMinutes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,downloadUrl,fileName,expiresInMinutes,createdAt);

@override
String toString() {
  return 'ExportResult(downloadUrl: $downloadUrl, fileName: $fileName, expiresInMinutes: $expiresInMinutes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ExportResultCopyWith<$Res> implements $ExportResultCopyWith<$Res> {
  factory _$ExportResultCopyWith(_ExportResult value, $Res Function(_ExportResult) _then) = __$ExportResultCopyWithImpl;
@override @useResult
$Res call({
 String downloadUrl, String fileName, int expiresInMinutes, DateTime? createdAt
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
@override @pragma('vm:prefer-inline') $Res call({Object? downloadUrl = null,Object? fileName = null,Object? expiresInMinutes = null,Object? createdAt = freezed,}) {
  return _then(_ExportResult(
downloadUrl: null == downloadUrl ? _self.downloadUrl : downloadUrl // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,expiresInMinutes: null == expiresInMinutes ? _self.expiresInMinutes : expiresInMinutes // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

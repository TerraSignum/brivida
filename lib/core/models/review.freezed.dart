// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReviewModeration {

 ReviewModerationStatus get status; String? get reason; String? get adminUid; DateTime get updatedAt;
/// Create a copy of ReviewModeration
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewModerationCopyWith<ReviewModeration> get copyWith => _$ReviewModerationCopyWithImpl<ReviewModeration>(this as ReviewModeration, _$identity);

  /// Serializes this ReviewModeration to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewModeration&&(identical(other.status, status) || other.status == status)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.adminUid, adminUid) || other.adminUid == adminUid)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,reason,adminUid,updatedAt);

@override
String toString() {
  return 'ReviewModeration(status: $status, reason: $reason, adminUid: $adminUid, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ReviewModerationCopyWith<$Res>  {
  factory $ReviewModerationCopyWith(ReviewModeration value, $Res Function(ReviewModeration) _then) = _$ReviewModerationCopyWithImpl;
@useResult
$Res call({
 ReviewModerationStatus status, String? reason, String? adminUid, DateTime updatedAt
});




}
/// @nodoc
class _$ReviewModerationCopyWithImpl<$Res>
    implements $ReviewModerationCopyWith<$Res> {
  _$ReviewModerationCopyWithImpl(this._self, this._then);

  final ReviewModeration _self;
  final $Res Function(ReviewModeration) _then;

/// Create a copy of ReviewModeration
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? reason = freezed,Object? adminUid = freezed,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReviewModerationStatus,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,adminUid: freezed == adminUid ? _self.adminUid : adminUid // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ReviewModeration].
extension ReviewModerationPatterns on ReviewModeration {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReviewModeration value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReviewModeration() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReviewModeration value)  $default,){
final _that = this;
switch (_that) {
case _ReviewModeration():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReviewModeration value)?  $default,){
final _that = this;
switch (_that) {
case _ReviewModeration() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ReviewModerationStatus status,  String? reason,  String? adminUid,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReviewModeration() when $default != null:
return $default(_that.status,_that.reason,_that.adminUid,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ReviewModerationStatus status,  String? reason,  String? adminUid,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ReviewModeration():
return $default(_that.status,_that.reason,_that.adminUid,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ReviewModerationStatus status,  String? reason,  String? adminUid,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ReviewModeration() when $default != null:
return $default(_that.status,_that.reason,_that.adminUid,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReviewModeration implements ReviewModeration {
  const _ReviewModeration({required this.status, this.reason, this.adminUid, required this.updatedAt});
  factory _ReviewModeration.fromJson(Map<String, dynamic> json) => _$ReviewModerationFromJson(json);

@override final  ReviewModerationStatus status;
@override final  String? reason;
@override final  String? adminUid;
@override final  DateTime updatedAt;

/// Create a copy of ReviewModeration
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewModerationCopyWith<_ReviewModeration> get copyWith => __$ReviewModerationCopyWithImpl<_ReviewModeration>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReviewModerationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReviewModeration&&(identical(other.status, status) || other.status == status)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.adminUid, adminUid) || other.adminUid == adminUid)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,reason,adminUid,updatedAt);

@override
String toString() {
  return 'ReviewModeration(status: $status, reason: $reason, adminUid: $adminUid, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ReviewModerationCopyWith<$Res> implements $ReviewModerationCopyWith<$Res> {
  factory _$ReviewModerationCopyWith(_ReviewModeration value, $Res Function(_ReviewModeration) _then) = __$ReviewModerationCopyWithImpl;
@override @useResult
$Res call({
 ReviewModerationStatus status, String? reason, String? adminUid, DateTime updatedAt
});




}
/// @nodoc
class __$ReviewModerationCopyWithImpl<$Res>
    implements _$ReviewModerationCopyWith<$Res> {
  __$ReviewModerationCopyWithImpl(this._self, this._then);

  final _ReviewModeration _self;
  final $Res Function(_ReviewModeration) _then;

/// Create a copy of ReviewModeration
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? reason = freezed,Object? adminUid = freezed,Object? updatedAt = null,}) {
  return _then(_ReviewModeration(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReviewModerationStatus,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,adminUid: freezed == adminUid ? _self.adminUid : adminUid // ignore: cast_nullable_to_non_nullable
as String?,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$Review {

 String get firestoreId; String get jobId; String get paymentId; String get customerUid; String get proUid; int get rating;// 1-5 stars
 String get comment;// max 500 chars
 DateTime get createdAt; ReviewModeration get moderation;// Optional customer info for display (anonymized)
 String? get customerDisplayName; String? get customerInitials;
/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewCopyWith<Review> get copyWith => _$ReviewCopyWithImpl<Review>(this as Review, _$identity);

  /// Serializes this Review to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Review&&(identical(other.firestoreId, firestoreId) || other.firestoreId == firestoreId)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.customerUid, customerUid) || other.customerUid == customerUid)&&(identical(other.proUid, proUid) || other.proUid == proUid)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.moderation, moderation) || other.moderation == moderation)&&(identical(other.customerDisplayName, customerDisplayName) || other.customerDisplayName == customerDisplayName)&&(identical(other.customerInitials, customerInitials) || other.customerInitials == customerInitials));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,firestoreId,jobId,paymentId,customerUid,proUid,rating,comment,createdAt,moderation,customerDisplayName,customerInitials);

@override
String toString() {
  return 'Review(firestoreId: $firestoreId, jobId: $jobId, paymentId: $paymentId, customerUid: $customerUid, proUid: $proUid, rating: $rating, comment: $comment, createdAt: $createdAt, moderation: $moderation, customerDisplayName: $customerDisplayName, customerInitials: $customerInitials)';
}


}

/// @nodoc
abstract mixin class $ReviewCopyWith<$Res>  {
  factory $ReviewCopyWith(Review value, $Res Function(Review) _then) = _$ReviewCopyWithImpl;
@useResult
$Res call({
 String firestoreId, String jobId, String paymentId, String customerUid, String proUid, int rating, String comment, DateTime createdAt, ReviewModeration moderation, String? customerDisplayName, String? customerInitials
});


$ReviewModerationCopyWith<$Res> get moderation;

}
/// @nodoc
class _$ReviewCopyWithImpl<$Res>
    implements $ReviewCopyWith<$Res> {
  _$ReviewCopyWithImpl(this._self, this._then);

  final Review _self;
  final $Res Function(Review) _then;

/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? firestoreId = null,Object? jobId = null,Object? paymentId = null,Object? customerUid = null,Object? proUid = null,Object? rating = null,Object? comment = null,Object? createdAt = null,Object? moderation = null,Object? customerDisplayName = freezed,Object? customerInitials = freezed,}) {
  return _then(_self.copyWith(
firestoreId: null == firestoreId ? _self.firestoreId : firestoreId // ignore: cast_nullable_to_non_nullable
as String,jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,paymentId: null == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String,customerUid: null == customerUid ? _self.customerUid : customerUid // ignore: cast_nullable_to_non_nullable
as String,proUid: null == proUid ? _self.proUid : proUid // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,moderation: null == moderation ? _self.moderation : moderation // ignore: cast_nullable_to_non_nullable
as ReviewModeration,customerDisplayName: freezed == customerDisplayName ? _self.customerDisplayName : customerDisplayName // ignore: cast_nullable_to_non_nullable
as String?,customerInitials: freezed == customerInitials ? _self.customerInitials : customerInitials // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReviewModerationCopyWith<$Res> get moderation {
  
  return $ReviewModerationCopyWith<$Res>(_self.moderation, (value) {
    return _then(_self.copyWith(moderation: value));
  });
}
}


/// Adds pattern-matching-related methods to [Review].
extension ReviewPatterns on Review {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Review value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Review() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Review value)  $default,){
final _that = this;
switch (_that) {
case _Review():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Review value)?  $default,){
final _that = this;
switch (_that) {
case _Review() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String firestoreId,  String jobId,  String paymentId,  String customerUid,  String proUid,  int rating,  String comment,  DateTime createdAt,  ReviewModeration moderation,  String? customerDisplayName,  String? customerInitials)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Review() when $default != null:
return $default(_that.firestoreId,_that.jobId,_that.paymentId,_that.customerUid,_that.proUid,_that.rating,_that.comment,_that.createdAt,_that.moderation,_that.customerDisplayName,_that.customerInitials);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String firestoreId,  String jobId,  String paymentId,  String customerUid,  String proUid,  int rating,  String comment,  DateTime createdAt,  ReviewModeration moderation,  String? customerDisplayName,  String? customerInitials)  $default,) {final _that = this;
switch (_that) {
case _Review():
return $default(_that.firestoreId,_that.jobId,_that.paymentId,_that.customerUid,_that.proUid,_that.rating,_that.comment,_that.createdAt,_that.moderation,_that.customerDisplayName,_that.customerInitials);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String firestoreId,  String jobId,  String paymentId,  String customerUid,  String proUid,  int rating,  String comment,  DateTime createdAt,  ReviewModeration moderation,  String? customerDisplayName,  String? customerInitials)?  $default,) {final _that = this;
switch (_that) {
case _Review() when $default != null:
return $default(_that.firestoreId,_that.jobId,_that.paymentId,_that.customerUid,_that.proUid,_that.rating,_that.comment,_that.createdAt,_that.moderation,_that.customerDisplayName,_that.customerInitials);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Review extends Review {
  const _Review({required this.firestoreId, required this.jobId, required this.paymentId, required this.customerUid, required this.proUid, required this.rating, required this.comment, required this.createdAt, required this.moderation, this.customerDisplayName, this.customerInitials}): super._();
  factory _Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

@override final  String firestoreId;
@override final  String jobId;
@override final  String paymentId;
@override final  String customerUid;
@override final  String proUid;
@override final  int rating;
// 1-5 stars
@override final  String comment;
// max 500 chars
@override final  DateTime createdAt;
@override final  ReviewModeration moderation;
// Optional customer info for display (anonymized)
@override final  String? customerDisplayName;
@override final  String? customerInitials;

/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewCopyWith<_Review> get copyWith => __$ReviewCopyWithImpl<_Review>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReviewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Review&&(identical(other.firestoreId, firestoreId) || other.firestoreId == firestoreId)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.customerUid, customerUid) || other.customerUid == customerUid)&&(identical(other.proUid, proUid) || other.proUid == proUid)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.moderation, moderation) || other.moderation == moderation)&&(identical(other.customerDisplayName, customerDisplayName) || other.customerDisplayName == customerDisplayName)&&(identical(other.customerInitials, customerInitials) || other.customerInitials == customerInitials));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,firestoreId,jobId,paymentId,customerUid,proUid,rating,comment,createdAt,moderation,customerDisplayName,customerInitials);

@override
String toString() {
  return 'Review(firestoreId: $firestoreId, jobId: $jobId, paymentId: $paymentId, customerUid: $customerUid, proUid: $proUid, rating: $rating, comment: $comment, createdAt: $createdAt, moderation: $moderation, customerDisplayName: $customerDisplayName, customerInitials: $customerInitials)';
}


}

/// @nodoc
abstract mixin class _$ReviewCopyWith<$Res> implements $ReviewCopyWith<$Res> {
  factory _$ReviewCopyWith(_Review value, $Res Function(_Review) _then) = __$ReviewCopyWithImpl;
@override @useResult
$Res call({
 String firestoreId, String jobId, String paymentId, String customerUid, String proUid, int rating, String comment, DateTime createdAt, ReviewModeration moderation, String? customerDisplayName, String? customerInitials
});


@override $ReviewModerationCopyWith<$Res> get moderation;

}
/// @nodoc
class __$ReviewCopyWithImpl<$Res>
    implements _$ReviewCopyWith<$Res> {
  __$ReviewCopyWithImpl(this._self, this._then);

  final _Review _self;
  final $Res Function(_Review) _then;

/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? firestoreId = null,Object? jobId = null,Object? paymentId = null,Object? customerUid = null,Object? proUid = null,Object? rating = null,Object? comment = null,Object? createdAt = null,Object? moderation = null,Object? customerDisplayName = freezed,Object? customerInitials = freezed,}) {
  return _then(_Review(
firestoreId: null == firestoreId ? _self.firestoreId : firestoreId // ignore: cast_nullable_to_non_nullable
as String,jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,paymentId: null == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String,customerUid: null == customerUid ? _self.customerUid : customerUid // ignore: cast_nullable_to_non_nullable
as String,proUid: null == proUid ? _self.proUid : proUid // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,moderation: null == moderation ? _self.moderation : moderation // ignore: cast_nullable_to_non_nullable
as ReviewModeration,customerDisplayName: freezed == customerDisplayName ? _self.customerDisplayName : customerDisplayName // ignore: cast_nullable_to_non_nullable
as String?,customerInitials: freezed == customerInitials ? _self.customerInitials : customerInitials // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of Review
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReviewModerationCopyWith<$Res> get moderation {
  
  return $ReviewModerationCopyWith<$Res>(_self.moderation, (value) {
    return _then(_self.copyWith(moderation: value));
  });
}
}


/// @nodoc
mixin _$RatingAggregate {

 double get average; int get count; Map<int, int> get distribution;
/// Create a copy of RatingAggregate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RatingAggregateCopyWith<RatingAggregate> get copyWith => _$RatingAggregateCopyWithImpl<RatingAggregate>(this as RatingAggregate, _$identity);

  /// Serializes this RatingAggregate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RatingAggregate&&(identical(other.average, average) || other.average == average)&&(identical(other.count, count) || other.count == count)&&const DeepCollectionEquality().equals(other.distribution, distribution));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,average,count,const DeepCollectionEquality().hash(distribution));

@override
String toString() {
  return 'RatingAggregate(average: $average, count: $count, distribution: $distribution)';
}


}

/// @nodoc
abstract mixin class $RatingAggregateCopyWith<$Res>  {
  factory $RatingAggregateCopyWith(RatingAggregate value, $Res Function(RatingAggregate) _then) = _$RatingAggregateCopyWithImpl;
@useResult
$Res call({
 double average, int count, Map<int, int> distribution
});




}
/// @nodoc
class _$RatingAggregateCopyWithImpl<$Res>
    implements $RatingAggregateCopyWith<$Res> {
  _$RatingAggregateCopyWithImpl(this._self, this._then);

  final RatingAggregate _self;
  final $Res Function(RatingAggregate) _then;

/// Create a copy of RatingAggregate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? average = null,Object? count = null,Object? distribution = null,}) {
  return _then(_self.copyWith(
average: null == average ? _self.average : average // ignore: cast_nullable_to_non_nullable
as double,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,distribution: null == distribution ? _self.distribution : distribution // ignore: cast_nullable_to_non_nullable
as Map<int, int>,
  ));
}

}


/// Adds pattern-matching-related methods to [RatingAggregate].
extension RatingAggregatePatterns on RatingAggregate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RatingAggregate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RatingAggregate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RatingAggregate value)  $default,){
final _that = this;
switch (_that) {
case _RatingAggregate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RatingAggregate value)?  $default,){
final _that = this;
switch (_that) {
case _RatingAggregate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double average,  int count,  Map<int, int> distribution)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RatingAggregate() when $default != null:
return $default(_that.average,_that.count,_that.distribution);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double average,  int count,  Map<int, int> distribution)  $default,) {final _that = this;
switch (_that) {
case _RatingAggregate():
return $default(_that.average,_that.count,_that.distribution);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double average,  int count,  Map<int, int> distribution)?  $default,) {final _that = this;
switch (_that) {
case _RatingAggregate() when $default != null:
return $default(_that.average,_that.count,_that.distribution);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RatingAggregate implements RatingAggregate {
  const _RatingAggregate({this.average = 0.0, this.count = 0, final  Map<int, int> distribution = const {}}): _distribution = distribution;
  factory _RatingAggregate.fromJson(Map<String, dynamic> json) => _$RatingAggregateFromJson(json);

@override@JsonKey() final  double average;
@override@JsonKey() final  int count;
 final  Map<int, int> _distribution;
@override@JsonKey() Map<int, int> get distribution {
  if (_distribution is EqualUnmodifiableMapView) return _distribution;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_distribution);
}


/// Create a copy of RatingAggregate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RatingAggregateCopyWith<_RatingAggregate> get copyWith => __$RatingAggregateCopyWithImpl<_RatingAggregate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RatingAggregateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RatingAggregate&&(identical(other.average, average) || other.average == average)&&(identical(other.count, count) || other.count == count)&&const DeepCollectionEquality().equals(other._distribution, _distribution));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,average,count,const DeepCollectionEquality().hash(_distribution));

@override
String toString() {
  return 'RatingAggregate(average: $average, count: $count, distribution: $distribution)';
}


}

/// @nodoc
abstract mixin class _$RatingAggregateCopyWith<$Res> implements $RatingAggregateCopyWith<$Res> {
  factory _$RatingAggregateCopyWith(_RatingAggregate value, $Res Function(_RatingAggregate) _then) = __$RatingAggregateCopyWithImpl;
@override @useResult
$Res call({
 double average, int count, Map<int, int> distribution
});




}
/// @nodoc
class __$RatingAggregateCopyWithImpl<$Res>
    implements _$RatingAggregateCopyWith<$Res> {
  __$RatingAggregateCopyWithImpl(this._self, this._then);

  final _RatingAggregate _self;
  final $Res Function(_RatingAggregate) _then;

/// Create a copy of RatingAggregate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? average = null,Object? count = null,Object? distribution = null,}) {
  return _then(_RatingAggregate(
average: null == average ? _self.average : average // ignore: cast_nullable_to_non_nullable
as double,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,distribution: null == distribution ? _self._distribution : distribution // ignore: cast_nullable_to_non_nullable
as Map<int, int>,
  ));
}


}


/// @nodoc
mixin _$ReviewSubmissionRequest {

 String get jobId; String get paymentId; int get rating; String get comment;
/// Create a copy of ReviewSubmissionRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewSubmissionRequestCopyWith<ReviewSubmissionRequest> get copyWith => _$ReviewSubmissionRequestCopyWithImpl<ReviewSubmissionRequest>(this as ReviewSubmissionRequest, _$identity);

  /// Serializes this ReviewSubmissionRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewSubmissionRequest&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.comment, comment) || other.comment == comment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,jobId,paymentId,rating,comment);

@override
String toString() {
  return 'ReviewSubmissionRequest(jobId: $jobId, paymentId: $paymentId, rating: $rating, comment: $comment)';
}


}

/// @nodoc
abstract mixin class $ReviewSubmissionRequestCopyWith<$Res>  {
  factory $ReviewSubmissionRequestCopyWith(ReviewSubmissionRequest value, $Res Function(ReviewSubmissionRequest) _then) = _$ReviewSubmissionRequestCopyWithImpl;
@useResult
$Res call({
 String jobId, String paymentId, int rating, String comment
});




}
/// @nodoc
class _$ReviewSubmissionRequestCopyWithImpl<$Res>
    implements $ReviewSubmissionRequestCopyWith<$Res> {
  _$ReviewSubmissionRequestCopyWithImpl(this._self, this._then);

  final ReviewSubmissionRequest _self;
  final $Res Function(ReviewSubmissionRequest) _then;

/// Create a copy of ReviewSubmissionRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? jobId = null,Object? paymentId = null,Object? rating = null,Object? comment = null,}) {
  return _then(_self.copyWith(
jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,paymentId: null == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ReviewSubmissionRequest].
extension ReviewSubmissionRequestPatterns on ReviewSubmissionRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReviewSubmissionRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReviewSubmissionRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReviewSubmissionRequest value)  $default,){
final _that = this;
switch (_that) {
case _ReviewSubmissionRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReviewSubmissionRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ReviewSubmissionRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String jobId,  String paymentId,  int rating,  String comment)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReviewSubmissionRequest() when $default != null:
return $default(_that.jobId,_that.paymentId,_that.rating,_that.comment);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String jobId,  String paymentId,  int rating,  String comment)  $default,) {final _that = this;
switch (_that) {
case _ReviewSubmissionRequest():
return $default(_that.jobId,_that.paymentId,_that.rating,_that.comment);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String jobId,  String paymentId,  int rating,  String comment)?  $default,) {final _that = this;
switch (_that) {
case _ReviewSubmissionRequest() when $default != null:
return $default(_that.jobId,_that.paymentId,_that.rating,_that.comment);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReviewSubmissionRequest implements ReviewSubmissionRequest {
  const _ReviewSubmissionRequest({required this.jobId, required this.paymentId, required this.rating, required this.comment});
  factory _ReviewSubmissionRequest.fromJson(Map<String, dynamic> json) => _$ReviewSubmissionRequestFromJson(json);

@override final  String jobId;
@override final  String paymentId;
@override final  int rating;
@override final  String comment;

/// Create a copy of ReviewSubmissionRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewSubmissionRequestCopyWith<_ReviewSubmissionRequest> get copyWith => __$ReviewSubmissionRequestCopyWithImpl<_ReviewSubmissionRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReviewSubmissionRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReviewSubmissionRequest&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.comment, comment) || other.comment == comment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,jobId,paymentId,rating,comment);

@override
String toString() {
  return 'ReviewSubmissionRequest(jobId: $jobId, paymentId: $paymentId, rating: $rating, comment: $comment)';
}


}

/// @nodoc
abstract mixin class _$ReviewSubmissionRequestCopyWith<$Res> implements $ReviewSubmissionRequestCopyWith<$Res> {
  factory _$ReviewSubmissionRequestCopyWith(_ReviewSubmissionRequest value, $Res Function(_ReviewSubmissionRequest) _then) = __$ReviewSubmissionRequestCopyWithImpl;
@override @useResult
$Res call({
 String jobId, String paymentId, int rating, String comment
});




}
/// @nodoc
class __$ReviewSubmissionRequestCopyWithImpl<$Res>
    implements _$ReviewSubmissionRequestCopyWith<$Res> {
  __$ReviewSubmissionRequestCopyWithImpl(this._self, this._then);

  final _ReviewSubmissionRequest _self;
  final $Res Function(_ReviewSubmissionRequest) _then;

/// Create a copy of ReviewSubmissionRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? jobId = null,Object? paymentId = null,Object? rating = null,Object? comment = null,}) {
  return _then(_ReviewSubmissionRequest(
jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,paymentId: null == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as int,comment: null == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ReviewModerationRequest {

 String get reviewId; ReviewModerationStatus get action; String? get reason;
/// Create a copy of ReviewModerationRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewModerationRequestCopyWith<ReviewModerationRequest> get copyWith => _$ReviewModerationRequestCopyWithImpl<ReviewModerationRequest>(this as ReviewModerationRequest, _$identity);

  /// Serializes this ReviewModerationRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewModerationRequest&&(identical(other.reviewId, reviewId) || other.reviewId == reviewId)&&(identical(other.action, action) || other.action == action)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reviewId,action,reason);

@override
String toString() {
  return 'ReviewModerationRequest(reviewId: $reviewId, action: $action, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $ReviewModerationRequestCopyWith<$Res>  {
  factory $ReviewModerationRequestCopyWith(ReviewModerationRequest value, $Res Function(ReviewModerationRequest) _then) = _$ReviewModerationRequestCopyWithImpl;
@useResult
$Res call({
 String reviewId, ReviewModerationStatus action, String? reason
});




}
/// @nodoc
class _$ReviewModerationRequestCopyWithImpl<$Res>
    implements $ReviewModerationRequestCopyWith<$Res> {
  _$ReviewModerationRequestCopyWithImpl(this._self, this._then);

  final ReviewModerationRequest _self;
  final $Res Function(ReviewModerationRequest) _then;

/// Create a copy of ReviewModerationRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reviewId = null,Object? action = null,Object? reason = freezed,}) {
  return _then(_self.copyWith(
reviewId: null == reviewId ? _self.reviewId : reviewId // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as ReviewModerationStatus,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReviewModerationRequest].
extension ReviewModerationRequestPatterns on ReviewModerationRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReviewModerationRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReviewModerationRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReviewModerationRequest value)  $default,){
final _that = this;
switch (_that) {
case _ReviewModerationRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReviewModerationRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ReviewModerationRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String reviewId,  ReviewModerationStatus action,  String? reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReviewModerationRequest() when $default != null:
return $default(_that.reviewId,_that.action,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String reviewId,  ReviewModerationStatus action,  String? reason)  $default,) {final _that = this;
switch (_that) {
case _ReviewModerationRequest():
return $default(_that.reviewId,_that.action,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String reviewId,  ReviewModerationStatus action,  String? reason)?  $default,) {final _that = this;
switch (_that) {
case _ReviewModerationRequest() when $default != null:
return $default(_that.reviewId,_that.action,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReviewModerationRequest implements ReviewModerationRequest {
  const _ReviewModerationRequest({required this.reviewId, required this.action, this.reason});
  factory _ReviewModerationRequest.fromJson(Map<String, dynamic> json) => _$ReviewModerationRequestFromJson(json);

@override final  String reviewId;
@override final  ReviewModerationStatus action;
@override final  String? reason;

/// Create a copy of ReviewModerationRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewModerationRequestCopyWith<_ReviewModerationRequest> get copyWith => __$ReviewModerationRequestCopyWithImpl<_ReviewModerationRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReviewModerationRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReviewModerationRequest&&(identical(other.reviewId, reviewId) || other.reviewId == reviewId)&&(identical(other.action, action) || other.action == action)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reviewId,action,reason);

@override
String toString() {
  return 'ReviewModerationRequest(reviewId: $reviewId, action: $action, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$ReviewModerationRequestCopyWith<$Res> implements $ReviewModerationRequestCopyWith<$Res> {
  factory _$ReviewModerationRequestCopyWith(_ReviewModerationRequest value, $Res Function(_ReviewModerationRequest) _then) = __$ReviewModerationRequestCopyWithImpl;
@override @useResult
$Res call({
 String reviewId, ReviewModerationStatus action, String? reason
});




}
/// @nodoc
class __$ReviewModerationRequestCopyWithImpl<$Res>
    implements _$ReviewModerationRequestCopyWith<$Res> {
  __$ReviewModerationRequestCopyWithImpl(this._self, this._then);

  final _ReviewModerationRequest _self;
  final $Res Function(_ReviewModerationRequest) _then;

/// Create a copy of ReviewModerationRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reviewId = null,Object? action = null,Object? reason = freezed,}) {
  return _then(_ReviewModerationRequest(
reviewId: null == reviewId ? _self.reviewId : reviewId // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as ReviewModerationStatus,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

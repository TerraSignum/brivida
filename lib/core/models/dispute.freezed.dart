// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dispute.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Evidence {

 EvidenceType get type; String? get path; String? get text; DateTime get createdAt;
/// Create a copy of Evidence
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EvidenceCopyWith<Evidence> get copyWith => _$EvidenceCopyWithImpl<Evidence>(this as Evidence, _$identity);

  /// Serializes this Evidence to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Evidence&&(identical(other.type, type) || other.type == type)&&(identical(other.path, path) || other.path == path)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,path,text,createdAt);

@override
String toString() {
  return 'Evidence(type: $type, path: $path, text: $text, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $EvidenceCopyWith<$Res>  {
  factory $EvidenceCopyWith(Evidence value, $Res Function(Evidence) _then) = _$EvidenceCopyWithImpl;
@useResult
$Res call({
 EvidenceType type, String? path, String? text, DateTime createdAt
});




}
/// @nodoc
class _$EvidenceCopyWithImpl<$Res>
    implements $EvidenceCopyWith<$Res> {
  _$EvidenceCopyWithImpl(this._self, this._then);

  final Evidence _self;
  final $Res Function(Evidence) _then;

/// Create a copy of Evidence
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? path = freezed,Object? text = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as EvidenceType,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Evidence].
extension EvidencePatterns on Evidence {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Evidence value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Evidence() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Evidence value)  $default,){
final _that = this;
switch (_that) {
case _Evidence():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Evidence value)?  $default,){
final _that = this;
switch (_that) {
case _Evidence() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EvidenceType type,  String? path,  String? text,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Evidence() when $default != null:
return $default(_that.type,_that.path,_that.text,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EvidenceType type,  String? path,  String? text,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _Evidence():
return $default(_that.type,_that.path,_that.text,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EvidenceType type,  String? path,  String? text,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Evidence() when $default != null:
return $default(_that.type,_that.path,_that.text,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Evidence implements Evidence {
  const _Evidence({required this.type, this.path, this.text, required this.createdAt});
  factory _Evidence.fromJson(Map<String, dynamic> json) => _$EvidenceFromJson(json);

@override final  EvidenceType type;
@override final  String? path;
@override final  String? text;
@override final  DateTime createdAt;

/// Create a copy of Evidence
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EvidenceCopyWith<_Evidence> get copyWith => __$EvidenceCopyWithImpl<_Evidence>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EvidenceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Evidence&&(identical(other.type, type) || other.type == type)&&(identical(other.path, path) || other.path == path)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,path,text,createdAt);

@override
String toString() {
  return 'Evidence(type: $type, path: $path, text: $text, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$EvidenceCopyWith<$Res> implements $EvidenceCopyWith<$Res> {
  factory _$EvidenceCopyWith(_Evidence value, $Res Function(_Evidence) _then) = __$EvidenceCopyWithImpl;
@override @useResult
$Res call({
 EvidenceType type, String? path, String? text, DateTime createdAt
});




}
/// @nodoc
class __$EvidenceCopyWithImpl<$Res>
    implements _$EvidenceCopyWith<$Res> {
  __$EvidenceCopyWithImpl(this._self, this._then);

  final _Evidence _self;
  final $Res Function(_Evidence) _then;

/// Create a copy of Evidence
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? path = freezed,Object? text = freezed,Object? createdAt = null,}) {
  return _then(_Evidence(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as EvidenceType,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$DisputeAuditEntry {

 String get by;// 'system' | 'customer' | 'pro' | 'admin'
 String get action; String? get note; DateTime get at;
/// Create a copy of DisputeAuditEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DisputeAuditEntryCopyWith<DisputeAuditEntry> get copyWith => _$DisputeAuditEntryCopyWithImpl<DisputeAuditEntry>(this as DisputeAuditEntry, _$identity);

  /// Serializes this DisputeAuditEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DisputeAuditEntry&&(identical(other.by, by) || other.by == by)&&(identical(other.action, action) || other.action == action)&&(identical(other.note, note) || other.note == note)&&(identical(other.at, at) || other.at == at));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,by,action,note,at);

@override
String toString() {
  return 'DisputeAuditEntry(by: $by, action: $action, note: $note, at: $at)';
}


}

/// @nodoc
abstract mixin class $DisputeAuditEntryCopyWith<$Res>  {
  factory $DisputeAuditEntryCopyWith(DisputeAuditEntry value, $Res Function(DisputeAuditEntry) _then) = _$DisputeAuditEntryCopyWithImpl;
@useResult
$Res call({
 String by, String action, String? note, DateTime at
});




}
/// @nodoc
class _$DisputeAuditEntryCopyWithImpl<$Res>
    implements $DisputeAuditEntryCopyWith<$Res> {
  _$DisputeAuditEntryCopyWithImpl(this._self, this._then);

  final DisputeAuditEntry _self;
  final $Res Function(DisputeAuditEntry) _then;

/// Create a copy of DisputeAuditEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? by = null,Object? action = null,Object? note = freezed,Object? at = null,}) {
  return _then(_self.copyWith(
by: null == by ? _self.by : by // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DisputeAuditEntry].
extension DisputeAuditEntryPatterns on DisputeAuditEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DisputeAuditEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DisputeAuditEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DisputeAuditEntry value)  $default,){
final _that = this;
switch (_that) {
case _DisputeAuditEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DisputeAuditEntry value)?  $default,){
final _that = this;
switch (_that) {
case _DisputeAuditEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String by,  String action,  String? note,  DateTime at)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DisputeAuditEntry() when $default != null:
return $default(_that.by,_that.action,_that.note,_that.at);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String by,  String action,  String? note,  DateTime at)  $default,) {final _that = this;
switch (_that) {
case _DisputeAuditEntry():
return $default(_that.by,_that.action,_that.note,_that.at);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String by,  String action,  String? note,  DateTime at)?  $default,) {final _that = this;
switch (_that) {
case _DisputeAuditEntry() when $default != null:
return $default(_that.by,_that.action,_that.note,_that.at);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DisputeAuditEntry implements DisputeAuditEntry {
  const _DisputeAuditEntry({required this.by, required this.action, this.note, required this.at});
  factory _DisputeAuditEntry.fromJson(Map<String, dynamic> json) => _$DisputeAuditEntryFromJson(json);

@override final  String by;
// 'system' | 'customer' | 'pro' | 'admin'
@override final  String action;
@override final  String? note;
@override final  DateTime at;

/// Create a copy of DisputeAuditEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DisputeAuditEntryCopyWith<_DisputeAuditEntry> get copyWith => __$DisputeAuditEntryCopyWithImpl<_DisputeAuditEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DisputeAuditEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DisputeAuditEntry&&(identical(other.by, by) || other.by == by)&&(identical(other.action, action) || other.action == action)&&(identical(other.note, note) || other.note == note)&&(identical(other.at, at) || other.at == at));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,by,action,note,at);

@override
String toString() {
  return 'DisputeAuditEntry(by: $by, action: $action, note: $note, at: $at)';
}


}

/// @nodoc
abstract mixin class _$DisputeAuditEntryCopyWith<$Res> implements $DisputeAuditEntryCopyWith<$Res> {
  factory _$DisputeAuditEntryCopyWith(_DisputeAuditEntry value, $Res Function(_DisputeAuditEntry) _then) = __$DisputeAuditEntryCopyWithImpl;
@override @useResult
$Res call({
 String by, String action, String? note, DateTime at
});




}
/// @nodoc
class __$DisputeAuditEntryCopyWithImpl<$Res>
    implements _$DisputeAuditEntryCopyWith<$Res> {
  __$DisputeAuditEntryCopyWithImpl(this._self, this._then);

  final _DisputeAuditEntry _self;
  final $Res Function(_DisputeAuditEntry) _then;

/// Create a copy of DisputeAuditEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? by = null,Object? action = null,Object? note = freezed,Object? at = null,}) {
  return _then(_DisputeAuditEntry(
by: null == by ? _self.by : by // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as String,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$Dispute {

 String get id; String get jobId; String get paymentId; String get customerUid; String get proUid; DisputeStatus get status; DisputeReason get reason; String get description; double get requestedAmount; double? get awardedAmount; DateTime get openedAt; DateTime get deadlineProResponse; DateTime get deadlineDecision; DateTime? get resolvedAt; List<Evidence> get evidence; List<Evidence> get proResponse; List<DisputeAuditEntry> get audit;
/// Create a copy of Dispute
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DisputeCopyWith<Dispute> get copyWith => _$DisputeCopyWithImpl<Dispute>(this as Dispute, _$identity);

  /// Serializes this Dispute to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Dispute&&(identical(other.id, id) || other.id == id)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.customerUid, customerUid) || other.customerUid == customerUid)&&(identical(other.proUid, proUid) || other.proUid == proUid)&&(identical(other.status, status) || other.status == status)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.description, description) || other.description == description)&&(identical(other.requestedAmount, requestedAmount) || other.requestedAmount == requestedAmount)&&(identical(other.awardedAmount, awardedAmount) || other.awardedAmount == awardedAmount)&&(identical(other.openedAt, openedAt) || other.openedAt == openedAt)&&(identical(other.deadlineProResponse, deadlineProResponse) || other.deadlineProResponse == deadlineProResponse)&&(identical(other.deadlineDecision, deadlineDecision) || other.deadlineDecision == deadlineDecision)&&(identical(other.resolvedAt, resolvedAt) || other.resolvedAt == resolvedAt)&&const DeepCollectionEquality().equals(other.evidence, evidence)&&const DeepCollectionEquality().equals(other.proResponse, proResponse)&&const DeepCollectionEquality().equals(other.audit, audit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,jobId,paymentId,customerUid,proUid,status,reason,description,requestedAmount,awardedAmount,openedAt,deadlineProResponse,deadlineDecision,resolvedAt,const DeepCollectionEquality().hash(evidence),const DeepCollectionEquality().hash(proResponse),const DeepCollectionEquality().hash(audit));

@override
String toString() {
  return 'Dispute(id: $id, jobId: $jobId, paymentId: $paymentId, customerUid: $customerUid, proUid: $proUid, status: $status, reason: $reason, description: $description, requestedAmount: $requestedAmount, awardedAmount: $awardedAmount, openedAt: $openedAt, deadlineProResponse: $deadlineProResponse, deadlineDecision: $deadlineDecision, resolvedAt: $resolvedAt, evidence: $evidence, proResponse: $proResponse, audit: $audit)';
}


}

/// @nodoc
abstract mixin class $DisputeCopyWith<$Res>  {
  factory $DisputeCopyWith(Dispute value, $Res Function(Dispute) _then) = _$DisputeCopyWithImpl;
@useResult
$Res call({
 String id, String jobId, String paymentId, String customerUid, String proUid, DisputeStatus status, DisputeReason reason, String description, double requestedAmount, double? awardedAmount, DateTime openedAt, DateTime deadlineProResponse, DateTime deadlineDecision, DateTime? resolvedAt, List<Evidence> evidence, List<Evidence> proResponse, List<DisputeAuditEntry> audit
});




}
/// @nodoc
class _$DisputeCopyWithImpl<$Res>
    implements $DisputeCopyWith<$Res> {
  _$DisputeCopyWithImpl(this._self, this._then);

  final Dispute _self;
  final $Res Function(Dispute) _then;

/// Create a copy of Dispute
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? jobId = null,Object? paymentId = null,Object? customerUid = null,Object? proUid = null,Object? status = null,Object? reason = null,Object? description = null,Object? requestedAmount = null,Object? awardedAmount = freezed,Object? openedAt = null,Object? deadlineProResponse = null,Object? deadlineDecision = null,Object? resolvedAt = freezed,Object? evidence = null,Object? proResponse = null,Object? audit = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,paymentId: null == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String,customerUid: null == customerUid ? _self.customerUid : customerUid // ignore: cast_nullable_to_non_nullable
as String,proUid: null == proUid ? _self.proUid : proUid // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DisputeStatus,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as DisputeReason,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,requestedAmount: null == requestedAmount ? _self.requestedAmount : requestedAmount // ignore: cast_nullable_to_non_nullable
as double,awardedAmount: freezed == awardedAmount ? _self.awardedAmount : awardedAmount // ignore: cast_nullable_to_non_nullable
as double?,openedAt: null == openedAt ? _self.openedAt : openedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deadlineProResponse: null == deadlineProResponse ? _self.deadlineProResponse : deadlineProResponse // ignore: cast_nullable_to_non_nullable
as DateTime,deadlineDecision: null == deadlineDecision ? _self.deadlineDecision : deadlineDecision // ignore: cast_nullable_to_non_nullable
as DateTime,resolvedAt: freezed == resolvedAt ? _self.resolvedAt : resolvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,evidence: null == evidence ? _self.evidence : evidence // ignore: cast_nullable_to_non_nullable
as List<Evidence>,proResponse: null == proResponse ? _self.proResponse : proResponse // ignore: cast_nullable_to_non_nullable
as List<Evidence>,audit: null == audit ? _self.audit : audit // ignore: cast_nullable_to_non_nullable
as List<DisputeAuditEntry>,
  ));
}

}


/// Adds pattern-matching-related methods to [Dispute].
extension DisputePatterns on Dispute {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Dispute value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Dispute() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Dispute value)  $default,){
final _that = this;
switch (_that) {
case _Dispute():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Dispute value)?  $default,){
final _that = this;
switch (_that) {
case _Dispute() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String jobId,  String paymentId,  String customerUid,  String proUid,  DisputeStatus status,  DisputeReason reason,  String description,  double requestedAmount,  double? awardedAmount,  DateTime openedAt,  DateTime deadlineProResponse,  DateTime deadlineDecision,  DateTime? resolvedAt,  List<Evidence> evidence,  List<Evidence> proResponse,  List<DisputeAuditEntry> audit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Dispute() when $default != null:
return $default(_that.id,_that.jobId,_that.paymentId,_that.customerUid,_that.proUid,_that.status,_that.reason,_that.description,_that.requestedAmount,_that.awardedAmount,_that.openedAt,_that.deadlineProResponse,_that.deadlineDecision,_that.resolvedAt,_that.evidence,_that.proResponse,_that.audit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String jobId,  String paymentId,  String customerUid,  String proUid,  DisputeStatus status,  DisputeReason reason,  String description,  double requestedAmount,  double? awardedAmount,  DateTime openedAt,  DateTime deadlineProResponse,  DateTime deadlineDecision,  DateTime? resolvedAt,  List<Evidence> evidence,  List<Evidence> proResponse,  List<DisputeAuditEntry> audit)  $default,) {final _that = this;
switch (_that) {
case _Dispute():
return $default(_that.id,_that.jobId,_that.paymentId,_that.customerUid,_that.proUid,_that.status,_that.reason,_that.description,_that.requestedAmount,_that.awardedAmount,_that.openedAt,_that.deadlineProResponse,_that.deadlineDecision,_that.resolvedAt,_that.evidence,_that.proResponse,_that.audit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String jobId,  String paymentId,  String customerUid,  String proUid,  DisputeStatus status,  DisputeReason reason,  String description,  double requestedAmount,  double? awardedAmount,  DateTime openedAt,  DateTime deadlineProResponse,  DateTime deadlineDecision,  DateTime? resolvedAt,  List<Evidence> evidence,  List<Evidence> proResponse,  List<DisputeAuditEntry> audit)?  $default,) {final _that = this;
switch (_that) {
case _Dispute() when $default != null:
return $default(_that.id,_that.jobId,_that.paymentId,_that.customerUid,_that.proUid,_that.status,_that.reason,_that.description,_that.requestedAmount,_that.awardedAmount,_that.openedAt,_that.deadlineProResponse,_that.deadlineDecision,_that.resolvedAt,_that.evidence,_that.proResponse,_that.audit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Dispute extends Dispute {
  const _Dispute({required this.id, required this.jobId, required this.paymentId, required this.customerUid, required this.proUid, required this.status, required this.reason, required this.description, required this.requestedAmount, this.awardedAmount, required this.openedAt, required this.deadlineProResponse, required this.deadlineDecision, this.resolvedAt, final  List<Evidence> evidence = const [], final  List<Evidence> proResponse = const [], final  List<DisputeAuditEntry> audit = const []}): _evidence = evidence,_proResponse = proResponse,_audit = audit,super._();
  factory _Dispute.fromJson(Map<String, dynamic> json) => _$DisputeFromJson(json);

@override final  String id;
@override final  String jobId;
@override final  String paymentId;
@override final  String customerUid;
@override final  String proUid;
@override final  DisputeStatus status;
@override final  DisputeReason reason;
@override final  String description;
@override final  double requestedAmount;
@override final  double? awardedAmount;
@override final  DateTime openedAt;
@override final  DateTime deadlineProResponse;
@override final  DateTime deadlineDecision;
@override final  DateTime? resolvedAt;
 final  List<Evidence> _evidence;
@override@JsonKey() List<Evidence> get evidence {
  if (_evidence is EqualUnmodifiableListView) return _evidence;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_evidence);
}

 final  List<Evidence> _proResponse;
@override@JsonKey() List<Evidence> get proResponse {
  if (_proResponse is EqualUnmodifiableListView) return _proResponse;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_proResponse);
}

 final  List<DisputeAuditEntry> _audit;
@override@JsonKey() List<DisputeAuditEntry> get audit {
  if (_audit is EqualUnmodifiableListView) return _audit;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_audit);
}


/// Create a copy of Dispute
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DisputeCopyWith<_Dispute> get copyWith => __$DisputeCopyWithImpl<_Dispute>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DisputeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Dispute&&(identical(other.id, id) || other.id == id)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.customerUid, customerUid) || other.customerUid == customerUid)&&(identical(other.proUid, proUid) || other.proUid == proUid)&&(identical(other.status, status) || other.status == status)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.description, description) || other.description == description)&&(identical(other.requestedAmount, requestedAmount) || other.requestedAmount == requestedAmount)&&(identical(other.awardedAmount, awardedAmount) || other.awardedAmount == awardedAmount)&&(identical(other.openedAt, openedAt) || other.openedAt == openedAt)&&(identical(other.deadlineProResponse, deadlineProResponse) || other.deadlineProResponse == deadlineProResponse)&&(identical(other.deadlineDecision, deadlineDecision) || other.deadlineDecision == deadlineDecision)&&(identical(other.resolvedAt, resolvedAt) || other.resolvedAt == resolvedAt)&&const DeepCollectionEquality().equals(other._evidence, _evidence)&&const DeepCollectionEquality().equals(other._proResponse, _proResponse)&&const DeepCollectionEquality().equals(other._audit, _audit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,jobId,paymentId,customerUid,proUid,status,reason,description,requestedAmount,awardedAmount,openedAt,deadlineProResponse,deadlineDecision,resolvedAt,const DeepCollectionEquality().hash(_evidence),const DeepCollectionEquality().hash(_proResponse),const DeepCollectionEquality().hash(_audit));

@override
String toString() {
  return 'Dispute(id: $id, jobId: $jobId, paymentId: $paymentId, customerUid: $customerUid, proUid: $proUid, status: $status, reason: $reason, description: $description, requestedAmount: $requestedAmount, awardedAmount: $awardedAmount, openedAt: $openedAt, deadlineProResponse: $deadlineProResponse, deadlineDecision: $deadlineDecision, resolvedAt: $resolvedAt, evidence: $evidence, proResponse: $proResponse, audit: $audit)';
}


}

/// @nodoc
abstract mixin class _$DisputeCopyWith<$Res> implements $DisputeCopyWith<$Res> {
  factory _$DisputeCopyWith(_Dispute value, $Res Function(_Dispute) _then) = __$DisputeCopyWithImpl;
@override @useResult
$Res call({
 String id, String jobId, String paymentId, String customerUid, String proUid, DisputeStatus status, DisputeReason reason, String description, double requestedAmount, double? awardedAmount, DateTime openedAt, DateTime deadlineProResponse, DateTime deadlineDecision, DateTime? resolvedAt, List<Evidence> evidence, List<Evidence> proResponse, List<DisputeAuditEntry> audit
});




}
/// @nodoc
class __$DisputeCopyWithImpl<$Res>
    implements _$DisputeCopyWith<$Res> {
  __$DisputeCopyWithImpl(this._self, this._then);

  final _Dispute _self;
  final $Res Function(_Dispute) _then;

/// Create a copy of Dispute
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? jobId = null,Object? paymentId = null,Object? customerUid = null,Object? proUid = null,Object? status = null,Object? reason = null,Object? description = null,Object? requestedAmount = null,Object? awardedAmount = freezed,Object? openedAt = null,Object? deadlineProResponse = null,Object? deadlineDecision = null,Object? resolvedAt = freezed,Object? evidence = null,Object? proResponse = null,Object? audit = null,}) {
  return _then(_Dispute(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,paymentId: null == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String,customerUid: null == customerUid ? _self.customerUid : customerUid // ignore: cast_nullable_to_non_nullable
as String,proUid: null == proUid ? _self.proUid : proUid // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DisputeStatus,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as DisputeReason,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,requestedAmount: null == requestedAmount ? _self.requestedAmount : requestedAmount // ignore: cast_nullable_to_non_nullable
as double,awardedAmount: freezed == awardedAmount ? _self.awardedAmount : awardedAmount // ignore: cast_nullable_to_non_nullable
as double?,openedAt: null == openedAt ? _self.openedAt : openedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deadlineProResponse: null == deadlineProResponse ? _self.deadlineProResponse : deadlineProResponse // ignore: cast_nullable_to_non_nullable
as DateTime,deadlineDecision: null == deadlineDecision ? _self.deadlineDecision : deadlineDecision // ignore: cast_nullable_to_non_nullable
as DateTime,resolvedAt: freezed == resolvedAt ? _self.resolvedAt : resolvedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,evidence: null == evidence ? _self._evidence : evidence // ignore: cast_nullable_to_non_nullable
as List<Evidence>,proResponse: null == proResponse ? _self._proResponse : proResponse // ignore: cast_nullable_to_non_nullable
as List<Evidence>,audit: null == audit ? _self._audit : audit // ignore: cast_nullable_to_non_nullable
as List<DisputeAuditEntry>,
  ));
}


}

// dart format on

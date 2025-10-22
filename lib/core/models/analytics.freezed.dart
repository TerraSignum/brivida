// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AnalyticsEvent {

 String get id; String? get uid;// nullable for events before login
 String? get role;// customer|pro|admin|null
 DateTime get ts; String get src;// client|server
 String get name; Map<String, Object?> get props; Map<String, Object?> get context; String get sessionId;
/// Create a copy of AnalyticsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsEventCopyWith<AnalyticsEvent> get copyWith => _$AnalyticsEventCopyWithImpl<AnalyticsEvent>(this as AnalyticsEvent, _$identity);

  /// Serializes this AnalyticsEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.role, role) || other.role == role)&&(identical(other.ts, ts) || other.ts == ts)&&(identical(other.src, src) || other.src == src)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.props, props)&&const DeepCollectionEquality().equals(other.context, context)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,uid,role,ts,src,name,const DeepCollectionEquality().hash(props),const DeepCollectionEquality().hash(context),sessionId);

@override
String toString() {
  return 'AnalyticsEvent(id: $id, uid: $uid, role: $role, ts: $ts, src: $src, name: $name, props: $props, context: $context, sessionId: $sessionId)';
}


}

/// @nodoc
abstract mixin class $AnalyticsEventCopyWith<$Res>  {
  factory $AnalyticsEventCopyWith(AnalyticsEvent value, $Res Function(AnalyticsEvent) _then) = _$AnalyticsEventCopyWithImpl;
@useResult
$Res call({
 String id, String? uid, String? role, DateTime ts, String src, String name, Map<String, Object?> props, Map<String, Object?> context, String sessionId
});




}
/// @nodoc
class _$AnalyticsEventCopyWithImpl<$Res>
    implements $AnalyticsEventCopyWith<$Res> {
  _$AnalyticsEventCopyWithImpl(this._self, this._then);

  final AnalyticsEvent _self;
  final $Res Function(AnalyticsEvent) _then;

/// Create a copy of AnalyticsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? uid = freezed,Object? role = freezed,Object? ts = null,Object? src = null,Object? name = null,Object? props = null,Object? context = null,Object? sessionId = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,ts: null == ts ? _self.ts : ts // ignore: cast_nullable_to_non_nullable
as DateTime,src: null == src ? _self.src : src // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,props: null == props ? _self.props : props // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,context: null == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AnalyticsEvent].
extension AnalyticsEventPatterns on AnalyticsEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalyticsEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalyticsEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalyticsEvent value)  $default,){
final _that = this;
switch (_that) {
case _AnalyticsEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalyticsEvent value)?  $default,){
final _that = this;
switch (_that) {
case _AnalyticsEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? uid,  String? role,  DateTime ts,  String src,  String name,  Map<String, Object?> props,  Map<String, Object?> context,  String sessionId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalyticsEvent() when $default != null:
return $default(_that.id,_that.uid,_that.role,_that.ts,_that.src,_that.name,_that.props,_that.context,_that.sessionId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? uid,  String? role,  DateTime ts,  String src,  String name,  Map<String, Object?> props,  Map<String, Object?> context,  String sessionId)  $default,) {final _that = this;
switch (_that) {
case _AnalyticsEvent():
return $default(_that.id,_that.uid,_that.role,_that.ts,_that.src,_that.name,_that.props,_that.context,_that.sessionId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? uid,  String? role,  DateTime ts,  String src,  String name,  Map<String, Object?> props,  Map<String, Object?> context,  String sessionId)?  $default,) {final _that = this;
switch (_that) {
case _AnalyticsEvent() when $default != null:
return $default(_that.id,_that.uid,_that.role,_that.ts,_that.src,_that.name,_that.props,_that.context,_that.sessionId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnalyticsEvent extends AnalyticsEvent {
  const _AnalyticsEvent({required this.id, this.uid, this.role, required this.ts, required this.src, required this.name, required final  Map<String, Object?> props, required final  Map<String, Object?> context, required this.sessionId}): _props = props,_context = context,super._();
  factory _AnalyticsEvent.fromJson(Map<String, dynamic> json) => _$AnalyticsEventFromJson(json);

@override final  String id;
@override final  String? uid;
// nullable for events before login
@override final  String? role;
// customer|pro|admin|null
@override final  DateTime ts;
@override final  String src;
// client|server
@override final  String name;
 final  Map<String, Object?> _props;
@override Map<String, Object?> get props {
  if (_props is EqualUnmodifiableMapView) return _props;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_props);
}

 final  Map<String, Object?> _context;
@override Map<String, Object?> get context {
  if (_context is EqualUnmodifiableMapView) return _context;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_context);
}

@override final  String sessionId;

/// Create a copy of AnalyticsEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalyticsEventCopyWith<_AnalyticsEvent> get copyWith => __$AnalyticsEventCopyWithImpl<_AnalyticsEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnalyticsEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.role, role) || other.role == role)&&(identical(other.ts, ts) || other.ts == ts)&&(identical(other.src, src) || other.src == src)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._props, _props)&&const DeepCollectionEquality().equals(other._context, _context)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,uid,role,ts,src,name,const DeepCollectionEquality().hash(_props),const DeepCollectionEquality().hash(_context),sessionId);

@override
String toString() {
  return 'AnalyticsEvent(id: $id, uid: $uid, role: $role, ts: $ts, src: $src, name: $name, props: $props, context: $context, sessionId: $sessionId)';
}


}

/// @nodoc
abstract mixin class _$AnalyticsEventCopyWith<$Res> implements $AnalyticsEventCopyWith<$Res> {
  factory _$AnalyticsEventCopyWith(_AnalyticsEvent value, $Res Function(_AnalyticsEvent) _then) = __$AnalyticsEventCopyWithImpl;
@override @useResult
$Res call({
 String id, String? uid, String? role, DateTime ts, String src, String name, Map<String, Object?> props, Map<String, Object?> context, String sessionId
});




}
/// @nodoc
class __$AnalyticsEventCopyWithImpl<$Res>
    implements _$AnalyticsEventCopyWith<$Res> {
  __$AnalyticsEventCopyWithImpl(this._self, this._then);

  final _AnalyticsEvent _self;
  final $Res Function(_AnalyticsEvent) _then;

/// Create a copy of AnalyticsEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? uid = freezed,Object? role = freezed,Object? ts = null,Object? src = null,Object? name = null,Object? props = null,Object? context = null,Object? sessionId = null,}) {
  return _then(_AnalyticsEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,uid: freezed == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,ts: null == ts ? _self.ts : ts // ignore: cast_nullable_to_non_nullable
as DateTime,src: null == src ? _self.src : src // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,props: null == props ? _self._props : props // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,context: null == context ? _self._context : context // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AnalyticsDaily {

 String get date;// yyyyMMdd format
 AnalyticsKpis get kpis; DateTime get updatedAt;
/// Create a copy of AnalyticsDaily
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsDailyCopyWith<AnalyticsDaily> get copyWith => _$AnalyticsDailyCopyWithImpl<AnalyticsDaily>(this as AnalyticsDaily, _$identity);

  /// Serializes this AnalyticsDaily to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsDaily&&(identical(other.date, date) || other.date == date)&&(identical(other.kpis, kpis) || other.kpis == kpis)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,kpis,updatedAt);

@override
String toString() {
  return 'AnalyticsDaily(date: $date, kpis: $kpis, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $AnalyticsDailyCopyWith<$Res>  {
  factory $AnalyticsDailyCopyWith(AnalyticsDaily value, $Res Function(AnalyticsDaily) _then) = _$AnalyticsDailyCopyWithImpl;
@useResult
$Res call({
 String date, AnalyticsKpis kpis, DateTime updatedAt
});


$AnalyticsKpisCopyWith<$Res> get kpis;

}
/// @nodoc
class _$AnalyticsDailyCopyWithImpl<$Res>
    implements $AnalyticsDailyCopyWith<$Res> {
  _$AnalyticsDailyCopyWithImpl(this._self, this._then);

  final AnalyticsDaily _self;
  final $Res Function(AnalyticsDaily) _then;

/// Create a copy of AnalyticsDaily
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? kpis = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,kpis: null == kpis ? _self.kpis : kpis // ignore: cast_nullable_to_non_nullable
as AnalyticsKpis,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of AnalyticsDaily
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsKpisCopyWith<$Res> get kpis {
  
  return $AnalyticsKpisCopyWith<$Res>(_self.kpis, (value) {
    return _then(_self.copyWith(kpis: value));
  });
}
}


/// Adds pattern-matching-related methods to [AnalyticsDaily].
extension AnalyticsDailyPatterns on AnalyticsDaily {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalyticsDaily value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalyticsDaily() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalyticsDaily value)  $default,){
final _that = this;
switch (_that) {
case _AnalyticsDaily():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalyticsDaily value)?  $default,){
final _that = this;
switch (_that) {
case _AnalyticsDaily() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  AnalyticsKpis kpis,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalyticsDaily() when $default != null:
return $default(_that.date,_that.kpis,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  AnalyticsKpis kpis,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _AnalyticsDaily():
return $default(_that.date,_that.kpis,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  AnalyticsKpis kpis,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _AnalyticsDaily() when $default != null:
return $default(_that.date,_that.kpis,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnalyticsDaily implements AnalyticsDaily {
  const _AnalyticsDaily({required this.date, required this.kpis, required this.updatedAt});
  factory _AnalyticsDaily.fromJson(Map<String, dynamic> json) => _$AnalyticsDailyFromJson(json);

@override final  String date;
// yyyyMMdd format
@override final  AnalyticsKpis kpis;
@override final  DateTime updatedAt;

/// Create a copy of AnalyticsDaily
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalyticsDailyCopyWith<_AnalyticsDaily> get copyWith => __$AnalyticsDailyCopyWithImpl<_AnalyticsDaily>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnalyticsDailyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsDaily&&(identical(other.date, date) || other.date == date)&&(identical(other.kpis, kpis) || other.kpis == kpis)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,kpis,updatedAt);

@override
String toString() {
  return 'AnalyticsDaily(date: $date, kpis: $kpis, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$AnalyticsDailyCopyWith<$Res> implements $AnalyticsDailyCopyWith<$Res> {
  factory _$AnalyticsDailyCopyWith(_AnalyticsDaily value, $Res Function(_AnalyticsDaily) _then) = __$AnalyticsDailyCopyWithImpl;
@override @useResult
$Res call({
 String date, AnalyticsKpis kpis, DateTime updatedAt
});


@override $AnalyticsKpisCopyWith<$Res> get kpis;

}
/// @nodoc
class __$AnalyticsDailyCopyWithImpl<$Res>
    implements _$AnalyticsDailyCopyWith<$Res> {
  __$AnalyticsDailyCopyWithImpl(this._self, this._then);

  final _AnalyticsDaily _self;
  final $Res Function(_AnalyticsDaily) _then;

/// Create a copy of AnalyticsDaily
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? kpis = null,Object? updatedAt = null,}) {
  return _then(_AnalyticsDaily(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,kpis: null == kpis ? _self.kpis : kpis // ignore: cast_nullable_to_non_nullable
as AnalyticsKpis,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of AnalyticsDaily
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalyticsKpisCopyWith<$Res> get kpis {
  
  return $AnalyticsKpisCopyWith<$Res>(_self.kpis, (value) {
    return _then(_self.copyWith(kpis: value));
  });
}
}


/// @nodoc
mixin _$AnalyticsKpis {

 int get jobsCreated; int get leadsCreated; int get leadsAccepted; double get paymentsCapturedEur; double get paymentsReleasedEur; double get refundsEur; int get chatMessages; int get activePros; int get activeCustomers; int get newUsers; int get disputesOpened; int get disputesResolved; double get avgRating; int get ratingsCount; int get pushDelivered; int get pushOpened; double get pushOpenRate;
/// Create a copy of AnalyticsKpis
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsKpisCopyWith<AnalyticsKpis> get copyWith => _$AnalyticsKpisCopyWithImpl<AnalyticsKpis>(this as AnalyticsKpis, _$identity);

  /// Serializes this AnalyticsKpis to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsKpis&&(identical(other.jobsCreated, jobsCreated) || other.jobsCreated == jobsCreated)&&(identical(other.leadsCreated, leadsCreated) || other.leadsCreated == leadsCreated)&&(identical(other.leadsAccepted, leadsAccepted) || other.leadsAccepted == leadsAccepted)&&(identical(other.paymentsCapturedEur, paymentsCapturedEur) || other.paymentsCapturedEur == paymentsCapturedEur)&&(identical(other.paymentsReleasedEur, paymentsReleasedEur) || other.paymentsReleasedEur == paymentsReleasedEur)&&(identical(other.refundsEur, refundsEur) || other.refundsEur == refundsEur)&&(identical(other.chatMessages, chatMessages) || other.chatMessages == chatMessages)&&(identical(other.activePros, activePros) || other.activePros == activePros)&&(identical(other.activeCustomers, activeCustomers) || other.activeCustomers == activeCustomers)&&(identical(other.newUsers, newUsers) || other.newUsers == newUsers)&&(identical(other.disputesOpened, disputesOpened) || other.disputesOpened == disputesOpened)&&(identical(other.disputesResolved, disputesResolved) || other.disputesResolved == disputesResolved)&&(identical(other.avgRating, avgRating) || other.avgRating == avgRating)&&(identical(other.ratingsCount, ratingsCount) || other.ratingsCount == ratingsCount)&&(identical(other.pushDelivered, pushDelivered) || other.pushDelivered == pushDelivered)&&(identical(other.pushOpened, pushOpened) || other.pushOpened == pushOpened)&&(identical(other.pushOpenRate, pushOpenRate) || other.pushOpenRate == pushOpenRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,jobsCreated,leadsCreated,leadsAccepted,paymentsCapturedEur,paymentsReleasedEur,refundsEur,chatMessages,activePros,activeCustomers,newUsers,disputesOpened,disputesResolved,avgRating,ratingsCount,pushDelivered,pushOpened,pushOpenRate);

@override
String toString() {
  return 'AnalyticsKpis(jobsCreated: $jobsCreated, leadsCreated: $leadsCreated, leadsAccepted: $leadsAccepted, paymentsCapturedEur: $paymentsCapturedEur, paymentsReleasedEur: $paymentsReleasedEur, refundsEur: $refundsEur, chatMessages: $chatMessages, activePros: $activePros, activeCustomers: $activeCustomers, newUsers: $newUsers, disputesOpened: $disputesOpened, disputesResolved: $disputesResolved, avgRating: $avgRating, ratingsCount: $ratingsCount, pushDelivered: $pushDelivered, pushOpened: $pushOpened, pushOpenRate: $pushOpenRate)';
}


}

/// @nodoc
abstract mixin class $AnalyticsKpisCopyWith<$Res>  {
  factory $AnalyticsKpisCopyWith(AnalyticsKpis value, $Res Function(AnalyticsKpis) _then) = _$AnalyticsKpisCopyWithImpl;
@useResult
$Res call({
 int jobsCreated, int leadsCreated, int leadsAccepted, double paymentsCapturedEur, double paymentsReleasedEur, double refundsEur, int chatMessages, int activePros, int activeCustomers, int newUsers, int disputesOpened, int disputesResolved, double avgRating, int ratingsCount, int pushDelivered, int pushOpened, double pushOpenRate
});




}
/// @nodoc
class _$AnalyticsKpisCopyWithImpl<$Res>
    implements $AnalyticsKpisCopyWith<$Res> {
  _$AnalyticsKpisCopyWithImpl(this._self, this._then);

  final AnalyticsKpis _self;
  final $Res Function(AnalyticsKpis) _then;

/// Create a copy of AnalyticsKpis
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? jobsCreated = null,Object? leadsCreated = null,Object? leadsAccepted = null,Object? paymentsCapturedEur = null,Object? paymentsReleasedEur = null,Object? refundsEur = null,Object? chatMessages = null,Object? activePros = null,Object? activeCustomers = null,Object? newUsers = null,Object? disputesOpened = null,Object? disputesResolved = null,Object? avgRating = null,Object? ratingsCount = null,Object? pushDelivered = null,Object? pushOpened = null,Object? pushOpenRate = null,}) {
  return _then(_self.copyWith(
jobsCreated: null == jobsCreated ? _self.jobsCreated : jobsCreated // ignore: cast_nullable_to_non_nullable
as int,leadsCreated: null == leadsCreated ? _self.leadsCreated : leadsCreated // ignore: cast_nullable_to_non_nullable
as int,leadsAccepted: null == leadsAccepted ? _self.leadsAccepted : leadsAccepted // ignore: cast_nullable_to_non_nullable
as int,paymentsCapturedEur: null == paymentsCapturedEur ? _self.paymentsCapturedEur : paymentsCapturedEur // ignore: cast_nullable_to_non_nullable
as double,paymentsReleasedEur: null == paymentsReleasedEur ? _self.paymentsReleasedEur : paymentsReleasedEur // ignore: cast_nullable_to_non_nullable
as double,refundsEur: null == refundsEur ? _self.refundsEur : refundsEur // ignore: cast_nullable_to_non_nullable
as double,chatMessages: null == chatMessages ? _self.chatMessages : chatMessages // ignore: cast_nullable_to_non_nullable
as int,activePros: null == activePros ? _self.activePros : activePros // ignore: cast_nullable_to_non_nullable
as int,activeCustomers: null == activeCustomers ? _self.activeCustomers : activeCustomers // ignore: cast_nullable_to_non_nullable
as int,newUsers: null == newUsers ? _self.newUsers : newUsers // ignore: cast_nullable_to_non_nullable
as int,disputesOpened: null == disputesOpened ? _self.disputesOpened : disputesOpened // ignore: cast_nullable_to_non_nullable
as int,disputesResolved: null == disputesResolved ? _self.disputesResolved : disputesResolved // ignore: cast_nullable_to_non_nullable
as int,avgRating: null == avgRating ? _self.avgRating : avgRating // ignore: cast_nullable_to_non_nullable
as double,ratingsCount: null == ratingsCount ? _self.ratingsCount : ratingsCount // ignore: cast_nullable_to_non_nullable
as int,pushDelivered: null == pushDelivered ? _self.pushDelivered : pushDelivered // ignore: cast_nullable_to_non_nullable
as int,pushOpened: null == pushOpened ? _self.pushOpened : pushOpened // ignore: cast_nullable_to_non_nullable
as int,pushOpenRate: null == pushOpenRate ? _self.pushOpenRate : pushOpenRate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [AnalyticsKpis].
extension AnalyticsKpisPatterns on AnalyticsKpis {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalyticsKpis value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalyticsKpis() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalyticsKpis value)  $default,){
final _that = this;
switch (_that) {
case _AnalyticsKpis():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalyticsKpis value)?  $default,){
final _that = this;
switch (_that) {
case _AnalyticsKpis() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int jobsCreated,  int leadsCreated,  int leadsAccepted,  double paymentsCapturedEur,  double paymentsReleasedEur,  double refundsEur,  int chatMessages,  int activePros,  int activeCustomers,  int newUsers,  int disputesOpened,  int disputesResolved,  double avgRating,  int ratingsCount,  int pushDelivered,  int pushOpened,  double pushOpenRate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalyticsKpis() when $default != null:
return $default(_that.jobsCreated,_that.leadsCreated,_that.leadsAccepted,_that.paymentsCapturedEur,_that.paymentsReleasedEur,_that.refundsEur,_that.chatMessages,_that.activePros,_that.activeCustomers,_that.newUsers,_that.disputesOpened,_that.disputesResolved,_that.avgRating,_that.ratingsCount,_that.pushDelivered,_that.pushOpened,_that.pushOpenRate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int jobsCreated,  int leadsCreated,  int leadsAccepted,  double paymentsCapturedEur,  double paymentsReleasedEur,  double refundsEur,  int chatMessages,  int activePros,  int activeCustomers,  int newUsers,  int disputesOpened,  int disputesResolved,  double avgRating,  int ratingsCount,  int pushDelivered,  int pushOpened,  double pushOpenRate)  $default,) {final _that = this;
switch (_that) {
case _AnalyticsKpis():
return $default(_that.jobsCreated,_that.leadsCreated,_that.leadsAccepted,_that.paymentsCapturedEur,_that.paymentsReleasedEur,_that.refundsEur,_that.chatMessages,_that.activePros,_that.activeCustomers,_that.newUsers,_that.disputesOpened,_that.disputesResolved,_that.avgRating,_that.ratingsCount,_that.pushDelivered,_that.pushOpened,_that.pushOpenRate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int jobsCreated,  int leadsCreated,  int leadsAccepted,  double paymentsCapturedEur,  double paymentsReleasedEur,  double refundsEur,  int chatMessages,  int activePros,  int activeCustomers,  int newUsers,  int disputesOpened,  int disputesResolved,  double avgRating,  int ratingsCount,  int pushDelivered,  int pushOpened,  double pushOpenRate)?  $default,) {final _that = this;
switch (_that) {
case _AnalyticsKpis() when $default != null:
return $default(_that.jobsCreated,_that.leadsCreated,_that.leadsAccepted,_that.paymentsCapturedEur,_that.paymentsReleasedEur,_that.refundsEur,_that.chatMessages,_that.activePros,_that.activeCustomers,_that.newUsers,_that.disputesOpened,_that.disputesResolved,_that.avgRating,_that.ratingsCount,_that.pushDelivered,_that.pushOpened,_that.pushOpenRate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnalyticsKpis implements AnalyticsKpis {
  const _AnalyticsKpis({this.jobsCreated = 0, this.leadsCreated = 0, this.leadsAccepted = 0, this.paymentsCapturedEur = 0.0, this.paymentsReleasedEur = 0.0, this.refundsEur = 0.0, this.chatMessages = 0, this.activePros = 0, this.activeCustomers = 0, this.newUsers = 0, this.disputesOpened = 0, this.disputesResolved = 0, this.avgRating = 0.0, this.ratingsCount = 0, this.pushDelivered = 0, this.pushOpened = 0, this.pushOpenRate = 0.0});
  factory _AnalyticsKpis.fromJson(Map<String, dynamic> json) => _$AnalyticsKpisFromJson(json);

@override@JsonKey() final  int jobsCreated;
@override@JsonKey() final  int leadsCreated;
@override@JsonKey() final  int leadsAccepted;
@override@JsonKey() final  double paymentsCapturedEur;
@override@JsonKey() final  double paymentsReleasedEur;
@override@JsonKey() final  double refundsEur;
@override@JsonKey() final  int chatMessages;
@override@JsonKey() final  int activePros;
@override@JsonKey() final  int activeCustomers;
@override@JsonKey() final  int newUsers;
@override@JsonKey() final  int disputesOpened;
@override@JsonKey() final  int disputesResolved;
@override@JsonKey() final  double avgRating;
@override@JsonKey() final  int ratingsCount;
@override@JsonKey() final  int pushDelivered;
@override@JsonKey() final  int pushOpened;
@override@JsonKey() final  double pushOpenRate;

/// Create a copy of AnalyticsKpis
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalyticsKpisCopyWith<_AnalyticsKpis> get copyWith => __$AnalyticsKpisCopyWithImpl<_AnalyticsKpis>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnalyticsKpisToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsKpis&&(identical(other.jobsCreated, jobsCreated) || other.jobsCreated == jobsCreated)&&(identical(other.leadsCreated, leadsCreated) || other.leadsCreated == leadsCreated)&&(identical(other.leadsAccepted, leadsAccepted) || other.leadsAccepted == leadsAccepted)&&(identical(other.paymentsCapturedEur, paymentsCapturedEur) || other.paymentsCapturedEur == paymentsCapturedEur)&&(identical(other.paymentsReleasedEur, paymentsReleasedEur) || other.paymentsReleasedEur == paymentsReleasedEur)&&(identical(other.refundsEur, refundsEur) || other.refundsEur == refundsEur)&&(identical(other.chatMessages, chatMessages) || other.chatMessages == chatMessages)&&(identical(other.activePros, activePros) || other.activePros == activePros)&&(identical(other.activeCustomers, activeCustomers) || other.activeCustomers == activeCustomers)&&(identical(other.newUsers, newUsers) || other.newUsers == newUsers)&&(identical(other.disputesOpened, disputesOpened) || other.disputesOpened == disputesOpened)&&(identical(other.disputesResolved, disputesResolved) || other.disputesResolved == disputesResolved)&&(identical(other.avgRating, avgRating) || other.avgRating == avgRating)&&(identical(other.ratingsCount, ratingsCount) || other.ratingsCount == ratingsCount)&&(identical(other.pushDelivered, pushDelivered) || other.pushDelivered == pushDelivered)&&(identical(other.pushOpened, pushOpened) || other.pushOpened == pushOpened)&&(identical(other.pushOpenRate, pushOpenRate) || other.pushOpenRate == pushOpenRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,jobsCreated,leadsCreated,leadsAccepted,paymentsCapturedEur,paymentsReleasedEur,refundsEur,chatMessages,activePros,activeCustomers,newUsers,disputesOpened,disputesResolved,avgRating,ratingsCount,pushDelivered,pushOpened,pushOpenRate);

@override
String toString() {
  return 'AnalyticsKpis(jobsCreated: $jobsCreated, leadsCreated: $leadsCreated, leadsAccepted: $leadsAccepted, paymentsCapturedEur: $paymentsCapturedEur, paymentsReleasedEur: $paymentsReleasedEur, refundsEur: $refundsEur, chatMessages: $chatMessages, activePros: $activePros, activeCustomers: $activeCustomers, newUsers: $newUsers, disputesOpened: $disputesOpened, disputesResolved: $disputesResolved, avgRating: $avgRating, ratingsCount: $ratingsCount, pushDelivered: $pushDelivered, pushOpened: $pushOpened, pushOpenRate: $pushOpenRate)';
}


}

/// @nodoc
abstract mixin class _$AnalyticsKpisCopyWith<$Res> implements $AnalyticsKpisCopyWith<$Res> {
  factory _$AnalyticsKpisCopyWith(_AnalyticsKpis value, $Res Function(_AnalyticsKpis) _then) = __$AnalyticsKpisCopyWithImpl;
@override @useResult
$Res call({
 int jobsCreated, int leadsCreated, int leadsAccepted, double paymentsCapturedEur, double paymentsReleasedEur, double refundsEur, int chatMessages, int activePros, int activeCustomers, int newUsers, int disputesOpened, int disputesResolved, double avgRating, int ratingsCount, int pushDelivered, int pushOpened, double pushOpenRate
});




}
/// @nodoc
class __$AnalyticsKpisCopyWithImpl<$Res>
    implements _$AnalyticsKpisCopyWith<$Res> {
  __$AnalyticsKpisCopyWithImpl(this._self, this._then);

  final _AnalyticsKpis _self;
  final $Res Function(_AnalyticsKpis) _then;

/// Create a copy of AnalyticsKpis
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? jobsCreated = null,Object? leadsCreated = null,Object? leadsAccepted = null,Object? paymentsCapturedEur = null,Object? paymentsReleasedEur = null,Object? refundsEur = null,Object? chatMessages = null,Object? activePros = null,Object? activeCustomers = null,Object? newUsers = null,Object? disputesOpened = null,Object? disputesResolved = null,Object? avgRating = null,Object? ratingsCount = null,Object? pushDelivered = null,Object? pushOpened = null,Object? pushOpenRate = null,}) {
  return _then(_AnalyticsKpis(
jobsCreated: null == jobsCreated ? _self.jobsCreated : jobsCreated // ignore: cast_nullable_to_non_nullable
as int,leadsCreated: null == leadsCreated ? _self.leadsCreated : leadsCreated // ignore: cast_nullable_to_non_nullable
as int,leadsAccepted: null == leadsAccepted ? _self.leadsAccepted : leadsAccepted // ignore: cast_nullable_to_non_nullable
as int,paymentsCapturedEur: null == paymentsCapturedEur ? _self.paymentsCapturedEur : paymentsCapturedEur // ignore: cast_nullable_to_non_nullable
as double,paymentsReleasedEur: null == paymentsReleasedEur ? _self.paymentsReleasedEur : paymentsReleasedEur // ignore: cast_nullable_to_non_nullable
as double,refundsEur: null == refundsEur ? _self.refundsEur : refundsEur // ignore: cast_nullable_to_non_nullable
as double,chatMessages: null == chatMessages ? _self.chatMessages : chatMessages // ignore: cast_nullable_to_non_nullable
as int,activePros: null == activePros ? _self.activePros : activePros // ignore: cast_nullable_to_non_nullable
as int,activeCustomers: null == activeCustomers ? _self.activeCustomers : activeCustomers // ignore: cast_nullable_to_non_nullable
as int,newUsers: null == newUsers ? _self.newUsers : newUsers // ignore: cast_nullable_to_non_nullable
as int,disputesOpened: null == disputesOpened ? _self.disputesOpened : disputesOpened // ignore: cast_nullable_to_non_nullable
as int,disputesResolved: null == disputesResolved ? _self.disputesResolved : disputesResolved // ignore: cast_nullable_to_non_nullable
as int,avgRating: null == avgRating ? _self.avgRating : avgRating // ignore: cast_nullable_to_non_nullable
as double,ratingsCount: null == ratingsCount ? _self.ratingsCount : ratingsCount // ignore: cast_nullable_to_non_nullable
as int,pushDelivered: null == pushDelivered ? _self.pushDelivered : pushDelivered // ignore: cast_nullable_to_non_nullable
as int,pushOpened: null == pushOpened ? _self.pushOpened : pushOpened // ignore: cast_nullable_to_non_nullable
as int,pushOpenRate: null == pushOpenRate ? _self.pushOpenRate : pushOpenRate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$AnalyticsExportRequest {

 String get type;// 'events' | 'daily'
 String? get dateFrom; String? get dateTo;
/// Create a copy of AnalyticsExportRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsExportRequestCopyWith<AnalyticsExportRequest> get copyWith => _$AnalyticsExportRequestCopyWithImpl<AnalyticsExportRequest>(this as AnalyticsExportRequest, _$identity);

  /// Serializes this AnalyticsExportRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsExportRequest&&(identical(other.type, type) || other.type == type)&&(identical(other.dateFrom, dateFrom) || other.dateFrom == dateFrom)&&(identical(other.dateTo, dateTo) || other.dateTo == dateTo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,dateFrom,dateTo);

@override
String toString() {
  return 'AnalyticsExportRequest(type: $type, dateFrom: $dateFrom, dateTo: $dateTo)';
}


}

/// @nodoc
abstract mixin class $AnalyticsExportRequestCopyWith<$Res>  {
  factory $AnalyticsExportRequestCopyWith(AnalyticsExportRequest value, $Res Function(AnalyticsExportRequest) _then) = _$AnalyticsExportRequestCopyWithImpl;
@useResult
$Res call({
 String type, String? dateFrom, String? dateTo
});




}
/// @nodoc
class _$AnalyticsExportRequestCopyWithImpl<$Res>
    implements $AnalyticsExportRequestCopyWith<$Res> {
  _$AnalyticsExportRequestCopyWithImpl(this._self, this._then);

  final AnalyticsExportRequest _self;
  final $Res Function(AnalyticsExportRequest) _then;

/// Create a copy of AnalyticsExportRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? dateFrom = freezed,Object? dateTo = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,dateFrom: freezed == dateFrom ? _self.dateFrom : dateFrom // ignore: cast_nullable_to_non_nullable
as String?,dateTo: freezed == dateTo ? _self.dateTo : dateTo // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AnalyticsExportRequest].
extension AnalyticsExportRequestPatterns on AnalyticsExportRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalyticsExportRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalyticsExportRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalyticsExportRequest value)  $default,){
final _that = this;
switch (_that) {
case _AnalyticsExportRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalyticsExportRequest value)?  $default,){
final _that = this;
switch (_that) {
case _AnalyticsExportRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String? dateFrom,  String? dateTo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalyticsExportRequest() when $default != null:
return $default(_that.type,_that.dateFrom,_that.dateTo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String? dateFrom,  String? dateTo)  $default,) {final _that = this;
switch (_that) {
case _AnalyticsExportRequest():
return $default(_that.type,_that.dateFrom,_that.dateTo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String? dateFrom,  String? dateTo)?  $default,) {final _that = this;
switch (_that) {
case _AnalyticsExportRequest() when $default != null:
return $default(_that.type,_that.dateFrom,_that.dateTo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnalyticsExportRequest implements AnalyticsExportRequest {
  const _AnalyticsExportRequest({required this.type, this.dateFrom, this.dateTo});
  factory _AnalyticsExportRequest.fromJson(Map<String, dynamic> json) => _$AnalyticsExportRequestFromJson(json);

@override final  String type;
// 'events' | 'daily'
@override final  String? dateFrom;
@override final  String? dateTo;

/// Create a copy of AnalyticsExportRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalyticsExportRequestCopyWith<_AnalyticsExportRequest> get copyWith => __$AnalyticsExportRequestCopyWithImpl<_AnalyticsExportRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnalyticsExportRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsExportRequest&&(identical(other.type, type) || other.type == type)&&(identical(other.dateFrom, dateFrom) || other.dateFrom == dateFrom)&&(identical(other.dateTo, dateTo) || other.dateTo == dateTo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,dateFrom,dateTo);

@override
String toString() {
  return 'AnalyticsExportRequest(type: $type, dateFrom: $dateFrom, dateTo: $dateTo)';
}


}

/// @nodoc
abstract mixin class _$AnalyticsExportRequestCopyWith<$Res> implements $AnalyticsExportRequestCopyWith<$Res> {
  factory _$AnalyticsExportRequestCopyWith(_AnalyticsExportRequest value, $Res Function(_AnalyticsExportRequest) _then) = __$AnalyticsExportRequestCopyWithImpl;
@override @useResult
$Res call({
 String type, String? dateFrom, String? dateTo
});




}
/// @nodoc
class __$AnalyticsExportRequestCopyWithImpl<$Res>
    implements _$AnalyticsExportRequestCopyWith<$Res> {
  __$AnalyticsExportRequestCopyWithImpl(this._self, this._then);

  final _AnalyticsExportRequest _self;
  final $Res Function(_AnalyticsExportRequest) _then;

/// Create a copy of AnalyticsExportRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? dateFrom = freezed,Object? dateTo = freezed,}) {
  return _then(_AnalyticsExportRequest(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,dateFrom: freezed == dateFrom ? _self.dateFrom : dateFrom // ignore: cast_nullable_to_non_nullable
as String?,dateTo: freezed == dateTo ? _self.dateTo : dateTo // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AnalyticsContext {

 String get platform;// android|ios|web|server
 String get appVersion; String? get ipHash;// server-side only
 String? get uaHash;
/// Create a copy of AnalyticsContext
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsContextCopyWith<AnalyticsContext> get copyWith => _$AnalyticsContextCopyWithImpl<AnalyticsContext>(this as AnalyticsContext, _$identity);

  /// Serializes this AnalyticsContext to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsContext&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.ipHash, ipHash) || other.ipHash == ipHash)&&(identical(other.uaHash, uaHash) || other.uaHash == uaHash));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,platform,appVersion,ipHash,uaHash);

@override
String toString() {
  return 'AnalyticsContext(platform: $platform, appVersion: $appVersion, ipHash: $ipHash, uaHash: $uaHash)';
}


}

/// @nodoc
abstract mixin class $AnalyticsContextCopyWith<$Res>  {
  factory $AnalyticsContextCopyWith(AnalyticsContext value, $Res Function(AnalyticsContext) _then) = _$AnalyticsContextCopyWithImpl;
@useResult
$Res call({
 String platform, String appVersion, String? ipHash, String? uaHash
});




}
/// @nodoc
class _$AnalyticsContextCopyWithImpl<$Res>
    implements $AnalyticsContextCopyWith<$Res> {
  _$AnalyticsContextCopyWithImpl(this._self, this._then);

  final AnalyticsContext _self;
  final $Res Function(AnalyticsContext) _then;

/// Create a copy of AnalyticsContext
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? platform = null,Object? appVersion = null,Object? ipHash = freezed,Object? uaHash = freezed,}) {
  return _then(_self.copyWith(
platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,ipHash: freezed == ipHash ? _self.ipHash : ipHash // ignore: cast_nullable_to_non_nullable
as String?,uaHash: freezed == uaHash ? _self.uaHash : uaHash // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AnalyticsContext].
extension AnalyticsContextPatterns on AnalyticsContext {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalyticsContext value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalyticsContext() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalyticsContext value)  $default,){
final _that = this;
switch (_that) {
case _AnalyticsContext():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalyticsContext value)?  $default,){
final _that = this;
switch (_that) {
case _AnalyticsContext() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String platform,  String appVersion,  String? ipHash,  String? uaHash)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalyticsContext() when $default != null:
return $default(_that.platform,_that.appVersion,_that.ipHash,_that.uaHash);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String platform,  String appVersion,  String? ipHash,  String? uaHash)  $default,) {final _that = this;
switch (_that) {
case _AnalyticsContext():
return $default(_that.platform,_that.appVersion,_that.ipHash,_that.uaHash);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String platform,  String appVersion,  String? ipHash,  String? uaHash)?  $default,) {final _that = this;
switch (_that) {
case _AnalyticsContext() when $default != null:
return $default(_that.platform,_that.appVersion,_that.ipHash,_that.uaHash);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnalyticsContext implements AnalyticsContext {
  const _AnalyticsContext({required this.platform, required this.appVersion, this.ipHash, this.uaHash});
  factory _AnalyticsContext.fromJson(Map<String, dynamic> json) => _$AnalyticsContextFromJson(json);

@override final  String platform;
// android|ios|web|server
@override final  String appVersion;
@override final  String? ipHash;
// server-side only
@override final  String? uaHash;

/// Create a copy of AnalyticsContext
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalyticsContextCopyWith<_AnalyticsContext> get copyWith => __$AnalyticsContextCopyWithImpl<_AnalyticsContext>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnalyticsContextToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsContext&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.ipHash, ipHash) || other.ipHash == ipHash)&&(identical(other.uaHash, uaHash) || other.uaHash == uaHash));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,platform,appVersion,ipHash,uaHash);

@override
String toString() {
  return 'AnalyticsContext(platform: $platform, appVersion: $appVersion, ipHash: $ipHash, uaHash: $uaHash)';
}


}

/// @nodoc
abstract mixin class _$AnalyticsContextCopyWith<$Res> implements $AnalyticsContextCopyWith<$Res> {
  factory _$AnalyticsContextCopyWith(_AnalyticsContext value, $Res Function(_AnalyticsContext) _then) = __$AnalyticsContextCopyWithImpl;
@override @useResult
$Res call({
 String platform, String appVersion, String? ipHash, String? uaHash
});




}
/// @nodoc
class __$AnalyticsContextCopyWithImpl<$Res>
    implements _$AnalyticsContextCopyWith<$Res> {
  __$AnalyticsContextCopyWithImpl(this._self, this._then);

  final _AnalyticsContext _self;
  final $Res Function(_AnalyticsContext) _then;

/// Create a copy of AnalyticsContext
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? platform = null,Object? appVersion = null,Object? ipHash = freezed,Object? uaHash = freezed,}) {
  return _then(_AnalyticsContext(
platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,appVersion: null == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String,ipHash: freezed == ipHash ? _self.ipHash : ipHash // ignore: cast_nullable_to_non_nullable
as String?,uaHash: freezed == uaHash ? _self.uaHash : uaHash // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationPreferences {

 bool get leadNew; bool get leadStatus; bool get jobAssigned; bool get jobReminder24h; bool get jobReminder1h; bool get payment; bool get dispute; bool get inAppOnly; QuietHours get quietHours;
/// Create a copy of NotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationPreferencesCopyWith<NotificationPreferences> get copyWith => _$NotificationPreferencesCopyWithImpl<NotificationPreferences>(this as NotificationPreferences, _$identity);

  /// Serializes this NotificationPreferences to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationPreferences&&(identical(other.leadNew, leadNew) || other.leadNew == leadNew)&&(identical(other.leadStatus, leadStatus) || other.leadStatus == leadStatus)&&(identical(other.jobAssigned, jobAssigned) || other.jobAssigned == jobAssigned)&&(identical(other.jobReminder24h, jobReminder24h) || other.jobReminder24h == jobReminder24h)&&(identical(other.jobReminder1h, jobReminder1h) || other.jobReminder1h == jobReminder1h)&&(identical(other.payment, payment) || other.payment == payment)&&(identical(other.dispute, dispute) || other.dispute == dispute)&&(identical(other.inAppOnly, inAppOnly) || other.inAppOnly == inAppOnly)&&(identical(other.quietHours, quietHours) || other.quietHours == quietHours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,leadNew,leadStatus,jobAssigned,jobReminder24h,jobReminder1h,payment,dispute,inAppOnly,quietHours);

@override
String toString() {
  return 'NotificationPreferences(leadNew: $leadNew, leadStatus: $leadStatus, jobAssigned: $jobAssigned, jobReminder24h: $jobReminder24h, jobReminder1h: $jobReminder1h, payment: $payment, dispute: $dispute, inAppOnly: $inAppOnly, quietHours: $quietHours)';
}


}

/// @nodoc
abstract mixin class $NotificationPreferencesCopyWith<$Res>  {
  factory $NotificationPreferencesCopyWith(NotificationPreferences value, $Res Function(NotificationPreferences) _then) = _$NotificationPreferencesCopyWithImpl;
@useResult
$Res call({
 bool leadNew, bool leadStatus, bool jobAssigned, bool jobReminder24h, bool jobReminder1h, bool payment, bool dispute, bool inAppOnly, QuietHours quietHours
});


$QuietHoursCopyWith<$Res> get quietHours;

}
/// @nodoc
class _$NotificationPreferencesCopyWithImpl<$Res>
    implements $NotificationPreferencesCopyWith<$Res> {
  _$NotificationPreferencesCopyWithImpl(this._self, this._then);

  final NotificationPreferences _self;
  final $Res Function(NotificationPreferences) _then;

/// Create a copy of NotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? leadNew = null,Object? leadStatus = null,Object? jobAssigned = null,Object? jobReminder24h = null,Object? jobReminder1h = null,Object? payment = null,Object? dispute = null,Object? inAppOnly = null,Object? quietHours = null,}) {
  return _then(_self.copyWith(
leadNew: null == leadNew ? _self.leadNew : leadNew // ignore: cast_nullable_to_non_nullable
as bool,leadStatus: null == leadStatus ? _self.leadStatus : leadStatus // ignore: cast_nullable_to_non_nullable
as bool,jobAssigned: null == jobAssigned ? _self.jobAssigned : jobAssigned // ignore: cast_nullable_to_non_nullable
as bool,jobReminder24h: null == jobReminder24h ? _self.jobReminder24h : jobReminder24h // ignore: cast_nullable_to_non_nullable
as bool,jobReminder1h: null == jobReminder1h ? _self.jobReminder1h : jobReminder1h // ignore: cast_nullable_to_non_nullable
as bool,payment: null == payment ? _self.payment : payment // ignore: cast_nullable_to_non_nullable
as bool,dispute: null == dispute ? _self.dispute : dispute // ignore: cast_nullable_to_non_nullable
as bool,inAppOnly: null == inAppOnly ? _self.inAppOnly : inAppOnly // ignore: cast_nullable_to_non_nullable
as bool,quietHours: null == quietHours ? _self.quietHours : quietHours // ignore: cast_nullable_to_non_nullable
as QuietHours,
  ));
}
/// Create a copy of NotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuietHoursCopyWith<$Res> get quietHours {
  
  return $QuietHoursCopyWith<$Res>(_self.quietHours, (value) {
    return _then(_self.copyWith(quietHours: value));
  });
}
}


/// Adds pattern-matching-related methods to [NotificationPreferences].
extension NotificationPreferencesPatterns on NotificationPreferences {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationPreferences value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationPreferences() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationPreferences value)  $default,){
final _that = this;
switch (_that) {
case _NotificationPreferences():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationPreferences value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationPreferences() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool leadNew,  bool leadStatus,  bool jobAssigned,  bool jobReminder24h,  bool jobReminder1h,  bool payment,  bool dispute,  bool inAppOnly,  QuietHours quietHours)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationPreferences() when $default != null:
return $default(_that.leadNew,_that.leadStatus,_that.jobAssigned,_that.jobReminder24h,_that.jobReminder1h,_that.payment,_that.dispute,_that.inAppOnly,_that.quietHours);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool leadNew,  bool leadStatus,  bool jobAssigned,  bool jobReminder24h,  bool jobReminder1h,  bool payment,  bool dispute,  bool inAppOnly,  QuietHours quietHours)  $default,) {final _that = this;
switch (_that) {
case _NotificationPreferences():
return $default(_that.leadNew,_that.leadStatus,_that.jobAssigned,_that.jobReminder24h,_that.jobReminder1h,_that.payment,_that.dispute,_that.inAppOnly,_that.quietHours);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool leadNew,  bool leadStatus,  bool jobAssigned,  bool jobReminder24h,  bool jobReminder1h,  bool payment,  bool dispute,  bool inAppOnly,  QuietHours quietHours)?  $default,) {final _that = this;
switch (_that) {
case _NotificationPreferences() when $default != null:
return $default(_that.leadNew,_that.leadStatus,_that.jobAssigned,_that.jobReminder24h,_that.jobReminder1h,_that.payment,_that.dispute,_that.inAppOnly,_that.quietHours);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationPreferences extends NotificationPreferences {
  const _NotificationPreferences({this.leadNew = true, this.leadStatus = true, this.jobAssigned = true, this.jobReminder24h = true, this.jobReminder1h = true, this.payment = true, this.dispute = true, this.inAppOnly = false, this.quietHours = const QuietHours()}): super._();
  factory _NotificationPreferences.fromJson(Map<String, dynamic> json) => _$NotificationPreferencesFromJson(json);

@override@JsonKey() final  bool leadNew;
@override@JsonKey() final  bool leadStatus;
@override@JsonKey() final  bool jobAssigned;
@override@JsonKey() final  bool jobReminder24h;
@override@JsonKey() final  bool jobReminder1h;
@override@JsonKey() final  bool payment;
@override@JsonKey() final  bool dispute;
@override@JsonKey() final  bool inAppOnly;
@override@JsonKey() final  QuietHours quietHours;

/// Create a copy of NotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationPreferencesCopyWith<_NotificationPreferences> get copyWith => __$NotificationPreferencesCopyWithImpl<_NotificationPreferences>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationPreferencesToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationPreferences&&(identical(other.leadNew, leadNew) || other.leadNew == leadNew)&&(identical(other.leadStatus, leadStatus) || other.leadStatus == leadStatus)&&(identical(other.jobAssigned, jobAssigned) || other.jobAssigned == jobAssigned)&&(identical(other.jobReminder24h, jobReminder24h) || other.jobReminder24h == jobReminder24h)&&(identical(other.jobReminder1h, jobReminder1h) || other.jobReminder1h == jobReminder1h)&&(identical(other.payment, payment) || other.payment == payment)&&(identical(other.dispute, dispute) || other.dispute == dispute)&&(identical(other.inAppOnly, inAppOnly) || other.inAppOnly == inAppOnly)&&(identical(other.quietHours, quietHours) || other.quietHours == quietHours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,leadNew,leadStatus,jobAssigned,jobReminder24h,jobReminder1h,payment,dispute,inAppOnly,quietHours);

@override
String toString() {
  return 'NotificationPreferences(leadNew: $leadNew, leadStatus: $leadStatus, jobAssigned: $jobAssigned, jobReminder24h: $jobReminder24h, jobReminder1h: $jobReminder1h, payment: $payment, dispute: $dispute, inAppOnly: $inAppOnly, quietHours: $quietHours)';
}


}

/// @nodoc
abstract mixin class _$NotificationPreferencesCopyWith<$Res> implements $NotificationPreferencesCopyWith<$Res> {
  factory _$NotificationPreferencesCopyWith(_NotificationPreferences value, $Res Function(_NotificationPreferences) _then) = __$NotificationPreferencesCopyWithImpl;
@override @useResult
$Res call({
 bool leadNew, bool leadStatus, bool jobAssigned, bool jobReminder24h, bool jobReminder1h, bool payment, bool dispute, bool inAppOnly, QuietHours quietHours
});


@override $QuietHoursCopyWith<$Res> get quietHours;

}
/// @nodoc
class __$NotificationPreferencesCopyWithImpl<$Res>
    implements _$NotificationPreferencesCopyWith<$Res> {
  __$NotificationPreferencesCopyWithImpl(this._self, this._then);

  final _NotificationPreferences _self;
  final $Res Function(_NotificationPreferences) _then;

/// Create a copy of NotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? leadNew = null,Object? leadStatus = null,Object? jobAssigned = null,Object? jobReminder24h = null,Object? jobReminder1h = null,Object? payment = null,Object? dispute = null,Object? inAppOnly = null,Object? quietHours = null,}) {
  return _then(_NotificationPreferences(
leadNew: null == leadNew ? _self.leadNew : leadNew // ignore: cast_nullable_to_non_nullable
as bool,leadStatus: null == leadStatus ? _self.leadStatus : leadStatus // ignore: cast_nullable_to_non_nullable
as bool,jobAssigned: null == jobAssigned ? _self.jobAssigned : jobAssigned // ignore: cast_nullable_to_non_nullable
as bool,jobReminder24h: null == jobReminder24h ? _self.jobReminder24h : jobReminder24h // ignore: cast_nullable_to_non_nullable
as bool,jobReminder1h: null == jobReminder1h ? _self.jobReminder1h : jobReminder1h // ignore: cast_nullable_to_non_nullable
as bool,payment: null == payment ? _self.payment : payment // ignore: cast_nullable_to_non_nullable
as bool,dispute: null == dispute ? _self.dispute : dispute // ignore: cast_nullable_to_non_nullable
as bool,inAppOnly: null == inAppOnly ? _self.inAppOnly : inAppOnly // ignore: cast_nullable_to_non_nullable
as bool,quietHours: null == quietHours ? _self.quietHours : quietHours // ignore: cast_nullable_to_non_nullable
as QuietHours,
  ));
}

/// Create a copy of NotificationPreferences
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$QuietHoursCopyWith<$Res> get quietHours {
  
  return $QuietHoursCopyWith<$Res>(_self.quietHours, (value) {
    return _then(_self.copyWith(quietHours: value));
  });
}
}


/// @nodoc
mixin _$QuietHours {

 String get start; String get end; String get timezone;
/// Create a copy of QuietHours
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuietHoursCopyWith<QuietHours> get copyWith => _$QuietHoursCopyWithImpl<QuietHours>(this as QuietHours, _$identity);

  /// Serializes this QuietHours to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuietHours&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.timezone, timezone) || other.timezone == timezone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,start,end,timezone);

@override
String toString() {
  return 'QuietHours(start: $start, end: $end, timezone: $timezone)';
}


}

/// @nodoc
abstract mixin class $QuietHoursCopyWith<$Res>  {
  factory $QuietHoursCopyWith(QuietHours value, $Res Function(QuietHours) _then) = _$QuietHoursCopyWithImpl;
@useResult
$Res call({
 String start, String end, String timezone
});




}
/// @nodoc
class _$QuietHoursCopyWithImpl<$Res>
    implements $QuietHoursCopyWith<$Res> {
  _$QuietHoursCopyWithImpl(this._self, this._then);

  final QuietHours _self;
  final $Res Function(QuietHours) _then;

/// Create a copy of QuietHours
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? start = null,Object? end = null,Object? timezone = null,}) {
  return _then(_self.copyWith(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as String,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [QuietHours].
extension QuietHoursPatterns on QuietHours {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuietHours value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuietHours() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuietHours value)  $default,){
final _that = this;
switch (_that) {
case _QuietHours():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuietHours value)?  $default,){
final _that = this;
switch (_that) {
case _QuietHours() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String start,  String end,  String timezone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuietHours() when $default != null:
return $default(_that.start,_that.end,_that.timezone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String start,  String end,  String timezone)  $default,) {final _that = this;
switch (_that) {
case _QuietHours():
return $default(_that.start,_that.end,_that.timezone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String start,  String end,  String timezone)?  $default,) {final _that = this;
switch (_that) {
case _QuietHours() when $default != null:
return $default(_that.start,_that.end,_that.timezone);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuietHours implements QuietHours {
  const _QuietHours({this.start = '22:00', this.end = '07:00', this.timezone = 'Atlantic/Madeira'});
  factory _QuietHours.fromJson(Map<String, dynamic> json) => _$QuietHoursFromJson(json);

@override@JsonKey() final  String start;
@override@JsonKey() final  String end;
@override@JsonKey() final  String timezone;

/// Create a copy of QuietHours
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuietHoursCopyWith<_QuietHours> get copyWith => __$QuietHoursCopyWithImpl<_QuietHours>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuietHoursToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuietHours&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.timezone, timezone) || other.timezone == timezone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,start,end,timezone);

@override
String toString() {
  return 'QuietHours(start: $start, end: $end, timezone: $timezone)';
}


}

/// @nodoc
abstract mixin class _$QuietHoursCopyWith<$Res> implements $QuietHoursCopyWith<$Res> {
  factory _$QuietHoursCopyWith(_QuietHours value, $Res Function(_QuietHours) _then) = __$QuietHoursCopyWithImpl;
@override @useResult
$Res call({
 String start, String end, String timezone
});




}
/// @nodoc
class __$QuietHoursCopyWithImpl<$Res>
    implements _$QuietHoursCopyWith<$Res> {
  __$QuietHoursCopyWithImpl(this._self, this._then);

  final _QuietHours _self;
  final $Res Function(_QuietHours) _then;

/// Create a copy of QuietHours
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? start = null,Object? end = null,Object? timezone = null,}) {
  return _then(_QuietHours(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as String,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AppNotification {

 String get firestoreId; String get uid; NotificationType get type; String get title; String get body; Map<String, dynamic> get data; bool get read; DateTime get createdAt;
/// Create a copy of AppNotification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppNotificationCopyWith<AppNotification> get copyWith => _$AppNotificationCopyWithImpl<AppNotification>(this as AppNotification, _$identity);

  /// Serializes this AppNotification to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppNotification&&(identical(other.firestoreId, firestoreId) || other.firestoreId == firestoreId)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.read, read) || other.read == read)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,firestoreId,uid,type,title,body,const DeepCollectionEquality().hash(data),read,createdAt);

@override
String toString() {
  return 'AppNotification(firestoreId: $firestoreId, uid: $uid, type: $type, title: $title, body: $body, data: $data, read: $read, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $AppNotificationCopyWith<$Res>  {
  factory $AppNotificationCopyWith(AppNotification value, $Res Function(AppNotification) _then) = _$AppNotificationCopyWithImpl;
@useResult
$Res call({
 String firestoreId, String uid, NotificationType type, String title, String body, Map<String, dynamic> data, bool read, DateTime createdAt
});




}
/// @nodoc
class _$AppNotificationCopyWithImpl<$Res>
    implements $AppNotificationCopyWith<$Res> {
  _$AppNotificationCopyWithImpl(this._self, this._then);

  final AppNotification _self;
  final $Res Function(AppNotification) _then;

/// Create a copy of AppNotification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? firestoreId = null,Object? uid = null,Object? type = null,Object? title = null,Object? body = null,Object? data = null,Object? read = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
firestoreId: null == firestoreId ? _self.firestoreId : firestoreId // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as NotificationType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,read: null == read ? _self.read : read // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AppNotification].
extension AppNotificationPatterns on AppNotification {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppNotification value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppNotification() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppNotification value)  $default,){
final _that = this;
switch (_that) {
case _AppNotification():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppNotification value)?  $default,){
final _that = this;
switch (_that) {
case _AppNotification() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String firestoreId,  String uid,  NotificationType type,  String title,  String body,  Map<String, dynamic> data,  bool read,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppNotification() when $default != null:
return $default(_that.firestoreId,_that.uid,_that.type,_that.title,_that.body,_that.data,_that.read,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String firestoreId,  String uid,  NotificationType type,  String title,  String body,  Map<String, dynamic> data,  bool read,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _AppNotification():
return $default(_that.firestoreId,_that.uid,_that.type,_that.title,_that.body,_that.data,_that.read,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String firestoreId,  String uid,  NotificationType type,  String title,  String body,  Map<String, dynamic> data,  bool read,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AppNotification() when $default != null:
return $default(_that.firestoreId,_that.uid,_that.type,_that.title,_that.body,_that.data,_that.read,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppNotification extends AppNotification {
  const _AppNotification({required this.firestoreId, required this.uid, required this.type, required this.title, required this.body, final  Map<String, dynamic> data = const {}, this.read = false, required this.createdAt}): _data = data,super._();
  factory _AppNotification.fromJson(Map<String, dynamic> json) => _$AppNotificationFromJson(json);

@override final  String firestoreId;
@override final  String uid;
@override final  NotificationType type;
@override final  String title;
@override final  String body;
 final  Map<String, dynamic> _data;
@override@JsonKey() Map<String, dynamic> get data {
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_data);
}

@override@JsonKey() final  bool read;
@override final  DateTime createdAt;

/// Create a copy of AppNotification
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppNotificationCopyWith<_AppNotification> get copyWith => __$AppNotificationCopyWithImpl<_AppNotification>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppNotificationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppNotification&&(identical(other.firestoreId, firestoreId) || other.firestoreId == firestoreId)&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.read, read) || other.read == read)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,firestoreId,uid,type,title,body,const DeepCollectionEquality().hash(_data),read,createdAt);

@override
String toString() {
  return 'AppNotification(firestoreId: $firestoreId, uid: $uid, type: $type, title: $title, body: $body, data: $data, read: $read, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AppNotificationCopyWith<$Res> implements $AppNotificationCopyWith<$Res> {
  factory _$AppNotificationCopyWith(_AppNotification value, $Res Function(_AppNotification) _then) = __$AppNotificationCopyWithImpl;
@override @useResult
$Res call({
 String firestoreId, String uid, NotificationType type, String title, String body, Map<String, dynamic> data, bool read, DateTime createdAt
});




}
/// @nodoc
class __$AppNotificationCopyWithImpl<$Res>
    implements _$AppNotificationCopyWith<$Res> {
  __$AppNotificationCopyWithImpl(this._self, this._then);

  final _AppNotification _self;
  final $Res Function(_AppNotification) _then;

/// Create a copy of AppNotification
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? firestoreId = null,Object? uid = null,Object? type = null,Object? title = null,Object? body = null,Object? data = null,Object? read = null,Object? createdAt = null,}) {
  return _then(_AppNotification(
firestoreId: null == firestoreId ? _self.firestoreId : firestoreId // ignore: cast_nullable_to_non_nullable
as String,uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as NotificationType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,read: null == read ? _self.read : read // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$NotificationRequest {

 String get uid; NotificationType get type; String get title; String get body; Map<String, dynamic> get data;
/// Create a copy of NotificationRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationRequestCopyWith<NotificationRequest> get copyWith => _$NotificationRequestCopyWithImpl<NotificationRequest>(this as NotificationRequest, _$identity);

  /// Serializes this NotificationRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationRequest&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other.data, data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,type,title,body,const DeepCollectionEquality().hash(data));

@override
String toString() {
  return 'NotificationRequest(uid: $uid, type: $type, title: $title, body: $body, data: $data)';
}


}

/// @nodoc
abstract mixin class $NotificationRequestCopyWith<$Res>  {
  factory $NotificationRequestCopyWith(NotificationRequest value, $Res Function(NotificationRequest) _then) = _$NotificationRequestCopyWithImpl;
@useResult
$Res call({
 String uid, NotificationType type, String title, String body, Map<String, dynamic> data
});




}
/// @nodoc
class _$NotificationRequestCopyWithImpl<$Res>
    implements $NotificationRequestCopyWith<$Res> {
  _$NotificationRequestCopyWithImpl(this._self, this._then);

  final NotificationRequest _self;
  final $Res Function(NotificationRequest) _then;

/// Create a copy of NotificationRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? type = null,Object? title = null,Object? body = null,Object? data = null,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as NotificationType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationRequest].
extension NotificationRequestPatterns on NotificationRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationRequest value)  $default,){
final _that = this;
switch (_that) {
case _NotificationRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationRequest value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  NotificationType type,  String title,  String body,  Map<String, dynamic> data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationRequest() when $default != null:
return $default(_that.uid,_that.type,_that.title,_that.body,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  NotificationType type,  String title,  String body,  Map<String, dynamic> data)  $default,) {final _that = this;
switch (_that) {
case _NotificationRequest():
return $default(_that.uid,_that.type,_that.title,_that.body,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  NotificationType type,  String title,  String body,  Map<String, dynamic> data)?  $default,) {final _that = this;
switch (_that) {
case _NotificationRequest() when $default != null:
return $default(_that.uid,_that.type,_that.title,_that.body,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NotificationRequest implements NotificationRequest {
  const _NotificationRequest({required this.uid, required this.type, required this.title, required this.body, final  Map<String, dynamic> data = const {}}): _data = data;
  factory _NotificationRequest.fromJson(Map<String, dynamic> json) => _$NotificationRequestFromJson(json);

@override final  String uid;
@override final  NotificationType type;
@override final  String title;
@override final  String body;
 final  Map<String, dynamic> _data;
@override@JsonKey() Map<String, dynamic> get data {
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_data);
}


/// Create a copy of NotificationRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationRequestCopyWith<_NotificationRequest> get copyWith => __$NotificationRequestCopyWithImpl<_NotificationRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NotificationRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationRequest&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other._data, _data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,type,title,body,const DeepCollectionEquality().hash(_data));

@override
String toString() {
  return 'NotificationRequest(uid: $uid, type: $type, title: $title, body: $body, data: $data)';
}


}

/// @nodoc
abstract mixin class _$NotificationRequestCopyWith<$Res> implements $NotificationRequestCopyWith<$Res> {
  factory _$NotificationRequestCopyWith(_NotificationRequest value, $Res Function(_NotificationRequest) _then) = __$NotificationRequestCopyWithImpl;
@override @useResult
$Res call({
 String uid, NotificationType type, String title, String body, Map<String, dynamic> data
});




}
/// @nodoc
class __$NotificationRequestCopyWithImpl<$Res>
    implements _$NotificationRequestCopyWith<$Res> {
  __$NotificationRequestCopyWithImpl(this._self, this._then);

  final _NotificationRequest _self;
  final $Res Function(_NotificationRequest) _then;

/// Create a copy of NotificationRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? type = null,Object? title = null,Object? body = null,Object? data = null,}) {
  return _then(_NotificationRequest(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as NotificationType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}


/// @nodoc
mixin _$FCMMessage {

 String get token; String get title; String get body; Map<String, String> get data; String? get imageUrl;
/// Create a copy of FCMMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FCMMessageCopyWith<FCMMessage> get copyWith => _$FCMMessageCopyWithImpl<FCMMessage>(this as FCMMessage, _$identity);

  /// Serializes this FCMMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FCMMessage&&(identical(other.token, token) || other.token == token)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other.data, data)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,title,body,const DeepCollectionEquality().hash(data),imageUrl);

@override
String toString() {
  return 'FCMMessage(token: $token, title: $title, body: $body, data: $data, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $FCMMessageCopyWith<$Res>  {
  factory $FCMMessageCopyWith(FCMMessage value, $Res Function(FCMMessage) _then) = _$FCMMessageCopyWithImpl;
@useResult
$Res call({
 String token, String title, String body, Map<String, String> data, String? imageUrl
});




}
/// @nodoc
class _$FCMMessageCopyWithImpl<$Res>
    implements $FCMMessageCopyWith<$Res> {
  _$FCMMessageCopyWithImpl(this._self, this._then);

  final FCMMessage _self;
  final $Res Function(FCMMessage) _then;

/// Create a copy of FCMMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? token = null,Object? title = null,Object? body = null,Object? data = null,Object? imageUrl = freezed,}) {
  return _then(_self.copyWith(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, String>,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [FCMMessage].
extension FCMMessagePatterns on FCMMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FCMMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FCMMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FCMMessage value)  $default,){
final _that = this;
switch (_that) {
case _FCMMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FCMMessage value)?  $default,){
final _that = this;
switch (_that) {
case _FCMMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String token,  String title,  String body,  Map<String, String> data,  String? imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FCMMessage() when $default != null:
return $default(_that.token,_that.title,_that.body,_that.data,_that.imageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String token,  String title,  String body,  Map<String, String> data,  String? imageUrl)  $default,) {final _that = this;
switch (_that) {
case _FCMMessage():
return $default(_that.token,_that.title,_that.body,_that.data,_that.imageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String token,  String title,  String body,  Map<String, String> data,  String? imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _FCMMessage() when $default != null:
return $default(_that.token,_that.title,_that.body,_that.data,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FCMMessage implements FCMMessage {
  const _FCMMessage({required this.token, required this.title, required this.body, final  Map<String, String> data = const {}, this.imageUrl}): _data = data;
  factory _FCMMessage.fromJson(Map<String, dynamic> json) => _$FCMMessageFromJson(json);

@override final  String token;
@override final  String title;
@override final  String body;
 final  Map<String, String> _data;
@override@JsonKey() Map<String, String> get data {
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_data);
}

@override final  String? imageUrl;

/// Create a copy of FCMMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FCMMessageCopyWith<_FCMMessage> get copyWith => __$FCMMessageCopyWithImpl<_FCMMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FCMMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FCMMessage&&(identical(other.token, token) || other.token == token)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other._data, _data)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,title,body,const DeepCollectionEquality().hash(_data),imageUrl);

@override
String toString() {
  return 'FCMMessage(token: $token, title: $title, body: $body, data: $data, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$FCMMessageCopyWith<$Res> implements $FCMMessageCopyWith<$Res> {
  factory _$FCMMessageCopyWith(_FCMMessage value, $Res Function(_FCMMessage) _then) = __$FCMMessageCopyWithImpl;
@override @useResult
$Res call({
 String token, String title, String body, Map<String, String> data, String? imageUrl
});




}
/// @nodoc
class __$FCMMessageCopyWithImpl<$Res>
    implements _$FCMMessageCopyWith<$Res> {
  __$FCMMessageCopyWithImpl(this._self, this._then);

  final _FCMMessage _self;
  final $Res Function(_FCMMessage) _then;

/// Create a copy of FCMMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? token = null,Object? title = null,Object? body = null,Object? data = null,Object? imageUrl = freezed,}) {
  return _then(_FCMMessage(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, String>,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

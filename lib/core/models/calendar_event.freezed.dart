// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calendar_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CalendarLocation {

 double get lat; double get lng; String get address;
/// Create a copy of CalendarLocation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalendarLocationCopyWith<CalendarLocation> get copyWith => _$CalendarLocationCopyWithImpl<CalendarLocation>(this as CalendarLocation, _$identity);

  /// Serializes this CalendarLocation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalendarLocation&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.address, address) || other.address == address));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,lng,address);

@override
String toString() {
  return 'CalendarLocation(lat: $lat, lng: $lng, address: $address)';
}


}

/// @nodoc
abstract mixin class $CalendarLocationCopyWith<$Res>  {
  factory $CalendarLocationCopyWith(CalendarLocation value, $Res Function(CalendarLocation) _then) = _$CalendarLocationCopyWithImpl;
@useResult
$Res call({
 double lat, double lng, String address
});




}
/// @nodoc
class _$CalendarLocationCopyWithImpl<$Res>
    implements $CalendarLocationCopyWith<$Res> {
  _$CalendarLocationCopyWithImpl(this._self, this._then);

  final CalendarLocation _self;
  final $Res Function(CalendarLocation) _then;

/// Create a copy of CalendarLocation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lat = null,Object? lng = null,Object? address = null,}) {
  return _then(_self.copyWith(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CalendarLocation].
extension CalendarLocationPatterns on CalendarLocation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalendarLocation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalendarLocation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalendarLocation value)  $default,){
final _that = this;
switch (_that) {
case _CalendarLocation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalendarLocation value)?  $default,){
final _that = this;
switch (_that) {
case _CalendarLocation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double lat,  double lng,  String address)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CalendarLocation() when $default != null:
return $default(_that.lat,_that.lng,_that.address);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double lat,  double lng,  String address)  $default,) {final _that = this;
switch (_that) {
case _CalendarLocation():
return $default(_that.lat,_that.lng,_that.address);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double lat,  double lng,  String address)?  $default,) {final _that = this;
switch (_that) {
case _CalendarLocation() when $default != null:
return $default(_that.lat,_that.lng,_that.address);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CalendarLocation implements CalendarLocation {
  const _CalendarLocation({required this.lat, required this.lng, required this.address});
  factory _CalendarLocation.fromJson(Map<String, dynamic> json) => _$CalendarLocationFromJson(json);

@override final  double lat;
@override final  double lng;
@override final  String address;

/// Create a copy of CalendarLocation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalendarLocationCopyWith<_CalendarLocation> get copyWith => __$CalendarLocationCopyWithImpl<_CalendarLocation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CalendarLocationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalendarLocation&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.address, address) || other.address == address));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,lng,address);

@override
String toString() {
  return 'CalendarLocation(lat: $lat, lng: $lng, address: $address)';
}


}

/// @nodoc
abstract mixin class _$CalendarLocationCopyWith<$Res> implements $CalendarLocationCopyWith<$Res> {
  factory _$CalendarLocationCopyWith(_CalendarLocation value, $Res Function(_CalendarLocation) _then) = __$CalendarLocationCopyWithImpl;
@override @useResult
$Res call({
 double lat, double lng, String address
});




}
/// @nodoc
class __$CalendarLocationCopyWithImpl<$Res>
    implements _$CalendarLocationCopyWith<$Res> {
  __$CalendarLocationCopyWithImpl(this._self, this._then);

  final _CalendarLocation _self;
  final $Res Function(_CalendarLocation) _then;

/// Create a copy of CalendarLocation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lat = null,Object? lng = null,Object? address = null,}) {
  return _then(_CalendarLocation(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CalendarEvent {

 String? get id; String get ownerUid; EventType get type; String get title;// Event title/name
 String? get description;// Optional description
 DateTime get start; DateTime get end; String? get rrule;// RRULE string for recurring events
 CalendarLocation? get location; int get bufferBefore;// Minutes
 int get bufferAfter;// Minutes
 EventVisibility get visibility; String? get jobId;// Required for job events
 DateTime get createdAt; DateTime? get updatedAt;
/// Create a copy of CalendarEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalendarEventCopyWith<CalendarEvent> get copyWith => _$CalendarEventCopyWithImpl<CalendarEvent>(this as CalendarEvent, _$identity);

  /// Serializes this CalendarEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalendarEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerUid, ownerUid) || other.ownerUid == ownerUid)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.rrule, rrule) || other.rrule == rrule)&&(identical(other.location, location) || other.location == location)&&(identical(other.bufferBefore, bufferBefore) || other.bufferBefore == bufferBefore)&&(identical(other.bufferAfter, bufferAfter) || other.bufferAfter == bufferAfter)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerUid,type,title,description,start,end,rrule,location,bufferBefore,bufferAfter,visibility,jobId,createdAt,updatedAt);

@override
String toString() {
  return 'CalendarEvent(id: $id, ownerUid: $ownerUid, type: $type, title: $title, description: $description, start: $start, end: $end, rrule: $rrule, location: $location, bufferBefore: $bufferBefore, bufferAfter: $bufferAfter, visibility: $visibility, jobId: $jobId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $CalendarEventCopyWith<$Res>  {
  factory $CalendarEventCopyWith(CalendarEvent value, $Res Function(CalendarEvent) _then) = _$CalendarEventCopyWithImpl;
@useResult
$Res call({
 String? id, String ownerUid, EventType type, String title, String? description, DateTime start, DateTime end, String? rrule, CalendarLocation? location, int bufferBefore, int bufferAfter, EventVisibility visibility, String? jobId, DateTime createdAt, DateTime? updatedAt
});


$CalendarLocationCopyWith<$Res>? get location;

}
/// @nodoc
class _$CalendarEventCopyWithImpl<$Res>
    implements $CalendarEventCopyWith<$Res> {
  _$CalendarEventCopyWithImpl(this._self, this._then);

  final CalendarEvent _self;
  final $Res Function(CalendarEvent) _then;

/// Create a copy of CalendarEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? ownerUid = null,Object? type = null,Object? title = null,Object? description = freezed,Object? start = null,Object? end = null,Object? rrule = freezed,Object? location = freezed,Object? bufferBefore = null,Object? bufferAfter = null,Object? visibility = null,Object? jobId = freezed,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,ownerUid: null == ownerUid ? _self.ownerUid : ownerUid // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as EventType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,rrule: freezed == rrule ? _self.rrule : rrule // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as CalendarLocation?,bufferBefore: null == bufferBefore ? _self.bufferBefore : bufferBefore // ignore: cast_nullable_to_non_nullable
as int,bufferAfter: null == bufferAfter ? _self.bufferAfter : bufferAfter // ignore: cast_nullable_to_non_nullable
as int,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as EventVisibility,jobId: freezed == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of CalendarEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CalendarLocationCopyWith<$Res>? get location {
    if (_self.location == null) {
    return null;
  }

  return $CalendarLocationCopyWith<$Res>(_self.location!, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}


/// Adds pattern-matching-related methods to [CalendarEvent].
extension CalendarEventPatterns on CalendarEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalendarEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalendarEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalendarEvent value)  $default,){
final _that = this;
switch (_that) {
case _CalendarEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalendarEvent value)?  $default,){
final _that = this;
switch (_that) {
case _CalendarEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String ownerUid,  EventType type,  String title,  String? description,  DateTime start,  DateTime end,  String? rrule,  CalendarLocation? location,  int bufferBefore,  int bufferAfter,  EventVisibility visibility,  String? jobId,  DateTime createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CalendarEvent() when $default != null:
return $default(_that.id,_that.ownerUid,_that.type,_that.title,_that.description,_that.start,_that.end,_that.rrule,_that.location,_that.bufferBefore,_that.bufferAfter,_that.visibility,_that.jobId,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String ownerUid,  EventType type,  String title,  String? description,  DateTime start,  DateTime end,  String? rrule,  CalendarLocation? location,  int bufferBefore,  int bufferAfter,  EventVisibility visibility,  String? jobId,  DateTime createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _CalendarEvent():
return $default(_that.id,_that.ownerUid,_that.type,_that.title,_that.description,_that.start,_that.end,_that.rrule,_that.location,_that.bufferBefore,_that.bufferAfter,_that.visibility,_that.jobId,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String ownerUid,  EventType type,  String title,  String? description,  DateTime start,  DateTime end,  String? rrule,  CalendarLocation? location,  int bufferBefore,  int bufferAfter,  EventVisibility visibility,  String? jobId,  DateTime createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _CalendarEvent() when $default != null:
return $default(_that.id,_that.ownerUid,_that.type,_that.title,_that.description,_that.start,_that.end,_that.rrule,_that.location,_that.bufferBefore,_that.bufferAfter,_that.visibility,_that.jobId,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CalendarEvent implements CalendarEvent {
  const _CalendarEvent({this.id, required this.ownerUid, required this.type, this.title = '', this.description, required this.start, required this.end, this.rrule, this.location, this.bufferBefore = 0, this.bufferAfter = 0, this.visibility = EventVisibility.busy, this.jobId, required this.createdAt, this.updatedAt});
  factory _CalendarEvent.fromJson(Map<String, dynamic> json) => _$CalendarEventFromJson(json);

@override final  String? id;
@override final  String ownerUid;
@override final  EventType type;
@override@JsonKey() final  String title;
// Event title/name
@override final  String? description;
// Optional description
@override final  DateTime start;
@override final  DateTime end;
@override final  String? rrule;
// RRULE string for recurring events
@override final  CalendarLocation? location;
@override@JsonKey() final  int bufferBefore;
// Minutes
@override@JsonKey() final  int bufferAfter;
// Minutes
@override@JsonKey() final  EventVisibility visibility;
@override final  String? jobId;
// Required for job events
@override final  DateTime createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of CalendarEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalendarEventCopyWith<_CalendarEvent> get copyWith => __$CalendarEventCopyWithImpl<_CalendarEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CalendarEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalendarEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.ownerUid, ownerUid) || other.ownerUid == ownerUid)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.rrule, rrule) || other.rrule == rrule)&&(identical(other.location, location) || other.location == location)&&(identical(other.bufferBefore, bufferBefore) || other.bufferBefore == bufferBefore)&&(identical(other.bufferAfter, bufferAfter) || other.bufferAfter == bufferAfter)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,ownerUid,type,title,description,start,end,rrule,location,bufferBefore,bufferAfter,visibility,jobId,createdAt,updatedAt);

@override
String toString() {
  return 'CalendarEvent(id: $id, ownerUid: $ownerUid, type: $type, title: $title, description: $description, start: $start, end: $end, rrule: $rrule, location: $location, bufferBefore: $bufferBefore, bufferAfter: $bufferAfter, visibility: $visibility, jobId: $jobId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CalendarEventCopyWith<$Res> implements $CalendarEventCopyWith<$Res> {
  factory _$CalendarEventCopyWith(_CalendarEvent value, $Res Function(_CalendarEvent) _then) = __$CalendarEventCopyWithImpl;
@override @useResult
$Res call({
 String? id, String ownerUid, EventType type, String title, String? description, DateTime start, DateTime end, String? rrule, CalendarLocation? location, int bufferBefore, int bufferAfter, EventVisibility visibility, String? jobId, DateTime createdAt, DateTime? updatedAt
});


@override $CalendarLocationCopyWith<$Res>? get location;

}
/// @nodoc
class __$CalendarEventCopyWithImpl<$Res>
    implements _$CalendarEventCopyWith<$Res> {
  __$CalendarEventCopyWithImpl(this._self, this._then);

  final _CalendarEvent _self;
  final $Res Function(_CalendarEvent) _then;

/// Create a copy of CalendarEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? ownerUid = null,Object? type = null,Object? title = null,Object? description = freezed,Object? start = null,Object? end = null,Object? rrule = freezed,Object? location = freezed,Object? bufferBefore = null,Object? bufferAfter = null,Object? visibility = null,Object? jobId = freezed,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_CalendarEvent(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,ownerUid: null == ownerUid ? _self.ownerUid : ownerUid // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as EventType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,rrule: freezed == rrule ? _self.rrule : rrule // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as CalendarLocation?,bufferBefore: null == bufferBefore ? _self.bufferBefore : bufferBefore // ignore: cast_nullable_to_non_nullable
as int,bufferAfter: null == bufferAfter ? _self.bufferAfter : bufferAfter // ignore: cast_nullable_to_non_nullable
as int,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as EventVisibility,jobId: freezed == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of CalendarEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CalendarLocationCopyWith<$Res>? get location {
    if (_self.location == null) {
    return null;
  }

  return $CalendarLocationCopyWith<$Res>(_self.location!, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}


/// @nodoc
mixin _$ConflictResult {

 bool get hasConflict; bool get isHard;// true = blocking, false = warning
 String? get message; CalendarConflictCode get code; CalendarEvent? get conflictingEvent; int? get missingMinutes;// How many minutes short for buffer/ETA
 int? get actualGapMinutes; int? get requiredGapMinutes;
/// Create a copy of ConflictResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConflictResultCopyWith<ConflictResult> get copyWith => _$ConflictResultCopyWithImpl<ConflictResult>(this as ConflictResult, _$identity);

  /// Serializes this ConflictResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConflictResult&&(identical(other.hasConflict, hasConflict) || other.hasConflict == hasConflict)&&(identical(other.isHard, isHard) || other.isHard == isHard)&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code)&&(identical(other.conflictingEvent, conflictingEvent) || other.conflictingEvent == conflictingEvent)&&(identical(other.missingMinutes, missingMinutes) || other.missingMinutes == missingMinutes)&&(identical(other.actualGapMinutes, actualGapMinutes) || other.actualGapMinutes == actualGapMinutes)&&(identical(other.requiredGapMinutes, requiredGapMinutes) || other.requiredGapMinutes == requiredGapMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hasConflict,isHard,message,code,conflictingEvent,missingMinutes,actualGapMinutes,requiredGapMinutes);

@override
String toString() {
  return 'ConflictResult(hasConflict: $hasConflict, isHard: $isHard, message: $message, code: $code, conflictingEvent: $conflictingEvent, missingMinutes: $missingMinutes, actualGapMinutes: $actualGapMinutes, requiredGapMinutes: $requiredGapMinutes)';
}


}

/// @nodoc
abstract mixin class $ConflictResultCopyWith<$Res>  {
  factory $ConflictResultCopyWith(ConflictResult value, $Res Function(ConflictResult) _then) = _$ConflictResultCopyWithImpl;
@useResult
$Res call({
 bool hasConflict, bool isHard, String? message, CalendarConflictCode code, CalendarEvent? conflictingEvent, int? missingMinutes, int? actualGapMinutes, int? requiredGapMinutes
});


$CalendarEventCopyWith<$Res>? get conflictingEvent;

}
/// @nodoc
class _$ConflictResultCopyWithImpl<$Res>
    implements $ConflictResultCopyWith<$Res> {
  _$ConflictResultCopyWithImpl(this._self, this._then);

  final ConflictResult _self;
  final $Res Function(ConflictResult) _then;

/// Create a copy of ConflictResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hasConflict = null,Object? isHard = null,Object? message = freezed,Object? code = null,Object? conflictingEvent = freezed,Object? missingMinutes = freezed,Object? actualGapMinutes = freezed,Object? requiredGapMinutes = freezed,}) {
  return _then(_self.copyWith(
hasConflict: null == hasConflict ? _self.hasConflict : hasConflict // ignore: cast_nullable_to_non_nullable
as bool,isHard: null == isHard ? _self.isHard : isHard // ignore: cast_nullable_to_non_nullable
as bool,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as CalendarConflictCode,conflictingEvent: freezed == conflictingEvent ? _self.conflictingEvent : conflictingEvent // ignore: cast_nullable_to_non_nullable
as CalendarEvent?,missingMinutes: freezed == missingMinutes ? _self.missingMinutes : missingMinutes // ignore: cast_nullable_to_non_nullable
as int?,actualGapMinutes: freezed == actualGapMinutes ? _self.actualGapMinutes : actualGapMinutes // ignore: cast_nullable_to_non_nullable
as int?,requiredGapMinutes: freezed == requiredGapMinutes ? _self.requiredGapMinutes : requiredGapMinutes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of ConflictResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CalendarEventCopyWith<$Res>? get conflictingEvent {
    if (_self.conflictingEvent == null) {
    return null;
  }

  return $CalendarEventCopyWith<$Res>(_self.conflictingEvent!, (value) {
    return _then(_self.copyWith(conflictingEvent: value));
  });
}
}


/// Adds pattern-matching-related methods to [ConflictResult].
extension ConflictResultPatterns on ConflictResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConflictResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConflictResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConflictResult value)  $default,){
final _that = this;
switch (_that) {
case _ConflictResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConflictResult value)?  $default,){
final _that = this;
switch (_that) {
case _ConflictResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool hasConflict,  bool isHard,  String? message,  CalendarConflictCode code,  CalendarEvent? conflictingEvent,  int? missingMinutes,  int? actualGapMinutes,  int? requiredGapMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConflictResult() when $default != null:
return $default(_that.hasConflict,_that.isHard,_that.message,_that.code,_that.conflictingEvent,_that.missingMinutes,_that.actualGapMinutes,_that.requiredGapMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool hasConflict,  bool isHard,  String? message,  CalendarConflictCode code,  CalendarEvent? conflictingEvent,  int? missingMinutes,  int? actualGapMinutes,  int? requiredGapMinutes)  $default,) {final _that = this;
switch (_that) {
case _ConflictResult():
return $default(_that.hasConflict,_that.isHard,_that.message,_that.code,_that.conflictingEvent,_that.missingMinutes,_that.actualGapMinutes,_that.requiredGapMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool hasConflict,  bool isHard,  String? message,  CalendarConflictCode code,  CalendarEvent? conflictingEvent,  int? missingMinutes,  int? actualGapMinutes,  int? requiredGapMinutes)?  $default,) {final _that = this;
switch (_that) {
case _ConflictResult() when $default != null:
return $default(_that.hasConflict,_that.isHard,_that.message,_that.code,_that.conflictingEvent,_that.missingMinutes,_that.actualGapMinutes,_that.requiredGapMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConflictResult implements ConflictResult {
  const _ConflictResult({required this.hasConflict, required this.isHard, this.message, this.code = CalendarConflictCode.unknown, this.conflictingEvent, this.missingMinutes, this.actualGapMinutes, this.requiredGapMinutes});
  factory _ConflictResult.fromJson(Map<String, dynamic> json) => _$ConflictResultFromJson(json);

@override final  bool hasConflict;
@override final  bool isHard;
// true = blocking, false = warning
@override final  String? message;
@override@JsonKey() final  CalendarConflictCode code;
@override final  CalendarEvent? conflictingEvent;
@override final  int? missingMinutes;
// How many minutes short for buffer/ETA
@override final  int? actualGapMinutes;
@override final  int? requiredGapMinutes;

/// Create a copy of ConflictResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConflictResultCopyWith<_ConflictResult> get copyWith => __$ConflictResultCopyWithImpl<_ConflictResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConflictResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConflictResult&&(identical(other.hasConflict, hasConflict) || other.hasConflict == hasConflict)&&(identical(other.isHard, isHard) || other.isHard == isHard)&&(identical(other.message, message) || other.message == message)&&(identical(other.code, code) || other.code == code)&&(identical(other.conflictingEvent, conflictingEvent) || other.conflictingEvent == conflictingEvent)&&(identical(other.missingMinutes, missingMinutes) || other.missingMinutes == missingMinutes)&&(identical(other.actualGapMinutes, actualGapMinutes) || other.actualGapMinutes == actualGapMinutes)&&(identical(other.requiredGapMinutes, requiredGapMinutes) || other.requiredGapMinutes == requiredGapMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hasConflict,isHard,message,code,conflictingEvent,missingMinutes,actualGapMinutes,requiredGapMinutes);

@override
String toString() {
  return 'ConflictResult(hasConflict: $hasConflict, isHard: $isHard, message: $message, code: $code, conflictingEvent: $conflictingEvent, missingMinutes: $missingMinutes, actualGapMinutes: $actualGapMinutes, requiredGapMinutes: $requiredGapMinutes)';
}


}

/// @nodoc
abstract mixin class _$ConflictResultCopyWith<$Res> implements $ConflictResultCopyWith<$Res> {
  factory _$ConflictResultCopyWith(_ConflictResult value, $Res Function(_ConflictResult) _then) = __$ConflictResultCopyWithImpl;
@override @useResult
$Res call({
 bool hasConflict, bool isHard, String? message, CalendarConflictCode code, CalendarEvent? conflictingEvent, int? missingMinutes, int? actualGapMinutes, int? requiredGapMinutes
});


@override $CalendarEventCopyWith<$Res>? get conflictingEvent;

}
/// @nodoc
class __$ConflictResultCopyWithImpl<$Res>
    implements _$ConflictResultCopyWith<$Res> {
  __$ConflictResultCopyWithImpl(this._self, this._then);

  final _ConflictResult _self;
  final $Res Function(_ConflictResult) _then;

/// Create a copy of ConflictResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hasConflict = null,Object? isHard = null,Object? message = freezed,Object? code = null,Object? conflictingEvent = freezed,Object? missingMinutes = freezed,Object? actualGapMinutes = freezed,Object? requiredGapMinutes = freezed,}) {
  return _then(_ConflictResult(
hasConflict: null == hasConflict ? _self.hasConflict : hasConflict // ignore: cast_nullable_to_non_nullable
as bool,isHard: null == isHard ? _self.isHard : isHard // ignore: cast_nullable_to_non_nullable
as bool,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as CalendarConflictCode,conflictingEvent: freezed == conflictingEvent ? _self.conflictingEvent : conflictingEvent // ignore: cast_nullable_to_non_nullable
as CalendarEvent?,missingMinutes: freezed == missingMinutes ? _self.missingMinutes : missingMinutes // ignore: cast_nullable_to_non_nullable
as int?,actualGapMinutes: freezed == actualGapMinutes ? _self.actualGapMinutes : actualGapMinutes // ignore: cast_nullable_to_non_nullable
as int?,requiredGapMinutes: freezed == requiredGapMinutes ? _self.requiredGapMinutes : requiredGapMinutes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of ConflictResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CalendarEventCopyWith<$Res>? get conflictingEvent {
    if (_self.conflictingEvent == null) {
    return null;
  }

  return $CalendarEventCopyWith<$Res>(_self.conflictingEvent!, (value) {
    return _then(_self.copyWith(conflictingEvent: value));
  });
}
}


/// @nodoc
mixin _$EtaRequest {

 CalendarLocation get origin; CalendarLocation get destination;
/// Create a copy of EtaRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EtaRequestCopyWith<EtaRequest> get copyWith => _$EtaRequestCopyWithImpl<EtaRequest>(this as EtaRequest, _$identity);

  /// Serializes this EtaRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EtaRequest&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.destination, destination) || other.destination == destination));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,origin,destination);

@override
String toString() {
  return 'EtaRequest(origin: $origin, destination: $destination)';
}


}

/// @nodoc
abstract mixin class $EtaRequestCopyWith<$Res>  {
  factory $EtaRequestCopyWith(EtaRequest value, $Res Function(EtaRequest) _then) = _$EtaRequestCopyWithImpl;
@useResult
$Res call({
 CalendarLocation origin, CalendarLocation destination
});


$CalendarLocationCopyWith<$Res> get origin;$CalendarLocationCopyWith<$Res> get destination;

}
/// @nodoc
class _$EtaRequestCopyWithImpl<$Res>
    implements $EtaRequestCopyWith<$Res> {
  _$EtaRequestCopyWithImpl(this._self, this._then);

  final EtaRequest _self;
  final $Res Function(EtaRequest) _then;

/// Create a copy of EtaRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? origin = null,Object? destination = null,}) {
  return _then(_self.copyWith(
origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as CalendarLocation,destination: null == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as CalendarLocation,
  ));
}
/// Create a copy of EtaRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CalendarLocationCopyWith<$Res> get origin {
  
  return $CalendarLocationCopyWith<$Res>(_self.origin, (value) {
    return _then(_self.copyWith(origin: value));
  });
}/// Create a copy of EtaRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CalendarLocationCopyWith<$Res> get destination {
  
  return $CalendarLocationCopyWith<$Res>(_self.destination, (value) {
    return _then(_self.copyWith(destination: value));
  });
}
}


/// Adds pattern-matching-related methods to [EtaRequest].
extension EtaRequestPatterns on EtaRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EtaRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EtaRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EtaRequest value)  $default,){
final _that = this;
switch (_that) {
case _EtaRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EtaRequest value)?  $default,){
final _that = this;
switch (_that) {
case _EtaRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CalendarLocation origin,  CalendarLocation destination)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EtaRequest() when $default != null:
return $default(_that.origin,_that.destination);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CalendarLocation origin,  CalendarLocation destination)  $default,) {final _that = this;
switch (_that) {
case _EtaRequest():
return $default(_that.origin,_that.destination);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CalendarLocation origin,  CalendarLocation destination)?  $default,) {final _that = this;
switch (_that) {
case _EtaRequest() when $default != null:
return $default(_that.origin,_that.destination);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EtaRequest implements EtaRequest {
  const _EtaRequest({required this.origin, required this.destination});
  factory _EtaRequest.fromJson(Map<String, dynamic> json) => _$EtaRequestFromJson(json);

@override final  CalendarLocation origin;
@override final  CalendarLocation destination;

/// Create a copy of EtaRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EtaRequestCopyWith<_EtaRequest> get copyWith => __$EtaRequestCopyWithImpl<_EtaRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EtaRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EtaRequest&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.destination, destination) || other.destination == destination));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,origin,destination);

@override
String toString() {
  return 'EtaRequest(origin: $origin, destination: $destination)';
}


}

/// @nodoc
abstract mixin class _$EtaRequestCopyWith<$Res> implements $EtaRequestCopyWith<$Res> {
  factory _$EtaRequestCopyWith(_EtaRequest value, $Res Function(_EtaRequest) _then) = __$EtaRequestCopyWithImpl;
@override @useResult
$Res call({
 CalendarLocation origin, CalendarLocation destination
});


@override $CalendarLocationCopyWith<$Res> get origin;@override $CalendarLocationCopyWith<$Res> get destination;

}
/// @nodoc
class __$EtaRequestCopyWithImpl<$Res>
    implements _$EtaRequestCopyWith<$Res> {
  __$EtaRequestCopyWithImpl(this._self, this._then);

  final _EtaRequest _self;
  final $Res Function(_EtaRequest) _then;

/// Create a copy of EtaRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? origin = null,Object? destination = null,}) {
  return _then(_EtaRequest(
origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as CalendarLocation,destination: null == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as CalendarLocation,
  ));
}

/// Create a copy of EtaRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CalendarLocationCopyWith<$Res> get origin {
  
  return $CalendarLocationCopyWith<$Res>(_self.origin, (value) {
    return _then(_self.copyWith(origin: value));
  });
}/// Create a copy of EtaRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CalendarLocationCopyWith<$Res> get destination {
  
  return $CalendarLocationCopyWith<$Res>(_self.destination, (value) {
    return _then(_self.copyWith(destination: value));
  });
}
}


/// @nodoc
mixin _$EtaResult {

 int get minutes; bool get fromCache;
/// Create a copy of EtaResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EtaResultCopyWith<EtaResult> get copyWith => _$EtaResultCopyWithImpl<EtaResult>(this as EtaResult, _$identity);

  /// Serializes this EtaResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EtaResult&&(identical(other.minutes, minutes) || other.minutes == minutes)&&(identical(other.fromCache, fromCache) || other.fromCache == fromCache));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,minutes,fromCache);

@override
String toString() {
  return 'EtaResult(minutes: $minutes, fromCache: $fromCache)';
}


}

/// @nodoc
abstract mixin class $EtaResultCopyWith<$Res>  {
  factory $EtaResultCopyWith(EtaResult value, $Res Function(EtaResult) _then) = _$EtaResultCopyWithImpl;
@useResult
$Res call({
 int minutes, bool fromCache
});




}
/// @nodoc
class _$EtaResultCopyWithImpl<$Res>
    implements $EtaResultCopyWith<$Res> {
  _$EtaResultCopyWithImpl(this._self, this._then);

  final EtaResult _self;
  final $Res Function(EtaResult) _then;

/// Create a copy of EtaResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? minutes = null,Object? fromCache = null,}) {
  return _then(_self.copyWith(
minutes: null == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int,fromCache: null == fromCache ? _self.fromCache : fromCache // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [EtaResult].
extension EtaResultPatterns on EtaResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EtaResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EtaResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EtaResult value)  $default,){
final _that = this;
switch (_that) {
case _EtaResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EtaResult value)?  $default,){
final _that = this;
switch (_that) {
case _EtaResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int minutes,  bool fromCache)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EtaResult() when $default != null:
return $default(_that.minutes,_that.fromCache);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int minutes,  bool fromCache)  $default,) {final _that = this;
switch (_that) {
case _EtaResult():
return $default(_that.minutes,_that.fromCache);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int minutes,  bool fromCache)?  $default,) {final _that = this;
switch (_that) {
case _EtaResult() when $default != null:
return $default(_that.minutes,_that.fromCache);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EtaResult implements EtaResult {
  const _EtaResult({required this.minutes, this.fromCache = false});
  factory _EtaResult.fromJson(Map<String, dynamic> json) => _$EtaResultFromJson(json);

@override final  int minutes;
@override@JsonKey() final  bool fromCache;

/// Create a copy of EtaResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EtaResultCopyWith<_EtaResult> get copyWith => __$EtaResultCopyWithImpl<_EtaResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EtaResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EtaResult&&(identical(other.minutes, minutes) || other.minutes == minutes)&&(identical(other.fromCache, fromCache) || other.fromCache == fromCache));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,minutes,fromCache);

@override
String toString() {
  return 'EtaResult(minutes: $minutes, fromCache: $fromCache)';
}


}

/// @nodoc
abstract mixin class _$EtaResultCopyWith<$Res> implements $EtaResultCopyWith<$Res> {
  factory _$EtaResultCopyWith(_EtaResult value, $Res Function(_EtaResult) _then) = __$EtaResultCopyWithImpl;
@override @useResult
$Res call({
 int minutes, bool fromCache
});




}
/// @nodoc
class __$EtaResultCopyWithImpl<$Res>
    implements _$EtaResultCopyWith<$Res> {
  __$EtaResultCopyWithImpl(this._self, this._then);

  final _EtaResult _self;
  final $Res Function(_EtaResult) _then;

/// Create a copy of EtaResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? minutes = null,Object? fromCache = null,}) {
  return _then(_EtaResult(
minutes: null == minutes ? _self.minutes : minutes // ignore: cast_nullable_to_non_nullable
as int,fromCache: null == fromCache ? _self.fromCache : fromCache // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

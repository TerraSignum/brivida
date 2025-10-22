// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Chat {

 String? get id; String get jobId; String get customerUid; String get proUid; List<String> get memberUids; String? get lastMessage; DateTime? get lastMessageAt; DateTime get createdAt; DateTime? get updatedAt;
/// Create a copy of Chat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatCopyWith<Chat> get copyWith => _$ChatCopyWithImpl<Chat>(this as Chat, _$identity);

  /// Serializes this Chat to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Chat&&(identical(other.id, id) || other.id == id)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.customerUid, customerUid) || other.customerUid == customerUid)&&(identical(other.proUid, proUid) || other.proUid == proUid)&&const DeepCollectionEquality().equals(other.memberUids, memberUids)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage)&&(identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,jobId,customerUid,proUid,const DeepCollectionEquality().hash(memberUids),lastMessage,lastMessageAt,createdAt,updatedAt);

@override
String toString() {
  return 'Chat(id: $id, jobId: $jobId, customerUid: $customerUid, proUid: $proUid, memberUids: $memberUids, lastMessage: $lastMessage, lastMessageAt: $lastMessageAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ChatCopyWith<$Res>  {
  factory $ChatCopyWith(Chat value, $Res Function(Chat) _then) = _$ChatCopyWithImpl;
@useResult
$Res call({
 String? id, String jobId, String customerUid, String proUid, List<String> memberUids, String? lastMessage, DateTime? lastMessageAt, DateTime createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$ChatCopyWithImpl<$Res>
    implements $ChatCopyWith<$Res> {
  _$ChatCopyWithImpl(this._self, this._then);

  final Chat _self;
  final $Res Function(Chat) _then;

/// Create a copy of Chat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? jobId = null,Object? customerUid = null,Object? proUid = null,Object? memberUids = null,Object? lastMessage = freezed,Object? lastMessageAt = freezed,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,customerUid: null == customerUid ? _self.customerUid : customerUid // ignore: cast_nullable_to_non_nullable
as String,proUid: null == proUid ? _self.proUid : proUid // ignore: cast_nullable_to_non_nullable
as String,memberUids: null == memberUids ? _self.memberUids : memberUids // ignore: cast_nullable_to_non_nullable
as List<String>,lastMessage: freezed == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as String?,lastMessageAt: freezed == lastMessageAt ? _self.lastMessageAt : lastMessageAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Chat].
extension ChatPatterns on Chat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Chat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Chat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Chat value)  $default,){
final _that = this;
switch (_that) {
case _Chat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Chat value)?  $default,){
final _that = this;
switch (_that) {
case _Chat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String jobId,  String customerUid,  String proUid,  List<String> memberUids,  String? lastMessage,  DateTime? lastMessageAt,  DateTime createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Chat() when $default != null:
return $default(_that.id,_that.jobId,_that.customerUid,_that.proUid,_that.memberUids,_that.lastMessage,_that.lastMessageAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String jobId,  String customerUid,  String proUid,  List<String> memberUids,  String? lastMessage,  DateTime? lastMessageAt,  DateTime createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Chat():
return $default(_that.id,_that.jobId,_that.customerUid,_that.proUid,_that.memberUids,_that.lastMessage,_that.lastMessageAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String jobId,  String customerUid,  String proUid,  List<String> memberUids,  String? lastMessage,  DateTime? lastMessageAt,  DateTime createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Chat() when $default != null:
return $default(_that.id,_that.jobId,_that.customerUid,_that.proUid,_that.memberUids,_that.lastMessage,_that.lastMessageAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Chat implements Chat {
  const _Chat({this.id, required this.jobId, required this.customerUid, required this.proUid, required final  List<String> memberUids, this.lastMessage, this.lastMessageAt, required this.createdAt, this.updatedAt}): _memberUids = memberUids;
  factory _Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

@override final  String? id;
@override final  String jobId;
@override final  String customerUid;
@override final  String proUid;
 final  List<String> _memberUids;
@override List<String> get memberUids {
  if (_memberUids is EqualUnmodifiableListView) return _memberUids;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_memberUids);
}

@override final  String? lastMessage;
@override final  DateTime? lastMessageAt;
@override final  DateTime createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of Chat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatCopyWith<_Chat> get copyWith => __$ChatCopyWithImpl<_Chat>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Chat&&(identical(other.id, id) || other.id == id)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.customerUid, customerUid) || other.customerUid == customerUid)&&(identical(other.proUid, proUid) || other.proUid == proUid)&&const DeepCollectionEquality().equals(other._memberUids, _memberUids)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage)&&(identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,jobId,customerUid,proUid,const DeepCollectionEquality().hash(_memberUids),lastMessage,lastMessageAt,createdAt,updatedAt);

@override
String toString() {
  return 'Chat(id: $id, jobId: $jobId, customerUid: $customerUid, proUid: $proUid, memberUids: $memberUids, lastMessage: $lastMessage, lastMessageAt: $lastMessageAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ChatCopyWith<$Res> implements $ChatCopyWith<$Res> {
  factory _$ChatCopyWith(_Chat value, $Res Function(_Chat) _then) = __$ChatCopyWithImpl;
@override @useResult
$Res call({
 String? id, String jobId, String customerUid, String proUid, List<String> memberUids, String? lastMessage, DateTime? lastMessageAt, DateTime createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$ChatCopyWithImpl<$Res>
    implements _$ChatCopyWith<$Res> {
  __$ChatCopyWithImpl(this._self, this._then);

  final _Chat _self;
  final $Res Function(_Chat) _then;

/// Create a copy of Chat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? jobId = null,Object? customerUid = null,Object? proUid = null,Object? memberUids = null,Object? lastMessage = freezed,Object? lastMessageAt = freezed,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_Chat(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,customerUid: null == customerUid ? _self.customerUid : customerUid // ignore: cast_nullable_to_non_nullable
as String,proUid: null == proUid ? _self.proUid : proUid // ignore: cast_nullable_to_non_nullable
as String,memberUids: null == memberUids ? _self._memberUids : memberUids // ignore: cast_nullable_to_non_nullable
as List<String>,lastMessage: freezed == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as String?,lastMessageAt: freezed == lastMessageAt ? _self.lastMessageAt : lastMessageAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$Message {

 String? get id; String get senderUid; MessageType get type; String? get content;// For text messages
 String? get imageUrl;// For image messages
 bool get delivered; bool get read; DateTime get createdAt; DateTime? get updatedAt;
/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageCopyWith<Message> get copyWith => _$MessageCopyWithImpl<Message>(this as Message, _$identity);

  /// Serializes this Message to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Message&&(identical(other.id, id) || other.id == id)&&(identical(other.senderUid, senderUid) || other.senderUid == senderUid)&&(identical(other.type, type) || other.type == type)&&(identical(other.content, content) || other.content == content)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.delivered, delivered) || other.delivered == delivered)&&(identical(other.read, read) || other.read == read)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,senderUid,type,content,imageUrl,delivered,read,createdAt,updatedAt);

@override
String toString() {
  return 'Message(id: $id, senderUid: $senderUid, type: $type, content: $content, imageUrl: $imageUrl, delivered: $delivered, read: $read, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $MessageCopyWith<$Res>  {
  factory $MessageCopyWith(Message value, $Res Function(Message) _then) = _$MessageCopyWithImpl;
@useResult
$Res call({
 String? id, String senderUid, MessageType type, String? content, String? imageUrl, bool delivered, bool read, DateTime createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$MessageCopyWithImpl<$Res>
    implements $MessageCopyWith<$Res> {
  _$MessageCopyWithImpl(this._self, this._then);

  final Message _self;
  final $Res Function(Message) _then;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? senderUid = null,Object? type = null,Object? content = freezed,Object? imageUrl = freezed,Object? delivered = null,Object? read = null,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,senderUid: null == senderUid ? _self.senderUid : senderUid // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MessageType,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,delivered: null == delivered ? _self.delivered : delivered // ignore: cast_nullable_to_non_nullable
as bool,read: null == read ? _self.read : read // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Message].
extension MessagePatterns on Message {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Message value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Message() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Message value)  $default,){
final _that = this;
switch (_that) {
case _Message():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Message value)?  $default,){
final _that = this;
switch (_that) {
case _Message() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String senderUid,  MessageType type,  String? content,  String? imageUrl,  bool delivered,  bool read,  DateTime createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Message() when $default != null:
return $default(_that.id,_that.senderUid,_that.type,_that.content,_that.imageUrl,_that.delivered,_that.read,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String senderUid,  MessageType type,  String? content,  String? imageUrl,  bool delivered,  bool read,  DateTime createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Message():
return $default(_that.id,_that.senderUid,_that.type,_that.content,_that.imageUrl,_that.delivered,_that.read,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String senderUid,  MessageType type,  String? content,  String? imageUrl,  bool delivered,  bool read,  DateTime createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Message() when $default != null:
return $default(_that.id,_that.senderUid,_that.type,_that.content,_that.imageUrl,_that.delivered,_that.read,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Message implements Message {
  const _Message({this.id, required this.senderUid, required this.type, this.content, this.imageUrl, this.delivered = false, this.read = false, required this.createdAt, this.updatedAt});
  factory _Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

@override final  String? id;
@override final  String senderUid;
@override final  MessageType type;
@override final  String? content;
// For text messages
@override final  String? imageUrl;
// For image messages
@override@JsonKey() final  bool delivered;
@override@JsonKey() final  bool read;
@override final  DateTime createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageCopyWith<_Message> get copyWith => __$MessageCopyWithImpl<_Message>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Message&&(identical(other.id, id) || other.id == id)&&(identical(other.senderUid, senderUid) || other.senderUid == senderUid)&&(identical(other.type, type) || other.type == type)&&(identical(other.content, content) || other.content == content)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.delivered, delivered) || other.delivered == delivered)&&(identical(other.read, read) || other.read == read)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,senderUid,type,content,imageUrl,delivered,read,createdAt,updatedAt);

@override
String toString() {
  return 'Message(id: $id, senderUid: $senderUid, type: $type, content: $content, imageUrl: $imageUrl, delivered: $delivered, read: $read, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$MessageCopyWith<$Res> implements $MessageCopyWith<$Res> {
  factory _$MessageCopyWith(_Message value, $Res Function(_Message) _then) = __$MessageCopyWithImpl;
@override @useResult
$Res call({
 String? id, String senderUid, MessageType type, String? content, String? imageUrl, bool delivered, bool read, DateTime createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$MessageCopyWithImpl<$Res>
    implements _$MessageCopyWith<$Res> {
  __$MessageCopyWithImpl(this._self, this._then);

  final _Message _self;
  final $Res Function(_Message) _then;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? senderUid = null,Object? type = null,Object? content = freezed,Object? imageUrl = freezed,Object? delivered = null,Object? read = null,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_Message(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,senderUid: null == senderUid ? _self.senderUid : senderUid // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as MessageType,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,delivered: null == delivered ? _self.delivered : delivered // ignore: cast_nullable_to_non_nullable
as bool,read: null == read ? _self.read : read // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppUser {

 String get uid; String get email; String? get displayName; String? get username; String? get usernameLower; String? get photoUrl; String? get phoneNumber; String? get locale; bool get marketingOptIn; bool get isVerified; String? get role;@TimestampConverter() DateTime? get createdAt; bool get deleted;
/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppUserCopyWith<AppUser> get copyWith => _$AppUserCopyWithImpl<AppUser>(this as AppUser, _$identity);

  /// Serializes this AppUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppUser&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.username, username) || other.username == username)&&(identical(other.usernameLower, usernameLower) || other.usernameLower == usernameLower)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.marketingOptIn, marketingOptIn) || other.marketingOptIn == marketingOptIn)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.role, role) || other.role == role)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.deleted, deleted) || other.deleted == deleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,email,displayName,username,usernameLower,photoUrl,phoneNumber,locale,marketingOptIn,isVerified,role,createdAt,deleted);

@override
String toString() {
  return 'AppUser(uid: $uid, email: $email, displayName: $displayName, username: $username, usernameLower: $usernameLower, photoUrl: $photoUrl, phoneNumber: $phoneNumber, locale: $locale, marketingOptIn: $marketingOptIn, isVerified: $isVerified, role: $role, createdAt: $createdAt, deleted: $deleted)';
}


}

/// @nodoc
abstract mixin class $AppUserCopyWith<$Res>  {
  factory $AppUserCopyWith(AppUser value, $Res Function(AppUser) _then) = _$AppUserCopyWithImpl;
@useResult
$Res call({
 String uid, String email, String? displayName, String? username, String? usernameLower, String? photoUrl, String? phoneNumber, String? locale, bool marketingOptIn, bool isVerified, String? role,@TimestampConverter() DateTime? createdAt, bool deleted
});




}
/// @nodoc
class _$AppUserCopyWithImpl<$Res>
    implements $AppUserCopyWith<$Res> {
  _$AppUserCopyWithImpl(this._self, this._then);

  final AppUser _self;
  final $Res Function(AppUser) _then;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? email = null,Object? displayName = freezed,Object? username = freezed,Object? usernameLower = freezed,Object? photoUrl = freezed,Object? phoneNumber = freezed,Object? locale = freezed,Object? marketingOptIn = null,Object? isVerified = null,Object? role = freezed,Object? createdAt = freezed,Object? deleted = null,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,usernameLower: freezed == usernameLower ? _self.usernameLower : usernameLower // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String?,marketingOptIn: null == marketingOptIn ? _self.marketingOptIn : marketingOptIn // ignore: cast_nullable_to_non_nullable
as bool,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deleted: null == deleted ? _self.deleted : deleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AppUser].
extension AppUserPatterns on AppUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppUser value)  $default,){
final _that = this;
switch (_that) {
case _AppUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppUser value)?  $default,){
final _that = this;
switch (_that) {
case _AppUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  String email,  String? displayName,  String? username,  String? usernameLower,  String? photoUrl,  String? phoneNumber,  String? locale,  bool marketingOptIn,  bool isVerified,  String? role, @TimestampConverter()  DateTime? createdAt,  bool deleted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that.uid,_that.email,_that.displayName,_that.username,_that.usernameLower,_that.photoUrl,_that.phoneNumber,_that.locale,_that.marketingOptIn,_that.isVerified,_that.role,_that.createdAt,_that.deleted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  String email,  String? displayName,  String? username,  String? usernameLower,  String? photoUrl,  String? phoneNumber,  String? locale,  bool marketingOptIn,  bool isVerified,  String? role, @TimestampConverter()  DateTime? createdAt,  bool deleted)  $default,) {final _that = this;
switch (_that) {
case _AppUser():
return $default(_that.uid,_that.email,_that.displayName,_that.username,_that.usernameLower,_that.photoUrl,_that.phoneNumber,_that.locale,_that.marketingOptIn,_that.isVerified,_that.role,_that.createdAt,_that.deleted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  String email,  String? displayName,  String? username,  String? usernameLower,  String? photoUrl,  String? phoneNumber,  String? locale,  bool marketingOptIn,  bool isVerified,  String? role, @TimestampConverter()  DateTime? createdAt,  bool deleted)?  $default,) {final _that = this;
switch (_that) {
case _AppUser() when $default != null:
return $default(_that.uid,_that.email,_that.displayName,_that.username,_that.usernameLower,_that.photoUrl,_that.phoneNumber,_that.locale,_that.marketingOptIn,_that.isVerified,_that.role,_that.createdAt,_that.deleted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppUser extends AppUser {
  const _AppUser({required this.uid, required this.email, this.displayName, this.username, this.usernameLower, this.photoUrl, this.phoneNumber, this.locale, this.marketingOptIn = false, this.isVerified = false, this.role, @TimestampConverter() this.createdAt, this.deleted = false}): super._();
  factory _AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);

@override final  String uid;
@override final  String email;
@override final  String? displayName;
@override final  String? username;
@override final  String? usernameLower;
@override final  String? photoUrl;
@override final  String? phoneNumber;
@override final  String? locale;
@override@JsonKey() final  bool marketingOptIn;
@override@JsonKey() final  bool isVerified;
@override final  String? role;
@override@TimestampConverter() final  DateTime? createdAt;
@override@JsonKey() final  bool deleted;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppUserCopyWith<_AppUser> get copyWith => __$AppUserCopyWithImpl<_AppUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppUserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppUser&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.username, username) || other.username == username)&&(identical(other.usernameLower, usernameLower) || other.usernameLower == usernameLower)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.marketingOptIn, marketingOptIn) || other.marketingOptIn == marketingOptIn)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.role, role) || other.role == role)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.deleted, deleted) || other.deleted == deleted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,email,displayName,username,usernameLower,photoUrl,phoneNumber,locale,marketingOptIn,isVerified,role,createdAt,deleted);

@override
String toString() {
  return 'AppUser(uid: $uid, email: $email, displayName: $displayName, username: $username, usernameLower: $usernameLower, photoUrl: $photoUrl, phoneNumber: $phoneNumber, locale: $locale, marketingOptIn: $marketingOptIn, isVerified: $isVerified, role: $role, createdAt: $createdAt, deleted: $deleted)';
}


}

/// @nodoc
abstract mixin class _$AppUserCopyWith<$Res> implements $AppUserCopyWith<$Res> {
  factory _$AppUserCopyWith(_AppUser value, $Res Function(_AppUser) _then) = __$AppUserCopyWithImpl;
@override @useResult
$Res call({
 String uid, String email, String? displayName, String? username, String? usernameLower, String? photoUrl, String? phoneNumber, String? locale, bool marketingOptIn, bool isVerified, String? role,@TimestampConverter() DateTime? createdAt, bool deleted
});




}
/// @nodoc
class __$AppUserCopyWithImpl<$Res>
    implements _$AppUserCopyWith<$Res> {
  __$AppUserCopyWithImpl(this._self, this._then);

  final _AppUser _self;
  final $Res Function(_AppUser) _then;

/// Create a copy of AppUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? email = null,Object? displayName = freezed,Object? username = freezed,Object? usernameLower = freezed,Object? photoUrl = freezed,Object? phoneNumber = freezed,Object? locale = freezed,Object? marketingOptIn = null,Object? isVerified = null,Object? role = freezed,Object? createdAt = freezed,Object? deleted = null,}) {
  return _then(_AppUser(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,usernameLower: freezed == usernameLower ? _self.usernameLower : usernameLower // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String?,marketingOptIn: null == marketingOptIn ? _self.marketingOptIn : marketingOptIn // ignore: cast_nullable_to_non_nullable
as bool,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,deleted: null == deleted ? _self.deleted : deleted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

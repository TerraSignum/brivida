// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'legal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LegalDocument {

 String get id; LegalDocType get type; String get version; SupportedLanguage get lang; String get content; DateTime get publishedAt; bool get isActive; String? get title;// Document title
 String? get previousVersion; String? get publishedBy;
/// Create a copy of LegalDocument
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LegalDocumentCopyWith<LegalDocument> get copyWith => _$LegalDocumentCopyWithImpl<LegalDocument>(this as LegalDocument, _$identity);

  /// Serializes this LegalDocument to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LegalDocument&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.version, version) || other.version == version)&&(identical(other.lang, lang) || other.lang == lang)&&(identical(other.content, content) || other.content == content)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.title, title) || other.title == title)&&(identical(other.previousVersion, previousVersion) || other.previousVersion == previousVersion)&&(identical(other.publishedBy, publishedBy) || other.publishedBy == publishedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,version,lang,content,publishedAt,isActive,title,previousVersion,publishedBy);

@override
String toString() {
  return 'LegalDocument(id: $id, type: $type, version: $version, lang: $lang, content: $content, publishedAt: $publishedAt, isActive: $isActive, title: $title, previousVersion: $previousVersion, publishedBy: $publishedBy)';
}


}

/// @nodoc
abstract mixin class $LegalDocumentCopyWith<$Res>  {
  factory $LegalDocumentCopyWith(LegalDocument value, $Res Function(LegalDocument) _then) = _$LegalDocumentCopyWithImpl;
@useResult
$Res call({
 String id, LegalDocType type, String version, SupportedLanguage lang, String content, DateTime publishedAt, bool isActive, String? title, String? previousVersion, String? publishedBy
});




}
/// @nodoc
class _$LegalDocumentCopyWithImpl<$Res>
    implements $LegalDocumentCopyWith<$Res> {
  _$LegalDocumentCopyWithImpl(this._self, this._then);

  final LegalDocument _self;
  final $Res Function(LegalDocument) _then;

/// Create a copy of LegalDocument
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? version = null,Object? lang = null,Object? content = null,Object? publishedAt = null,Object? isActive = null,Object? title = freezed,Object? previousVersion = freezed,Object? publishedBy = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as LegalDocType,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,lang: null == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as SupportedLanguage,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,publishedAt: null == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,previousVersion: freezed == previousVersion ? _self.previousVersion : previousVersion // ignore: cast_nullable_to_non_nullable
as String?,publishedBy: freezed == publishedBy ? _self.publishedBy : publishedBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LegalDocument].
extension LegalDocumentPatterns on LegalDocument {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LegalDocument value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LegalDocument() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LegalDocument value)  $default,){
final _that = this;
switch (_that) {
case _LegalDocument():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LegalDocument value)?  $default,){
final _that = this;
switch (_that) {
case _LegalDocument() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  LegalDocType type,  String version,  SupportedLanguage lang,  String content,  DateTime publishedAt,  bool isActive,  String? title,  String? previousVersion,  String? publishedBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LegalDocument() when $default != null:
return $default(_that.id,_that.type,_that.version,_that.lang,_that.content,_that.publishedAt,_that.isActive,_that.title,_that.previousVersion,_that.publishedBy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  LegalDocType type,  String version,  SupportedLanguage lang,  String content,  DateTime publishedAt,  bool isActive,  String? title,  String? previousVersion,  String? publishedBy)  $default,) {final _that = this;
switch (_that) {
case _LegalDocument():
return $default(_that.id,_that.type,_that.version,_that.lang,_that.content,_that.publishedAt,_that.isActive,_that.title,_that.previousVersion,_that.publishedBy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  LegalDocType type,  String version,  SupportedLanguage lang,  String content,  DateTime publishedAt,  bool isActive,  String? title,  String? previousVersion,  String? publishedBy)?  $default,) {final _that = this;
switch (_that) {
case _LegalDocument() when $default != null:
return $default(_that.id,_that.type,_that.version,_that.lang,_that.content,_that.publishedAt,_that.isActive,_that.title,_that.previousVersion,_that.publishedBy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LegalDocument extends LegalDocument {
  const _LegalDocument({required this.id, required this.type, required this.version, required this.lang, required this.content, required this.publishedAt, this.isActive = true, this.title, this.previousVersion, this.publishedBy}): super._();
  factory _LegalDocument.fromJson(Map<String, dynamic> json) => _$LegalDocumentFromJson(json);

@override final  String id;
@override final  LegalDocType type;
@override final  String version;
@override final  SupportedLanguage lang;
@override final  String content;
@override final  DateTime publishedAt;
@override@JsonKey() final  bool isActive;
@override final  String? title;
// Document title
@override final  String? previousVersion;
@override final  String? publishedBy;

/// Create a copy of LegalDocument
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LegalDocumentCopyWith<_LegalDocument> get copyWith => __$LegalDocumentCopyWithImpl<_LegalDocument>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LegalDocumentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LegalDocument&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.version, version) || other.version == version)&&(identical(other.lang, lang) || other.lang == lang)&&(identical(other.content, content) || other.content == content)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.title, title) || other.title == title)&&(identical(other.previousVersion, previousVersion) || other.previousVersion == previousVersion)&&(identical(other.publishedBy, publishedBy) || other.publishedBy == publishedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,version,lang,content,publishedAt,isActive,title,previousVersion,publishedBy);

@override
String toString() {
  return 'LegalDocument(id: $id, type: $type, version: $version, lang: $lang, content: $content, publishedAt: $publishedAt, isActive: $isActive, title: $title, previousVersion: $previousVersion, publishedBy: $publishedBy)';
}


}

/// @nodoc
abstract mixin class _$LegalDocumentCopyWith<$Res> implements $LegalDocumentCopyWith<$Res> {
  factory _$LegalDocumentCopyWith(_LegalDocument value, $Res Function(_LegalDocument) _then) = __$LegalDocumentCopyWithImpl;
@override @useResult
$Res call({
 String id, LegalDocType type, String version, SupportedLanguage lang, String content, DateTime publishedAt, bool isActive, String? title, String? previousVersion, String? publishedBy
});




}
/// @nodoc
class __$LegalDocumentCopyWithImpl<$Res>
    implements _$LegalDocumentCopyWith<$Res> {
  __$LegalDocumentCopyWithImpl(this._self, this._then);

  final _LegalDocument _self;
  final $Res Function(_LegalDocument) _then;

/// Create a copy of LegalDocument
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? version = null,Object? lang = null,Object? content = null,Object? publishedAt = null,Object? isActive = null,Object? title = freezed,Object? previousVersion = freezed,Object? publishedBy = freezed,}) {
  return _then(_LegalDocument(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as LegalDocType,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,lang: null == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as SupportedLanguage,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,publishedAt: null == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,previousVersion: freezed == previousVersion ? _self.previousVersion : previousVersion // ignore: cast_nullable_to_non_nullable
as String?,publishedBy: freezed == publishedBy ? _self.publishedBy : publishedBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$UserConsent {

 String get uid; String get tosVersion; String get privacyVersion; DateTime get consentedAt; String get consentedIp; SupportedLanguage get consentedLang; String? get impressumVersion; DateTime? get lastUpdated; bool get needsReConsent;
/// Create a copy of UserConsent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserConsentCopyWith<UserConsent> get copyWith => _$UserConsentCopyWithImpl<UserConsent>(this as UserConsent, _$identity);

  /// Serializes this UserConsent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserConsent&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.tosVersion, tosVersion) || other.tosVersion == tosVersion)&&(identical(other.privacyVersion, privacyVersion) || other.privacyVersion == privacyVersion)&&(identical(other.consentedAt, consentedAt) || other.consentedAt == consentedAt)&&(identical(other.consentedIp, consentedIp) || other.consentedIp == consentedIp)&&(identical(other.consentedLang, consentedLang) || other.consentedLang == consentedLang)&&(identical(other.impressumVersion, impressumVersion) || other.impressumVersion == impressumVersion)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&(identical(other.needsReConsent, needsReConsent) || other.needsReConsent == needsReConsent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,tosVersion,privacyVersion,consentedAt,consentedIp,consentedLang,impressumVersion,lastUpdated,needsReConsent);

@override
String toString() {
  return 'UserConsent(uid: $uid, tosVersion: $tosVersion, privacyVersion: $privacyVersion, consentedAt: $consentedAt, consentedIp: $consentedIp, consentedLang: $consentedLang, impressumVersion: $impressumVersion, lastUpdated: $lastUpdated, needsReConsent: $needsReConsent)';
}


}

/// @nodoc
abstract mixin class $UserConsentCopyWith<$Res>  {
  factory $UserConsentCopyWith(UserConsent value, $Res Function(UserConsent) _then) = _$UserConsentCopyWithImpl;
@useResult
$Res call({
 String uid, String tosVersion, String privacyVersion, DateTime consentedAt, String consentedIp, SupportedLanguage consentedLang, String? impressumVersion, DateTime? lastUpdated, bool needsReConsent
});




}
/// @nodoc
class _$UserConsentCopyWithImpl<$Res>
    implements $UserConsentCopyWith<$Res> {
  _$UserConsentCopyWithImpl(this._self, this._then);

  final UserConsent _self;
  final $Res Function(UserConsent) _then;

/// Create a copy of UserConsent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? tosVersion = null,Object? privacyVersion = null,Object? consentedAt = null,Object? consentedIp = null,Object? consentedLang = null,Object? impressumVersion = freezed,Object? lastUpdated = freezed,Object? needsReConsent = null,}) {
  return _then(_self.copyWith(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,tosVersion: null == tosVersion ? _self.tosVersion : tosVersion // ignore: cast_nullable_to_non_nullable
as String,privacyVersion: null == privacyVersion ? _self.privacyVersion : privacyVersion // ignore: cast_nullable_to_non_nullable
as String,consentedAt: null == consentedAt ? _self.consentedAt : consentedAt // ignore: cast_nullable_to_non_nullable
as DateTime,consentedIp: null == consentedIp ? _self.consentedIp : consentedIp // ignore: cast_nullable_to_non_nullable
as String,consentedLang: null == consentedLang ? _self.consentedLang : consentedLang // ignore: cast_nullable_to_non_nullable
as SupportedLanguage,impressumVersion: freezed == impressumVersion ? _self.impressumVersion : impressumVersion // ignore: cast_nullable_to_non_nullable
as String?,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime?,needsReConsent: null == needsReConsent ? _self.needsReConsent : needsReConsent // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UserConsent].
extension UserConsentPatterns on UserConsent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserConsent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserConsent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserConsent value)  $default,){
final _that = this;
switch (_that) {
case _UserConsent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserConsent value)?  $default,){
final _that = this;
switch (_that) {
case _UserConsent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  String tosVersion,  String privacyVersion,  DateTime consentedAt,  String consentedIp,  SupportedLanguage consentedLang,  String? impressumVersion,  DateTime? lastUpdated,  bool needsReConsent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserConsent() when $default != null:
return $default(_that.uid,_that.tosVersion,_that.privacyVersion,_that.consentedAt,_that.consentedIp,_that.consentedLang,_that.impressumVersion,_that.lastUpdated,_that.needsReConsent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  String tosVersion,  String privacyVersion,  DateTime consentedAt,  String consentedIp,  SupportedLanguage consentedLang,  String? impressumVersion,  DateTime? lastUpdated,  bool needsReConsent)  $default,) {final _that = this;
switch (_that) {
case _UserConsent():
return $default(_that.uid,_that.tosVersion,_that.privacyVersion,_that.consentedAt,_that.consentedIp,_that.consentedLang,_that.impressumVersion,_that.lastUpdated,_that.needsReConsent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  String tosVersion,  String privacyVersion,  DateTime consentedAt,  String consentedIp,  SupportedLanguage consentedLang,  String? impressumVersion,  DateTime? lastUpdated,  bool needsReConsent)?  $default,) {final _that = this;
switch (_that) {
case _UserConsent() when $default != null:
return $default(_that.uid,_that.tosVersion,_that.privacyVersion,_that.consentedAt,_that.consentedIp,_that.consentedLang,_that.impressumVersion,_that.lastUpdated,_that.needsReConsent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserConsent extends UserConsent {
  const _UserConsent({required this.uid, required this.tosVersion, required this.privacyVersion, required this.consentedAt, required this.consentedIp, required this.consentedLang, this.impressumVersion, this.lastUpdated, this.needsReConsent = false}): super._();
  factory _UserConsent.fromJson(Map<String, dynamic> json) => _$UserConsentFromJson(json);

@override final  String uid;
@override final  String tosVersion;
@override final  String privacyVersion;
@override final  DateTime consentedAt;
@override final  String consentedIp;
@override final  SupportedLanguage consentedLang;
@override final  String? impressumVersion;
@override final  DateTime? lastUpdated;
@override@JsonKey() final  bool needsReConsent;

/// Create a copy of UserConsent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserConsentCopyWith<_UserConsent> get copyWith => __$UserConsentCopyWithImpl<_UserConsent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserConsentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserConsent&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.tosVersion, tosVersion) || other.tosVersion == tosVersion)&&(identical(other.privacyVersion, privacyVersion) || other.privacyVersion == privacyVersion)&&(identical(other.consentedAt, consentedAt) || other.consentedAt == consentedAt)&&(identical(other.consentedIp, consentedIp) || other.consentedIp == consentedIp)&&(identical(other.consentedLang, consentedLang) || other.consentedLang == consentedLang)&&(identical(other.impressumVersion, impressumVersion) || other.impressumVersion == impressumVersion)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&(identical(other.needsReConsent, needsReConsent) || other.needsReConsent == needsReConsent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uid,tosVersion,privacyVersion,consentedAt,consentedIp,consentedLang,impressumVersion,lastUpdated,needsReConsent);

@override
String toString() {
  return 'UserConsent(uid: $uid, tosVersion: $tosVersion, privacyVersion: $privacyVersion, consentedAt: $consentedAt, consentedIp: $consentedIp, consentedLang: $consentedLang, impressumVersion: $impressumVersion, lastUpdated: $lastUpdated, needsReConsent: $needsReConsent)';
}


}

/// @nodoc
abstract mixin class _$UserConsentCopyWith<$Res> implements $UserConsentCopyWith<$Res> {
  factory _$UserConsentCopyWith(_UserConsent value, $Res Function(_UserConsent) _then) = __$UserConsentCopyWithImpl;
@override @useResult
$Res call({
 String uid, String tosVersion, String privacyVersion, DateTime consentedAt, String consentedIp, SupportedLanguage consentedLang, String? impressumVersion, DateTime? lastUpdated, bool needsReConsent
});




}
/// @nodoc
class __$UserConsentCopyWithImpl<$Res>
    implements _$UserConsentCopyWith<$Res> {
  __$UserConsentCopyWithImpl(this._self, this._then);

  final _UserConsent _self;
  final $Res Function(_UserConsent) _then;

/// Create a copy of UserConsent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? tosVersion = null,Object? privacyVersion = null,Object? consentedAt = null,Object? consentedIp = null,Object? consentedLang = null,Object? impressumVersion = freezed,Object? lastUpdated = freezed,Object? needsReConsent = null,}) {
  return _then(_UserConsent(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,tosVersion: null == tosVersion ? _self.tosVersion : tosVersion // ignore: cast_nullable_to_non_nullable
as String,privacyVersion: null == privacyVersion ? _self.privacyVersion : privacyVersion // ignore: cast_nullable_to_non_nullable
as String,consentedAt: null == consentedAt ? _self.consentedAt : consentedAt // ignore: cast_nullable_to_non_nullable
as DateTime,consentedIp: null == consentedIp ? _self.consentedIp : consentedIp // ignore: cast_nullable_to_non_nullable
as String,consentedLang: null == consentedLang ? _self.consentedLang : consentedLang // ignore: cast_nullable_to_non_nullable
as SupportedLanguage,impressumVersion: freezed == impressumVersion ? _self.impressumVersion : impressumVersion // ignore: cast_nullable_to_non_nullable
as String?,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime?,needsReConsent: null == needsReConsent ? _self.needsReConsent : needsReConsent // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$LegalComplianceStatus {

 bool get hasValidConsent; bool get needsReConsent; List<String> get missingDocuments; List<String> get outdatedDocuments; String? get currentTosVersion; String? get currentPrivacyVersion; String? get latestTosVersion; String? get latestPrivacyVersion;
/// Create a copy of LegalComplianceStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LegalComplianceStatusCopyWith<LegalComplianceStatus> get copyWith => _$LegalComplianceStatusCopyWithImpl<LegalComplianceStatus>(this as LegalComplianceStatus, _$identity);

  /// Serializes this LegalComplianceStatus to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LegalComplianceStatus&&(identical(other.hasValidConsent, hasValidConsent) || other.hasValidConsent == hasValidConsent)&&(identical(other.needsReConsent, needsReConsent) || other.needsReConsent == needsReConsent)&&const DeepCollectionEquality().equals(other.missingDocuments, missingDocuments)&&const DeepCollectionEquality().equals(other.outdatedDocuments, outdatedDocuments)&&(identical(other.currentTosVersion, currentTosVersion) || other.currentTosVersion == currentTosVersion)&&(identical(other.currentPrivacyVersion, currentPrivacyVersion) || other.currentPrivacyVersion == currentPrivacyVersion)&&(identical(other.latestTosVersion, latestTosVersion) || other.latestTosVersion == latestTosVersion)&&(identical(other.latestPrivacyVersion, latestPrivacyVersion) || other.latestPrivacyVersion == latestPrivacyVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hasValidConsent,needsReConsent,const DeepCollectionEquality().hash(missingDocuments),const DeepCollectionEquality().hash(outdatedDocuments),currentTosVersion,currentPrivacyVersion,latestTosVersion,latestPrivacyVersion);

@override
String toString() {
  return 'LegalComplianceStatus(hasValidConsent: $hasValidConsent, needsReConsent: $needsReConsent, missingDocuments: $missingDocuments, outdatedDocuments: $outdatedDocuments, currentTosVersion: $currentTosVersion, currentPrivacyVersion: $currentPrivacyVersion, latestTosVersion: $latestTosVersion, latestPrivacyVersion: $latestPrivacyVersion)';
}


}

/// @nodoc
abstract mixin class $LegalComplianceStatusCopyWith<$Res>  {
  factory $LegalComplianceStatusCopyWith(LegalComplianceStatus value, $Res Function(LegalComplianceStatus) _then) = _$LegalComplianceStatusCopyWithImpl;
@useResult
$Res call({
 bool hasValidConsent, bool needsReConsent, List<String> missingDocuments, List<String> outdatedDocuments, String? currentTosVersion, String? currentPrivacyVersion, String? latestTosVersion, String? latestPrivacyVersion
});




}
/// @nodoc
class _$LegalComplianceStatusCopyWithImpl<$Res>
    implements $LegalComplianceStatusCopyWith<$Res> {
  _$LegalComplianceStatusCopyWithImpl(this._self, this._then);

  final LegalComplianceStatus _self;
  final $Res Function(LegalComplianceStatus) _then;

/// Create a copy of LegalComplianceStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hasValidConsent = null,Object? needsReConsent = null,Object? missingDocuments = null,Object? outdatedDocuments = null,Object? currentTosVersion = freezed,Object? currentPrivacyVersion = freezed,Object? latestTosVersion = freezed,Object? latestPrivacyVersion = freezed,}) {
  return _then(_self.copyWith(
hasValidConsent: null == hasValidConsent ? _self.hasValidConsent : hasValidConsent // ignore: cast_nullable_to_non_nullable
as bool,needsReConsent: null == needsReConsent ? _self.needsReConsent : needsReConsent // ignore: cast_nullable_to_non_nullable
as bool,missingDocuments: null == missingDocuments ? _self.missingDocuments : missingDocuments // ignore: cast_nullable_to_non_nullable
as List<String>,outdatedDocuments: null == outdatedDocuments ? _self.outdatedDocuments : outdatedDocuments // ignore: cast_nullable_to_non_nullable
as List<String>,currentTosVersion: freezed == currentTosVersion ? _self.currentTosVersion : currentTosVersion // ignore: cast_nullable_to_non_nullable
as String?,currentPrivacyVersion: freezed == currentPrivacyVersion ? _self.currentPrivacyVersion : currentPrivacyVersion // ignore: cast_nullable_to_non_nullable
as String?,latestTosVersion: freezed == latestTosVersion ? _self.latestTosVersion : latestTosVersion // ignore: cast_nullable_to_non_nullable
as String?,latestPrivacyVersion: freezed == latestPrivacyVersion ? _self.latestPrivacyVersion : latestPrivacyVersion // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LegalComplianceStatus].
extension LegalComplianceStatusPatterns on LegalComplianceStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LegalComplianceStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LegalComplianceStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LegalComplianceStatus value)  $default,){
final _that = this;
switch (_that) {
case _LegalComplianceStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LegalComplianceStatus value)?  $default,){
final _that = this;
switch (_that) {
case _LegalComplianceStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool hasValidConsent,  bool needsReConsent,  List<String> missingDocuments,  List<String> outdatedDocuments,  String? currentTosVersion,  String? currentPrivacyVersion,  String? latestTosVersion,  String? latestPrivacyVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LegalComplianceStatus() when $default != null:
return $default(_that.hasValidConsent,_that.needsReConsent,_that.missingDocuments,_that.outdatedDocuments,_that.currentTosVersion,_that.currentPrivacyVersion,_that.latestTosVersion,_that.latestPrivacyVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool hasValidConsent,  bool needsReConsent,  List<String> missingDocuments,  List<String> outdatedDocuments,  String? currentTosVersion,  String? currentPrivacyVersion,  String? latestTosVersion,  String? latestPrivacyVersion)  $default,) {final _that = this;
switch (_that) {
case _LegalComplianceStatus():
return $default(_that.hasValidConsent,_that.needsReConsent,_that.missingDocuments,_that.outdatedDocuments,_that.currentTosVersion,_that.currentPrivacyVersion,_that.latestTosVersion,_that.latestPrivacyVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool hasValidConsent,  bool needsReConsent,  List<String> missingDocuments,  List<String> outdatedDocuments,  String? currentTosVersion,  String? currentPrivacyVersion,  String? latestTosVersion,  String? latestPrivacyVersion)?  $default,) {final _that = this;
switch (_that) {
case _LegalComplianceStatus() when $default != null:
return $default(_that.hasValidConsent,_that.needsReConsent,_that.missingDocuments,_that.outdatedDocuments,_that.currentTosVersion,_that.currentPrivacyVersion,_that.latestTosVersion,_that.latestPrivacyVersion);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LegalComplianceStatus extends LegalComplianceStatus {
  const _LegalComplianceStatus({required this.hasValidConsent, required this.needsReConsent, required final  List<String> missingDocuments, required final  List<String> outdatedDocuments, this.currentTosVersion, this.currentPrivacyVersion, this.latestTosVersion, this.latestPrivacyVersion}): _missingDocuments = missingDocuments,_outdatedDocuments = outdatedDocuments,super._();
  factory _LegalComplianceStatus.fromJson(Map<String, dynamic> json) => _$LegalComplianceStatusFromJson(json);

@override final  bool hasValidConsent;
@override final  bool needsReConsent;
 final  List<String> _missingDocuments;
@override List<String> get missingDocuments {
  if (_missingDocuments is EqualUnmodifiableListView) return _missingDocuments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_missingDocuments);
}

 final  List<String> _outdatedDocuments;
@override List<String> get outdatedDocuments {
  if (_outdatedDocuments is EqualUnmodifiableListView) return _outdatedDocuments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_outdatedDocuments);
}

@override final  String? currentTosVersion;
@override final  String? currentPrivacyVersion;
@override final  String? latestTosVersion;
@override final  String? latestPrivacyVersion;

/// Create a copy of LegalComplianceStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LegalComplianceStatusCopyWith<_LegalComplianceStatus> get copyWith => __$LegalComplianceStatusCopyWithImpl<_LegalComplianceStatus>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LegalComplianceStatusToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LegalComplianceStatus&&(identical(other.hasValidConsent, hasValidConsent) || other.hasValidConsent == hasValidConsent)&&(identical(other.needsReConsent, needsReConsent) || other.needsReConsent == needsReConsent)&&const DeepCollectionEquality().equals(other._missingDocuments, _missingDocuments)&&const DeepCollectionEquality().equals(other._outdatedDocuments, _outdatedDocuments)&&(identical(other.currentTosVersion, currentTosVersion) || other.currentTosVersion == currentTosVersion)&&(identical(other.currentPrivacyVersion, currentPrivacyVersion) || other.currentPrivacyVersion == currentPrivacyVersion)&&(identical(other.latestTosVersion, latestTosVersion) || other.latestTosVersion == latestTosVersion)&&(identical(other.latestPrivacyVersion, latestPrivacyVersion) || other.latestPrivacyVersion == latestPrivacyVersion));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hasValidConsent,needsReConsent,const DeepCollectionEquality().hash(_missingDocuments),const DeepCollectionEquality().hash(_outdatedDocuments),currentTosVersion,currentPrivacyVersion,latestTosVersion,latestPrivacyVersion);

@override
String toString() {
  return 'LegalComplianceStatus(hasValidConsent: $hasValidConsent, needsReConsent: $needsReConsent, missingDocuments: $missingDocuments, outdatedDocuments: $outdatedDocuments, currentTosVersion: $currentTosVersion, currentPrivacyVersion: $currentPrivacyVersion, latestTosVersion: $latestTosVersion, latestPrivacyVersion: $latestPrivacyVersion)';
}


}

/// @nodoc
abstract mixin class _$LegalComplianceStatusCopyWith<$Res> implements $LegalComplianceStatusCopyWith<$Res> {
  factory _$LegalComplianceStatusCopyWith(_LegalComplianceStatus value, $Res Function(_LegalComplianceStatus) _then) = __$LegalComplianceStatusCopyWithImpl;
@override @useResult
$Res call({
 bool hasValidConsent, bool needsReConsent, List<String> missingDocuments, List<String> outdatedDocuments, String? currentTosVersion, String? currentPrivacyVersion, String? latestTosVersion, String? latestPrivacyVersion
});




}
/// @nodoc
class __$LegalComplianceStatusCopyWithImpl<$Res>
    implements _$LegalComplianceStatusCopyWith<$Res> {
  __$LegalComplianceStatusCopyWithImpl(this._self, this._then);

  final _LegalComplianceStatus _self;
  final $Res Function(_LegalComplianceStatus) _then;

/// Create a copy of LegalComplianceStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hasValidConsent = null,Object? needsReConsent = null,Object? missingDocuments = null,Object? outdatedDocuments = null,Object? currentTosVersion = freezed,Object? currentPrivacyVersion = freezed,Object? latestTosVersion = freezed,Object? latestPrivacyVersion = freezed,}) {
  return _then(_LegalComplianceStatus(
hasValidConsent: null == hasValidConsent ? _self.hasValidConsent : hasValidConsent // ignore: cast_nullable_to_non_nullable
as bool,needsReConsent: null == needsReConsent ? _self.needsReConsent : needsReConsent // ignore: cast_nullable_to_non_nullable
as bool,missingDocuments: null == missingDocuments ? _self._missingDocuments : missingDocuments // ignore: cast_nullable_to_non_nullable
as List<String>,outdatedDocuments: null == outdatedDocuments ? _self._outdatedDocuments : outdatedDocuments // ignore: cast_nullable_to_non_nullable
as List<String>,currentTosVersion: freezed == currentTosVersion ? _self.currentTosVersion : currentTosVersion // ignore: cast_nullable_to_non_nullable
as String?,currentPrivacyVersion: freezed == currentPrivacyVersion ? _self.currentPrivacyVersion : currentPrivacyVersion // ignore: cast_nullable_to_non_nullable
as String?,latestTosVersion: freezed == latestTosVersion ? _self.latestTosVersion : latestTosVersion // ignore: cast_nullable_to_non_nullable
as String?,latestPrivacyVersion: freezed == latestPrivacyVersion ? _self.latestPrivacyVersion : latestPrivacyVersion // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$LegalStatistics {

 int get totalUsers; int get usersWithConsent; int get usersNeedingReConsent; Map<String, int> get consentByVersion; Map<String, int> get consentByLanguage; DateTime get lastUpdated;
/// Create a copy of LegalStatistics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LegalStatisticsCopyWith<LegalStatistics> get copyWith => _$LegalStatisticsCopyWithImpl<LegalStatistics>(this as LegalStatistics, _$identity);

  /// Serializes this LegalStatistics to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LegalStatistics&&(identical(other.totalUsers, totalUsers) || other.totalUsers == totalUsers)&&(identical(other.usersWithConsent, usersWithConsent) || other.usersWithConsent == usersWithConsent)&&(identical(other.usersNeedingReConsent, usersNeedingReConsent) || other.usersNeedingReConsent == usersNeedingReConsent)&&const DeepCollectionEquality().equals(other.consentByVersion, consentByVersion)&&const DeepCollectionEquality().equals(other.consentByLanguage, consentByLanguage)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalUsers,usersWithConsent,usersNeedingReConsent,const DeepCollectionEquality().hash(consentByVersion),const DeepCollectionEquality().hash(consentByLanguage),lastUpdated);

@override
String toString() {
  return 'LegalStatistics(totalUsers: $totalUsers, usersWithConsent: $usersWithConsent, usersNeedingReConsent: $usersNeedingReConsent, consentByVersion: $consentByVersion, consentByLanguage: $consentByLanguage, lastUpdated: $lastUpdated)';
}


}

/// @nodoc
abstract mixin class $LegalStatisticsCopyWith<$Res>  {
  factory $LegalStatisticsCopyWith(LegalStatistics value, $Res Function(LegalStatistics) _then) = _$LegalStatisticsCopyWithImpl;
@useResult
$Res call({
 int totalUsers, int usersWithConsent, int usersNeedingReConsent, Map<String, int> consentByVersion, Map<String, int> consentByLanguage, DateTime lastUpdated
});




}
/// @nodoc
class _$LegalStatisticsCopyWithImpl<$Res>
    implements $LegalStatisticsCopyWith<$Res> {
  _$LegalStatisticsCopyWithImpl(this._self, this._then);

  final LegalStatistics _self;
  final $Res Function(LegalStatistics) _then;

/// Create a copy of LegalStatistics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalUsers = null,Object? usersWithConsent = null,Object? usersNeedingReConsent = null,Object? consentByVersion = null,Object? consentByLanguage = null,Object? lastUpdated = null,}) {
  return _then(_self.copyWith(
totalUsers: null == totalUsers ? _self.totalUsers : totalUsers // ignore: cast_nullable_to_non_nullable
as int,usersWithConsent: null == usersWithConsent ? _self.usersWithConsent : usersWithConsent // ignore: cast_nullable_to_non_nullable
as int,usersNeedingReConsent: null == usersNeedingReConsent ? _self.usersNeedingReConsent : usersNeedingReConsent // ignore: cast_nullable_to_non_nullable
as int,consentByVersion: null == consentByVersion ? _self.consentByVersion : consentByVersion // ignore: cast_nullable_to_non_nullable
as Map<String, int>,consentByLanguage: null == consentByLanguage ? _self.consentByLanguage : consentByLanguage // ignore: cast_nullable_to_non_nullable
as Map<String, int>,lastUpdated: null == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [LegalStatistics].
extension LegalStatisticsPatterns on LegalStatistics {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LegalStatistics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LegalStatistics() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LegalStatistics value)  $default,){
final _that = this;
switch (_that) {
case _LegalStatistics():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LegalStatistics value)?  $default,){
final _that = this;
switch (_that) {
case _LegalStatistics() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalUsers,  int usersWithConsent,  int usersNeedingReConsent,  Map<String, int> consentByVersion,  Map<String, int> consentByLanguage,  DateTime lastUpdated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LegalStatistics() when $default != null:
return $default(_that.totalUsers,_that.usersWithConsent,_that.usersNeedingReConsent,_that.consentByVersion,_that.consentByLanguage,_that.lastUpdated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalUsers,  int usersWithConsent,  int usersNeedingReConsent,  Map<String, int> consentByVersion,  Map<String, int> consentByLanguage,  DateTime lastUpdated)  $default,) {final _that = this;
switch (_that) {
case _LegalStatistics():
return $default(_that.totalUsers,_that.usersWithConsent,_that.usersNeedingReConsent,_that.consentByVersion,_that.consentByLanguage,_that.lastUpdated);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalUsers,  int usersWithConsent,  int usersNeedingReConsent,  Map<String, int> consentByVersion,  Map<String, int> consentByLanguage,  DateTime lastUpdated)?  $default,) {final _that = this;
switch (_that) {
case _LegalStatistics() when $default != null:
return $default(_that.totalUsers,_that.usersWithConsent,_that.usersNeedingReConsent,_that.consentByVersion,_that.consentByLanguage,_that.lastUpdated);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LegalStatistics extends LegalStatistics {
  const _LegalStatistics({required this.totalUsers, required this.usersWithConsent, required this.usersNeedingReConsent, required final  Map<String, int> consentByVersion, required final  Map<String, int> consentByLanguage, required this.lastUpdated}): _consentByVersion = consentByVersion,_consentByLanguage = consentByLanguage,super._();
  factory _LegalStatistics.fromJson(Map<String, dynamic> json) => _$LegalStatisticsFromJson(json);

@override final  int totalUsers;
@override final  int usersWithConsent;
@override final  int usersNeedingReConsent;
 final  Map<String, int> _consentByVersion;
@override Map<String, int> get consentByVersion {
  if (_consentByVersion is EqualUnmodifiableMapView) return _consentByVersion;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_consentByVersion);
}

 final  Map<String, int> _consentByLanguage;
@override Map<String, int> get consentByLanguage {
  if (_consentByLanguage is EqualUnmodifiableMapView) return _consentByLanguage;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_consentByLanguage);
}

@override final  DateTime lastUpdated;

/// Create a copy of LegalStatistics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LegalStatisticsCopyWith<_LegalStatistics> get copyWith => __$LegalStatisticsCopyWithImpl<_LegalStatistics>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LegalStatisticsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LegalStatistics&&(identical(other.totalUsers, totalUsers) || other.totalUsers == totalUsers)&&(identical(other.usersWithConsent, usersWithConsent) || other.usersWithConsent == usersWithConsent)&&(identical(other.usersNeedingReConsent, usersNeedingReConsent) || other.usersNeedingReConsent == usersNeedingReConsent)&&const DeepCollectionEquality().equals(other._consentByVersion, _consentByVersion)&&const DeepCollectionEquality().equals(other._consentByLanguage, _consentByLanguage)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalUsers,usersWithConsent,usersNeedingReConsent,const DeepCollectionEquality().hash(_consentByVersion),const DeepCollectionEquality().hash(_consentByLanguage),lastUpdated);

@override
String toString() {
  return 'LegalStatistics(totalUsers: $totalUsers, usersWithConsent: $usersWithConsent, usersNeedingReConsent: $usersNeedingReConsent, consentByVersion: $consentByVersion, consentByLanguage: $consentByLanguage, lastUpdated: $lastUpdated)';
}


}

/// @nodoc
abstract mixin class _$LegalStatisticsCopyWith<$Res> implements $LegalStatisticsCopyWith<$Res> {
  factory _$LegalStatisticsCopyWith(_LegalStatistics value, $Res Function(_LegalStatistics) _then) = __$LegalStatisticsCopyWithImpl;
@override @useResult
$Res call({
 int totalUsers, int usersWithConsent, int usersNeedingReConsent, Map<String, int> consentByVersion, Map<String, int> consentByLanguage, DateTime lastUpdated
});




}
/// @nodoc
class __$LegalStatisticsCopyWithImpl<$Res>
    implements _$LegalStatisticsCopyWith<$Res> {
  __$LegalStatisticsCopyWithImpl(this._self, this._then);

  final _LegalStatistics _self;
  final $Res Function(_LegalStatistics) _then;

/// Create a copy of LegalStatistics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalUsers = null,Object? usersWithConsent = null,Object? usersNeedingReConsent = null,Object? consentByVersion = null,Object? consentByLanguage = null,Object? lastUpdated = null,}) {
  return _then(_LegalStatistics(
totalUsers: null == totalUsers ? _self.totalUsers : totalUsers // ignore: cast_nullable_to_non_nullable
as int,usersWithConsent: null == usersWithConsent ? _self.usersWithConsent : usersWithConsent // ignore: cast_nullable_to_non_nullable
as int,usersNeedingReConsent: null == usersNeedingReConsent ? _self.usersNeedingReConsent : usersNeedingReConsent // ignore: cast_nullable_to_non_nullable
as int,consentByVersion: null == consentByVersion ? _self._consentByVersion : consentByVersion // ignore: cast_nullable_to_non_nullable
as Map<String, int>,consentByLanguage: null == consentByLanguage ? _self._consentByLanguage : consentByLanguage // ignore: cast_nullable_to_non_nullable
as Map<String, int>,lastUpdated: null == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on

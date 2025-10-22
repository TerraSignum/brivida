// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Document {

 String? get id; String get proUid; DocumentType get type; String get fileName; String get storageUrl; String? get storagePath; DocumentStatus get status; String? get rejectionReason; DateTime? get expiryDate;// Review metadata
 String? get reviewedBy;@TimestampConverter() DateTime? get reviewedAt; String? get reviewNotes;// Upload metadata
 int get fileSize; String? get mimeType;@TimestampConverter() DateTime? get uploadedAt;@TimestampConverter() DateTime? get createdAt;@TimestampConverter() DateTime? get updatedAt;
/// Create a copy of Document
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentCopyWith<Document> get copyWith => _$DocumentCopyWithImpl<Document>(this as Document, _$identity);

  /// Serializes this Document to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Document&&(identical(other.id, id) || other.id == id)&&(identical(other.proUid, proUid) || other.proUid == proUid)&&(identical(other.type, type) || other.type == type)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.storageUrl, storageUrl) || other.storageUrl == storageUrl)&&(identical(other.storagePath, storagePath) || other.storagePath == storagePath)&&(identical(other.status, status) || other.status == status)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&(identical(other.reviewedBy, reviewedBy) || other.reviewedBy == reviewedBy)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt)&&(identical(other.reviewNotes, reviewNotes) || other.reviewNotes == reviewNotes)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.uploadedAt, uploadedAt) || other.uploadedAt == uploadedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,proUid,type,fileName,storageUrl,storagePath,status,rejectionReason,expiryDate,reviewedBy,reviewedAt,reviewNotes,fileSize,mimeType,uploadedAt,createdAt,updatedAt);

@override
String toString() {
  return 'Document(id: $id, proUid: $proUid, type: $type, fileName: $fileName, storageUrl: $storageUrl, storagePath: $storagePath, status: $status, rejectionReason: $rejectionReason, expiryDate: $expiryDate, reviewedBy: $reviewedBy, reviewedAt: $reviewedAt, reviewNotes: $reviewNotes, fileSize: $fileSize, mimeType: $mimeType, uploadedAt: $uploadedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $DocumentCopyWith<$Res>  {
  factory $DocumentCopyWith(Document value, $Res Function(Document) _then) = _$DocumentCopyWithImpl;
@useResult
$Res call({
 String? id, String proUid, DocumentType type, String fileName, String storageUrl, String? storagePath, DocumentStatus status, String? rejectionReason, DateTime? expiryDate, String? reviewedBy,@TimestampConverter() DateTime? reviewedAt, String? reviewNotes, int fileSize, String? mimeType,@TimestampConverter() DateTime? uploadedAt,@TimestampConverter() DateTime? createdAt,@TimestampConverter() DateTime? updatedAt
});




}
/// @nodoc
class _$DocumentCopyWithImpl<$Res>
    implements $DocumentCopyWith<$Res> {
  _$DocumentCopyWithImpl(this._self, this._then);

  final Document _self;
  final $Res Function(Document) _then;

/// Create a copy of Document
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? proUid = null,Object? type = null,Object? fileName = null,Object? storageUrl = null,Object? storagePath = freezed,Object? status = null,Object? rejectionReason = freezed,Object? expiryDate = freezed,Object? reviewedBy = freezed,Object? reviewedAt = freezed,Object? reviewNotes = freezed,Object? fileSize = null,Object? mimeType = freezed,Object? uploadedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,proUid: null == proUid ? _self.proUid : proUid // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DocumentType,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,storageUrl: null == storageUrl ? _self.storageUrl : storageUrl // ignore: cast_nullable_to_non_nullable
as String,storagePath: freezed == storagePath ? _self.storagePath : storagePath // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DocumentStatus,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,reviewedBy: freezed == reviewedBy ? _self.reviewedBy : reviewedBy // ignore: cast_nullable_to_non_nullable
as String?,reviewedAt: freezed == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reviewNotes: freezed == reviewNotes ? _self.reviewNotes : reviewNotes // ignore: cast_nullable_to_non_nullable
as String?,fileSize: null == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,uploadedAt: freezed == uploadedAt ? _self.uploadedAt : uploadedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Document].
extension DocumentPatterns on Document {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Document value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Document() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Document value)  $default,){
final _that = this;
switch (_that) {
case _Document():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Document value)?  $default,){
final _that = this;
switch (_that) {
case _Document() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String proUid,  DocumentType type,  String fileName,  String storageUrl,  String? storagePath,  DocumentStatus status,  String? rejectionReason,  DateTime? expiryDate,  String? reviewedBy, @TimestampConverter()  DateTime? reviewedAt,  String? reviewNotes,  int fileSize,  String? mimeType, @TimestampConverter()  DateTime? uploadedAt, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Document() when $default != null:
return $default(_that.id,_that.proUid,_that.type,_that.fileName,_that.storageUrl,_that.storagePath,_that.status,_that.rejectionReason,_that.expiryDate,_that.reviewedBy,_that.reviewedAt,_that.reviewNotes,_that.fileSize,_that.mimeType,_that.uploadedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String proUid,  DocumentType type,  String fileName,  String storageUrl,  String? storagePath,  DocumentStatus status,  String? rejectionReason,  DateTime? expiryDate,  String? reviewedBy, @TimestampConverter()  DateTime? reviewedAt,  String? reviewNotes,  int fileSize,  String? mimeType, @TimestampConverter()  DateTime? uploadedAt, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Document():
return $default(_that.id,_that.proUid,_that.type,_that.fileName,_that.storageUrl,_that.storagePath,_that.status,_that.rejectionReason,_that.expiryDate,_that.reviewedBy,_that.reviewedAt,_that.reviewNotes,_that.fileSize,_that.mimeType,_that.uploadedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String proUid,  DocumentType type,  String fileName,  String storageUrl,  String? storagePath,  DocumentStatus status,  String? rejectionReason,  DateTime? expiryDate,  String? reviewedBy, @TimestampConverter()  DateTime? reviewedAt,  String? reviewNotes,  int fileSize,  String? mimeType, @TimestampConverter()  DateTime? uploadedAt, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Document() when $default != null:
return $default(_that.id,_that.proUid,_that.type,_that.fileName,_that.storageUrl,_that.storagePath,_that.status,_that.rejectionReason,_that.expiryDate,_that.reviewedBy,_that.reviewedAt,_that.reviewNotes,_that.fileSize,_that.mimeType,_that.uploadedAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Document implements Document {
  const _Document({this.id, required this.proUid, required this.type, required this.fileName, required this.storageUrl, this.storagePath, this.status = DocumentStatus.pending, this.rejectionReason, this.expiryDate, this.reviewedBy, @TimestampConverter() this.reviewedAt, this.reviewNotes, this.fileSize = 0, this.mimeType, @TimestampConverter() this.uploadedAt, @TimestampConverter() this.createdAt, @TimestampConverter() this.updatedAt});
  factory _Document.fromJson(Map<String, dynamic> json) => _$DocumentFromJson(json);

@override final  String? id;
@override final  String proUid;
@override final  DocumentType type;
@override final  String fileName;
@override final  String storageUrl;
@override final  String? storagePath;
@override@JsonKey() final  DocumentStatus status;
@override final  String? rejectionReason;
@override final  DateTime? expiryDate;
// Review metadata
@override final  String? reviewedBy;
@override@TimestampConverter() final  DateTime? reviewedAt;
@override final  String? reviewNotes;
// Upload metadata
@override@JsonKey() final  int fileSize;
@override final  String? mimeType;
@override@TimestampConverter() final  DateTime? uploadedAt;
@override@TimestampConverter() final  DateTime? createdAt;
@override@TimestampConverter() final  DateTime? updatedAt;

/// Create a copy of Document
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DocumentCopyWith<_Document> get copyWith => __$DocumentCopyWithImpl<_Document>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DocumentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Document&&(identical(other.id, id) || other.id == id)&&(identical(other.proUid, proUid) || other.proUid == proUid)&&(identical(other.type, type) || other.type == type)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.storageUrl, storageUrl) || other.storageUrl == storageUrl)&&(identical(other.storagePath, storagePath) || other.storagePath == storagePath)&&(identical(other.status, status) || other.status == status)&&(identical(other.rejectionReason, rejectionReason) || other.rejectionReason == rejectionReason)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&(identical(other.reviewedBy, reviewedBy) || other.reviewedBy == reviewedBy)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt)&&(identical(other.reviewNotes, reviewNotes) || other.reviewNotes == reviewNotes)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.uploadedAt, uploadedAt) || other.uploadedAt == uploadedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,proUid,type,fileName,storageUrl,storagePath,status,rejectionReason,expiryDate,reviewedBy,reviewedAt,reviewNotes,fileSize,mimeType,uploadedAt,createdAt,updatedAt);

@override
String toString() {
  return 'Document(id: $id, proUid: $proUid, type: $type, fileName: $fileName, storageUrl: $storageUrl, storagePath: $storagePath, status: $status, rejectionReason: $rejectionReason, expiryDate: $expiryDate, reviewedBy: $reviewedBy, reviewedAt: $reviewedAt, reviewNotes: $reviewNotes, fileSize: $fileSize, mimeType: $mimeType, uploadedAt: $uploadedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$DocumentCopyWith<$Res> implements $DocumentCopyWith<$Res> {
  factory _$DocumentCopyWith(_Document value, $Res Function(_Document) _then) = __$DocumentCopyWithImpl;
@override @useResult
$Res call({
 String? id, String proUid, DocumentType type, String fileName, String storageUrl, String? storagePath, DocumentStatus status, String? rejectionReason, DateTime? expiryDate, String? reviewedBy,@TimestampConverter() DateTime? reviewedAt, String? reviewNotes, int fileSize, String? mimeType,@TimestampConverter() DateTime? uploadedAt,@TimestampConverter() DateTime? createdAt,@TimestampConverter() DateTime? updatedAt
});




}
/// @nodoc
class __$DocumentCopyWithImpl<$Res>
    implements _$DocumentCopyWith<$Res> {
  __$DocumentCopyWithImpl(this._self, this._then);

  final _Document _self;
  final $Res Function(_Document) _then;

/// Create a copy of Document
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? proUid = null,Object? type = null,Object? fileName = null,Object? storageUrl = null,Object? storagePath = freezed,Object? status = null,Object? rejectionReason = freezed,Object? expiryDate = freezed,Object? reviewedBy = freezed,Object? reviewedAt = freezed,Object? reviewNotes = freezed,Object? fileSize = null,Object? mimeType = freezed,Object? uploadedAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Document(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,proUid: null == proUid ? _self.proUid : proUid // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DocumentType,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,storageUrl: null == storageUrl ? _self.storageUrl : storageUrl // ignore: cast_nullable_to_non_nullable
as String,storagePath: freezed == storagePath ? _self.storagePath : storagePath // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DocumentStatus,rejectionReason: freezed == rejectionReason ? _self.rejectionReason : rejectionReason // ignore: cast_nullable_to_non_nullable
as String?,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,reviewedBy: freezed == reviewedBy ? _self.reviewedBy : reviewedBy // ignore: cast_nullable_to_non_nullable
as String?,reviewedAt: freezed == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reviewNotes: freezed == reviewNotes ? _self.reviewNotes : reviewNotes // ignore: cast_nullable_to_non_nullable
as String?,fileSize: null == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,uploadedAt: freezed == uploadedAt ? _self.uploadedAt : uploadedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on

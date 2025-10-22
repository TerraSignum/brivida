// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_service.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminService {

 String? get id; String get proId; AdminServicePackage get package; double get price; AdminServiceStatus get status; String? get assignedAdminId; String? get adminNotes; ContactChannel? get contactChannel; String? get stripeSessionId; String? get stripePaymentIntentId;// Timestamps
@TimestampConverter() DateTime? get createdAt;@TimestampConverter() DateTime? get updatedAt;@TimestampConverter() DateTime? get assignedAt;@TimestampConverter() DateTime? get completedAt;// Follow-up tracking
 bool get followUpSent;@TimestampConverter() DateTime? get followUpSentAt; bool get pdfGuideDelivered;
/// Create a copy of AdminService
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminServiceCopyWith<AdminService> get copyWith => _$AdminServiceCopyWithImpl<AdminService>(this as AdminService, _$identity);

  /// Serializes this AdminService to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminService&&(identical(other.id, id) || other.id == id)&&(identical(other.proId, proId) || other.proId == proId)&&(identical(other.package, package) || other.package == package)&&(identical(other.price, price) || other.price == price)&&(identical(other.status, status) || other.status == status)&&(identical(other.assignedAdminId, assignedAdminId) || other.assignedAdminId == assignedAdminId)&&(identical(other.adminNotes, adminNotes) || other.adminNotes == adminNotes)&&(identical(other.contactChannel, contactChannel) || other.contactChannel == contactChannel)&&(identical(other.stripeSessionId, stripeSessionId) || other.stripeSessionId == stripeSessionId)&&(identical(other.stripePaymentIntentId, stripePaymentIntentId) || other.stripePaymentIntentId == stripePaymentIntentId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.assignedAt, assignedAt) || other.assignedAt == assignedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.followUpSent, followUpSent) || other.followUpSent == followUpSent)&&(identical(other.followUpSentAt, followUpSentAt) || other.followUpSentAt == followUpSentAt)&&(identical(other.pdfGuideDelivered, pdfGuideDelivered) || other.pdfGuideDelivered == pdfGuideDelivered));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,proId,package,price,status,assignedAdminId,adminNotes,contactChannel,stripeSessionId,stripePaymentIntentId,createdAt,updatedAt,assignedAt,completedAt,followUpSent,followUpSentAt,pdfGuideDelivered);

@override
String toString() {
  return 'AdminService(id: $id, proId: $proId, package: $package, price: $price, status: $status, assignedAdminId: $assignedAdminId, adminNotes: $adminNotes, contactChannel: $contactChannel, stripeSessionId: $stripeSessionId, stripePaymentIntentId: $stripePaymentIntentId, createdAt: $createdAt, updatedAt: $updatedAt, assignedAt: $assignedAt, completedAt: $completedAt, followUpSent: $followUpSent, followUpSentAt: $followUpSentAt, pdfGuideDelivered: $pdfGuideDelivered)';
}


}

/// @nodoc
abstract mixin class $AdminServiceCopyWith<$Res>  {
  factory $AdminServiceCopyWith(AdminService value, $Res Function(AdminService) _then) = _$AdminServiceCopyWithImpl;
@useResult
$Res call({
 String? id, String proId, AdminServicePackage package, double price, AdminServiceStatus status, String? assignedAdminId, String? adminNotes, ContactChannel? contactChannel, String? stripeSessionId, String? stripePaymentIntentId,@TimestampConverter() DateTime? createdAt,@TimestampConverter() DateTime? updatedAt,@TimestampConverter() DateTime? assignedAt,@TimestampConverter() DateTime? completedAt, bool followUpSent,@TimestampConverter() DateTime? followUpSentAt, bool pdfGuideDelivered
});




}
/// @nodoc
class _$AdminServiceCopyWithImpl<$Res>
    implements $AdminServiceCopyWith<$Res> {
  _$AdminServiceCopyWithImpl(this._self, this._then);

  final AdminService _self;
  final $Res Function(AdminService) _then;

/// Create a copy of AdminService
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? proId = null,Object? package = null,Object? price = null,Object? status = null,Object? assignedAdminId = freezed,Object? adminNotes = freezed,Object? contactChannel = freezed,Object? stripeSessionId = freezed,Object? stripePaymentIntentId = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? assignedAt = freezed,Object? completedAt = freezed,Object? followUpSent = null,Object? followUpSentAt = freezed,Object? pdfGuideDelivered = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,proId: null == proId ? _self.proId : proId // ignore: cast_nullable_to_non_nullable
as String,package: null == package ? _self.package : package // ignore: cast_nullable_to_non_nullable
as AdminServicePackage,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AdminServiceStatus,assignedAdminId: freezed == assignedAdminId ? _self.assignedAdminId : assignedAdminId // ignore: cast_nullable_to_non_nullable
as String?,adminNotes: freezed == adminNotes ? _self.adminNotes : adminNotes // ignore: cast_nullable_to_non_nullable
as String?,contactChannel: freezed == contactChannel ? _self.contactChannel : contactChannel // ignore: cast_nullable_to_non_nullable
as ContactChannel?,stripeSessionId: freezed == stripeSessionId ? _self.stripeSessionId : stripeSessionId // ignore: cast_nullable_to_non_nullable
as String?,stripePaymentIntentId: freezed == stripePaymentIntentId ? _self.stripePaymentIntentId : stripePaymentIntentId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,assignedAt: freezed == assignedAt ? _self.assignedAt : assignedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,followUpSent: null == followUpSent ? _self.followUpSent : followUpSent // ignore: cast_nullable_to_non_nullable
as bool,followUpSentAt: freezed == followUpSentAt ? _self.followUpSentAt : followUpSentAt // ignore: cast_nullable_to_non_nullable
as DateTime?,pdfGuideDelivered: null == pdfGuideDelivered ? _self.pdfGuideDelivered : pdfGuideDelivered // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminService].
extension AdminServicePatterns on AdminService {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminService value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminService() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminService value)  $default,){
final _that = this;
switch (_that) {
case _AdminService():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminService value)?  $default,){
final _that = this;
switch (_that) {
case _AdminService() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String proId,  AdminServicePackage package,  double price,  AdminServiceStatus status,  String? assignedAdminId,  String? adminNotes,  ContactChannel? contactChannel,  String? stripeSessionId,  String? stripePaymentIntentId, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt, @TimestampConverter()  DateTime? assignedAt, @TimestampConverter()  DateTime? completedAt,  bool followUpSent, @TimestampConverter()  DateTime? followUpSentAt,  bool pdfGuideDelivered)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminService() when $default != null:
return $default(_that.id,_that.proId,_that.package,_that.price,_that.status,_that.assignedAdminId,_that.adminNotes,_that.contactChannel,_that.stripeSessionId,_that.stripePaymentIntentId,_that.createdAt,_that.updatedAt,_that.assignedAt,_that.completedAt,_that.followUpSent,_that.followUpSentAt,_that.pdfGuideDelivered);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String proId,  AdminServicePackage package,  double price,  AdminServiceStatus status,  String? assignedAdminId,  String? adminNotes,  ContactChannel? contactChannel,  String? stripeSessionId,  String? stripePaymentIntentId, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt, @TimestampConverter()  DateTime? assignedAt, @TimestampConverter()  DateTime? completedAt,  bool followUpSent, @TimestampConverter()  DateTime? followUpSentAt,  bool pdfGuideDelivered)  $default,) {final _that = this;
switch (_that) {
case _AdminService():
return $default(_that.id,_that.proId,_that.package,_that.price,_that.status,_that.assignedAdminId,_that.adminNotes,_that.contactChannel,_that.stripeSessionId,_that.stripePaymentIntentId,_that.createdAt,_that.updatedAt,_that.assignedAt,_that.completedAt,_that.followUpSent,_that.followUpSentAt,_that.pdfGuideDelivered);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String proId,  AdminServicePackage package,  double price,  AdminServiceStatus status,  String? assignedAdminId,  String? adminNotes,  ContactChannel? contactChannel,  String? stripeSessionId,  String? stripePaymentIntentId, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt, @TimestampConverter()  DateTime? assignedAt, @TimestampConverter()  DateTime? completedAt,  bool followUpSent, @TimestampConverter()  DateTime? followUpSentAt,  bool pdfGuideDelivered)?  $default,) {final _that = this;
switch (_that) {
case _AdminService() when $default != null:
return $default(_that.id,_that.proId,_that.package,_that.price,_that.status,_that.assignedAdminId,_that.adminNotes,_that.contactChannel,_that.stripeSessionId,_that.stripePaymentIntentId,_that.createdAt,_that.updatedAt,_that.assignedAt,_that.completedAt,_that.followUpSent,_that.followUpSentAt,_that.pdfGuideDelivered);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminService implements AdminService {
  const _AdminService({this.id, required this.proId, required this.package, required this.price, this.status = AdminServiceStatus.pending, this.assignedAdminId, this.adminNotes, this.contactChannel, this.stripeSessionId, this.stripePaymentIntentId, @TimestampConverter() this.createdAt, @TimestampConverter() this.updatedAt, @TimestampConverter() this.assignedAt, @TimestampConverter() this.completedAt, this.followUpSent = false, @TimestampConverter() this.followUpSentAt, this.pdfGuideDelivered = false});
  factory _AdminService.fromJson(Map<String, dynamic> json) => _$AdminServiceFromJson(json);

@override final  String? id;
@override final  String proId;
@override final  AdminServicePackage package;
@override final  double price;
@override@JsonKey() final  AdminServiceStatus status;
@override final  String? assignedAdminId;
@override final  String? adminNotes;
@override final  ContactChannel? contactChannel;
@override final  String? stripeSessionId;
@override final  String? stripePaymentIntentId;
// Timestamps
@override@TimestampConverter() final  DateTime? createdAt;
@override@TimestampConverter() final  DateTime? updatedAt;
@override@TimestampConverter() final  DateTime? assignedAt;
@override@TimestampConverter() final  DateTime? completedAt;
// Follow-up tracking
@override@JsonKey() final  bool followUpSent;
@override@TimestampConverter() final  DateTime? followUpSentAt;
@override@JsonKey() final  bool pdfGuideDelivered;

/// Create a copy of AdminService
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminServiceCopyWith<_AdminService> get copyWith => __$AdminServiceCopyWithImpl<_AdminService>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminServiceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminService&&(identical(other.id, id) || other.id == id)&&(identical(other.proId, proId) || other.proId == proId)&&(identical(other.package, package) || other.package == package)&&(identical(other.price, price) || other.price == price)&&(identical(other.status, status) || other.status == status)&&(identical(other.assignedAdminId, assignedAdminId) || other.assignedAdminId == assignedAdminId)&&(identical(other.adminNotes, adminNotes) || other.adminNotes == adminNotes)&&(identical(other.contactChannel, contactChannel) || other.contactChannel == contactChannel)&&(identical(other.stripeSessionId, stripeSessionId) || other.stripeSessionId == stripeSessionId)&&(identical(other.stripePaymentIntentId, stripePaymentIntentId) || other.stripePaymentIntentId == stripePaymentIntentId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.assignedAt, assignedAt) || other.assignedAt == assignedAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.followUpSent, followUpSent) || other.followUpSent == followUpSent)&&(identical(other.followUpSentAt, followUpSentAt) || other.followUpSentAt == followUpSentAt)&&(identical(other.pdfGuideDelivered, pdfGuideDelivered) || other.pdfGuideDelivered == pdfGuideDelivered));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,proId,package,price,status,assignedAdminId,adminNotes,contactChannel,stripeSessionId,stripePaymentIntentId,createdAt,updatedAt,assignedAt,completedAt,followUpSent,followUpSentAt,pdfGuideDelivered);

@override
String toString() {
  return 'AdminService(id: $id, proId: $proId, package: $package, price: $price, status: $status, assignedAdminId: $assignedAdminId, adminNotes: $adminNotes, contactChannel: $contactChannel, stripeSessionId: $stripeSessionId, stripePaymentIntentId: $stripePaymentIntentId, createdAt: $createdAt, updatedAt: $updatedAt, assignedAt: $assignedAt, completedAt: $completedAt, followUpSent: $followUpSent, followUpSentAt: $followUpSentAt, pdfGuideDelivered: $pdfGuideDelivered)';
}


}

/// @nodoc
abstract mixin class _$AdminServiceCopyWith<$Res> implements $AdminServiceCopyWith<$Res> {
  factory _$AdminServiceCopyWith(_AdminService value, $Res Function(_AdminService) _then) = __$AdminServiceCopyWithImpl;
@override @useResult
$Res call({
 String? id, String proId, AdminServicePackage package, double price, AdminServiceStatus status, String? assignedAdminId, String? adminNotes, ContactChannel? contactChannel, String? stripeSessionId, String? stripePaymentIntentId,@TimestampConverter() DateTime? createdAt,@TimestampConverter() DateTime? updatedAt,@TimestampConverter() DateTime? assignedAt,@TimestampConverter() DateTime? completedAt, bool followUpSent,@TimestampConverter() DateTime? followUpSentAt, bool pdfGuideDelivered
});




}
/// @nodoc
class __$AdminServiceCopyWithImpl<$Res>
    implements _$AdminServiceCopyWith<$Res> {
  __$AdminServiceCopyWithImpl(this._self, this._then);

  final _AdminService _self;
  final $Res Function(_AdminService) _then;

/// Create a copy of AdminService
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? proId = null,Object? package = null,Object? price = null,Object? status = null,Object? assignedAdminId = freezed,Object? adminNotes = freezed,Object? contactChannel = freezed,Object? stripeSessionId = freezed,Object? stripePaymentIntentId = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? assignedAt = freezed,Object? completedAt = freezed,Object? followUpSent = null,Object? followUpSentAt = freezed,Object? pdfGuideDelivered = null,}) {
  return _then(_AdminService(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,proId: null == proId ? _self.proId : proId // ignore: cast_nullable_to_non_nullable
as String,package: null == package ? _self.package : package // ignore: cast_nullable_to_non_nullable
as AdminServicePackage,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AdminServiceStatus,assignedAdminId: freezed == assignedAdminId ? _self.assignedAdminId : assignedAdminId // ignore: cast_nullable_to_non_nullable
as String?,adminNotes: freezed == adminNotes ? _self.adminNotes : adminNotes // ignore: cast_nullable_to_non_nullable
as String?,contactChannel: freezed == contactChannel ? _self.contactChannel : contactChannel // ignore: cast_nullable_to_non_nullable
as ContactChannel?,stripeSessionId: freezed == stripeSessionId ? _self.stripeSessionId : stripeSessionId // ignore: cast_nullable_to_non_nullable
as String?,stripePaymentIntentId: freezed == stripePaymentIntentId ? _self.stripePaymentIntentId : stripePaymentIntentId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,assignedAt: freezed == assignedAt ? _self.assignedAt : assignedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,followUpSent: null == followUpSent ? _self.followUpSent : followUpSent // ignore: cast_nullable_to_non_nullable
as bool,followUpSentAt: freezed == followUpSentAt ? _self.followUpSentAt : followUpSentAt // ignore: cast_nullable_to_non_nullable
as DateTime?,pdfGuideDelivered: null == pdfGuideDelivered ? _self.pdfGuideDelivered : pdfGuideDelivered // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Payment {

 String? get id; String get jobId; String get customerUid; String? get connectedAccountId; double get amountGross; String get currency; PaymentStatus get status;@TimestampConverter() DateTime? get escrowHoldUntil;@TimestampConverter() DateTime? get createdAt;@TimestampConverter() DateTime? get capturedAt;@TimestampConverter() DateTime? get transferredAt; String? get stripePaymentIntentId; String? get stripeChargeId; String? get transferId; double? get platformFee; double? get totalRefunded;@TimestampConverter() DateTime? get lastRefundedAt; bool? get autoReleased;
/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentCopyWith<Payment> get copyWith => _$PaymentCopyWithImpl<Payment>(this as Payment, _$identity);

  /// Serializes this Payment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Payment&&(identical(other.id, id) || other.id == id)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.customerUid, customerUid) || other.customerUid == customerUid)&&(identical(other.connectedAccountId, connectedAccountId) || other.connectedAccountId == connectedAccountId)&&(identical(other.amountGross, amountGross) || other.amountGross == amountGross)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.status, status) || other.status == status)&&(identical(other.escrowHoldUntil, escrowHoldUntil) || other.escrowHoldUntil == escrowHoldUntil)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.capturedAt, capturedAt) || other.capturedAt == capturedAt)&&(identical(other.transferredAt, transferredAt) || other.transferredAt == transferredAt)&&(identical(other.stripePaymentIntentId, stripePaymentIntentId) || other.stripePaymentIntentId == stripePaymentIntentId)&&(identical(other.stripeChargeId, stripeChargeId) || other.stripeChargeId == stripeChargeId)&&(identical(other.transferId, transferId) || other.transferId == transferId)&&(identical(other.platformFee, platformFee) || other.platformFee == platformFee)&&(identical(other.totalRefunded, totalRefunded) || other.totalRefunded == totalRefunded)&&(identical(other.lastRefundedAt, lastRefundedAt) || other.lastRefundedAt == lastRefundedAt)&&(identical(other.autoReleased, autoReleased) || other.autoReleased == autoReleased));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,jobId,customerUid,connectedAccountId,amountGross,currency,status,escrowHoldUntil,createdAt,capturedAt,transferredAt,stripePaymentIntentId,stripeChargeId,transferId,platformFee,totalRefunded,lastRefundedAt,autoReleased);

@override
String toString() {
  return 'Payment(id: $id, jobId: $jobId, customerUid: $customerUid, connectedAccountId: $connectedAccountId, amountGross: $amountGross, currency: $currency, status: $status, escrowHoldUntil: $escrowHoldUntil, createdAt: $createdAt, capturedAt: $capturedAt, transferredAt: $transferredAt, stripePaymentIntentId: $stripePaymentIntentId, stripeChargeId: $stripeChargeId, transferId: $transferId, platformFee: $platformFee, totalRefunded: $totalRefunded, lastRefundedAt: $lastRefundedAt, autoReleased: $autoReleased)';
}


}

/// @nodoc
abstract mixin class $PaymentCopyWith<$Res>  {
  factory $PaymentCopyWith(Payment value, $Res Function(Payment) _then) = _$PaymentCopyWithImpl;
@useResult
$Res call({
 String? id, String jobId, String customerUid, String? connectedAccountId, double amountGross, String currency, PaymentStatus status,@TimestampConverter() DateTime? escrowHoldUntil,@TimestampConverter() DateTime? createdAt,@TimestampConverter() DateTime? capturedAt,@TimestampConverter() DateTime? transferredAt, String? stripePaymentIntentId, String? stripeChargeId, String? transferId, double? platformFee, double? totalRefunded,@TimestampConverter() DateTime? lastRefundedAt, bool? autoReleased
});




}
/// @nodoc
class _$PaymentCopyWithImpl<$Res>
    implements $PaymentCopyWith<$Res> {
  _$PaymentCopyWithImpl(this._self, this._then);

  final Payment _self;
  final $Res Function(Payment) _then;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? jobId = null,Object? customerUid = null,Object? connectedAccountId = freezed,Object? amountGross = null,Object? currency = null,Object? status = null,Object? escrowHoldUntil = freezed,Object? createdAt = freezed,Object? capturedAt = freezed,Object? transferredAt = freezed,Object? stripePaymentIntentId = freezed,Object? stripeChargeId = freezed,Object? transferId = freezed,Object? platformFee = freezed,Object? totalRefunded = freezed,Object? lastRefundedAt = freezed,Object? autoReleased = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,customerUid: null == customerUid ? _self.customerUid : customerUid // ignore: cast_nullable_to_non_nullable
as String,connectedAccountId: freezed == connectedAccountId ? _self.connectedAccountId : connectedAccountId // ignore: cast_nullable_to_non_nullable
as String?,amountGross: null == amountGross ? _self.amountGross : amountGross // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PaymentStatus,escrowHoldUntil: freezed == escrowHoldUntil ? _self.escrowHoldUntil : escrowHoldUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,capturedAt: freezed == capturedAt ? _self.capturedAt : capturedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,transferredAt: freezed == transferredAt ? _self.transferredAt : transferredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,stripePaymentIntentId: freezed == stripePaymentIntentId ? _self.stripePaymentIntentId : stripePaymentIntentId // ignore: cast_nullable_to_non_nullable
as String?,stripeChargeId: freezed == stripeChargeId ? _self.stripeChargeId : stripeChargeId // ignore: cast_nullable_to_non_nullable
as String?,transferId: freezed == transferId ? _self.transferId : transferId // ignore: cast_nullable_to_non_nullable
as String?,platformFee: freezed == platformFee ? _self.platformFee : platformFee // ignore: cast_nullable_to_non_nullable
as double?,totalRefunded: freezed == totalRefunded ? _self.totalRefunded : totalRefunded // ignore: cast_nullable_to_non_nullable
as double?,lastRefundedAt: freezed == lastRefundedAt ? _self.lastRefundedAt : lastRefundedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,autoReleased: freezed == autoReleased ? _self.autoReleased : autoReleased // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [Payment].
extension PaymentPatterns on Payment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Payment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Payment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Payment value)  $default,){
final _that = this;
switch (_that) {
case _Payment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Payment value)?  $default,){
final _that = this;
switch (_that) {
case _Payment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String jobId,  String customerUid,  String? connectedAccountId,  double amountGross,  String currency,  PaymentStatus status, @TimestampConverter()  DateTime? escrowHoldUntil, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? capturedAt, @TimestampConverter()  DateTime? transferredAt,  String? stripePaymentIntentId,  String? stripeChargeId,  String? transferId,  double? platformFee,  double? totalRefunded, @TimestampConverter()  DateTime? lastRefundedAt,  bool? autoReleased)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Payment() when $default != null:
return $default(_that.id,_that.jobId,_that.customerUid,_that.connectedAccountId,_that.amountGross,_that.currency,_that.status,_that.escrowHoldUntil,_that.createdAt,_that.capturedAt,_that.transferredAt,_that.stripePaymentIntentId,_that.stripeChargeId,_that.transferId,_that.platformFee,_that.totalRefunded,_that.lastRefundedAt,_that.autoReleased);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String jobId,  String customerUid,  String? connectedAccountId,  double amountGross,  String currency,  PaymentStatus status, @TimestampConverter()  DateTime? escrowHoldUntil, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? capturedAt, @TimestampConverter()  DateTime? transferredAt,  String? stripePaymentIntentId,  String? stripeChargeId,  String? transferId,  double? platformFee,  double? totalRefunded, @TimestampConverter()  DateTime? lastRefundedAt,  bool? autoReleased)  $default,) {final _that = this;
switch (_that) {
case _Payment():
return $default(_that.id,_that.jobId,_that.customerUid,_that.connectedAccountId,_that.amountGross,_that.currency,_that.status,_that.escrowHoldUntil,_that.createdAt,_that.capturedAt,_that.transferredAt,_that.stripePaymentIntentId,_that.stripeChargeId,_that.transferId,_that.platformFee,_that.totalRefunded,_that.lastRefundedAt,_that.autoReleased);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String jobId,  String customerUid,  String? connectedAccountId,  double amountGross,  String currency,  PaymentStatus status, @TimestampConverter()  DateTime? escrowHoldUntil, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? capturedAt, @TimestampConverter()  DateTime? transferredAt,  String? stripePaymentIntentId,  String? stripeChargeId,  String? transferId,  double? platformFee,  double? totalRefunded, @TimestampConverter()  DateTime? lastRefundedAt,  bool? autoReleased)?  $default,) {final _that = this;
switch (_that) {
case _Payment() when $default != null:
return $default(_that.id,_that.jobId,_that.customerUid,_that.connectedAccountId,_that.amountGross,_that.currency,_that.status,_that.escrowHoldUntil,_that.createdAt,_that.capturedAt,_that.transferredAt,_that.stripePaymentIntentId,_that.stripeChargeId,_that.transferId,_that.platformFee,_that.totalRefunded,_that.lastRefundedAt,_that.autoReleased);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Payment implements Payment {
  const _Payment({this.id, required this.jobId, required this.customerUid, this.connectedAccountId, required this.amountGross, required this.currency, this.status = PaymentStatus.pending, @TimestampConverter() this.escrowHoldUntil, @TimestampConverter() this.createdAt, @TimestampConverter() this.capturedAt, @TimestampConverter() this.transferredAt, this.stripePaymentIntentId, this.stripeChargeId, this.transferId, this.platformFee, this.totalRefunded, @TimestampConverter() this.lastRefundedAt, this.autoReleased});
  factory _Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);

@override final  String? id;
@override final  String jobId;
@override final  String customerUid;
@override final  String? connectedAccountId;
@override final  double amountGross;
@override final  String currency;
@override@JsonKey() final  PaymentStatus status;
@override@TimestampConverter() final  DateTime? escrowHoldUntil;
@override@TimestampConverter() final  DateTime? createdAt;
@override@TimestampConverter() final  DateTime? capturedAt;
@override@TimestampConverter() final  DateTime? transferredAt;
@override final  String? stripePaymentIntentId;
@override final  String? stripeChargeId;
@override final  String? transferId;
@override final  double? platformFee;
@override final  double? totalRefunded;
@override@TimestampConverter() final  DateTime? lastRefundedAt;
@override final  bool? autoReleased;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentCopyWith<_Payment> get copyWith => __$PaymentCopyWithImpl<_Payment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Payment&&(identical(other.id, id) || other.id == id)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.customerUid, customerUid) || other.customerUid == customerUid)&&(identical(other.connectedAccountId, connectedAccountId) || other.connectedAccountId == connectedAccountId)&&(identical(other.amountGross, amountGross) || other.amountGross == amountGross)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.status, status) || other.status == status)&&(identical(other.escrowHoldUntil, escrowHoldUntil) || other.escrowHoldUntil == escrowHoldUntil)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.capturedAt, capturedAt) || other.capturedAt == capturedAt)&&(identical(other.transferredAt, transferredAt) || other.transferredAt == transferredAt)&&(identical(other.stripePaymentIntentId, stripePaymentIntentId) || other.stripePaymentIntentId == stripePaymentIntentId)&&(identical(other.stripeChargeId, stripeChargeId) || other.stripeChargeId == stripeChargeId)&&(identical(other.transferId, transferId) || other.transferId == transferId)&&(identical(other.platformFee, platformFee) || other.platformFee == platformFee)&&(identical(other.totalRefunded, totalRefunded) || other.totalRefunded == totalRefunded)&&(identical(other.lastRefundedAt, lastRefundedAt) || other.lastRefundedAt == lastRefundedAt)&&(identical(other.autoReleased, autoReleased) || other.autoReleased == autoReleased));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,jobId,customerUid,connectedAccountId,amountGross,currency,status,escrowHoldUntil,createdAt,capturedAt,transferredAt,stripePaymentIntentId,stripeChargeId,transferId,platformFee,totalRefunded,lastRefundedAt,autoReleased);

@override
String toString() {
  return 'Payment(id: $id, jobId: $jobId, customerUid: $customerUid, connectedAccountId: $connectedAccountId, amountGross: $amountGross, currency: $currency, status: $status, escrowHoldUntil: $escrowHoldUntil, createdAt: $createdAt, capturedAt: $capturedAt, transferredAt: $transferredAt, stripePaymentIntentId: $stripePaymentIntentId, stripeChargeId: $stripeChargeId, transferId: $transferId, platformFee: $platformFee, totalRefunded: $totalRefunded, lastRefundedAt: $lastRefundedAt, autoReleased: $autoReleased)';
}


}

/// @nodoc
abstract mixin class _$PaymentCopyWith<$Res> implements $PaymentCopyWith<$Res> {
  factory _$PaymentCopyWith(_Payment value, $Res Function(_Payment) _then) = __$PaymentCopyWithImpl;
@override @useResult
$Res call({
 String? id, String jobId, String customerUid, String? connectedAccountId, double amountGross, String currency, PaymentStatus status,@TimestampConverter() DateTime? escrowHoldUntil,@TimestampConverter() DateTime? createdAt,@TimestampConverter() DateTime? capturedAt,@TimestampConverter() DateTime? transferredAt, String? stripePaymentIntentId, String? stripeChargeId, String? transferId, double? platformFee, double? totalRefunded,@TimestampConverter() DateTime? lastRefundedAt, bool? autoReleased
});




}
/// @nodoc
class __$PaymentCopyWithImpl<$Res>
    implements _$PaymentCopyWith<$Res> {
  __$PaymentCopyWithImpl(this._self, this._then);

  final _Payment _self;
  final $Res Function(_Payment) _then;

/// Create a copy of Payment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? jobId = null,Object? customerUid = null,Object? connectedAccountId = freezed,Object? amountGross = null,Object? currency = null,Object? status = null,Object? escrowHoldUntil = freezed,Object? createdAt = freezed,Object? capturedAt = freezed,Object? transferredAt = freezed,Object? stripePaymentIntentId = freezed,Object? stripeChargeId = freezed,Object? transferId = freezed,Object? platformFee = freezed,Object? totalRefunded = freezed,Object? lastRefundedAt = freezed,Object? autoReleased = freezed,}) {
  return _then(_Payment(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,customerUid: null == customerUid ? _self.customerUid : customerUid // ignore: cast_nullable_to_non_nullable
as String,connectedAccountId: freezed == connectedAccountId ? _self.connectedAccountId : connectedAccountId // ignore: cast_nullable_to_non_nullable
as String?,amountGross: null == amountGross ? _self.amountGross : amountGross // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PaymentStatus,escrowHoldUntil: freezed == escrowHoldUntil ? _self.escrowHoldUntil : escrowHoldUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,capturedAt: freezed == capturedAt ? _self.capturedAt : capturedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,transferredAt: freezed == transferredAt ? _self.transferredAt : transferredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,stripePaymentIntentId: freezed == stripePaymentIntentId ? _self.stripePaymentIntentId : stripePaymentIntentId // ignore: cast_nullable_to_non_nullable
as String?,stripeChargeId: freezed == stripeChargeId ? _self.stripeChargeId : stripeChargeId // ignore: cast_nullable_to_non_nullable
as String?,transferId: freezed == transferId ? _self.transferId : transferId // ignore: cast_nullable_to_non_nullable
as String?,platformFee: freezed == platformFee ? _self.platformFee : platformFee // ignore: cast_nullable_to_non_nullable
as double?,totalRefunded: freezed == totalRefunded ? _self.totalRefunded : totalRefunded // ignore: cast_nullable_to_non_nullable
as double?,lastRefundedAt: freezed == lastRefundedAt ? _self.lastRefundedAt : lastRefundedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,autoReleased: freezed == autoReleased ? _self.autoReleased : autoReleased // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$Transfer {

 String? get id; String get paymentId; String get jobId; String? get proUid;// Added for PG-12: Pro user ID for security & queries
 String get connectedAccountId; double get amountNet; double get platformFee; double? get amountGross;// Added for PG-12: Total amount from customer
 String get currency; TransferStatus get status; bool get manualRelease; String? get releasedBy;@TimestampConverter() DateTime? get createdAt;@TimestampConverter() DateTime? get completedAt;@TimestampConverter() DateTime? get releasedAt;// Added for PG-12: When transfer was released
 String? get stripeTransferId;
/// Create a copy of Transfer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransferCopyWith<Transfer> get copyWith => _$TransferCopyWithImpl<Transfer>(this as Transfer, _$identity);

  /// Serializes this Transfer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Transfer&&(identical(other.id, id) || other.id == id)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.proUid, proUid) || other.proUid == proUid)&&(identical(other.connectedAccountId, connectedAccountId) || other.connectedAccountId == connectedAccountId)&&(identical(other.amountNet, amountNet) || other.amountNet == amountNet)&&(identical(other.platformFee, platformFee) || other.platformFee == platformFee)&&(identical(other.amountGross, amountGross) || other.amountGross == amountGross)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.status, status) || other.status == status)&&(identical(other.manualRelease, manualRelease) || other.manualRelease == manualRelease)&&(identical(other.releasedBy, releasedBy) || other.releasedBy == releasedBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.releasedAt, releasedAt) || other.releasedAt == releasedAt)&&(identical(other.stripeTransferId, stripeTransferId) || other.stripeTransferId == stripeTransferId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,paymentId,jobId,proUid,connectedAccountId,amountNet,platformFee,amountGross,currency,status,manualRelease,releasedBy,createdAt,completedAt,releasedAt,stripeTransferId);

@override
String toString() {
  return 'Transfer(id: $id, paymentId: $paymentId, jobId: $jobId, proUid: $proUid, connectedAccountId: $connectedAccountId, amountNet: $amountNet, platformFee: $platformFee, amountGross: $amountGross, currency: $currency, status: $status, manualRelease: $manualRelease, releasedBy: $releasedBy, createdAt: $createdAt, completedAt: $completedAt, releasedAt: $releasedAt, stripeTransferId: $stripeTransferId)';
}


}

/// @nodoc
abstract mixin class $TransferCopyWith<$Res>  {
  factory $TransferCopyWith(Transfer value, $Res Function(Transfer) _then) = _$TransferCopyWithImpl;
@useResult
$Res call({
 String? id, String paymentId, String jobId, String? proUid, String connectedAccountId, double amountNet, double platformFee, double? amountGross, String currency, TransferStatus status, bool manualRelease, String? releasedBy,@TimestampConverter() DateTime? createdAt,@TimestampConverter() DateTime? completedAt,@TimestampConverter() DateTime? releasedAt, String? stripeTransferId
});




}
/// @nodoc
class _$TransferCopyWithImpl<$Res>
    implements $TransferCopyWith<$Res> {
  _$TransferCopyWithImpl(this._self, this._then);

  final Transfer _self;
  final $Res Function(Transfer) _then;

/// Create a copy of Transfer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? paymentId = null,Object? jobId = null,Object? proUid = freezed,Object? connectedAccountId = null,Object? amountNet = null,Object? platformFee = null,Object? amountGross = freezed,Object? currency = null,Object? status = null,Object? manualRelease = null,Object? releasedBy = freezed,Object? createdAt = freezed,Object? completedAt = freezed,Object? releasedAt = freezed,Object? stripeTransferId = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,paymentId: null == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String,jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,proUid: freezed == proUid ? _self.proUid : proUid // ignore: cast_nullable_to_non_nullable
as String?,connectedAccountId: null == connectedAccountId ? _self.connectedAccountId : connectedAccountId // ignore: cast_nullable_to_non_nullable
as String,amountNet: null == amountNet ? _self.amountNet : amountNet // ignore: cast_nullable_to_non_nullable
as double,platformFee: null == platformFee ? _self.platformFee : platformFee // ignore: cast_nullable_to_non_nullable
as double,amountGross: freezed == amountGross ? _self.amountGross : amountGross // ignore: cast_nullable_to_non_nullable
as double?,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TransferStatus,manualRelease: null == manualRelease ? _self.manualRelease : manualRelease // ignore: cast_nullable_to_non_nullable
as bool,releasedBy: freezed == releasedBy ? _self.releasedBy : releasedBy // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,releasedAt: freezed == releasedAt ? _self.releasedAt : releasedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,stripeTransferId: freezed == stripeTransferId ? _self.stripeTransferId : stripeTransferId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Transfer].
extension TransferPatterns on Transfer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Transfer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Transfer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Transfer value)  $default,){
final _that = this;
switch (_that) {
case _Transfer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Transfer value)?  $default,){
final _that = this;
switch (_that) {
case _Transfer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String paymentId,  String jobId,  String? proUid,  String connectedAccountId,  double amountNet,  double platformFee,  double? amountGross,  String currency,  TransferStatus status,  bool manualRelease,  String? releasedBy, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? completedAt, @TimestampConverter()  DateTime? releasedAt,  String? stripeTransferId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Transfer() when $default != null:
return $default(_that.id,_that.paymentId,_that.jobId,_that.proUid,_that.connectedAccountId,_that.amountNet,_that.platformFee,_that.amountGross,_that.currency,_that.status,_that.manualRelease,_that.releasedBy,_that.createdAt,_that.completedAt,_that.releasedAt,_that.stripeTransferId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String paymentId,  String jobId,  String? proUid,  String connectedAccountId,  double amountNet,  double platformFee,  double? amountGross,  String currency,  TransferStatus status,  bool manualRelease,  String? releasedBy, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? completedAt, @TimestampConverter()  DateTime? releasedAt,  String? stripeTransferId)  $default,) {final _that = this;
switch (_that) {
case _Transfer():
return $default(_that.id,_that.paymentId,_that.jobId,_that.proUid,_that.connectedAccountId,_that.amountNet,_that.platformFee,_that.amountGross,_that.currency,_that.status,_that.manualRelease,_that.releasedBy,_that.createdAt,_that.completedAt,_that.releasedAt,_that.stripeTransferId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String paymentId,  String jobId,  String? proUid,  String connectedAccountId,  double amountNet,  double platformFee,  double? amountGross,  String currency,  TransferStatus status,  bool manualRelease,  String? releasedBy, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? completedAt, @TimestampConverter()  DateTime? releasedAt,  String? stripeTransferId)?  $default,) {final _that = this;
switch (_that) {
case _Transfer() when $default != null:
return $default(_that.id,_that.paymentId,_that.jobId,_that.proUid,_that.connectedAccountId,_that.amountNet,_that.platformFee,_that.amountGross,_that.currency,_that.status,_that.manualRelease,_that.releasedBy,_that.createdAt,_that.completedAt,_that.releasedAt,_that.stripeTransferId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Transfer implements Transfer {
  const _Transfer({this.id, required this.paymentId, required this.jobId, this.proUid, required this.connectedAccountId, required this.amountNet, this.platformFee = 0.0, this.amountGross, required this.currency, this.status = TransferStatus.pending, this.manualRelease = false, this.releasedBy, @TimestampConverter() this.createdAt, @TimestampConverter() this.completedAt, @TimestampConverter() this.releasedAt, this.stripeTransferId});
  factory _Transfer.fromJson(Map<String, dynamic> json) => _$TransferFromJson(json);

@override final  String? id;
@override final  String paymentId;
@override final  String jobId;
@override final  String? proUid;
// Added for PG-12: Pro user ID for security & queries
@override final  String connectedAccountId;
@override final  double amountNet;
@override@JsonKey() final  double platformFee;
@override final  double? amountGross;
// Added for PG-12: Total amount from customer
@override final  String currency;
@override@JsonKey() final  TransferStatus status;
@override@JsonKey() final  bool manualRelease;
@override final  String? releasedBy;
@override@TimestampConverter() final  DateTime? createdAt;
@override@TimestampConverter() final  DateTime? completedAt;
@override@TimestampConverter() final  DateTime? releasedAt;
// Added for PG-12: When transfer was released
@override final  String? stripeTransferId;

/// Create a copy of Transfer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransferCopyWith<_Transfer> get copyWith => __$TransferCopyWithImpl<_Transfer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransferToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Transfer&&(identical(other.id, id) || other.id == id)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.proUid, proUid) || other.proUid == proUid)&&(identical(other.connectedAccountId, connectedAccountId) || other.connectedAccountId == connectedAccountId)&&(identical(other.amountNet, amountNet) || other.amountNet == amountNet)&&(identical(other.platformFee, platformFee) || other.platformFee == platformFee)&&(identical(other.amountGross, amountGross) || other.amountGross == amountGross)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.status, status) || other.status == status)&&(identical(other.manualRelease, manualRelease) || other.manualRelease == manualRelease)&&(identical(other.releasedBy, releasedBy) || other.releasedBy == releasedBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.releasedAt, releasedAt) || other.releasedAt == releasedAt)&&(identical(other.stripeTransferId, stripeTransferId) || other.stripeTransferId == stripeTransferId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,paymentId,jobId,proUid,connectedAccountId,amountNet,platformFee,amountGross,currency,status,manualRelease,releasedBy,createdAt,completedAt,releasedAt,stripeTransferId);

@override
String toString() {
  return 'Transfer(id: $id, paymentId: $paymentId, jobId: $jobId, proUid: $proUid, connectedAccountId: $connectedAccountId, amountNet: $amountNet, platformFee: $platformFee, amountGross: $amountGross, currency: $currency, status: $status, manualRelease: $manualRelease, releasedBy: $releasedBy, createdAt: $createdAt, completedAt: $completedAt, releasedAt: $releasedAt, stripeTransferId: $stripeTransferId)';
}


}

/// @nodoc
abstract mixin class _$TransferCopyWith<$Res> implements $TransferCopyWith<$Res> {
  factory _$TransferCopyWith(_Transfer value, $Res Function(_Transfer) _then) = __$TransferCopyWithImpl;
@override @useResult
$Res call({
 String? id, String paymentId, String jobId, String? proUid, String connectedAccountId, double amountNet, double platformFee, double? amountGross, String currency, TransferStatus status, bool manualRelease, String? releasedBy,@TimestampConverter() DateTime? createdAt,@TimestampConverter() DateTime? completedAt,@TimestampConverter() DateTime? releasedAt, String? stripeTransferId
});




}
/// @nodoc
class __$TransferCopyWithImpl<$Res>
    implements _$TransferCopyWith<$Res> {
  __$TransferCopyWithImpl(this._self, this._then);

  final _Transfer _self;
  final $Res Function(_Transfer) _then;

/// Create a copy of Transfer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? paymentId = null,Object? jobId = null,Object? proUid = freezed,Object? connectedAccountId = null,Object? amountNet = null,Object? platformFee = null,Object? amountGross = freezed,Object? currency = null,Object? status = null,Object? manualRelease = null,Object? releasedBy = freezed,Object? createdAt = freezed,Object? completedAt = freezed,Object? releasedAt = freezed,Object? stripeTransferId = freezed,}) {
  return _then(_Transfer(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,paymentId: null == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String,jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,proUid: freezed == proUid ? _self.proUid : proUid // ignore: cast_nullable_to_non_nullable
as String?,connectedAccountId: null == connectedAccountId ? _self.connectedAccountId : connectedAccountId // ignore: cast_nullable_to_non_nullable
as String,amountNet: null == amountNet ? _self.amountNet : amountNet // ignore: cast_nullable_to_non_nullable
as double,platformFee: null == platformFee ? _self.platformFee : platformFee // ignore: cast_nullable_to_non_nullable
as double,amountGross: freezed == amountGross ? _self.amountGross : amountGross // ignore: cast_nullable_to_non_nullable
as double?,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TransferStatus,manualRelease: null == manualRelease ? _self.manualRelease : manualRelease // ignore: cast_nullable_to_non_nullable
as bool,releasedBy: freezed == releasedBy ? _self.releasedBy : releasedBy // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,releasedAt: freezed == releasedAt ? _self.releasedAt : releasedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,stripeTransferId: freezed == stripeTransferId ? _self.stripeTransferId : stripeTransferId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Refund {

 String? get id; String get paymentId; String get jobId; double get amount; String get currency; String get reason; RefundStatus get status; String? get requestedBy;@TimestampConverter() DateTime? get createdAt; String? get stripeRefundId;
/// Create a copy of Refund
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RefundCopyWith<Refund> get copyWith => _$RefundCopyWithImpl<Refund>(this as Refund, _$identity);

  /// Serializes this Refund to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Refund&&(identical(other.id, id) || other.id == id)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.status, status) || other.status == status)&&(identical(other.requestedBy, requestedBy) || other.requestedBy == requestedBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.stripeRefundId, stripeRefundId) || other.stripeRefundId == stripeRefundId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,paymentId,jobId,amount,currency,reason,status,requestedBy,createdAt,stripeRefundId);

@override
String toString() {
  return 'Refund(id: $id, paymentId: $paymentId, jobId: $jobId, amount: $amount, currency: $currency, reason: $reason, status: $status, requestedBy: $requestedBy, createdAt: $createdAt, stripeRefundId: $stripeRefundId)';
}


}

/// @nodoc
abstract mixin class $RefundCopyWith<$Res>  {
  factory $RefundCopyWith(Refund value, $Res Function(Refund) _then) = _$RefundCopyWithImpl;
@useResult
$Res call({
 String? id, String paymentId, String jobId, double amount, String currency, String reason, RefundStatus status, String? requestedBy,@TimestampConverter() DateTime? createdAt, String? stripeRefundId
});




}
/// @nodoc
class _$RefundCopyWithImpl<$Res>
    implements $RefundCopyWith<$Res> {
  _$RefundCopyWithImpl(this._self, this._then);

  final Refund _self;
  final $Res Function(Refund) _then;

/// Create a copy of Refund
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? paymentId = null,Object? jobId = null,Object? amount = null,Object? currency = null,Object? reason = null,Object? status = null,Object? requestedBy = freezed,Object? createdAt = freezed,Object? stripeRefundId = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,paymentId: null == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String,jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RefundStatus,requestedBy: freezed == requestedBy ? _self.requestedBy : requestedBy // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,stripeRefundId: freezed == stripeRefundId ? _self.stripeRefundId : stripeRefundId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Refund].
extension RefundPatterns on Refund {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Refund value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Refund() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Refund value)  $default,){
final _that = this;
switch (_that) {
case _Refund():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Refund value)?  $default,){
final _that = this;
switch (_that) {
case _Refund() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String paymentId,  String jobId,  double amount,  String currency,  String reason,  RefundStatus status,  String? requestedBy, @TimestampConverter()  DateTime? createdAt,  String? stripeRefundId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Refund() when $default != null:
return $default(_that.id,_that.paymentId,_that.jobId,_that.amount,_that.currency,_that.reason,_that.status,_that.requestedBy,_that.createdAt,_that.stripeRefundId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String paymentId,  String jobId,  double amount,  String currency,  String reason,  RefundStatus status,  String? requestedBy, @TimestampConverter()  DateTime? createdAt,  String? stripeRefundId)  $default,) {final _that = this;
switch (_that) {
case _Refund():
return $default(_that.id,_that.paymentId,_that.jobId,_that.amount,_that.currency,_that.reason,_that.status,_that.requestedBy,_that.createdAt,_that.stripeRefundId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String paymentId,  String jobId,  double amount,  String currency,  String reason,  RefundStatus status,  String? requestedBy, @TimestampConverter()  DateTime? createdAt,  String? stripeRefundId)?  $default,) {final _that = this;
switch (_that) {
case _Refund() when $default != null:
return $default(_that.id,_that.paymentId,_that.jobId,_that.amount,_that.currency,_that.reason,_that.status,_that.requestedBy,_that.createdAt,_that.stripeRefundId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Refund implements Refund {
  const _Refund({this.id, required this.paymentId, required this.jobId, required this.amount, required this.currency, this.reason = 'requested_by_customer', this.status = RefundStatus.completed, this.requestedBy, @TimestampConverter() this.createdAt, this.stripeRefundId});
  factory _Refund.fromJson(Map<String, dynamic> json) => _$RefundFromJson(json);

@override final  String? id;
@override final  String paymentId;
@override final  String jobId;
@override final  double amount;
@override final  String currency;
@override@JsonKey() final  String reason;
@override@JsonKey() final  RefundStatus status;
@override final  String? requestedBy;
@override@TimestampConverter() final  DateTime? createdAt;
@override final  String? stripeRefundId;

/// Create a copy of Refund
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RefundCopyWith<_Refund> get copyWith => __$RefundCopyWithImpl<_Refund>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RefundToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Refund&&(identical(other.id, id) || other.id == id)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.status, status) || other.status == status)&&(identical(other.requestedBy, requestedBy) || other.requestedBy == requestedBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.stripeRefundId, stripeRefundId) || other.stripeRefundId == stripeRefundId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,paymentId,jobId,amount,currency,reason,status,requestedBy,createdAt,stripeRefundId);

@override
String toString() {
  return 'Refund(id: $id, paymentId: $paymentId, jobId: $jobId, amount: $amount, currency: $currency, reason: $reason, status: $status, requestedBy: $requestedBy, createdAt: $createdAt, stripeRefundId: $stripeRefundId)';
}


}

/// @nodoc
abstract mixin class _$RefundCopyWith<$Res> implements $RefundCopyWith<$Res> {
  factory _$RefundCopyWith(_Refund value, $Res Function(_Refund) _then) = __$RefundCopyWithImpl;
@override @useResult
$Res call({
 String? id, String paymentId, String jobId, double amount, String currency, String reason, RefundStatus status, String? requestedBy,@TimestampConverter() DateTime? createdAt, String? stripeRefundId
});




}
/// @nodoc
class __$RefundCopyWithImpl<$Res>
    implements _$RefundCopyWith<$Res> {
  __$RefundCopyWithImpl(this._self, this._then);

  final _Refund _self;
  final $Res Function(_Refund) _then;

/// Create a copy of Refund
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? paymentId = null,Object? jobId = null,Object? amount = null,Object? currency = null,Object? reason = null,Object? status = null,Object? requestedBy = freezed,Object? createdAt = freezed,Object? stripeRefundId = freezed,}) {
  return _then(_Refund(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,paymentId: null == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String,jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RefundStatus,requestedBy: freezed == requestedBy ? _self.requestedBy : requestedBy // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,stripeRefundId: freezed == stripeRefundId ? _self.stripeRefundId : stripeRefundId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

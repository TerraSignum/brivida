// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Job {

 String? get id; String get customerUid; String? get assignedProUid;// PG-14: Public address fields (visible to all)
 String? get addressCity; String? get addressDistrict; String? get addressHint; bool get hasPrivateLocation;// PG-17/18: Enhanced job fields
 double get sizeM2; int get rooms; List<String> get services; JobWindow get window; double get budget; String get notes; JobStatus get status; List<String> get visibleTo;// PG-17/18: New pricing and service fields
 JobCategory get category; double get baseHours; List<String> get extras;// ExtraId strings
 double get extrasHours; bool get materialProvidedByPro; double get materialFeeEur; bool get isExpress;// PG-17: Recurring jobs
 Map<String, dynamic> get recurrence; int get occurrenceIndex; String? get parentJobId;// For recurring instances
// PG-17: Extra features
 List<String> get extraServices; bool get materialsRequired; List<String> get checklist; List<String> get completedPhotos;// Storage URLs
// Timestamps
@TimestampConverter() DateTime? get createdAt;@TimestampConverter() DateTime? get updatedAt;// Payment-related fields
 String? get paymentId; String? get transferId; PaymentStatus get paymentStatus;@TimestampConverter() DateTime? get paymentCreatedAt;@TimestampConverter() DateTime? get paymentCompletedAt; double? get paidAmount; String? get currency; bool? get escrowReleased;@TimestampConverter() DateTime? get escrowReleasedAt;
/// Create a copy of Job
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobCopyWith<Job> get copyWith => _$JobCopyWithImpl<Job>(this as Job, _$identity);

  /// Serializes this Job to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Job&&(identical(other.id, id) || other.id == id)&&(identical(other.customerUid, customerUid) || other.customerUid == customerUid)&&(identical(other.assignedProUid, assignedProUid) || other.assignedProUid == assignedProUid)&&(identical(other.addressCity, addressCity) || other.addressCity == addressCity)&&(identical(other.addressDistrict, addressDistrict) || other.addressDistrict == addressDistrict)&&(identical(other.addressHint, addressHint) || other.addressHint == addressHint)&&(identical(other.hasPrivateLocation, hasPrivateLocation) || other.hasPrivateLocation == hasPrivateLocation)&&(identical(other.sizeM2, sizeM2) || other.sizeM2 == sizeM2)&&(identical(other.rooms, rooms) || other.rooms == rooms)&&const DeepCollectionEquality().equals(other.services, services)&&(identical(other.window, window) || other.window == window)&&(identical(other.budget, budget) || other.budget == budget)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.visibleTo, visibleTo)&&(identical(other.category, category) || other.category == category)&&(identical(other.baseHours, baseHours) || other.baseHours == baseHours)&&const DeepCollectionEquality().equals(other.extras, extras)&&(identical(other.extrasHours, extrasHours) || other.extrasHours == extrasHours)&&(identical(other.materialProvidedByPro, materialProvidedByPro) || other.materialProvidedByPro == materialProvidedByPro)&&(identical(other.materialFeeEur, materialFeeEur) || other.materialFeeEur == materialFeeEur)&&(identical(other.isExpress, isExpress) || other.isExpress == isExpress)&&const DeepCollectionEquality().equals(other.recurrence, recurrence)&&(identical(other.occurrenceIndex, occurrenceIndex) || other.occurrenceIndex == occurrenceIndex)&&(identical(other.parentJobId, parentJobId) || other.parentJobId == parentJobId)&&const DeepCollectionEquality().equals(other.extraServices, extraServices)&&(identical(other.materialsRequired, materialsRequired) || other.materialsRequired == materialsRequired)&&const DeepCollectionEquality().equals(other.checklist, checklist)&&const DeepCollectionEquality().equals(other.completedPhotos, completedPhotos)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.transferId, transferId) || other.transferId == transferId)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.paymentCreatedAt, paymentCreatedAt) || other.paymentCreatedAt == paymentCreatedAt)&&(identical(other.paymentCompletedAt, paymentCompletedAt) || other.paymentCompletedAt == paymentCompletedAt)&&(identical(other.paidAmount, paidAmount) || other.paidAmount == paidAmount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.escrowReleased, escrowReleased) || other.escrowReleased == escrowReleased)&&(identical(other.escrowReleasedAt, escrowReleasedAt) || other.escrowReleasedAt == escrowReleasedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,customerUid,assignedProUid,addressCity,addressDistrict,addressHint,hasPrivateLocation,sizeM2,rooms,const DeepCollectionEquality().hash(services),window,budget,notes,status,const DeepCollectionEquality().hash(visibleTo),category,baseHours,const DeepCollectionEquality().hash(extras),extrasHours,materialProvidedByPro,materialFeeEur,isExpress,const DeepCollectionEquality().hash(recurrence),occurrenceIndex,parentJobId,const DeepCollectionEquality().hash(extraServices),materialsRequired,const DeepCollectionEquality().hash(checklist),const DeepCollectionEquality().hash(completedPhotos),createdAt,updatedAt,paymentId,transferId,paymentStatus,paymentCreatedAt,paymentCompletedAt,paidAmount,currency,escrowReleased,escrowReleasedAt]);

@override
String toString() {
  return 'Job(id: $id, customerUid: $customerUid, assignedProUid: $assignedProUid, addressCity: $addressCity, addressDistrict: $addressDistrict, addressHint: $addressHint, hasPrivateLocation: $hasPrivateLocation, sizeM2: $sizeM2, rooms: $rooms, services: $services, window: $window, budget: $budget, notes: $notes, status: $status, visibleTo: $visibleTo, category: $category, baseHours: $baseHours, extras: $extras, extrasHours: $extrasHours, materialProvidedByPro: $materialProvidedByPro, materialFeeEur: $materialFeeEur, isExpress: $isExpress, recurrence: $recurrence, occurrenceIndex: $occurrenceIndex, parentJobId: $parentJobId, extraServices: $extraServices, materialsRequired: $materialsRequired, checklist: $checklist, completedPhotos: $completedPhotos, createdAt: $createdAt, updatedAt: $updatedAt, paymentId: $paymentId, transferId: $transferId, paymentStatus: $paymentStatus, paymentCreatedAt: $paymentCreatedAt, paymentCompletedAt: $paymentCompletedAt, paidAmount: $paidAmount, currency: $currency, escrowReleased: $escrowReleased, escrowReleasedAt: $escrowReleasedAt)';
}


}

/// @nodoc
abstract mixin class $JobCopyWith<$Res>  {
  factory $JobCopyWith(Job value, $Res Function(Job) _then) = _$JobCopyWithImpl;
@useResult
$Res call({
 String? id, String customerUid, String? assignedProUid, String? addressCity, String? addressDistrict, String? addressHint, bool hasPrivateLocation, double sizeM2, int rooms, List<String> services, JobWindow window, double budget, String notes, JobStatus status, List<String> visibleTo, JobCategory category, double baseHours, List<String> extras, double extrasHours, bool materialProvidedByPro, double materialFeeEur, bool isExpress, Map<String, dynamic> recurrence, int occurrenceIndex, String? parentJobId, List<String> extraServices, bool materialsRequired, List<String> checklist, List<String> completedPhotos,@TimestampConverter() DateTime? createdAt,@TimestampConverter() DateTime? updatedAt, String? paymentId, String? transferId, PaymentStatus paymentStatus,@TimestampConverter() DateTime? paymentCreatedAt,@TimestampConverter() DateTime? paymentCompletedAt, double? paidAmount, String? currency, bool? escrowReleased,@TimestampConverter() DateTime? escrowReleasedAt
});


$JobWindowCopyWith<$Res> get window;

}
/// @nodoc
class _$JobCopyWithImpl<$Res>
    implements $JobCopyWith<$Res> {
  _$JobCopyWithImpl(this._self, this._then);

  final Job _self;
  final $Res Function(Job) _then;

/// Create a copy of Job
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? customerUid = null,Object? assignedProUid = freezed,Object? addressCity = freezed,Object? addressDistrict = freezed,Object? addressHint = freezed,Object? hasPrivateLocation = null,Object? sizeM2 = null,Object? rooms = null,Object? services = null,Object? window = null,Object? budget = null,Object? notes = null,Object? status = null,Object? visibleTo = null,Object? category = null,Object? baseHours = null,Object? extras = null,Object? extrasHours = null,Object? materialProvidedByPro = null,Object? materialFeeEur = null,Object? isExpress = null,Object? recurrence = null,Object? occurrenceIndex = null,Object? parentJobId = freezed,Object? extraServices = null,Object? materialsRequired = null,Object? checklist = null,Object? completedPhotos = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? paymentId = freezed,Object? transferId = freezed,Object? paymentStatus = null,Object? paymentCreatedAt = freezed,Object? paymentCompletedAt = freezed,Object? paidAmount = freezed,Object? currency = freezed,Object? escrowReleased = freezed,Object? escrowReleasedAt = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,customerUid: null == customerUid ? _self.customerUid : customerUid // ignore: cast_nullable_to_non_nullable
as String,assignedProUid: freezed == assignedProUid ? _self.assignedProUid : assignedProUid // ignore: cast_nullable_to_non_nullable
as String?,addressCity: freezed == addressCity ? _self.addressCity : addressCity // ignore: cast_nullable_to_non_nullable
as String?,addressDistrict: freezed == addressDistrict ? _self.addressDistrict : addressDistrict // ignore: cast_nullable_to_non_nullable
as String?,addressHint: freezed == addressHint ? _self.addressHint : addressHint // ignore: cast_nullable_to_non_nullable
as String?,hasPrivateLocation: null == hasPrivateLocation ? _self.hasPrivateLocation : hasPrivateLocation // ignore: cast_nullable_to_non_nullable
as bool,sizeM2: null == sizeM2 ? _self.sizeM2 : sizeM2 // ignore: cast_nullable_to_non_nullable
as double,rooms: null == rooms ? _self.rooms : rooms // ignore: cast_nullable_to_non_nullable
as int,services: null == services ? _self.services : services // ignore: cast_nullable_to_non_nullable
as List<String>,window: null == window ? _self.window : window // ignore: cast_nullable_to_non_nullable
as JobWindow,budget: null == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as double,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as JobStatus,visibleTo: null == visibleTo ? _self.visibleTo : visibleTo // ignore: cast_nullable_to_non_nullable
as List<String>,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as JobCategory,baseHours: null == baseHours ? _self.baseHours : baseHours // ignore: cast_nullable_to_non_nullable
as double,extras: null == extras ? _self.extras : extras // ignore: cast_nullable_to_non_nullable
as List<String>,extrasHours: null == extrasHours ? _self.extrasHours : extrasHours // ignore: cast_nullable_to_non_nullable
as double,materialProvidedByPro: null == materialProvidedByPro ? _self.materialProvidedByPro : materialProvidedByPro // ignore: cast_nullable_to_non_nullable
as bool,materialFeeEur: null == materialFeeEur ? _self.materialFeeEur : materialFeeEur // ignore: cast_nullable_to_non_nullable
as double,isExpress: null == isExpress ? _self.isExpress : isExpress // ignore: cast_nullable_to_non_nullable
as bool,recurrence: null == recurrence ? _self.recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,occurrenceIndex: null == occurrenceIndex ? _self.occurrenceIndex : occurrenceIndex // ignore: cast_nullable_to_non_nullable
as int,parentJobId: freezed == parentJobId ? _self.parentJobId : parentJobId // ignore: cast_nullable_to_non_nullable
as String?,extraServices: null == extraServices ? _self.extraServices : extraServices // ignore: cast_nullable_to_non_nullable
as List<String>,materialsRequired: null == materialsRequired ? _self.materialsRequired : materialsRequired // ignore: cast_nullable_to_non_nullable
as bool,checklist: null == checklist ? _self.checklist : checklist // ignore: cast_nullable_to_non_nullable
as List<String>,completedPhotos: null == completedPhotos ? _self.completedPhotos : completedPhotos // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,paymentId: freezed == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String?,transferId: freezed == transferId ? _self.transferId : transferId // ignore: cast_nullable_to_non_nullable
as String?,paymentStatus: null == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as PaymentStatus,paymentCreatedAt: freezed == paymentCreatedAt ? _self.paymentCreatedAt : paymentCreatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,paymentCompletedAt: freezed == paymentCompletedAt ? _self.paymentCompletedAt : paymentCompletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,paidAmount: freezed == paidAmount ? _self.paidAmount : paidAmount // ignore: cast_nullable_to_non_nullable
as double?,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,escrowReleased: freezed == escrowReleased ? _self.escrowReleased : escrowReleased // ignore: cast_nullable_to_non_nullable
as bool?,escrowReleasedAt: freezed == escrowReleasedAt ? _self.escrowReleasedAt : escrowReleasedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of Job
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JobWindowCopyWith<$Res> get window {
  
  return $JobWindowCopyWith<$Res>(_self.window, (value) {
    return _then(_self.copyWith(window: value));
  });
}
}


/// Adds pattern-matching-related methods to [Job].
extension JobPatterns on Job {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Job value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Job() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Job value)  $default,){
final _that = this;
switch (_that) {
case _Job():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Job value)?  $default,){
final _that = this;
switch (_that) {
case _Job() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String customerUid,  String? assignedProUid,  String? addressCity,  String? addressDistrict,  String? addressHint,  bool hasPrivateLocation,  double sizeM2,  int rooms,  List<String> services,  JobWindow window,  double budget,  String notes,  JobStatus status,  List<String> visibleTo,  JobCategory category,  double baseHours,  List<String> extras,  double extrasHours,  bool materialProvidedByPro,  double materialFeeEur,  bool isExpress,  Map<String, dynamic> recurrence,  int occurrenceIndex,  String? parentJobId,  List<String> extraServices,  bool materialsRequired,  List<String> checklist,  List<String> completedPhotos, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt,  String? paymentId,  String? transferId,  PaymentStatus paymentStatus, @TimestampConverter()  DateTime? paymentCreatedAt, @TimestampConverter()  DateTime? paymentCompletedAt,  double? paidAmount,  String? currency,  bool? escrowReleased, @TimestampConverter()  DateTime? escrowReleasedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Job() when $default != null:
return $default(_that.id,_that.customerUid,_that.assignedProUid,_that.addressCity,_that.addressDistrict,_that.addressHint,_that.hasPrivateLocation,_that.sizeM2,_that.rooms,_that.services,_that.window,_that.budget,_that.notes,_that.status,_that.visibleTo,_that.category,_that.baseHours,_that.extras,_that.extrasHours,_that.materialProvidedByPro,_that.materialFeeEur,_that.isExpress,_that.recurrence,_that.occurrenceIndex,_that.parentJobId,_that.extraServices,_that.materialsRequired,_that.checklist,_that.completedPhotos,_that.createdAt,_that.updatedAt,_that.paymentId,_that.transferId,_that.paymentStatus,_that.paymentCreatedAt,_that.paymentCompletedAt,_that.paidAmount,_that.currency,_that.escrowReleased,_that.escrowReleasedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String customerUid,  String? assignedProUid,  String? addressCity,  String? addressDistrict,  String? addressHint,  bool hasPrivateLocation,  double sizeM2,  int rooms,  List<String> services,  JobWindow window,  double budget,  String notes,  JobStatus status,  List<String> visibleTo,  JobCategory category,  double baseHours,  List<String> extras,  double extrasHours,  bool materialProvidedByPro,  double materialFeeEur,  bool isExpress,  Map<String, dynamic> recurrence,  int occurrenceIndex,  String? parentJobId,  List<String> extraServices,  bool materialsRequired,  List<String> checklist,  List<String> completedPhotos, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt,  String? paymentId,  String? transferId,  PaymentStatus paymentStatus, @TimestampConverter()  DateTime? paymentCreatedAt, @TimestampConverter()  DateTime? paymentCompletedAt,  double? paidAmount,  String? currency,  bool? escrowReleased, @TimestampConverter()  DateTime? escrowReleasedAt)  $default,) {final _that = this;
switch (_that) {
case _Job():
return $default(_that.id,_that.customerUid,_that.assignedProUid,_that.addressCity,_that.addressDistrict,_that.addressHint,_that.hasPrivateLocation,_that.sizeM2,_that.rooms,_that.services,_that.window,_that.budget,_that.notes,_that.status,_that.visibleTo,_that.category,_that.baseHours,_that.extras,_that.extrasHours,_that.materialProvidedByPro,_that.materialFeeEur,_that.isExpress,_that.recurrence,_that.occurrenceIndex,_that.parentJobId,_that.extraServices,_that.materialsRequired,_that.checklist,_that.completedPhotos,_that.createdAt,_that.updatedAt,_that.paymentId,_that.transferId,_that.paymentStatus,_that.paymentCreatedAt,_that.paymentCompletedAt,_that.paidAmount,_that.currency,_that.escrowReleased,_that.escrowReleasedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String customerUid,  String? assignedProUid,  String? addressCity,  String? addressDistrict,  String? addressHint,  bool hasPrivateLocation,  double sizeM2,  int rooms,  List<String> services,  JobWindow window,  double budget,  String notes,  JobStatus status,  List<String> visibleTo,  JobCategory category,  double baseHours,  List<String> extras,  double extrasHours,  bool materialProvidedByPro,  double materialFeeEur,  bool isExpress,  Map<String, dynamic> recurrence,  int occurrenceIndex,  String? parentJobId,  List<String> extraServices,  bool materialsRequired,  List<String> checklist,  List<String> completedPhotos, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt,  String? paymentId,  String? transferId,  PaymentStatus paymentStatus, @TimestampConverter()  DateTime? paymentCreatedAt, @TimestampConverter()  DateTime? paymentCompletedAt,  double? paidAmount,  String? currency,  bool? escrowReleased, @TimestampConverter()  DateTime? escrowReleasedAt)?  $default,) {final _that = this;
switch (_that) {
case _Job() when $default != null:
return $default(_that.id,_that.customerUid,_that.assignedProUid,_that.addressCity,_that.addressDistrict,_that.addressHint,_that.hasPrivateLocation,_that.sizeM2,_that.rooms,_that.services,_that.window,_that.budget,_that.notes,_that.status,_that.visibleTo,_that.category,_that.baseHours,_that.extras,_that.extrasHours,_that.materialProvidedByPro,_that.materialFeeEur,_that.isExpress,_that.recurrence,_that.occurrenceIndex,_that.parentJobId,_that.extraServices,_that.materialsRequired,_that.checklist,_that.completedPhotos,_that.createdAt,_that.updatedAt,_that.paymentId,_that.transferId,_that.paymentStatus,_that.paymentCreatedAt,_that.paymentCompletedAt,_that.paidAmount,_that.currency,_that.escrowReleased,_that.escrowReleasedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Job implements Job {
  const _Job({this.id, required this.customerUid, this.assignedProUid, this.addressCity, this.addressDistrict, this.addressHint, this.hasPrivateLocation = false, required this.sizeM2, required this.rooms, required final  List<String> services, required this.window, required this.budget, this.notes = '', this.status = JobStatus.open, final  List<String> visibleTo = const [], this.category = JobCategory.m, this.baseHours = 3.0, final  List<String> extras = const [], this.extrasHours = 0.0, this.materialProvidedByPro = false, this.materialFeeEur = 7.0, this.isExpress = false, final  Map<String, dynamic> recurrence = const {'type' : 'none', 'intervalDays' : 0}, this.occurrenceIndex = 1, this.parentJobId, final  List<String> extraServices = const [], this.materialsRequired = false, final  List<String> checklist = const [], final  List<String> completedPhotos = const [], @TimestampConverter() this.createdAt, @TimestampConverter() this.updatedAt, this.paymentId, this.transferId, this.paymentStatus = PaymentStatus.none, @TimestampConverter() this.paymentCreatedAt, @TimestampConverter() this.paymentCompletedAt, this.paidAmount, this.currency, this.escrowReleased, @TimestampConverter() this.escrowReleasedAt}): _services = services,_visibleTo = visibleTo,_extras = extras,_recurrence = recurrence,_extraServices = extraServices,_checklist = checklist,_completedPhotos = completedPhotos;
  factory _Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);

@override final  String? id;
@override final  String customerUid;
@override final  String? assignedProUid;
// PG-14: Public address fields (visible to all)
@override final  String? addressCity;
@override final  String? addressDistrict;
@override final  String? addressHint;
@override@JsonKey() final  bool hasPrivateLocation;
// PG-17/18: Enhanced job fields
@override final  double sizeM2;
@override final  int rooms;
 final  List<String> _services;
@override List<String> get services {
  if (_services is EqualUnmodifiableListView) return _services;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_services);
}

@override final  JobWindow window;
@override final  double budget;
@override@JsonKey() final  String notes;
@override@JsonKey() final  JobStatus status;
 final  List<String> _visibleTo;
@override@JsonKey() List<String> get visibleTo {
  if (_visibleTo is EqualUnmodifiableListView) return _visibleTo;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_visibleTo);
}

// PG-17/18: New pricing and service fields
@override@JsonKey() final  JobCategory category;
@override@JsonKey() final  double baseHours;
 final  List<String> _extras;
@override@JsonKey() List<String> get extras {
  if (_extras is EqualUnmodifiableListView) return _extras;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_extras);
}

// ExtraId strings
@override@JsonKey() final  double extrasHours;
@override@JsonKey() final  bool materialProvidedByPro;
@override@JsonKey() final  double materialFeeEur;
@override@JsonKey() final  bool isExpress;
// PG-17: Recurring jobs
 final  Map<String, dynamic> _recurrence;
// PG-17: Recurring jobs
@override@JsonKey() Map<String, dynamic> get recurrence {
  if (_recurrence is EqualUnmodifiableMapView) return _recurrence;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_recurrence);
}

@override@JsonKey() final  int occurrenceIndex;
@override final  String? parentJobId;
// For recurring instances
// PG-17: Extra features
 final  List<String> _extraServices;
// For recurring instances
// PG-17: Extra features
@override@JsonKey() List<String> get extraServices {
  if (_extraServices is EqualUnmodifiableListView) return _extraServices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_extraServices);
}

@override@JsonKey() final  bool materialsRequired;
 final  List<String> _checklist;
@override@JsonKey() List<String> get checklist {
  if (_checklist is EqualUnmodifiableListView) return _checklist;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_checklist);
}

 final  List<String> _completedPhotos;
@override@JsonKey() List<String> get completedPhotos {
  if (_completedPhotos is EqualUnmodifiableListView) return _completedPhotos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_completedPhotos);
}

// Storage URLs
// Timestamps
@override@TimestampConverter() final  DateTime? createdAt;
@override@TimestampConverter() final  DateTime? updatedAt;
// Payment-related fields
@override final  String? paymentId;
@override final  String? transferId;
@override@JsonKey() final  PaymentStatus paymentStatus;
@override@TimestampConverter() final  DateTime? paymentCreatedAt;
@override@TimestampConverter() final  DateTime? paymentCompletedAt;
@override final  double? paidAmount;
@override final  String? currency;
@override final  bool? escrowReleased;
@override@TimestampConverter() final  DateTime? escrowReleasedAt;

/// Create a copy of Job
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobCopyWith<_Job> get copyWith => __$JobCopyWithImpl<_Job>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Job&&(identical(other.id, id) || other.id == id)&&(identical(other.customerUid, customerUid) || other.customerUid == customerUid)&&(identical(other.assignedProUid, assignedProUid) || other.assignedProUid == assignedProUid)&&(identical(other.addressCity, addressCity) || other.addressCity == addressCity)&&(identical(other.addressDistrict, addressDistrict) || other.addressDistrict == addressDistrict)&&(identical(other.addressHint, addressHint) || other.addressHint == addressHint)&&(identical(other.hasPrivateLocation, hasPrivateLocation) || other.hasPrivateLocation == hasPrivateLocation)&&(identical(other.sizeM2, sizeM2) || other.sizeM2 == sizeM2)&&(identical(other.rooms, rooms) || other.rooms == rooms)&&const DeepCollectionEquality().equals(other._services, _services)&&(identical(other.window, window) || other.window == window)&&(identical(other.budget, budget) || other.budget == budget)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._visibleTo, _visibleTo)&&(identical(other.category, category) || other.category == category)&&(identical(other.baseHours, baseHours) || other.baseHours == baseHours)&&const DeepCollectionEquality().equals(other._extras, _extras)&&(identical(other.extrasHours, extrasHours) || other.extrasHours == extrasHours)&&(identical(other.materialProvidedByPro, materialProvidedByPro) || other.materialProvidedByPro == materialProvidedByPro)&&(identical(other.materialFeeEur, materialFeeEur) || other.materialFeeEur == materialFeeEur)&&(identical(other.isExpress, isExpress) || other.isExpress == isExpress)&&const DeepCollectionEquality().equals(other._recurrence, _recurrence)&&(identical(other.occurrenceIndex, occurrenceIndex) || other.occurrenceIndex == occurrenceIndex)&&(identical(other.parentJobId, parentJobId) || other.parentJobId == parentJobId)&&const DeepCollectionEquality().equals(other._extraServices, _extraServices)&&(identical(other.materialsRequired, materialsRequired) || other.materialsRequired == materialsRequired)&&const DeepCollectionEquality().equals(other._checklist, _checklist)&&const DeepCollectionEquality().equals(other._completedPhotos, _completedPhotos)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.paymentId, paymentId) || other.paymentId == paymentId)&&(identical(other.transferId, transferId) || other.transferId == transferId)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.paymentCreatedAt, paymentCreatedAt) || other.paymentCreatedAt == paymentCreatedAt)&&(identical(other.paymentCompletedAt, paymentCompletedAt) || other.paymentCompletedAt == paymentCompletedAt)&&(identical(other.paidAmount, paidAmount) || other.paidAmount == paidAmount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.escrowReleased, escrowReleased) || other.escrowReleased == escrowReleased)&&(identical(other.escrowReleasedAt, escrowReleasedAt) || other.escrowReleasedAt == escrowReleasedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,customerUid,assignedProUid,addressCity,addressDistrict,addressHint,hasPrivateLocation,sizeM2,rooms,const DeepCollectionEquality().hash(_services),window,budget,notes,status,const DeepCollectionEquality().hash(_visibleTo),category,baseHours,const DeepCollectionEquality().hash(_extras),extrasHours,materialProvidedByPro,materialFeeEur,isExpress,const DeepCollectionEquality().hash(_recurrence),occurrenceIndex,parentJobId,const DeepCollectionEquality().hash(_extraServices),materialsRequired,const DeepCollectionEquality().hash(_checklist),const DeepCollectionEquality().hash(_completedPhotos),createdAt,updatedAt,paymentId,transferId,paymentStatus,paymentCreatedAt,paymentCompletedAt,paidAmount,currency,escrowReleased,escrowReleasedAt]);

@override
String toString() {
  return 'Job(id: $id, customerUid: $customerUid, assignedProUid: $assignedProUid, addressCity: $addressCity, addressDistrict: $addressDistrict, addressHint: $addressHint, hasPrivateLocation: $hasPrivateLocation, sizeM2: $sizeM2, rooms: $rooms, services: $services, window: $window, budget: $budget, notes: $notes, status: $status, visibleTo: $visibleTo, category: $category, baseHours: $baseHours, extras: $extras, extrasHours: $extrasHours, materialProvidedByPro: $materialProvidedByPro, materialFeeEur: $materialFeeEur, isExpress: $isExpress, recurrence: $recurrence, occurrenceIndex: $occurrenceIndex, parentJobId: $parentJobId, extraServices: $extraServices, materialsRequired: $materialsRequired, checklist: $checklist, completedPhotos: $completedPhotos, createdAt: $createdAt, updatedAt: $updatedAt, paymentId: $paymentId, transferId: $transferId, paymentStatus: $paymentStatus, paymentCreatedAt: $paymentCreatedAt, paymentCompletedAt: $paymentCompletedAt, paidAmount: $paidAmount, currency: $currency, escrowReleased: $escrowReleased, escrowReleasedAt: $escrowReleasedAt)';
}


}

/// @nodoc
abstract mixin class _$JobCopyWith<$Res> implements $JobCopyWith<$Res> {
  factory _$JobCopyWith(_Job value, $Res Function(_Job) _then) = __$JobCopyWithImpl;
@override @useResult
$Res call({
 String? id, String customerUid, String? assignedProUid, String? addressCity, String? addressDistrict, String? addressHint, bool hasPrivateLocation, double sizeM2, int rooms, List<String> services, JobWindow window, double budget, String notes, JobStatus status, List<String> visibleTo, JobCategory category, double baseHours, List<String> extras, double extrasHours, bool materialProvidedByPro, double materialFeeEur, bool isExpress, Map<String, dynamic> recurrence, int occurrenceIndex, String? parentJobId, List<String> extraServices, bool materialsRequired, List<String> checklist, List<String> completedPhotos,@TimestampConverter() DateTime? createdAt,@TimestampConverter() DateTime? updatedAt, String? paymentId, String? transferId, PaymentStatus paymentStatus,@TimestampConverter() DateTime? paymentCreatedAt,@TimestampConverter() DateTime? paymentCompletedAt, double? paidAmount, String? currency, bool? escrowReleased,@TimestampConverter() DateTime? escrowReleasedAt
});


@override $JobWindowCopyWith<$Res> get window;

}
/// @nodoc
class __$JobCopyWithImpl<$Res>
    implements _$JobCopyWith<$Res> {
  __$JobCopyWithImpl(this._self, this._then);

  final _Job _self;
  final $Res Function(_Job) _then;

/// Create a copy of Job
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? customerUid = null,Object? assignedProUid = freezed,Object? addressCity = freezed,Object? addressDistrict = freezed,Object? addressHint = freezed,Object? hasPrivateLocation = null,Object? sizeM2 = null,Object? rooms = null,Object? services = null,Object? window = null,Object? budget = null,Object? notes = null,Object? status = null,Object? visibleTo = null,Object? category = null,Object? baseHours = null,Object? extras = null,Object? extrasHours = null,Object? materialProvidedByPro = null,Object? materialFeeEur = null,Object? isExpress = null,Object? recurrence = null,Object? occurrenceIndex = null,Object? parentJobId = freezed,Object? extraServices = null,Object? materialsRequired = null,Object? checklist = null,Object? completedPhotos = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? paymentId = freezed,Object? transferId = freezed,Object? paymentStatus = null,Object? paymentCreatedAt = freezed,Object? paymentCompletedAt = freezed,Object? paidAmount = freezed,Object? currency = freezed,Object? escrowReleased = freezed,Object? escrowReleasedAt = freezed,}) {
  return _then(_Job(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,customerUid: null == customerUid ? _self.customerUid : customerUid // ignore: cast_nullable_to_non_nullable
as String,assignedProUid: freezed == assignedProUid ? _self.assignedProUid : assignedProUid // ignore: cast_nullable_to_non_nullable
as String?,addressCity: freezed == addressCity ? _self.addressCity : addressCity // ignore: cast_nullable_to_non_nullable
as String?,addressDistrict: freezed == addressDistrict ? _self.addressDistrict : addressDistrict // ignore: cast_nullable_to_non_nullable
as String?,addressHint: freezed == addressHint ? _self.addressHint : addressHint // ignore: cast_nullable_to_non_nullable
as String?,hasPrivateLocation: null == hasPrivateLocation ? _self.hasPrivateLocation : hasPrivateLocation // ignore: cast_nullable_to_non_nullable
as bool,sizeM2: null == sizeM2 ? _self.sizeM2 : sizeM2 // ignore: cast_nullable_to_non_nullable
as double,rooms: null == rooms ? _self.rooms : rooms // ignore: cast_nullable_to_non_nullable
as int,services: null == services ? _self._services : services // ignore: cast_nullable_to_non_nullable
as List<String>,window: null == window ? _self.window : window // ignore: cast_nullable_to_non_nullable
as JobWindow,budget: null == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as double,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as JobStatus,visibleTo: null == visibleTo ? _self._visibleTo : visibleTo // ignore: cast_nullable_to_non_nullable
as List<String>,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as JobCategory,baseHours: null == baseHours ? _self.baseHours : baseHours // ignore: cast_nullable_to_non_nullable
as double,extras: null == extras ? _self._extras : extras // ignore: cast_nullable_to_non_nullable
as List<String>,extrasHours: null == extrasHours ? _self.extrasHours : extrasHours // ignore: cast_nullable_to_non_nullable
as double,materialProvidedByPro: null == materialProvidedByPro ? _self.materialProvidedByPro : materialProvidedByPro // ignore: cast_nullable_to_non_nullable
as bool,materialFeeEur: null == materialFeeEur ? _self.materialFeeEur : materialFeeEur // ignore: cast_nullable_to_non_nullable
as double,isExpress: null == isExpress ? _self.isExpress : isExpress // ignore: cast_nullable_to_non_nullable
as bool,recurrence: null == recurrence ? _self._recurrence : recurrence // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,occurrenceIndex: null == occurrenceIndex ? _self.occurrenceIndex : occurrenceIndex // ignore: cast_nullable_to_non_nullable
as int,parentJobId: freezed == parentJobId ? _self.parentJobId : parentJobId // ignore: cast_nullable_to_non_nullable
as String?,extraServices: null == extraServices ? _self._extraServices : extraServices // ignore: cast_nullable_to_non_nullable
as List<String>,materialsRequired: null == materialsRequired ? _self.materialsRequired : materialsRequired // ignore: cast_nullable_to_non_nullable
as bool,checklist: null == checklist ? _self._checklist : checklist // ignore: cast_nullable_to_non_nullable
as List<String>,completedPhotos: null == completedPhotos ? _self._completedPhotos : completedPhotos // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,paymentId: freezed == paymentId ? _self.paymentId : paymentId // ignore: cast_nullable_to_non_nullable
as String?,transferId: freezed == transferId ? _self.transferId : transferId // ignore: cast_nullable_to_non_nullable
as String?,paymentStatus: null == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as PaymentStatus,paymentCreatedAt: freezed == paymentCreatedAt ? _self.paymentCreatedAt : paymentCreatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,paymentCompletedAt: freezed == paymentCompletedAt ? _self.paymentCompletedAt : paymentCompletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,paidAmount: freezed == paidAmount ? _self.paidAmount : paidAmount // ignore: cast_nullable_to_non_nullable
as double?,currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,escrowReleased: freezed == escrowReleased ? _self.escrowReleased : escrowReleased // ignore: cast_nullable_to_non_nullable
as bool?,escrowReleasedAt: freezed == escrowReleasedAt ? _self.escrowReleasedAt : escrowReleasedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of Job
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JobWindowCopyWith<$Res> get window {
  
  return $JobWindowCopyWith<$Res>(_self.window, (value) {
    return _then(_self.copyWith(window: value));
  });
}
}


/// @nodoc
mixin _$GeoLocation {

 double get lat; double get lng;
/// Create a copy of GeoLocation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeoLocationCopyWith<GeoLocation> get copyWith => _$GeoLocationCopyWithImpl<GeoLocation>(this as GeoLocation, _$identity);

  /// Serializes this GeoLocation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeoLocation&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,lng);

@override
String toString() {
  return 'GeoLocation(lat: $lat, lng: $lng)';
}


}

/// @nodoc
abstract mixin class $GeoLocationCopyWith<$Res>  {
  factory $GeoLocationCopyWith(GeoLocation value, $Res Function(GeoLocation) _then) = _$GeoLocationCopyWithImpl;
@useResult
$Res call({
 double lat, double lng
});




}
/// @nodoc
class _$GeoLocationCopyWithImpl<$Res>
    implements $GeoLocationCopyWith<$Res> {
  _$GeoLocationCopyWithImpl(this._self, this._then);

  final GeoLocation _self;
  final $Res Function(GeoLocation) _then;

/// Create a copy of GeoLocation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lat = null,Object? lng = null,}) {
  return _then(_self.copyWith(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [GeoLocation].
extension GeoLocationPatterns on GeoLocation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeoLocation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeoLocation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeoLocation value)  $default,){
final _that = this;
switch (_that) {
case _GeoLocation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeoLocation value)?  $default,){
final _that = this;
switch (_that) {
case _GeoLocation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double lat,  double lng)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeoLocation() when $default != null:
return $default(_that.lat,_that.lng);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double lat,  double lng)  $default,) {final _that = this;
switch (_that) {
case _GeoLocation():
return $default(_that.lat,_that.lng);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double lat,  double lng)?  $default,) {final _that = this;
switch (_that) {
case _GeoLocation() when $default != null:
return $default(_that.lat,_that.lng);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeoLocation implements GeoLocation {
  const _GeoLocation({required this.lat, required this.lng});
  factory _GeoLocation.fromJson(Map<String, dynamic> json) => _$GeoLocationFromJson(json);

@override final  double lat;
@override final  double lng;

/// Create a copy of GeoLocation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeoLocationCopyWith<_GeoLocation> get copyWith => __$GeoLocationCopyWithImpl<_GeoLocation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeoLocationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeoLocation&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,lng);

@override
String toString() {
  return 'GeoLocation(lat: $lat, lng: $lng)';
}


}

/// @nodoc
abstract mixin class _$GeoLocationCopyWith<$Res> implements $GeoLocationCopyWith<$Res> {
  factory _$GeoLocationCopyWith(_GeoLocation value, $Res Function(_GeoLocation) _then) = __$GeoLocationCopyWithImpl;
@override @useResult
$Res call({
 double lat, double lng
});




}
/// @nodoc
class __$GeoLocationCopyWithImpl<$Res>
    implements _$GeoLocationCopyWith<$Res> {
  __$GeoLocationCopyWithImpl(this._self, this._then);

  final _GeoLocation _self;
  final $Res Function(_GeoLocation) _then;

/// Create a copy of GeoLocation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lat = null,Object? lng = null,}) {
  return _then(_GeoLocation(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$JobPrivate {

 String get jobId; String get addressText; String get addressFormatted; GeoLocation get location; String? get entranceNotes;@TimestampConverter() DateTime? get createdAt;@TimestampConverter() DateTime? get updatedAt;
/// Create a copy of JobPrivate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobPrivateCopyWith<JobPrivate> get copyWith => _$JobPrivateCopyWithImpl<JobPrivate>(this as JobPrivate, _$identity);

  /// Serializes this JobPrivate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobPrivate&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.addressText, addressText) || other.addressText == addressText)&&(identical(other.addressFormatted, addressFormatted) || other.addressFormatted == addressFormatted)&&(identical(other.location, location) || other.location == location)&&(identical(other.entranceNotes, entranceNotes) || other.entranceNotes == entranceNotes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,jobId,addressText,addressFormatted,location,entranceNotes,createdAt,updatedAt);

@override
String toString() {
  return 'JobPrivate(jobId: $jobId, addressText: $addressText, addressFormatted: $addressFormatted, location: $location, entranceNotes: $entranceNotes, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $JobPrivateCopyWith<$Res>  {
  factory $JobPrivateCopyWith(JobPrivate value, $Res Function(JobPrivate) _then) = _$JobPrivateCopyWithImpl;
@useResult
$Res call({
 String jobId, String addressText, String addressFormatted, GeoLocation location, String? entranceNotes,@TimestampConverter() DateTime? createdAt,@TimestampConverter() DateTime? updatedAt
});


$GeoLocationCopyWith<$Res> get location;

}
/// @nodoc
class _$JobPrivateCopyWithImpl<$Res>
    implements $JobPrivateCopyWith<$Res> {
  _$JobPrivateCopyWithImpl(this._self, this._then);

  final JobPrivate _self;
  final $Res Function(JobPrivate) _then;

/// Create a copy of JobPrivate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? jobId = null,Object? addressText = null,Object? addressFormatted = null,Object? location = null,Object? entranceNotes = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,addressText: null == addressText ? _self.addressText : addressText // ignore: cast_nullable_to_non_nullable
as String,addressFormatted: null == addressFormatted ? _self.addressFormatted : addressFormatted // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoLocation,entranceNotes: freezed == entranceNotes ? _self.entranceNotes : entranceNotes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of JobPrivate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoLocationCopyWith<$Res> get location {
  
  return $GeoLocationCopyWith<$Res>(_self.location, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}


/// Adds pattern-matching-related methods to [JobPrivate].
extension JobPrivatePatterns on JobPrivate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobPrivate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobPrivate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobPrivate value)  $default,){
final _that = this;
switch (_that) {
case _JobPrivate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobPrivate value)?  $default,){
final _that = this;
switch (_that) {
case _JobPrivate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String jobId,  String addressText,  String addressFormatted,  GeoLocation location,  String? entranceNotes, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobPrivate() when $default != null:
return $default(_that.jobId,_that.addressText,_that.addressFormatted,_that.location,_that.entranceNotes,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String jobId,  String addressText,  String addressFormatted,  GeoLocation location,  String? entranceNotes, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _JobPrivate():
return $default(_that.jobId,_that.addressText,_that.addressFormatted,_that.location,_that.entranceNotes,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String jobId,  String addressText,  String addressFormatted,  GeoLocation location,  String? entranceNotes, @TimestampConverter()  DateTime? createdAt, @TimestampConverter()  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _JobPrivate() when $default != null:
return $default(_that.jobId,_that.addressText,_that.addressFormatted,_that.location,_that.entranceNotes,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JobPrivate implements JobPrivate {
  const _JobPrivate({required this.jobId, required this.addressText, required this.addressFormatted, required this.location, this.entranceNotes, @TimestampConverter() this.createdAt, @TimestampConverter() this.updatedAt});
  factory _JobPrivate.fromJson(Map<String, dynamic> json) => _$JobPrivateFromJson(json);

@override final  String jobId;
@override final  String addressText;
@override final  String addressFormatted;
@override final  GeoLocation location;
@override final  String? entranceNotes;
@override@TimestampConverter() final  DateTime? createdAt;
@override@TimestampConverter() final  DateTime? updatedAt;

/// Create a copy of JobPrivate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobPrivateCopyWith<_JobPrivate> get copyWith => __$JobPrivateCopyWithImpl<_JobPrivate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobPrivateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobPrivate&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.addressText, addressText) || other.addressText == addressText)&&(identical(other.addressFormatted, addressFormatted) || other.addressFormatted == addressFormatted)&&(identical(other.location, location) || other.location == location)&&(identical(other.entranceNotes, entranceNotes) || other.entranceNotes == entranceNotes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,jobId,addressText,addressFormatted,location,entranceNotes,createdAt,updatedAt);

@override
String toString() {
  return 'JobPrivate(jobId: $jobId, addressText: $addressText, addressFormatted: $addressFormatted, location: $location, entranceNotes: $entranceNotes, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$JobPrivateCopyWith<$Res> implements $JobPrivateCopyWith<$Res> {
  factory _$JobPrivateCopyWith(_JobPrivate value, $Res Function(_JobPrivate) _then) = __$JobPrivateCopyWithImpl;
@override @useResult
$Res call({
 String jobId, String addressText, String addressFormatted, GeoLocation location, String? entranceNotes,@TimestampConverter() DateTime? createdAt,@TimestampConverter() DateTime? updatedAt
});


@override $GeoLocationCopyWith<$Res> get location;

}
/// @nodoc
class __$JobPrivateCopyWithImpl<$Res>
    implements _$JobPrivateCopyWith<$Res> {
  __$JobPrivateCopyWithImpl(this._self, this._then);

  final _JobPrivate _self;
  final $Res Function(_JobPrivate) _then;

/// Create a copy of JobPrivate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? jobId = null,Object? addressText = null,Object? addressFormatted = null,Object? location = null,Object? entranceNotes = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_JobPrivate(
jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,addressText: null == addressText ? _self.addressText : addressText // ignore: cast_nullable_to_non_nullable
as String,addressFormatted: null == addressFormatted ? _self.addressFormatted : addressFormatted // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoLocation,entranceNotes: freezed == entranceNotes ? _self.entranceNotes : entranceNotes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of JobPrivate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeoLocationCopyWith<$Res> get location {
  
  return $GeoLocationCopyWith<$Res>(_self.location, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}


/// @nodoc
mixin _$JobWindow {

@TimestampConverter() DateTime get start;@TimestampConverter() DateTime get end;
/// Create a copy of JobWindow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobWindowCopyWith<JobWindow> get copyWith => _$JobWindowCopyWithImpl<JobWindow>(this as JobWindow, _$identity);

  /// Serializes this JobWindow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobWindow&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,start,end);

@override
String toString() {
  return 'JobWindow(start: $start, end: $end)';
}


}

/// @nodoc
abstract mixin class $JobWindowCopyWith<$Res>  {
  factory $JobWindowCopyWith(JobWindow value, $Res Function(JobWindow) _then) = _$JobWindowCopyWithImpl;
@useResult
$Res call({
@TimestampConverter() DateTime start,@TimestampConverter() DateTime end
});




}
/// @nodoc
class _$JobWindowCopyWithImpl<$Res>
    implements $JobWindowCopyWith<$Res> {
  _$JobWindowCopyWithImpl(this._self, this._then);

  final JobWindow _self;
  final $Res Function(JobWindow) _then;

/// Create a copy of JobWindow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? start = null,Object? end = null,}) {
  return _then(_self.copyWith(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [JobWindow].
extension JobWindowPatterns on JobWindow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobWindow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobWindow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobWindow value)  $default,){
final _that = this;
switch (_that) {
case _JobWindow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobWindow value)?  $default,){
final _that = this;
switch (_that) {
case _JobWindow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@TimestampConverter()  DateTime start, @TimestampConverter()  DateTime end)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobWindow() when $default != null:
return $default(_that.start,_that.end);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@TimestampConverter()  DateTime start, @TimestampConverter()  DateTime end)  $default,) {final _that = this;
switch (_that) {
case _JobWindow():
return $default(_that.start,_that.end);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@TimestampConverter()  DateTime start, @TimestampConverter()  DateTime end)?  $default,) {final _that = this;
switch (_that) {
case _JobWindow() when $default != null:
return $default(_that.start,_that.end);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JobWindow implements JobWindow {
  const _JobWindow({@TimestampConverter() required this.start, @TimestampConverter() required this.end});
  factory _JobWindow.fromJson(Map<String, dynamic> json) => _$JobWindowFromJson(json);

@override@TimestampConverter() final  DateTime start;
@override@TimestampConverter() final  DateTime end;

/// Create a copy of JobWindow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobWindowCopyWith<_JobWindow> get copyWith => __$JobWindowCopyWithImpl<_JobWindow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JobWindowToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobWindow&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,start,end);

@override
String toString() {
  return 'JobWindow(start: $start, end: $end)';
}


}

/// @nodoc
abstract mixin class _$JobWindowCopyWith<$Res> implements $JobWindowCopyWith<$Res> {
  factory _$JobWindowCopyWith(_JobWindow value, $Res Function(_JobWindow) _then) = __$JobWindowCopyWithImpl;
@override @useResult
$Res call({
@TimestampConverter() DateTime start,@TimestampConverter() DateTime end
});




}
/// @nodoc
class __$JobWindowCopyWithImpl<$Res>
    implements _$JobWindowCopyWith<$Res> {
  __$JobWindowCopyWithImpl(this._self, this._then);

  final _JobWindow _self;
  final $Res Function(_JobWindow) _then;

/// Create a copy of JobWindow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? start = null,Object? end = null,}) {
  return _then(_JobWindow(
start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as DateTime,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on

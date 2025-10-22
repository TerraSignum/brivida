// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdminService _$AdminServiceFromJson(Map<String, dynamic> json) =>
    _AdminService(
      id: json['id'] as String?,
      proId: json['proId'] as String,
      package: $enumDecode(_$AdminServicePackageEnumMap, json['package']),
      price: (json['price'] as num).toDouble(),
      status:
          $enumDecodeNullable(_$AdminServiceStatusEnumMap, json['status']) ??
          AdminServiceStatus.pending,
      assignedAdminId: json['assignedAdminId'] as String?,
      adminNotes: json['adminNotes'] as String?,
      contactChannel: $enumDecodeNullable(
        _$ContactChannelEnumMap,
        json['contactChannel'],
      ),
      stripeSessionId: json['stripeSessionId'] as String?,
      stripePaymentIntentId: json['stripePaymentIntentId'] as String?,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
      assignedAt: const TimestampConverter().fromJson(json['assignedAt']),
      completedAt: const TimestampConverter().fromJson(json['completedAt']),
      followUpSent: json['followUpSent'] as bool? ?? false,
      followUpSentAt: const TimestampConverter().fromJson(
        json['followUpSentAt'],
      ),
      pdfGuideDelivered: json['pdfGuideDelivered'] as bool? ?? false,
    );

Map<String, dynamic> _$AdminServiceToJson(
  _AdminService instance,
) => <String, dynamic>{
  'id': instance.id,
  'proId': instance.proId,
  'package': _$AdminServicePackageEnumMap[instance.package]!,
  'price': instance.price,
  'status': _$AdminServiceStatusEnumMap[instance.status]!,
  'assignedAdminId': instance.assignedAdminId,
  'adminNotes': instance.adminNotes,
  'contactChannel': _$ContactChannelEnumMap[instance.contactChannel],
  'stripeSessionId': instance.stripeSessionId,
  'stripePaymentIntentId': instance.stripePaymentIntentId,
  'createdAt': const TimestampConverter().toJson(instance.createdAt),
  'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
  'assignedAt': const TimestampConverter().toJson(instance.assignedAt),
  'completedAt': const TimestampConverter().toJson(instance.completedAt),
  'followUpSent': instance.followUpSent,
  'followUpSentAt': const TimestampConverter().toJson(instance.followUpSentAt),
  'pdfGuideDelivered': instance.pdfGuideDelivered,
};

const _$AdminServicePackageEnumMap = {
  AdminServicePackage.basic: 'basic',
  AdminServicePackage.secure: 'secure',
};

const _$AdminServiceStatusEnumMap = {
  AdminServiceStatus.pendingPayment: 'pending_payment',
  AdminServiceStatus.pending: 'pending',
  AdminServiceStatus.assigned: 'assigned',
  AdminServiceStatus.completed: 'completed',
  AdminServiceStatus.cancelled: 'cancelled',
};

const _$ContactChannelEnumMap = {
  ContactChannel.chat: 'chat',
  ContactChannel.phone: 'phone',
  ContactChannel.inPerson: 'inPerson',
};

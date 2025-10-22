import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'admin_service.freezed.dart';
part 'admin_service.g.dart';

enum AdminServicePackage {
  @JsonValue('basic')
  basic,
  @JsonValue('secure')
  secure,
}

enum AdminServiceStatus {
  @JsonValue('pending_payment')
  pendingPayment,
  @JsonValue('pending')
  pending,
  @JsonValue('assigned')
  assigned,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

enum ContactChannel {
  @JsonValue('chat')
  chat,
  @JsonValue('phone')
  phone,
  @JsonValue('inPerson')
  inPerson,
}

/// PG-17/18: Admin service model for "Oficializa-te" registration assistance
@freezed
abstract class AdminService with _$AdminService {
  const factory AdminService({
    String? id,
    required String proId,
    required AdminServicePackage package,
    required double price,
    @Default(AdminServiceStatus.pending) AdminServiceStatus status,
    String? assignedAdminId,
    String? adminNotes,
    ContactChannel? contactChannel,
    String? stripeSessionId,
    String? stripePaymentIntentId,

    // Timestamps
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
    @TimestampConverter() DateTime? assignedAt,
    @TimestampConverter() DateTime? completedAt,

    // Follow-up tracking
    @Default(false) bool followUpSent,
    @TimestampConverter() DateTime? followUpSentAt,
    @Default(false) bool pdfGuideDelivered,
  }) = _AdminService;

  factory AdminService.fromJson(Map<String, dynamic> json) =>
      _$AdminServiceFromJson(json);

  factory AdminService.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    if (data == null) {
      throw StateError('AdminService document ${doc.id} has no data');
    }

    return AdminService.fromJson({'id': doc.id, ...data});
  }
}

/// Admin service package information
class AdminServicePackageInfo {
  final AdminServicePackage package;
  final String titleKey;
  final String subtitleKey;
  final double price;
  final List<String> featureKeys;
  final String descriptionKey;
  final bool isRecommended;

  const AdminServicePackageInfo({
    required this.package,
    required this.titleKey,
    required this.subtitleKey,
    required this.price,
    required this.featureKeys,
    required this.descriptionKey,
    this.isRecommended = false,
  });

  static const List<AdminServicePackageInfo> packages = [
    AdminServicePackageInfo(
      package: AdminServicePackage.basic,
      titleKey: 'adminServices.oficializaTe.packages.basic.title',
      subtitleKey: 'adminServices.oficializaTe.packages.basic.subtitle',
      price: 79.0,
      featureKeys: [
        'adminServices.oficializaTe.packages.basic.features.checklist',
        'adminServices.oficializaTe.packages.basic.features.remoteSupport',
        'adminServices.oficializaTe.packages.basic.features.guide',
        'adminServices.oficializaTe.packages.basic.features.preparation',
      ],
      descriptionKey: 'adminServices.oficializaTe.packages.basic.description',
    ),
    AdminServicePackageInfo(
      package: AdminServicePackage.secure,
      titleKey: 'adminServices.oficializaTe.packages.secure.title',
      subtitleKey: 'adminServices.oficializaTe.packages.secure.subtitle',
      price: 129.0,
      featureKeys: [
        'adminServices.oficializaTe.packages.secure.features.includesBasic',
        'adminServices.oficializaTe.packages.secure.features.inPerson',
        'adminServices.oficializaTe.packages.secure.features.followUp',
        'adminServices.oficializaTe.packages.secure.features.taxSupport',
        'adminServices.oficializaTe.packages.secure.features.directChat',
      ],
      descriptionKey: 'adminServices.oficializaTe.packages.secure.description',
      isRecommended: true,
    ),
  ];

  static final Map<AdminServicePackage, AdminServicePackageInfo> _byPackage = {
    for (final info in packages) info.package: info,
  };

  static AdminServicePackageInfo resolve(AdminServicePackage package) {
    final info = _byPackage[package];
    if (info == null) {
      throw ArgumentError('Unknown admin service package: $package');
    }
    return info;
  }
}

extension AdminServiceX on AdminService {
  bool get isPendingPayment => status == AdminServiceStatus.pendingPayment;

  bool get isPending => status == AdminServiceStatus.pending;

  bool get isAssigned => status == AdminServiceStatus.assigned;

  bool get isCompleted => status == AdminServiceStatus.completed;

  bool get isCancelled => status == AdminServiceStatus.cancelled;

  bool get isActionable =>
      status == AdminServiceStatus.pending ||
      status == AdminServiceStatus.assigned;

  AdminServicePackageInfo get packageInfo =>
      AdminServicePackageInfo.resolve(package);
}

extension AdminServiceStatusWireX on AdminServiceStatus {
  String get wireValue => _$AdminServiceStatusEnumMap[this]!;
}

/// Timestamp converter for Firestore
class TimestampConverter implements JsonConverter<DateTime?, Object?> {
  const TimestampConverter();

  @override
  DateTime? fromJson(Object? json) {
    if (json is Timestamp) {
      return json.toDate();
    }
    if (json is String) {
      return DateTime.tryParse(json);
    }
    return null;
  }

  @override
  Object? toJson(DateTime? object) {
    return object != null ? Timestamp.fromDate(object) : null;
  }
}

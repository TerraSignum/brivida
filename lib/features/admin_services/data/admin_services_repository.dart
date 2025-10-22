import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../../../core/config/environment.dart';
import '../../../core/models/admin_service.dart';
import '../../../core/utils/debug_logger.dart';
import 'admin_service_checkout_result.dart';

/// PG-17/18: Repository for admin services (Oficializa-te)
class AdminServicesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('adminServices');

  /// Create a Stripe checkout session for an admin service
  Future<AdminServiceCheckoutResult> createCheckoutSession(
    AdminServicePackage package,
  ) async {
    DebugLogger.enter('AdminServicesRepository.createCheckoutSession', {
      'package': package.name,
    });
    try {
      final callable = _functions.httpsCallable('createAdminServiceCheckout');
      final returnUrl = Environment.isProduction
          ? 'https://brivida.app/admin-services/success'
          : 'https://dev.brivida.app/admin-services/success';

      final result = await callable.call({
        'packageType': package.name,
        'returnUrl': returnUrl,
      });

      if (result.data is! Map) {
        throw StateError(
          'Unexpected checkout session payload: ${result.data.runtimeType}',
        );
      }

      final payload = Map<String, dynamic>.from(result.data as Map);
      final checkoutResult = AdminServiceCheckoutResult.fromMap(
        payload,
        package,
      );

      DebugLogger.exit(
        'AdminServicesRepository.createCheckoutSession',
        checkoutResult.adminServiceId,
      );
      return checkoutResult;
    } on FirebaseFunctionsException catch (e, stackTrace) {
      DebugLogger.error(
        '❌ Failed to create admin service checkout via callable',
        e,
        stackTrace,
      );
      throw Exception('Failed to create checkout session: ${e.message}');
    } catch (e, stackTrace) {
      DebugLogger.error(
        '❌ Unexpected error creating admin service checkout',
        e,
        stackTrace,
      );
      throw Exception('Failed to create checkout session: $e');
    }
  }

  /// Get admin services for a specific pro
  Stream<List<AdminService>> getAdminServicesForPro(String proId) {
    return _collection
        .where('proId', isEqualTo: proId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map(AdminService.fromDocument).toList(),
        );
  }

  /// Get all admin services (for admin console)
  Stream<List<AdminService>> getAllAdminServices({AdminServiceStatus? status}) {
    Query<Map<String, dynamic>> query = _collection.orderBy(
      'createdAt',
      descending: true,
    );

    if (status != null) {
      query = query.where('status', isEqualTo: status.wireValue);
    }

    return query.snapshots().map(
      (snapshot) => snapshot.docs.map(AdminService.fromDocument).toList(),
    );
  }

  /// Update admin service status (admin only)
  Future<void> updateAdminServiceStatus(
    String serviceId,
    AdminServiceStatus status, {
    String? adminNotes,
    String? assignedAdminId,
  }) async {
    final updateData = <String, dynamic>{
      'status': status.wireValue,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (adminNotes != null) {
      updateData['adminNotes'] = adminNotes;
    }

    if (assignedAdminId != null) {
      updateData['assignedAdminId'] = assignedAdminId;
      updateData['assignedAt'] = FieldValue.serverTimestamp();
    }

    if (status == AdminServiceStatus.completed) {
      updateData['completedAt'] = FieldValue.serverTimestamp();
    }

    await _collection.doc(serviceId).update(updateData);
  }

  /// Add admin notes to a service
  Future<void> addAdminNotes(String serviceId, String notes) async {
    await _collection.doc(serviceId).update({
      'adminNotes': notes,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Get pending admin services count
  Future<int> getPendingServicesCount() async {
    final snapshot = await _collection
        .where('status', isEqualTo: AdminServiceStatus.pending.wireValue)
        .get();

    return snapshot.docs.length;
  }

  /// Mark follow-up as sent
  Future<void> markFollowUpSent(String serviceId) async {
    await _collection.doc(serviceId).update({
      'followUpSent': true,
      'followUpSentAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Mark PDF guide as delivered
  Future<void> markPdfGuideDelivered(String serviceId) async {
    await _collection.doc(serviceId).update({
      'pdfGuideDelivered': true,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Get admin service by ID
  Future<AdminService?> getAdminService(String serviceId) async {
    final doc = await _collection.doc(serviceId).get();

    if (!doc.exists) {
      return null;
    }

    return AdminService.fromDocument(doc);
  }

  /// Search admin services
  Future<List<AdminService>> searchAdminServices({
    String? proEmail,
    AdminServicePackage? package,
    AdminServiceStatus? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    Query<Map<String, dynamic>> query = _collection;

    if (package != null) {
      query = query.where('package', isEqualTo: package.name);
    }

    if (status != null) {
      query = query.where('status', isEqualTo: status.wireValue);
    }

    if (startDate != null) {
      query = query.where(
        'createdAt',
        isGreaterThanOrEqualTo: Timestamp.fromDate(startDate),
      );
    }

    if (endDate != null) {
      query = query.where(
        'createdAt',
        isLessThanOrEqualTo: Timestamp.fromDate(endDate),
      );
    }

    final snapshot = await query
        .orderBy('createdAt', descending: true)
        .limit(100)
        .get();

    return snapshot.docs.map(AdminService.fromDocument).toList();
  }
}

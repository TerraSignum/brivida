import '../../../core/models/admin_service.dart';

/// Result returned after creating an admin service Stripe Checkout session.
class AdminServiceCheckoutResult {
  final String sessionId;
  final String checkoutUrl;
  final String adminServiceId;
  final AdminServicePackage package;

  const AdminServiceCheckoutResult({
    required this.sessionId,
    required this.checkoutUrl,
    required this.adminServiceId,
    required this.package,
  });

  factory AdminServiceCheckoutResult.fromMap(
    Map<String, dynamic> data,
    AdminServicePackage package,
  ) {
    final sessionId =
        data['sessionId'] as String? ?? data['session_id'] as String?;
    final checkoutUrl =
        data['checkoutUrl'] as String? ?? data['checkout_url'] as String?;
    final adminServiceId =
        data['adminServiceId'] as String? ??
        data['admin_service_id'] as String?;

    if (sessionId == null || checkoutUrl == null || adminServiceId == null) {
      throw StateError('Invalid checkout result payload: $data');
    }

    return AdminServiceCheckoutResult(
      sessionId: sessionId,
      checkoutUrl: checkoutUrl,
      adminServiceId: adminServiceId,
      package: package,
    );
  }
}

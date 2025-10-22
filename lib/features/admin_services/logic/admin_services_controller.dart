import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/admin_service.dart';
import '../data/admin_service_checkout_result.dart';
import '../data/admin_services_repository.dart';

/// Provider for admin services repository
final adminServicesRepositoryProvider = Provider<AdminServicesRepository>((
  ref,
) {
  return AdminServicesRepository();
});

/// Provider for admin services controller
final adminServicesControllerProvider =
    StateNotifierProvider<
      AdminServicesController,
      AsyncValue<List<AdminService>>
    >((ref) {
      return AdminServicesController(ref.read(adminServicesRepositoryProvider));
    });

/// Provider for pending admin services count
final pendingAdminServicesCountProvider = FutureProvider<int>((ref) {
  return ref.read(adminServicesRepositoryProvider).getPendingServicesCount();
});

/// Provider for admin services stream (for specific pro)
final adminServicesStreamProvider =
    StreamProvider.family<List<AdminService>, String>((ref, proId) {
      return ref
          .read(adminServicesRepositoryProvider)
          .getAdminServicesForPro(proId);
    });

/// Provider for all admin services stream (for admin console)
final allAdminServicesStreamProvider =
    StreamProvider.family<List<AdminService>, AdminServiceStatus?>((
      ref,
      status,
    ) {
      return ref
          .read(adminServicesRepositoryProvider)
          .getAllAdminServices(status: status);
    });

/// Admin services controller
class AdminServicesController
    extends StateNotifier<AsyncValue<List<AdminService>>> {
  final AdminServicesRepository _repository;

  AdminServicesController(this._repository) : super(const AsyncValue.loading());

  /// Create a checkout session for purchasing an admin service
  Future<AdminServiceCheckoutResult> createCheckoutSession(
    AdminServicePackage package,
  ) async {
    try {
      return await _repository.createCheckoutSession(package);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  /// Load admin services for a specific pro
  Future<void> loadAdminServicesForPro(String proId) async {
    state = const AsyncValue.loading();
    try {
      final stream = _repository.getAdminServicesForPro(proId);
      await for (final services in stream) {
        state = AsyncValue.data(services);
        break; // Just get the first emission for loading
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Update admin service status (admin only)
  Future<void> updateServiceStatus(
    String serviceId,
    AdminServiceStatus status, {
    String? adminNotes,
    String? assignedAdminId,
  }) async {
    try {
      await _repository.updateAdminServiceStatus(
        serviceId,
        status,
        adminNotes: adminNotes,
        assignedAdminId: assignedAdminId,
      );

      // Refresh the state
      state.whenData((services) {
        final updatedServices = services.map((service) {
          if (service.id == serviceId) {
            return service.copyWith(
              status: status,
              adminNotes: adminNotes,
              assignedAdminId: assignedAdminId,
              updatedAt: DateTime.now(),
            );
          }
          return service;
        }).toList();
        state = AsyncValue.data(updatedServices);
      });
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  /// Add admin notes to a service
  Future<void> addAdminNotes(String serviceId, String notes) async {
    try {
      await _repository.addAdminNotes(serviceId, notes);

      // Refresh the state
      state.whenData((services) {
        final updatedServices = services.map((service) {
          if (service.id == serviceId) {
            return service.copyWith(
              adminNotes: notes,
              updatedAt: DateTime.now(),
            );
          }
          return service;
        }).toList();
        state = AsyncValue.data(updatedServices);
      });
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  /// Mark follow-up as sent
  Future<void> markFollowUpSent(String serviceId) async {
    try {
      await _repository.markFollowUpSent(serviceId);

      // Refresh the state
      state.whenData((services) {
        final updatedServices = services.map((service) {
          if (service.id == serviceId) {
            return service.copyWith(
              followUpSent: true,
              followUpSentAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );
          }
          return service;
        }).toList();
        state = AsyncValue.data(updatedServices);
      });
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  /// Mark PDF guide as delivered
  Future<void> markPdfGuideDelivered(String serviceId) async {
    try {
      await _repository.markPdfGuideDelivered(serviceId);

      // Refresh the state
      state.whenData((services) {
        final updatedServices = services.map((service) {
          if (service.id == serviceId) {
            return service.copyWith(
              pdfGuideDelivered: true,
              updatedAt: DateTime.now(),
            );
          }
          return service;
        }).toList();
        state = AsyncValue.data(updatedServices);
      });
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  /// Get admin service by ID
  Future<AdminService?> getAdminService(String serviceId) async {
    try {
      return await _repository.getAdminService(serviceId);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }

  /// Search admin services
  Future<List<AdminService>> searchAdminServices({
    String? proEmail,
    AdminServicePackage? package,
    AdminServiceStatus? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      return await _repository.searchAdminServices(
        proEmail: proEmail,
        package: package,
        status: status,
        startDate: startDate,
        endDate: endDate,
      );
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
      rethrow;
    }
  }
}

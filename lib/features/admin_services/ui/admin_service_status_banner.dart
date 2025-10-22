import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/user_role_provider.dart';
import '../../../core/utils/debug_logger.dart';
import '../../../core/models/admin_service.dart';
import '../logic/admin_services_controller.dart';

class AdminServiceStatusBanner extends ConsumerWidget {
  const AdminServiceStatusBanner({super.key});

  static const _transitionDuration = Duration(milliseconds: 250);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roleAsync = ref.watch(userRoleProvider);

    return roleAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (error, stackTrace) {
        DebugLogger.error(
          'AdminServiceStatusBanner role check failed',
          error,
          stackTrace,
        );
        return const SizedBox.shrink();
      },
      data: (role) {
        if (role != AppUserRole.pro) {
          return const SizedBox.shrink();
        }

        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser == null) {
          return const SizedBox.shrink();
        }

        final servicesAsync = ref.watch(
          adminServicesStreamProvider(currentUser.uid),
        );

        return AnimatedSwitcher(
          duration: _transitionDuration,
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: servicesAsync.when(
            loading: () => const _AdminServiceBannerPlaceholder(
              key: ValueKey('admin-banner-loading'),
            ),
            error: (error, stackTrace) {
              DebugLogger.error(
                'AdminServiceStatusBanner stream failed',
                error,
                stackTrace,
              );
              return _AdminServiceErrorCard(
                key: const ValueKey('admin-banner-error'),
                error: error,
              );
            },
            data: (services) {
              if (services.isEmpty) {
                return _AdminServiceCtaCard(
                  key: const ValueKey('admin-banner-cta'),
                  onTap: () => _openOficializaTe(context),
                );
              }

              final sortedServices = [...services]
                ..sort((a, b) {
                  final aDate =
                      a.updatedAt ??
                      a.createdAt ??
                      DateTime.fromMillisecondsSinceEpoch(0);
                  final bDate =
                      b.updatedAt ??
                      b.createdAt ??
                      DateTime.fromMillisecondsSinceEpoch(0);
                  return bDate.compareTo(aDate);
                });

              final latest = sortedServices.first;
              return _AdminServiceStatusCard(
                key: ValueKey(
                  'admin-banner-status-${latest.id ?? latest.hashCode}',
                ),
                service: latest,
                onTap: () => _openOficializaTe(context),
              );
            },
          ),
        );
      },
    );
  }

  void _openOficializaTe(BuildContext context) {
    context.push('/oficializa-te');
  }
}

class _AdminServiceCtaCard extends StatelessWidget {
  const _AdminServiceCtaCard({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.verified_user, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'adminServices.banner.title'.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'adminServices.banner.subtitle'.tr(),
                    style: TextStyle(color: Colors.green.shade800),
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: onTap,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.arrow_forward),
                    label: Text('adminServices.banner.cta'.tr()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminServiceStatusCard extends StatelessWidget {
  const _AdminServiceStatusCard({
    super.key,
    required this.service,
    required this.onTap,
  });

  final AdminService service;
  final VoidCallback onTap;

  Color _statusColor(AdminServiceStatus status) {
    switch (status) {
      case AdminServiceStatus.pendingPayment:
        return Colors.orange.shade600;
      case AdminServiceStatus.pending:
        return Colors.blue.shade600;
      case AdminServiceStatus.assigned:
        return Colors.indigo.shade600;
      case AdminServiceStatus.completed:
        return Colors.green.shade600;
      case AdminServiceStatus.cancelled:
        return Colors.red.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = service.status;
    final statusKey = 'adminServices.status.${status.name}';
    final statusLabel = tr(statusKey);
    final packageKey = 'adminServices.package.${service.package.name}.title';
    final localizedPackage = tr(packageKey);
    final packageLabel = localizedPackage == packageKey
        ? AdminServicePackageInfo.resolve(service.package).titleKey.tr()
        : localizedPackage;

    final lastUpdated = service.updatedAt ?? service.createdAt;

    return Card(
      color: Colors.blue.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.verified, color: _statusColor(status)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    tr('adminServices.banner.statusTitle'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                FilledButton.tonal(
                  onPressed: onTap,
                  child: Text('adminServices.banner.manage'.tr()),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              packageLabel,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _statusColor(status).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                statusLabel,
                style: TextStyle(
                  color: _statusColor(status),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (lastUpdated != null) ...[
              const SizedBox(height: 8),
              Text(
                tr(
                  'adminServices.banner.updated',
                  namedArgs: {
                    'date': DateFormat.yMMMd().add_Hm().format(lastUpdated),
                  },
                ),
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
            ],
            const SizedBox(height: 12),
            Text(
              tr('adminServices.banner.help'),
              style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminServiceBannerPlaceholder extends StatelessWidget {
  const _AdminServiceBannerPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            LinearProgressIndicator(),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _AdminServiceErrorCard extends StatelessWidget {
  const _AdminServiceErrorCard({super.key, required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final message = tr(
      'adminServices.statusList.error',
      namedArgs: {'message': '$error'},
    );

    return Card(
      color: colorScheme.errorContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.warning_rounded, color: colorScheme.onErrorContainer),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: colorScheme.onErrorContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

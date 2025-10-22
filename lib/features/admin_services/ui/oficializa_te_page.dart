import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/models/admin_service.dart';
import '../../../core/utils/debug_logger.dart';
import '../logic/admin_services_controller.dart';

/// PG-17/18: "Oficializa-te" page for pros to purchase registration assistance
class OficializaTePage extends ConsumerStatefulWidget {
  const OficializaTePage({super.key});

  @override
  ConsumerState<OficializaTePage> createState() => _OficializaTePageState();
}

class _OficializaTePageState extends ConsumerState<OficializaTePage> {
  AdminServicePackage? _selectedPackage;
  bool _isLoading = false;
  static const String _supportEmail = 'elierysmanzanarez@gmail.com';

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final servicesAsync = user != null
        ? ref.watch(adminServicesStreamProvider(user.uid))
        : const AsyncValue<List<AdminService>>.data(<AdminService>[]);

    return Scaffold(
      appBar: AppBar(
        title: Text('adminServices.oficializaTe.appBarTitle'.tr()),
        backgroundColor: Colors.green.shade50,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: user == null
                  ? _buildAuthRequiredCard()
                  : _buildExistingServices(servicesAsync),
            ),
            const SizedBox(height: 24),
            _buildPackages(),
            const SizedBox(height: 24),
            _buildLegalNotice(),
            const SizedBox(height: 24),
            _buildFAQ(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthRequiredCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lock_outline, color: Colors.orange),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'adminServices.auth.required'.tr(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('adminServices.auth.description'.tr()),
          ],
        ),
      ),
    );
  }

  Widget _buildExistingServices(AsyncValue<List<AdminService>> servicesAsync) {
    return servicesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Card(
        color: Colors.red.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'adminServices.statusList.error'.tr(
                    namedArgs: {'message': '$error'},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      data: (services) {
        if (services.isEmpty) {
          return Card(
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'adminServices.statusList.empty.title'.tr(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('adminServices.statusList.empty.subtitle'.tr()),
                ],
              ),
            ),
          );
        }

        services.sort((a, b) {
          final aDate = a.updatedAt ?? a.createdAt ?? DateTime(1970);
          final bDate = b.updatedAt ?? b.createdAt ?? DateTime(1970);
          return bDate.compareTo(aDate);
        });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'adminServices.statusList.title'.tr(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...services.map(_buildServiceStatusCard),
          ],
        );
      },
    );
  }

  Widget _buildServiceStatusCard(AdminService service) {
    final statusKey = 'adminServices.status.${service.status.name}';
    final statusLabel = statusKey.tr();
    final statusColor = _statusColor(service.status);
    final packageInfo = AdminServicePackageInfo.resolve(service.package);
    final packageKey = 'adminServices.package.${service.package.name}.title';
    final localizedPackage = tr(packageKey);
    final packageLabel = localizedPackage == packageKey
        ? packageInfo.titleKey.tr()
        : localizedPackage;
    final updatedAt = service.updatedAt ?? service.createdAt;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.assignment, color: statusColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    packageLabel,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '€${service.price.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                statusLabel,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (service.assignedAdminId != null)
              Text(
                'adminServices.statusList.assigned'.tr(
                  namedArgs: {'adminId': service.assignedAdminId!},
                ),
                style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
              ),
            if (service.adminNotes?.isNotEmpty == true) ...[
              const SizedBox(height: 8),
              Text(
                service.adminNotes!,
                style: TextStyle(color: Colors.grey.shade800),
              ),
            ],
            if (updatedAt != null) ...[
              const SizedBox(height: 8),
              Text(
                'adminServices.statusList.updated'.tr(
                  namedArgs: {
                    'timestamp': DateFormat.yMMMd().add_Hm().format(updatedAt),
                  },
                ),
                style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
              ),
            ],
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => _contactSupport(),
              icon: const Icon(Icons.support_agent),
              label: Text('adminServices.statusList.support'.tr()),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(AdminServiceStatus status) {
    switch (status) {
      case AdminServiceStatus.pendingPayment:
        return Colors.orange;
      case AdminServiceStatus.pending:
        return Colors.blue;
      case AdminServiceStatus.assigned:
        return Colors.indigo;
      case AdminServiceStatus.completed:
        return Colors.green;
      case AdminServiceStatus.cancelled:
        return Colors.red;
    }
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade100, Colors.green.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.gavel, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'adminServices.oficializaTe.header.title'.tr(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    Text(
                      'adminServices.oficializaTe.header.subtitle'.tr(),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'adminServices.oficializaTe.header.benefitsTitle'.tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text('adminServices.oficializaTe.header.benefits.legal'.tr()),
                Text('adminServices.oficializaTe.header.benefits.social'.tr()),
                Text(
                  'adminServices.oficializaTe.header.benefits.receipts'.tr(),
                ),
                Text(
                  'adminServices.oficializaTe.header.benefits.protection'.tr(),
                ),
                Text(
                  'adminServices.oficializaTe.header.benefits.credibility'.tr(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackages() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'adminServices.oficializaTe.packages.heading'.tr(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...AdminServicePackageInfo.packages.map(
            (package) => _buildPackageCard(package),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageCard(AdminServicePackageInfo package) {
    final isSelected = _selectedPackage == package.package;
    final title = package.titleKey.tr();
    final subtitle = package.subtitleKey.tr();
    final description = package.descriptionKey.tr();
    final featureLabels = package.featureKeys.map((key) => key.tr()).toList();
    final recommendedRibbon =
        'adminServices.oficializaTe.packages.recommendedRibbon'.tr();
    final paymentNote = 'adminServices.oficializaTe.packages.paymentNote'.tr();
    final includesTitle = 'adminServices.oficializaTe.packages.includesTitle'
        .tr();
    final processingLabel = 'adminServices.oficializaTe.packages.processing'
        .tr();
    final buyNowLabel = 'adminServices.oficializaTe.packages.buyNowLabel'.tr(
      namedArgs: {'price': package.price.toInt().toString()},
    );
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? Colors.green : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: Colors.green.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: isSelected ? Colors.green.shade50 : Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            setState(() {
              _selectedPackage = package.package;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (package.isRecommended) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          recommendedRibbon,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '€${package.price.toInt()}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          paymentNote,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 16),
                Text(description, style: const TextStyle(fontSize: 14)),
                const SizedBox(height: 16),
                Text(
                  includesTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                ...featureLabels.map(
                  (feature) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: Colors.green.shade600,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            feature,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading
                          ? null
                          : () => _purchasePackage(package),
                      icon: _isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.payment),
                      label: Text(_isLoading ? processingLabel : buyNowLabel),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegalNotice() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info, color: Colors.amber.shade700),
              const SizedBox(width: 8),
              Text(
                'adminServices.oficializaTe.legal.title'.tr(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'adminServices.oficializaTe.legal.body'.tr(),
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 8),
          Text(
            'adminServices.oficializaTe.legal.disclaimer'.tr(),
            style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQ() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'adminServices.oficializaTe.faq.title'.tr(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildFAQItem(
            'adminServices.oficializaTe.faq.items.duration.question',
            'adminServices.oficializaTe.faq.items.duration.answer',
          ),
          _buildFAQItem(
            'adminServices.oficializaTe.faq.items.digitalKey.question',
            'adminServices.oficializaTe.faq.items.digitalKey.answer',
          ),
          _buildFAQItem(
            'adminServices.oficializaTe.faq.items.documents.question',
            'adminServices.oficializaTe.faq.items.documents.answer',
          ),
          _buildFAQItem(
            'adminServices.oficializaTe.faq.items.refund.question',
            'adminServices.oficializaTe.faq.items.refund.answer',
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _contactSupport,
            icon: const Icon(Icons.support_agent),
            label: Text('adminServices.oficializaTe.faq.supportCta'.tr()),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.green,
              side: const BorderSide(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String questionKey, String answerKey) {
    return ExpansionTile(
      title: Text(
        questionKey.tr(),
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            answerKey.tr(),
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
          ),
        ),
      ],
    );
  }

  Future<void> _purchasePackage(AdminServicePackageInfo package) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Show confirmation dialog first
      final confirmed = await _showConfirmationDialog(package);
      if (!confirmed) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Create admin service checkout via Cloud Function
      final result = await ref
          .read(adminServicesControllerProvider.notifier)
          .createCheckoutSession(package.package);

      DebugLogger.debug('🧾 Admin service checkout created', {
        'adminServiceId': result.adminServiceId,
        'package': package.package.name,
      });

      final uri = Uri.parse(result.checkoutUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception(tr('adminServices.oficializaTe.checkout.openFailed'));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'adminServices.oficializaTe.checkout.error'.tr(
                namedArgs: {'message': '$e'},
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<bool> _showConfirmationDialog(AdminServicePackageInfo package) async {
    final packageTitle = package.titleKey.tr();
    final price = package.price.toInt().toString();
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'adminServices.oficializaTe.checkout.confirmTitle'.tr(
                namedArgs: {'package': packageTitle},
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'adminServices.oficializaTe.checkout.confirmBody'.tr(
                    namedArgs: {'package': packageTitle, 'price': price},
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'adminServices.oficializaTe.checkout.afterPaymentTitle'.tr(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '• ${'adminServices.oficializaTe.checkout.steps.contact'.tr()}',
                ),
                Text(
                  '• ${'adminServices.oficializaTe.checkout.steps.instructions'.tr()}',
                ),
                Text(
                  '• ${'adminServices.oficializaTe.checkout.steps.start'.tr()}',
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Text(
                    'adminServices.oficializaTe.checkout.reminder'.tr(),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('adminServices.oficializaTe.checkout.cancel'.tr()),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: Text('adminServices.oficializaTe.checkout.confirm'.tr()),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _contactSupport() async {
    final emailBody = '${'adminServices.oficializaTe.support.intro'.tr()}\n\n';
    final launched = await _launchSupportEmail(body: emailBody);

    if (launched || !mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('adminServices.oficializaTe.support.dialogTitle'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('adminServices.oficializaTe.support.intro'.tr()),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.email, color: Colors.blue),
              title: Text(_supportEmail),
              subtitle: const Text('Email support'),
              onTap: () async {
                final reLaunched = await _launchSupportEmail(body: emailBody);
                if (!mounted || !dialogContext.mounted) {
                  return;
                }

                if (reLaunched) {
                  Navigator.of(dialogContext).pop();
                }
              },
              trailing: IconButton(
                icon: const Icon(Icons.copy),
                tooltip: 'Copy email',
                onPressed: () async {
                  await Clipboard.setData(
                    const ClipboardData(text: _supportEmail),
                  );
                  if (!mounted || !dialogContext.mounted) {
                    return;
                  }

                  Navigator.of(dialogContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Email copied: $_supportEmail')),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.chat_bubble_outline, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'adminServices.oficializaTe.support.chat'.tr(),
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('adminServices.oficializaTe.support.close'.tr()),
          ),
        ],
      ),
    );
  }

  Future<bool> _launchSupportEmail({String? body}) async {
    final query = <String, String>{
      'subject': 'Oficializa-te Support Request',
      if (body != null && body.isNotEmpty) 'body': body,
    };

    final uri = Uri(
      scheme: 'mailto',
      path: _supportEmail,
      query: _encodeQueryParameters(query),
    );

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        DebugLogger.warning('Support email intent could not be opened');
      }
      return launched;
    } catch (error, stackTrace) {
      DebugLogger.error('Failed to launch support email', error, stackTrace);
      return false;
    }
  }

  String _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (entry) =>
              '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value)}',
        )
        .join('&');
  }
}

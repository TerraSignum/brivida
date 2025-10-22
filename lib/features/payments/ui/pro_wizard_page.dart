import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';

import '../logic/payment_controller.dart';
import '../../../core/config/environment.dart';

class ProWizardPage extends ConsumerStatefulWidget {
  const ProWizardPage({super.key});

  @override
  ConsumerState<ProWizardPage> createState() => _ProWizardPageState();
}

class _ProWizardPageState extends ConsumerState<ProWizardPage> {
  bool _isLoading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text('payment.pro_wizard.title'.tr()),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header illustration
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.1),
                    theme.colorScheme.secondary.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Icon(
                      Icons.account_balance,
                      size: 80,
                      color: theme.colorScheme.primary.withValues(alpha: 0.6),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.security,
                        color: theme.colorScheme.onPrimaryContainer,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Title and description
            Text(
              'payment.pro_wizard.welcome_title'.tr(),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'payment.pro_wizard.welcome_description'.tr(),
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),

            // Benefits list
            Text(
              'payment.pro_wizard.benefits_title'.tr(),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildBenefitItem(
              icon: Icons.payment,
              title: 'payment.pro_wizard.benefit_secure_payments'.tr(),
              description:
                  'payment.pro_wizard.benefit_secure_payments_desc'.tr(),
            ),
            const SizedBox(height: 12),
            _buildBenefitItem(
              icon: Icons.schedule,
              title: 'payment.pro_wizard.benefit_fast_transfers'.tr(),
              description:
                  'payment.pro_wizard.benefit_fast_transfers_desc'.tr(),
            ),
            const SizedBox(height: 12),
            _buildBenefitItem(
              icon: Icons.shield,
              title: 'payment.pro_wizard.benefit_protected'.tr(),
              description: 'payment.pro_wizard.benefit_protected_desc'.tr(),
            ),
            const SizedBox(height: 32),

            // Requirements
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'payment.pro_wizard.requirements_title'.tr(),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'payment.pro_wizard.requirements_description'.tr(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Error message
            if (_error != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _error!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onErrorContainer,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Setup button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _startConnectOnboarding,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: theme.colorScheme.onPrimary,
                        ),
                      )
                    : Text(
                        'payment.pro_wizard.setup_button'.tr(),
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),

            // Skip button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed:
                    _isLoading ? null : () => Navigator.of(context).pop(),
                child: Text('payment.pro_wizard.skip_button'.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: theme.colorScheme.onPrimaryContainer,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _startConnectOnboarding() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final paymentController = ref.read(paymentControllerProvider.notifier);

      // Configure URLs per environment
      final String refreshUrl = Environment.isProduction
          ? 'https://brivida.app/pro/connect/refresh'
          : 'https://dev.brivida.app/pro/connect/refresh';
      final String returnUrl = Environment.isProduction
          ? 'https://brivida.app/pro/connect/success'
          : 'https://dev.brivida.app/pro/connect/success';

      final result = await paymentController.createConnectOnboarding(
        refreshUrl: refreshUrl,
        returnUrl: returnUrl,
      );

      if (result == null) {
        throw Exception('payment.pro_wizard.error.failed_create'.tr());
      }

      // Launch Stripe Connect onboarding
      final uri = Uri.parse(result.onboardingUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );

        // Show success message and navigate back
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('payment.pro_wizard.onboarding_started'.tr()),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
          Navigator.of(context).pop();
        }
      } else {
        throw Exception('payment.pro_wizard.error.cannot_open_url'.tr());
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

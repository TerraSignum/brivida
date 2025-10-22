import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:easy_localization/easy_localization.dart';

import '../../../core/services/firebase_service.dart';
import '../logic/payment_controller.dart';

class CheckoutSheet extends ConsumerStatefulWidget {
  final String jobId;
  final double amount;
  final String currency;
  final String? connectedAccountId;
  final VoidCallback? onSuccess;
  final VoidCallback? onCancel;

  const CheckoutSheet({
    super.key,
    required this.jobId,
    required this.amount,
    this.currency = 'eur',
    this.connectedAccountId,
    this.onSuccess,
    this.onCancel,
  });

  @override
  ConsumerState<CheckoutSheet> createState() => _CheckoutSheetState();
}

class _CheckoutSheetState extends ConsumerState<CheckoutSheet> {
  bool _isProcessing = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    'payment.checkout.title'.tr(),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _isProcessing ? null : widget.onCancel,
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Amount display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'payment.checkout.total'.tr(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.amount.toStringAsFixed(2)} ${widget.currency.toUpperCase()}',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Escrow info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.secondaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.security,
                    color: theme.colorScheme.secondary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'payment.checkout.escrow_info'.tr(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

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

            // Pay button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _processPayment,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isProcessing
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: theme.colorScheme.onPrimary,
                        ),
                      )
                    : Text(
                        'payment.checkout.pay_now'.tr(),
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            // Terms
            const SizedBox(height: 12),
            Text(
              'payment.checkout.terms'.tr(),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),

            // Safe area padding
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  Future<void> _processPayment() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
      _error = null;
    });

    try {
      final paymentController = ref.read(paymentControllerProvider.notifier);

      // Create PaymentIntent
      final paymentIntentResult = await paymentController.createPaymentIntent(
        jobId: widget.jobId,
        amount: widget.amount,
        currency: widget.currency,
        connectedAccountId: widget.connectedAccountId,
      );

      if (paymentIntentResult == null) {
        throw Exception('payment.checkout.error.failed_create'.tr());
      }

      // Initialize payment sheet
      await stripe.Stripe.instance.initPaymentSheet(
        paymentSheetParameters: stripe.SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentResult.clientSecret,
          merchantDisplayName: 'Brivida',
          style: ThemeMode.system,
          billingDetails: stripe.BillingDetails(
            email: FirebaseService.currentUser?.email,
          ),
        ),
      );

      // Present payment sheet
      await stripe.Stripe.instance.presentPaymentSheet();

      // Payment successful
      widget.onSuccess?.call();

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      String errorMessage;

      if (e is stripe.StripeException) {
        // Handle different Stripe error types by checking error message
        final stripeMessage = e.error.message ?? '';
        if (stripeMessage.toLowerCase().contains('cancel')) {
          // User canceled, don't show error
          setState(() {
            _isProcessing = false;
          });
          return;
        } else if (stripeMessage.toLowerCase().contains('failed')) {
          errorMessage = 'payment.checkout.error.payment_failed'.tr();
        } else if (stripeMessage.toLowerCase().contains('invalid')) {
          errorMessage = 'payment.checkout.error.invalid_request'.tr();
        } else {
          errorMessage = stripeMessage.isNotEmpty
              ? stripeMessage
              : 'payment.checkout.error.unknown'.tr();
        }
      } else {
        errorMessage = 'payment.checkout.error.unknown'.tr();
      }

      setState(() {
        _error = errorMessage;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }
}

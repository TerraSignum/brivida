import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../../../core/providers/firebase_providers.dart';

class PaymentController extends StateNotifier<AsyncValue<void>> {
  PaymentController(this._functions) : super(const AsyncValue.data(null));

  final FirebaseFunctions _functions;

  /// Create PaymentIntent for job escrow
  Future<PaymentIntentResult?> createPaymentIntent({
    required String jobId,
    required double amount,
    required String currency,
    String? connectedAccountId,
  }) async {
    state = const AsyncValue.loading();

    try {
      final callable = _functions.httpsCallable('createPaymentIntent');
      final result = await callable.call({
        'jobId': jobId,
        'amount': amount,
        'currency': currency,
        if (connectedAccountId != null)
          'connectedAccountId': connectedAccountId,
      });

      final data = result.data as Map<String, dynamic>;

      state = const AsyncValue.data(null);

      return PaymentIntentResult(
        paymentIntentId: data['paymentIntentId'] as String,
        clientSecret: data['clientSecret'] as String,
      );
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return null;
    }
  }

  /// Create Stripe Connect onboarding for Pro user
  Future<ConnectOnboardingResult?> createConnectOnboarding({
    required String refreshUrl,
    required String returnUrl,
  }) async {
    state = const AsyncValue.loading();

    try {
      final callable = _functions.httpsCallable('createConnectOnboarding');
      final result = await callable.call({
        'refreshUrl': refreshUrl,
        'returnUrl': returnUrl,
      });

      final data = result.data as Map<String, dynamic>;

      state = const AsyncValue.data(null);

      return ConnectOnboardingResult(
        accountId: data['accountId'] as String,
        onboardingUrl: data['onboardingUrl'] as String,
      );
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return null;
    }
  }

  /// Release escrow transfer to Pro (manual approval)
  Future<ReleaseTransferResult?> releaseTransfer({
    required String paymentId,
    bool manualRelease = true,
  }) async {
    state = const AsyncValue.loading();

    try {
      final callable = _functions.httpsCallable('releaseTransfer');
      final result = await callable.call({
        'paymentId': paymentId,
        'manualRelease': manualRelease,
      });

      final data = result.data as Map<String, dynamic>;

      state = const AsyncValue.data(null);

      return ReleaseTransferResult(
        transferId: data['transferId'] as String,
        amountNet: (data['amountNet'] as num).toDouble(),
        platformFee: (data['platformFee'] as num).toDouble(),
      );
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return null;
    }
  }

  /// Create partial refund for disputes
  Future<RefundResult?> createPartialRefund({
    required String paymentId,
    required double refundAmount,
    String reason = 'requested_by_customer',
  }) async {
    state = const AsyncValue.loading();

    try {
      final callable = _functions.httpsCallable('partialRefund');
      final result = await callable.call({
        'paymentId': paymentId,
        'refundAmount': refundAmount,
        'reason': reason,
      });

      final data = result.data as Map<String, dynamic>;

      state = const AsyncValue.data(null);

      return RefundResult(
        refundId: data['refundId'] as String,
        amount: (data['amount'] as num).toDouble(),
        currency: data['currency'] as String,
      );
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return null;
    }
  }
}

// Results classes
class PaymentIntentResult {
  final String paymentIntentId;
  final String clientSecret;

  const PaymentIntentResult({
    required this.paymentIntentId,
    required this.clientSecret,
  });
}

class ConnectOnboardingResult {
  final String accountId;
  final String onboardingUrl;

  const ConnectOnboardingResult({
    required this.accountId,
    required this.onboardingUrl,
  });
}

class ReleaseTransferResult {
  final String transferId;
  final double amountNet;
  final double platformFee;

  const ReleaseTransferResult({
    required this.transferId,
    required this.amountNet,
    required this.platformFee,
  });
}

class RefundResult {
  final String refundId;
  final double amount;
  final String currency;

  const RefundResult({
    required this.refundId,
    required this.amount,
    required this.currency,
  });
}

// Provider
final paymentControllerProvider =
    StateNotifierProvider<PaymentController, AsyncValue<void>>((ref) {
  final functions = ref.watch(functionsProvider);
  return PaymentController(functions);
});

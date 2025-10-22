import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/firebase_providers.dart';
import '../../../core/utils/debug_logger.dart';
import '../logic/payment_controller.dart';

class PaymentRepository {
  PaymentRepository(this._functions) {
    DebugLogger.debug('🏗️ PaymentRepository created',
        {'functionsType': _functions.runtimeType.toString()});
  }

  final FirebaseFunctions _functions;

  /// Create PaymentIntent for job escrow
  Future<PaymentIntentResult?> createPaymentIntent({
    required String jobId,
    required double amount,
    required String currency,
    String? connectedAccountId,
  }) async {
    DebugLogger.enter('PaymentRepository.createPaymentIntent', {
      'jobId': jobId,
      'amount': amount,
      'currency': currency,
      'hasConnectedAccount': connectedAccountId != null,
      'connectedAccountId': connectedAccountId
    });
    DebugLogger.startTimer('createPaymentIntent');

    try {
      DebugLogger.debug('💳 Creating Stripe PaymentIntent via Cloud Function',
          {'jobId': jobId, 'amount': amount, 'currency': currency});

      DebugLogger.debug('☁️ Calling Cloud Function: createPaymentIntent');

      final callable = _functions.httpsCallable('createPaymentIntent');
      final result = await callable.call({
        'jobId': jobId,
        'amount': amount,
        'currency': currency,
        if (connectedAccountId != null)
          'connectedAccountId': connectedAccountId,
      });

      final data = result.data as Map<String, dynamic>;

      DebugLogger.debug('✅ PaymentIntent created successfully', {
        'hasPaymentIntentId': data.containsKey('paymentIntentId'),
        'hasClientSecret': data.containsKey('clientSecret'),
        'paymentIntentId': data['paymentIntentId'] as String?,
        'dataKeys': data.keys.toList()
      });

      final paymentResult = PaymentIntentResult(
        paymentIntentId: data['paymentIntentId'] as String,
        clientSecret: data['clientSecret'] as String,
      );

      final duration = DebugLogger.stopTimer('createPaymentIntent');
      DebugLogger.performance('createPaymentIntent', duration!);
      DebugLogger.exit('PaymentRepository.createPaymentIntent',
          paymentResult.paymentIntentId);

      return paymentResult;
    } catch (error, stackTrace) {
      DebugLogger.error(
          '❌ Error creating PaymentIntent for jobId=$jobId', error, stackTrace);
      DebugLogger.stopTimer('createPaymentIntent');
      DebugLogger.exit('PaymentRepository.createPaymentIntent', 'error');
      rethrow;
    }
  }

  /// Create Stripe Connect onboarding for Pro user
  Future<ConnectOnboardingResult?> createConnectOnboarding({
    required String refreshUrl,
    required String returnUrl,
  }) async {
    DebugLogger.enter('PaymentRepository.createConnectOnboarding',
        {'refreshUrl': refreshUrl, 'returnUrl': returnUrl});
    DebugLogger.startTimer('createConnectOnboarding');

    try {
      DebugLogger.debug(
          '🔗 Creating Stripe Connect onboarding via Cloud Function', {
        'refreshUrl': '${refreshUrl.substring(0, 50)}...',
        'returnUrl': '${returnUrl.substring(0, 50)}...'
      });

      DebugLogger.debug('☁️ Calling Cloud Function: createConnectOnboarding');

      final callable = _functions.httpsCallable('createConnectOnboarding');
      final result = await callable.call({
        'refreshUrl': refreshUrl,
        'returnUrl': returnUrl,
      });

      final data = result.data as Map<String, dynamic>;

      DebugLogger.debug('✅ Connect onboarding created successfully', {
        'hasAccountId': data.containsKey('accountId'),
        'hasOnboardingUrl': data.containsKey('onboardingUrl'),
        'accountId': data['accountId'] as String?,
        'dataKeys': data.keys.toList()
      });

      final connectResult = ConnectOnboardingResult(
        accountId: data['accountId'] as String,
        onboardingUrl: data['onboardingUrl'] as String,
      );

      final duration = DebugLogger.stopTimer('createConnectOnboarding');
      DebugLogger.performance('createConnectOnboarding', duration!);
      DebugLogger.exit(
          'PaymentRepository.createConnectOnboarding', connectResult.accountId);

      return connectResult;
    } catch (error, stackTrace) {
      DebugLogger.error(
          '❌ Error creating Connect onboarding', error, stackTrace);
      DebugLogger.stopTimer('createConnectOnboarding');
      DebugLogger.exit('PaymentRepository.createConnectOnboarding', 'error');
      rethrow;
    }
  }

  /// Release escrow transfer to Pro (manual approval)
  Future<ReleaseTransferResult?> releaseTransfer({
    required String paymentId,
    bool manualRelease = true,
  }) async {
    DebugLogger.enter('PaymentRepository.releaseTransfer',
        {'paymentId': paymentId, 'manualRelease': manualRelease});
    DebugLogger.startTimer('releaseTransfer');

    try {
      DebugLogger.debug('💸 Releasing escrow transfer via Cloud Function',
          {'paymentId': paymentId, 'manualRelease': manualRelease});

      DebugLogger.debug('☁️ Calling Cloud Function: releaseTransfer');

      final callable = _functions.httpsCallable('releaseTransfer');
      final result = await callable.call({
        'paymentId': paymentId,
        'manualRelease': manualRelease,
      });

      final data = result.data as Map<String, dynamic>;

      DebugLogger.debug('✅ Escrow transfer released successfully', {
        'hasTransferId': data.containsKey('transferId'),
        'hasAmountNet': data.containsKey('amountNet'),
        'hasPlatformFee': data.containsKey('platformFee'),
        'amountNet': (data['amountNet'] as num?)?.toDouble(),
        'platformFee': (data['platformFee'] as num?)?.toDouble(),
        'dataKeys': data.keys.toList()
      });

      final transferResult = ReleaseTransferResult(
        transferId: data['transferId'] as String,
        amountNet: (data['amountNet'] as num).toDouble(),
        platformFee: (data['platformFee'] as num).toDouble(),
      );

      final duration = DebugLogger.stopTimer('releaseTransfer');
      DebugLogger.performance('releaseTransfer', duration!);
      DebugLogger.exit(
          'PaymentRepository.releaseTransfer', transferResult.transferId);

      return transferResult;
    } catch (error, stackTrace) {
      DebugLogger.error(
          '❌ Error releasing escrow transfer for paymentId=$paymentId',
          error,
          stackTrace);
      DebugLogger.stopTimer('releaseTransfer');
      DebugLogger.exit('PaymentRepository.releaseTransfer', 'error');
      rethrow;
    }
  }

  /// Create partial refund for disputes
  Future<RefundResult?> createPartialRefund({
    required String paymentId,
    required double refundAmount,
    String reason = 'requested_by_customer',
  }) async {
    DebugLogger.enter('PaymentRepository.createPartialRefund', {
      'paymentId': paymentId,
      'refundAmount': refundAmount,
      'reason': reason
    });
    DebugLogger.startTimer('createPartialRefund');

    try {
      DebugLogger.debug('💰 Creating partial refund via Cloud Function', {
        'paymentId': paymentId,
        'refundAmount': refundAmount,
        'reason': reason
      });

      DebugLogger.debug('☁️ Calling Cloud Function: partialRefund');

      final callable = _functions.httpsCallable('partialRefund');
      final result = await callable.call({
        'paymentId': paymentId,
        'refundAmount': refundAmount,
        'reason': reason,
      });

      final data = result.data as Map<String, dynamic>;

      DebugLogger.debug('✅ Partial refund created successfully', {
        'hasRefundId': data.containsKey('refundId'),
        'hasAmount': data.containsKey('amount'),
        'hasCurrency': data.containsKey('currency'),
        'refundAmount': (data['amount'] as num?)?.toDouble(),
        'currency': data['currency'] as String?,
        'dataKeys': data.keys.toList()
      });

      final refundResult = RefundResult(
        refundId: data['refundId'] as String,
        amount: (data['amount'] as num).toDouble(),
        currency: data['currency'] as String,
      );

      final duration = DebugLogger.stopTimer('createPartialRefund');
      DebugLogger.performance('createPartialRefund', duration!);
      DebugLogger.exit(
          'PaymentRepository.createPartialRefund', refundResult.refundId);

      return refundResult;
    } catch (error, stackTrace) {
      DebugLogger.error(
          '❌ Error creating partial refund for paymentId=$paymentId',
          error,
          stackTrace);
      DebugLogger.stopTimer('createPartialRefund');
      DebugLogger.exit('PaymentRepository.createPartialRefund', 'error');
      rethrow;
    }
  }
}

// Provider
final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  DebugLogger.debug('🔗 Creating PaymentRepository provider instance');
  final functions = ref.watch(functionsProvider);
  return PaymentRepository(functions);
});

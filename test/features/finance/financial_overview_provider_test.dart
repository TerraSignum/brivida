import 'package:brivida_app/core/models/payment.dart';
import 'package:brivida_app/core/models/payout.dart';
import 'package:brivida_app/features/finance/logic/financial_overview_provider.dart';
import 'package:brivida_app/features/payouts/data/payouts_repo.dart';
import 'package:brivida_app/features/payouts/logic/payouts_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('financialOverviewProvider', () {
    test('aggregates stats and highlights pending/completed transfers', () async {
      final now = DateTime.now();
      final pendingEarly = Transfer(
        id: 'pending_early',
        paymentId: 'payment_a',
        jobId: 'job_a',
        connectedAccountId: 'acct_1',
        amountNet: 60,
        platformFee: 6,
        currency: 'EUR',
        status: TransferStatus.pending,
        createdAt: now.subtract(const Duration(days: 7)),
      );
      final pendingLater = Transfer(
        id: 'pending_later',
        paymentId: 'payment_b',
        jobId: 'job_b',
        connectedAccountId: 'acct_1',
        amountNet: 40,
        platformFee: 4,
        currency: 'EUR',
        status: TransferStatus.pending,
        createdAt: now.subtract(const Duration(days: 2)),
      );
      final completedEarlier = Transfer(
        id: 'completed_earlier',
        paymentId: 'payment_c',
        jobId: 'job_c',
        connectedAccountId: 'acct_1',
        amountNet: 90,
        platformFee: 9,
        currency: 'EUR',
        status: TransferStatus.completed,
        createdAt: now.subtract(const Duration(days: 10)),
        completedAt: now.subtract(const Duration(days: 9)),
      );
      final completedRecent = Transfer(
        id: 'completed_recent',
        paymentId: 'payment_d',
        jobId: 'job_d',
        connectedAccountId: 'acct_1',
        amountNet: 120,
        platformFee: 12,
        currency: 'EUR',
        status: TransferStatus.completed,
        createdAt: now.subtract(const Duration(days: 3)),
        completedAt: now.subtract(const Duration(days: 2)),
      );

      final fakeRepository = _FakePayoutsRepository(
        stats: const TransferStats(
          totalAmountNet: 210,
          completedCount: 2,
          pendingCount: 2,
          failedCount: 0,
        ),
        transfers: [
          pendingEarly,
          completedEarlier,
          pendingLater,
          completedRecent,
        ],
      );

      final container = ProviderContainer(
        overrides: [
          payoutsRepositoryProvider.overrideWithValue(fakeRepository),
        ],
      );
      addTearDown(container.dispose);

      final summary = await container.read(financialOverviewProvider.future);

      expect(summary.stats.totalAmountNet, 210);
      expect(summary.recentTransfers, fakeRepository.transfers);
      expect(summary.pendingNetAmount, 100);
      expect(summary.hasPending, isTrue);
      expect(summary.nextPendingTransfer?.id, pendingEarly.id);
      expect(summary.lastCompletedTransfer?.id, completedRecent.id);

      // Ensure repository interactions received the expected filters and limits.
      expect(fakeRepository.capturedFilter, isNotNull);
      expect(fakeRepository.capturedFilter?.from, isNull);
      expect(fakeRepository.capturedFilter?.to, isNull);
      expect(fakeRepository.capturedLimit, 150);
      expect(fakeRepository.capturedStatsFrom, isNull);
      expect(fakeRepository.capturedStatsTo, isNull);
    });
  });
}

class _FakePayoutsRepository implements PayoutsRepository {
  _FakePayoutsRepository({required this.stats, required this.transfers});

  final TransferStats stats;
  final List<Transfer> transfers;

  PayoutFilter? capturedFilter;
  int capturedLimit = 0;
  DateTime? capturedStatsFrom;
  DateTime? capturedStatsTo;

  @override
  Future<ExportResult> exportMyTransfersCsv({DateTime? from, DateTime? to}) {
    throw UnimplementedError('Not used in tests');
  }

  @override
  Future<Transfer?> getTransfer(String transferId) {
    throw UnimplementedError('Not used in tests');
  }

  @override
  Future<TransferStats> getTransferStats({DateTime? from, DateTime? to}) async {
    capturedStatsFrom = from;
    capturedStatsTo = to;
    return stats;
  }

  @override
  Future<bool> openInStripe(String stripeTransferId) async => false;

  @override
  Future<List<Transfer>> filterTransfers({
    required PayoutFilter filter,
    int limit = 50,
  }) async {
    capturedFilter = filter;
    capturedLimit = limit;
    return transfers;
  }

  @override
  Stream<List<Transfer>> watchMyTransfers({
    DateTime? from,
    DateTime? to,
    String? status,
  }) {
    throw UnimplementedError('Not used in tests');
  }
}

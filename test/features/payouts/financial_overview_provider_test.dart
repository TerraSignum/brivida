import 'package:brivida_app/core/models/payment.dart';
import 'package:brivida_app/core/models/payout.dart';
import 'package:brivida_app/features/payouts/logic/financial_overview_provider.dart';
import 'package:brivida_app/features/payouts/logic/payouts_controller.dart';
import 'package:brivida_app/features/payouts/data/payouts_repo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakePayoutsRepository implements PayoutsRepository {
  FakePayoutsRepository({
    required this.statsResponse,
    required this.transfersResponse,
  });

  final TransferStats statsResponse;
  final List<Transfer> transfersResponse;

  int statsCalls = 0;
  int filterCalls = 0;
  DateTime? lastStatsFrom;
  DateTime? lastStatsTo;
  PayoutFilter? lastFilter;
  int? lastLimit;

  @override
  Stream<List<Transfer>> watchMyTransfers({
    DateTime? from,
    DateTime? to,
    String? status,
  }) {
    throw UnimplementedError('watchMyTransfers not used in tests');
  }

  @override
  Future<Transfer?> getTransfer(String transferId) {
    throw UnimplementedError('getTransfer not used in tests');
  }

  @override
  Future<ExportResult> exportMyTransfersCsv({DateTime? from, DateTime? to}) {
    throw UnimplementedError('exportMyTransfersCsv not used in tests');
  }

  @override
  Future<bool> openInStripe(String stripeTransferId) {
    throw UnimplementedError('openInStripe not used in tests');
  }

  @override
  Future<TransferStats> getTransferStats({DateTime? from, DateTime? to}) async {
    statsCalls++;
    lastStatsFrom = from;
    lastStatsTo = to;
    return statsResponse;
  }

  @override
  Future<List<Transfer>> filterTransfers({
    required PayoutFilter filter,
    int limit = 50,
  }) async {
    filterCalls++;
    lastFilter = filter;
    lastLimit = limit;
    return transfersResponse;
  }
}

Transfer _transfer({
  required String id,
  required TransferStatus status,
  required double amountNet,
  required DateTime createdAt,
}) {
  return Transfer(
    id: id,
    paymentId: 'payment_$id',
    jobId: 'job_$id',
    proUid: 'pro_123',
    connectedAccountId: 'acct_123',
    amountNet: amountNet,
    platformFee: 5.0,
    amountGross: amountNet + 5.0,
    currency: 'EUR',
    status: status,
    createdAt: createdAt,
  );
}

void main() {
  group('financialOverviewProvider', () {
    test('aggregates recent transfers and highlights correctly', () async {
      final now = DateTime(2025, 1, 31);
      final pendingRecent = _transfer(
        id: 'pending_recent',
        status: TransferStatus.pending,
        amountNet: 180.0,
        createdAt: now.subtract(const Duration(days: 3)),
      );
      final pendingUpcoming = _transfer(
        id: 'pending_upcoming',
        status: TransferStatus.pending,
        amountNet: 120.0,
        createdAt: now.subtract(const Duration(days: 10)),
      );
      final completedOlder = _transfer(
        id: 'completed_older',
        status: TransferStatus.completed,
        amountNet: 220.0,
        createdAt: now.subtract(const Duration(days: 12)),
      );
      final completedLatest = _transfer(
        id: 'completed_latest',
        status: TransferStatus.completed,
        amountNet: 260.0,
        createdAt: now.subtract(const Duration(days: 1)),
      );
      final failed = _transfer(
        id: 'failed_1',
        status: TransferStatus.failed,
        amountNet: 90.0,
        createdAt: now.subtract(const Duration(days: 5)),
      );

      final repo = FakePayoutsRepository(
        statsResponse: const TransferStats(
          totalCount: 5,
          totalAmountNet: 780.0,
          totalAmountGross: 830.0,
          totalPlatformFees: 25.0,
          pendingCount: 2,
          completedCount: 2,
          failedCount: 1,
        ),
        transfersResponse: [
          pendingRecent,
          completedLatest,
          failed,
          completedOlder,
          pendingUpcoming,
        ],
      );

      final container = ProviderContainer(
        overrides: [payoutsRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      final summary = await container.read(financialOverviewProvider.future);

      expect(repo.statsCalls, 1);
      expect(repo.filterCalls, 1);
      expect(repo.lastLimit, 50);
      expect(summary.stats.totalCount, 5);
      expect(summary.recentTransfers, repo.transfersResponse);
      expect(summary.pendingNetAmount, 300.0);
      expect(summary.nextPendingTransfer?.id, pendingUpcoming.id);
      expect(summary.lastCompletedTransfer?.id, completedLatest.id);
      expect(summary.hasPending, isTrue);

      expect(repo.lastStatsFrom, isNotNull);
      expect(repo.lastStatsTo, isNotNull);
      expect(repo.lastFilter, isNotNull);
      final from = repo.lastFilter!.from;
      final to = repo.lastFilter!.to;
      expect(from, isNotNull);
      expect(to, isNotNull);
      final span = to!.difference(from!);
      expect(span.inDays >= 29 && span.inDays <= 31, isTrue);
    });

    test('handles empty transfer results gracefully', () async {
      final repo = FakePayoutsRepository(
        statsResponse: const TransferStats(),
        transfersResponse: const [],
      );

      final container = ProviderContainer(
        overrides: [payoutsRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      final summary = await container.read(financialOverviewProvider.future);

      expect(summary.stats.totalCount, 0);
      expect(summary.recentTransfers, isEmpty);
      expect(summary.pendingNetAmount, 0);
      expect(summary.nextPendingTransfer, isNull);
      expect(summary.lastCompletedTransfer, isNull);
      expect(summary.hasPending, isFalse);
    });
  });
}

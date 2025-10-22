import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/exceptions/app_exceptions.dart';
import '../../../core/models/payment.dart';
import '../../../core/models/payout.dart';
import '../../payouts/logic/payouts_controller.dart'
    show payoutsRepositoryProvider;

/// Aggregated financial metrics and recent activity for a Pro user.
class FinancialOverviewSummary {
  const FinancialOverviewSummary({
    required this.stats,
    required this.recentTransfers,
    required this.pendingNetAmount,
    this.nextPendingTransfer,
    this.lastCompletedTransfer,
  });

  const FinancialOverviewSummary.empty()
    : stats = const TransferStats(),
      recentTransfers = const [],
      pendingNetAmount = 0,
      nextPendingTransfer = null,
      lastCompletedTransfer = null;

  /// Aggregate statistics derived from historic transfers.
  final TransferStats stats;

  /// Recent transfers (last 30 days, up to limit) for context listings.
  final List<Transfer> recentTransfers;

  /// Sum of net amounts for transfers that are still pending release.
  final double pendingNetAmount;

  /// The next pending transfer by creation date (used to highlight upcoming payout).
  final Transfer? nextPendingTransfer;

  /// The most recent completed transfer, if available.
  final Transfer? lastCompletedTransfer;

  bool get hasPending => pendingNetAmount > 0;
}

/// Provides an aggregated financial overview using transfer stats and recent activity.
final financialOverviewProvider = FutureProvider<FinancialOverviewSummary>((
  ref,
) async {
  final repository = ref.watch(payoutsRepositoryProvider);

  const aggregationLimit = 50;
  final now = DateTime.now();
  final periodStart = now.subtract(const Duration(days: 30));
  final filter = PayoutFilter(from: periodStart, to: now);

  TransferStats stats;
  try {
    stats = await repository.getTransferStats(from: filter.from, to: filter.to);
  } on NotAuthenticatedException {
    return const FinancialOverviewSummary.empty();
  } on ForbiddenException {
    return const FinancialOverviewSummary.empty();
  }

  List<Transfer> transfersForAggregation;
  try {
    transfersForAggregation = await repository.filterTransfers(
      filter: filter,
      limit: aggregationLimit,
    );
  } on NotAuthenticatedException {
    return const FinancialOverviewSummary.empty();
  } on ForbiddenException {
    return const FinancialOverviewSummary.empty();
  }

  final filteredRecentTransfers = transfersForAggregation
      .where(
        (transfer) =>
            transfer.createdAt != null &&
            !transfer.createdAt!.isBefore(periodStart),
      )
      .toList();

  final recentTransfers =
      (filteredRecentTransfers.isNotEmpty
              ? filteredRecentTransfers
              : transfersForAggregation)
          .take(50)
          .toList();

  double pendingNetAmount = 0;
  Transfer? nextPendingTransfer;
  Transfer? lastCompletedTransfer;

  for (final transfer in transfersForAggregation) {
    if (transfer.status == TransferStatus.pending) {
      pendingNetAmount += transfer.amountNet;

      if (nextPendingTransfer == null) {
        nextPendingTransfer = transfer;
      } else {
        final existingDate = nextPendingTransfer.createdAt;
        final candidateDate = transfer.createdAt;

        if (candidateDate != null &&
            (existingDate == null || candidateDate.isBefore(existingDate))) {
          nextPendingTransfer = transfer;
        }
      }
    }

    if (transfer.status == TransferStatus.completed) {
      if (lastCompletedTransfer == null) {
        lastCompletedTransfer = transfer;
      } else {
        final existingDate =
            lastCompletedTransfer.completedAt ??
            lastCompletedTransfer.createdAt;
        final candidateDate = transfer.completedAt ?? transfer.createdAt;

        if (candidateDate != null &&
            (existingDate == null || candidateDate.isAfter(existingDate))) {
          lastCompletedTransfer = transfer;
        }
      }
    }
  }

  return FinancialOverviewSummary(
    stats: stats,
    recentTransfers: recentTransfers,
    pendingNetAmount: pendingNetAmount,
    nextPendingTransfer: nextPendingTransfer,
    lastCompletedTransfer: lastCompletedTransfer,
  );
});

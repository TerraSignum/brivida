import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/payment.dart';
import '../../../core/models/payout.dart';
import '../data/payouts_repo.dart';

/// Provider for payouts repository
final payoutsRepositoryProvider = Provider<PayoutsRepository>((ref) {
  return PayoutsRepository();
});

/// Provider for watching user's transfers with optional filtering
final transfersProvider = StreamProvider.family<List<Transfer>, PayoutFilter?>((
  ref,
  filter,
) {
  final repository = ref.watch(payoutsRepositoryProvider);

  return repository.watchMyTransfers(
    from: filter?.from,
    to: filter?.to,
    status: filter?.status,
  );
});

/// Provider for getting a specific transfer
final transferProvider = FutureProvider.family<Transfer?, String>((
  ref,
  transferId,
) async {
  final repository = ref.watch(payoutsRepositoryProvider);
  return repository.getTransfer(transferId);
});

/// Provider for transfer statistics
final transferStatsProvider =
    FutureProvider.family<TransferStats, PayoutFilter?>((ref, filter) async {
      final repository = ref.watch(payoutsRepositoryProvider);
      return repository.getTransferStats(from: filter?.from, to: filter?.to);
    });

/// Controller for managing payout operations
class PayoutsController extends StateNotifier<AsyncValue<void>> {
  final PayoutsRepository _repository;

  PayoutsController(this._repository) : super(const AsyncValue.data(null));

  /// Export transfers as CSV
  Future<ExportResult?> exportTransfersCsv({
    DateTime? from,
    DateTime? to,
  }) async {
    state = const AsyncValue.loading();

    try {
      final result = await _repository.exportMyTransfersCsv(from: from, to: to);
      state = const AsyncValue.data(null);
      return result;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return null;
    }
  }

  /// Open transfer in Stripe dashboard
  Future<bool> openInStripe(String stripeTransferId) async {
    try {
      return await _repository.openInStripe(stripeTransferId);
    } catch (error) {
      return false;
    }
  }

  /// Filter transfers by criteria
  Future<List<Transfer>?> filterTransfers({
    required PayoutFilter filter,
    int limit = 50,
  }) async {
    state = const AsyncValue.loading();

    try {
      final transfers = await _repository.filterTransfers(
        filter: filter,
        limit: limit,
      );
      state = const AsyncValue.data(null);
      return transfers;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return null;
    }
  }
}

/// Provider for payouts controller
final payoutsControllerProvider =
    StateNotifierProvider<PayoutsController, AsyncValue<void>>((ref) {
      final repository = ref.watch(payoutsRepositoryProvider);
      return PayoutsController(repository);
    });

/// Provider for current filter state
final payoutFilterProvider = StateProvider<PayoutFilter>((ref) {
  return const PayoutFilter();
});

/// Provider for filtered transfers based on current filter
final filteredTransfersProvider = FutureProvider<List<Transfer>>((ref) async {
  final filter = ref.watch(payoutFilterProvider);
  final repository = ref.watch(payoutsRepositoryProvider);

  return repository.filterTransfers(filter: filter);
});

/// Provider for export loading state
final exportLoadingProvider = StateProvider<bool>((ref) => false);

/// Provider for selected transfer IDs (for batch operations)
final selectedTransfersProvider = StateProvider<Set<String>>((ref) => {});

/// Provider for current view mode (list/grid/stats)
final payoutViewModeProvider = StateProvider<PayoutViewMode>(
  (ref) => PayoutViewMode.list,
);

/// Enum for different view modes
enum PayoutViewMode {
  list,
  grid,
  stats;

  String label(BuildContext context) {
    switch (this) {
      case PayoutViewMode.list:
        return context.tr('payouts.viewModes.list');
      case PayoutViewMode.grid:
        return context.tr('payouts.viewModes.grid');
      case PayoutViewMode.stats:
        return context.tr('payouts.viewModes.stats');
    }
  }

  IconData get icon {
    switch (this) {
      case PayoutViewMode.list:
        return Icons.list;
      case PayoutViewMode.grid:
        return Icons.grid_view;
      case PayoutViewMode.stats:
        return Icons.analytics;
    }
  }
}

/// Extension to add convenient methods
extension PayoutFilterExt on PayoutFilter {
  /// Check if filter is active (has any non-default values)
  bool get isActive {
    return from != null || to != null || (status != null && status != 'all');
  }

  /// Get a human-readable description of the filter
  String description(BuildContext context) {
    final parts = <String>[];

    if (from != null) {
      parts.add(
        context.tr('payouts.filters.fromLabel', args: [_formatDate(from!)]),
      );
    }
    if (to != null) {
      parts.add(
        context.tr('payouts.filters.toLabel', args: [_formatDate(to!)]),
      );
    }
    if (status != null && status != 'all') {
      final statusLabel = TransferStatusFilter.values
          .firstWhere((s) => s.apiValue == status)
          .label(context);
      parts.add(context.tr('payouts.filters.statusLabel', args: [statusLabel]));
    }

    return parts.isEmpty
        ? context.tr('payouts.filters.noneActive')
        : parts.join(', ');
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}

/// Provider for checking if user has any transfers
final hasTransfersProvider = FutureProvider<bool>((ref) async {
  final repository = ref.watch(payoutsRepositoryProvider);
  final transfers = await repository.filterTransfers(
    filter: const PayoutFilter(),
    limit: 1,
  );
  return transfers.isNotEmpty;
});

/// Provider for recent transfers (last 30 days)
final recentTransfersProvider = FutureProvider<List<Transfer>>((ref) async {
  final repository = ref.watch(payoutsRepositoryProvider);
  final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));

  return repository.filterTransfers(
    filter: PayoutFilter(from: thirtyDaysAgo),
    limit: 10,
  );
});

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/payment.dart';
import '../logic/financial_overview_provider.dart';

/// High-level card summarising the financial performance for a Pro user.
class FinancialOverviewWidget extends ConsumerWidget {
  const FinancialOverviewWidget({super.key, this.onViewDetails});

  final VoidCallback? onViewDetails;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewAsync = ref.watch(financialOverviewProvider);

    return overviewAsync.when(
      data: (summary) => _FinancialOverviewCard(
        summary: summary,
        onViewDetails: onViewDetails,
      ),
      loading: () => const _FinancialOverviewSkeleton(),
      error: (error, _) => _FinancialOverviewError(
        error: error,
        onRetry: () => ref.refresh(financialOverviewProvider),
      ),
    );
  }
}

class _FinancialOverviewCard extends StatelessWidget {
  const _FinancialOverviewCard({required this.summary, this.onViewDetails});

  final FinancialOverviewSummary summary;
  final VoidCallback? onViewDetails;

  @override
  Widget build(BuildContext context) {
    final localeName = context.locale.toString();
    final currencyFormat = NumberFormat.simpleCurrency(
      locale: localeName,
      name: 'EUR',
    );
    final dateFormat = DateFormat.yMMMMd(localeName);

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'finance.overview.title'.tr(),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'finance.overview.period'.tr(),
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: onViewDetails,
                  icon: const Icon(Icons.chevron_right),
                  label: Text('finance.overview.viewPayouts'.tr()),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _OverviewMetricsRow(
              totalNet: summary.stats.totalAmountNet,
              pendingNet: summary.pendingNetAmount,
              completedCount: summary.stats.completedCount,
              failedCount: summary.stats.failedCount,
              currencyFormat: currencyFormat,
            ),
            const SizedBox(height: 16),
            if (summary.lastCompletedTransfer != null ||
                summary.nextPendingTransfer != null) ...[
              _HighlightsSection(
                lastCompleted: summary.lastCompletedTransfer,
                nextPending: summary.nextPendingTransfer,
                numberFormat: currencyFormat,
                dateFormat: dateFormat,
              ),
              const SizedBox(height: 16),
            ],
            if (summary.recentTransfers.isNotEmpty)
              _RecentTransfersList(
                transfers: summary.recentTransfers.take(3).toList(),
                dateFormat: dateFormat,
                numberFormat: currencyFormat,
                onViewDetails: onViewDetails,
              )
            else
              const _EmptyRecentTransfers(),
          ],
        ),
      ),
    );
  }
}

class _OverviewMetricsRow extends StatelessWidget {
  const _OverviewMetricsRow({
    required this.totalNet,
    required this.pendingNet,
    required this.completedCount,
    required this.failedCount,
    required this.currencyFormat,
  });

  final double totalNet;
  final double pendingNet;
  final int completedCount;
  final int failedCount;
  final NumberFormat currencyFormat;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        final children = <Widget>[
          _MetricTile(
            icon: Icons.account_balance_wallet,
            title: 'finance.overview.metrics.totalNet'.tr(),
            value: currencyFormat.format(totalNet),
            color: Colors.green,
          ),
          _MetricTile(
            icon: Icons.schedule,
            title: 'finance.overview.metrics.pendingNet'.tr(),
            value: currencyFormat.format(pendingNet),
            color: Colors.orange,
          ),
          _MetricTile(
            icon: Icons.check_circle_outline,
            title: 'finance.overview.metrics.completed'.tr(),
            value: completedCount.toString(),
            color: Colors.blue,
          ),
          _MetricTile(
            icon: Icons.error_outline,
            title: 'finance.overview.metrics.failed'.tr(),
            value: failedCount.toString(),
            color: Colors.red,
          ),
        ];

        if (isWide) {
          return Row(
            children: children
                .map(
                  (tile) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: tile,
                    ),
                  ),
                )
                .toList(),
          );
        }

        return Column(
          children: children
              .map(
                (tile) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: tile,
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color.withValues(alpha: 0.08),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HighlightsSection extends StatelessWidget {
  const _HighlightsSection({
    required this.lastCompleted,
    required this.nextPending,
    required this.numberFormat,
    required this.dateFormat,
  });

  final Transfer? lastCompleted;
  final Transfer? nextPending;
  final NumberFormat numberFormat;
  final DateFormat dateFormat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.blueGrey.withValues(alpha: 0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'finance.overview.highlights.title'.tr(),
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (lastCompleted != null)
                Expanded(
                  child: _HighlightTile(
                    icon: Icons.check_circle,
                    title: 'finance.overview.highlights.lastPayout'.tr(),
                    amount: numberFormat.format(lastCompleted?.amountNet ?? 0),
                    date: lastCompleted?.completedAt != null
                        ? dateFormat.format(lastCompleted!.completedAt!)
                        : null,
                    color: Colors.green,
                  ),
                ),
              if (lastCompleted != null && nextPending != null)
                const SizedBox(width: 12),
              if (nextPending != null)
                Expanded(
                  child: _HighlightTile(
                    icon: Icons.watch_later_outlined,
                    title: 'finance.overview.highlights.nextPayout'.tr(),
                    amount: numberFormat.format(nextPending?.amountNet ?? 0),
                    date: nextPending?.createdAt != null
                        ? dateFormat.format(nextPending!.createdAt!)
                        : null,
                    color: Colors.orange,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HighlightTile extends StatelessWidget {
  const _HighlightTile({
    required this.icon,
    required this.title,
    required this.amount,
    required this.color,
    this.date,
  });

  final IconData icon;
  final String title;
  final String amount;
  final String? date;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            amount,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          if (date != null) ...[
            const SizedBox(height: 4),
            Text(
              date!,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ],
      ),
    );
  }
}

class _RecentTransfersList extends StatelessWidget {
  const _RecentTransfersList({
    required this.transfers,
    required this.dateFormat,
    required this.numberFormat,
    this.onViewDetails,
  });

  final List<Transfer> transfers;
  final DateFormat dateFormat;
  final NumberFormat numberFormat;
  final VoidCallback? onViewDetails;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'finance.overview.recent.title'.tr(),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            TextButton(
              onPressed: onViewDetails,
              child: Text('finance.overview.recent.seeAll'.tr()),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...transfers.map(
          (transfer) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: _TransferListTile(
              transfer: transfer,
              dateFormat: dateFormat,
              numberFormat: numberFormat,
            ),
          ),
        ),
      ],
    );
  }
}

class _TransferListTile extends StatelessWidget {
  const _TransferListTile({
    required this.transfer,
    required this.dateFormat,
    required this.numberFormat,
  });

  final Transfer transfer;
  final DateFormat dateFormat;
  final NumberFormat numberFormat;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(transfer.status);
    final statusLabel = _statusLabel(context, transfer.status);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: statusColor.withValues(alpha: 0.15),
        child: Icon(Icons.payments_outlined, color: statusColor),
      ),
      title: Text(
        numberFormat.format(transfer.amountNet),
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        transfer.createdAt != null
            ? dateFormat.format(transfer.createdAt!)
            : 'finance.overview.recent.unknownDate'.tr(),
      ),
      trailing: Chip(
        label: Text(statusLabel),
        backgroundColor: statusColor.withValues(alpha: 0.15),
        labelStyle: TextStyle(color: statusColor),
      ),
    );
  }

  Color _statusColor(TransferStatus status) {
    switch (status) {
      case TransferStatus.completed:
        return Colors.green;
      case TransferStatus.pending:
        return Colors.orange;
      case TransferStatus.failed:
        return Colors.red;
    }
  }

  String _statusLabel(BuildContext context, TransferStatus status) {
    switch (status) {
      case TransferStatus.completed:
        return 'finance.overview.status.completed'.tr();
      case TransferStatus.pending:
        return 'finance.overview.status.pending'.tr();
      case TransferStatus.failed:
        return 'finance.overview.status.failed'.tr();
    }
  }
}

class _EmptyRecentTransfers extends StatelessWidget {
  const _EmptyRecentTransfers();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.inbox_outlined, color: Colors.grey[500]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'finance.overview.recent.emptyTitle'.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'finance.overview.recent.emptySubtitle'.tr(),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FinancialOverviewSkeleton extends StatelessWidget {
  const _FinancialOverviewSkeleton();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(width: 200, height: 20, color: Colors.grey[300]),
                Container(
                  width: 100,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              children: List.generate(
                4,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FinancialOverviewError extends StatelessWidget {
  const _FinancialOverviewError({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'finance.overview.error.generic'.tr(),
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    error.toString(),
                    style: TextStyle(color: Colors.red[300]),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: onRetry,
              child: Text('finance.overview.error.retry'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}

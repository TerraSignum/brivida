import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/models/payment.dart';
import '../../../core/models/payout.dart';
import '../../../core/utils/navigation_helpers.dart';
import '../logic/payouts_controller.dart';

/// Main page for Pro users to view their payout history
class PayoutsPage extends ConsumerStatefulWidget {
  const PayoutsPage({super.key});

  @override
  ConsumerState<PayoutsPage> createState() => _PayoutsPageState();
}

class _PayoutsPageState extends ConsumerState<PayoutsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(payoutFilterProvider);
    final viewMode = ref.watch(payoutViewModeProvider);
    final transfersAsync = ref.watch(
      transfersProvider(filter.isActive ? filter : null),
    );
    final exportLoading = ref.watch(exportLoadingProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => popOrGoHome(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(context.tr('payouts.title')),
        actions: [
          // Filter button
          IconButton(
            icon: Badge(
              isLabelVisible: filter.isActive,
              child: const Icon(Icons.filter_list),
            ),
            onPressed: () => _showFilterSheet(context),
            tooltip: context.tr('payouts.actions.filter'),
          ),
          // View mode selector
          PopupMenuButton<PayoutViewMode>(
            icon: Icon(viewMode.icon),
            onSelected: (mode) {
              ref.read(payoutViewModeProvider.notifier).state = mode;
            },
            itemBuilder: (context) => PayoutViewMode.values
                .map(
                  (mode) => PopupMenuItem(
                    value: mode,
                    child: Row(
                      children: [
                        Icon(mode.icon, size: 20),
                        const SizedBox(width: 8),
                        Text(mode.label(context)),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          // Export button
          IconButton(
            icon: exportLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.download),
            onPressed: exportLoading ? null : () => _exportTransfers(context),
            tooltip: context.tr('payouts.actions.exportCsv'),
          ),
        ],
        bottom: viewMode == PayoutViewMode.stats
            ? null
            : TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                    text: context.tr('payouts.tabs.all'),
                    icon: const Icon(Icons.list),
                  ),
                  Tab(
                    text: context.tr('payouts.tabs.pending'),
                    icon: const Icon(Icons.pending),
                  ),
                ],
              ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(transfersProvider);
          ref.invalidate(transferStatsProvider);
        },
        child: _buildBody(context, transfersAsync, viewMode),
      ),
      floatingActionButton: filter.isActive
          ? FloatingActionButton.extended(
              onPressed: () {
                ref.read(payoutFilterProvider.notifier).state =
                    const PayoutFilter();
              },
              icon: const Icon(Icons.clear),
              label: Text(context.tr('payouts.actions.resetFilters')),
            )
          : null,
    );
  }

  Widget _buildBody(
    BuildContext context,
    AsyncValue<List<Transfer>> transfersAsync,
    PayoutViewMode viewMode,
  ) {
    return transfersAsync.when(
      data: (transfers) {
        if (transfers.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_balance_wallet,
                  size: 64,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  context.tr('payouts.empty.primaryTitle'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.tr('payouts.empty.primarySubtitle'),
                  style: const TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        switch (viewMode) {
          case PayoutViewMode.list:
            return _buildListView(transfers);
          case PayoutViewMode.grid:
            return _buildGridView(transfers);
          case PayoutViewMode.stats:
            return _buildStatsView();
        }
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorWidget(error),
    );
  }

  Widget _buildListView(List<Transfer> transfers) {
    return TabBarView(
      controller: _tabController,
      children: [
        // All transfers
        _buildTransfersList(context, transfers),
        // Pending transfers
        _buildTransfersList(
          context,
          transfers.where((t) => t.status == TransferStatus.pending).toList(),
        ),
      ],
    );
  }

  Widget _buildTransfersList(BuildContext context, List<Transfer> transfers) {
    if (transfers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              context.tr('payouts.empty.filteredTitle'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.tr('payouts.empty.filteredSubtitle'),
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return ListView.separated(
      controller: _scrollController,
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset),
      itemCount: transfers.length,
      separatorBuilder: (context, index) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final transfer = transfers[index];
        return _buildTransferListItem(context, transfer);
      },
    );
  }

  Widget _buildGridView(List<Transfer> transfers) {
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final transfer = transfers[index];
              return _buildGridItem(context, transfer);
            }, childCount: transfers.length),
          ),
        ),
      ],
    );
  }

  Widget _buildGridItem(BuildContext context, Transfer transfer) {
    return Card(
      child: InkWell(
        onTap: () => _navigateToDetail(transfer.id ?? ''),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status and amount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  transfer.statusChip(context),
                  Text(
                    transfer.formattedAmount,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: transfer.status == TransferStatus.completed
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Date
              Text(
                transfer.formattedDate,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Spacer(),
              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (transfer.stripeTransferId != null)
                    IconButton(
                      icon: const Icon(Icons.open_in_new, size: 16),
                      onPressed: () => _openInStripe(context, transfer),
                      tooltip: context.tr('payouts.actions.openInStripe'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsView() {
    final filter = ref.watch(payoutFilterProvider);
    final statsAsync = ref.watch(
      transferStatsProvider(filter.isActive ? filter : null),
    );
    final transfersAsync = ref.watch(
      transfersProvider(filter.isActive ? filter : null),
    );

    return statsAsync.when(
      data: (stats) => transfersAsync.when(
        data: (transfers) => SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            16 + MediaQuery.of(context).viewPadding.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Auszahlungsstatistiken',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              _buildBasicStatsCard(stats),
              const SizedBox(height: 24),
              _buildStatsCharts(stats),
              const SizedBox(height: 24),
              _buildDailyNetBarChart(transfers),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorWidget(error),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorWidget(error),
    );
  }

  Widget _buildStatsCharts(TransferStats stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Verlauf', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        // Enhanced table view instead of placeholder chart
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transfer Summary',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                _buildStatsTable(stats),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsTable(TransferStats stats) {
    return Table(
      columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(1)},
      children: [
        _buildTableRow(
          'Total Net Amount',
          '€${stats.totalAmountNet.toStringAsFixed(2)}',
          Colors.green,
        ),
        _buildTableRow(
          'Total Gross Amount',
          '€${stats.totalAmountGross.toStringAsFixed(2)}',
          Colors.blue,
        ),
        _buildTableRow(
          'Platform Fees',
          '€${stats.totalPlatformFees.toStringAsFixed(2)}',
          Colors.purple,
        ),
        _buildTableRow(
          'Completed Transfers',
          '${stats.completedCount}',
          Colors.green,
        ),
        _buildTableRow(
          'Pending Transfers',
          '${stats.pendingCount}',
          Colors.orange,
        ),
        _buildTableRow('Failed Transfers', '${stats.failedCount}', Colors.red),
        _buildTableRow(
          'Total Transfers',
          '${stats.totalCount}',
          Colors.grey[700]!,
        ),
      ],
    );
  }

  Widget _buildDailyNetBarChart(List<Transfer> transfers) {
    // Aggregate by date (YYYY-MM-DD) for completed transfers
    final Map<String, double> perDay = {};
    for (final t in transfers) {
      if (t.status != TransferStatus.completed || t.createdAt == null) continue;
      final d = t.createdAt!;
      final key =
          '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
      perDay.update(key, (v) => v + t.amountNet, ifAbsent: () => t.amountNet);
    }

    if (perDay.isEmpty) {
      return const SizedBox.shrink();
    }

    // Sort by date ascending
    final entries = perDay.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    final maxVal = entries
        .map((e) => e.value)
        .fold<double>(0, (p, v) => v > p ? v : p);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Netto pro Tag',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (final e in entries) ...[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Tooltip(
                            message: '€${e.value.toStringAsFixed(2)}',
                            child: Container(
                              height: maxVal == 0
                                  ? 0
                                  : (150 * (e.value / maxVal)),
                              width: 10,
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            e.key.substring(5),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(String label, String value, Color color) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Fehler beim Laden der Auszahlungen',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: const TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.invalidate(transfersProvider);
            },
            child: const Text('Erneut versuchen'),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _buildFilterSheet(context),
    );
  }

  Future<void> _exportTransfers(BuildContext context) async {
    ref.read(exportLoadingProvider.notifier).state = true;

    try {
      final filter = ref.read(payoutFilterProvider);
      final controller = ref.read(payoutsControllerProvider.notifier);

      final result = await controller.exportTransfersCsv(
        from: filter.from,
        to: filter.to,
      );

      if (!context.mounted) {
        return;
      }

      if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('CSV-Export erfolgreich erstellt'),
            action: SnackBarAction(
              label: 'Download',
              onPressed: () => _downloadCsv(result.downloadUrl),
            ),
          ),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export fehlgeschlagen: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      ref.read(exportLoadingProvider.notifier).state = false;
    }
  }

  Future<void> _downloadCsv(String url) async {
    // Show user choice dialog
    final choice = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('CSV Download'),
        content: const Text('Wie möchten Sie die CSV-Datei öffnen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop('copy'),
            child: const Text('URL kopieren'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop('open'),
            child: const Text('Im Browser öffnen'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
        ],
      ),
    );

    if (choice == null) return;

    try {
      if (choice == 'copy') {
        await Clipboard.setData(ClipboardData(text: url));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Download-URL wurde in die Zwischenablage kopiert'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else if (choice == 'open') {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          throw Exception('Could not launch URL');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Öffnen der URL: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _navigateToDetail(String transferId) {
    context.push('/payouts/$transferId');
  }

  Future<void> _openInStripe(BuildContext context, Transfer transfer) async {
    if (transfer.stripeTransferId == null) return;

    final controller = ref.read(payoutsControllerProvider.notifier);
    final messenger = ScaffoldMessenger.of(context);
    final errorText = context.tr('payouts.errors.openStripe');

    final success = await controller.openInStripe(transfer.stripeTransferId!);

    if (!mounted) return;

    if (!success) {
      messenger.showSnackBar(
        SnackBar(content: Text(errorText), backgroundColor: Colors.orange),
      );
    }
  }

  Widget _buildTransferListItem(BuildContext context, Transfer transfer) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: transfer.statusColor,
          child: Icon(
            transfer.status == TransferStatus.completed
                ? Icons.check
                : transfer.status == TransferStatus.failed
                ? Icons.error
                : Icons.access_time,
            color: Colors.white,
          ),
        ),
        title: Text(transfer.formattedAmount),
        subtitle: Text(
          '${transfer.statusLabel(context)} • ${transfer.formattedDate}',
        ),
        trailing: transfer.stripeTransferId != null
            ? IconButton(
                icon: const Icon(Icons.open_in_new),
                onPressed: () => _openInStripe(context, transfer),
                tooltip: context.tr('payouts.actions.openInStripe'),
              )
            : null,
        onTap: () => _navigateToDetail(transfer.id ?? ''),
      ),
    );
  }

  Widget _buildBasicStatsCard(TransferStats stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Übersicht', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Gesamt',
                    '${stats.totalAmountNet.toStringAsFixed(2)} €',
                    Icons.euro,
                    Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Anzahl',
                    '${stats.totalCount}',
                    Icons.receipt,
                    Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Ausstehend',
                    '${stats.pendingCount}',
                    Icons.pending,
                    Colors.orange,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Fehlgeschlagen',
                    '${stats.failedCount}',
                    Icons.error,
                    Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _buildFilterSheet(BuildContext context) {
    final currentFilter = ref.read(payoutFilterProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Filter', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          const Text('Zeitraum:'),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: currentFilter.from ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      ref.read(payoutFilterProvider.notifier).state =
                          currentFilter.copyWith(from: date);
                    }
                  },
                  child: Text(
                    currentFilter.from?.toString().split(' ')[0] ?? 'Von',
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: currentFilter.to ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      ref.read(payoutFilterProvider.notifier).state =
                          currentFilter.copyWith(to: date);
                    }
                  },
                  child: Text(
                    currentFilter.to?.toString().split(' ')[0] ?? 'Bis',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Abbrechen'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Anwenden'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

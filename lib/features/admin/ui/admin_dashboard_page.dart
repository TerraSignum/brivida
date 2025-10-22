import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/admin.dart';
import '../../../core/models/dispute.dart';
import '../../../core/models/payment.dart';
import '../logic/admin_controller.dart';
import 'admin_retention_settings_page.dart';
import '../../../core/utils/navigation_helpers.dart';

class AdminDashboardPage extends ConsumerStatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  ConsumerState<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends ConsumerState<AdminDashboardPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  AdminFilter _filter = const AdminFilter();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminControllerProvider.notifier).loadKpiData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'admin.dashboard.backTooltip'.tr(),
          onPressed: () => popOrGoHome(context),
        ),
        title: Text('admin.dashboard.title'.tr()),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: 'admin.dashboard.tabs.disputes'.tr(),
              icon: const Icon(Icons.gavel),
            ),
            Tab(
              text: 'admin.dashboard.tabs.payments'.tr(),
              icon: const Icon(Icons.payment),
            ),
            Tab(
              text: 'admin.dashboard.tabs.pros'.tr(),
              icon: const Icon(Icons.people),
            ),
            Tab(
              text: 'admin.dashboard.tabs.settings'.tr(),
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // KPI Cards Section
          _buildKpiSection(),

          // Main Content Tabs
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDisputesTab(),
                _buildPaymentsTab(),
                _buildProsTab(),
                _buildSettingsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiSection() {
    final kpiAsyncValue = ref.watch(kpiDataProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[50],
      child: kpiAsyncValue.when(
        data: (kpiData) => _buildKpiCards(kpiData),
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stack) => Container(
          padding: const EdgeInsets.all(16),
          child: Text(
            'admin.dashboard.kpi.loadError'.tr(
              namedArgs: {'error': error.toString()},
            ),
            style: TextStyle(color: Colors.red[700]),
          ),
        ),
      ),
    );
  }

  Widget _buildKpiCards(AdminKpiData kpiData) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.5,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _buildKpiCard(
          'admin.dashboard.kpi.activePros'.tr(),
          '${kpiData.activePros}',
          Icons.people_alt,
          Colors.blue,
        ),
        _buildKpiCard(
          'admin.dashboard.kpi.openDisputes'.tr(),
          '${kpiData.openDisputes}',
          Icons.gavel,
          Colors.orange,
        ),
        _buildKpiCard(
          'admin.dashboard.kpi.captured24h'.tr(),
          '€${kpiData.capturedPayments24h.toStringAsFixed(0)}',
          Icons.trending_up,
          Colors.green,
        ),
        _buildKpiCard(
          'admin.dashboard.kpi.refunds24h'.tr(),
          '€${kpiData.refunds24h.toStringAsFixed(0)}',
          Icons.trending_down,
          Colors.red,
        ),
      ],
    );
  }

  Widget _buildKpiCard(String title, String value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisputesTab() {
    final disputesAsyncValue = ref.watch(disputesStreamProvider);

    return Column(
      children: [
        _buildDisputesFilter(),
        Expanded(
          child: disputesAsyncValue.when(
            data: (disputes) {
              final filteredDisputes = disputes.where((dispute) {
                final matchesStatus =
                    _filter.status == null ||
                    dispute.status.name == _filter.status;
                final query = _filter.searchQuery?.trim();
                final matchesQuery = query == null || query.isEmpty
                    ? true
                    : dispute.id.toLowerCase().contains(query.toLowerCase()) ||
                          dispute.jobId.toLowerCase().contains(
                            query.toLowerCase(),
                          ) ||
                          dispute.paymentId.toLowerCase().contains(
                            query.toLowerCase(),
                          );
                return matchesStatus && matchesQuery;
              }).toList();

              if (_filter.sortBy == 'openedAt') {
                filteredDisputes.sort(
                  (a, b) => _filter.sortAsc
                      ? a.openedAt.compareTo(b.openedAt)
                      : b.openedAt.compareTo(a.openedAt),
                );
              }

              return _buildDisputesList(filteredDisputes);
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Text(
                'admin.dashboard.errors.generic'.tr(
                  namedArgs: {'error': error.toString()},
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDisputesFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[50],
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String?>(
              value: _filter.status,
              decoration: InputDecoration(
                labelText: 'admin.dashboard.filters.status'.tr(),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              items: [
                DropdownMenuItem<String?>(
                  value: null,
                  child: Text('admin.dashboard.filters.all'.tr()),
                ),
                ...DisputeStatus.values.map(
                  (status) => DropdownMenuItem<String?>(
                    value: status.name,
                    child: Text(status.displayName),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _filter = _filter.copyWith(status: value);
                });
              },
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: _showExportDialog,
            icon: const Icon(Icons.download, size: 18),
            label: Text('admin.dashboard.actions.export'.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildDisputesList(List<Dispute> disputes) {
    if (disputes.isEmpty) {
      return Center(child: Text('admin.dashboard.empty.disputes'.tr()));
    }

    return ListView.builder(
      itemCount: disputes.length,
      itemBuilder: (context, index) {
        final dispute = disputes[index];
        return _buildDisputeCard(dispute);
      },
    );
  }

  Widget _buildDisputeCard(Dispute dispute) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getDisputeStatusColor(dispute.status),
          child: Icon(Icons.gavel, color: Colors.white, size: 20),
        ),
        title: Text(
          'admin.dashboard.cards.case'.tr(
            namedArgs: {'id': dispute.id.substring(0, 8)},
          ),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'admin.dashboard.cards.reason'.tr(
                namedArgs: {'reason': dispute.reason.displayName},
              ),
            ),
            Text(
              'admin.dashboard.cards.amount'.tr(
                namedArgs: {
                  'amount': dispute.requestedAmount.toStringAsFixed(2),
                },
              ),
            ),
            Text(
              'admin.dashboard.cards.status'.tr(
                namedArgs: {'status': dispute.status.displayName},
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatDate(dispute.openedAt),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
        onTap: () {
          // Navigate to dispute detail page using GoRouter
          context.push('/disputes/${dispute.id}');
        },
      ),
    );
  }

  // ========================================
  // PAYMENTS TAB
  // ========================================

  Widget _buildPaymentsTab() {
    final paymentsAsyncValue = ref.watch(paymentsStreamProvider);

    return paymentsAsyncValue.when(
      data: (payments) => _buildPaymentsList(payments),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          'admin.dashboard.errors.generic'.tr(
            namedArgs: {'error': error.toString()},
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentsList(List<Payment> payments) {
    if (payments.isEmpty) {
      return Center(child: Text('admin.dashboard.empty.payments'.tr()));
    }

    return ListView.builder(
      itemCount: payments.length,
      itemBuilder: (context, index) {
        final payment = payments[index];
        return _buildPaymentCard(payment);
      },
    );
  }

  Widget _buildPaymentCard(Payment payment) {
    final paymentId = payment.id != null && payment.id!.length >= 8
        ? payment.id!.substring(0, 8)
        : payment.id ?? '—';
    final jobIdSnippet = payment.jobId.length >= 8
        ? payment.jobId.substring(0, 8)
        : payment.jobId;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getPaymentStatusColor(payment.status),
          child: Icon(Icons.payment, color: Colors.white, size: 20),
        ),
        title: Text(
          'admin.dashboard.cards.payment'.tr(namedArgs: {'id': paymentId}),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'admin.dashboard.cards.job'.tr(
                namedArgs: {'jobId': jobIdSnippet},
              ),
            ),
            Text(
              'admin.dashboard.cards.amount'.tr(
                namedArgs: {'amount': payment.amountGross.toStringAsFixed(2)},
              ),
            ),
            Text(
              'admin.dashboard.cards.status'.tr(
                namedArgs: {'status': payment.status.name},
              ),
            ),
          ],
        ),
        trailing: Text(
          _formatDate(payment.createdAt),
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ),
    );
  }

  // ========================================
  // PROS TAB
  // ========================================

  Widget _buildProsTab() {
    final adminState = ref.watch(adminControllerProvider);
    final pros = adminState.pros;
    final isLoading = adminState.isLoading && pros.isEmpty;
    final error = adminState.error;

    return Column(
      children: [
        _buildProsFilter(),
        Expanded(
          child: Builder(
            builder: (context) {
              if (isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (error != null && pros.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'admin.dashboard.errors.prosLoad'.tr(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          error,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (pros.isEmpty) {
                return Center(child: Text('admin.dashboard.empty.pros'.tr()));
              }

              return _buildProsList(pros);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProsFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[50],
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: 'admin.dashboard.filters.searchPlaceholder'.tr(),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _filter = _filter.copyWith(searchQuery: value);
                });
                ref.read(adminControllerProvider.notifier).searchPros(value);
              },
            ),
          ),
          const SizedBox(width: 16),
          DropdownButton<String>(
            value: _filter.sortBy ?? 'createdAt',
            items: [
              DropdownMenuItem(
                value: 'createdAt',
                child: Text('admin.dashboard.filters.sort.createdAt'.tr()),
              ),
              DropdownMenuItem(
                value: 'healthScore',
                child: Text('admin.dashboard.filters.sort.healthScore'.tr()),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _filter = _filter.copyWith(sortBy: value);
              });
              ref
                  .read(adminControllerProvider.notifier)
                  .loadPros(sortBy: value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProsList(List<Map<String, dynamic>> pros) {
    if (pros.isEmpty) {
      return Center(child: Text('admin.dashboard.empty.pros'.tr()));
    }

    return ListView.builder(
      itemCount: pros.length,
      itemBuilder: (context, index) {
        final pro = pros[index];
        return _buildProCard(pro);
      },
    );
  }

  Widget _buildProCard(Map<String, dynamic> pro) {
    final health = pro['health'] as HealthScore;
    final flags = pro['flags'] as ProFlags;
    final badges = pro['badges'] as List<ProBadge>;
    final rawName = pro['name'] as String?;
    final displayName = (rawName == null || rawName.isEmpty)
        ? 'admin.dashboard.unknown'.tr()
        : rawName;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: flags.hardBanned
              ? Colors.red
              : flags.softBanned
              ? Colors.orange
              : Colors.green,
          child: Text(
            health.score.toInt().toString(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        title: Text(
          displayName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(pro['email'] as String? ?? ''),
            if (badges.isNotEmpty)
              Wrap(
                spacing: 4,
                children: badges
                    .take(2)
                    .map(
                      (badge) => Chip(
                        label: Text(
                          badge.displayName,
                          style: const TextStyle(fontSize: 10),
                        ),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    )
                    .toList(),
              ),
            if (flags.softBanned || flags.hardBanned)
              Text(
                flags.hardBanned
                    ? 'admin.dashboard.flags.hard'.tr()
                    : 'admin.dashboard.flags.soft'.tr(),
                style: TextStyle(
                  color: flags.hardBanned ? Colors.red : Colors.orange,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          context.push('/admin/pro/${pro['uid'] as String}');
        },
      ),
    );
  }

  // ========================================
  // HELPER METHODS
  // ========================================

  Color _getDisputeStatusColor(DisputeStatus status) {
    switch (status) {
      case DisputeStatus.open:
      case DisputeStatus.awaitingPro:
        return Colors.orange;
      case DisputeStatus.underReview:
        return Colors.blue;
      case DisputeStatus.resolvedRefundFull:
      case DisputeStatus.resolvedRefundPartial:
      case DisputeStatus.resolvedNoRefund:
        return Colors.green;
      case DisputeStatus.cancelled:
      case DisputeStatus.expired:
        return Colors.grey;
    }
  }

  Color _getPaymentStatusColor(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.pending:
        return Colors.orange;
      case PaymentStatus.captured:
        return Colors.blue;
      case PaymentStatus.transferred:
        return Colors.green;
      case PaymentStatus.refunded:
        return Colors.red;
      case PaymentStatus.failed:
      case PaymentStatus.cancelled:
        return Colors.grey;
    }
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('admin.dashboard.exportDialog.title'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('admin.dashboard.exportDialog.disputes'.tr()),
              onTap: () => _exportCsv(ExportType.disputes),
            ),
            ListTile(
              title: Text('admin.dashboard.exportDialog.payments'.tr()),
              onTap: () => _exportCsv(ExportType.payments),
            ),
            ListTile(
              title: Text('admin.dashboard.exportDialog.jobs'.tr()),
              onTap: () => _exportCsv(ExportType.jobs),
            ),
            ListTile(
              title: Text('admin.dashboard.exportDialog.users'.tr()),
              onTap: () => _exportCsv(ExportType.users),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('admin.dashboard.exportDialog.cancel'.tr()),
          ),
        ],
      ),
    );
  }

  void _exportCsv(ExportType type) {
    Navigator.of(context).pop();
    ref.read(adminControllerProvider.notifier).exportCsv(type);
  }

  Widget _buildSettingsTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.settings, color: Theme.of(context).primaryColor),
              const SizedBox(width: 8),
              Text(
                'admin.dashboard.settings.title'.tr(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Settings Cards
          Expanded(
            child: ListView(
              children: [
                // Data Retention Settings
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.security, color: Colors.blue),
                    title: Text(
                      'admin.dashboard.settings.dataRetention.title'.tr(),
                    ),
                    subtitle: Text(
                      'admin.dashboard.settings.dataRetention.subtitle'.tr(),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              const AdminRetentionSettingsPage(),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 8),

                // Analytics Settings
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.analytics, color: Colors.green),
                    title: Text(
                      'admin.dashboard.settings.analytics.title'.tr(),
                    ),
                    subtitle: Text(
                      'admin.dashboard.settings.analytics.subtitle'.tr(),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      context.push('/admin/analytics');
                    },
                  ),
                ),

                const SizedBox(height: 8),

                // System Configuration
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.tune, color: Colors.orange),
                    title: Text('admin.dashboard.settings.system.title'.tr()),
                    subtitle: Text(
                      'admin.dashboard.settings.system.subtitle'.tr(),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      context.push('/admin/system');
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return '—';
    }

    return DateFormat('dd MMM yyyy, HH:mm').format(date);
  }
}

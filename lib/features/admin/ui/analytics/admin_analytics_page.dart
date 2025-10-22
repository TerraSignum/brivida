import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/services/kpi_service.dart';
import '../../../../core/utils/navigation_helpers.dart';

// Simple auth state provider for admin check
final authStreamProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

class AdminAnalyticsPage extends ConsumerWidget {
  const AdminAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStreamProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          popOrGoHome(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: MaterialLocalizations.of(context).backButtonTooltip,
            onPressed: () => popOrGoHome(context),
          ),
          title: Text('analytics.admin.title'.tr()),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 1,
        ),
        body: authState.when(
          data: (user) {
            if (user == null) {
              return const Center(child: Text('Not authenticated'));
            }
            return _AnalyticsContent();
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }
}

class _AnalyticsContent extends ConsumerStatefulWidget {
  @override
  _AnalyticsContentState createState() => _AnalyticsContentState();
}

class _AnalyticsContentState extends ConsumerState<_AnalyticsContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTimeRange? _dateRange;
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Default to last 30 days
    final now = DateTime.now();
    _dateRange = DateTimeRange(
      start: now.subtract(const Duration(days: 30)),
      end: now,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Date Range Picker
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
          ),
          child: Row(
            children: [
              Expanded(
                child: _DateRangeButton(
                  dateRange: _dateRange,
                  onChanged: (range) => setState(() => _dateRange = range),
                ),
              ),
              const SizedBox(width: 16),
              _ExportButton(
                dateRange: _dateRange,
                isLoading: _isExporting,
                onExportStart: () => setState(() => _isExporting = true),
                onExportEnd: () => setState(() => _isExporting = false),
              ),
            ],
          ),
        ),

        // Tabs
        TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Colors.grey[600],
          indicatorColor: Theme.of(context).primaryColor,
          tabs: [
            Tab(text: 'analytics.admin.tabs.kpis'.tr()),
            Tab(text: 'analytics.admin.tabs.events'.tr()),
          ],
        ),

        // Tab Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _ServerKpiTab(dateRange: _dateRange),
              _EventsTab(dateRange: _dateRange),
            ],
          ),
        ),
      ],
    );
  }
}

class _DateRangeButton extends StatelessWidget {
  final DateTimeRange? dateRange;
  final ValueChanged<DateTimeRange?> onChanged;

  const _DateRangeButton({required this.dateRange, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd.MM.yyyy');

    return OutlinedButton.icon(
      onPressed: () async {
        final range = await showDateRangePicker(
          context: context,
          firstDate: DateTime.now().subtract(const Duration(days: 365)),
          lastDate: DateTime.now(),
          initialDateRange: dateRange,
        );
        if (range != null) {
          onChanged(range);
        }
      },
      icon: const Icon(Icons.date_range),
      label: Text(
        dateRange != null
            ? '${formatter.format(dateRange!.start)} - ${formatter.format(dateRange!.end)}'
            : 'analytics.admin.selectDateRange'.tr(),
      ),
    );
  }
}

class _ExportButton extends StatelessWidget {
  final DateTimeRange? dateRange;
  final bool isLoading;
  final VoidCallback onExportStart;
  final VoidCallback onExportEnd;

  const _ExportButton({
    required this.dateRange,
    required this.isLoading,
    required this.onExportStart,
    required this.onExportEnd,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (type) => _export(context, type),
      enabled: !isLoading && dateRange != null,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'events',
          child: Text('analytics.admin.export.events'.tr()),
        ),
        PopupMenuItem(
          value: 'daily',
          child: Text('analytics.admin.export.daily'.tr()),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            else
              const Icon(Icons.download, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text(
              'analytics.admin.export.title'.tr(),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _export(BuildContext context, String type) async {
    if (dateRange == null) return;

    onExportStart();

    try {
      final functions = FirebaseFunctions.instanceFor(region: 'europe-west1');
      final callable = functions.httpsCallable('exportAnalyticsCsv');

      final result = await callable.call({
        'type': type,
        'dateFrom': dateRange!.start.toIso8601String(),
        'dateTo': dateRange!.end.toIso8601String(),
      });

      final data = result.data as Map<String, dynamic>;
      final downloadUrl = data['downloadUrl'] as String;
      final filename = data['filename'] as String;

      if (context.mounted) {
        _showDownloadDialog(context, downloadUrl, filename);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'analytics.admin.export.error'.tr(args: [e.toString()]),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      onExportEnd();
    }
  }

  void _showDownloadDialog(BuildContext context, String url, String filename) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('analytics.admin.export.ready'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('analytics.admin.export.filename'.tr(args: [filename])),
            const SizedBox(height: 8),
            Text('analytics.admin.export.expiry'.tr()),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('common.close'.tr()),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _handleDownload(context, url, filename);
            },
            child: Text('analytics.admin.export.download'.tr()),
          ),
        ],
      ),
    );
  }

  Future<void> _handleDownload(
    BuildContext context,
    String url,
    String filename,
  ) async {
    try {
      // Show options dialog: Copy URL or Launch in browser
      final action = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Download Options'),
          content: const Text('Choose how to access the export file:'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop('copy'),
              child: const Text('Copy URL'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop('launch'),
              child: const Text('Open in Browser'),
            ),
          ],
        ),
      );

      if (action == 'copy') {
        // Copy URL to clipboard
        await Clipboard.setData(ClipboardData(text: url));
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Export URL copied to clipboard'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else if (action == 'launch') {
        // Launch URL in browser
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Could not launch URL. URL copied to clipboard instead.',
                ),
                duration: Duration(seconds: 3),
              ),
            );
            await Clipboard.setData(ClipboardData(text: url));
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}

class _ServerKpiTab extends StatelessWidget {
  final DateTimeRange? dateRange;

  const _ServerKpiTab({required this.dateRange});

  @override
  Widget build(BuildContext context) {
    if (dateRange == null) {
      return const Center(child: Text('Please select a date range'));
    }

    return Consumer(
      builder: (context, ref, child) {
        final kpiSummaryAsync = ref.watch(serverKpiSummaryProvider(dateRange));
        final advancedMetricsAsync = ref.watch(serverAdvancedMetricsProvider);

        return kpiSummaryAsync.when(
          data: (kpiData) => SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Server-computed KPI cards
                _buildServerKpiCards(kpiData),
                const SizedBox(height: 24),

                // Advanced metrics section
                advancedMetricsAsync.when(
                  data: (metricsData) =>
                      _buildAdvancedMetricsSection(metricsData),
                  loading: () => const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(width: 16),
                          Text('Loading advanced metrics...'),
                        ],
                      ),
                    ),
                  ),
                  error: (error, stack) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text('Error loading advanced metrics: $error'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) =>
              Center(child: Text('Error loading KPI data: $error')),
        );
      },
    );
  }

  Widget _buildServerKpiCards(Map<String, dynamic> kpiData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Server-Computed KPI Summary',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            _buildKpiCard(
              'Jobs Created',
              '${kpiData['jobsCreated'] ?? 0}',
              Icons.work,
            ),
            _buildKpiCard(
              'Requests Created',
              '${kpiData['leadsCreated'] ?? 0}',
              Icons.star,
            ),
            _buildKpiCard(
              'Requests Accepted',
              '${kpiData['leadsAccepted'] ?? 0}',
              Icons.check_circle,
            ),
            _buildKpiCard(
              'Revenue',
              '€${(kpiData['paymentsCapturedEur'] ?? 0.0).toStringAsFixed(2)}',
              Icons.euro,
            ),
            _buildKpiCard(
              'New Users',
              '${kpiData['newUsers'] ?? 0}',
              Icons.person_add,
            ),
            _buildKpiCard(
              'Push Open Rate',
              '${(kpiData['pushOpenRate'] ?? 0.0).toStringAsFixed(1)}%',
              Icons.notifications,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdvancedMetricsSection(Map<String, dynamic> metricsData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Advanced Analytics',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildMetricRow(
                  'Request Conversion Rate',
                  '${(metricsData['leadConversionRate'] ?? 0.0).toStringAsFixed(1)}%',
                ),
                const Divider(),
                _buildMetricRow(
                  'Average Job Value',
                  '€${(metricsData['avgJobValue'] ?? 0.0).toStringAsFixed(2)}',
                ),
                const Divider(),
                _buildMetricRow(
                  'Dispute Rate',
                  '${(metricsData['disputeRate'] ?? 0.0).toStringAsFixed(1)}%',
                ),
                const Divider(),
                _buildMetricRow(
                  'User Retention Rate',
                  '${(metricsData['userRetentionRate'] ?? 0.0).toStringAsFixed(1)}%',
                ),
                const Divider(),
                _buildMetricRow(
                  'Revenue Growth Rate',
                  '${(metricsData['revenueGrowthRate'] ?? 0.0).toStringAsFixed(1)}%',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKpiCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: Colors.blue),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _EventsTab extends StatelessWidget {
  final DateTimeRange? dateRange;

  const _EventsTab({required this.dateRange});

  @override
  Widget build(BuildContext context) {
    if (dateRange == null) {
      return Center(child: Text('analytics.admin.selectDateRange'.tr()));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: _getEventsStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return Center(child: Text('analytics.admin.noEvents'.tr()));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            final event = doc.data() as Map<String, dynamic>;
            return _EventCard(event: event);
          },
        );
      },
    );
  }

  Stream<QuerySnapshot> _getEventsStream() {
    final startTimestamp = Timestamp.fromDate(dateRange!.start);
    final endTimestamp = Timestamp.fromDate(
      dateRange!.end.add(const Duration(days: 1)),
    );

    return FirebaseFirestore.instance
        .collection('analyticsEvents')
        .where('ts', isGreaterThanOrEqualTo: startTimestamp)
        .where('ts', isLessThan: endTimestamp)
        .orderBy('ts', descending: true)
        .limit(100) // Limit for performance
        .snapshots();
  }
}

class _EventCard extends StatelessWidget {
  final Map<String, dynamic> event;

  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final timestamp = (event['ts'] as Timestamp?)?.toDate();
    final name = event['name'] as String? ?? 'Unknown';
    final source = event['src'] as String? ?? 'Unknown';
    final userId = event['uid'] as String? ?? 'Anonymous';
    final role = event['role'] as String? ?? 'Unknown';
    final props = event['props'] as Map<String, dynamic>? ?? {};

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        title: Text(name),
        subtitle: Text('$source • ${_formatTimestamp(timestamp)}'),
        trailing: Chip(
          label: Text(role),
          backgroundColor: _getRoleColor(role),
          labelStyle: const TextStyle(fontSize: 12, color: Colors.white),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _EventDetail('User ID', userId),
                _EventDetail('Source', source),
                _EventDetail('Timestamp', _formatTimestamp(timestamp)),
                if (props.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Properties:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  ...props.entries.map(
                    (entry) => _EventDetail(
                      entry.key,
                      entry.value?.toString() ?? 'null',
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime? timestamp) {
    if (timestamp == null) return 'Unknown';
    return DateFormat('dd.MM.yyyy HH:mm:ss').format(timestamp);
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin':
        return Colors.red;
      case 'pro':
        return Colors.blue;
      case 'customer':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

class _EventDetail extends StatelessWidget {
  final String label;
  final String value;

  const _EventDetail(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: Colors.grey[700])),
          ),
        ],
      ),
    );
  }
}

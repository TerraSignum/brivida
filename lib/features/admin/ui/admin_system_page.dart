import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../legal/logic/legal_controller.dart';
import '../logic/admin_controller.dart';
import '../../../core/utils/navigation_helpers.dart';

class AdminSystemPage extends ConsumerStatefulWidget {
  const AdminSystemPage({super.key});

  @override
  ConsumerState<AdminSystemPage> createState() => _AdminSystemPageState();
}

class _AdminSystemPageState extends ConsumerState<AdminSystemPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          title: const Text('System Configuration'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 1,
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Legal Versions', icon: Icon(Icons.gavel)),
              Tab(text: 'System Health', icon: Icon(Icons.health_and_safety)),
              Tab(text: 'Configuration', icon: Icon(Icons.settings)),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildLegalVersionsTab(),
            _buildSystemHealthTab(),
            _buildConfigurationTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildLegalVersionsTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Legal Document Version Management',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Legal Versions',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Consumer(
                    builder: (context, ref, child) {
                      final language = ref.watch(currentLanguageProvider);
                      final versionsAsync = ref.watch(
                        latestLegalVersionsProvider(language),
                      );

                      return versionsAsync.when(
                        data: (versions) => Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.description),
                              title: const Text('Terms of Service'),
                              subtitle: Text(
                                'Version ${versions['tos'] ?? 'N/A'}',
                              ),
                              trailing: const Icon(Icons.info_outline),
                            ),
                            ListTile(
                              leading: const Icon(Icons.privacy_tip),
                              title: const Text('Privacy Policy'),
                              subtitle: Text(
                                'Version ${versions['privacy'] ?? 'N/A'}',
                              ),
                              trailing: const Icon(Icons.info_outline),
                            ),
                          ],
                        ),
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, stack) => Text('Error: $error'),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _showUpdateVersionDialog();
                    },
                    child: const Text('Update Legal Versions'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemHealthTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'System Health Dashboard',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildHealthCard(
                  'Firebase Functions',
                  Icons.functions,
                  Colors.green,
                  'Operational',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildHealthCard(
                  'Firestore Database',
                  Icons.storage,
                  Colors.green,
                  'Operational',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildHealthCard(
                  'Stripe Payments',
                  Icons.payment,
                  Colors.green,
                  'Operational',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildHealthCard(
                  'ETA Service',
                  Icons.location_on,
                  Colors.green,
                  'Operational',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConfigurationTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Platform Configuration',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.schedule),
                  title: const Text('Scheduled Functions'),
                  subtitle: const Text('Manage automated tasks'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Scheduled functions management coming soon',
                        ),
                      ),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Push Notifications'),
                  subtitle: const Text('Configure notification settings'),
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {
                      // Toggle notifications
                    },
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.security),
                  title: const Text('Security Settings'),
                  subtitle: const Text('Admin access and permissions'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Security settings coming soon'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthCard(
    String title,
    IconData icon,
    Color color,
    String status,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(status, style: TextStyle(color: color, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  void _showUpdateVersionDialog() {
    final termsController = TextEditingController();
    final privacyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Legal Versions'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: termsController,
              decoration: const InputDecoration(
                labelText: 'New Terms Version',
                hintText: '1.0.1',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: privacyController,
              decoration: const InputDecoration(
                labelText: 'New Privacy Version',
                hintText: '1.0.1',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final termsVersion = termsController.text.trim();
              final privacyVersion = privacyController.text.trim();

              if (termsVersion.isNotEmpty || privacyVersion.isNotEmpty) {
                try {
                  await ref
                      .read(adminControllerProvider.notifier)
                      .updateLegalVersions(
                        termsVersion: termsVersion.isNotEmpty
                            ? termsVersion
                            : null,
                        privacyVersion: privacyVersion.isNotEmpty
                            ? privacyVersion
                            : null,
                      );

                  if (!context.mounted) {
                    return;
                  }

                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Legal versions updated successfully'),
                    ),
                  );

                  // Refresh legal versions
                  ref.invalidate(latestLegalVersionsProvider);
                } catch (e) {
                  if (!context.mounted) {
                    return;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error updating versions: $e')),
                  );
                }
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}

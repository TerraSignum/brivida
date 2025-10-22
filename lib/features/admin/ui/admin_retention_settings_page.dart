import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/admin_repo.dart';
import '../logic/admin_controller.dart';
import '../../../core/utils/navigation_helpers.dart';

// Provider for retention configuration
final retentionConfigProvider = FutureProvider<Map<String, dynamic>?>((
  ref,
) async {
  final adminRepo = ref.read(adminRepoProvider);
  return await adminRepo.getRetentionConfig();
});

// Provider for updating retention configuration
final retentionConfigControllerProvider =
    StateNotifierProvider<
      RetentionConfigController,
      AsyncValue<Map<String, dynamic>?>
    >((ref) {
      return RetentionConfigController(ref.read(adminRepoProvider));
    });

class RetentionConfigController
    extends StateNotifier<AsyncValue<Map<String, dynamic>?>> {
  final AdminRepository _adminRepo;

  RetentionConfigController(this._adminRepo)
    : super(const AsyncValue.loading()) {
    loadConfig();
  }

  Future<void> loadConfig() async {
    try {
      state = const AsyncValue.loading();
      final config = await _adminRepo.getRetentionConfig();
      state = AsyncValue.data(config);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateConfig({
    required int jobsPrivateRetentionMonths,
    required int chatRetentionMonths,
    required int disputeRetentionMonths,
  }) async {
    try {
      state = const AsyncValue.loading();

      await _adminRepo.updateRetentionConfig(
        jobsPrivateRetentionMonths: jobsPrivateRetentionMonths,
        chatRetentionMonths: chatRetentionMonths,
        disputeRetentionMonths: disputeRetentionMonths,
      );

      final updatedConfig = await _adminRepo.getRetentionConfig();
      state = AsyncValue.data(updatedConfig);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> triggerDataRetention() async {
    try {
      await _adminRepo.triggerDataRetention();
    } catch (error) {
      throw Exception('Failed to trigger data retention: $error');
    }
  }
}

class AdminRetentionSettingsPage extends ConsumerStatefulWidget {
  const AdminRetentionSettingsPage({super.key});

  @override
  ConsumerState<AdminRetentionSettingsPage> createState() =>
      _AdminRetentionSettingsPageState();
}

class _AdminRetentionSettingsPageState
    extends ConsumerState<AdminRetentionSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _jobsPrivateController;
  late TextEditingController _chatController;
  late TextEditingController _disputeController;

  @override
  void initState() {
    super.initState();
    _jobsPrivateController = TextEditingController();
    _chatController = TextEditingController();
    _disputeController = TextEditingController();
  }

  @override
  void dispose() {
    _jobsPrivateController.dispose();
    _chatController.dispose();
    _disputeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final configState = ref.watch(retentionConfigControllerProvider);

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
          title: const Text('Data Retention Settings'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: configState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error loading configuration: $error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(retentionConfigControllerProvider.notifier)
                        .loadConfig();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          data: (config) => _buildConfigForm(context, config),
        ),
      ),
    );
  }

  Widget _buildConfigForm(BuildContext context, Map<String, dynamic>? config) {
    // Set default values or load from config
    if (config != null && _jobsPrivateController.text.isEmpty) {
      _jobsPrivateController.text = (config['jobsPrivateRetentionMonths'] ?? 12)
          .toString();
      _chatController.text = (config['chatRetentionMonths'] ?? 24).toString();
      _disputeController.text = (config['disputeRetentionMonths'] ?? 36)
          .toString();
    } else if (config == null && _jobsPrivateController.text.isEmpty) {
      // Set defaults for new configuration
      _jobsPrivateController.text = '12';
      _chatController.text = '24';
      _disputeController.text = '36';
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.security,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'GDPR Data Retention Policy',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Configure how long different types of personal data are retained before automatic deletion/anonymization.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Jobs Private Data Retention
            _buildRetentionField(
              controller: _jobsPrivateController,
              title: 'Jobs Private Data (Addresses)',
              subtitle:
                  'Private location data including exact addresses and entrance notes',
              icon: Icons.location_on,
              helpText:
                  'This includes private addresses, coordinates, and entrance instructions. Legal minimum: 6 months for billing, recommended: 12 months.',
            ),

            const SizedBox(height: 16),

            // Chat Messages Retention
            _buildRetentionField(
              controller: _chatController,
              title: 'Chat Messages',
              subtitle: 'Messages between customers and professionals',
              icon: Icons.chat,
              helpText:
                  'Chat history for completed jobs. Legal minimum: 12 months for dispute resolution, recommended: 24 months.',
            ),

            const SizedBox(height: 16),

            // Dispute Data Retention
            _buildRetentionField(
              controller: _disputeController,
              title: 'Dispute Records',
              subtitle: 'Closed dispute cases and evidence',
              icon: Icons.gavel,
              helpText:
                  'Resolved dispute cases with evidence. Legal minimum: 24 months for appeals, recommended: 36 months.',
            ),

            const SizedBox(height: 32),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _saveConfiguration(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Save Configuration'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _triggerManualCleanup(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Run Cleanup Now'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Status Information
            if (config != null) _buildStatusInfo(config),
          ],
        ),
      ),
    );
  }

  Widget _buildRetentionField({
    required TextEditingController controller,
    required String title,
    required String subtitle,
    required IconData icon,
    required String helpText,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Retention Period (months)',
                border: OutlineInputBorder(),
                suffixText: 'months',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a retention period';
                }
                final int? months = int.tryParse(value);
                if (months == null || months < 1) {
                  return 'Please enter a valid number of months (minimum 1)';
                }
                if (months > 120) {
                  return 'Maximum retention period is 120 months (10 years)';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            Text(
              helpText,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusInfo(Map<String, dynamic> config) {
    final updatedAt = config['updatedAt'] as DateTime?;
    final updatedBy = config['updatedBy'] as String?;

    return Card(
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.info, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Configuration Status',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (updatedAt != null) ...[
              Text('Last updated: ${_formatDate(updatedAt)}'),
              if (updatedBy != null) Text('Updated by: $updatedBy'),
            ] else
              const Text('Using default configuration'),
            const SizedBox(height: 8),
            const Text(
              'The automatic cleanup runs daily at 2 AM UTC. Data older than the configured retention periods will be permanently deleted or anonymized.',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _saveConfiguration() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final jobsPrivate = int.parse(_jobsPrivateController.text);
      final chat = int.parse(_chatController.text);
      final dispute = int.parse(_disputeController.text);

      await ref
          .read(retentionConfigControllerProvider.notifier)
          .updateConfig(
            jobsPrivateRetentionMonths: jobsPrivate,
            chatRetentionMonths: chat,
            disputeRetentionMonths: dispute,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Retention configuration saved successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save configuration: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _triggerManualCleanup() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Manual Data Cleanup'),
        content: const Text(
          'This will immediately delete/anonymize all personal data older than the configured retention periods. This action cannot be undone.\n\nAre you sure you want to proceed?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Run Cleanup'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref
          .read(retentionConfigControllerProvider.notifier)
          .triggerDataRetention();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data retention cleanup completed successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to trigger cleanup: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

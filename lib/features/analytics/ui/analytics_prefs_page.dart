import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/analytics_repo.dart';
import 'package:easy_localization/easy_localization.dart';

/// Provider for analytics repository
final analyticsRepositoryProvider = Provider<AnalyticsRepository>((ref) {
  return AnalyticsRepository();
});

/// Provider for analytics opt-out state
final analyticsOptOutProvider =
    StateNotifierProvider<AnalyticsOptOutNotifier, AsyncValue<bool>>((ref) {
  final repo = ref.watch(analyticsRepositoryProvider);
  return AnalyticsOptOutNotifier(repo);
});

class AnalyticsOptOutNotifier extends StateNotifier<AsyncValue<bool>> {
  final AnalyticsRepository _repo;

  AnalyticsOptOutNotifier(this._repo) : super(const AsyncValue.loading()) {
    _loadOptOutState();
  }

  Future<void> _loadOptOutState() async {
    try {
      final optOut = await _repo.getAnalyticsOptOut();
      state = AsyncValue.data(optOut);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> setOptOut(bool optOut) async {
    try {
      state = const AsyncValue.loading();
      await _repo.setAnalyticsOptOut(optOut);
      state = AsyncValue.data(optOut);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

/// Analytics preferences page for GDPR compliance
class AnalyticsPrefsPage extends ConsumerWidget {
  const AnalyticsPrefsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optOutState = ref.watch(analyticsOptOutProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('settings.analytics.title'.tr()),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.analytics_outlined,
                          color: Theme.of(context).primaryColor,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'settings.analytics.title'.tr(),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'settings.analytics.description'.tr(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Analytics Toggle
            Card(
              child: optOutState.when(
                data: (isOptedOut) => SwitchListTile(
                  value: !isOptedOut, // Switch shows "analytics enabled" state
                  onChanged: (enabled) {
                    ref
                        .read(analyticsOptOutProvider.notifier)
                        .setOptOut(!enabled);
                  },
                  title: Text(
                    'settings.analytics.allow'.tr(),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    !isOptedOut
                        ? 'settings.analytics.status_enabled'.tr()
                        : 'settings.analytics.status_disabled'.tr(),
                    style: TextStyle(
                      color: !isOptedOut ? Colors.green[600] : Colors.grey[600],
                    ),
                  ),
                  secondary: Icon(
                    !isOptedOut ? Icons.analytics : Icons.analytics_outlined,
                    color: !isOptedOut ? Colors.green[600] : Colors.grey[400],
                  ),
                ),
                loading: () => const ListTile(
                  leading: CircularProgressIndicator(),
                  title: Text('Loading...'),
                ),
                error: (error, stackTrace) => ListTile(
                  leading: const Icon(Icons.error, color: Colors.red),
                  title: const Text('Error loading preferences'),
                  subtitle: Text(error.toString()),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Information Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'settings.analytics.info_title'.tr(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    _buildInfoItem(
                      context,
                      Icons.check_circle_outline,
                      'settings.analytics.info_usage'.tr(),
                      Colors.green[600]!,
                    ),
                    _buildInfoItem(
                      context,
                      Icons.security_outlined,
                      'settings.analytics.info_privacy'.tr(),
                      Colors.blue[600]!,
                    ),
                    _buildInfoItem(
                      context,
                      Icons.trending_up_outlined,
                      'settings.analytics.info_improvement'.tr(),
                      Colors.orange[600]!,
                    ),
                    _buildInfoItem(
                      context,
                      Icons.block_outlined,
                      'settings.analytics.info_no_personal'.tr(),
                      Colors.purple[600]!,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Legal Links
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined),
                    title: Text('settings.analytics.privacy_policy'.tr()),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _openPrivacyPolicy(context),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.description_outlined),
                    title: Text('settings.analytics.terms_service'.tr()),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _openTermsOfService(context),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Footer Note
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'settings.analytics.footer_note'.tr(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
      BuildContext context, IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  void _openPrivacyPolicy(BuildContext context) {
    // Navigate to privacy policy - using existing legal routes
    Navigator.of(context).pushNamed('/legal/privacy');
  }

  void _openTermsOfService(BuildContext context) {
    // Navigate to terms of service - using existing legal routes
    Navigator.of(context).pushNamed('/legal/terms');
  }
}

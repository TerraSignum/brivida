import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brivida_app/features/notifications/logic/notifications_controller.dart';

/// Page for managing notification preferences
class NotificationPreferencesPage extends ConsumerWidget {
  const NotificationPreferencesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferencesAsync = ref.watch(preferencesControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Benachrichtigungs-Einstellungen'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: preferencesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Fehler beim Laden: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(preferencesControllerProvider);
                },
                child: const Text('Erneut versuchen'),
              ),
            ],
          ),
        ),
        data: (preferences) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.notifications),
                          const SizedBox(width: 12),
                          Text(
                            'Push-Benachrichtigungen',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Verwalten Sie, welche Benachrichtigungen Sie erhalten möchten',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Test notification button
              Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      await ref
                          .read(notificationsControllerProvider.notifier)
                          .createTestNotification();

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Test-Benachrichtigung gesendet'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Fehler: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  icon: const Icon(Icons.send),
                  label: const Text('Test-Benachrichtigung senden'),
                ),
              ),

              const SizedBox(height: 24),

              // Individual preferences placeholder
              const Text('Weitere Einstellungen werden hier angezeigt...'),
            ],
          ),
        ),
      ),
    );
  }
}

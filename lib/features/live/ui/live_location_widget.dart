// PG-16: Live Location Widget for job detail page
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/models/job.dart';
import '../../../core/models/live_location.dart';
import '../logic/live_share_controller.dart';

class LiveLocationWidget extends ConsumerWidget {
  final Job job;

  const LiveLocationWidget({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;

    // Only show for assigned pros during active jobs
    if (user == null ||
        job.assignedProUid != user.uid ||
        job.id == null ||
        !['assigned', 'in_progress'].contains(job.status.name)) {
      return const SizedBox.shrink();
    }

    final liveShareState = ref.watch(liveShareControllerProvider(job.id!));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.my_location, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Live Location Sharing',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Share your real-time location with the customer during the job',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 16),

            // Main sharing toggle
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: liveShareState.isSharing
                        ? () => _stopSharing(ref, job.id!)
                        : () => _startSharing(ref, job.id!),
                    icon: Icon(
                      liveShareState.isSharing ? Icons.stop : Icons.play_arrow,
                      color: Colors.white,
                    ),
                    label: Text(
                      liveShareState.isSharing
                          ? 'Stop Sharing'
                          : 'Start Sharing',
                      style: const TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          liveShareState.isSharing ? Colors.red : Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                if (liveShareState.isSharing) ...[
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => _pauseSharing(ref, job.id!),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                    ),
                    child: const Icon(Icons.pause, color: Colors.white),
                  ),
                ],
              ],
            ),

            // Status information
            if (liveShareState.isSharing ||
                liveShareState.lastLocation != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: liveShareState.isSharing
                      ? Colors.green[50]
                      : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: liveShareState.isSharing
                        ? Colors.green[200]!
                        : Colors.grey[300]!,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          liveShareState.isSharing
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          size: 16,
                          color: liveShareState.isSharing
                              ? Colors.green
                              : Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          liveShareState.isSharing
                              ? 'Sharing active'
                              : 'Sharing stopped',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: liveShareState.isSharing
                                ? Colors.green[700]
                                : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    if (liveShareState.lastLocation != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Last update: ${liveShareState.lastLocation!.lastUpdatedText}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      if (liveShareState.lastLocation!.accuracy != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          liveShareState.lastLocation!.accuracyText,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: liveShareState
                                            .lastLocation!.hasAccurateReading
                                        ? Colors.green[600]
                                        : Colors.orange[600],
                                  ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ],

            // Error display
            if (liveShareState.error != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error, size: 16, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        liveShareState.error!,
                        style: TextStyle(
                          color: Colors.red[700],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Permission warning
            if (!liveShareState.hasPermission && !liveShareState.isSharing) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, size: 16, color: Colors.orange),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Location permission required for live sharing',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Privacy note
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  const Icon(Icons.privacy_tip, size: 14, color: Colors.blue),
                  const SizedBox(width: 6),
                  const Expanded(
                    child: Text(
                      'Your location is only shared with this customer during active jobs. No location history is stored.',
                      style: TextStyle(fontSize: 11, color: Colors.blue),
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

  void _startSharing(WidgetRef ref, String jobId) async {
    final controller = ref.read(liveShareControllerProvider(jobId).notifier);
    await controller.startSharing(jobId);
  }

  void _stopSharing(WidgetRef ref, String jobId) async {
    final controller = ref.read(liveShareControllerProvider(jobId).notifier);
    await controller.stopSharing();
  }

  void _pauseSharing(WidgetRef ref, String jobId) async {
    final controller = ref.read(liveShareControllerProvider(jobId).notifier);
    await controller.pauseSharing();
  }
}

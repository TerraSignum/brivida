import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../logic/jobs_controller.dart';
import '../data/jobs_repo.dart';
import '../../../core/models/job.dart';
import '../../live/ui/live_location_widget.dart';
import '../../live/ui/customer_live_map.dart';
import 'job_comfort_widget.dart';
import 'job_completion_page.dart';
import '../../../core/utils/navigation_helpers.dart';
import '../../../core/providers/user_role_provider.dart';
import '../../tutorial/logic/tutorial_registry.dart';
import '../../tutorial/ui/tutorial_trigger.dart';

// PG-14: State for ETA calculation
final etaStateProvider =
    StateProvider.family<AsyncValue<Map<String, dynamic>?>, String>((
      ref,
      jobId,
    ) {
      return const AsyncValue.data(null);
    });

class JobDetailPage extends ConsumerWidget {
  final String jobId;

  const JobDetailPage({super.key, required this.jobId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobAsync = ref.watch(jobProvider(jobId));

    final scaffold = Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => popOrGoHome(context, homeRoute: '/jobs'),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text('job.detail.title'.tr()),
        elevation: 0,
      ),
      body: jobAsync.when(
        data: (job) {
          if (job == null) {
            return Center(child: Text('job.detail.notFound'.tr()));
          }

          final bottomInset = MediaQuery.of(context).viewPadding.bottom;
          final completionAction = _buildCompletionAction(context, ref, job);

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'job.detail.overview'.tr(),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${'job.detail.size'.tr()}: ${job.sizeM2.toInt()}m²',
                        ),
                        Text('${'job.detail.rooms'.tr()}: ${job.rooms}'),
                        Text(
                          '${'job.detail.budget'.tr()}: €${job.budget.toStringAsFixed(2)}',
                        ),
                        Text('${'job.detail.status'.tr()}: ${job.status.name}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'job.detail.services'.tr(),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: job.services.map((service) {
                            return Chip(label: Text(service));
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                // PG-14: Maps & Location Section
                const SizedBox(height: 16),
                _buildLocationSection(context, job, ref),

                // PG-16: Live Location Sharing Section (for pros)
                const SizedBox(height: 16),
                LiveLocationWidget(job: job),

                // PG-16: Customer Live Map Section (for customers)
                const SizedBox(height: 16),
                CustomerLiveMapWidget(job: job),

                // PG-16.1: Job Comfort Features
                const SizedBox(height: 16),
                JobComfortWidget(
                  job: job,
                  isProView: _isCurrentUserAssignedPro(job),
                ),
                if (completionAction != null) ...[
                  const SizedBox(height: 16),
                  completionAction,
                ],
                if (job.notes.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'job.detail.notes'.tr(),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          Text(job.notes),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text('${'job.detail.error'.tr()}: $error')),
      ),
    );

    return TutorialTrigger(screen: TutorialScreen.jobDetail, child: scaffold);
  }

  // PG-14: Build location and maps section
  Widget _buildLocationSection(BuildContext context, Job job, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    final isAdmin = ref
        .watch(isAdminRoleProvider)
        .maybeWhen(data: (value) => value, orElse: () => false);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'job.map.location'.tr(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // Public address information (always visible)
            if (job.addressCity?.isNotEmpty == true) ...[
              Row(
                children: [
                  const Icon(Icons.location_city, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    '${job.addressCity}${job.addressDistrict?.isNotEmpty == true ? ', ${job.addressDistrict}' : ''}',
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],

            if (job.addressHint?.isNotEmpty == true) ...[
              Row(
                children: [
                  const Icon(Icons.info_outline, size: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text(job.addressHint!)),
                ],
              ),
              const SizedBox(height: 8),
            ],

            // Private location data (only for authorized users)
            if (user != null &&
                job.id != null &&
                (user.uid == job.customerUid ||
                    job.assignedProUid == user.uid ||
                    isAdmin)) ...[
              _buildPrivateLocationSection(context, job, ref),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lock, size: 16),
                    const SizedBox(width: 8),
                    Text('job.map.addressHidden'.tr()),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget? _buildCompletionAction(BuildContext context, WidgetRef ref, Job job) {
    if (job.id == null) {
      return null;
    }

    final user = FirebaseAuth.instance.currentUser;
    final isAdmin = ref
        .watch(isAdminRoleProvider)
        .maybeWhen(data: (value) => value, orElse: () => false);

    final isCustomer = user != null && user.uid == job.customerUid;
    final isPro = user != null && job.assignedProUid == user.uid;

    if (!isCustomer && !isPro && !isAdmin) {
      return null;
    }

    final subtitle = isPro
        ? 'jobCompletion.pro.shortDescription'.tr()
        : 'jobCompletion.customer.shortDescription'.tr();

    return Card(
      child: ListTile(
        leading: const Icon(Icons.assignment_turned_in_outlined),
        title: Text('jobCompletion.title'.tr()),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => context.push(JobCompletionPage.route(job.id!)),
      ),
    );
  }

  // PG-14: Build private location section with maps and navigation
  Widget _buildPrivateLocationSection(
    BuildContext context,
    Job job,
    WidgetRef ref,
  ) {
    if (job.id == null) return const SizedBox.shrink();

    final jobPrivateAsync = ref.watch(jobPrivateProvider(job.id!));
    final etaState = ref.watch(etaStateProvider(job.id!));

    return jobPrivateAsync.when(
      data: (jobPrivate) {
        if (jobPrivate == null) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            const SizedBox(height: 8),

            // Full address display
            if (jobPrivate.addressFormatted.isNotEmpty) ...[
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text(jobPrivate.addressFormatted)),
                  IconButton(
                    tooltip: 'job.map.copyAddress'.tr(),
                    icon: const Icon(Icons.copy, size: 16),
                    onPressed: () async {
                      await Clipboard.setData(
                        ClipboardData(text: jobPrivate.addressFormatted),
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('job.map.addressCopied'.tr())),
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],

            // Entrance notes
            if (jobPrivate.entranceNotes?.isNotEmpty == true) ...[
              Row(
                children: [
                  const Icon(Icons.door_front_door, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      jobPrivate.entranceNotes!,
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],

            // Google Maps view
            const SizedBox(height: 8),
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      jobPrivate.location.lat,
                      jobPrivate.location.lng,
                    ),
                    zoom: 16,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId('job_location'),
                      position: LatLng(
                        jobPrivate.location.lat,
                        jobPrivate.location.lng,
                      ),
                      infoWindow: InfoWindow(
                        title: 'job.map.jobLocation'.tr(),
                        snippet: jobPrivate.addressFormatted,
                      ),
                    ),
                  },
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Navigation and ETA row
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _openInGoogleMaps(
                      jobPrivate.location.lat,
                      jobPrivate.location.lng,
                    ),
                    icon: const Icon(Icons.directions),
                    label: Text('job.map.navigate'.tr()),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _calculateEta(context, job.id!, ref),
                    icon: const Icon(Icons.schedule),
                    label: Text('job.map.calculateEta'.tr()),
                  ),
                ),
              ],
            ),

            // ETA display
            etaState.when(
              data: (eta) {
                if (eta == null) return const SizedBox.shrink();
                return Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${'job.map.eta'.tr()}: ${eta['duration']} (${eta['distance']})',
                        style: TextStyle(color: Colors.blue[700]),
                      ),
                    ],
                  ),
                );
              },
              loading: () => Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(width: 8),
                    Text('job.map.calculatingEta'.tr()),
                  ],
                ),
              ),
              error: (error, stack) => Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error, size: 16, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'job.map.etaError'.tr(),
                        style: TextStyle(color: Colors.red[700]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error loading location: $error'),
    );
  }

  // PG-14: Open location in Google Maps for navigation
  void _openInGoogleMaps(double latitude, double longitude) async {
    final url =
        'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  // PG-14: Calculate ETA using Cloud Function
  void _calculateEta(BuildContext context, String jobId, WidgetRef ref) async {
    final repo = ref.read(jobsRepoProvider);
    final etaNotifier = ref.read(etaStateProvider(jobId).notifier);

    etaNotifier.state = const AsyncValue.loading();

    try {
      final eta = await repo.getEta(jobId);
      etaNotifier.state = AsyncValue.data(eta);
    } catch (error) {
      etaNotifier.state = AsyncValue.error(error, StackTrace.current);
    }
  }

  // Helper method to check if current user is the assigned pro
  bool _isCurrentUserAssignedPro(Job job) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return currentUser != null &&
        job.assignedProUid != null &&
        currentUser.uid == job.assignedProUid;
  }
}

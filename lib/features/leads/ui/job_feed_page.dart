import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../core/models/job.dart';
import '../../jobs/logic/jobs_controller.dart';
import '../logic/leads_controller.dart';
import '../../../core/utils/navigation_helpers.dart';
import '../../tutorial/logic/tutorial_registry.dart';
import '../../tutorial/ui/tutorial_trigger.dart';

final _jobApplicationLoadingProvider = StateProvider.autoDispose
    .family<bool, String>((ref, jobId) => false);

class JobFeedPage extends ConsumerWidget {
  const JobFeedPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final openJobsAsync = ref.watch(openJobsProvider);

    final scaffold = Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => popOrGoHome(context, homeRoute: '/jobs'),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text('leads.feedTitle'.tr()),
        elevation: 0,
      ),
      body: openJobsAsync.when(
        data: (jobs) {
          if (jobs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.work_outline,
                    size: 64,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'leads.noJobs'.tr(),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'leads.noJobsSubtitle'.tr(),
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final bottomInset = MediaQuery.of(context).viewPadding.bottom;

          return ListView.builder(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset),
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
              return _JobCard(key: ValueKey(job.id ?? 'job_$index'), job: job);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'leads.errorLoadingJobs'.tr(),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );

    return TutorialTrigger(screen: TutorialScreen.jobFeed, child: scaffold);
  }
}

class _JobCard extends ConsumerWidget {
  const _JobCard({required this.job, super.key});

  final Job job;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobId = job.id ?? '__pending_${job.hashCode}';
    final isLoading = ref.watch(_jobApplicationLoadingProvider(jobId));
    final servicesToDisplay = {
      ...job.services,
      ...job.extraServices,
      if (job.materialProvidedByPro) 'materials_provided',
      if (job.isExpress) 'express_priority',
    }.toList();

    Future<void> applyForJob(String message) async {
      final trimmedMessage = message.trim();
      final currentJobId = job.id;
      if (currentJobId == null) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('leads.applicationError'.tr())));
        return;
      }

      ref.read(_jobApplicationLoadingProvider(jobId).notifier).state = true;

      try {
        final controller = ref.read(leadsControllerProvider);
        await controller.createLead(
          jobId: currentJobId,
          customerUid: job.customerUid,
          message: trimmedMessage,
        );

        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('leads.applicationSent'.tr())));
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${'leads.applicationError'.tr()}: $e')),
          );
        }
      } finally {
        if (ref.exists(_jobApplicationLoadingProvider(jobId))) {
          ref.read(_jobApplicationLoadingProvider(jobId).notifier).state =
              false;
        }
      }
    }

    Future<void> showApplicationDialog() async {
      final messageController = TextEditingController();

      final result = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text('leads.applicationTitle'.tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'leads.applicationMessage'.tr(),
                style: Theme.of(dialogContext).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: messageController,
                decoration: InputDecoration(
                  labelText: 'leads.applicationMessageLabel'.tr(),
                  hintText: 'leads.applicationHint'.tr(),
                ),
                maxLines: 3,
                maxLength: 300,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text('leads.cancel'.tr()),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text('leads.sendApplication'.tr()),
            ),
          ],
        ),
      );

      if (result == true) {
        await applyForJob(messageController.text);
      }

      messageController.dispose();
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${job.sizeM2.toInt()}m² • ${job.rooms} ${'leads.rooms'.tr()}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '€${job.budget.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'leads.statusOpen'.tr(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            if (servicesToDisplay.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: servicesToDisplay.take(3).map((service) {
                  return Chip(
                    label: Text(
                      _getServiceName(context, service),
                      style: const TextStyle(fontSize: 12),
                    ),
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
              if (servicesToDisplay.length > 3)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    '+${servicesToDisplay.length - 3} ${'leads.moreServices'.tr()}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
            ],
            if ((job.addressCity?.isNotEmpty ?? false) ||
                (job.addressDistrict?.isNotEmpty ?? false) ||
                (job.addressHint?.isNotEmpty ?? false)) ...[
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.place,
                    size: 16,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'job.map.title'.tr(),
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        if ((job.addressCity?.isNotEmpty ?? false) ||
                            (job.addressDistrict?.isNotEmpty ?? false))
                          Text(
                            [
                              if (job.addressCity?.isNotEmpty ?? false)
                                job.addressCity!,
                              if (job.addressDistrict?.isNotEmpty ?? false)
                                job.addressDistrict!,
                            ].join(' · '),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        if (job.addressHint?.isNotEmpty ?? false)
                          Text(
                            job.addressHint!,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 16,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(width: 4),
                Text(
                  _formatDate(job.window.start),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: Theme.of(context).colorScheme.outline,
                ),
                const SizedBox(width: 4),
                Text(
                  _formatTimeRange(job.window.start, job.window.end),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            if (job.notes.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'leads.notes'.tr(),
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(_localizeJobNote(context, job.notes)),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: job.id == null || isLoading
                    ? null
                    : showApplicationDialog,
                icon: isLoading
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send),
                label: Text(
                  isLoading ? 'leads.applying'.tr() : 'leads.applyForJob'.tr(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _getServiceName(BuildContext context, String service) {
    switch (service) {
      case 'house_cleaning':
      case 'general_cleaning':
        return 'jobs.serviceGeneralCleaning'.tr();
      case 'deep_cleaning':
        return 'jobs.serviceDeepCleaning'.tr();
      case 'window_cleaning':
        return 'jobs.serviceWindowCleaning'.tr();
      case 'carpet_cleaning':
        return 'jobs.serviceCarpetCleaning'.tr();
      case 'kitchen_cleaning':
        return 'jobs.serviceKitchenCleaning'.tr();
      case 'bathroom_cleaning':
        return 'jobs.serviceBathroomCleaning'.tr();
      case 'ironing':
        return 'jobs.serviceIroning'.tr();
      case 'organization':
        return 'jobs.serviceOrganization'.tr();
      case 'windows_inside':
        return 'jobForm.extraWindowsInside'.tr();
      case 'windows_in_out':
        return 'jobForm.extraWindowsInOut'.tr();
      case 'kitchen_deep':
        return 'jobForm.extraKitchenDeep'.tr();
      case 'bathroom_deep':
        return 'jobForm.extraBathroomDeep'.tr();
      case 'laundry':
        return 'jobForm.extraLaundry'.tr();
      case 'ironing_light':
        return 'jobForm.extraIroningLight'.tr();
      case 'ironing_full':
        return 'jobForm.extraIroningFull'.tr();
      case 'balcony':
        return 'jobForm.extraBalcony'.tr();
      case 'organization_plus':
        return 'jobForm.extraOrganization'.tr();
      case 'materials_provided':
        return 'jobForm.optionMaterialsProvided'.tr();
      case 'express_priority':
        return 'jobForm.optionExpress'.tr();
      default:
        return service;
    }
  }

  static const Set<String> _knownFullAddressLabels = {
    'Vollständige Adresse',
    'Full Address',
    'Dirección Completa',
    'Adresse complète',
    'Endereço Completo',
  };

  static String _localizeJobNote(BuildContext context, String note) {
    final trimmed = note.trim();
    final colonIndex = trimmed.indexOf(':');
    if (colonIndex <= 0) {
      return note;
    }

    final label = trimmed.substring(0, colonIndex).trim();
    if (!_knownFullAddressLabels.contains(label)) {
      return note;
    }

    final value = trimmed.substring(colonIndex + 1).trim();
    final localizedLabel = 'jobForm.address'.tr();
    if (value.isEmpty) {
      return localizedLabel;
    }
    return '$localizedLabel: $value';
  }

  static String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  static String _formatTimeRange(DateTime start, DateTime end) {
    final startTime =
        '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}';
    final endTime =
        '${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
    return '$startTime - $endTime';
  }
}

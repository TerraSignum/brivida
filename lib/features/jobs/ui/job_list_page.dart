import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/i18n/app_localizations.dart';
import '../../../core/models/job.dart';
import '../logic/jobs_controller.dart';
import '../../../core/utils/debug_logger.dart';
import '../../../core/utils/navigation_helpers.dart';
import '../../tutorial/logic/tutorial_registry.dart';
import '../../tutorial/ui/tutorial_trigger.dart';

class JobListPage extends ConsumerWidget {
  const JobListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    try {
      DebugLogger.debug('📝 JOB_LIST: Building JobListPage...');
      final l = AppLocalizations.of(context);
      DebugLogger.debug('📝 JOB_LIST: Localizations loaded successfully');

      final jobsAsync = ref.watch(userJobsProvider);
      DebugLogger.debug(
        '📝 JOB_LIST: Jobs provider state: ${jobsAsync.runtimeType}',
      );

      final scaffold = Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => popOrGoHome(context),
            icon: const Icon(Icons.arrow_back),
          ),
          title: Text(l.myJobs),
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1F2937),
          elevation: 1,
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push('/jobs/new'),
          child: const Icon(Icons.add),
        ),
        body: jobsAsync.when(
          data: (jobs) {
            DebugLogger.debug('📝 JOB_LIST: Received ${jobs.length} jobs');
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
                      l.noJobsYet,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l.createFirstJob,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => context.push('/jobs/new'),
                      icon: const Icon(Icons.add),
                      label: Text(l.createJob),
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
                return _JobCard(job: job);
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
                  l.errorLoadingJobs,
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

      return TutorialTrigger(screen: TutorialScreen.jobList, child: scaffold);
    } catch (e, stackTrace) {
      DebugLogger.error(
        '📝 JOB_LIST: Error building JobListPage',
        e,
        stackTrace,
      );

      // Return error widget for debugging
      return Scaffold(
        appBar: AppBar(title: const Text('Job List Error'), elevation: 0),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'JobListPage Build Error',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Error: $e',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }
  }
}

class _JobCard extends StatelessWidget {
  final Job job;

  const _JobCard({required this.job});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.push('/jobs/${job.id}'),
        borderRadius: BorderRadius.circular(12),
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
                          '${job.sizeM2.toInt()}m² • ${job.rooms} ${l.rooms}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '€${job.budget.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                  _StatusChip(status: job.status),
                ],
              ),
              if (job.services.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: job.services.take(3).map((service) {
                    return Chip(
                      label: Text(
                        _getServiceName(l, service),
                        style: const TextStyle(fontSize: 12),
                      ),
                      visualDensity: VisualDensity.compact,
                    );
                  }).toList(),
                ),
                if (job.services.length > 3)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      '+${job.services.length - 3} ${l.moreServices}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
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
            ],
          ),
        ),
      ),
    );
  }

  String _getServiceName(AppLocalizations l, String service) {
    switch (service) {
      case 'house_cleaning':
      case 'general_cleaning':
        return l.serviceGeneralCleaning;
      case 'deep_cleaning':
        return l.serviceDeepCleaning;
      case 'window_cleaning':
        return l.serviceWindowCleaning;
      case 'carpet_cleaning':
        return l.serviceCarpetCleaning;
      case 'kitchen_cleaning':
        return l.serviceKitchenCleaning;
      case 'bathroom_cleaning':
        return l.serviceBathroomCleaning;
      case 'ironing':
        return l.serviceIroning;
      case 'organization':
        return l.serviceOrganization;
      case 'windows_inside':
        return l.jobFormExtraWindowsInside;
      case 'windows_in_out':
        return l.jobFormExtraWindowsInOut;
      case 'kitchen_deep':
        return l.jobFormExtraKitchenDeep;
      case 'bathroom_deep':
        return l.jobFormExtraBathroomDeep;
      case 'laundry':
        return l.jobFormExtraLaundry;
      case 'ironing_light':
        return l.jobFormExtraIroningLight;
      case 'ironing_full':
        return l.jobFormExtraIroningFull;
      case 'balcony':
        return l.jobFormExtraBalcony;
      default:
        return service
            .split('_')
            .map(
              (segment) => segment.isEmpty
                  ? segment
                  : '${segment[0].toUpperCase()}${segment.substring(1)}',
            )
            .join(' ');
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  String _formatTimeRange(DateTime start, DateTime end) {
    final startTime =
        '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}';
    final endTime =
        '${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
    return '$startTime - $endTime';
  }
}

class _StatusChip extends StatelessWidget {
  final JobStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    Color backgroundColor;
    Color textColor;
    String text;

    switch (status) {
      case JobStatus.open:
        backgroundColor = Theme.of(context).colorScheme.primaryContainer;
        textColor = Theme.of(context).colorScheme.onPrimaryContainer;
        text = l.statusOpen;
        break;
      case JobStatus.assigned:
        backgroundColor = Theme.of(context).colorScheme.secondaryContainer;
        textColor = Theme.of(context).colorScheme.onSecondaryContainer;
        text = l.statusAssigned;
        break;
      case JobStatus.completed:
        backgroundColor = Theme.of(context).colorScheme.tertiaryContainer;
        textColor = Theme.of(context).colorScheme.onTertiaryContainer;
        text = l.statusCompleted;
        break;
      case JobStatus.cancelled:
        backgroundColor = Theme.of(context).colorScheme.errorContainer;
        textColor = Theme.of(context).colorScheme.onErrorContainer;
        text = l.statusCancelled;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }
}

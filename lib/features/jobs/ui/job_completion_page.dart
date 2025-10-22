import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/job.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/utils/debug_logger.dart';
import '../../../core/utils/navigation_helpers.dart';
import '../../disputes/ui/dispute_open_sheet.dart';
import '../../tutorial/logic/tutorial_registry.dart';
import '../../tutorial/ui/tutorial_trigger.dart';
import '../data/job_completion_repository.dart';
import '../logic/job_completion_controller.dart';
import '../logic/jobs_controller.dart';
import '../models/job_completion.dart';

class JobCompletionPage extends ConsumerStatefulWidget {
  const JobCompletionPage({super.key, required this.jobId});

  final String jobId;

  static String route(String jobId) => '/jobs/$jobId/completion';

  @override
  ConsumerState<JobCompletionPage> createState() => _JobCompletionPageState();
}

class _JobCompletionPageState extends ConsumerState<JobCompletionPage> {
  late final TextEditingController _noteController;
  bool _noteSynced = false;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
    ref.listen<JobCompletionState>(
      jobCompletionControllerProvider(widget.jobId),
      (previous, next) {
        if (!mounted) return;

        if (next.errorMessage != null &&
            next.errorMessage != previous?.errorMessage) {
          final message = next.errorMessage ?? 'jobCompletion.error.generic';
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message.tr())));
        }

        if (previous?.status != next.status) {
          if (next.status == 'submitted') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('jobCompletion.success.submit'.tr())),
            );
          } else if (next.status == 'approved') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('jobCompletion.success.approve'.tr())),
            );
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jobAsync = ref.watch(jobProvider(widget.jobId));
    final completionAsync = ref.watch(jobCompletionProvider(widget.jobId));
    final state = ref.watch(jobCompletionControllerProvider(widget.jobId));
    final controller = ref.read(
      jobCompletionControllerProvider(widget.jobId).notifier,
    );
    final userAsync = ref.watch(currentUserProvider);

    final scaffold = jobAsync.when(
      data: (job) {
        if (job == null) {
          return Scaffold(
            appBar: _buildAppBar(context),
            body: Center(child: Text('job.detail.notFound'.tr())),
          );
        }

        final completion = completionAsync.maybeWhen(
          data: (value) => value,
          orElse: () => null,
        );
        final currentUser = userAsync.maybeWhen(
          data: (value) => value,
          orElse: () => null,
        );
        final uid = currentUser?.uid;
        final isCustomer = uid != null && uid == job.customerUid;
        final isPro =
            uid != null &&
            job.assignedProUid != null &&
            uid == job.assignedProUid;
        final isAdmin = userAsync.maybeWhen(
          data: (user) =>
              user?.email != null && user!.email!.endsWith('@brivida.com'),
          orElse: () => false,
        );

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          controller.hydrate(job, completion, isPro: isPro);
          if (!_noteSynced || _noteController.text != state.note) {
            _noteSynced = true;
            _noteController.value = TextEditingValue(
              text: state.note,
              selection: TextSelection.collapsed(offset: state.note.length),
            );
          }
        });

        if (!isCustomer && !isPro && !isAdmin) {
          return Scaffold(
            appBar: _buildAppBar(context),
            body: Center(child: Text('jobCompletion.roleWarning'.tr())),
          );
        }

        return Scaffold(
          appBar: _buildAppBar(context),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(jobProvider(widget.jobId));
                ref.invalidate(jobCompletionProvider(widget.jobId));
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _buildJobSummaryCard(context, job),
                  const SizedBox(height: 16),
                  _buildPaymentStatusCard(context, job),
                  const SizedBox(height: 16),
                  if (isPro) ...[
                    _buildChecklistSection(context, state, controller),
                    const SizedBox(height: 16),
                    _buildPhotosSection(context, state, controller),
                    const SizedBox(height: 16),
                    _buildNoteSection(context, state, controller),
                    const SizedBox(height: 24),
                    _buildSubmitSection(context, state, controller),
                  ] else ...[
                    _buildCompletionSummary(context, state, completion),
                    const SizedBox(height: 24),
                    _buildCustomerActions(context, job, state, controller),
                  ],
                ],
              ),
            ),
          ),
        );
      },
      loading: () => Scaffold(
        appBar: _buildAppBar(context),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) {
        DebugLogger.error('❌ JOB_COMPLETION: Failed to load job', error, stack);
        return Scaffold(
          appBar: _buildAppBar(context),
          body: Center(child: Text('job.detail.error'.tr(args: ['$error']))),
        );
      },
    );

    return TutorialTrigger(
      screen: TutorialScreen.jobCompletion,
      child: scaffold,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        onPressed: () => popOrGoHome(context, homeRoute: '/jobs'),
        icon: const Icon(Icons.arrow_back),
      ),
      title: Text('jobCompletion.title'.tr()),
      centerTitle: true,
    );
  }

  Widget _buildJobSummaryCard(BuildContext context, Job job) {
    final start = job.window.start;
    final end = job.window.end;
    final dateRange =
        '${DateFormat.yMMMMd().format(start)} · '
        '${DateFormat.Hm().format(start)} - ${DateFormat.Hm().format(end)}';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'jobCompletion.summary.title'.tr(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _SummaryRow(
              label: 'jobCompletion.summary.status'.tr(),
              value: 'job.status.${job.status.name}'.tr(),
            ),
            _SummaryRow(
              label: 'jobCompletion.summary.budget'.tr(),
              value: '€${job.budget.toStringAsFixed(2)}',
            ),
            _SummaryRow(
              label: 'jobCompletion.summary.schedule'.tr(),
              value: dateRange,
            ),
            if (job.addressCity?.isNotEmpty == true)
              _SummaryRow(
                label: 'jobCompletion.summary.city'.tr(),
                value: job.addressCity!,
              ),
            if (job.services.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'job.detail.services'.tr(),
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: job.services
                    .map((service) => Chip(label: Text(service)))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentStatusCard(BuildContext context, Job job) {
    String description;
    IconData icon;
    Color color;

    switch (job.paymentStatus) {
      case PaymentStatus.captured:
        description = 'jobCompletion.payment.pendingRelease'.tr();
        icon = Icons.lock_clock;
        color = Colors.amber[700]!;
        break;
      case PaymentStatus.transferred:
        description = 'jobCompletion.payment.released'.tr();
        icon = Icons.check_circle_outline;
        color = Colors.green[700]!;
        break;
      case PaymentStatus.pending:
        description = 'jobCompletion.payment.pendingCapture'.tr();
        icon = Icons.hourglass_bottom;
        color = Colors.blueGrey[700]!;
        break;
      default:
        description = 'jobCompletion.payment.notAvailable'.tr();
        icon = Icons.info_outline;
        color = Colors.blueGrey[400]!;
        break;
    }

    return Card(
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text('jobCompletion.payment.title'.tr()),
        subtitle: Text(description),
      ),
    );
  }

  Widget _buildChecklistSection(
    BuildContext context,
    JobCompletionState state,
    JobCompletionController controller,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'jobCompletion.pro.checklist.title'.tr(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (state.checklist.isEmpty)
              Text('jobCompletion.pro.checklist.empty'.tr())
            else
              ...state.checklist.map(
                (item) => CheckboxListTile(
                  value: item.completed,
                  onChanged: (_) => controller.toggleChecklistItem(item.id),
                  title: Text(item.label),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotosSection(
    BuildContext context,
    JobCompletionState state,
    JobCompletionController controller,
  ) {
    final photos = state.photos;
    final isUploading = state.isUploadingPhoto;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'jobCompletion.pro.photos.title'.tr(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text('${photos.length}/5'),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ...photos.map(
                  (photo) => Stack(
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[200],
                          image: photo.url.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(photo.url),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: photo.isUploading
                            ? const Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: InkWell(
                          onTap: () => controller.removePhoto(photo.id),
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black54,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (photos.length < 5)
                  SizedBox(
                    width: 96,
                    height: 96,
                    child: OutlinedButton(
                      onPressed: isUploading
                          ? null
                          : () => controller.pickAndAddPhoto(),
                      child: isUploading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.add_a_photo_outlined),
                                const SizedBox(height: 8),
                                Text(
                                  'jobCompletion.pro.photos.add'.tr(),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteSection(
    BuildContext context,
    JobCompletionState state,
    JobCompletionController controller,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'jobCompletion.pro.note.title'.tr(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              maxLines: 5,
              minLines: 3,
              onChanged: controller.setNote,
              decoration: InputDecoration(
                hintText: 'jobCompletion.pro.note.hint'.tr(),
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitSection(
    BuildContext context,
    JobCompletionState state,
    JobCompletionController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (state.hasPendingSubmission)
          Card(
            color: Colors.amber[50],
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text('jobCompletion.pro.waitingApproval.title'.tr()),
              subtitle: Text('jobCompletion.pro.waitingApproval.body'.tr()),
            ),
          ),
        ElevatedButton.icon(
          onPressed: state.isSubmitting
              ? null
              : () => controller.submit(role: 'pro'),
          icon: state.isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.check_circle_outline),
          label: Text('jobCompletion.pro.submit'.tr()),
        ),
      ],
    );
  }

  Widget _buildCompletionSummary(
    BuildContext context,
    JobCompletionState state,
    JobCompletion? completion,
  ) {
    if (completion == null) {
      return Card(
        child: ListTile(
          leading: const Icon(Icons.hourglass_bottom),
          title: Text('jobCompletion.customer.waiting.title'.tr()),
          subtitle: Text('jobCompletion.customer.waiting.body'.tr()),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'jobCompletion.customer.submission.title'.tr(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            ...state.checklist.map(
              (item) => Row(
                children: [
                  Icon(
                    item.completed
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: item.completed ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: Text(item.label)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (state.photos.isNotEmpty) ...[
              Text(
                'jobCompletion.customer.photos.title'.tr(),
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: state.photos
                    .map(
                      (photo) => ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          photo.url,
                          width: 96,
                          height: 96,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 12),
            ],
            Text(
              'jobCompletion.customer.note.title'.tr(),
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            Text(
              state.note.isEmpty
                  ? 'jobCompletion.customer.note.empty'.tr()
                  : state.note,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerActions(
    BuildContext context,
    Job job,
    JobCompletionState state,
    JobCompletionController controller,
  ) {
    final canApprove = state.hasPendingSubmission;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: (!canApprove || state.isApproving || state.isApproved)
              ? null
              : () => controller.approve(job: job),
          icon: state.isApproving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.check_circle_outline),
          label: Text('jobCompletion.customer.approve'.tr()),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => _openDispute(context, job),
          icon: const Icon(Icons.report_problem_outlined),
          label: Text('jobCompletion.customer.dispute'.tr()),
        ),
      ],
    );
  }

  Future<void> _openDispute(BuildContext context, Job job) async {
    if (!mounted) return;
    final paymentId = job.paymentId;
    final amount = job.paidAmount ?? job.budget;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return DisputeOpenSheet(
          jobId: job.id ?? '',
          paymentId: paymentId ?? '',
          maxRefundAmount: amount,
        );
      },
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ),
          Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

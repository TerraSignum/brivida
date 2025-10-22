import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:typed_data';
import '../../../core/models/dispute.dart';
import '../logic/dispute_controller.dart';
import '../../auth/logic/auth_controller.dart';
import '../../../core/utils/debug_logger.dart';

class DisputeDetailPage extends ConsumerStatefulWidget {
  final String caseId;

  const DisputeDetailPage({
    super.key,
    required this.caseId,
  });

  @override
  ConsumerState<DisputeDetailPage> createState() => _DisputeDetailPageState();
}

class _DisputeDetailPageState extends ConsumerState<DisputeDetailPage> {
  final _responseController = TextEditingController();
  final _scrollController = ScrollController();
  final List<PlatformFile> _selectedFiles = [];
  bool _isSubmittingResponse = false;

  @override
  void dispose() {
    _responseController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disputeAsync = ref.watch(disputeProvider(widget.caseId));
    final userRole = ref.watch(userRoleProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text('dispute.detail.title'.tr()),
        actions: [
          if (userRole.value == 'admin')
            IconButton(
              onPressed: () => _showAdminActions(context),
              icon: const Icon(Icons.admin_panel_settings),
            ),
        ],
      ),
      body: disputeAsync.when(
        data: (dispute) {
          if (dispute == null) {
            return Center(
              child: Text('dispute.not_found'.tr()),
            );
          }
          return _buildDisputeContent(dispute);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error,
                  size: 64, color: Theme.of(context).colorScheme.error),
              const SizedBox(height: 16),
              Text('dispute.load_error'.tr()),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => ref.invalidate(disputeProvider(widget.caseId)),
                child: Text('common.retry'.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDisputeContent(Dispute dispute) {
    return Column(
      children: [
        // Status header
        _buildStatusHeader(dispute),

        // Timeline
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildDisputeInfo(dispute),
                const SizedBox(height: 24),
                _buildTimeline(dispute),
                const SizedBox(height: 24),
                if (dispute.status.canAddEvidence)
                  _buildResponseSection(dispute),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusHeader(Dispute dispute) {
    Color statusColor;
    IconData statusIcon;

    switch (dispute.status) {
      case DisputeStatus.open:
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        break;
      case DisputeStatus.underReview:
        statusColor = Colors.blue;
        statusIcon = Icons.visibility;
        break;
      case DisputeStatus.resolvedRefundFull:
      case DisputeStatus.resolvedRefundPartial:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case DisputeStatus.resolvedNoRefund:
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.info;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      color: statusColor.withValues(alpha: 0.1),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'dispute.status.${dispute.status.name}'.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                if (dispute.status == DisputeStatus.open &&
                    dispute.deadlineProResponse.isAfter(DateTime.now()))
                  Text(
                    'dispute.deadline.pro'.tr(args: [
                      DateFormat('dd.MM.yyyy HH:mm')
                          .format(dispute.deadlineProResponse)
                    ]),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                if (dispute.status == DisputeStatus.underReview &&
                    dispute.deadlineDecision.isAfter(DateTime.now()))
                  Text(
                    'dispute.deadline.decision'.tr(args: [
                      DateFormat('dd.MM.yyyy HH:mm')
                          .format(dispute.deadlineDecision)
                    ]),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
          ),
          Text(
            '€${dispute.requestedAmount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisputeInfo(Dispute dispute) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'dispute.info'.tr(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            _buildInfoRow('dispute.reason.title'.tr(),
                'dispute.reason.${dispute.reason.name}'.tr()),
            _buildInfoRow('dispute.opened'.tr(),
                DateFormat('dd.MM.yyyy HH:mm').format(dispute.openedAt)),
            _buildInfoRow('dispute.request.amount'.tr(),
                '€${dispute.requestedAmount.toStringAsFixed(2)}'),
            if (dispute.awardedAmount != null)
              _buildInfoRow('dispute.awarded.amount'.tr(),
                  '€${dispute.awardedAmount!.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            Text(
              'dispute.description'.tr(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 4),
            Text(dispute.description),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildTimeline(Dispute dispute) {
    final List<Widget> timelineItems = [];

    // Opening
    timelineItems.add(_buildTimelineItem(
      icon: Icons.flag,
      title: 'dispute.timeline.opened'.tr(),
      subtitle: DateFormat('dd.MM.yyyy HH:mm').format(dispute.openedAt),
      isFirst: true,
    ));

    // Customer evidence
    for (final evidence in dispute.evidence) {
      timelineItems.add(_buildTimelineItem(
        icon: Icons.person,
        title: 'dispute.timeline.customer_evidence'.tr(),
        subtitle: DateFormat('dd.MM.yyyy HH:mm').format(evidence.createdAt),
        content: _buildEvidenceContent(evidence),
      ));
    }

    // Pro responses
    for (final response in dispute.proResponse) {
      timelineItems.add(_buildTimelineItem(
        icon: Icons.business,
        title: 'dispute.timeline.pro_response'.tr(),
        subtitle: DateFormat('dd.MM.yyyy HH:mm').format(response.createdAt),
        content: _buildEvidenceContent(response),
      ));
    }

    // Resolution
    if (dispute.resolvedAt != null) {
      timelineItems.add(_buildTimelineItem(
        icon: Icons.gavel,
        title: 'dispute.timeline.resolved'.tr(),
        subtitle: DateFormat('dd.MM.yyyy HH:mm').format(dispute.resolvedAt!),
        isLast: true,
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'dispute.timeline.title'.tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        ...timelineItems,
      ],
    );
  }

  Widget _buildTimelineItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? content,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              if (!isFirst)
                Container(height: 16, width: 2, color: Colors.grey[300]),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 16),
              ),
              if (!isLast)
                Expanded(child: Container(width: 2, color: Colors.grey[300])),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  if (content != null) ...[
                    const SizedBox(height: 8),
                    content,
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEvidenceContent(Evidence evidence) {
    switch (evidence.type) {
      case EvidenceType.text:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(evidence.text ?? ''),
        );
      case EvidenceType.image:
        if (evidence.path != null) {
          return FutureBuilder<String?>(
            future: ref
                .read(disputeControllerProvider.notifier)
                .getEvidenceUrl(evidence.path!),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: snapshot.data!,
                    height: 200,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.error),
                    ),
                  ),
                );
              }
              return Container(
                height: 200,
                color: Colors.grey[300],
                child: const Center(child: CircularProgressIndicator()),
              );
            },
          );
        }
        break;
      case EvidenceType.audio:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.audiotrack),
              const SizedBox(width: 8),
              Text('dispute.evidence.audio'.tr()),
            ],
          ),
        );
    }
    return const SizedBox.shrink();
  }

  Widget _buildResponseSection(Dispute dispute) {
    final currentUser = ref.watch(authStateProvider);
    final isCustomer = currentUser.value?.uid == dispute.customerUid;
    final isPro = currentUser.value?.uid == dispute.proUid;

    if (!isCustomer && !isPro) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              isCustomer
                  ? 'dispute.add.evidence'.tr()
                  : 'dispute.add.response'.tr(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _responseController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'dispute.response.hint'.tr(),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            _buildFileSelection(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isSubmittingResponse ? null : _submitResponse,
              child: _isSubmittingResponse
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text('dispute.submit.response'.tr()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          onPressed: _pickFiles,
          icon: const Icon(Icons.attach_file),
          label: Text('dispute.evidence.add'.tr()),
        ),
        if (_selectedFiles.isNotEmpty) ...[
          const SizedBox(height: 8),
          ..._selectedFiles.asMap().entries.map((entry) {
            final index = entry.key;
            final file = entry.value;
            return ListTile(
              leading: Icon(_getFileIcon(file.extension)),
              title: Text(file.name),
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    _selectedFiles.removeAt(index);
                  });
                },
                icon: const Icon(Icons.remove_circle),
              ),
              dense: true,
              contentPadding: EdgeInsets.zero,
            );
          }),
        ],
      ],
    );
  }

  Future<void> _pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: [
          'jpg',
          'jpeg',
          'png',
          'gif',
          'mp3',
          'wav',
          'm4a',
          'aac'
        ],
        withData: true,
      );

      if (result != null) {
        setState(() {
          _selectedFiles.addAll(result.files);
        });
      }
    } catch (e) {
      DebugLogger.log('❌ DISPUTE UI: Error picking files: $e');
    }
  }

  IconData _getFileIcon(String? extension) {
    if (extension == null) return Icons.insert_drive_file;

    if (['jpg', 'jpeg', 'png', 'gif'].contains(extension.toLowerCase())) {
      return Icons.image;
    } else if (['mp3', 'wav', 'm4a', 'aac'].contains(extension.toLowerCase())) {
      return Icons.audiotrack;
    }
    return Icons.insert_drive_file;
  }

  Future<void> _submitResponse() async {
    final currentUser = ref.read(authStateProvider).value;
    if (currentUser == null) return;

    final dispute = ref.read(disputeProvider(widget.caseId)).value;
    if (dispute == null) return;

    final isCustomer = currentUser.uid == dispute.customerUid;
    final role = isCustomer ? 'customer' : 'pro';

    setState(() {
      _isSubmittingResponse = true;
    });

    try {
      final controller = ref.read(disputeControllerProvider.notifier);

      List<Uint8List>? mediaData;
      List<String>? fileNames;

      if (_selectedFiles.isNotEmpty) {
        mediaData = [];
        fileNames = [];

        for (final file in _selectedFiles) {
          if (file.bytes != null) {
            mediaData.add(file.bytes!);
            fileNames.add(file.name);
          }
        }
      }

      final success = await controller.addEvidence(
        caseId: widget.caseId,
        role: role,
        text: _responseController.text.trim().isNotEmpty
            ? _responseController.text.trim()
            : null,
        mediaFiles: mediaData,
        fileNames: fileNames,
      );

      if (mounted && success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('dispute.response.success'.tr()),
            backgroundColor: Colors.green,
          ),
        );
        _responseController.clear();
        setState(() {
          _selectedFiles.clear();
        });

        // Scroll to bottom to show new content
        Future.delayed(const Duration(milliseconds: 500), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
    } catch (e) {
      DebugLogger.log('❌ DISPUTE UI: Error submitting response: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('dispute.response.error'.tr())),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmittingResponse = false;
        });
      }
    }
  }

  void _showAdminActions(BuildContext context) {
    final dispute = ref.read(disputeProvider(widget.caseId)).value;
    if (dispute == null || dispute.status.isResolved) return;

    showModalBottomSheet(
      context: context,
      builder: (context) => AdminDisputeActions(dispute: dispute),
    );
  }
}

class AdminDisputeActions extends ConsumerStatefulWidget {
  final Dispute dispute;

  const AdminDisputeActions({
    super.key,
    required this.dispute,
  });

  @override
  ConsumerState<AdminDisputeActions> createState() =>
      _AdminDisputeActionsState();
}

class _AdminDisputeActionsState extends ConsumerState<AdminDisputeActions> {
  final _amountController = TextEditingController();
  String _selectedDecision = 'no_refund';

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'dispute.admin.resolve'.tr(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),

          // Decision options
          RadioListTile<String>(
            title: Text('dispute.admin.no_refund'.tr()),
            value: 'no_refund',
            groupValue: _selectedDecision,
            onChanged: (value) => setState(() => _selectedDecision = value!),
          ),
          RadioListTile<String>(
            title: Text('dispute.admin.full_refund'.tr()),
            value: 'refund_full',
            groupValue: _selectedDecision,
            onChanged: (value) => setState(() => _selectedDecision = value!),
          ),
          RadioListTile<String>(
            title: Text('dispute.admin.partial_refund'.tr()),
            value: 'refund_partial',
            groupValue: _selectedDecision,
            onChanged: (value) => setState(() => _selectedDecision = value!),
          ),

          // Amount input for partial refund
          if (_selectedDecision == 'refund_partial') ...[
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'dispute.admin.amount'.tr(),
                prefixText: '€ ',
                border: const OutlineInputBorder(),
              ),
            ),
          ],

          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => context.pop(),
                  child: Text('common.cancel'.tr()),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _resolveDispute,
                  child: Text('dispute.admin.resolve'.tr()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _resolveDispute() async {
    try {
      double? amount;
      if (_selectedDecision == 'refund_partial') {
        amount = double.tryParse(_amountController.text.trim());
        if (amount == null || amount <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('dispute.admin.amount.invalid'.tr())),
          );
          return;
        }
      }

      final controller = ref.read(disputeControllerProvider.notifier);
      final success = await controller.resolveDispute(
        caseId: widget.dispute.id,
        decision: _selectedDecision,
        amount: amount,
      );

      if (mounted) {
        context.pop(); // Close bottom sheet
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('dispute.admin.resolved.success'.tr()),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('dispute.admin.resolved.error'.tr())),
          );
        }
      }
    } catch (e) {
      DebugLogger.log('❌ DISPUTE UI: Error resolving dispute: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('dispute.admin.resolved.error'.tr())),
        );
      }
    }
  }
}

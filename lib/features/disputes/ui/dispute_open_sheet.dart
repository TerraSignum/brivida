import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import '../../../core/models/dispute.dart';
import '../logic/dispute_controller.dart';
import '../../../core/utils/debug_logger.dart';

class DisputeOpenSheet extends ConsumerStatefulWidget {
  final String jobId;
  final String paymentId;
  final double maxRefundAmount;

  const DisputeOpenSheet({
    super.key,
    required this.jobId,
    required this.paymentId,
    required this.maxRefundAmount,
  });

  @override
  ConsumerState<DisputeOpenSheet> createState() => _DisputeOpenSheetState();
}

class _DisputeOpenSheetState extends ConsumerState<DisputeOpenSheet> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();

  DisputeReason _selectedReason = DisputeReason.poorQuality;
  final List<PlatformFile> _selectedFiles = [];
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Set default amount to max refund
    _amountController.text = widget.maxRefundAmount.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            children: [
              Text(
                'dispute.open'.tr(),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Spacer(),
              IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Form
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Reason selection
                Text(
                  'dispute.reason.title'.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                _buildReasonSelector(),
                const SizedBox(height: 16),

                // Description
                Text(
                  'dispute.description'.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'dispute.description.hint'.tr(),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'dispute.description.required'.tr();
                    }
                    if (value.trim().length < 10) {
                      return 'dispute.description.min_length'.tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Requested amount
                Text(
                  'dispute.request.amount'.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixText: '€ ',
                    border: const OutlineInputBorder(),
                    helperText: 'dispute.request.amount.max'
                        .tr(args: [widget.maxRefundAmount.toStringAsFixed(2)]),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'dispute.request.amount.required'.tr();
                    }
                    final amount = double.tryParse(value.trim());
                    if (amount == null || amount <= 0) {
                      return 'dispute.request.amount.invalid'.tr();
                    }
                    if (amount > widget.maxRefundAmount) {
                      return 'dispute.request.amount.exceeds_max'.tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Evidence upload
                Text(
                  'dispute.evidence'.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                _buildEvidenceSection(),
                const SizedBox(height: 24),

                // Submit button
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitDispute,
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text('dispute.submit'.tr()),
                ),
                const SizedBox(height: 8),

                // Warning text
                Text(
                  'dispute.warning'.tr(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReasonSelector() {
    return Column(
      children: DisputeReason.values.map((reason) {
        return RadioListTile<DisputeReason>(
          title: Text('dispute.reason.${reason.name}'.tr()),
          value: reason,
          groupValue: _selectedReason,
          onChanged: (value) {
            setState(() {
              _selectedReason = value!;
            });
          },
          dense: true,
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }

  Widget _buildEvidenceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          onPressed: _pickFiles,
          icon: const Icon(Icons.attach_file),
          label: Text('dispute.evidence.add'.tr()),
        ),
        const SizedBox(height: 8),
        if (_selectedFiles.isNotEmpty) ...[
          Text(
            'dispute.evidence.selected'
                .tr(args: [_selectedFiles.length.toString()]),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          ..._selectedFiles.asMap().entries.map((entry) {
            final index = entry.key;
            final file = entry.value;
            return ListTile(
              leading: Icon(_getFileIcon(file.extension)),
              title: Text(file.name),
              subtitle: Text(_formatFileSize(file.size)),
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
        Text(
          'dispute.evidence.info'.tr(),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
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
        withData: true, // Important for web
      );

      if (result != null) {
        setState(() {
          _selectedFiles.addAll(result.files);
        });
      }
    } catch (e) {
      DebugLogger.log('❌ DISPUTE UI: Error picking files: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('dispute.evidence.error'.tr())),
        );
      }
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

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  Future<void> _submitDispute() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final controller = ref.read(disputeControllerProvider.notifier);

      // Prepare media files for upload
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

      final caseId = await controller.openDispute(
        jobId: widget.jobId,
        paymentId: widget.paymentId,
        reason: _selectedReason,
        description: _descriptionController.text.trim(),
        requestedAmount: double.parse(_amountController.text.trim()),
        mediaFiles: mediaData,
        fileNames: fileNames,
      );

      if (mounted) {
        if (caseId != null) {
          // Success - show message and navigate to dispute detail
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('dispute.submitted.success'.tr()),
              backgroundColor: Colors.green,
            ),
          );
          context.pop(); // Close sheet
          context.go('/dispute/$caseId'); // Navigate to dispute detail
        } else {
          // Error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('dispute.submitted.error'.tr())),
          );
        }
      }
    } catch (e) {
      DebugLogger.log('❌ DISPUTE UI: Error submitting dispute: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('dispute.submitted.error'.tr())),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}

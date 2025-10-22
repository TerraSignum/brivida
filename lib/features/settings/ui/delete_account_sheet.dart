import 'package:brivida_app/core/exceptions/app_exceptions.dart';
import 'package:brivida_app/core/i18n/app_localizations.dart';
import 'package:brivida_app/core/utils/debug_logger.dart';
import 'package:brivida_app/features/settings/logic/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteAccountSheet extends ConsumerStatefulWidget {
  const DeleteAccountSheet({super.key});

  @override
  ConsumerState<DeleteAccountSheet> createState() => _DeleteAccountSheetState();
}

class _DeleteAccountSheetState extends ConsumerState<DeleteAccountSheet> {
  late final TextEditingController _confirmationController;
  bool _understood = false;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _confirmationController = TextEditingController();
  }

  @override
  void dispose() {
    _confirmationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);
    final user = state.valueOrNull;
    final email = user?.email ?? '';

    final canConfirm =
        _understood &&
        !_isDeleting &&
        email.isNotEmpty &&
        _confirmationController.text.trim().toLowerCase() ==
            email.toLowerCase();

    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: AnimatedPadding(
        padding: EdgeInsets.only(
          bottom: bottomInset,
          left: 16,
          right: 16,
          top: 24,
        ),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.translate('settings.delete.title'),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.red[700]),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.translate('settings.delete.warning'),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              _buildDangerList(context, l10n),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmationController,
                enabled: !_isDeleting,
                decoration: InputDecoration(
                  labelText: l10n.translate('settings.delete.confirmLabel'),
                  hintText: email,
                  helperText: l10n
                      .translate('settings.delete.confirmHelper')
                      .replaceAll('{email}', email),
                ),
                onChanged: (_) => setState(() {}),
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.translate('settings.delete.acknowledge')),
                value: _understood,
                onChanged: _isDeleting
                    ? null
                    : (value) {
                        setState(() {
                          _understood = value ?? false;
                        });
                      },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: _isDeleting
                        ? null
                        : () {
                            Navigator.of(context).pop(false);
                          },
                    child: Text(l10n.translate('common.cancel')),
                  ),
                  const Spacer(),
                  FilledButton.tonalIcon(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.red[50],
                      foregroundColor: Colors.red[800],
                    ),
                    onPressed: canConfirm
                        ? () => _deleteAccount(controller)
                        : null,
                    icon: _isDeleting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.red,
                            ),
                          )
                        : const Icon(Icons.delete_forever_outlined),
                    label: Text(
                      l10n.translate('settings.delete.confirmAction'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDangerList(BuildContext context, AppLocalizations l10n) {
    final bulletStyle = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]);

    final items = [
      l10n.translate('settings.delete.bullet.profile'),
      l10n.translate('settings.delete.bullet.jobs'),
      l10n.translate('settings.delete.bullet.credits'),
      l10n.translate('settings.delete.bullet.payments'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 4),
                const Text('• '),
                Expanded(child: Text(item, style: bulletStyle)),
              ],
            ),
          ),
      ],
    );
  }

  Future<void> _deleteAccount(SettingsController controller) async {
    final l10n = AppLocalizations.of(context);
    final email = _confirmationController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.translate('settings.delete.confirmHint'))),
      );
      return;
    }

    setState(() {
      _isDeleting = true;
    });

    try {
      await controller.deleteAccount();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.translate('settings.delete.success'))),
      );
      Navigator.of(context).pop(true);
    } on AppException catch (error) {
      _handleError(error);
    } catch (error, stack) {
      DebugLogger.error('Unknown error deleting account', error, stack);
      _handleError(error);
    } finally {
      if (mounted) {
        setState(() {
          _isDeleting = false;
        });
      }
    }
  }

  void _handleError(Object error) {
    final l10n = AppLocalizations.of(context);
    final message = error is AppException
        ? error.message
        : l10n.translate('settings.error.generic');
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

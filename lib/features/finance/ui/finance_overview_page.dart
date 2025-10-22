import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/exceptions/app_exceptions.dart';
import '../../../core/models/payment.dart';
import '../../../core/models/payout.dart';
import '../../../core/utils/debug_logger.dart';
import '../../../core/utils/navigation_helpers.dart';
import '../../payouts/logic/payouts_controller.dart';
import '../logic/financial_overview_provider.dart';
import '../widgets/financial_overview_widget.dart';
import '../../tutorial/logic/tutorial_registry.dart';
import '../../tutorial/ui/tutorial_trigger.dart';

const _financeSupportEmail = 'finance-support@brivida.com';

class FinanceOverviewPage extends ConsumerWidget {
  const FinanceOverviewPage({super.key});

  static const routePath = '/finance';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewAsync = ref.watch(financialOverviewProvider);

    final scaffold = Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => popOrGoHome(context),
        ),
        title: Text('finance.page.title'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            tooltip: 'finance.page.actions.openPayouts'.tr(),
            onPressed: () => context.push('/payouts'),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: overviewAsync.when(
          data: (summary) {
            final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(financialOverviewProvider);
                await ref.read(financialOverviewProvider.future);
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.fromLTRB(16, 16, 16, 32 + bottomPadding),
                children: [
                  FinancialOverviewWidget(
                    onViewDetails: () => context.push('/payouts'),
                  ),
                  const SizedBox(height: 24),
                  _FinanceQuickActions(
                    onViewPayouts: () => context.push('/payouts'),
                    onDownloadStatement: () =>
                        _handleDownloadStatement(context, ref),
                    onContactSupport: () => _handleFinanceSupport(context),
                  ),
                  const SizedBox(height: 24),
                  _FinanceRecentTransfersSection(
                    transfers: summary.recentTransfers,
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => _FinanceOverviewErrorState(
            error: error,
            onRetry: () => ref.refresh(financialOverviewProvider),
          ),
        ),
      ),
    );

    return TutorialTrigger(screen: TutorialScreen.finance, child: scaffold);
  }
}

class _FinanceQuickActions extends StatelessWidget {
  const _FinanceQuickActions({
    required this.onViewPayouts,
    required this.onDownloadStatement,
    required this.onContactSupport,
  });

  final VoidCallback onViewPayouts;
  final Future<void> Function() onDownloadStatement;
  final Future<void> Function() onContactSupport;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'finance.page.sections.actions'.tr(),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet_outlined),
              title: Text('finance.page.actions.openPayouts'.tr()),
              subtitle: Text('finance.page.actions.openPayoutsSubtitle'.tr()),
              trailing: const Icon(Icons.chevron_right),
              onTap: onViewPayouts,
            ),
            const Divider(height: 0),
            ListTile(
              leading: const Icon(Icons.download_outlined),
              title: Text('finance.page.actions.downloadStatement'.tr()),
              subtitle: Text(
                'finance.page.actions.downloadStatementSubtitle'.tr(),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => unawaited(onDownloadStatement()),
            ),
            const Divider(height: 0),
            ListTile(
              leading: const Icon(Icons.support_agent_outlined),
              title: Text('finance.page.actions.contactSupport'.tr()),
              subtitle: Text(
                'finance.page.actions.contactSupportSubtitle'.tr(),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => unawaited(onContactSupport()),
            ),
          ],
        ),
      ),
    );
  }
}

class _FinanceRecentTransfersSection extends StatelessWidget {
  const _FinanceRecentTransfersSection({required this.transfers});

  final List<Transfer> transfers;

  @override
  Widget build(BuildContext context) {
    final localeName = context.locale.toString();
    final currencyFormat = NumberFormat.simpleCurrency(
      locale: localeName,
      name: 'EUR',
    );
    final dateFormat = DateFormat.yMMMMd(localeName);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'finance.page.sections.recent'.tr(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (transfers.isNotEmpty)
                  TextButton(
                    onPressed: () => context.push('/payouts'),
                    child: Text('finance.overview.recent.seeAll'.tr()),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (transfers.isEmpty)
              const _FinanceEmptyState()
            else
              ...transfers.map(
                (transfer) => Column(
                  children: [
                    _FinanceTransferTile(
                      transfer: transfer,
                      currencyFormat: currencyFormat,
                      dateFormat: dateFormat,
                    ),
                    if (transfer != transfers.last) const Divider(height: 16),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FinanceTransferTile extends StatelessWidget {
  const _FinanceTransferTile({
    required this.transfer,
    required this.currencyFormat,
    required this.dateFormat,
  });

  final Transfer transfer;
  final NumberFormat currencyFormat;
  final DateFormat dateFormat;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(transfer.status);
    final statusLabel = _statusLabel(context, transfer.status);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: statusColor.withValues(alpha: 0.12),
        child: Icon(Icons.payments, color: statusColor),
      ),
      title: Text(
        currencyFormat.format(transfer.amountNet),
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            transfer.createdAt != null
                ? dateFormat.format(transfer.createdAt!)
                : 'finance.overview.recent.unknownDate'.tr(),
          ),
          const SizedBox(height: 4),
          Text(
            'finance.page.recent.statusLabel'.tr(
              namedArgs: {'status': statusLabel},
            ),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      onTap: () => context.push('/payouts'),
    );
  }
}

class _FinanceEmptyState extends StatelessWidget {
  const _FinanceEmptyState();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Icon(Icons.inbox_outlined, color: Colors.grey[500], size: 48),
        const SizedBox(height: 12),
        Text(
          'finance.page.empty.title'.tr(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 6),
        Text(
          'finance.page.empty.subtitle'.tr(),
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _FinanceOverviewErrorState extends StatelessWidget {
  const _FinanceOverviewErrorState({
    required this.error,
    required this.onRetry,
  });

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: Colors.red[400], size: 48),
            const SizedBox(height: 12),
            Text(
              'finance.overview.error.generic'.tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.red[400],
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: onRetry,
              child: Text('finance.overview.error.retry'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}

Color _statusColor(TransferStatus status) {
  return switch (status) {
    TransferStatus.completed => Colors.green,
    TransferStatus.pending => Colors.orange,
    TransferStatus.failed => Colors.red,
  };
}

String _statusLabel(BuildContext context, TransferStatus status) {
  return switch (status) {
    TransferStatus.completed => 'finance.overview.status.completed'.tr(),
    TransferStatus.pending => 'finance.overview.status.pending'.tr(),
    TransferStatus.failed => 'finance.overview.status.failed'.tr(),
  };
}

class _FinanceExportProgressDialog extends StatelessWidget {
  const _FinanceExportProgressDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text('finance.page.actions.downloadStatementPreparing'.tr()),
        ],
      ),
    );
  }
}

Future<void> _handleDownloadStatement(
  BuildContext context,
  WidgetRef ref,
) async {
  DebugLogger.custom('💶', 'FINANCE', 'User requested finance CSV export');

  var progressDismissed = false;
  final progressFuture =
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (_) => const _FinanceExportProgressDialog(),
      ).whenComplete(() {
        progressDismissed = true;
      });

  final now = DateTime.now();
  final periodStart = now.subtract(const Duration(days: 30));
  final controller = ref.read(payoutsControllerProvider.notifier);

  ExportResult? result;
  Object? capturedError;
  StackTrace? capturedStack;

  try {
    result = await controller.exportTransfersCsv(from: periodStart, to: now);
  } catch (error, stackTrace) {
    capturedError = error;
    capturedStack = stackTrace;
    DebugLogger.error(
      '💶 FINANCE: exportTransfersCsv threw unexpectedly',
      error,
      stackTrace,
    );
  } finally {
    if (!progressDismissed && context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
    await progressFuture;
  }

  if (!context.mounted) {
    return;
  }

  if (result == null) {
    final controllerState = ref.read(payoutsControllerProvider);
    final stateError = controllerState.maybeWhen(
      error: (error, _) => error,
      orElse: () => null,
    );
    final resolvedError = capturedError ?? stateError;

    DebugLogger.warning(
      '💶 FINANCE: CSV export failed',
      resolvedError,
      capturedStack,
    );

    final message = _financeExportErrorMessage(resolvedError);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
    return;
  }

  DebugLogger.custom(
    '💶',
    'FINANCE',
    'Finance CSV export ready (${result.filename})',
  );

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('finance.page.actions.downloadStatementSuccess'.tr()),
    ),
  );

  await _showFinanceDownloadSheet(context, result);
}

Future<void> _showFinanceDownloadSheet(
  BuildContext context,
  ExportResult result,
) async {
  final choice = await showModalBottomSheet<String>(
    context: context,
    builder: (sheetContext) {
      final localeName = context.locale.toString();
      final expiresAt = DateFormat.yMMMMd(
        localeName,
      ).add_Hm().format(result.expiresAt.toLocal());

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'finance.page.actions.downloadStatementOptionsTitle'.tr(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'finance.page.actions.downloadStatementOptionsSubtitle'.tr(
                  namedArgs: {'filename': result.filename},
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.open_in_new),
                title: Text(
                  'finance.page.actions.downloadStatementOptionOpen'.tr(),
                ),
                onTap: () => Navigator.of(sheetContext).pop('open'),
              ),
              ListTile(
                leading: const Icon(Icons.copy_outlined),
                title: Text(
                  'finance.page.actions.downloadStatementOptionCopy'.tr(),
                ),
                onTap: () => Navigator.of(sheetContext).pop('copy'),
              ),
              const SizedBox(height: 8),
              Text(
                'finance.page.actions.downloadStatementOptionExpires'.tr(
                  namedArgs: {'date': expiresAt},
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(sheetContext).pop(),
                  child: Text('common.cancel'.tr()),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  if (!context.mounted || choice == null) {
    return;
  }

  if (choice == 'copy') {
    await Clipboard.setData(ClipboardData(text: result.downloadUrl));
    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'finance.page.actions.downloadStatementOptionCopied'.tr(),
        ),
      ),
    );
    return;
  }

  if (choice == 'open') {
    final launched = await _launchExternalUrl(result.downloadUrl);
    if (!context.mounted) {
      return;
    }

    if (!launched) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'finance.page.actions.downloadStatementOptionLaunchError'.tr(),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}

Future<bool> _launchExternalUrl(String url) async {
  try {
    final uri = Uri.parse(url);
    if (!await canLaunchUrl(uri)) {
      DebugLogger.warning('💶 FINANCE: cannot launch download URL', url);
      return false;
    }

    return await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (error, stackTrace) {
    DebugLogger.error(
      '💶 FINANCE: failed to open download URL',
      error,
      stackTrace,
    );
    return false;
  }
}

Future<void> _handleFinanceSupport(BuildContext context) async {
  DebugLogger.custom(
    '💶',
    'FINANCE_SUPPORT',
    'User requested finance support contact',
  );

  final subject = 'finance.page.actions.contactSupportSubject'.tr();
  final body = 'finance.page.actions.contactSupportEmailBody'.tr();

  final launched = await _launchFinanceSupportEmail(
    subject: subject,
    body: body,
  );

  if (!context.mounted) {
    return;
  }

  if (launched) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('finance.page.actions.contactSupportLaunchSuccess'.tr()),
      ),
    );
    return;
  }

  DebugLogger.warning('💶 FINANCE_SUPPORT: email app unavailable');
  await _showFinanceSupportDialog(context, subject: subject, body: body);
}

Future<bool> _launchFinanceSupportEmail({
  required String subject,
  required String body,
}) async {
  final query = <String, String>{
    'subject': subject,
    if (body.trim().isNotEmpty) 'body': body,
  };

  final uri = Uri(
    scheme: 'mailto',
    path: _financeSupportEmail,
    query: _encodeQueryParameters(query),
  );

  try {
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      DebugLogger.warning('💶 FINANCE_SUPPORT: support mail client refused');
    }
    return launched;
  } catch (error, stackTrace) {
    DebugLogger.error(
      '💶 FINANCE_SUPPORT: failed to open support email',
      error,
      stackTrace,
    );
    return false;
  }
}

Future<void> _showFinanceSupportDialog(
  BuildContext context, {
  required String subject,
  required String body,
}) async {
  final choice = await showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text('finance.page.actions.contactSupportDialogTitle'.tr()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('finance.page.actions.contactSupportDialogBody'.tr()),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.email_outlined),
            title: Text('finance.page.actions.contactSupportDialogOpen'.tr()),
            subtitle: Text(_financeSupportEmail),
            onTap: () => Navigator.of(dialogContext).pop('open'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.copy_outlined),
            title: Text('finance.page.actions.contactSupportDialogCopy'.tr()),
            subtitle: Text(_financeSupportEmail),
            onTap: () => Navigator.of(dialogContext).pop('copy'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: Text('common.cancel'.tr()),
        ),
      ],
    ),
  );

  if (!context.mounted || choice == null) {
    return;
  }

  if (choice == 'copy') {
    await Clipboard.setData(const ClipboardData(text: _financeSupportEmail));
    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('finance.page.actions.contactSupportDialogCopied'.tr()),
      ),
    );
    return;
  }

  if (choice == 'open') {
    final relaunched = await _launchFinanceSupportEmail(
      subject: subject,
      body: body,
    );

    if (!context.mounted) {
      return;
    }

    if (relaunched) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'finance.page.actions.contactSupportLaunchSuccess'.tr(),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('finance.page.actions.contactSupportLaunchError'.tr()),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}

String _encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map(
        (entry) =>
            '${Uri.encodeComponent(entry.key)}=${Uri.encodeComponent(entry.value)}',
      )
      .join('&');
}

String _financeExportErrorMessage(Object? error) {
  if (error is AppException) {
    return error.message;
  }

  return 'finance.page.actions.downloadStatementError'.tr();
}

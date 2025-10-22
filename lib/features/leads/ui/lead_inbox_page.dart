import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/i18n/app_localizations.dart';
import '../../../core/models/lead.dart';
import '../logic/leads_controller.dart';
import '../../../core/utils/debug_logger.dart';
import '../../../core/utils/navigation_helpers.dart';
import '../../tutorial/logic/tutorial_registry.dart';
import '../../tutorial/ui/tutorial_trigger.dart';

class LeadInboxPage extends ConsumerWidget {
  const LeadInboxPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    try {
      DebugLogger.debug('📨 LEAD_INBOX: Building LeadInboxPage...');
      final l = AppLocalizations.of(context);
      DebugLogger.debug('📨 LEAD_INBOX: Localizations loaded successfully');

      final leadsAsync = ref.watch(proLeadsProvider);
      DebugLogger.debug(
        '📨 LEAD_INBOX: Leads provider state: ${leadsAsync.runtimeType}',
      );

      final scaffold = Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => popOrGoHome(context, homeRoute: '/jobs'),
            icon: const Icon(Icons.arrow_back),
          ),
          title: Text(l.leadInboxTitle),
          elevation: 0,
        ),
        body: leadsAsync.when(
          data: (leads) {
            DebugLogger.debug('📨 LEAD_INBOX: Received ${leads.length} leads');
            if (leads.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 64,
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l.leadInboxEmptyTitle,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l.leadInboxEmptySubtitle,
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
              itemCount: leads.length,
              itemBuilder: (context, index) {
                final lead = leads[index];
                return _LeadCard(lead: lead);
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
                  l.leadInboxErrorTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  l.leadInboxErrorDetails('$error'),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );

      return TutorialTrigger(screen: TutorialScreen.leadInbox, child: scaffold);
    } catch (e, stackTrace) {
      DebugLogger.error(
        '📨 LEAD_INBOX: Error building LeadInboxPage',
        e,
        stackTrace,
      );

      // Return error widget for debugging
      final l = AppLocalizations.of(context);

      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => popOrGoHome(context, homeRoute: '/jobs'),
            icon: const Icon(Icons.arrow_back),
          ),
          title: Text(l.leadInboxFallbackTitle),
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                l.leadInboxFallbackMessage,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l.leadInboxFallbackError('$e'),
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

class _LeadCard extends ConsumerStatefulWidget {
  final Lead lead;

  const _LeadCard({required this.lead});

  @override
  ConsumerState<_LeadCard> createState() => _LeadCardState();
}

class _LeadCardState extends ConsumerState<_LeadCard> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

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
                        l.leadCardTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l.leadCardJobId(widget.lead.jobId),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
                _StatusChip(status: widget.lead.status),
              ],
            ),
            if (widget.lead.message.isNotEmpty) ...[
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
                      l.leadCardMessageLabel,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(widget.lead.message),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () => context.push('/jobs/${widget.lead.jobId}'),
                  icon: const Icon(Icons.visibility),
                  label: Text(l.leadViewJob),
                ),
                const Spacer(),
                if (widget.lead.status == LeadStatus.pending) ...[
                  OutlinedButton(
                    onPressed: _isLoading ? null : () => _declineLead(),
                    child: Text(l.leadDecline),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _isLoading ? null : () => _acceptLead(),
                    child: _isLoading
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l.leadAccept),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _acceptLead() async {
    if (widget.lead.id == null) return;

    setState(() {
      _isLoading = true;
    });

    final l = AppLocalizations.of(context);

    try {
      final controller = ref.read(leadsControllerProvider);
      await controller.acceptLead(widget.lead.id!);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l.leadSnackbarAcceptSuccess)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.leadSnackbarAcceptError('$e'))),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _declineLead() async {
    if (widget.lead.id == null) return;

    setState(() {
      _isLoading = true;
    });

    final l = AppLocalizations.of(context);

    try {
      final controller = ref.read(leadsControllerProvider);
      await controller.declineLead(widget.lead.id!);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l.leadSnackbarDeclineSuccess)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.leadSnackbarDeclineError('$e'))),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

class _StatusChip extends StatelessWidget {
  final LeadStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    Color backgroundColor;
    Color textColor;
    String text;

    switch (status) {
      case LeadStatus.pending:
        backgroundColor = Theme.of(context).colorScheme.primaryContainer;
        textColor = Theme.of(context).colorScheme.onPrimaryContainer;
        text = l.leadStatusPending;
        break;
      case LeadStatus.accepted:
        backgroundColor = Theme.of(context).colorScheme.tertiaryContainer;
        textColor = Theme.of(context).colorScheme.onTertiaryContainer;
        text = l.leadAccepted;
        break;
      case LeadStatus.declined:
        backgroundColor = Theme.of(context).colorScheme.errorContainer;
        textColor = Theme.of(context).colorScheme.onErrorContainer;
        text = l.leadDeclined;
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/payment.dart';
import '../../../core/models/payout.dart'; // Import for Transfer extensions
import '../logic/payouts_controller.dart';

/// Detail page for a specific transfer/payout
class PayoutDetailPage extends ConsumerWidget {
  final String transferId;

  const PayoutDetailPage({super.key, required this.transferId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transferAsync = ref.watch(transferProvider(transferId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Auszahlung Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(transferProvider(transferId));
            },
          ),
        ],
      ),
      body: transferAsync.when(
        data: (transfer) {
          if (transfer == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Auszahlung nicht gefunden',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          final bottomInset = MediaQuery.of(context).viewPadding.bottom;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header card with key info
                _buildHeaderCard(context, transfer),
                const SizedBox(height: 16),

                // Amount details
                _buildAmountCard(context, transfer),
                const SizedBox(height: 16),

                // Status and timestamps
                _buildStatusCard(context, transfer),
                const SizedBox(height: 16),

                // Stripe integration
                if (transfer.stripeTransferId != null) ...[
                  _buildStripeCard(context, transfer, ref),
                  const SizedBox(height: 16),
                ],

                // Technical details
                _buildTechnicalCard(context, transfer),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Fehler beim Laden der Auszahlung',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: const TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(transferProvider(transferId));
                },
                child: const Text('Erneut versuchen'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context, Transfer transfer) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Auszahlung',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                transfer.statusChip(context),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              transfer.formattedAmount,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: transfer.status == TransferStatus.completed
                    ? Colors.green
                    : transfer.status == TransferStatus.failed
                    ? Colors.red
                    : Colors.orange,
              ),
            ),
            if (transfer.id != null) ...[
              const SizedBox(height: 8),
              Text(
                'ID: ${transfer.id}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAmountCard(BuildContext context, Transfer transfer) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Beträge', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            _buildAmountRow('Nettobetrag', transfer.formattedAmountNet),
            if (transfer.amountGross != null)
              _buildAmountRow('Bruttobetrag', transfer.formattedAmountGross),
            _buildAmountRow('Plattformgebühr', transfer.formattedPlatformFee),
            if (transfer.amountGross != null) ...[
              const Divider(),
              _buildAmountRow(
                'Gebührenanteil',
                '${transfer.platformFeePercentage.toStringAsFixed(2)}%',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAmountRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, Transfer transfer) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status & Zeiten',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Status', transfer.statusLabel(context)),
            if (transfer.createdAt != null)
              _buildInfoRow('Erstellt', _formatDateTime(transfer.createdAt!)),
            if (transfer.releasedAt != null)
              _buildInfoRow(
                'Freigegeben',
                _formatDateTime(transfer.releasedAt!),
              ),
            if (transfer.completedAt != null)
              _buildInfoRow(
                'Abgeschlossen',
                _formatDateTime(transfer.completedAt!),
              ),
            if (transfer.manualRelease) ...[
              const Divider(),
              _buildInfoRow('Manuelle Freigabe', 'Ja'),
              if (transfer.releasedBy != null)
                _buildInfoRow('Freigegeben von', transfer.releasedBy!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStripeCard(
    BuildContext context,
    Transfer transfer,
    WidgetRef ref,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Stripe Integration',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Transfer ID', transfer.stripeTransferId!),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _openInStripe(transfer, ref, context),
                icon: const Icon(Icons.open_in_new),
                label: const Text('In Stripe Dashboard öffnen'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTechnicalCard(BuildContext context, Transfer transfer) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Technische Details',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Job ID', transfer.jobId),
            _buildInfoRow('Payment ID', transfer.paymentId),
            if (transfer.connectedAccountId.isNotEmpty)
              _buildInfoRow('Connected Account', transfer.connectedAccountId),
            _buildInfoRow('Währung', transfer.currency),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}.${dateTime.month}.${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _openInStripe(
    Transfer transfer,
    WidgetRef ref,
    BuildContext context,
  ) async {
    if (transfer.stripeTransferId == null) return;

    final controller = ref.read(payoutsControllerProvider.notifier);
    final success = await controller.openInStripe(transfer.stripeTransferId!);

    if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Stripe-Dashboard konnte nicht geöffnet werden'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }
}

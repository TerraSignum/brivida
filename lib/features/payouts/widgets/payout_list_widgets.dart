import 'package:flutter/material.dart';
import '../../../core/models/payment.dart';
import '../../../core/models/payout.dart'; // For Transfer extensions

/// Reusable widget for displaying transfer list items
class PayoutListItem extends StatelessWidget {
  final Transfer transfer;
  final VoidCallback? onTap;
  final VoidCallback? onOpenInStripe;

  const PayoutListItem({
    super.key,
    required this.transfer,
    this.onTap,
    this.onOpenInStripe,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with status and amount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  transfer.statusChip(context),
                  Text(
                    transfer.formattedAmount,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: transfer.status == TransferStatus.completed
                          ? Colors.green
                          : transfer.status == TransferStatus.failed
                          ? Colors.red
                          : Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Details row
              Row(
                children: [
                  Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    transfer.formattedDate,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Spacer(),
                  if (transfer.stripeTransferId != null &&
                      onOpenInStripe != null)
                    IconButton(
                      icon: const Icon(Icons.open_in_new, size: 16),
                      onPressed: onOpenInStripe,
                      tooltip: 'In Stripe öffnen',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),

              // Additional info if available
              if (transfer.amountGross != null || transfer.platformFee > 0) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (transfer.amountGross != null) ...[
                      Icon(Icons.euro, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        'Brutto: ${transfer.formattedAmountGross}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                    Icon(
                      Icons.account_balance,
                      size: 14,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Gebühr: ${transfer.formattedPlatformFee}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact transfer item for grid view
class PayoutGridItem extends StatelessWidget {
  final Transfer transfer;
  final VoidCallback? onTap;
  final VoidCallback? onOpenInStripe;

  const PayoutGridItem({
    super.key,
    required this.transfer,
    this.onTap,
    this.onOpenInStripe,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status and amount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: transfer.statusChip(context)),
                  Text(
                    transfer.formattedAmount,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: transfer.status == TransferStatus.completed
                          ? Colors.green
                          : transfer.status == TransferStatus.failed
                          ? Colors.red
                          : Colors.orange,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Date
              Text(
                transfer.formattedDate,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Spacer(),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (transfer.stripeTransferId != null &&
                      onOpenInStripe != null)
                    IconButton(
                      icon: const Icon(Icons.open_in_new, size: 16),
                      onPressed: onOpenInStripe,
                      tooltip: 'In Stripe öffnen',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget for empty state when no transfers are available
class EmptyPayoutsWidget extends StatelessWidget {
  const EmptyPayoutsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.account_balance_wallet, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Keine Auszahlungen verfügbar',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Auszahlungen erscheinen hier nach\nabgeschlossenen Jobs',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () {
              // Could navigate to job creation or help
            },
            icon: const Icon(Icons.help_outline),
            label: const Text('Mehr erfahren'),
          ),
        ],
      ),
    );
  }
}

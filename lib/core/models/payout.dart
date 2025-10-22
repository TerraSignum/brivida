import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'payment.dart'; // Import existing payment models

part 'payout.freezed.dart';
part 'payout.g.dart';

@freezed
abstract class PayoutFilter with _$PayoutFilter {
  const factory PayoutFilter({
    DateTime? from,
    DateTime? to,
    String? status, // 'all', 'created', 'failed'
  }) = _PayoutFilter;

  factory PayoutFilter.fromJson(Map<String, dynamic> json) =>
      _$PayoutFilterFromJson(json);
}

@freezed
abstract class ExportRequest with _$ExportRequest {
  const factory ExportRequest({
    DateTime? from,
    DateTime? to,
    @Default('transfers') String kind,
  }) = _ExportRequest;

  factory ExportRequest.fromJson(Map<String, dynamic> json) =>
      _$ExportRequestFromJson(json);
}

@freezed
abstract class ExportResult with _$ExportResult {
  const factory ExportResult({
    required String downloadUrl,
    required String filename,
    required DateTime expiresAt,
  }) = _ExportResult;

  factory ExportResult.fromJson(Map<String, dynamic> json) =>
      _$ExportResultFromJson(json);
}

/// Transfer status for better UI handling
enum TransferStatusFilter {
  all,
  created,
  failed;

  String label(BuildContext context) {
    switch (this) {
      case TransferStatusFilter.all:
        return context.tr('payouts.filters.all');
      case TransferStatusFilter.created:
        return context.tr('payouts.status.created');
      case TransferStatusFilter.failed:
        return context.tr('payouts.status.failed');
    }
  }

  String? get apiValue {
    switch (this) {
      case TransferStatusFilter.all:
        return null;
      case TransferStatusFilter.created:
        return 'created';
      case TransferStatusFilter.failed:
        return 'failed';
    }
  }
}

/// Extensions for Transfer model enhancements
extension TransferExtensions on Transfer {
  /// Get platform fee percentage
  double get platformFeePercentage => amountGross != null && amountGross! > 0
      ? (platformFee / amountGross!) * 100
      : 0.0;

  /// Format amount for display
  String get formattedAmount => '${amountNet.toStringAsFixed(2)} €';

  String get formattedAmountNet => '${amountNet.toStringAsFixed(2)} €';

  String get formattedAmountGross =>
      amountGross != null ? '${amountGross!.toStringAsFixed(2)} €' : 'N/A';

  String get formattedPlatformFee => '${platformFee.toStringAsFixed(2)} €';

  /// Get status display string
  String statusLabel(BuildContext context) {
    switch (status) {
      case TransferStatus.pending:
        return context.tr('payouts.status.pending');
      case TransferStatus.completed:
        return context.tr('payouts.status.completed');
      case TransferStatus.failed:
        return context.tr('payouts.status.failed');
    }
  }

  /// Get status color for UI
  Color get statusColor {
    switch (status) {
      case TransferStatus.pending:
        return Colors.orange;
      case TransferStatus.completed:
        return Colors.green;
      case TransferStatus.failed:
        return Colors.red;
    }
  }

  /// Get status chip widget
  Widget statusChip(BuildContext context) {
    return Chip(
      label: Text(
        statusLabel(context),
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: statusColor,
    );
  }

  /// Check if can be retried
  bool get canRetry => status == TransferStatus.failed;

  /// Get Stripe dashboard URL (test mode)
  String? get stripeUrl => stripeTransferId != null
      ? 'https://dashboard.stripe.com/test/connect/transfers/$stripeTransferId'
      : null;

  /// Get formatted date strings
  String get formattedDate => createdAt?.toString().split(' ')[0] ?? 'N/A';
  String? get formattedCreatedAt => createdAt?.toString();
  String? get formattedReleasedAt => releasedAt?.toString();
  String? get formattedCompletedAt => completedAt?.toString();
}

/// Simple stats model for transfers
@freezed
abstract class TransferStats with _$TransferStats {
  const factory TransferStats({
    @Default(0) int totalCount,
    @Default(0.0) double totalAmountNet,
    @Default(0.0) double totalAmountGross,
    @Default(0.0) double totalPlatformFees,
    @Default(0) int pendingCount,
    @Default(0) int completedCount,
    @Default(0) int failedCount,
  }) = _TransferStats;

  factory TransferStats.fromJson(Map<String, dynamic> json) =>
      _$TransferStatsFromJson(json);
}

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/utils/debug_logger.dart';

/// Server-side KPI computation service
/// Provides lightweight client interface for server-computed KPI aggregations
class KpiService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  /// Get aggregated KPI summary from server
  /// Optional date range for filtering (ISO string format)
  Future<Map<String, dynamic>> getKpiSummary({
    String? startDate,
    String? endDate,
  }) async {
    try {
      DebugLogger.debug('🔥 KPI_SERVICE: Requesting KPI summary from server');

      final callable = _functions.httpsCallable('getKpiSummaryCF');
      final result = await callable.call({
        if (startDate != null) 'startDate': startDate,
        if (endDate != null) 'endDate': endDate,
      });

      DebugLogger.debug('✅ KPI_SERVICE: KPI summary received successfully');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      DebugLogger.error('❌ KPI_SERVICE: Error getting KPI summary: $e');
      rethrow;
    }
  }

  /// Get advanced analytics metrics computed server-side
  Future<Map<String, dynamic>> getAdvancedMetrics() async {
    try {
      DebugLogger.debug(
          '🔥 KPI_SERVICE: Requesting advanced metrics from server');

      final callable = _functions.httpsCallable('getAdvancedMetricsCF');
      final result = await callable.call();

      DebugLogger.debug(
          '✅ KPI_SERVICE: Advanced metrics received successfully');
      return Map<String, dynamic>.from(result.data);
    } catch (e) {
      DebugLogger.error('❌ KPI_SERVICE: Error getting advanced metrics: $e');
      rethrow;
    }
  }

  /// Convert date range to ISO strings for server calls
  static Map<String, String> dateRangeToServerFormat(DateTimeRange dateRange) {
    return {
      'startDate': dateRange.start.toIso8601String(),
      'endDate': dateRange.end.toIso8601String(),
    };
  }
}

/// Predefined date ranges for analytics
class AnalyticsDateRanges {
  static DateTimeRange get last7Days {
    final now = DateTime.now();
    return DateTimeRange(
      start: now.subtract(const Duration(days: 7)),
      end: now,
    );
  }

  static DateTimeRange get last30Days {
    final now = DateTime.now();
    return DateTimeRange(
      start: now.subtract(const Duration(days: 30)),
      end: now,
    );
  }

  static DateTimeRange get currentMonth {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    return DateTimeRange(
      start: startOfMonth,
      end: now,
    );
  }

  static DateTimeRange get previousMonth {
    final now = DateTime.now();
    final startOfPrevMonth = DateTime(now.year, now.month - 1, 1);
    final endOfPrevMonth = DateTime(now.year, now.month, 0);
    return DateTimeRange(
      start: startOfPrevMonth,
      end: endOfPrevMonth,
    );
  }
}

/// Provider for KPI Service
final kpiServiceProvider = Provider<KpiService>((ref) {
  return KpiService();
});

/// Provider for server-computed KPI summary
final serverKpiSummaryProvider =
    FutureProvider.family<Map<String, dynamic>, DateTimeRange?>(
        (ref, dateRange) async {
  final kpiService = ref.read(kpiServiceProvider);

  if (dateRange != null) {
    final serverDateRange = KpiService.dateRangeToServerFormat(dateRange);
    return await kpiService.getKpiSummary(
      startDate: serverDateRange['startDate'],
      endDate: serverDateRange['endDate'],
    );
  } else {
    return await kpiService.getKpiSummary();
  }
});

/// Provider for server-computed advanced metrics
final serverAdvancedMetricsProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  final kpiService = ref.read(kpiServiceProvider);
  return await kpiService.getAdvancedMetrics();
});

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Centralized debug logging that respects build mode and can be toggled
class DebugLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  static final Map<String, Stopwatch> _timers = {};

  /// Log debug information (only in debug mode)
  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.d('🔍 $message', error: error, stackTrace: stackTrace);
    }
  }

  /// Log info (only in debug mode)
  static void info(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.i('ℹ️ $message', error: error, stackTrace: stackTrace);
    }
  }

  /// Generic log helper for migrating legacy print statements
  static void log(Object? message) {
    if (kDebugMode) {
      _logger.d('📝 ${message ?? 'null'}');
    }
  }

  /// Log warning (always shown)
  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w('⚠️ $message', error: error, stackTrace: stackTrace);
  }

  /// Log error (always shown)
  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e('❌ $message', error: error, stackTrace: stackTrace);
  }

  /// Log fatal error (always shown)
  static void fatal(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f('💀 $message', error: error, stackTrace: stackTrace);
  }

  /// Log function entry (only in debug mode)
  static void enter(String functionName, [Map<String, dynamic>? params]) {
    if (kDebugMode) {
      final paramsStr = params != null ? ' with params: $params' : '';
      _logger.d('🟢 ENTER: $functionName$paramsStr');
    }
  }

  /// Log function exit (only in debug mode)
  static void exit(String functionName, [dynamic result]) {
    if (kDebugMode) {
      final resultStr = result != null ? ' -> $result' : '';
      _logger.d('🔴 EXIT: $functionName$resultStr');
    }
  }

  /// Log state change (only in debug mode)
  static void stateChange(String component, String from, String to,
      [Map<String, dynamic>? data]) {
    if (kDebugMode) {
      final dataStr = data != null ? ' data: $data' : '';
      _logger.d('🔄 STATE: $component: $from -> $to$dataStr');
    }
  }

  /// Log API call (only in debug mode)
  static void apiCall(String method, String endpoint,
      [Map<String, dynamic>? payload]) {
    if (kDebugMode) {
      final payloadStr = payload != null ? ' payload: $payload' : '';
      _logger.d('🌐 API: $method $endpoint$payloadStr');
    }
  }

  /// Log API response (only in debug mode)
  static void apiResponse(String endpoint, int statusCode, [dynamic response]) {
    if (kDebugMode) {
      final responseStr = response != null ? ' response: $response' : '';
      _logger.d('🌐 API RESPONSE: $endpoint [$statusCode]$responseStr');
    }
  }

  /// Log navigation (only in debug mode)
  static void navigation(String from, String to,
      [Map<String, dynamic>? params]) {
    if (kDebugMode) {
      final paramsStr = params != null ? ' params: $params' : '';
      _logger.d('🧭 NAV: $from -> $to$paramsStr');
    }
  }

  /// Log user action (only in debug mode)
  static void userAction(String action, [Map<String, dynamic>? details]) {
    if (kDebugMode) {
      final detailsStr = details != null ? ' details: $details' : '';
      _logger.d('👤 USER: $action$detailsStr');
    }
  }

  /// Log performance measurement (only in debug mode)
  static void performance(String operation, Duration duration,
      [Map<String, dynamic>? metrics]) {
    if (kDebugMode) {
      final metricsStr = metrics != null ? ' metrics: $metrics' : '';
      _logger.d(
          '⏱️ PERF: $operation took ${duration.inMilliseconds}ms$metricsStr');
    }
  }

  /// Start performance timer (only in debug mode)
  static void startTimer(String timerId) {
    if (kDebugMode) {
      _timers[timerId] = Stopwatch()..start();
      _logger.d('⏱️ START TIMER: $timerId');
    }
  }

  /// Stop performance timer and log result (only in debug mode)
  static Duration? stopTimer(String timerId, [String? operation]) {
    if (kDebugMode && _timers.containsKey(timerId)) {
      final timer = _timers[timerId]!..stop();
      final duration = timer.elapsed;
      final opStr = operation != null ? ' for $operation' : '';
      _logger
          .d('⏱️ STOP TIMER: $timerId$opStr -> ${duration.inMilliseconds}ms');
      _timers.remove(timerId);
      return duration;
    }
    return null;
  }

  /// Log widget lifecycle (only in debug mode)
  static void lifecycle(String widget, String event,
      [Map<String, dynamic>? data]) {
    if (kDebugMode) {
      final dataStr = data != null ? ' data: $data' : '';
      _logger.d('🏗️ LIFECYCLE: $widget.$event$dataStr');
    }
  }

  /// Log database operation (only in debug mode)
  static void database(String operation, String collection,
      [Map<String, dynamic>? query]) {
    if (kDebugMode) {
      final queryStr = query != null ? ' query: $query' : '';
      _logger.d('🗄️ DB: $operation on $collection$queryStr');
    }
  }

  /// Log cache operation (only in debug mode)
  static void cache(String operation, String key, [dynamic value]) {
    if (kDebugMode) {
      final valueStr = value != null ? ' value: $value' : '';
      _logger.d('💾 CACHE: $operation $key$valueStr');
    }
  }

  /// Log with custom emoji and category (only in debug mode)
  static void custom(String emoji, String category, String message,
      [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.d('$emoji $category: $message',
          error: error, stackTrace: stackTrace);
    }
  }
}

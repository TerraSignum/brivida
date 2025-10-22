// Web plugin registrant wrapper
// This file handles the registration of Flutter web plugins

import 'package:flutter/foundation.dart';
import 'core/utils/debug_logger.dart';

void registerPlugins() {
  if (kIsWeb) {
    try {
      // Dynamic import to avoid compilation issues
      // The actual registerPlugins will be available after first web build
      // ignore: undefined_function
      registerWebPlugins();
    } catch (e) {
      // Ignore errors during initial compilation
      DebugLogger.log('Web plugins not yet available: $e');
    }
  }
}

// This will be replaced by the generated file
void registerWebPlugins() {
  // Stub implementation
}

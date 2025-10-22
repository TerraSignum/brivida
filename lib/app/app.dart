import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../core/utils/debug_logger.dart';
import '../core/widgets/mock_data_debug_widget.dart';
import '../core/widgets/back_navigation_guard.dart';
import '../features/notifications/ui/notification_service.dart';
import 'router.dart';

class BrividaApp extends StatelessWidget {
  const BrividaApp({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      DebugLogger.debug('🎨 APP: Building BrividaApp widget...');

      DebugLogger.debug('🌍 APP: Checking EasyLocalization context...');
      final localizationDelegates = context.localizationDelegates;
      final supportedLocales = context.supportedLocales;
      final locale = context.locale;

      DebugLogger.debug(
        '🌍 APP: Localization delegates count: ${localizationDelegates.length}',
      );
      DebugLogger.debug(
        '🌍 APP: Supported locales count: ${supportedLocales.length}',
      );
      DebugLogger.debug('🌍 APP: Current locale: $locale');

      DebugLogger.debug('🧭 APP: Checking router...');
      DebugLogger.debug('✅ APP: appRouter is available (non-nullable)');

      DebugLogger.debug('🎨 APP: Creating MaterialApp.router...');
      final app = MockDataDebugWidget(
        child: NotificationInitializer(
          child: BackNavigationGuard(
            child: MaterialApp.router(
              title: 'Brivida',
              routerConfig: appRouter,
              localizationsDelegates: localizationDelegates,
              supportedLocales: supportedLocales,
              locale: locale,
              theme: ThemeData(
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              debugShowCheckedModeBanner: false,
            ),
          ),
        ),
      );

      DebugLogger.debug('✅ APP: BrividaApp built successfully');
      return app;
    } catch (e, stackTrace) {
      DebugLogger.error('❌ APP: Error building BrividaApp', e, stackTrace);

      // Return error widget
      return MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.red[100],
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'App Build Error',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Error: $e',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

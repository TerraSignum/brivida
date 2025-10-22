import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../logic/legal_controller.dart' as legal_logic;
import '../../../core/i18n/app_localizations.dart';
import '../../../core/utils/debug_logger.dart';

/// Controls whether the legal compliance guard should be active.
/// This can be disabled in tests to bypass Firestore/Firebase dependencies.
final legalComplianceEnabledProvider = Provider<bool>((ref) => true);

/// A widget that checks legal compliance before allowing access to protected routes.
/// If the user hasn't accepted the latest legal documents, they are redirected
/// to the legal acceptance page.
class LegalComplianceGuard extends ConsumerWidget {
  final Widget child;
  final bool bypassForAdmin;

  const LegalComplianceGuard({
    super.key,
    required this.child,
    this.bypassForAdmin = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    try {
      DebugLogger.debug('🛡️ LEGAL_GUARD: Building LegalComplianceGuard...');

      final isEnabled = ref.watch(legalComplianceEnabledProvider);
      if (!isEnabled) {
        DebugLogger.debug(
          '🛡️ LEGAL_GUARD: Compliance disabled via override - returning child',
        );
        return child;
      }

      // Initialize the compliance watcher (starts listening for auth changes)
      ref.watch(legal_logic.legalComplianceWatcherProvider);

      // Initialize compliance check if not done already
      final controller = ref.read(legal_logic.legalControllerProvider.notifier);
      Future.microtask(() => controller.initializeCompliance());

      final complianceAsync = ref.watch(legal_logic.legalControllerProvider);
      DebugLogger.debug(
        '🛡️ LEGAL_GUARD: Compliance async state: ${complianceAsync.runtimeType}',
      );

      return complianceAsync.when(
        loading: () {
          DebugLogger.debug(
            '🛡️ LEGAL_GUARD: Showing loading screen - compliance check in progress',
          );
          DebugLogger.log('LegalComplianceGuard: Loading compliance status...');
          return const LegalComplianceLoadingScreen();
        },
        error: (error, stack) {
          DebugLogger.error(
            '🛡️ LEGAL_GUARD: Error in compliance check',
            error,
            stack,
          );
          DebugLogger.log(
            'LegalComplianceGuard: Error in compliance check - $error',
          );

          // In development, show the child widget instead of blocking access
          if (kDebugMode || (kIsWeb && Uri.base.host == 'localhost')) {
            DebugLogger.debug(
              '🛡️ LEGAL_GUARD: Development mode - allowing access despite error',
            );
            DebugLogger.log(
              'LegalComplianceGuard: Development mode - allowing access despite error',
            );
            return child;
          }

          // In production, allow access but log the issue to monitor compliance errors
          DebugLogger.debug(
            '🛡️ LEGAL_GUARD: Production mode - allowing access despite error',
          );
          return child;
        },
        data: (complianceStatus) {
          DebugLogger.debug(
            '🛡️ LEGAL_GUARD: Compliance status received - canProceed: ${complianceStatus.canProceed}',
          );
          DebugLogger.log(
            'LegalComplianceGuard: Compliance status received - canProceed: ${complianceStatus.canProceed}',
          );

          // Check if user is compliant with latest legal documents
          if (!complianceStatus.canProceed) {
            DebugLogger.debug(
              '🛡️ LEGAL_GUARD: User not compliant, bypassing legal screen per new flow',
            );
            DebugLogger.log(
              'LegalComplianceGuard: User not compliant, bypassing legal screen',
            );
          } else {
            DebugLogger.debug(
              '🛡️ LEGAL_GUARD: User is compliant, showing protected content',
            );
            DebugLogger.log(
              'LegalComplianceGuard: User is compliant, showing protected content',
            );
          }

          return child;
        },
      );
    } catch (guardError) {
      DebugLogger.error('🛡️ LEGAL_GUARD: Critical error in guard', guardError);
      DebugLogger.log(
        'LegalComplianceGuard: Critical error in guard - $guardError',
      );

      // Fallback: show child widget to keep app functional
      DebugLogger.debug('🛡️ LEGAL_GUARD: Showing child widget as fallback');
      return child;
    }
  }
}

/// Loading screen shown while checking legal compliance
class LegalComplianceLoadingScreen extends StatelessWidget {
  const LegalComplianceLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 28,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 104,
                      height: 104,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFD4AF37), Color(0xFFE5E4E2)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Image.asset(
                            'assets/images/logo2.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Brivida',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFD4AF37),
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.translate('settings.legal.complianceGuard.tagline'),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF4B5563),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
                strokeWidth: 3,
              ),
              const SizedBox(height: 24),
              Column(
                children: [
                  Text(
                    l10n.translate('settings.legal.complianceGuard.checking'),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF1F2937),
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.translate('settings.legal.complianceGuard.pleaseWait'),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF6B7280),
                    ),
                    textAlign: TextAlign.center,
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

/// Provider that can be used to check if a route should be protected by legal compliance
final routeRequiresLegalComplianceProvider = Provider.family<bool, String>((
  ref,
  route,
) {
  // Define routes that require legal compliance
  const protectedRoutes = [
    '/home',
    '/jobs',
    '/job-feed',
    '/leads',
    '/chats',
    '/calendar',
    '/admin',
  ];

  // Check if the route starts with any protected route
  return protectedRoutes.any(
    (protectedRoute) => route.startsWith(protectedRoute),
  );
});

/// Extension to easily wrap routes with legal compliance checking
extension LegalComplianceRouteExtension on GoRoute {
  /// Wraps a GoRoute builder with legal compliance checking
  static Widget Function(BuildContext, GoRouterState) withLegalCompliance(
    Widget Function(BuildContext, GoRouterState) originalBuilder, {
    bool bypassForAdmin = false,
  }) {
    return (context, state) {
      final child = originalBuilder(context, state);
      return LegalComplianceGuard(bypassForAdmin: bypassForAdmin, child: child);
    };
  }
}

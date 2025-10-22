import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import '../core/utils/debug_logger.dart';
import '../core/config/admin_whitelist.dart';
import '../features/auth/ui/sign_in_page.dart';
import '../features/auth/ui/sign_up_page.dart';
import '../features/home/ui/home_page.dart';
import '../features/jobs/ui/job_form_page.dart';
import '../features/jobs/ui/job_list_page.dart';
import '../features/jobs/ui/job_detail_page.dart';
import '../features/jobs/ui/job_completion_page.dart';
import '../features/leads/ui/lead_inbox_page.dart';
import '../features/leads/ui/job_feed_page.dart';
import '../features/chat/ui/chat_list_page.dart';
import '../features/chat/ui/chat_page.dart';
import '../features/calendar/ui/calendar_page.dart';
import '../features/disputes/ui/dispute_detail_page.dart';
import '../features/finance/ui/finance_overview_page.dart';
import '../features/payouts/ui/payouts_page.dart';
import '../features/payouts/ui/payout_detail_page.dart';
import '../features/admin/ui/admin_dashboard_page.dart';
import '../features/admin/ui/admin_pro_detail_page.dart';
import '../features/admin/ui/analytics/admin_analytics_page.dart';
import '../features/admin/ui/admin_system_page.dart';
import '../features/admin_services/ui/oficializa_te_page.dart';
import '../features/admin_services/ui/admin_services_page.dart';
import '../features/admin_services/ui/admin_service_success_page.dart';
import '../features/legal/ui/legal_viewer_page.dart';
import '../features/legal/ui/legal_compliance_guard.dart';
import '../core/models/legal.dart';
import '../features/notifications/ui/notifications_page.dart';
import '../features/offers/ui/pro_offers_page.dart';
import '../features/offers/ui/offer_search_page.dart';
import '../features/settings/ui/settings_page.dart';

// Helper function to check admin role
@visibleForTesting
FirebaseAuth Function() firebaseAuthFactory = () => FirebaseAuth.instance;

Future<bool> _isUserAdmin() async {
  try {
    final user = firebaseAuthFactory().currentUser;
    if (user == null) return false;

    final idTokenResult = await user.getIdTokenResult();
    final claims = idTokenResult.claims;

    return claims?['role'] == 'admin' || AdminWhitelist.contains(user.email);
  } catch (e) {
    DebugLogger.error('❌ ROUTER: Error checking admin status', e);
    return false;
  }
}

final appRouter = GoRouter(
  initialLocation: '/sign-in',
  routes: [
    GoRoute(
      path: '/sign-in',
      builder: (context, state) {
        try {
          DebugLogger.debug('🧭 ROUTER: Building SignInPage');
          return const SignInPage();
        } catch (e, stackTrace) {
          DebugLogger.error(
            '❌ ROUTER: Error building SignInPage',
            e,
            stackTrace,
          );
          rethrow;
        }
      },
    ),
    GoRoute(
      path: '/sign-up',
      builder: (context, state) {
        try {
          DebugLogger.debug('🧭 ROUTER: Building SignUpPage');
          return const SignUpPage();
        } catch (e, stackTrace) {
          DebugLogger.error(
            '❌ ROUTER: Error building SignUpPage',
            e,
            stackTrace,
          );
          rethrow;
        }
      },
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) {
        try {
          DebugLogger.debug(
            '🧭 ROUTER: Building HomePage with Legal Compliance Guard',
          );
          return const LegalComplianceGuard(child: HomePage());
        } catch (e, stackTrace) {
          DebugLogger.error('❌ ROUTER: Error building HomePage', e, stackTrace);
          rethrow;
        }
      },
      redirect: (context, state) {
        try {
          DebugLogger.debug('🧭 ROUTER: Checking auth redirect for /home');
          final user = firebaseAuthFactory().currentUser;
          if (user == null) {
            DebugLogger.debug(
              '🧭 ROUTER: User not authenticated, redirecting to sign-in',
            );
            return '/sign-in';
          }
          DebugLogger.debug(
            '🧭 ROUTER: User authenticated, allowing access to /home',
          );
          return null; // Allow access
        } catch (e, stackTrace) {
          DebugLogger.error('❌ ROUTER: Error in home redirect', e, stackTrace);
          return '/sign-in'; // Safe fallback
        }
      },
    ),
    // Jobs routes (Customer)
    GoRoute(
      path: '/jobs',
      builder: (context, state) =>
          const LegalComplianceGuard(child: JobListPage()),
      redirect: (context, state) {
        final user = firebaseAuthFactory().currentUser;
        if (user == null) {
          return '/sign-in';
        }
        return null;
      },
    ),
    GoRoute(
      path: '/jobs/new',
      builder: (context, state) =>
          const LegalComplianceGuard(child: JobFormPage()),
      redirect: (context, state) {
        final user = firebaseAuthFactory().currentUser;
        if (user == null) {
          return '/sign-in';
        }
        return null;
      },
    ),
    GoRoute(
      path: '/jobs/:id',
      builder: (context, state) {
        final jobId = state.pathParameters['id']!;
        return LegalComplianceGuard(child: JobDetailPage(jobId: jobId));
      },
      redirect: (context, state) {
        final user = firebaseAuthFactory().currentUser;
        if (user == null) {
          return '/sign-in';
        }
        return null;
      },
    ),
    GoRoute(
      path: '/jobs/:id/completion',
      builder: (context, state) {
        final jobId = state.pathParameters['id']!;
        return LegalComplianceGuard(child: JobCompletionPage(jobId: jobId));
      },
      redirect: (context, state) {
        final user = firebaseAuthFactory().currentUser;
        if (user == null) {
          return '/sign-in';
        }
        return null;
      },
    ),
    // Leads routes (Pro)
    GoRoute(
      path: '/leads',
      builder: (context, state) =>
          const LegalComplianceGuard(child: LeadInboxPage()),
      redirect: (context, state) {
        final user = firebaseAuthFactory().currentUser;
        if (user == null) {
          return '/sign-in';
        }
        return null;
      },
    ),
    GoRoute(
      path: ProOffersPage.routeName,
      builder: (context, state) =>
          const LegalComplianceGuard(child: ProOffersPage()),
      redirect: (context, state) {
        final user = firebaseAuthFactory().currentUser;
        if (user == null) {
          return '/sign-in';
        }
        return null;
      },
    ),
    GoRoute(
      path: '/job-feed',
      builder: (context, state) =>
          const LegalComplianceGuard(child: JobFeedPage()),
      redirect: (context, state) {
        final user = firebaseAuthFactory().currentUser;
        if (user == null) {
          return '/sign-in';
        }
        return null;
      },
    ),
    GoRoute(
      path: OfferSearchPage.routeName,
      builder: (context, state) =>
          const LegalComplianceGuard(child: OfferSearchPage()),
      redirect: (context, state) {
        final user = firebaseAuthFactory().currentUser;
        if (user == null) {
          return '/sign-in';
        }
        return null;
      },
    ),
    // Calendar route (Pro)
    GoRoute(
      path: '/calendar',
      builder: (context, state) =>
          const LegalComplianceGuard(child: CalendarPage()),
      redirect: (context, state) {
        final user = firebaseAuthFactory().currentUser;
        if (user == null) {
          return '/sign-in';
        }
        return null;
      },
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) {
        try {
          DebugLogger.debug('🧭 ROUTER: Building SettingsPage');
          return const LegalComplianceGuard(child: SettingsPage());
        } catch (e, stackTrace) {
          DebugLogger.error(
            '❌ ROUTER: Error building SettingsPage',
            e,
            stackTrace,
          );
          rethrow;
        }
      },
      redirect: (context, state) {
        final user = firebaseAuthFactory().currentUser;
        if (user == null) {
          DebugLogger.debug(
            '🧭 ROUTER: Settings route - user not authenticated',
          );
          return '/sign-in';
        }
        return null;
      },
    ),
    // Chat routes
    GoRoute(
      path: '/chats',
      builder: (context, state) =>
          const LegalComplianceGuard(child: ChatListPage()),
      redirect: (context, state) {
        final user = firebaseAuthFactory().currentUser;
        if (user == null) {
          return '/sign-in';
        }
        return null;
      },
    ),
    GoRoute(
      path: '/chat/:chatId',
      builder: (context, state) {
        final chatId = state.pathParameters['chatId']!;
        return LegalComplianceGuard(child: ChatPage(chatId: chatId));
      },
      redirect: (context, state) {
        final user = firebaseAuthFactory().currentUser;
        if (user == null) {
          return '/sign-in';
        }
        return null;
      },
    ),

    // Dispute routes
    GoRoute(
      path: '/disputes/:caseId',
      builder: (context, state) {
        try {
          final caseId = state.pathParameters['caseId']!;
          DebugLogger.debug(
            '🧭 ROUTER: Building DisputeDetailPage for case: $caseId with Legal Compliance Guard',
          );
          return LegalComplianceGuard(child: DisputeDetailPage(caseId: caseId));
        } catch (e, stackTrace) {
          DebugLogger.error(
            '❌ ROUTER: Error building DisputeDetailPage',
            e,
            stackTrace,
          );
          rethrow;
        }
      },
    ),

    // Admin routes (restricted to admin users)
    GoRoute(
      path: '/admin',
      builder: (context, state) {
        try {
          DebugLogger.debug(
            '🧭 ROUTER: Building AdminDashboardPage with Legal Compliance Guard',
          );
          return const LegalComplianceGuard(child: AdminDashboardPage());
        } catch (e, stackTrace) {
          DebugLogger.error(
            '❌ ROUTER: Error building AdminDashboardPage',
            e,
            stackTrace,
          );
          rethrow;
        }
      },
      redirect: (context, state) async {
        final user = firebaseAuthFactory().currentUser;
        if (user == null) {
          DebugLogger.debug('🧭 ROUTER: Admin route - user not authenticated');
          return '/sign-in';
        }

        final isAdmin = await _isUserAdmin();
        if (!isAdmin) {
          DebugLogger.debug(
            '🧭 ROUTER: Admin route - user not admin, redirecting to home',
          );
          return '/home';
        }

        DebugLogger.debug(
          '🧭 ROUTER: Admin route - user is admin, allowing access',
        );
        return null;
      },
    ),
    GoRoute(
      path: '/admin/pro/:proUid',
      builder: (context, state) {
        try {
          final proUid = state.pathParameters['proUid']!;
          DebugLogger.debug(
            '🧭 ROUTER: Building AdminProDetailPage for pro: $proUid with Legal Compliance Guard',
          );
          return LegalComplianceGuard(
            child: AdminProDetailPage(proUid: proUid),
          );
        } catch (e, stackTrace) {
          DebugLogger.error(
            '❌ ROUTER: Error building AdminProDetailPage',
            e,
            stackTrace,
          );
          rethrow;
        }
      },
      redirect: (context, state) async {
        final user = firebaseAuthFactory().currentUser;
        if (user == null) {
          DebugLogger.debug(
            '🧭 ROUTER: Admin pro detail route - user not authenticated',
          );
          return '/sign-in';
        }

        final isAdmin = await _isUserAdmin();
        if (!isAdmin) {
          DebugLogger.debug(
            '🧭 ROUTER: Admin pro detail route - user not admin, redirecting to home',
          );
          return '/home';
        }

        DebugLogger.debug(
          '🧭 ROUTER: Admin pro detail route - user is admin, allowing access',
        );
        return null;
      },
    ),

    // Admin Analytics route
    GoRoute(
      path: '/admin/analytics',
      builder: (context, state) {
        try {
          DebugLogger.debug(
            '🧭 ROUTER: Building AdminAnalyticsPage with Legal Compliance Guard',
          );
          return const LegalComplianceGuard(child: AdminAnalyticsPage());
        } catch (e, stackTrace) {
          DebugLogger.error(
            '❌ ROUTER: Error building AdminAnalyticsPage',
            e,
            stackTrace,
          );
          rethrow;
        }
      },
      redirect: (context, state) async {
        final user = firebaseAuthFactory().currentUser;
        if (user == null) {
          DebugLogger.debug(
            '🧭 ROUTER: Admin analytics route - user not authenticated',
          );
          return '/sign-in';
        }

        final isAdmin = await _isUserAdmin();
        if (!isAdmin) {
          DebugLogger.debug(
            '🧭 ROUTER: Admin analytics route - user not admin, redirecting to home',
          );
          return '/home';
        }

        DebugLogger.debug(
          '🧭 ROUTER: Admin analytics route - user is admin, allowing access',
        );
        return null;
      },
    ),

    // Admin System Configuration route
    GoRoute(
      path: '/admin/system',
      builder: (context, state) {
        try {
          DebugLogger.debug(
            '🧭 ROUTER: Building AdminSystemPage with Legal Compliance Guard',
          );
          return const LegalComplianceGuard(child: AdminSystemPage());
        } catch (e, stackTrace) {
          DebugLogger.error(
            '❌ ROUTER: Error building AdminSystemPage',
            e,
            stackTrace,
          );
          rethrow;
        }
      },
      redirect: (context, state) async {
        final user = firebaseAuthFactory().currentUser;
        if (user == null) {
          DebugLogger.debug(
            '🧭 ROUTER: Admin system route - user not authenticated',
          );
          return '/sign-in';
        }

        final isAdmin = await _isUserAdmin();
        if (!isAdmin) {
          DebugLogger.debug(
            '🧭 ROUTER: Admin system route - user not admin, redirecting to home',
          );
          return '/home';
        }

        DebugLogger.debug(
          '🧭 ROUTER: Admin system route - user is admin, allowing access',
        );
        return null;
      },
    ),

    // Admin Services routes (for Pro users)
    GoRoute(
      path: '/oficializa-te',
      builder: (context, state) {
        try {
          DebugLogger.debug('🧭 ROUTER: Building OficializaTePage');
          return const LegalComplianceGuard(child: OficializaTePage());
        } catch (e, stackTrace) {
          DebugLogger.error(
            '❌ ROUTER: Error building OficializaTePage',
            e,
            stackTrace,
          );
          rethrow;
        }
      },
      redirect: (context, state) async {
        final user = firebaseAuthFactory().currentUser;
        if (user == null) {
          DebugLogger.debug(
            '🧭 ROUTER: Oficializa-te route - user not authenticated',
          );
          return '/sign-in';
        }

        // Check if user is pro (can access admin services)
        try {
          final idTokenResult = await user.getIdTokenResult();
          final claims = idTokenResult.claims;
          final role = claims?['role'];

          if (role != 'pro') {
            DebugLogger.debug(
              '🧭 ROUTER: Oficializa-te route - user not pro, redirecting to home',
            );
            return '/home';
          }
        } catch (e) {
          DebugLogger.debug(
            '🧭 ROUTER: Error checking user role for Oficializa-te: $e',
          );
          return '/home';
        }

        DebugLogger.debug(
          '🧭 ROUTER: Oficializa-te route - user is pro, allowing access',
        );
        return null;
      },
    ),

    // Admin Services success page
    GoRoute(
      path: '/admin-services/success',
      builder: (context, state) {
        try {
          final sessionId = state.uri.queryParameters['session_id'];
          final adminServiceId = state.uri.queryParameters['admin_service_id'];

          DebugLogger.debug('🧭 ROUTER: Building AdminServiceSuccessPage');
          return LegalComplianceGuard(
            child: AdminServiceSuccessPage(
              sessionId: sessionId,
              adminServiceId: adminServiceId,
            ),
          );
        } catch (e, stackTrace) {
          DebugLogger.error(
            '❌ ROUTER: Error building AdminServiceSuccessPage',
            e,
            stackTrace,
          );
          rethrow;
        }
      },
    ),

    // Admin Services management (admin only)
    GoRoute(
      path: '/admin/services',
      builder: (context, state) {
        try {
          DebugLogger.debug('🧭 ROUTER: Building AdminServicesPage');
          return const LegalComplianceGuard(child: AdminServicesPage());
        } catch (e, stackTrace) {
          DebugLogger.error(
            '❌ ROUTER: Error building AdminServicesPage',
            e,
            stackTrace,
          );
          rethrow;
        }
      },
      redirect: (context, state) async {
        final user = firebaseAuthFactory().currentUser;
        if (user == null) {
          DebugLogger.debug(
            '🧭 ROUTER: Admin services route - user not authenticated',
          );
          return '/sign-in';
        }

        final isAdmin = await _isUserAdmin();
        if (!isAdmin) {
          DebugLogger.debug(
            '🧭 ROUTER: Admin services route - user not admin, redirecting to home',
          );
          return '/home';
        }

        DebugLogger.debug(
          '🧭 ROUTER: Admin services route - user is admin, allowing access',
        );
        return null;
      },
    ),

    // ==================== FINANCE ROUTES ====================
    GoRoute(
      path: FinanceOverviewPage.routePath,
      builder: (context, state) {
        try {
          DebugLogger.debug('🧭 ROUTER: Building FinanceOverviewPage');
          return const LegalComplianceGuard(child: FinanceOverviewPage());
        } catch (e, stackTrace) {
          DebugLogger.error(
            '❌ ROUTER: Error building FinanceOverviewPage',
            e,
            stackTrace,
          );
          rethrow;
        }
      },
      redirect: (context, state) {
        final user = firebaseAuthFactory().currentUser;
        if (user == null) {
          DebugLogger.debug(
            '🧭 ROUTER: Finance route - user not authenticated',
          );
          return '/sign-in';
        }
        return null;
      },
    ),

    // ==================== PAYOUTS ROUTES ====================

    // Payout history for Pro users
    GoRoute(
      path: '/payouts',
      builder: (context, state) {
        try {
          DebugLogger.debug('🧭 ROUTER: Building PayoutsPage');
          return LegalComplianceGuard(child: PayoutsPage());
        } catch (e, stackTrace) {
          DebugLogger.error(
            '❌ ROUTER: Error building PayoutsPage',
            e,
            stackTrace,
          );
          rethrow;
        }
      },
      redirect: (context, state) async {
        final user = firebaseAuthFactory().currentUser;
        if (user == null) {
          DebugLogger.debug(
            '🧭 ROUTER: Payouts route - user not authenticated',
          );
          return '/sign-in';
        }
        return null;
      },
    ),

    // Payout detail view
    GoRoute(
      path: '/payouts/:transferId',
      builder: (context, state) {
        try {
          final transferId = state.pathParameters['transferId']!;
          DebugLogger.debug(
            '🧭 ROUTER: Building PayoutDetailPage for transfer: $transferId',
          );
          return LegalComplianceGuard(
            child: PayoutDetailPage(transferId: transferId),
          );
        } catch (e, stackTrace) {
          DebugLogger.error(
            '❌ ROUTER: Error building PayoutDetailPage',
            e,
            stackTrace,
          );
          rethrow;
        }
      },
      redirect: (context, state) async {
        final user = firebaseAuthFactory().currentUser;
        if (user == null) {
          DebugLogger.debug(
            '🧭 ROUTER: Payout detail route - user not authenticated',
          );
          return '/sign-in';
        }
        return null;
      },
    ),

    // ==================== LEGAL ROUTES ====================

    // Legal document viewer (Terms of Service)
    GoRoute(
      path: '/legal/terms',
      builder: (context, state) {
        try {
          DebugLogger.debug('🧭 ROUTER: Building LegalViewerPage for Terms');
          final language = state.uri.queryParameters['lang'];
          final version = state.uri.queryParameters['version'];

          SupportedLanguage? lang;
          if (language != null) {
            try {
              lang = SupportedLanguage.values.firstWhere(
                (l) => l.name == language,
              );
            } catch (e) {
              DebugLogger.debug(
                '🧭 ROUTER: Invalid language parameter: $language',
              );
            }
          }

          return LegalViewerPage(
            docType: LegalDocType.tos,
            language: lang,
            version: version,
          );
        } catch (e, stackTrace) {
          DebugLogger.error(
            '❌ ROUTER: Error building LegalViewerPage for Terms',
            e,
            stackTrace,
          );
          rethrow;
        }
      },
    ),

    // Legal document viewer (Privacy Policy)
    GoRoute(
      path: '/legal/privacy',
      builder: (context, state) {
        try {
          DebugLogger.debug('🧭 ROUTER: Building LegalViewerPage for Privacy');
          final language = state.uri.queryParameters['lang'];
          final version = state.uri.queryParameters['version'];

          SupportedLanguage? lang;
          if (language != null) {
            try {
              lang = SupportedLanguage.values.firstWhere(
                (l) => l.name == language,
              );
            } catch (e) {
              DebugLogger.debug(
                '🧭 ROUTER: Invalid language parameter: $language',
              );
            }
          }

          return LegalViewerPage(
            docType: LegalDocType.privacy,
            language: lang,
            version: version,
          );
        } catch (e, stackTrace) {
          DebugLogger.error(
            '❌ ROUTER: Error building LegalViewerPage for Privacy',
            e,
            stackTrace,
          );
          rethrow;
        }
      },
    ),

    // Legal document viewer (Impressum)
    GoRoute(
      path: '/legal/impressum',
      builder: (context, state) {
        try {
          DebugLogger.debug(
            '🧭 ROUTER: Building LegalViewerPage for Impressum',
          );
          final language = state.uri.queryParameters['lang'];
          final version = state.uri.queryParameters['version'];

          SupportedLanguage? lang;
          if (language != null) {
            try {
              lang = SupportedLanguage.values.firstWhere(
                (l) => l.name == language,
              );
            } catch (e) {
              DebugLogger.debug(
                '🧭 ROUTER: Invalid language parameter: $language',
              );
            }
          }

          return LegalViewerPage(
            docType: LegalDocType.impressum,
            language: lang,
            version: version,
          );
        } catch (e, stackTrace) {
          DebugLogger.error(
            '❌ ROUTER: Error building LegalViewerPage for Impressum',
            e,
            stackTrace,
          );
          rethrow;
        }
      },
    ),

    // Legal document viewer (Guidelines)
    GoRoute(
      path: '/legal/guidelines',
      builder: (context, state) {
        try {
          DebugLogger.debug(
            '🧭 ROUTER: Building LegalViewerPage for Guidelines',
          );
          final language = state.uri.queryParameters['lang'];
          final version = state.uri.queryParameters['version'];

          SupportedLanguage? lang;
          if (language != null) {
            try {
              lang = SupportedLanguage.values.firstWhere(
                (l) => l.name == language,
              );
            } catch (e) {
              DebugLogger.debug(
                '🧭 ROUTER: Invalid language parameter: $language',
              );
            }
          }

          return LegalViewerPage(
            docType: LegalDocType.guidelines,
            language: lang,
            version: version,
          );
        } catch (e, stackTrace) {
          DebugLogger.error(
            '❌ ROUTER: Error building LegalViewerPage for Guidelines',
            e,
            stackTrace,
          );
          rethrow;
        }
      },
    ),

    // Legal document viewer (Refund Policy)
    GoRoute(
      path: '/legal/refund',
      builder: (context, state) {
        try {
          DebugLogger.debug('🧭 ROUTER: Building LegalViewerPage for Refund');
          final language = state.uri.queryParameters['lang'];
          final version = state.uri.queryParameters['version'];

          SupportedLanguage? lang;
          if (language != null) {
            try {
              lang = SupportedLanguage.values.firstWhere(
                (l) => l.name == language,
              );
            } catch (e) {
              DebugLogger.debug(
                '🧭 ROUTER: Invalid language parameter: $language',
              );
            }
          }

          return LegalViewerPage(
            docType: LegalDocType.refund,
            language: lang,
            version: version,
          );
        } catch (e, stackTrace) {
          DebugLogger.error(
            '❌ ROUTER: Error building LegalViewerPage for Refund',
            e,
            stackTrace,
          );
          rethrow;
        }
      },
    ),

    // ==================== NOTIFICATIONS ROUTES ====================
    GoRoute(
      path: '/notifications',
      builder: (context, state) {
        try {
          DebugLogger.debug('🧭 ROUTER: Building NotificationsPage');
          return const LegalComplianceGuard(child: NotificationsPage());
        } catch (e, stackTrace) {
          DebugLogger.error(
            '❌ ROUTER: Error building NotificationsPage',
            e,
            stackTrace,
          );
          rethrow;
        }
      },
      redirect: (context, state) {
        final user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          DebugLogger.debug(
            '🧭 ROUTER: Notifications route - user not authenticated',
          );
          return '/sign-in';
        }
        return null;
      },
    ),
  ],
  redirect: (context, state) {
    final user = firebaseAuthFactory().currentUser;
    final isAuthenticated = user != null;
    final isAuthRoute =
        state.matchedLocation == '/sign-in' ||
        state.matchedLocation == '/sign-up';

    if (isAuthenticated && isAuthRoute) {
      return '/home';
    }

    if (!isAuthenticated && !isAuthRoute) {
      return '/sign-in';
    }

    return null; // No redirect needed
  },
);

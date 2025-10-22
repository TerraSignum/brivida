import 'dart:async';

import 'package:brivida_app/core/models/app_user.dart';
import 'package:brivida_app/core/models/legal.dart';
import 'package:brivida_app/core/providers/firebase_providers.dart';
import 'package:brivida_app/core/widgets/back_navigation_guard.dart';
import 'package:brivida_app/features/offers/data/offer_search_repo.dart';
import 'package:brivida_app/features/offers/logic/offer_search_controller.dart';
import 'package:brivida_app/features/offers/ui/offer_search_page.dart';
import 'package:brivida_app/features/legal/ui/legal_viewer_page.dart';
import 'package:brivida_app/features/settings/data/settings_repo.dart';
import 'package:brivida_app/features/settings/logic/settings_controller.dart';
import 'package:brivida_app/features/settings/ui/settings_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _TestTranslationsLoader extends AssetLoader {
  const _TestTranslationsLoader();

  static const Map<String, dynamic> _translations = {
    'offerSearch': {
      'pageTitle': 'Find Cleaning Pros',
      'filters': {
        'address': {'label': 'Service address', 'hint': 'Street and number'},
        'duration': 'Duration: {hours}h',
        'radius': 'Radius: {km}km',
        'recurring': 'Recurring job',
        'extras': 'Extras',
        'hourlyRate': 'Hourly rate',
        'search': 'Search offers',
      },
      'extras': {
        'laundry': 'Laundry service',
        'ironing': 'Ironing',
        'windows': 'Window cleaning',
      },
      'validation': {
        'address': 'Please select an address',
        'hourly': 'Enter a valid hourly rate',
      },
      'location': {
        'title': 'Job location',
        'placeholder': 'Pick a place on the map',
        'helper': 'Select an exact location for better matches',
        'coordinates': 'Lat {lat} · Lng {lng}',
        'mapCaption': 'Preview of the selected address',
        'select': 'Select location',
        'change': 'Change location',
      },
      'messages': {
        'requestSent': 'Request sent successfully',
        'requestError': 'Something went wrong ({code})',
        'searchError': 'Search failed: {code}',
      },
      'results': {'title': 'Results ({count})'},
    },
    'settings': {
      'title': 'Settings',
      'sections': {
        'profile': 'Profile',
        'notifications': 'Notifications',
        'account': 'Account',
        'legal': 'Legal',
        'dangerZone': 'Danger zone',
      },
      'profile': {
        'displayName': 'Display name',
        'username': 'Username',
        'language': 'Language',
      },
      'username': {'addPrompt': 'Add a username'},
      'language': {'current': 'Current: {code}'},
      'notifications': {
        'marketing': 'Marketing updates',
        'marketingHint': 'Get platform news and offers',
      },
      'legal': {
        'terms': 'Terms of Service',
        'privacy': 'Privacy Policy',
        'imprint': 'Legal Notice',
      },
      'logout': 'Log out',
      'delete': {
        'title': 'Delete account',
        'subtitle': 'This action cannot be undone',
      },
      'marketing': {'updated': 'Marketing preference updated'},
      'error': {
        'generic': 'Something went wrong',
        'photoUpload': 'Could not upload photo',
        'noProfile': 'No profile available',
      },
      'photo': {'updated': 'Profile photo updated'},
    },
    'common': {'retry': 'Retry'},
    'legal': {
      'viewer': {'title': 'Document'},
    },
  };

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    return _translations;
  }
}

class MockOfferSearchRepository extends Mock implements OfferSearchRepository {}

class MockSettingsRepository extends Mock implements SettingsRepository {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

Future<void> _pumpRouterApp(
  WidgetTester tester, {
  required GoRouter router,
  List<Override> overrides = const [],
}) async {
  await tester.pumpWidget(
    EasyLocalization(
      supportedLocales: const [Locale('en')],
      path: 'assets/i18n',
      fallbackLocale: const Locale('en'),
      assetLoader: const _TestTranslationsLoader(),
      child: ProviderScope(
        overrides: overrides,
        child: Builder(
          builder: (context) => MaterialApp.router(
            routerConfig: router,
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
          ),
        ),
      ),
    ),
  );

  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await EasyLocalization.ensureInitialized();
  });

  group('OfferSearchPage back navigation', () {
    testWidgets('App bar back button navigates to /home', (tester) async {
      final mockRepo = MockOfferSearchRepository();
      final controller = OfferSearchController(mockRepo);

      final router = GoRouter(
        initialLocation: OfferSearchPage.routeName,
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Home', key: Key('home_screen'))),
            ),
          ),
          GoRoute(
            path: OfferSearchPage.routeName,
            builder: (context, state) => const OfferSearchPage(),
          ),
        ],
      );

      addTearDown(router.dispose);
      addTearDown(controller.dispose);

      await _pumpRouterApp(
        tester,
        router: router,
        overrides: [
          offerSearchControllerProvider.overrideWith((ref) => controller),
        ],
      );

      await tester.pumpAndSettle();
      expect(find.byType(OfferSearchPage), findsOneWidget);

      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('home_screen')), findsOneWidget);
      expect(find.byType(OfferSearchPage), findsNothing);
    });

    testWidgets('System back navigates to /home', (tester) async {
      final mockRepo = MockOfferSearchRepository();
      final controller = OfferSearchController(mockRepo);

      final router = GoRouter(
        initialLocation: OfferSearchPage.routeName,
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Home', key: Key('home_screen'))),
            ),
          ),
          GoRoute(
            path: OfferSearchPage.routeName,
            builder: (context, state) => const OfferSearchPage(),
          ),
        ],
      );

      addTearDown(router.dispose);
      addTearDown(controller.dispose);

      await _pumpRouterApp(
        tester,
        router: router,
        overrides: [
          offerSearchControllerProvider.overrideWith((ref) => controller),
        ],
      );

      await tester.pumpAndSettle();
      expect(find.byType(OfferSearchPage), findsOneWidget);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('home_screen')), findsOneWidget);
      expect(find.byType(OfferSearchPage), findsNothing);
    });
  });

  group('SettingsPage back navigation', () {
    late MockSettingsRepository mockRepo;
    late SettingsController controller;
    late StreamController<AppUser?> userController;
    late FirebaseAuth fakeAuth;

    setUp(() {
      mockRepo = MockSettingsRepository();
      userController = StreamController<AppUser?>();
      when(
        () => mockRepo.watchCurrentUser(),
      ).thenAnswer((_) => userController.stream);
      when(() => mockRepo.updateMarketingOptIn(any())).thenAnswer((_) async {});
      controller = SettingsController(mockRepo);
      fakeAuth = MockFirebaseAuth();

      userController.add(
        const AppUser(
          uid: 'user_1',
          email: 'user@example.com',
          displayName: 'Alex',
          marketingOptIn: false,
        ),
      );
    });

    tearDown(() {
      controller.dispose();
      userController.close();
    });

    testWidgets('App bar back button navigates to /home', (tester) async {
      final router = GoRouter(
        initialLocation: '/settings',
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Home', key: Key('home_screen'))),
            ),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      );

      addTearDown(router.dispose);

      await _pumpRouterApp(
        tester,
        router: router,
        overrides: [
          settingsControllerProvider.overrideWith((ref) => controller),
          authProvider.overrideWithValue(fakeAuth),
        ],
      );

      await tester.pumpAndSettle();
      expect(find.byType(SettingsPage), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);

      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('home_screen')), findsOneWidget);
      expect(find.byType(SettingsPage), findsNothing);
    });

    testWidgets('System back navigates to /home', (tester) async {
      final router = GoRouter(
        initialLocation: '/settings',
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Home', key: Key('home_screen'))),
            ),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      );

      addTearDown(router.dispose);

      await _pumpRouterApp(
        tester,
        router: router,
        overrides: [
          settingsControllerProvider.overrideWith((ref) => controller),
          authProvider.overrideWithValue(fakeAuth),
        ],
      );

      await tester.pumpAndSettle();
      expect(find.byType(SettingsPage), findsOneWidget);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('home_screen')), findsOneWidget);
      expect(find.byType(SettingsPage), findsNothing);
    });
  });

  group('LegalViewerPage back handling', () {
    testWidgets('System back pops the legal page', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              appBar: AppBar(title: const Text('Root Home')),
              body: Center(
                child: ElevatedButton(
                  key: const Key('open_legal'),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const LegalViewerPage(
                          docType: LegalDocType.tos,
                          language: SupportedLanguage.en,
                        ),
                      ),
                    );
                  },
                  child: const Text('Open legal'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('open_legal')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(LegalViewerPage), findsOneWidget);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.byType(LegalViewerPage), findsNothing);
      expect(find.text('Root Home'), findsOneWidget);
    });
  });

  group('BackNavigationGuard', () {
    testWidgets('Navigates to fallback route before exiting', (tester) async {
      final router = GoRouter(
        initialLocation: '/secondary',
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const BackNavigationGuard(
              child: Scaffold(
                body: Center(child: Text('Home', key: Key('home_screen'))),
              ),
            ),
          ),
          GoRoute(
            path: '/secondary',
            builder: (context, state) => const BackNavigationGuard(
              child: Scaffold(
                body: Center(
                  child: Text('Secondary', key: Key('secondary_screen')),
                ),
              ),
            ),
          ),
        ],
      );

      addTearDown(router.dispose);

      await _pumpRouterApp(tester, router: router);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('secondary_screen')), findsOneWidget);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('home_screen')), findsOneWidget);
    });
  });
}

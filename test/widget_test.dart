// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:brivida_app/app/app.dart';
import 'package:brivida_app/app/router.dart' as app_router;
import 'package:brivida_app/core/services/mock_data_service.dart';
import 'package:brivida_app/features/auth/data/auth_repo.dart';
import 'package:brivida_app/features/auth/logic/auth_controller.dart';
import 'package:brivida_app/features/legal/ui/legal_compliance_guard.dart';
import 'package:brivida_app/features/notifications/ui/notification_service.dart';

void main() {
  final binding = TestWidgetsFlutterBinding.ensureInitialized();
  binding.platformDispatcher.localeTestValue = const Locale('en');
  SharedPreferences.setMockInitialValues({});

  testWidgets('App loads without crashing', (WidgetTester tester) async {
    // Ensure EasyLocalization is initialized for testing
    await EasyLocalization.ensureInitialized();

    final fakeAuth = MockFirebaseAuth(
      signedIn: false,
      mockUser: MockUser(
        uid: 'test-user',
        email: 'test@example.com',
        displayName: 'Test User',
      ),
    );

    final fakeFirestore = FakeFirebaseFirestore();

    MockDataService.configureForTesting(
      firestore: fakeFirestore,
      auth: fakeAuth,
    );

    addTearDown(MockDataService.resetTestOverrides);
    final previousAuthFactory = app_router.firebaseAuthFactory;
    app_router.firebaseAuthFactory = () => fakeAuth;

    addTearDown(() {
      app_router.firebaseAuthFactory = previousAuthFactory;
    });

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [
          Locale('de'),
          Locale('en'),
          Locale('es'),
          Locale('fr'),
          Locale('pt'),
        ],
        path: 'assets/i18n',
        fallbackLocale: const Locale('en'),
        assetLoader: const _InMemoryAssetLoader(),
        child: ProviderScope(
          overrides: [
            notificationInitializationEnabledProvider.overrideWithValue(false),
            legalComplianceEnabledProvider.overrideWithValue(false),
            authRepositoryProvider.overrideWithValue(
              AuthRepository(firebaseAuth: fakeAuth),
            ),
          ],
          child: const BrividaApp(),
        ),
      ),
    );

    // Wait for the app to load
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Verify that the app loads successfully (look for common elements)
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}

class _InMemoryAssetLoader extends AssetLoader {
  const _InMemoryAssetLoader();

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    const sharedTranslations = {
      'auth': {
        'welcomeTitle': 'Welcome to Brivida',
        'welcomeSubtitle': 'Connect with trusted cleaning professionals',
        'emailLabel': 'Email',
        'emailHint': 'name@example.com',
        'passwordLabel': 'Password',
        'passwordHint': 'Enter your password',
        'signInButton': 'Sign in',
        'noAccount': "Don't have an account?",
        'signUp': 'Sign up',
      },
      'language': {'select': 'Select language'},
      'footer': {
        'legal': {
          'terms': 'Terms of Service',
          'privacy': 'Privacy Policy',
          'imprint': 'Legal Notice',
        },
      },
      'settings': {
        'legal': {
          'terms': 'Terms of Service',
          'privacy': 'Privacy Policy',
          'imprint': 'Legal Notice',
        },
      },
    };

    if (locale.languageCode == 'en') {
      return sharedTranslations;
    }

    return sharedTranslations;
  }
}

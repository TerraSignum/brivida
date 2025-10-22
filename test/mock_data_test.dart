import 'package:brivida_app/core/config/environment.dart';
import 'package:brivida_app/core/services/mock_data_service.dart';
import 'package:brivida_app/core/utils/debug_logger.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeFirebaseFirestore fakeFirestore;
  late MockFirebaseAuth mockAuth;

  group('Mock Data Service Tests', () {
    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      mockAuth = MockFirebaseAuth(
        signedIn: true,
        mockUser: MockUser(
          uid: 'test-user',
          email: 'test@example.com',
          displayName: 'Test User',
        ),
      );

      MockDataService.configureForTesting(
        firestore: fakeFirestore,
        auth: mockAuth,
      );

      // Ensure we're in development environment for testing
      if (!Environment.isDevelopment) {
        fail('Tests must run in development environment');
      }
    });

    tearDown(() {
      MockDataService.resetTestOverrides();
    });

    test('should create mock jobs with proper structure', () async {
      try {
        await MockDataService.initializeMockData(force: true);

        // The service should create mock data without throwing
        expect(true, true); // If we get here, initialization succeeded

        final jobDocs = await fakeFirestore.collection('jobs').get();
        expect(jobDocs.docs, isNotEmpty);
        expect(jobDocs.docs.first.data()['isMockData'], true);

        DebugLogger.debug('✅ Mock data initialization test passed');
      } catch (e) {
        fail('Mock data initialization failed: $e');
      }
    });

    test('should only work in development environment', () {
      expect(
        Environment.isDevelopment,
        true,
        reason: 'Mock data should only be available in development',
      );

      expect(kDebugMode, true, reason: 'Tests should run in debug mode');
    });

    test('should create interconnected mock data', () async {
      try {
        await MockDataService.initializeMockData(force: true);

        // Test that the service runs without errors
        // The actual data validation would happen in integration tests
        // since we need Firebase to be set up

        final leadsDocs = await fakeFirestore.collection('leads').get();
        expect(leadsDocs.docs, isNotEmpty);

        DebugLogger.debug('✅ Interconnected mock data test passed');
      } catch (e) {
        fail('Interconnected mock data creation failed: $e');
      }
    });
  });
}

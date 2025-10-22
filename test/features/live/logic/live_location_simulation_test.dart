import 'package:brivida_app/core/config/environment.dart';
import 'package:brivida_app/core/services/mock_data_service.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeFirebaseFirestore fakeFirestore;
  late MockFirebaseAuth mockAuth;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    mockAuth = MockFirebaseAuth(
      signedIn: true,
      mockUser: MockUser(
        uid: 'sim-user',
        email: 'sim@example.com',
        displayName: 'Sim Tester',
      ),
    );

    MockDataService.configureForTesting(
      firestore: fakeFirestore,
      auth: mockAuth,
    );

    expect(
      Environment.isDevelopment,
      isTrue,
      reason: 'Simulation tests require development environment',
    );
  });

  tearDown(() async {
    await MockDataService.clearMockData();
    MockDataService.resetTestOverrides();
  });

  group('Live location simulation', () {
    const jobId = 'mock_job_002';
    const proUid = 'mock_pro_001';

    Future<Map<String, dynamic>?> readLiveDoc() async {
      final snapshot = await fakeFirestore
          .collection('liveLocations')
          .doc(jobId)
          .collection('pros')
          .doc(proUid)
          .get();
      return snapshot.data();
    }

    test('seeded route is created when simulation enabled', () async {
      await MockDataService.initializeMockData(
        force: true,
        enableLiveLocationSimulation: true,
      );

      final liveData = await readLiveDoc();
      expect(liveData, isNotNull);
      expect(liveData!['lat'], closeTo(52.521918, 0.00001));
      expect(liveData['lng'], closeTo(13.413215, 0.00001));
      expect(liveData['isMockData'], isTrue);
      expect(liveData['source'], 'simulated');
      expect(MockDataService.isLiveLocationSimulationActive, isFalse);
    });

    test('manual simulation step updates coordinates along route', () async {
      await MockDataService.initializeMockData(
        force: true,
        enableLiveLocationSimulation: true,
      );

      await MockDataService.triggerLiveLocationSimulationStep();
      final firstStep = await readLiveDoc();
      expect(firstStep!['lat'], closeTo(52.522500, 0.00001));
      expect(firstStep['lng'], closeTo(13.415200, 0.00001));

      await MockDataService.triggerLiveLocationSimulationStep();
      final secondStep = await readLiveDoc();
      expect(secondStep!['lat'], closeTo(52.523150, 0.00001));
      expect(secondStep['lng'], closeTo(13.417450, 0.00001));
    });

    test('clearing mock data removes simulated live documents', () async {
      await MockDataService.initializeMockData(
        force: true,
        enableLiveLocationSimulation: true,
      );

      await MockDataService.clearMockData();
      final liveDoc = await readLiveDoc();
      expect(liveDoc, isNull);
    });
  });
}

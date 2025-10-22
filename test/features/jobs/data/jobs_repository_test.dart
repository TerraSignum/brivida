import 'package:brivida_app/core/models/job.dart';
import 'package:brivida_app/features/jobs/data/jobs_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeFirebaseFunctions extends Fake implements FirebaseFunctions {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('JobsRepository', () {
    late FakeFirebaseFirestore firestore;
    late MockFirebaseAuth auth;
    late JobsRepository repository;
    late MockUser mockUser;

    setUp(() {
      firestore = FakeFirebaseFirestore();
      mockUser = MockUser(uid: 'customer-123', email: 'customer@example.com');
      auth = MockFirebaseAuth(mockUser: mockUser, signedIn: true);
      repository = JobsRepository(
        firestore: firestore,
        auth: auth,
        functions: _FakeFirebaseFunctions(),
      );
    });

    Job buildJob() {
      final now = DateTime.utc(2024, 1, 1, 12);
      return Job(
        customerUid: 'placeholder',
        sizeM2: 60,
        rooms: 3,
        services: const ['basic-cleaning'],
        window: JobWindow(start: now, end: now.add(const Duration(hours: 3))),
        budget: 120,
      );
    }

    test('createJob stores job linked to authenticated user', () async {
      final job = buildJob();

      final jobId = await repository.createJob(job);
      final snapshot = await firestore.collection('jobs').doc(jobId).get();

      expect(snapshot.exists, isTrue);
      final data = snapshot.data();
      expect(data, isNotNull);
      expect(data!['customerUid'], mockUser.uid);
      expect(data['budget'], job.budget);
      expect(data['services'], equals(job.services));
      expect(data['window'], isA<Map<String, dynamic>>());
      expect(data['createdAt'], isA<Timestamp>());
      expect(data['updatedAt'], isA<Timestamp>());
    });

    test('getUserJobs emits saved job for authenticated user', () async {
      final jobFuture = repository.getUserJobs().firstWhere(
        (jobs) => jobs.isNotEmpty,
      );

      await repository.createJob(buildJob());

      final jobs = await jobFuture;
      expect(jobs, hasLength(1));
      final savedJob = jobs.first;
      expect(savedJob.customerUid, mockUser.uid);
      expect(savedJob.budget, 120);
      expect(savedJob.services, contains('basic-cleaning'));
      expect(savedJob.createdAt, isNotNull);
    });
  });
}

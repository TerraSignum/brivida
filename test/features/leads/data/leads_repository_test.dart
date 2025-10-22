import 'package:brivida_app/features/leads/data/leads_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test_utils/stub_firebase_functions.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('LeadsRepository.acceptLead', () {
    late FakeFirebaseFirestore firestore;
    late MockFirebaseAuth auth;
    late StubFirebaseFunctions functions;
    late LeadsRepository repository;

    setUp(() {
      firestore = FakeFirebaseFirestore();
      auth = MockFirebaseAuth(
        mockUser: MockUser(uid: 'pro-123', email: 'pro@example.com'),
        signedIn: true,
      );

      functions = StubFirebaseFunctions();

      functions.registerHandler('acceptLeadCF', (parameters) async {
        final payload = Map<String, dynamic>.from(parameters as Map);
        final leadId = payload['leadId'] as String;

        final leadRef = firestore.collection('leads').doc(leadId);
        final leadSnapshot = await leadRef.get();
        final leadData = leadSnapshot.data()!;

        final jobId = leadData['jobId'] as String;
        final proUid = leadData['proUid'] as String;

        await leadRef.update({
          'status': 'accepted',
          'acceptedAt': Timestamp.now(),
          'updatedAt': Timestamp.now(),
        });

        await firestore.collection('jobs').doc(jobId).update({
          'status': 'assigned',
          'visibleTo': FieldValue.arrayUnion(<String>[proUid]),
          'updatedAt': Timestamp.now(),
        });

        return {'success': true, 'leadId': leadId, 'jobId': jobId};
      });

      repository = LeadsRepository(
        firestore: firestore,
        auth: auth,
        functions: functions,
      );
    });

    Future<void> seedData() async {
      await firestore.collection('jobs').doc('job-001').set({
        'customerUid': 'customer-42',
        'status': 'open',
        'visibleTo': <String>[],
        'updatedAt': Timestamp.now(),
      });

      await firestore.collection('leads').doc('lead-001').set({
        'jobId': 'job-001',
        'customerUid': 'customer-42',
        'proUid': 'pro-123',
        'message': 'Happy to help',
        'status': 'pending',
        'createdAt': Timestamp.now(),
      });
    }

    test('updates lead and job documents on success', () async {
      await seedData();

      await repository.acceptLead('lead-001');

      final leadDoc = await firestore.collection('leads').doc('lead-001').get();
      final jobDoc = await firestore.collection('jobs').doc('job-001').get();

      expect(leadDoc.data()!['status'], 'accepted');
      expect(leadDoc.data()!['acceptedAt'], isA<Timestamp>());

      expect(jobDoc.data()!['status'], 'assigned');
      final visibleTo = (jobDoc.data()!['visibleTo'] as List).cast<String>();
      expect(visibleTo, contains('pro-123'));
    });

    test('throws when lead cannot be accepted', () async {
      functions.registerHandler('acceptLeadCF', (_) async {
        throw FirebaseFunctionsException(
          code: 'failed-precondition',
          message: 'Lead no longer pending',
        );
      });

      await expectLater(
        repository.acceptLead('lead-999'),
        throwsA(isA<Exception>()),
      );
    });
  });
}

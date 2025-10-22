import 'package:brivida_app/core/models/pro_offer.dart';
import 'package:brivida_app/features/offers/data/offers_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OffersRepository', () {
    late FakeFirebaseFirestore firestore;
    late MockFirebaseAuth auth;
    late OffersRepository repository;
    late MockUser mockUser;

    setUp(() {
      firestore = FakeFirebaseFirestore();
      mockUser = MockUser(uid: 'pro-123', email: 'pro@example.com');
      auth = MockFirebaseAuth(mockUser: mockUser, signedIn: true);
      repository = OffersRepository(firestore: firestore, auth: auth);
    });

    ProOffer buildDraft({List<int>? weekdays}) {
      return ProOffer(
        proId: 'placeholder-pro',
        title: 'Deep Clean Blitz',
        weekdays: weekdays ?? [6, 3, 5],
        timeFrom: '08:00',
        timeTo: '14:00',
        minHours: 3,
        maxHours: 6,
        acceptsRecurring: true,
        extras: const OfferExtras(laundry: true, ironingFull: true),
        geoCenter: const OfferLocation(lat: 52.52, lng: 13.405),
        serviceRadiusKm: 25,
        notes: 'Bring eco products',
        isActive: true,
      );
    }

    test('createOffer stores offer for authenticated pro', () async {
      final draft = buildDraft();

      final offerId = await repository.createOffer(draft);
      final snapshot = await firestore
          .collection('proOffers')
          .doc(offerId)
          .get();

      expect(snapshot.exists, isTrue);
      final data = snapshot.data();
      expect(data, isNotNull);
      expect(data!['proId'], mockUser.uid);
      expect(data['title'], draft.title);
      expect((data['weekdays'] as List).cast<int>(), equals([3, 5, 6]));
      final geoCenter = (data['geoCenter'] as Map<String, dynamic>);
      expect(geoCenter['lat'], closeTo(52.52, 0.0001));
      expect(geoCenter['lng'], closeTo(13.405, 0.0001));
      expect(data['isActive'], isTrue);
      expect(data['createdAt'], isA<Timestamp>());
      expect(data['updatedAt'], isA<Timestamp>());
    });

    test('streamMyOffers emits saved offers for authenticated pro', () async {
      final offerFuture = repository.streamMyOffers().firstWhere(
        (offers) => offers.isNotEmpty,
      );

      await repository.createOffer(buildDraft());

      final offers = await offerFuture;
      expect(offers, hasLength(1));
      final offer = offers.first;
      expect(offer.id, isNotNull);
      expect(offer.proId, mockUser.uid);
      expect(offer.weekdays, equals([3, 5, 6]));
      expect(offer.geoCenter.lat, closeTo(52.52, 0.0001));
      expect(offer.geoCenter.lng, closeTo(13.405, 0.0001));
      expect(offer.isActive, isTrue);
      expect(offer.createdAt, isNotNull);
    });
  });
}

import 'package:brivida_app/core/models/offer_request.dart';
import 'package:brivida_app/core/models/pro_offer.dart';
import 'package:brivida_app/core/services/cloud_function_names.dart';
import 'package:brivida_app/features/offers/data/offer_search_repo.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../test_utils/stub_firebase_functions.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OfferSearchRepository - acceptance', () {
    late StubFirebaseFunctions functions;
    late OfferSearchRepository repository;
    late Map<String, dynamic> capturedPayload;

    setUp(() {
      capturedPayload = <String, dynamic>{};
      functions = StubFirebaseFunctions(
        handlers: {
          CloudFunctionNames.createOfferRequestCF: (parameters) async {
            capturedPayload = Map<String, dynamic>.from(
              (parameters ?? <String, dynamic>{}) as Map,
            );
            return {'requestId': 'req-42'};
          },
        },
      );

      repository = OfferSearchRepository(functions: functions);
    });

    OfferRequestJob buildJob() => OfferRequestJob(
      address: 'Rua das Flores 123, Funchal',
      geo: const OfferLocation(lat: 32.65, lng: -16.92),
      start: DateTime.utc(2025, 10, 6, 9),
      durationH: 2.5,
      extras: const {'windows': true, 'deep_clean': false},
      recurring: 'weekly',
    );

    OfferRequestPrice buildPrice() =>
        const OfferRequestPrice(hourly: 18.5, estimatedTotal: 46.25);

    test(
      'createOfferRequest forwards payload and returns request id',
      () async {
        final job = buildJob();
        final price = buildPrice();

        final requestId = await repository.createOfferRequest(
          offerId: 'offer-007',
          job: job,
          price: price,
          note: 'Prefer eco-friendly supplies',
        );

        expect(requestId, 'req-42');
        expect(capturedPayload['offerId'], 'offer-007');
        expect(capturedPayload['job'], equals(job.toJson()));
        expect(capturedPayload['price'], equals(price.toJson()));
        expect(capturedPayload['note'], 'Prefer eco-friendly supplies');
      },
    );

    test('createOfferRequest omits empty note field', () async {
      final job = buildJob();
      final price = buildPrice();

      await repository.createOfferRequest(
        offerId: 'offer-008',
        job: job,
        price: price,
        note: '',
      );

      expect(capturedPayload.containsKey('note'), isFalse);
    });
  });
}

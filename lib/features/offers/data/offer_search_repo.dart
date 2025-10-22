import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/offer_request.dart';
import '../../../core/models/offer_search.dart';
import '../../../core/utils/debug_logger.dart';
import '../../../core/services/cloud_function_names.dart';

final offerSearchRepositoryProvider = Provider<OfferSearchRepository>((ref) {
  DebugLogger.debug('🔗 Creating OfferSearchRepository');
  return OfferSearchRepository(functions: FirebaseFunctions.instance);
});

class OfferSearchRepository {
  OfferSearchRepository({required FirebaseFunctions functions})
    : _functions = functions;

  final FirebaseFunctions _functions;

  Future<List<OfferSearchResult>> searchOffers(OfferSearchFilter filter) async {
    DebugLogger.enter('OfferSearchRepository.searchOffers', {
      'when': filter.when.toIso8601String(),
      'radiusKm': filter.radiusKm,
      'recurring': filter.recurring,
      'extras': filter.extras.toJson(),
    });

    try {
      final callable = _functions.httpsCallable(
        CloudFunctionNames.searchProOffersCF,
      );
      final response = await callable.call(filter.toJson());
      final data = (response.data as List<dynamic>?) ?? const [];
      final results = data
          .map(
            (item) => OfferSearchResult.fromJson(
              Map<String, dynamic>.from(item as Map),
            ),
          )
          .toList();

      DebugLogger.debug('✅ Offer search returned results', {
        'count': results.length,
      });
      DebugLogger.exit('OfferSearchRepository.searchOffers', 'success');
      return results;
    } on FirebaseFunctionsException catch (error, stackTrace) {
      DebugLogger.error(
        '❌ Offer search callable failed: ${error.code}',
        error,
        stackTrace,
      );
      rethrow;
    } catch (error, stackTrace) {
      DebugLogger.error('❌ Unexpected offer search error', error, stackTrace);
      rethrow;
    }
  }

  Future<String> createOfferRequest({
    required String offerId,
    required OfferRequestJob job,
    required OfferRequestPrice price,
    String? note,
  }) async {
    DebugLogger.enter('OfferSearchRepository.createOfferRequest', {
      'offerId': offerId,
      'noteLength': note?.length ?? 0,
      'extras': job.extras,
    });

    try {
      final callable = _functions.httpsCallable(
        CloudFunctionNames.createOfferRequestCF,
      );
      final response = await callable.call({
        'offerId': offerId,
        'job': job.toJson(),
        'price': price.toJson(),
        if (note != null && note.isNotEmpty) 'note': note,
      });

      final data = response.data as Map<String, dynamic>?;
      final requestId = data?['requestId'] as String?;
      if (requestId == null || requestId.isEmpty) {
        DebugLogger.warning(
          '⚠️ Offer request callable returned without requestId',
          {'response': data},
        );
        throw StateError('offer_request_missing_id');
      }

      DebugLogger.exit('OfferSearchRepository.createOfferRequest', requestId);
      return requestId;
    } on FirebaseFunctionsException catch (error, stackTrace) {
      DebugLogger.error(
        '❌ Offer request callable failed: ${error.code}',
        error,
        stackTrace,
      );
      rethrow;
    } catch (error, stackTrace) {
      DebugLogger.error('❌ Unexpected offer request error', error, stackTrace);
      rethrow;
    }
  }
}

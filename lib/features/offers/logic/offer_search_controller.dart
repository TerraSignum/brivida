import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/offer_request.dart';
import '../../../core/models/offer_search.dart';
import '../../../core/utils/debug_logger.dart';
import '../data/offer_search_repo.dart';

final offerSearchControllerProvider =
    StateNotifierProvider<OfferSearchController, OfferSearchState>((ref) {
      DebugLogger.debug('🔗 Creating OfferSearchController provider instance');
      final repo = ref.watch(offerSearchRepositoryProvider);
      return OfferSearchController(repo);
    });

class OfferSearchController extends StateNotifier<OfferSearchState> {
  OfferSearchController(this._repo) : super(const OfferSearchState());

  final OfferSearchRepository _repo;

  Future<void> searchOffers(OfferSearchFilter filter) async {
    DebugLogger.enter('OfferSearchController.searchOffers', {
      'when': filter.when.toIso8601String(),
      'radiusKm': filter.radiusKm,
    });
    if (!mounted) {
      DebugLogger.exit('OfferSearchController.searchOffers', 'disposed');
      return;
    }
    state = state.copyWith(isLoading: true, clearError: true, filter: filter);

    try {
      final results = await _repo.searchOffers(filter);
      if (!mounted) {
        DebugLogger.exit('OfferSearchController.searchOffers', 'disposed');
        return;
      }
      state = state.copyWith(
        isLoading: false,
        results: results,
        clearError: true,
      );
      DebugLogger.exit('OfferSearchController.searchOffers', 'success');
    } on FirebaseFunctionsException catch (error) {
      DebugLogger.error(
        '❌ OfferSearch callable error: ${error.code}',
        error,
        error.stackTrace,
      );
      if (!mounted) {
        DebugLogger.exit('OfferSearchController.searchOffers', 'disposed');
        return;
      }
      state = state.copyWith(isLoading: false, errorCode: error.code);
    } catch (error, stackTrace) {
      DebugLogger.error('❌ OfferSearch unexpected error', error, stackTrace);
      if (!mounted) {
        DebugLogger.exit('OfferSearchController.searchOffers', 'disposed');
        return;
      }
      state = state.copyWith(isLoading: false, errorCode: 'unknown-error');
    }
  }

  Future<String?> submitRequest({
    required String offerId,
    required OfferRequestJob job,
    required OfferRequestPrice price,
    String? note,
  }) async {
    DebugLogger.enter('OfferSearchController.submitRequest', {
      'offerId': offerId,
      'noteLength': note?.length ?? 0,
    });
    if (!mounted) {
      DebugLogger.exit('OfferSearchController.submitRequest', 'disposed');
      return null;
    }
    state = state.copyWith(
      isSubmittingRequest: true,
      clearRequestError: true,
      clearLastRequestId: true,
    );

    try {
      final requestId = await _repo.createOfferRequest(
        offerId: offerId,
        job: job,
        price: price,
        note: note,
      );
      if (!mounted) {
        DebugLogger.exit('OfferSearchController.submitRequest', 'disposed');
        return null;
      }
      state = state.copyWith(
        isSubmittingRequest: false,
        lastRequestId: requestId,
        clearRequestError: true,
      );
      DebugLogger.exit('OfferSearchController.submitRequest', requestId);
      return requestId;
    } on FirebaseFunctionsException catch (error) {
      DebugLogger.error(
        '❌ Offer request callable error: ${error.code}',
        error,
        error.stackTrace,
      );
      if (!mounted) {
        DebugLogger.exit('OfferSearchController.submitRequest', 'disposed');
        return null;
      }
      state = state.copyWith(
        isSubmittingRequest: false,
        requestErrorCode: error.code,
      );
    } catch (error, stackTrace) {
      DebugLogger.error('❌ Offer request unexpected error', error, stackTrace);
      if (!mounted) {
        DebugLogger.exit('OfferSearchController.submitRequest', 'disposed');
        return null;
      }
      state = state.copyWith(
        isSubmittingRequest: false,
        requestErrorCode: 'unknown-error',
      );
    }
    return null;
  }

  void clearRequestFeedback() {
    if (!mounted) {
      return;
    }
    state = state.copyWith(clearLastRequestId: true, clearRequestError: true);
  }
}

class OfferSearchState {
  const OfferSearchState({
    this.filter,
    this.results = const <OfferSearchResult>[],
    this.isLoading = false,
    this.errorCode,
    this.isSubmittingRequest = false,
    this.requestErrorCode,
    this.lastRequestId,
  });

  final OfferSearchFilter? filter;
  final List<OfferSearchResult> results;
  final bool isLoading;
  final String? errorCode;
  final bool isSubmittingRequest;
  final String? requestErrorCode;
  final String? lastRequestId;

  OfferSearchState copyWith({
    OfferSearchFilter? filter,
    List<OfferSearchResult>? results,
    bool? isLoading,
    String? errorCode,
    bool clearError = false,
    bool? isSubmittingRequest,
    String? requestErrorCode,
    bool clearRequestError = false,
    String? lastRequestId,
    bool clearLastRequestId = false,
    bool clearFilter = false,
  }) {
    return OfferSearchState(
      filter: clearFilter ? null : (filter ?? this.filter),
      results: results ?? this.results,
      isLoading: isLoading ?? this.isLoading,
      errorCode: clearError ? null : (errorCode ?? this.errorCode),
      isSubmittingRequest: isSubmittingRequest ?? this.isSubmittingRequest,
      requestErrorCode: clearRequestError
          ? null
          : (requestErrorCode ?? this.requestErrorCode),
      lastRequestId: clearLastRequestId
          ? null
          : (lastRequestId ?? this.lastRequestId),
    );
  }
}

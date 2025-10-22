import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brivida_app/core/models/review.dart';
import 'package:brivida_app/features/reviews/data/reviews_repository.dart';
import 'package:brivida_app/core/exceptions/app_exceptions.dart';

/// Provider for reviews repository
final reviewsRepositoryProvider = Provider<ReviewsRepository>((ref) {
  return ReviewsRepository();
});

/// Provider for reviews controller
final reviewsControllerProvider =
    StateNotifierProvider<ReviewsController, AsyncValue<List<Review>>>((ref) {
  final repository = ref.watch(reviewsRepositoryProvider);
  return ReviewsController(repository);
});

/// Controller for managing reviews state and operations
class ReviewsController extends StateNotifier<AsyncValue<List<Review>>> {
  final ReviewsRepository _repository;

  ReviewsController(this._repository) : super(const AsyncValue.loading());

  /// Submit a new review
  Future<Review> submitReview(ReviewSubmissionRequest request) async {
    try {
      final review = await _repository.submitReview(request);

      // Refresh the current list if we're showing reviews
      if (state.hasValue) {
        await refresh();
      }

      return review;
    } catch (e) {
      // Re-throw the error for the UI to handle
      rethrow;
    }
  }

  /// Load reviews for a specific pro
  Future<void> loadProReviews(String proUid, {int? limit}) async {
    state = const AsyncValue.loading();

    try {
      final reviews = await _repository.listProReviews(proUid, limit: limit);
      state = AsyncValue.data(reviews);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// Load current user's reviews
  Future<void> loadMyReviews({int? limit}) async {
    state = const AsyncValue.loading();

    try {
      final reviews = await _repository.listMyReviews(limit: limit);
      state = AsyncValue.data(reviews);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// Load all reviews for admin
  Future<void> loadAllReviews({
    ReviewModerationStatus? status,
    int? limit,
  }) async {
    state = const AsyncValue.loading();

    try {
      final reviews = await _repository.listAllReviews(
        status: status,
        limit: limit,
      );
      state = AsyncValue.data(reviews);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  /// Moderate a review (admin only)
  Future<void> moderateReview(ReviewModerationRequest request) async {
    try {
      await _repository.moderateReview(request);

      // Refresh the current list
      await refresh();
    } catch (e) {
      // Re-throw the error for the UI to handle
      rethrow;
    }
  }

  /// Check if user has reviewed a job
  Future<bool> hasReviewedJob(String jobId) async {
    try {
      return await _repository.hasReviewedJob(jobId);
    } catch (e) {
      // Return false on error to be safe
      return false;
    }
  }

  /// Get rating aggregate for a pro
  Future<RatingAggregate> getProRatingAggregate(String proUid) async {
    try {
      return await _repository.getProRatingAggregate(proUid);
    } catch (e) {
      // Return empty aggregate on error
      return const RatingAggregate();
    }
  }

  /// Refresh current reviews list
  Future<void> refresh() async {
    if (state.hasValue) {
      final currentReviews = state.value!;
      if (currentReviews.isNotEmpty) {
        // Attempt to refresh based on what we think we're showing
        // This is a simple implementation - could be improved with better state tracking
        state = const AsyncValue.loading();
        try {
          // For now, just reload the same type of reviews
          // In a real app, we'd track what type of list we're showing
          final reviews = await _repository.listMyReviews();
          state = AsyncValue.data(reviews);
        } catch (e) {
          state = AsyncValue.error(e, StackTrace.current);
        }
      }
    }
  }

  /// Clear current state
  void clear() {
    state = const AsyncValue.data([]);
  }
}

/// Provider for pro reviews stream
final proReviewsStreamProvider =
    StreamProvider.family<List<Review>, String>((ref, proUid) {
  final repository = ref.watch(reviewsRepositoryProvider);
  return repository.streamProReviews(proUid, limit: 20);
});

/// Provider for single review
final reviewProvider =
    FutureProvider.family<Review?, String>((ref, reviewId) async {
  final repository = ref.watch(reviewsRepositoryProvider);
  return repository.getReview(reviewId);
});

/// Provider for pro rating aggregate
final proRatingAggregateProvider =
    FutureProvider.family<RatingAggregate, String>((ref, proUid) async {
  final repository = ref.watch(reviewsRepositoryProvider);
  return repository.getProRatingAggregate(proUid);
});

/// Provider to check if job has been reviewed
final hasReviewedJobProvider =
    FutureProvider.family<bool, String>((ref, jobId) async {
  final repository = ref.watch(reviewsRepositoryProvider);
  return repository.hasReviewedJob(jobId);
});

/// Provider for reviews list by type
enum ReviewsListType {
  proReviews,
  myReviews,
  allReviews,
}

final reviewsListProvider = StateNotifierProvider.family<ReviewsListController,
    AsyncValue<List<Review>>, ReviewsListParams>((ref, params) {
  final repository = ref.watch(reviewsRepositoryProvider);
  return ReviewsListController(repository, params);
});

class ReviewsListParams {
  final ReviewsListType type;
  final String? proUid;
  final ReviewModerationStatus? status;
  final int? limit;

  const ReviewsListParams({
    required this.type,
    this.proUid,
    this.status,
    this.limit,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewsListParams &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          proUid == other.proUid &&
          status == other.status &&
          limit == other.limit;

  @override
  int get hashCode =>
      type.hashCode ^ proUid.hashCode ^ status.hashCode ^ limit.hashCode;
}

class ReviewsListController extends StateNotifier<AsyncValue<List<Review>>> {
  final ReviewsRepository _repository;
  final ReviewsListParams _params;

  ReviewsListController(this._repository, this._params)
      : super(const AsyncValue.loading()) {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      List<Review> reviews;

      switch (_params.type) {
        case ReviewsListType.proReviews:
          if (_params.proUid == null) {
            throw const AppException.validation(
                message: 'Pro UID is required for pro reviews');
          }
          reviews = await _repository.listProReviews(_params.proUid!,
              limit: _params.limit);
          break;

        case ReviewsListType.myReviews:
          reviews = await _repository.listMyReviews(limit: _params.limit);
          break;

        case ReviewsListType.allReviews:
          reviews = await _repository.listAllReviews(
            status: _params.status,
            limit: _params.limit,
          );
          break;
      }

      state = AsyncValue.data(reviews);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> refresh() async {
    await _loadInitialData();
  }
}

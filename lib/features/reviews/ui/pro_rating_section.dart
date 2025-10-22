import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brivida_app/core/models/review.dart';
import 'package:brivida_app/features/reviews/ui/widgets/star_rating.dart';
import 'package:brivida_app/features/reviews/ui/reviews_display.dart';
import 'package:brivida_app/features/reviews/logic/reviews_controller.dart';

/// Widget to display rating aggregate and reviews for a pro profile
class ProRatingSection extends ConsumerWidget {
  final String proUid;
  final bool showAllReviews;

  const ProRatingSection({
    super.key,
    required this.proUid,
    this.showAllReviews = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ratingAggregateAsync = ref.watch(proRatingAggregateProvider(proUid));

    return ratingAggregateAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => const Center(
        child: Text('Fehler beim Laden der Bewertungen'),
      ),
      data: (aggregate) {
        if (aggregate.count == 0) {
          return const _NoReviewsWidget();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rating summary
            _RatingSummary(aggregate: aggregate),

            const SizedBox(height: 16),

            // Reviews list
            if (showAllReviews) ...[
              Text(
                'Bewertungen (${aggregate.count})',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 400, // Fixed height for scrollable reviews
                child: ReviewsList(proUid: proUid),
              ),
            ] else ...[
              // Show limited reviews with "Show more" button
              _LimitedReviewsList(proUid: proUid),
            ],
          ],
        );
      },
    );
  }
}

/// Widget for when no reviews exist
class _NoReviewsWidget extends StatelessWidget {
  const _NoReviewsWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(
            Icons.rate_review_outlined,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 12),
          Text(
            'Noch keine Bewertungen',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Seien Sie der Erste, der diesen Pro bewertet!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Widget showing rating summary with breakdown
class _RatingSummary extends StatelessWidget {
  final RatingAggregate aggregate;

  const _RatingSummary({required this.aggregate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          // Overall rating
          Row(
            children: [
              Text(
                aggregate.average.toStringAsFixed(1),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CompactStarRating(
                      rating: aggregate.average,
                      starSize: 20,
                      showValue: false,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${aggregate.count} Bewertung${aggregate.count != 1 ? 'en' : ''}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Rating breakdown
          RatingBreakdown(
            distribution: aggregate.distribution,
            totalCount: aggregate.count,
          ),
        ],
      ),
    );
  }
}

/// Widget showing limited reviews with "Show more" option
class _LimitedReviewsList extends ConsumerWidget {
  final String proUid;
  final int maxReviews = 3;

  const _LimitedReviewsList({required this.proUid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsAsync = ref.watch(proReviewsStreamProvider(proUid));

    return reviewsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Text('Fehler: $error'),
      data: (reviews) {
        if (reviews.isEmpty) {
          return const SizedBox.shrink();
        }

        final limitedReviews = reviews.take(maxReviews).toList();
        final hasMore = reviews.length > maxReviews;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bewertungen',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                if (hasMore)
                  TextButton(
                    onPressed: () => _showAllReviews(context),
                    child: Text('Alle ${reviews.length} anzeigen'),
                  ),
              ],
            ),
            const SizedBox(height: 8),

            // Limited reviews
            ...limitedReviews.map((review) => ReviewCard(review: review)),

            // Show more button
            if (hasMore) ...[
              const SizedBox(height: 12),
              Center(
                child: OutlinedButton(
                  onPressed: () => _showAllReviews(context),
                  child: Text(
                      '${reviews.length - maxReviews} weitere Bewertungen anzeigen'),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  void _showAllReviews(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _AllReviewsPage(proUid: proUid),
      ),
    );
  }
}

/// Full-screen page showing all reviews for a pro
class _AllReviewsPage extends StatelessWidget {
  final String proUid;

  const _AllReviewsPage({required this.proUid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alle Bewertungen'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Rating summary header
          Padding(
            padding: const EdgeInsets.all(16),
            child: ProRatingSection(
              proUid: proUid,
              showAllReviews: false, // Just show summary, not recursive
            ),
          ),

          const Divider(),

          // All reviews
          Expanded(
            child: ReviewsList(proUid: proUid),
          ),
        ],
      ),
    );
  }
}

/// Compact rating display for cards and lists
class ProRatingCompact extends ConsumerWidget {
  final String proUid;
  final bool showCount;

  const ProRatingCompact({
    super.key,
    required this.proUid,
    this.showCount = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ratingAggregateAsync = ref.watch(proRatingAggregateProvider(proUid));

    return ratingAggregateAsync.when(
      loading: () => const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (error, stack) => const Icon(
        Icons.error,
        size: 16,
        color: Colors.red,
      ),
      data: (aggregate) {
        if (aggregate.count == 0) {
          return Text(
            'Keine Bewertungen',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          );
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CompactStarRating(
              rating: aggregate.average,
              starSize: 14,
              showValue: false,
            ),
            const SizedBox(width: 4),
            Text(
              aggregate.average.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (showCount) ...[
              const SizedBox(width: 4),
              Text(
                '(${aggregate.count})',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        );
      },
    );
  }
}

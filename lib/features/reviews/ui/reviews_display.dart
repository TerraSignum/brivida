import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brivida_app/core/i18n/app_localizations.dart';
import 'package:brivida_app/core/models/review.dart';
import 'package:brivida_app/features/reviews/ui/widgets/star_rating.dart';
import 'package:brivida_app/features/reviews/logic/reviews_controller.dart';

/// Widget to display a single review
class ReviewCard extends StatelessWidget {
  final Review review;
  final bool showProInfo;
  final bool showModerationActions;
  final VoidCallback? onModerationChanged;

  const ReviewCard({
    super.key,
    required this.review,
    this.showProInfo = false,
    this.showModerationActions = false,
    this.onModerationChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with rating and customer info
            Row(
              children: [
                CompactStarRating(
                  rating: review.rating.toDouble(),
                  showValue: false,
                ),
                const SizedBox(width: 8),
                Text(
                  review.anonymizedCustomerName,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Text(
                  _formatDate(l10n, review.createdAt),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ),

            // Comment
            if (review.hasComment) ...[
              const SizedBox(height: 12),
              Text(
                review.comment,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],

            // Pro info (if showing in customer's review list)
            if (showProInfo) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  l10n.translate(
                    'reviews.card.proInfo',
                    namedArgs: {'name': review.proUid},
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],

            // Moderation status and actions
            if (showModerationActions || !review.isVisible) ...[
              const SizedBox(height: 12),
              _ModerationSection(
                review: review,
                showActions: showModerationActions,
                onModerationChanged: onModerationChanged,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(AppLocalizations l10n, DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      final count = difference.inDays;
      return l10n.translate(
        'reviews.card.time.days',
        namedArgs: {'count': '$count'},
      );
    } else if (difference.inHours > 0) {
      final count = difference.inHours;
      return l10n.translate(
        'reviews.card.time.hours',
        namedArgs: {'count': '$count'},
      );
    } else if (difference.inMinutes > 0) {
      final count = difference.inMinutes;
      return l10n.translate(
        'reviews.card.time.minutes',
        namedArgs: {'count': '$count'},
      );
    } else {
      return l10n.translate('reviews.card.time.now');
    }
  }
}

/// Widget for moderation section
class _ModerationSection extends ConsumerWidget {
  final Review review;
  final bool showActions;
  final VoidCallback? onModerationChanged;

  const _ModerationSection({
    required this.review,
    required this.showActions,
    this.onModerationChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        // Moderation status
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getModerationColor(review.moderation.status),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            l10n.translate(
              'reviews.moderation.status.${review.moderation.status.name}',
            ),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        // Moderation reason
        if (review.moderation.reason != null) ...[
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.translate(
                'reviews.moderation.reasonLabel',
                namedArgs: {'reason': review.moderation.reason!},
              ),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
          ),
        ],

        // Admin actions
        if (showActions) ...[
          const SizedBox(width: 8),
          PopupMenuButton<ReviewModerationStatus>(
            icon: const Icon(Icons.more_vert, size: 16),
            onSelected: (action) =>
                _handleModerationAction(context, ref, action),
            itemBuilder: (context) => [
              if (review.moderation.status != ReviewModerationStatus.visible)
                PopupMenuItem(
                  value: ReviewModerationStatus.visible,
                  child: Row(
                    children: [
                      const Icon(Icons.visibility, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        l10n.translate('reviews.moderation.menu.makeVisible'),
                      ),
                    ],
                  ),
                ),
              if (review.moderation.status != ReviewModerationStatus.hidden)
                PopupMenuItem(
                  value: ReviewModerationStatus.hidden,
                  child: Row(
                    children: [
                      const Icon(Icons.visibility_off, size: 16),
                      const SizedBox(width: 8),
                      Text(l10n.translate('reviews.moderation.menu.hide')),
                    ],
                  ),
                ),
              if (review.moderation.status != ReviewModerationStatus.flagged)
                PopupMenuItem(
                  value: ReviewModerationStatus.flagged,
                  child: Row(
                    children: [
                      const Icon(Icons.flag, size: 16),
                      const SizedBox(width: 8),
                      Text(l10n.translate('reviews.moderation.menu.flag')),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }

  Color _getModerationColor(ReviewModerationStatus status) {
    switch (status) {
      case ReviewModerationStatus.visible:
        return Colors.green;
      case ReviewModerationStatus.hidden:
        return Colors.red;
      case ReviewModerationStatus.flagged:
        return Colors.orange;
    }
  }

  Future<void> _handleModerationAction(
    BuildContext context,
    WidgetRef ref,
    ReviewModerationStatus action,
  ) async {
    final l10n = AppLocalizations.of(context);

    // Show confirmation dialog for destructive actions
    if (action == ReviewModerationStatus.hidden) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.translate('reviews.moderation.dialogs.hide.title')),
          content: Text(l10n.translate('reviews.moderation.dialogs.hide.body')),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(l10n.translate('common.cancel')),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text(
                l10n.translate('reviews.moderation.dialogs.hide.confirm'),
              ),
            ),
          ],
        ),
      );

      if (!context.mounted) return;

      if (confirmed != true) return;
    }

    // Show reason input for flagged status
    String? reason;
    if (action == ReviewModerationStatus.flagged) {
      try {
        reason = await showDialog<String>(
          context: context,
          builder: (context) => const _ReasonInputDialog(),
        );
      } catch (e) {
        // Context may not be valid anymore
        return;
      }

      if (!context.mounted) return;

      if (reason == null) return;
    }

    // Perform the moderation action
    try {
      final request = ReviewModerationRequest(
        reviewId: review.firestoreId,
        action: action,
        reason: reason,
      );

      await ref
          .read(reviewsControllerProvider.notifier)
          .moderateReview(request);
      onModerationChanged?.call();

      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.translate(
              'reviews.moderation.snackbar.success',
              namedArgs: {
                'status': l10n
                    .translate('reviews.moderation.status.${action.name}')
                    .toLowerCase(),
              },
            ),
          ),
        ),
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.translate(
                'reviews.moderation.snackbar.error',
                namedArgs: {'error': e.toString()},
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

/// Dialog for entering moderation reason
class _ReasonInputDialog extends StatefulWidget {
  const _ReasonInputDialog();

  @override
  State<_ReasonInputDialog> createState() => _ReasonInputDialogState();
}

class _ReasonInputDialogState extends State<_ReasonInputDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(l10n.translate('reviews.moderation.dialogs.reason.title')),
      content: TextField(
        controller: _controller,
        maxLines: 3,
        decoration: InputDecoration(
          labelText: l10n.translate('reviews.moderation.dialogs.reason.label'),
          hintText: l10n.translate('reviews.moderation.dialogs.reason.hint'),
        ),
        maxLength: 200,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.translate('common.cancel')),
        ),
        ElevatedButton(
          onPressed: () {
            final reason = _controller.text.trim();
            if (reason.isNotEmpty) {
              Navigator.of(context).pop(reason);
            }
          },
          child: Text(
            l10n.translate('reviews.moderation.dialogs.reason.confirm'),
          ),
        ),
      ],
    );
  }
}

/// Widget to display list of reviews
class ReviewsList extends ConsumerWidget {
  final String? proUid;
  final bool showProInfo;
  final bool showModerationActions;
  final ReviewModerationStatus? filterStatus;

  const ReviewsList({
    super.key,
    this.proUid,
    this.showProInfo = false,
    this.showModerationActions = false,
    this.filterStatus,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    if (proUid != null) {
      // Show reviews for a specific pro
      final reviewsAsync = ref.watch(proReviewsStreamProvider(proUid!));

      return reviewsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          final message = error.toString();
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  l10n.translate(
                    'reviews.list.loadingError',
                    namedArgs: {'error': message},
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      ref.refresh(proReviewsStreamProvider(proUid!)),
                  child: Text(l10n.translate('common.retry')),
                ),
              ],
            ),
          );
        },
        data: (reviews) {
          if (reviews.isEmpty) {
            final theme = Theme.of(context);
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.rate_review, size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    l10n.translate('reviews.list.empty.title'),
                    style: theme.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.translate('reviews.list.empty.subtitle'),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return ReviewCard(
                review: review,
                showProInfo: showProInfo,
                showModerationActions: showModerationActions,
                onModerationChanged: () {
                  // ignore: unused_result
                  ref.refresh(proReviewsStreamProvider(proUid!));
                },
              );
            },
          );
        },
      );
    } else {
      // Show user's reviews or all reviews for admin
      final params = ReviewsListParams(
        type: showModerationActions
            ? ReviewsListType.allReviews
            : ReviewsListType.myReviews,
        status: filterStatus,
        limit: 50,
      );

      final reviewsAsync = ref.watch(reviewsListProvider(params));

      return reviewsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          final message = error.toString();
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  l10n.translate(
                    'reviews.list.loadingError',
                    namedArgs: {'error': message},
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.refresh(reviewsListProvider(params)),
                  child: Text(l10n.translate('common.retry')),
                ),
              ],
            ),
          );
        },
        data: (reviews) {
          if (reviews.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.rate_review, size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    l10n.translate('reviews.list.noneFound'),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              // ignore: unused_result
              ref.refresh(reviewsListProvider(params));
            },
            child: ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                final review = reviews[index];
                return ReviewCard(
                  review: review,
                  showProInfo: showProInfo,
                  showModerationActions: showModerationActions,
                  onModerationChanged: () {
                    // ignore: unused_result
                    ref.refresh(reviewsListProvider(params));
                  },
                );
              },
            ),
          );
        },
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:brivida_app/core/i18n/app_localizations.dart';
import 'package:brivida_app/core/models/review.dart';
import 'package:brivida_app/features/reviews/ui/widgets/star_rating.dart';
import 'package:brivida_app/features/reviews/logic/reviews_controller.dart';

/// Dialog for submitting a review for a completed job
class ReviewSubmissionDialog extends ConsumerStatefulWidget {
  final String jobId;
  final String paymentId;
  final String proName;

  const ReviewSubmissionDialog({
    super.key,
    required this.jobId,
    required this.paymentId,
    required this.proName,
  });

  @override
  ConsumerState<ReviewSubmissionDialog> createState() =>
      _ReviewSubmissionDialogState();
}

class _ReviewSubmissionDialogState
    extends ConsumerState<ReviewSubmissionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  int _rating = 0;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitReview() async {
    final l10n = AppLocalizations.of(context);

    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.translate('reviews.submission.missingRating')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final request = ReviewSubmissionRequest(
        jobId: widget.jobId,
        paymentId: widget.paymentId,
        rating: _rating,
        comment: _commentController.text.trim(),
      );

      await ref.read(reviewsControllerProvider.notifier).submitReview(request);

      if (mounted) {
        Navigator.of(context).pop(true); // Return true to indicate success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.translate(
                'reviews.submission.success',
                namedArgs: {'name': widget.proName},
              ),
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.translate(
                'reviews.submission.error',
                namedArgs: {'error': e.toString()},
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.rate_review, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.translate('reviews.submission.title'),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                IconButton(
                  onPressed: _isSubmitting
                      ? null
                      : () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Pro name
            Text(
              l10n.translate(
                'reviews.submission.for',
                namedArgs: {'name': widget.proName},
              ),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),

            // Star rating
            Text(
              l10n.translate('reviews.submission.ratingPrompt'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),

            Center(
              child: StarRating(
                initialRating: _rating,
                starSize: 40,
                onRatingChanged: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
            ),

            if (_rating > 0) ...[
              const SizedBox(height: 8),
              Center(
                child: Text(
                  _getRatingText(l10n, _rating),
                  style: TextStyle(
                    color: _getRatingColor(_rating),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Comment form
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.translate('reviews.submission.commentLabel'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _commentController,
                    maxLines: 4,
                    maxLength: 500,
                    decoration: InputDecoration(
                      hintText: l10n.translate(
                        'reviews.submission.commentHint',
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value != null && value.length > 500) {
                        return l10n.translate(
                          'reviews.submission.commentValidation',
                        );
                      }
                      return null;
                    },
                    enabled: !_isSubmitting,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Submit buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isSubmitting
                      ? null
                      : () => Navigator.of(context).pop(),
                  child: Text(l10n.translate('common.cancel')),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitReview,
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.translate('reviews.submission.submit')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getRatingText(AppLocalizations l10n, int rating) {
    return l10n.translate('reviews.submission.ratingText.$rating');
  }

  Color _getRatingColor(int rating) {
    switch (rating) {
      case 1:
      case 2:
        return Colors.red;
      case 3:
        return Colors.orange;
      case 4:
      case 5:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

/// Button widget to trigger review submission
class ReviewButton extends ConsumerWidget {
  final String jobId;
  final String paymentId;
  final String proName;
  final VoidCallback? onReviewSubmitted;

  const ReviewButton({
    super.key,
    required this.jobId,
    required this.paymentId,
    required this.proName,
    this.onReviewSubmitted,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return FutureBuilder<bool>(
      future: ref
          .read(reviewsControllerProvider.notifier)
          .hasReviewedJob(jobId),
      builder: (context, snapshot) {
        final hasReviewed = snapshot.data ?? false;

        if (hasReviewed) {
          return OutlinedButton.icon(
            onPressed: null,
            icon: const Icon(Icons.check_circle, color: Colors.green),
            label: Text(l10n.translate('reviews.buttons.reviewed')),
          );
        }

        return ElevatedButton.icon(
          onPressed: () async {
            final result = await showDialog<bool>(
              context: context,
              builder: (context) => ReviewSubmissionDialog(
                jobId: jobId,
                paymentId: paymentId,
                proName: proName,
              ),
            );

            if (result == true) {
              onReviewSubmitted?.call();
            }
          },
          icon: const Icon(Icons.rate_review),
          label: Text(l10n.translate('reviews.buttons.review')),
        );
      },
    );
  }
}

/// Helper function to show review dialog
Future<bool?> showReviewDialog(
  BuildContext context, {
  required String jobId,
  required String paymentId,
  required String proName,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => ReviewSubmissionDialog(
      jobId: jobId,
      paymentId: paymentId,
      proName: proName,
    ),
  );
}

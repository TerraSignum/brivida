import 'package:brivida_app/core/i18n/app_localizations.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'review.freezed.dart';
part 'review.g.dart';

/// Enum for review moderation status
enum ReviewModerationStatus {
  @JsonValue('visible')
  visible,
  @JsonValue('hidden')
  hidden,
  @JsonValue('flagged')
  flagged,
}

extension ReviewModerationStatusExt on ReviewModerationStatus {
  String displayName(AppLocalizations l10n) {
    return l10n.translate('reviews.moderation.status.$name');
  }

  String get name {
    switch (this) {
      case ReviewModerationStatus.visible:
        return 'visible';
      case ReviewModerationStatus.hidden:
        return 'hidden';
      case ReviewModerationStatus.flagged:
        return 'flagged';
    }
  }
}

/// Review moderation information
@freezed
abstract class ReviewModeration with _$ReviewModeration {
  const factory ReviewModeration({
    required ReviewModerationStatus status,
    String? reason,
    String? adminUid,
    required DateTime updatedAt,
  }) = _ReviewModeration;

  factory ReviewModeration.fromJson(Map<String, dynamic> json) =>
      _$ReviewModerationFromJson(json);

  /// Default visible moderation for new reviews
  factory ReviewModeration.visible() {
    return ReviewModeration(
      status: ReviewModerationStatus.visible,
      updatedAt: DateTime.now(),
    );
  }

  /// Create moderation action
  factory ReviewModeration.action({
    required ReviewModerationStatus status,
    String? reason,
    required String adminUid,
  }) {
    return ReviewModeration(
      status: status,
      reason: reason,
      adminUid: adminUid,
      updatedAt: DateTime.now(),
    );
  }
}

/// Customer review for a completed job
@freezed
abstract class Review with _$Review {
  const Review._();

  const factory Review({
    required String firestoreId,
    required String jobId,
    required String paymentId,
    required String customerUid,
    required String proUid,
    required int rating, // 1-5 stars
    required String comment, // max 500 chars
    required DateTime createdAt,
    required ReviewModeration moderation,

    // Optional customer info for display (anonymized)
    String? customerDisplayName,
    String? customerInitials,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);

  /// Create from Firestore document
  factory Review.fromFirestore(Map<String, dynamic> data, String id) {
    return Review.fromJson({
      ...data,
      'firestoreId': id,
      'createdAt': (data['createdAt'] as Timestamp?)
          ?.toDate()
          .toIso8601String(),
      'moderation': {
        ...data['moderation'] ?? {},
        'updatedAt':
            (data['moderation']?['updatedAt'] as Timestamp?)
                ?.toDate()
                .toIso8601String() ??
            DateTime.now().toIso8601String(),
      },
    });
  }

  /// Convert to Firestore format
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('firestoreId');

    // Convert DateTime to Timestamp
    json['createdAt'] = Timestamp.fromDate(createdAt);

    // Convert moderation updatedAt
    if (json['moderation'] != null) {
      final moderationData = json['moderation'] as Map<String, dynamic>;
      if (moderationData['updatedAt'] != null) {
        moderationData['updatedAt'] = Timestamp.fromDate(moderation.updatedAt);
      }
    }

    return json;
  }
}

/// Extension for review business logic
extension ReviewExt on Review {
  /// Check if review is visible to public
  bool get isVisible => moderation.status == ReviewModerationStatus.visible;

  /// Check if review is hidden by admin
  bool get isHidden => moderation.status == ReviewModerationStatus.hidden;

  /// Check if review is flagged for review
  bool get isFlagged => moderation.status == ReviewModerationStatus.flagged;

  /// Get anonymized customer name for display
  String get anonymizedCustomerName {
    if (customerDisplayName != null && customerDisplayName!.isNotEmpty) {
      return '${customerDisplayName![0]}***';
    }
    if (customerInitials != null && customerInitials!.isNotEmpty) {
      return customerInitials!;
    }
    return 'Kunde';
  }

  /// Get star display string
  String get starsDisplay => '★' * rating + '☆' * (5 - rating);

  /// Check if comment is empty or placeholder
  bool get hasComment => comment.trim().isNotEmpty;

  /// Get truncated comment for list display
  String commentPreview(int maxLength) {
    if (comment.length <= maxLength) return comment;
    return '${comment.substring(0, maxLength)}...';
  }

  /// Validate review data
  List<String> validate() {
    final errors = <String>[];

    if (rating < 1 || rating > 5) {
      errors.add('Bewertung muss zwischen 1 und 5 Sternen liegen');
    }

    if (comment.length > 500) {
      errors.add('Kommentar darf maximal 500 Zeichen haben');
    }

    if (jobId.isEmpty) {
      errors.add('Job-ID ist erforderlich');
    }

    if (paymentId.isEmpty) {
      errors.add('Payment-ID ist erforderlich');
    }

    if (customerUid.isEmpty) {
      errors.add('Kunden-ID ist erforderlich');
    }

    if (proUid.isEmpty) {
      errors.add('Pro-ID ist erforderlich');
    }

    return errors;
  }
}

/// Rating aggregation for pro profiles
@freezed
abstract class RatingAggregate with _$RatingAggregate {
  const factory RatingAggregate({
    @Default(0.0) double average,
    @Default(0) int count,
    @Default({}) Map<int, int> distribution, // star -> count
  }) = _RatingAggregate;

  factory RatingAggregate.fromJson(Map<String, dynamic> json) =>
      _$RatingAggregateFromJson(json);
}

/// Extension for rating calculations
extension RatingAggregateExt on RatingAggregate {
  /// Add a new rating to the aggregate
  RatingAggregate addRating(int rating) {
    final newCount = this.count + 1;
    final newSum = (this.average * this.count) + rating;
    final newAverage = newSum / newCount;

    final newDistribution = Map<int, int>.from(distribution);
    newDistribution[rating] = (newDistribution[rating] ?? 0) + 1;

    return copyWith(
      average: newAverage,
      count: newCount,
      distribution: newDistribution,
    );
  }

  /// Remove a rating from the aggregate
  RatingAggregate removeRating(int rating) {
    if (this.count <= 1) {
      return const RatingAggregate(); // Reset to empty
    }

    final newCount = this.count - 1;
    final currentSum = this.average * this.count;
    final newSum = currentSum - rating;
    final newAverage = newSum / newCount;

    final newDistribution = Map<int, int>.from(distribution);
    if (newDistribution[rating] != null && newDistribution[rating]! > 0) {
      newDistribution[rating] = newDistribution[rating]! - 1;
      if (newDistribution[rating] == 0) {
        newDistribution.remove(rating);
      }
    }

    return copyWith(
      average: newAverage,
      count: newCount,
      distribution: newDistribution,
    );
  }

  /// Get percentage for each star rating
  Map<int, double> get percentageDistribution {
    if (this.count == 0) return {};

    return distribution.map(
      (star, starCount) => MapEntry(star, (starCount / this.count) * 100),
    );
  }

  /// Get star display with average
  String get starsDisplay {
    if (this.count == 0) return 'Noch keine Bewertungen';

    final fullStars = this.average.floor();
    final hasHalfStar = (this.average - fullStars) >= 0.5;

    String display = '★' * fullStars;
    if (hasHalfStar) display += '☆';
    display += '☆' * (5 - fullStars - (hasHalfStar ? 1 : 0));

    return '$display (${this.average.toStringAsFixed(1)} • ${this.count} Bewertungen)';
  }
}

/// Review submission request
@freezed
abstract class ReviewSubmissionRequest with _$ReviewSubmissionRequest {
  const factory ReviewSubmissionRequest({
    required String jobId,
    required String paymentId,
    required int rating,
    required String comment,
  }) = _ReviewSubmissionRequest;

  factory ReviewSubmissionRequest.fromJson(Map<String, dynamic> json) =>
      _$ReviewSubmissionRequestFromJson(json);
}

/// Admin moderation request
@freezed
abstract class ReviewModerationRequest with _$ReviewModerationRequest {
  const factory ReviewModerationRequest({
    required String reviewId,
    required ReviewModerationStatus action,
    String? reason,
  }) = _ReviewModerationRequest;

  factory ReviewModerationRequest.fromJson(Map<String, dynamic> json) =>
      _$ReviewModerationRequestFromJson(json);
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brivida_app/core/config/admin_whitelist.dart';
import 'package:brivida_app/core/models/review.dart';
import 'package:brivida_app/core/models/job.dart';
import 'package:brivida_app/core/exceptions/app_exceptions.dart';

/// Repository for managing reviews data
class ReviewsRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ReviewsRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  /// Collection references
  CollectionReference<Map<String, dynamic>> get _reviewsCollection =>
      _firestore.collection('reviews');

  CollectionReference<Map<String, dynamic>> get _proProfilesCollection =>
      _firestore.collection('proProfiles');

  CollectionReference<Map<String, dynamic>> get _jobsCollection =>
      _firestore.collection('jobs');

  CollectionReference<Map<String, dynamic>> get _paymentsCollection =>
      _firestore.collection('payments');

  /// Get current user
  User? get _currentUser => _auth.currentUser;

  Future<void> _assertAdminAccess() async {
    final user = _currentUser;
    if (user == null) {
      throw const AppException.notAuthenticated();
    }

    try {
      final tokenResult = await user.getIdTokenResult();
      final claims = tokenResult.claims ?? {};
      final roleClaim = claims['role'] as String?;

      final isAdmin =
          roleClaim == 'admin' || AdminWhitelist.contains(user.email);

      if (!isAdmin) {
        throw const AppException.forbidden(
          message: 'Admin privileges required',
        );
      }
    } catch (error) {
      if (error is AppException) rethrow;
      throw AppException.unknown(message: error.toString());
    }
  }

  /// Submit a new review for a completed job
  ///
  /// Validates job completion, payment status, and prevents duplicate reviews
  Future<Review> submitReview(ReviewSubmissionRequest request) async {
    if (_currentUser == null) {
      throw const AppException.notAuthenticated();
    }

    final customerUid = _currentUser!.uid;

    try {
      // Validate the request
      final validationErrors = _validateReviewRequest(request);
      if (validationErrors.isNotEmpty) {
        throw AppException.validation(
          message: 'Ungültige Review-Daten',
          details: validationErrors,
        );
      }

      // Use a transaction to ensure data consistency
      return await _firestore.runTransaction<Review>((transaction) async {
        // 1. Verify job exists and belongs to customer
        final jobDoc = await transaction.get(
          _jobsCollection.doc(request.jobId),
        );
        if (!jobDoc.exists) {
          throw const AppException.notFound(resource: 'Job');
        }

        final jobData = jobDoc.data()!;
        if (jobData['customerUid'] != customerUid) {
          throw const AppException.forbidden();
        }

        // 2. Verify job is completed
        if (jobData['status'] != JobStatus.completed.name) {
          throw const AppException.validation(
            message: 'Job muss abgeschlossen sein für eine Bewertung',
          );
        }

        // 3. Verify payment exists and is completed
        final paymentDoc = await transaction.get(
          _paymentsCollection.doc(request.paymentId),
        );
        if (!paymentDoc.exists) {
          throw const AppException.notFound(resource: 'Payment');
        }

        final paymentData = paymentDoc.data()!;
        if (paymentData['jobId'] != request.jobId) {
          throw const AppException.validation(
            message: 'Payment gehört nicht zu diesem Job',
          );
        }

        if (paymentData['status'] != 'completed') {
          throw const AppException.validation(
            message: 'Payment muss abgeschlossen sein für eine Bewertung',
          );
        }

        final proUid = jobData['proUid'] as String;

        // 4. Check for duplicate review
        final existingReviews = await _reviewsCollection
            .where('jobId', isEqualTo: request.jobId)
            .where('customerUid', isEqualTo: customerUid)
            .limit(1)
            .get();

        if (existingReviews.docs.isNotEmpty) {
          throw const AppException.validation(
            message: 'Es existiert bereits eine Bewertung für diesen Job',
          );
        }

        // 5. Get customer data for anonymization
        final customerDoc = await transaction.get(
          _firestore.collection('users').doc(customerUid),
        );
        final customerData = customerDoc.data() ?? {};

        final customerDisplayName = customerData['displayName'] as String?;
        final customerInitials = _generateInitials(customerDisplayName);

        // 6. Create the review
        final review = Review(
          firestoreId: '', // Will be set after creation
          jobId: request.jobId,
          paymentId: request.paymentId,
          customerUid: customerUid,
          proUid: proUid,
          rating: request.rating,
          comment: request.comment,
          createdAt: DateTime.now(),
          moderation: ReviewModeration.visible(),
          customerDisplayName: customerDisplayName,
          customerInitials: customerInitials,
        );

        // 7. Save review to Firestore
        final reviewRef = _reviewsCollection.doc();
        transaction.set(reviewRef, review.toFirestore());

        // 8. Update pro profile rating aggregate
        final proProfileDoc = await transaction.get(
          _proProfilesCollection.doc(proUid),
        );
        if (proProfileDoc.exists) {
          final proData = proProfileDoc.data()!;
          final currentAggregate = RatingAggregate.fromJson(
            proData['ratingAggregate'] ?? {},
          );

          final newAggregate = currentAggregate.addRating(request.rating);

          transaction.update(_proProfilesCollection.doc(proUid), {
            'ratingAggregate': newAggregate.toJson(),
            'averageRating': newAggregate.average,
            'reviewCount': newAggregate.count,
          });
        }

        return review.copyWith(firestoreId: reviewRef.id);
      });
    } on FirebaseException catch (e) {
      throw AppException.fromFirestore(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException.unknown(message: e.toString());
    }
  }

  /// Get all reviews for a specific pro
  Future<List<Review>> listProReviews(
    String proUid, {
    int? limit,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _reviewsCollection
          .where('proUid', isEqualTo: proUid)
          .where(
            'moderation.status',
            isEqualTo: ReviewModerationStatus.visible.name,
          )
          .orderBy('createdAt', descending: true);

      if (limit != null) {
        query = query.limit(limit);
      }

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final snapshot = await query.get();

      return snapshot.docs.map((doc) {
        return Review.fromFirestore(doc.data(), doc.id);
      }).toList();
    } on FirebaseException catch (e) {
      throw AppException.fromFirestore(e);
    } catch (e) {
      throw AppException.unknown(message: e.toString());
    }
  }

  /// Get reviews submitted by current user
  Future<List<Review>> listMyReviews({
    int? limit,
    DocumentSnapshot? startAfter,
  }) async {
    if (_currentUser == null) {
      throw const AppException.notAuthenticated();
    }

    try {
      Query<Map<String, dynamic>> query = _reviewsCollection
          .where('customerUid', isEqualTo: _currentUser!.uid)
          .orderBy('createdAt', descending: true);

      if (limit != null) {
        query = query.limit(limit);
      }

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final snapshot = await query.get();

      return snapshot.docs.map((doc) {
        return Review.fromFirestore(doc.data(), doc.id);
      }).toList();
    } on FirebaseException catch (e) {
      throw AppException.fromFirestore(e);
    } catch (e) {
      throw AppException.unknown(message: e.toString());
    }
  }

  /// Get all reviews for admin moderation (admin only)
  Future<List<Review>> listAllReviews({
    ReviewModerationStatus? status,
    int? limit,
    DocumentSnapshot? startAfter,
  }) async {
    if (_currentUser == null) {
      throw const AppException.notAuthenticated();
    }

    await _assertAdminAccess();

    try {
      Query<Map<String, dynamic>> query = _reviewsCollection.orderBy(
        'createdAt',
        descending: true,
      );

      if (status != null) {
        query = query.where('moderation.status', isEqualTo: status.name);
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }

      final snapshot = await query.get();

      return snapshot.docs.map((doc) {
        return Review.fromFirestore(doc.data(), doc.id);
      }).toList();
    } on FirebaseException catch (e) {
      throw AppException.fromFirestore(e);
    } catch (e) {
      throw AppException.unknown(message: e.toString());
    }
  }

  /// Moderate a review (admin only)
  Future<void> moderateReview(ReviewModerationRequest request) async {
    if (_currentUser == null) {
      throw const AppException.notAuthenticated();
    }

    await _assertAdminAccess();
    final adminUid = _currentUser!.uid;

    try {
      await _firestore.runTransaction((transaction) async {
        // Get the review
        final reviewDoc = await transaction.get(
          _reviewsCollection.doc(request.reviewId),
        );
        if (!reviewDoc.exists) {
          throw const AppException.notFound(resource: 'Review');
        }

        final reviewData = reviewDoc.data()!;
        final currentReview = Review.fromFirestore(
          reviewData,
          request.reviewId,
        );

        // If hiding a visible review, update pro rating aggregate
        if (currentReview.moderation.status == ReviewModerationStatus.visible &&
            request.action == ReviewModerationStatus.hidden) {
          final proUid = currentReview.proUid;
          final proProfileDoc = await transaction.get(
            _proProfilesCollection.doc(proUid),
          );

          if (proProfileDoc.exists) {
            final proData = proProfileDoc.data()!;
            final currentAggregate = RatingAggregate.fromJson(
              proData['ratingAggregate'] ?? {},
            );

            final newAggregate = currentAggregate.removeRating(
              currentReview.rating,
            );

            transaction.update(_proProfilesCollection.doc(proUid), {
              'ratingAggregate': newAggregate.toJson(),
              'averageRating': newAggregate.average,
              'reviewCount': newAggregate.count,
            });
          }
        }

        // If making a hidden review visible, add back to aggregate
        if (currentReview.moderation.status == ReviewModerationStatus.hidden &&
            request.action == ReviewModerationStatus.visible) {
          final proUid = currentReview.proUid;
          final proProfileDoc = await transaction.get(
            _proProfilesCollection.doc(proUid),
          );

          if (proProfileDoc.exists) {
            final proData = proProfileDoc.data()!;
            final currentAggregate = RatingAggregate.fromJson(
              proData['ratingAggregate'] ?? {},
            );

            final newAggregate = currentAggregate.addRating(
              currentReview.rating,
            );

            transaction.update(_proProfilesCollection.doc(proUid), {
              'ratingAggregate': newAggregate.toJson(),
              'averageRating': newAggregate.average,
              'reviewCount': newAggregate.count,
            });
          }
        }

        // Update review moderation
        final newModeration = ReviewModeration.action(
          status: request.action,
          reason: request.reason,
          adminUid: adminUid,
        );

        transaction.update(_reviewsCollection.doc(request.reviewId), {
          'moderation': newModeration.toJson(),
        });
      });
    } on FirebaseException catch (e) {
      throw AppException.fromFirestore(e);
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException.unknown(message: e.toString());
    }
  }

  /// Get review by ID
  Future<Review?> getReview(String reviewId) async {
    try {
      final doc = await _reviewsCollection.doc(reviewId).get();
      if (!doc.exists) return null;

      return Review.fromFirestore(doc.data()!, doc.id);
    } on FirebaseException catch (e) {
      throw AppException.fromFirestore(e);
    } catch (e) {
      throw AppException.unknown(message: e.toString());
    }
  }

  /// Check if user has already reviewed a job
  Future<bool> hasReviewedJob(String jobId) async {
    if (_currentUser == null) return false;

    try {
      final snapshot = await _reviewsCollection
          .where('jobId', isEqualTo: jobId)
          .where('customerUid', isEqualTo: _currentUser!.uid)
          .limit(1)
          .get();

      return snapshot.docs.isNotEmpty;
    } on FirebaseException catch (e) {
      throw AppException.fromFirestore(e);
    } catch (e) {
      throw AppException.unknown(message: e.toString());
    }
  }

  /// Get rating aggregate for a pro
  Future<RatingAggregate> getProRatingAggregate(String proUid) async {
    try {
      final doc = await _proProfilesCollection.doc(proUid).get();
      if (!doc.exists) {
        return const RatingAggregate();
      }

      final data = doc.data()!;
      return RatingAggregate.fromJson(data['ratingAggregate'] ?? {});
    } on FirebaseException catch (e) {
      throw AppException.fromFirestore(e);
    } catch (e) {
      throw AppException.unknown(message: e.toString());
    }
  }

  /// Stream reviews for a pro (real-time updates)
  Stream<List<Review>> streamProReviews(String proUid, {int? limit}) {
    Query<Map<String, dynamic>> query = _reviewsCollection
        .where('proUid', isEqualTo: proUid)
        .where(
          'moderation.status',
          isEqualTo: ReviewModerationStatus.visible.name,
        )
        .orderBy('createdAt', descending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Review.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }

  /// Validate review submission request
  List<String> _validateReviewRequest(ReviewSubmissionRequest request) {
    final errors = <String>[];

    if (request.jobId.isEmpty) {
      errors.add('Job-ID ist erforderlich');
    }

    if (request.paymentId.isEmpty) {
      errors.add('Payment-ID ist erforderlich');
    }

    if (request.rating < 1 || request.rating > 5) {
      errors.add('Bewertung muss zwischen 1 und 5 Sternen liegen');
    }

    if (request.comment.length > 500) {
      errors.add('Kommentar darf maximal 500 Zeichen haben');
    }

    // Optional: Check for spam/inappropriate content
    if (_containsInappropriateContent(request.comment)) {
      errors.add('Kommentar enthält unangemessene Inhalte');
    }

    return errors;
  }

  /// Basic spam/inappropriate content detection
  bool _containsInappropriateContent(String text) {
    final lowercaseText = text.toLowerCase();

    // Basic blacklist - should be expanded in production
    const inappropriateWords = [
      'spam',
      'scam',
      'fake',
      // Add more inappropriate words as needed
    ];

    for (final word in inappropriateWords) {
      if (lowercaseText.contains(word)) {
        return true;
      }
    }

    // Check for suspicious patterns
    if (text.contains(RegExp(r'[A-Z]{5,}'))) {
      return true; // Too many consecutive capital letters
    }

    if (text.contains(RegExp(r'(.)\1{4,}'))) {
      return true; // Too many repeated characters
    }

    return false;
  }

  /// Generate initials from display name
  String? _generateInitials(String? displayName) {
    if (displayName == null || displayName.isEmpty) return null;

    final words = displayName.trim().split(' ');
    if (words.length == 1) {
      return words[0][0].toUpperCase();
    }

    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }
}

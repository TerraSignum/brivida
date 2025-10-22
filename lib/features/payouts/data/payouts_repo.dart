import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/models/payment.dart';
import '../../../core/models/payout.dart';
import '../../../core/exceptions/app_exceptions.dart';
import '../../../core/config/admin_whitelist.dart';
import '../../../core/utils/debug_logger.dart';

class PayoutsRepository {
  static const String _transfersCollection = 'transfers';

  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;
  final FirebaseAuth _auth;

  PayoutsRepository({
    FirebaseFirestore? firestore,
    FirebaseFunctions? functions,
    FirebaseAuth? auth,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _functions =
           functions ?? FirebaseFunctions.instanceFor(region: 'europe-west1'),
       _auth = auth ?? FirebaseAuth.instance;

  /// Watch transfers for the current user with optional filtering
  Stream<List<Transfer>> watchMyTransfers({
    DateTime? from,
    DateTime? to,
    String? status,
  }) {
    final user = _auth.currentUser;
    if (user == null) {
      throw const AppException.notAuthenticated();
    }

    // Start with base query filtering by proUid
    Query query = _firestore
        .collection(_transfersCollection)
        .where('proUid', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true);

    // Add date range filters if provided
    if (from != null) {
      query = query.where('createdAt', isGreaterThanOrEqualTo: from);
    }
    if (to != null) {
      query = query.where('createdAt', isLessThanOrEqualTo: to);
    }

    // Add status filter if provided (null means 'all')
    if (status != null && status != 'all') {
      if (status == 'created') {
        query = query.where('status', isEqualTo: 'pending');
      } else if (status == 'failed') {
        query = query.where('status', isEqualTo: 'failed');
      }
    }

    return query
        .limit(100) // Reasonable limit for mobile performance
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => Transfer.fromJson({
                  ...doc.data() as Map<String, dynamic>,
                  'id': doc.id,
                }),
              )
              .toList(),
        );
  }

  /// Get a specific transfer by ID
  Future<Transfer?> getTransfer(String transferId) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const AppException.notAuthenticated();
    }

    try {
      final doc = await _firestore
          .collection(_transfersCollection)
          .doc(transferId)
          .get();

      if (!doc.exists) {
        return null;
      }

      final data = doc.data()!;

      // Security check: only allow access to own transfers or admin
      if (data['proUid'] != user.uid) {
        final userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();
        final userData = userDoc.data();
        final isWhitelistedAdmin = AdminWhitelist.contains(user.email);
        if (userData?['role'] != 'admin' && !isWhitelistedAdmin) {
          throw const AppException.forbidden();
        }
      }

      return Transfer.fromJson({...data, 'id': doc.id});
    } catch (e) {
      DebugLogger.log('Error getting transfer: $e');
      throw const AppException.unknown(
        message: 'Failed to load transfer details',
      );
    }
  }

  /// Export transfers as CSV for the current user
  Future<ExportResult> exportMyTransfersCsv({
    DateTime? from,
    DateTime? to,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const AppException.notAuthenticated();
    }

    try {
      final callable = _functions.httpsCallable('exportMyTransfersCsvCF');
      final result = await callable.call({
        if (from != null) 'from': from.toIso8601String(),
        if (to != null) 'to': to.toIso8601String(),
      });

      final data = result.data as Map<String, dynamic>;

      return ExportResult(
        downloadUrl: data['downloadUrl'] as String,
        filename: data['filename'] as String,
        expiresAt: DateTime.parse(data['expiresAt'] as String),
      );
    } catch (e) {
      DebugLogger.log('Error exporting transfers: $e');
      throw const AppException.unknown(
        message: 'Failed to export transfer data',
      );
    }
  }

  /// Open transfer in Stripe dashboard (test mode)
  Future<bool> openInStripe(String stripeTransferId) async {
    try {
      final url = Uri.parse(
        'https://dashboard.stripe.com/test/connect/transfers/$stripeTransferId',
      );

      final canLaunch = await canLaunchUrl(url);
      if (canLaunch) {
        return await launchUrl(url, mode: LaunchMode.externalApplication);
      }
      return false;
    } catch (e) {
      DebugLogger.log('Error opening Stripe URL: $e');
      return false;
    }
  }

  /// Get transfer statistics for dashboard
  Future<TransferStats> getTransferStats({DateTime? from, DateTime? to}) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const AppException.notAuthenticated();
    }

    try {
      // Base query for user's transfers
      Query query = _firestore
          .collection(_transfersCollection)
          .where('proUid', isEqualTo: user.uid);

      // Add date filters
      if (from != null) {
        query = query.where('createdAt', isGreaterThanOrEqualTo: from);
      }
      if (to != null) {
        query = query.where('createdAt', isLessThanOrEqualTo: to);
      }

      query = query.orderBy('createdAt', descending: true).limit(500);

      final snapshot = await query.get();

      double totalNet = 0;
      double totalGross = 0;
      double totalFees = 0;
      int completedCount = 0;
      int failedCount = 0;

      for (final doc in snapshot.docs) {
        final transfer = Transfer.fromJson({
          ...doc.data() as Map<String, dynamic>,
          'id': doc.id,
        });

        if (transfer.status == TransferStatus.completed) {
          completedCount++;
          totalNet += transfer.amountNet;
          totalGross += transfer.amountGross ?? 0;
          totalFees += transfer.platformFee;
        } else if (transfer.status == TransferStatus.failed) {
          failedCount++;
        }
      }

      return TransferStats(
        totalCount: snapshot.docs.length,
        totalAmountNet: totalNet,
        totalAmountGross: totalGross,
        totalPlatformFees: totalFees,
        pendingCount: snapshot.docs.length - completedCount - failedCount,
        completedCount: completedCount,
        failedCount: failedCount,
      );
    } on FirebaseException catch (error, stackTrace) {
      throw _mapFirebaseError(
        error,
        stackTrace,
        context: 'getTransferStats',
        fallbackMessage: 'Failed to load transfer statistics',
      );
    } catch (error, stackTrace) {
      DebugLogger.error('Error getting transfer stats', error, stackTrace);
      throw const AppException.unknown(
        message: 'Failed to load transfer statistics',
      );
    }
  }

  /// Filter transfers by various criteria
  Future<List<Transfer>> filterTransfers({
    required PayoutFilter filter,
    int limit = 50,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const AppException.notAuthenticated();
    }

    try {
      Query query = _firestore
          .collection(_transfersCollection)
          .where('proUid', isEqualTo: user.uid)
          .orderBy('createdAt', descending: true);

      // Apply filters
      if (filter.from != null) {
        query = query.where('createdAt', isGreaterThanOrEqualTo: filter.from);
      }
      if (filter.to != null) {
        query = query.where('createdAt', isLessThanOrEqualTo: filter.to);
      }
      if (filter.status != null && filter.status != 'all') {
        final firestoreStatus = filter.status == 'created'
            ? 'pending'
            : filter.status!;
        query = query.where('status', isEqualTo: firestoreStatus);
      }

      final snapshot = await query.limit(limit).get();

      return snapshot.docs
          .map(
            (doc) => Transfer.fromJson({
              ...doc.data() as Map<String, dynamic>,
              'id': doc.id,
            }),
          )
          .toList();
    } on FirebaseException catch (error, stackTrace) {
      throw _mapFirebaseError(
        error,
        stackTrace,
        context: 'filterTransfers',
        fallbackMessage: 'Failed to filter transfers',
      );
    } catch (error, stackTrace) {
      DebugLogger.error('Error filtering transfers', error, stackTrace);
      throw const AppException.unknown(message: 'Failed to filter transfers');
    }
  }

  AppException _mapFirebaseError(
    FirebaseException error,
    StackTrace stackTrace, {
    required String context,
    required String fallbackMessage,
  }) {
    DebugLogger.error(
      'Firestore error in $context (${error.code})',
      error,
      stackTrace,
    );

    if (_isMissingIndex(error)) {
      return AppException.firestore(
        message:
            'Firestore index for payouts missing. Deploy composite index on proUid + createdAt.',
        code: 'missing-index',
      );
    }

    return AppException.fromFirestore(error);
  }

  bool _isMissingIndex(FirebaseException error) {
    return error.code == 'failed-precondition' &&
        (error.message?.toLowerCase().contains('index') ?? false);
  }
}

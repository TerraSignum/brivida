// PG-16.1: Job Comfort Features Controller
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';
import '../ui/job_comfort_widget.dart';
import '../../../core/utils/debug_logger.dart';

// Provider for job comfort controller
final jobComfortControllerProvider =
    StateNotifierProvider.family<JobComfortController, JobComfortState, String>(
        (ref, jobId) {
  return JobComfortController(jobId: jobId);
});

class JobComfortController extends StateNotifier<JobComfortState> {
  final String jobId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  JobComfortController({required this.jobId}) : super(const JobComfortState()) {
    _loadComfortState();
  }

  Future<void> _loadComfortState() async {
    try {
      state = state.copyWith(isLoading: true);

      final doc = await _firestore
          .collection('jobs')
          .doc(jobId)
          .collection('comfort')
          .doc('state')
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        state = JobComfortState(
          onMyWayPressed: data['onMyWayPressed'] ?? false,
          onMyWayTime: data['onMyWayTime']?.toDate(),
          arrivalWindow: data['arrivalWindow'] != null
              ? ArrivalWindow(
                  earliest: data['arrivalWindow']['earliest'].toDate(),
                  latest: data['arrivalWindow']['latest'].toDate(),
                )
              : null,
          parkingNotes: data['parkingNotes'] ?? '',
          buildingPhotos: List<String>.from(data['buildingPhotos'] ?? []),
          exactAddressShared: data['exactAddressShared'] ?? false,
          arrivalPin: data['arrivalPin'],
          pinVerified: data['pinVerified'] ?? false,
        );
      }

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> setOnMyWay() async {
    try {
      state = state.copyWith(isLoading: true);

      final now = DateTime.now();

      // Calculate estimated arrival window (30 minutes from now, ±15 minutes)
      final estimatedArrival = now.add(const Duration(minutes: 30));
      final arrivalWindow = ArrivalWindow(
        earliest: estimatedArrival.subtract(const Duration(minutes: 15)),
        latest: estimatedArrival.add(const Duration(minutes: 15)),
      );

      // Generate arrival PIN
      final pin = _generateArrivalPin();

      // Update state
      state = state.copyWith(
        onMyWayPressed: true,
        onMyWayTime: now,
        arrivalWindow: arrivalWindow,
        arrivalPin: pin,
        isLoading: false,
      );

      // Save to Firestore
      await _saveComfortState();

      // Send notification to customer
      await _notifyCustomerOnMyWay();
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> updateParkingNotes(String notes) async {
    state = state.copyWith(parkingNotes: notes);
    await _saveComfortState();

    // Notify customer if notes are not empty
    if (notes.trim().isNotEmpty) {
      await _notifyCustomerParkingUpdate();
    }
  }

  Future<void> addBuildingPhoto(String photoUrl) async {
    final updatedPhotos = [...state.buildingPhotos, photoUrl];
    state = state.copyWith(buildingPhotos: updatedPhotos);
    await _saveComfortState();

    // Notify customer about new building photo
    await _notifyCustomerBuildingPhoto();
  }

  Future<void> toggleAddressSharing(bool share) async {
    state = state.copyWith(exactAddressShared: share);
    await _saveComfortState();

    // Update job document with address sharing preference
    await _updateJobAddressSharing(share);
  }

  Future<void> verifyArrivalPin(String enteredPin) async {
    if (enteredPin == state.arrivalPin) {
      state = state.copyWith(pinVerified: true);
      await _saveComfortState();

      // Update job status to in_progress if verified
      await _updateJobStatusToInProgress();

      // Notify pro of successful verification
      await _notifyProArrivalConfirmed();
    }
  }

  String _generateArrivalPin() {
    final random = Random();
    return (1000 + random.nextInt(9000)).toString(); // 4-digit PIN
  }

  Future<void> _saveComfortState() async {
    try {
      final data = {
        'onMyWayPressed': state.onMyWayPressed,
        'onMyWayTime': state.onMyWayTime,
        'arrivalWindow': state.arrivalWindow != null
            ? {
                'earliest': Timestamp.fromDate(
                    state.arrivalWindow?.earliest ?? DateTime.now()),
                'latest': Timestamp.fromDate(
                    state.arrivalWindow?.latest ?? DateTime.now()),
              }
            : null,
        'parkingNotes': state.parkingNotes,
        'buildingPhotos': state.buildingPhotos,
        'exactAddressShared': state.exactAddressShared,
        'arrivalPin': state.arrivalPin,
        'pinVerified': state.pinVerified,
        'updatedAt': FieldValue.serverTimestamp(),
        'updatedBy': _auth.currentUser?.uid,
      };

      await _firestore
          .collection('jobs')
          .doc(jobId)
          .collection('comfort')
          .doc('state')
          .set(data, SetOptions(merge: true));
    } catch (e) {
      // Handle error silently for now
    }
  }

  Future<void> _notifyCustomerOnMyWay() async {
    try {
      // Get job details
      final jobDoc = await _firestore.collection('jobs').doc(jobId).get();
      if (!jobDoc.exists) return;

      final jobData = jobDoc.data()!;
      final customerUid = jobData['customerUid'];

      if (customerUid != null) {
        // Add notification to customer's notifications collection
        await _firestore
            .collection('users')
            .doc(customerUid)
            .collection('notifications')
            .add({
          'type': 'pro_on_way',
          'title': 'Your pro is on the way!',
          'body':
              'The professional is now heading to your location. Expected arrival: ${_formatArrivalWindow()}',
          'jobId': jobId,
          'createdAt': FieldValue.serverTimestamp(),
          'read': false,
          'data': {
            'arrivalWindow': {
              'earliest': Timestamp.fromDate(
                  state.arrivalWindow?.earliest ?? DateTime.now()),
              'latest': Timestamp.fromDate(
                  state.arrivalWindow?.latest ?? DateTime.now()),
            }
          },
        });

        // Send FCM notification (would need FCM setup)
        await _sendFCMNotification(customerUid, 'pro_on_way');
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _notifyCustomerParkingUpdate() async {
    try {
      final jobDoc = await _firestore.collection('jobs').doc(jobId).get();
      if (!jobDoc.exists) return;

      final jobData = jobDoc.data()!;
      final customerUid = jobData['customerUid'];

      if (customerUid != null) {
        await _firestore
            .collection('users')
            .doc(customerUid)
            .collection('notifications')
            .add({
          'type': 'parking_update',
          'title': 'Parking information updated',
          'body': 'Your pro has shared parking details for your location.',
          'jobId': jobId,
          'createdAt': FieldValue.serverTimestamp(),
          'read': false,
        });

        await _sendFCMNotification(customerUid, 'parking_update');
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _notifyCustomerBuildingPhoto() async {
    try {
      final jobDoc = await _firestore.collection('jobs').doc(jobId).get();
      if (!jobDoc.exists) return;

      final jobData = jobDoc.data()!;
      final customerUid = jobData['customerUid'];

      if (customerUid != null) {
        await _firestore
            .collection('users')
            .doc(customerUid)
            .collection('notifications')
            .add({
          'type': 'building_photo',
          'title': 'New building photo',
          'body':
              'Your pro has shared a photo to help you find their location.',
          'jobId': jobId,
          'createdAt': FieldValue.serverTimestamp(),
          'read': false,
        });

        await _sendFCMNotification(customerUid, 'building_photo');
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _updateJobAddressSharing(bool share) async {
    try {
      await _firestore.collection('jobs').doc(jobId).update({
        'exactAddressShared': share,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _updateJobStatusToInProgress() async {
    try {
      await _firestore.collection('jobs').doc(jobId).update({
        'status': 'in_progress',
        'startedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _notifyProArrivalConfirmed() async {
    try {
      final jobDoc = await _firestore.collection('jobs').doc(jobId).get();
      if (!jobDoc.exists) return;

      final jobData = jobDoc.data()!;
      final proUid = jobData['assignedProUid'];

      if (proUid != null) {
        await _firestore
            .collection('users')
            .doc(proUid)
            .collection('notifications')
            .add({
          'type': 'arrival_confirmed',
          'title': 'Arrival confirmed',
          'body':
              'Customer has confirmed your arrival. Job is now in progress.',
          'jobId': jobId,
          'createdAt': FieldValue.serverTimestamp(),
          'read': false,
        });

        await _sendFCMNotification(proUid, 'arrival_confirmed');
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _sendFCMNotification(String userUid, String type) async {
    // This would integrate with FCM service
    // For now, just log the notification
    DebugLogger.log('FCM notification sent to $userUid: $type');
  }

  String _formatArrivalWindow() {
    final arrivalWindow = state.arrivalWindow;
    if (arrivalWindow == null) return '';

    final earliest = arrivalWindow.earliest;
    final latest = arrivalWindow.latest;

    return '${_formatTime(earliest)} - ${_formatTime(latest)}';
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

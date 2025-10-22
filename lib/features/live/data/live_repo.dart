// PG-16: Live Location Repository for real-time position sharing
import 'dart:developer' as developer;
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/models/live_location.dart';

class LiveLocationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Cache to prevent excessive writes
  final Map<String, DateTime> _lastUpdateTimes = {};
  final Map<String, LiveLocation> _lastSentLocations = {};
  static const Duration _minUpdateInterval = Duration(seconds: 5);
  static const double _minDistanceChangeMeters = 8;
  static const double _minHeadingChangeDegrees = 15;

  /// Start sharing live location for a specific job
  Future<void> startSharing(String jobId) async {
    developer.log(
      'Starting live location sharing for job: $jobId',
      name: 'LiveLocationRepo',
    );

    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User must be authenticated to share location');
    }

    // We don't store anything here - sharing starts when first location is sent
    // This method exists for consistency with the controller interface
  }

  /// Stop sharing live location for a specific job
  Future<void> stopSharing(String jobId) async {
    developer.log(
      'Stopping live location sharing for job: $jobId',
      name: 'LiveLocationRepo',
    );

    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // Delete the live location document to stop sharing
      await _firestore
          .collection('liveLocations')
          .doc(jobId)
          .collection('pros')
          .doc(user.uid)
          .delete();

      // Clear cache entry
      final cacheKey = '${jobId}_${user.uid}';
      _lastUpdateTimes.remove(cacheKey);
      _lastSentLocations.remove(cacheKey);

      developer.log(
        'Live location sharing stopped for job: $jobId',
        name: 'LiveLocationRepo',
      );
    } catch (e) {
      developer.log(
        'Error stopping live location sharing: $e',
        name: 'LiveLocationRepo',
      );
      rethrow;
    }
  }

  /// Update current live location with rate limiting
  Future<bool> updateLocation(String jobId, LiveLocation location) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User must be authenticated to update location');
    }

    // Rate limiting - only allow updates every 5 seconds per job
    final cacheKey = '${jobId}_${user.uid}';
    final lastUpdate = _lastUpdateTimes[cacheKey];
    final now = DateTime.now();

    if (lastUpdate != null && now.difference(lastUpdate) < _minUpdateInterval) {
      developer.log(
        'Rate limited: Skipping location update for job: $jobId',
        name: 'LiveLocationRepo',
      );
      return false;
    }

    try {
      // Validate coordinates
      if (!location.isValidCoordinates) {
        throw Exception(
          'Invalid coordinates: ${location.lat}, ${location.lng}',
        );
      }

      final previousLocation = _lastSentLocations[cacheKey];
      if (previousLocation != null) {
        final distance = _distanceBetweenMeters(
          previousLocation.lat,
          previousLocation.lng,
          location.lat,
          location.lng,
        );

        final headingChanged = () {
          if (previousLocation.heading == null || location.heading == null) {
            return false;
          }
          final diff =
              (previousLocation.heading! - location.heading!).abs() % 360;
          final normalized = diff > 180 ? 360 - diff : diff;
          return normalized >= _minHeadingChangeDegrees;
        }();

        final accuracyImproved = () {
          if (location.accuracy == null) return false;
          if (previousLocation.accuracy == null) return true;
          return location.accuracy! + 3 < previousLocation.accuracy!;
        }();

        if (distance < _minDistanceChangeMeters &&
            !headingChanged &&
            !accuracyImproved) {
          developer.log(
            'Skipping redundant location update for job: $jobId (Δ ${distance.toStringAsFixed(1)} m)',
            name: 'LiveLocationRepo',
          );
          _lastUpdateTimes[cacheKey] = now;
          return false;
        }
      }

      // Update location in Firestore with server timestamp
      await _firestore
          .collection('liveLocations')
          .doc(jobId)
          .collection('pros')
          .doc(user.uid)
          .set(location.toFirestore(), SetOptions(merge: true));

      // Update cache
      _lastUpdateTimes[cacheKey] = now;
      _lastSentLocations[cacheKey] = location;

      developer.log(
        'Location updated for job: $jobId (${location.lat}, ${location.lng}) accuracy: ${location.accuracy}m',
        name: 'LiveLocationRepo',
      );
      return true;
    } catch (e) {
      developer.log(
        'Error updating live location: $e',
        name: 'LiveLocationRepo',
      );
      rethrow;
    }
  }

  /// Stream live location for a specific pro in a job (for customers)
  Stream<LiveLocation?> streamProLocation(String jobId, String proUid) {
    return _firestore
        .collection('liveLocations')
        .doc(jobId)
        .collection('pros')
        .doc(proUid)
        .snapshots()
        .map((snapshot) {
          if (!snapshot.exists || snapshot.data() == null) {
            return null;
          }

          try {
            return LiveLocationFirestore.fromFirestore(snapshot.data()!);
          } catch (e) {
            developer.log(
              'Error parsing live location: $e',
              name: 'LiveLocationRepo',
            );
            return null;
          }
        });
  }

  /// Stream all pro locations for a job (for multi-pro jobs)
  Stream<Map<String, LiveLocation>> streamAllPros(String jobId) {
    return _firestore
        .collection('liveLocations')
        .doc(jobId)
        .collection('pros')
        .snapshots()
        .map((snapshot) {
          final locations = <String, LiveLocation>{};

          for (final doc in snapshot.docs) {
            try {
              final location = LiveLocationFirestore.fromFirestore(doc.data());
              locations[doc.id] = location;
            } catch (e) {
              developer.log(
                'Error parsing location for pro ${doc.id}: $e',
                name: 'LiveLocationRepo',
              );
            }
          }

          return locations;
        });
  }

  /// Check if a pro is currently sharing location for a job
  Future<bool> isSharing(String jobId, String proUid) async {
    try {
      final doc = await _firestore
          .collection('liveLocations')
          .doc(jobId)
          .collection('pros')
          .doc(proUid)
          .get();

      if (!doc.exists) return false;

      // Check if location is recent (within 5 minutes)
      final data = doc.data();
      if (data == null || data['updatedAt'] == null) return false;

      final updatedAt = (data['updatedAt'] as Timestamp).toDate();
      final now = DateTime.now();
      final isRecent = now.difference(updatedAt).inMinutes < 5;

      return isRecent;
    } catch (e) {
      developer.log(
        'Error checking sharing status: $e',
        name: 'LiveLocationRepo',
      );
      return false;
    }
  }

  /// Get last known location for a pro (without streaming)
  Future<LiveLocation?> getLastLocation(String jobId, String proUid) async {
    try {
      final doc = await _firestore
          .collection('liveLocations')
          .doc(jobId)
          .collection('pros')
          .doc(proUid)
          .get();

      if (!doc.exists || doc.data() == null) {
        return null;
      }

      return LiveLocationFirestore.fromFirestore(doc.data()!);
    } catch (e) {
      developer.log(
        'Error getting last location: $e',
        name: 'LiveLocationRepo',
      );
      return null;
    }
  }

  /// Clear all cached update times (useful for testing)
  void clearCache() {
    _lastUpdateTimes.clear();
    _lastSentLocations.clear();
  }

  double _distanceBetweenMeters(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadius = 6371000; // meters
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);
    final a =
        (math.sin(dLat / 2) * math.sin(dLat / 2)) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            (math.sin(dLon / 2) * math.sin(dLon / 2));
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double degree) => degree * (math.pi / 180);
}

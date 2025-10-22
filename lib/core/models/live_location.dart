// PG-16: Live Location Model for real-time position sharing
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'live_location.freezed.dart';
part 'live_location.g.dart';

@freezed
abstract class LiveLocation with _$LiveLocation {
  const factory LiveLocation({
    required double lat,
    required double lng,
    required DateTime updatedAt,
    double? accuracy,
    double? heading,
  }) = _LiveLocation;

  factory LiveLocation.fromJson(Map<String, dynamic> json) =>
      _$LiveLocationFromJson(json);
}

// Extension for Firestore conversion
extension LiveLocationFirestore on LiveLocation {
  Map<String, dynamic> toFirestore() {
    return {
      'lat': lat,
      'lng': lng,
      'updatedAt': FieldValue.serverTimestamp(),
      'clientUpdatedAt': updatedAt.toUtc().toIso8601String(),
      if (accuracy != null) 'accuracy': accuracy,
      if (heading != null) 'heading': heading,
    };
  }

  static LiveLocation fromFirestore(Map<String, dynamic> data) {
    DateTime? updatedAt;
    final rawUpdatedAt = data['updatedAt'];
    if (rawUpdatedAt is Timestamp) {
      updatedAt = rawUpdatedAt.toDate();
    } else if (rawUpdatedAt is DateTime) {
      updatedAt = rawUpdatedAt;
    }

    if (updatedAt == null && data['clientUpdatedAt'] is String) {
      updatedAt = DateTime.tryParse(data['clientUpdatedAt'] as String);
    }

    updatedAt ??= DateTime.now();

    return LiveLocation(
      lat: (data['lat'] as num).toDouble(),
      lng: (data['lng'] as num).toDouble(),
      updatedAt: updatedAt,
      accuracy: data['accuracy'] != null
          ? (data['accuracy'] as num).toDouble()
          : null,
      heading: data['heading'] != null
          ? (data['heading'] as num).toDouble()
          : null,
    );
  }
}

// Validation helpers
extension LiveLocationValidation on LiveLocation {
  bool get isValidCoordinates {
    return lat >= -90 && lat <= 90 && lng >= -180 && lng <= 180;
  }

  bool get isRecentLocation {
    final now = DateTime.now();
    return now.difference(updatedAt).inMinutes <
        5; // Consider stale after 5 minutes
  }

  bool get hasAccurateReading {
    return accuracy != null && accuracy! <= 50; // 50 meters or better
  }

  String get lastUpdatedText {
    final now = DateTime.now();
    final diff = now.difference(updatedAt);

    if (diff.inSeconds < 60) {
      return '${diff.inSeconds}s ago';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else {
      return '${diff.inHours}h ago';
    }
  }

  String get accuracyText {
    if (accuracy == null) return 'Unknown accuracy';
    if (accuracy! <= 5) return 'Very accurate (${accuracy!.round()}m)';
    if (accuracy! <= 20) return 'Good accuracy (${accuracy!.round()}m)';
    if (accuracy! <= 50) return 'Fair accuracy (${accuracy!.round()}m)';
    return 'Poor accuracy (${accuracy!.round()}m)';
  }
}

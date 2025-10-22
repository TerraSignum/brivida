// Temporary stub for ProProfile model
// This should be replaced with the actual ProProfile model when available

class ProProfile {
  final String uid;
  final Map<String, dynamic> ratingAggregate;
  final double averageRating;
  final int reviewCount;

  const ProProfile({
    required this.uid,
    this.ratingAggregate = const {},
    this.averageRating = 0.0,
    this.reviewCount = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'ratingAggregate': ratingAggregate,
      'averageRating': averageRating,
      'reviewCount': reviewCount,
    };
  }

  factory ProProfile.fromJson(Map<String, dynamic> json) {
    return ProProfile(
      uid: json['uid'] ?? '',
      ratingAggregate: json['ratingAggregate'] ?? {},
      averageRating: (json['averageRating'] ?? 0.0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
    );
  }
}

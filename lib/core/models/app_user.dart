import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

/// Converter for Firestore [Timestamp] values to [DateTime].
class TimestampConverter implements JsonConverter<DateTime?, Object?> {
  const TimestampConverter();

  @override
  DateTime? fromJson(Object? json) {
    if (json == null) return null;
    if (json is Timestamp) return json.toDate();
    if (json is DateTime) return json;
    if (json is Map<String, dynamic> && json['seconds'] != null) {
      final seconds = json['seconds'];
      final nanoseconds = json['nanoseconds'] ?? 0;
      if (seconds is int) {
        return Timestamp(
          seconds,
          nanoseconds is int ? nanoseconds : 0,
        ).toDate();
      }
    }
    return null;
  }

  @override
  Object? toJson(DateTime? object) {
    if (object == null) return null;
    return Timestamp.fromDate(object);
  }
}

@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    required String uid,
    required String email,
    String? displayName,
    String? username,
    String? usernameLower,
    String? photoUrl,
    String? phoneNumber,
    String? locale,
    @Default(false) bool marketingOptIn,
    @Default(false) bool isVerified,
    String? role,
    @TimestampConverter() DateTime? createdAt,
    @Default(false) bool deleted,
  }) = _AppUser;

  const AppUser._();

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  factory AppUser.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    if (data == null) {
      throw StateError('User document ${snapshot.id} is empty');
    }

    return AppUser.fromJson({
      'uid': snapshot.id,
      'email': data['email'],
      'displayName': data['displayName'],
      'username': data['username'],
      'usernameLower': data['usernameLower'],
      'photoUrl': data['photoUrl'],
      'phoneNumber': data['phoneNumber'],
      'locale': data['locale'],
      'marketingOptIn': data['marketingOptIn'] ?? false,
      'isVerified': data['isVerified'] ?? false,
      'role': data['role'],
      'createdAt': data['createdAt'],
      'deleted': data['deleted'] ?? false,
    });
  }

  /// Preferred display label for public surfaces.
  String get displayLabel {
    final normalizedUsername = username?.trim();
    if (normalizedUsername != null && normalizedUsername.isNotEmpty) {
      return '@$normalizedUsername';
    }

    final normalizedDisplayName = displayName?.trim();
    if (normalizedDisplayName != null && normalizedDisplayName.isNotEmpty) {
      return normalizedDisplayName;
    }

    return _maskEmail(email);
  }

  /// Returns the best effort human readable name for greetings.
  String get friendlyName {
    final normalizedDisplayName = displayName?.trim();
    if (normalizedDisplayName != null && normalizedDisplayName.isNotEmpty) {
      return normalizedDisplayName;
    }
    final normalizedUsername = username?.trim();
    if (normalizedUsername != null && normalizedUsername.isNotEmpty) {
      return '@$normalizedUsername';
    }
    return _maskEmail(email);
  }

  bool get hasUsername => (username?.trim().isNotEmpty ?? false);

  bool get isDeleted => deleted;

  String _maskEmail(String value) {
    final parts = value.split('@');
    if (parts.length != 2 || parts[0].isEmpty) {
      return value;
    }

    final localPart = parts[0];
    final domain = parts[1];
    if (localPart.length <= 2) {
      return '${localPart[0]}***@$domain';
    }

    final visibleCount = max(1, (localPart.length * 0.3).floor());
    final visiblePart = localPart.substring(0, visibleCount);
    return '$visiblePart***@$domain';
  }
}

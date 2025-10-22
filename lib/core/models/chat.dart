import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'chat.freezed.dart';
part 'chat.g.dart';

@freezed
abstract class Chat with _$Chat {
  const factory Chat({
    String? id,
    required String jobId,
    required String customerUid,
    required String proUid,
    required List<String> memberUids,
    String? lastMessage,
    DateTime? lastMessageAt,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Chat;

  factory Chat.fromJson(Map<String, dynamic> json) => _$ChatFromJson(json);

  factory Chat.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    DateTime? toDate(dynamic value) {
      if (value == null) return null;
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      if (value is String) return DateTime.tryParse(value);
      return null;
    }

    final createdAt = toDate(data['createdAt']) ?? DateTime.now();
    final lastMessageAt = toDate(data['lastMessageAt']);
    final updatedAt = toDate(data['updatedAt']);

    final rawMembers = data['memberUids'] as List<dynamic>?;
    final rawParticipants = data['participants'] as List<dynamic>?;

    final memberUids = (rawMembers ?? rawParticipants ?? const [])
        .map((e) => e.toString())
        .toList();

    // Backfill participants array when missing to keep queries consistent
    if ((rawParticipants == null || rawParticipants.isEmpty) &&
        memberUids.isNotEmpty) {
      try {
        doc.reference.set({
          'participants': memberUids,
        }, SetOptions(merge: true));
      } catch (_) {
        // Ignore write failures during backfill to avoid crashing UI
      }
    }

    return Chat.fromJson({
      ...data,
      'id': doc.id,
      'memberUids': memberUids,
      'createdAt': createdAt.toIso8601String(),
      'lastMessageAt': lastMessageAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    });
  }
}

extension ChatFirestore on Chat {
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id'); // Don't store ID in the document
    // Convert DateTime to Timestamp
    json['createdAt'] = Timestamp.fromDate(createdAt);
    if (lastMessageAt != null) {
      json['lastMessageAt'] = Timestamp.fromDate(lastMessageAt!);
    }
    if (json.containsKey('updatedAt') && json['updatedAt'] != null) {
      json['updatedAt'] = Timestamp.fromDate(updatedAt!);
    }
    return json;
  }
}

enum MessageType { text, image }

@freezed
abstract class Message with _$Message {
  const factory Message({
    String? id,
    required String senderUid,
    required MessageType type,
    String? content, // For text messages
    String? imageUrl, // For image messages
    @Default(false) bool delivered,
    @Default(false) bool read,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  factory Message.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    DateTime? toDate(dynamic value) {
      if (value == null) return null;
      if (value is Timestamp) return value.toDate();
      if (value is DateTime) return value;
      if (value is String) return DateTime.tryParse(value);
      return null;
    }

    final createdAt = toDate(data['createdAt']) ?? DateTime.now();
    final updatedAt = toDate(data['updatedAt']);

    final messageType = data['type'] ?? data['messageType'] ?? 'text';
    final content = data['content'] ?? data['text'];

    return Message.fromJson({
      ...data,
      'id': doc.id,
      'type': messageType,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    });
  }
}

extension MessageFirestore on Message {
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id'); // Don't store ID in the document
    // Convert DateTime to Timestamp
    json['createdAt'] = Timestamp.fromDate(createdAt);
    if (updatedAt != null) {
      json['updatedAt'] = Timestamp.fromDate(updatedAt!);
    }
    return json;
  }
}

import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/models/chat.dart';
import '../../../core/utils/debug_logger.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository();
});

class ChatRepository {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final Uuid _uuid;

  ChatRepository({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    Uuid? uuid,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _storage = storage ?? FirebaseStorage.instance,
       _uuid = uuid ?? const Uuid();

  // Get or create chat between customer and pro for a specific job
  Future<Chat?> getOrCreateChat(
    String jobId,
    String customerUid,
    String proUid,
  ) async {
    try {
      final members = [customerUid, proUid]..sort();

      // Check if chat already exists for this job and members
      final existingChatQuery = await _firestore
          .collection('chats')
          .where('jobId', isEqualTo: jobId)
          .where('customerUid', isEqualTo: customerUid)
          .where('proUid', isEqualTo: proUid)
          .limit(1)
          .get();

      if (existingChatQuery.docs.isNotEmpty) {
        return Chat.fromFirestore(existingChatQuery.docs.first);
      }

      // Create new chat
      final now = DateTime.now();
      final chatData = {
        'jobId': jobId,
        'customerUid': customerUid,
        'proUid': proUid,
        'memberUids': members,
        'participants': members,
        'lastMessageAt': Timestamp.fromDate(now),
        'createdAt': Timestamp.fromDate(now),
      };

      final docRef = await _firestore.collection('chats').add(chatData);

      // Return the created chat
      final chatDoc = await docRef.get();
      return Chat.fromFirestore(chatDoc);
    } catch (e) {
      DebugLogger.error('Error creating/getting chat: $e');
      return null;
    }
  }

  // Stream all chats for a user
  Stream<List<Chat>> streamUserChats(String uid) {
    final collection = _firestore.collection('chats');

    Stream<QuerySnapshot<Map<String, dynamic>>> snapshots;

    try {
      snapshots = collection
          .where('participants', arrayContains: uid)
          .orderBy('lastMessageAt', descending: true)
          .snapshots();
    } on FirebaseException catch (error) {
      if (error.code == 'failed-precondition') {
        DebugLogger.warning(
          'CHAT_REPO: Missing index for participants arrayContains, falling back to memberUids for uid=$uid',
        );
        snapshots = collection
            .where('memberUids', arrayContains: uid)
            .orderBy('lastMessageAt', descending: true)
            .snapshots();
      } else {
        rethrow;
      }
    }

    return snapshots.transform(
      StreamTransformer.fromHandlers(
        handleData: (snapshot, sink) {
          sink.add(
            snapshot.docs.map((doc) => Chat.fromFirestore(doc)).toList(),
          );
        },
        handleError: (error, stack, sink) {
          if (error is FirebaseException && error.code == 'permission-denied') {
            DebugLogger.warning(
              'CHAT_REPO: Permission denied streaming chats for $uid. Returning empty list for UI fallbacks.',
            );
            sink.add(<Chat>[]);
          } else {
            sink.addError(error, stack);
          }
        },
      ),
    );
  }

  // Stream messages for a specific chat
  Stream<List<Message>> streamMessages(String chatId) {
    final snapshots = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots();

    return snapshots.transform(
      StreamTransformer.fromHandlers(
        handleData: (snapshot, sink) {
          sink.add(
            snapshot.docs.map((doc) => Message.fromFirestore(doc)).toList(),
          );
        },
        handleError: (error, stack, sink) {
          if (error is FirebaseException && error.code == 'permission-denied') {
            DebugLogger.warning(
              'CHAT_REPO: Permission denied streaming messages for $chatId. Returning empty list for UI fallbacks.',
            );
            sink.add(<Message>[]);
          } else {
            sink.addError(error, stack);
          }
        },
      ),
    );
  }

  // Send text message
  Future<void> sendText(String chatId, String senderUid, String text) async {
    try {
      final now = DateTime.now();
      final messageData = {
        'senderUid': senderUid,
        'type': MessageType.text.name,
        'content': text,
        'text': text,
        'createdAt': Timestamp.fromDate(now),
      };

      // Add message to subcollection
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add(messageData);

      // Update chat's lastMessageAt
      await _firestore.collection('chats').doc(chatId).update({
        'lastMessageAt': Timestamp.fromDate(now),
      });
    } catch (e) {
      DebugLogger.error('Error sending text message: $e');
      throw Exception('Failed to send message');
    }
  }

  // Send image message
  Future<void> sendImage(
    String chatId,
    String senderUid,
    File imageFile,
  ) async {
    try {
      // Upload image to Firebase Storage
      final fileName = '${_uuid.v4()}.jpg';
      final storageRef = _storage.ref().child('chat_media/$chatId/$fileName');

      final uploadTask = storageRef.putFile(
        imageFile,
        SettableMetadata(contentType: 'image/jpeg'),
      );

      await uploadTask;
      final mediaPath = 'chat_media/$chatId/$fileName';

      // Create message with media path
      final now = DateTime.now();
      final messageData = {
        'senderUid': senderUid,
        'type': MessageType.image.name,
        'imageUrl': mediaPath,
        'createdAt': Timestamp.fromDate(now),
      };

      // Add message to subcollection
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add(messageData);

      // Update chat's lastMessageAt
      await _firestore.collection('chats').doc(chatId).update({
        'lastMessageAt': Timestamp.fromDate(now),
      });
    } catch (e) {
      DebugLogger.log('Error sending image message: $e');
      throw Exception('Failed to send image');
    }
  }

  // Get download URL for image
  Future<String> getImageUrl(String mediaPath) async {
    try {
      return await _storage.ref(mediaPath).getDownloadURL();
    } catch (e) {
      DebugLogger.log('Error getting image URL: $e');
      throw Exception('Failed to load image');
    }
  }

  // Save FCM token for push notifications
  Future<void> saveFcmToken(String uid, String token) async {
    try {
      await _firestore.collection('users').doc(uid).update({'fcmToken': token});
    } catch (e) {
      DebugLogger.log('Error saving FCM token: $e');
      // Don't throw error as this is not critical
    }
  }

  // Get chat by ID
  Future<Chat?> getChatById(String chatId) async {
    try {
      final doc = await _firestore.collection('chats').doc(chatId).get();
      if (doc.exists) {
        return Chat.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      DebugLogger.log('Error getting chat: $e');
      return null;
    }
  }
}

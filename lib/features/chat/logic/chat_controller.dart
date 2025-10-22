import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/models/chat.dart';
import '../data/chat_repo.dart';
import '../../../core/models/app_user.dart';
import '../../../core/utils/debug_logger.dart';

// Current user provider
final currentUserProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// Provider for all user chats
final userChatsProvider = StreamProvider.autoDispose<List<Chat>>((ref) {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return Stream.value([]);

  final chatRepo = ref.watch(chatRepositoryProvider);
  return chatRepo.streamUserChats(user.uid);
});

// Provider for specific chat
final chatProvider = FutureProvider.autoDispose.family<Chat?, String>((
  ref,
  chatId,
) {
  final chatRepo = ref.watch(chatRepositoryProvider);
  return chatRepo.getChatById(chatId);
});

// Provider for messages in a specific chat
final messagesProvider = StreamProvider.autoDispose
    .family<List<Message>, String>((ref, chatId) {
      final chatRepo = ref.watch(chatRepositoryProvider);
      return chatRepo.streamMessages(chatId);
    });

final chatMemberProfileProvider = FutureProvider.autoDispose
    .family<AppUser?, String>((ref, uid) async {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();

        if (!doc.exists) {
          DebugLogger.warning('CHAT: Missing profile document for member $uid');
          return null;
        }

        return AppUser.fromDocument(doc);
      } on FirebaseException catch (error, stackTrace) {
        DebugLogger.error(
          'CHAT: Failed to load member profile (FirebaseException)',
          error,
          stackTrace,
        );
        return null;
      } catch (error, stackTrace) {
        DebugLogger.error(
          'CHAT: Failed to load member profile',
          error,
          stackTrace,
        );
        return null;
      }
    });

// Chat Controller State
class ChatState {
  final bool isLoading;
  final bool isSendingMessage;
  final String? error;

  ChatState({
    this.isLoading = false,
    this.isSendingMessage = false,
    this.error,
  });

  ChatState copyWith({bool? isLoading, bool? isSendingMessage, String? error}) {
    return ChatState(
      isLoading: isLoading ?? this.isLoading,
      isSendingMessage: isSendingMessage ?? this.isSendingMessage,
      error: error ?? this.error,
    );
  }
}

// Chat Controller
class ChatController extends StateNotifier<ChatState> {
  final ChatRepository _chatRepo;
  final ImagePicker _imagePicker = ImagePicker();

  ChatController(this._chatRepo) : super(ChatState());

  // Send text message
  Future<void> sendTextMessage(String chatId, String text) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || text.trim().isEmpty) return;

    state = state.copyWith(isSendingMessage: true, error: null);

    try {
      await _chatRepo.sendText(chatId, user.uid, text.trim());
      state = state.copyWith(isSendingMessage: false);
    } catch (e) {
      state = state.copyWith(
        isSendingMessage: false,
        error: 'Failed to send message: ${e.toString()}',
      );
    }
  }

  // Send image message
  Future<void> sendImageMessage(String chatId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image == null) return;

      state = state.copyWith(isSendingMessage: true, error: null);

      final imageFile = File(image.path);
      await _chatRepo.sendImage(chatId, user.uid, imageFile);

      state = state.copyWith(isSendingMessage: false);
    } catch (e) {
      state = state.copyWith(
        isSendingMessage: false,
        error: 'Failed to send image: ${e.toString()}',
      );
    }
  }

  // Create or get chat for a job
  Future<Chat?> getOrCreateChatForJob(
    String jobId,
    String customerUid,
    String proUid,
  ) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final chat = await _chatRepo.getOrCreateChat(jobId, customerUid, proUid);
      state = state.copyWith(isLoading: false);
      return chat;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to create chat: ${e.toString()}',
      );
      return null;
    }
  }

  // Get image URL
  Future<String?> getImageUrl(String mediaPath) async {
    try {
      return await _chatRepo.getImageUrl(mediaPath);
    } catch (e) {
      return null;
    }
  }

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Chat Controller Provider
final chatControllerProvider = StateNotifierProvider<ChatController, ChatState>(
  (ref) {
    final chatRepo = ref.watch(chatRepositoryProvider);
    return ChatController(chatRepo);
  },
);

// Helper provider to get chat info for a job
final chatForJobProvider = FutureProvider.autoDispose.family<Chat?, String>((
  ref,
  jobId,
) async {
  final user = ref.watch(currentUserProvider).value;
  if (user == null) return null;

  final chatRepo = ref.watch(chatRepositoryProvider);
  final chats = await chatRepo.streamUserChats(user.uid).first;

  // Find chat for this specific job
  return chats.where((chat) => chat.jobId == jobId).firstOrNull;
});

// Extension to help with null safety
extension IterableExtension<T> on Iterable<T> {
  T? get firstOrNull {
    if (isEmpty) return null;
    return first;
  }
}

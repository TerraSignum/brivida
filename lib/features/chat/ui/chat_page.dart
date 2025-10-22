import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/models/chat.dart';
import '../logic/chat_controller.dart';
import '../../../core/utils/navigation_helpers.dart';
import '../../../core/utils/debug_logger.dart';
import '../../tutorial/logic/tutorial_registry.dart';
import '../../tutorial/ui/tutorial_trigger.dart';

class ChatPage extends ConsumerStatefulWidget {
  final String chatId;

  const ChatPage({super.key, required this.chatId});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatAsync = ref.watch(chatProvider(widget.chatId));
    final messagesAsync = ref.watch(messagesProvider(widget.chatId));
    final chatState = ref.watch(chatControllerProvider);
    final currentUser = ref.watch(currentUserProvider).value;

    final scaffold = Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => popOrGoHome(context, homeRoute: '/chats'),
          icon: const Icon(Icons.arrow_back),
        ),
        title: chatAsync.when(
          data: (chat) => Text(
            chat != null
                ? 'chat.jobTitle'.tr(args: [chat.jobId.substring(0, 8)])
                : 'chat.title'.tr(),
          ),
          loading: () => Text('chat.title'.tr()),
          error: (error, stackTrace) => Text('chat.title'.tr()),
        ),
        actions: [
          chatAsync.maybeWhen(
            data: (chat) {
              if (chat == null || currentUser == null) {
                return const SizedBox.shrink();
              }
              return _ChatCallAction(
                chat: chat,
                currentUserId: currentUser.uid,
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
        ],
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1F2937),
        elevation: 1,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return _buildEmptyState();
                }

                final mediaQuery = MediaQuery.of(context);
                final navigationInset = mediaQuery.padding.bottom > 0
                    ? mediaQuery.padding.bottom
                    : mediaQuery.viewPadding.bottom;
                final listPadding = EdgeInsets.fromLTRB(
                  16,
                  navigationInset + 16,
                  16,
                  16,
                );

                return ListView.builder(
                  controller: _scrollController,
                  reverse: true, // Show newest messages at bottom
                  padding: listPadding,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.senderUid == currentUser?.uid;

                    return _buildMessageBubble(context, ref, message, isMe);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'chat.loadError'.tr(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          ref.invalidate(messagesProvider(widget.chatId)),
                      child: Text('common.retry'.tr()),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Error Display
          if (chatState.error != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red[700], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      chatState.error!,
                      style: TextStyle(color: Colors.red[700], fontSize: 14),
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        ref.read(chatControllerProvider.notifier).clearError(),
                    icon: Icon(Icons.close, color: Colors.red[700], size: 20),
                  ),
                ],
              ),
            ),

          // Message Input
          SafeArea(
            top: false,
            minimum: const EdgeInsets.only(bottom: 16),
            child: _buildMessageInput(chatState),
          ),
        ],
      ),
    );

    return TutorialTrigger(screen: TutorialScreen.chat, child: scaffold);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            Text(
              'chat.noMessages'.tr(),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'chat.startConversation'.tr(),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(
    BuildContext context,
    WidgetRef ref,
    Message message,
    bool isMe,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF6366F1),
              child: Text(
                message.senderUid.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isMe ? const Color(0xFF6366F1) : Colors.white,
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomLeft: isMe
                      ? const Radius.circular(16)
                      : const Radius.circular(4),
                  bottomRight: isMe
                      ? const Radius.circular(4)
                      : const Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.type == MessageType.text &&
                      message.content != null)
                    Text(
                      message.content!,
                      style: TextStyle(
                        color: isMe ? Colors.white : const Color(0xFF1F2937),
                        fontSize: 16,
                      ),
                    )
                  else if (message.type == MessageType.image &&
                      message.imageUrl != null)
                    _buildImageMessage(ref, message.imageUrl!, isMe),
                  const SizedBox(height: 4),
                  Text(
                    _formatMessageTime(message.createdAt),
                    style: TextStyle(
                      color: isMe
                          ? Colors.white.withValues(alpha: 0.8)
                          : Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF10B981),
              child: Text(
                message.senderUid.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImageMessage(WidgetRef ref, String mediaPath, bool isMe) {
    return FutureBuilder<String?>(
      future: ref.read(chatControllerProvider.notifier).getImageUrl(mediaPath),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: 200,
            height: 150,
            decoration: BoxDecoration(
              color: isMe
                  ? Colors.white.withValues(alpha: 0.2)
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Container(
            width: 200,
            height: 150,
            decoration: BoxDecoration(
              color: isMe
                  ? Colors.white.withValues(alpha: 0.2)
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  color: isMe ? Colors.white : Colors.grey[500],
                ),
                const SizedBox(height: 8),
                Text(
                  'chat.imageLoadError'.tr(),
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.grey[500],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: snapshot.data!,
            width: 200,
            height: 150,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              width: 200,
              height: 150,
              color: Colors.grey[200],
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              width: 200,
              height: 150,
              color: Colors.grey[200],
              child: const Icon(Icons.error),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageInput(ChatState chatState) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          // Image Button
          IconButton(
            onPressed: chatState.isSendingMessage ? null : () => _sendImage(),
            icon: Icon(
              Icons.image,
              color: chatState.isSendingMessage
                  ? Colors.grey[400]
                  : const Color(0xFF6366F1),
            ),
          ),

          // Text Input
          Expanded(
            child: TextField(
              controller: _messageController,
              enabled: !chatState.isSendingMessage,
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'chat.typeMessage'.tr(),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: Color(0xFF6366F1)),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onSubmitted: (_) => _sendTextMessage(),
            ),
          ),

          const SizedBox(width: 8),

          // Send Button
          chatState.isSendingMessage
              ? const SizedBox(
                  width: 48,
                  height: 48,
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              : IconButton(
                  onPressed: _sendTextMessage,
                  icon: const Icon(Icons.send, color: Color(0xFF6366F1)),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(
                      0xFF6366F1,
                    ).withValues(alpha: 0.1),
                    shape: const CircleBorder(),
                  ),
                ),
        ],
      ),
    );
  }

  void _sendTextMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    ref
        .read(chatControllerProvider.notifier)
        .sendTextMessage(widget.chatId, text);
    _messageController.clear();

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendImage() {
    ref.read(chatControllerProvider.notifier).sendImageMessage(widget.chatId);

    // Scroll to bottom after image is sent
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _formatMessageTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      return DateFormat('HH:mm').format(dateTime);
    } else if (messageDate == today.subtract(const Duration(days: 1))) {
      return '${'chat.yesterday'.tr()} ${DateFormat('HH:mm').format(dateTime)}';
    } else {
      return DateFormat('dd.MM HH:mm').format(dateTime);
    }
  }
}

Future<void> _launchPhoneCall(BuildContext context, String phoneNumber) async {
  final messenger = ScaffoldMessenger.maybeOf(context);
  final sanitized = phoneNumber.replaceAll(RegExp(r'[\s()-]'), '');
  final uri = Uri(scheme: 'tel', path: sanitized);

  try {
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!launched) {
      messenger?.showSnackBar(
        SnackBar(content: Text('chat.callUnavailable'.tr())),
      );
    }
  } catch (error, stackTrace) {
    DebugLogger.error('CHAT: Failed to launch phone dialer', error, stackTrace);
    messenger?.showSnackBar(
      SnackBar(content: Text('chat.callUnavailable'.tr())),
    );
  }
}

class _ChatCallAction extends ConsumerWidget {
  const _ChatCallAction({required this.chat, required this.currentUserId});

  final Chat chat;
  final String currentUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counterpartUid = chat.memberUids.firstWhere(
      (uid) => uid != currentUserId,
      orElse: () => '',
    );

    if (counterpartUid.isEmpty) {
      return const SizedBox.shrink();
    }

    final profileAsync = ref.watch(chatMemberProfileProvider(counterpartUid));

    return profileAsync.when(
      data: (profile) {
        final phone = profile?.phoneNumber?.trim() ?? '';
        if (phone.isEmpty) {
          return IconButton(
            icon: const Icon(Icons.phone_disabled_outlined),
            tooltip: 'chat.noPhone'.tr(),
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('chat.noPhone'.tr())));
            },
          );
        }

        return IconButton(
          icon: const Icon(Icons.phone_outlined),
          tooltip: 'chat.actions.call'.tr(),
          onPressed: () => _launchPhoneCall(context, phone),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.only(right: 12),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (error, stackTrace) {
        DebugLogger.error(
          'CHAT: Failed to load counterpart profile',
          error,
          stackTrace,
        );
        return IconButton(
          icon: const Icon(Icons.phone_disabled_outlined),
          tooltip: 'chat.callUnavailable'.tr(),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('chat.callUnavailable'.tr())),
            );
          },
        );
      },
    );
  }
}

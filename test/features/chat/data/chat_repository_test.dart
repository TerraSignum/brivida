import 'package:brivida_app/core/models/chat.dart';
import 'package:brivida_app/features/chat/data/chat_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockFirebaseStorage extends Mock implements FirebaseStorage {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ChatRepository', () {
    late FakeFirebaseFirestore firestore;
    late ChatRepository repository;

    setUp(() {
      firestore = FakeFirebaseFirestore();
      repository = ChatRepository(
        firestore: firestore,
        storage: _MockFirebaseStorage(),
      );
    });

    test(
      'getOrCreateChat creates chat once per job and participants',
      () async {
        final chat = await repository.getOrCreateChat(
          'job-123',
          'customer-z',
          'pro-a',
        );

        expect(chat, isNotNull);
        expect(chat!.customerUid, 'customer-z');
        expect(chat.proUid, 'pro-a');
        expect(chat.memberUids, containsAll(<String>['customer-z', 'pro-a']));

        final storedChat = await firestore
            .collection('chats')
            .doc(chat.id!)
            .get();
        final data = storedChat.data();
        expect(data, isNotNull);
        expect(data!['customerUid'], equals('customer-z'));
        expect(data['proUid'], equals('pro-a'));
        final memberUids = List<String>.from(
          data['memberUids'] as List<dynamic>,
        );
        expect(memberUids, equals(<String>['customer-z', 'pro-a']..sort()));

        final second = await repository.getOrCreateChat(
          'job-123',
          'customer-z',
          'pro-a',
        );

        expect(second, isNotNull);
        expect(second!.id, equals(chat.id));

        final allChats = await firestore.collection('chats').get();
        expect(allChats.docs, hasLength(1));
      },
    );

    test('streamUserChats emits chats for participating user', () async {
      final chat = await repository.getOrCreateChat(
        'job-456',
        'customer-1',
        'pro-1',
      );
      expect(chat, isNotNull);

      final chats = await repository
          .streamUserChats('customer-1')
          .firstWhere((items) => items.isNotEmpty);

      expect(chats, hasLength(1));
      expect(chats.first.jobId, equals('job-456'));
      expect(chats.first.customerUid, equals('customer-1'));
      expect(chats.first.proUid, equals('pro-1'));
    });

    test('sendText stores message and updates lastMessageAt', () async {
      final chat = await repository.getOrCreateChat(
        'job-789',
        'customer-2',
        'pro-2',
      );
      final chatId = chat!.id!;

      final beforeUpdate = await firestore
          .collection('chats')
          .doc(chatId)
          .get();
      final Timestamp initialTimestamp = beforeUpdate.get('lastMessageAt');

      await repository.sendText(chatId, 'customer-2', 'Hello there');

      final messagesSnapshot = await firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .get();

      expect(messagesSnapshot.docs, hasLength(1));
      final messageData = messagesSnapshot.docs.first.data();
      expect(messageData['senderUid'], equals('customer-2'));
      expect(messageData['content'], equals('Hello there'));
      expect(messageData['type'], equals(MessageType.text.name));

      final chats = await repository.streamMessages(chatId).first;
      expect(chats, hasLength(1));
      final message = chats.first;
      expect(message.senderUid, equals('customer-2'));
      expect(message.type, equals(MessageType.text));
      expect(message.content, equals('Hello there'));

      final updatedChat = await firestore.collection('chats').doc(chatId).get();
      final Timestamp updatedTimestamp = updatedChat.get('lastMessageAt');
      expect(
        updatedTimestamp.millisecondsSinceEpoch,
        greaterThanOrEqualTo(initialTimestamp.millisecondsSinceEpoch),
      );
    });
  });
}

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:viewducts/constants/constants.dart';
import 'package:viewducts/core/core.dart';
import 'package:viewducts/core/providers.dart';
import 'package:viewducts/model/chatModel.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/state/serverApi.dart';
import 'package:viewducts/state/stateController.dart';
import 'package:dart_appwrite/dart_appwrite.dart' as appWriteDart;

var chatUserIdProvider = StateProvider<String>((ref) {
  return '';
});
final chatAPIProvider = Provider((ref) {
  return ChatAPI(
    db: ref.watch(appwriteDatabaseProvider),
    realtime: ref.watch(appwriteRealtimeProvider),
    chatDb: ref.watch(appwriteChatDatabaseProvider),
  );
});

abstract class IChatAPI {
  Future<List<Document>> getChatList();
  Stream<RealtimeMessage> getLatestChatList();
  Future<List<Document>> getStoryChat(String chatId);
  Future<List<Document>> getUsersChats(ChatCridentialsModel chatCredentials);
  Stream<RealtimeMessage> getUsersChatsStream(
      ChatCridentialsModel chatCredentials);
  Stream<RealtimeMessage> getPinDuctChatStream();
  FutureEitherVoid sendPinDuctChatMessage({
    required ChatStoryModel message,
    //  required String currentUser,
    //  required String storyId,
  });
  FutureEitherVoid sendMessage({
    required ChatMessage message,
    required ChatMessage localMessage,
    required ChatMessage secondUserChatListMessage,
    required String currentUserChatListKey,
    required String secondUserChatListKey,
    required ViewductsUser currentUser,
    required ViewductsUser secondUser,
    required ChatMessage currentUserChatListMessage,
  });
  Future<List<Document>> getUnreadMessages(UnreadMessageModel data);
}

class ChatAPI implements IChatAPI {
  final Databases _db;
  final appWriteDart.Databases _chatDb;
  final Realtime _realtime;
  ChatAPI({
    required Databases db,
    required Realtime realtime,
    required appWriteDart.Databases chatDb,
  })  : _db = db,
        _chatDb = chatDb,
        _realtime = realtime;

  @override
  Future<List<Document>> getChatList() async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.chatsColl,
      queries: [
        Query.orderDesc('createdAt'),
      ],
    );
    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestChatList() {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.chatsColl}.documents'
    ]).stream;
  }

  @override
  Future<List<Document>> getUsersChats(
      ChatCridentialsModel chatCredentials) async {
    await ServerApi().createConversation(
        ref: chatCredentials.ref,
        chatCredentials.currentUser,
        chatCredentials.secondUser);
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.chatDatabase,
      collectionId: chatCredentials.currentSecondUserChatkey,
      queries: [
        Query.orderDesc('createdAt'),
        Query.equal('fileDownloaded', 'new'),
        Query.limit(10),
      ],
    );
    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getUsersChatsStream(
      ChatCridentialsModel chatCredentials) {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.chatDatabase}.collections.${chatCredentials.currentSecondUserChatkey}.documents'
    ]).stream;
  }

  @override
  FutureEitherVoid sendMessage(
      {required ChatMessage message,
      required ChatMessage localMessage,
      required ChatMessage secondUserChatListMessage,
      required String currentUserChatListKey,
      required String secondUserChatListKey,
      required ViewductsUser currentUser,
      required ViewductsUser secondUser,
      required ChatMessage currentUserChatListMessage}) async {
    try {
      await _db.createDocument(
          databaseId: AppwriteConstants.chatDatabase,
          collectionId: '${message.chatlistKey}',
          documentId: message.key.toString(),
          data: message.toJson());
      await _db.listDocuments(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.chatsColl,
          queries: [
            Query.equal('chatlistKey', message.chatlistKey.toString()),
            Query.equal('senderId', currentUser.userId)
          ]).then((data) async {
        if (data.documents.isNotEmpty) {
          await _db.updateDocument(
            databaseId: AppwriteConstants.databaseId,
            collectionId: AppwriteConstants.chatsColl,
            documentId: currentUserChatListKey.toString(),
            data: currentUserChatListMessage.toJson(),
          );
        } else if (data.documents.isEmpty) {
          await _db.createDocument(
            databaseId: AppwriteConstants.databaseId,
            collectionId: AppwriteConstants.chatsColl,
            documentId: currentUserChatListKey.toString(),
            data: currentUserChatListMessage.toJson(),
          );
        }
      });
      await _chatDb.listDocuments(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.chatsColl,
          queries: [
            Query.equal('chatlistKey', message.chatlistKey.toString()),
            Query.equal('senderId', secondUser.userId)
          ]).then((data) async {
        if (data.documents.isNotEmpty) {
          await _chatDb.updateDocument(
              databaseId: AppwriteConstants.databaseId,
              collectionId: AppwriteConstants.chatsColl,
              documentId: secondUserChatListKey.toString(),
              data: secondUserChatListMessage.toJson(),
              permissions: [
                Permission.read(Role.user("${secondUser.userId}")),
                Permission.write(Role.user("${secondUser.userId}")),
                Permission.update(Role.user("${secondUser.userId}")),
              ]);
        } else if (data.documents.isEmpty) {
          await _chatDb.createDocument(
              databaseId: AppwriteConstants.databaseId,
              collectionId: AppwriteConstants.chatsColl,
              documentId: secondUserChatListKey.toString(),
              data: secondUserChatListMessage.toJson(),
              permissions: [
                Permission.read(Role.user("${secondUser.userId}")),
                Permission.write(Role.user("${secondUser.userId}")),
                Permission.update(Role.user("${secondUser.userId}")),
              ]);
        }
      });
      return right(null);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? 'Some unexpected error occurred', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }

  @override
  Future<List<Document>> getUnreadMessages(UnreadMessageModel data) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.chatDatabase,
      collectionId: data.chatListkey,
      queries: [
        Query.equal('seen', 'false'),
        Query.equal('senderId', data.senderUserId),
      ],
    );
    return documents.documents;
  }

  @override
  Future<List<Document>> getStoryChat(String chatId) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.storyChtsId,
      queries: [
        Query.orderDesc('createdAt'),
        Query.equal('storyId', chatId),
      ],
    );
    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getPinDuctChatStream() {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.storyChtsId}.documents'
    ]).stream;
  }

  @override
  FutureEitherVoid sendPinDuctChatMessage({
    required ChatStoryModel message,
  }) async {
    try {
      final documents = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.storyChtsId,
        documentId: message.key.toString(),
        data: message.toJson(),
      );

      return right(documents);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viewducts/apis/chat_api.dart';
import 'package:viewducts/core/utils.dart';
import 'package:viewducts/encryption/encryption.dart';
import 'package:viewducts/features/auth/controller/auth_controller.dart';
import 'package:viewducts/helper/enum.dart';
import 'package:viewducts/model/chatModel.dart';
import 'package:viewducts/model/user.dart';

final chatControllerProvider = StateNotifierProvider<ChatController, bool>(
  (ref) {
    return ChatController(
      // ref: ref,
      chatApi: ref.watch(chatAPIProvider),
    );
  },
);
final currentChatListDetailsProvider = FutureProvider((ref) {
  final tweetController = ref.watch(chatControllerProvider.notifier);
  return tweetController.getChatList();
});
final currentUserSecondUserChatsDetailsProvider = FutureProvider.family
    .autoDispose((ref, ChatCridentialsModel chatCredentials) {
  final tweetController = ref.watch(chatControllerProvider.notifier);
  return tweetController.getUsersChats(chatCredentials);
});
final getLatestChatListProvider = StreamProvider((ref) {
  final chatAPI = ref.watch(chatAPIProvider);
  return chatAPI.getLatestChatList();
});
final getChatStreamProvider = StreamProvider.family
    .autoDispose((ref, ChatCridentialsModel chatCredentials) {
  final chatAPI = ref.watch(chatAPIProvider);
  return chatAPI.getUsersChatsStream(chatCredentials);
});
final getUnreadMessageProvider =
    FutureProvider.family.autoDispose((ref, UnreadMessageModel data) {
  final chatAPI = ref.watch(chatAPIProvider);
  return chatAPI.getUnreadMessages(data);
});
final getPinDuctStoryProvider =
    FutureProvider.family.autoDispose((ref, String data) {
  final chatAPI = ref.watch(chatControllerProvider.notifier);
  return chatAPI.getStoryChat(data);
});
final getPinDuctChatStreamProvider = StreamProvider((
  ref,
) {
  final chatAPI = ref.watch(chatAPIProvider);
  return chatAPI.getPinDuctChatStream();
});
// final currentChatListDetailsProvider = FutureProvider((ref) {
//   final currentUserId = ref.watch(currentUserAccountProvider).value!.$id;
//   final chatListDetails = ref.watch(chatListDetailsProvider(currentUserId));
//   return chatListDetails.value;
// });

// final chatListDetailsProvider = FutureProvider.family((ref, String uid) {
//   final chatController = ref.watch(chatControllerProvider.notifier);
//   return chatController.getChatList();
// });

class ChatController extends StateNotifier<bool> {
  final ChatAPI _chatApi;
  ChatController({
    required ChatAPI chatApi,
  })  : _chatApi = chatApi,
        super(false);

  Future<List<ChatMessage>> getChatList() async {
    final countryLocation = await _chatApi.getChatList();
    return countryLocation
        .map((chatApi) => ChatMessage.fromJson(chatApi.data))
        .toList();
  }

  Future<List<ChatStoryModel>> getStoryChat(String chatId) async {
    final countryLocation = await _chatApi.getStoryChat(chatId);
    return countryLocation
        .map((chatApi) => ChatStoryModel.fromJson(chatApi.data))
        .toList();
  }

  Future<List<ChatMessage>> getUsersChats(
      ChatCridentialsModel chatCredentials) async {
    final countryLocation = await _chatApi.getUsersChats(chatCredentials);
    return countryLocation
        .map((chatApi) => ChatMessage.fromJson(chatApi.data))
        .toList();
  }

  void sendMessage({
    required String text,
    required ViewductsUser currentUser,
    required ViewductsUser secondUser,
    required BuildContext context,
    required MessagesType type,
    WidgetRef? ref,
    File? imageFile,
    File? videoFile,
    required String messageKey,
    ChatMessage? replyMessage,
  }) async {
    String currentUserChatListKey =
        '${currentUser.userId!.substring(4, 15)}-${secondUser.userId!.substring(4, 15)}';
    String secondUserChatListKey =
        '${secondUser.userId!.substring(4, 15)}-${currentUser.userId!.substring(4, 15)}';
    final encrypted = await TextEncryptDecrypt.encryptAES(text.trim());
    ChatMessage localMessage = ChatMessage();
    ChatMessage message = ChatMessage(
        key: messageKey,
        message: encrypted,
        fileDownloaded: 'new',
        // searchKey: widget.keyId,
        createdAt: DateTime.now().toUtc().toString(),
        clicked: 'false',
        replyedMessage: replyMessage?.message.toString(),
        receiverId: secondUser.userId!,
        senderId: currentUser.userId,
        userId: currentUser.userId,
        chatlistKey: ref!.read(chatUserIdProvider.notifier).state,
        // chatIdUsers == null
        //     ? "feedState.dataBaseChatsId!.value"
        //     : chatIdUsers.toString(),
        newChats: 'true',
        //imageKey: imageKey,
        seen:
            //  chatState.onlineStatus.value.chatOnlineChatStatus == 'online'
            //     ? 'true'
            //     :
            'false',
        type: type.index,
        timeStamp: DateTime.now().toUtc().millisecondsSinceEpoch,
        senderName: currentUser.displayName);
    ChatMessage secondUserChatListMessage = ChatMessage(
        key: secondUserChatListKey,
        message: encrypted,
        fileDownloaded: 'new',
        // searchKey: widget.keyId,
        createdAt: DateTime.now().toUtc().toString(),
        clicked: 'false',
        replyedMessage: replyMessage?.message.toString(),
        receiverId: currentUser.userId!,
        senderId: secondUser.userId,
        userId: currentUser.userId,
        chatlistKey: ref.read(chatUserIdProvider.notifier).state,
        // chatIdUsers == null
        //     ? "feedState.dataBaseChatsId!.value"
        //     : chatIdUsers.toString(),
        newChats: 'true',
        //imageKey: imageKey,
        seen:
            //  chatState.onlineStatus.value.chatOnlineChatStatus == 'online'
            //     ? 'true'
            //     :
            'false',
        type: type.index,
        timeStamp: DateTime.now().toUtc().millisecondsSinceEpoch,
        senderName: currentUser.displayName);
    ChatMessage currentUserChatListMessage = ChatMessage(
        key: currentUserChatListKey,
        message: encrypted,
        fileDownloaded: 'new',
        // searchKey: widget.keyId,
        createdAt: DateTime.now().toUtc().toString(),
        clicked: 'false',
        replyedMessage: replyMessage?.message.toString(),
        receiverId: secondUser.userId!,
        senderId: currentUser.userId,
        userId: currentUser.userId,
        chatlistKey: ref.read(chatUserIdProvider.notifier).state,
        // chatIdUsers == null
        //     ? "feedState.dataBaseChatsId!.value"
        //     : chatIdUsers.toString(),
        newChats: 'true',
        //imageKey: imageKey,
        seen:
            //  chatState.onlineStatus.value.chatOnlineChatStatus == 'online'
            //     ? 'true'
            //     :
            'false',
        type: type.index,
        timeStamp: DateTime.now().toUtc().millisecondsSinceEpoch,
        senderName: currentUser.displayName);
    if (encrypted is String) {}
    final res = await _chatApi.sendMessage(
        message: message,
        localMessage: localMessage,
        currentUserChatListKey: currentUserChatListKey,
        secondUserChatListKey: secondUserChatListKey,
        secondUserChatListMessage: secondUserChatListMessage,
        secondUser: secondUser,
        currentUser: currentUser,
        currentUserChatListMessage: currentUserChatListMessage);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {},
    );
  }

  Future<List<UnreadMessageModel>> getUnReadMeassges(
      UnreadMessageModel data) async {
    final getUnreadMessage = await _chatApi.getUnreadMessages(data);
    return getUnreadMessage
        .map((orders) => UnreadMessageModel.fromMap(orders.data))
        .toList();
  }

  void sendPinDuctMessage({
    //required ChatStoryModel message,
    required ViewductsUser currentUser,
    required String storyId,
    required BuildContext context,
    required String text,
    required String messageKey,
    required String replyMessage,
  }) async {
    ChatStoryModel message = ChatStoryModel(
        message: text,
        senderId: currentUser.userId,
        storyId: storyId,
        type: 0,
        chatId: storyId,
        replyedMessage: replyMessage.toString(),
        key: messageKey,
        createdAt: DateTime.now().toUtc().toString(),
        senderImage: currentUser.profilePic,
        senderName: currentUser.displayName);
    final res = await _chatApi.sendPinDuctChatMessage(message: message);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {},
    );
  }
}

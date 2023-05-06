import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:dart_appwrite/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:viewducts/apis/chat_api.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/chatModel.dart';
import 'package:viewducts/page/message/local_database.dart';
import 'package:viewducts/state/stateController.dart';

extension SplitString on String {
  List<String> splitByLength(int length) =>
      [substring(0, length), substring(length)];
}

/// This class contains all the functions which can't be performed on client side
/// so we are making a seperate class to perform these server side functions.
/// Since the api are different from the client side, we are using the `dart_appwrite`
class ServerApi {
  static ServerApi instance = Get.find<ServerApi>();

  final endPoint = 'https://6357.viewducts.com/v1';
  final serverKey =
      'cfda8d2ce26ec0da493f6a2347c009c4bcff9a07b2b6f17e9b9a7614eed866752f4c01ebc1b2a48f49bfa164e7f163b79e4e975dee889d0d3e453c0f5ca6e6d9d7f5f96413bf6210d651a707f4b2ef79938fbe5bd77d736f7b545547b3ca822dc99976548dc025a7a574d8275f1fac01f3b129635ee6f4e4d5e6afc9bbd39bea';
  serverClientConnect() {
    final client = Client();
    client
        .setEndpoint(endPoint) // Your Appwrite Endpoint
        .setProject(projectId)
        .setKey(serverKey);
    // Your project ID
    return client;
  }

  clientConnect() {
    final client = Client();
    client
        .setEndpoint('https://6357.viewducts.com/v1') // Your Appwrite Endpoint
        .setProject(projectId);

    return client;
  }
  // Note: These Classes are from `dart_appwrite` package.
  // So there are more functionalities and features than the client side package
  // final Client client;

  // late final Account account;
  // late final Database database;

  // /// Constructor to initialize the client and other api services
  // ServerApi(this.client) {
  //   account = Account(client);
  //   database = Database(client);
  // }

  /// Get the list of all the documents of users you had convo with
  ///  That document usually contains the last message and the time of the last message
  // Future<List<ServerUser>?> getConvoUsersList() async {
  //   try {
  //     final response = await database.listDocuments(collectionId: 'chats');
  //     final List<ServerUser> users = [];
  //     final temp = response.documents;

  //     for (var element in temp) {
  //       users.add(ServerUser.fromMap(element.data));
  //     }
  //     return users;
  //   } on AppwriteException {
  //     rethrow;
  //   }
  // }
  RxList<ChatMessage> chatMessageServer = RxList<ChatMessage>([]);
  RxList<ChatMessage> chatMessageServer2 = RxList<ChatMessage>([]);

  /// This function will create a new Convo Collection between two users
  /// If the collection exists or not, it will return the collection Id.
  createConversation(String curruserId, String otheruserId,
      {WidgetRef? ref}) async {
    try {
      cprint(curruserId + '' + otheruserId);

      /// For collection id, we are using the combination of the two user id
      /// collectionId = '${curruserId/2}_${otheruserId/2}'; or
      /// collectionId = '${otheruserId/2}_${curruserId/2}';
      /// Because curruser and otheruserId is interchangable for both the users
      /// Divide by 2 means we are creating a substring of the user id of length
      /// half of the current userId.
      /// Then We are concatenating those two substring with '_'.
      /// This is the collection id.
      /// Currently this is the way, I am making the collection.
      /// OfCourse, this can be improved a lot better.
      Collection? collection;
      final client = Client();

      client
          .setEndpoint(endPoint) // Your Appwrite Endpoint
          .setProject(projectId)
          .setKey(serverKey);
      final database = Databases(
        client,
      );
      // Check if the collection exists or not
      try {
        // We will try to get the collection in the first try

        collection = await database.getCollection(
            databaseId: chatDatabase,
            collectionId:
                '${curruserId.splitByLength((curruserId.length) ~/ 2)[0]}_${otheruserId.splitByLength((otheruserId.length) ~/ 2)[0]}');
        // if (!kIsWeb) {
        //   feedState.dataBaseChatsId?.value =
        //       '${curruserId.splitByLength((curruserId.length) ~/ 2)[0]}_${otheruserId.splitByLength((otheruserId.length) ~/ 2)[0]}';
        //   chatMessageServer2.value = await SQLHelper.findLocalMessages(
        //       '${curruserId.splitByLength((curruserId.length) ~/ 2)[0]}_${otheruserId.splitByLength((otheruserId.length) ~/ 2)[0]}');
        //   chatMessageServer.value = await SQLHelper.findLocalMessages(
        //       '${otheruserId.splitByLength((otheruserId.length) ~/ 2)[0]}_${curruserId.splitByLength((curruserId.length) ~/ 2)[0]}');
        //   if (chatState.chatMessage.isEmpty) {
        //     chatMessageServer2 = await chatMessageServer;
        //   } else if (chatMessageServer.isEmpty) {
        //     LocalChatMessages chats = LocalChatMessages(
        //         '${curruserId.splitByLength((curruserId.length) ~/ 2)[0]}_${otheruserId.splitByLength((otheruserId.length) ~/ 2)[0]}');

        //     SQLHelper.createLocalChats(chats);
        //   } else {}
        // }
        ref!.read(chatUserIdProvider.notifier).state =
            '${curruserId.splitByLength((curruserId.length) ~/ 2)[0]}_${otheruserId.splitByLength((otheruserId.length) ~/ 2)[0]}';
      } on AppwriteException catch (e) {
        // If the collection doesn't exist, we will try with another id
        if (e.code == 404) {
          try {
            collection = await database.getCollection(
                databaseId: chatDatabase,
                collectionId:
                    '${otheruserId.splitByLength((otheruserId.length) ~/ 2)[0]}_${curruserId.splitByLength((curruserId.length) ~/ 2)[0]}');
            // if (!kIsWeb) {
            //   feedState.dataBaseChatsId!.value =
            //       '${otheruserId.splitByLength((otheruserId.length) ~/ 2)[0]}_${curruserId.splitByLength((curruserId.length) ~/ 2)[0]}';
            //   chatMessageServer2.value = await SQLHelper.findLocalMessages(
            //       '${curruserId.splitByLength((curruserId.length) ~/ 2)[0]}_${otheruserId.splitByLength((otheruserId.length) ~/ 2)[0]}');
            //   chatMessageServer.value = await SQLHelper.findLocalMessages(
            //       '${otheruserId.splitByLength((otheruserId.length) ~/ 2)[0]}_${curruserId.splitByLength((curruserId.length) ~/ 2)[0]}');
            //   if (chatState.chatMessage.isEmpty) {
            //     chatMessageServer2 = await chatMessageServer;
            //   } else if (chatMessageServer.isEmpty) {
            //     LocalChatMessages chats = LocalChatMessages(
            //         '${curruserId.splitByLength((curruserId.length) ~/ 2)[0]}_${otheruserId.splitByLength((otheruserId.length) ~/ 2)[0]}');

            //     SQLHelper.createLocalChats(chats);
            //   } else {}
            // }
            ref!.read(chatUserIdProvider.notifier).state =
                '${otheruserId.splitByLength((otheruserId.length) ~/ 2)[0]}_${curruserId.splitByLength((curruserId.length) ~/ 2)[0]}';
          } on AppwriteException catch (e) {
            // If it still doesn't exists then we will create a new collection
            if (e.code == 404) {
              // Create a new collection

              collection = await database.createCollection(
                  databaseId: chatDatabase,
                  collectionId:
                      '${curruserId.splitByLength((curruserId.length) ~/ 2)[0]}_${otheruserId.splitByLength((otheruserId.length) ~/ 2)[0]}',
                  name:
                      '${curruserId.splitByLength((curruserId.length) ~/ 2)[0]}_${otheruserId.splitByLength((otheruserId.length) ~/ 2)[0]}',
                  permissions: [
                    Permission.read(Role.user("$curruserId")),
                    Permission.read(Role.user("$otheruserId")),
                    Permission.write(Role.user("$curruserId")),
                    Permission.write(Role.user("$otheruserId")),
                  ],
                  // read: ["user:$curruserId", "user:$otheruserId"],
                  // write: ["user:$curruserId", "user:$otheruserId"],
                  documentSecurity: true
                  // permission: 'collection',
                  );
              ref!.read(chatUserIdProvider.notifier).state =
                  '${curruserId.splitByLength((curruserId.length) ~/ 2)[0]}_${otheruserId.splitByLength((otheruserId.length) ~/ 2)[0]}';
              // if (!kIsWeb) {
              //   feedState.dataBaseChatsId!.value =
              //       '${curruserId.splitByLength((curruserId.length) ~/ 2)[0]}_${otheruserId.splitByLength((otheruserId.length) ~/ 2)[0]}';
              //   chatMessageServer2.value = await SQLHelper.findLocalMessages(
              //       '${curruserId.splitByLength((curruserId.length) ~/ 2)[0]}_${otheruserId.splitByLength((otheruserId.length) ~/ 2)[0]}');
              //   chatMessageServer.value = await SQLHelper.findLocalMessages(
              //       '${otheruserId.splitByLength((otheruserId.length) ~/ 2)[0]}_${curruserId.splitByLength((curruserId.length) ~/ 2)[0]}');
              //   if (chatState.chatMessage.isEmpty) {
              //     chatMessageServer2 = await chatMessageServer;
              //   } else if (chatMessageServer.isEmpty) {
              //     LocalChatMessages chats = LocalChatMessages(
              //         '${curruserId.splitByLength((curruserId.length) ~/ 2)[0]}_${otheruserId.splitByLength((otheruserId.length) ~/ 2)[0]}');

              //     SQLHelper.createLocalChats(chats);
              //   } else {}
              // }
            } else {
              // If there is any other error, we will throw it
              rethrow;
            }
          }
        } else {
          // Same goes for here. Anything can happen between the two tries
          rethrow;
        }
      }

      /// If the collection attributes are empty, then we will define those attributes
      if (collection.attributes.isEmpty) {
        await _defineDocument(collection.$id);
      }
      // Return the collection id
      return collection.$id;
    } on AppwriteException catch (e) {
      cprint('$e createConversation');
    }
  }

  /// This function will define the attributes of the collection
  /// This function will be called only once when the collection is created
  /// A private function cause we don't want that to be called from outside
  Future<void> _defineDocument(String collectionId) async {
    // Defining attributes
    final client = Client();
    client
        .setEndpoint(endPoint) // Your Appwrite Endpoint
        .setProject(projectId)
        .setKey(serverKey);
    final database = Databases(
      client,
    );
    var keys = Uuid().v1();
    var keys2 = Uuid().v4();

    try {
      // You are free to choose your own key name.
      // But make to sure to replace those things in the model too.

      await database.createStringAttribute(
          databaseId: chatDatabase,
          collectionId: collectionId,
          key: "key",
          size: 255,
          xrequired: true);
      await database.createStringAttribute(
          databaseId: chatDatabase,
          collectionId: collectionId,
          key: "senderId",
          size: 255,
          xrequired: true);
      await database.createStringAttribute(
          databaseId: chatDatabase,
          collectionId: collectionId,
          key: "message",
          size: 255,
          xrequired: true);
      await database.createIntegerAttribute(
          databaseId: chatDatabase,
          collectionId: collectionId,
          key: "reactions",
          xrequired: false);
      await database.createStringAttribute(
          databaseId: chatDatabase,
          collectionId: collectionId,
          key: "seen",
          size: 255,
          xrequired: false);
      await database.createStringAttribute(
          databaseId: chatDatabase,
          collectionId: collectionId,
          key: "imagePath",
          size: 255,
          xrequired: false);
      await database.createStringAttribute(
          databaseId: chatDatabase,
          collectionId: collectionId,
          key: "createdAt",
          size: 255,
          xrequired: false);
      await database.createIntegerAttribute(
          databaseId: chatDatabase,
          collectionId: collectionId,
          key: "type",
          xrequired: false);
      await database.createStringAttribute(
          databaseId: chatDatabase,
          collectionId: collectionId,
          key: "replyedMessage",
          size: 255,
          xrequired: false);
      await database.createStringAttribute(
          databaseId: chatDatabase,
          collectionId: collectionId,
          key: "chatlistKey",
          size: 255,
          xrequired: false);
      await database.createIntegerAttribute(
          databaseId: chatDatabase,
          collectionId: collectionId,
          key: "orderState",
          xrequired: false);

      await database.createStringAttribute(
          databaseId: chatDatabase,
          collectionId: collectionId,
          size: 255,
          key: "newChats",
          xrequired: false);
      await database.createStringAttribute(
          databaseId: chatDatabase,
          collectionId: collectionId,
          size: 255,
          key: "searchKey",
          xrequired: false);

      await database.createStringAttribute(
          databaseId: chatDatabase,
          collectionId: collectionId,
          size: 255,
          key: "clicked",
          xrequired: false);
      await database.createIntegerAttribute(
          databaseId: chatDatabase,
          collectionId: collectionId,
          key: "timeStamp",
          xrequired: false);
      await database.createIntegerAttribute(
          databaseId: chatDatabase,
          collectionId: collectionId,
          key: "senderReactions",
          xrequired: false);
      await database.createIntegerAttribute(
          databaseId: chatDatabase,
          collectionId: collectionId,
          key: "receiverReactions",
          xrequired: false);
      await database.createStringAttribute(
          databaseId: chatDatabase,
          collectionId: collectionId,
          key: "imageKey",
          size: 255,
          xrequired: false);
      await database.createStringAttribute(
          databaseId: chatDatabase,
          collectionId: collectionId,
          key: "senderName",
          size: 255,
          xrequired: false);
      await database.createStringAttribute(
          databaseId: chatDatabase,
          collectionId: collectionId,
          key: "receiverId",
          size: 255,
          xrequired: false);
      await database.createStringAttribute(
          databaseId: chatDatabase,
          collectionId: collectionId,
          key: "userId",
          size: 255,
          xrequired: false);
      await database.createStringAttribute(
          databaseId: chatDatabase,
          collectionId: collectionId,
          key: "sellerId",
          size: 255,
          xrequired: false);
      await database.createStringAttribute(
          databaseId: chatDatabase,
          collectionId: collectionId,
          key: "productName",
          size: 30,
          xrequired: false);
      await database.createStringAttribute(
          databaseId: chatDatabase,
          collectionId: collectionId,
          key: "fileDownloaded",
          size: 30,
          xrequired: false);

      await database.createStringAttribute(
          databaseId: chatDatabase,
          collectionId: collectionId,
          key: "videoThumbnail",
          size: 100,
          xrequired: false);
      await database.createStringAttribute(
          databaseId: chatDatabase,
          collectionId: collectionId,
          key: "audioFile",
          size: 100,
          xrequired: false);
      await database.createStringAttribute(
          databaseId: chatDatabase,
          collectionId: collectionId,
          key: "voiceMessage",
          size: 100,
          xrequired: false);
      await database.createStringAttribute(
          databaseId: chatDatabase,
          collectionId: collectionId,
          key: "chatType",
          size: 100,
          xrequired: false);
      await database.createStringAttribute(
          databaseId: chatDatabase,
          collectionId: collectionId,
          key: "videoKey",
          size: 30,
          xrequired: false);
      await database.createIndex(
          databaseId: chatDatabase,
          collectionId: collectionId,
          key: '$keys',
          type: 'key',
          attributes: ['createdAt'],
          orders: ['ASC']);
      await database.createIndex(
          databaseId: chatDatabase,
          collectionId: collectionId,
          key: '89847ry',
          type: 'key',
          attributes: ['seen', 'senderId'],
          orders: ['ASC', 'ASC']);
      await database.createIndex(
          databaseId: chatDatabase,
          collectionId: collectionId,
          key: '89847ry78P',
          type: 'key',
          attributes: ['createdAt', 'seen', 'senderId'],
          orders: ['ASC', 'ASC', 'ASC']);
      await database.createIndex(
          databaseId: chatDatabase,
          collectionId: collectionId,
          key: '$keys2',
          type: 'key',
          attributes: ['key'],
          orders: ['ASC']);
      await database.createIndex(
          databaseId: chatDatabase,
          collectionId: collectionId,
          key: '09oeudjry4h5',
          type: 'key',
          attributes: ['senderId'],
          orders: ['ASC']);
      await database.createIndex(
          databaseId: chatDatabase,
          collectionId: collectionId,
          key: '09oeudjrnjugr',
          type: 'key',
          attributes: ['seen'],
          orders: ['ASC']);
      await database.createIndex(
          databaseId: chatDatabase,
          collectionId: collectionId,
          key: 'ploiujjrnjugr',
          type: 'key',
          attributes: ['fileDownloaded'],
          orders: ['ASC']);
      await database.createIndex(
          databaseId: chatDatabase,
          collectionId: collectionId,
          key: '89847ry78uit',
          type: 'key',
          attributes: ['fileDownloaded', 'key'],
          orders: ['ASC', 'ASC']);
      await database.createIndex(
          databaseId: chatDatabase,
          collectionId: collectionId,
          key: '89847ry78uit',
          type: 'key',
          attributes: ['fileDownloaded', 'senderId'],
          orders: ['ASC', 'ASC']);
      // await database.createEnumAttribute(
      //     collectionId: collectionId,
      //     key: "message_type",
      //     elements: ["IMAGE", "VIDEO", "TEXT"],
      //     xdefault: "TEXT",
      //     xrequired: false);
    } on AppwriteException {
      rethrow;
    }
  }
}

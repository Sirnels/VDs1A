// ignore_for_file: invalid_use_of_protected_member, must_call_super, unnecessary_null_comparison, file_names

import 'dart:async';
import 'dart:convert';
import 'dart:io';
//import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:dart_appwrite/dart_appwrite.dart' as server;
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/appwrite.dart' as query;
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:core';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localstorage/localstorage.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viewducts/E2EE/crc.dart';
import 'package:viewducts/encryption/encryption.dart';
import 'package:viewducts/helper/constant.dart';
import 'package:viewducts/helper/enum.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/chatModel.dart';
import 'package:viewducts/model/user.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:viewducts/page/message/local_database.dart';
import 'package:viewducts/state/authState.dart';
import 'package:viewducts/state/seen_state.dart';
import 'package:viewducts/state/stateController.dart';

extension SplitString on String {
  List<String> splitByLength(int length) =>
      [substring(0, length), substring(length)];
}

class ChatState extends GetxController {
  static ChatState instance = Get.find<ChatState>();

  bool? setIsChatScreenOpen;
  // final FirebaseDatabase _database = FirebaseDatabase.instance;
  AuthState? authstate;
  SeenState? seenState;
  bool? mounted;
  Rx<ViewductsUser> chatUserModel = ViewductsUser().obs;

  RxList<ChatMessage>? messageListing = RxList<ChatMessage>([]);
  RxList<ChatMessage> chatMessage = RxList<ChatMessage>([]);
  //Rx<ChatActivenesseModel> chatActive = ChatActivenesseModel().obs;
  RxList<ChatMessage> chatMessageList = RxList<ChatMessage>([]);
  Rx<ChatOnlineStatus> onlineStatus = ChatOnlineStatus().obs;
  Rx<ChatOnlineStatus> chatStatus = ChatOnlineStatus().obs;
  RxList<ChatMessage>? _chatUserList = RxList<ChatMessage>([]);
  RxString? savedFile = ''.obs;
  Rx<ViewductsUser?> _chatUser = ViewductsUser().obs;
  String? serverToken = "<FCM SERVER KEY>";
  FlutterSecureStorage storage = const FlutterSecureStorage();
  late encrypt.Encrypter cryptor;
  final iv = encrypt.IV.fromLength(8);
  bool empty = true;
  int? status;

  /// Get FCM server key from firebase project settings
  ViewductsUser? get chatUser => _chatUser.value;
  set setChatUser(ViewductsUser? model) {
    _chatUser = model.obs;
  }

  RxInt msgCount = 0.obs;
  String? _channelName;
  Stream? messageQuery;

  /// Contains list of chat messages on main chat screen
  /// List is sortBy mesage timeStamp
  /// Last message will be display on the bottom of screen
  RxList<ChatMessage>? get messageList {
    if (messageListing == null) {
      return null;
    } else {
      // messageListing.sort((x, y) => DateTime.parse(y.createdAt)
      //     .toLocal()
      //     .compareTo(DateTime.parse(x.createdAt).toLocal()));
      return messageListing!;
    }
  }

  int? get msgc {
    if (msgCount == null) {
      return null;
    } else {
      // messageListing.sort((x, y) => DateTime.parse(y.createdAt)
      //     .toLocal()
      //     .compareTo(DateTime.parse(x.createdAt).toLocal()));
      return msgCount.value;
    }
  }

  // ChatOnlineStatus? get onlineStatus {
  //   if (onlineStatus == null) {
  //     return null;
  //   } else {
  //     // messageListing.sort((x, y) => DateTime.parse(y.createdAt)
  //     //     .toLocal()
  //     //     .compareTo(DateTime.parse(x.createdAt).toLocal()));
  //     return onlineStatus.value;
  //   }
  // }

  /// Contain list of users who have chat history with logged in user
  RxList<ChatMessage>? get chatUserList {
    if (_chatUserList == null) {
      return null;
    } else {
      return _chatUserList;
    }
  }

  @override
  void onReady() {
    super.onReady();
    final database = Databases(
      clientConnect(),
    );
    database
        .listDocuments(
      databaseId: databaseId,
      collectionId: profileUserColl,
      //  queries: [query.Query.equal('key', ductId)]
    )
        .then((data) {
      // Map map = data.toMap();

      var value =
          data.documents.map((e) => ViewductsUser.fromJson(e.data)).toList();
      //data.documents;
      searchState.viewUserlist = value.obs;
      // cprint('${data.documents.map((e) => FeedModel.fromJson(e.data))}');
      // cprint('${searchState.viewUserlist.value.map((e) => e.key)}');
    });
    // allChatMessage();
//     databaseInit(authState.userId, chatState.chatUser!.userId);
//     chatMessageList.bindStream(getUserchatLists(authState.userId));
// //unreadChatMSGCount(authState.user!.uid,chatState.chatUser!.userId);
//     SharedPreferences.getInstance();
//     authState.updateFCMToken();
//     getFCMServerKey();

    // databaseInit(chatUser.key, authState.userModel.userId);
    //getchatDetailAsync();
    // user = Rx<User>(_firebaseAuth.currentUser);
    // user.bindStream(_firebaseAuth.userChanges());
    // onlineOfflineChatStatus(authState.userId, chatState.chatUser.userId);
    getFCMServerKey();
  }

  @override
  void onClose() async {
    super.onClose();
    chatUserList!.close();
    //chatState.messageListing!.value.close();
  }
  // @override
  // void onInit() {
  //   super.onInit();

  //   // onlineStatus.bindStream(
  //   //     onlineOfflineChatStatus(authState.userId, chatState.chatUser!.userId));

  //   // databaseInit(chatUser.key, authState.userModel.userId);
  //   //getchatDetailAsync();
  //   // user = Rx<User>(_firebaseAuth.currentUser);
  //   // user.bindStream(_firebaseAuth.userChanges());

  //   // databaseInit(chatState.chatUser!.userId, authState.userId);
  // }

  databaseInit(String? currentUser, String? secondUser) async {
    // String _multiChannelName;
    // List<String> list = [
    //   currentUser.substring(0, 5),
    //   secondUser.substring(0, 5)
    // ];
    // list.sort();
    // _multiChannelName = '${list[0]}-${list[1]}';
    // messageListing = null;
    // if (_channelName == null) {
    //   getChannelName(currentUser, secondUser);
    // }
    // vDatabase.collection("chatUsers").where(myId).snapshots().listen((event) {
    //   event.docChanges.forEach((element) {
    //     if (element.type == docChangeType.added) {
    //       _onChatUserAdded(element);
    //     }
    //   });
    // });

    if (messageQuery == null ||
        _channelName != getChannelName(currentUser!, secondUser!)) {
      messageQuery =
          vDatabase.collection("chats").doc(_channelName).snapshots();
      // messageQuery.onChildAdded.listen(_onMessageAdded);
      // messageQuery.onChildChanged.listen(_onMessageChanged);
    }
  }

  /// Fecth FCM server key from firebase Remote config
  /// FCM server key is stored in firebase remote config
  /// you have to add server key in firebase remote config
  /// To fetch this key go to project setting in firebase
  /// Click on `cloud messaging` tab
  /// Copy server key from `Project credentials`
  /// Now goto `Remote Congig` section in fireabse
  /// Add [FcmServerKey]  as paramerter key and below json in Default vslue
  ///  ``` json
  ///  {
  ///    "key": "FCM server key here"
  ///  } ```
  /// For more detail visit:- https://github.com/TheAlphamerc/flutter_twitter_clone/issues/28#issue-611695533
  /// For package detail check:-  https://pub.dev/packages/firebase_remote_config#-readme-tab-
  void getFCMServerKey() async {
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetch();
    await remoteConfig.fetchAndActivate();
    var data = remoteConfig.getString('FcmServerKey');
    if (data.isNotEmpty) {
      serverToken = jsonDecode(data)["key"];
    } else {
      cprint("Please configure Remote config in firebase",
          errorIn: "getFCMServerKey");
    }
  }

  String multiChannelName(String currentUsers, String? secondUser) {
    String _multiChannelName;
    List<String> list = [
      currentUsers.substring(0, 5),
      secondUser!.substring(0, 5)
    ];
    list.sort();
    _multiChannelName = '${list[0]}-${list[1]}';
    return _multiChannelName;
  }

  Stream<List<ChatMessage>> firebaseChatUsers(
    String? userId,
  ) =>
      kDatabase.child('chats/$userId/messages').onValue.map((event) => event
          .snapshot.children
          .map((e) => ChatMessage.fromJson(e.value as Map))
          .toList());

  allChatMessage({String? currentUsers, String? secondUser}) async {
    final database = Databases(
      clientConnect(),
    );
    return await database
        .listDocuments(
      databaseId: databaseId,
      collectionId: chatsColl,
    )
        .then((data) {
      var value =
          data.documents.map((e) => ChatMessage.fromJson(e.data)).toList();
      chatMessage.value = value;
    });
    // String _multiChannelName;
    // List<String> list = [
    //   currentUsers.substring(0, 5),
    //   secondUser!.substring(0, 5)
    // ];
    // list.sort();
    // _multiChannelName = '${list[0]}-${list[1]}';
    // return kDatabase.child('chats/$_multiChannelName/messages').onValue.map(
    //     (event) => event.snapshot.children
    //         .map((e) => ChatMessage.fromJson(e.value as Map))
    //         .toList());

    // vDatabase
    //     .collection('chats')
    //     //reference
    //     .doc(_multiChannelName.toString())
    //     .collection('messages')
    //     .orderBy('timeStamp')
    //     .where('users',
    //         arrayContains: [authState.user!.uid, chatState.chatUser!.userId])
    //     .snapshots()
    //     .map((data) => data.docs
    //         .map((value) => ChatMessage.fromJson(value.data()))
    //         .toList());
  }

  Stream<List<ChatMessage>> getUserchatLists(String? userId) =>
//try {
      // vDatabase.runTransaction((transaction) async {
      //CollectionReference reference =
      kDatabase.child('chatUsers/$userId/messages').onValue.map((event) => event
          .snapshot.children
          .map((p) => ChatMessage.fromJson(p.value as Map))
          .toList());

  /// Fetch users list to who have ever engaged in chat message with logged-in user
  void getUserchatList(String? userId) =>
//try {
      // vDatabase.runTransaction((transaction) async {
      //CollectionReference reference =
      vDatabase
          .collection('chatUsers')
          .doc(authState.userId)
          .collection('messages')
          .snapshots()
          .listen((snapshot) {
        _chatUserList!.value = <ChatMessage>[];
        if (snapshot.docs != null) {
          for (var value in snapshot.docs) {
            var model = ChatMessage.fromJson(value.data());
            model.key = value.id;
            _chatUserList!.value.add(model);
          }

          _chatUserList!.value.sort((x, y) {
            if (x.createdAt != null && y.createdAt != null) {
              return DateTime.parse(y.createdAt)
                  .compareTo(DateTime.parse(x.createdAt));
            } else {
              if (x.createdAt != null) {
                return 0;
              } else {
                return 1;
              }
            }
          });
        } else {
          _chatUserList = null;
        }
        update();
      });
  //});
  // } catch (error) {
  //   cprint(error);
  // }

  /// Fetch chat  all chat messages
  /// `_channelName` is used as primary key for chat message table
  /// `_channelName` is created from  by combining first 5 letters from user ids of two users
  getchatDetailAsync(String? currentUser, String? secondUser) {
    try {
      String _multiChannelName;
      List<String> list = [
        currentUser!.substring(0, 5),
        secondUser!.substring(0, 5)
      ];
      list.sort();
      _multiChannelName = '${list[0]}-${list[1]}';
      // vDatabase.runTransaction((transaction) async {
      //CollectionReference reference =
      vDatabase
          .collection('chats')
          //reference
          .doc(_multiChannelName)
          .collection('messages')
          .orderBy('timeStamp')
          .snapshots()
          .listen((snapshot) {
        messageListing!.value = <ChatMessage>[];
        if (snapshot.docs != null) {
          for (var value in snapshot.docs) {
            var model = (ChatMessage.fromJson(value.data()));
            // model.message = decryptWithCRC(model.message);

            model.key = value.id;

            messageListing!.value.add(model);
            // cprint('chat messages');
            // return messageListing;
          }
        } else {
          messageListing = null;
        }
        update();
      });

      //});
    } catch (error) {
      cprint(error);
    }
    return messageListing;
  }

  Future<int?> getUnreadMSGCount([String? peerUserID]) async {
    try {
      int unReadMSGCount = 0;
      String targetID = '';
      SharedPreferences prefs = await SharedPreferences.getInstance();

      peerUserID == null
          ? targetID = (prefs.get('userId') as String? ?? 'NoId')
          : targetID = peerUserID;
//      if (targetID != 'NoId') {
      final QuerySnapshot chatListResult = await vDatabase
          .collection('users')
          .doc(targetID)
          .collection('chatlist')
          .get();
      final List<DocumentSnapshot> chatListDocuments = chatListResult.docs;
      for (var data in chatListDocuments) {
        final QuerySnapshot unReadMSGDocument = await vDatabase
            .collection('chatroom')
            .doc(data['chatID'])
            .collection(data['chatID'])
            .where('idTo', isEqualTo: targetID)
            .where('isread', isEqualTo: false)
            .get();

        final List<DocumentSnapshot> unReadMSGDocuments =
            unReadMSGDocument.docs;
        unReadMSGCount = unReadMSGCount + unReadMSGDocuments.length;
      }
      // cprint('unread MSG count is $unReadMSGCount');
//      }
      if (peerUserID == null) {
        //  FlutterAppBadger.updateBadgeCount(unReadMSGCount);
        return null;
      } else {
        return unReadMSGCount;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return null;
  }

  creatCollectionId(String curruserId, String otheruserId) async {
    try {
      final database = Databases(
        clientConnect(),
      );
      database.createDocument(
          databaseId: databaseId,
          collectionId: 'unique()',
          documentId:
              '${curruserId.splitByLength((curruserId.length) ~/ 2)[0]}_${otheruserId.splitByLength((otheruserId.length) ~/ 2)[0]}',
          data: {'user1': curruserId, 'user2': otheruserId, 'NewChats': true});
    } on AppwriteException catch (e) {
      cprint("$e");
    }
  }

  allChatMessages(String curruserId, String otheruserId) async {
    final database = Databases(
      clientConnect(),
    );
    return await database
        .listDocuments(
      databaseId: chatDatabase,
      collectionId:
          '${curruserId.splitByLength((curruserId.length) ~/ 2)[0]}_${otheruserId.splitByLength((otheruserId.length) ~/ 2)[0]}',
    )
        .then((data) {
      if (data.documents.isNotEmpty) {
        var value =
            data.documents.map((e) => ChatMessage.fromJson(e.data)).toList();
        //  setState(() {
        chatState.chatMessage = value.obs;
        // });
      } else {}
    }).onError((error, stackTrace) async {
      if (error == 404) {
        await database
            .listDocuments(
          databaseId: chatDatabase,
          collectionId:
              '${otheruserId.splitByLength((otheruserId.length) ~/ 2)[0]}_${curruserId.splitByLength((curruserId.length) ~/ 2)[0]}',
        )
            .then((data) {
          if (data.documents.isNotEmpty) {
            var value = data.documents
                .map((e) => ChatMessage.fromJson(e.data))
                .toList();
            //  setState(() {
            chatState.chatMessage = value.obs;
            // });
          } else {}
        });
      }
    });
  }

  collChatsMessageId(String curruserId, String otheruserId) =>
      '${curruserId.splitByLength((curruserId.length) ~/ 2)[0]}_${otheruserId.splitByLength((otheruserId.length) ~/ 2)[0]}';
  getChatActiveness(String activ, String currentUser, String secondUser,
      {String? status}) async {
    final database = Databases(
      clientConnect(),
    );
    String timestamps = DateTime.now().toUtc().toString();
    final id =
        '${currentUser.splitByLength((currentUser.length) ~/ 2)[0]}_${secondUser.splitByLength((secondUser.length) ~/ 2)[0]}';
    await database.listDocuments(
        databaseId: databaseId,
        collectionId: chatActiveColl,
        queries: [query.Query.equal('ids', id.toString())]).then((data) async {
      if (data.documents.isNotEmpty) {
        await database.updateDocument(
          databaseId: databaseId,
          collectionId: chatActiveColl,
          documentId: id,
          permissions: [
            Permission.read(Role.users()),
          ],
          data: {
            'chatOnlineChatStatus': activ,
            'ids': id,
            'uid': currentUser,
            'seenChat': timestamps,
            'lastSeen':
                DateTime.now().toUtc().millisecondsSinceEpoch.toString(),
            // 'userSeen': timestamps,
            'chatStatus': status,
          },
        );
      } else {
        await database.createDocument(
          databaseId: databaseId,
          collectionId: chatActiveColl,
          documentId: id,
          permissions: [
            Permission.read(Role.users()),
          ],
          data: {
            'chatOnlineChatStatus': activ,
            'ids': id,
            'uid': currentUser,
            'seenChat': timestamps,
            'lastSeen':
                DateTime.now().toUtc().millisecondsSinceEpoch.toString(),
            //'userSeen': timestamps,
            'chatStatus': status,
          },
        );
      }
    });
  }

  upDateChatListMessages(
      {ChatMessage? message,
      String? currentUser,
      String? secondUser,
      ChatMessage? instMsg}) async {
    final database = Databases(
      clientConnect(),
    );
    String _multiChannelName;

    // List<String> list = [
    //   currentUser!.substring(4, 15),
    //   secondUser!.substring(4, 15)
    // ];
    // list.sort();
    _multiChannelName =
        '${currentUser!.substring(4, 15)}-${secondUser!.substring(4, 15)}';
    await database.updateDocument(
      databaseId: databaseId,
      collectionId: chatsColl,
      documentId: _multiChannelName.toString(),
      data: {'clicked': 'true'},
    );
  }

  Rx<ChatOnlineStatus> myonlineStatus = ChatOnlineStatus().obs;
  onMessageSubmitted(ChatMessage message, String currentUser, String secondUser,
      ChatMessage instMsg,
      {String? notofication, String? key}) async {
    String _multiChannelName;
    String _multiChannelNameSecondUser;
    //  ChatMessage chatList;
    _multiChannelName =
        '${currentUser.substring(4, 15)}-${secondUser.substring(4, 15)}';
    // chatList = ChatMessage(
    //     message: message.message,
    //     fileDownloaded: message.fileDownloaded,
    //     createdAt: message.createdAt,
    //     receiverId: message.receiverId!,
    //     senderId: message.senderId,
    //     imageKey: message.imageKey,
    //     searchKey: message.searchKey,
    //     userId: message.userId,
    //     chatlistKey: message.chatlistKey,
    //     videoKey: message.videoKey,
    //     audioFile: message.audioFile,
    //     reactions: message.reactions,
    //     orderState: message.orderState,
    //     productName: message.productName,
    //     receiverReactions: message.receiverReactions,
    //     sellerId: message.sellerId,
    //     senderReactions: message.senderReactions,
    //     videoThumbnail: message.videoThumbnail,
    //     voiceMessage: message.voiceMessage,
    //     clicked: message.clicked,
    //     key: _multiChannelName,
    //     newChats: message.newChats,
    //     replyedMessage: message.replyedMessage,
    //     imagePath: message.imagePath,
    //     seen: message.seen,
    //     type: message.type,
    //     timeStamp: message.timeStamp,
    //     senderName: message.senderName);

    // await SQLHelper.createLocalchatList(chatList);
    //'${list[0]}-${list[1]}';
    // final id =
    //     '${currentUser.splitByLength((currentUser.length) ~/ 2)[0]}_${secondUser.splitByLength((secondUser.length) ~/ 2)[0]}';

    // var chatId = const Uuid().v1();
    /// message.searchKey = await _multiChannelName;
    final database = Databases(
      clientConnect(),
    );

    cprint('uploded message key ${message.key}');
    await database.createDocument(
        databaseId: chatDatabase,
        collectionId: '${message.chatlistKey}',
        documentId: message.key.toString(),
        data: message.toJson());

    await database.listDocuments(
        databaseId: databaseId.toString(),
        collectionId: chatsColl.toString(),
        queries: [
          query.Query.equal('chatlistKey', message.chatlistKey.toString())
        ]).then((data) async {
      message.key = _multiChannelName;
      if (data.documents.isNotEmpty) {
        await database.updateDocument(
          databaseId: databaseId,
          collectionId: chatsColl,
          documentId: _multiChannelName.toString(),
          data: message.toJson(),
        );
        cprint('message updated');
      } else if (data.documents.isEmpty) {
        await database.createDocument(
          databaseId: databaseId.toString(),
          collectionId: chatsColl.toString(),
          documentId: _multiChannelName.toString(),
          data: message.toJson(),
        );
        cprint('message created online');
      }
    });
    //.then((value) async {
    final databases = server.Databases(
      serverApi.serverClientConnect(),
    );
    _multiChannelNameSecondUser =
        '${secondUser.substring(4, 15)}-${currentUser.substring(4, 15)}';
    var secondUserMessage = message;
    secondUserMessage.senderId = secondUser;
    secondUserMessage.key = _multiChannelNameSecondUser;
    secondUserMessage.receiverId = currentUser;
    await databases.listDocuments(
        databaseId: databaseId.toString(),
        collectionId: chatsColl.toString(),
        queries: [
          query.Query.equal('key', _multiChannelNameSecondUser.toString())
        ]).then((data) async {
      if (data.documents.isNotEmpty) {
        await databases.updateDocument(
            databaseId: databaseId,
            collectionId: chatsColl,
            documentId: _multiChannelNameSecondUser.toString(),
            data: secondUserMessage.toJson(),
            permissions: [
              Permission.read(Role.user("$secondUser")),
              Permission.write(Role.user("$secondUser")),
              Permission.update(Role.user("$secondUser")),
            ]);
        cprint('second user message updated');
      } else if (data.documents.isEmpty) {
        await databases.createDocument(
            databaseId: databaseId.toString(),
            collectionId: chatsColl.toString(),
            documentId: _multiChannelNameSecondUser.toString(),
            data: secondUserMessage.toJson(),
            permissions: [
              Permission.read(Role.user("$secondUser")),
              Permission.write(Role.user("$secondUser")),
              Permission.update(Role.user("$secondUser")),
            ]);
        cprint('second user message created online');
      }
    });
    // });

    if (notofication == null || notofication == '0n') {
      sendAndRetrieveMessage(message);
    } else {
      emptyOperation();
    }

    logEvent('send_message');
    try {} on AppwriteException catch (error) {
      if (error == 409) {
        cprint('$error onMessageSubmitted');
      }
      if (error == 404) {
        try {
          final ids =
              '${secondUser.splitByLength((secondUser.length) ~/ 2)[0]}_${currentUser.splitByLength((currentUser.length) ~/ 2)[0]}';
          //  if (currentUser == secondUser) {
          await database.createDocument(
            databaseId: chatDatabase,
            collectionId: ids,
            documentId: message.key.toString(),
            data: message.toJson(),
          );

          await database.listDocuments(
              databaseId: databaseId,
              collectionId: chatsColl,
              queries: [
                query.Query.equal('searchKey', message.searchKey.toString())
              ]).then((data) async {
            if (data.documents.isNotEmpty) {
              await database.updateDocument(
                databaseId: databaseId,
                collectionId: chatsColl,
                documentId: _multiChannelName,
                data: message.toJson(),
              );
              cprint('message updated');
            } else {
              await database.createDocument(
                databaseId: databaseId,
                collectionId: chatsColl,
                documentId: _multiChannelName,
                data: message.toJson(),
              );
              cprint('message created online');
            }
          });

          if (notofication == null || notofication == '0n') {
            sendAndRetrieveMessage(message);
          } else {
            emptyOperation();
          }

          logEvent('send_message');
        } catch (e) {
          cprint('$e onMessageSubmitted');
        }
      }
    }
  }

  emptyOperation() {}
  void storySubmitMessage(
    ChatStoryModel message,
    String currentUser,
    String? storyId,
    String? secondUser,
  ) async {
    // ignore: prefer_const_constructors
    //  var chatId = Uuid().v1();
    try {
      final database = Databases(
        clientConnect(),
      );

      await database.createDocument(
        databaseId: databaseId,
        collectionId: storyChtsId,
        documentId: message.key.toString(),
        data: message.toJson(),
      );
      // kDatabase.child('duct/${authState.userId}').update(model.toJson());
      // vDatabase.runTransaction((transaction) async {
      //   CollectionReference reference = vDatabase.collection('duct');
      //   await reference.doc(authState.userId).set(model.toJson());
      // });
    } on AppwriteException catch (error) {
      cprint(error, errorIn: 'storyChat');
    }
    // try {
    //   //var key = kDatabase.child('ductStory/$secondUser/story/$storyId').key;
    //   kDatabase
    //       .child('storyChats/$storyId/$chatId')
    //       //.push()
    //       .update(message.toJson());
    // } catch (error) {
    //   cprint(error);
    // }
  }

  updateDownlodImageMessage(
      {ChatMessage? chat,
      ChatMessage? localMessage,
      String? key,
      String? currentUser,
      String? secondUser,
      int? reaction}) async {
    List<String> list = [
      currentUser!.substring(0, 5),
      secondUser!.substring(0, 5)
    ];
    list.sort();

    try {
      await SQLHelper.updateLocalMessage(localMessage!);

      final database = Databases(
        clientConnect(),
      );
      database.updateDocument(
          databaseId: chatDatabase,
          collectionId: chat!.chatlistKey.toString(),
          data: {'fileDownloaded': 'downloded', 'seen': 'true'},
          documentId: chat.key.toString());
    } catch (e) {
      if (e == 400) {
        cprint('$e updateDownlodImageMessage');
      }
      if (e == 404) {
        try {
          final ids =
              '${secondUser.splitByLength((secondUser.length) ~/ 2)[0]}_${currentUser.splitByLength((currentUser.length) ~/ 2)[0]}';
          await SQLHelper.updateLocalMessage(localMessage!);
          final database = Databases(
            clientConnect(),
          );
          database.updateDocument(
              databaseId: chatDatabase,
              collectionId: ids,
              data: chat!.toJson(),
              documentId: chat.key.toString());
        } catch (e) {
          cprint('$e');
        }
      }
    }
  }

  deleteMessage(
      {ChatMessage? chat,
      String? key,
      String? currentUser,
      String? secondUser,
      int? reaction}) async {
    try {
      // await SQLHelper.deletLocalMessage(chat!);
      // chatState.chatMessage.value =
      //     await SQLHelper.findLocalMessages(chat.chatlistKey.toString());
      String _multiChannelNameSecondUser;
      String _multiChannelName;

      // List<String> list = [
      //   currentUser.substring(4, 15),
      //   secondUser.substring(4, 15)
      // ];
      // list.sort();
      _multiChannelName =
          '${currentUser!.substring(4, 15)}-${secondUser!.substring(4, 15)}';
      final database = Databases(
        clientConnect(),
      );

      cprint(chat!.key.toString());
      cprint(chat.senderId.toString());
      cprint(chat.chatlistKey.toString());

      if (chat.seen == 'deleted') {
        await SQLHelper.deletLocalMessage(chat);
        chatState.chatMessage.value =
            await SQLHelper.findLocalMessages(chat.chatlistKey.toString());
        await database.deleteDocument(
            databaseId: chatDatabase,
            collectionId: chat.chatlistKey.toString(),
            documentId: chat.key.toString());
      } else if (authState.appUser?.$id == chat.userId) {
        chat.seen = 'deleted';
        await SQLHelper.deletLocalMessage(chat);
        chatState.chatMessage.value =
            await SQLHelper.findLocalMessages(chat.chatlistKey.toString());
        await database.updateDocument(
          databaseId: chatDatabase,
          collectionId: chat.chatlistKey.toString(),
          documentId: chat.key.toString(),
          data: ({'seen': 'deleted', 'fileDownloaded': 'new'}),
        );
        await database.listDocuments(
            databaseId: databaseId.toString(),
            collectionId: chatsColl.toString(),
            queries: [
              query.Query.equal('chatlistKey', chat.chatlistKey.toString())
            ]).then((data) async {
          if (data.documents.isNotEmpty) {
            await database.updateDocument(
              databaseId: databaseId,
              collectionId: chatsColl,
              documentId: _multiChannelName.toString(),
              data: chat.toJson(),
            );
            cprint('online message deleted');
          } else if (data.documents.isEmpty) {
            await database.createDocument(
              databaseId: databaseId.toString(),
              collectionId: chatsColl.toString(),
              documentId: _multiChannelName.toString(),
              data: chat.toJson(),
            );
            cprint('online message deleted');
          } else {}
        });
      } else {
        await SQLHelper.deletLocalMessage(chat);
        chatState.chatMessage.value =
            await SQLHelper.findLocalMessages(chat.chatlistKey.toString());
        await database.updateDocument(
          databaseId: chatDatabase,
          collectionId: chat.chatlistKey.toString(),
          documentId: chat.key.toString(),
          data: ({
            'seen': 'deleted for me',
          }),
        );
      }
      final databases = server.Databases(
        serverApi.serverClientConnect(),
      );
      _multiChannelNameSecondUser =
          '${secondUser.substring(4, 15)}-${currentUser.substring(4, 15)}';
      var secondUserMessage = chat;
      secondUserMessage.senderId = secondUser;
      secondUserMessage.key = _multiChannelNameSecondUser;
      secondUserMessage.receiverId = currentUser;
      await databases.listDocuments(
          databaseId: databaseId.toString(),
          collectionId: chatsColl.toString(),
          queries: [
            query.Query.equal('key', _multiChannelNameSecondUser.toString())
          ]).then((data) async {
        if (data.documents.isNotEmpty) {
          await databases.updateDocument(
              databaseId: databaseId,
              collectionId: chatsColl,
              documentId: _multiChannelNameSecondUser.toString(),
              data: secondUserMessage.toJson(),
              permissions: [
                Permission.read(Role.user("$secondUser")),
                Permission.write(Role.user("$secondUser")),
                Permission.update(Role.user("$secondUser")),
              ]);
          cprint('delete second user message updated');
        } else if (data.documents.isEmpty) {
          await databases.createDocument(
              databaseId: databaseId.toString(),
              collectionId: chatsColl.toString(),
              documentId: _multiChannelNameSecondUser.toString(),
              data: secondUserMessage.toJson(),
              permissions: [
                Permission.read(Role.user("$secondUser")),
                Permission.write(Role.user("$secondUser")),
                Permission.update(Role.user("$secondUser")),
              ]);
          cprint('delete second user message created online');
        }
      });
      // });

    } catch (e) {
      cprint('$e Deleted Document ');
      // if (e == 404) {
      //   try {
      //     final ids =
      //         '${secondUser.splitByLength((secondUser.length) ~/ 2)[0]}_${currentUser.splitByLength((currentUser.length) ~/ 2)[0]}';
      //     await SQLHelper.deletLocalMessage(chat!);
      //     chatState.chatMessage.value = await SQLHelper.findLocalMessages(
      //         '${currentUser.splitByLength((currentUser.length) ~/ 2)[0]}_${secondUser.splitByLength((secondUser.length) ~/ 2)[0]}');
      //     if (chatState.chatMessage.value.isEmpty) {
      //       chatState.chatMessage.value = await SQLHelper.findLocalMessages(
      //           '${secondUser.splitByLength((secondUser.length) ~/ 2)[0]}_${currentUser.splitByLength((currentUser.length) ~/ 2)[0]}');
      //     }
      //     final database = Databases(
      //       clientConnect(),
      //     );
      //     database.deleteDocument(
      //         databaseId: databaseId,
      //         collectionId: ids,
      //         documentId: chat.key.toString());
      //   } catch (e) {
      //     cprint('$e');
      //   }
      // }
    }
  }

  onMessageUpdate(ChatMessage? chat, String? key, String? currentUser,
      String? secondUser, int? reaction) async {
    List<String> list = [
      currentUser!.substring(0, 5),
      secondUser!.substring(0, 5)
    ];
    list.sort();

    String _multiChannelName;

    // List<String> list = [
    //   currentUser.substring(4, 15),
    //   secondUser.substring(4, 15)
    // ];
    // list.sort();
    _multiChannelName =
        '${currentUser.substring(4, 15)}-${secondUser.substring(4, 15)}';
    // var chatId = const Uuid().v1();
    try {
      final database = Databases(
        clientConnect(),
      );
      await SQLHelper.addReaction(
        chat,
        int.parse(reaction.toString()),
        authState.userModel!.key!,
      );
      chatState.chatMessage.value =
          await SQLHelper.findLocalMessages(chat!.chatlistKey.toString());
      if (authState.appUser!.$id == currentUser) {
        chat.senderReactions = reaction;
        // await database.listDocuments(
        //     databaseId: chatDatabase,
        //     collectionId: chat.chatlistKey.toString(),
        //     queries: [query.Query.equal('key', key)]).then((data) async {
        //   if (data.documents.isNotEmpty) {
        await database.updateDocument(
          databaseId: chatDatabase,
          collectionId: chat.chatlistKey.toString(),
          documentId: key.toString(),
          data: ({
            'senderReactions': reaction.toString(),
            'fileDownloaded': 'new'
          }),
        );
        await database.listDocuments(
            databaseId: databaseId.toString(),
            collectionId: chatsColl.toString(),
            queries: [
              query.Query.equal('chatlistKey', chat.chatlistKey.toString())
            ]).then((data) async {
          if (data.documents.isNotEmpty) {
            await database.updateDocument(
              databaseId: databaseId,
              collectionId: chatsColl,
              documentId: _multiChannelName.toString(),
              data: chat.toJson(),
            );
            cprint('message updated');
          } else if (data.documents.isEmpty) {
            await database.createDocument(
              databaseId: databaseId.toString(),
              collectionId: chatsColl.toString(),
              documentId: _multiChannelName.toString(),
              data: chat.toJson(),
            );
            cprint('message created online');
          } else {}
        });
        cprint('reaction updated');
        sendAndRetrieveMessageReaction(
          chat,
        );
        //   }
        // });
      } else {
        chat.receiverReactions = reaction;
        // await database.listDocuments(
        //     databaseId: chatDatabase,
        //     collectionId: id,
        //     queries: [query.Query.equal('key', key)]).then((data) async {
        //   if (data.documents.isNotEmpty) {
        await database.updateDocument(
          databaseId: chatDatabase,
          collectionId: chat.chatlistKey.toString(),
          documentId: key.toString(),
          data: ({
            'receiverReactions': reaction.toString(),
            'fileDownloaded': 'new'
          }),
        );
        //   }
        // });
        await database.listDocuments(
            databaseId: databaseId.toString(),
            collectionId: chatsColl.toString(),
            queries: [
              query.Query.equal('chatlistKey', chat.chatlistKey.toString())
            ]).then((data) async {
          if (data.documents.isNotEmpty) {
            await database.updateDocument(
              databaseId: databaseId,
              collectionId: chatsColl,
              documentId: _multiChannelName.toString(),
              data: chat.toJson(),
            );
            cprint('message updated');
          } else if (data.documents.isEmpty) {
            await database.createDocument(
              databaseId: databaseId.toString(),
              collectionId: chatsColl.toString(),
              documentId: _multiChannelName.toString(),
              data: chat.toJson(),
            );
            cprint('message created online');
          } else {}
        });
        cprint('reaction updated');
        sendAndRetrieveMessageReaction(
          chat,
        );
      }

      // sendAndRetrieveMessage(message);
      // logEvent('send_message');
    } on AppwriteException catch (error) {
      if (error == 404) {
        try {
          final id =
              '${secondUser.splitByLength((secondUser.length) ~/ 2)[0]}_${currentUser.splitByLength((currentUser.length) ~/ 2)[0]}';

          // var chatId = const Uuid().v1();
          final database = Databases(
            clientConnect(),
          );

          if (authState.appUser!.$id == currentUser) {
            await database.listDocuments(
                databaseId: chatDatabase,
                collectionId: id,
                queries: [query.Query.equal('key', key)]).then((data) async {
              if (data.documents.isNotEmpty) {
                await database.updateDocument(
                  databaseId: chatDatabase,
                  collectionId: id.toString(),
                  documentId: key.toString(),
                  data: ({
                    'senderReactions': reaction.toString(),
                  }),
                );
              }
            });
          } else {
            await database.listDocuments(
                databaseId: chatDatabase,
                collectionId: id,
                queries: [query.Query.equal('key', key)]).then((data) async {
              if (data.documents.isNotEmpty) {
                await database.updateDocument(
                  databaseId: chatDatabase,
                  collectionId: id.toString(),
                  documentId: key.toString(),
                  data: ({
                    'receiverReactions': reaction.toString(),
                  }),
                );
              }
            });
          }
        } on AppwriteException catch (e) {
          cprint('$e onMessageUpdate');
        }
      }
    }
  }

  listingMessagesLikes(
    RxList<ChatMessage> feedListSetState,
    ChatMessage chat,
    String? currentUser,
    String? secondUser,
  ) async {
    List<String> list = [
      currentUser!.substring(0, 5),
      secondUser!.substring(0, 5)
    ];
    list.sort();

    final id =
        '${currentUser.splitByLength((currentUser.length) ~/ 2)[0]}_${secondUser.splitByLength((secondUser.length) ~/ 2)[0]}';

    // var chatId = const Uuid().v1();
    try {
      final database = Databases(
        clientConnect(),
      );

      await database
          .listDocuments(
        databaseId: chatDatabase,
        collectionId: id,
        //  queries: [query.Query.equal('key', '')]
      )
          .then((data) async {
        if (data.documents.isNotEmpty) {
          var value =
              data.documents.map((e) => ChatMessage.fromJson(e.data)).toList();

          feedListSetState.value = value.where((feedData) {
            if (chat.key == feedData.message) {
              return true;
            } else {
              return false;
            }
          }).toList();
          ;
        }
      });

      // sendAndRetrieveMessage(message);
      // logEvent('send_message');
    } on AppwriteException catch (error) {
      if (error == 404) {
        try {
          final id =
              '${secondUser.splitByLength((secondUser.length) ~/ 2)[0]}_${currentUser.splitByLength((currentUser.length) ~/ 2)[0]}';

          // var chatId = const Uuid().v1();
          final database = Databases(
            clientConnect(),
          );

          await database
              .listDocuments(
            databaseId: chatDatabase,
            collectionId: id,
            // queries: [query.Query.equal('key', '')]
          )
              .then((data) async {
            if (data.documents.isNotEmpty) {
              var value = data.documents
                  .map((e) => ChatMessage.fromJson(e.data))
                  .toList();

              feedListSetState.value = value.where((feedData) {
                if (chat.key == feedData.message) {
                  return true;
                } else {
                  return false;
                }
              }).toList();
              ;
            }
          });
        } on AppwriteException catch (e) {
          cprint('$e onMessageUpdate');
        }
      }
    }
  }

  void multipleMessageSubmitted(
      var message, String? currentUser, List vendors) async {
    try {
//      int i;
      String _multiChannelName;

      for (var uid in vendors) {
        vDatabase.collection('chatUsers').doc(currentUser).set(
          {},
        ).then((value) {
          vDatabase
              .collection('chatUsers')
              .doc(currentUser)
              .collection('messages')
              .doc(uid)
              .set(
                message.toJson(),
              );
        });
      }
      for (var uid in vendors) {
        List<String?> list = [
          currentUser!.substring(0, 5),
          uid.substring(0, 5)
        ];
        list.sort();
        _multiChannelName = '${list[0]}-${list[1]}';

        vDatabase.collection('chats').doc(_multiChannelName).set(
          {},
        ).then((value) async {
          var response = await vDatabase.collection('chats').get();
          for (var doc in response.docs) {
            vDatabase
                .collection('chats')
                .doc(doc.id)
                .collection('messages')
                .add(message.toJson());
          }
        });
      }

      // sendAndRetrieveMessage(message);
      logEvent('send_message');
    } catch (error) {
      cprint('$error');
    }
  }

  request(String? currentUserNo, String? recieverChatId) {
    vDatabase
        .collection('chatUsers')
        .doc(currentUserNo)
        .collection(CHATS_WITH)
        .doc(CHATS_WITH)
        .set({'$recieverChatId': ChatStatus.waiting.index},
            SetOptions(merge: true));
    vDatabase
        .collection('chatUsers')
        .doc(recieverChatId)
        .collection(CHATS_WITH)
        .doc(CHATS_WITH)
        .set({'$currentUserNo': ChatStatus.requested.index},
            SetOptions(merge: true));
  }

  accept(String? currentUserNo, String? recieverChatId) {
    FirebaseFirestore.instance
        .collection('chatUsers')
        .doc(currentUserNo)
        .collection(CHATS_WITH)
        .doc(CHATS_WITH)
        .set({'$recieverChatId': ChatStatus.accepted.index},
            SetOptions(merge: true));
  }

  block(String currentUserNo, String recieverChatId,
      {dynamic chatStatus}) async {
    final database = Databases(
      clientConnect(),
    );

    final id =
        '${currentUserNo.splitByLength((currentUserNo.length) ~/ 2)[0]}_${recieverChatId.splitByLength((recieverChatId.length) ~/ 2)[0]}';
    await database.listDocuments(
        databaseId: databaseId,
        collectionId: chatActiveColl,
        queries: [query.Query.equal('ids', id.toString())]).then((data) async {
      if (data.documents.isNotEmpty) {
        await database.updateDocument(
          databaseId: databaseId,
          collectionId: chatActiveColl,
          documentId: id,
          permissions: [
            Permission.read(Role.users()),
          ],
          data: {
            'chatStatus': chatStatus.toString(),
          },
        );
      } else {
        await database.createDocument(
          databaseId: databaseId,
          collectionId: chatActiveColl,
          documentId: id,
          permissions: [
            Permission.read(Role.users()),
          ],
          data: {
            'chatStatus': chatStatus.toString(),
          },
        );
      }
    });
    ViewDucts.toast('Blocked.');
  }

  unblock(String currentUserNo, String recieverChatId,
      {dynamic chatStatus}) async {
    final database = Databases(
      clientConnect(),
    );
    final id =
        '${currentUserNo.splitByLength((currentUserNo.length) ~/ 2)[0]}_${recieverChatId.splitByLength((recieverChatId.length) ~/ 2)[0]}';
    await database.listDocuments(
        databaseId: databaseId,
        collectionId: chatActiveColl,
        queries: [query.Query.equal('ids', id.toString())]).then((data) async {
      if (data.documents.isNotEmpty) {
        await database.updateDocument(
          databaseId: databaseId,
          collectionId: chatActiveColl,
          documentId: id,
          permissions: [
            Permission.read(Role.users()),
          ],
          data: {
            'chatStatus': chatStatus.toString(),
          },
        );
      } else {
        await database.createDocument(
          databaseId: databaseId,
          collectionId: chatActiveColl,
          documentId: id,
          permissions: [
            Permission.read(Role.users()),
          ],
          data: {
            'chatStatus': chatStatus.toString(),
          },
        );
      }
    });

    ViewDucts.toast('unBlocked.');
  }

  offNotification(String currentUserNo, String recieverChatId,
      {dynamic chatStatus}) async {
    final database = Databases(
      clientConnect(),
    );
    final id =
        '${currentUserNo.splitByLength((currentUserNo.length) ~/ 2)[0]}_${recieverChatId.splitByLength((recieverChatId.length) ~/ 2)[0]}';
    await database.listDocuments(
        databaseId: databaseId,
        collectionId: chatActiveColl,
        queries: [query.Query.equal('ids', id.toString())]).then((data) async {
      if (data.documents.isNotEmpty) {
        await database.updateDocument(
          databaseId: databaseId,
          collectionId: chatActiveColl,
          documentId: id,
          permissions: [
            Permission.read(Role.users()),
          ],
          data: {
            'notofication': chatStatus.toString(),
          },
        );
      } else {
        await database.createDocument(
          databaseId: databaseId,
          collectionId: chatActiveColl,
          documentId: id,
          permissions: [
            Permission.read(Role.users()),
          ],
          data: {
            'notofication': chatStatus.toString(),
          },
        );
      }
    });

    ViewDucts.toast('unBlocked.');
  }

  onNotification(String currentUserNo, String recieverChatId,
      {dynamic chatStatus}) async {
    final database = Databases(
      clientConnect(),
    );
    final id =
        '${currentUserNo.splitByLength((currentUserNo.length) ~/ 2)[0]}_${recieverChatId.splitByLength((recieverChatId.length) ~/ 2)[0]}';
    await database.listDocuments(
        databaseId: databaseId,
        collectionId: chatActiveColl,
        queries: [query.Query.equal('ids', id.toString())]).then((data) async {
      if (data.documents.isNotEmpty) {
        await database.updateDocument(
          databaseId: databaseId,
          collectionId: chatActiveColl,
          documentId: id,
          permissions: [
            Permission.read(Role.users()),
          ],
          data: {
            'notofication': chatStatus.toString(),
          },
        );
      } else {
        await database.createDocument(
          databaseId: databaseId,
          collectionId: chatActiveColl,
          documentId: id,
          permissions: [
            Permission.read(Role.users()),
          ],
          data: {
            'notofication': chatStatus.toString(),
          },
        );
      }
    });

    ViewDucts.toast('unBlocked.');
  }

  getStatus(String currentUserNo, String recieverChatId) async {
    int? state;
    var doc = await FirebaseFirestore.instance
        .collection('chatUsers')
        .doc(currentUserNo)
        .collection(CHATS_WITH)
        .where(recieverChatId, isEqualTo: state)

//.doc(CHATS_WITH)
        .get();

    for (var e in doc.docs) {
      status = e.data()[recieverChatId];
    }
    //     .then((value) {
    //   cprint(value.data()[recieverChatId]);
    // });

    return status;
    //  ChatStatus.values[status];
  }

  setReadMessages(String currentUserNo, String recieverChatId) async {
    try {
      String _multiChannelName;
      List<String> list = [
        currentUserNo.substring(0, 5),
        recieverChatId.substring(0, 5)
      ];
      list.sort();
      _multiChannelName = '${list[0]}-${list[1]}';
      return kDatabase
          .child('chats/$_multiChannelName/messages')
          .root
          // .orderByChild('seen')
          .equalTo('seen')
          //.startAt('seen')
          .ref
          // .child('chats/$_multiChannelName/messages')
          // .equalTo({'sender_id': recieverChatId.toString()})
          // .ref
          .update({'seen': true});
      // var status;

      // vDatabase
      //     .collection('chats')
      //     .doc(_multiChannelName)
      //     .get()
      //     .then((snapshot) async {
      //   snapshot.reference
      //       .collection('messages')
      //       .where('seen', isEqualTo: false)
      //       .where('sender_id', isEqualTo: recieverChatId)
      //       .get()
      //       .then((res) {
      //     var batch = vDatabase.batch();
      //     for (var doc in res.docs) {
      //       var docRef = vDatabase
      //           .collection('chats')
      //           .doc(_multiChannelName)
      //           .collection('messages')
      //           .doc(doc.id);
      //       batch.update(docRef, {'seen': true});
      //       //  cprint('completed');
      //       batch.commit().then((value) => cprint('completed'));
      //     }
      //   });
      // });
      // vDatabase
      //     .collection('chatUsers')
      //     .doc(currentUserNo)
      //     .get()
      //     .then((snapshot) async {
      //   snapshot.reference
      //       .collection('messages')
      //       .where('seen', isEqualTo: false)
      //       .where('sender_id', isEqualTo: recieverChatId)
      //       .get()
      //       .then((res) {
      //     var batch = vDatabase.batch();
      //     for (var doc in res.docs) {
      //       var docRef = vDatabase
      //           .collection('chatUsers')
      //           .doc(currentUserNo)
      //           .collection('messages')
      //           .doc(recieverChatId);
      //       batch.update(docRef, {'seen': true});
      //       // cprint('chat chat');
      //       batch.commit();
      //     }
      //   });
      // });

      // .get()
      // .then((value) {

      // });

      // status = docs.data()[recieverChatId];
      // cprint('$status');
      // return status;
    } catch (e) {
      cprint('$e in chat message');
    }
  }

  // getOnlineOfflineStatus(String currentUserNo, String recieverChatId) async {
  //   String _multiChannelName;
  //   List<String> list = [
  //     currentUserNo.substring(0, 5),
  //     recieverChatId.substring(0, 5)
  //   ];
  //   list.sort();
  //   _multiChannelName = '${list[0]}-${list[1]}';
  //   // int state;
  //   var status;

  //   var docs = await vDatabase.collection('chats').doc(_multiChannelName).get();
  //   // doc.then((docs) {
  //   //   if (docs != null) {
  //   //     map['online'] = docs.data()[recieverChatId];
  //   //   }
  //   //   status = map['online'];
  //   //   cprint('acces $status set');

  //   // });
  //   status = docs.data()['chatOnlineChatStatus'];
  //   cprint('$status');
  //   return status;
  // }

  Stream<ChatOnlineStatus> onlineOfflineChatStatus(
      String? currentUserNo, String? recieverChatId) {
    String _multiChannelName;
    List<String> list = [
      currentUserNo!.substring(0, 5),
      recieverChatId!.substring(0, 5)
    ];
    list.sort();
    _multiChannelName = '${list[0]}-${list[1]}';
    return kDatabase
        .child('chats/$_multiChannelName/chatUsersOnlineStatus/$currentUserNo')
        // .orderByChild('uid')
        // .equalTo(currentUserNo)
        .onValue
        .map((event) {
      if (event.snapshot.value == null) {
        return ChatOnlineStatus.fromJson({});
      }
      return ChatOnlineStatus.fromJson(event.snapshot.value as Map);
    });
    // CollectionReference reference = vDatabase.collection('chats');
    // reference
    //     .doc(_multiChannelName)
    //     .collection('chatUsersOnlineStatus')
    //     .where('uid', isEqualTo: recieverChatId)
    //     .snapshots()
    //     .listen((snap) {
    //   for (var snapshot in snap.docChanges) {
    //     onlineStatus.value = ChatOnlineStatus();
    //     if (snapshot.type == DocumentChangeType.added) {
    //       var model = (ChatOnlineStatus.fromJson(snapshot.doc.data()!));
    //       model.uid = snapshot.doc.id;
    //       onlineStatus.value = model;
    //       update();
    //     } else if (snapshot.type == DocumentChangeType.modified) {
    //       var model = ChatOnlineStatus.fromJson(snapshot.doc.data()!);
    //       model.uid = snapshot.doc.id;
    //       onlineStatus.value = model;

    //       update();
    //     }
    //   }
    // });
  }

  Stream<ChatOnlineStatus> userChatStatus(
      String? currentUserNo, String? recieverChatId) {
    String _multiChannelName;
    List<String> list = [
      currentUserNo!.substring(0, 5),
      recieverChatId!.substring(0, 5)
    ];
    list.sort();
    _multiChannelName = '${list[0]}-${list[1]}';
    return kDatabase
        .child('chats/$_multiChannelName/chatUsersOnlineStatus/$currentUserNo')
        // .orderByChild('chatOnlineChatStatus')
        // .equalTo(recieverChatId)
        .onValue
        .map((event) {
      if (event.snapshot.value == null) {
        return ChatOnlineStatus.fromJson({});
      }
      return ChatOnlineStatus.fromJson(event.snapshot.value as Map);
    });
    // CollectionReference reference = vDatabase.collection('chats');
    // reference
    //     .doc(_multiChannelName)
    //     .collection('chatUsersOnlineStatus')
    //     .where('uid', isEqualTo: recieverChatId)
    //     .snapshots()
    //     .listen((snap) {
    //   for (var snapshot in snap.docChanges) {
    //     onlineStatus.value = ChatOnlineStatus();
    //     if (snapshot.type == DocumentChangeType.added) {
    //       var model = (ChatOnlineStatus.fromJson(snapshot.doc.data()!));
    //       model.uid = snapshot.doc.id;
    //       onlineStatus.value = model;
    //       update();
    //     } else if (snapshot.type == DocumentChangeType.modified) {
    //       var model = ChatOnlineStatus.fromJson(snapshot.doc.data()!);
    //       model.uid = snapshot.doc.id;
    //       onlineStatus.value = model;

    //       update();
    //     }
    //   }
    // });
  }

  Future<RxInt> unreadChatMSGCount(
      String? currentUserNo, String? recieverChatId,
      {String? time}) async {
    String _multiChannelName;
    List<String> list = [
      currentUserNo!.substring(0, 5),
      recieverChatId!.substring(0, 5)
    ];
    list.sort();
    _multiChannelName = '${list[0]}-${list[1]}';

    var snap = kDatabase
        .child('chats/$_multiChannelName/messages')
        .endBefore(time)
        .onValue
        .map((event) => event.snapshot.children
            .map((e) => ChatMessage.fromJson(e.value as Map))
            .toList());
    msgCount.value = await snap.length;
    cprint(msgCount.value.toString());
    // CollectionReference reference = vDatabase.collection('chats');
    // reference
    //     .doc(_multiChannelName)
    //     .collection('chatUsersOnlineStatus')
    //     .snapshots()
    // kDatabase
    //     .child('chats/$_multiChannelName/chatUsersOnlineStatus')
    //     .endBefore(time)
    //     .onValue
    //     .listen((snap) {
    //   msgCount.value = snap.snapshot.children.length;
    //   cprint('$msgCount Unread message');
    // for (var snapshot in snap.docs) {
    //   if (snapshot.data()['timeStamp'] != null) {
    //     //   int? time = snapshot.data()['timeStamp'];
    //     CollectionReference count = vDatabase.collection('chats');
    //     count
    //         .doc(_multiChannelName)
    //         .collection('messages')
    //         // .where('timeStamp', isGreaterThan: time)
    //         .where('seen', isEqualTo: false)
    //         .snapshots()
    //         .listen((cnt) {
    //       msgCount.value = cnt.docs.length;
    //       cprint('$msgCount Unread message');
    //     });
    //   }
    //   // if (snapshot.type == DocumentChangeType.added) {
    //   //   var model = ChatOnlineStatus.fromJson(snapshot.doc.data());

    //   //   model.uid = snapshot.doc.id;
    //   //   onlineStatus = model;
    //   //    update();
    //   // } else if (snapshot.type == DocumentChangeType.modified) {
    //   //   var model = ChatOnlineStatus.fromJson(snapshot.doc.data());
    //   //   model.uid = snapshot.doc.id;
    //   //   onlineStatus = model;
    //   //    update();
    //   // }
    // }
    //  });
    return msgCount;
  }

  hideChat(currentUserNo, recieverChatId) {
    vDatabase.collection(USERS).doc(currentUserNo).set({
      HIDDEN: FieldValue.arrayUnion([recieverChatId])
    }, SetOptions(merge: true));
    ViewDucts.toast('Chat hidden.');
  }

  unhideChat(currentUserNo, recieverChatId) {
    vDatabase.collection(USERS).doc(currentUserNo).set({
      HIDDEN: FieldValue.arrayRemove([recieverChatId])
    }, SetOptions(merge: true));
    ViewDucts.toast('Chat is visible.');
  }

  lockChat(currentUserNo, recieverChatId) {
    vDatabase.collection(USERS).doc(currentUserNo).set({
      LOCKED: FieldValue.arrayUnion([recieverChatId])
    }, SetOptions(merge: true));
    ViewDucts.toast('Chat locked.');
  }

  unlockChat(currentUserNo, recieverChatId) {
    vDatabase.collection(USERS).doc(currentUserNo).set({
      LOCKED: FieldValue.arrayRemove([recieverChatId])
    }, SetOptions(merge: true));
    ViewDucts.toast('Chat unlocked.');
  }

  justSettingLastSeen(
    String currentUserNo,
  ) async {
    await FirebaseFirestore.instance
        .collection('profile')
        .doc(currentUserNo)
        .set({'lastSeen': DateTime.now().millisecondsSinceEpoch},
            SetOptions(merge: true));
  }

  lastSeen(
    String? recieverChatId,
    String currentUserNo,
  ) async {
    await FirebaseFirestore.instance
        .collection('profile')
        .doc(currentUserNo)
        .set({'lastSeen': recieverChatId}, SetOptions(merge: true));
  }

  lastSeen2(
    String? recieverChatId,
    String currentUserNo,
  ) async {
    await FirebaseFirestore.instance
        .collection('profile')
        .doc(currentUserNo)
        .set({'lastSeen': true}, SetOptions(merge: true));
  }

  setLastSeen(String currentUser, String secondUser, {String? status}) async {
    final database = Databases(
      clientConnect(),
    );
    String timestamps = DateTime.now().toUtc().toString();
    final id =
        '${currentUser.splitByLength((currentUser.length) ~/ 2)[0]}_${secondUser.splitByLength((secondUser.length) ~/ 2)[0]}';
    await database.listDocuments(
        databaseId: databaseId,
        collectionId: chatActiveColl,
        queries: [query.Query.equal('ids', id.toString())]).then((data) async {
      if (data.documents.isNotEmpty) {
        await database.updateDocument(
          databaseId: databaseId,
          collectionId: chatActiveColl,
          documentId: id,
          data: {
            'chatOnlineChatStatus': timestamps,
            'ids': id,
            'uid': currentUser,
            'seenChat': timestamps,
            'lastSeen':
                DateTime.now().toUtc().millisecondsSinceEpoch.toString(),
            // 'userSeen': timestamps,
            'chatStatus': status,
          },
        );
      } else {
        await database.createDocument(
          databaseId: databaseId,
          collectionId: chatActiveColl,
          documentId: id,
          data: {
            'chatOnlineChatStatus': timestamps,
            'ids': id,
            'uid': currentUser,
            'seenChat': timestamps,
            'lastSeen':
                DateTime.now().toUtc().millisecondsSinceEpoch.toString(),
            // 'userSeen': timestamps,
            'chatStatus': status,
          },
        );
      }
    });
  }

  setIsActive(String currentUserNo, String? recieverChatId) async {
    String _multiChannelName;
    List<String> list = [
      currentUserNo.substring(0, 5),
      recieverChatId!.substring(0, 5)
    ];
    list.sort();
    _multiChannelName = '${list[0]}-${list[1]}';
    kDatabase
        .child('chats/$_multiChannelName/chatUsersOnlineStatus/$currentUserNo')
        .update(
      {
        'chatOnlineChatStatus': true,
        'uid': recieverChatId,
      },
    );
    // await vDatabase
    //     .collection('chats')
    //     .doc(_multiChannelName)
    //     .collection('chatUsersOnlineStatus')
    //     .doc(currentUserNo)
    //     .set(
    //   {
    //     'chatOnlineChatStatus': true,
    //     'uid': currentUserNo,
    //   },
    // );
  }

  // onLine(String? currentUserNo) async {
  //   await vDatabase
  //       .collection('profile')
  //       .doc(currentUserNo)
  //       .set({'lastSeen': true}, SetOptions(merge: true));
  // }

  Stream<MessageData> getUnread(
    ViewductsUser user,
  ) {
    var controller = StreamController<MessageData>.broadcast();
    // unreadSubscriptions.add(vDatabase
    //     .collection('chats')
    //     .doc(_channelName)
    //     .snapshots()
    //     .listen((doc) {
    //   if (doc.data()![currentUserNo!] != null &&
    //       doc.data()![currentUserNo] is int) {
    //     unreadSubscriptions.add(vDatabase
    //         .collection('chats')
    //         .doc(_channelName)
    //         .collection(_channelName!)
    //         .snapshots()
    //         .listen((snapshot) {
    //       controller.add(MessageData(
    //           snapshot: snapshot, lastSeen: doc.data()![currentUserNo]));
    //     }));
    //   }
    // }));
    // controllers.add(controller);
    return controller.stream;
  }

  dynamic encryptWithCRC(
    String input,
  ) {
    try {
      String encrypted = cryptor.encrypt(input, iv: iv).base64;
      int crc = CRC32.compute(input);
      return '$encrypted$CRC_SEPARATOR$crc';
    } catch (e) {
      ViewDucts.toast('Waiting for your peer to join the chat.');
      return false;
    }
  }

  String decryptWithCRC(
    String input,
  ) {
    try {
      if (input.contains(CRC_SEPARATOR)) {
        int idx = input.lastIndexOf(CRC_SEPARATOR);
        String msgPart = input.substring(0, idx);
        String crcPart = input.substring(idx + 1);
        int? crc = int.tryParse(crcPart);
        if (crc != null) {
          msgPart =
              cryptor.decrypt(encrypt.Encrypted.fromBase64(msgPart), iv: iv);
          if (CRC32.compute(msgPart) == crc) return msgPart;
        }
      }
    } on FormatException {
      return '';
    }
    return '';
  }

  // static void authenticate(DataModel model, String caption,
  //     {@required NavigatorState state,
  //     AuthenticationType type = AuthenticationType.passcode,
  //     @required SharedPreferences prefs,
  //     @required Function onSuccess,
  //     @required bool shouldPop}) {
  //   Map<String, dynamic> user = model.currentUser;
  //   if (user != null && model != null) {
  //     state.push(MaterialPageRoute<bool>(
  //         builder: (context) => Authenticate(
  //             shouldPop: shouldPop,
  //             caption: caption,
  //             type: type,
  //             model: model,
  //             state: state,
  //             answer: user[ANSWER],
  //             passcode: user[PASSCODE],
  //             question: user[QUESTION],
  //             phoneNo: user[PHONE],
  //             prefs: prefs,
  //             onSuccess: onSuccess)));
  //   }
  // }
  String? getChannelName(String user1, String user2) {
    user1 = user1.substring(0, 5);
    user2 = user2.substring(0, 5);
    List<String> list = [user1, user2];
    list.sort();
    _channelName = '${list[0]}-${list[1]}';
    // cprint(_channelName); //2RhfE-5kyFB
    return _channelName;
  }

  @override
  void dispose() {
    var user =
        _chatUserList!.value.firstWhere((x) => x.key == chatUser!.userId);
    if (messageListing != null) {
      user.message = messageListing!.value.first.message;
      user.createdAt = messageListing!.value.first.createdAt; //;

      messageListing = null;
      // setIsActive(authstate.userId);
      // deleteUptoSubscription(mounted);
      // seenSubscription(seenState, mounted, chatUser.userId, chatUser.lastSeen);

      // setLastSeen(authstate.userModel.chatStatus, authstate.userModel.userId);
      update();
    } else {}

    /// [Warning] do not call super.dispose() from this method
    /// If this method called here it will dipose chat state data
    // super.dispose();
  }

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  void sendAndRetrieveMessage(ChatMessage model, {ViewductsUser? user}) async {
    /// on notification
    await firebaseMessaging.requestPermission(
        sound: true, badge: true, alert: true, provisional: false);
    if (chatUser!.fcmToken == null) {
      return;
    }
    var body = jsonEncode(<String, dynamic>{
      'notification': <String, dynamic>{
        'body': TextEncryptDecrypt.decryptAES(model.message),
        'title': "${model.senderName}"
      },
      'priority': 'high',
      'data': <String, dynamic>{
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done',
        "type": NotificationType.Message.toString(),
        "senderId": model.senderId,
        "receiverId": model.receiverId,
        "chatlistKey": model.chatlistKey,
        "senderPicture": authState.userModel!.profilePic,
        "title": "${model.senderName}",
        "body": TextEncryptDecrypt.decryptAES(model.message),
        "messageType": "chat"
      },
      'to': chatUserModel.value.fcmToken
    });
    var response =
        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'key=$serverToken',
            },
            body: body);
    if (kDebugMode) {
      print(response.body.toString());
    }
  }

  void sendAndRetrieveMessageReaction(ChatMessage model,
      {ViewductsUser? user}) async {
    /// on notification
    await firebaseMessaging.requestPermission(
        sound: true, badge: true, alert: true, provisional: false);
    if (chatUser!.fcmToken == null) {
      return;
    }
    var body = jsonEncode(<String, dynamic>{
      'notification': <String, dynamic>{
        'body': authState.appUser?.$id == model.userId
            ? '${authState.userModel!.displayName} reacted to a message'
            : '${authState.userModel!.displayName} reacted to your message',
        'title': "${authState.userModel!.displayName}"
      },
      'priority': 'high',
      'data': <String, dynamic>{
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done',
        'senderReactions': "${model.senderReactions}",
        ' receiverReactions': "${model.receiverReactions}",
        "type": NotificationType.Message.toString(),
        "senderId": model.senderId,
        "receiverId": model.receiverId,
        "senderPicture": authState.userModel!.profilePic,
        "chatlistKey": model.chatlistKey,
        "title": "${model.senderName}",
        "body": '${model.senderName} reacted to your message',
        "messageType": "chat"
      },
      'to': chatUserModel.value.fcmToken
    });
    var response =
        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'key=$serverToken',
            },
            body: body);
    if (kDebugMode) {
      print(response.body.toString());
    }
  }

  void boughtItemMessageNotification(ViewductsUser model) async {
    /// on notification
    await firebaseMessaging.requestPermission(
        sound: true, badge: true, alert: true, provisional: false);
    if (model.fcmToken == null) {
      return;
    }
    var body = jsonEncode(<String, dynamic>{
      'notification': <String, dynamic>{
        'body': 'i just order some products from you',
        'title': "${authState.userModel!.displayName}"
      },
      'priority': 'high',
      'data': <String, dynamic>{
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done',
        "type": NotificationType.Message.toString(),
        "senderId": authState.userModel!.key,
        "receiverId": model.key,
        "title": "title",
        "body": 'i just order some products from you',
        "messageType": "order"
      },
      'to': model.fcmToken
    });
    var response =
        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'key=$serverToken',
            },
            body: body);

    if (kDebugMode) {
      print(response.body.toString());
    }
    userCartController.staff.value.forEach((staffData) async {
      await firebaseMessaging.requestPermission(
          sound: true, badge: true, alert: true, provisional: false);
      if (staffData.fcm == null) {
        return;
      }
      var body = jsonEncode(<String, dynamic>{
        'notification': <String, dynamic>{
          'body': 'i just order some products from you',
          'title': "${authState.userModel!.displayName}"
        },
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done',
          "type": NotificationType.Message.toString(),
          "senderId": authState.userModel!.key,
          "receiverId": staffData.id,
          "title": "title",
          "body": 'i just order some products from you',
          "messageType": "order"
        },
        'to': staffData.fcm
      });
      var response =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization': 'key=$serverToken',
              },
              body: body);
      if (kDebugMode) {
        print(response.body.toString());
      }
    });
  }

  void confirmedOrderStateNotification(
      {ViewductsUser? model, String? orderState, String? orderId}) async {
    /// on notification
    await firebaseMessaging.requestPermission(
        sound: true, badge: true, alert: true, provisional: false);
    if (model?.fcmToken == null) {
      return;
    }
    var body = jsonEncode(<String, dynamic>{
      'notification': <String, dynamic>{
        'body': 'Your Order $orderId is been $orderState',
        'title': "Order"
      },
      'priority': 'high',
      'data': <String, dynamic>{
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done',
        "type": NotificationType.Message.toString(),
        "senderId": authState.userModel!.key,
        "receiverId": model!.key,
        "title": "title",
        "body": 'i just order some products from you',
        "messageType": "order"
      },
      'to': model.fcmToken
    });
    var response =
        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'key=$serverToken',
            },
            body: body);

    if (kDebugMode) {
      print(response.body.toString());
    }
  }

  Map<String?, Map<String, dynamic>?> userData =
      <String?, Map<String, dynamic>?>{};

  final Map<String, Future> _messageStatus = <String, Future>{};

  _getMessageKey(String? recieverChatId, dynamic timestamp) =>
      '$recieverChatId$timestamp';

  getMessageStatus(String? recieverChatId, dynamic timestamp) {
    final key = _getMessageKey(recieverChatId, timestamp);
    return _messageStatus[key] ?? true;
  }

  final bool _loaded = false;

  final LocalStorage _storage = LocalStorage('model');

  addMessage(String recieverChatId, int timestamp, Future future) {
    final key = _getMessageKey(recieverChatId, timestamp);
    future.then((_) {
      _messageStatus.remove(key);
    });
    _messageStatus[key] = future;
  }

  addUser(DocumentSnapshot user) {
    userData[user[PHONE]] = user.data() as Map<String, dynamic>?;
    update();
  }

  getWhen(date) {
    DateTime now = DateTime.now();
    String when;
    if (date.day == now.day) {
      when = 'today';
    } else if (date.day == now.subtract(const Duration(days: 1)).day) {
      when = 'yesterday';
    } else {
      when = DateFormat.MMMd().format(date);
    }
    return when;
  }

  getPeerStatus(val, String currentUserNo) {
    if (val is bool && val == true) {
      return '';
    } else if (val is int) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(val);
      String at = DateFormat.jm().format(date), when = getWhen(date);
      return 'last seen $when at $at';
    } else if (val is String) {
      if (val == currentUserNo) return 'typing…';
      return 'online';
    }
    return 'loading…';
  }

  setWallpaper(String? phone, File image) async {
    final dir = await getDir();
    int now = DateTime.now().millisecondsSinceEpoch;
    String path = '${dir.path}/WALLPAPER-$phone-$now';
    await image.copy(path);
    userData[phone]![WALLPAPER] = path;
    updateItem(phone!, {WALLPAPER: path});
    update();
  }

  removeWallpaper(String phone) {
    userData[phone]![WALLPAPER] = null;
    String? path = userData[phone]![ALIAS_AVATAR];
    if (path != null) {
      File(path).delete();
      userData[phone]![WALLPAPER] = null;
    }
    updateItem(phone, {WALLPAPER: null});
    update();
  }

  getDir() async {
    return await getApplicationDocumentsDirectory();
  }

  updateItem(String key, Map<String, dynamic> value) {
    Map<String, dynamic> old = _storage.getItem(key) ?? <String, dynamic>{};
    old.addAll(value);
    _storage.setItem(key, old);
  }

  setAlias(String aliasName, File image, String phone) async {
    userData[phone]![ALIAS_NAME] = aliasName;
    final dir = await getDir();
    int now = DateTime.now().millisecondsSinceEpoch;
    String path = '${dir.path}/$phone-$now';
    await image.copy(path);
    userData[phone]![ALIAS_AVATAR] = path;
    updateItem(phone, {
      ALIAS_NAME: userData[phone]![ALIAS_NAME],
      ALIAS_AVATAR: userData[phone]![ALIAS_AVATAR],
    });
    update();
  }

  removeAlias(String phone) {
    userData[phone]![ALIAS_NAME] = null;
    String? path = userData[phone]![ALIAS_AVATAR];
    if (path != null) {
      File(path).delete();
      userData[phone]![ALIAS_AVATAR] = null;
    }
    updateItem(phone, {ALIAS_NAME: null, ALIAS_AVATAR: null});
    update();
  }

  deleteUpto(int upto) {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(_channelName)
        .collection(_channelName!)
        .where(TIMESTAMP, isLessThanOrEqualTo: upto)
        .get()
        .then((query) {
      for (var msg in query.docs) {
        if (msg.data()[TYPE] == MessageType.image.index) {
          FirebaseStorage.instance
              .ref()
              .child(getImageFileName(msg.data()[FROM], msg.data()[TIMESTAMP]))
              .delete();
        }
        msg.reference.delete();
      }
    });

    FirebaseFirestore.instance
        .collection('chats')
        .doc(_channelName)
        .set({DELETE_UPTO: upto}, SetOptions(merge: true));
    deleteMessagesUpto(upto);
    empty = true;
  }

  deleteMessages(
    Map<String, dynamic> doc,
  ) {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(_channelName)
        .collection(_channelName!)
        .doc('${doc[TIMESTAMP]}')
        .delete();
  }

  getImageFileName(id, timestamp) {
    return "$id-$timestamp";
  }

  deleteMessagesUpto(int upto) {
    int before = messageList!.length;

    messageListing!.value =
        List.from(messageList!.where((msg) => msg.timeStamp! > upto));
    if (messageList!.length < before) ViewDucts.toast('Conversation Ended!');
  }

  updateLocalUserData(
    dynamic model,
    Map<String, dynamic>? peer,
    bool locked,
    bool hidden,
    int? chatStatus,
    String? peerAvatar,
    String recieverChatId,
    var currentUser,
  ) {
    peer = model.userData[recieverChatId];
    // currentUser = _cachedModel.currentUser;
    if (currentUser != null && peer != null) {
      hidden = currentUser[HIDDEN] != null &&
          currentUser[HIDDEN].contains(recieverChatId);
      locked = currentUser[LOCKED] != null &&
          currentUser[LOCKED].contains(recieverChatId);
      chatStatus = peer[CHAT_STATUS];
      peerAvatar = peer[PHOTO_URL];
    }
  }

  seenSubscription(SeenState seenState, bool mounted, String recieverChatId,
      dynamic lastSeen) {
    vDatabase.collection('chats').doc(_channelName).snapshots().listen((doc) {
      if (mounted) {
        seenState.value = doc.data()![recieverChatId] ?? false;
        if (seenState.value is String) {
          // prefs.setInt(getLastSeenKey(recieverChatId, lastSeen), seenState.value);
        }
      }
    });
  }

  deleteUptoSubscription(bool mounted) {
    vDatabase.collection('chats').doc(_channelName).snapshots().listen((doc) {
      if (mounted) {
//deleteMessagesUpto(doc.data()[DELETE_UPTO]);
      }
    });
  }

  String getLastSeenKey(String? recieverChatId, String? lastSeen) {
    return "$recieverChatId-$lastSeen";
  }

  bool get loaded => _loaded;

  Map<String, dynamic>? get currentUser => _currentUser;

  Map<String, dynamic>? _currentUser;

  Map<String, int> get lastSpokenAt => _lastSpokenAt;

  final Map<String, int> _lastSpokenAt = {};

  // getChatOrder(List<String> chatsWith, String currentUserNo) {
  //   List<Stream<QuerySnapshot>> messages = List<Stream<QuerySnapshot>>();
  //   chatsWith.forEach((otherNo) {
  //     String chatId = ViewDucts.getChatId(currentUserNo, otherNo);
  //     messages.add(Firestore.instance
  //         .collection(MESSAGES)
  //         .document(chatId)
  //         .collection(chatId)
  //         .snapshots());
  //   });
  //   StreamGroup.merge(messages).listen((snapshot) {
  //     if (snapshot.documents.isNotEmpty) {
  //       DocumentSnapshot message = snapshot.documents.last;
  //       _lastSpokenAt[message.data()[FROM] == currentUserNo
  //           ? message.data()[TO]
  //           : message.data()[FROM]] = message.data()[TIMESTAMP];
  //        update();
  //     }
  //   });
  // }

  // DataModel(String currentUserNo) {
  //   Firestore.instance
  //       .collection(USERS)
  //       .document(currentUserNo)
  //       .snapshots()
  //       .listen((user) {
  //     _currentUser = user.data();
  //      update();
  //   });
  //   _storage.ready.then((ready) {
  //     if (ready) {
  //       Firestore.instance
  //           .collection(USERS)
  //           .document(currentUserNo)
  //           .collection(CHATS_WITH)
  //           .document(CHATS_WITH)
  //           .snapshots()
  //           .listen((_chatsWith) {
  //         if (_chatsWith?.data != null) {
  //           List<Stream<DocumentSnapshot>> users =
  //               new List<Stream<DocumentSnapshot>>();
  //           List<String> peers = [];
  //           _chatsWith.data().entries.forEach((_data) {
  //             peers.add(_data.key);
  //             users.add(Firestore.instance
  //                 .collection(USERS)
  //                 .document(_data.key)
  //                 .snapshots());
  //             if (userData[_data.key] != null) {
  //               userData[_data.key][CHAT_STATUS] = _chatsWith.data()[_data.key];
  //             }
  //           });
  //           getChatOrder(peers, currentUserNo);
  //            update();
  //           Map<String, Map<String, dynamic>> newData =
  //               Map<String, Map<String, dynamic>>();
  //           StreamGroup.merge(users).listen((user) {
  //             if (user.data() != null) {
  //               newData[user.data()[PHONE]] = user.data();
  //               newData[user.data()[PHONE]][CHAT_STATUS] =
  //                   _chatsWith.data()[user.data()[PHONE]];
  //               Map<String, dynamic> _stored =
  //                   _storage.getItem(user.data()[PHONE]);
  //               if (_stored != null) {
  //                 newData[user.data()[PHONE]].addAll(_stored);
  //               }
  //             }
  //             userData = Map.from(newData);
  //              update();
  //           });
  //         }
  //         if (!_loaded) {
  //           _loaded = true;
  //            update();
  //         }
  //       });
  //     }
  //   });
  // }

}

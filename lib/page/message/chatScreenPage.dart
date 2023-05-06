// ignore_for_file: invalid_use_of_protected_member, unnecessary_statements, file_names, unused_element, invalid_use_of_visible_for_testing_member, must_be_immutable, prefer_typing_uninitialized_variables, unnecessary_null_comparison
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter_aws_s3_client/flutter_aws_s3_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:minio/io.dart';
import 'package:minio/minio.dart';
import 'package:path/path.dart' as path;
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:ui';
import 'package:permission_handler/permission_handler.dart' as camera;
import 'package:appwrite/appwrite.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart' as permi;
import 'package:uuid/uuid.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
//import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:viewducts/admin/screens/video_admin_upload.dart';
import 'package:viewducts/apis/chat_api.dart';
import 'package:viewducts/common/common.dart';
import 'package:viewducts/constants/constants.dart';
import 'package:viewducts/features/auth/controller/auth_controller.dart';
import 'package:viewducts/features/chats/chat_controller.dart';
import 'package:viewducts/features/products/product_controller.dart';
import 'package:viewducts/helper/constant.dart';
import 'package:viewducts/model/chatModel.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:viewducts/page/feed/composeTweet/widget/composeTweetImage.dart';
import 'package:viewducts/page/message/local_database.dart';
import 'package:viewducts/page/product/shopingCart.dart';
import 'package:viewducts/page/profile/see_provider.dart';
//import 'package:emoji_picker/emoji_picker.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

//import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
//import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:viewducts/E2EE/crc.dart';
import 'package:viewducts/encryption/encryption.dart';
import 'package:viewducts/helper/enum.dart';
import 'package:viewducts/helper/save.dart';
import 'package:viewducts/helper/theme.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/page/message/item_Search_bar.dart';
import 'package:viewducts/page/product/market.dart';
import 'package:viewducts/page/profile/bubble.dart';
import 'package:viewducts/page/responsive.dart';
import 'package:viewducts/page/responsiveView.dart';
// import 'package:viewducts/state/chats/chatState.dart';
// import 'package:viewducts/state/feedState.dart';
// import 'package:viewducts/state/seen_state.dart';
//import 'package:viewducts/state/stateController.dart';

import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/frosted.dart';
import 'package:viewducts/widgets/newWidget/customUrlText.dart';
import 'package:viewducts/widgets/newWidget/rippleButton.dart';
import 'package:collection/collection.dart';
import 'package:viewducts/widgets/newWidget/title_text.dart';

import '../../widgets/duct/ductStoryPage.dart';
import '../../widgets/duct/profile_orders.dart';

extension SplitString on String {
  List<String> splitByLengths(int length) =>
      [substring(0, length), substring(length)];
}

class ChatScreenPage extends ConsumerStatefulWidget {
  ChatScreenPage(
      {Key? key,
      this.keyId,
      this.chatIdUsers,
      this.userProfileId,
      this.dependency = true,
      this.productId,
      this.isVductProduct = false,
      this.isDesktop = false,
      this.isTablet = false})
      : super(key: key);
  final bool isVductProduct;
  final String? chatIdUsers;
  bool? dependency;
  final String? userProfileId;
  bool isDesktop;
  final bool isTablet;
  String? productId;
  final String? keyId;

  @override
  ConsumerState<ChatScreenPage> createState() => _ChatScreenPageState();
}

class _ChatScreenPageState extends ConsumerState<ChatScreenPage> {
//   @override
  final messageController = TextEditingController();

  // String senderId;
  String? userImage;

  bool? isContinuing;

  FocusNode textFieldFocus = FocusNode();

  FocusNode imageTextFieldFocus = FocusNode();

  // ChatState chatState = ChatState();
  // SeenState? seenState;

  ValueNotifier<bool> isSelected = ValueNotifier(false);

  String? ductId, chatUserProductId;

  GlobalKey<ScaffoldState>? _scaffoldKey;

  String? peerAvatar, peerNo, currentUserNo, privateKey, sharedSecret;

  var locked = false.obs;

  var hidden = false.obs;

//ViewductsUser peer, authState.userModel;
  int? unread;

  GlobalKey? actionKey;

  var isDropdown = false.obs;

  double? height, width, xPosiion, yPosition;

  late OverlayEntry floatingMenu;

  dynamic lastSeen;

  String? chatId;

  late SharedPreferences prefs;

  var isWriting = false.obs;

  var showEmojiPicker = false.obs;

  var typing = false.obs;

  File? imageFile;

  late bool isLoading;

  String? imageUrl;

  FeedModel? model;

  // List<Message> messages = new List<Message>();
  List<Map<String, dynamic>> _savedMessageDocs = <Map<String, dynamic>>[];

  Map<String, dynamic>? peer, currentUser;

  int? uploadTimestamp;

  final TextEditingController textEditingController = TextEditingController();

  final TextEditingController imageTextEditingController =
      TextEditingController();

  ViewductsUser? viewductsUser;

  final ScrollController realtime = ScrollController();

  final ScrollController saved = ScrollController();

  List<Message> messages = [];

  dynamic timestamp;

  encrypt.Encrypter? cryptor;

  final iv = encrypt.IV.fromLength(8);

  var models;

  var lastseen;

  int? statusInit;

  var chattersId;

  var currentUserlastSeen;

  //var onlineStatus;
  Color? wordCountColor;
  final loading = (false.obs);
  // @override
  RxBool seenMessagesState = false.obs;
  File? audioFile, videoFile, _thumbnail, imageFileState;
  final myOrders = (''.obs);

  String mediaType = '';

  String? lastId;
  File? savedFile;
  final audioPlayer = AudioPlayer();
  final _controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    final secondUser =
        ref.watch(userDetailsProvider(widget.userProfileId!.toString())).value;
    double heightFactor = 300 / Get.height;
    // final chatSetState = (chatState.chatMessage);

    // subscribe({String? pageIndex}) async {
    //   // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   try {
    //    // chatSetState.value.value = await chatState.chatMessage.value;
    //     await serverApi.createConversation(
    //         '${currentUser.userId!}', widget.userProfileId.toString());

    //     cprint('${feedState.dataBaseChatsId} chatId online');

    //     final database = Databases(
    //       clientConnect(),
    //     );

    //     if (pageIndex == 'bottom') {
    //       await database.listDocuments(
    //           databaseId: chatDatabase,
    //           collectionId: "feedState.dataBaseChatsId!.value".toString(),
    //           // '${curruserId.splitByLengths((curruserId.length) ~/ 2)[0]}_${otheruserId.splitByLengths((otheruserId.length) ~/ 2)[0]}',
    //           queries: [
    //             Query.orderDesc('createdAt'),
    //             //Query.equal('seen', 'false'),
    //             Query.equal('fileDownloaded', 'new'),
    //             // Query.equal('senderId', userProfileId.toString()
    //             // chatSetState.value.value
    //             //     .map((data) => data.key.toString())
    //             //     .toList()

    //             //   ),
    //             // Query.equal('senderId', otheruserId.toString()),
    //             Query.limit(10),
    //             // Query.cursorAfter(lastId.toString()),
    //           ]).then((data) async {
    //         if (data.documents.isNotEmpty) {
    //           var value = data.documents
    //               .map((e) => ChatMessage.fromJson(e.data))
    //               .toList();
    //           value.forEach((data) {
    //             if (chatSetState.value
    //                     .firstWhere((msg) => msg.key == data.key,
    //                         orElse: () => ChatMessage())
    //                     .key ==
    //                 data.key) {
    //               return;
    //             }
    //             SQLHelper.createLocalMessages(data);
    //           });
    //           chatSetState.value.value = await SQLHelper.findLocalMessages(
    //               widget.chatIdUsers == null
    //                   ? "feedState.dataBaseChatsId!.value"
    //                   : widget.chatIdUsers.toString());
    //           lastId = lastId = data.documents.last.$id;
    //           cprint('lastId is $lastId');
    //         } else {}
    //       }).onError((error, stackTrace) {
    //         cprint('$error pageIndex == bottom');
    //       });
    //     } else if (pageIndex == 'top') {
    //       await database.listDocuments(
    //           databaseId: chatDatabase,
    //           collectionId: "feedState.dataBaseChatsId!.value".toString(),
    //           // '${curruserId.splitByLengths((curruserId.length) ~/ 2)[0]}_${otheruserId.splitByLengths((otheruserId.length) ~/ 2)[0]}',
    //           queries: [
    //             Query.orderDesc('createdAt'),
    //             // Query.equal('seen', 'false'),
    //             Query.equal('fileDownloaded', 'new'),
    //             //Query.equal('senderId', userProfileId.toString()
    //             // chatSetState.value.value
    //             //     .map((data) => data.key.toString())
    //             //     .toList()

    //             //  ),
    //             // Query.equal('senderId', otheruserId.toString()),
    //             Query.limit(10),
    //             Query.cursorAfter(lastId.toString()),
    //           ]).then((data) async {
    //         if (data.documents.isNotEmpty) {
    //           var value = data.documents
    //               .map((e) => ChatMessage.fromJson(e.data))
    //               .toList();
    //           value.forEach((data) {
    //             if (chatSetState.value
    //                     .firstWhere((msg) => msg.key == data.key,
    //                         orElse: () => ChatMessage())
    //                     .key ==
    //                 data.key) {
    //               return;
    //             }
    //             SQLHelper.createLocalMessages(data);
    //           });
    //           chatSetState.value.value = await SQLHelper.findLocalMessages(
    //               widget.chatIdUsers == null
    //                   ? "feedState.dataBaseChatsId!.value"
    //                   : widget.chatIdUsers.toString());
    //           lastId = data.documents.last.$id;
    //           cprint('lastId is $lastId');
    //         } else {}
    //       }).onError((error, stackTrace) {
    //         cprint('$error pageIndex == top');
    //       });
    //     } else {
    //       await database.listDocuments(
    //           databaseId: chatDatabase,
    //           collectionId: "feedState.dataBaseChatsId!.value".toString(),
    //           //  '${curruserId.splitByLengths((curruserId.length) ~/ 2)[0]}_${otheruserId.splitByLengths((otheruserId.length) ~/ 2)[0]}',
    //           queries: [
    //             Query.orderDesc('createdAt'),
    //             // Query.equal('seen', 'false'),
    //             Query.equal('fileDownloaded', 'new'),
    //             // Query.equal('senderId', userProfileId.toString()
    //             // chatSetState.value.value
    //             //     .map((data) => data.key.toString())
    //             //     .toList()

    //             // ),
    //             // Query.equal('senderId', otheruserId.toString()),
    //             Query.limit(10),
    //           ]).then((data) async {
    //         if (data.documents.isNotEmpty) {
    //           var value = data.documents
    //               .map((e) => ChatMessage.fromJson(e.data))
    //               .toList();
    //           value.forEach((datas) async {
    //             // if (data.seen == 'deleted' &&
    //             //     data.userId == currentUser?.userId) {
    //             //   data.seen = 'deleted';
    //             //   return;
    //             // }
    //             if (datas.seen == 'deleted' &&
    //                 datas.userId == currentUser?.userId) {
    //               return;
    //             }
    //             // if (datas.seen == 'false' &&
    //             //     datas.userId == currentUser?.userId) {
    //             //   return;
    //             // }
    //             //else {
    //             cprint('${datas.seen} message online sent');

    //             return await SQLHelper.createLocalMessages(datas);
    //             //  }
    //           });
    //           chatSetState.value.value = await SQLHelper.findLocalMessages(
    //               widget.chatIdUsers == null
    //                   ? "feedState.dataBaseChatsId!.value"
    //                   : widget.chatIdUsers.toString());
    //           if (seenMessagesState.value == true) {
    //             chatSetState.value.forEach((data) async {
    //               if (data.senderId == authState.appUser!.$id) {
    //                 return;
    //               }
    //               if (data.seen == 'true') {
    //                 await database.updateDocument(
    //                   databaseId: chatDatabase,
    //                   collectionId: data.chatlistKey.toString(),
    //                   documentId: data.key.toString(),
    //                   data: {"seen": 'true', "fileDownloaded": "recieved"},
    //                 );
    //               } else if (data.seen == 'deleted' &&
    //                   data.userId != currentUser?.userId) {
    //                 await database.updateDocument(
    //                   databaseId: chatDatabase,
    //                   collectionId: data.chatlistKey.toString(),
    //                   documentId: data.key.toString(),
    //                   data: {"seen": 'deleted', "fileDownloaded": "recieved"},
    //                 );
    //                 seenMessagesState.value = false;
    //               } else if (data.seen == 'deleted' &&
    //                   data.userId == currentUser?.userId) {
    //                 await SQLHelper.deletLocalMessage(data);
    //               } else if (data.fileDownloaded != 'recieved') {
    //                 await database.updateDocument(
    //                   databaseId: chatDatabase,
    //                   collectionId: data.chatlistKey.toString(),
    //                   documentId: data.key.toString(),
    //                   data: {"seen": 'true', "fileDownloaded": "new"},
    //                 );
    //                 // .catchError((error) {
    //                 //   cprint(error.message,
    //                 //       errorIn: 'data.fileDownloaded != recieved');
    //                 //   return false;
    //                 // });
    //                 await SQLHelper.updateLocalMessageSeen(data, seen: 'true');
    //                 chatSetState.value.value =
    //                     await SQLHelper.findLocalMessages(
    //                         widget.chatIdUsers == null
    //                             ? "feedState.dataBaseChatsId!.value"
    //                             : widget.chatIdUsers.toString());
    //                 seenMessagesState.value = false;
    //               }
    //               //  else if (data.seen == 'deleted' &&
    //               //     data.userId != currentUser?.userId) {
    //               //   await SQLHelper.deletLocalMessage(data);
    //               //   chatSetState.value.value =
    //               //       await SQLHelper.findLocalMessages(chatIdUsers == null
    //               //           ? "feedState.dataBaseChatsId!.value"
    //               //           : chatIdUsers.toString());
    //               //   await database.deleteDocument(
    //               //       databaseId: chatDatabase,
    //               //       collectionId: data.chatlistKey.toString(),
    //               //       documentId: data.key.toString());

    //               //   seenMessagesState.value = false;
    //               // }
    //             });
    //             chatSetState.value.value = await SQLHelper.findLocalMessages(
    //                 widget.chatIdUsers == null
    //                     ? "feedState.dataBaseChatsId!.value"
    //                     : widget.chatIdUsers.toString());
    //             seenMessagesState.value = false;
    //           }
    //           lastId = data.documents.last.$id;
    //           cprint('lastId is $lastId');
    //         } else {}
    //       });
    //     }
    //     //  }

    //     await database
    //         .getDocument(
    //             databaseId: databaseId,
    //             collectionId: profileUserColl,
    //             documentId: widget.userProfileId.toString())
    //         .then((item) {
    //       chatState.chatUserModel.value = ViewductsUser.fromJson(item.data);
    //     });

    //     await chatState.getChatActiveness(
    //         'online', authState.appUser!.$id, widget.userProfileId.toString());
    //     await database
    //         .getDocument(
    //       databaseId: databaseId,
    //       collectionId: chatActiveColl,
    //       documentId:
    //           '${otheruserId.splitByLengths((otheruserId.length) ~/ 2)[0]}_${curruserId.splitByLengths((curruserId.length) ~/ 2)[0]}',
    //     )
    //         .then((item) {
    //       myNotificationBlockStatus.value.value =
    //           ChatOnlineStatus.fromJson(item.data);
    //       chatState.myonlineStatus = myNotificationBlockStatus.value;
    //     });
    //     await database
    //         .getDocument(
    //       databaseId: databaseId,
    //       collectionId: chatActiveColl,
    //       documentId:
    //           '${otheruserId.splitByLengths((otheruserId.length) ~/ 2)[0]}_${curruserId.splitByLengths((curruserId.length) ~/ 2)[0]}',
    //     )
    //         .then((item) {
    //       onlineStatusState.value.value = ChatOnlineStatus.fromJson(item.data);
    //     });

    //     // userCartController.listenToOrders(order: userCartController.orders);
    //     chatSetState.value.value.forEach((data) async {
    //       if (data.seen != 'sending') {
    //         return;
    //       }
    //       if (data.seen == 'deleted') {
    //         return;
    //       }
    //       if (data.seen == 'deleted for me') {
    //         return;
    //       }
    //       if (data.seen == 'sending') {
    //         data.seen = 'false';
    //         if (data.imagePath != null) {
    //           final keyImagePath =
    //               '${DateTime.now().toUtc().toString().replaceAll(RegExp(r'\.\d*Z$'), 'Z').replaceAll(RegExp(r'[:-]|\.\d{3}'), '').split(' ').join('T')}${path.extension(data.imagePath.toString())}';
    //           final minio = Minio(
    //               endPoint:
    //                   "userCartController.wasabiAws.value.endPoint.toString()",
    //               accessKey:
    //                   "userCartController.wasabiAws.value.accessKey.toString()",
    //               secretKey:
    //                   "userCartController.wasabiAws.value.secretKey.toString()",
    //               region: userCartController.wasabiAws.value.region.toString());

    //           await minio.fPutObject(
    //               userCartController.wasabiAws.value.buckedId.toString(),
    //               keyImagePath,
    //               data.imagePath.toString());
    //           await chatState.onMessageSubmitted(data,
    //               currentUser.userId!, widget.userProfileId!, data,
    //               notofication: chatState.myonlineStatus.value.notofication);
    //           await SQLHelper.createLocalMessages(data);
    //           chatSetState.value.value = await SQLHelper.findLocalMessages(
    //               data.chatlistKey.toString());
    //           cprint(' offline image sent');
    //         } else if (data.videoKey != null) {
    //           final keyvideoPath =
    //               '${DateTime.now().toUtc().toString().replaceAll(RegExp(r'\.\d*Z$'), 'Z').replaceAll(RegExp(r'[:-]|\.\d{3}'), '').split(' ').join('T')}${path.extension(data.videoKey.toString())}';
    //           final keyThumpnailPath =
    //               '${DateTime.now().toUtc().toString().replaceAll(RegExp(r'\.\d*Z$'), 'Z').replaceAll(RegExp(r'[:-]|\.\d{3}'), '').split(' ').join('T')}${path.extension(data.videoThumbnail.toString())}';

    //           final minio = Minio(
    //               endPoint:
    //                   "userCartController.wasabiAws.value.endPoint.toString()",
    //               accessKey:
    //                   "userCartController.wasabiAws.value.accessKey.toString()",
    //               secretKey:
    //                   "userCartController.wasabiAws.value.secretKey.toString()",
    //               region: userCartController.wasabiAws.value.region.toString());

    //           await minio.fPutObject(
    //               userCartController.wasabiAws.value.buckedId.toString(),
    //               keyvideoPath,
    //               data.videoKey.toString());
    //           await minio.fPutObject(
    //               userCartController.wasabiAws.value.buckedId.toString(),
    //               keyThumpnailPath,
    //               data.videoThumbnail.toString());
    //           await chatState.onMessageSubmitted(data,
    //               currentUser.userId!, widget.userProfileId!, data,
    //               notofication: chatState.myonlineStatus.value.notofication);
    //           await SQLHelper.createLocalMessages(data);
    //           chatSetState.value.value = await SQLHelper.findLocalMessages(
    //               data.chatlistKey.toString());
    //           cprint('offline video sent');
    //         } else if (data.audioFile != null) {
    //           final keyImagePath =
    //               '${DateTime.now().toUtc().toString().replaceAll(RegExp(r'\.\d*Z$'), 'Z').replaceAll(RegExp(r'[:-]|\.\d{3}'), '').split(' ').join('T')}${path.extension(data.audioFile!.toString())}';

    //           final minio = Minio(
    //               endPoint:
    //                   "userCartController.wasabiAws.value.endPoint.toString()",
    //               accessKey:
    //                   "userCartController.wasabiAws.value.accessKey.toString()",
    //               secretKey:
    //                   "userCartController.wasabiAws.value.secretKey.toString()",
    //               region: userCartController.wasabiAws.value.region.toString());

    //           await minio.fPutObject(
    //               userCartController.wasabiAws.value.buckedId.toString(),
    //               keyImagePath,
    //               data.audioFile!.toString());
    //           await chatState.onMessageSubmitted(data,
    //               currentUser.userId!, widget.userProfileId!, data,
    //               notofication: chatState.myonlineStatus.value.notofication);
    //           await SQLHelper.createLocalMessages(data);
    //           chatSetState.value.value = await SQLHelper.findLocalMessages(
    //               data.chatlistKey.toString());
    //           cprint(' offline audio sent');
    //         } else {
    //           data.fileDownloaded = null;
    //           await chatState.onMessageSubmitted(data,
    //               currentUser.userId!, widget.userProfileId!, data,
    //               notofication: chatState.myonlineStatus.value.notofication);
    //           await SQLHelper.createLocalMessages(data);
    //           chatSetState.value.value = await SQLHelper.findLocalMessages(
    //               data.chatlistKey.toString());
    //           cprint(' offline message sent');
    //         }
    //       }
    //     });
    //     await database
    //         .listDocuments(
    //       databaseId: databaseId,
    //       collectionId: userOrdersCollection,
    //     )
    //         .then((data) {
    //       var value = data.documents
    //           .map((e) => OrderViewProduct.fromSnapshot(e.data))
    //           .toList();

    //       userCartController.orders.value = value;
    //       // orders = value.obs;
    //     });
    //     seenMessagesState.value = false;
    //   } on AppwriteException catch (e) {
    //     cprint('$e');
    //     // if (e.code == 404) {
    //     //   try {
    //     //     cprint(
    //     //         '${chatIdUsers == null ? "feedState.dataBaseChatsId!.value" : chatIdUsers.toString()} chatId 2');
    //     //     chatSetState.value.value = await SQLHelper.findLocalMessages(
    //     //         chatIdUsers == null
    //     //             ? "feedState.dataBaseChatsId!.value"
    //     //             : chatIdUsers.toString());
    //     //     final database = Databases(
    //     //       clientConnect(),
    //     //     );

    //     //     if (pageIndex == 'bottom') {
    //     //       await database.listDocuments(
    //     //           databaseId: chatDatabase,
    //     //           collectionId:
    //     //               '${otheruserId.splitByLengths((otheruserId.length) ~/ 2)[0]}_${curruserId.splitByLengths((curruserId.length) ~/ 2)[0]}',
    //     //           queries: [
    //     //             Query.orderDesc('createdAt'),
    //     //             Query.equal('fileDownloaded', 'new'),
    //     //             // Query.equal('seen', 'false'),
    //     //             // Query.equal('senderId', otheruserId.toString()),
    //     //             Query.limit(10),

    //     //             // Query.cursorAfter(lastId.toString()),
    //     //           ]).then((data) async {
    //     //         if (data.documents.isNotEmpty) {
    //     //           var value = data.documents
    //     //               .map((e) => ChatMessage.fromJson(e.data))
    //     //               .toList();
    //     //           value.forEach((data) {
    //     //             if (chatSetState.value
    //     //                     .firstWhere((msg) => msg.key == data.key,
    //     //                         orElse: () => ChatMessage())
    //     //                     .key ==
    //     //                 data.key) {
    //     //               return;
    //     //             }
    //     //             SQLHelper.createLocalMessages(data);
    //     //           });
    //     //           chatSetState.value.value =
    //     //               await SQLHelper.findLocalMessages(chatIdUsers == null
    //     //                   ? "feedState.dataBaseChatsId!.value"
    //     //                   : chatIdUsers.toString());
    //     //           lastId = data.documents.last.$id;
    //     //           cprint('lastId is $lastId');
    //     //         } else {}
    //     //       }).onError((error, stackTrace) {
    //     //         cprint('$error pageIndex == bottom');
    //     //       });
    //     //     } else if (pageIndex == 'top') {
    //     //       await database.listDocuments(
    //     //           databaseId: chatDatabase,
    //     //           collectionId:
    //     //               '${otheruserId.splitByLengths((otheruserId.length) ~/ 2)[0]}_${curruserId.splitByLengths((curruserId.length) ~/ 2)[0]}',
    //     //           queries: [
    //     //             Query.orderDesc('createdAt'),
    //     //             Query.equal('fileDownloaded', 'new'),
    //     //             // Query.equal('seen', 'false'),
    //     //             // Query.equal('senderId', otheruserId.toString()),
    //     //             Query.limit(10),
    //     //             Query.cursorAfter(lastId.toString()),
    //     //           ]).then((data) async {
    //     //         if (data.documents.isNotEmpty) {
    //     //           var value = data.documents
    //     //               .map((e) => ChatMessage.fromJson(e.data))
    //     //               .toList();
    //     //           value.forEach((data) {
    //     //             if (chatSetState.value
    //     //                     .firstWhere((msg) => msg.key == data.key,
    //     //                         orElse: () => ChatMessage())
    //     //                     .key ==
    //     //                 data.key) {
    //     //               return;
    //     //             }
    //     //             SQLHelper.createLocalMessages(data);
    //     //           });
    //     //           chatSetState.value.value =
    //     //               await SQLHelper.findLocalMessages(chatIdUsers == null
    //     //                   ? "feedState.dataBaseChatsId!.value"
    //     //                   : chatIdUsers.toString());
    //     //           lastId = data.documents.last.$id;
    //     //           cprint('lastId is $lastId');
    //     //         } else {}
    //     //       }).onError((error, stackTrace) {
    //     //         cprint('$error pageIndex == top');
    //     //       });
    //     //     } else {
    //     //       await database.listDocuments(
    //     //           databaseId: chatDatabase,
    //     //           collectionId:
    //     //               '${otheruserId.splitByLengths((otheruserId.length) ~/ 2)[0]}_${curruserId.splitByLengths((curruserId.length) ~/ 2)[0]}',
    //     //           queries: [
    //     //             Query.orderDesc('createdAt'),
    //     //             Query.equal('fileDownloaded', 'new'),
    //     //             //  Query.equal('seen', 'false'),
    //     //             // Query.equal('senderId', otheruserId.toString()),
    //     //             Query.limit(10),
    //     //           ]).then((data) async {
    //     //         if (data.documents.isNotEmpty) {
    //     //           var value = data.documents
    //     //               .map((e) => ChatMessage.fromJson(e.data))
    //     //               .toList();
    //     //           value.forEach((data) async {
    //     //             // if (chatSetState.value
    //     //             //         .firstWhere((msg) => msg.key == data.key,
    //     //             //             orElse: () => ChatMessage())
    //     //             //         .key ==
    //     //             //     data.key) {
    //     //             //   return;
    //     //             // }
    //     //             return await SQLHelper.createLocalMessages(data);
    //     //           });
    //     //           chatSetState.value.value =
    //     //               await SQLHelper.findLocalMessages(chatIdUsers == null
    //     //                   ? "feedState.dataBaseChatsId!.value"
    //     //                   : chatIdUsers.toString());
    //     //           if (seenMessagesState.value == true) {
    //     //             chatSetState.value.forEach((data) async {
    //     //               if (data.senderId == authState.appUser!.$id) {
    //     //                 return;
    //     //               }
    //     //               if (data.seen == 'true') {
    //     //                 await database.updateDocument(
    //     //                   databaseId: chatDatabase,
    //     //                   collectionId: data.chatlistKey.toString(),
    //     //                   documentId: data.key.toString(),
    //     //                   data: {
    //     //                     "seen": 'true',
    //     //                     "fileDownloaded": "recieved"
    //     //                   },
    //     //                 );
    //     //               } else if (data.fileDownloaded != 'recieved') {
    //     //                 await database.updateDocument(
    //     //                   databaseId: chatDatabase,
    //     //                   collectionId: data.chatlistKey.toString(),
    //     //                   documentId: data.key.toString(),
    //     //                   data: {"seen": 'true', "fileDownloaded": "new"},
    //     //                 );
    //     //                 await SQLHelper.updateLocalMessageSeen(data,
    //     //                     seen: 'true');
    //     //               }
    //     //             });
    //     //             chatSetState.value.value =
    //     //                 await SQLHelper.findLocalMessages(chatIdUsers == null
    //     //                     ? "feedState.dataBaseChatsId!.value"
    //     //                     : chatIdUsers.toString());
    //     //             seenMessagesState.value = false;
    //     //           }
    //     //           lastId = data.documents.last.$id;
    //     //           cprint('lastId is null 2');
    //     //         } else {}
    //     //       }).onError((error, stackTrace) {
    //     //         cprint('$error pageIndex == bottom');
    //     //       });
    //     //     }

    //     //     database
    //     //         .getDocument(
    //     //             databaseId: databaseId,
    //     //             collectionId: profileUserColl,
    //     //             documentId: userProfileId.toString())
    //     //         .then((item) {
    //     //       chatState.chatUserModel.value =
    //     //           ViewductsUser.fromJson(item.data);
    //     //     });
    //     //     await chatState.getChatActiveness(
    //     //       'online',
    //     //       curruserId,
    //     //       otheruserId,
    //     //     );
    //     //     await database
    //     //         .getDocument(
    //     //       databaseId: databaseId,
    //     //       collectionId: chatActiveColl,
    //     //       documentId:
    //     //           '${curruserId.splitByLengths((curruserId.length) ~/ 2)[0]}_${otheruserId.splitByLengths((otheruserId.length) ~/ 2)[0]}',
    //     //     )
    //     //         .then((item) {
    //     //       myNotificationBlockStatus.value.value =
    //     //           ChatOnlineStatus.fromJson(item.data);
    //     //       chatState.myonlineStatus = myNotificationBlockStatus.value;
    //     //     });
    //     //     await database
    //     //         .getDocument(
    //     //       databaseId: databaseId,
    //     //       collectionId: chatActiveColl,
    //     //       documentId:
    //     //           '${otheruserId.splitByLengths((otheruserId.length) ~/ 2)[0]}_${curruserId.splitByLengths((curruserId.length) ~/ 2)[0]}',
    //     //     )
    //     //         .then((item) {
    //     //       onlineStatusState.value.value =
    //     //           ChatOnlineStatus.fromJson(item.data);
    //     //     });
    //     //     // await database
    //     //     //     .getDocument(
    //     //     //   databaseId: databaseId,
    //     //     //   collectionId: chatActiveColl,
    //     //     //   documentId:
    //     //     //       '${curruserId.splitByLengths((curruserId.length) ~/ 2)[0]}_${otheruserId.splitByLengths((otheruserId.length) ~/ 2)[0]}',
    //     //     // )
    //     //     //     .then((item) {
    //     //     //   onlineStatusState.value.value =
    //     //     //       ChatOnlineStatus.fromJson(item.data);
    //     //     // });

    //     //     seenMessagesState.value = false;
    //     //     cprint('second id');
    //     //   } on AppwriteException catch (e) {
    //     //     cprint('$e subscribe');
    //     //   }

    //     // }

    //   }
    //   // });
    // }

    // final chatStream = useStream(realtime.subscribe([
    //   "databases.$chatDatabase.collections.${feedState.dataBaseChatsId}.documents"
    // ]).stream);
    // final onlineStatus = useStream(realtime.subscribe([
    //   "databases.$databaseId.collections.$chatActiveColl.documents"
    // ]).stream);

    // final progress = (0.0.obs);
    _requestPersmission(permi.Permission permission) async {
      if (await permission.isGranted) {
        return true;
      } else {
        var result = await permission.request();
        if (result == permi.PermissionStatus.granted) {
          return true;
        } else {
          return false;
        }
      }
    }

    PlatformFile? pickedFile;
    createFileRecursively(String folder, String imageUrl) async {
      try {
        var response = await http.get(Uri.parse(
            'https://6357.viewducts.com/v1/storage/buckets/$chatsMedia/files/$imageUrl/download?project=62e0a2f7680479a72579')); // Get the image

        Directory? tempDir = await getExternalStorageDirectory();
        String extDir = tempDir!.path;

        // Where folder in this case will be Tralien
        Directory writeDir = Directory.fromUri(Uri(
            path: "$extDir/$folder")); // Join the folder and external storage
        writeDir.createSync(
            recursive:
                true); // We first create the folder and file if it does not exist.

        String filename = DateTime.now().millisecondsSinceEpoch.toString();

        File("$extDir/$folder/$filename.png").writeAsBytes(response.bodyBytes,
            flush:
                true); // Finally, we write the bytes into the file we just created
        savedFile = File("$extDir/$folder/$filename.png");
        cprint("${savedFile?.path} local file");
      } on AppwriteException catch (e) {
        cprint('$e createFileRecursively');
      }
    }

    Future<bool> saveFile({String? url, String? filename}) async {
      Directory? directory;
      try {
        // Storage storage = Storage(clientConnect());
        // final result =
        //    await storage.getFile(bucketId: chatsMedia, fileId: url.toString());
        if (Platform.isAndroid) {
          if (await _requestPersmission(permi.Permission.storage)) {
            directory = await getExternalStorageDirectory();

            // String newPath = "";
            // List<String> folders = directory!.path.split("/");
            // for (int i = 1; i < folders.length; i++) {
            //   String folder = folders[i];
            //   if (folder != "Android") {
            //     newPath += "/" + folder;
            //   } else {
            //     break;
            //   }
            // }
            // newPath = newPath + "/ViewDucts";
            // directory = Directory(newPath);
            cprint('${directory!.path} path');
          } else {
            return false;
          }
        } else {
          if (await _requestPersmission(permi.Permission.photos)) {
            directory = await getTemporaryDirectory();
          } else {
            return false;
          }
        }
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        if (await directory.exists()) {
          // cprint('$url files');
          // final minio = Minio(
          //     endPoint: "userCartController.wasabiAws.value.endPoint.toString()",
          //     accessKey:
          //         "userCartController.wasabiAws.value.accessKey.toString()",
          //     secretKey:
          //         "userCartController.wasabiAws.value.secretKey.toString()",
          //     region: userCartController.wasabiAws.value.region.toString());
          // final stream = await minio.getObject("storage-viewduct", '$url');
          // await stream.pipe(File(directory.path + "/$url").openWrite());
          // // await dio.download(url.toString(), savedFile!.path,
          // //     onReceiveProgress: (downloded, totalSize) {
          // //   progress.value.value = (downloded / totalSize);
          // // });
          // savedFile = await File(directory.path + "/$filename");
          // await ImageGallerySaver.saveFile(
          //   savedFile!.path,
          // );
          // cprint('${savedFile!.path} path');
          // if (Platform.isIOS) {
          //   await ImageGallerySaver.saveFile(savedFile!.path,
          //       isReturnPathOfIOS: true);
          // }
          return true;
        }
      } catch (e) {
        cprint('$e downlod file chatScreen');
      }
      return false;
    }

    // _save({String? url, String? filename}) async {
    //   try {
    //     // Storage storage = Storage(clientConnect());
    //     // final image = await storage.getFileDownload(
    //     //     bucketId: chatsMedia, fileId: url.toString());
    //     // final link =
    //     //     'https://6357.viewducts.com/v1/storage/buckets/$chatsMedia/files/$url/download?project=62e0a2f7680479a72579';
    //     var response = await Dio().get(
    //         "https://ss0.baidu.com/94o3dSag_xI4khGko9WTAnF6hhy/image/h%3D300/sign=a62e824376d98d1069d40a31113eb807/838ba61ea8d3fd1fc9c7b6853a4e251f94ca5f46.jpg",
    //         options: Options(responseType: ResponseType.bytes));
    //     final result = await ImageGallerySaver.saveImage(
    //         Uint8List.fromList(response.data),
    //         quality: 60,
    //         name: "hello");
    //     cprint(result.toString());
    //   } catch (e) {
    //     cprint(e.toString());
    //   }
    // }

    downloadFile({String? url, String? filename}) async {
      loading.value = true;
      bool downloaded = await saveFile(url: url, filename: filename);
      if (downloaded) {
        cprint('File Downloaded');
      } else {
        cprint('Problems Downloading File');
      }
      loading.value = false;
    }

    // onlineSubs() {
    //   onlineStatus.data;
    //   if (onlineStatusState.value.value != null) {
    //     switch (onlineStatus.data?.events) {
    //       case ["collections.*.documents"]:
    //         // setState(() {});
    //         onlineStatusState.value.value =
    //             (ChatOnlineStatus.fromJson(onlineStatus.data?.payload));

    //         break;
    //       case ["collections.*.documents.*.delete"]:
    //         break;

    //       default:
    //         break;
    //     }
    //   } else {
    //     cprint('it is empty');
    //   }
    // }

    // subs() async {
    //   try {
    //     chatStream.data;
    //     cprint('local messages new');
    //     if (chatSetState.value.value.isNotEmpty) {
    //       switch (chatStream.data?.events) {
    //         case ["collections.*.documents"]:
    //           cprint('local messages new');
    //           SQLHelper.createLocalMessages(
    //               ChatMessage.fromJson(chatStream.data?.payload));
    //           chatSetState.value.value
    //               .add(ChatMessage.fromJson(chatStream.data?.payload));
    //           chatSetState.value.value = await chatState.chatMessage.value;
    //           chatSetState.value.value = await SQLHelper.findLocalMessages(
    //               '${curruserId.splitByLengths((curruserId.length) ~/ 2)[0]}_${otheruserId.splitByLengths((otheruserId.length) ~/ 2)[0]}');
    //           if (chatSetState.value.value.isEmpty) {
    //             chatSetState.value.value = await SQLHelper.findLocalMessages(
    //                 '${otheruserId.splitByLengths((otheruserId.length) ~/ 2)[0]}_${curruserId.splitByLengths((curruserId.length) ~/ 2)[0]}');
    //           }

    //           break;
    //         case ["collections.*.documents.*.delete"]:
    //           chatSetState.value.value.removeWhere(
    //               (datas) => datas.key == chatStream.data!.payload['key']);

    //           break;

    //         default:
    //           break;
    //       }
    //     } else {
    //       chatSetState.value.value = await chatState.chatMessage.value;
    //       chatSetState.value.value = await SQLHelper.findLocalMessages(
    //           '${curruserId.splitByLengths((curruserId.length) ~/ 2)[0]}_${otheruserId.splitByLengths((otheruserId.length) ~/ 2)[0]}');
    //       if (chatSetState.value.value.isEmpty) {
    //         chatSetState.value.value = await SQLHelper.findLocalMessages(
    //             '${otheruserId.splitByLengths((otheruserId.length) ~/ 2)[0]}_${curruserId.splitByLengths((curruserId.length) ~/ 2)[0]}');
    //       }

    //       cprint('local messages');
    //     }
    //   } on AppwriteException catch (e) {
    //     cprint('$e subs');
    //   }
    // }

    // final subStreaming = useMemoized(() => subs());
    // final onlineStatusStreaming = useMemoized(() => onlineSubs());

    showKeyboard() => textFieldFocus.requestFocus();

    hideKeyboard() => textFieldFocus.unfocus();

    hideEmojiContainer() {
      seenMessagesState.value = true;
      showEmojiPicker.value = false;
      if (myOrders != '') {
        cprint('${myOrders} orders keys');
      }
    }

    showEmojiContainer() {
      showEmojiPicker.value = true;
    }

    // @override
    dynamic encryptWithCRC(input) {
      try {
        final encrypted = cryptor!.encrypt(input, iv: iv);
        int crc = CRC32.compute(input);
        return '$encrypted$CRC_SEPARATOR$crc';
      } catch (e) {
        ViewDucts.toast('Waiting for your peer to join the chat.');
        return false;
      }
    }

    String decryptWithCRC(String input) {
      try {
        if (input.contains(CRC_SEPARATOR)) {
          int idx = input.lastIndexOf(CRC_SEPARATOR);
          String msgPart = input.substring(0, idx);
          String crcPart = input.substring(idx + 1);
          int? crc = int.tryParse(crcPart);
          if (crc != null) {
            msgPart = cryptor?.decrypt(encrypt.Encrypted.fromBase64(msgPart),
                    iv: iv) ??
                "";
            if (CRC32.compute(msgPart) == crc) return msgPart;
          }
        }
      } on FormatException {
        return 'there is error';
      }
      return '';
    }

    void pickImage({required ImageSource source}) async {
      // File selectedImage = await Utils.pickImage(source: source);
      // _storageMethods.uploadImage(
      //     image: selectedImage,
      //     receiverId: receiver.uid,
      //     senderId: _currentUserId,
      //     imageUploadProvider: _imageUploadProvider);
    }

    // @override
    updateLocalUserData() {
      // if (authState.userModel != null && chatState.chatUser != null) {
      //   hidden.value = authState.userModel!.hidden != null &&
      //       authState.userModel!.hidden!.contains(userProfileId);
      //   locked.value = authState.userModel!.locked != null &&
      //       authState.userModel!.locked!.contains(userProfileId);
      // }
    }
    BorderRadius getBorder(bool myMessage) {
      return BorderRadius.only(
        topLeft: const Radius.circular(20),
        topRight: const Radius.circular(20),
        bottomRight:
            myMessage ? const Radius.circular(0) : const Radius.circular(20),
        bottomLeft:
            myMessage ? const Radius.circular(20) : const Radius.circular(0),
      );
    }
    // FlutterSecureStorage storage = const FlutterSecureStorage();

    // String getLastSeenKey(String peerNo, String lastSeen) {

    getImageFileName(id, timestamp) {
      return "$id-$timestamp";
    }

    Future uploadFile() async {
      //  var authState = Provider.of<AuthState>(context, listen: false);

      uploadTimestamp = DateTime.now().millisecondsSinceEpoch;
      String fileName =
          getImageFileName("currentUser.userId", '$uploadTimestamp');
      Reference reference = FirebaseStorage.instance.ref().child(fileName);
      TaskSnapshot uploading = await reference.putFile(imageFile!);
      return uploading.ref.getDownloadURL();
    }

    delete(int? ts) {
      // chatState.messageList!.removeWhere((msg) => msg.timeStamp == ts);
      // chatState.messageListing!.value = List.from(chatState.messageList!);
    }

    getImage(File image) {
      imageFile = image;
      return uploadFile();
    }

    void _audioPlayer(BuildContext context, String audioPath, bool isLocal) {
      showModalBottomSheet(
          backgroundColor: Colors.red,
          isDismissible: false,
          // bounce: true,
          context: context,
          builder: (context) => Scaffold(
                backgroundColor: CupertinoColors.darkBackgroundGray,
                body: SafeArea(
                    child: Responsive(
                  mobile: Stack(
                    children: <Widget>[
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.grey.withOpacity(.3),
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.35,
                          child: Stack(
                            children: [
                              AudioUploadAdmin(
                                audioPickedFile: audioPath,
                                loacalFile: isLocal,
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: Get.height * 0.02,
                        left: 10,
                        child: GestureDetector(
                          onTap: () async {
                            await audioPlayer.stop();

                            Navigator.maybePop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      offset: const Offset(0, 11),
                                      blurRadius: 11,
                                      color: Colors.black.withOpacity(0.06))
                                ],
                                borderRadius: BorderRadius.circular(18),
                                color: CupertinoColors.inactiveGray),
                            padding: const EdgeInsets.all(5.0),
                            child: const Icon(
                              CupertinoIcons.back,
                              color: CupertinoColors.lightBackgroundGray,
                              size: 40,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  tablet: Stack(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Stack(
                              children: <Widget>[
                                Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Colors.grey.withOpacity(.3),
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.35,
                                    child: Stack(
                                      children: [
                                        AudioUploadAdmin(
                                          audioPickedFile: audioPath,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: Get.height * 0.02,
                        left: 10,
                        child: GestureDetector(
                          onTap: () async {
                            await audioPlayer.stop();

                            Navigator.maybePop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      offset: const Offset(0, 11),
                                      blurRadius: 11,
                                      color: Colors.black.withOpacity(0.06))
                                ],
                                borderRadius: BorderRadius.circular(18),
                                color: CupertinoColors.inactiveGray),
                            padding: const EdgeInsets.all(5.0),
                            child: const Icon(
                              CupertinoIcons.back,
                              color: CupertinoColors.lightBackgroundGray,
                              size: 40,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  desktop: Stack(
                    children: [
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                        child: Container(
                          color: (Colors.white12).withOpacity(0.1),
                        ),
                      ),
                      Row(
                        children: [
                          // Once our width is less then 1300 then it start showing errors
                          // Now there is no error if our width is less then 1340

                          Expanded(
                            flex: Get.width > 1340 ? 3 : 5,
                            child: PlainScaffold(),
                          ),
                          Expanded(
                            flex: Get.width > 1340 ? 8 : 10,
                            child: Stack(
                              children: <Widget>[
                                Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Colors.grey.withOpacity(.3),
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.35,
                                    child: Stack(
                                      children: [
                                        AudioUploadAdmin(
                                          audioPickedFile: audioPath,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: Get.height * 0.02,
                                  left: 10,
                                  child: GestureDetector(
                                    onTap: () async {
                                      await audioPlayer.stop();

                                      Navigator.maybePop(context);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                offset: const Offset(0, 11),
                                                blurRadius: 11,
                                                color: Colors.black
                                                    .withOpacity(0.06))
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          color: CupertinoColors.inactiveGray),
                                      padding: const EdgeInsets.all(5.0),
                                      child: const Icon(
                                        CupertinoIcons.back,
                                        color:
                                            CupertinoColors.lightBackgroundGray,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: Get.width > 1340 ? 2 : 4,
                            child: PlainScaffold(),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
              ));
    }

    void _imageView(BuildContext context, String imagePath) {
      showModalBottomSheet(
          backgroundColor: Colors.red,
          // bounce: true,
          context: context,
          builder: (context) => Scaffold(
                backgroundColor: CupertinoColors.darkBackgroundGray,
                body: SafeArea(
                    child: Responsive(
                  mobile: Hero(
                    tag: imagePath,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: Get.height,
                          width: Get.width,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            image: DecorationImage(
                                image: FileImage(File(imagePath.toString())),
                                fit: BoxFit.cover),
                          ),
                          //  child: Image.memory(pickedFile!.bytes!),
                        ),
                      ],
                    ),
                  ),
                  tablet: Stack(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  height: Get.height,
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    image: DecorationImage(
                                        image: FileImage(
                                            File(imagePath.toString())),
                                        fit: BoxFit.cover),
                                  ),
                                  //  child: Image.memory(pickedFile!.bytes!),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  desktop: Stack(
                    children: [
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                        child: Container(
                          color: (Colors.white12).withOpacity(0.1),
                        ),
                      ),
                      Row(
                        children: [
                          // Once our width is less then 1300 then it start showing errors
                          // Now there is no error if our width is less then 1340

                          Expanded(
                            flex: Get.width > 1340 ? 3 : 5,
                            child: PlainScaffold(),
                          ),
                          Expanded(
                            flex: Get.width > 1340 ? 8 : 10,
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  height: Get.height,
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    image: DecorationImage(
                                        image: FileImage(
                                            File(imagePath.toString())),
                                        fit: BoxFit.cover),
                                  ),
                                  //  child: Image.memory(pickedFile!.bytes!),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: Get.width > 1340 ? 2 : 4,
                            child: PlainScaffold(),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
              ));
    }

    getWallpaper(File image) {
      //  final chatState = Provider.of<ChatState>(context);

      // chatState.setWallpaper(widget.userProfileId, image);
      return Future.value(false);
    }

    Rx<ChatMessage>? replyMessag;
    final replyMessage = (replyMessag);
    swipeMessage(ChatMessage message) {
      replyMessage?.value = message;
      cprint('${replyMessage?.value.message} message');
    }

    void cancelReply() {
      replyMessage?.value == null;
      textFieldFocus.unfocus();
    }

    final uplodingFileInProgress = (false.obs);
    Widget _messages(ChatMessage chat, bool myMessage, BuildContext context) {
      RxString savedFiles = ''.obs;
      final List<FeedModel>? userOrders = <FeedModel>[];
      // feedState.commissionProducts(authState.userModel, chat.imageKey);
      final AwsS3Client s3client = AwsS3Client(
          region: "userCartController.wasabiAws.value.region",
          host: "s3.wasabisys.com",
          bucketId: "storage-viewduct",
          accessKey: "userCartController.wasabiAws.value.accessKey",
          secretKey: "userCartController.wasabiAws.value.secretKey");

      var imagePathOnline =
          s3client.buildSignedGetParams(key: chat.imagePath.toString()).uri;
      Future<void> _downloadFile() async {
        // final localMessage = chat;
        // DownloadService downloadService =
        //     kIsWeb ? WebDownloadService() : MobileDownloadService();
        // await downloadService.download(
        //     url: chat.imagePath.toString(), savedFile: savedFiles.value);

        // chat.fileDownloaded = 'downloded';
        // localMessage.fileDownloaded = 'downloded';
        // localMessage.imagePath = chatState.savedFile!.value.toString();

        // await chatState.updateDownlodImageMessage(
        //     chat: chat,
        //     currentUser: currentUser?.userId,
        //     secondUser: chat.senderId,
        //     localMessage: localMessage);
        // cprint('image downloded');
      }

      return SwipeTo(
        onRightSwipe: () {
          textFieldFocus.requestFocus();
          //  replyMessage = chat;

          swipeMessage(chat);
        },
        child: Column(
          key: UniqueKey(),
          crossAxisAlignment:
              myMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisAlignment:
              myMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            chat.message == null
                ? Container()
                : chat.replyedMessage != null
                    ? Container(
                        alignment: myMessage
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        // margin: EdgeInsets.only(
                        //   right: myMessage ? 10 : (Get.width / 4),
                        //   top: 20,
                        //   left: myMessage ? (Get.width / 9) : 10,
                        // ),
                        child: IntrinsicHeight(
                            //  width: Get.width * 0.9,
                            child: Row(
                          crossAxisAlignment: myMessage
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          mainAxisAlignment: myMessage
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            !myMessage
                                ? Container(color: Colors.cyan, width: 4)
                                : Container(),
                            // Row(
                            //   children: [
                            //     customText((replyMessage?.value!.value.senderId.toString())),
                            //   ],
                            // ),

                            SizedBox(
                              width: Get.width * 0.8,
                              child: Column(
                                crossAxisAlignment: myMessage
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                mainAxisAlignment: myMessage
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                                children: [
                                  Container(
                                    // width: Get.width * 0.8,
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        borderRadius: getBorder(true),
                                        color: myMessage
                                            ? Colors.amber[300]
                                            : Colors.cyan[100]),
                                    child: Container(
                                      child: customText(
                                          TextEncryptDecrypt.decryptAES(
                                              chat.replyedMessage.toString()),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  customText(TextEncryptDecrypt.decryptAES(
                                      chat.message.toString())),
                                ],
                              ),
                            ),
                            myMessage
                                ? Container(color: Colors.cyan, width: 4)
                                : Container(),
                          ],
                        )),
                      )
                    : Row(
                        crossAxisAlignment: myMessage
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        mainAxisAlignment: myMessage
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: <Widget>[
                          // myMessage
                          //     ? SizedBox()
                          //     : CircleAvatar(
                          //         backgroundColor: Colors.transparent,
                          //         backgroundImage:
                          //             customAdvanceNetworkImage(userImage),
                          //       ),
                          Container(
                            alignment: myMessage
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            // margin: EdgeInsets.only(
                            //   right: myMessage ? 10 : (Get.width / 4),
                            //   top: 20,
                            //   left: myMessage ? (Get.width / 4) : 0,
                            // ),
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  child: chat.type ==
                                          MessagesType.ChatUserProducts.index
                                      ? SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            crossAxisAlignment: myMessage
                                                ? CrossAxisAlignment.end
                                                : CrossAxisAlignment.start,
                                            mainAxisAlignment: myMessage
                                                ? MainAxisAlignment.end
                                                : MainAxisAlignment.start,
                                            children: [
                                              Stack(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        myMessage
                                                            ? CrossAxisAlignment
                                                                .end
                                                            : CrossAxisAlignment
                                                                .start,
                                                    mainAxisAlignment: myMessage
                                                        ? MainAxisAlignment.end
                                                        : MainAxisAlignment
                                                            .start,
                                                    children: [
                                                      const Text(
                                                        'Products',
                                                        style: TextStyle(
                                                            color: Colors.cyan,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      frostedGreen(SizedBox(
                                                        width: Get.width * 0.6,
                                                        height:
                                                            Get.width * 0.25,
                                                        child: ListView.builder(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          addAutomaticKeepAlives:
                                                              false,
                                                          physics:
                                                              const BouncingScrollPhysics(),
                                                          itemBuilder: (context, index) => Padding(
                                                              padding:
                                                                  const EdgeInsets.all(
                                                                      8.0),
                                                              child: SizedBox(
                                                                  height: fullWidth(
                                                                          context) *
                                                                      0.3,
                                                                  width: fullWidth(
                                                                      context),
                                                                  child: _SelectedProduct(
                                                                      list: userOrders![
                                                                          index],
                                                                      model:
                                                                          model,
                                                                      ductId: chat
                                                                          .imageKey))),
                                                          itemCount: userOrders
                                                                  ?.length ??
                                                              0,
                                                        ),
                                                      )),
                                                      myMessage
                                                          ? const Divider(
                                                              color:
                                                                  Colors.teal,
                                                              height: 5,
                                                              thickness: 1,
                                                            )
                                                          : const Divider(
                                                              color:
                                                                  Colors.purple,
                                                              height: 5,
                                                              thickness: 1,
                                                            ),
                                                      myMessage
                                                          ? BubbleSpecialThree(
                                                              color: Colors
                                                                  .black54,
                                                              text: TextEncryptDecrypt
                                                                  .decryptAES(chat
                                                                      .message),
                                                              textStyle: onPrimarySubTitleText
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .orange
                                                                          .shade100),
                                                            )
                                                          : BubbleSpecialThree(
                                                              isSender: false,
                                                              tail: true,
                                                              color:
                                                                  TwitterColor
                                                                      .mystic,
                                                              text: TextEncryptDecrypt
                                                                  .decryptAES(chat
                                                                      .message),
                                                            )
                                                    ],
                                                  ),
                                                  myMessage
                                                      ? Positioned(
                                                          bottom: 30,
                                                          right: 0,
                                                          child: InkWell(
                                                            onTap: () {
                                                              showModalBottomSheet(
                                                                  backgroundColor:
                                                                      Colors
                                                                          .red,
                                                                  // bounce: true,
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) =>
                                                                          ProductStoryView(
                                                                            commissionUser: chat.senderId == currentUser?.userId
                                                                                ? null
                                                                                : chat.senderId,
                                                                            // model: feedState.productlist!.firstWhere((e) => e.key == chat.imageKey),
                                                                          ));
                                                              //  _buyingDialog(
                                                              // context);
                                                            },
                                                            child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(0),
                                                                decoration: const BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .yellow),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child:
                                                                      customTitleText(
                                                                          'Buy'),
                                                                )),
                                                          ),
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      : chat.type == MessagesType.Products.index
                                          ? SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                crossAxisAlignment: myMessage
                                                    ? CrossAxisAlignment.end
                                                    : CrossAxisAlignment.start,
                                                mainAxisAlignment: myMessage
                                                    ? MainAxisAlignment.end
                                                    : MainAxisAlignment.start,
                                                children: [
                                                  Stack(
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment: myMessage
                                                            ? CrossAxisAlignment
                                                                .end
                                                            : CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment: myMessage
                                                            ? MainAxisAlignment
                                                                .end
                                                            : MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          // const Text(
                                                          //   'Product in Cart',
                                                          //   style: TextStyle(
                                                          //       color: Colors
                                                          //           .cyan,
                                                          //       fontWeight:
                                                          //           FontWeight
                                                          //               .bold),
                                                          // ),
                                                          frostedPink(
                                                              SingleChildScrollView(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            child: Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: context.responsiveValue(
                                                                      mobile:
                                                                          Get.height *
                                                                              0.4,
                                                                      tablet:
                                                                          Get.height *
                                                                              0.4,
                                                                      desktop:
                                                                          Get.height *
                                                                              0.4),
                                                                  height: context.responsiveValue(
                                                                      mobile: Get
                                                                              .height *
                                                                          0.14,
                                                                      tablet: Get
                                                                              .height *
                                                                          0.14,
                                                                      desktop: Get
                                                                              .height *
                                                                          0.14),
                                                                  child: ListView
                                                                      .builder(
                                                                    scrollDirection:
                                                                        Axis.horizontal,
                                                                    addAutomaticKeepAlives:
                                                                        false,
                                                                    physics:
                                                                        const BouncingScrollPhysics(),
                                                                    itemBuilder: (context, index) => Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(
                                                                                8.0),
                                                                        child: SizedBox(
                                                                            height: context.responsiveValue(
                                                                                mobile: Get.height * 0.14,
                                                                                tablet: Get.height * 0.14,
                                                                                desktop: Get.height * 0.14),
                                                                            width: context.responsiveValue(mobile: Get.height * 0.8, tablet: Get.height * 0.8, desktop: Get.height * 0.8),
                                                                            child: _SelectedProduct(list: userOrders![index], model: model, ductId: chat.imageKey))),
                                                                    itemCount:
                                                                        userOrders?.length ??
                                                                            0,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )),
                                                          myMessage
                                                              ? const Divider(
                                                                  color: Colors
                                                                      .teal,
                                                                  height: 5,
                                                                  thickness: 1,
                                                                )
                                                              : const Divider(
                                                                  color: Colors
                                                                      .purple,
                                                                  height: 5,
                                                                  thickness: 1,
                                                                ),
                                                          myMessage
                                                              ? BubbleSpecialThree(
                                                                  color: Colors
                                                                      .black54,
                                                                  text: TextEncryptDecrypt
                                                                      .decryptAES(
                                                                          chat.message),
                                                                  textStyle: onPrimarySubTitleText.copyWith(
                                                                      color: Colors
                                                                          .orange
                                                                          .shade100),
                                                                )
                                                              : BubbleSpecialThree(
                                                                  isSender:
                                                                      false,
                                                                  tail: true,
                                                                  color:
                                                                      TwitterColor
                                                                          .mystic,
                                                                  text: TextEncryptDecrypt
                                                                      .decryptAES(
                                                                          chat.message),
                                                                )
                                                        ],
                                                      ),
                                                      myMessage
                                                          ? Positioned(
                                                              bottom: 30,
                                                              right: 0,
                                                              child: InkWell(
                                                                onTap: () {
                                                                  showModalBottomSheet(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .red,
                                                                      // bounce:
                                                                      //     true,
                                                                      context:
                                                                          context,
                                                                      builder: (context) => ShoppingCart(
                                                                          // sellersName:
                                                                          //     chatState.chatUser?.displayName.toString(),
                                                                          // cart: userCartController.cart,
                                                                          // sellerId: chat.receiverId,
                                                                          // buyerId: chat.senderId
                                                                          ));
                                                                  // showModalBottomSheet(
                                                                  //     backgroundColor:
                                                                  //         Colors
                                                                  //             .red,
                                                                  //     bounce:
                                                                  //         true,
                                                                  //     context:
                                                                  //         context,
                                                                  //     builder:
                                                                  //         (context) =>
                                                                  //             ProductStoryView(
                                                                  //               commissionUser: chat.senderId == authState.userId ? null : chat.senderId,
                                                                  //               model: feedState.productlist!.firstWhere((e) => e.key == chat.imageKey),
                                                                  //             ));
                                                                },
                                                                child:
                                                                    Container(
                                                                        padding:
                                                                            const EdgeInsets.all(
                                                                                0),
                                                                        decoration: const BoxDecoration(
                                                                            shape: BoxShape
                                                                                .circle,
                                                                            color: Colors
                                                                                .yellow),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              customTitleText('Cart'),
                                                                        )),
                                                              ),
                                                            )
                                                          : Container(),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          : chat.type ==
                                                  MessagesType.MyOrders.index
                                              ? SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        myMessage
                                                            ? CrossAxisAlignment
                                                                .end
                                                            : CrossAxisAlignment
                                                                .start,
                                                    mainAxisAlignment: myMessage
                                                        ? MainAxisAlignment.end
                                                        : MainAxisAlignment
                                                            .start,
                                                    children: [
                                                      Stack(
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                myMessage
                                                                    ? CrossAxisAlignment
                                                                        .end
                                                                    : CrossAxisAlignment
                                                                        .start,
                                                            mainAxisAlignment: myMessage
                                                                ? MainAxisAlignment
                                                                    .end
                                                                : MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const Text(
                                                                'My Orders',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .cyan,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              frostedOrange(
                                                                  SizedBox(
                                                                width:
                                                                    Get.width *
                                                                        0.6,
                                                                height:
                                                                    Get.width *
                                                                        0.25,
                                                                child: ListView
                                                                    .builder(
                                                                  scrollDirection:
                                                                      Axis.horizontal,
                                                                  addAutomaticKeepAlives:
                                                                      false,
                                                                  physics:
                                                                      const BouncingScrollPhysics(),
                                                                  itemBuilder: (context, index) => Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child: SizedBox(
                                                                          height: fullWidth(context) *
                                                                              0.3,
                                                                          width: fullWidth(
                                                                              context),
                                                                          child: _SelectedProduct(
                                                                              list: userOrders![index],
                                                                              model: model,
                                                                              ductId: chat.imageKey))),
                                                                  itemCount:
                                                                      userOrders
                                                                              ?.length ??
                                                                          0,
                                                                ),
                                                              )),
                                                              myMessage
                                                                  ? const Divider(
                                                                      color: Colors
                                                                          .teal,
                                                                      height: 5,
                                                                      thickness:
                                                                          1,
                                                                    )
                                                                  : const Divider(
                                                                      color: Colors
                                                                          .purple,
                                                                      height: 5,
                                                                      thickness:
                                                                          1,
                                                                    ),
                                                              myMessage
                                                                  ? BubbleSpecialThree(
                                                                      color: Colors
                                                                          .black54,
                                                                      text: TextEncryptDecrypt
                                                                          .decryptAES(
                                                                              chat.message),
                                                                      textStyle: onPrimarySubTitleText.copyWith(
                                                                          color: Colors
                                                                              .orange
                                                                              .shade100),
                                                                    )
                                                                  : BubbleSpecialThree(
                                                                      isSender:
                                                                          false,
                                                                      tail:
                                                                          true,
                                                                      color: TwitterColor
                                                                          .mystic,
                                                                      text: TextEncryptDecrypt
                                                                          .decryptAES(
                                                                              chat.message),
                                                                    )
                                                            ],
                                                          ),
                                                          myMessage
                                                              ? Positioned(
                                                                  bottom: 30,
                                                                  right: 0,
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      showModalBottomSheet(
                                                                          backgroundColor: Colors
                                                                              .red,
                                                                          // bounce:
                                                                          //     true,
                                                                          context:
                                                                              context,
                                                                          builder: (context) => ProductStoryView(
                                                                              // commissionUser: chat.senderId == currentUser?.userId ? null : chat.senderId,
                                                                              // model: feedState.productlist!.firstWhere((e) => e.key == chat.imageKey),
                                                                              ));
                                                                      //  _buyingDialog(
                                                                      // context);
                                                                    },
                                                                    child: Container(
                                                                        padding: const EdgeInsets.all(0),
                                                                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.yellow),
                                                                        child: Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              customTitleText('Buy'),
                                                                        )),
                                                                  ),
                                                                )
                                                              : Container(),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : chat.type ==
                                                      MessagesType.Image.index
                                                  ? SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Row(
                                                        crossAxisAlignment: myMessage
                                                            ? CrossAxisAlignment
                                                                .end
                                                            : CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment: myMessage
                                                            ? MainAxisAlignment
                                                                .end
                                                            : MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                myMessage
                                                                    ? CrossAxisAlignment
                                                                        .end
                                                                    : CrossAxisAlignment
                                                                        .start,
                                                            mainAxisAlignment: myMessage
                                                                ? MainAxisAlignment
                                                                    .end
                                                                : MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              // SizedBox(
                                                              //   width: Get.width *
                                                              //           (.8) -
                                                              //       8,
                                                              //   height: Get.width *
                                                              //           (.8) -
                                                              //       8,
                                                              //   //decoration: BoxDecoration(),
                                                              //   child:
                                                              //       AspectRatio(
                                                              //     aspectRatio:
                                                              //         4 / 3,
                                                              //     child: customNetworkImage(
                                                              //         chat.imagePath
                                                              //             .toString(),
                                                              //         fit: BoxFit
                                                              //             .cover),
                                                              //   ),
                                                              // ),
                                                              Stack(
                                                                children: [
                                                                  chat.fileDownloaded ==
                                                                              "downloded" ||
                                                                          chat.senderId ==
                                                                              currentUser?.userId
                                                                      ? GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            _imageView(context,
                                                                                chat.imagePath.toString());
                                                                          },
                                                                          child:
                                                                              Hero(
                                                                            tag:
                                                                                chat.key.toString(),
                                                                            child:
                                                                                Container(
                                                                              width: Get.height * 0.3,
                                                                              height: Get.height * 0.4,
                                                                              child: Stack(
                                                                                children: [
                                                                                  Container(
                                                                                    width: Get.height * 0.3,
                                                                                    height: Get.height * 0.4,
                                                                                    decoration: BoxDecoration(
                                                                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                                                      image: DecorationImage(image: FileImage(File(chat.imagePath.toString()
                                                                                          //  pickedFile!.path.toString()

                                                                                          )), fit: BoxFit.cover),
                                                                                    ),
                                                                                    //  child: Image.memory(pickedFile!.bytes!),
                                                                                  ),
                                                                                  //  chat.fileDownloaded == "downloded" || chat.fileDownloaded == 'uploded' ? Container() : Positioned(bottom: 10, left: 10, child: uplodingFileInProgress.value == true ? CircularProgressIndicator.adaptive() : Container())
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : Container(
                                                                          width:
                                                                              Get.height * 0.3,
                                                                          height:
                                                                              Get.height * 0.4,
                                                                          child:
                                                                              Stack(
                                                                            children: [
                                                                              customNetworkImage(imagePathOnline.toString(), fit: BoxFit.cover),
                                                                              Positioned(
                                                                                child: GestureDetector(
                                                                                  onTap: _downloadFile,
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: Icon(
                                                                                      CupertinoIcons.arrow_down_doc_fill,
                                                                                      size: 40,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),

                                                                  // FutureBuilder(
                                                                  //     future:
                                                                  //         storage.getFileView(
                                                                  //       bucketId: chatsMedia,
                                                                  //       fileId: chat.imagePath.toString(),
                                                                  //     ), //works for both public file and private file, for private files you need to be logged in
                                                                  //     builder:
                                                                  //         (context, snapshot) {
                                                                  //       return snapshot.hasData && snapshot.data != null
                                                                  //           ? Image.memory(snapshot.data as Uint8List, width: Get.height * 0.3, height: Get.height * 0.4, fit: BoxFit.cover)
                                                                  //           : Center(
                                                                  //               child: SizedBox(
                                                                  //               width: Get.height * 0.2,
                                                                  //               height: Get.height * 0.2,
                                                                  //               child: LoadingIndicator(
                                                                  //                   indicatorType: Indicator.ballTrianglePath,

                                                                  //                   /// Required, The loading type of the widget
                                                                  //                   colors: const [Colors.pink, Colors.green, Colors.blue],

                                                                  //                   /// Optional, The color collections
                                                                  //                   strokeWidth: 0.5,

                                                                  //                   /// Optional, The stroke of the line, only applicable to widget which contains line
                                                                  //                   backgroundColor: Colors.transparent,

                                                                  //                   /// Optional, Background of the widget
                                                                  //                   pathBackgroundColor: Colors.blue

                                                                  //                   /// Optional, the stroke backgroundColor
                                                                  //                   ),
                                                                  //             )
                                                                  //               //  CircularProgressIndicator
                                                                  //               //     .adaptive()
                                                                  //               );
                                                                  //     },
                                                                  //   ),
                                                                  // chat.fileDownloaded ==
                                                                  //             "downloded" ||
                                                                  //         chat.senderId ==
                                                                  //             currentUser?.userId
                                                                  //     ? Container()
                                                                  //     : Center(
                                                                  //         child:
                                                                  //             Container(
                                                                  //           width: Get.height * 0.3,
                                                                  //           height: Get.height * 0.4,
                                                                  //           color: CupertinoColors.lightBackgroundGray.withOpacity(0.1),
                                                                  //           child: Stack(
                                                                  //             children: [
                                                                  //               Positioned(
                                                                  //                 bottom: 0,
                                                                  //                 left: 0,
                                                                  //                 child: Row(children: [
                                                                  //                   GestureDetector(
                                                                  //                     onTap: () async {
                                                                  //                       try {
                                                                  //                         loading.value = true;
                                                                  //                         final localMessage = chat;
                                                                  //                         //  await createFileRecursively('ViewDucts', 'https://6357.viewducts.com/v1/storage/buckets/$chatsMedia/files/${chat.imagePath}/download?project=62e0a2f7680479a72579');
                                                                  //                         await downloadFile(url: chat.imagePath, filename: '${DateTime.now().toUtc().toString().replaceAll(RegExp(r'\.\d*Z$'), 'Z').replaceAll(RegExp(r'[:-]|\.\d{3}'), '').split(' ').join('T')}.png');
                                                                  //                         chat.fileDownloaded = 'downloded';
                                                                  //                         localMessage.fileDownloaded = 'downloded';
                                                                  //                         localMessage.imagePath = savedFile?.path.toString();

                                                                  //                         await chatState.updateDownlodImageMessage(chat: chat, currentUser: currentUser?.userId, secondUser: userProfileId, localMessage: localMessage);
                                                                  //                         loading.value = false;
                                                                  //                         cprint('image downloded');
                                                                  //                       } catch (e) {
                                                                  //                         cprint(e.toString());
                                                                  //                       }
                                                                  //                     },
                                                                  //                     child: Padding(
                                                                  //                       padding: const EdgeInsets.all(8.0),
                                                                  //                       child: Icon(
                                                                  //                         CupertinoIcons.arrow_down_doc_fill,
                                                                  //                         size: 40,
                                                                  //                       ),
                                                                  //                     ),
                                                                  //                   ),
                                                                  //                   chat.fileDownloaded == "downloded" || chat.senderId == currentUser?.userId
                                                                  //                       ? Container()
                                                                  //                       : loading.value == true
                                                                  //                           ? CircularProgressIndicator.adaptive(
                                                                  //                               value: progress.value.value,
                                                                  //                             )
                                                                  //                           : Container(),
                                                                  //                 ]),
                                                                  //               )
                                                                  //             ],
                                                                  //           ),
                                                                  //         ),
                                                                  //       )
                                                                ],
                                                              ),
                                                              //                                                                 CachedNetworkImage(
                                                              //                                                                     imageUrl: chat
                                                              //                                                                         .imagePath
                                                              //                                                                         .toString(),
                                                              //                                                                     width:
                                                              //                                                                         Get.height *
                                                              //                                                                             0.3,
                                                              //                                                                     height:
                                                              //                                                                         Get.height *
                                                              //                                                                             0.4,
                                                              //                                                                     fit: BoxFit
                                                              //                                                                         .cover),
                                                              // _imageFeed(chat.imagePath),
                                                              // chat.message ==
                                                              //             null ||
                                                              //         chat.message ==
                                                              //             ''
                                                              //     ? Container()
                                                              //     : frostedTeal(
                                                              //         Padding(
                                                              //           padding:
                                                              //               const EdgeInsets.all(8.0),
                                                              //           child:
                                                              //               UrlText(
                                                              //             text:
                                                              //                 (chat.message),
                                                              //             style:
                                                              //                 TextStyle(
                                                              //               fontSize: 16,
                                                              //               color: myMessage ? TwitterColor.black : Colors.black,
                                                              //             ),
                                                              //             urlStyle:
                                                              //                 TextStyle(
                                                              //               fontSize: 16,
                                                              //               color: myMessage ? TwitterColor.white : TwitterColor.dodgetBlue,
                                                              //               decoration: TextDecoration.underline,
                                                              //             ),
                                                              //           ),
                                                              //         ),
                                                              //       ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : chat.type ==
                                                          MessagesType
                                                              .Document.index
                                                      ? Container()
                                                      : chat.type ==
                                                              MessagesType
                                                                  .Audio.index
                                                          ? Column(
                                                              crossAxisAlignment:
                                                                  myMessage
                                                                      ? CrossAxisAlignment
                                                                          .end
                                                                      : CrossAxisAlignment
                                                                          .start,
                                                              mainAxisAlignment:
                                                                  myMessage
                                                                      ? MainAxisAlignment
                                                                          .end
                                                                      : MainAxisAlignment
                                                                          .start,
                                                              children: [
                                                                chat.fileDownloaded ==
                                                                            "downloded" ||
                                                                        chat.senderId ==
                                                                            currentUser?.userId
                                                                    ? GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          // seenMessagesState.value =
                                                                          //     true;
                                                                          // cprint('${chat.audioFile} audio');
                                                                          // _audioPlayer(
                                                                          //     context,
                                                                          //     chat.audioFile.toString(),
                                                                          //     false);
                                                                        },
                                                                        child: Wrap(
                                                                            children: [
                                                                              Icon(
                                                                                CupertinoIcons.music_note_2,
                                                                                color: CupertinoColors.lightBackgroundGray,
                                                                                size: 50,
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(5.0),
                                                                                child: Container(
                                                                                    decoration: BoxDecoration(boxShadow: [
                                                                                      BoxShadow(offset: const Offset(0, 11), blurRadius: 11, color: Colors.black.withOpacity(0.06))
                                                                                    ], borderRadius: BorderRadius.circular(18), color: CupertinoColors.systemOrange),
                                                                                    padding: const EdgeInsets.all(5.0),
                                                                                    child: TitleText('Audio File >')),
                                                                              ),
                                                                            ]),
                                                                      )
                                                                    : GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          // seenMessagesState.value =
                                                                          //     true;
                                                                          // cprint('${chat.audioFile} audio');
                                                                          // _audioPlayer(
                                                                          //     context,
                                                                          //     chat.audioFile.toString(),
                                                                          //     true);
                                                                        },
                                                                        child: Wrap(
                                                                            children: [
                                                                              Icon(
                                                                                CupertinoIcons.music_note_2,
                                                                                color: CupertinoColors.lightBackgroundGray,
                                                                                size: 50,
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(5.0),
                                                                                child: Container(
                                                                                    decoration: BoxDecoration(boxShadow: [
                                                                                      BoxShadow(offset: const Offset(0, 11), blurRadius: 11, color: Colors.black.withOpacity(0.06))
                                                                                    ], borderRadius: BorderRadius.circular(18), color: CupertinoColors.systemOrange),
                                                                                    padding: const EdgeInsets.all(5.0),
                                                                                    child: TitleText('Audio File >')),
                                                                              ),
                                                                            ]),
                                                                      ),
                                                              ],
                                                            )
                                                          : chat.type ==
                                                                  MessagesType
                                                                      .VoiceMessage
                                                                      .index
                                                              ? Container()
                                                              : chat.type ==
                                                                      MessagesType
                                                                          .Video
                                                                          .index
                                                                  ? Column(
                                                                      crossAxisAlignment: myMessage
                                                                          ? CrossAxisAlignment
                                                                              .end
                                                                          : CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment: myMessage
                                                                          ? MainAxisAlignment
                                                                              .end
                                                                          : MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        chat.fileDownloaded == "downloded" ||
                                                                                chat.senderId == currentUser?.userId
                                                                            ? Wrap(
                                                                                children: [
                                                                                  Hero(
                                                                                    tag: chat.key.toString(),
                                                                                    child: Center(
                                                                                      child: frostedWhite(
                                                                                        Container(
                                                                                          decoration: BoxDecoration(boxShadow: [
                                                                                            BoxShadow(offset: const Offset(0, 11), blurRadius: 11, color: Colors.black.withOpacity(0.06))
                                                                                          ], borderRadius: BorderRadius.circular(18), color: CupertinoColors.darkBackgroundGray),
                                                                                          padding: const EdgeInsets.all(5.0),
                                                                                          width: MediaQuery.of(context).size.height * 0.4,
                                                                                          height: MediaQuery.of(context).size.height * 0.25,
                                                                                          child: Stack(
                                                                                            children: [
                                                                                              VideoUploadAdmin(
                                                                                                isLocal: true,
                                                                                                chat: chat,

                                                                                                // playNow: true,
                                                                                                videoFile: File(chat.videoKey.toString()),
                                                                                                videoPath: chat.videoKey.toString(),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              )
                                                                            : Wrap(
                                                                                children: [
                                                                                  Hero(
                                                                                    tag: chat.key.toString(),
                                                                                    child: Center(
                                                                                      child: Container(
                                                                                        decoration: BoxDecoration(boxShadow: [
                                                                                          BoxShadow(offset: const Offset(0, 11), blurRadius: 11, color: Colors.black.withOpacity(0.06))
                                                                                        ], borderRadius: BorderRadius.circular(18), color: CupertinoColors.darkBackgroundGray),
                                                                                        padding: const EdgeInsets.all(5.0),
                                                                                        width: MediaQuery.of(context).size.height * 0.4,
                                                                                        height: MediaQuery.of(context).size.height * 0.25,
                                                                                        child: Stack(
                                                                                          children: [
                                                                                            VideoUploadAdmin(
                                                                                              // isLocal: true,
                                                                                              isChatOnline: true,
                                                                                              chat: chat,
                                                                                              // playNow: true,
                                                                                              videoFile: File(chat.videoKey.toString()),
                                                                                              videoPath: chat.videoKey.toString(),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                      ],
                                                                    )
                                                                  : Column(
                                                                      crossAxisAlignment: myMessage
                                                                          ? CrossAxisAlignment
                                                                              .end
                                                                          : CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        chat.seen ==
                                                                                'deleted'
                                                                            ? myMessage
                                                                                ? Container()
                                                                                : Container(
                                                                                    decoration: BoxDecoration(
                                                                                      boxShadow: [
                                                                                        BoxShadow(offset: const Offset(0, 11), blurRadius: 11, color: Colors.black.withOpacity(0.06))
                                                                                      ],
                                                                                      borderRadius: BorderRadius.circular(18),
                                                                                    ),
                                                                                    child: BubbleSpecialThree(isSender: false, tail: true, color: CupertinoColors.systemRed, text: 'message deleted', textStyle: TextStyle(fontStyle: FontStyle.italic)),
                                                                                  )
                                                                            : myMessage
                                                                                ? Container(
                                                                                    decoration: BoxDecoration(
                                                                                      boxShadow: [
                                                                                        BoxShadow(offset: const Offset(0, 11), blurRadius: 11, color: Colors.black.withOpacity(0.06))
                                                                                      ],
                                                                                      borderRadius: BorderRadius.circular(18),
                                                                                    ),
                                                                                    child: BubbleSpecialThree(
                                                                                      color: Colors.black54,
                                                                                      text: TextEncryptDecrypt.decryptAES(chat.message),
                                                                                      textStyle: onPrimarySubTitleText.copyWith(color: Colors.orange.shade100),
                                                                                    ),
                                                                                  )
                                                                                : Container(
                                                                                    decoration: BoxDecoration(
                                                                                      boxShadow: [
                                                                                        BoxShadow(offset: const Offset(0, 11), blurRadius: 11, color: Colors.black.withOpacity(0.06))
                                                                                      ],
                                                                                      borderRadius: BorderRadius.circular(18),
                                                                                    ),
                                                                                    child: BubbleSpecialThree(
                                                                                      isSender: false,
                                                                                      tail: true,
                                                                                      color: TwitterColor.mystic,
                                                                                      text: TextEncryptDecrypt.decryptAES(chat.message),
                                                                                    ),
                                                                                  )
                                                                      ],
                                                                    ),
                                ),
                                // chat.type == 2
                                //     ? Positioned(
                                //         right: 0,
                                //         top: 0,
                                //         child: Image.asset(
                                //           'assets/carts.png',
                                //           width: Get.width * 0.05,
                                //         ),
                                //       )
                                //     : Container()
                              ],
                            ),
                          ),
                        ],
                      ),
            Padding(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: Row(
                mainAxisAlignment:
                    myMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
                crossAxisAlignment: myMessage
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  myMessage
                      ? chat.seen == 'true'
                          //  DateTime.parse(chatState.onlineStatus.value.seenChat
                          //                 .toString())
                          //             .isAfter(DateTime.parse(chat.createdAt)) ==
                          //         true
                          //  int.tryParse(chatState.onlineStatus.value.userSeen) ==
                          //         int.tryParse(chat.createdAt.toString())
                          // chat.seen is bool && chat.seen == true
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 2),
                              child: SizedBox(
                                  height: Get.height * 0.025,
                                  width: Get.height * 0.025,
                                  child: Icon(Icons.done_all,
                                      color: Colors.blue,
                                      size: Get.height * 0.025)),
                            )
                          : chat.seen == 'false'
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 2),
                                  child: SizedBox(
                                    height: Get.height * 0.025,
                                    width: Get.height * 0.025,
                                    child: Icon(Icons.done,
                                        color: Colors.grey,
                                        size: Get.height * 0.025),
                                  ),
                                )
                              : Container()
                      : Container(),

                  // getReadStatus(onlineStatus, chat.receiverId),
                  chat.seen == 'deleted'
                      ? Container()
                      : Text(
                          // DateFormat('h:mm a').format(
                          //         DateTime.fromMillisecondsSinceEpoch(chat.timeStamp))
                          getChatTime(chat.createdAt) + (myMessage ? ' ' : ''),
                          style: TextStyle(
                            color: myMessage
                                ? Colors.blueGrey.withOpacity(0.8)
                                : viewductBlack,
                          )),
                  SingleChildScrollView(
                      child: Row(children: [
                    chat.senderReactions == ReactionType.Love.index
                        ? Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: chat.senderReactions ==
                                      ReactionType.Empty.index
                                  ? Colors.transparent
                                  : Colors.white60,
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(100.0)),
                            ),
                            child:
                                Image.asset('assets/heartlove.png', height: 12),
                          )
                        : chat.senderReactions == ReactionType.Like.index
                            ? Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: chat.senderReactions ==
                                          ReactionType.Empty.index
                                      ? Colors.transparent
                                      : Colors.white60,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(100.0)),
                                ),
                                child: Image.asset('assets/like  (1).png',
                                    height: 12),
                              )
                            : chat.senderReactions ==
                                    ReactionType.Delicious.index
                                ? Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: chat.senderReactions ==
                                              ReactionType.Empty.index
                                          ? Colors.transparent
                                          : Colors.white60,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(100.0)),
                                    ),
                                    child: Image.asset('assets/delicious.png',
                                        height: 12),
                                  )
                                : chat.senderReactions ==
                                        ReactionType.Smile.index
                                    ? Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: chat.senderReactions ==
                                                  ReactionType.Empty.index
                                              ? Colors.transparent
                                              : Colors.white60,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(100.0)),
                                        ),
                                        child: Image.asset('assets/happy.png',
                                            height: 12),
                                      )
                                    : chat.senderReactions ==
                                            ReactionType.Sad.index
                                        ? Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: chat.reactions ==
                                                      ReactionType.Empty.index
                                                  ? Colors.transparent
                                                  : Colors.white60,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(100.0)),
                                            ),
                                            child: Image.asset('assets/sad.png',
                                                height: 20),
                                          )
                                        : const Text(''),
                    chat.receiverReactions == ReactionType.Love.index
                        ? Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: chat.receiverReactions ==
                                      ReactionType.Empty.index
                                  ? Colors.transparent
                                  : Colors.white60,
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(100.0)),
                            ),
                            child:
                                Image.asset('assets/heartlove.png', height: 20),
                          )
                        : chat.receiverReactions == ReactionType.Like.index
                            ? Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: chat.receiverReactions ==
                                          ReactionType.Empty.index
                                      ? Colors.transparent
                                      : Colors.white60,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(100.0)),
                                ),
                                child: Image.asset('assets/like  (1).png',
                                    height: 20),
                              )
                            : chat.receiverReactions ==
                                    ReactionType.Delicious.index
                                ? Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: chat.receiverReactions ==
                                              ReactionType.Empty.index
                                          ? Colors.transparent
                                          : Colors.white60,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(100.0)),
                                    ),
                                    child: Image.asset('assets/delicious.png',
                                        height: 20),
                                  )
                                : chat.receiverReactions ==
                                        ReactionType.Smile.index
                                    ? Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: chat.receiverReactions ==
                                                  ReactionType.Empty.index
                                              ? Colors.transparent
                                              : Colors.white60,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(100.0)),
                                        ),
                                        child: Image.asset('assets/happy.png',
                                            height: 20),
                                      )
                                    : chat.receiverReactions ==
                                            ReactionType.Sad.index
                                        ? Container(
                                            padding: const EdgeInsets.all(5),
                                            decoration: BoxDecoration(
                                              color: chat.receiverReactions ==
                                                      ReactionType.Empty.index
                                                  ? Colors.transparent
                                                  : Colors.white60,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(100.0)),
                                            ),
                                            child: Image.asset('assets/sad.png',
                                                height: 20),
                                          )
                                        : const Text(''),
                  ])),
                ],
              ),
              // Text(
              //   getChatTime(chat.createdAt),
              //   style: Theme.of(context).textTheme.caption.copyWith(fontSize: 12),
              // ),
            ),
          ],
        ),
      );
    }

    List<Widget> likes(ChatMessage chat) {
      return [
        GestureDetector(
          onTap: () async {
            seenMessagesState.value = true;
            Navigator.pop(context);

            // await chatState.onMessageUpdate(
            //     chat, chat.key, chat.senderId, chat.receiverId, 0);
            // cprint('reaction heart');
            // chatState.chatMessage.value =
            //     await SQLHelper.findLocalMessages(chat.chatlistKey.toString());
          },
          child: Image.asset(
            'assets/heartlove.png',
            height: Get.height * 0.05,
          ),
        ),
        SizedBox(
          width: Get.width * 0.04,
        ),
        GestureDetector(
          onTap: () async {
            seenMessagesState.value = true;
            Navigator.pop(context);
            // await chatState.onMessageUpdate(
            //     chat, chat.key, chat.senderId, chat.receiverId, 3);
            // cprint('reaction added');
            // chatState.chatMessage.value =
            //     await SQLHelper.findLocalMessages(chat.chatlistKey.toString());
          },
          child: Image.asset(
            'assets/happy.png',
            height: Get.height * 0.05,
          ),
        ),
        SizedBox(
          width: Get.width * 0.04,
        ),
        GestureDetector(
          onTap: () async {
            seenMessagesState.value = true;
            Navigator.pop(context);
            // await chatState.onMessageUpdate(
            //     chat, chat.key, chat.senderId, chat.receiverId, 2);
            // cprint('reaction added');
            // chatState.chatMessage.value =
            //     await SQLHelper.findLocalMessages(chat.chatlistKey.toString());
          },
          child: Image.asset(
            'assets/delicious.png',
            height: Get.height * 0.05,
          ),
        ),
        SizedBox(
          width: Get.width * 0.04,
        ),
        GestureDetector(
          onTap: () async {
            seenMessagesState.value = true;
            Navigator.pop(context);
            // await chatState.onMessageUpdate(
            //     chat, chat.key, chat.senderId, chat.receiverId, 1);
            // cprint('reaction added');
            // chatState.chatMessage.value =
            //     await SQLHelper.findLocalMessages(chat.chatlistKey.toString());
          },
          child: Image.asset(
            'assets/like  (1).png',
            height: Get.height * 0.05,
          ),
        ),
        SizedBox(
          width: Get.width * 0.04,
        ),
        GestureDetector(
          onTap: () async {
            seenMessagesState.value = true;
            Navigator.pop(context);
            // await chatState.onMessageUpdate(
            //     chat, chat.key, chat.senderId, chat.receiverId, 4);
            // cprint('reaction added');
            // chatState.chatMessage.value =
            //     await SQLHelper.findLocalMessages(chat.chatlistKey.toString());
          },
          child: Image.asset(
            'assets/sad.png',
            height: Get.height * 0.05,
          ),
        ),
      ];
    }

    chatMessage(ChatMessage message, BuildContext context,
        {bool saved = false, List<Message>? savedMsgs}) {
      if (message.senderId == currentUser?.userId.toString()) {
        return DuctMenuHolder(
            chat: message,
            msgkey: message.key,
            reciverId: message.receiverId,
            onPressed: () {},
            menuItems: <DuctFocusedMenuItem>[
              DuctFocusedMenuItem(
                backgroundColor: CupertinoColors.systemYellow,
                title: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: likes(message),
                  ),
                ),
                onPressed: () {},
              ),
              message.audioFile != null
                  ? DuctFocusedMenuItem(
                      title: Text("Back"),
                      onPressed: () {},
                      trailingIcon: const Icon(CupertinoIcons.back))
                  : message.imagePath != null
                      ? DuctFocusedMenuItem(
                          title: Text("Back"),
                          onPressed: () {},
                          trailingIcon: const Icon(CupertinoIcons.back))
                      : message.videoKey != null
                          ? DuctFocusedMenuItem(
                              title: Text("Back"),
                              onPressed: () {},
                              trailingIcon: const Icon(CupertinoIcons.back))
                          : DuctFocusedMenuItem(
                              title: const Text('Copy'),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(
                                    text: TextEncryptDecrypt.decryptAES(
                                        message.message)));
                              },
                              trailingIcon:
                                  const Icon(CupertinoIcons.add_circled_solid)),
              DuctFocusedMenuItem(
                  title: const Text('Reply'),
                  onPressed: () {
                    replyMessage!.value = message;
                    swipeMessage(message);
                    FocusScope.of(context).requestFocus(textFieldFocus);
                  },
                  trailingIcon: const Icon(CupertinoIcons.reply)),
              DuctFocusedMenuItem(
                  title: const Text('Delete'),
                  backgroundColor: CupertinoColors.systemRed,
                  onPressed: () {
                    // chatState.deleteMessage(
                    //     chat: message,
                    //     currentUser: currentUser?.userId,
                    //     secondUser: widget.userProfileId);
                  },
                  trailingIcon: const Icon(CupertinoIcons.delete)),
            ],
            child: _messages(message, true, context));
      } else {
        return DuctMenuHolder(
            chat: message,
            msgkey: message.key,
            reciverId: message.senderId,
            onPressed: () {},
            menuItems: <DuctFocusedMenuItem>[
              DuctFocusedMenuItem(
                backgroundColor: CupertinoColors.systemYellow,
                title: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: likes(message),
                  ),
                ),
                onPressed: () {},
              ),
              message.audioFile != null
                  ? DuctFocusedMenuItem(
                      title: Text("Back"),
                      onPressed: () {},
                      trailingIcon: const Icon(CupertinoIcons.back))
                  : message.imagePath != null
                      ? DuctFocusedMenuItem(
                          title: Text("Back"),
                          onPressed: () {},
                          trailingIcon: const Icon(CupertinoIcons.back))
                      : message.videoKey != null
                          ? DuctFocusedMenuItem(
                              title: Text("Back"),
                              onPressed: () {},
                              trailingIcon: const Icon(CupertinoIcons.back))
                          : DuctFocusedMenuItem(
                              title: const Text('Copy'),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(
                                    text: TextEncryptDecrypt.decryptAES(
                                        message.message)));
                              },
                              trailingIcon:
                                  const Icon(CupertinoIcons.add_circled_solid)),
              DuctFocusedMenuItem(
                  title: const Text('Reply'),
                  onPressed: () {
                    replyMessage?.value = message;
                    swipeMessage(message);
                    FocusScope.of(context).requestFocus(textFieldFocus);
                    // Get.back();

                    // swipeMessage(message);
                    // setState(() {});
                    // textFieldFocus.nextFocus();
                  },
                  trailingIcon: const Icon(CupertinoIcons.reply)),
              DuctFocusedMenuItem(
                  title: const Text('Delete'),
                  backgroundColor: CupertinoColors.systemRed,
                  onPressed: () async {
                    await SQLHelper.deletLocalMessage(message);
                    // chatState.chatMessage.value =
                    //     await SQLHelper.findLocalMessages(
                    //         message.chatlistKey.toString());
                    // chatState.deleteMessage(
                    //     chat: message,
                    //     currentUser: currentUser?.userId,
                    //     secondUser: userProfileId);
                  },
                  trailingIcon: const Icon(CupertinoIcons.delete)),
            ],
            child: _messages(message, false, context));
      }
    }

    getWhen(String? time) {
      if (time == null || time.isEmpty) {
        return '';
      }
      var date = DateTime.parse(time).toLocal();
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

    Widget _widgetBottomSheetRow(BuildContext context, int icon,
        {String? text, Function? onPressed, bool isEnable = false}) {
      return Expanded(
        child: customInkWell(
          context: context,
          onPressed: () {
            if (onPressed != null) {
              onPressed();
            } else {
              Navigator.pop(context);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: <Widget>[
                customIcon(
                  context,
                  icon: icon,
                  istwitterIcon: true,
                  size: 25,
                  paddingIcon: 8,
                  iconColor: isEnable ? Colors.teal : AppColor.lightGrey,
                ),
                const SizedBox(
                  width: 15,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blueGrey[50],
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.2),
                        Colors.black.withOpacity(0.3)
                        // Color(0xfffbfbfb),
                        // Color(0xfff7f7f7),
                      ],
                      // begin: Alignment.topCenter,
                      // end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: customText(
                      text,
                      context: context,
                      style: TextStyle(
                        color: isEnable
                            ? Colors.orange.shade100
                            : AppColor.lightGrey,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    bool isBlocked() {
      return false;
      // chatState.onlineStatus.value.chatStatus ==
      //     ChatStatus.blocked.index;
    }

    // Widget _privacyView(
    //   BuildContext context,
    //   ChatState model,
    // ) {
    //   // var authState = Provider.of<AuthState>(context, listen: false);
    //   return Column(
    //     children: <Widget>[
    //       Container(
    //         width: Get.width * .1,
    //         height: 5,
    //         decoration: BoxDecoration(
    //           color: Theme.of(context).dividerColor,
    //           borderRadius: const BorderRadius.all(
    //             Radius.circular(10),
    //           ),
    //         ),
    //       ),

    //       // authState.userModel!.hidden!.contains(model.chatUser!.userId) == true
    //       //     ? _widgetBottomSheetRow(context, AppIcon.unFollow, onPressed: () {
    //       //         chatState.unhideChat(authState.userModel!.key.toString(), userProfileId);
    //       //       }, text: 'Unhide chat', isEnable: true)
    //       //     : _widgetBottomSheetRow(context, AppIcon.unFollow, onPressed: () {
    //       //         chatState.hideChat(authState.userModel!.key.toString(), userProfileId);
    //       //       }, text: 'Hide  chat', isEnable: true),
    //       // authState.userModel!.locked!.contains(model.chatUser!.userId)
    //       //     ? _widgetBottomSheetRow(context, AppIcon.unFollow, onPressed: () {
    //       //         chatState.unlockChat(authState.userModel!.key.toString(), userProfileId);
    //       //       }, text: 'Unlock  chat', isEnable: true)
    //       //     : _widgetBottomSheetRow(context, AppIcon.unFollow, onPressed: () {
    //       //         chatState.lockChat(authState.userModel!.key.toString(), userProfileId);
    //       //       }, text: 'Lock  chat', isEnable: true),
    //       isBlocked()
    //           ? _widgetBottomSheetRow(context, AppIcon.unFollow, onPressed: () {
    //               chatState.accept(authState.userModel!.key.toString(),
    //                   widget.userProfileId);
    //             },
    //               text: 'Unblock ${model.chatUser!.displayName}',
    //               isEnable: true)
    //           : _widgetBottomSheetRow(context, AppIcon.block, onPressed: () {
    //               chatState.block(authState.userModel!.key.toString(),
    //                   widget.userProfileId!);
    //             },
    //               text: 'Block ${model.chatUser!.displayName}', isEnable: true),
    //       _widgetBottomSheetRow(context, AppIcon.report,
    //           text: 'Report Store', isEnable: true),
    //       // case 'hide':

    //       //                                 break;
    //       //                               case 'unhide':
    //       //                                 chatState.unhideChat(
    //       //                                     authState.userModel.userId,
    //       //                                     chatState.chatUser.userId);
    //       //                                 break;
    //       //                               case 'lock':

    //       //                                 break;
    //       //                               case 'unlock':
    //       //                                 chatState.unlockChat(
    //       //                                     authState.userModel.userId,
    //       //                                     chatState.chatUser.userId);
    //       //                                 break;
    //       //                               case 'block':

    //       //                                 break;
    //       //                               case 'unblock':
    //       //                                 chatState.accept(
    //       //                                     authState.userModel.userId,
    //       //                                     chatState.chatUser.userId);
    //       //                                 ViewDucts.toast('Unblocked.');
    //     ],
    //   );
    // }

    // void _postProsductoption() {
//     OverlayEntry _createPostMenu(BuildContext context) {
//       // var chatState = Provider.of<ChatState>(context, listen: false);
//       // // double heightFactor = 300 / Get.height;
//       // var authState = Provider.of<AuthState>(context, listen: false);
//       // var feedState = Provider.of<FeedState>(context, listen: false);

//       // var userImage = chatState.chatUser.profilePic;
//       // String id = userProfileId ?? chatState.chatUser.userId;

//       FeedModel? model;
//       return OverlayEntry(
//         builder: (context) {
//           return GetX<FeedState>(builder: (_) {
//             List<FeedModel>? list =
//                 feedState.getStoreProductList(authState.userId);

//             if (feedState.feedlist != null && feedState.feedlist!.isNotEmpty) {
//               list = feedState.getStoreProductList(authState.userId);
//               // .where((x) => x.userId == id)
//               // .toList();
//             }
//             return GestureDetector(
//               onTap: () {
//                 if (isDropdown.value) {
//                   floatingMenu.remove();
//                 } else {
//                   // _postProsductoption();
//                   floatingMenu = _createPostMenu(context);
//                   Overlay.of(context)!.insert(floatingMenu);
//                 }

//                 isDropdown.value = !isDropdown.value;
//               },
//               child: Material(
//                 color: Colors.transparent,
//                 child: frostedWhite(
//                   SizedBox(
//                     height: Get.width,
//                     width: Get.width,
//                     child: Stack(
//                       children: [
//                         Positioned(
//                           top: Get.width * 0.1,
// //                        right: xPosiion - Get.width * 0.5,
//                           right: xPosiion,
//                           // width: width,
//                           // height: 4 + height + 40,
//                           child: SizedBox(
//                             //  height: Get.width * 0.4,
//                             width: Get.width,
//                             child: Stack(
//                               children: [
//                                 Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Row(
//                                         children: [
//                                           customTitleText(
//                                             'ViewShare with',
//                                           ),
//                                           frostedPink(
//                                             Padding(
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: customTitleText(
//                                                 '${chatState.chatUser!.displayName}',
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     const Divider(),
//                                     Column(
//                                       children: [
//                                         Row(
//                                           children: [
//                                             frostedTeal(
//                                               const Padding(
//                                                 padding: EdgeInsets.all(8.0),
//                                                 child: Text('Your Orders',
//                                                     style: TextStyle(
//                                                       fontSize: 16,
//                                                     )),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         Row(
//                                           children: [
//                                             list == null
//                                                 ? Column(
//                                                     children: [
//                                                       Padding(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                 .all(8.0),
//                                                         child: Text(
//                                                             'You haven\'t order a product yet',
//                                                             style: TextStyle(
//                                                               fontSize: fullWidth(
//                                                                       context) *
//                                                                   0.05,
//                                                             )),
//                                                       ),
//                                                       ButtonTheme(
//                                                         height: 45.0,
//                                                         minWidth: 100.0,
//                                                         shape: const RoundedRectangleBorder(
//                                                             borderRadius:
//                                                                 BorderRadius.all(
//                                                                     Radius.circular(
//                                                                         7.0))),
//                                                         // ignore: deprecated_member_use
//                                                         child: ElevatedButton(
//                                                           // color: const Color(
//                                                           //     0xff313134),
//                                                           onPressed: () async {
//                                                             if (isDropdown
//                                                                 .value) {
//                                                               floatingMenu
//                                                                   .remove();
//                                                             } else {
//                                                               // _postProsductoption();
//                                                               floatingMenu =
//                                                                   _createPostMenu(
//                                                                       context);
//                                                               Overlay.of(
//                                                                       context)!
//                                                                   .insert(
//                                                                       floatingMenu);
//                                                             }

//                                                             isDropdown.value =
//                                                                 !isDropdown
//                                                                     .value;

//                                                             Navigator.of(
//                                                                     context)
//                                                                 .push(
//                                                               MaterialPageRoute(
//                                                                   builder:
//                                                                       (context) =>
//                                                                           Home()),
//                                                             );

//                                                             //   Map<String,dynamic> args = new Map();
//                                                             // //  Loader.showLoadingScreen(context, _keyLoader);
//                                                             //   List<Map<String,String>> categoryList = await _productService.listCategories();
//                                                             //   args['category'] = categoryList;
//                                                             //   Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
//                                                             //   Navigator.pushReplacementNamed(context, '/shop',arguments: args);
//                                                           },
//                                                           child: const Text(
//                                                             'Shop',
//                                                             style: TextStyle(
//                                                                 color: Colors
//                                                                     .white,
//                                                                 fontSize: 20.0,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                       const SizedBox(
//                                                         height: 20,
//                                                       )
//                                                     ],
//                                                   )
//                                                 : SizedBox(
//                                                     width: Get.width * 0.8,
//                                                     height: Get.width * 0.5,
//                                                     child: ListView.builder(
//                                                       scrollDirection:
//                                                           Axis.horizontal,
//                                                       addAutomaticKeepAlives:
//                                                           false,
//                                                       physics:
//                                                           const BouncingScrollPhysics(),
//                                                       itemBuilder:
//                                                           (context, index) =>
//                                                               Padding(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                 .all(8.0),
//                                                         child: SizedBox(
//                                                             height:
//                                                                 fullWidth(
//                                                                         context) *
//                                                                     0.5,
//                                                             width: fullWidth(
//                                                                     context) *
//                                                                 0.5,
//                                                             child: Padding(
//                                                               padding:
//                                                                   const EdgeInsets
//                                                                           .only(
//                                                                       bottom:
//                                                                           12.0),
//                                                               child:
//                                                                   GestureDetector(
//                                                                 onTap: () {
//                                                                   if (isSelected
//                                                                       .value) {
//                                                                     chatUserProductId =
//                                                                         null;
//                                                                     ductId =
//                                                                         null;
//                                                                     myOrders
//                                                                         .value
//                                                                         .value = list![
//                                                                             index]
//                                                                         .key
//                                                                         .toString();
//                                                                     isSelected
//                                                                         .value;
//                                                                   } else {
//                                                                     myOrders
//                                                                         .value
//                                                                         .value = list![
//                                                                             index]
//                                                                         .key
//                                                                         .toString();
//                                                                     isSelected
//                                                                             .value =
//                                                                         !isSelected
//                                                                             .value;
//                                                                   }

//                                                                   if (isDropdown
//                                                                       .value) {
//                                                                     floatingMenu
//                                                                         .remove();
//                                                                   } else {
//                                                                     // _postProsductoption();
//                                                                     floatingMenu =
//                                                                         _createPostMenu(
//                                                                             context);
//                                                                     Overlay.of(
//                                                                             context)!
//                                                                         .insert(
//                                                                             floatingMenu);
//                                                                   }

//                                                                   isDropdown
//                                                                           .value =
//                                                                       !isDropdown
//                                                                           .value;
//                                                                 },
//                                                                 child: _StoreProducts(
//                                                                     list: list![index],
//                                                                     //   isSelected: isSelected,
//                                                                     model: model),
//                                                               ),
//                                                             )),
//                                                       ),
//                                                       itemCount: list.length,
//                                                     ),
//                                                   ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           });
//         },
//       );
//     }

    addMediaModal(context) {
      showModalBottomSheet(
          context: context,
          elevation: 0,
          backgroundColor: Colors.transparent,

          //  backgroundColor: Colors.black,
          // UniversalVariables.blackColor,
          builder: (context) {
            return frostedTeal(
              Column(
                children: <Widget>[
                  Flexible(
                    child: ListView(
                      children: <Widget>[
                        ModalTile(
                          title: "Galary",
                          subtitle: "Share Photos and Video",
                          icon: Icons.image,
                          onTap: () => pickImage(source: ImageSource.gallery),
                        ),
                        ModalTile(
                          title: "Video",
                          subtitle: "Share Videos",
                          icon: Icons.tab,
                          onTap: () {},
                        ),
                        const ModalTile(
                          title: "Camera",
                          subtitle: "Share with Camera",
                          icon: Icons.contacts,
                        ),
                        ModalTile(
                          title: "Contacts",
                          subtitle: "Share Contacts",
                          icon: Icons.tab,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
    }

    void _onCrossThumbnail() async {
      imageFileState = null;
    }

    imagePreview(context) {
      setWritingTo(bool val) {
        isWriting.value = val;
      }

      showModalBottomSheet(
          context: context,
          elevation: 0,
          backgroundColor: Colors.transparent,

          //  backgroundColor: Colors.black,
          // UniversalVariables.blackColor,
          builder: (context) {
            return Material(
              color: Colors.transparent,
              child: frostedTeal(
                SizedBox(
                  width: Get.width,
                  child: Column(
                    children: <Widget>[
                      Flexible(
                        child: ListView(
                          children: <Widget>[
                            Stack(
                              children: [
                                SizedBox(
                                  height: Get.width,
                                  width: Get.width,
                                  child: FittedBox(
                                    child: ComposeThumbnail(
                                      image: imageFileState,
                                      onCrossIconPressed: _onCrossThumbnail,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  right: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: IconButton(
                                      onPressed: () => _onCrossThumbnail,
                                      color: Colors.black,
                                      icon: const Icon(
                                          CupertinoIcons.clear_circled_solid),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: Get.width * 0.25,
                                  right: 10,
                                  child: Container(
                                    height: Get.width * 0.1,
                                    width: Get.width * 0.1,
                                    margin: const EdgeInsets.only(left: 10),
                                    decoration: const BoxDecoration(
                                        color: Colors.blueGrey,
                                        //  gradient: UniversalVariables.fabGradient,
                                        shape: BoxShape.circle),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.send,
                                        color: Colors.white,
                                      ),
                                      onPressed: statusInit ==
                                              ChatStatus.blocked.index
                                          ? null
                                          : () async {
                                              // var chatState = Provider.of<FeedState>(
                                              //     context,
                                              //     listen: false);
                                              kScreenloader.showLoader(context);
                                              if (imageFileState != null) {
                                                // await feedState
                                                //     .uploadFile(_image!)
                                                //     .then((imagePath) {
                                                //   if (imagePath != null) {
                                                //     submitMessage(
                                                //         imageTextEditingController
                                                //             .text,
                                                //         MessagesType.Image,
                                                //         DateTime.now()
                                                //             .millisecondsSinceEpoch,
                                                //         null,
                                                //         context,
                                                //         null);
                                                //   }
                                                // });
                                              }
                                              kScreenloader.hideLoader();
                                              Navigator.maybePop(context);
                                            },
                                      //    color: viewductWhite,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: frostedOrange(
                          TextField(
                            controller: textEditingController,
                            focusNode: textFieldFocus,
                            onTap: () => hideEmojiContainer(),
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            onChanged: (val) {
                              (val.isNotEmpty && val.trim() != "")
                                  ? setWritingTo(true)
                                  : setWritingTo(false);
                            },
                            maxLines: null,
                            decoration: const InputDecoration(
                              hintText: "type a message",
                              hintStyle: TextStyle(color: Colors.yellow
//color: UniversalVariables.greyColor,
                                  ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(50.0),
                                  ),
                                  borderSide: BorderSide.none),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              filled: true,
//fillColor: UniversalVariables.separatorColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
    }

    Future<bool?> _showDialogs() {
      return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return frostedYellow(
            Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Colors.transparent,
              child: frostedYellow(
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      offset: const Offset(0, 11),
                                      blurRadius: 11,
                                      color: Colors.black.withOpacity(0.06))
                                ],
                                borderRadius: BorderRadius.circular(18),
                                color: CupertinoColors.white),
                            padding: const EdgeInsets.all(5.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.maybePop(context);
                              },
                              child: const Text(
                                'File Size Must be less than 50mb',
                                style: TextStyle(fontWeight: FontWeight.w200),
                              ),
                            )),
                      ),
                      // Container(
                      //   height: Get.height * 0.3,
                      //   width: Get.height * 0.2,
                      //   decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(20)),
                      //   child: SafeArea(
                      //     child: Stack(
                      //       children: <Widget>[
                      //         Center(
                      //           child: ModalTile(
                      //             title: "File Exceeds Limit",
                      //             subtitle: "Please reduce your file size",
                      //             icon: Icons.tab,
                      //             onTap: () async {
                      //               Navigator.maybePop(context);
                      //             },
                      //           ),
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    Future<bool?> _showDialog(BuildContext context) {
      //var appSize = MediaQuery.of(context).size;
      // final chatState = Provider.of<ChatState>(context);
      return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return frostedYellow(
            Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: frostedYellow(
                Container(
                  height: Get.width,
                  width: Get.width,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: SafeArea(
                    child: Stack(
                      children: <Widget>[
                        Center(
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  // child: Text(
                                  //   'Accept ${chatState.chatUser!.displayName}\'s invitation?',
                                  //   style: TextStyle(
                                  //       fontSize: 20,
                                  //       color: Colors.blueGrey[500]),
                                  // ),
                                ),
                                Container(
                                  height: 0.5,
                                  color: Colors.blueGrey[300],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Material(
                                        elevation: 20,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        shadowColor: Colors.yellow[50],
                                        child: frostedRed(
                                          // ignore: deprecated_member_use
                                          TextButton(
                                              child: const Text('Reject'),
                                              onPressed: () {
                                                // chatState.block(
                                                //     authState.userId!,
                                                //     widget.userProfileId!);

                                                statusInit =
                                                    ChatStatus.blocked.index;
                                              }),
                                        ),
                                      ),
                                      Material(
                                        elevation: 20,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        shadowColor: Colors.yellow[50],
                                        child: frostedGreen(
                                          // ignore: deprecated_member_use
                                          TextButton(
                                              child: const Text('Accept'),
                                              onPressed: () {
                                                // chatState.accept(
                                                //     currentUserNo, peerNo);

                                                statusInit =
                                                    ChatStatus.accepted.index;
                                              }),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    void _buyingDialog(BuildContext context) async {
      await showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          // var appSize = MediaQuery.of(context).size;

          // // double heightFactor = 300 / Get.height;
          // var authState = Provider.of<AuthState>(context, listen: false);
          // var chatState = Provider.of<FeedState>(context, listen: false);
          //      ViewductsUser model;
          return frostedWhite(
            Stack(
              children: [
                Material(
                  color: Colors.transparent,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: SizedBox(
                      width: Get.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.yellow),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: customTitleText('Pick at Store'),
                                    )),
                                // frostedOrange(
                                //   Padding(
                                //     padding: const EdgeInsets.all(8.0),
                                //     child: Text('Pick At Store',
                                //         style: TextStyle(
                                //             fontSize: 16, color: Colors.white)),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.teal[50]),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: customTitleText('Home Delivery'),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    Column addressColumn(OrderViewProduct? cartItem) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: const [
              Text(
                "Delivery address",
                style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            cartItem!.shippingAddress.toString(),
          ),
          const SizedBox(
            height: 10,
          ),
          // Text("Kimihurura")
        ],
      );
    }

    Widget invoiceHeader(OrderViewProduct? cartItem) {
      return frostedYellow(
        Container(
          width: Get.width,
          //  width: ScreenConfig.deviceWidth,
          //height: ScreenConfig.getProportionalHeight(374),
          color: Color(0xFFF3BB1C),
          padding: EdgeInsets.only(
            top: Get.width * 0.04,
            left: Get.width * 0.04,
            // right: ScreenConfig.getProportionalWidth(40)
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Get.width * 0.1,
                    ),
                    Text(
                      "Orders",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Get.width * 0.06),
                    ),
                    // SizedBox(
                    //   height: Get.width * 0.04,
                    // ),
                    // topHeaderText("#20/07/1203"),
                    SizedBox(
                      height: Get.width * 0.04,
                    ),

                    customText(
                      timeago.format(cartItem!.placedDate!.toDate()).toString(),
                    ),
                  ],
                ),
                SizedBox(
                  height: Get.width * 0.04,
                ),
                SizedBox(
                  width: Get.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "assets/groceries.png",
                        height: Get.width * 0.2,
                      ),
                      SizedBox(
                          width: Get.width * 0.7,
                          child: addressColumn(cartItem))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }

    Future<bool> _onWillPop() async {
      //   int chatState;
      //chatState.chatMessage.value = [];
      // chatState.chatMessage.value = [];
      // statusInit = await chatState.getStatus(
      //     authState.userModel!.key.toString(), widget.userProfileId!);
      // chatState.setLastSeen(
      //   authState.appUser!.$id,
      //   widget.userProfileId.toString(),
      // );
      // chatState.onlineStatus.value.chatOnlineChatStatus = null;
      // chatState.onlineStatus.value.seenChat = null;
      // chatState.onlineStatus.value = ChatOnlineStatus();
      // chatState.chatMessage.close();

      widget.dependency = true;
      // var authState = Provider.of<AuthState>(context, listen: false);
      // final chatState = Provider.of<ChatState>(context, listen: false);
      //await chatState.setLastSeen(chatState, authState.user.uid);
      //await chatState.justSettingLastSeen(authState.user.uid);
      // await chatState.lastSeen(
      //     chatState.chatUser.userId, authState.user.uid, chatState.chatUser.userId);
      // chatState.setIsChatScreenOpen = false;
      //  chatState.dispose();
      Get.back();
      return true;
    }

    save(Map<String, dynamic> doc) async {
      ViewDucts.toast('Saved');
      if (!_savedMessageDocs.any((_doc) => _doc[TIMESTAMP] == doc[TIMESTAMP])) {
        String? content;
        if (doc[TYPE] == MessageType.image.index) {
          content = doc[CONTENT].toString().startsWith('http')
              ? await Save.getBase64FromImage(imageUrl: doc[CONTENT] as String?)
              : doc[
                  CONTENT]; // if not a url, it is a base64 from saved messages
        } else {
          // If text
          content = doc[CONTENT];
        }
        doc[CONTENT] = content;

        Save.saveMessage(widget.userProfileId, doc);
        _savedMessageDocs.add(doc);

        _savedMessageDocs = List.from(_savedMessageDocs);
      }
    }

    Widget buildLoading() {
      return Positioned(
        child: isLoading
            ? Container(
                child: const Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(viewductBlue)),
                ),
                color: viewductBlack.withOpacity(0.8),
              )
            : Container(),
      );
    }

    contextMenu(Map<String, dynamic> doc, BuildContext context,
        {bool saved = false}) {
      List<Widget> tiles = <Widget>[];
      if (saved == false) {
        tiles.add(ListTile(
            dense: true,
            leading: const Icon(Icons.save_alt),
            title: const Text(
              'Save',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              save(doc);
              Navigator.pop(context);
            }));
      }
      if (doc[FROM] == currentUser?.userId.toString() && saved == false) {
        tiles.add(ListTile(
            dense: true,
            leading: const Icon(Icons.delete),
            title: const Text(
              'Delete',
              style: TextStyle(
                  color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              delete(doc[TIMESTAMP]);
              //  chatState.deleteMessages(doc);
              Navigator.pop(context);
              ViewDucts.toast('Deleted!');
            }));
      }
      if (saved == true) {
        tiles.add(ListTile(
            dense: true,
            leading: const Icon(Icons.delete),
            title: const Text(
              'Delete',
              style: TextStyle(
                  color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Save.deleteMessage(widget.userProfileId, doc);
              _savedMessageDocs
                  .removeWhere((msg) => msg[TIMESTAMP] == doc[TIMESTAMP]);

              _savedMessageDocs = List.from(_savedMessageDocs);

              Navigator.pop(context);
              ViewDucts.toast('Deleted!');
            }));
      }
      if (doc[TYPE] == MessageType.text.index) {
        tiles.add(ListTile(
            dense: true,
            leading: const Icon(Icons.content_copy),
            title: const Text(
              'Copy',
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Clipboard.setData(ClipboardData(text: doc[CONTENT]));
              Navigator.pop(context);
              ViewDucts.toast('Copied!');
            }));
      }
      showDialog(
        context: context,
        // builder: (context) {
        //   return SimpleDialog(children: tiles);
        // }
        builder: (context) {
          return Stack(
            children: [
              Positioned(
                top: Get.width * 0.5,
                left: 50,
                right: 0,
                child: Material(
                  borderRadius: BorderRadius.circular(20),
                  child: frostedPink(
                    Container(
                        padding: const EdgeInsets.only(top: 5, bottom: 0),
                        height: Get.width * 0.6,
                        width: Get.width,
                        // decoration: BoxDecoration(
                        //   color: Theme.of(context).bottomSheetTheme.backgroundColor,
                        //   borderRadius: BorderRadius.only(
                        //     topLeft: Radius.circular(20),
                        //     topRight: Radius.circular(20),
                        //   ),
                        // ),
                        child: Column(
                          children: tiles,
                        )
                        //_vDuct(context, model, type)

                        ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    Widget getImageMessage(Map<String, dynamic> doc, {bool saved = false}) {
      return Container(
          child: saved
              ? Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: Save.getImageFromBase64(doc[CONTENT]).image,
                        fit: BoxFit.cover),
                  ),
                  width: 200.0,
                  height: 200.0,
                )
              : Container()

          // CachedNetworkImage(
          //     placeholder: (context, url) => Container(
          //       child: CircularProgressIndicator(
          //         valueColor: AlwaysStoppedAnimation<Color>(viewductBlue),
          //       ),
          //       width: 200.0,
          //       height: 200.0,
          //       padding: EdgeInsets.all(80.0),
          //       decoration: BoxDecoration(
          //         color: Colors.blueGrey,
          //         borderRadius: BorderRadius.all(
          //           Radius.circular(8.0),
          //         ),
          //       ),
          //     ),
          //     errorWidget: (context, str, error) => Material(
          //       child: Image.asset(
          //         'assets/shopping-bag.png',
          //         // 'assets/img_not_available.jpeg',
          //         width: 200.0,
          //         height: 200.0,
          //         fit: BoxFit.cover,
          //       ),
          //       borderRadius: BorderRadius.all(
          //         Radius.circular(8.0),
          //       ),
          //       clipBehavior: Clip.hardEdge,
          //     ),
          //     imageUrl: doc[CONTENT],
          //     width: 200.0,
          //     height: 200.0,
          //     fit: BoxFit.cover,
          //   ),
          );
    }

    Widget getTempImageMessage({String? url}) {
      return imageFile != null
          ? Image.file(
              imageFile!,
              width: 200.0,
              height: 200.0,
              fit: BoxFit.cover,
            )
          : getImageMessage({CONTENT: url});
    }

    Widget getTempTextMessage(String message) {
      return Text(
        message,
        style: const TextStyle(color: Colors.grey, fontSize: 16.0),
      );
    }

    Widget buildTempMessage(MessagesType type, content, timestamp, delivered) {
      const bool isMe = true;

      return Container();
      //  SeenProvider(
      //     timestamp: timestamp.toString(),
      //     data: seenState,
      //     child: Bubble(
      //       child: type == MessagesType.Text
      //           ? getTempTextMessage(content)
      //           : getTempImageMessage(url: content),
      //       isMe: isMe,
      //       timestamp: timestamp,
      //       delivered: delivered,
      //       isContinuing: chatState.messageList!.isNotEmpty &&
      //           chatState.messageList!.last.senderId ==
      //               authState.userModel!.key.toString(),
      //     ));
    }

    Widget getTextMessage(bool isMe, Map<String, dynamic> doc, bool saved) {
      return UrlText(
        text: (doc[CONTENT]),
        style: TextStyle(
          fontSize: 16,
          color: isMe ? TwitterColor.white : Colors.black,
        ),
        urlStyle: TextStyle(
          fontSize: 16,
          color: isMe ? TwitterColor.white : Colors.blueGrey,
          decoration: TextDecoration.underline,
        ),
      );
      //  Text(
      //   doc[CONTENT],
      //   style:
      //       TextStyle(color: isMe ? viewductWhite : Colors.black, fontSize: 16.0),
      // );
    }

    Widget buildMessage(Map<String, dynamic> doc,
        {bool saved = false, List<Message>? savedMsgs}) {
      // final chatState = Provider.of<ChatState>(context, listen: false);
      // final authState = Provider.of<AuthState>(context, listen: false);

      // final bool isMe = doc[FROM] == currentUser.userId;
      bool isContinuing;
      if (savedMsgs == null) {
        // isContinuing = chatState.messageList!.isNotEmpty
        //     ? chatState.messageList!.last.senderId == doc[FROM]
        //     : false;
      } else {
        isContinuing =
            savedMsgs.isNotEmpty ? savedMsgs.last.from == doc[FROM] : false;
      }
      return Container();

      // SeenProvider(
      //     timestamp: doc[TIMESTAMP].toString(),
      //     data: seenState,
      //     child: Bubble(
      //         child: doc[TYPE] == MessageType.text.index
      //             ? getTextMessage(isMe, doc, saved)
      //             : getImageMessage(
      //                 doc,
      //                 saved: saved,
      //               ),
      //         isMe: isMe,
      //         timestamp: doc[TIMESTAMP],
      //         delivered: chatState.getMessageStatus(
      //             widget.userProfileId, doc[TIMESTAMP]),
      //         isContinuing: isContinuing));
    }

    List<Widget> sortAndGroupSavedMessages(
        List<Map<String, dynamic>> _msgs, BuildContext context) {
      _msgs.sort((a, b) => a[TIMESTAMP] - b[TIMESTAMP]);
      List<Message> _savedMessages = <Message>[];
      List<Widget> _groupedSavedMessages = <Widget>[];
      for (var msg in _msgs) {
        _savedMessages.add(Message(
            buildMessage(msg, saved: true, savedMsgs: _savedMessages),
            saved: true,
            from: msg[FROM],
            onDoubleTap: () {}, onLongPress: () {
          contextMenu(msg, context, saved: true);
        },
            onDismiss: null,
            onTap:
                // msg[TYPE] == MessageType.image.index
                //     ? () => Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => PhotoViewWrapper(
                //             tag: "saved_" + msg[TIMESTAMP].toString(),
                //             imageProvider: msg[CONTENT].toString().startsWith(
                //                     'http') // See if it is an online or saved
                //                 ? CachedNetworkImageProvider(msg[CONTENT])
                //                 : Save.getImageFromBase64(msg[CONTENT]).image,
                //           ),
                //         ))
                //     :
                null,
            timestamp: msg[TIMESTAMP]));
      }

      _groupedSavedMessages
          .add(const Center(child: Chip(label: Text('Saved Conversations'))));

      groupBy<Message, String>(_savedMessages, (msg) {
        return getWhen(msg.createdAt);
      }).forEach((when, _actualMessages) {
        _groupedSavedMessages.add(Center(
            child: Chip(
          label: Text(when),
        )));
        for (var msg in _actualMessages) {
          _groupedSavedMessages.add(msg.child);
        }
      });
      return _groupedSavedMessages;
    }

    Widget buildSavedMessages(BuildContext context) {
      return Flexible(
          child: ListView(
        padding: const EdgeInsets.all(10.0),
        children: _savedMessageDocs.isEmpty
            ? [
                const Padding(
                    padding: EdgeInsets.only(top: 200.0),
                    child: Text('No saved messages.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 18)))
              ]
            : sortAndGroupSavedMessages(_savedMessageDocs, context),
        controller: saved,
      ));
    }

    void loadSavedMessages() {
      if (_savedMessageDocs.isEmpty) {
        Save.getSavedMessages(chattersId).then((_msgDocs) {
          _savedMessageDocs = _msgDocs;
        });
      }
    }

    getGroupedMessages(BuildContext context, List<ChatMessage> streamMessage) {
      RxList<Widget> _groupedMessages = RxList<Widget>([]);
      var msgCount = ref
              .watch(getUnreadMessageProvider(UnreadMessageModel(
                  chatListkey: widget.chatIdUsers!,
                  senderUserId: secondUser!.userId!)))
              .value
              ?.length ??
          0;
      // int nums = 1;
      // var chatState = Provider.of<ChatState>(context, listen: false);
      groupBy<ChatMessage, String>(streamMessage, (msg) {
        return
            //getChatTime(msg.createdAt);
            getWhen(msg.createdAt);
      }).forEach(
        (when, _actualMessages) {
          for (var msg in _actualMessages) {
            // count++;
            if (msgCount != 0) {
              _groupedMessages.value.add(Center(
                  child: Chip(
                label: Text('${msgCount} unread messages'),
              )));

              setState(() {
                ref
                    .watch(getUnreadMessageProvider(UnreadMessageModel(
                        chatListkey: widget.chatIdUsers!,
                        senderUserId: secondUser.userId!)))
                    .value
                    ?.length = 0;
                msgCount = 0;
              }); // reset
            }
            _groupedMessages.value.add(chatMessage(msg, context));
          }
          _groupedMessages.value.add(Center(
              child: Chip(
            label: Text(when),
          )));
        },
      );
      return _groupedMessages.value.toList();
    }

    emojiContainer() {
      return SingleChildScrollView(
        child: FittedBox(
          fit: BoxFit.fill,
          child: SizedBox(
            width: Get.width,
            height: Get.width * 0.8,
            child: EmojiPicker(
              onEmojiSelected: (emoji, category) {
                isWriting.value = true;

                textEditingController.text =
                    textEditingController.text + category.emoji;
              },
              config: const Config(
                bgColor: TwitterColor.mystic,
                indicatorColor: UniversalVariables.blueColor,
                recentsLimit: 28,
                // rows: 3,
                columns: 7,
              ),
              // recommendKeywords: ["face", "happy", "party", "sad"],
              // numRecommended: 50,
            ),
          ),
        ),
      );
    }

    void _contactSheet(
      BuildContext context,
    ) async {
      // bool isMychat = authState.userId == model.userId;

      await showDialog(
        context: context,
        builder: (context) {
          return Stack(
            children: [
              Positioned(
                top: Get.width * 0.5,
                left: 30,
                right: 30,
                child: Material(
                  color: Colors.transparent,
                  child: frostedYellow(
                    Container(
                        padding: const EdgeInsets.only(top: 5, bottom: 0),
                        //height: Get.height * 0.25,
                        width: Get.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blueGrey[50],
                          gradient: LinearGradient(
                            colors: [
                              Colors.orange.shade100.withOpacity(0.1),
                              Colors.black87.withOpacity(0.2),
                              Colors.grey.withOpacity(0.3)
                              // Color(0xfffbfbfb),
                              // Color(0xfff7f7f7),
                            ],
                            // begin: Alignment.topCenter,
                            // end: Alignment.bottomCenter,
                          ),
                        ),
                        // decoration: BoxDecoration(
                        //   borderRadius: BorderRadius.only(
                        //     topLeft: Radius.circular(20),
                        //     topRight: Radius.circular(20),
                        //   ),
                        // ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                '${secondUser?.displayName}\'s Contact:',
                                style: TextStyle(
                                  color: Colors.orange.shade100,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.blueGrey[50],
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.1),
                                    Colors.black.withOpacity(0.2),
                                    Colors.black.withOpacity(0.3)
                                    // Color(0xfffbfbfb),
                                    // Color(0xfff7f7f7),
                                  ],
                                  // begin: Alignment.topCenter,
                                  // end: Alignment.bottomCenter,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  secondUser!.contact.toString(),
                                  style: TextStyle(
                                    color: Colors.orange.shade100,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            )
                          ],
                        )),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    getTime(date) {
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

    Widget getPeerStatus(String val, String? lastSeens) {
      if (val == 'online') {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(color: Colors.grey, height: 20, width: 20),
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.green,
                  radius: 5,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blueGrey[50],
                      gradient: LinearGradient(
                        colors: [
                          Colors.yellow.withOpacity(0.1),
                          Colors.white60.withOpacity(0.2),
                          Colors.white60.withOpacity(0.3)
                          // Color(0xfffbfbfb),
                          // Color(0xfff7f7f7),
                        ],
                        // begin: Alignment.topCenter,
                        // end: Alignment.bottomCenter,
                      )),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: customText(
                      'online',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ],
        );
      } else if (val == 'typing') {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(color: Colors.grey, height: 20, width: 20),
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: CupertinoColors.lightBackgroundGray,
                  radius: 5,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blueGrey[50],
                      gradient: LinearGradient(
                        colors: [
                          Colors.yellow.withOpacity(0.1),
                          Colors.white60.withOpacity(0.2),
                          Colors.white60.withOpacity(0.3)
                          // Color(0xfffbfbfb),
                          // Color(0xfff7f7f7),
                        ],
                        // begin: Alignment.topCenter,
                        // end: Alignment.bottomCenter,
                      )),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: customText(
                      'typing...',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ],
        );
      } else {
        if (lastSeens != null) {
          DateTime date =
              DateTime.fromMillisecondsSinceEpoch(int.parse(lastSeens));
          String at = DateFormat.jm().format(date), when = getTime(date);
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(color: Colors.red, height: 20, width: 20),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blueGrey[50],
                    gradient: LinearGradient(
                      colors: [
                        Colors.yellow.withOpacity(0.1),
                        Colors.white60.withOpacity(0.2),
                        Colors.white60.withOpacity(0.3)
                        // Color(0xfffbfbfb),
                        // Color(0xfff7f7f7),
                      ],
                      // begin: Alignment.topCenter,
                      // end: Alignment.bottomCenter,
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: customText(
                    '$when at $at',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          );
        }
      }
      // else if (val is String) {
      //   if (val == currentUserNo) {
      //     return Container(
      //       decoration: BoxDecoration(
      //           borderRadius: BorderRadius.circular(20),
      //           color: Colors.blueGrey[50],
      //           gradient: LinearGradient(
      //             colors: [
      //               Colors.yellow.withOpacity(0.1),
      //               Colors.white60.withOpacity(0.2),
      //               Colors.white60.withOpacity(0.3)
      //               // Color(0xfffbfbfb),
      //               // Color(0xfff7f7f7),
      //             ],
      //             // begin: Alignment.topCenter,
      //             // end: Alignment.bottomCenter,
      //           )),
      //       child: Padding(
      //         padding: const EdgeInsets.all(4.0),
      //         child: customText(
      //           'typing.value...',
      //           style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      //         ),
      //       ),
      //     );
      //   }
      //   return const CircleAvatar(
      //     backgroundColor: Colors.transparent,
      //     radius: 5,
      //   );
      // }
      return const Text('tryping');
    }

    RealtimeSubscription? subscription;
    void setImage(ImageSource source) async {
      /// status can either be: granted, denied, restricted or permanentlyDenied
      var status = await camera.Permission.camera.status;
      if (status.isGranted) {
        XTypeGroup typeGroup = XTypeGroup(
          extensions: <String>['jpg', 'png'],
        );

        if (Platform.isMacOS || Platform.isWindows) {
          final file =
              await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);

          imageFileState = File(file!.path);
        } else {
          PickedFile? file = await ImagePicker.platform
              .pickImage(source: ImageSource.gallery, imageQuality: 100);
          cprint(file?.path.toString());

          imageFileState = File(file!.path);
        }
      } else if (status.isDenied) {
        // We didn't ask for permission yet or the permission has been denied before but not permanently.
        if (await camera.Permission.camera.request().isGranted) {
          XTypeGroup typeGroup = XTypeGroup(
            extensions: <String>['jpg', 'png'],
          );

          if (Platform.isMacOS || Platform.isWindows) {
            final file =
                await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);

            imageFileState = File(file!.path);
          } else {
            PickedFile? file = await ImagePicker.platform
                .pickImage(source: ImageSource.gallery, imageQuality: 100);
            cprint(file?.path.toString());

            imageFileState = File(file!.path);
          }
        }
      }
    }

    _showMessage(String message,
        [Duration duration = const Duration(seconds: 4)]) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
        content: Text(message),
        duration: duration,
        action: SnackBarAction(
            label: 'CLOSE',
            onPressed: () =>
                ScaffoldMessenger.of(Get.context!).removeCurrentSnackBar()),
      ));
    }

    void sendMessageToUser({
      required String text,
      required ViewductsUser currentUser,
      required ViewductsUser secondUser,
      required BuildContext context,
      required MessagesType type,
      File? imageFile,
      File? videoFile,
    }) {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (textEditingController.text.isEmpty) {
        return ViewDucts.toast('Type Something Nice...');
      }
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      var key = Uuid().v1();
      ref.read(chatControllerProvider.notifier).sendMessage(
          text: text,
          currentUser: currentUser,
          secondUser: secondUser,
          context: context,
          type: type,
          messageKey: key,
          replyMessage: replyMessage?.value,
          ref: ref);
      Future.delayed(const Duration(milliseconds: 50)).then((_) {
        textEditingController.clear();
        // replyMessage?.value = null;
      });
    }

    void submitMessage(String content, MessagesType type, var timestamp,
        String? imageKey, BuildContext context, String? imagePath,
        {String? localMediaPath, String? videoPath}) async {
      ChatMessage message, instMsg, localMessage;
      FocusScopeNode currentFocus = FocusScope.of(context);
      var key = Uuid().v1();
      String _multiChannelName;
      List<String> list = [
        currentUser!.userId!.substring(8, 14),
        widget.userProfileId!.substring(8, 14)
      ];
      list.sort();
      _multiChannelName = '${list[0]}-${list[1]}';
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      if (localMediaPath == null) {
        if (textEditingController.text.isEmpty) {
          return ViewDucts.toast('Type Something Nice...');
        }
      }
      final encrypted = await TextEncryptDecrypt.encryptAES(content.trim());

      // encryptWithCRC(
      //   content.trim(),
      // );
      imageFileState = null;
      chatUserProductId = null;
      myOrders.value = '';
      ductId = null;

      // if (statusInit == null)
      //   chatState.request(authState.userId, userProfileId);
      messageController.clear();
      textEditingController.clear();

      // cprint('$imagePath');
      // cprint('$encrypted');
      if (mediaType == 'image') {
        final commentEncrypted =
            await TextEncryptDecrypt.encryptAES(content.trim());

        var timestamps = DateTime.now().toUtc().toString();
        localMessage = ChatMessage(
            message: commentEncrypted,
            fileDownloaded: 'new',
            createdAt: timestamps,
            receiverId: widget.userProfileId!,
            senderId: currentUser.userId.toString(),
            imageKey: imageKey,
            searchKey: widget.keyId,
            userId: currentUser.userId,
            chatlistKey: "feedState.dataBaseChatsId!.value",
            // chatIdUsers == null
            //     ? "feedState.dataBaseChatsId!.value"
            //     : chatIdUsers.toString(),
            clicked: 'false',
            key: key,
            newChats: 'true',
            replyedMessage: replyMessage?.value.message.toString(),
            imagePath: pickedFile!.path.toString(),
            seen:
                //  chatState.onlineStatus.value.chatOnlineChatStatus == 'online'
                //     ? 'true'
                //     :
                'sending',
            type: type.index,
            timeStamp: DateTime.now().toUtc().millisecondsSinceEpoch,
            senderName: currentUser.displayName);

        SQLHelper.createLocalMessages(localMessage);
        // chatSetState.value.value = await SQLHelper.findLocalMessages(
        //     widget.chatIdUsers == null
        //         ? "feedState.dataBaseChatsId!.value"
        //         : widget.chatIdUsers.toString());
        isWriting.value = false;
        // final AwsS3Client s3client = AwsS3Client(
        //     region: userCartController.wasabiAws.value.region.toString(),
        //     host: "s3.wasabisys.com",
        //     bucketId: "storage-viewduct",
        //     accessKey: "userCartController.wasabiAws.value.accessKey.toString()",
        //     secretKey: "userCartController.wasabiAws.value.secretKey.toString()");
        final keyImagePath =
            '${DateTime.now().toUtc().toString().replaceAll(RegExp(r'\.\d*Z$'), 'Z').replaceAll(RegExp(r'[:-]|\.\d{3}'), '').split(' ').join('T')}${path.extension(pickedFile!.path.toString())}';
        final minio = Minio(
            endPoint: "userCartController.wasabiAws.value.endPoint.toString()",
            accessKey:
                "userCartController.wasabiAws.value.accessKey.toString()",
            secretKey:
                "userCartController.wasabiAws.value.secretKey.toString()",
            region: "userCartController.wasabiAws.value.region.toString()");

        await minio.fPutObject(
            "userCartController.wasabiAws.value.buckedId.toString()",
            keyImagePath,
            pickedFile!.path.toString());
        cprint('$keyImagePath online image path');

        // final imageEncrypted = await TextEncryptDecrypt.encryptAES(
        //    keyImagePath);

        instMsg = ChatMessage(
            message: commentEncrypted,
            createdAt: timestamps,
            fileDownloaded: 'new',
            clicked: 'false',
            replyedMessage: replyMessage?.value.message.toString(),
            senderId: currentUser.userId.toString(),
            receiverId: widget.userProfileId!,
            imageKey: imageKey,
            searchKey: widget.keyId,
            userId: currentUser.userId,
            imagePath: keyImagePath,
            key: _multiChannelName,
            chatlistKey: "feedState.dataBaseChatsId!.value",
            //  chatIdUsers == null
            //     ? "feedState.dataBaseChatsId!.value"
            //     : chatIdUsers.toString(),
            newChats: 'true',
            seen:
                // chatState.onlineStatus.value.chatOnlineChatStatus == 'online'
                //     ? 'true'
                //     :
                'false',
            type: type.index,
            timeStamp: DateTime.now().toUtc().millisecondsSinceEpoch,
            senderName: currentUser.displayName);
        message = ChatMessage(
            message: commentEncrypted,
            createdAt: timestamps,
            fileDownloaded: 'new',
            receiverId: widget.userProfileId!,
            senderId: currentUser.userId,
            imageKey: imageKey,
            searchKey: widget.keyId,
            userId: currentUser.userId,
            chatlistKey: widget.chatIdUsers == null
                ? "feedState.dataBaseChatsId!.value"
                : widget.chatIdUsers.toString(),
            clicked: 'false',
            key: key,
            newChats: 'true',
            replyedMessage: replyMessage?.value.message.toString(),
            imagePath: keyImagePath,
            seen:
                //  chatState.onlineStatus.value.chatOnlineChatStatus == 'online'
                //     ? 'true'
                //     :
                'false',
            type: type.index,
            timeStamp: DateTime.now().toUtc().millisecondsSinceEpoch,
            senderName: currentUser.displayName);

        // await getGroupedMessages(context, [message].obs);
        // chatSetState.value.add(chatMessage(message, context)
//       Message(
// //_message(message, true),
//         buildTempMessage(type, content, timestamp, message),
//         onTap: null,
//         onDismiss: null,
//         onDoubleTap: () {
//           save(tempDoc);
//         },
//         onLongPress: () {
//           contextMenu(tempDoc, context);
//         },
//         from: authState.userModel!.key.toString(),
//         timestamp: timestamp,
//       )
        //   );
        // await chatState.onMessageSubmitted(message,
        //     currentUser.userId!, widget.userProfileId!, instMsg,
        //     notofication: chatState.myonlineStatus.value.notofication);
        localMessage = ChatMessage(
            message: commentEncrypted,
            fileDownloaded: 'new',
            createdAt: timestamps,
            receiverId: widget.userProfileId!,
            senderId: currentUser.userId,
            imageKey: imageKey,
            searchKey: widget.keyId,
            userId: currentUser.userId,
            chatlistKey: "feedState.dataBaseChatsId!.value",
            // chatIdUsers == null
            //     ? "feedState.dataBaseChatsId!.value"
            //     : chatIdUsers.toString(),
            clicked: 'false',
            key: key,
            newChats: 'true',
            replyedMessage: replyMessage?.value.message.toString(),
            imagePath: pickedFile!.path.toString(),
            seen:
                //  chatState.onlineStatus.value.chatOnlineChatStatus == 'online'
                //     ? 'true'
                //     :
                'false',
            type: type.index,
            timeStamp: DateTime.now().toUtc().millisecondsSinceEpoch,
            senderName: currentUser.displayName);
        SQLHelper.createLocalMessages(localMessage);
        // chatSetState.value.value = await SQLHelper.findLocalMessages(
        //     widget.chatIdUsers == null
        //         ? "feedState.dataBaseChatsId!.value"
        //         : widget.chatIdUsers.toString());
        cprint('image sent to database');
        Future.delayed(const Duration(milliseconds: 50)).then((_) {
          //  replyMessage?.value = null;
          textEditingController.clear();
        });
        uplodingFileInProgress.value = false;
        kScreenloader.hideLoader();
      } else if (videoFile != null) {
        var timestamps = DateTime.now().toUtc().toString();
        cprint('${videoFile!.path} video');
        localMessage = ChatMessage(
            message: content.trim(),
            createdAt: timestamps,
            receiverId: widget.userProfileId!,
            fileDownloaded: 'new',
            senderId: currentUser.userId,
            videoKey: videoFile!.path,
            searchKey: widget.keyId,
            userId: currentUser.userId,
            chatlistKey: "feedState.dataBaseChatsId!.value",
            // chatIdUsers == null
            //     ? "feedState.dataBaseChatsId!.value"
            //     : chatIdUsers.toString(),
            clicked: 'false',
            key: key,
            newChats: 'true',
            replyedMessage: replyMessage?.value.message.toString(),
            imagePath: localMediaPath?.trim(),
            seen:
                // chatState.onlineStatus.value.chatOnlineChatStatus == 'online'
                //     ? 'true'
                //     :

                'sending',
            type: type.index,
            timeStamp: DateTime.now().toUtc().millisecondsSinceEpoch,
            senderName: currentUser.displayName);
        isWriting.value = false;

        await SQLHelper.createLocalMessages(localMessage);
        // chatSetState.value.value = await SQLHelper.findLocalMessages(
        //     widget.chatIdUsers == null
        //         ? "feedState.dataBaseChatsId!.value"
        //         : widget.chatIdUsers.toString());

        final keyvideoPath =
            '${DateTime.now().toUtc().toString().replaceAll(RegExp(r'\.\d*Z$'), 'Z').replaceAll(RegExp(r'[:-]|\.\d{3}'), '').split(' ').join('T')}${path.extension(videoFile!.path.toString())}';
        final keyThumpnailPath =
            '${DateTime.now().toUtc().toString().replaceAll(RegExp(r'\.\d*Z$'), 'Z').replaceAll(RegExp(r'[:-]|\.\d{3}'), '').split(' ').join('T')}${path.extension(_thumbnail!.path.toString())}';

        final minio = Minio(
            endPoint: "userCartController.wasabiAws.value.endPoint.toString()",
            accessKey:
                "userCartController.wasabiAws.value.accessKey.toString()",
            secretKey:
                "userCartController.wasabiAws.value.secretKey.toString()",
            region: "userCartController.wasabiAws.value.region.toString()");

        await minio.fPutObject(
            "userCartController.wasabiAws.value.buckedId.toString()",
            keyvideoPath,
            videoFile!.path.toString());
        await minio.fPutObject(
            "userCartController.wasabiAws.value.buckedId.toString()",
            keyThumpnailPath,
            _thumbnail!.path.toString());
        instMsg = ChatMessage(
            message: content,
            videoKey: keyvideoPath,
            createdAt: timestamps,
            fileDownloaded: 'new',
            videoThumbnail: keyThumpnailPath,
            clicked: 'false',
            replyedMessage: replyMessage?.value.message.toString(),
            senderId: currentUser.userId,
            receiverId: widget.userProfileId!,
            imageKey: imageKey,
            searchKey: widget.keyId,
            userId: currentUser.userId,
            imagePath: imagePath,
            key: _multiChannelName,
            chatlistKey: "feedState.dataBaseChatsId!.value",
            // chatIdUsers == null
            //     ? "feedState.dataBaseChatsId!.value"
            //     : chatIdUsers.toString(),
            newChats: 'true',
            seen:
                //  chatState.onlineStatus.value.chatOnlineChatStatus == 'online'
                //     ? 'true'
                //     :
                'false',
            type: type.index,
            timeStamp: DateTime.now().toUtc().millisecondsSinceEpoch,
            senderName: currentUser.displayName);
        message = ChatMessage(
            message: content.trim(),
            createdAt: timestamps,
            fileDownloaded: 'new',
            videoKey: keyvideoPath,
            receiverId: widget.userProfileId!,
            senderId: currentUser.userId,
            videoThumbnail: keyThumpnailPath,
            searchKey: widget.keyId,
            userId: currentUser.userId,
            chatlistKey: "feedState.dataBaseChatsId!.value",
            // chatIdUsers == null
            //     ? "feedState.dataBaseChatsId!.value"
            //     : chatIdUsers.toString(),
            clicked: 'false',
            key: key,
            newChats: 'true',
            replyedMessage: replyMessage?.value.message.toString(),
            seen:
                // chatState.onlineStatus.value.chatOnlineChatStatus == 'online'
                //     ? 'true'
                //     :
                'false',
            type: type.index,
            timeStamp: DateTime.now().toUtc().millisecondsSinceEpoch,
            senderName: currentUser.displayName);

        // await getGroupedMessages(context, [message].obs);
        // chatSetState.value.add(chatMessage(message, context)
//       Message(
// //_message(message, true),
//         buildTempMessage(type, content, timestamp, message),
//         onTap: null,
//         onDismiss: null,
//         onDoubleTap: () {
//           save(tempDoc);
//         },
//         onLongPress: () {
//           contextMenu(tempDoc, context);
//         },
//         from: authState.userModel!.key.toString(),
//         timestamp: timestamp,
//       )
        //   );
        // await chatState.onMessageSubmitted(message,
        //     currentUser.userId!, widget.userProfileId!, instMsg,
        //     notofication: chatState.myonlineStatus.value.notofication);
        localMessage = ChatMessage(
            message: content.trim(),
            fileDownloaded: 'downloded',
            createdAt: timestamps,
            receiverId: widget.userProfileId!,
            senderId: currentUser.userId,
            videoKey: videoFile!.path,
            searchKey: widget.keyId,
            userId: currentUser.userId,
            chatlistKey: "feedState.dataBaseChatsId!.value",
            // chatIdUsers == null
            //     ? "feedState.dataBaseChatsId!.value"
            //     : chatIdUsers.toString(),
            clicked: 'false',
            key: key,
            newChats: 'true',
            replyedMessage: replyMessage?.value.message.toString(),
            seen:
                //  chatState.onlineStatus.value.chatOnlineChatStatus == 'online'
                //     ? 'true'
                //     :
                'false',
            type: type.index,
            timeStamp: DateTime.now().toUtc().millisecondsSinceEpoch,
            senderName: currentUser.displayName);
        await SQLHelper.createLocalMessages(localMessage);
        // chatSetState.value.value = await SQLHelper.findLocalMessages(
        //     widget.chatIdUsers == null
        //         ? "feedState.dataBaseChatsId!.value"
        //         : widget.chatIdUsers.toString());
        cprint('video sent to database');
        Future.delayed(const Duration(milliseconds: 50)).then((_) {
          // replyMessage?.value = null;
          textEditingController.clear();
        });
        kScreenloader.hideLoader();
      } else if (audioFile != null) {
        final commentEncrypted =
            await TextEncryptDecrypt.encryptAES(content.trim());
        // cprint(audioFile!.path.toString());
        var timestamps = DateTime.now().toUtc().toString();
        localMessage = ChatMessage(
            message: commentEncrypted,
            fileDownloaded: 'new',
            createdAt: timestamps,
            receiverId: widget.userProfileId!,
            senderId: currentUser.userId,
            searchKey: widget.keyId,
            userId: currentUser.userId,
            chatlistKey:
                // chatIdUsers == null
                //     ?
                "feedState.dataBaseChatsId!.value",
            // : chatIdUsers.toString(),
            clicked: 'false',
            key: key,
            newChats: 'true',
            replyedMessage: replyMessage?.value.message.toString(),
            audioFile: audioFile!.path.toString(),
            seen:
                // chatState.onlineStatus.value.chatOnlineChatStatus == 'online'
                //     ? 'true'
                //     :
                'sending',
            type: type.index,
            timeStamp: DateTime.now().toUtc().millisecondsSinceEpoch,
            senderName: currentUser.displayName);

        SQLHelper.createLocalMessages(localMessage);
        // chatSetState.value.value = await SQLHelper.findLocalMessages(
        //     widget.chatIdUsers == null
        //         ? "feedState.dataBaseChatsId!.value"
        //         : widget.chatIdUsers.toString());
        isWriting.value = false;

        final keyImagePath =
            '${DateTime.now().toUtc().toString().replaceAll(RegExp(r'\.\d*Z$'), 'Z').replaceAll(RegExp(r'[:-]|\.\d{3}'), '').split(' ').join('T')}${path.extension(audioFile!.path.toString())}';

        final minio = Minio(
          endPoint: "userCartController.wasabiAws.value.endPoint.toString()",
          accessKey: "userCartController.wasabiAws.value.accessKey.toString()",
          secretKey: "userCartController.wasabiAws.value.secretKey.toString()",
          // region: userCartController.wasabiAws.value.region.toString()
        );

        await minio.fPutObject(
            "userCartController.wasabiAws.value.buckedId.toString()",
            keyImagePath,
            audioFile!.path.toString());
        cprint(keyImagePath);

        // final imageEncrypted = await TextEncryptDecrypt.encryptAES(
        //    keyImagePath);

        instMsg = ChatMessage(
            message: commentEncrypted,
            createdAt: timestamps,
            fileDownloaded: 'new',
            clicked: 'false',
            replyedMessage: replyMessage?.value.message.toString(),
            senderId: currentUser.userId,
            receiverId: widget.userProfileId!,
            searchKey: widget.keyId,
            userId: currentUser.userId,
            audioFile: keyImagePath,
            key: _multiChannelName,
            chatlistKey: widget.chatIdUsers == null
                ? "feedState.dataBaseChatsId!.value"
                : widget.chatIdUsers.toString(),
            newChats: 'true',
            seen:
                // chatState.onlineStatus.value.chatOnlineChatStatus == 'online'
                //     ? 'true'
                //     :
                'false',
            type: type.index,
            timeStamp: DateTime.now().toUtc().millisecondsSinceEpoch,
            senderName: currentUser.displayName);
        message = ChatMessage(
            message: commentEncrypted,
            createdAt: timestamps,
            receiverId: widget.userProfileId!,
            fileDownloaded: 'new',
            senderId: currentUser.userId,
            searchKey: widget.keyId,
            userId: currentUser.userId,
            chatlistKey: widget.chatIdUsers == null
                ? "feedState.dataBaseChatsId!.value"
                : widget.chatIdUsers.toString(),
            clicked: 'false',
            key: key,
            newChats: 'true',
            replyedMessage: replyMessage?.value.message.toString(),
            audioFile: keyImagePath,
            seen:
                // chatState.onlineStatus.value.chatOnlineChatStatus == 'online'
                //     ? 'true'
                //     :
                'false',
            type: type.index,
            timeStamp: DateTime.now().toUtc().millisecondsSinceEpoch,
            senderName: currentUser.displayName);

        // await getGroupedMessages(context, [message].obs);
        // chatSetState.value.add(chatMessage(message, context)
//       Message(
// //_message(message, true),
//         buildTempMessage(type, content, timestamp, message),
//         onTap: null,
//         onDismiss: null,
//         onDoubleTap: () {
//           save(tempDoc);
//         },
//         onLongPress: () {
//           contextMenu(tempDoc, context);
//         },
//         from: authState.userModel!.key.toString(),
//         timestamp: timestamp,
//       )
        //   );
        // await chatState.onMessageSubmitted(message,
        //     currentUser.userId!, widget.userProfileId!, instMsg,
        //     notofication: chatState.myonlineStatus.value.notofication);
        localMessage = ChatMessage(
            message: commentEncrypted,
            fileDownloaded: 'new',
            createdAt: timestamps,
            receiverId: widget.userProfileId!,
            senderId: currentUser.userId,
            imageKey: imageKey,
            searchKey: widget.keyId,
            userId: currentUser.userId,
            chatlistKey: "feedState.dataBaseChatsId!.value",
            // chatIdUsers == null
            //     ? "feedState.dataBaseChatsId!.value"
            //     : chatIdUsers.toString(),
            clicked: 'false',
            key: key,
            newChats: 'true',
            replyedMessage: replyMessage?.value.message.toString(),
            imagePath: audioFile!.path.toString(),
            seen:
                //  chatState.onlineStatus.value.chatOnlineChatStatus == 'online'
                //     ? 'true'
                //     :
                'false',
            type: type.index,
            timeStamp: DateTime.now().toUtc().millisecondsSinceEpoch,
            senderName: currentUser.displayName);
        SQLHelper.createLocalMessages(localMessage);
        // chatSetState.value.value = await SQLHelper.findLocalMessages(
        //     widget.chatIdUsers == null
        //         ? "feedState.dataBaseChatsId!.value"
        //         : widget.chatIdUsers.toString());
        cprint('audio sent to database');
        Future.delayed(const Duration(milliseconds: 50)).then((_) {
          // replyMessage?.value = null;
          textEditingController.clear();
        });
        uplodingFileInProgress.value = false;
        kScreenloader.hideLoader();
      } else if (encrypted is String) {
        var timestamps = DateTime.now().toUtc().toString();
        // localMessage = ChatMessage(
        //     message: encrypted,
        //     key: key,
        //     // fileDownloaded: 'new',
        //     searchKey: keyId,
        //     createdAt: timestamps,
        //     clicked: 'false',
        //     replyedMessage: replyMessage?.value.message.toString(),
        //     receiverId: userProfileId!,
        //     senderId: currentUser.userId,
        //     userId: currentUser.userId,
        //     chatlistKey: "feedState.dataBaseChatsId!.value",
        //     // chatIdUsers == null
        //     //     ? "feedState.dataBaseChatsId!.value"
        //     //     : chatIdUsers.toString(),
        //     newChats: 'true',
        //     imageKey: imageKey,
        //     seen:
        //         //  chatState.onlineStatus.value.chatOnlineChatStatus == 'online'
        //         //     ? 'true'
        //         //     :
        //         'sending',
        //     type: type.index,
        //     timeStamp: DateTime.now().toUtc().millisecondsSinceEpoch,
        //     senderName: currentUser.displayName);
        instMsg = ChatMessage(
            key: key,
            message: encrypted,
            createdAt: timestamps,
            // fileDownloaded: 'new',
            clicked: 'false',
            receiverId: widget.userProfileId!,
            replyedMessage: replyMessage?.value.message.toString(),
            senderId: currentUser.userId,
            imageKey: imageKey,
            searchKey: widget.keyId,
            chatlistKey: "feedState.dataBaseChatsId!.value",
            //  chatIdUsers == null
            //     ? "feedState.dataBaseChatsId!.value"
            //     : chatIdUsers.toString(),
            userId: currentUser.userId,
            newChats: 'true',
            seen:
                //  chatState.onlineStatus.value.chatOnlineChatStatus == 'online'
                //     ? 'true'
                //     :
                'sending',
            type: type.index,
            timeStamp: DateTime.now().toUtc().millisecondsSinceEpoch,
            senderName: currentUser.displayName);
        message = ChatMessage(
            message: encrypted,
            key: key,
            fileDownloaded: 'new',
            searchKey: widget.keyId,
            createdAt: timestamps,
            clicked: 'false',
            replyedMessage: replyMessage?.value.message.toString(),
            receiverId: widget.userProfileId!,
            senderId: currentUser.userId,
            userId: currentUser.userId,
            chatlistKey: "feedState.dataBaseChatsId!.value",
            // chatIdUsers == null
            //     ? "feedState.dataBaseChatsId!.value"
            //     : chatIdUsers.toString(),
            newChats: 'true',
            imageKey: imageKey,
            seen:
                //  chatState.onlineStatus.value.chatOnlineChatStatus == 'online'
                //     ? 'true'
                //     :
                'false',
            type: type.index,
            timeStamp: DateTime.now().toUtc().millisecondsSinceEpoch,
            senderName: currentUser.displayName);

        isWriting.value = false;

        await SQLHelper.createLocalMessages(instMsg);
        // chatSetState.value.value =
        //     await SQLHelper.findLocalMessages("feedState.dataBaseChatsId!.value"
        //         // chatIdUsers == null
        //         //     ? "feedState.dataBaseChatsId!.value"
        //         //     : chatIdUsers.toString()
        //         );

        // await chatState.onMessageSubmitted(message,
        //     authState.userModel!.key.toString(), widget.userProfileId!, instMsg,
        //     notofication: chatState.myonlineStatus.value.notofication,
        //     key: key);
        await SQLHelper.createLocalMessages(message);
        // chatSetState.value.value =
        //     await SQLHelper.findLocalMessages("feedState.dataBaseChatsId!.value"
        //         // chatIdUsers == null
        //         //     ? "feedState.dataBaseChatsId!.value"
        //         //     : chatIdUsers.toString()
        //         );
        Future.delayed(const Duration(milliseconds: 50)).then((_) {
          textEditingController.clear();
          // replyMessage?.value = null;
        });
      }
    }

    setWritingTo(bool val) {
      isWriting.value = val;
    }

    void _uploadChatImge(BuildContext context) {
      showModalBottomSheet(
          backgroundColor: Colors.red,
          isDismissible: false,
          // bounce: true,
          context: context,
          builder: (context) => Scaffold(
                backgroundColor: CupertinoColors.darkBackgroundGray,
                body: SafeArea(
                    child: Responsive(
                  mobile: Stack(
                    children: <Widget>[
                      mediaType == 'audio'
                          ? Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.grey.withOpacity(.3),
                                ),
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.35,
                                child: Stack(
                                  children: [
                                    AudioUploadAdmin(
                                      audioPickedFile: audioFile?.path,
                                    )
                                  ],
                                ),
                              ),
                            )
                          : mediaType == 'video'
                              ? Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Colors.grey.withOpacity(.3),
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height *
                                        0.4,
                                    child: Stack(
                                      children: [
                                        VideoUploadAdmin(
                                          videoFile:
                                              File(videoFile!.path.toString()),
                                          videoPath: videoFile!.path.toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : kIsWeb
                                  ? Container(
                                      height: Get.height,
                                      width: Get.width,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        // image: DecorationImage(
                                        //     image: FileImage(
                                        //         File(pickedFile!.path.toString())),
                                        //     fit: BoxFit.cover),
                                      ),
                                      child: Image.memory(pickedFile!.bytes!,
                                          fit: BoxFit.cover),
                                    )
                                  : Container(
                                      height: Get.height,
                                      width: Get.width,
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        image: DecorationImage(
                                            image: FileImage(
                                                File('${pickedFile?.path}')),
                                            fit: BoxFit.contain),
                                      ),
                                      //  child: Image.memory(pickedFile!.bytes!),
                                    ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        right: 10,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(boxShadow: [
                                BoxShadow(
                                    offset: const Offset(0, 11),
                                    blurRadius: 11,
                                    color: Colors.black.withOpacity(0.06))
                              ], shape: BoxShape.circle, color: Colors.orange),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: IconButton(
                                  onPressed: () async {
                                    await audioPlayer.stop();
                                    uplodingFileInProgress.value = true;
                                    //   kScreenloader.showLoader(context);

                                    // late InputFile inFile;
                                    // if (kIsWeb) {
                                    //   inFile = InputFile(
                                    //     filename: pickedFile!.name,
                                    //     bytes: pickedFile!.bytes,
                                    //   );
                                    // } else {
                                    //   String? imageName =
                                    //       '${DateTime.now().toUtc().toString().replaceAll(RegExp(r'\.\d*Z$'), 'Z').replaceAll(RegExp(r'[:-]|\.\d{3}'), '').split(' ').join('T')}${path.extension(pickedFile!.path!)}';
                                    //   inFile = InputFile(
                                    //     path: pickedFile!.path,
                                    //     filename: imageName,
                                    //     bytes: pickedFile!.bytes,
                                    //   );
                                    // }
                                    if (audioFile != null) {
                                      submitMessage(
                                          'audio',
                                          MessagesType.Audio,
                                          DateTime.now().millisecondsSinceEpoch,
                                          null,
                                          context,
                                          null,
                                          localMediaPath: audioFile!.path);
                                    } else if (videoFile != null) {
                                      submitMessage(
                                          'video',
                                          MessagesType.Video,
                                          DateTime.now().millisecondsSinceEpoch,
                                          null,
                                          context,
                                          null,
                                          localMediaPath: videoFile!.path);
                                    } else if (mediaType == 'image') {
                                      submitMessage(
                                          'image',
                                          MessagesType.Image,
                                          DateTime.now().millisecondsSinceEpoch,
                                          null,
                                          context,
                                          null,
                                          localMediaPath: pickedFile?.path);
                                    }

                                    // Storage storage = Storage(clientConnect());
                                    // await storage
                                    //     .createFile(
                                    //         bucketId: chatsMedia,
                                    //         fileId: "unique()",
                                    //         permissions: [
                                    //           Permission.read(Role.users())
                                    //         ],
                                    //         file: inFile)
                                    //     .then((imagePath) {

                                    // });

                                    // kScreenloader.hideLoader();
                                    Navigator.maybePop(context);
                                    //  kScreenloader.hideLoader();
                                  },
                                  icon: const Icon(
                                    CupertinoIcons.share,
                                    // color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            // Expanded(
                            //   child: Stack(
                            //     alignment: Alignment.centerRight,
                            //     children: [
                            //       frostedOrange(
                            //         TextField(
                            //           controller: textEditingController,
                            //           focusNode: textFieldFocus,
                            //           onTap: () => hideEmojiContainer(),
                            //           style: const TextStyle(
                            //             color: Colors.black,
                            //           ),
                            //           onChanged: (val) {
                            //             (val.isNotEmpty && val.trim() != "")
                            //                 ? setWritingTo(true)
                            //                 : setWritingTo(false);
                            //           },
                            //           maxLines: null,
                            //           decoration: const InputDecoration(
                            //             hintText: "Be positive in words",
                            //             hintStyle: TextStyle(
                            //                 color: Colors.blueGrey
                            //                 //color: UniversalVariables.greyColor,
                            //                 ),
                            //             border: OutlineInputBorder(
                            //                 borderRadius: BorderRadius.all(
                            //                   Radius.circular(50.0),
                            //                 ),
                            //                 borderSide: BorderSide.none),
                            //             contentPadding: EdgeInsets.symmetric(
                            //                 horizontal: 20, vertical: 5),
                            //             filled: true,
                            //             //fillColor: UniversalVariables.separatorColor,
                            //           ),
                            //         ),
                            //       ),
                            //       GestureDetector(
                            //         onTap: () {
                            //           if (!showEmojiPicker.value) {
                            //             // keyboard is visible
                            //             hideKeyboard();
                            //             showEmojiContainer();
                            //           } else {
                            //             //keyboard is hidden.value
                            //             showKeyboard();
                            //             hideEmojiContainer();
                            //           }
                            //         },
                            //         child: Material(
                            //           elevation: 5,
                            //           borderRadius:
                            //               BorderRadius.circular(100),
                            //           child: CircleAvatar(
                            //             radius: 12,
                            //             backgroundColor: Colors.transparent,
                            //             child: Image.asset(
                            //                 'assets/happy (1).png'),
                            //           ),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      mediaType != 'video'
                          ? Container()
                          : _thumbnail == null
                              ? Container()
                              : Positioned(
                                  right: 0,
                                  bottom: Get.height * 0.1,
                                  child: Container(
                                    width: Get.height * 0.15,
                                    height: Get.height * 0.15,
                                    margin: const EdgeInsets.only(top: 30),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: FileImage(_thumbnail!),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.grey.withOpacity(.3),
                                    ),
                                  ),
                                ),
                      Positioned(
                        top: Get.height * 0.02,
                        left: 10,
                        child: GestureDetector(
                          onTap: () async {
                            mediaType = '';
                            await audioPlayer.stop();

                            await _thumbnail == null;
                            await imageFileState == null;
                            await videoFile == null;

                            Navigator.maybePop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      offset: const Offset(0, 11),
                                      blurRadius: 11,
                                      color: Colors.black.withOpacity(0.06))
                                ],
                                borderRadius: BorderRadius.circular(18),
                                color: CupertinoColors.inactiveGray),
                            padding: const EdgeInsets.all(5.0),
                            child: const Icon(
                              CupertinoIcons.back,
                              color: CupertinoColors.lightBackgroundGray,
                              size: 20,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  tablet: Stack(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Stack(
                              children: <Widget>[
                                mediaType == 'audio'
                                    ? Center(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            color: Colors.grey.withOpacity(.3),
                                          ),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.35,
                                          child: Stack(
                                            children: [
                                              AudioUploadAdmin(
                                                audioPickedFile:
                                                    audioFile?.path,
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    : mediaType == 'video'
                                        ? Center(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                color:
                                                    Colors.grey.withOpacity(.3),
                                              ),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.4,
                                              child: Stack(
                                                children: [
                                                  VideoUploadAdmin(
                                                    videoFile: File(videoFile!
                                                        .path
                                                        .toString()),
                                                    videoPath: videoFile!.path
                                                        .toString(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : kIsWeb
                                            ? Container(
                                                height: Get.height,
                                                width: Get.width,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10)),
                                                  // image: DecorationImage(
                                                  //     image: FileImage(
                                                  //         File(pickedFile!.path.toString())),
                                                  //     fit: BoxFit.cover),
                                                ),
                                                child: Image.memory(
                                                    pickedFile!.bytes!,
                                                    fit: BoxFit.cover),
                                              )
                                            : Container(
                                                height: Get.height,
                                                width: Get.width,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10)),
                                                  image: DecorationImage(
                                                      image: FileImage(File(
                                                          '${imageFileState?.path}')),
                                                      fit: BoxFit.cover),
                                                ),
                                                //  child: Image.memory(pickedFile!.bytes!),
                                              ),
                                Positioned(
                                  bottom: 10,
                                  left: 10,
                                  right: 10,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  offset: const Offset(0, 11),
                                                  blurRadius: 11,
                                                  color: Colors.black
                                                      .withOpacity(0.06))
                                            ],
                                            shape: BoxShape.circle,
                                            color: Colors.orange),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: IconButton(
                                            onPressed: () async {
                                              await audioPlayer.stop();
                                              uplodingFileInProgress.value =
                                                  true;
                                              //   kScreenloader.showLoader(context);

                                              // late InputFile inFile;
                                              // if (kIsWeb) {
                                              //   inFile = InputFile(
                                              //     filename: pickedFile!.name,
                                              //     bytes: pickedFile!.bytes,
                                              //   );
                                              // } else {
                                              //   String? imageName =
                                              //       '${DateTime.now().toUtc().toString().replaceAll(RegExp(r'\.\d*Z$'), 'Z').replaceAll(RegExp(r'[:-]|\.\d{3}'), '').split(' ').join('T')}${path.extension(pickedFile!.path!)}';
                                              //   inFile = InputFile(
                                              //     path: pickedFile!.path,
                                              //     filename: imageName,
                                              //     bytes: pickedFile!.bytes,
                                              //   );
                                              // }
                                              if (textEditingController.text !=
                                                      '' &&
                                                  audioFile != null) {
                                                submitMessage(
                                                    textEditingController.text,
                                                    MessagesType.Audio,
                                                    DateTime.now()
                                                        .millisecondsSinceEpoch,
                                                    null,
                                                    context,
                                                    '',
                                                    localMediaPath:
                                                        audioFile!.path);
                                              } else if (audioFile != null) {
                                                submitMessage(
                                                    'audio',
                                                    MessagesType.Audio,
                                                    DateTime.now()
                                                        .millisecondsSinceEpoch,
                                                    null,
                                                    context,
                                                    null,
                                                    localMediaPath:
                                                        audioFile!.path);
                                              }
                                              if (textEditingController.text !=
                                                      '' &&
                                                  videoFile != null) {
                                                submitMessage(
                                                    textEditingController.text,
                                                    MessagesType.Video,
                                                    DateTime.now()
                                                        .millisecondsSinceEpoch,
                                                    null,
                                                    context,
                                                    '',
                                                    localMediaPath:
                                                        videoFile!.path);
                                              } else if (videoFile != null) {
                                                submitMessage(
                                                    'video',
                                                    MessagesType.Video,
                                                    DateTime.now()
                                                        .millisecondsSinceEpoch,
                                                    null,
                                                    context,
                                                    null,
                                                    localMediaPath:
                                                        videoFile!.path);
                                              }
                                              if (textEditingController.text !=
                                                      '' &&
                                                  imageFileState != null) {
                                                submitMessage(
                                                    textEditingController.text,
                                                    MessagesType.Image,
                                                    DateTime.now()
                                                        .millisecondsSinceEpoch,
                                                    null,
                                                    context,
                                                    '',
                                                    localMediaPath:
                                                        imageFileState!.path);
                                              } else if (imageFileState !=
                                                  null) {
                                                submitMessage(
                                                    'image',
                                                    MessagesType.Image,
                                                    DateTime.now()
                                                        .millisecondsSinceEpoch,
                                                    null,
                                                    context,
                                                    null,
                                                    localMediaPath:
                                                        imageFileState!.path);
                                              }

                                              // Storage storage = Storage(clientConnect());
                                              // await storage
                                              //     .createFile(
                                              //         bucketId: chatsMedia,
                                              //         fileId: "unique()",
                                              //         permissions: [
                                              //           Permission.read(Role.users())
                                              //         ],
                                              //         file: inFile)
                                              //     .then((imagePath) {

                                              // });

                                              // kScreenloader.hideLoader();
                                              Navigator.maybePop(context);
                                              //  kScreenloader.hideLoader();
                                            },
                                            icon: const Icon(
                                              CupertinoIcons.share,
                                              // color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Expanded(
                                      //   child: Stack(
                                      //     alignment: Alignment.centerRight,
                                      //     children: [
                                      //       frostedOrange(
                                      //         TextField(
                                      //           controller: textEditingController,
                                      //           focusNode: textFieldFocus,
                                      //           onTap: () => hideEmojiContainer(),
                                      //           style: const TextStyle(
                                      //             color: Colors.black,
                                      //           ),
                                      //           onChanged: (val) {
                                      //             (val.isNotEmpty && val.trim() != "")
                                      //                 ? setWritingTo(true)
                                      //                 : setWritingTo(false);
                                      //           },
                                      //           maxLines: null,
                                      //           decoration: const InputDecoration(
                                      //             hintText: "Be positive in words",
                                      //             hintStyle: TextStyle(
                                      //                 color: Colors.blueGrey
                                      //                 //color: UniversalVariables.greyColor,
                                      //                 ),
                                      //             border: OutlineInputBorder(
                                      //                 borderRadius: BorderRadius.all(
                                      //                   Radius.circular(50.0),
                                      //                 ),
                                      //                 borderSide: BorderSide.none),
                                      //             contentPadding: EdgeInsets.symmetric(
                                      //                 horizontal: 20, vertical: 5),
                                      //             filled: true,
                                      //             //fillColor: UniversalVariables.separatorColor,
                                      //           ),
                                      //         ),
                                      //       ),
                                      //       GestureDetector(
                                      //         onTap: () {
                                      //           if (!showEmojiPicker.value) {
                                      //             // keyboard is visible
                                      //             hideKeyboard();
                                      //             showEmojiContainer();
                                      //           } else {
                                      //             //keyboard is hidden.value
                                      //             showKeyboard();
                                      //             hideEmojiContainer();
                                      //           }
                                      //         },
                                      //         child: Material(
                                      //           elevation: 5,
                                      //           borderRadius:
                                      //               BorderRadius.circular(100),
                                      //           child: CircleAvatar(
                                      //             radius: 12,
                                      //             backgroundColor: Colors.transparent,
                                      //             child: Image.asset(
                                      //                 'assets/happy (1).png'),
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  desktop: Stack(
                    children: [
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                        child: Container(
                          color: (Colors.white12).withOpacity(0.1),
                        ),
                      ),
                      Row(
                        children: [
                          // Once our width is less then 1300 then it start showing errors
                          // Now there is no error if our width is less then 1340

                          Expanded(
                            flex: Get.width > 1340 ? 3 : 5,
                            child: PlainScaffold(),
                          ),
                          Expanded(
                            flex: Get.width > 1340 ? 8 : 10,
                            child: Stack(
                              children: <Widget>[
                                mediaType == 'audio'
                                    ? Center(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            color: Colors.grey.withOpacity(.3),
                                          ),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.35,
                                          child: Stack(
                                            children: [
                                              AudioUploadAdmin(
                                                audioPickedFile:
                                                    audioFile?.path,
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    : mediaType == 'video'
                                        ? Center(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                color:
                                                    Colors.grey.withOpacity(.3),
                                              ),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.4,
                                              child: Stack(
                                                children: [
                                                  VideoUploadAdmin(
                                                    videoFile: File(videoFile!
                                                        .path
                                                        .toString()),
                                                    videoPath: videoFile!.path
                                                        .toString(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : kIsWeb
                                            ? Container(
                                                height: Get.height,
                                                width: Get.width,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10)),
                                                  // image: DecorationImage(
                                                  //     image: FileImage(
                                                  //         File(pickedFile!.path.toString())),
                                                  //     fit: BoxFit.cover),
                                                ),
                                                child: Image.memory(
                                                    pickedFile!.bytes!,
                                                    fit: BoxFit.cover),
                                              )
                                            : Container(
                                                height: Get.height,
                                                width: Get.width,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(10)),
                                                  image: DecorationImage(
                                                      image: FileImage(File(
                                                          '${imageFileState?.path}')),
                                                      fit: BoxFit.cover),
                                                ),
                                                //  child: Image.memory(pickedFile!.bytes!),
                                              ),
                                Positioned(
                                  bottom: 10,
                                  left: 10,
                                  right: 10,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  offset: const Offset(0, 11),
                                                  blurRadius: 11,
                                                  color: Colors.black
                                                      .withOpacity(0.06))
                                            ],
                                            shape: BoxShape.circle,
                                            color: Colors.orange),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: IconButton(
                                            onPressed: () async {
                                              await audioPlayer.stop();
                                              uplodingFileInProgress.value =
                                                  true;
                                              //   kScreenloader.showLoader(context);

                                              // late InputFile inFile;
                                              // if (kIsWeb) {
                                              //   inFile = InputFile(
                                              //     filename: pickedFile!.name,
                                              //     bytes: pickedFile!.bytes,
                                              //   );
                                              // } else {
                                              //   String? imageName =
                                              //       '${DateTime.now().toUtc().toString().replaceAll(RegExp(r'\.\d*Z$'), 'Z').replaceAll(RegExp(r'[:-]|\.\d{3}'), '').split(' ').join('T')}${path.extension(pickedFile!.path!)}';
                                              //   inFile = InputFile(
                                              //     path: pickedFile!.path,
                                              //     filename: imageName,
                                              //     bytes: pickedFile!.bytes,
                                              //   );
                                              // }
                                              if (textEditingController.text !=
                                                      '' &&
                                                  audioFile != null) {
                                                submitMessage(
                                                    textEditingController.text,
                                                    MessagesType.Audio,
                                                    DateTime.now()
                                                        .millisecondsSinceEpoch,
                                                    null,
                                                    context,
                                                    '',
                                                    localMediaPath:
                                                        audioFile!.path);
                                              } else if (audioFile != null) {
                                                submitMessage(
                                                    'audio',
                                                    MessagesType.Audio,
                                                    DateTime.now()
                                                        .millisecondsSinceEpoch,
                                                    null,
                                                    context,
                                                    null,
                                                    localMediaPath:
                                                        audioFile!.path);
                                              }
                                              if (textEditingController.text !=
                                                      '' &&
                                                  videoFile != null) {
                                                submitMessage(
                                                    textEditingController.text,
                                                    MessagesType.Video,
                                                    DateTime.now()
                                                        .millisecondsSinceEpoch,
                                                    null,
                                                    context,
                                                    '',
                                                    localMediaPath:
                                                        videoFile!.path);
                                              } else if (videoFile != null) {
                                                submitMessage(
                                                    'video',
                                                    MessagesType.Video,
                                                    DateTime.now()
                                                        .millisecondsSinceEpoch,
                                                    null,
                                                    context,
                                                    null,
                                                    localMediaPath:
                                                        videoFile!.path);
                                              }
                                              if (textEditingController.text !=
                                                      '' &&
                                                  imageFileState != null) {
                                                submitMessage(
                                                    textEditingController.text,
                                                    MessagesType.Image,
                                                    DateTime.now()
                                                        .millisecondsSinceEpoch,
                                                    null,
                                                    context,
                                                    '',
                                                    localMediaPath:
                                                        imageFileState!.path);
                                              } else if (imageFileState !=
                                                  null) {
                                                submitMessage(
                                                    'image',
                                                    MessagesType.Image,
                                                    DateTime.now()
                                                        .millisecondsSinceEpoch,
                                                    null,
                                                    context,
                                                    null,
                                                    localMediaPath:
                                                        imageFileState!.path);
                                              }

                                              // Storage storage = Storage(clientConnect());
                                              // await storage
                                              //     .createFile(
                                              //         bucketId: chatsMedia,
                                              //         fileId: "unique()",
                                              //         permissions: [
                                              //           Permission.read(Role.users())
                                              //         ],
                                              //         file: inFile)
                                              //     .then((imagePath) {

                                              // });

                                              // kScreenloader.hideLoader();
                                              Navigator.maybePop(context);
                                              //  kScreenloader.hideLoader();
                                            },
                                            icon: const Icon(
                                              CupertinoIcons.share,
                                              // color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Expanded(
                                      //   child: Stack(
                                      //     alignment: Alignment.centerRight,
                                      //     children: [
                                      //       frostedOrange(
                                      //         TextField(
                                      //           controller: textEditingController,
                                      //           focusNode: textFieldFocus,
                                      //           onTap: () => hideEmojiContainer(),
                                      //           style: const TextStyle(
                                      //             color: Colors.black,
                                      //           ),
                                      //           onChanged: (val) {
                                      //             (val.isNotEmpty && val.trim() != "")
                                      //                 ? setWritingTo(true)
                                      //                 : setWritingTo(false);
                                      //           },
                                      //           maxLines: null,
                                      //           decoration: const InputDecoration(
                                      //             hintText: "Be positive in words",
                                      //             hintStyle: TextStyle(
                                      //                 color: Colors.blueGrey
                                      //                 //color: UniversalVariables.greyColor,
                                      //                 ),
                                      //             border: OutlineInputBorder(
                                      //                 borderRadius: BorderRadius.all(
                                      //                   Radius.circular(50.0),
                                      //                 ),
                                      //                 borderSide: BorderSide.none),
                                      //             contentPadding: EdgeInsets.symmetric(
                                      //                 horizontal: 20, vertical: 5),
                                      //             filled: true,
                                      //             //fillColor: UniversalVariables.separatorColor,
                                      //           ),
                                      //         ),
                                      //       ),
                                      //       GestureDetector(
                                      //         onTap: () {
                                      //           if (!showEmojiPicker.value) {
                                      //             // keyboard is visible
                                      //             hideKeyboard();
                                      //             showEmojiContainer();
                                      //           } else {
                                      //             //keyboard is hidden.value
                                      //             showKeyboard();
                                      //             hideEmojiContainer();
                                      //           }
                                      //         },
                                      //         child: Material(
                                      //           elevation: 5,
                                      //           borderRadius:
                                      //               BorderRadius.circular(100),
                                      //           child: CircleAvatar(
                                      //             radius: 12,
                                      //             backgroundColor: Colors.transparent,
                                      //             child: Image.asset(
                                      //                 'assets/happy (1).png'),
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: Get.width > 1340 ? 2 : 4,
                            child: PlainScaffold(),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
              ));
    }

    Widget buildReply() => IntrinsicHeight(
            //  width: Get.width * 0.9,
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(color: Colors.green, width: 4),
            // Row(
            //   children: [
            //     customText((replyMessage?.value!.value.senderId.toString())),
            //   ],
            // ),
            GestureDetector(
              onTap: cancelReply,
              child: Icon(CupertinoIcons.clear_circled_solid,
                  size: Get.width * 0.06),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: getBorder(true),
                color: Colors.amber[300],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(replyMessage?.value.senderName.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  customText(TextEncryptDecrypt.decryptAES(
                      replyMessage?.value.message.toString())),
                ],
              ),
            ),
          ],
        ));
    void _orderList(BuildContext context, OrderViewProduct? cartItem) {
      FeedModel model = FeedModel();
      Storage storage = Storage(clientConnect());
      // double height =
      //     ScreenConfig.deviceHeight! - ScreenConfig.getProportionalHeight(374);
      // List<ViewductsUser>? list =
      //     searchState.getVendors(authState.userModel?.location);
      showModalBottomSheet(
          backgroundColor: Colors.red,
          // bounce: true,
          context: context,
          builder: (context) => Stack(
                children: <Widget>[
                  SizedBox(
                    width: Get.width,
                    height: Get.height,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Expanded(
                          //   flex: 4,
                          //   child: CustomScrollView(
                          //     slivers: <Widget>[
                          //       CupertinoSliverNavigationBar(
                          //         backgroundColor: Colors.transparent,
                          //         leading: Container(),
                          //         largeTitle: Text(
                          //           'Placed Orders',
                          //           style: TextStyle(color: Colors.blueGrey[200]),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          invoiceHeader(cartItem),
                          Stack(
                            children: [
                              Container(
                                height: Get.height,
                                width: Get.width,
                                decoration: BoxDecoration(
                                  // borderRadius: BorderRadius.circular(100),
                                  //color: Colors.blueGrey[50]
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.yellow[100]!.withOpacity(0.3),
                                      Colors.yellow[200]!.withOpacity(0.1),
                                      Colors.yellowAccent[100]!.withOpacity(0.2)
                                      // Color(0xfffbfbfb),
                                      // Color(0xfff7f7f7),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: -250,
                                child: Transform.rotate(
                                  angle: 90,
                                  child: Container(
                                    height: fullWidth(context) * 0.8,
                                    width: fullWidth(context),
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/ankara3.jpg'))),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 40,
                                right: -260,
                                child: Transform.rotate(
                                  angle: 30,
                                  child: Container(
                                    height: fullWidth(context) * 0.8,
                                    width: fullWidth(context),
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/ankkara1.jpg'))),
                                  ),
                                ),
                              ),
                              SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text("State",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: Get.width * 0.04)),
                                        SizedBox(
                                          width: Get.width * 0.04,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Container(
                                            height: Get.width * 0.1,

                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              color: cartItem!.orderState ==
                                                      'shipping'
                                                  ? Colors.yellow
                                                  : cartItem.orderState ==
                                                          'delivered'
                                                      ? Colors.green
                                                      : iAccentColor2,
                                            ),
                                            // shape: RoundedRectangleBorder(
                                            //     borderRadius:
                                            //         BorderRadius.circular(18)),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.add),
                                                cartItem.orderState ==
                                                        'shipping'
                                                    ? const Text(
                                                        'Shipping',
                                                        style: TextStyle(
                                                            //fontSize: 17.0,
                                                            // color: Colors.white,
                                                            ),
                                                      )
                                                    : cartItem.orderState ==
                                                            'delivered'
                                                        ? const Text(
                                                            'Delivered',
                                                            style: TextStyle(
                                                                //  fontSize: 17.0,
                                                                // color: Colors.white,
                                                                ),
                                                          )
                                                        : const Text(
                                                            'Processing',
                                                            style: TextStyle(
                                                                // fontSize: 17.0,
                                                                //color: Colors.white,
                                                                ),
                                                          )
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: cartItem.items!
                                          .map((item) => GestureDetector(
                                                onTap: () {
                                                  if (isSelected.value) {
                                                    myOrders.value =
                                                        // itemList[
                                                        //     index]['id'];
                                                        item.id.toString();
                                                    isSelected.value;
                                                    cprint(
                                                        'my order key ${myOrders.value}');

                                                    Get.back();
                                                  } else {
                                                    myOrders.value =
                                                        item.id.toString();
                                                    // itemList[
                                                    //     index]['id'];
                                                    isSelected.value =
                                                        !isSelected.value;
                                                    cprint(
                                                        'my order key ${myOrders.value}');
                                                    Get.back();
                                                  }
                                                },
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      height: Get.height * 0.2,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  Get.width *
                                                                      0.04),
                                                      color: iPrimarryColor,
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                                height:
                                                                    Get.width *
                                                                        0.04),

                                                            //   addItemAction(),
                                                            // SizedBox(
                                                            //   height: Get.width *
                                                            //       0.04,
                                                            // ),
                                                            Container(
                                                              height:
                                                                  Get.width *
                                                                      0.2,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          Get.width *
                                                                              0.04),
                                                              decoration:
                                                                  BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                            offset: const Offset(
                                                                                0, 11),
                                                                            blurRadius:
                                                                                11,
                                                                            color:
                                                                                Colors.black.withOpacity(0.06))
                                                                      ],
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20)),
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    item.quantity
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(
                                                                                0.6),
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  CircleAvatar(
                                                                    radius: 25,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .transparent,
                                                                    child:
                                                                        FutureBuilder(
                                                                      future: storage.getFileView(
                                                                          bucketId:
                                                                              productBucketId,
                                                                          fileId:
                                                                              ''
                                                                          //  feedState.productlist!
                                                                          //     .firstWhere(
                                                                          //       (e) => e.key == item.productId,
                                                                          //       orElse: () => model,
                                                                          //     )
                                                                          //     .imagePath
                                                                          //     .toString()
                                                                          ), //works for both public file and private file, for private files you need to be logged in
                                                                      builder:
                                                                          (context,
                                                                              snapshot) {
                                                                        return snapshot.hasData &&
                                                                                snapshot.data != null
                                                                            ? Image.memory(snapshot.data as Uint8List, width: Get.height * 0.3, height: Get.height * 0.4, fit: BoxFit.contain)
                                                                            : Center(
                                                                                child: SizedBox(
                                                                                width: Get.height * 0.2,
                                                                                height: Get.height * 0.2,
                                                                                child: LoadingIndicator(
                                                                                    indicatorType: Indicator.ballTrianglePath,

                                                                                    /// Required, The loading type of the widget
                                                                                    colors: const [Colors.pink, Colors.green, Colors.blue],

                                                                                    /// Optional, The color collections
                                                                                    strokeWidth: 0.5,

                                                                                    /// Optional, The stroke of the line, only applicable to widget which contains line
                                                                                    backgroundColor: Colors.transparent,

                                                                                    /// Optional, Background of the widget
                                                                                    pathBackgroundColor: Colors.blue

                                                                                    /// Optional, the stroke backgroundColor
                                                                                    ),
                                                                              )
                                                                                //  CircularProgressIndicator
                                                                                //     .adaptive()
                                                                                );
                                                                      },
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    "${item.name}",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(
                                                                                0.6),
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  // SizedBox(
                                                                  //   width: ScreenConfig.getProportionalWidth(145),
                                                                  //   child: Text(
                                                                  //     itemDesc,
                                                                  //     style: TextStyle(color: Colors.black),
                                                                  //   ),
                                                                  // ),
                                                                  Text(
                                                                    '',
                                                                    // NumberFormat.currency(
                                                                    //         name:
                                                                    //         feedState.productlist!
                                                                    //                         .firstWhere(
                                                                    //                           (e) => e.key == item.productId,
                                                                    //                           orElse: () => model,
                                                                    //                         )
                                                                    //                         .productLocation ==
                                                                    //                     'Nigeria' ||
                                                                    //                 authState.userModel?.location == 'Nigeria'
                                                                    //             ? '₦ '
                                                                    //             : '£'

                                                                    //             )
                                                                    //     .format(double.parse(
                                                                    //   "${(double.parse(item.price!.toString()) * int.parse(item.quantity!.toString()))}",
                                                                    // )),
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              child: Container(
                                                                  width:
                                                                      Get.width *
                                                                          0.8,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              18),
                                                                      color: CupertinoColors
                                                                          .darkBackgroundGray),
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          5.0),
                                                                  child: Row(
                                                                    children: [
                                                                      const Text(
                                                                        'Commission when Ducts: ',
                                                                        style: TextStyle(
                                                                            color:
                                                                                CupertinoColors.systemGrey,
                                                                            fontWeight: FontWeight.w700),
                                                                      ),
                                                                      Text('',
                                                                          // feedState.productlist!
                                                                          //                 .firstWhere(
                                                                          //                   (e) => e.key == item.productId,
                                                                          //                   orElse: () => model,
                                                                          //                 )
                                                                          //                 .productLocation ==
                                                                          //             'Nigeria' ||
                                                                          //         authState.userModel?.location == 'Nigeria'
                                                                          //     ? '₦  ${item.commissionPrice}'
                                                                          //     : '£ ${item.commissionPrice}',
                                                                          // NumberFormat.currency(name: 'N ')
                                                                          //     .format(int.parse(
                                                                          //   item.commissionPrice.toString(),
                                                                          // )),
                                                                          style: const TextStyle(
                                                                              color: CupertinoColors.systemYellow,
                                                                              fontWeight: FontWeight.w200)),
                                                                    ],
                                                                  )),
                                                            ),
                                                            //invoiceTotal(totalAmount),

                                                            // FlatButton(
                                                            //   color: iAccentColor,
                                                            //   shape: RoundedRectangleBorder(
                                                            //       borderRadius:
                                                            //           BorderRadius
                                                            //               .circular(
                                                            //                   15)),
                                                            //   child: SizedBox(
                                                            //     height: ScreenConfig
                                                            //         .getProportionalHeight(
                                                            //             80),
                                                            //     child: Row(
                                                            //       mainAxisAlignment:
                                                            //           MainAxisAlignment
                                                            //               .center,
                                                            //       children: [
                                                            //         Icon(Icons
                                                            //             .file_download),
                                                            //         SizedBox(
                                                            //           width: ScreenConfig
                                                            //               .getProportionalWidth(
                                                            //                   21),
                                                            //         ),
                                                            //         Text(
                                                            //           "Download now",
                                                            //           style: TextStyle(
                                                            //               fontSize: ScreenConfig
                                                            //                   .getProportionalHeight(
                                                            //                       27),
                                                            //               fontWeight:
                                                            //                   FontWeight
                                                            //                       .bold),
                                                            //         )
                                                            //       ],
                                                            //     ),
                                                            //   ),
                                                            //   onPressed: () {},
                                                            // )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Total: ",
                                              style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.6),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: Get.width * 0.04),
                                            ),
                                            SizedBox(
                                              width: Get.width * 0.04,
                                            ),
                                            Text(
                                              "\$${cartItem.totalPrice}",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: Get.width * 0.04),
                                            ),
                                            SizedBox(height: Get.width * 0.1)
                                          ],
                                        ),
                                        SizedBox(height: Get.width * 0.04),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(10),
                      child: frostedOrange(
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.blueGrey[50],
                              gradient: LinearGradient(
                                colors: [
                                  Colors.yellow.withOpacity(0.1),
                                  Colors.white60.withOpacity(0.2),
                                  Colors.orange.withOpacity(0.3)
                                ],
                                // begin: Alignment.topCenter,
                                // end: Alignment.bottomCenter,
                              )),
                          child: Row(
                            children: [
                              Material(
                                elevation: 10,
                                borderRadius: BorderRadius.circular(100),
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: Colors.transparent,
                                  child: Image.asset('assets/delicious.png'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 3),
                                child: customTitleText('ViewDucts'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ));
    }

    void _orders(BuildContext context) async {
      showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => SizedBox(
            height: Get.width * 0.45,
            child: ref.read(getUserOrdersProvider(currentUser!.userId!)).when(
                  data: (myOrderList) => Stack(
                    children: [
                      // Container(
                      //   width: Get.width,
                      //   height: Get.height,
                      //   color: TwitterColor.mystic,
                      // ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 3),
                            decoration: BoxDecoration(
                                color: Colors.yellow,
                                borderRadius: BorderRadius.circular(10)),
                            child: myOrderList.isEmpty
                                ? customTitleText(
                                    'You don\'t have order to recommend to ${secondUser!.displayName}')
                                : customTitleText(
                                    'Recommend Your Orders to ${secondUser!.displayName}'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: fullHeight(context) * 0.1,
                              width: fullWidth(context),
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: myOrderList
                                    .map(
                                      (cartItem) => Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GestureDetector(
                                            onTap: () {
                                              Get.back;
                                              _orderList(context, cartItem);
                                            },
                                            child: DuctStatusView(
                                                radius: Get.width * 0.1,
                                                numberOfStatus:
                                                    cartItem.items!.length,
                                                bucketId: productBucketId,
                                                centerImageUrl: ''
                                                // feedState.productlist!
                                                //     .firstWhere(
                                                //       (e) =>
                                                //           e.key ==
                                                //           cartItem.items![0].productId
                                                //               .toString(),
                                                //       orElse: () => model,
                                                //     )
                                                //     .imagePath
                                                //     .toString()

                                                )),
                                      ),
                                    )
                                    .toList(),
                              ),

                              // ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  error: (error, stackTrace) => ErrorText(
                    error: error.toString(),
                  ),
                  loading: () => Loader(),
                )),
      );
    }

    Widget orderProducts() => IntrinsicHeight(
            child: Stack(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                frostedOrange(
                  Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 11),
                              blurRadius: 11,
                              color: Colors.black.withOpacity(0.06))
                        ],
                        borderRadius: BorderRadius.circular(18),
                        color: CupertinoColors.lightBackgroundGray),
                    width: Get.width,
                    height: Get.width * 0.25,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      addAutomaticKeepAlives: false,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                            height: Get.width * 0.3,
                            width: Get.width,
                            child: _SelectedProduct(
                                model: model, ductId: myOrders.value)),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: frostedPink(Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(0, 11),
                          blurRadius: 11,
                          color: Colors.black.withOpacity(0.06))
                    ],
                    borderRadius: BorderRadius.circular(5),
                    color: CupertinoColors.darkBackgroundGray),
                padding: const EdgeInsets.all(8.0),
                child: customTitleText(
                  colors: CupertinoColors.systemYellow,
                  'My Order',
                ),
              )),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => myOrders.value = '',
                child: Icon(CupertinoIcons.clear_circled_solid,
                    size: Get.width * 0.06),
              ),
            ),
          ],
        ));
    Widget _bottomEntryField(BuildContext context) {
      // ductsProduct() async {
      //   // Rx<FeedModel> productsIrders = FeedModel().obs;
      //   final database = Databases(
      //     clientConnect(),
      //   );
      //   // database
      //   //     .getDocument(
      //   //         databaseId: databaseId,
      //   //         collectionId: procold,
      //   //         documentId: myOrders.value)
      //   //     .then((ducsers) {
      //   //   // Map map = data.toMap();

      //   //   // var value =
      //   //   //     data.data.map((e) => ViewductsUser.fromJson(e.data));
      //   //   //data.documents;
      //   //   // setState(() {
      //   //   productsIrders = FeedModel.fromJson(ducsers.data).obs;
      //   //   // });
      //   // });
      //   //  cprint('${productsIrders.value.imagePath} products');
      //   await database.listDocuments(
      //       databaseId: databaseId,
      //       collectionId: procold,
      //       queries: [
      //         Query.equal('key', myOrders.value.toString())
      //       ]).then((data) {
      //     feedState.productlist!.value =
      //         data.documents.map((e) => FeedModel.fromJson(e.data)).toList();
      //   });
      // }

      // ;
      final List<FeedModel>? commissionProduct = <FeedModel>[];
      // feedState.commissionProducts(authState.userModel, ductId);
      final List<FeedModel>? chatUserProduct = <FeedModel>[];
      //  feedState.commissionProducts(authState.userModel, chatUserProductId);

      userImage = secondUser?.profilePic;

      if (statusInit == ChatStatus.requested.index) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: frostedYellow(
            Container(
              height: Get.width * 0.5,
              width: Get.width * 0.6,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: SafeArea(
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      bottom: -160,
                      left: -140,
                      child: Transform.rotate(
                        angle: 90,
                        child: Container(
                          height: Get.width * 0.8,
                          width: Get.width,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/ankkara1.jpg'))),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -160,
                      right: -180,
                      child: Transform.rotate(
                        angle: 90,
                        child: Container(
                          height: Get.width * 0.8,
                          width: Get.width,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/ankara2.jpg'))),
                        ),
                      ),
                    ),
                    Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Material(
                              elevation: 20,
                              shadowColor: TwitterColor.mystic,
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(100),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 5),
                                    shape: BoxShape.circle),
                                child: RippleButton(
                                  child: customImage(
                                    context,
                                    secondUser?.profilePic,
                                    height: 60,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                  onPressed: () {
                                    // Navigator.of(context).pushNamed(
                                    //     '/ProfilePage/',
                                    //     arguments: chatState?.chatUser);
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Accept',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.blueGrey[500]),
                                  ),
                                  Text(
                                    ' ${secondUser?.displayName}\'s',
                                    style: TextStyle(
                                        fontSize: 22, color: Colors.teal[500]),
                                  ),
                                  Text(
                                    ' invitation?',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.blueGrey[500]),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 0.5,
                              color: Colors.blue,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Material(
                                    elevation: 20,
                                    borderRadius: BorderRadius.circular(100),
                                    shadowColor: Colors.yellow[50],
                                    child: frostedRed(
                                      TextButton(
                                          child: const Text('Reject'),
                                          onPressed: () {
                                            // chatState.block(authState.userId!,
                                            //     widget.userProfileId!);

                                            // statusInit =
                                            //     ChatStatus.blocked.index;
                                          }),
                                    ),
                                  ),
                                  Material(
                                    elevation: 20,
                                    borderRadius: BorderRadius.circular(100),
                                    shadowColor: Colors.yellow[50],
                                    child: frostedGreen(
                                      TextButton(
                                          child: const Text('Accept'),
                                          onPressed: () async {
                                            // await chatState.accept(
                                            //     authState.userId,
                                            //     widget.userProfileId);

                                            // statusInit =
                                            //     ChatStatus.accepted.index;
                                          }),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }
      // subscribe();
      // cprint('${replyMessage?.value.message} reply message');
      // seenMessagesState.value = true;
      return Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (replyMessage?.value.message != null) buildReply(),
                if (myOrders.value != '') orderProducts(),
                // _image == null
                //     ? Container()
                //     : Stack(
                //         children: [
                //           Container(
                //             height: Get.width * 0.5,
                //             width: Get.width * 0.5,
                //             child: FittedBox(
                //               child: ComposeThumbnail(
                //                 image: _image,
                //                 onCrossIconPressed: _onCrossThumbnail,
                //               ),
                //             ),
                //           ),
                //           Positioned(
                //             top: 0,
                //             right: 0,
                //             child: Padding(
                //               padding: const EdgeInsets.all(8.0),
                //               child: IconButton(
                //                 onPressed: () => _onCrossThumbnail,
                //                 color: Colors.black,
                //                 icon: Icon(CupertinoIcons.clear_circled_solid),
                //               ),
                //             ),
                //           ),
                //         ],
                //       ),
                !isSelected.value
                    ? Container()
                    // : commissionProduct == null
                    //     ? Container()
                    : Stack(
                        children: [
                          ductId == null
                              ? Container()
                              : frostedTeal(
                                  SizedBox(
                                    width: Get.width,
                                    height: Get.width * 0.25,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      addAutomaticKeepAlives: false,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) => Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                            height: Get.width * 0.3,
                                            width: Get.width,
                                            child: _SelectedProduct(
                                                list: commissionProduct![index],
                                                model: model,
                                                ductId: ductId)),
                                      ),
                                      itemCount: commissionProduct?.length ?? 0,
                                    ),
                                  ),
                                ),
                          chatUserProductId == null ||
                                  chatUserProductId!.isEmpty ||
                                  chatUserProductId == ""
                              ? Container()
                              : frostedGreen(
                                  SizedBox(
                                    width: Get.width,
                                    height: Get.width * 0.25,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      addAutomaticKeepAlives: false,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) => Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                            height: Get.width * 0.3,
                                            width: Get.width,
                                            child: _SelectedProduct(
                                                list: chatUserProduct![index],
                                                model: model,
                                                ductId: chatUserProductId)),
                                      ),
                                      itemCount: chatUserProduct?.length ?? 0,
                                    ),
                                  ),
                                ),
                          ductId == null
                              ? Container()
                              : Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: frostedPink(Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: customTitleText(
                                      'My Product',
                                    ),
                                  )),
                                ),
                          chatUserProductId == null ||
                                  chatUserProductId!.isEmpty ||
                                  chatUserProductId == ""
                              ? Container()
                              : Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: InkWell(
                                    onTap: () {
                                      //_buyingDialog(context);
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.all(0),
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.yellow),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: customTitleText('Buy'),
                                        )),
                                  ),
                                ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              onPressed: () {
                                ductId = null;
                                chatUserProductId = null;
                                myOrders.value = '';
                              },
                              color: Colors.black,
                              icon: const Icon(
                                  CupertinoIcons.clear_circled_solid),
                            ),
                          ),
                        ],
                      ),

                Obx(
                  () => Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          _contactSheet(context);
                        },
                        //=> addMediaModal(context),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            //color: Colors.black,
                            //gradient: UniversalVariables.fabGradient,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.call,
                            size: 40,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            frostedOrange(
                              TextField(
                                controller: textEditingController,
                                focusNode: textFieldFocus,
                                onTap: () => hideEmojiContainer(),
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                                onChanged: (val) {
                                  (val.isNotEmpty && val.trim() != "")
                                      ? setWritingTo(true)
                                      : setWritingTo(false);
                                },
                                maxLines: null,
                                decoration: const InputDecoration(
                                  hintText: "Be positive in words",
                                  hintStyle: TextStyle(color: Colors.blueGrey
                                      //color: UniversalVariables.greyColor,
                                      ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(50.0),
                                      ),
                                      borderSide: BorderSide.none),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  filled: true,
                                  //fillColor: UniversalVariables.separatorColor,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (!showEmojiPicker.value) {
                                  // keyboard is visible
                                  hideKeyboard();
                                  showEmojiContainer();
                                } else {
                                  //keyboard is hidden.value
                                  showKeyboard();
                                  hideEmojiContainer();
                                }
                              },
                              child: Material(
                                elevation: 5,
                                borderRadius: BorderRadius.circular(100),
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.transparent,
                                  child: Image.asset('assets/happy (1).png'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      isWriting.value
                          ? Container()
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: GestureDetector(
                                  key: actionKey,
                                  onTap: () {
                                    _orders(context);
                                    // if (isDropdown.value) {
                                    //   floatingMenu.remove();
                                    // } else {
                                    //   //  _postProsductoption();
                                    //   floatingMenu = _createPostMenu(context);
                                    //   Overlay.of(context)!.insert(floatingMenu);
                                    // }

                                    // isDropdown.value = !isDropdown.value;

                                    //  Navigator.of(context).pushNamed('/CreateFeedPage/chat');
                                  },
                                  // onTap: () {

                                  //   cprint('is working');
                                  // },
                                  child: const Icon(
                                      CupertinoIcons.bag_badge_plus)),
                            ),
                      // kIsWeb
                      //     ? Container()
                      //     :
                      isWriting.value
                          ? Container()
                          : GestureDetector(
                              onTap: () {},
                              child: ViewDuctMenuHolder(
                                onPressed: () {},
                                menuItems: <DuctFocusedMenuItem>[
                                  DuctFocusedMenuItem(
                                      title: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                    offset: const Offset(0, 11),
                                                    blurRadius: 11,
                                                    color: Colors.black
                                                        .withOpacity(0.06))
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              color: CupertinoColors
                                                  .lightBackgroundGray),
                                          padding: const EdgeInsets.all(5.0),
                                          child: const Text(
                                            'Gallary',
                                            style: TextStyle(
                                              //fontSize: Get.width * 0.03,
                                              color: AppColor.darkGrey,
                                            ),
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        videoFile = null;
                                        audioFile = null;
                                        imageFileState = null;
                                        _thumbnail = null;
                                        //  setImage(ImageSource.gallery);
                                        final response =
                                            await FilePicker.platform.pickFiles(
                                          type: FileType.image,
                                          allowMultiple: false,
                                        );
                                        if (response == null) return;
                                        pickedFile = response.files.single;
                                        mediaType = 'image';

                                        _uploadChatImge(context);
                                      },
                                      trailingIcon:
                                          const Icon(CupertinoIcons.photo)),
                                  DuctFocusedMenuItem(
                                      title: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                    offset: const Offset(0, 11),
                                                    blurRadius: 11,
                                                    color: Colors.black
                                                        .withOpacity(0.06))
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              color:
                                                  CupertinoColors.systemOrange),
                                          padding: const EdgeInsets.all(5.0),
                                          child: const Text(
                                            'Video Files',
                                            style: TextStyle(
                                              //fontSize: Get.width * 0.03,
                                              color: AppColor.darkGrey,
                                            ),
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        videoFile = null;
                                        audioFile = null;
                                        imageFileState = null;
                                        _thumbnail = null;

                                        /// status can either be: granted, denied, restricted or permanentlyDenied
                                        var status = await camera
                                            .Permission.camera.status;
                                        if (status.isGranted) {
                                          XTypeGroup typeGroup = XTypeGroup(
                                            extensions: <String>['mp4'],
                                          );

                                          if (Platform.isMacOS ||
                                              Platform.isWindows) {
                                            final files = await openFile(
                                                acceptedTypeGroups: <
                                                    XTypeGroup>[typeGroup]);
                                            //  setState(() async {
                                            File file = File(files!.path);
                                            cprint('${file.lengthSync()} size');
                                            if (file.lengthSync() > 50000000) {
                                              // setState(() {
                                              //file = null;
                                              videoFile = null;
                                              // });
                                              _showDialogs();
                                              // _showDialog();
                                            } else {
                                              // setState(() {
                                              videoFile = file;
                                              // });
                                              if (videoFile != null) {
                                                // setState(() {
                                                //   _videoPlayerController = VideoPlayerController.file(_video!)
                                                //     ..initialize().then((value) {
                                                //       setState(() {
                                                //         _duration = _videoPlayerController!.value.duration;
                                                //       });
                                                //     });
                                                // });
                                                var thumb = await VideoThumbnail
                                                    .thumbnailFile(
                                                        imageFormat:
                                                            ImageFormat.PNG,
                                                        maxHeight: 64,
                                                        quality: 100,
                                                        video: file.path);
                                                // setState(() {
                                                videoFile = file;
                                                _thumbnail = File(thumb!);
                                                // });     // final response =
                                                //     await FilePicker.platform.pickFiles(
                                                //   type: FileType.video,
                                                //   allowMultiple: false,
                                                // );
                                                // if (response == null) return;
                                                // pickedFile = response.files.single;
                                                mediaType = 'video';
                                                // var thumb =
                                                //     await VideoThumbnail.thumbnailFile(
                                                //         imageFormat: ImageFormat.PNG,
                                                //         maxHeight: 64,
                                                //         quality: 100,
                                                //         video: pickedFile!.path
                                                //             .toString());

                                                // _thumbnail = File(thumb!);

                                                _uploadChatImge(context);
                                              }
                                            }
                                            // });
                                          } else {
                                            PickedFile? pickedFile =
                                                // ignore: deprecated_member_use
                                                await (ImagePicker().getVideo(
                                                    source: ImageSource.gallery,
                                                    maxDuration: const Duration(
                                                        seconds: 45)));
                                            File file = File(pickedFile!.path);
                                            cprint('${file.lengthSync()}');
                                            if (file.lengthSync() > 500000000) {
                                              // setState(() {
                                              //   //file = null;
                                              videoFile = null;
                                              // });
                                              _showDialogs();
                                              // _showDialog();
                                            } else {
                                              final thumb = await VideoThumbnail
                                                  .thumbnailFile(
                                                      imageFormat:
                                                          ImageFormat.PNG,
                                                      maxHeight: 64,
                                                      quality: 100,
                                                      video: file.path);
                                              // setState(() {
                                              videoFile = file;
                                              _thumbnail = File(
                                                  thumb!); // final response =
                                              //     await FilePicker.platform.pickFiles(
                                              //   type: FileType.video,
                                              //   allowMultiple: false,
                                              // );
                                              // if (response == null) return;
                                              // pickedFile = response.files.single;
                                              mediaType = 'video';
                                              // var thumb =
                                              //     await VideoThumbnail.thumbnailFile(
                                              //         imageFormat: ImageFormat.PNG,
                                              //         maxHeight: 64,
                                              //         quality: 100,
                                              //         video: pickedFile!.path
                                              //             .toString());

                                              // _thumbnail = File(thumb!);

                                              _uploadChatImge(context);
                                              //});

                                              // if (_video != null) {
                                              //   setState(() {
                                              //     _videoPlayerController = VideoPlayerController.file(_video!)
                                              //       ..initialize().then((value) {
                                              //         setState(() {
                                              //           _duration = _videoPlayerController!.value.duration;
                                              //         });
                                              //       });
                                              //   });
                                              // }
                                            }
                                          }
                                        } else if (status.isDenied) {
                                          // We didn't ask for permission yet or the permission has been denied before but not permanently.
                                          if (await camera.Permission.camera
                                              .request()
                                              .isGranted) {
                                            // Either the permission was already granted before or the user just granted it.

                                            XTypeGroup typeGroup = XTypeGroup(
                                              extensions: <String>['mp4'],
                                            );

                                            if (Platform.isMacOS ||
                                                Platform.isWindows) {
                                              final files = await openFile(
                                                  acceptedTypeGroups: <
                                                      XTypeGroup>[typeGroup]);
                                              //  setState(() async {
                                              File file = File(files!.path);
                                              cprint('${file.lengthSync()}');
                                              if (file.lengthSync() >
                                                  50000000) {
                                                // setState(() {
                                                //   //file = null;
                                                videoFile = null;
                                                // });
                                                _showDialogs();
                                                // _showDialog();
                                              } else {
                                                // setState(() {
                                                videoFile = file;
                                                // });
                                                if (videoFile != null) {
                                                  // setState(() {
                                                  //   _videoPlayerController = VideoPlayerController.file(_video!)
                                                  //     ..initialize().then((value) {
                                                  //       setState(() {
                                                  //         _duration = _videoPlayerController!.value.duration;
                                                  //       });
                                                  //     });
                                                  // });
                                                  var thumb =
                                                      await VideoThumbnail
                                                          .thumbnailFile(
                                                              imageFormat:
                                                                  ImageFormat
                                                                      .PNG,
                                                              maxHeight: 64,
                                                              quality: 100,
                                                              video: file.path);
                                                  // setState(() {
                                                  videoFile = file;
                                                  _thumbnail = File(thumb!);
                                                  // });     // final response =
                                                  //     await FilePicker.platform.pickFiles(
                                                  //   type: FileType.video,
                                                  //   allowMultiple: false,
                                                  // );
                                                  // if (response == null) return;
                                                  // pickedFile = response.files.single;
                                                  mediaType = 'video';
                                                  // var thumb =
                                                  //     await VideoThumbnail.thumbnailFile(
                                                  //         imageFormat: ImageFormat.PNG,
                                                  //         maxHeight: 64,
                                                  //         quality: 100,
                                                  //         video: pickedFile!.path
                                                  //             .toString());

                                                  // _thumbnail = File(thumb!);

                                                  _uploadChatImge(context);
                                                }
                                              }
                                              // });
                                            } else {
                                              PickedFile? pickedFile =
                                                  // ignore: deprecated_member_use
                                                  await (ImagePicker().getVideo(
                                                      source:
                                                          ImageSource.gallery,
                                                      maxDuration:
                                                          const Duration(
                                                              seconds: 45)));
                                              File file =
                                                  File(pickedFile!.path);
                                              cprint('${file.lengthSync()}');
                                              if (file.lengthSync() >
                                                  50000000) {
                                                // setState(() {
                                                //   //file = null;
                                                videoFile = null;
                                                // });
                                                _showDialogs();
                                                // _showDialog();
                                              } else {
                                                final thumb =
                                                    await VideoThumbnail
                                                        .thumbnailFile(
                                                            imageFormat:
                                                                ImageFormat.PNG,
                                                            maxHeight: 64,
                                                            quality: 100,
                                                            video: file.path);
                                                // setState(() {
                                                videoFile = file;
                                                _thumbnail = File(thumb!);
                                                //});
                                                // final response =
                                                //     await FilePicker.platform.pickFiles(
                                                //   type: FileType.video,
                                                //   allowMultiple: false,
                                                // );
                                                // if (response == null) return;
                                                // pickedFile = response.files.single;
                                                mediaType = 'video';
                                                // var thumb =
                                                //     await VideoThumbnail.thumbnailFile(
                                                //         imageFormat: ImageFormat.PNG,
                                                //         maxHeight: 64,
                                                //         quality: 100,
                                                //         video: pickedFile!.path
                                                //             .toString());

                                                // _thumbnail = File(thumb!);

                                                _uploadChatImge(context);
                                              }
                                            }
                                          }
                                        }
                                      },
                                      trailingIcon: const Icon(
                                        CupertinoIcons.video_camera,
                                        color: AppColor.darkGrey,
                                      )),
                                  DuctFocusedMenuItem(
                                      title: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                    offset: const Offset(0, 11),
                                                    blurRadius: 11,
                                                    color: Colors.black
                                                        .withOpacity(0.06))
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              color:
                                                  CupertinoColors.systemYellow),
                                          padding: const EdgeInsets.all(5.0),
                                          child: const Text(
                                            'Audio Files',
                                            style: TextStyle(
                                              //fontSize: Get.width * 0.03,
                                              color: AppColor.darkGrey,
                                            ),
                                          ),
                                        ),
                                      ),
                                      onPressed: () async {
                                        videoFile = null;
                                        audioFile = null;
                                        imageFileState = null;
                                        _thumbnail = null;
                                        // final response =
                                        //     await FilePicker.platform.pickFiles(
                                        //   type: FileType.audio,
                                        //   allowMultiple: false,
                                        // );
                                        // if (response == null) return;
                                        // pickedFile = response.files.single;
                                        final pickedFiles =
                                            // ignore: deprecated_member_use
                                            await FilePicker.platform.pickFiles(
                                                type: FileType.audio);

                                        File file = File(pickedFiles!
                                            .files.single.path
                                            .toString());
                                        cprint('${file.lengthSync()}');
                                        if (file.lengthSync() > 5000000) {
                                          //file = null;
                                          audioFile = null;

                                          _showDialogs();
                                        } else {
                                          audioFile = file;

                                          if (audioFile != null) {
                                            audioFile = file;
                                          }
                                        }
                                        mediaType = 'audio';

                                        _uploadChatImge(context);
                                      },
                                      trailingIcon: const Icon(
                                          CupertinoIcons.music_note_2)),
                                ],
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: const CircleAvatar(
                                    radius: 14,
                                    backgroundColor: Colors.yellow,
                                    child: Icon(
                                      CupertinoIcons.add_circled_solid,
                                      color: Colors.black,
                                    ),
                                    // Image.asset('assets/folder.png'),
                                  ),
                                ),
                              ),
                              //  customButton(
                              //   'Media',
                              //   Image.asset('assets/folder.png'),
                              // ),
                            ),

                      //  GestureDetector(
                      //     child: const Icon(
                      //       Icons.camera_alt,
                      //       color: Colors.cyan,
                      //     ),
                      //     onTap: () async {
                      //       final response =
                      //           await FilePicker.platform.pickFiles(
                      //         type: FileType.custom,
                      //         allowMultiple: false,
                      //         allowedExtensions: [
                      //           'jpg',
                      //           'png',
                      //         ],
                      //       );
                      //       if (response == null) return;
                      //       pickedFile = response.files.single;

                      //       _uploadChatImge(context);

                      //     }

                      //     ),
                      isWriting.value
                          ? KeyboardDismisser(
                              gestures: const [
                                GestureType.onTap,
                                GestureType.onPanUpdateUpDirection,
                              ],
                              child: Container(
                                margin: const EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                    color: Colors.blueGrey,
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.blueGrey.withOpacity(0.1),
                                        Colors.blueGrey.withOpacity(0.2),
                                        Colors.grey.withOpacity(0.3)
                                        // Color(0xfffbfbfb),
                                        // Color(0xfff7f7f7),
                                      ],
                                      // begin: Alignment.topCenter,
                                      // end: Alignment.bottomCenter,
                                    ),
                                    //  gradient: UniversalVariables.fabGradient,
                                    shape: BoxShape.circle),
                                child: IconButton(
                                    icon: const Icon(
                                      Icons.send,
                                      color: Colors.black,
                                    ),
                                    onPressed: statusInit ==
                                            ChatStatus.blocked.index
                                        ? null
                                        : () => ductId != null
                                            ? submitMessage(
                                                textEditingController.text,
                                                MessagesType.Products,
                                                DateTime.now()
                                                    .millisecondsSinceEpoch,
                                                ductId,
                                                context,
                                                null)
                                            : chatUserProductId != null
                                                ? submitMessage(
                                                    textEditingController.text,
                                                    MessagesType
                                                        .ChatUserProducts,
                                                    DateTime.now()
                                                        .millisecondsSinceEpoch,
                                                    chatUserProductId,
                                                    context,
                                                    null)
                                                : myOrders.value != ''
                                                    ? submitMessage(
                                                        textEditingController
                                                            .text,
                                                        MessagesType.MyOrders,
                                                        DateTime.now()
                                                            .millisecondsSinceEpoch,
                                                        myOrders.value,
                                                        context,
                                                        null)
                                                    : imageFileState != null
                                                        ? submitMessage(
                                                            textEditingController
                                                                .text,
                                                            MessagesType.Image,
                                                            DateTime.now()
                                                                .millisecondsSinceEpoch,
                                                            null,
                                                            context,
                                                            null)
                                                        : sendMessageToUser(
                                                            context: context,
                                                            currentUser:
                                                                currentUser!,
                                                            secondUser:
                                                                secondUser!,
                                                            text:
                                                                textEditingController
                                                                    .text,
                                                            type: MessagesType
                                                                .Text)
                                    // submitMessage(
                                    //     textEditingController
                                    //         .text,
                                    //     MessagesType.Text,
                                    //     DateTime.now()
                                    //         .millisecondsSinceEpoch,
                                    //     null,
                                    //     context,
                                    //     null),
                                    //    color: viewductWhite,
                                    ),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
                Obx(() => showEmojiPicker.value
                    ? Container(child: emojiContainer())
                    : Container())
              ],
            ),
          ),
          width: double.infinity,
//height: 100.0,
        ),
        // Container(
        //   child: Row(
        //     children: <Widget>[
        //       IconButton(
        //           // color: viewductWhite,
        //           padding: EdgeInsets.all(0.0),
        //           icon: Icon(Icons.arrow_drop_down_circle, size: 40),
        //           onPressed: () async {
        //             // final gif = await GiphyPicker.pickGif(
        //             //     context: context,
        //             //     apiKey: 'PkjPKUvd84HUEd2GGStxDxW8za02HBti');
        //             // submitMessage(gif.images.original.url, MessageType.image,
        //             //     DateTime.now().millisecondsSinceEpoch);
        //           }),
        //       IconButton(
        //         icon: new Icon(Icons.image),
        //         padding: EdgeInsets.all(0.0),
        //         onPressed: chatState.chatUser.chatState == ChatStatus.blocked.index
        //             ? null
        //             : () {
        //                 Navigator.push(
        //                     context,
        //                     MaterialPageRoute(
        //                         builder: (context) => HybridImagePicker(
        //                               title: 'Pick an image',
        //                               callback: getImage,
        //                             ))).then((url) {
        //                   if (url != null) {
        //                     submitMessage(
        //                         url, MessagesType.Image, uploadTimestamp);
        //                   }
        //                 });
        //               },
        //         //    color: viewductWhite,
        //       ),
        //       Flexible(
        //         child: Container(
        //             child: SingleChildScrollView(
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: <Widget>[
        //               Material(
        //                 elevation: 20,
        //                 color: Colors.transparent,
        //                 borderRadius: BorderRadius.circular(100),
        //                 child: frostedBlack(
        //                   Padding(
        //                     padding: const EdgeInsets.symmetric(
        //                         horizontal: 8.0, vertical: 8.0),
        //                     child: TextField(
        //                       controller: textEditingController,
        //                       // onChanged: (text) {
        //                       //   Provider.of<Composemessagestate>(context, listen: false)
        //                       //       .onDescriptionChanged(text, searchState);
        //                       // },
        //                       maxLines: null,
        //                       decoration: InputDecoration.collapsed(
        //                           border: InputBorder.none,
        //                           hintText: 'Start with a message',
        //                           hintStyle: TextStyle(fontSize: 18)),
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         )
        //             // TextField(
        //             //   maxLines: null,
        //             //   controller: messageController,
        //             //   decoration: InputDecoration.collapsed(
        //             //     hintText: 'Type your message',
        //             //   ),
        //             // ),
        //             ),
        //       ),
        //       // Button send message

        //     ],
        //   ),
        //   width: double.infinity,
        //   height: 60.0,
        //   // decoration: new BoxDecoration(
        //   //   border:
        //   //       new Border(top: new BorderSide(color: Colors.black, width: 0.5)),
        //   //   color: viewductBlack,
        //   // ),
        // ),
      );
      // return Align(
      //   alignment: Alignment.bottomLeft,
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.end,
      //     children: <Widget>[
      //       Divider(
      //         thickness: 0,
      //         height: 1,
      //       ),
      //       TextField(
      //         onSubmitted: (val) async {
      //           submitMessage(content, type, timestamp);
      //         },
      //         controller: messageController,
      //         decoration: InputDecoration(
      //           contentPadding:
      //               EdgeInsets.symmetric(horizontal: 10, vertical: 13),
      //           alignLabelWithHint: true,
      //           hintText: 'Start with a message...',
      //           suffixIcon: IconButton(
      //             icon: Icon(Icons.send),
      //             onPressed: () {
      //               submitMessage(content, type, timestamp);
      //             },
      //           ),
      //           // fillColor: Colors.black12, filled: true
      //         ),
      //       ),
      //     ],
      //   ),
      // );
    }

    Widget _chatScreenBody(
        BuildContext context, List<ChatMessage> streamMessage) {
      // if (chatState.chatStatus.value.chatStatus == ChatStatus.blocked.index) {
      //   return Dialog(
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(20),
      //     ),
      //     child: frostedWhite(
      //       Container(
      //         height: Get.width * 0.5,
      //         width: Get.width * 0.6,
      //         decoration:
      //             BoxDecoration(borderRadius: BorderRadius.circular(20)),
      //         child: SafeArea(
      //           child: Stack(
      //             children: <Widget>[
      //               Center(
      //                 child: SingleChildScrollView(
      //                   child: Column(
      //                     mainAxisAlignment: MainAxisAlignment.center,
      //                     crossAxisAlignment: CrossAxisAlignment.center,
      //                     children: <Widget>[
      //                       Material(
      //                         elevation: 20,
      //                         shadowColor: TwitterColor.mystic,
      //                         color: Colors.transparent,
      //                         borderRadius: BorderRadius.circular(100),
      //                         child: AnimatedContainer(
      //                           duration: const Duration(milliseconds: 500),
      //                           padding:
      //                               const EdgeInsets.symmetric(horizontal: 10),
      //                           decoration: BoxDecoration(
      //                               border: Border.all(
      //                                   color: Colors.white, width: 5),
      //                               shape: BoxShape.circle),
      //                           child: RippleButton(
      //                             child: customImage(
      //                               context,
      //                               chatState.chatUser!.profilePic,
      //                               height: 60,
      //                             ),
      //                             borderRadius: BorderRadius.circular(50),
      //                             onPressed: () {
      //                               // Navigator.of(context).pushNamed(
      //                               //     '/ProfilePage/',
      //                               //     arguments: chatState?.chatUser);
      //                             },
      //                           ),
      //                         ),
      //                       ),
      //                       Padding(
      //                         padding: const EdgeInsets.all(8.0),
      //                         child: Row(
      //                           crossAxisAlignment: CrossAxisAlignment.center,
      //                           mainAxisAlignment: MainAxisAlignment.center,
      //                           children: [
      //                             Text(
      //                               'Unblock',
      //                               style: TextStyle(
      //                                   fontSize: 20,
      //                                   color: Colors.blueGrey[500]),
      //                             ),
      //                             Text(
      //                               ' ${chatState.chatUser!.displayName}',
      //                               style: TextStyle(
      //                                   fontSize: 22, color: Colors.teal[500]),
      //                             ),
      //                           ],
      //                         ),
      //                       ),
      //                       const SizedBox(
      //                         height: 10,
      //                       ),
      //                       Container(
      //                         height: 0.5,
      //                         color: Colors.blue,
      //                       ),
      //                       Padding(
      //                         padding: const EdgeInsets.all(15.0),
      //                         child: Row(
      //                           crossAxisAlignment: CrossAxisAlignment.center,
      //                           mainAxisAlignment:
      //                               MainAxisAlignment.spaceBetween,
      //                           children: [
      //                             Material(
      //                               elevation: 20,
      //                               borderRadius: BorderRadius.circular(100),
      //                               shadowColor: Colors.yellow[50],
      //                               child: frostedRed(
      //                                 // ignore: deprecated_member_use
      //                                 TextButton(
      //                                     child: const Text('Cancel'),
      //                                     onPressed: () {
      //                                       Navigator.pop(context);
      //                                     }),
      //                               ),
      //                             ),
      //                             Material(
      //                               elevation: 20,
      //                               borderRadius: BorderRadius.circular(100),
      //                               shadowColor: Colors.yellow[50],
      //                               child: frostedGreen(
      //                                 TextButton(
      //                                     child: const Text('Unblock'),
      //                                     onPressed: () {
      //                                       chatState.unblock(authState.userId!,
      //                                           widget.userProfileId!,
      //                                           chatStatus:
      //                                               ChatStatus.accepted.index);
      //                                       // chatState.accept(authState.userId,
      //                                       //     userProfileId);

      //                                       // statusInit =
      //                                       //     ChatStatus.accepted.index;
      //                                     }),
      //                               ),
      //                             )
      //                           ],
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                 ),
      //               )
      //             ],
      //           ),
      //         ),
      //       ),
      //     ),
      //   );
      // }
      return streamMessage.isEmpty
          //  ||
          // sharedSecret == null
          ? Center(
              child: showEmojiPicker.value
                  ? Container()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(100),
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.transparent,
                            child: Image.asset('assets/happy.png'),
                          ),
                        ),
                        const Text(' Say Hi to'),
                        Text(' ${secondUser?.displayName}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                      ],
                    ),
            )
          : NotificationListener<ScrollEndNotification>(
              child: ListView(
                padding: const EdgeInsets.all(10.0),
                children: getGroupedMessages(context, streamMessage),
                controller: _controller,
                physics: BouncingScrollPhysics(),
                reverse: true,
                shrinkWrap: true,
              ),
              onNotification: (notification) {
                // if (t is ScrollEndNotification) {
                //  cprint(_controller.position.pixels.toString());
                // cprint(_controller.position.minScrollExtent.toString());
                if (notification.metrics.atEdge) {
                  if (notification.metrics.pixels == 0) {
                    //subscribe(pageIndex: 'top');
                    cprint('At top');
                    cprint(lastId.toString());
                  } else {
                    // subscribe(pageIndex: 'bottom');
                    cprint('At bottom');
                  }
                }
                // }
                //How many pixels scrolled from pervious frame
                // print(t!.scrollDelta);

                // //List scroll position
                // print(t.metrics.pixels);
                return true;
              },
            );
      // ListView.builder(
      //     controller: _controller,
      //     shrinkWrap: true,
      //     reverse: false,
      //     physics: BouncingScrollPhysics(),
      //     itemCount: streamMessage.length,
      //     itemBuilder: (context, index) =>
      //         // getGroupedMessages(context, streamMessage)[index]
      //         chatMessage(streamMessage[index], context),
      //   ));
    }

    // @override
    // void didChangeAppLifecycleState(AppLifecycleState state) {
    //   if (state == AppLifecycleState.resumed)
    //     chatState.getChatActiveness(
    //         'online', authState.appUser!.$id, widget.userProfileId.toString());
    //   else
    //     chatState.setLastSeen(
    //       authState.appUser!.$id,
    //       widget.userProfileId.toString(),
    //     );
    // }

    // useEffect(
    //   () {
    //     animationController.forward();
    //     subscribe();
    //     // onlineStatusState.value = ChatOnlineStatus().obs;
    //     // textEditingController.addListener(() async {
    //     //   final database = Databases(
    //     //     clientConnect(),
    //     //   );
    //     //   if (textEditingController.text.isNotEmpty && typing.value == false) {
    //     //     await chatState.getChatActiveness(
    //     //         'typing', authState.appUser!.$id, userProfileId.toString());

    //     //     // await database
    //     //     //     .getDocument(
    //     //     //   databaseId: databaseId,
    //     //     //   collectionId: chatActiveColl,
    //     //     //   documentId:
    //     //     //       '${userProfileId!.splitByLengths((userProfileId!.length) ~/ 2)[0]}_${authState.appUser!.$id.splitByLengths((authState.appUser!.$id.length) ~/ 2)[0]}',
    //     //     // )
    //     //     //     .then((item) {
    //     //     //   onlineStatusState.value.value =
    //     //     //       ChatOnlineStatus.fromJson(item.data);
    //     //     // });
    //     //     typing.value = true;
    //     //     cprint('I\'m typing');
    //     //   }
    //     //   if (textEditingController.text.isEmpty && typing == true) {
    //     //     await chatState.getChatActiveness(
    //     //         'online', authState.appUser!.$id, userProfileId.toString());

    //     //     // await database
    //     //     //     .getDocument(
    //     //     //   databaseId: databaseId,
    //     //     //   collectionId: chatActiveColl,
    //     //     //   documentId:
    //     //     //       '${userProfileId!.splitByLengths((userProfileId!.length) ~/ 2)[0]}_${authState.appUser!.$id.splitByLengths((authState.appUser!.$id.length) ~/ 2)[0]}',
    //     //     // )
    //     //     //     .then((item) {
    //     //     //   onlineStatusState.value.value =
    //     //     //       ChatOnlineStatus.fromJson(item.data);
    //     //     // });
    //     //     typing.value = false;
    //     //   }
    //     // });

    //     FToast().init(Get.context!);
    //     chatUserProductId = widget.productId;

    //     widget.isVductProduct == true
    //         ? isSelected.value = true
    //         : isSelected.value = false;
    //     subStreaming;
    //     onlineStatusStreaming;
    //     cprint(
    //         "${chatState.myonlineStatus.value.notofication} notification effect");
    //     //   onlineStatusStreaming;
    //     return () {
    //       subscription?.close;
    //       ;
    //     };
    //   },
    //   [
    //     // replyMessage?.value.message,
    //     //subStreaming
    //     chatState.myonlineStatus.value.notofication,
    //     chatState.chatMessage, chatState.onlineStatus
    //   ],
    // );

    return WillPopScope(
      onWillPop: _onWillPop,
      child: KeyboardDismisser(
          gestures: const [
            GestureType.onTap,
            GestureType.onPanUpdateUpDirection,
          ],
          child: Scaffold(
              //  backgroundColor: TwitterColor.mystic,
              key: _scaffoldKey,
              body: SafeArea(
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    ThemeMode.system == ThemeMode.light
                        ? frostedYellow(
                            Container(
                              height: Get.height,
                              width: Get.width,
                              decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(100),
                                //color: Colors.blueGrey[50]
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.yellow[100]!.withOpacity(0.3),
                                    Colors.yellow[200]!.withOpacity(0.1),
                                    Colors.yellowAccent[100]!.withOpacity(0.2)
                                    // Color(0xfffbfbfb),
                                    // Color(0xfff7f7f7),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    Positioned(
                      top: -220,
                      right: -200,
                      child: Transform.rotate(
                        angle: 90,
                        child: Container(
                          height: Get.width * 0.8,
                          width: Get.width,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/ankkara1.jpg'))),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -80,
                      left: -250,
                      child: Transform.rotate(
                        angle: 90,
                        child: Container(
                          height: Get.width * 0.8,
                          width: Get.width,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/ankkara1.jpg'))),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: -250,
                      child: Transform.rotate(
                        angle: 90,
                        child: Container(
                          height: Get.width * 0.8,
                          width: Get.width,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/ankara3.jpg'))),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 40,
                      right: -260,
                      child: Transform.rotate(
                        angle: 30,
                        child: Container(
                          height: Get.width * 0.8,
                          width: Get.width,
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/ankkara1.jpg'))),
                        ),
                      ),
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: Container(
                        color: (Colors.white12).withOpacity(0.1),
                      ),
                    ),
                    FractionallySizedBox(
                      alignment: Alignment.bottomCenter,
                      heightFactor: 1 - (heightFactor * 0.42),
                      child: PageView(
                        children: [
                          Stack(
                            children: [
                              ref
                                  .watch(
                                      currentUserSecondUserChatsDetailsProvider(
                                          ChatCridentialsModel(
                                    ref: ref,
                                    currentSecondUserChatkey: ref
                                        .read(chatUserIdProvider.notifier)
                                        .state,
                                    currentUser: currentUser!.userId.toString(),
                                    isDowmloaded: '',
                                    secondUser: widget.userProfileId.toString(),
                                  )))
                                  .when(
                                    data: (messages) {
                                      return ref
                                          .watch(getChatStreamProvider(
                                              ChatCridentialsModel(
                                            ref: ref,
                                            currentSecondUserChatkey:
                                                widget.chatIdUsers ?? '',
                                            currentUser:
                                                currentUser.userId.toString(),
                                            isDowmloaded: '',
                                            secondUser:
                                                widget.userProfileId.toString(),
                                          )))
                                          .when(
                                            data: (data) {
                                              if (data.events.contains(
                                                'databases.${AppwriteConstants.chatDatabase}.collections.${ref.read(chatUserIdProvider.notifier).state}.documents.*.create',
                                              )) {
                                                messages.insert(
                                                    0,
                                                    ChatMessage.fromJson(
                                                        data.payload));
                                              } else if (data.events.contains(
                                                'databases.${AppwriteConstants.chatDatabase}.collections.${ref.read(chatUserIdProvider.notifier).state}.documents.*.update',
                                              )) {
                                                // get id of original chat
                                                final startingPoint = data
                                                    .events[0]
                                                    .lastIndexOf('documents.');
                                                final endPoint = data.events[0]
                                                    .lastIndexOf('.update');
                                                final chatId = data.events[0]
                                                    .substring(
                                                        startingPoint + 10,
                                                        endPoint);

                                                var chat = messages
                                                    .where((element) =>
                                                        element.key == chatId)
                                                    .first;

                                                final chatIndex =
                                                    messages.indexOf(chat);
                                                messages.removeWhere(
                                                    (element) =>
                                                        element.key == chatId);

                                                chat = ChatMessage.fromJson(
                                                    data.payload);
                                                messages.insert(
                                                    chatIndex, chat);
                                              }

                                              return Align(
                                                  alignment: Alignment.topRight,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 50),
                                                    child:
                                                        //  isDesktop == true
                                                        //     ? Container()
                                                        //     :
                                                        _chatScreenBody(
                                                            context, messages),
                                                  ));
                                            },
                                            error: (error, stackTrace) =>
                                                ErrorText(
                                              error: error.toString(),
                                            ),
                                            loading: () {
                                              return Align(
                                                  alignment: Alignment.topRight,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 50),
                                                    child:
                                                        //  isDesktop == true
                                                        //     ? Container()
                                                        //     :
                                                        _chatScreenBody(
                                                            context, messages),
                                                  ));
                                            },
                                          );
                                    },
                                    error: (error, stackTrace) => ErrorText(
                                      error: error.toString(),
                                    ),
                                    loading: () => const Loader(),
                                  ),
                              isBlocked()
                                  ? Container()
                                  :
                                  //chatControls()
                                  _bottomEntryField(context),
                            ],
                          ),
                          // Column(
                          //   children: [
                          //     // List of saved messages
                          //     buildSavedMessages()
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      right: 10,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () async {
                                          // await chatState.getChatActiveness(
                                          //   'online',
                                          //   curruserId,
                                          //   otheruserId,
                                          // );
                                          // chatState.onlineStatus.value
                                          //         .notofication ==
                                          //     null;

                                          // chatState.chatMessage.value = [];
                                          //chatSetState.value.value = [];
                                          // chatState.onlineStatus.value
                                          //     .chatOnlineChatStatus = null;
                                          // chatState.onlineStatus.value.seenChat =
                                          //     null;

                                          // // statusInit = await chatState.getStatus(
                                          // //     authState.userModel!.key.toString(),
                                          // //     userProfileId!);
                                          // chatState.setLastSeen(
                                          //   authState.appUser!.$id,
                                          //   widget.userProfileId.toString(),
                                          // );
                                          // Get.back();
                                          Navigator.pop(context);
                                        },
                                        //color: Colors.black,
                                        icon: const Icon(CupertinoIcons.back),
                                      ),
                                      Hero(
                                        tag: secondUser!.profilePic.toString(),
                                        child: Material(
                                          elevation: 20,
                                          shadowColor: TwitterColor.mystic,
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 500),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 5),
                                                shape: BoxShape.circle),
                                            child: RippleButton(
                                              child: customImage(
                                                context,
                                                secondUser.profilePic,
                                                height: 40,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              onPressed: () {
                                                // chatState.setLastSeen(
                                                //   authState.appUser!.$id,
                                                //   widget.userProfileId.toString(),
                                                // );
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ProfileResponsiveView(
                                                              profileId: widget
                                                                  .userProfileId,
                                                              profileType:
                                                                  ProfileType
                                                                      .Profile,
                                                            )));

                                                // Navigator.of(context).pushNamed(
                                                //     '/ProfilePage/',
                                                //     arguments: chatState?.chatUser);
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfileResponsiveView(
                                                      profileId:
                                                          widget.userProfileId,
                                                      profileType:
                                                          ProfileType.Store,
                                                    )));
                                      },
                                      child: Row(children: [
                                        Image.asset(
                                          'assets/shop.png',
                                          width: 40,
                                        ),
                                        const Icon(Icons.arrow_right),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.blueGrey[50],
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.black.withOpacity(0.6),
                                                Colors.black.withOpacity(0.7),
                                                Colors.black.withOpacity(0.8)
                                                // Color(0xfffbfbfb),
                                                // Color(0xfff7f7f7),
                                              ],
                                              // begin: Alignment.topCenter,
                                              // end: Alignment.bottomCenter,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: customText(
                                              'Store',
                                              context: context,
                                              style: const TextStyle(
                                                color: Colors.yellow,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        )
                                      ])),
                                ],
                              ),
                              // Obx(
                              //   () => ViewDuctMenuHolder(
                              //     onPressed: () {},
                              //     menuItems: <DuctFocusedMenuItem>[
                              //       myNotificationBlockStatus
                              //                   .value.value.notofication ==
                              //               null
                              //           ? DuctFocusedMenuItem(
                              //               title: Padding(
                              //                 padding: const EdgeInsets.symmetric(
                              //                     horizontal: 20.0),
                              //                 child: Container(
                              //                   decoration: BoxDecoration(
                              //                       boxShadow: [
                              //                         BoxShadow(
                              //                             offset:
                              //                                 const Offset(0, 11),
                              //                             blurRadius: 11,
                              //                             color: Colors.black
                              //                                 .withOpacity(0.06))
                              //                       ],
                              //                       borderRadius:
                              //                           BorderRadius.circular(18),
                              //                       color: CupertinoColors
                              //                           .lightBackgroundGray),
                              //                   padding:
                              //                       const EdgeInsets.all(5.0),
                              //                   child: const Text(
                              //                     'Off Notification',
                              //                     style: TextStyle(
                              //                       //fontSize: Get.width * 0.03,
                              //                       color: AppColor.darkGrey,
                              //                     ),
                              //                   ),
                              //                 ),
                              //               ),
                              //               onPressed: () async {
                              //                 await chatState.offNotification(
                              //                     authState.appUser!.$id,
                              //                     widget.userProfileId!,
                              //                     chatStatus: 'off');
                              //                 FToast().showToast(
                              //                     child: Padding(
                              //                       padding:
                              //                           const EdgeInsets.all(5.0),
                              //                       child: Container(
                              //                           // width:
                              //                           //    Get.width * 0.3,
                              //                           decoration: BoxDecoration(
                              //                               boxShadow: [
                              //                                 BoxShadow(
                              //                                     offset:
                              //                                         const Offset(
                              //                                             0, 11),
                              //                                     blurRadius: 11,
                              //                                     color: Colors
                              //                                         .black
                              //                                         .withOpacity(
                              //                                             0.06))
                              //                               ],
                              //                               borderRadius:
                              //                                   BorderRadius
                              //                                       .circular(18),
                              //                               color: CupertinoColors
                              //                                   .systemRed),
                              //                           padding:
                              //                               const EdgeInsets.all(
                              //                                   5.0),
                              //                           child: Text(
                              //                             'Notification Off',
                              //                             style: TextStyle(
                              //                                 color: CupertinoColors
                              //                                     .darkBackgroundGray,
                              //                                 fontWeight:
                              //                                     FontWeight
                              //                                         .w900),
                              //                           )),
                              //                     ),
                              //                     gravity: ToastGravity.TOP_LEFT,
                              //                     toastDuration:
                              //                         Duration(seconds: 3));

                              //                 // Get.back();

                              //                 // swipeMessage(message);
                              //                 // setState(() {});
                              //                 // textFieldFocus.nextFocus();
                              //               },
                              //               trailingIcon: const Icon(CupertinoIcons
                              //                   .rectangle_arrow_up_right_arrow_down_left))
                              //           : myNotificationBlockStatus
                              //                       .value.value.notofication ==
                              //                   'On'
                              //               ? DuctFocusedMenuItem(
                              //                   title: Padding(
                              //                     padding:
                              //                         const EdgeInsets.symmetric(
                              //                             horizontal: 20.0),
                              //                     child: Container(
                              //                       decoration: BoxDecoration(
                              //                           boxShadow: [
                              //                             BoxShadow(
                              //                                 offset:
                              //                                     const Offset(
                              //                                         0, 11),
                              //                                 blurRadius: 11,
                              //                                 color: Colors.black
                              //                                     .withOpacity(
                              //                                         0.06))
                              //                           ],
                              //                           borderRadius:
                              //                               BorderRadius.circular(
                              //                                   18),
                              //                           color: CupertinoColors
                              //                               .lightBackgroundGray),
                              //                       padding:
                              //                           const EdgeInsets.all(5.0),
                              //                       child: const Text(
                              //                         'Off Notification',
                              //                         style: TextStyle(
                              //                           //fontSize: Get.width * 0.03,
                              //                           color: AppColor.darkGrey,
                              //                         ),
                              //                       ),
                              //                     ),
                              //                   ),
                              //                   onPressed: () async {
                              //                     await chatState.offNotification(
                              //                         authState.appUser!.$id,
                              //                         widget.userProfileId!,
                              //                         chatStatus: 'off');
                              //                     FToast().showToast(
                              //                         child: Padding(
                              //                           padding:
                              //                               const EdgeInsets.all(
                              //                                   5.0),
                              //                           child: Container(
                              //                               // width:
                              //                               //    Get.width * 0.3,
                              //                               decoration: BoxDecoration(
                              //                                   boxShadow: [
                              //                                     BoxShadow(
                              //                                         offset:
                              //                                             const Offset(0,
                              //                                                 11),
                              //                                         blurRadius:
                              //                                             11,
                              //                                         color: Colors
                              //                                             .black
                              //                                             .withOpacity(
                              //                                                 0.06))
                              //                                   ],
                              //                                   borderRadius:
                              //                                       BorderRadius
                              //                                           .circular(
                              //                                               18),
                              //                                   color:
                              //                                       CupertinoColors
                              //                                           .systemRed),
                              //                               padding:
                              //                                   const EdgeInsets
                              //                                       .all(5.0),
                              //                               child: Text(
                              //                                 'Notification Off',
                              //                                 style: TextStyle(
                              //                                     color: CupertinoColors
                              //                                         .darkBackgroundGray,
                              //                                     fontWeight:
                              //                                         FontWeight
                              //                                             .w900),
                              //                               )),
                              //                         ),
                              //                         gravity:
                              //                             ToastGravity.TOP_LEFT,
                              //                         toastDuration:
                              //                             Duration(seconds: 3));

                              //                     // Get.back();

                              //                     // swipeMessage(message);
                              //                     // setState(() {});
                              //                     // textFieldFocus.nextFocus();
                              //                   },
                              //                   trailingIcon: const Icon(
                              //                       CupertinoIcons
                              //                           .rectangle_arrow_up_right_arrow_down_left))
                              //               : DuctFocusedMenuItem(
                              //                   title: Padding(
                              //                     padding:
                              //                         const EdgeInsets.symmetric(
                              //                             horizontal: 20.0),
                              //                     child: Container(
                              //                       decoration: BoxDecoration(
                              //                           boxShadow: [
                              //                             BoxShadow(
                              //                                 offset:
                              //                                     const Offset(
                              //                                         0, 11),
                              //                                 blurRadius: 11,
                              //                                 color: Colors.black
                              //                                     .withOpacity(
                              //                                         0.06))
                              //                           ],
                              //                           borderRadius:
                              //                               BorderRadius.circular(
                              //                                   18),
                              //                           color: CupertinoColors
                              //                               .systemGreen),
                              //                       padding:
                              //                           const EdgeInsets.all(5.0),
                              //                       child: const Text(
                              //                         'On Notification',
                              //                         style: TextStyle(
                              //                           //fontSize: Get.width * 0.03,
                              //                           color: AppColor.darkGrey,
                              //                         ),
                              //                       ),
                              //                     ),
                              //                   ),
                              //                   onPressed: () {
                              //                     chatState.onNotification(
                              //                         authState.appUser!.$id,
                              //                         widget.userProfileId!,
                              //                         chatStatus: '0n');
                              //                     FToast().showToast(
                              //                         child: Padding(
                              //                           padding:
                              //                               const EdgeInsets.all(
                              //                                   5.0),
                              //                           child: Container(
                              //                               // width:
                              //                               //    Get.width * 0.3,
                              //                               decoration: BoxDecoration(
                              //                                   boxShadow: [
                              //                                     BoxShadow(
                              //                                         offset:
                              //                                             const Offset(0,
                              //                                                 11),
                              //                                         blurRadius:
                              //                                             11,
                              //                                         color: Colors
                              //                                             .black
                              //                                             .withOpacity(
                              //                                                 0.06))
                              //                                   ],
                              //                                   borderRadius:
                              //                                       BorderRadius
                              //                                           .circular(
                              //                                               18),
                              //                                   color: CupertinoColors
                              //                                       .activeGreen),
                              //                               padding:
                              //                                   const EdgeInsets
                              //                                       .all(5.0),
                              //                               child: Text(
                              //                                 'Notification On',
                              //                                 style: TextStyle(
                              //                                     color: CupertinoColors
                              //                                         .darkBackgroundGray,
                              //                                     fontWeight:
                              //                                         FontWeight
                              //                                             .w900),
                              //                               )),
                              //                         ),
                              //                         gravity:
                              //                             ToastGravity.TOP_LEFT,
                              //                         toastDuration:
                              //                             Duration(seconds: 3));
                              //                   },
                              //                   trailingIcon: const Icon(
                              //                       CupertinoIcons
                              //                           .rectangle_arrow_up_right_arrow_down_left_slash)),
                              //       myNotificationBlockStatus
                              //                   .value.value.chatStatus ==
                              //               0
                              //           ? DuctFocusedMenuItem(
                              //               title: Padding(
                              //                 padding: const EdgeInsets.symmetric(
                              //                     horizontal: 20.0),
                              //                 child: Container(
                              //                   decoration: BoxDecoration(
                              //                       boxShadow: [
                              //                         BoxShadow(
                              //                             offset:
                              //                                 const Offset(0, 11),
                              //                             blurRadius: 11,
                              //                             color: Colors.black
                              //                                 .withOpacity(0.06))
                              //                       ],
                              //                       borderRadius:
                              //                           BorderRadius.circular(18),
                              //                       color: CupertinoColors
                              //                           .systemOrange),
                              //                   padding:
                              //                       const EdgeInsets.all(5.0),
                              //                   child: const Text(
                              //                     'Unchat',
                              //                     style: TextStyle(
                              //                       //fontSize: Get.width * 0.03,
                              //                       color: AppColor.darkGrey,
                              //                     ),
                              //                   ),
                              //                 ),
                              //               ),
                              //               onPressed: () {
                              //                 chatState.unblock(authState.userId!,
                              //                     widget.userProfileId!,
                              //                     chatStatus:
                              //                         ChatStatus.accepted.index);
                              //                 FToast().showToast(
                              //                     child: Padding(
                              //                       padding:
                              //                           const EdgeInsets.all(5.0),
                              //                       child: Container(
                              //                           // width:
                              //                           //    Get.width * 0.3,
                              //                           decoration: BoxDecoration(
                              //                               boxShadow: [
                              //                                 BoxShadow(
                              //                                     offset:
                              //                                         const Offset(
                              //                                             0, 11),
                              //                                     blurRadius: 11,
                              //                                     color: Colors
                              //                                         .black
                              //                                         .withOpacity(
                              //                                             0.06))
                              //                               ],
                              //                               borderRadius:
                              //                                   BorderRadius
                              //                                       .circular(18),
                              //                               color: CupertinoColors
                              //                                   .activeGreen),
                              //                           padding:
                              //                               const EdgeInsets.all(
                              //                                   5.0),
                              //                           child: Text(
                              //                             'user chatted',
                              //                             style: TextStyle(
                              //                                 color: CupertinoColors
                              //                                     .darkBackgroundGray,
                              //                                 fontWeight:
                              //                                     FontWeight
                              //                                         .w900),
                              //                           )),
                              //                     ),
                              //                     gravity: ToastGravity.TOP_LEFT,
                              //                     toastDuration:
                              //                         Duration(seconds: 3));

                              //                 // Get.back();

                              //                 // swipeMessage(message);
                              //                 // setState(() {});
                              //                 // textFieldFocus.nextFocus();
                              //               },
                              //               trailingIcon:
                              //                   const Icon(CupertinoIcons.reply))
                              //           : DuctFocusedMenuItem(
                              //               title: Padding(
                              //                 padding: const EdgeInsets.symmetric(
                              //                     horizontal: 20.0),
                              //                 child: Container(
                              //                   decoration: BoxDecoration(
                              //                       boxShadow: [
                              //                         BoxShadow(
                              //                             offset:
                              //                                 const Offset(0, 11),
                              //                             blurRadius: 11,
                              //                             color: Colors.black
                              //                                 .withOpacity(0.06))
                              //                       ],
                              //                       borderRadius:
                              //                           BorderRadius.circular(18),
                              //                       color: CupertinoColors
                              //                           .systemYellow),
                              //                   padding:
                              //                       const EdgeInsets.all(5.0),
                              //                   child: const Text(
                              //                     'Unchat',
                              //                     style: TextStyle(
                              //                       //fontSize: Get.width * 0.03,
                              //                       color: AppColor.darkGrey,
                              //                     ),
                              //                   ),
                              //                 ),
                              //               ),
                              //               onPressed: () {
                              //                 chatState.block(authState.userId!,
                              //                     widget.userProfileId!,
                              //                     chatStatus:
                              //                         ChatStatus.blocked.index);
                              //                 FToast().showToast(
                              //                     child: Padding(
                              //                       padding:
                              //                           const EdgeInsets.all(5.0),
                              //                       child: Container(
                              //                           // width:
                              //                           //    Get.width * 0.3,
                              //                           decoration: BoxDecoration(
                              //                               boxShadow: [
                              //                                 BoxShadow(
                              //                                     offset:
                              //                                         const Offset(
                              //                                             0, 11),
                              //                                     blurRadius: 11,
                              //                                     color: Colors
                              //                                         .black
                              //                                         .withOpacity(
                              //                                             0.06))
                              //                               ],
                              //                               borderRadius:
                              //                                   BorderRadius
                              //                                       .circular(18),
                              //                               color: CupertinoColors
                              //                                   .systemRed),
                              //                           padding:
                              //                               const EdgeInsets.all(
                              //                                   5.0),
                              //                           child: Text(
                              //                             'user unchated',
                              //                             style: TextStyle(
                              //                                 color: CupertinoColors
                              //                                     .darkBackgroundGray,
                              //                                 fontWeight:
                              //                                     FontWeight
                              //                                         .w900),
                              //                           )),
                              //                     ),
                              //                     gravity: ToastGravity.TOP_LEFT,
                              //                     toastDuration:
                              //                         Duration(seconds: 3));
                              //               },
                              //               trailingIcon: const Icon(
                              //                   CupertinoIcons
                              //                       .bubble_left_bubble_right))
                              //       // DuctFocusedMenuItem(
                              //       //     title: const Text(
                              //       //       'Report User',
                              //       //       style: TextStyle(
                              //       //         //fontSize: Get.width * 0.03,
                              //       //         color: Colors.red,
                              //       //       ),
                              //       //     ),
                              //       //     onPressed: () {},
                              //       //     trailingIcon: const Icon(
                              //       //       CupertinoIcons.person,
                              //       //       color: Colors.red,
                              //       //     ))
                              //     ],
                              //     child: Padding(
                              //       padding: EdgeInsets.all(8.0),
                              //       child: Container(
                              //         decoration: BoxDecoration(
                              //             boxShadow: [
                              //               BoxShadow(
                              //                   offset: const Offset(0, 11),
                              //                   blurRadius: 11,
                              //                   color: Colors.black
                              //                       .withOpacity(0.06))
                              //             ],
                              //             borderRadius:
                              //                 BorderRadius.circular(100),
                              //             color: CupertinoColors
                              //                 .lightBackgroundGray),
                              //         padding: const EdgeInsets.all(5.0),
                              //         child: Icon(CupertinoIcons.app_badge),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          SizedBox(
                            width: Get.width,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // onlineStatusState
                                //             .value.value.chatOnlineChatStatus ==
                                //         null
                                //     ? Container()
                                //     : Padding(
                                //         padding: const EdgeInsets.all(4.0),
                                //         child: frostedWhite(
                                //           Padding(
                                //             padding: const EdgeInsets.all(8.0),
                                //             child: getPeerStatus(
                                //                 onlineStatusState.value.value
                                //                     .chatOnlineChatStatus
                                //                     .toString(),
                                //                 onlineStatusState
                                //                     .value.value.lastSeen
                                //                     .toString()),
                                //           ),
                                //         ),
                                //       ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ))),
    );
  }
}

class _Orders extends HookWidget {
  _Orders({
    Key? key,
    required this.model,
    this.list,
    this.type,
    this.ontap,
    this.chatUserProductId,
  }) : super(key: key);

  final FeedModel? model;
  final FeedModel? list;
  final DuctType? type;
  final Function? ontap;
  String? chatUserProductId;

  Widget _imageFeed(String? _image) {
    return _image == null
        ? Container()
        : SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: Get.width * 0.5,
                height: Get.width * 0.5,
                child: customNetworkImage(
                  _image,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: Get.width * 0.2,
        height: Get.width * 0.2,
        child: _imageFeed(list!.imagePath));
  }
}

class _StoreProducts extends HookWidget {
  const _StoreProducts({
    Key? key,
    required this.model,
    this.list,
    this.type,
  }) : super(key: key);

  final FeedModel? model;
  final FeedModel? list;
  final DuctType? type;

  Widget _imageFeed(String? _image) {
    return _image == null
        ? Container()
        : SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: Get.width * 0.5,
                height: Get.width * 0.5,
                child: customNetworkImage(
                  _image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _imageFeed(list!.imagePath),
        Positioned(
          bottom: 0,
          left: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              frostedOrange(
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Text('Price:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w900)),
                      Text('${list!.price}',
                          style:
                              const TextStyle(fontSize: 16, color: Colors.red)),
                    ],
                  ),
                ),
              ),
              frostedOrange(
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Text('Product:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w900)),
                      Text('${list!.productName}',
                          style: const TextStyle(
                            fontSize: 16,
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SelectedProduct extends HookWidget {
  _SelectedProduct({
    Key? key,
    required this.model,
    this.list,
    this.type,
    this.ontap,
    this.ductId,
  }) : super(key: key);

  final FeedModel? model;
  final FeedModel? list;
  final DuctType? type;
  final Function? ontap;
  String? ductId;

  Widget _imageFeed(String? _image, BuildContext context) {
    Storage storage = Storage(clientConnect());
    return _image == null
        ? Container()
        : SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                height: context.responsiveValue(
                    mobile: Get.height * 0.1,
                    tablet: Get.height * 0.1,
                    desktop: Get.height * 0.1),
                width: context.responsiveValue(
                  mobile: Get.height * 0.1,
                  tablet: Get.height * 0.1,
                ),
                child: FutureBuilder(
                  future: storage.getFileView(
                      bucketId: productBucketId,
                      fileId:
                          _image), //works for both public file and private file, for private files you need to be logged in
                  builder: (context, snapshot) {
                    return snapshot.hasData && snapshot.data != null
                        ? Image.memory(snapshot.data as Uint8List,
                            width: Get.height * 0.3,
                            height: Get.height * 0.4,
                            fit: BoxFit.contain)
                        : Center(
                            child: SizedBox(
                            width: Get.height * 0.2,
                            height: Get.height * 0.2,
                            child: LoadingIndicator(
                                indicatorType: Indicator.ballTrianglePath,

                                /// Required, The loading type of the widget
                                colors: const [
                                  Colors.pink,
                                  Colors.green,
                                  Colors.blue
                                ],

                                /// Optional, The color collections
                                strokeWidth: 0.5,

                                /// Optional, The stroke of the line, only applicable to widget which contains line
                                backgroundColor: Colors.transparent,

                                /// Optional, Background of the widget
                                pathBackgroundColor: Colors.blue

                                /// Optional, the stroke backgroundColor
                                ),
                          )
                            //  CircularProgressIndicator
                            //     .adaptive()
                            );
                  },
                ),

                //  customNetworkImage(
                //   _image,
                //   fit: BoxFit.cover,
                // ),
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: context.responsiveValue(
              mobile: Get.height * 0.1,
              tablet: Get.height * 0.1,
              desktop: Get.height * 0.1),
          width: context.responsiveValue(
            mobile: Get.height * 0.1,
            tablet: Get.height * 0.1,
          ),
          // child: _imageFeed(
          //     feedState.productlist!
          //         .firstWhere(
          //           (e) => e.key == ductId,
          //           orElse: () => FeedModel(),
          //         )
          //         .imagePath,
          //     context)
        ),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              frostedOrange(
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const Text('Price: ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w900)),
                        Text('',
                            // NumberFormat.currency(
                            //         name: feedState.productlist!
                            //                     .firstWhere(
                            //                       (e) => e.key == ductId,
                            //                     )
                            //                     .productLocation ==
                            //                 'Nigeria'
                            //             ? '₦'
                            //             : '£')
                            //     .format(double.parse(
                            //         '${feedState.productlist!.firstWhere(
                            //               (e) => e.key == ductId,
                            //             ).price}')),
                            style: const TextStyle(
                                fontSize: 16, color: Colors.cyan)),
                      ],
                    ),
                  ),
                ),
              ),
              frostedTeal(
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text('',
                            // '${feedState.productlist!.firstWhere(
                            //       (e) => e.key == ductId,
                            //     ).productName}',
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Positioned(
        //   bottom: 0,
        //   left: 5,
        //   child:
        // ),
      ],
    );
  }
}

class ModalTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Function? onTap;

  const ModalTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: CustomTile(
        mini: false,
        onTap: onTap as void Function()?,
        leading: Container(
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: UniversalVariables.receiverColor,
          ),
          padding: const EdgeInsets.all(10),
          child: Icon(
            icon,
            color: UniversalVariables.greyColor,
            size: 38,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: UniversalVariables.greyColor,
            fontSize: 14,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

class CustomTile extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget? icon;
  final Widget subtitle;
  final Widget? trailing;
  final EdgeInsets margin;
  final bool mini;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;

  const CustomTile({
    Key? key,
    required this.leading,
    required this.title,
    this.icon,
    required this.subtitle,
    this.trailing,
    this.margin = const EdgeInsets.all(0),
    this.onTap,
    this.onLongPress,
    this.mini = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: mini ? 10 : 0),
        margin: margin,
        child: Row(
          children: <Widget>[
            leading,
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: mini ? 10 : 15),
                padding: EdgeInsets.symmetric(vertical: mini ? 3 : 20),
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            width: 1,
                            color: UniversalVariables.separatorColor))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        title,
                        const SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            icon ?? Container(),
                            subtitle,
                          ],
                        )
                      ],
                    ),
                    trailing ?? Container(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Message extends ChatMessage {
  Message(Widget child,
      {required this.timestamp,
      required this.from,
      required this.onTap,
      required this.onDoubleTap,
      required this.onDismiss,
      required this.onLongPress,
      this.saved = false})
      : child = wrapMessage(
            child: child as SeenProvider,
            onDismiss: onDismiss,
            onDoubleTap: onDoubleTap,
            onTap: onTap,
            onLongPress: onLongPress,
            saved: saved);

  final String? from;
  final Widget child;
  final dynamic timestamp;
  final VoidCallback? onTap, onDoubleTap, onDismiss, onLongPress;
  final bool saved;
  static Widget wrapMessage(
      {required SeenProvider child,
      required onDismiss,
      required onDoubleTap,
      required onTap,
      required onLongPress,
      required bool saved}) {
    return child.child.isMe
        ? GestureDetector(
            child: child,
            onTap: onTap,
            onDoubleTap: onDoubleTap,
            onLongPress: onLongPress,
          )
        : Dismissible(
            background: const Align(
              child: Icon(Icons.delete_sweep, color: viewductWhite, size: 40),
              alignment: Alignment.bottomLeft,
            ),
            key: Key(child.timestamp!),
            dismissThresholds: const {DismissDirection.startToEnd: 0.9},
            child: GestureDetector(
              child: child,
              onDoubleTap: onDoubleTap,
              onTap: onTap,
              onLongPress: onLongPress,
            ),
            onDismissed: (direction) {
              if (onDismiss != null) onDismiss();
            },
            direction: DismissDirection.startToEnd,
          );
  }
}

class ChatMessageDesign extends StatefulWidget {
  final String from;
  final Widget child;
  final dynamic timestamp;
  final VoidCallback onTap, onDoubleTap, onDismiss, onLongPress;
  final bool saved;
  static Widget wrapMessage(
      {required child,
      required onDismiss,
      required onDoubleTap,
      required onTap,
      required onLongPress,
      required bool saved}) {
    return child.child.isMe
        ? GestureDetector(
            child: child,
            onTap: onTap,
            onDoubleTap: onDoubleTap,
            onLongPress: onLongPress,
          )
        : Dismissible(
            background: const Align(
              child: Icon(Icons.delete_sweep, color: viewductWhite, size: 40),
              alignment: Alignment.bottomLeft,
            ),
            key: Key(child.timestamp),
            dismissThresholds: const {DismissDirection.startToEnd: 0.9},
            child: GestureDetector(
              child: child,
              onDoubleTap: onDoubleTap,
              onTap: onTap,
              onLongPress: onLongPress,
            ),
            onDismissed: (direction) {
              if (onDismiss != null) onDismiss();
            },
            direction: DismissDirection.startToEnd,
          );
  }

  // ignore: use_key_in_widget_constructors
  ChatMessageDesign(Widget child,
      {Key? key,
      required this.timestamp,
      required this.from,
      required this.onTap,
      required this.onDoubleTap,
      required this.onDismiss,
      required this.onLongPress,
      this.saved = false})
      : child = wrapMessage(
            child: child,
            onDismiss: onDismiss,
            onDoubleTap: onDoubleTap,
            onTap: onTap,
            onLongPress: onLongPress,
            saved: saved);

  @override
  _ChatMessageDesignState createState() => _ChatMessageDesignState();
}

class _ChatMessageDesignState extends State<ChatMessageDesign> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.child,
    );
  }
}

// ignore_for_file: invalid_use_of_protected_member, unnecessary_statements, file_names, unused_element, invalid_use_of_visible_for_testing_member, must_be_immutable, prefer_typing_uninitialized_variables

import 'dart:async';

import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:viewducts/app_theme/app_theme_constant.dart';
import 'package:viewducts/common/common.dart';
import 'package:viewducts/common/v_player.dart';
import 'package:viewducts/constants/constants.dart';
import 'package:viewducts/features/chats/chat_controller.dart';

import 'package:viewducts/helper/constant.dart';
import 'package:viewducts/model/chatModel.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:viewducts/page/profile/see_provider.dart';
//import 'package:emoji_picker/emoji_picker.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
import 'package:viewducts/page/feed/composeTweet/widget/composeTweetImage.dart';
import 'package:viewducts/page/message/item_Search_bar.dart';
import 'package:viewducts/page/product/market.dart';
import 'package:viewducts/page/profile/bubble.dart';
// import 'package:viewducts/state/chats/chatState.dart';
// import 'package:viewducts/state/feedState.dart';
// import 'package:viewducts/state/seen_state.dart';
// import 'package:viewducts/state/stateController.dart';

import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/frosted.dart';
import 'package:viewducts/widgets/newWidget/customUrlText.dart';
import 'package:viewducts/widgets/newWidget/rippleButton.dart';
import 'package:viewducts/E2EE/e2ee.dart' as e2ee;
import 'package:collection/collection.dart';
import 'package:viewducts/widgets/newWidget/title_text.dart';

import '../../widgets/duct/profile_orders.dart';

class StoryChat extends ConsumerStatefulWidget {
  StoryChat(
      {Key? key,
      this.userProfileId,
      this.productId,
      this.storyId,
      this.storyChatsMessages,
      required this.currentStory,
      required this.currentUser,
      this.isVductProduct = false})
      : super(key: key);
  final bool isVductProduct;
  final String? userProfileId;
  final DuctStoryModel currentStory;
  final ViewductsUser currentUser;
  String? productId;
  String? storyId;
  RxList<ChatStoryModel>? storyChatsMessages = <ChatStoryModel>[].obs;

  @override
  ConsumerState<StoryChat> createState() => _StoryChatState();
}

class _StoryChatState extends ConsumerState<StoryChat> {
  final messageController = TextEditingController();

  // String senderId;
  String? userImage;

  bool? isContinuing;

  FocusNode textFieldFocus = FocusNode();

  FocusNode imageTextFieldFocus = FocusNode();

  // ChatState chatState = ChatState();
  ValueNotifier<bool> isSelected = ValueNotifier(false);

  String? ductId, chatUserProductId, myOrders;

  final _controller = ScrollController();

  GlobalKey<ScaffoldState>? _scaffoldKey;

  String? peerAvatar, peerNo, currentUserNo, privateKey, sharedSecret;

  var locked = false.obs;

  var hidden = false.obs;

//ViewductsUser peer, authState.userModel;
  int? unread;

  File? _image;

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

  // @override
  showKeyboard() => textFieldFocus.requestFocus();

  hideKeyboard() => textFieldFocus.unfocus();

  hideEmojiContainer() {
    showEmojiPicker.value = false;
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
          msgPart =
              cryptor?.decrypt(encrypt.Encrypted.fromBase64(msgPart), iv: iv) ??
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
    //     receiverId: widget.receiver.uid,
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

  FlutterSecureStorage storage = const FlutterSecureStorage();

  // String getLastSeenKey(String peerNo, String lastSeen) {
  readLocal() async {
//     prefs = await SharedPreferences.getInstance();
//     try {
//       privateKey = await storage.read(key: PRIVATE_KEY);
//       sharedSecret = (await const e2ee.X25519().calculateSharedSecret(
//               e2ee.Key.fromBase64(privateKey!, false),
//               e2ee.Key.fromBase64(chatState.chatUser!.publicKey!, true)))
//           .toBase64();
//       final key = encrypt.Key.fromBase64(sharedSecret!);
//       cryptor = encrypt.Encrypter(encrypt.Salsa20(key));
//     } catch (e) {
//       sharedSecret = null;
//     }
//     try {
//       seenState!.value =
//           prefs.getInt(chatState.getLastSeenKey(userProfileId, lastSeen));
//     } catch (e) {
//       seenState!.value = false;
//     }
// //chatId = ViewDucts.getChatId(authState.userId, chatState.chatUser.userId);
//     textEditingController.addListener(() {
//       if (textEditingController.text.isNotEmpty && typing.value == false) {
//         lastSeen = userProfileId;
//         chatState.lastSeen(userProfileId, authState.user!.uid);
//         typing.value = true;
//       }
//       if (textEditingController.text.isEmpty && typing.value == true) {
//         lastSeen = true;
//         chatState.lastSeen2(userProfileId, authState.user!.uid);

//         typing.value = false;
//       }
//     });
  }

  delete(int? ts) {
    // chatState.messageList!.removeWhere((msg) => msg.timeStamp == ts);
    // chatState.messageListing!.value = List.from(chatState.messageList!);
  }

  getImage(File image) {
    imageFile = image;
    return uploadFile();
  }

  getWallpaper(File image) {
    //  final chatState = Provider.of<ChatState>(context);

    // chatState.setWallpaper(userProfileId, image);
    return Future.value(false);
  }

  getImageFileName(id, timestamp) {
    return "$id-$timestamp";
  }

  Future uploadFile() async {
    //  var authState = Provider.of<AuthState>(context, listen: false);

    uploadTimestamp = DateTime.now().millisecondsSinceEpoch;
    String fileName =
        getImageFileName("authState.userModel!.userId", '$uploadTimestamp');
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    TaskSnapshot uploading = await reference.putFile(imageFile!);
    return uploading.ref.getDownloadURL();
  }

  Widget _chatScreenBody(
      BuildContext context, List<ChatStoryModel> streamMessage) {
    // initializeStatus();

    // final chatState = Provider.of<ChatState>(context, listen: false);
    // final authState = Provider.of<AuthState>(context, listen: false);
    // if (chatState.chatStatus.value.chatStatus == ChatStatus.blocked.index) {
    //   return Dialog(
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(20),
    //     ),
    //     child: frostedWhite(
    //       Container(
    //         height: Get.width * 0.5,
    //         width: Get.width * 0.6,
    //         decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
    //         child: SafeArea(
    //           child: Stack(
    //             children: <Widget>[
    //               // Positioned(
    //               //   bottom: -160,
    //               //   left: -140,
    //               //   child: Transform.rotate(
    //               //     angle: 90,
    //               //     child: Container(
    //               //       height: Get.width * 0.8,
    //               //       width: Get.width,
    //               //       decoration: const BoxDecoration(
    //               //           image: DecorationImage(
    //               //               image: AssetImage('assets/ankkara1.jpg'))),
    //               //     ),
    //               //   ),
    //               // ),
    //               // Positioned(
    //               //   top: -160,
    //               //   right: -180,
    //               //   child: Transform.rotate(
    //               //     angle: 90,
    //               //     child: Container(
    //               //       height: Get.width * 0.8,
    //               //       width: Get.width,
    //               //       decoration: const BoxDecoration(
    //               //           image: DecorationImage(
    //               //               image: AssetImage('assets/ankara2.jpg'))),
    //               //     ),
    //               //   ),
    //               //     ),
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
    //                               border:
    //                                   Border.all(color: Colors.white, width: 5),
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
    //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    //                                       chatState.unblock(
    //                                           authState.userId!, userProfileId!,
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
    return Obx(() => streamMessage.isEmpty
        //  ||
        // sharedSecret == null
        ? Center(child: showEmojiPicker.value ? Container() : const SizedBox())
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
          ));
  }

  Rx<ChatStoryModel>? replyMessage;

  swipeMessage(ChatStoryModel message) {
    replyMessage = message.obs;
  }

  void cancelReply() {
    replyMessage = null;
    textFieldFocus.unfocus();
  }

  Widget _messages(ChatStoryModel chat, bool myMessage, BuildContext context) {
    return SwipeTo(
      onRightSwipe: () {
        textFieldFocus.requestFocus();
        swipeMessage(chat);
      },
      child: Column(
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
                      margin: EdgeInsets.only(
                        right: myMessage ? 10 : (Get.width / 4),
                        top: 20,
                        left: myMessage ? (Get.width / 9) : 10,
                      ),
                      child: IntrinsicHeight(
                          //  width: Get.width * 0.9,
                          child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row(
                          //   children: [
                          //     customText((replyMessage!.value.senderId.toString())),
                          //   ],
                          // ),

                          SizedBox(
                            width: Get.width * 0.8,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
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

                          Container(color: Colors.cyan, width: 4),
                        ],
                      )),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: myMessage
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        mainAxisAlignment: myMessage
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            alignment: myMessage
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            margin: EdgeInsets.only(
                              right: myMessage ? 10 : (Get.width),
                              top: 20,
                              left: myMessage ? (Get.width / 4) : 0,
                            ),
                            child: Stack(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: myMessage
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        myMessage
                                            ? const SizedBox()
                                            : Stack(
                                                children: [
                                                  // Align(
                                                  //   alignment: Alignment.center,
                                                  //   child: CircleAvatar(
                                                  //     radius: 22,
                                                  //     backgroundColor: Colors
                                                  //         .yellow.shade200,
                                                  //   ),
                                                  // ),
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: CircleAvatar(
                                                      radius: 22,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      child: Material(
                                                        elevation: 20,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        child: customImage(
                                                            context,
                                                            chat.senderImage,
                                                            height: 30),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            myMessage
                                                ? const SizedBox()
                                                : Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 6,
                                                                vertical: 4),
                                                        child: customText(
                                                            chat.senderName,
                                                            //getWhen(time),
                                                            style:
                                                                const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              color: CupertinoColors
                                                                  .darkBackgroundGray,
                                                            )),
                                                      ),
                                                      Container(
                                                        height: 2,
                                                        width: 30,
                                                        color: CupertinoColors
                                                            .systemOrange,
                                                      )
                                                    ],
                                                  ),
                                            SizedBox(
                                              width: Get.width * 0.6,
                                              child: myMessage
                                                  ? BubbleSpecialThree(
                                                      color: CupertinoColors
                                                          .darkBackgroundGray,
                                                      text: TextEncryptDecrypt
                                                          .decryptAES(
                                                              chat.message),
                                                      textStyle: onPrimarySubTitleText
                                                          .copyWith(
                                                              color: CupertinoColors
                                                                  .lightBackgroundGray),
                                                    )
                                                  : BubbleSpecialThree(
                                                      isSender: false,
                                                      tail: true,
                                                      color: CupertinoColors
                                                          .lightBackgroundGray,
                                                      text: TextEncryptDecrypt
                                                          .decryptAES(
                                                              chat.message),
                                                    ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: Row(
              mainAxisAlignment:
                  myMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
              crossAxisAlignment:
                  myMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                // ' chatState.onlineStatus.value.userSeen' == null
                //     ? Container()
                //     : myMessage
                //         ? DateTime.parse(
                //                         'chatState.onlineStatus.value.userSeen')
                //                     .isAfter(DateTime.parse(chat.createdAt)) ==
                //                 true
                //             //  int.tryParse(chatState.onlineStatus.value.userSeen) ==
                //             //         int.tryParse(chat.createdAt.toString())
                //             // chat.seen is bool && chat.seen == true
                //             ? Padding(
                //                 padding: const EdgeInsets.symmetric(
                //                     horizontal: 4, vertical: 2),
                //                 child: SizedBox(
                //                     height: Get.height * 0.025,
                //                     width: Get.height * 0.025,
                //                     child: Icon(Icons.done_all,
                //                         color: Colors.blue,
                //                         size: Get.height * 0.025)),
                //               )
                //             : Padding(
                //                 padding: const EdgeInsets.symmetric(
                //                     horizontal: 4, vertical: 2),
                //                 child: SizedBox(
                //                   height: Get.height * 0.025,
                //                   width: Get.height * 0.025,
                //                   child: Icon(Icons.done,
                //                       color: Colors.blue,
                //                       size: Get.height * 0.025),
                //                 ),
                //               )
                //         : Container(),

                // getReadStatus(onlineStatus, chat.receiverId),
                Text(
                    // DateFormat('h:mm a').format(
                    //         DateTime.fromMillisecondsSinceEpoch(chat.timeStamp))
                    getChatTime(chat.createdAt) + (myMessage ? ' ' : ''),
                    style: TextStyle(
                      color: myMessage
                          ? Colors.blueGrey.withOpacity(0.8)
                          : viewductBlack,
                      fontSize: Get.width * 0.035,
                    )),
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

  chatMessage(ChatStoryModel message, BuildContext context,
      {bool saved = false, List<Message>? savedMsgs}) {
    if (message.senderId == widget.currentUser.userId) {
      return StoryDuctMenuHolder(
          msgkey: message.key,
          reciverId: message.receiverId,
          onPressed: () {},
          menuItems: <DuctFocusedMenuItem>[
            DuctFocusedMenuItem(
                title: const Text('Copy'),
                onPressed: () {
                  Clipboard.setData(ClipboardData(
                      text: TextEncryptDecrypt.decryptAES(message.message)));
                },
                trailingIcon: const Icon(CupertinoIcons.add_circled_solid)),
            // DuctFocusedMenuItem(
            //     title: const Text('Reply'),
            //     onPressed: () {
            //       swipeMessage(message);
            //       FocusScope.of(context).requestFocus(textFieldFocus);
            //       // Get.back();

            //       // swipeMessage(message);
            //       // setState(() {});
            //       // textFieldFocus.nextFocus();
            //     },
            //     trailingIcon: const Icon(CupertinoIcons.reply)),
            // DuctFocusedMenuItem(
            //     title: const Text(
            //       'Delete',
            //       style: TextStyle(color: Colors.red),
            //     ),
            //     onPressed: () {},
            //     trailingIcon: const Icon(
            //       CupertinoIcons.delete,
            //       color: Colors.red,
            //     ))
          ],
          child: _messages(message, true, context));
    } else {
      return StoryDuctMenuHolder(
          msgkey: message.key,
          reciverId: message.senderId,
          onPressed: () {},
          menuItems: <DuctFocusedMenuItem>[
            DuctFocusedMenuItem(
                title: const Text('Copy'),
                onPressed: () {
                  Clipboard.setData(ClipboardData(
                      text: TextEncryptDecrypt.decryptAES(message.message)));
                },
                trailingIcon: const Icon(CupertinoIcons.add_circled_solid)),
            // DuctFocusedMenuItem(
            //     title: const Text('Reply'),
            //     onPressed: () {
            //       swipeMessage(message);
            //       FocusScope.of(context).requestFocus(textFieldFocus);
            //       // Get.back();

            //       // swipeMessage(message);
            //       // setState(() {});
            //       // textFieldFocus.nextFocus();
            //     },
            //     trailingIcon: const Icon(CupertinoIcons.reply)),
            // DuctFocusedMenuItem(
            //     title: const Text(
            //       'Delete',
            //       style: TextStyle(color: Colors.red),
            //     ),
            //     onPressed: () {},
            //     trailingIcon: const Icon(
            //       CupertinoIcons.delete,
            //       color: Colors.red,
            //     ))
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

  Widget _privacyView(
    BuildContext context,
    // ChatState model,
  ) {
    // var authState = Provider.of<AuthState>(context, listen: false);
    return Column(
      children: <Widget>[
        Container(
          width: Get.width * .1,
          height: 5,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),

        // authState.userModel!.hidden!.contains(model.chatUser!.userId) == true
        //     ? _widgetBottomSheetRow(context, AppIcon.unFollow, onPressed: () {
        //         chatState.unhideChat(authState.user!.uid, userProfileId);
        //       }, text: 'Unhide chat', isEnable: true)
        //     : _widgetBottomSheetRow(context, AppIcon.unFollow, onPressed: () {
        //         chatState.hideChat(authState.user!.uid, userProfileId);
        //       }, text: 'Hide  chat', isEnable: true),
        // authState.userModel!.locked!.contains(model.chatUser!.userId)
        //     ? _widgetBottomSheetRow(context, AppIcon.unFollow, onPressed: () {
        //         chatState.unlockChat(authState.user!.uid, userProfileId);
        //       }, text: 'Unlock  chat', isEnable: true)
        //     : _widgetBottomSheetRow(context, AppIcon.unFollow, onPressed: () {
        //         chatState.lockChat(authState.user!.uid, userProfileId);
        //       }, text: 'Lock  chat', isEnable: true),
        // isBlocked()
        //     ? _widgetBottomSheetRow(context, AppIcon.unFollow, onPressed: () {
        //         chatState.accept(authState.user!.uid, userProfileId);
        //       }, text: 'Unblock ${model.chatUser!.displayName}', isEnable: true)
        //     : _widgetBottomSheetRow(context, AppIcon.block, onPressed: () {
        //         chatState.block(authState.user!.uid, userProfileId!);
        //       }, text: 'Block ${model.chatUser!.displayName}', isEnable: true),
        // _widgetBottomSheetRow(context, AppIcon.report,
        //     text: 'Report Store', isEnable: true),
        // case 'hide':

        //                                 break;
        //                               case 'unhide':
        //                                 chatState.unhideChat(
        //                                     authState.userModel.userId,
        //                                     chatState.chatUser.userId);
        //                                 break;
        //                               case 'lock':

        //                                 break;
        //                               case 'unlock':
        //                                 chatState.unlockChat(
        //                                     authState.userModel.userId,
        //                                     chatState.chatUser.userId);
        //                                 break;
        //                               case 'block':

        //                                 break;
        //                               case 'unblock':
        //                                 chatState.accept(
        //                                     authState.userModel.userId,
        //                                     chatState.chatUser.userId);
        //                                 ViewDucts.toast('Unblocked.');
      ],
    );
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

  // void _postProsductoption() {
  OverlayEntry _createPostMenu(BuildContext context) {
    // var chatState = Provider.of<ChatState>(context, listen: false);
    // // double heightFactor = 300 / Get.height;
    // var authState = Provider.of<AuthState>(context, listen: false);
    // var feedState = Provider.of<FeedState>(context, listen: false);

    // var userImage = chatState.chatUser.profilePic;
    // String id = userProfileId ?? chatState.chatUser.userId;

    FeedModel? model;
    return OverlayEntry(
      builder: (context) {
        return Container();
//         return GetX<FeedState>(builder: (_) {
//           List<FeedModel>? list =
//               feedState.getStoreProductList(authState.userId);

//           if (feedState.feedlist != null && feedState.feedlist!.isNotEmpty) {
//             list = feedState.getStoreProductList(authState.userId);
//             // .where((x) => x.userId == id)
//             // .toList();
//           }
//           return GestureDetector(
//             onTap: () {
//               if (isDropdown.value) {
//                 floatingMenu.remove();
//               } else {
//                 // _postProsductoption();
//                 floatingMenu = _createPostMenu(context);
//                 Overlay.of(context).insert(floatingMenu);
//               }

//               isDropdown.value = !isDropdown.value;
//             },
//             child: Material(
//               color: Colors.transparent,
//               child: frostedWhite(
//                 SizedBox(
//                   height: Get.width,
//                   width: Get.width,
//                   child: Stack(
//                     children: [
//                       Positioned(
//                         top: Get.width * 0.1,
// //                        right: xPosiion - Get.width * 0.5,
//                         right: xPosiion,
//                         // width: width,
//                         // height: 4 + height + 40,
//                         child: SizedBox(
//                           //  height: Get.width * 0.4,
//                           width: Get.width,
//                           child: Stack(
//                             children: [
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Row(
//                                       children: [
//                                         customTitleText(
//                                           'ViewShare with',
//                                         ),
//                                         frostedPink(
//                                           Padding(
//                                             padding: const EdgeInsets.all(8.0),
//                                             child: customTitleText(
//                                               '${chatState.chatUser!.displayName}',
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   const Divider(),
//                                   Column(
//                                     children: [
//                                       Row(
//                                         children: [
//                                           frostedTeal(
//                                             const Padding(
//                                               padding: EdgeInsets.all(8.0),
//                                               child: Text('Your Orders',
//                                                   style: TextStyle(
//                                                     fontSize: 16,
//                                                   )),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         children: [
//                                           list == null
//                                               ? Column(
//                                                   children: [
//                                                     Padding(
//                                                       padding:
//                                                           const EdgeInsets.all(
//                                                               8.0),
//                                                       child: Text(
//                                                           'You haven\'t order a product yet',
//                                                           style: TextStyle(
//                                                             fontSize: fullWidth(
//                                                                     context) *
//                                                                 0.05,
//                                                           )),
//                                                     ),
//                                                     ButtonTheme(
//                                                       height: 45.0,
//                                                       minWidth: 100.0,
//                                                       shape: const RoundedRectangleBorder(
//                                                           borderRadius:
//                                                               BorderRadius.all(
//                                                                   Radius
//                                                                       .circular(
//                                                                           7.0))),
//                                                       // ignore: deprecated_member_use
//                                                       child: ElevatedButton(
//                                                         // color: const Color(
//                                                         //     0xff313134),
//                                                         onPressed: () async {
//                                                           if (isDropdown
//                                                               .value) {
//                                                             floatingMenu
//                                                                 .remove();
//                                                           } else {
//                                                             // _postProsductoption();
//                                                             floatingMenu =
//                                                                 _createPostMenu(
//                                                                     context);
//                                                             Overlay.of(context)
//                                                                 .insert(
//                                                                     floatingMenu);
//                                                           }

//                                                           isDropdown.value =
//                                                               !isDropdown.value;

//                                                           Navigator.of(context)
//                                                               .push(
//                                                             MaterialPageRoute(
//                                                                 builder:
//                                                                     (context) =>
//                                                                         Home()),
//                                                           );

//                                                           //   Map<String,dynamic> args = new Map();
//                                                           // //  Loader.showLoadingScreen(context, _keyLoader);
//                                                           //   List<Map<String,String>> categoryList = await _productService.listCategories();
//                                                           //   args['category'] = categoryList;
//                                                           //   Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
//                                                           //   Navigator.pushReplacementNamed(context, '/shop',arguments: args);
//                                                         },
//                                                         child: const Text(
//                                                           'Shop',
//                                                           style: TextStyle(
//                                                               color:
//                                                                   Colors.white,
//                                                               fontSize: 20.0,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .bold),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                     const SizedBox(
//                                                       height: 20,
//                                                     )
//                                                   ],
//                                                 )
//                                               : SizedBox(
//                                                   width: Get.width * 0.8,
//                                                   height: Get.width * 0.5,
//                                                   child: ListView.builder(
//                                                     scrollDirection:
//                                                         Axis.horizontal,
//                                                     addAutomaticKeepAlives:
//                                                         false,
//                                                     physics:
//                                                         const BouncingScrollPhysics(),
//                                                     itemBuilder:
//                                                         (context, index) =>
//                                                             Padding(
//                                                       padding:
//                                                           const EdgeInsets.all(
//                                                               8.0),
//                                                       child: SizedBox(
//                                                           height: fullWidth(
//                                                                   context) *
//                                                               0.5,
//                                                           width: fullWidth(
//                                                                   context) *
//                                                               0.5,
//                                                           child: Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                         .only(
//                                                                     bottom:
//                                                                         12.0),
//                                                             child:
//                                                                 GestureDetector(
//                                                               onTap: () {
//                                                                 if (isSelected
//                                                                     .value) {
//                                                                   chatUserProductId =
//                                                                       null;
//                                                                   ductId = null;
//                                                                   myOrders =
//                                                                       list![index]
//                                                                           .key;
//                                                                   isSelected
//                                                                       .value;
//                                                                 } else {
//                                                                   myOrders =
//                                                                       list![index]
//                                                                           .key;
//                                                                   isSelected
//                                                                           .value =
//                                                                       !isSelected
//                                                                           .value;
//                                                                 }

//                                                                 if (isDropdown
//                                                                     .value) {
//                                                                   floatingMenu
//                                                                       .remove();
//                                                                 } else {
//                                                                   // _postProsductoption();
//                                                                   floatingMenu =
//                                                                       _createPostMenu(
//                                                                           context);
//                                                                   Overlay.of(
//                                                                           context)
//                                                                       .insert(
//                                                                           floatingMenu);
//                                                                 }

//                                                                 isDropdown
//                                                                         .value =
//                                                                     !isDropdown
//                                                                         .value;
//                                                               },
//                                                               child: _StoreProducts(
//                                                                   list: list![index],
//                                                                   //   isSelected: isSelected,
//                                                                   model: model),
//                                                             ),
//                                                           )),
//                                                     ),
//                                                     itemCount: list.length,
//                                                   ),
//                                                 ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         });
      },
    );
  }

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
    _image = null;
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
                                    image: _image,
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
                                            if (_image != null) {
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
                      // Center(
                      //   child: SingleChildScrollView(
                      //     child: Column(
                      //       children: <Widget>[
                      //         Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Text(
                      //             'Accept ${chatState.chatUser!.displayName}\'s invitation?',
                      //             style: TextStyle(
                      //                 fontSize: 20,
                      //                 color: Colors.blueGrey[500]),
                      //           ),
                      //         ),
                      //         Container(
                      //           height: 0.5,
                      //           color: Colors.blueGrey[300],
                      //         ),
                      //         Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Row(
                      //             children: [
                      //               Material(
                      //                 elevation: 20,
                      //                 borderRadius: BorderRadius.circular(100),
                      //                 shadowColor: Colors.yellow[50],
                      //                 child: frostedRed(
                      //                   // ignore: deprecated_member_use
                      //                   TextButton(
                      //                       child: const Text('Reject'),
                      //                       onPressed: () {
                      //                         chatState.block(authState.userId!,
                      //                             userProfileId!);

                      //                         statusInit =
                      //                             ChatStatus.blocked.index;
                      //                       }),
                      //                 ),
                      //               ),
                      //               Material(
                      //                 elevation: 20,
                      //                 borderRadius: BorderRadius.circular(100),
                      //                 shadowColor: Colors.yellow[50],
                      //                 child: frostedGreen(
                      //                   // ignore: deprecated_member_use
                      //                   TextButton(
                      //                       child: const Text('Accept'),
                      //                       onPressed: () {
                      //                         chatState.accept(
                      //                             currentUserNo, peerNo);

                      //                         statusInit =
                      //                             ChatStatus.accepted.index;
                      //                       }),
                      //                 ),
                      //               )
                      //             ],
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // )
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

  void _uploadChatImge(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.red,
        // bounce: true,
        context: context,
        builder: (context) => Stack(
              children: <Widget>[
                Material(
                  elevation: 10,
                  child: Container(
                    height: Get.height,
                    width: Get.width,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                          image: FileImage(_image!), fit: BoxFit.cover),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.all(0),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.yellow),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: () async {
                          kScreenloader.showLoader(context);
                          if (_image != null) {
                            // await feedState
                            //     .uploadChatFile(_image!)
                            //     .then((imagePaths) {
                            //   if (imagePaths != null) {
                            //     RxString path = imagePaths.obs;
                            //     // image.imagePath = ;

                            //     submitMessage(
                            //         textEditingController.text = 'image',
                            //         MessagesType.Image,
                            //         DateTime.now().millisecondsSinceEpoch,

                            //         null,
                            //         context,
                            //         path.value);
                            //   }
                            // });
                          }
                          kScreenloader.hideLoader();
                          Navigator.maybePop(context);
                          kScreenloader.hideLoader();
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ));
  }

  Widget invoiceHeader(OrderViewProduct? cartItem) {
    return frostedYellow(
      Container(
        width: Get.width,
        //  width: ScreenConfig.deviceWidth,
        //height: ScreenConfig.getProportionalHeight(374),
        color: Colors.yellow[100],
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
                        width: Get.width * 0.7, child: addressColumn(cartItem))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
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

  Widget buildReply() => IntrinsicHeight(
          //  width: Get.width * 0.9,
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(color: Colors.green, width: 4),
          // Row(
          //   children: [
          //     customText((replyMessage!.value.senderId.toString())),
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
                customText(replyMessage!.value.senderName.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                customText(TextEncryptDecrypt.decryptAES(
                    replyMessage!.value.message.toString())),
              ],
            ),
          ),
        ],
      ));

  void _orderList(BuildContext context, OrderViewProduct? cartItem) {
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
                                              cartItem.orderState == 'shipping'
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
                                                  // setState(() {
                                                  myOrders =
                                                      // itemList[
                                                      //     index]['id'];
                                                      item.id;
                                                  isSelected.value;
                                                  // });
                                                  Get.back();
                                                } else {
                                                  //setState(() {
                                                  myOrders = item.id;
                                                  // itemList[
                                                  //     index]['id'];
                                                  isSelected.value =
                                                      !isSelected.value;
                                                  // });
                                                  Get.back();
                                                }
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: Get.width * 0.3,
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
                                                                Get.width * 0.2,
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
                                                                          offset: const Offset(0,
                                                                              11),
                                                                          blurRadius:
                                                                              11,
                                                                          color: Colors
                                                                              .black
                                                                              .withOpacity(0.06))
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
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                // Image.network(feedState
                                                                //     .productlist!
                                                                //     .firstWhere((e) =>
                                                                //         e.key ==
                                                                //         item.id)
                                                                //     .imagePath
                                                                //     .toString()),
                                                                Text(
                                                                  "\$${item.price}",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.6),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                // SizedBox(
                                                                //   width: ScreenConfig.getProportionalWidth(145),
                                                                //   child: Text(
                                                                //     itemDesc,
                                                                //     style: TextStyle(color: Colors.black),
                                                                //   ),
                                                                // ),
                                                                Text(
                                                                  "\$${(int.parse(item.price!.toString()) * int.parse(item.quantity!.toString()))}",
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                )
                                                              ],
                                                            ),
                                                          ),

                                                          //invoiceTotal(totalAmount),

                                                          // TextButton(
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
        child: Stack(
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
                  decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(10)),
                  child: customTitleText('Your Orders'),
                ),
                // SizedBox(
                //   height: fullWidth(context) * 0.35,
                //   width: fullWidth(context),
                //   child: ListView(
                //     scrollDirection: Axis.horizontal,
                //     children: userCartController.orders.value
                //         .map(
                //           (cartItem) => Padding(
                //             padding: const EdgeInsets.all(8.0),
                //             child: GestureDetector(
                //               onTap: () {
                //                 Get.back;
                //                 _orderList(context, cartItem);
                //               },
                //               child: DuctStatusView(
                //                   radius: Get.width * 0.1,
                //                   numberOfStatus: cartItem.items!.length,
                //                   centerImageUrl: 'assets/groceries.png'),
                //             ),
                //           ),
                //         )
                //         .toList(),
                //   ),

                //   // ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomEntryField(BuildContext context) {
    final List<FeedModel>? commissionProduct;
    //  =
    //     feedState.commissionProducts(authState.userModel, ductId);
    final List<FeedModel>? chatUserProduct;
    // =
    //     feedState.commissionProducts(authState.userModel, chatUserProductId);
    final List<FeedModel>? userOrders;
    //  =
    //     feedState.commissionProducts(authState.userModel, myOrders);

    userImage = 'chatState.chatUser!.profilePic';
    setWritingTo(bool val) {
      isWriting.value = val;
    }

    if (statusInit == ChatStatus.requested.index) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: frostedYellow(
          Container(
            height: Get.width * 0.5,
            width: Get.width * 0.6,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
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
                                  border:
                                      Border.all(color: Colors.white, width: 5),
                                  shape: BoxShape.circle),
                              child: RippleButton(
                                child: customImage(
                                  context,
                                  " chatState.chatUser!.profilePic,",
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
                                  '',
                                  // ' ${chatState.chatUser!.displayName}\'s',
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
                          // Padding(
                          //   padding: const EdgeInsets.all(15.0),
                          //   child: Row(
                          //     crossAxisAlignment: CrossAxisAlignment.center,
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       Material(
                          //         elevation: 20,
                          //         borderRadius: BorderRadius.circular(100),
                          //         shadowColor: Colors.yellow[50],
                          //         child: frostedRed(
                          //           TextButton(
                          //               child: const Text('Reject'),
                          //               onPressed: () {
                          //                 chatState.block(authState.userId!,
                          //                     userProfileId!);

                          //                 statusInit = ChatStatus.blocked.index;
                          //               }),
                          //         ),
                          //       ),
                          //       Material(
                          //         elevation: 20,
                          //         borderRadius: BorderRadius.circular(100),
                          //         shadowColor: Colors.yellow[50],
                          //         child: frostedGreen(
                          //           TextButton(
                          //               child: const Text('Accept'),
                          //               onPressed: () async {
                          //                 await chatState.accept(
                          //                     authState.userId, userProfileId);

                          //                 statusInit =
                          //                     ChatStatus.accepted.index;
                          //               }),
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // ),
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
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (replyMessage != null) buildReply(),
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
                                        // child: _SelectedProduct(
                                        //     list: commissionProduct![index],
                                        //     model: model,
                                        //     ductId: ductId)
                                      ),
                                    ),
                                    itemCount: 1,
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
                                        // child: _SelectedProduct(
                                        //     list: chatUserProduct![index],
                                        //     model: model,
                                        //     ductId: chatUserProductId)
                                      ),
                                    ),
                                    itemCount: 0,
                                  ),
                                ),
                              ),
                        myOrders == null
                            ? Container()
                            : frostedOrange(
                                SizedBox(
                                  width: Get.width,
                                  height: Get.width * 0.25,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    addAutomaticKeepAlives: false,
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (context, index) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      // child: SizedBox(
                                      //     height: Get.width * 0.3,
                                      //     width: Get.width,
                                      //     child: _SelectedProduct(
                                      //         list: userOrders![index],
                                      //         model: model,
                                      //         ductId: myOrders)),
                                    ),
                                    itemCount: 0,
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
                        myOrders == null
                            ? Container()
                            : Positioned(
                                bottom: 0,
                                right: 0,
                                child: frostedPink(Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: customTitleText(
                                    'My Order',
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
                              myOrders = null;
                            },
                            color: Colors.black,
                            icon:
                                const Icon(CupertinoIcons.clear_circled_solid),
                          ),
                        ),
                      ],
                    ),
              Row(
                children: <Widget>[
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
                              color: CupertinoColors.darkBackgroundGray,
                            ),
                            onChanged: (val) {
                              (val.isNotEmpty && val.trim() != "")
                                  ? setWritingTo(true)
                                  : setWritingTo(false);
                            },
                            maxLines: null,
                            decoration: const InputDecoration(
                              hintText: "Be positive in words",
                              hintStyle: TextStyle(
                                  color: CupertinoColors.darkBackgroundGray
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
                  // isWriting.value
                  //     ? Container()
                  //     : Padding(
                  //         padding: const EdgeInsets.symmetric(horizontal: 10),
                  //         child: GestureDetector(
                  //           key: actionKey,
                  //           onTap: () {
                  //             _orders(context);
                  //             // if (isDropdown.value) {
                  //             //   floatingMenu.remove();
                  //             // } else {
                  //             //   //  _postProsductoption();
                  //             //   floatingMenu = _createPostMenu(context);
                  //             //   Overlay.of(context).insert(floatingMenu);
                  //             // }

                  //             // isDropdown.value = !isDropdown.value;

                  //             //  Navigator.of(context).pushNamed('/CreateFeedPage/tweet');
                  //           },
                  //           // onTap: () {

                  //           //   cprint('is working');
                  //           // },
                  //           child: const Icon(
                  //             Icons.record_voice_over,
                  //             color: Colors.teal,
                  //           ),
                  //         ),
                  //       ),
//                   isWriting.value
//                       ? Container()
//                       : Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: GestureDetector(
//                               child: const Icon(
//                                 Icons.camera_alt,
//                                 color: Colors.cyan,
//                               ),
//                               onTap: () async {
//                                 PickedFile? file = await ImagePicker.platform
//                                     .pickImage(
//                                         source: ImageSource.gallery,
//                                         imageQuality: 50);

//                                 _image = File(file!.path);
//                                 //  cprint('$_image');
//                                 _uploadChatImge(context);

//                                 // File file = await ImagePicker.pickImage(
//                                 //     source: ImageSource.gallery, imageQuality: 50);
//                                 // setState(() {
//                                 //   _image = file;
//                                 // });
// //imagePreview(context);
//                               }
//                               //=> pickImage(source: ImageSource.camera),
//                               ),
//                         ),
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
                                  color: CupertinoColors.lightBackgroundGray,
                                ),
                                onPressed: () =>
                                    // statusInit == ChatStatus.blocked.index
                                    //     ? null
                                    //     : () => ductId != null
                                    //         ? submitMessage(
                                    //             textEditingController.text,
                                    //             MessagesType.Products,
                                    //             DateTime.now().millisecondsSinceEpoch,
                                    //             ductId,
                                    //             context,
                                    //             null)
                                    //         : chatUserProductId != null
                                    //             ? submitMessage(
                                    //                 textEditingController.text,
                                    //                 MessagesType.ChatUserProducts,
                                    //                 DateTime.now()
                                    //                     .millisecondsSinceEpoch,
                                    //                 chatUserProductId,
                                    //                 context,
                                    //                 null)
                                    //             : myOrders != null
                                    //                 ? submitMessage(
                                    //                     textEditingController.text,
                                    //                     MessagesType.MyOrders,
                                    //                     DateTime.now()
                                    //                         .millisecondsSinceEpoch,
                                    //                     myOrders,
                                    //                     context,
                                    //                     null)
                                    //                 : _image != null
                                    //                     ? submitMessage(
                                    //                         textEditingController
                                    //                             .text,
                                    //                         MessagesType.Image,
                                    //                         DateTime.now()
                                    //                             .millisecondsSinceEpoch,
                                    //                         null,
                                    //                         context,
                                    //                         null)
                                    //                     :
                                    sendMessageToUser(
                                        context: context,
                                        currentUser: widget.currentUser,
                                        storyId: widget.currentStory.key!,
                                        text: textEditingController.text)

//                                                   sendMessageToUser(
// (
//                                                     text: textEditingController
//                                                           .text, cu

//                                                       // MessagesType.Text,
//                                                       // DateTime.now()
//                                                       //     .millisecondsSinceEpoch,
//                                                       // null,
//                                                       // context,
//                                                       // null
//                                                       ),
                                //    color: viewductWhite,
                                ),
                          ),
                        )
                      : Container()
                ],
              ),
              showEmojiPicker.value
                  ? Container(child: emojiContainer())
                  : Container()
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
      //                       //   Provider.of<ComposeTweetState>(context, listen: false)
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

  Future<bool> _onWillPop() async {
    //   int chatState;
    // chatState.chatMessage.close();
    // statusInit =
    //     await chatState.getStatus(authState.user!.uid, userProfileId!);
    // chatState.setLastSeen(
    //     statusInit, authState.user!.uid, userProfileId!);

    // var authState = Provider.of<AuthState>(context, listen: false);
    // final chatState = Provider.of<ChatState>(context, listen: false);
    //await chatState.setLastSeen(chatState, authState.user.uid);
    //await chatState.justSettingLastSeen(authState.user.uid);
    // await chatState.lastSeen(
    //     chatState.chatUser.userId, authState.user.uid, chatState.chatUser.userId);
    // chatState.setIsChatScreenOpen = false;
    //  chatState.dispose();
    Navigator.pop(context);
    return true;
  }

  void sendMessageToUser({
    required String text,
    required ViewductsUser currentUser,
    required String storyId,
    required BuildContext context,
  }) async {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (textEditingController.text.isEmpty) {
      return ViewDucts.toast('Type Something Nice...');
    }
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    final encrypted = await TextEncryptDecrypt.encryptAES(text.trim());
    var key = Uuid().v1();
    ref.read(chatControllerProvider.notifier).sendPinDuctMessage(
        text: encrypted,
        currentUser: currentUser,
        storyId: storyId,
        context: context,
        messageKey: key,
        replyMessage: replyMessage!.value.message.toString());
    Future.delayed(const Duration(milliseconds: 50)).then((_) {
      textEditingController.clear();

      setState(() {
        replyMessage = null;
      });
    });
  }

  void submitMessage(String content, MessagesType type, var timestamp,
      String? imageKey, BuildContext context, String? imagePath) async {
    ChatStoryModel message;
    FocusScopeNode currentFocus = FocusScope.of(context);
    // ignore: prefer_const_constructors
    var key = Uuid().v1();
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if (imagePath == null) {
      if (textEditingController.text.isEmpty) {
        return ViewDucts.toast('Type Something Nice...');
      }
    }
    final encrypted = await TextEncryptDecrypt.encryptAES(content.trim());

    // encryptWithCRC(
    //   content.trim(),
    // );
    _image = null;
    chatUserProductId = null;
    myOrders = null;
    ductId = null;

    // if (statusInit == null)
    //   chatState.request(authState.userId, userProfileId);
    messageController.clear();
    textEditingController.clear();

    // cprint('$imagePath');
    // cprint('$encrypted');
    if (imagePath != null) {
      var timestamps = DateTime.now().toUtc().toString();
      message = ChatStoryModel(
          message: content.trim(),
          senderId: 'authState.userModel!.userId',
          storyId: widget.storyId,
          type: 0,
          replyedMessage: replyMessage?.value.message.toString(),
          key: key,
          createdAt: timestamps,
          receiverId: widget.userProfileId,
          senderImage: 'authState.userModel!.profilePic',
          senderName: 'authState.userModel!.displayName');

      isWriting.value = false;

      // chatState.storySubmitMessage(
      //   message,
      //   authState.userModel!.userId!,
      //   storyId,
      //   userProfileId,
      // );
      var tempDoc = {
        TIMESTAMP: timestamp,
        TYPE: type.index,
        CONTENT: message,
        FROM: 'authState.userId',
      };

//       chatState.messageList!.add(Message(
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
//         from: authState.userModel?.key,
//         timestamp: timestamp,
//       ));

      Future.delayed(const Duration(milliseconds: 50)).then((_) {
        replyMessage = null;
        textEditingController.clear();
      });
      kScreenloader.hideLoader();
    } else if (encrypted is String) {
      var timestamps = DateTime.now().toUtc().toString();
      // instMsg = ChatMessage(
      //     message: encrypted,
      //     createdAt: timestamps,
      //     receiverId: userProfileId!,
      //     replyedMessage: replyMessage?.value.message.toString(),
      //     senderId: authState.userId,
      //     imageKey: imageKey,
      //     seen: chatState.onlineStatus.value.chatOnlineChatStatus == true
      //         ? true
      //         : false,
      //     type: type.index,
      //     timeStamp: DateTime.now().toUtc().millisecondsSinceEpoch,
      //     senderName: authState.user!.displayName);
      message = ChatStoryModel(
          message: encrypted,
          senderId: ' authState.userId',
          storyId: widget.storyId,
          chatId: key,
          type: 0,
          replyedMessage: replyMessage?.value.message.toString(),
          key: key,
          createdAt: timestamps,
          receiverId: widget.userProfileId,
          senderImage: 'authState.userModel!.profilePic',
          senderName: 'authState.userModel!.displayName');

      isWriting.value = false;

      // chatState.storySubmitMessage(
      //   message,
      //   authState.userId!,
      //   storyId,
      //   userProfileId,
      // );
      var tempDoc = {
        TIMESTAMP: timestamp,
        TYPE: type.index,
        CONTENT: message,
        FROM: 'authState.userId',
      };

//       chatState.messageList!.add(Message(
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
//         from: authState.userModel?.key,
//         timestamp: timestamp,
//       ));

      Future.delayed(const Duration(milliseconds: 50)).then((_) {
        textEditingController.clear();
        replyMessage = null;
      });
    }
    try {
      // final chatState = Provider.of<ChatState>(context,listen: false);
      // if (chatState.messageList != null &&
      //     chatState.messageList!.length > 1 &&
      //     _controller.offset > 0) {
      //   _controller.animateTo(
      //     0.0,
      //     curve: Curves.easeOut,
      //     duration: const Duration(milliseconds: 300),
      //   );
      // }
    } catch (e) {
      if (kDebugMode) {
        print("[Error] $e");
      }
    }
  }

  save(Map<String, dynamic> doc) async {
    ViewDucts.toast('Saved');
    if (!_savedMessageDocs.any((_doc) => _doc[TIMESTAMP] == doc[TIMESTAMP])) {
      String? content;
      if (doc[TYPE] == MessageType.image.index) {
        content = doc[CONTENT].toString().startsWith('http')
            ? await Save.getBase64FromImage(imageUrl: doc[CONTENT] as String?)
            : doc[CONTENT]; // if not a url, it is a base64 from saved messages
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
    // if (doc[FROM] == authState.user!.uid && saved == false) {
    //   tiles.add(ListTile(
    //       dense: true,
    //       leading: const Icon(Icons.delete),
    //       title: const Text(
    //         'Delete',
    //         style: TextStyle(
    //             color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
    //       ),
    //       onTap: () {
    //         delete(doc[TIMESTAMP]);
    //         chatState.deleteMessages(doc);
    //         Navigator.pop(context);
    //         ViewDucts.toast('Deleted!');
    //       }));
    // }
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
                color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
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

  Widget buildTempMessage(MessagesType type, content, timestamp, delivered) {
    const bool isMe = true;
    return Container();
    // return SeenProvider(
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
    //           chatState.messageList!.last.senderId == authState.userModel?.key,
    //     ));
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

  Widget getTempTextMessage(String message) {
    return Text(
      message,
      style: const TextStyle(color: Colors.grey, fontSize: 16.0),
    );
  }

  bool isBlocked() {
    return false;
    //return chatState.onlineStatus.value.chatStatus == ChatStatus.blocked.index;
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

  Widget buildMessage(Map<String, dynamic> doc,
      {bool saved = false, List<Message>? savedMsgs}) {
    // final chatState = Provider.of<ChatState>(context, listen: false);
    // final authState = Provider.of<AuthState>(context, listen: false);

    // final bool isMe = doc[FROM] == authState.userModel!.userId;
    // bool isContinuing;
    // if (savedMsgs == null) {
    //   isContinuing = chatState.messageList!.isNotEmpty
    //       ? chatState.messageList!.last.senderId == doc[FROM]
    //       : false;
    // } else {
    //   isContinuing =
    //       savedMsgs.isNotEmpty ? savedMsgs.last.from == doc[FROM] : false;
    // }
    return Container();
    // return SeenProvider(
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
    //         delivered:
    //             chatState.getMessageStatus(userProfileId, doc[TIMESTAMP]),
    //         isContinuing: isContinuing));
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

  List<ChatMessageDesign> listOfMessages = [];
  getGroupedMessages(BuildContext context, List<ChatStoryModel> streamMessage) {
    RxList<Widget> _groupedMessages = RxList<Widget>([]);
    // var msgCount = ref
    //         .watch(getUnreadMessageProvider(UnreadMessageModel(
    //             chatListkey: widget.chatIdUsers!,
    //             senderUserId: secondUser!.userId!)))
    //         .value
    //         ?.length ??
    //     0;
    // int nums = 1;
    // var chatState = Provider.of<ChatState>(context, listen: false);
    groupBy<ChatStoryModel, String>(streamMessage, (msg) {
      return
          //getChatTime(msg.createdAt);
          getWhen(msg.createdAt);
    }).forEach(
      (when, _actualMessages) {
        for (var msg in _actualMessages) {
          // count++;
          // if (msgCount != 0) {
          //   _groupedMessages.value.add(Center(
          //       child: Chip(
          //     label: Text('${msgCount} unread messages'),
          //   )));

          //   // setState(() {
          //   //   ref
          //   //       .watch(getUnreadMessageProvider(UnreadMessageModel(
          //   //           chatListkey: widget.chatIdUsers!,
          //   //           senderUserId: secondUser.userId!)))
          //   //       .value
          //   //       ?.length = 0;
          //   //   msgCount = 0;
          //   // }); // reset
          // }
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
    // bool isMyTweet = authState.userId == model.userId;

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
                              '',
                              // '${chatState.chatUser!.displayName}\'s Contact:',
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
                                '',
                                // chatState.chatUser!.contact.toString(),
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

  Widget getPeerStatus(val, String? currentUserNo) {
    if (val is bool && val == true) {
      return Row(
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
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      );
    } else if (val is int) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(val);
      String at = DateFormat.jm().format(date), when = getTime(date);
      return Container(
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
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      );
    } else if (val is String) {
      if (val == currentUserNo) {
        return Container(
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
              'typing.value...',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }
      return const CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 5,
      );
    }
    return const Text('');
  }

  Widget _pageView({required int index, required DuctStoryModel data}) {
    switch (index) {
      case 0:
        return Container(
          decoration: BoxDecoration(
            color: Pallete.scafoldBacgroundColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(0),
              bottom: Radius.circular(0),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 35,
            vertical: 16,
          ),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CupertinoColors.darkBackgroundGray,
              ),
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Linkify(
                      onOpen: (link) async {
                        if (await canLaunchUrl(Uri.parse(link.url))) {
                          await launchURL(link.url);
                        } else {
                          throw 'Could not launch $link';
                        }
                      },
                      text: data.ductComment.toString(),
                      style: TextStyle(
                        color: CupertinoColors.lightBackgroundGray,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                      linkStyle: TextStyle(color: Colors.blueGrey))),
            ),
          ),
          //color: backgroundColor,
        );

      case 1:
        return Container(
          color: CupertinoColors.black,
          alignment: Alignment.center,
          child: SizedBox(
              height: Get.height,
              width: Get.width,
              child: customNetworkImage(data.imagePath, fit: BoxFit.cover)),
        );

      case 2:
        return VideoPlayerItem(
          videoUrl: data.videoPath.toString(),
        );

      default:
        return Container();
    }
  }

  // RealtimeSubscription? subscription;
  @override
  Widget build(BuildContext context) {
    // useEffect(
    //   () {
    //     chatUserProductId = productId;

    //     return () {};
    //   },
    //   [storyChatsMessages],
    // );

    //subscribe();
    // feedState.getStoryChatsFromDatabase(storyId);
    // chatState.getchatDetailAsync(authState.userId, chatState.chatUser?.userId);
    //userImage = chatState.chatUser.profilePic;
    // String id = userProfileId ?? chatState.chatUser.userId;
    // List<FeedModel>? list =
    //     feedState.getStoreProductList(userProfileId);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: KeyboardDismisser(
        gestures: const [
          GestureType.onTap,
          GestureType.onPanUpdateUpDirection,
        ],
        child: Scaffold(
            backgroundColor: Pallete.scafoldBacgroundColor,
            key: _scaffoldKey,
            body: SafeArea(
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  FractionallySizedBox(
                    alignment: Alignment.bottomCenter,
                    heightFactor: 1,
                    child: PageView(
                      children: [
                        Stack(
                          children: [
                            Column(
                              children: [
                                Expanded(
                                    child: Container(
                                  height: fullHeight(context) * 0.25,
                                  width: fullWidth(context),
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            offset: const Offset(0, 11),
                                            blurRadius: 11,
                                            color:
                                                Colors.black.withOpacity(0.06))
                                      ],
                                      borderRadius: BorderRadius.circular(18),
                                      color: CupertinoColors.inactiveGray),
                                  padding: const EdgeInsets.all(5.0),
                                  child: _pageView(
                                      data: widget.currentStory,
                                      index: widget.currentStory.storyType!),
                                )),
                                Expanded(
                                  child: Container(
                                    height: fullHeight(context) * 0.75,
                                    width: fullWidth(context),
                                    child: ref
                                        .watch(getPinDuctStoryProvider(
                                            widget.storyId.toString()))
                                        .when(
                                          data: (messages) {
                                            return ref
                                                .watch(
                                                    getPinDuctChatStreamProvider)
                                                .when(
                                                  data: (data) {
                                                    if (data.events.contains(
                                                      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.storyChtsId}.documents.*.create',
                                                    )) {
                                                      messages.insert(
                                                          0,
                                                          ChatStoryModel
                                                              .fromJson(data
                                                                  .payload));
                                                    } else if (data.events
                                                        .contains(
                                                      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.storyChtsId}.documents.*.update',
                                                    )) {
                                                      // get id of original chat
                                                      final startingPoint = data
                                                          .events[0]
                                                          .lastIndexOf(
                                                              'documents.');
                                                      final endPoint = data
                                                          .events[0]
                                                          .lastIndexOf(
                                                              '.update');
                                                      final chatId = data
                                                          .events[0]
                                                          .substring(
                                                              startingPoint +
                                                                  10,
                                                              endPoint);

                                                      var chat = messages
                                                          .where((element) =>
                                                              element.key ==
                                                              chatId)
                                                          .first;

                                                      final chatIndex = messages
                                                          .indexOf(chat);
                                                      messages.removeWhere(
                                                          (element) =>
                                                              element.key ==
                                                              chatId);

                                                      chat = ChatStoryModel
                                                          .fromJson(
                                                              data.payload);
                                                      messages.insert(
                                                          chatIndex, chat);
                                                    }

                                                    return Align(
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 50),
                                                          child:
                                                              //  isDesktop == true
                                                              //     ? Container()
                                                              //     :
                                                              _chatScreenBody(
                                                                  context,
                                                                  messages),
                                                        ));
                                                  },
                                                  error: (error, stackTrace) =>
                                                      ErrorText(
                                                    error: error.toString(),
                                                  ),
                                                  loading: () {
                                                    return Align(
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 50),
                                                          child:
                                                              //  isDesktop == true
                                                              //     ? Container()
                                                              //     :
                                                              _chatScreenBody(
                                                                  context,
                                                                  messages),
                                                        ));
                                                  },
                                                );
                                          },
                                          error: (error, stackTrace) =>
                                              ErrorText(
                                            error: error.toString(),
                                          ),
                                          loading: () => const Loader(),
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            isBlocked()
                                ? Container()
                                :
                                //chatControls()
                                Obx(
                                    () => _bottomEntryField(context),
                                  ),
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
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          //color: Colors.black,
                          icon: const Icon(CupertinoIcons.back),
                        ),
                        Container(
                          // width: 60,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(0, 11),
                                    blurRadius: 11,
                                    color: Colors.black.withOpacity(0.06))
                              ],
                              borderRadius: BorderRadius.circular(20),
                              color: Pallete.scafoldBacgroundColor),
                          padding: const EdgeInsets.all(5.0),
                          child: TitleText('PinDucts Chats',
                              // color: Colors.white,
                              // fontSize: 16,
                              // fontWeight: FontWeight.w800,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

class _Orders extends StatefulWidget {
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

  @override
  __OrdersState createState() => __OrdersState();
}

class __OrdersState extends State<_Orders> {
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
        child: _imageFeed(widget.list!.imagePath));
  }
}

class _StoreProducts extends StatefulWidget {
  const _StoreProducts({
    Key? key,
    required this.model,
    this.list,
    this.type,
  }) : super(key: key);

  final FeedModel? model;
  final FeedModel? list;
  final DuctType? type;

  @override
  __StoreProductsState createState() => __StoreProductsState();
}

class __StoreProductsState extends State<_StoreProducts> {
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
        _imageFeed(widget.list!.imagePath),
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
                      Text('${widget.list!.price}',
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
                      Text('${widget.list!.productName}',
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

class _SelectedProduct extends StatelessWidget {
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
    return Row(
      children: [
        SizedBox(
          width: Get.width * 0.2,
          height: Get.width * 0.2,
          // child: _imageFeed(
          //   feedState.productlist!
          //       .firstWhere(
          //         (e) => e.key == ductId,
          //       )
          //       .imagePath,
          // )
        ),
        Column(
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
                          // NumberFormat.currency(name: 'N ').format(
                          //     int.parse('${feedState.productlist!.firstWhere(
                          //           (e) => e.key == ductId,
                          //         ).price}')),
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

const primaryColor = Color(0xFF2697FF);
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFF212332);

const defaultPadding = 16.0;

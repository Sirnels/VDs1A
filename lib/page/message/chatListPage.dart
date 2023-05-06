// ignore_for_file: invalid_use_of_protected_member, unnecessary_null_comparison, file_names

import 'dart:io';
import 'dart:ui';
import 'package:animations/animations.dart';
import 'package:appwrite/appwrite.dart';
//import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:lottie/lottie.dart';
import 'package:minio/minio.dart';
//import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:viewducts/admin/Admin_dashbord/responsive.dart';
import 'package:viewducts/admin/screens/video_admin_upload.dart';
import 'package:viewducts/apis/auth_api.dart';
import 'package:viewducts/apis/chat_api.dart';
import 'package:viewducts/common/chat_loading_page.dart';
import 'package:viewducts/common/common.dart';
import 'package:viewducts/constants/constants.dart';
// import 'package:scoped_model/scoped_model.dart';
import 'package:viewducts/encryption/encryption.dart';
import 'package:viewducts/features/auth/controller/auth_controller.dart';
import 'package:viewducts/features/chats/chat_controller.dart';
import 'package:viewducts/features/products/product_controller.dart';
import 'package:viewducts/helper/constant.dart';
import 'package:viewducts/helper/enum.dart';
import 'package:viewducts/helper/theme.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/chatModel.dart';
import 'package:viewducts/model/feedModel.dart';

import 'package:viewducts/model/user.dart';
import 'package:viewducts/page/message/item_Search_bar.dart';
import 'package:viewducts/page/message/local_database.dart';

import 'package:viewducts/page/responsiveView.dart';

import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/state/viewDuctsNotification.dart';
import 'package:viewducts/widgets/cartIcon.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/frosted.dart';
import 'package:viewducts/widgets/newWidget/emptyList.dart';
import 'package:viewducts/widgets/newWidget/rippleButton.dart';
import 'package:viewducts/widgets/newWidget/title_text.dart';
import 'dart:async';
import 'dart:core';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:get/get.dart';

// ignore: must_be_immutable
class ChatListPage extends ConsumerWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  bool isDesktop;
  bool isTablet;
  bool isCart;
  ChatListPage(
      {Key? key,
      this.scaffoldKey,
      this.isDesktop = false,
      this.isTablet = false,
      this.isCart = false})
      : super(key: key);

//   @override
//   State<ChatListPage> createState() => _ChatListPageState();
// }

// class _ChatListPageState extends State<ChatListPage> {
//   _ChatListPageState createState() => _ChatListPageState();
  late AnimationController animationController;

  SharedPreferences? prefs;

  bool showHidden = false, biometricEnabled = false;

  int? unread;

  ViewductsUser? viewductsUser;

  late encrypt.Encrypter cryptor;

  final iv = encrypt.IV.fromLength(8);

  bool isAuthenticating = false;

  ScrollController scrollController = ScrollController();

  StreamSubscription? spokenSubscription;

  List<StreamSubscription> unreadSubscriptions = <StreamSubscription>[];

  double topDuct = 0;

  Color? wordCountColor;

  List<StreamController> controllers = <StreamController>[];

  bool closeTopStores = false;

  // DataModel _cachedModel;
  List<dynamic> itemList = [];

  double? height, width, xPosiion, yPosition;

  late OverlayEntry floatingMenu;

  var isDropdown = false.obs;

  void toggle() => animationController.isDismissed
      ? animationController.forward()
      : animationController.reverse();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var appSize = MediaQuery.of(context).size;
    Bible bible = Bible();
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    // final chatListDataBase = ref.watch(currentChatListDetailsProvider);
    // Rx<KeyViewducts> keysView = KeyViewducts().obs;
    // RealtimeSubscription? subscription;
    // final appPlayStoreState = useState(authState.appPlayStore);
    // final animationController = useAnimationController(
    //   duration: Duration(milliseconds: 600),
    // );
    // final setState = useState(() {});
    // final idState = useState(''.obs);
    // final idsState = useState(''.obs);
    // final chatSetState = useState(chatState.chatUserList);
    // final messageCountState = useState(chatState.msgCount);
    // final realtime = Realtime(clientConnect());
    // final chatStream = useStream(realtime.subscribe(
    //     ["databases.$databaseId.collections.$chatsColl.documents"]).stream);
    // final meesagesCountStreaming = useStream(realtime.subscribe([
    //   "databases.$chatDatabase.collections.${idState}.documents"
    // ]).stream);
    // final meesagesCountsStreaming = useStream(realtime.subscribe([
    //   "databases.$chatDatabase.collections.${idsState}.documents"
    // ]).stream);
    // Future<bool?> _showDialogs() {
    //   return showDialog(
    //     context: Get.context!,
    //     barrierDismissible: false,
    //     builder: (BuildContext context) {
    //       return frostedYellow(
    //         Dialog(
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(20),
    //           ),
    //           backgroundColor: Colors.transparent,
    //           child: frostedYellow(
    //             Center(
    //               child: SingleChildScrollView(
    //                 scrollDirection: Axis.vertical,
    //                 child: Container(
    //                   height: Get.height * 0.5,
    //                   child: Column(
    //                     children: [
    //                       Padding(
    //                         padding: const EdgeInsets.all(5.0),
    //                         child: Container(
    //                             decoration: BoxDecoration(
    //                                 boxShadow: [
    //                                   BoxShadow(
    //                                       offset: const Offset(0, 11),
    //                                       blurRadius: 11,
    //                                       color: Colors.black.withOpacity(0.06))
    //                                 ],
    //                                 borderRadius: BorderRadius.circular(18),
    //                                 color: CupertinoColors.white),
    //                             padding: const EdgeInsets.all(5.0),
    //                             child: GestureDetector(
    //                               onTap: () {
    //                                 Navigator.maybePop(context);
    //                               },
    //                               child: const Text(
    //                                 'Downlod App to Countinue',
    //                                 style:
    //                                     TextStyle(fontWeight: FontWeight.w200),
    //                               ),
    //                             )),
    //                       ),
    //                       // authState.appPlayStore
    //                       //         .where((data) => data.operatingSystem == 'IOS')
    //                       //         .isNotEmpty
    //                       //     ?
    //                       GestureDetector(
    //                         onTap: () {},
    //                         child: Image.asset(
    //                           'assets/app-store.png',
    //                           height: context.responsiveValue(
    //                               mobile: Get.height * 0.1,
    //                               tablet: Get.height * 0.1,
    //                               desktop: Get.height * 0.1),
    //                         ),
    //                       ),
    //                       // : Container(),
    //                       // authState.appPlayStore
    //                       //         .where((data) => data.operatingSystem == 'Android')
    //                       //         .isNotEmpty
    //                       //     ?
    //                       GestureDetector(
    //                         onTap: () {
    //                           String? appDownload = appPlayStoreState
    //                               .firstWhere((data) =>
    //                                   data.operatingSystem == 'Android')
    //                               .downloadApp;
    //                           String? storeUrl = appPlayStoreState
    //                               .firstWhere((data) =>
    //                                   data.operatingSystem == 'Android')
    //                               .storeUrl;
    //                           String? downlodUrl = appPlayStoreState
    //                               .firstWhere((data) =>
    //                                   data.operatingSystem == 'Android')
    //                               .downloadUrl;
    //                           final minio = Minio(
    //                               endPoint: userCartController
    //                                   .wasabiAws.endPoint
    //                                   .toString(),
    //                               accessKey: userCartController
    //                                   .wasabiAws.accessKey
    //                                   .toString(),
    //                               secretKey: userCartController
    //                                   .wasabiAws.secretKey
    //                                   .toString(),
    //                               region: userCartController
    //                                   .wasabiAws.region
    //                                   .toString());
    //                           appDownload == ''
    //                               ? minio.getObject(
    //                                   userCartController
    //                                       .wasabiAws.buckedId
    //                                       .toString(),
    //                                   '$downlodUrl')
    //                               : launchURL("$storeUrl");
    //                         },
    //                         child: Image.asset(
    //                           'assets/google-play.png',
    //                           height: context.responsiveValue(
    //                               mobile: Get.height * 0.15,
    //                               tablet: Get.height * 0.15,
    //                               desktop: Get.height * 0.15),
    //                         ),
    //                       )
    //                       //: Container(),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //       );
    //     },
    //   );
    // }

    void _bibleTips(BuildContext context) {
      showModalBottomSheet(
          backgroundColor: Colors.red,
          // bounce: true,
          context: context,
          builder: (context) => Scaffold(
                backgroundColor: CupertinoColors.darkBackgroundGray,
                body: SafeArea(
                    child: Responsive(
                  mobile: Obx(
                    () => Stack(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(0, 11),
                                    blurRadius: 11,
                                    color: Colors.black.withOpacity(0.06))
                              ],
                              borderRadius: BorderRadius.circular(18),
                              color: CupertinoColors.darkBackgroundGray),
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Wrap(
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
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          color: CupertinoColors.systemYellow),
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        'Theme:',
                                        style: TextStyle(
                                            color: CupertinoColors
                                                .darkBackgroundGray),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${bible.theme}',
                                        style: TextStyle(
                                            color: CupertinoColors
                                                .lightBackgroundGray),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Wrap(
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
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          color: CupertinoColors.systemYellow),
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        'Topic:'.tr,
                                        style: TextStyle(
                                            color: CupertinoColors
                                                .darkBackgroundGray),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${bible.topic}'.tr,
                                        style: TextStyle(
                                            color: CupertinoColors
                                                .lightBackgroundGray),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Wrap(
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
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          color: CupertinoColors.systemYellow),
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(
                                        'Bible Verse:'.tr,
                                        style: TextStyle(
                                            color: CupertinoColors
                                                .darkBackgroundGray),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${bible.text}'.tr,
                                        style: TextStyle(
                                            color: CupertinoColors
                                                .lightBackgroundGray),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              bible.videoPath == null
                                  ? Container()
                                  : const Divider(
                                      color: CupertinoColors.systemYellow,
                                    ),
                              bible.videoPath == null
                                  ? Container()
                                  : Wrap(
                                      children: [
                                        Hero(
                                          tag: bible.videoPath.toString(),
                                          child: Center(
                                            child: frostedWhite(
                                              Container(
                                                decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                        offset:
                                                            const Offset(0, 11),
                                                        blurRadius: 11,
                                                        color: Colors.black
                                                            .withOpacity(0.06))
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(18),
                                                ),
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.4,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.25,
                                                child: Stack(
                                                  children: [
                                                    VideoUploadAdmin(
                                                      isBible: true,

                                                      // playNow: true,
                                                      videoFile: File(bible
                                                          .videoPath
                                                          .toString()),
                                                      videoPath: bible.videoPath
                                                          .toString(),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                              const Divider(
                                color: CupertinoColors.systemYellow,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Wrap(
                                  children: [
                                    Linkify(
                                      onOpen: (link) async {
                                        if (await canLaunchUrl(
                                            Uri.parse(link.url))) {
                                          await launchURL(link.url);
                                        } else {
                                          throw 'Could not launch $link';
                                        }
                                      },
                                      text: bible.body.toString().tr,
                                      style: TextStyle(
                                          color: CupertinoColors.systemYellow),
                                      linkStyle: onPrimarySubTitleText.copyWith(
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  tablet: Stack(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Stack(
                              children: <Widget>[],
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
                              children: <Widget>[],
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

    // allChatMessage() async {
    //   WidgetsBinding.instance.addPostFrameCallback((_) async {
    //     final database = Databases(
    //       clientConnect(),
    //     );
    //     try {
    //       DynamicLinksService.initDynamicLinks();
    //       // chatSetState? =
    //       //     await SQLHelper.findLocalChatliistMessages();
    //       // if (authState.logginType == 'local') {
    //       //   final account = acc.Account(clientConnect());
    //       //   account.get().then((data) async {
    //       //     try {
    //       //       if (data.status == true) {
    //       //         await authState.setInitialScreen(clientConnect());
    //       //         authState.logginType = 'online';
    //       //       }
    //       //     } on AppwriteException catch (e) {
    //       //       cprint(e.message);
    //       //     }
    //       //   });
    //       // }
    //       await database.listDocuments(
    //           databaseId: databaseId,
    //           collectionId: chatsColl,
    //           queries: [
    //             Query.orderDesc('createdAt'),
    //             //  Query.notEqual('userId', authState.appUser!.$id),
    //           ]).then((data) async {
    //         //   if (data.documents.isNotEmpty) {
    //         var value = data.documents
    //             .map((e) => ChatMessage.fromJson(e.data))
    //             .toList();
    //         chatSetState? = value;
    //         // value.forEach((data) async {
    //         //   // if (chatSetState!
    //         //   //         .firstWhere((msg) => msg.userId == data.userId,
    //         //   //             orElse: () => ChatMessage())
    //         //   //         .userId ==
    //         //   //     authState.appUser!.$id) {
    //         //   //   return;
    //         //   // }
    //         //   return await SQLHelper.createLocalchatList(data);
    //         // });
    //         // chatSetState? =
    //         //     await SQLHelper.findLocalChatliistMessages();
    //         // chatSetState? = value;
    //         // } else {}
    //       });
    //       await database.listDocuments(
    //           databaseId: databaseId,
    //           collectionId: profileUserColl,
    //           queries: [
    //             Query.equal(
    //                 'key',
    //                 chatSetState!
    //                     .map((data) => data.receiverId.toString())
    //                     .toList())
    //           ]
    //           //  queries: [query.Query.equal('key', ductId)]
    //           ).then((data) {
    //         if (data.documents.isNotEmpty) {
    //           var value = data.documents
    //               .map((e) => ViewductsUser.fromJson(e.data))
    //               .toList();

    //           searchState.viewUserlistChatList = value.obs;
    //           chatState.chatUser ==
    //               value
    //                   .firstWhere((data) => data.key == authState.appUser?.$id,
    //                       orElse: () => ViewductsUser())
    //                   .obs;
    //         }
    //       });
    //       await database
    //           .getDocument(
    //               databaseId: databaseId,
    //               collectionId: 'keyViewducts',
    //               documentId: 'keysViewKeys')
    //           .then((doc) {
    //         keysView = KeyViewducts.fromSnapshot(doc.data);
    //       });
    //       await database
    //           .getDocument(
    //               databaseId: databaseId,
    //               collectionId: 'clipsBible',
    //               documentId: keysView.viewductKey.toString())
    //           .then((doc) {
    //         bible = Bible.fromSnapshot(doc.data);
    //       });
    //       await database.listDocuments(
    //           databaseId: databaseId,
    //           collectionId: playAppStoreColl,
    //           queries: [Query.equal('active', true)]).then((data) {
    //         var value = data.documents
    //             .map((e) => AppPlayStoreModel.fromJson(e.data))
    //             .toList();

    //         appPlayStoreState = value.obs;
    //       });
    //     } on AppwriteException catch (e) {
    //       cprint('$e allChatMessage chatlist');
    //     }
    //   });
    // }

    // subs() {
    //   chatStream.data;
    //   if (chatSetState! != null) {
    //     switch (chatStream.data?.events) {
    //       case ["collections.*.documents"]:
    //         // setState(() {});
    //         chatSetState!
    //             .add(ChatMessage.fromJson(chatStream.data?.payload));

    //         break;
    //       case ["collections.*.documents.*.delete"]:
    //         // setState(() {});
    //         chatSetState!.removeWhere(
    //             (datas) => datas.key == chatStream.data!.payload['key']);

    //         break;

    //       default:
    //         break;
    //     }
    //   } else {
    //     cprint('it is empty');
    //   }
    // }

    // meesagesCountSubs() {
    //   meesagesCountStreaming.data;
    //   if (messageCountState != null) {
    //     switch (meesagesCountStreaming.data?.events) {
    //       case ["collections.*.documents"]:
    //         messageCountState =
    //             meesagesCountStreaming.data!.payload.length;

    //         break;

    //       default:
    //         break;
    //     }
    //   } else {
    //     cprint('it is empty');
    //   }
    // }

    // meesagesCountSub() {
    //   meesagesCountsStreaming.data;
    //   if (messageCountState != null) {
    //     switch (meesagesCountsStreaming.data?.events) {
    //       case ["collections.*.documents"]:
    //         messageCountState =
    //             meesagesCountsStreaming.data!.payload.length;

    //         break;

    //       default:
    //         break;
    //     }
    //   } else {
    //     cprint('it is empty');
    //   }
    // }

    // final msCountStreaming = useMemoized(() => meesagesCountSubs());
    // final msCountsStreaming = useMemoized(() => meesagesCountSub());
    // final subStreaming = useMemoized(() => subs());
    // // preference() async {
    // //   prefs = await SharedPreferences.getInstance();
    // // }

    getWhen(String? time) {
      if (time == null || time.isEmpty) {
        return '';
      }
      var date = DateTime.parse(time).toLocal();

      var dat = DateFormat.jm().format(date);
      DateTime now = DateTime.now();
      String when;
      if (date.minute == now.minute) {
        when = 'Just Now';
      } else if (date.day == now.day) {
        when = dat;
      } else if (date.day == now.subtract(const Duration(days: 1)).day) {
        when = 'yesterday';
      } else {
        when = DateFormat.MMMd().format(date);
      }
      return when;
    }

    String? getLastMessage(String? message) {
      if (message != null && message.isNotEmpty) {
        if (message.length > 28) {
          message = message.substring(0, 25) + '...';
          return message;
        } else {
          return message;
        }
      }
      return null;
    }

    Widget _userCard(
      ViewductsUser model,
      ChatMessage lastMessage,
      BuildContext context,
      RxInt msgCounts,
      // var setState,
      // ValueNotifier<RxString> idState,
      // ValueNotifier<RxString> idsState
    ) {
      // msgCount = 0.obs;
      // msgCounting() async {
      //   final database = Databases(
      //     clientConnect(),
      //   );
      //   try {
      //     idState =
      //         '${authState.appUser?.$id.splitByLength((authState.appUser!.$id.length) ~/ 2)[0]}_${model.userId?.splitByLength((model.userId!.length) ~/ 2)[0]}';
      //     idsState =
      //         '${model.userId?.splitByLength((model.userId!.length) ~/ 2)[0]}_${authState.appUser?.$id.splitByLength((authState.appUser!.$id.length) ~/ 2)[0]}';

      //     await database.listDocuments(
      //         databaseId: chatDatabase,
      //         collectionId: idState,
      //         queries: [
      //           Query.equal('seen', 'false'),
      //           Query.equal(
      //               'senderId', lastMessage.receiverId.toString()),
      //         ]).then((data) {
      //       if (data.documents.isNotEmpty) {
      //         cprint('${data.total} unread');
      //         msgCount = data.total;
      //       }
      //     }).onError((error, stackTrace) async {
      //       if (error == 404) {
      //         try {
      //           final database = Databases(
      //             clientConnect(),
      //           );
      //           await database.listDocuments(
      //               databaseId: chatDatabase,
      //               collectionId: idsState,
      //               queries: [
      //                 Query.equal('seen', 'false'),
      //                 Query.equal(
      //                     'senderId', lastMessage.receiverId.toString()),
      //               ]).then((data) async {
      //             if (data.documents.isNotEmpty) {
      //               cprint('${data.total} unread');
      //               msgCount == data.total.obs;
      //             } else {}
      //           });
      //           setState;
      //         } on AppwriteException catch (e) {
      //           cprint('$e msgCounting');
      //         }
      //       }
      //     });
      //     setState;
      //   } on AppwriteException catch (e) {
      //     cprint('$e msgcount');
      //   }
      // }

      // msgCounting();
      var msgCount = ref
              .watch(getUnreadMessageProvider(UnreadMessageModel(
                  chatListkey: lastMessage.chatlistKey!,
                  senderUserId: lastMessage.receiverId!)))
              .value
              ?.length
              .obs ??
          0;
      Storage storage = Storage(clientConnect());
      Image? url;
      if (model.userProfilePic == null) {
      } else {
        storage
            .getFileView(
                bucketId: profileImageBudgetId,
                fileId: model.userProfilePic.toString())
            .then((bytes) {
          url = Image.memory(bytes);
        });
      }
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          leading: RippleButton(
            onPressed: () {
              if (lastMessage.receiverId != null) {
                //chatState.setChatUser = model;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OpenContainer(
                              closedBuilder: (context, action) {
                                return ProfileResponsiveView(
                                  profileId: lastMessage.receiverId,
                                  profileType: ProfileType.Store,
                                );
                              },
                              openBuilder: (context, action) {
                                return ProfileResponsiveView(
                                  profileId: lastMessage.receiverId,
                                  profileType: ProfileType.Store,
                                );
                              },
                            )));
              } else if (isCart == true) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OpenContainer(
                              closedBuilder: (context, action) {
                                return ProfileResponsiveView(
                                  profileId: lastMessage.receiverId,
                                  profileType: ProfileType.Store,
                                );
                              },
                              openBuilder: (context, action) {
                                return ProfileResponsiveView(
                                  profileId: lastMessage.receiverId,
                                  profileType: ProfileType.Store,
                                );
                              },
                            )));
              }
              //              Navigator.of(context).pushNamed('/ProfilePage/${model.userId}');
            },
            borderRadius: BorderRadius.circular(28),
            child: Hero(
              tag: model.profilePic ?? DateTime.now().microsecondsSinceEpoch,
              child: Stack(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.transparent,
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.yellow.shade200,
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.transparent,
                                child: Material(
                                  elevation: 20,
                                  borderRadius: BorderRadius.circular(100),
                                  child: model.userProfilePic == null
                                      ? customImage(context,
                                          model.profilePic ?? dummyProfilePic,
                                          height: fullHeight(context) * 0.06)
                                      : FutureBuilder(
                                          future: storage.getFileView(
                                              bucketId: profileImageBudgetId,
                                              fileId: model.userProfilePic
                                                  .toString()),
                                          builder: (context, snap) {
                                            return snap.hasData &&
                                                        snap.data != null ||
                                                    url?.image != null
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        image: DecorationImage(
                                                            image: url?.image ??
                                                                customAdvanceNetworkImage(
                                                                    dummyProfilePic),
                                                            fit: BoxFit.cover),
                                                        color:
                                                            Colors.blueGrey[50],
                                                        gradient:
                                                            LinearGradient(
                                                          colors: [
                                                            Colors.yellow
                                                                .withOpacity(
                                                                    0.1),
                                                            Colors.white60
                                                                .withOpacity(
                                                                    0.2),
                                                            Colors.pink
                                                                .withOpacity(
                                                                    0.3)
                                                          ],
                                                          // begin: Alignment.topCenter,
                                                          // end: Alignment.bottomCenter,
                                                        )),
                                                  )
                                                : SizedBox();
                                          }),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: model.isVerified == true
                            ? Material(
                                elevation: 10,
                                borderRadius: BorderRadius.circular(100),
                                child: CircleAvatar(
                                  radius: 9,
                                  backgroundColor: Colors.transparent,
                                  child: Image.asset('assets/delicious.png'),
                                ),
                              )
                            : Container(),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          title: SingleChildScrollView(
            child: Row(
              children: [
                isCart == true
                    ? Container(
                        child: TitleText(
                          "${model.displayName} Store",
                          fontSize: 16,
                          color: CupertinoColors.white,
                          fontWeight: FontWeight.w900,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    : TitleText(
                        model.displayName ?? "",
                        fontSize: 16,
                        color: CupertinoColors.white,
                        fontWeight: FontWeight.w900,
                        overflow: TextOverflow.ellipsis,
                      ),
                model.isVerified == true
                    ? customIcon(
                        context,
                        icon: AppIcon.blueTick,
                        istwitterIcon: true,
                        iconColor: AppColor.primary,
                        size: 9,
                        paddingIcon: 3,
                      )
                    : const SizedBox(width: 0),
              ],
            ),
          ),
          subtitle: ViewDuctMenuHolder(
            onPressed: () {},
            menuItems: <DuctFocusedMenuItem>[
              DuctFocusedMenuItem(
                  title: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(0, 11),
                                    blurRadius: 11,
                                    color: Colors.black.withOpacity(0.06))
                              ],
                              borderRadius: BorderRadius.circular(18),
                              color: CupertinoColors.systemYellow),
                          padding: const EdgeInsets.all(5.0),
                          child: const Text('Copy'))),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(
                        text: TextEncryptDecrypt.decryptAES(
                            lastMessage.message)));
                  },
                  trailingIcon: const Icon(CupertinoIcons.add_circled_solid)),
            ],
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                    onLongPress: () async {
                      if (lastMessage.type == 2 &&
                          lastMessage.userId == authState.appUser!.$id) {
                        showModalBottomSheet(
                            backgroundColor: Colors.red,
                            //bounce: true,
                            context: context,
                            builder: (context) => ShoppingCartResponsive(
                                cart: userCartController.cart,
                                sellerId: lastMessage.receiverId,
                                buyerId: lastMessage.senderId,
                                sellersName: model.displayName));
                      }
                    },
                    onTap: () async {
                      if (kIsWeb) {
                        // lastMessage.type == 2
                        //     ? showModalBottomSheet(
                        //         backgroundColor: Colors.red,
                        //         bounce: true,
                        //         context: context,
                        //         builder: (context) =>
                        //             ShoppingCartResponsive(
                        //               cart: userCartController.cart,
                        //               sellerId:
                        //                   lastMessage.receiverId,
                        //               buyerId: lastMessage.senderId,
                        //             ))
                        //     : _showDialogs();
                      } else {
                        //chatState.setChatUser = model;

                        // if (searchState.viewUserlistChatList
                        //     .any((x) => x.userId == lastMessage.receiverId)) {
                        //   chatState.setChatUser = searchState
                        //       .viewUserlistChatList
                        //       .where((x) => x.userId == lastMessage.receiverId)
                        //       .first;
                        //   //}
                        //   chatState.chatMessage =
                        //       await SQLHelper.findLocalMessages(
                        //           lastMessage.chatlistKey.toString());
                        //   chatState.upDateChatListMessages(
                        //       currentUser: authState.userModel?.key,
                        //       secondUser: lastMessage.receiverId);

                        if (isCart == true) {
                          showModalBottomSheet(
                              backgroundColor: Colors.red,
                              // bounce: true,
                              context: context,
                              builder: (context) => ShoppingCartResponsive(
                                  cart: userCartController.cart,
                                  sellerId: lastMessage.receiverId,
                                  buyerId: lastMessage.senderId,
                                  sellersName: model.displayName));
                        } else {
                          ref.read(chatUserIdProvider.notifier).state =
                              lastMessage.chatlistKey!;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OpenContainer(
                                        closedBuilder: (context, action) {
                                          return ChatResponsive(
                                            keyId: lastMessage.searchKey,
                                            chatIdUsers:
                                                lastMessage.chatlistKey,
                                            userProfileId:
                                                lastMessage.receiverId,
                                          );
                                        },
                                        openBuilder: (context, action) {
                                          return ChatResponsive(
                                            keyId: lastMessage.searchKey,
                                            chatIdUsers:
                                                lastMessage.chatlistKey,
                                            userProfileId:
                                                lastMessage.receiverId,
                                          );
                                        },
                                      )));
                        }
                        // }
                      }
                    },
                    child: Container(
                      child:
                          TextEncryptDecrypt.decryptAES(lastMessage.message)
                                      .length <
                                  20
                              ? Badge(
                                  backgroundColor: msgCount == 0.obs
                                      ? Colors.transparent
                                      : Colors.red,
                                  label: Text(
                                    msgCount == 0.obs ? '' : '${msgCount}',
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            offset: const Offset(0, 11),
                                            blurRadius: 11,
                                            color:
                                                Colors.black.withOpacity(0.06))
                                      ],
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    padding: const EdgeInsets.all(5.0),
                                    child: CustomPaint(
                                      painter: ViewductChatBuble(
                                          color: lastMessage.seen == 'deleted'
                                              ? CupertinoColors.systemRed
                                              : lastMessage.type == 2
                                                  ? CupertinoColors.activeOrange
                                                  : CupertinoColors
                                                      .lightBackgroundGray,
                                          alignment: Alignment.topRight,
                                          tail: true),
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 9, horizontal: 15),
                                          child: lastMessage.type == 1
                                              ? Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.camera_alt,
                                                      color: Colors.cyan,
                                                    ),
                                                    customText(
                                                      'Image',
                                                      style: onPrimarySubTitleText
                                                          .copyWith(
                                                              color: CupertinoColors
                                                                  .darkBackgroundGray),
                                                    ),
                                                  ],
                                                )
                                              : lastMessage.type == 2
                                                  ? Row(
                                                      children: [
                                                        // Image.asset(
                                                        //   'assets/carts.png',
                                                        //   height:
                                                        //       Get.height *
                                                        //           0.02,
                                                        // ),
                                                        const SizedBox(
                                                            width: 2),
                                                        customText(
                                                          '${lastMessage.productName}',
                                                          style: onPrimarySubTitleText
                                                              .copyWith(
                                                                  color: CupertinoColors
                                                                      .darkBackgroundGray),
                                                        ),
                                                      ],
                                                    )
                                                  : lastMessage.type == 3
                                                      ? Row(
                                                          children: [
                                                            CircleAvatar(
                                                              radius:
                                                                  Get.width *
                                                                      0.03,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              child: Image.asset(
                                                                  'assets/groceries.png'),
                                                            ),
                                                            customText(
                                                              'My oders',
                                                              style: onPrimarySubTitleText
                                                                  .copyWith(
                                                                      color: CupertinoColors
                                                                          .darkBackgroundGray),
                                                            ),
                                                          ],
                                                        )
                                                      : lastMessage.type == 4
                                                          ? Row(
                                                              children: [
                                                                Image.asset(
                                                                  'assets/shopping-bag.png',
                                                                  height:
                                                                      Get.height *
                                                                          0.02,
                                                                ),
                                                                customText(
                                                                  'Sellers product',
                                                                  style: onPrimarySubTitleText
                                                                      .copyWith(
                                                                          color:
                                                                              CupertinoColors.darkBackgroundGray),
                                                                ),
                                                              ],
                                                            )
                                                          : lastMessage.type ==
                                                                  5
                                                              ? Row(
                                                                  children: [
                                                                    const Icon(
                                                                      Icons
                                                                          .video_camera_front,
                                                                      color: Colors
                                                                          .cyan,
                                                                    ),
                                                                    customText(
                                                                      'Video',
                                                                      style: onPrimarySubTitleText.copyWith(
                                                                          color:
                                                                              CupertinoColors.darkBackgroundGray),
                                                                    ),
                                                                  ],
                                                                )
                                                              : lastMessage
                                                                          .type ==
                                                                      7
                                                                  ? Row(
                                                                      children: [
                                                                        const Icon(
                                                                          CupertinoIcons
                                                                              .music_note_2,
                                                                          color:
                                                                              Colors.cyan,
                                                                        ),
                                                                        customText(
                                                                          'Audio',
                                                                          style:
                                                                              onPrimarySubTitleText.copyWith(color: CupertinoColors.darkBackgroundGray),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  : lastMessage
                                                                              .seen ==
                                                                          'deleted'
                                                                      ? Linkify(
                                                                          onOpen:
                                                                              (link) async {
                                                                            if (await canLaunchUrl(Uri.parse(link.url))) {
                                                                              await launchURL(link.url);
                                                                            } else {
                                                                              throw 'Could not launch $link';
                                                                            }
                                                                          },
                                                                          text: getLastMessage('message deleted') ??
                                                                              '@${model.displayName ?? ''}',
                                                                          style: TextStyle(
                                                                              color: CupertinoColors.lightBackgroundGray,
                                                                              fontStyle: FontStyle.italic),
                                                                          linkStyle:
                                                                              onPrimarySubTitleText.copyWith(color: Colors.yellow),
                                                                        )
                                                                      : Linkify(
                                                                          onOpen:
                                                                              (link) async {
                                                                            if (await canLaunchUrl(Uri.parse(link.url))) {
                                                                              await launchURL(link.url);
                                                                            } else {
                                                                              throw 'Could not launch $link';
                                                                            }
                                                                          },
                                                                          text: getLastMessage(TextEncryptDecrypt.decryptAES(lastMessage.message)) ??
                                                                              '@${model.displayName ?? ''}',
                                                                          style:
                                                                              TextStyle(color: CupertinoColors.darkBackgroundGray),
                                                                          linkStyle:
                                                                              onPrimarySubTitleText.copyWith(color: Colors.yellow),
                                                                        )

                                          // Padding(
                                          //   padding: const EdgeInsets.symmetric(horizontal: 10),
                                          //   child: UrlText(
                                          //     text: getLastMessage(TextEncryptDecrypt.decryptAES(lastMessage.message)) ?? '@${model.displayName ?? ''}',
                                          //     style: onPrimarySubTitleText.copyWith(color: CupertinoColors.darkBackgroundGray),
                                          //     urlStyle: const TextStyle(
                                          //       fontSize: 16,
                                          //     ),
                                          //   ),
                                          // ),
                                          ),
                                    ),
                                  ),
                                )
                              : Badge(
                                  backgroundColor: msgCount == 0.obs
                                      ? Colors.transparent
                                      : Colors.red,
                                  label: Text(
                                    msgCount == 0.obs ? '' : '${msgCount}',
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            offset: const Offset(0, 11),
                                            blurRadius: 11,
                                            color:
                                                Colors.black.withOpacity(0.06))
                                      ],
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    padding: const EdgeInsets.all(5.0),
                                    child: CustomPaint(
                                      painter: ViewductChatBuble(
                                          color: lastMessage.seen == 'deleted'
                                              ? CupertinoColors.systemRed
                                              : lastMessage.type == 2
                                                  ? CupertinoColors.activeOrange
                                                  : CupertinoColors
                                                      .lightBackgroundGray,
                                          alignment: Alignment.topRight,
                                          tail: true),
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 9, horizontal: 12),
                                          child: lastMessage.type == 1
                                              ? Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.camera_alt,
                                                      color: Colors.cyan,
                                                    ),
                                                    customText(
                                                      'Image',
                                                      style: onPrimarySubTitleText
                                                          .copyWith(
                                                              color: CupertinoColors
                                                                  .darkBackgroundGray),
                                                    ),
                                                  ],
                                                )
                                              : lastMessage.type == 2
                                                  ? SingleChildScrollView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      child: Row(
                                                        children: [
                                                          // Image.asset(
                                                          //   'assets/carts.png',
                                                          //   height:
                                                          //       Get.height *
                                                          //           0.02,
                                                          // ),
                                                          const SizedBox(
                                                              width: 2),
                                                          customText(
                                                            '${lastMessage.productName}',
                                                            style: onPrimarySubTitleText
                                                                .copyWith(
                                                                    color: CupertinoColors
                                                                        .darkBackgroundGray),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : lastMessage.type == 3
                                                      ? Row(
                                                          children: [
                                                            CircleAvatar(
                                                              radius:
                                                                  Get.width *
                                                                      0.03,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              child: Image.asset(
                                                                  'assets/groceries.png'),
                                                            ),
                                                            customText(
                                                              'My oders',
                                                              style: onPrimarySubTitleText
                                                                  .copyWith(
                                                                      color: CupertinoColors
                                                                          .darkBackgroundGray),
                                                            ),
                                                          ],
                                                        )
                                                      : lastMessage.type == 4
                                                          ? Row(
                                                              children: [
                                                                Image.asset(
                                                                  'assets/shopping-bag.png',
                                                                  height:
                                                                      Get.height *
                                                                          0.02,
                                                                ),
                                                                customText(
                                                                  'Sellers product',
                                                                  style: onPrimarySubTitleText
                                                                      .copyWith(
                                                                          color:
                                                                              Colors.yellow),
                                                                ),
                                                              ],
                                                            )
                                                          : lastMessage.seen ==
                                                                  'deleted'
                                                              ? Linkify(
                                                                  onOpen:
                                                                      (link) async {
                                                                    if (await canLaunchUrl(
                                                                        Uri.parse(
                                                                            link.url))) {
                                                                      await launchURL(
                                                                          link.url);
                                                                    } else {
                                                                      throw 'Could not launch $link';
                                                                    }
                                                                  },
                                                                  text: getLastMessage(
                                                                          'message deleted') ??
                                                                      '@${model.displayName ?? ''}',
                                                                  style: TextStyle(
                                                                      color: CupertinoColors
                                                                          .lightBackgroundGray,
                                                                      fontStyle:
                                                                          FontStyle
                                                                              .italic),
                                                                  linkStyle: onPrimarySubTitleText
                                                                      .copyWith(
                                                                          color:
                                                                              Colors.yellow),
                                                                )
                                                              : Linkify(
                                                                  onOpen:
                                                                      (link) async {
                                                                    if (await canLaunchUrl(
                                                                        Uri.parse(
                                                                            link.url))) {
                                                                      await launchURL(
                                                                          link.url);
                                                                    } else {
                                                                      throw 'Could not launch $link';
                                                                    }
                                                                  },
                                                                  text: getLastMessage(
                                                                          TextEncryptDecrypt.decryptAES(
                                                                              lastMessage.message)) ??
                                                                      '@${model.displayName ?? ''}',
                                                                  style: TextStyle(
                                                                      color: CupertinoColors
                                                                          .darkBackgroundGray),
                                                                  linkStyle: onPrimarySubTitleText
                                                                      .copyWith(
                                                                          color:
                                                                              Colors.yellow),
                                                                )),
                                    ),
                                  ),
                                ),
                    )),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 11),
                                blurRadius: 11,
                                color: Colors.black.withOpacity(0.06))
                          ],
                          borderRadius: BorderRadius.circular(5),
                          color: CupertinoColors.darkBackgroundGray),
                      padding: const EdgeInsets.all(5.0),
                      child: Text(getWhen(lastMessage.createdAt).toString(),
                          style: const TextStyle(
                              color: CupertinoColors.lightBackgroundGray,
                              fontWeight: FontWeight.bold)),
                    ),
                    SingleChildScrollView(
                        child: Row(children: [
                      lastMessage.senderReactions == ReactionType.Love.index
                          ? Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: lastMessage.senderReactions ==
                                        ReactionType.Empty.index
                                    ? Colors.transparent
                                    : Colors.white60,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(100.0)),
                              ),
                              child: Image.asset('assets/heartlove.png',
                                  height: 12),
                            )
                          : lastMessage.senderReactions ==
                                  ReactionType.Like.index
                              ? Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: lastMessage.senderReactions ==
                                            ReactionType.Empty.index
                                        ? Colors.transparent
                                        : Colors.white60,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(100.0)),
                                  ),
                                  child: Image.asset('assets/like  (1).png',
                                      height: 12),
                                )
                              : lastMessage.senderReactions ==
                                      ReactionType.Delicious.index
                                  ? Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: lastMessage.senderReactions ==
                                                ReactionType.Empty.index
                                            ? Colors.transparent
                                            : Colors.white60,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(100.0)),
                                      ),
                                      child: Image.asset('assets/delicious.png',
                                          height: 12),
                                    )
                                  : lastMessage.senderReactions ==
                                          ReactionType.Smile.index
                                      ? Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color:
                                                lastMessage.senderReactions ==
                                                        ReactionType.Empty.index
                                                    ? Colors.transparent
                                                    : Colors.white60,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(100.0)),
                                          ),
                                          child: Image.asset('assets/happy.png',
                                              height: 12),
                                        )
                                      : lastMessage.senderReactions ==
                                              ReactionType.Sad.index
                                          ? Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: lastMessage.reactions ==
                                                        ReactionType.Empty.index
                                                    ? Colors.transparent
                                                    : Colors.white60,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(100.0)),
                                              ),
                                              child: Image.asset(
                                                  'assets/sad.png',
                                                  height: 20),
                                            )
                                          : const Text(''),
                      lastMessage.receiverReactions == ReactionType.Love.index
                          ? Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: lastMessage.receiverReactions ==
                                        ReactionType.Empty.index
                                    ? Colors.transparent
                                    : Colors.white60,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(100.0)),
                              ),
                              child: Image.asset('assets/heartlove.png',
                                  height: 20),
                            )
                          : lastMessage.receiverReactions ==
                                  ReactionType.Like.index
                              ? Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: lastMessage.receiverReactions ==
                                            ReactionType.Empty.index
                                        ? Colors.transparent
                                        : Colors.white60,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(100.0)),
                                  ),
                                  child: Image.asset('assets/like  (1).png',
                                      height: 20),
                                )
                              : lastMessage.receiverReactions ==
                                      ReactionType.Delicious.index
                                  ? Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: lastMessage.receiverReactions ==
                                                ReactionType.Empty.index
                                            ? Colors.transparent
                                            : Colors.white60,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(100.0)),
                                      ),
                                      child: Image.asset('assets/delicious.png',
                                          height: 20),
                                    )
                                  : lastMessage.receiverReactions ==
                                          ReactionType.Smile.index
                                      ? Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color:
                                                lastMessage.receiverReactions ==
                                                        ReactionType.Empty.index
                                                    ? Colors.transparent
                                                    : Colors.white60,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(100.0)),
                                          ),
                                          child: Image.asset('assets/happy.png',
                                              height: 20),
                                        )
                                      : lastMessage.receiverReactions ==
                                              ReactionType.Sad.index
                                          ? Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: lastMessage
                                                            .receiverReactions ==
                                                        ReactionType.Empty.index
                                                    ? Colors.transparent
                                                    : Colors.white60,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(100.0)),
                                              ),
                                              child: Image.asset(
                                                  'assets/sad.png',
                                                  height: 20),
                                            )
                                          : const Text(''),
                    ])),
                  ],
                )
              ],
            ),
          ),
          trailing: Container(
            width: 50,
            height: 50,
            child: CartIcon(
                sellerId: lastMessage.receiverId,
                buyerId: lastMessage.senderId,
                orderType: lastMessage.orderState,
                sellersName: model.displayName),
          ),
        ),

        //  ),
      );
    }

    Widget _body(
      BuildContext context,
      List<ChatMessage> chats,
      // RxInt msgCount,
      // var setState,
      // ValueNotifier<RxString> idState,
      // ValueNotifier<RxString> idsState
    ) {
      // final state = Provider.of<ChatState>(context, listen: false);
      // final searchState = Provider.of<SearchState>(context, listen: false);
      // final authState =  Provider.of<AuthState>(context, listen: false);

      if (chats == null || chats.isEmpty
          //  ||
          // authState.userId == null ||
          // authState.userModel?.key== null
          ) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: Get.height * 0.3,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: frostedWhite(
                  Align(
                    alignment: Alignment.topCenter,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: isTablet == true
                          ? SizedBox(
                              height: Get.height * 0.2,
                              child: const EmptyList(
                                'No message available ',
                                subTitle:
                                    'Start conversing by pressing the button at bottom right!',
                              ),
                            )
                          : SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: SizedBox(
                                height: Get.height * 0.2,
                                child: SizedBox(
                                  height: double.infinity,
                                  // width: double.infinity,
                                  child: const EmptyList(
                                    'No message available ',
                                    subTitle:
                                        'Start conversing by pressing the button at bottom right!',
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        // if (searchState.userList.isEmpty) {
        //   searchState.resetFilterList();
        // }

        return SizedBox(
          height: fullHeight(context) * 0.8,
          width: Get.width,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: chats.length,
            controller: scrollController,
            itemBuilder: (context, index) {
              double scale = 1.0;
              if (topDuct > 0.5) {
                scale = index + 0.5 - topDuct;
                if (scale < 0) {
                  scale = 0;
                } else if (scale > 1) {
                  scale = 1;
                }
              }
              ;

              return Transform(
                  transform: Matrix4.identity()..scale(scale, scale),
                  child: Container()

                  // _userCard(

                  //     // authState.profileUser,
                  //     searchState.viewUserlistChatList.firstWhere(
                  //       (x) => x.userId == chats[index].receiverId,
                  //       orElse: () => ViewductsUser(),
                  //     ),
                  //     chats[index].obs,
                  //     context,
                  //     msgCount,
                  //     setState,
                  //     idState,
                  //     idsState),
                  );
            },
            // separatorBuilder: (context, index) {
            //   return Divider();
            // },
          ),
        );
      }
    }

    _newMessageButton(BuildContext context) {
      return isCart == true
          ? Container()
          : Wrap(
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
                          color: CupertinoColors.lightBackgroundGray),
                      padding: const EdgeInsets.all(5.0),
                      child: TitleText('New Chats')),
                ),
                FloatingActionButton(
                    backgroundColor: Colors.blueGrey,
                    onPressed: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          // backgroundColor: TwitterColor.mystic,
                          //bounce: true,
                          context: context,
                          builder: (context) => Container(
                              height: fullHeight(context),
                              child: UserSearchResponsive()));
                    },
                    child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Lottie.asset(
                          'assets/lottie/chat-box-animation.json',
                        ))),
              ],
            );
    }

    // // void onSettingIconPressed() {
    // //   Navigator.pushNamed(Get.context!, '/DirectMessagesPage');
    // // }

    // // String decryptWithCRC({required String input}) {
    // //   try {
    // //     if (input.contains(CRC_SEPARATOR)) {
    // //       int idx = input.lastIndexOf(CRC_SEPARATOR);
    // //       String msgPart = input.substring(0, idx);
    // //       String crcPart = input.substring(idx + 1);
    // //       int? crc = int.tryParse(crcPart);
    // //       if (crc != null) {
    // //         msgPart =
    // //             cryptor.decrypt(encrypt.Encrypted.fromBase64(msgPart), iv: iv);
    // //         if (CRC32.compute(msgPart) == crc) return msgPart;
    // //       }
    // //     }
    // //   } on FormatException {
    // //     return '';
    // //   }
    // //   return '';
    // // }

    // // Widget getTextMessage(
    // //   Map<String, dynamic> doc,
    // // ) {
    // //   return UrlText(
    // //     text: decryptWithCRC(input: doc[CONTENT]),
    // //     style: const TextStyle(
    // //       fontSize: 16,
    // //       color: TwitterColor.white,
    // //     ),
    // //     urlStyle: const TextStyle(
    // //       fontSize: 16,
    // //       color: Colors.blueGrey,
    // //       decoration: TextDecoration.underline,
    // //     ),
    // //   );
    // // }

    Widget _getUserAvatar(BuildContext context) {
      Storage storage = Storage(clientConnect());
      Image? url;
      if (currentUser?.userProfilePic == null) {
      } else {
        storage
            .getFileView(
                bucketId: profileImageBudgetId,
                fileId: currentUser?.userProfilePic ?? '')
            .then((bytes) {
          url = Image.memory(bytes);
        });
      }
      return customInkWell(
        context: context,
        onPressed: () {
          //  chatState.setChatUser = authState.userModel;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OpenContainer(
                        closedBuilder: (context, action) {
                          return ProfileResponsiveView(
                            profileId: currentUser!.userId,
                            profileType: ProfileType.Store,
                          );
                        },
                        openBuilder: (context, action) {
                          return ProfileResponsiveView(
                            profileId: currentUser?.userId,
                            profileType: ProfileType.Store,
                          );
                        },
                      )));

          // Get.to(() => OpenContainer(
          //       closedBuilder: (context, action) {
          //         return ProfileResponsiveView(
          //           profileId: currentUser!.userId,
          //           profileType: ProfileType.Store,
          //         );
          //       },
          //       openBuilder: (context, action) {
          //         return ProfileResponsiveView(
          //           profileId: currentUser?.userId,
          //           profileType: ProfileType.Store,
          //         );
          //       },
          //     )
          //     );
        },
        child: currentUser?.userProfilePic == null
            ? Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(0, 11),
                            blurRadius: 11,
                            color: Colors.black.withOpacity(0.06))
                      ],
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: customImage(
                        context, currentUser?.profilePic ?? dummyProfilePic,
                        height: 50),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: currentUser?.isVerified == true
                        ? Material(
                            elevation: 10,
                            borderRadius: BorderRadius.circular(100),
                            child: CircleAvatar(
                              radius: 9,
                              backgroundColor: Colors.transparent,
                              child: Image.asset('assets/delicious.png'),
                            ),
                          )
                        : Container(),
                  )
                ],
              )
            : FutureBuilder(
                future: storage.getFileView(
                    bucketId: profileImageBudgetId,
                    fileId: currentUser!.userProfilePic.toString()),
                builder: (context, snap) {
                  return snap.hasData && snap.data != null || url?.image != null
                      ? Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                  image: url?.image ??
                                      customAdvanceNetworkImage(
                                          dummyProfilePic),
                                  fit: BoxFit.cover),
                              color: Colors.blueGrey[50],
                              gradient: LinearGradient(
                                colors: [
                                  Colors.yellow.withOpacity(0.1),
                                  Colors.white60.withOpacity(0.2),
                                  Colors.pink.withOpacity(0.3)
                                ],
                                // begin: Alignment.topCenter,
                                // end: Alignment.bottomCenter,
                              )),
                        )
                      : SizedBox();
                }),
      );
    }

    // // Rx<String?>? state;

    // // deviceState() async {
    // //   String? platForm;
    // //   try {
    // //     platForm = await FlutterSimCountryCode.simCountryCode;
    // //   } on PlatformException {
    // //     platForm = 'failed to get sim country code';
    // //   }
    // //   return state = platForm.obs;
    // // }

    // useEffect(
    //   () {
    //     animationController.forward();
    //     // FirebaseMessaging.onMessageOpenedApp
    //     //     .listen((RemoteMessage message) async {
    //     //   // if (message.data["messageType"] == "chat") {
    //     //   cprint("onMessageOpenedApp}");
    //     //   // return await Get.to(() => ChatResponsive(
    //     //   //       userProfileId: message.data['senderId'],
    //     //   //     ));
    //     //   // // } else {}
    //     // });

    //     //  FirebaseMessaging.onMessage.listen(showFlutterNotification);

    //     // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //     //   print('A new onMessageOpenedApp event was published!');
    //     //   Get.to(() => ChatResponsive(
    //     //         userProfileId: message.senderId,
    //     //       ));
    //     // });
    //     allChatMessage();
    //     msCountStreaming;
    //     subStreaming;
    //     msCountsStreaming;

    //     return () {
    //       subscription?.close;
    //     };
    //   },
    //   [chatState.msgCount, chatState.chatUserList],
    // );

    return KeyboardDismisser(
      gestures: const [
        GestureType.onTap,
        GestureType.onPanUpdateUpDirection,
      ],
      child: Scaffold(
          floatingActionButton: _newMessageButton(context),
          // backgroundColor: ThemeMode.system == ThemeMode.light
          //     ? TwitterColor.mystic
          //     : bgColor,
          body: SafeArea(
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                // Note: Sensitivity is integer used when you don't want to mess up vertical drag
                int sensitivity = 8;
                if (details.delta.dx > sensitivity) {
                  // Right Swipe
                  if (ref.read(numberProvider.notifier).state == 0) {
                    ref.read(numberProvider.notifier).state = 4;
                  }
                } else if (details.delta.dx < -sensitivity) {
                  if (ref.read(numberProvider.notifier).state == 0) {
                    ref.read(numberProvider.notifier).state = 1;
                  }

                  //Left Swipe
                }
              },
              child: Stack(
                children: [
                  ThemeMode.system == ThemeMode.light
                      ? frostedYellow(
                          Container(
                            height: appSize.height,
                            width: appSize.width,
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
                  // Container(
                  //   height: fullHeight(context),
                  //   width: fullWidth(context),
                  //   decoration: const BoxDecoration(
                  //       image: DecorationImage(
                  //           image: AssetImage('assets/africa.png'))),
                  // ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                    child: Container(
                      color: (Colors.white12).withOpacity(0.1),
                    ),
                  ),
                  Positioned(
                      top: 60,
                      right: isDesktop == true
                          ? 0
                          : isTablet == true
                              ? 0
                              : appSize.width * 0.15,
                      left: 10,
                      child: SizedBox(
                        height: fullHeight(context),
                        width: Get.width,
                        child: PageView(
                          children: [
                            SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              child: Container(
                                height: fullHeight(context),
                                width: Get.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DateFormat("E").format(DateTime.now()) ==
                                            'Sun'
                                        ? Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                          offset: const Offset(
                                                              0, 11),
                                                          blurRadius: 11,
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.06))
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18),
                                                    color: CupertinoColors
                                                        .systemRed),
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: TitleText(
                                                  'Business is close for the week',
                                                  color: CupertinoColors
                                                      .lightBackgroundGray,
                                                )),
                                          )
                                        : Container(),
                                    Material(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.transparent,
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 3),
                                                child: customText(
                                                  isCart == true
                                                      ? "Cart".tr
                                                      : 'Messages'.tr,
                                                  style: const TextStyle(
                                                      // color: Colors.black45,

                                                      fontSize: 35,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            // Obx(
                                            //   () => kIsWeb
                                            //       ? Container()
                                            //       : authState.networkConnectionState
                                            //                    ==
                                            //               'Not Connected'
                                            //           ? Container(
                                            //               decoration: BoxDecoration(
                                            //                   color:
                                            //                       darkBackground,
                                            //                   borderRadius:
                                            //                       BorderRadius
                                            //                           .circular(
                                            //                               10)),
                                            //               width: context.responsiveValue(
                                            //                   mobile:
                                            //                       Get.height *
                                            //                           0.25,
                                            //                   tablet:
                                            //                       Get.height *
                                            //                           0.25,
                                            //                   desktop:
                                            //                       Get.height *
                                            //                           0.25),
                                            //               child:
                                            //                   SingleChildScrollView(
                                            //                       child:
                                            //                           Padding(
                                            //                 padding:
                                            //                     const EdgeInsets
                                            //                         .all(3.0),
                                            //                 child: Row(
                                            //                   mainAxisAlignment:
                                            //                       MainAxisAlignment
                                            //                           .start,
                                            //                   crossAxisAlignment:
                                            //                       CrossAxisAlignment
                                            //                           .start,
                                            //                   children: [
                                            //                     Icon(
                                            //                         color:
                                            //                             darkAccent,
                                            //                         CupertinoIcons
                                            //                             .wifi_slash),
                                            //                     Padding(
                                            //                       padding:
                                            //                           const EdgeInsets.all(
                                            //                               3.0),
                                            //                       child: Text(
                                            //                           'You\'re Offline',
                                            //                           style: TextStyle(
                                            //                               color: Colors
                                            //                                   .redAccent,
                                            //                               fontSize: context.responsiveValue(
                                            //                                   mobile: Get.height * 0.025,
                                            //                                   tablet: Get.height * 0.025,
                                            //                                   desktop: Get.height * 0.025),
                                            //                               fontWeight: FontWeight.w100)),
                                            //                     ),
                                            //                   ],
                                            //                 ),
                                            //               )),
                                            //             )
                                            //           : SizedBox(),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Divider(),

                                    ref
                                        .watch(currentChatListDetailsProvider)
                                        .when(
                                          data: (chatList) {
                                            return ref
                                                .watch(
                                                    getLatestChatListProvider)
                                                .when(
                                                  data: (data) {
                                                    if (data.events.contains(
                                                      'databases.*.collections.${AppwriteConstants.chatsColl}.documents.*.create',
                                                    )) {
                                                      chatList.insert(
                                                          0,
                                                          ChatMessage.fromJson(
                                                              data.payload));
                                                    } else if (data.events
                                                        .contains(
                                                      'databases.*.collections.${AppwriteConstants.chatsColl}.documents.*.delete',
                                                    )) {
                                                      chatList.remove(
                                                          ChatMessage.fromJson(
                                                              data.payload));
                                                    } else if (data.events
                                                        .contains(
                                                      'databases.*.collections.${AppwriteConstants.chatsColl}.documents.*.update',
                                                    )) {
                                                      // get id of original chatListMessage
                                                      final startingPoint = data
                                                          .events[0]
                                                          .lastIndexOf(
                                                              'documents.');
                                                      final endPoint = data
                                                          .events[0]
                                                          .lastIndexOf(
                                                              '.update');
                                                      final chatListId = data
                                                          .events[0]
                                                          .substring(
                                                              startingPoint +
                                                                  10,
                                                              endPoint);

                                                      var chatListMessage =
                                                          chatList.firstWhere(
                                                              (element) =>
                                                                  element.key ==
                                                                  chatListId,
                                                              orElse: () =>
                                                                  ChatMessage());

                                                      // final chatListIndex =
                                                      //     chatList.indexOf(
                                                      //         chatListMessage);
                                                      chatList.removeWhere(
                                                          (element) =>
                                                              element.key ==
                                                              chatListId);

                                                      chatListMessage =
                                                          ChatMessage.fromJson(
                                                              data.payload);
                                                      chatList.insert(
                                                          0, chatListMessage);
                                                    }

                                                    return Expanded(
                                                      child: ListView.builder(
                                                        itemCount:
                                                            chatList.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          final chatMessage =
                                                              chatList[index];
                                                          var chatUser = ref
                                                              .watch(userDetailsProvider(
                                                                  chatMessage
                                                                      .receiverId
                                                                      .toString()))
                                                              .value;

                                                          return chatList
                                                                      .isEmpty ||
                                                                  chatList ==
                                                                      null
                                                              ? Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          30),
                                                                  child:
                                                                      frostedWhite(
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .topCenter,
                                                                      child:
                                                                          SingleChildScrollView(
                                                                        scrollDirection:
                                                                            Axis.vertical,
                                                                        child: isTablet ==
                                                                                true
                                                                            ? SizedBox(
                                                                                height: Get.height * 0.2,
                                                                                child: const EmptyList(
                                                                                  'No message available ',
                                                                                  subTitle: 'Start conversing by pressing the button at bottom right!',
                                                                                ),
                                                                              )
                                                                            : SingleChildScrollView(
                                                                                scrollDirection: Axis.vertical,
                                                                                child: SizedBox(
                                                                                  height: Get.height * 0.2,
                                                                                  child: SizedBox(
                                                                                    height: double.infinity,
                                                                                    // width: double.infinity,
                                                                                    child: const EmptyList(
                                                                                      'No message available ',
                                                                                      subTitle: 'Start conversing by pressing the button at bottom right!',
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              : _userCard(
                                                                  chatUser ??
                                                                      ViewductsUser(),
                                                                  chatMessage,
                                                                  context,
                                                                  1.obs);
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  error: (error, stackTrace) =>
                                                      ErrorText(
                                                    error: error.toString(),
                                                  ),
                                                  loading: () {
                                                    return Expanded(
                                                      child: ListView.builder(
                                                        itemCount:
                                                            chatList.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          final chatMessage =
                                                              chatList[index];
                                                          final chatUser = ref
                                                              .watch(userDetailsProvider(
                                                                  chatMessage
                                                                      .receiverId
                                                                      .toString()))
                                                              .value;
                                                          return chatList
                                                                      .isEmpty ||
                                                                  chatList ==
                                                                      null
                                                              ? Center(
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      SizedBox(
                                                                        height: Get.height *
                                                                            0.3,
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(horizontal: 30),
                                                                        child:
                                                                            frostedWhite(
                                                                          Align(
                                                                            alignment:
                                                                                Alignment.topCenter,
                                                                            child:
                                                                                SingleChildScrollView(
                                                                              scrollDirection: Axis.vertical,
                                                                              child: isTablet == true
                                                                                  ? SizedBox(
                                                                                      height: Get.height * 0.2,
                                                                                      child: const EmptyList(
                                                                                        'No message available ',
                                                                                        subTitle: 'Start conversing by pressing the button at bottom right!',
                                                                                      ),
                                                                                    )
                                                                                  : SingleChildScrollView(
                                                                                      scrollDirection: Axis.vertical,
                                                                                      child: SizedBox(
                                                                                        height: Get.height * 0.2,
                                                                                        child: SizedBox(
                                                                                          height: double.infinity,
                                                                                          // width: double.infinity,
                                                                                          child: const EmptyList(
                                                                                            'No message available ',
                                                                                            subTitle: 'Start conversing by pressing the button at bottom right!',
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              : _userCard(
                                                                  chatUser ??
                                                                      ViewductsUser(),
                                                                  chatMessage,
                                                                  context,
                                                                  1.obs);
                                                        },
                                                      ),
                                                    );
                                                  },
                                                );
                                          },
                                          error: (error, stackTrace) =>
                                              ErrorText(
                                            error: error.toString(),
                                          ),
                                          loading: () =>
                                              const ChatLoadingPage(),
                                        ),

                                    // _body(context, [ChatMessage()]
                                    // chatSetState,
                                    // messageCountState,
                                    // setState(),
                                    // idState,
                                    // idsState
                                    //  ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Row(
                      children: [
                        isCart == true
                            ? IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                //color: Colors.black,
                                icon: const Icon(CupertinoIcons.back),
                              )
                            : Container(),
                        frostedOrange(
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.blueGrey[50],
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.yellow.withOpacity(0.1),
                                    Colors.white60.withOpacity(0.2),
                                    Colors.grey.withOpacity(0.3)
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
                      ],
                    ),
                  ),
                  isDesktop == true || isTablet == true
                      ? Container()
                      // : authState.appUser?.name == null
                      //     ? Container()
                      : Positioned(
                          top: 10,
                          right: 10,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          offset: const Offset(0, 11),
                                          blurRadius: 11,
                                          color: Colors.black.withOpacity(0.06))
                                    ],
                                    borderRadius: BorderRadius.circular(100),
                                    color: CupertinoColors.lightBackgroundGray),
                                padding: const EdgeInsets.all(5.0),
                                child: _getUserAvatar(context),
                              ),
                              const SizedBox(height: 10),
                              // Obx(() => customText(
                              //       greetings(),
                              //       style: TextStyle(
                              //           color: Colors.blueGrey[200],
                              //           fontSize: 20,
                              //           fontWeight: FontWeight.bold),
                              //     ))
                            ],
                          ),
                        ),
                  Positioned(
                    top: Get.height * 0.01,
                    // left: appSize.width * 0.7,
                    right: fullWidth(context) * 0.4,
                    child: Row(
                      children: <Widget>[
                        // isCart == true
                        //     ? Container()
                        //     : AdminNotificationForUsers()
                      ],
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      left: 5,
                      right: 50,
                      child: DateFormat("E").format(DateTime.now()) == 'Sun'
                          ? bible.body == null
                              ? Container()
                              : GestureDetector(
                                  onTap: () {
                                    _bibleTips(context);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: darkBackground,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    width: context.responsiveValue(
                                        mobile: Get.height * 0.32,
                                        tablet: Get.height * 0.45,
                                        desktop: Get.height * 0.45),
                                    child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Wrap(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                        offset:
                                                            const Offset(0, 11),
                                                        blurRadius: 11,
                                                        color: Colors.black
                                                            .withOpacity(0.06))
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: CupertinoColors
                                                      .systemYellow),
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                'Sunday:',
                                                style: TextStyle(
                                                    color: CupertinoColors
                                                        .darkBackgroundGray),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                  '${getLastMessage(bible.body)}'
                                                      .tr,
                                                  style: TextStyle(
                                                      color: darkAccent,
                                                      fontSize:
                                                          context.responsiveValue(
                                                              mobile:
                                                                  Get.height *
                                                                      0.025,
                                                              tablet:
                                                                  Get.height *
                                                                      0.025,
                                                              desktop:
                                                                  Get.height *
                                                                      0.025),
                                                      fontWeight:
                                                          FontWeight.w100)),
                                            ),
                                          ],
                                        )),
                                  ),
                                )
                          : Container())
                ],
              ),
            ),
          )),
    );
  }
}

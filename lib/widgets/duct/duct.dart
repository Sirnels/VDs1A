// ignore_for_file: use_key_in_widget_constructors, prefer_typing_uninitialized_variables, unused_element, deprecated_member_use

import 'dart:convert';
import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:appwrite/appwrite.dart' as query;
//import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
//import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:viewducts/helper/constant.dart';
import 'package:viewducts/helper/enum.dart';
import 'package:viewducts/helper/theme.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';

import 'package:viewducts/page/message/chatScreenPage.dart';
import 'package:viewducts/page/product/shopingCart.dart';
import 'package:viewducts/page/responsiveView.dart';

import 'package:viewducts/state/feedState.dart';
import 'package:viewducts/state/authState.dart';

import 'package:viewducts/state/stateController.dart';

import 'package:viewducts/widgets/duct/ductStoryPage.dart';
import 'package:viewducts/widgets/duct/widgets/ductIconsRow.dart';
import 'package:viewducts/widgets/duct/widgets/ductImage.dart';
import 'package:viewducts/widgets/frosted.dart';
import 'package:viewducts/widgets/newWidget/customUrlText.dart';
import 'package:viewducts/widgets/newWidget/title_text.dart';
import '../customWidgets.dart';

// ignore: must_be_immutable
class Duct extends HookWidget {
  final FeedModel? model;
  final Widget? trailing;
  final RxList<FeedModel>? commissionProduct;
  final DuctType type;
  final bool isDisplayOnProfile;
  final bool? isDeskLeft;
  //final RxList<DuctStoryModel>? storylist;
  Duct(
      {Key? key,
      //this.storylist,
      this.commissionProduct,
      this.model,
      this.imageAspectRatio = 33 / 49,
      this.trailing,
      this.isDeskLeft,
      this.type = DuctType.Duct,
      this.isDisplayOnProfile = false})
      : assert(imageAspectRatio > 0);
  static const double kTextBoxHeight = 65.0;
  final double imageAspectRatio;

//   @override
//   _DuctState createState() => _DuctState();
// }

// class _DuctState extends State<Duct> {
  String? ductId;
  Rx<ViewductsUser>? user;
  bool isDropdown = false;
  double? height, width, xPosiion, yPosition;
  OverlayEntry? floatingMenu;

  bool typing = false;

  String? senderId;

  String? userImage;

  bool? isContinuing;

  FocusNode textFieldFocus = FocusNode();

  FocusNode imageTextFieldFocus = FocusNode();

  ValueNotifier<bool> isSelected = ValueNotifier(false);

  String? chatUserProductId, myOrders;

  String? peerAvatar, peerNo, currentUserNo, privateKey, sharedSecret;

  bool? locked, hidden;

  int? chatStatus, unread;

  GlobalKey? actionKey;

  dynamic lastSeen;

  String? chatId;

  var isWriting = false.obs;

  var showEmojiPicker = false.obs;

  File? imageFile;

  bool? isLoading;
  String? postId;
  String? imageUrl;
  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController imageTextEditingController =
      TextEditingController();
  ViewductsUser? viewductsUser;
  final ScrollController realtime = ScrollController();
  final ScrollController saved = ScrollController();
  var quantity = 1.obs;
  RxString sizeValue = "".obs;
  String colorValue = "";
  bool? editProduct;
  String? image, name;
  String? selectedColor;
  var itemDetails;
  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ValueNotifier<bool> imageNotready = ValueNotifier(false);
  bool isToolAvailable = true;
  bool isMyProfile = false;
  late VideoPlayerController _videoController;
  final GlobalKey<State> keyLoader = GlobalKey<State>();
  List<dynamic>? size;
  FeedState? productState;

  Future<void>? _initializeVideoplayerfuture;
  var playstate;

  setQuantity(String type) {
    if (type == 'inc') {
      if (quantity.value != 5) {
        quantity.value = quantity.value + 1;
      }
    } else {
      if (quantity.value != 1) {
        quantity.value = quantity.value - 1;
      }
    }
  }

  showKeyboard() => textFieldFocus.requestFocus();

  hideKeyboard() => textFieldFocus.unfocus();

  hideEmojiContainer() {
    showEmojiPicker = false.obs;
  }

  showEmojiContainer() {
    showEmojiPicker = true.obs;
  }

  void onLongPressedTweet(BuildContext context) {
    if (type == DuctType.Detail || type == DuctType.ParentDuct) {
      var text = ClipboardData(text: model!.ductComment);
      Clipboard.setData(text);
      Get.snackbar('Text', 'Duct copied to clipboard');
      // Scaffold.of(context).showSnackBar(
      //   SnackBar(
      //     backgroundColor: TwitterColor.black,
      //     content: Text(
      //       'Duct copied to clipboard',
      //     ),
      //   ),
      // );
    }
  }

  void _opTions(BuildContext context, FeedState state) async {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        //var appSize = MediaQuery.of(context).size;

        // double heightFactor = 300 / fullHeight(context);
        // var authState = Provider.of<AuthState>(context, listen: false);
        // var state = Provider.of<FeedState>(context, listen: false);
        //  ViewductsUser model;
        return frostedOrange(
          Container(
            padding: const EdgeInsets.only(top: 5, bottom: 0),
            height: fullHeight(context) * 0.8,
            // (type == TweetType.Tweet
            //     ? (isMyTweet ? .25 : .44)
            //     : (isMyTweet ? .38 : .52)),
            width: fullWidth(context),
            decoration: const BoxDecoration(
                // color: Theme.of(context).bottomSheetTheme.backgroundColor,
                // borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(20),
                //   topRight: Radius.circular(20),
                // ),
                ),
            child: Stack(
              children: [
                Material(
                  color: Colors.transparent,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: SizedBox(
                      width: fullWidth(context),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Stack(
                            children: [
                              SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: fullWidth(context),
                                        //height: fullHeight(context),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Material(
                                                    elevation: 10,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: SizedBox(
                                                      width:
                                                          fullWidth(context) *
                                                              0.4,
                                                      height:
                                                          fullWidth(context) *
                                                              0.4,
                                                      //decoration: BoxDecoration(),
                                                      child: AspectRatio(
                                                          aspectRatio: 4 / 3,
                                                          child:
                                                              customNetworkImage(
                                                                  model!
                                                                      .imagePath,
                                                                  fit: BoxFit
                                                                      .contain)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Divider(),
                                              Row(
                                                children: [
                                                  customText(
                                                    model!.productName,
                                                    style: const TextStyle(
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              const Divider(),
                                              Row(
                                                children: [
                                                  customText(
                                                    'Qauntity : ',
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      GestureDetector(
                                                        onTap: () {
                                                          setQuantity('dec');
                                                        },
                                                        child: const Icon(
                                                          CupertinoIcons
                                                              .minus_circled,
                                                          size: 30,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 8),
                                                        child: Obx(
                                                          () => Text(
                                                              '${quantity.value}',
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          setQuantity('inc');
                                                        },
                                                        child: const Icon(
                                                          CupertinoIcons
                                                              .add_circled_solid,
                                                          size: 30,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const Divider(),
                                              Row(
                                                children: [
                                                  customText(
                                                    'Brand: ',
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  customText(
                                                    model!.brand,
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white),
                                                  )
                                                ],
                                              ),
                                              const Divider(),
                                              Row(
                                                children: [
                                                  customText(
                                                    'location: ',
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  customText(
                                                    model!.productLocation,
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white),
                                                  )
                                                ],
                                              ),
                                              const Divider(),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: fullWidth(context) *
                                                        0.9,
                                                    child: Column(
                                                      children: [
                                                        customText(
                                                          'Description:',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: Colors
                                                                      .red),
                                                        ),
                                                        customText(
                                                          model!
                                                              .productDescription,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 20,
                                                                  color: Colors
                                                                      .white),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 100,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: fullWidth(context) * 0.05,
                  right: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () async {
                            await addToShoppingBag(state, authState);
                            Navigator.maybePop(context);
                            // .then((value) {
                            //   Navigator.of(context).pop();
                            // });
                          },
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await addToShoppingBag(state, authState);
                                  Navigator.of(context).pop();
                                  // Navigator.maybePop(context).then((value) {

                                  // });
                                },
                                child: const Icon(
                                  CupertinoIcons.add_circled_solid,
                                  size: 30,
                                ),
                              ),
                              Container(
                                width: fullWidth(context) * 0.2,
                                height: fullWidth(context) * 0.08,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blueGrey[50],
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black87.withOpacity(0.1),
                                      Colors.black87.withOpacity(0.2),
                                      Colors.black87.withOpacity(0.3)
                                      // Color(0xfffbfbfb),
                                      // Color(0xfff7f7f7),
                                    ],
                                    // begin: Alignment.topCenter,
                                    // end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: customText(
                                  'Cart',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () async {
                            await addToShoppingBag(state, authState);
                            Navigator.of(context).pop();
                            Get.to(() => ShoppingCart());

                            // Navigator.maybePop(context).then((value) {
                            //   //Navigator.of(context).pop();
                            //   Navigator.of(context).push(
                            //     MaterialPageRoute(
                            //       builder: (context) => ShoppingCart(),
                            //     ),
                            //   );
                            // });
                          },
                          child: Container(
                            width: fullWidth(context) * 0.2,
                            height: fullWidth(context) * 0.08,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.blueGrey[50],
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black87.withOpacity(0.1),
                                  Colors.black87.withOpacity(0.2),
                                  Colors.black87.withOpacity(0.3)
                                  // Color(0xfffbfbfb),
                                  // Color(0xfff7f7f7),
                                ],
                                // begin: Alignment.topCenter,
                                // end: Alignment.bottomCenter,
                              ),
                            ),
                            child: customText(
                              'Buy',
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () async {
                            //await Navigator.maybePop(context);

                            // final chatState =
                            //     Provider.of<ChatState>(context, listen: false);
                            // final authState =
                            //     Provider.of<AuthState>(context, listen: false);
                            // final searchState = Provider.of<SearchState>(
                            //     context,
                            //     listen: false);
                            //chatState.setChatUser = model;

                            if (searchState.userlist!.any((x) =>
                                x.userId ==
                                state.ductDetailModel!.last!.userId)) {
                              chatState.setChatUser = searchState.userlist!
                                  .where((x) =>
                                      x.userId ==
                                      state.ductDetailModel!.last!.userId)
                                  .first;
                            }

                            // if (authState.userModel!.locked != null &&
                            //     authState.userModel!.locked!
                            //         .contains(chatState.chatUser!.userId)) {
                            //   // ChatControl.authenticate(
                            //   //     authState, 'Authentication needed to unlock the chat.',
                            //   //     state: state,
                            //   //     shouldPop: false,
                            //   //     type: ViewDucts.getAuthenticationType(
                            //   //         biometricEnabled, authState),
                            //   //     prefs: prefs, onSuccess: () {
                            //   //   cprint('security working');
                            //   //   // state.pushReplacement(new MaterialPageRoute(
                            //   //   //     builder: (context) => new ChatScreen(
                            //   //   //         unread: unread,
                            //   //   //         model: _cachedModel,
                            //   //   //         currentUserNo: currentUserNo,
                            //   //   //         peerNo: user[PHONE] as String)));
                            //   //   chatState.onLine(authState.userModel.userId);
                            //   //   Navigator.pushNamed(context, '/ChatScreenPage');
                            //   // });
                            // } else
                            {
                              Navigator.of(context).pop();
                              Get.to(() => ChatScreenPage());
                            }
                          },
                          child: Row(
                            children: [
                              // GestureDetector(
                              //   onTap: () async {
                              //     // await Navigator.maybePop(context);

                              //     final chatState = Provider.of<ChatState>(
                              //         context,
                              //         listen: false);
                              //     final authState = Provider.of<AuthState>(
                              //         context,
                              //         listen: false);
                              //     final searchState = Provider.of<SearchState>(
                              //         context,
                              //         listen: false);
                              //     //chatState.setChatUser = model;
                              //     chatState.onLine(authState.userModel.userId);
                              //     if (searchState.userlist.any((x) =>
                              //         x.userId ==
                              //         state.ductDetailModel.last.userId)) {
                              //       chatState.setChatUser = searchState.userlist
                              //           .where((x) =>
                              //               x.userId ==
                              //               state.ductDetailModel.last.userId)
                              //           .first;
                              //     }

                              //     if (authState.userModel.locked != null &&
                              //         authState.userModel.locked.contains(
                              //             chatState.chatUser.userId)) {
                              //       NavigatorState state =
                              //           Navigator.of(context);
                              //       // ChatControl.authenticate(
                              //       //     authState, 'Authentication needed to unlock the chat.',
                              //       //     state: state,
                              //       //     shouldPop: false,
                              //       //     type: ViewDucts.getAuthenticationType(
                              //       //         biometricEnabled, authState),
                              //       //     prefs: prefs, onSuccess: () {
                              //       //   cprint('security working');
                              //       //   // state.pushReplacement(new MaterialPageRoute(
                              //       //   //     builder: (context) => new ChatScreen(
                              //       //   //         unread: unread,
                              //       //   //         model: _cachedModel,
                              //       //   //         currentUserNo: currentUserNo,
                              //       //   //         peerNo: user[PHONE] as String)));
                              //       //   chatState.onLine(authState.userModel.userId);
                              //       //   Navigator.pushNamed(context, '/ChatScreenPage');
                              //       // });
                              //     } else {
                              //       chatState
                              //           .onLine(authState.userModel.userId);
                              //       Navigator.of(context).pop();
                              //       Navigator.pushNamed(
                              //           context, '/ChatScreenPage');
                              //     }
                              //   },
                              //   child: CircleAvatar(
                              //     radius: 15,
                              //     backgroundColor: Colors.transparent,
                              //     child: Image.asset('assets/chatchat.png'),
                              //   ),
                              // ),
                              Container(
                                width: fullWidth(context) * 0.2,
                                height: fullWidth(context) * 0.08,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blueGrey[50],
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black87.withOpacity(0.1),
                                      Colors.black87.withOpacity(0.2),
                                      Colors.black87.withOpacity(0.3)
                                      // Color(0xfffbfbfb),
                                      // Color(0xfff7f7f7),
                                    ],
                                    // begin: Alignment.topCenter,
                                    // end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: customText(
                                  'Chat',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.amber),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _vCommisionProduct(
    BuildContext context,
    List<FeedModel> commissionProduct,
  ) async {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        // var appSize = MediaQuery.of(context).size;

        // double heightFactor = 300 / fullHeight(context);
        // var authState = Provider.of<AuthState>(context, listen: false);
        // var state = Provider.of<FeedState>(context, listen: false);
        // final List<FeedModel> commissionProduct = state.commissionProducts(
        //     authState.userModel, model.cProduct);
        //ViewductsUser model;
        return frostedOrange(
          Container(
            padding: const EdgeInsets.only(top: 5, bottom: 0),
            height: fullHeight(context) * 0.8,
            // (type == TweetType.Tweet
            //     ? (isMyTweet ? .25 : .44)
            //     : (isMyTweet ? .38 : .52)),
            width: fullWidth(context),
            decoration: const BoxDecoration(
                // color: Theme.of(context).bottomSheetTheme.backgroundColor,
                // borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(20),
                //   topRight: Radius.circular(20),
                // ),
                ),
            child: Stack(
              children: [
                Material(
                  color: Colors.transparent,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: SizedBox(
                      width: fullWidth(context),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Stack(
                            children: [
                              SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: fullWidth(context),
                                        //height: fullHeight(context),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Material(
                                                    elevation: 10,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: SizedBox(
                                                      width:
                                                          fullWidth(context) *
                                                              0.4,
                                                      height:
                                                          fullWidth(context) *
                                                              0.4,
                                                      //decoration: BoxDecoration(),
                                                      child: AspectRatio(
                                                          aspectRatio: 4 / 3,
                                                          child: customNetworkImage(
                                                              commissionProduct
                                                                  .last
                                                                  .imagePath,
                                                              fit: BoxFit
                                                                  .contain)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Divider(),
                                              Row(
                                                children: [
                                                  customText(
                                                    commissionProduct
                                                        .last.productName,
                                                    style: const TextStyle(
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              const Divider(),
                                              Row(
                                                children: [
                                                  customText(
                                                    'Qauntity : ',
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      GestureDetector(
                                                        onTap: () {
                                                          setQuantity('dec');
                                                        },
                                                        child: const Icon(
                                                          CupertinoIcons
                                                              .minus_circled,
                                                          size: 30,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 8),
                                                        child: Obx(
                                                          () => Text(
                                                              '${quantity.value}',
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          setQuantity('inc');
                                                        },
                                                        child: const Icon(
                                                          CupertinoIcons
                                                              .add_circled_solid,
                                                          size: 30,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              const Divider(),
                                              Row(
                                                children: [
                                                  customText(
                                                    'Brand: ',
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  customText(
                                                    commissionProduct
                                                        .last.brand,
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white),
                                                  )
                                                ],
                                              ),
                                              const Divider(),
                                              Row(
                                                children: [
                                                  customText(
                                                    'location: ',
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                  customText(
                                                    commissionProduct
                                                        .last.productLocation,
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        color: Colors.white),
                                                  )
                                                ],
                                              ),
                                              const Divider(),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: fullWidth(context) *
                                                        0.9,
                                                    child: Column(
                                                      children: [
                                                        customText(
                                                          'Description:',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: Colors
                                                                      .red),
                                                        ),
                                                        customText(
                                                          commissionProduct.last
                                                              .productDescription,
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 20,
                                                                  color: Colors
                                                                      .white),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 100,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: fullWidth(context) * 0.05,
                  right: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () async {
                            await addToShoppingBag(feedState, authState);
                            Navigator.maybePop(context);
                            // .then((value) {
                            //   Navigator.of(context).pop();
                            // });
                          },
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await addToShoppingBag(feedState, authState);
                                  Navigator.of(context).pop();
                                  // Navigator.maybePop(context).then((value) {

                                  // });
                                },
                                child: const Icon(
                                  CupertinoIcons.add_circled_solid,
                                  size: 30,
                                ),
                              ),
                              Container(
                                width: fullWidth(context) * 0.2,
                                height: fullWidth(context) * 0.08,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blueGrey[50],
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black87.withOpacity(0.1),
                                      Colors.black87.withOpacity(0.2),
                                      Colors.black87.withOpacity(0.3)
                                      // Color(0xfffbfbfb),
                                      // Color(0xfff7f7f7),
                                    ],
                                    // begin: Alignment.topCenter,
                                    // end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: customText(
                                  'Cart',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () async {
                            await addToShoppingBag(feedState, authState);
                            Navigator.of(context).pop();
                            Get.to(() => ShoppingCart());

                            // Navigator.maybePop(context).then((value) {
                            //   //   Navigator.of(context).pop();
                            //   // }).then((value) {

                            // });
                          },
                          child: Container(
                            width: fullWidth(context) * 0.2,
                            height: fullWidth(context) * 0.08,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.blueGrey[50],
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black87.withOpacity(0.1),
                                  Colors.black87.withOpacity(0.2),
                                  Colors.black87.withOpacity(0.3)
                                  // Color(0xfffbfbfb),
                                  // Color(0xfff7f7f7),
                                ],
                                // begin: Alignment.topCenter,
                                // end: Alignment.bottomCenter,
                              ),
                            ),
                            child: customText(
                              'Buy',
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () async {
                            //await Navigator.maybePop(context);

                            // final chatState =
                            //     Provider.of<ChatState>(context, listen: false);
                            // final authState =
                            //     Provider.of<AuthState>(context, listen: false);
                            // final searchState = Provider.of<SearchState>(
                            //     context,
                            //     listen: false);
                            //chatState.setChatUser = model;

                            if (searchState.userlist!.any((x) =>
                                x.userId ==
                                feedState.ductDetailModel!.last!.userId)) {
                              chatState.setChatUser = searchState.userlist!
                                  .where((x) =>
                                      x.userId ==
                                      feedState.ductDetailModel!.last!.userId)
                                  .first;
                            }

                            // if (authState.userModel!.locked != null &&
                            //     authState.userModel!.locked!
                            //         .contains(chatState.chatUser!.userId)) {
                            //   // ChatControl.authenticate(
                            //   //     authState, 'Authentication needed to unlock the chat.',
                            //   //     state: state,
                            //   //     shouldPop: false,
                            //   //     type: ViewDucts.getAuthenticationType(
                            //   //         biometricEnabled, authState),
                            //   //     prefs: prefs, onSuccess: () {
                            //   //   cprint('security working');
                            //   //   // state.pushReplacement(new MaterialPageRoute(
                            //   //   //     builder: (context) => new ChatScreen(
                            //   //   //         unread: unread,
                            //   //   //         model: _cachedModel,
                            //   //   //         currentUserNo: currentUserNo,
                            //   //   //         peerNo: user[PHONE] as String)));
                            //   //   chatState.onLine(authState.userModel.userId);
                            //   //   Navigator.pushNamed(context, '/ChatScreenPage');
                            //   // });
                            // } else
                            {
                              //Navigator.of(context).pop();
                              Get.to(ChatScreenPage());
                              //Navigator.pushNamed(context, '/ChatScreenPage');
                            }
                          },
                          child: Row(
                            children: [
                              // GestureDetector(
                              //   onTap: () async {
                              //     // await Navigator.maybePop(context);

                              //     final chatState = Provider.of<ChatState>(
                              //         context,
                              //         listen: false);
                              //     final authState = Provider.of<AuthState>(
                              //         context,
                              //         listen: false);
                              //     final searchState = Provider.of<SearchState>(
                              //         context,
                              //         listen: false);
                              //     //chatState.setChatUser = model;
                              //     chatState.onLine(authState.userModel.userId);
                              //     if (searchState.userlist.any((x) =>
                              //         x.userId ==
                              //         state.ductDetailModel.last.userId)) {
                              //       chatState.setChatUser = searchState.userlist
                              //           .where((x) =>
                              //               x.userId ==
                              //               state.ductDetailModel.last.userId)
                              //           .first;
                              //     }

                              //     if (authState.userModel.locked != null &&
                              //         authState.userModel.locked.contains(
                              //             chatState.chatUser.userId)) {
                              //       NavigatorState state =
                              //           Navigator.of(context);
                              //       // ChatControl.authenticate(
                              //       //     authState, 'Authentication needed to unlock the chat.',
                              //       //     state: state,
                              //       //     shouldPop: false,
                              //       //     type: ViewDucts.getAuthenticationType(
                              //       //         biometricEnabled, authState),
                              //       //     prefs: prefs, onSuccess: () {
                              //       //   cprint('security working');
                              //       //   // state.pushReplacement(new MaterialPageRoute(
                              //       //   //     builder: (context) => new ChatScreen(
                              //       //   //         unread: unread,
                              //       //   //         model: _cachedModel,
                              //       //   //         currentUserNo: currentUserNo,
                              //       //   //         peerNo: user[PHONE] as String)));
                              //       //   chatState.onLine(authState.userModel.userId);
                              //       //   Navigator.pushNamed(context, '/ChatScreenPage');
                              //       // });
                              //     } else {
                              //       chatState
                              //           .onLine(authState.userModel.userId);
                              //       Navigator.of(context).pop();
                              //       Navigator.pushNamed(
                              //           context, '/ChatScreenPage');
                              //     }
                              //   },
                              //   child: CircleAvatar(
                              //     radius: 15,
                              //     backgroundColor: Colors.transparent,
                              //     child: Image.asset('assets/chatchat.png'),
                              //   ),
                              // ),
                              Container(
                                width: fullWidth(context) * 0.2,
                                height: fullWidth(context) * 0.08,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blueGrey[50],
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black87.withOpacity(0.1),
                                      Colors.black87.withOpacity(0.2),
                                      Colors.black87.withOpacity(0.3)
                                      // Color(0xfffbfbfb),
                                      // Color(0xfff7f7f7),
                                    ],
                                    // begin: Alignment.topCenter,
                                    // end: Alignment.bottomCenter,
                                  ),
                                ),
                                child: customText(
                                  'Chat',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.amber),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  setSizeOptions(String size) {
    sizeValue = size.obs;
  }

  setProductData(FeedState state) {
    // setState(() {
    //   itemDetails = ModalRoute.of(context).settings.arguments;
    // });
    String productValues =
        '{"price": "${state.ductDetailModel!.last!.price}","productId": "${state.ductDetailModel!.last!.key}","color": "${colorValue.toString()}","selectedCard": "${sizeValue.toString()}"}';

    itemDetails = jsonDecode(productValues);
    // final Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;

    // setState(() {
    //   itemDetails = args;
    // });
  }

  addToShoppingBag(FeedState _shoppingBagService, AuthState authState) async {
    setProductData(_shoppingBagService);

    // showInSnackBar(msg, Colors.black);
    if (sizeValue.value == '' && sizeValue.value.isNotEmpty) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: const Text('Select size'),
          action: SnackBarAction(
            label: 'Close',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(Get.context!).removeCurrentSnackBar();
            },
          ),
        ),
      );
    } else if (colorValue == '' && model!.colors!.isNotEmpty) {
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black,
          content: const Text('Select color'),
          action: SnackBarAction(
            label: 'Close',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(Get.context!).removeCurrentSnackBar();
            },
          ),
        ),
      );
    } else {
      await _shoppingBagService.addProductTocart(
          itemDetails['productId'],
          sizeValue.value,
          colorValue,
          quantity.value,
          authState.userId,
          model!.user!.userId);
//Navigator.of(keyLoader.currentContext, rootNavigator: true).pop();
      //Navigator.maybePop(context).then((value) {
      // Navigator.of(context).pop();
      // _scaffoldKey.currentState.showSnackBar(
      //   SnackBar(
      //     backgroundColor: Colors.teal,
      //     content: new Text(msg),
      //     action: SnackBarAction(
      //       label: 'Close',
      //       textColor: Colors.white,
      //       onPressed: () {
      //         _scaffoldKey.currentState.removeCurrentSnackBar();
      //       },
      //     ),
      //   ),
      // );
      //});

      // Loader.showLoadingScreen(context, keyLoader);
    }
  }

  OverlayEntry _ductView(BuildContext contexts, FeedState state,
      List<FeedModel> commissionProduct) {
    // double heightFactor = 300 / fullHeight(context);
    // var authState = Provider.of<AuthState>(context, listen: false);
    //  var state = Provider.of<FeedState>(context, listen: false);
    //FeedModel model;
    final NumberFormat formatter = NumberFormat.simpleCurrency(
      decimalDigits: 0,
      locale: Localizations.localeOf(Get.context!).toString(),
    );
    return OverlayEntry(
      builder: (context) {
        return Consumer<FeedState>(builder: (context, storeState, child) {
          return GestureDetector(
            onTap: () {
              //   // _video = null;
              //   // _image = null;
              //   // if (isDropdown) {
              //   //   floatingMenu.remove();
              //   // } else {
              //   //   // _postProsductoption();
              //   //   floatingMenu = _mediaView(
              //   //     context,
              //   //   );
              //   //   Overlay.of(context).insert(floatingMenu);
              //   // }

              //   // isDropdown = !isDropdown;
              // });
            },
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: frostedPink(
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // setState(() {
                                    //   // if (_image == null) {
                                    //   //   _image = File(image);
                                    //   // }
                                    //   if (isDropdown) {
                                    //     floatingMenu.remove();
                                    //   } else {
                                    //     // _postProsductoption();
                                    //     floatingMenu = _ductView(
                                    //         context, state, commissionProduct);
                                    //     Overlay.of(context)
                                    //         .insert(floatingMenu);
                                    //   }

                                    //   isDropdown = !isDropdown;
                                    // });
                                  },
                                  child: const Icon(Icons.close),
                                ),
                                // GestureDetector(
                                //     onTap: () {

                                //     },
                                //     child: Row(
                                //       children: [
                                //         customTitleText('Next'),
                                //         Icon(Icons.arrow_forward_ios)
                                //       ],
                                //     ))
                              ],
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: fullWidth(context) * 0.6,
                                width: fullWidth(context),
                                child:
                                    //Column(children: [],)
                                    CustomScrollView(
                                  slivers: <Widget>[
                                    SliverList(
                                      delegate: SliverChildListDelegate(
                                        state.ductReplyMap.isEmpty ||
                                                state.ductReplyMap[postId] ==
                                                    null
                                            // state.ductReplyMap == null ||
                                            //         state.ductReplyMap.length == 0 ||
                                            //         state.ductReplyMap[widget
                                            //                 .model.replyDuctKeyList] ==
                                            //             null
                                            ? [
                                                const Center(
                                                  child: Text(
                                                    'No comments',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                )
                                              ]
                                            : state.ductReplyMap[postId]!
                                                .map((x) =>
                                                    _commentRow(x, context))
                                                .toList(),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const Divider(color: Colors.white),
                              model!.videoPath == null
                                  ? ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(0),
                                      ),
                                      child: Material(
                                        elevation: 10,
                                        child: SizedBox(
                                          width: fullWidth(context),
                                          height: fullWidth(context) * .6,
                                          //decoration: BoxDecoration(),
                                          child: AspectRatio(
                                            aspectRatio: 4 / 3,
                                            child: customNetworkImage(
                                                model!.imagePath,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      constraints: BoxConstraints(
                                        maxHeight: fullHeight(context) * 0.3,
                                      ),
                                      child: FutureBuilder(
                                        future: _initializeVideoplayerfuture,
                                        // initialData: InitialData,
                                        builder: (BuildContext context,
                                            AsyncSnapshot snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.done) {
                                            return SizedBox.expand(
                                              child: FittedBox(
                                                fit: BoxFit.cover,
                                                child: frostedBlack(
                                                  SizedBox(
                                                    width: fullWidth(context),
                                                    height: fullHeight(context),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        if (_videoController
                                                            .value.isPlaying) {
                                                          _videoController
                                                              .pause();
                                                        } else {
                                                          _videoController
                                                              .play();
                                                        }
                                                      },
                                                      child: VideoPlayer(
                                                          _videoController),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          } else {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          }
                                        },
                                      )),
                              const Divider(color: Colors.white),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    // setState(() {
                                    //   if (isDropdown) {
                                    //     floatingMenu.remove();
                                    //   } else {
                                    //     //  _postProsductoption();
                                    //     floatingMenu = _ductView(
                                    //         context, state, commissionProduct);
                                    //     Overlay.of(context)
                                    //         .insert(floatingMenu);
                                    //   }

                                    //   isDropdown = !isDropdown;
                                    // });
                                    // _vCommisionProduct(
                                    //     context, commissionProduct);
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
                              Row(
                                children: [
                                  Material(
                                    borderRadius: BorderRadius.circular(100),
                                    elevation: 20,
                                    child: SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: GestureDetector(
                                        onTap: () {
                                          // setState(() {
                                          //   if (isDropdown) {
                                          //     floatingMenu.remove();
                                          //   } else {
                                          //     //  _postProsductoption();
                                          //     floatingMenu = _ductView(context,
                                          //         state, commissionProduct);
                                          //     Overlay.of(context)
                                          //         .insert(floatingMenu);
                                          //   }

                                          //   isDropdown = !isDropdown;
                                          // });
                                          Get.to(ProfileResponsiveView(
                                            profileId: model!.user!.userId,
                                            profileType: ProfileType.Store,
                                          ));
                                        },
                                        child: customImage(
                                            context, user!.value.profilePic),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: context.responsiveValue(
                                        mobile: Get.width * 0.85,
                                        tablet: Get.width * 0.45,
                                        desktop: Get.width * 0.4),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          frostedBlack(
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: UrlText(
                                                text: model!.ductComment,
                                                onHashTagPressed: (tag) {
                                                  cprint(tag);
                                                },
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary,
                                                    //fontSize: descriptionFontSize,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                urlStyle: const TextStyle(
                                                    color: Colors.blue,
                                                    //fontSize: descriptionFontSize,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              _bottomEntryField(),
                            ],
                          )),
                      Positioned(
                          right: 5,
                          bottom: fullWidth(context) * 0.18,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Material(
                                  elevation: 10,
                                  borderRadius: BorderRadius.circular(20),
                                  child: SizedBox(
                                    width: fullWidth(context) * 0.2,
                                    height: fullWidth(context) * 0.2,
                                    child: customNetworkImage(
                                      commissionProduct.last.imagePath,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                      Positioned(
                        top: 10,
                        right: 20,
                        child: Container(
                            height: 60,
                            width: fullWidth(context) * 0.25,
                            padding: const EdgeInsets.all(0),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                            child: Material(
                              elevation: 10,
                              //borderRadius: BorderRadius.circular(100),
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: customText(
                                          formatter.format(
                                              commissionProduct.last.price),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  fullWidth(context) * 0.05),
                                          context: context),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Widget _bottomEntryField() {
    setWritingTo(bool val) {
      isWriting = val.obs;
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
              Row(
                children: <Widget>[
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
                              hintText: "Say Something",
                              hintStyle: TextStyle(color: Colors.white
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
                            // if (!showEmojiPicker) {
                            //   // keyboard is visible
                            //   hideKeyboard();
                            //   showEmojiContainer();
                            // } else {
                            //   //keyboard is hidden
                            //   showKeyboard();
                            //   hideEmojiContainer();
                            // }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
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
                        ),
                      ],
                    ),
                  ),
                  isWriting == true.obs
                      ? Container(
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
                              onPressed: () {
                                _submitButton(Get.context);
                              }
                              //  statusInit == ChatStatus.blocked.index
                              //     ? null
                              //     : () => ductId != null
                              //         ? submitMessage(
                              //             textEditingController.text,
                              //             MessagesType.Products,
                              //             DateTime.now().millisecondsSinceEpoch,
                              //             ductId,
                              //           )
                              //         : chatUserProductId != null
                              //             ? submitMessage(
                              //                 textEditingController.text,
                              //                 MessagesType.ChatUserProducts,
                              //                 DateTime.now()
                              //                     .millisecondsSinceEpoch,
                              //                 chatUserProductId,
                              //               )
                              //             : myOrders != null
                              //                 ? submitMessage(
                              //                     textEditingController.text,
                              //                     MessagesType.MyOrders,
                              //                     DateTime.now()
                              //                         .millisecondsSinceEpoch,
                              //                     myOrders,
                              //                   )
                              //                 : _image != null
                              //                     ? submitMessage(
                              //                         textEditingController.text,
                              //                         MessagesType.Image,
                              //                         DateTime.now()
                              //                             .millisecondsSinceEpoch,
                              //                         null,
                              //                       )
                              //                     : submitMessage(
                              //                         textEditingController.text,
                              //                         MessagesType.Text,
                              //                         DateTime.now()
                              //                             .millisecondsSinceEpoch,
                              //                         null,
                              //                       ),
                              //    color: viewductWhite,
                              ),
                        )
                      : Container()
                ],
              ),
              showEmojiPicker == true.obs
                  ? Container(child: emojiContainer())
                  : Container()
            ],
          ),
        ),
        width: double.infinity,
//height: 100.0,
      ),
    );
  }

  emojiContainer() {
    return SingleChildScrollView(
      child: FittedBox(
        fit: BoxFit.fill,
        child: SizedBox(
          width: Get.width,
          child: Row(
            children: const [
              // EmojiPicker(
              //   bgColor: UniversalVariables.separatorColor,
              //   indicatorColor: UniversalVariables.blueColor,
              //   rows: 3,
              //   columns: 7,
              //   onEmojiSelected: (emoji, category) {
              //     isWriting = true.obs;

              //     textEditingController.text =
              //         textEditingController.text + emoji.emoji;
              //   },
              //   recommendKeywords: ["face", "happy", "party", "sad"],
              //   numRecommended: 50,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _likeCommentWidget(BuildContext context) {
    bool isLikeAvailable =
        model!.likeCount != null ? model!.likeCount! > 0 : false;
    bool isRetweetAvailable = model!.vductCount! > 0;
    bool isLikeRetweetAvailable = isRetweetAvailable || isLikeAvailable;
    return Column(
      children: <Widget>[
        const Divider(
          endIndent: 10,
          height: 0,
        ),
        AnimatedContainer(
          padding:
              EdgeInsets.symmetric(vertical: isLikeRetweetAvailable ? 12 : 0),
          duration: const Duration(milliseconds: 500),
          child: !isLikeRetweetAvailable
              ? const SizedBox.shrink()
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    !isRetweetAvailable
                        ? const SizedBox.shrink()
                        : customText(model!.vductCount.toString(),
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                    !isRetweetAvailable
                        ? const SizedBox.shrink()
                        : const SizedBox(width: 5),
                    AnimatedCrossFade(
                      firstChild: const SizedBox.shrink(),
                      secondChild: customText('Retweets', style: subtitleStyle),
                      crossFadeState: !isRetweetAvailable
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      duration: const Duration(milliseconds: 800),
                    ),
                    !isRetweetAvailable
                        ? const SizedBox.shrink()
                        : const SizedBox(width: 20),
                    InkWell(
                      onTap: () {
                        onLikeTextPressed(context);
                      },
                      child: AnimatedCrossFade(
                        firstChild: const SizedBox.shrink(),
                        secondChild: Row(
                          children: <Widget>[
                            customSwitcherWidget(
                              duraton: const Duration(milliseconds: 300),
                              child: customText(model!.likeCount.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  key: ValueKey(model!.likeCount)),
                            ),
                            const SizedBox(width: 5),
                            customText('Likes', style: subtitleStyle)
                          ],
                        ),
                        crossFadeState: !isLikeAvailable
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: const Duration(milliseconds: 300),
                      ),
                    )
                  ],
                ),
        ),
        !isLikeRetweetAvailable
            ? const SizedBox.shrink()
            : const Divider(
                endIndent: 10,
                height: 0,
              ),
      ],
    );
  }

  void addLikeToDuct(BuildContext context) {
    var state = Provider.of<FeedState>(context, listen: false);
    var authState = Provider.of<AuthState>(context, listen: false);
    state.addLikeToDuct(model!, authState.userId, model!.key);
  }

  void onLikeTextPressed(BuildContext context) {
    // Get.to(
    //   () => CustomRoute<bool>(
    //     builder: (BuildContext context) => UsersListPage(
    //       pageTitle: "Liked by",
    //       userIdsList: model!.likeList!.map((userId) => userId).toList(),
    //       emptyScreenText: "This tweet has no like yet",
    //       emptyScreenSubTileText:
    //           "Once a user likes this tweet, user list will be shown here",
    //     ),
    //   ),
    // );
    // Navigator.of(context).push(
    //   CustomRoute<bool>(
    //     builder: (BuildContext context) => UsersListPage(
    //       pageTitle: "Liked by",
    //       userIdsList: model.likeList.map((userId) => userId).toList(),
    //       emptyScreenText: "This tweet has no like yet",
    //       emptyScreenSubTileText:
    //           "Once a user likes this tweet, user list will be shown here",
    //     ),
    //   ),
    // );
  }

  Widget _commentRow(FeedModel model, BuildContext context) {
    return chatMessages(model, context);
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

  Widget chatMessages(
    FeedModel message,
    BuildContext context,
  ) {
    // if (senderId == null) {
    //   return Container();
    // }
    if (message.userId == senderId) {
      return _userComments(message, true);
    } else {
      return _userComments(message, false);
    }
  }

  Widget _userComments(FeedModel comment, bool myMessage) {
    return Column(
      crossAxisAlignment:
          myMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisAlignment:
          myMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            const SizedBox(
              width: 15,
            ),
            myMessage
                ? const SizedBox()
                : CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage:
                        customAdvanceNetworkImage(comment.user!.profilePic),
                  ),
            Expanded(
              child: Container(
                alignment:
                    myMessage ? Alignment.centerRight : Alignment.centerLeft,
                margin: EdgeInsets.only(
                  right: myMessage ? 10 : (Get.width / 4),
                  top: 20,
                  left: myMessage ? (Get.width / 4) : 10,
                ),
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: getBorder(myMessage),
                        color: myMessage ? Colors.grey : TwitterColor.mystic,
                      ),
                      child: UrlText(
                        text: comment.ductComment,
                        style: TextStyle(
                          fontSize: 16,
                          color: myMessage ? TwitterColor.white : Colors.black,
                        ),
                        urlStyle: TextStyle(
                          fontSize: 16,
                          color: myMessage
                              ? TwitterColor.white
                              : TwitterColor.dodgetBlue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: InkWell(
                        borderRadius: getBorder(myMessage),
                        onTap: () {},
                        child: const SizedBox(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        customText(getPostTime2(comment.createdAt),
            style: const TextStyle(color: Colors.yellow)
            // Theme.of(context).textTheme.caption.copyWith(fontSize: 12),
            )
        // Padding(
        //   padding: EdgeInsets.only(right: 10, left: 10),
        //   child: Text(
        //     getChatTime(chat.createdAt),
        //     style: Theme.of(context).textTheme.caption.copyWith(fontSize: 12),
        //   ),
        // )
      ],
    );
  }

  FeedModel createTweetModel() {
    // var state = Provider.of<FeedState>(context, listen: false);
    // var authState = Provider.of<AuthState>(context, listen: false);
    var myUser = authState.userModel!;
    var profilePic = myUser.profilePic ?? dummyProfilePic;
    var commentedUser = ViewductsUser(
        displayName: myUser.displayName ?? myUser.email!.split('@')[0],
        profilePic: profilePic,
        userId: myUser.userId,
        isVerified: authState.userModel!.isVerified,
        userName: authState.userModel!.userName);
    var tags = getHashTags(textEditingController.text);

    FeedModel reply = FeedModel(
        ductComment: textEditingController.text,
        user: commentedUser,
        cProduct: ductId,
        createdAt: DateTime.now().toUtc().toString(),
        tags: tags,
        parentkey:
            //  isTweet
            //     ? null
            //     : isRetweet
            //         ? null
            //:
            feedState.ductToReplyModel!.value!.key,
        childVductkey:
            //  isTweet
            //     ? null
            //     : isRetweet
            //         ? model.key
            //         :
            null,
        userId: myUser.userId);
    return reply;
  }

  /// Submit tweet to save in firebase database
  void _submitButton(BuildContext? context) async {
    if (textEditingController.text.isEmpty ||
        textEditingController.text.length > 280) {
      return;
    }
    //kScreenloader.showLoader(context);

    FeedModel tweetModel = createTweetModel();
    feedState.addcommentToPost(tweetModel);

    /// Checks for username in tweet ductComment
    /// If foud sends notification to all tagged user
    /// If no user found or not compost tweet screen is closed and redirect back to home page.
    await composeductState.sendNotification(tweetModel, searchState).then((_) {
      textEditingController.clear();

      /// Hide running loader on screen
      // kScreenloader.hideLoader();

      /// Navigate back to home page
      //  Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final storylist = useState(feedState.storylist);
    final userSetState = useState(user);
    getData() async {
      try {
        final database = Databases(
          clientConnect(),
        );

        await database
            .getDocument(
                databaseId: databaseId,
                collectionId: profileUserColl,
                documentId: model!.commissionUser.toString())
            .then((ductUser) {
          userSetState.value = ViewductsUser.fromJson(ductUser.data).obs;
        });
        await database.listDocuments(
            databaseId: databaseId,
            collectionId: storyCollId,
            queries: [
              query.Query.limit(15),
              query.Query.equal('userId', model?.userId.toString()),
              //   query.Query.greaterThanEqual('date', time)
            ]).then((data) {
          // Map map = data.toMap();

          var value = data.documents
              .map((e) => DuctStoryModel.fromMap(e.data))
              .toList();
          //data.documents;
          storylist.value = value
              .where((storyData) {
                if (DateTime.now()
                        .toUtc()
                        .difference(
                            DateTime.parse(storyData.createdAt.toString()))
                        .inHours <
                    24) {
                  return true;
                } else {
                  return false;
                }
              })
              .toList()
              .obs;
          // cprint('${data.documents.map((e) => FeedModel.fromJson(e.data))}');
          //cprint('${feedState.feedlist?.value.map((e) => e.key)}');
        });
      } on AppwriteException catch (e) {
        cprint("$e");
      }
    }

    void onTapDuct(BuildContext context, FeedModel? commissionProduct) {
      //  var feedState = Provider.of<FeedState>(context, listen: false);
      if (type == DuctType.Detail || type == DuctType.ParentDuct) {
        return;
      }
      if (type == DuctType.Duct && !isDisplayOnProfile) {
        feedState.clearAllDetailAndReplyDuctStack();
      }
      if (storylist.value.isNotEmpty) {
        // var state = Provider.of<FeedState>(context, listen: false);
        feedState.getpostDetailFromDatabase(null, model: model);
        // state.getpostDetailFromDatabase(model.key);
        feedState.setDuctToReply = model.obs;
        // showModalBottomSheet(
        //     backgroundColor: Colors.red,
        //     // bounce: true,
        //     context: context,
        //     builder: (context) => MainStoryResponsiveView(
        //         model: model, storylist: storylist.value));
      }
    }

    useEffect(
      () {
        getData();
        return () {};
      },
      [user],
    );
    return Obx(() => Container(
          width: Get.height * 0.5,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 11),
                    blurRadius: 11,
                    color: Colors.black.withOpacity(0.06))
              ],
              borderRadius: BorderRadius.circular(5),
              color: CupertinoColors.lightBackgroundGray.withOpacity(0.2)),
          padding: const EdgeInsets.all(5.0),
          child: Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              /// Left vertical bar of a tweet
              type != DuctType.ParentDuct
                  ? const SizedBox.shrink()
                  : Positioned.fill(
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 38,
                          top: 75,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                                width: 3.0, color: Colors.grey.shade400),
                          ),
                        ),
                      ),
                    ),
              frostedYellow(
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                        // padding: EdgeInsets.only(
                        //   top: type == DuctType.Duct || type == DuctType.Reply
                        //       ? 12
                        //       : 0,
                        // ),
                        child:
                            // type == DuctType.Duct || type == DuctType.Reply
                            //     ?

                            model!.caption == 'product'
                                ? _ProductDuctBody(
                                    isDisplayOnProfile: isDisplayOnProfile,
                                    model: model,
                                    trailing: trailing,
                                    type: type,
                                    state: feedState,
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      if (storylist.value.isNotEmpty) {
                                        // showModalBottomSheet(
                                        //     backgroundColor: Colors.red,
                                        //     // bounce: true,
                                        //     context: context,
                                        //     builder: (context) =>
                                        //         MainStoryResponsiveView(
                                        //           model: model,
                                        //           storylist: storylist.value,
                                        //         ));
                                      }
                                    },
                                    child: _DuctBody(
                                        Stack(
                                          children: [
                                            Align(
                                              alignment: Alignment.center,
                                              child: CircleAvatar(
                                                radius: 22,
                                                backgroundColor:
                                                    Colors.yellow.shade200,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                //  if (user?.value.userId != null) {
                                                chatState.setChatUser =
                                                    userSetState.value?.value;
                                                //   If tweet is displaying on someone's profile then no need to navigate to same user's profile again.
                                                // if (isDisplayOnProfile!) {
                                                //   return;
                                                // }
                                                // if (user?.value.displayName == null) {
                                                //   return;
                                                // } else {
                                                Get.to(
                                                    () => ProfileResponsiveView(
                                                          profileId:
                                                              userSetState.value
                                                                  ?.value.key,
                                                          profileType:
                                                              ProfileType.Store,
                                                        ));
                                                // Get.to(() => ChatScreenPage(
                                                //       userProfileId:
                                                //           model.value!.userId,
                                                //     ));
                                                //  }
                                              },
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: CircleAvatar(
                                                  radius: 22,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  child: Material(
                                                    elevation: 20,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    child: customImage(
                                                        context,
                                                        userSetState.value
                                                            ?.value.profilePic,
                                                        height: 30),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              right: 0,
                                              bottom: 0,
                                              child: userSetState.value?.value
                                                          .isVerified ==
                                                      true
                                                  ? Material(
                                                      elevation: 10,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      child: CircleAvatar(
                                                        radius: 9,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        child: Image.asset(
                                                            'assets/delicious.png'),
                                                      ),
                                                    )
                                                  : Container(),
                                            )
                                          ],
                                        ),
                                        isDisplayOnProfile: isDisplayOnProfile,
                                        model: model.obs,
                                        isDeskLeft: isDeskLeft,
                                        storylist: storylist.value,
                                        trailing: trailing,
                                        type: type,
                                        user: userSetState.value),
                                  )),
                    Padding(
                      padding: EdgeInsets.only(
                          right: type == DuctType.Detail ? 5 : 60),
                      child: Column(
                        children: [
                          model!.caption == 'product'
                              ?
                              //  model.videoPath == null
                              //     ?
                              ProductDuctImage(
                                  model: model,
                                  type: type,
                                )
                              // : ProductVideo(
                              //     model: model,
                              //     type: type,
                              //   )
                              : Stack(
                                  children: [
                                    model!.videoPath == null
                                        ?
                                        //  DuctMenuHolder(
                                        //     onPressed: () {},
                                        //     menuItems: <DuctFocusedMenuItem>[
                                        //       DuctFocusedMenuItem(
                                        //           title: const Text(
                                        //               'DownLoad Image'),
                                        //           onPressed: () {
                                        //             // Clipboard.setData(ClipboardData(
                                        //             //     text: TextEncryptDecrypt.decryptAES(
                                        //             //         lastMessage.value.message)));
                                        //           },
                                        //           trailingIcon: const Icon(
                                        //               CupertinoIcons
                                        //                   .add_circled_solid)),
                                        //       DuctFocusedMenuItem(
                                        //           title: const Text(
                                        //             'Delete',
                                        //             style: TextStyle(
                                        //                 color: Colors.red),
                                        //           ),
                                        //           onPressed: () {},
                                        //           trailingIcon: const Icon(
                                        //             CupertinoIcons.delete,
                                        //             color: Colors.red,
                                        //           ))
                                        //     ],
                                        //     child:
                                        DuctImage(
                                            model: model,
                                            type: type,
                                            storylist: storylist.value,
                                            commissionProduct:
                                                commissionProduct!.firstWhere(
                                              (comm) =>
                                                  comm.key == model!.cProduct,
                                              orElse: () => FeedModel(),
                                            ),
                                          )
                                        // )
                                        : VideoImage(
                                            model: model,
                                            type: type,
                                            storylist: storylist.value,
                                          ),
                                    model!.duration == null
                                        ? Container()
                                        : Positioned(
                                            bottom: 10,
                                            left: 5,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                            offset:
                                                                Offset(0, 11),
                                                            blurRadius: 11,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.06))
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18),
                                                      color: CupertinoColors
                                                          .white),
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    '${model!.duration}s',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w200),
                                                  )),
                                            ),
                                            //  Material(
                                            //   elevation: 10,
                                            //   borderRadius:
                                            //       BorderRadius.circular(10),
                                            //   child: frostedOrange(
                                            //     Padding(
                                            //       padding:
                                            //           const EdgeInsets.symmetric(
                                            //               horizontal: 8.0,
                                            //               vertical: 3),
                                            //       child: customText(
                                            //           '${model!.duration}s',
                                            //           style: const TextStyle(
                                            //             color: Colors.black87,
                                            //             fontFamily:
                                            //                 'HelveticaNeue',
                                            //             fontWeight:
                                            //                 FontWeight.w900,
                                            //             fontSize: 20,
                                            //           )),
                                            //     ),
                                            //   ),
                                            // ),
                                          ),
                                  ],
                                ),
                          // DuctIconsRow(
                          //   type: type,
                          //   model: model,
                          //   isDuctDetail: type == DuctType.Detail,
                          //   iconColor: Theme.of(context).textTheme.caption.color,
                          //   iconEnableColor: TwitterColor.ceriseRed,
                          //   size: 20,
                          // ),
                          model!.caption == 'product'
                              ? Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Row(
                                        children: [
                                          frostedTeal(
                                            const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('vDucts Comm..:',
                                                  style: TextStyle(
                                                    color: Colors.blueGrey,
                                                    fontWeight: FontWeight.w800,
                                                  )),
                                            ),
                                          ),
                                          Text('${model!.commissionPrice}%',
                                              style: const TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ))
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : Container()
                        ],
                      ),
                    ),
                    type == DuctType.ParentDuct
                        ? const SizedBox.shrink()
                        : const Divider(height: .5, thickness: .5),
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          model!.caption == 'product'
                              ? Container()
                              // ignore: unnecessary_null_comparison
                              : commissionProduct!.isEmpty
                                  ? Container()
                                  : Container(
                                      width: Get.height * 0.4,
                                      child: Stack(
                                        children: [
                                          Column(
                                            children: [
                                              SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  // direction: Axis.vertical,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        width: Get.height * 0.1,
                                                        child: Material(
                                                          elevation: 20,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          child: frostedYellow(
                                                            Center(
                                                              child: _Orders(
                                                                list: commissionProduct!.firstWhere(
                                                                    (comm) =>
                                                                        comm.key ==
                                                                        model!
                                                                            .cProduct,
                                                                    orElse: () =>
                                                                        FeedModel()),
                                                                commisionUser:
                                                                    model!
                                                                        .userId,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      width: Get.height * 0.4,
                                                      child: ListTile(
                                                        title: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              frostedOrange(
                                                                  Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                  color: Colors
                                                                      .blueGrey[50],
                                                                  gradient:
                                                                      LinearGradient(
                                                                    colors: [
                                                                      Colors
                                                                          .white54
                                                                          .withOpacity(
                                                                              0.1),
                                                                      Colors
                                                                          .white54
                                                                          .withOpacity(
                                                                              0.2),
                                                                      Colors
                                                                          .white54
                                                                          .withOpacity(
                                                                              0.3)
                                                                      // Color(0xfffbfbfb),
                                                                      // Color(0xfff7f7f7),
                                                                    ],
                                                                    // begin: Alignment.topCenter,
                                                                    // end: Alignment.bottomCenter,
                                                                  ),
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          2.0),
                                                                  child: customText(
                                                                      commissionProduct!
                                                                          .firstWhere(
                                                                              (comm) => comm.key == model!.cProduct,
                                                                              orElse: () => FeedModel())
                                                                          .productName,
                                                                      style: const TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                      )),
                                                                ),
                                                              )),
                                                              frostedOrange(
                                                                  Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                  color: Colors
                                                                      .blueGrey[50],
                                                                  gradient:
                                                                      LinearGradient(
                                                                    colors: [
                                                                      Colors.red
                                                                          .withOpacity(
                                                                              0.1),
                                                                      Colors
                                                                          .green
                                                                          .withOpacity(
                                                                              0.2),
                                                                      Colors
                                                                          .blue
                                                                          .withOpacity(
                                                                              0.3)
                                                                      // Color(0xfffbfbfb),
                                                                      // Color(0xfff7f7f7),
                                                                    ],
                                                                    // begin: Alignment.topCenter,
                                                                    // end: Alignment.bottomCenter,
                                                                  ),
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          2.0),
                                                                  child: customText(
                                                                      commissionProduct!
                                                                          .firstWhere(
                                                                              (comm) => comm.key == model!.cProduct,
                                                                              orElse: () => FeedModel())
                                                                          .section,
                                                                      style: const TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                      )),
                                                                ),
                                                              )),
                                                              commissionProduct!.firstWhere((comm) => comm.key == model!.cProduct, orElse: () => FeedModel()).userId ==
                                                                          authState
                                                                              .userId ||
                                                                      model!.userId ==
                                                                          authState
                                                                              .userId
                                                                  ? Container()
                                                                  : GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        showModalBottomSheet(
                                                                            backgroundColor: Colors
                                                                                .red,
                                                                            // bounce:
                                                                            //     true,
                                                                            context:
                                                                                context,
                                                                            builder: (context) =>
                                                                                ProductStoryView(
                                                                                  model: commissionProduct!.firstWhere((comm) => comm.key == model!.cProduct, orElse: () => FeedModel()),
                                                                                  commissionUser: model!.userId,
                                                                                  isVduct: true,
                                                                                ));
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
                                                            ],
                                                          ),
                                                        ),
                                                        // Expanded(child: Container()),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  commissionProduct!
                                                                  .firstWhere(
                                                                      (comm) =>
                                                                          comm.key ==
                                                                          model!
                                                                              .cProduct,
                                                                      orElse: () =>
                                                                          FeedModel())
                                                                  .salePrice ==
                                                              0 ||
                                                          commissionProduct!
                                                                  .firstWhere(
                                                                      (comm) =>
                                                                          comm.key ==
                                                                          model!
                                                                              .cProduct,
                                                                      orElse: () =>
                                                                          FeedModel())
                                                                  .salePrice ==
                                                              null
                                                      ? Container()
                                                      : Row(
                                                          children: [
                                                            commissionProduct!
                                                                            .firstWhere((comm) => comm.key == model!.cProduct,
                                                                                orElse: () =>
                                                                                    FeedModel())
                                                                            .salePrice ==
                                                                        0 ||
                                                                    commissionProduct!
                                                                            .firstWhere((comm) => comm.key == model!.cProduct,
                                                                                orElse: () => FeedModel())
                                                                            .salePrice ==
                                                                        null
                                                                ? Container()
                                                                : Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Container(
                                                                        padding: const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                8.0,
                                                                            vertical:
                                                                                3),
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.black54,
                                                                            borderRadius: BorderRadius.circular(10)),
                                                                        child: customText(
                                                                            NumberFormat.currency(name: commissionProduct!.firstWhere((comm) => comm.key == model!.cProduct, orElse: () => FeedModel()).productLocation == 'Nigeria' ? '₦' : '£').format(double.parse(commissionProduct!.firstWhere((comm) => comm.key == model!.cProduct, orElse: () => FeedModel()).salePrice.toString())),
                                                                            //'N ${widget.ductProduct!.price}',
                                                                            style: TextStyle(
                                                                              color: CupertinoColors.systemRed,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: context.responsiveValue(mobile: Get.height * 0.03, tablet: Get.height * 0.03, desktop: Get.height * 0.03),
                                                                            )),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(vertical: 2.0),
                                                                        child:
                                                                            Container(
                                                                          padding: const EdgeInsets.symmetric(
                                                                              horizontal: 8.0,
                                                                              vertical: 3),
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.black54,
                                                                              borderRadius: BorderRadius.circular(10)),
                                                                          child: customText(
                                                                              NumberFormat.currency(name: commissionProduct!.firstWhere((comm) => comm.key == model!.cProduct, orElse: () => FeedModel()).productLocation == 'Nigeria' ? '₦' : '£').format(double.parse(commissionProduct!.firstWhere((comm) => comm.key == model!.cProduct, orElse: () => FeedModel()).price.toString())),

                                                                              //'N ${widget.ductProduct!.price}',

                                                                              style: TextStyle(
                                                                                decoration: TextDecoration.lineThrough,
                                                                                color: CupertinoColors.systemYellow,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: context.responsiveValue(mobile: Get.height * 0.02, tablet: Get.height * 0.02, desktop: Get.height * 0.02),
                                                                              )),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                          ],
                                                        ),
                                                  commissionProduct!
                                                              .firstWhere(
                                                                  (comm) =>
                                                                      comm.key ==
                                                                      model!
                                                                          .cProduct,
                                                                  orElse: () =>
                                                                      FeedModel())
                                                              .price ==
                                                          null
                                                      ? SizedBox()
                                                      : Container(
                                                          height: context
                                                              .responsiveValue(
                                                                  mobile:
                                                                      Get.width *
                                                                          0.1,
                                                                  tablet:
                                                                      Get.height *
                                                                          0.06,
                                                                  desktop:
                                                                      Get.height *
                                                                          0.06),
                                                          //width: 70,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(0),

                                                          // decoration: BoxDecoration(
                                                          //     shape: BoxShape.circle, color: Colors.white),
                                                          child: Material(
                                                            elevation: 10,
                                                            //borderRadius: BorderRadius.circular(100),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .blueGrey[50],
                                                                gradient:
                                                                    LinearGradient(
                                                                  colors: [
                                                                    Colors
                                                                        .yellow
                                                                        .withOpacity(
                                                                            0.1),
                                                                    Colors
                                                                        .white54
                                                                        .withOpacity(
                                                                            0.2),
                                                                    Colors
                                                                        .orange
                                                                        .shade200
                                                                        .withOpacity(
                                                                            0.3)
                                                                    // Color(0xfffbfbfb),
                                                                    // Color(0xfff7f7f7),
                                                                  ],
                                                                  // begin: Alignment.topCenter,
                                                                  // end: Alignment.bottomCenter,
                                                                ),
                                                              ),
                                                              child: Stack(
                                                                children: [
                                                                  commissionProduct!.firstWhere((comm) => comm.key == model!.cProduct, orElse: () => FeedModel()).salePrice ==
                                                                              0 ||
                                                                          commissionProduct!.firstWhere((comm) => comm.key == model!.cProduct, orElse: () => FeedModel()).salePrice ==
                                                                              null
                                                                      ? Align(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child: Padding(
                                                                              padding: const EdgeInsets.all(10.0),
                                                                              child: customText(
                                                                                NumberFormat.currency(name: commissionProduct!.firstWhere((comm) => comm.key == model!.cProduct, orElse: () => FeedModel()).productLocation == 'Nigeria' ? '₦' : '£').format(double.parse("${commissionProduct!.firstWhere((comm) => comm.key == model!.cProduct, orElse: () => FeedModel()).price}")),
                                                                                // formatter.format(
                                                                                //     int.parse(model!.price.toString())),
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontSize: context.responsiveValue(mobile: Get.width * 0.05, tablet: Get.width * 0.02, desktop: Get.width * 0.02),
                                                                                ),
                                                                              )),
                                                                        )
                                                                      : Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(5.0),
                                                                          child: Container(
                                                                              decoration: BoxDecoration(boxShadow: [
                                                                                BoxShadow(offset: const Offset(0, 11), blurRadius: 11, color: Colors.black.withOpacity(0.06))
                                                                              ], borderRadius: BorderRadius.circular(18), color: CupertinoColors.systemRed),
                                                                              padding: const EdgeInsets.all(5.0),
                                                                              child: TitleText(
                                                                                'On Sale',
                                                                                color: CupertinoColors.lightBackgroundGray,
                                                                              )),
                                                                        ),
                                                                ],
                                                              ),
                                                            ),
                                                          )),
                                                ],
                                              ),
                                            ],
                                          ),
                                          model?.audioTag == null
                                              ? Container()
                                              : Positioned(
                                                  top: 0,
                                                  right: 0,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      // showModalBottomSheet(
                                                      //     backgroundColor:
                                                      //         Colors.red,
                                                      //     // bounce: true,
                                                      //     context: context,
                                                      //     builder: (context) =>
                                                      //         MainStoryResponsiveView(
                                                      //             model: model,
                                                      //             storylist:
                                                      //                 storylist
                                                      //                     .value));
                                                    },
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          CupertinoIcons
                                                              .music_note_2,
                                                          color: CupertinoColors
                                                              .systemTeal,
                                                          size: 50,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: Container(
                                                              decoration: BoxDecoration(
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                        offset: const Offset(
                                                                            0,
                                                                            11),
                                                                        blurRadius:
                                                                            11,
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(0.06))
                                                                  ],
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              18),
                                                                  color: CupertinoColors
                                                                      .lightBackgroundGray),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              child: TitleText(
                                                                  color: CupertinoColors
                                                                      .activeOrange,
                                                                  'Audio Tag')),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                        ],
                                      ),
                                    ),
                          model!.caption == 'product'
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: customText(model!.productName,
                                          // ductProduct == null
                                          //     ? ''
                                          //     : formatter.format(ductProduct.price),
                                          style: TextStyle(
                                            color: Colors.blueGrey[800],
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15,
                                          )),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.blueGrey[50],
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.red.withOpacity(0.1),
                                            Colors.green.withOpacity(0.2),
                                            Colors.blue.withOpacity(0.3)
                                            // Color(0xfffbfbfb),
                                            // Color(0xfff7f7f7),
                                          ],
                                          // begin: Alignment.topCenter,
                                          // end: Alignment.bottomCenter,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: customText(model!.section,
                                            // ductProduct == null
                                            //     ? ''
                                            //     : formatter.format(ductProduct.price),
                                            style: TextStyle(
                                              color: Colors.blueGrey[800],
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15,
                                            )),
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        const Icon(Icons.place),
                                        Row(
                                          children: [
                                            customText(model!.productState,
                                                // ductProduct == null
                                                //     ? ''
                                                //     : formatter.format(ductProduct.price),
                                                style: TextStyle(
                                                  color: Colors.blueGrey[800],
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15,
                                                )),
                                            customText(
                                                ', ${model!.productLocation}',
                                                // ductProduct == null
                                                //     ? ''
                                                //     : formatter.format(ductProduct.price),
                                                style: TextStyle(
                                                  color: Colors.blueGrey[800],
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15,
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : Container(),
                          const Divider()
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              model!.caption == 'product'
                  ? Positioned(
                      bottom: 20,
                      right: 20,
                      child: Container(
                          height: 70,
                          //width: 70,
                          padding: const EdgeInsets.all(0),

                          // decoration: BoxDecoration(
                          //     shape: BoxShape.circle, color: Colors.white),
                          child: Material(
                            elevation: 10,
                            //borderRadius: BorderRadius.circular(100),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blueGrey[50],
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.yellow.withOpacity(0.1),
                                    Colors.white54.withOpacity(0.2),
                                    Colors.orange.shade200.withOpacity(0.3)
                                    // Color(0xfffbfbfb),
                                    // Color(0xfff7f7f7),
                                  ],
                                  // begin: Alignment.topCenter,
                                  // end: Alignment.bottomCenter,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: customText(
                                          NumberFormat.currency(name: 'N ')
                                              .format(double.parse(
                                                  model!.price.toString())),
                                          // formatter.format(
                                          //     int.parse(model!.price.toString())),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  fullWidth(context) * 0.05),
                                          context: context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    )
                  : Container()
            ],
          ),
        ));
  }
}

// ignore: must_be_immutable
class _Orders extends HookWidget {
  _Orders({
    Key? key,
    this.isSelected,
    this.list,
    this.commisionUser,
  }) : super(key: key);

  final ValueNotifier<bool>? isSelected;
  final FeedModel? list;
  String? commisionUser;

  @override
  Widget build(BuildContext context) {
    Storage storage = Storage(clientConnect());
    imageStream() async {
      return CachedMemoryImage(
        uniqueKey: '${list?.imagePath}',
        fit: BoxFit.contain,
        bytes: await storage.getFileView(
            bucketId: productBucketId, fileId: '${list?.imagePath}'),
      );
    }

    final future = useMemoized(() => imageStream());
    final snapShotImage = useFuture(future);
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  backgroundColor: Colors.red,
                  // bounce: true,
                  context: context,
                  builder: (context) => ProductStoryView(
                        model: list,
                        commissionUser: commisionUser,
                      ));
            },
            child: SizedBox(
              width: context.responsiveValue(
                  mobile: Get.height * 0.1,
                  tablet: Get.height * 0.1,
                  desktop: Get.height * 0.1),
              height: context.responsiveValue(
                  mobile: Get.height * 0.1,
                  tablet: Get.height * 0.1,
                  desktop: Get.height * 0.1),
              child: SizedBox.expand(
                child: snapShotImage.data,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DuctBody extends HookWidget {
  final Rx<FeedModel?> model;
  final Widget? trailing;
  final Widget? profilePic;
  final DuctType? type;
  final bool? isDeskLeft;
  final bool? isDisplayOnProfile;
  final RxList<DuctStoryModel>? storylist;
  final Rx<ViewductsUser>? user;
  _DuctBody(this.profilePic,
      {Key? key,
      required this.model,
      this.trailing,
      this.isDeskLeft = true,
      this.type,
      this.storylist,
      this.isDisplayOnProfile,
      this.user})
      : super(key: key);
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

  @override
  Widget build(BuildContext context) {
    final userSetState = useState(user);

    double descriptionFontSize = type == DuctType.Duct
        ? 15
        : type == DuctType.Detail || type == DuctType.ParentDuct
            ? 18
            : 14;
    FontWeight descriptionFontWeight =
        type == DuctType.Duct || type == DuctType.Duct
            ? FontWeight.w400
            : FontWeight.w400;

    return Obx(() => Padding(
          padding: EdgeInsets.fromLTRB(10, 0, Get.height * 0.1, 0),
          child: Stack(
            children: [
              Column(
                children: [
                  DuctPostBar(
                    list: storylist,
                  ),
                  Wrap(
                    children: <Widget>[
                      //SizedBox(width: 1),
                      frostedWhite(
                        Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Wrap(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      //  if (user?.value.userId != null) {
                                      chatState.setChatUser =
                                          userSetState.value?.value;
                                      //   If tweet is displaying on someone's profile then no need to navigate to same user's profile again.
                                      // if (isDisplayOnProfile!) {
                                      //   return;
                                      // }
                                      // if (user?.value.displayName == null) {
                                      //   return;
                                      // } else {
                                      Get.to(() => ProfileResponsiveView(
                                            profileId: user?.value.userId,
                                            profileType: ProfileType.Store,
                                          ));
                                      // Get.to(() => ChatScreenPage(
                                      //       userProfileId:
                                      //           model.value!.userId,
                                      //     ));
                                      //  }
                                    },
                                    child: Stack(
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            // const Spacer(),

                                            Container(
                                              width: 40,
                                              height: 40,
                                              child: profilePic,
                                            ),
                                            Container(
                                                child: trailing ??
                                                    const SizedBox()),
                                          ],
                                        ),
                                        // Positioned(
                                        //   left: fullWidth(context) * 0.2,
                                        //   child: SizedBox(
                                        //     width: fullWidth(context) * 0.8,
                                        //     height: fullWidth(context) * 0.2,
                                        //     child: DuctIconsRow(
                                        //       type: type,
                                        //       model: model,
                                        //       isDuctDetail: type == DuctType.Detail,
                                        //       iconColor: Theme.of(context)
                                        //           .textTheme
                                        //           .caption!
                                        //           .color,
                                        //       iconEnableColor: TwitterColor.ceriseRed,
                                        //       size: 20,
                                        //       postId: model!.key,
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                        minWidth: 0,
                                        maxWidth: fullWidth(context) * .5),
                                    child: Row(
                                      children: [
                                        TitleText(user?.value.displayName ?? '',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            overflow: TextOverflow.ellipsis),
                                        user?.value.isVerified == true
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      Expanded(
                                        child: Row(
                                          children: <Widget>[
                                            const SizedBox(width: 3),
                                            // model!.user!.isVerified!
                                            //     ? customIcon(
                                            //         context,
                                            //         icon: AppIcon.blueTick,
                                            //         istwitterIcon: true,
                                            //         iconColor: AppColor.primary,
                                            //         size: 13,
                                            //         paddingIcon: 3,
                                            //       )
                                            //     : const SizedBox(width: 0),
                                            // SizedBox(
                                            //   width: model!.user!.isVerified! ? 5 : 0,
                                            // ),
                                            // Flexible(
                                            //   child: frostedOrange(
                                            //     Padding(
                                            //       padding: const EdgeInsets.all(8.0),
                                            //       child: customText(
                                            //         '${model!.user!.userName}',
                                            //         style: TextStyle(
                                            //             // color: Theme.of(context)
                                            //             //     .colorScheme
                                            //             //     .onPrimary,
                                            //             ),
                                            //         //  style: userNameStyle,
                                            //         overflow: TextOverflow.ellipsis,
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),
                                            const SizedBox(width: 4),
                                            frostedBlack(
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: customText(
                                                  model.value?.createdAt == null
                                                      ? ''
                                                      : timeago
                                                          .format(Timestamp.fromDate(
                                                                  DateTime.parse(
                                                                      '${model.value!.createdAt}'))
                                                              .toDate())
                                                          .toString(),
                                                  //   '${getWhen(model!.createdAt)}',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: CupertinoColors
                                                          .lightBackgroundGray
                                                      // color: Theme.of(context)
                                                      //     .colorScheme
                                                      //     .onPrimary,
                                                      ),
                                                  //style: userNameStyle
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  model.value!.ductComment == null ||
                                          model.value!.ductComment == ''
                                      ? Container()
                                      : GestureDetector(
                                          onTap: () {
                                            if (storylist!.isNotEmpty) {
                                              // showModalBottomSheet(
                                              //     backgroundColor: Colors.red,
                                              //     // bounce: true,
                                              //     context: context,
                                              //     builder: (context) =>
                                              //         MainStoryResponsiveView(
                                              //             model: model.value,
                                              //             storylist:
                                              //                 storylist));
                                            }
                                          },
                                          child: SizedBox(
                                            width: context.responsiveValue(
                                                mobile: Get.width * 0.7,
                                                tablet: Get.width * 0.4,
                                                desktop: Get.width * 0.4),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  frostedWhite(
                                                    Container(
                                                      // margin:
                                                      //     const EdgeInsets.only(top: 30),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.black
                                                            .withOpacity(.5),
                                                      ),
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 8),
                                                          child: Linkify(
                                                              onOpen:
                                                                  (link) async {
                                                                if (await canLaunchUrl(
                                                                    Uri.parse(link
                                                                        .url))) {
                                                                  await launchURL(
                                                                      link.url);
                                                                } else {
                                                                  throw 'Could not launch $link';
                                                                }
                                                              },
                                                              text:
                                                                  '${model.value!.ductComment}',
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      0xFFF3BB1C),
                                                                  fontSize:
                                                                      descriptionFontSize,
                                                                  fontWeight:
                                                                      descriptionFontWeight),
                                                              linkStyle: TextStyle(
                                                                  color: Colors
                                                                      .blueGrey))),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // const SizedBox(width: 10),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}

// ignore: must_be_immutable
class _ProductDuctBody extends HookWidget {
  final FeedModel? model;
  final Widget? trailing;
  final DuctType? type;
  final FeedState? state;
  final bool? isDisplayOnProfile;
  _ProductDuctBody(
      {Key? key,
      this.model,
      this.trailing,
      this.type,
      this.isDisplayOnProfile,
      this.state})
      : super(key: key);

  var quantity = 1.obs;
  String sizeValue = "";
  String colorValue = "";
  bool? editProduct;
  String? image, name;
  String? selectedColor;
  var itemDetails;

  void onTapDuct(
    BuildContext context,
  ) {
    if (type == DuctType.Detail || type == DuctType.ParentDuct) {
      return;
    }
    if (model!.caption == 'product') {
      feedState.getpostDetailFromDatabase(null, model: model);
      feedState.setDuctToReply = model.obs;
      showModalBottomSheet(
          backgroundColor: Colors.red,
          // bounce: true,
          context: context,
          builder: (context) => ProductStoryView(
                model: model,
              ));
    } else {
      feedState.getpostDetailFromDatabase(null, model: model);
      feedState.setDuctToReply = model.obs;
    }
  }

  ViewductsUser? user;
  getData() async {
    try {
      final database = Databases(
        clientConnect(),
      );

      await database
          .getDocument(
              databaseId: databaseId,
              collectionId: profileUserColl,
              documentId: model!.commissionUser.toString())
          .then((ductUser) {
        // Map map = data.toMap();

        // var value =
        //     data.data.map((e) => ViewductsUser.fromJson(e.data));
        //data.documents;
        user = ViewductsUser.fromJson(ductUser.data);
        // cprint('${data.documents.map((e) => FeedModel.fromJson(e.data))}');
        //cprint('${productlist?.value.map((e) => e.key)}');
      });
      //snap.documents;
    } on AppwriteException catch (e) {
      cprint("$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    getData();
    double descriptionFontSize = type == DuctType.Duct
        ? 15
        : type == DuctType.Detail || type == DuctType.ParentDuct
            ? 18
            : 14;
    FontWeight descriptionFontWeight =
        type == DuctType.Duct || type == DuctType.Duct
            ? FontWeight.w400
            : FontWeight.w400;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //SizedBox(width: 1),
          frostedBlueGray(
            SizedBox(
              width: context.responsiveValue(
                  mobile: Get.width * 0.85,
                  tablet: Get.width * 0.45,
                  desktop: Get.width * 0.4),
              //  height: fullWidth(context) * 0.6,
              child: Stack(
                children: [
                  SizedBox(
                    width: context.responsiveValue(
                        mobile: Get.width * 0.85,
                        tablet: Get.width * 0.45,
                        desktop: Get.width * 0.4),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Stack(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Stack(
                                    children: [
                                      Material(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        elevation: 20,
                                        child: SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: GestureDetector(
                                            onTap: () {
                                              ViewductsUser models;
                                              models = searchState.userlist!
                                                  .firstWhere(
                                                      (x) =>
                                                          x.userId ==
                                                          model?.userId,
                                                      orElse: () =>
                                                          ViewductsUser());
                                              chatState.setChatUser = models;
                                              // If tweet is displaying on someone's profile then no need to navigate to same user's profile again.
                                              // if (isDisplayOnProfile!) {
                                              //   return;
                                              // }
                                              Get.to(() =>
                                                  ProfileResponsiveView(
                                                    profileId: model?.userId,
                                                    profileType:
                                                        ProfileType.Store,
                                                  ));
                                              // Navigator.of(context).pushNamed(
                                              //     '/ProfilePage/' + model?.userId);
                                            },
                                            child: customImage(
                                                context, user?.profilePic),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: user?.isVerified == true
                                            ? Material(
                                                elevation: 10,
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: CircleAvatar(
                                                  radius: 9,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  child: Image.asset(
                                                      'assets/delicious.png'),
                                                ),
                                              )
                                            : Container(),
                                      )
                                    ],
                                  ),
                                  const Spacer(),
                                  Container(
                                      child: trailing ?? const SizedBox()),
                                ],
                              ),
                              Positioned(
                                left: fullWidth(context) * 0.2,
                                child: SizedBox(
                                  width: fullWidth(context) * 0.8,
                                  height: fullWidth(context) * 0.2,
                                  child: DuctIconsRow(
                                    type: type,
                                    model: model,
                                    isDuctDetail: type == DuctType.Detail,
                                    iconColor: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .color,
                                    iconEnableColor: TwitterColor.ceriseRed,
                                    size: 20,
                                    postId: model!.key,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                                minWidth: 0, maxWidth: fullWidth(context) * .5),
                            child: Row(
                              children: [
                                TitleText(user!.displayName,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    overflow: TextOverflow.ellipsis),
                                user!.isVerified == true
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    const SizedBox(width: 3),
                                    model!.user!.isVerified == true
                                        ? customIcon(
                                            context,
                                            icon: AppIcon.blueTick,
                                            istwitterIcon: true,
                                            iconColor: AppColor.primary,
                                            size: 9,
                                            paddingIcon: 3,
                                          )
                                        : const SizedBox(width: 0),
                                    SizedBox(
                                      width: model!.user!.isVerified! ? 5 : 0,
                                    ),
                                    frostedTeal(
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: customText(
                                          getChatTime(model!.createdAt),
                                          style: const TextStyle(
                                              color: CupertinoColors
                                                  .lightBackgroundGray
                                              //  Theme.of(context)
                                              //     .colorScheme
                                              //     .onPrimary,
                                              ),
                                          //style: userNameStyle
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: context.responsiveValue(
                                mobile: Get.width * 0.85,
                                tablet: Get.width * 0.45,
                                desktop: Get.width * 0.4),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  frostedBlack(
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: UrlText(
                                        text: model!.ductComment,
                                        onHashTagPressed: (tag) {
                                          cprint(tag);
                                        },
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                            fontSize: descriptionFontSize,
                                            fontWeight: descriptionFontWeight),
                                        urlStyle: TextStyle(
                                            color: Colors.blue,
                                            fontSize: descriptionFontSize,
                                            fontWeight: descriptionFontWeight),
                                      ),
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
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}

class DuctPostBar extends StatefulWidget {
  const DuctPostBar({Key? key, this.list}) : super(key: key);

  final RxList<DuctStoryModel>? list;
  @override
  _DuctPostBarState createState() => _DuctPostBarState();
}

class _DuctPostBarState extends State<DuctPostBar> {
  int? count;
  double spacing = 4;

  @override
  void initState() {
    super.initState();

    int count = widget.list!.length;
    spacing = (count > 15) ? 1 : ((count > 10) ? 2 : 4);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: widget.list!.map((it) {
          return Expanded(
            child: Container(
              padding:
                  EdgeInsets.only(right: widget.list!.last == it ? 0 : spacing),
              child: const DuctProgressIndicator(
                1,
                indicatorHeight: 3,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class OrderPostBar extends StatefulWidget {
  const OrderPostBar({Key? key, this.list}) : super(key: key);

  final List<OrderItemModel>? list;
  @override
  _OrderPostBarState createState() => _OrderPostBarState();
}

class _OrderPostBarState extends State<OrderPostBar> {
  int? count;
  double spacing = 4;

  @override
  void initState() {
    super.initState();

    int count = widget.list!.length;
    spacing = (count > 15) ? 1 : ((count > 10) ? 2 : 4);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.list!.map((it) {
        return Expanded(
          child: Container(
            padding:
                EdgeInsets.only(right: widget.list!.last == it ? 0 : spacing),
            child: const DuctProgressIndicator(
              1,
              indicatorHeight: 3,
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Custom progress bar. Supposed to be lighter than the
/// original [ProgressIndicator], and rounded at the sides.
class DuctProgressIndicator extends StatelessWidget {
  /// From `0.0` to `1.0`, determines the progress of the indicator
  final double value;
  final double indicatorHeight;

  const DuctProgressIndicator(
    this.value, {
    this.indicatorHeight = 5,
  }) : assert(indicatorHeight > 0,
            "[indicatorHeight] should not be null or less than 1");

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.fromHeight(
        indicatorHeight,
      ),
      foregroundPainter: IndicatorOval(
        CupertinoColors.darkBackgroundGray,
        value,
      ),
      painter: IndicatorOval(
        Colors.red.shade200,
        1.0,
      ),
    );
  }
}

class IndicatorOval extends CustomPainter {
  final Color color;
  final double widthFactor;

  IndicatorOval(this.color, this.widthFactor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(0, 0, size.width * widthFactor, size.height),
            const Radius.circular(3)),
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

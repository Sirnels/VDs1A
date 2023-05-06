// ignore_for_file: file_names, prefer_typing_uninitialized_variables, deprecated_member_use, unused_local_variable

import 'dart:convert';
import 'dart:io';

//import 'package:emoji_picker/emoji_picker.dart';
import 'package:appwrite/appwrite.dart';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
//import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:viewducts/helper/constant.dart';

import 'package:viewducts/helper/enum.dart';
import 'package:viewducts/helper/theme.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:viewducts/page/feed/videoViewer.dart';
import 'package:viewducts/page/responsiveView.dart';
import 'package:viewducts/state/authState.dart';
import 'package:viewducts/state/feedState.dart';
import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/frosted.dart';

import '../../customWidgets.dart';

// ignore: must_be_immutable
class DuctImage extends HookWidget {
  DuctImage(
      {Key? key,
      this.model,
      this.type,
      this.isVductImage = false,
      this.isDisplayOnProfile,
      this.commissionProduct,
      this.storylist,
      this.playState})
      : super(key: key);
  final RxList<DuctStoryModel>? storylist;
  final FeedModel? model;
  final DuctType? type;
  final bool isVductImage;
  final bool? isDisplayOnProfile;
  final FeedState? playState;
  final FeedModel? commissionProduct;

  String? ductId;

  var isDropdown = false.obs;
  double? height, width, xPosiion, yPosition;
  late OverlayEntry floatingMenu;
  bool typing = false;

  // String senderId;

  String? userImage;

  bool? isContinuing;

  FocusNode textFieldFocus = FocusNode();

  FocusNode imageTextFieldFocus = FocusNode();

  //ChatState state = ChatState();

  // AuthState authState = AuthState();

  //FeedState feedState = FeedState();

  ValueNotifier<bool> isSelected = ValueNotifier(false);

  String? chatUserProductId, myOrders;

  String? peerAvatar, peerNo, currentUserNo, privateKey, sharedSecret;

  bool? locked, hidden;

  int? chatStatus, unread;

  GlobalKey? actionKey;

  dynamic lastSeen;

  String? chatId;

  bool isWriting = false;

  bool showEmojiPicker = false;

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
  String sizeValue = "";
  String colorValue = "";
  bool? editProduct;
  String? image, name;
  String? selectedColor;
  var itemDetails;
  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ValueNotifier<bool> imageNotready = ValueNotifier(false);
  bool isToolAvailable = true;
  bool isMyProfile = false;
  final GlobalKey<State> keyLoader = GlobalKey<State>();
  List<dynamic>? size;
  FeedState? productState;

  // var playstate;
  // @override
  // void initState() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     // var authState = Provider.of<AuthState>(context, listen: false);
  //     // authState.getProfileUser(userProfileId: profileId);
  //     // isMyProfile =
  //     //     profileId == null || profileId == authState.userId;
  //    // final state = Provider.of<AuthState>(context, listen: false);

  //  //   senderId = state.userId;

  //    // playstate = Provider.of<FeedState>(context, listen: false);
  //    // _focusNode = FocusNode();
  //    // _textEditingController = TextEditingController();
  //     // _videoController = VideoPlayerController.network(model.videoPath);
  //     // _initializeVideoplayerfuture =
  //     //     _videoController.initialize().then((value) {
  //     //   setState(() {});
  //     //   _videoController.play();
  //     // });
  //   });

  //   super.initState();
  // }

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
    showEmojiPicker = false;
  }

  showEmojiContainer() {
    showEmojiPicker = true;
  }

  void onLongPressedTweet(BuildContext context) {
    if (type == DuctType.Detail || type == DuctType.ParentDuct) {
      var text = ClipboardData(text: model!.ductComment);
      Clipboard.setData(text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: TwitterColor.black,
          content: Text(
            'Duct copied to clipboard',
          ),
        ),
      );
    }
  }

  void onTapDuct(BuildContext context, List<FeedModel> commissionProduct) {
    // var feedState = Provider.of<FeedState>(context, listen: false);
    if (type == DuctType.Detail || type == DuctType.ParentDuct) {
      return;
    }
    if (type == DuctType.Duct && !isDisplayOnProfile!) {
      feedState.clearAllDetailAndReplyDuctStack();
    }
    // if (model.caption == 'product') {
    //   var state = Provider.of<FeedState>(context, listen: false);
    //   state.getpostDetailFromDatabase(null, model: model);
    //   // state.getpostDetailFromDatabase(model.key);
    //   state.setDuctToReply = model;

    //   // Navigator.pushNamed(context, '/ItemDetailspage');

    //   //_videoView(context);
    //   setState(() {
    //     if (isDropdown.value) {
    //       floatingMenu.remove();
    //     } else {
    //       //  _postProsductoption();
    //       floatingMenu = _mediaView(context, state);
    //       Overlay.of(context).insert(floatingMenu);
    //     }

    //     isDropdown.value = !isDropdown.value;
    //   });
    // }
    else {
      // feedState.getpostDetailFromDatabase(null, model: model);
      // Navigator.of(context).pushNamed('/FeedPostDetail/' + model.key);
      feedState.getpostDetailFromDatabase(null, model: model);
      feedState.setDuctToReply = model.obs;

      // Navigator.pushNamed(context, '/ItemDetailspage');

      //_videoView(context);

      if (isDropdown.value) {
        floatingMenu.remove();
      } else {
        //  _postProsductoption();
        // floatingMenu = _ductView(context, feedState, commissionProduct);
        Overlay.of(context).insert(floatingMenu);
      }

      isDropdown.value = !isDropdown.value;
    }
  }

  setSizeOptions(String size) {
    sizeValue = size;
  }

  setProductData(FeedState state) {
    //itemDetails = ModalRoute.of(context)!.settings.arguments;

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
    if (sizeValue == '' && sizeValue.isNotEmpty) {
      Get.snackbar("Size", 'Select size');
    } else if (colorValue == '' &&
        _shoppingBagService.ductDetailModel!.last!.colors!.isNotEmpty) {
      Get.snackbar("Color", 'Select color');
    } else {
      String msg = await _shoppingBagService.addProductTocart(
        itemDetails['productId'],
        sizeValue,
        colorValue,
        quantity.value,
        authState.userId,
        model!.user!.userId,
      );
      Get.snackbar("Product", msg);
//Navigator.of(keyLoader.currentContext, rootNavigator: true).pop();
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

      // Loader.showLoadingScreen(context, keyLoader);
    }
  }

//   Widget _bottomEntryField() {
//     setWritingTo(bool val) {
//       isWriting = val;
//     }

//     return Align(
//       alignment: Alignment.bottomLeft,
//       child: Container(
//         padding: const EdgeInsets.all(10),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: <Widget>[
//                   Expanded(
//                     child: Stack(
//                       alignment: Alignment.centerRight,
//                       children: [
//                         frostedOrange(
//                           TextField(
//                             controller: textEditingController,
//                             focusNode: textFieldFocus,
//                             onTap: () => hideEmojiContainer(),
//                             style: const TextStyle(
//                               color: Colors.black,
//                             ),
//                             onChanged: (val) {
//                               (val.isNotEmpty && val.trim() != "")
//                                   ? setWritingTo(true)
//                                   : setWritingTo(false);
//                             },
//                             maxLines: null,
//                             decoration: const InputDecoration(
//                               hintText: "Say Something",
//                               hintStyle: TextStyle(color: Colors.white
// //color: UniversalVariables.greyColor,
//                                   ),
//                               border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.all(
//                                     Radius.circular(50.0),
//                                   ),
//                                   borderSide: BorderSide.none),
//                               contentPadding: EdgeInsets.symmetric(
//                                   horizontal: 20, vertical: 5),
//                               filled: true,
// //fillColor: UniversalVariables.separatorColor,
//                             ),
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             // if (!showEmojiPicker) {
//                             //   // keyboard is visible
//                             //   hideKeyboard();
//                             //   showEmojiContainer();
//                             // } else {
//                             //   //keyboard is hidden
//                             //   showKeyboard();
//                             //   hideEmojiContainer();
//                             // }
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Material(
//                               elevation: 5,
//                               borderRadius: BorderRadius.circular(100),
//                               child: CircleAvatar(
//                                 radius: 12,
//                                 backgroundColor: Colors.transparent,
//                                 child: Image.asset('assets/happy (1).png'),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   isWriting
//                       ? Container(
//                           margin: const EdgeInsets.only(left: 10),
//                           decoration: const BoxDecoration(
//                               color: Colors.blueGrey,
//                               //  gradient: UniversalVariables.fabGradient,
//                               shape: BoxShape.circle),
//                           child: IconButton(
//                               icon: const Icon(
//                                 Icons.send,
//                                 color: Colors.white,
//                               ),
//                               onPressed: () {
//                                 _submitButton(Get.context!);
//                               }
//                               //  statusInit == ChatStatus.blocked.index
//                               //     ? null
//                               //     : () => ductId != null
//                               //         ? submitMessage(
//                               //             textEditingController.text,
//                               //             MessagesType.Products,
//                               //             DateTime.now().millisecondsSinceEpoch,
//                               //             ductId,
//                               //           )
//                               //         : chatUserProductId != null
//                               //             ? submitMessage(
//                               //                 textEditingController.text,
//                               //                 MessagesType.ChatUserProducts,
//                               //                 DateTime.now()
//                               //                     .millisecondsSinceEpoch,
//                               //                 chatUserProductId,
//                               //               )
//                               //             : myOrders != null
//                               //                 ? submitMessage(
//                               //                     textEditingController.text,
//                               //                     MessagesType.MyOrders,
//                               //                     DateTime.now()
//                               //                         .millisecondsSinceEpoch,
//                               //                     myOrders,
//                               //                   )
//                               //                 : _image != null
//                               //                     ? submitMessage(
//                               //                         textEditingController.text,
//                               //                         MessagesType.Image,
//                               //                         DateTime.now()
//                               //                             .millisecondsSinceEpoch,
//                               //                         null,
//                               //                       )
//                               //                     : submitMessage(
//                               //                         textEditingController.text,
//                               //                         MessagesType.Text,
//                               //                         DateTime.now()
//                               //                             .millisecondsSinceEpoch,
//                               //                         null,
//                               //                       ),
//                               //    color: viewductWhite,
//                               ),
//                         )
//                       : Container()
//                 ],
//               ),
//               showEmojiPicker ? Container(child: emojiContainer()) : Container()
//             ],
//           ),
//         ),
//         width: double.infinity,
// //height: 100.0,
//       ),
//     );
//   }

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
              //     setState(() {
              //       isWriting = true;
              //     });

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

  void addLikeToDuct(BuildContext context) {
    // var state = Provider.of<FeedState>(context, listen: false);
    // var authState = Provider.of<AuthState>(context, listen: false);
    feedState.addLikeToDuct(model!, authState.userId, model!.key);
  }

  void onLikeTextPressed(BuildContext context) {
    // Navigator.of(context).push(
    //   CustomRoute<bool>(
    //     builder: (BuildContext context) => UsersListPage(
    //       pageTitle: "Liked by",
    //       userIdsList: model!.likeList!.map((userId) => userId).toList(),
    //       emptyScreenText: "This tweet has no like yet",
    //       emptyScreenSubTileText:
    //           "Once a user likes this tweet, user list will be shown here",
    //     ),
    //   ),
    // );
  }

  // Widget _commentRow(FeedModel model, BuildContext context) {
  //   return chatMessages(model, context);
  // }

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

  // Widget chatMessages(
  //   FeedModel message,
  //   BuildContext context,
  // ) {
  //   // if (senderId == null) {
  //   //   return Container();
  //   // }
  //   if (message.userId == authState.user!.uid) {
  //     return _userComments(message, true);
  //   } else {
  //     return _userComments(message, false);
  //   }
  // }

  // Widget _userComments(FeedModel comment, bool myMessage) {
  //   return Column(
  //     crossAxisAlignment:
  //         myMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
  //     mainAxisAlignment:
  //         myMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
  //     children: <Widget>[
  //       Row(
  //         crossAxisAlignment: CrossAxisAlignment.end,
  //         children: <Widget>[
  //           const SizedBox(
  //             width: 15,
  //           ),
  //           myMessage
  //               ? const SizedBox()
  //               : CircleAvatar(
  //                   backgroundColor: Colors.transparent,
  //                   backgroundImage:
  //                       customAdvanceNetworkImage(comment.user!.profilePic),
  //                 ),
  //           Expanded(
  //             child: Container(
  //               alignment:
  //                   myMessage ? Alignment.centerRight : Alignment.centerLeft,
  //               margin: EdgeInsets.only(
  //                 right: myMessage ? 10 : (fullWidth(context) / 4),
  //                 top: 20,
  //                 left: myMessage ? (fullWidth(context) / 4) : 10,
  //               ),
  //               child: Stack(
  //                 children: <Widget>[
  //                   Container(
  //                     padding: const EdgeInsets.all(10),
  //                     decoration: BoxDecoration(
  //                       borderRadius: getBorder(myMessage),
  //                       color: myMessage ? Colors.grey : TwitterColor.mystic,
  //                     ),
  //                     child: UrlText(
  //                       text: comment.ductComment,
  //                       style: TextStyle(
  //                         fontSize: 16,
  //                         color: myMessage ? TwitterColor.white : Colors.black,
  //                       ),
  //                       urlStyle: TextStyle(
  //                         fontSize: 16,
  //                         color: myMessage
  //                             ? TwitterColor.white
  //                             : TwitterColor.dodgetBlue,
  //                         decoration: TextDecoration.underline,
  //                       ),
  //                     ),
  //                   ),
  //                   Positioned(
  //                     top: 0,
  //                     bottom: 0,
  //                     right: 0,
  //                     left: 0,
  //                     child: InkWell(
  //                       borderRadius: getBorder(myMessage),
  //                       onTap: () {
  //                         // onTapDuct(context);
  //                         // var text = ClipboardData(text: chat.ductComment);
  //                         // Clipboard.setData(text);
  //                         // _scaffoldKey.currentState.hideCurrentSnackBar();
  //                         // _scaffoldKey.currentState.showSnackBar(
  //                         //   SnackBar(
  //                         //     backgroundColor: TwitterColor.white,
  //                         //     content: Text(
  //                         //       'Message copied',
  //                         //       style: TextStyle(color: Colors.black),
  //                         //     ),
  //                         //   ),
  //                         // );
  //                       },
  //                       child: const SizedBox(),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),

  //       customText(getPostTime2(comment.createdAt),
  //           style: const TextStyle(color: Colors.yellow)
  //           // Theme.of(context).textTheme.caption.copyWith(fontSize: 12),
  //           )
  //       // Padding(
  //       //   padding: EdgeInsets.only(right: 10, left: 10),
  //       //   child: Text(
  //       //     getChatTime(chat.createdAt),
  //       //     style: Theme.of(context).textTheme.caption.copyWith(fontSize: 12),
  //       //   ),
  //       // )
  //     ],
  //   );
  // }

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
  // void _submitButton(BuildContext context) async {
  //   if (textEditingController.text.isEmpty ||
  //       textEditingController.text.length > 280) {
  //     return;
  //   }

  //   FeedModel tweetModel = createTweetModel();
  //   feedState.addcommentToPost(tweetModel);

  //   /// Checks for username in tweet ductComment
  //   /// If foud sends notification to all tagged user
  //   /// If no user found or not compost tweet screen is closed and redirect back to home page.
  //   await composeductState.sendNotification(tweetModel, searchState).then((_) {
  //     textEditingController.clear();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Storage storage = Storage(clientConnect());
    imageStream() async {
      return CachedMemoryImage(
        uniqueKey: '${model!.imagePath}',
        fit: BoxFit.cover,
        bytes: await storage.getFilePreview(
            bucketId: ductFile, fileId: '${model!.imagePath}'),
      );
    }

    final future = useMemoized(() => imageStream());
    final snapShotImage = useFuture(future);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      alignment: Alignment.centerRight,
      child: model!.imagePath == null
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.only(
                top: 8,
              ),
              child: InkWell(
                borderRadius: BorderRadius.all(
                  Radius.circular(isVductImage ? 10 : 20),
                ),
                onTap: () {
                  // DateFormat("E").format(DateTime.now()) == 'Sun'
                  //     ? Container()
                  //     : showModalBottomSheet(
                  //         backgroundColor: Colors.red,
                  //         //bounce: true,
                  //         context: context,
                  //         builder: (context) => MainStoryResponsiveView(
                  //               model: model,
                  //               storylist: storylist,
                  //             ));
                },
                child: frostedYellow(
                  ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(isVductImage ? 0 : 20),
                    ),
                    child: SizedBox(
                      width: fullWidth(context) *
                              (type == DuctType.Detail ? .95 : .8) -
                          8,
                      height: fullWidth(context) *
                              (type == DuctType.Detail ? .95 : .6) -
                          8,
                      //decoration: BoxDecoration(),
                      child: AspectRatio(
                          aspectRatio: 4 / 3,
                          child: customNetworkImage(model!.imagePath.toString(),
                              fit: BoxFit.cover)
                          // snapShotImage.hasData
                          //     ? SizedBox.expand(
                          //         child: snapShotImage.data,
                          //       )
                          //     : Center(
                          //         child: LoadingIndicator(
                          //             indicatorType: Indicator.ballTrianglePath,

                          //             /// Required, The loading type of the widget
                          //             colors: const [
                          //               Colors.pink,
                          //               Colors.green,
                          //               Colors.blue
                          //             ],

                          //             /// Optional, The color collections
                          //             strokeWidth: 0.5,

                          //             /// Optional, The stroke of the line, only applicable to widget which contains line
                          //             backgroundColor: Colors.transparent,

                          //             /// Optional, Background of the widget
                          //             pathBackgroundColor: Colors.blue

                          //             /// Optional, the stroke backgroundColor
                          //             )
                          //         //  CircularProgressIndicator
                          //         //     .adaptive()
                          //         )
                          //  }),
                          ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class VideoImage extends HookWidget {
  VideoImage(
      {Key? key,
      this.model,
      this.type,
      this.isVductImage = false,
      this.storylist})
      : super(key: key);
  final RxList<DuctStoryModel>? storylist;
  final FeedModel? model;
  final DuctType? type;
  final bool isVductImage;

  @override
  Widget build(BuildContext context) {
    Storage storage = Storage(clientConnect());
    imageStream() async {
      return CachedMemoryImage(
        uniqueKey: '${model!.imagePath}',
        fit: BoxFit.contain,
        bytes: await storage.getFilePreview(
            bucketId: ductFile, fileId: '${model!.imagePath}'),
      );
    }

    final future = useMemoized(() => imageStream());
    final snapShotImage = useFuture(future);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      alignment: Alignment.centerRight,
      child: model!.imagePath == null
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.only(
                top: 8,
              ),
              child: InkWell(
                borderRadius: BorderRadius.all(
                  Radius.circular(isVductImage ? 10 : 20),
                ),
                onTap: () {
                  // DateFormat("E").format(DateTime.now()) == 'Sun'
                  //     ? Container()
                  //     : showModalBottomSheet(
                  //         backgroundColor: Colors.red,
                  //         //bounce: true,
                  //         context: context,
                  //         builder: (context) => MainStoryResponsiveView(
                  //               model: model,
                  //               storylist: storylist,
                  //             ));
                },
                child: Stack(
                  children: [
                    frostedYellow(
                      ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(isVductImage ? 0 : 20),
                        ),
                        child: SizedBox(
                          width: fullWidth(context) *
                                  (type == DuctType.Detail ? .95 : .8) -
                              8,
                          height: fullWidth(context) *
                                  (type == DuctType.Detail ? .95 : .6) -
                              8,
                          //decoration: BoxDecoration(),
                          child: AspectRatio(
                              aspectRatio: 4 / 3,
                              child: snapShotImage.hasData
                                  ? SizedBox.expand(
                                      child: snapShotImage.data,
                                    )
                                  : Center(
                                      child: LoadingIndicator(
                                          indicatorType:
                                              Indicator.ballTrianglePath,

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
                                          )
                                      //  CircularProgressIndicator
                                      //     .adaptive()
                                      )
                              //  }),
                              ),
                        ),
                      ),
                    ),
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
                          child: Icon(CupertinoIcons.play_circle_fill)),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

// ignore: must_be_immutable
class ProductDuctImage extends StatelessWidget {
  ProductDuctImage({
    Key? key,
    this.model,
    this.type,
    this.isVductImage = false,
    this.isDisplayOnProfile,
    this.currentUser,
    this.vendor,
  }) : super(key: key);
  final ViewductsUser? currentUser;
  final ViewductsUser? vendor;
  final FeedModel? model;
  final DuctType? type;
  final bool isVductImage;
  final bool? isDisplayOnProfile;
//   @override
//   _ProductDuctImageState createState() => _ProductDuctImageState();
// }
//
// class _ProductDuctImageState extends State<ProductDuctImage> {
  String? ductId;

  var isDropdown = false.obs;
  double? height, width, xPosiion, yPosition;

  bool typing = false;

  String? senderId;

  String? userImage;

  bool? isContinuing;

  FocusNode textFieldFocus = FocusNode();

  FocusNode imageTextFieldFocus = FocusNode();

  //ChatState state = ChatState();

  AuthState authState = AuthState();

  FeedState feedState = FeedState();

  ValueNotifier<bool> isSelected = ValueNotifier(false);

  String? chatUserProductId, myOrders;

  String? peerAvatar, peerNo, currentUserNo, privateKey, sharedSecret;

  bool? locked, hidden;

  int? chatStatus, unread;

  GlobalKey? actionKey;

  dynamic lastSeen;

  String? chatId;

  bool isWriting = false;

  bool showEmojiPicker = false;

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
  String sizeValue = "";
  String colorValue = "";
  bool? editProduct;
  String? image, name;
  String? selectedColor;
  var itemDetails;
  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ValueNotifier<bool> imageNotready = ValueNotifier(false);
  bool isToolAvailable = true;
  bool isMyProfile = false;

  final GlobalKey<State> keyLoader = GlobalKey<State>();
  List<dynamic>? size;
  FeedState? productState;
  //FeedModel? model;

  @override
  Widget build(BuildContext context) {
    // final List<FeedModel>? commissionProduct =
    //     feedState.commissionProducts(authState.userModel, model!.cProduct);
    // Storage storage = Storage(clientConnect());
    // Image? url;
    // storage
    //     .getFileView(
    //         bucketId: productBucketId, fileId: model!.imagePath.toString())
    //     .then((bytes) {
    //   url = Image.memory(bytes);
    // });
    Storage storage = Storage(clientConnect());
    // imageStream() async {
    //   return CachedMemoryImage(
    //     uniqueKey: model!.imagePath.toString(),
    //     fit: BoxFit.contain,
    //     bytes: await storage.getFilePreview(
    //         bucketId: productBucketId, fileId: model!.imagePath.toString()),
    //   );
    // }

    // final future = useMemoized(() => imageStream());
    // final snapShotImage = useFuture(future);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      alignment: Alignment.centerRight,
      child: model!.imagePath == null
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.only(
                top: 8,
              ),
              child: InkWell(
                borderRadius: BorderRadius.all(
                  Radius.circular(isVductImage ? 10 : 20),
                ),
                onTap: () {
                  kIsWeb
                      ? Container()
                      // : DateFormat("E").format(DateTime.now()) == 'Sun'
                      //     ? Container()
                      : showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: Colors.red,
                          //bounce: true,
                          context: context,
                          builder: (context) => Container(
                                height: fullHeight(context) * 0.96,
                                width: fullWidth(context),
                                child: ProductResponsiveView(
                                    model: model,
                                    currentUser: currentUser,
                                    vendor: vendor),
                              ));
                  //  _opTions(context);
                  //  onTapDuct(context, commissionProduct);

                  // if (type == DuctType.ParentDuct) {
                  //   return;
                  // }
                  //
                  // feedState.getpostDetailFromDatabase(null,
                  //     model: model);
                  //
                  // feedState.setDuctToReply = model.obs;
                  //
                  //
                  // if (isDropdown.value) {
                  //   floatingMenu.remove();
                  // } else {
                  //
                  //   floatingMenu = _mediaView(context, feedState);
                  //   Overlay.of(context)!.insert(floatingMenu);
                  // }
                  //
                  // isDropdown.value = !isDropdown.value;
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(isVductImage ? 0 : 5),
                  ),
                  child: Material(
                    elevation: 20,
                    child: Stack(
                      children: [
                        SizedBox(
                            width: fullWidth(context) *
                                    (type == DuctType.Detail ? .95 : .8) -
                                8,
                            height: fullWidth(context) *
                                    (type == DuctType.Detail ? .95 : .5) -
                                8,
                            //decoration: BoxDecoration(),
                            child: AspectRatio(
                              aspectRatio: 4 / 3,
                              child:
                                  // FutureBuilder(
                                  //     future: storage.getFileView(
                                  //         bucketId: productBucketId,
                                  //         fileId: model!.imagePath.toString()),
                                  //     builder: (context, snap) {
                                  //       return
                                  FutureBuilder(
                                future: storage.getFileView(
                                  bucketId: productBucketId,
                                  fileId: model!.imagePath.toString(),
                                ), //works for both public file and private file, for private files you need to be logged in
                                builder: (context, snapshot) {
                                  return snapshot.hasData &&
                                          snapshot.data != null
                                      ? Image.memory(snapshot.data as Uint8List,
                                          width: Get.height * 0.3,
                                          height: Get.height * 0.4,
                                          fit: BoxFit.contain)
                                      : Center(
                                          child: SizedBox(
                                          width: Get.height * 0.2,
                                          height: Get.height * 0.2,
                                          child: LoadingIndicator(
                                              indicatorType:
                                                  Indicator.ballTrianglePath,

                                              /// Required, The loading type of the widget
                                              colors: const [
                                                Colors.pink,
                                                Colors.green,
                                                Colors.blue
                                              ],

                                              /// Optional, The color collections
                                              strokeWidth: 0.5,

                                              /// Optional, The stroke of the line, only applicable to widget which contains line
                                              backgroundColor:
                                                  Colors.transparent,

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
                              //     Image.network(
                              //   model!.imagePath.toString(),
                              //   fit: BoxFit.fill,
                              //   loadingBuilder: (BuildContext context,
                              //       Widget child,
                              //       ImageChunkEvent? loadingProgress) {
                              //     if (loadingProgress == null) return child;
                              //     return Center(
                              //         child: LoadingIndicator(
                              //             indicatorType:
                              //                 Indicator.ballTrianglePath,

                              //             /// Required, The loading type of the widget
                              //             colors: const [
                              //               Colors.pink,
                              //               Colors.green,
                              //               Colors.blue
                              //             ],

                              //             /// Optional, The color collections
                              //             strokeWidth: 0.5,

                              //             /// Optional, The stroke of the line, only applicable to widget which contains line
                              //             backgroundColor: Colors.transparent,

                              //             /// Optional, Background of the widget
                              //             pathBackgroundColor: Colors.blue

                              //             /// Optional, the stroke backgroundColor
                              //             )
                              //         //  CircularProgressIndicator
                              //         //     .adaptive()
                              //         );
                              //   },
                              // )

                              // })
                            )
                            // customNetworkImage(model!.imagePath,
                            //     fit: BoxFit.cover),
                            ),

                        // Positioned(
                        //     bottom: 0,
                        //     right: 0,
                        //     child: Container(
                        //       width: fullWidth(context) * 0.2,
                        //       height: fullWidth(context) * 0.08,
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(20),
                        //         color: Colors.blueGrey[50],
                        //         gradient: LinearGradient(
                        //           colors: [
                        //             Colors.black87.withOpacity(0.1),
                        //             Colors.black87.withOpacity(0.2),
                        //             Colors.black87.withOpacity(0.3)
                        //             // Color(0xfffbfbfb),
                        //             // Color(0xfff7f7f7),
                        //           ],
                        //           // begin: Alignment.topCenter,
                        //           // end: Alignment.bottomCenter,
                        //         ),
                        //       ),
                        //       child: Padding(
                        //         padding: const EdgeInsets.symmetric(
                        //             horizontal: 8.0, vertical: 3),
                        //         child: customText(
                        //             '${model!.duration.toString().substring(2, 7)}',
                        //             style: TextStyle(
                        //               color: Colors.black87,
                        //               fontFamily: 'HelveticaNeue',
                        //               fontWeight: FontWeight.w900,
                        //               fontSize: 20,
                        //             )),
                        //       ),
                        //     ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class ProductVideo extends StatelessWidget {
  const ProductVideo(
      {Key? key, this.model, this.type, this.isVductImage = false})
      : super(key: key);

  final FeedModel? model;
  final DuctType? type;
  final bool isVductImage;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      alignment: Alignment.centerRight,
      child: model!.imagePath == null
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.only(
                top: 8,
              ),
              child: InkWell(
                borderRadius: BorderRadius.all(
                  Radius.circular(isVductImage ? 10 : 20),
                ),
                onTap: () {
                  //  var state = Provider.of<FeedState>(context, listen: false);

                  if (type == DuctType.ParentDuct) {
                    return;
                  }

                  feedState.getpostDetailFromDatabase(model!.key);
                  feedState.setDuctToReply = model.obs;

                  Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(seconds: 2),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return ScaleTransition(
                            scale: animation,
                            child: child,
                          );
                        },
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return const ProductVideoViewPge();
                        },
                      ));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(isVductImage ? 0 : 20),
                  ),
                  child: Material(
                    elevation: 20,
                    child: SizedBox(
                      width: fullWidth(context) *
                              (type == DuctType.Detail ? .95 : .8) -
                          8,
                      height: fullWidth(context) *
                              (type == DuctType.Detail ? .95 : .8) -
                          8,
                      //decoration: BoxDecoration(),
                      child: AspectRatio(
                        aspectRatio: 4 / 3,
                        child: customNetworkImage(model!.thumbPath,
                            fit: BoxFit.contain),
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

// ignore_for_file: unused_element, file_names

import 'dart:io';

//import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viewducts/helper/constant.dart';

import 'package:viewducts/helper/enum.dart';
import 'package:viewducts/helper/theme.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/page/profile/profilePage.dart';
import 'package:viewducts/state/feedState.dart';
import 'package:viewducts/state/seen_state.dart';
import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/frosted.dart';
import 'package:viewducts/widgets/newWidget/customUrlText.dart';
import 'package:get/get.dart';
import '../../customWidgets.dart';

class DuctIconsRow extends StatefulWidget {
  final FeedModel? model;
  final Color? iconColor;
  final Color? iconEnableColor;
  final double? size;
  final bool isDuctDetail;
  final DuctType? type;
  final String? postId;
  const DuctIconsRow(
      {Key? key,
      this.model,
      this.iconColor,
      this.iconEnableColor,
      this.size,
      this.isDuctDetail = false,
      this.type,
      this.postId})
      : super(key: key);

  @override
  _DuctIconsRowState createState() => _DuctIconsRowState();
}

class _DuctIconsRowState extends State<DuctIconsRow> {
  final messageController = TextEditingController();

  // String senderId;

  String? userImage;

  bool? isContinuing;

  FocusNode textFieldFocus = FocusNode();

  FocusNode imageTextFieldFocus = FocusNode();

  // ChatState state = ChatState();

  // AuthState authState = AuthState();

  // FeedState feedState = FeedState();

  SeenState? seenState;

  ValueNotifier<bool> isSelected = ValueNotifier(false);

  String? ductId, chatUserProductId, myOrders;

  String? peerAvatar, peerNo, currentUserNo, privateKey, sharedSecret;

  bool? locked, hidden;

  int? chatStatus, unread;

  GlobalKey? actionKey;

  var isDropdown = false.obs;

  double? height, width, xPosiion, yPosition;

  late OverlayEntry floatingMenu;

  dynamic lastSeen;

  String? chatId;

  SharedPreferences? prefs;

  bool isWriting = false;

  var showEmojiPicker = false.obs;

  bool typing = false;

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
  showKeyboard() => textFieldFocus.requestFocus();

  hideKeyboard() => textFieldFocus.unfocus();

  hideEmojiContainer() {
    showEmojiPicker.value = false;
  }

  showEmojiContainer() {
    showEmojiPicker.value = true;
  }

  void _submitButton(BuildContext context) async {
    if (textEditingController.text.isEmpty ||
        textEditingController.text.length > 280) {
      return;
    }
    // var state = Provider.of<FeedState>(context, listen: false);
    //kScreenloader.showLoader(context);

    FeedModel tweetModel = createTweetModel();
    feedState.addcommentToPost(tweetModel);

    /// If tweet contain image
    /// First image is uploaded on firebase storage
    /// After sucessfull image upload to firebase storage it returns image path
    /// Add this image path to tweet model and save to firebase database
    // if (_image != null) {
    //   await state.uploadFile(_image).then((imagePath) {
    //     if (imagePath != null) {
    //       tweetModel.imagePath = imagePath;

    //       /// If type of tweet is new tweet
    //       if (widget.isTweet) {
    //         state.createDuct(tweetModel);
    //       }

    //       /// If type of tweet is  retweet
    //       else if (widget.isRetweet) {
    //         state.createvDuct(tweetModel);
    //       }

    //       /// If type of tweet is new comment tweet
    //       else {
    //         state.addcommentToPost(tweetModel);
    //       }
    //     }
    //   });
    // }

    // /// if duct has a video
    // else if (_video != null && _thumbnail != null) {
    //   await state.uploadFile(_video).then((videoPath) async {
    //     if (videoPath != null) {
    //       tweetModel.videoPath = videoPath;

    //       await state.uploadFile(_thumbnail).then((thumbPath) {
    //         tweetModel.imagePath = thumbPath;
    //       });

    //       tweetModel.duration = _duration.toString();

    //       /// If type of tweet is new tweet
    //       if (widget.isTweet) {
    //         state.createDuct(tweetModel);
    //       }

    //       /// If type of tweet is  retweet
    //       else if (widget.isRetweet) {
    //         state.createvDuct(tweetModel);
    //       }

    //       /// If type of tweet is new comment tweet
    //       else {
    //         state.addcommentToPost(tweetModel);
    //       }
    //     }
    //   });
    // }

    // /// If tweet did not contain image
    // else {
    //   /// If type of tweet is new tweet
    //   if (widget.isTweet) {
    //     state.createDuct(tweetModel);
    //   }

    //   /// If type of tweet is  retweet
    //   else if (widget.isRetweet) {
    //     state.createvDuct(tweetModel);
    //   }

    //   /// If type of tweet is new comment tweet
    //   else {
    //     state.addcommentToPost(tweetModel);
    //   }
    // }

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

  Widget _bottomEntryField() {
    setWritingTo(bool val) {
      setState(() {
        isWriting = val;
      });
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
                  isWriting
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
                                _submitButton(context);
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
              showEmojiPicker.value
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

  OverlayEntry _mediaView(BuildContext contexts, FeedState state) {
    return OverlayEntry(builder: (context) {
      // return Consumer<FeedState>(builder: (context, feedState, child) {

      if (feedState.feedlist != null && feedState.feedlist!.isNotEmpty) {
        // .where((x) => x.userId == id)
        // .toList();
      }
      return GestureDetector(
        onTap: () {},
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
                                // if (_image == null) {
                                //   _image = File(image);
                                // }
                                if (isDropdown.value) {
                                  floatingMenu.remove();
                                } else {
                                  // _postProsductoption();
                                  floatingMenu = _mediaView(context, state);
                                  Overlay.of(context).insert(floatingMenu);
                                }

                                isDropdown.value = !isDropdown.value;
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
                                            state.ductReplyMap[postId] == null
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
                                            .map((x) => _commentRow(x, context))
                                            .toList(),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Divider(color: Colors.white),
                          const Divider(color: Colors.white),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                if (isDropdown.value) {
                                  floatingMenu.remove();
                                } else {
                                  //  _postProsductoption();
                                  floatingMenu = _mediaView(context, state);
                                  Overlay.of(context).insert(floatingMenu);
                                }

                                isDropdown.value = !isDropdown.value;

                                _opTions(context);
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
                                      if (isDropdown.value) {
                                        floatingMenu.remove();
                                      } else {
                                        //  _postProsductoption();
                                        floatingMenu =
                                            _mediaView(context, state);
                                        Overlay.of(context)
                                            .insert(floatingMenu);
                                      }

                                      isDropdown.value = !isDropdown.value;

                                      Get.to(() => ProfilePage(
                                            profileId:
                                                widget.model!.user!.userId,
                                            profileType: ProfileType.Store,
                                          ));
                                      // If tweet is displaying on someone's profile then no need to navigate to same user's profile again.
                                      // if (isDisplayOnProfile) {
                                      //   return;
                                      // }
                                      // Navigator.of(context).pushNamed(
                                      //     '/ProfilePage/' + model?.userId);
                                    },
                                    child: customImage(context,
                                        widget.model!.user!.profilePic),
                                  ),
                                ),
                              ),
                              frostedBlack(
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: UrlText(
                                    text: widget.model!.ductComment,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    urlStyle: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
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
                                  widget.model!.imagePath,
                                  fit: BoxFit.cover,
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
                                  child: customText(widget.model!.price,
                                      // formatter.format(widget.model.price),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: fullWidth(context) * 0.05),
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
  }

  // @override
  // void initState() {
  //   super.initState();
  //   postId = widget.postId;
  //   // final state = Provider.of<AuthState>(context, listen: false);

  //   senderId = authState.userId;
  // }

  // String postId;
  Widget _likeCommentsIcons(BuildContext context, FeedModel model) {
    //var authState = Provider.of<AuthState>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // Row(
            //   children: [
            //     InkWell(
            //         child:
            // Image.asset(
            //           'assets/reshare.png',
            //           width: 25,
            //         ),
            //         onTap: () {
            //           _opTions(context);
            //           // DuctBottomSheet()
            //           //     .openvDuctbottomSheet(context, type, model);
            //         }),
            //     Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Text(
            //         widget.isDuctDetail ? '' : model.vductCount.toString(),
            //       ),
            //     )
            //   ],
            // ),
            // widget.type == DuctType.Detail
            //     ? Container()
            //     : Row(
            //         children: [
            //           InkWell(
            //               child: Image.asset(
            //                 'assets/chatchat.png',
            //                 width: 25,
            //               ),
            //               onTap: () {
            //                 if (widget.type == DuctType.ParentDuct) {
            //                   return;
            //                 }

            //                 feedState.getpostDetailFromDatabase(null,
            //                     model: widget.model);

            //                 feedState.setDuctToReply = widget.model.obs;

            //                 if (isDropdown.value) {
            //                   floatingMenu.remove();
            //                 } else {
            //                   floatingMenu = _mediaView(context, feedState);
            //                   Overlay.of(context).insert(floatingMenu);
            //                 }

            //                 isDropdown.value = !isDropdown.value;
            //               }),
            //           Padding(
            //             padding: const EdgeInsets.all(8.0),
            //             child: Text(
            //               widget.isDuctDetail
            //                   ? ''
            //                   : model.commentCount.toString(),
            //             ),
            //           )
            //         ],
            //       ),
            GestureDetector(
              onTap: () {
                addLikeToDuct(context);
              },
              child: Row(children: [
                model.likeList!.any((userId) => userId == authState.user!.uid)
                    ? Image.asset(
                        'assets/heartlove.png',
                        width: 25,
                      )
                    : Image.asset(
                        'assets/heart.png',
                        width: 25,
                      ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: customText(
                      widget.isDuctDetail ? '' : model.likeCount.toString()),
                ),
              ]),
            ),
          ],
        ),
      ],
    );
  }

  void addLikeToDuct(BuildContext context) {
    // var state = Provider.of<FeedState>(context, listen: false);
    // var authState = Provider.of<AuthState>(context, listen: false);
    feedState.addLikeToDuct(
        widget.model!, authState.user!.uid, widget.model!.key);
  }

  void onLikeTextPressed(BuildContext context) {
    // Navigator.of(context).push(
    //   CustomRoute<bool>(
    //     builder: (BuildContext context) => UsersListPage(
    //       pageTitle: "Liked by",
    //       userIdsList: widget.model!.likeList!.map((userId) => userId).toList(),
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
    if (message.userId == authState.user!.uid) {
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
                  right: myMessage ? 10 : (fullWidth(context) / 4),
                  top: 20,
                  left: myMessage ? (fullWidth(context) / 4) : 10,
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
                        onTap: () {
                          // onTapDuct(context);
                          // var text = ClipboardData(text: chat.ductComment);
                          // Clipboard.setData(text);
                          // _scaffoldKey.currentState.hideCurrentSnackBar();
                          // _scaffoldKey.currentState.showSnackBar(
                          //   SnackBar(
                          //     backgroundColor: TwitterColor.white,
                          //     content: Text(
                          //       'Message copied',
                          //       style: TextStyle(color: Colors.black),
                          //     ),
                          //   ),
                          // );
                        },
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

  void _opTions(
    BuildContext context,
  ) async {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        // double heightFactor = 300 / fullHeight(context);

        return frostedWhite(
          Container(
            padding: const EdgeInsets.only(top: 5, bottom: 0),
            height: fullWidth(context) * 0.6,
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
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Material(
                            borderRadius: BorderRadius.circular(50),
                            elevation: 2,
                            color: Colors.teal,
                            child: frostedYellow(Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: customText('VDucting',
                                  style: const TextStyle(color: Colors.white)),
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
                                    // If tweet is displaying on someone's profile then no need to navigate to same user's profile again.
                                    // if (isDisplayOnProfile) {
                                    //   return;
                                    // }
                                    // Navigator.of(context).pushNamed(
                                    //     '/ProfilePage/' + model?.userId);
                                  },
                                  child: customImage(
                                      context, widget.model!.user!.profilePic),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: fullWidth(context) - 100,
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
                                          text: widget.model!.ductComment,
                                          onHashTagPressed: (tag) {
                                            cprint(tag);
                                          },
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                              //fontSize: descriptionFontSize,
                                              fontWeight: FontWeight.w400),
                                          urlStyle: const TextStyle(
                                              color: Colors.blue,
                                              //fontSize: descriptionFontSize,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            // frostedBlack(
                            //   Padding(
                            //     padding: const EdgeInsets.all(8.0),
                            //     child: UrlText(
                            //       text: widget.model.ductComment,
                            //       style: TextStyle(
                            //         color:
                            //             Theme.of(context).colorScheme.onPrimary,
                            //         fontSize: 14,
                            //         fontWeight: FontWeight.w400,
                            //       ),
                            //       urlStyle: TextStyle(
                            //           color: Colors.blue,
                            //           fontWeight: FontWeight.w400),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        _bottomEntryFieldVduct(),
                      ],
                    )),
                Positioned(
                    right: 5,
                    top: 5,
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
                                widget.model!.imagePath,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _bottomEntryFieldVduct() {
    setWritingTo(bool val) {
      setState(() {
        isWriting = val;
      });
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
                              hintStyle: TextStyle(color: Colors.amber
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
                  // isWriting
                  //     ? Container()
                  //     : Padding(
                  //         padding: EdgeInsets.symmetric(horizontal: 10),
                  //         child: GestureDetector(
                  //           key: actionKey,
                  //           onTap: () {
                  //             // setState(() {
                  //             //   if (isDropdown) {
                  //             //     floatingMenu.remove();
                  //             //   } else {
                  //             //     //  _postProsductoption();
                  //             //     floatingMenu = _createPostMenu(context);
                  //             //     Overlay.of(context).insert(floatingMenu);
                  //             //   }

                  //             //   isDropdown = !isDropdown;
                  //             // });
                  //             //  Navigator.of(context).pushNamed('/CreateFeedPage/tweet');
                  //           },
                  //           // onTap: () {

                  //           //   cprint('is working');
                  //           // },
                  //           child: Icon(
                  //             Icons.record_voice_over,
                  //             color: Colors.teal,
                  //           ),
                  //         ),
                  //       ),
//                   isWriting
//                       ? Container()
//                       : GestureDetector(
//                           child: Icon(
//                             Icons.camera_alt,
//                             color: Colors.cyan,
//                           ),
//                           onTap: () async {
//                             // File file = await ImagePicker.pickImage(
//                             //     source: ImageSource.gallery, imageQuality: 50);
//                             // setState(() {
//                             //   _image = file;
//                             // });
// //imagePreview(context);
//                           }
//                           //=> pickImage(source: ImageSource.camera),
//                           ),
                  isWriting
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
                                _submitButtonVduct(context);
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
              showEmojiPicker.value
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
          width: fullWidth(context),
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

  FeedModel createTweetModel() {
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
            //  widget.isTweet
            //     ? null
            //     : widget.isRetweet
            //         ? null
            //:
            feedState.ductToReplyModel!.value!.key,
        childVductkey:
            //  widget.isTweet
            //     ? null
            //     : widget.isRetweet
            //         ? model.key
            //         :
            null,
        userId: myUser.userId);
    return reply;
  }

  /// Submit tweet to save in firebase database
  void _submitButtonComment(BuildContext context) async {
    if (textEditingController.text.isEmpty ||
        textEditingController.text.length > 280) {
      return;
    }
    // var state = Provider.of<FeedState>(context, listen: false);
    //kScreenloader.showLoader(context);

    FeedModel tweetModel = createTweetModel();
    feedState.addcommentToPost(tweetModel);

    /// If tweet contain image
    /// First image is uploaded on firebase storage
    /// After sucessfull image upload to firebase storage it returns image path
    /// Add this image path to tweet model and save to firebase database
    // if (_image != null) {
    //   await state.uploadFile(_image).then((imagePath) {
    //     if (imagePath != null) {
    //       tweetModel.imagePath = imagePath;

    //       /// If type of tweet is new tweet
    //       if (widget.isTweet) {
    //         state.createDuct(tweetModel);
    //       }

    //       /// If type of tweet is  retweet
    //       else if (widget.isRetweet) {
    //         state.createvDuct(tweetModel);
    //       }

    //       /// If type of tweet is new comment tweet
    //       else {
    //         state.addcommentToPost(tweetModel);
    //       }
    //     }
    //   });
    // }

    // /// if duct has a video
    // else if (_video != null && _thumbnail != null) {
    //   await state.uploadFile(_video).then((videoPath) async {
    //     if (videoPath != null) {
    //       tweetModel.videoPath = videoPath;

    //       await state.uploadFile(_thumbnail).then((thumbPath) {
    //         tweetModel.imagePath = thumbPath;
    //       });

    //       tweetModel.duration = _duration.toString();

    //       /// If type of tweet is new tweet
    //       if (widget.isTweet) {
    //         state.createDuct(tweetModel);
    //       }

    //       /// If type of tweet is  retweet
    //       else if (widget.isRetweet) {
    //         state.createvDuct(tweetModel);
    //       }

    //       /// If type of tweet is new comment tweet
    //       else {
    //         state.addcommentToPost(tweetModel);
    //       }
    //     }
    //   });
    // }

    // /// If tweet did not contain image
    // else {
    //   /// If type of tweet is new tweet
    //   if (widget.isTweet) {
    //     state.createDuct(tweetModel);
    //   }

    //   /// If type of tweet is  retweet
    //   else if (widget.isRetweet) {
    //     state.createvDuct(tweetModel);
    //   }

    //   /// If type of tweet is new comment tweet
    //   else {
    //     state.addcommentToPost(tweetModel);
    //   }
    // }

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

  /// Submit tweet to save in firebase database
  void _submitButtonVduct(BuildContext context) async {
    if (textEditingController.text.isEmpty ||
        textEditingController.text.length > 280) {
      return;
    }
    // var state = Provider.of<FeedState>(context, listen: false);
    //kScreenloader.showLoader(context);

    FeedModel tweetModel = createTweetModel();
    //state.addcommentToPost(tweetModel);
    feedState.createvDuct(tweetModel);

    /// If tweet contain image
    /// First image is uploaded on firebase storage
    /// After sucessfull image upload to firebase storage it returns image path
    /// Add this image path to tweet model and save to firebase database
    // if (_image != null) {
    //   await state.uploadFile(_image).then((imagePath) {
    //     if (imagePath != null) {
    //       tweetModel.imagePath = imagePath;

    //       /// If type of tweet is new tweet
    //       if (widget.isTweet) {
    //         state.createDuct(tweetModel);
    //       }

    //       /// If type of tweet is  retweet
    //       else if (widget.isRetweet) {
    //         state.createvDuct(tweetModel);
    //       }

    //       /// If type of tweet is new comment tweet
    //       else {
    //         state.addcommentToPost(tweetModel);
    //       }
    //     }
    //   });
    // }

    // /// if duct has a video
    // else if (_video != null && _thumbnail != null) {
    //   await state.uploadFile(_video).then((videoPath) async {
    //     if (videoPath != null) {
    //       tweetModel.videoPath = videoPath;

    //       await state.uploadFile(_thumbnail).then((thumbPath) {
    //         tweetModel.imagePath = thumbPath;
    //       });

    //       tweetModel.duration = _duration.toString();

    //       /// If type of tweet is new tweet
    //       if (widget.isTweet) {
    //         state.createDuct(tweetModel);
    //       }

    //       /// If type of tweet is  retweet
    //       else if (widget.isRetweet) {
    //         state.createvDuct(tweetModel);
    //       }

    //       /// If type of tweet is new comment tweet
    //       else {
    //         state.addcommentToPost(tweetModel);
    //       }
    //     }
    //   });
    // }

    // /// If tweet did not contain image
    // else {
    //   /// If type of tweet is new tweet
    //   if (widget.isTweet) {
    //     state.createDuct(tweetModel);
    //   }

    //   /// If type of tweet is  retweet
    //   else if (widget.isRetweet) {
    //     state.createvDuct(tweetModel);
    //   }

    //   /// If type of tweet is new comment tweet
    //   else {
    //     state.addcommentToPost(tweetModel);
    //   }
    // }

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // widget.isDuctDetail ? _timeWidget(context) : SizedBox(),
        // widget.isDuctDetail ? _likeCommentWidget(context) : SizedBox(),
        _likeCommentsIcons(context, widget.model!)
      ],
    );
  }
}

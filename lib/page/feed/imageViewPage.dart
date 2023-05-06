//import 'package:emoji_picker/emoji_picker.dart';
// ignore_for_file: prefer_typing_uninitialized_variables, file_names, file_names, duplicate_ignore, unused_element

import 'package:flutter/material.dart';
import 'package:viewducts/helper/constant.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/duct/widgets/ductIconsRow.dart';
import 'package:viewducts/widgets/frosted.dart';

class ImageViewPge extends StatefulWidget {
  const ImageViewPge({Key? key}) : super(key: key);

  @override
  _ImageViewPgeState createState() => _ImageViewPgeState();
}

class _ImageViewPgeState extends State<ImageViewPge> {
  bool isToolAvailable = true;

  FocusNode? _focusNode;
  TextEditingController? _textEditingController;
  FocusNode textFieldFocus = FocusNode();
  FocusNode imageTextFieldFocus = FocusNode();
  var playstate;
  bool isWriting = false;
  bool showEmojiPicker = false;
  bool typing = false;
  showKeyboard() => textFieldFocus.requestFocus();

  hideKeyboard() => textFieldFocus.unfocus();

  hideEmojiContainer() {
    setState(() {
      showEmojiPicker = false;
    });
  }

  showEmojiContainer() {
    setState(() {
      showEmojiPicker = true;
    });
  }

  @override
  void initState() {
    _focusNode = FocusNode();

    _textEditingController = TextEditingController();
    super.initState();
  }

  Widget _body(BuildContext context) {
//var state = Provider.of<FeedState>(context);
    // var authState = Provider.of<AuthState>(context, listen: false);

    final List<FeedModel>? commissionProduct = feedState.commissionProducts(
        authState.userModel, feedState.ductDetailModel!.last!.cProduct);
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: fullHeight(context),
            ),
            child:

                //  customNetworkImage(
                //   _image,
                //   fit: BoxFit.cover,
                // ),

                InkWell(
              onTap: () {
                setState(() {
                  isToolAvailable = !isToolAvailable;
                });
              },
              child: _imageFeed(feedState.ductDetailModel!.last!.imagePath),
            ),
          ),
        ),

//             Align(
//                 alignment: Alignment.topLeft,
//                 child: SafeArea(
//                   child: Container(
//                       width: 50,
//                       height: 50,
//                       alignment: Alignment.topLeft,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         // color: Colors.brown.shade700.withAlpha(200),
//                       ),
//                       child: Wrap(
//                         children: <Widget>[
//                           BackButton(
// //color: Colors.white,
//                               ),
//                         ],
//                       )),
//                 )),
        !isToolAvailable
            ? Container()
            : Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: DuctIconsRow(
                        model: feedState.ductDetailModel!.last,
                        iconColor: Theme.of(context).colorScheme.onPrimary,
                        iconEnableColor:
                            Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    _bottomEntryField()
                    // Container(
                    //   //    color: Colors.brown.shade700.withAlpha(200),
                    //   padding:
                    //       EdgeInsets.only(right: 10, left: 10, bottom: 10),
                    //   child: Material(
                    //     elevation: 20,
                    //     borderRadius: BorderRadius.circular(20),
                    //     child: frostedTeal(
                    //       TextField(
                    //         controller: _textEditingController,
                    //         maxLines: null,
                    //         //   style: TextStyle(color: Colors.white),
                    //         decoration: InputDecoration(
                    //           fillColor: Colors.blue,
                    //           border: OutlineInputBorder(
                    //             borderRadius: BorderRadius.all(
                    //               Radius.circular(30.0),
                    //             ),
                    //             borderSide: BorderSide(
                    //               color: Colors.white,
                    //             ),
                    //           ),
                    //           focusedBorder: OutlineInputBorder(
                    //             borderRadius: BorderRadius.all(
                    //               Radius.circular(30.0),
                    //             ),
                    //             borderSide: BorderSide(
                    //               color: Colors.white,
                    //             ),
                    //           ),
                    //           suffixIcon: IconButton(
                    //             onPressed: () {
                    //               _submitButton();
                    //             },
                    //             icon: Icon(Icons.send),
                    //           ),
                    //           focusColor: Colors.black,
                    //           contentPadding: EdgeInsets.symmetric(
                    //             horizontal: 10,
                    //             vertical: 10,
                    //           ),
                    //           hintText: 'React here..',
                    //           hintStyle: TextStyle(
                    //             color: Colors.black,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
        !isToolAvailable
            ? Container()
            :
            // commissionProduct == null
            //     ? Container()
            //     :
            Positioned(
                top: fullWidth(context) * 0.2,
                left: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Material(
                          elevation: 20,
                          borderRadius: BorderRadius.circular(20),
                          child: frostedYellow(
                            SizedBox(
                              width: fullWidth(context) * 0.2,
                              height: fullWidth(context) * 0.2,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                addAutomaticKeepAlives: false,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                      height: fullWidth(context) * 0.2,
                                      width: fullWidth(context) * 0.2,
                                      child: _Orders(
                                        list: commissionProduct![index],
                                        model: feedState.ductDetailModel!.last,
                                      )),
                                ),
                                itemCount: commissionProduct?.length ?? 0,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(0),
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.yellow),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: customTitleText('Buy'),
                                  )),
                              const SizedBox(
                                height: 10,
                              ),
                              frostedOrange(Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: customText(
                                    feedState
                                        .ductDetailModel!.last!.productName,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    )),
                              )),
                              const SizedBox(
                                height: 10,
                              ),
                              frostedOrange(Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: customText(
                                    '${feedState.ductDetailModel!.last!.price}',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    )),
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Container(
                    //     padding: EdgeInsets.all(0),
                    //     decoration: BoxDecoration(
                    //         shape: BoxShape.circle, color: Colors.yellow),
                    //     child: IconButton(
                    //       padding: EdgeInsets.all(0),
                    //       iconSize: 20,
                    //       onPressed: () {},
                    //       icon: Icon(
                    //         Icons.play_arrow,
                    //         color: Theme.of(context).colorScheme.primary,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Container(
                    //     padding: EdgeInsets.all(0),
                    //     decoration: BoxDecoration(
                    //         shape: BoxShape.circle, color: Colors.yellow),
                    //     child: IconButton(
                    //       padding: EdgeInsets.all(0),
                    //       iconSize: 20,
                    //       onPressed: () {},
                    //       icon: Icon(
                    //         Icons.person_add_outlined,
                    //         color: Theme.of(context).colorScheme.primary,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
        // !isToolAvailable
        //     ? Container()
        //     : Positioned(
        //         right: 10,
        //         top: fullWidth(context) * 0.08,
        //         child: Container(
        //           height: fullWidth(context) * 0.1,
        //           width: fullWidth(context) * 0.3,
        //           child: Center(
        //             child: InkWell(
        //                 onTap: () {
        //                   Navigator.pop(context);
        //                 },
        //                 child: Row(
        //                   children: <Widget>[
        //                     IconButton(
        //                       onPressed: () {
        //                         Navigator.pop(context);
        //                       },
        //                       color: Colors.black,
        //                       icon: Icon(CupertinoIcons.clear_circled_solid),
        //                     ),
        //                     Text(
        //                       'Back',
        //                       style: TextStyle(
        //                           fontSize: 20,
        //                           fontWeight: FontWeight.w600,
        //                           color: Colors.blueGrey[300]),
        //                     ),
        //                   ],
        //                 )),
        //           ),
        //         ),
        //       ),
      ],
    );
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
                            controller: _textEditingController,
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
                            if (!showEmojiPicker) {
                              // keyboard is visible
                              hideKeyboard();
                              showEmojiContainer();
                            } else {
                              //keyboard is hidden
                              showKeyboard();
                              hideEmojiContainer();
                            }
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
                                _submitButton();
                              }),
                        )
                      : Container()
                ],
              ),
              showEmojiPicker ? Container(child: emojiContainer()) : Container()
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

              //     _textEditingController.text =
              //         _textEditingController.text + emoji.emoji;
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

  Widget _imageFeed(String? _image) {
    return _image == null
        ? Container()
        : Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
              Colors.black.withOpacity(0.7),
              Colors.black.withOpacity(0.3)
            ])),
            child: SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: fullWidth(context),
                  height: fullHeight(context),
                  child: customNetworkImage(
                    _image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
  }

  void addLikeToDuct() {
    // var authState = Provider.of<AuthState>(context, listen: false);
    feedState.addLikeToDuct(feedState.ductDetailModel!.last!, authState.userId,
        feedState.ductDetailModel!.last!.key);
  }

  void _submitButton() {
    if (_textEditingController!.text.isEmpty) {
      return;
    }
    if (_textEditingController!.text.length > 280) {
      return;
    }
    // var authState = Provider.of<AuthState>(context, listen: false);
    var user = authState.userModel!;
    var profilePic = user.profilePic;
    profilePic ??= dummyProfilePic;
    var name = authState.userModel!.displayName ??
        authState.userModel!.email!.split('@')[0];
    var pic = authState.userModel!.profilePic ?? dummyProfilePic;
    var tags = getHashTags(_textEditingController!.text);

    ViewductsUser commentedUser = ViewductsUser(
        displayName: name,
        userName: authState.userModel!.userName,
        isVerified: authState.userModel!.isVerified,
        profilePic: pic,
        userId: authState.userId);

    var postId = feedState.ductDetailModel!.last!.key;

    FeedModel reply = FeedModel(
      ductComment: _textEditingController!.text,
      user: commentedUser,
      createdAt: DateTime.now().toUtc().toString(),
      tags: tags,
      userId: commentedUser.userId,
      parentkey: postId,
    );
    feedState.addcommentToPost(reply);
    FocusScope.of(context).requestFocus(_focusNode);
    setState(() {
      _textEditingController!.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _body(context));
  }
}

// ignore: must_be_immutable
class _Orders extends StatefulWidget {
  _Orders({
    Key? key,
    this.isSelected,
    required this.model,
    this.list,
    this.ductId,
  }) : super(key: key);

  final ValueNotifier<bool>? isSelected;
  final FeedModel? model;
  final FeedModel? list;
  String? ductId;

  @override
  __OrdersState createState() => __OrdersState();
}

class __OrdersState extends State<_Orders> {
  Widget _imageFeed(String? _image) {
    return _image == null
        ? Container()
        : Container(
            alignment: Alignment.center,
            child: Container(
              // height: fullHeight(context),
              // width: fullWidth(context),
              child: customNetworkImage(
                _image,
                fit: BoxFit.cover,
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          SizedBox(
            width: fullWidth(context) * 0.12,
            height: fullWidth(context) * 0.12,
            child: _imageFeed(widget.list?.imagePath),
          ),
        ],
      ),
    );
  }
}

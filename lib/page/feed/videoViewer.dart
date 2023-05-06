// ignore_for_file: unnecessary_null_comparison, prefer_typing_uninitialized_variables, file_names, unused_element

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:viewducts/model/feedModel.dart';

import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/frosted.dart';
import 'package:video_player/video_player.dart';

class VideoViewPge extends StatefulWidget {
  const VideoViewPge({Key? key}) : super(key: key);

  @override
  _VideoViewPgeState createState() => _VideoViewPgeState();
}

class _VideoViewPgeState extends State<VideoViewPge> {
  bool isToolAvailable = true;
  late VideoPlayerController _controller;
  Future<void>? _initializeVideoplayerfuture;
  var playfeedState;
  // @override
  // void initState() {
  //   playfeedState = Provider.of<FeedState>(context, listen: false);
  //   _focusNode = FocusNode();

  //   _controller =
  //       VideoPlayerController.network(playfeedState.ductDetailModel.last.videoPath);
  //   _initializeVideoplayerfuture = _controller.initialize().then((value) {
  //     setState(() {});
  //     _controller.play();
  //   });
  //   _textEditingController = TextEditingController();
  //   super.initState();
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _body(BuildContext context) {
//var feedState = Provider.of<FeedState>(context);
    // var feedState = Provider.of<FeedState>(context, listen: false);
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
              child: FutureBuilder(
                future: _initializeVideoplayerfuture,
                // initialData: InitialData,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return SizedBox.expand(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: frostedBlack(
                          SizedBox(
                            width: fullWidth(context),
                            height: fullHeight(context),
                            child: GestureDetector(
                              onTap: () {
                                if (_controller.value.isPlaying) {
                                  _controller.pause();
                                } else {
                                  _controller.play();
                                }
                              },
                              child: VideoPlayer(_controller),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              )),
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
                                child: customText('Iphone',
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
                                child: customText('N220',
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(0),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.yellow),
                        child: IconButton(
                          padding: const EdgeInsets.all(0),
                          iconSize: 20,
                          onPressed: () {},
                          icon: Icon(
                            Icons.play_arrow,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(0),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.yellow),
                        child: IconButton(
                          padding: const EdgeInsets.all(0),
                          iconSize: 20,
                          onPressed: () {},
                          icon: Icon(
                            Icons.person_add_outlined,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        !isToolAvailable
            ? Container()
            : Positioned(
                right: 10,
                top: fullWidth(context) * 0.08,
                child: SizedBox(
                  height: fullWidth(context) * 0.1,
                  width: fullWidth(context) * 0.3,
                  child: Center(
                    child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              color: Colors.black,
                              icon: const Icon(
                                  CupertinoIcons.clear_circled_solid),
                            ),
                            Text(
                              'Back',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blueGrey[300]),
                            ),
                          ],
                        )),
                  ),
                ),
              ),
        adsBottom(context)
      ],
    );
  }

  // void addLikeToDuct() {
  //   var feedState = Provider.of<FeedState>(context, listen: false);
  //   var authState = Provider.of<AuthState>(context, listen: false);
  //   feedState..addLikeToDuct(feedState.ductDetailModel.last, authState.userId);
  // }

  // void _submitButton() {
  //   if (_textEditingController.text == null ||
  //       _textEditingController.text.isEmpty) {
  //     return;
  //   }
  //   if (_textEditingController.text.length > 280) {
  //     return;
  //   }
  //   var feedState = Provider.of<FeedState>(context, listen: false);
  //   var authState = Provider.of<AuthState>(context, listen: false);
  //   var user = authState.userModel;
  //   var profilePic = user.profilePic;
  //   if (profilePic == null) {
  //     profilePic = dummyProfilePic;
  //   }
  //   var name = authState.userModel.displayName ??
  //       authState.userModel.email.split('@')[0];
  //   var pic = authState.userModel.profilePic ?? dummyProfilePic;
  //   var tags = getHashTags(_textEditingController.text);

  //   ViewductsUser commentedUser = ViewductsUser(
  //       displayName: name,
  //       userName: authState.userModel.userName,
  //       isVerified: authState.userModel.isVerified,
  //       profilePic: pic,
  //       userId: authState.userId);

  //   var postId = feedState.ductDetailModel.last.key;

  //   FeedModel reply = FeedModel(
  //     ductComment: _textEditingController.text,
  //     user: commentedUser,
  //     createdAt: DateTime.now().toUtc().toString(),
  //     tags: tags,
  //     userId: commentedUser.userId,
  //     parentkey: postId,
  //   );
  //   feedState.addcommentToPost(reply);
  //   FocusScope.of(context).requestFocus(_focusNode);
  //   setState(() {
  //     _textEditingController.text = '';
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
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

class ProductVideoViewPge extends StatefulWidget {
  const ProductVideoViewPge({Key? key}) : super(key: key);

  @override
  _ProductVideoViewPgeState createState() => _ProductVideoViewPgeState();
}

class _ProductVideoViewPgeState extends State<ProductVideoViewPge> {
  bool isToolAvailable = true;
  late VideoPlayerController _controller;
  Future<void>? _initializeVideoplayerfuture;
  var playfeedState;
  // @override
  // void initState() {
  //   playfeedState = Provider.of<FeedState>(context, listen: false);
  //   _focusNode = FocusNode();

  //   _controller =
  //       VideoPlayerController.network(playfeedState.ductDetailModel.last.videoPath);
  //   _initializeVideoplayerfuture = _controller.initialize().then((value) {
  //     setState(() {});
  //     _controller.play();
  //   });
  //   _textEditingController = TextEditingController();
  //   super.initState();
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _body(BuildContext context) {
//var feedState = Provider.of<FeedState>(context);
    // var feedState = Provider.of<FeedState>(context, listen: false);
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
              child: FutureBuilder(
                future: _initializeVideoplayerfuture,
                // initialData: InitialData,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return SizedBox.expand(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: frostedBlack(
                          SizedBox(
                            width: fullWidth(context),
                            height: fullHeight(context),
                            child: GestureDetector(
                              onTap: () {
                                if (_controller.value.isPlaying) {
                                  _controller.pause();
                                } else {
                                  _controller.play();
                                }
                              },
                              child: VideoPlayer(_controller),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              )),
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
                                child: customText('Iphone',
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
                                child: customText('N220',
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(0),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.yellow),
                        child: IconButton(
                          padding: const EdgeInsets.all(0),
                          iconSize: 20,
                          onPressed: () {},
                          icon: Icon(
                            Icons.play_arrow,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(0),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.yellow),
                        child: IconButton(
                          padding: const EdgeInsets.all(0),
                          iconSize: 20,
                          onPressed: () {},
                          icon: Icon(
                            Icons.person_add_outlined,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        !isToolAvailable
            ? Container()
            : Positioned(
                right: 10,
                top: fullWidth(context) * 0.08,
                child: SizedBox(
                  height: fullWidth(context) * 0.1,
                  width: fullWidth(context) * 0.3,
                  child: Center(
                    child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: <Widget>[
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              color: Colors.black,
                              icon: const Icon(
                                  CupertinoIcons.clear_circled_solid),
                            ),
                            Text(
                              'Back',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blueGrey[300]),
                            ),
                          ],
                        )),
                  ),
                ),
              ),
        adsBottom(context)
      ],
    );
  }

  // void addLikeToDuct() {
  //   var feedState = Provider.of<FeedState>(context, listen: false);
  //   var authState = Provider.of<AuthState>(context, listen: false);
  //   feedState..addLikeToDuct(feedState.ductDetailModel.last, authState.userId);
  // }

  // void _submitButton() {
  //   if (_textEditingController.text == null ||
  //       _textEditingController.text.isEmpty) {
  //     return;
  //   }
  //   if (_textEditingController.text.length > 280) {
  //     return;
  //   }
  //   var feedState = Provider.of<FeedState>(context, listen: false);
  //   var authState = Provider.of<AuthState>(context, listen: false);
  //   var user = authState.userModel;
  //   var profilePic = user.profilePic;
  //   if (profilePic == null) {
  //     profilePic = dummyProfilePic;
  //   }
  //   var name = authState.userModel.displayName ??
  //       authState.userModel.email.split('@')[0];
  //   var pic = authState.userModel.profilePic ?? dummyProfilePic;
  //   var tags = getHashTags(_textEditingController.text);

  //   ViewductsUser commentedUser = ViewductsUser(
  //       displayName: name,
  //       userName: authState.userModel.userName,
  //       isVerified: authState.userModel.isVerified,
  //       profilePic: pic,
  //       userId: authState.userId);

  //   var postId = feedState.ductDetailModel.last.key;

  //   FeedModel reply = FeedModel(
  //     ductComment: _textEditingController.text,
  //     user: commentedUser,
  //     createdAt: DateTime.now().toUtc().toString(),
  //     tags: tags,
  //     userId: commentedUser.userId,
  //     parentkey: postId,
  //   );
  //   feedState.addcommentToPost(reply);
  //   FocusScope.of(context).requestFocus(_focusNode);
  //   setState(() {
  //     _textEditingController.text = '';
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(body: _body(context));
  }
}

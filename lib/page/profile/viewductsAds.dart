// ignore_for_file: unnecessary_null_comparison, deprecated_member_use, file_names, unused_element

import 'dart:io';
import 'dart:math' as math;
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:video_player/video_player.dart';
import 'package:viewducts/helper/constant.dart';
import 'package:viewducts/helper/enum.dart';
import 'package:viewducts/helper/theme.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/page/feed/composeTweet/widget/composeTweetImage.dart';
import 'package:viewducts/page/message/chatScreenPage.dart';
import 'package:viewducts/state/feedState.dart';
import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/frosted.dart';
import 'package:viewducts/widgets/newWidget/emptyList.dart';
import 'package:viewducts/widgets/newWidget/rippleButton.dart';

class SalesData {
  final String year;
  final double sales;

  SalesData(this.year, this.sales);
}

class AdsPage extends StatefulWidget {
  const AdsPage({Key? key}) : super(key: key);

  @override
  _AdsPageState createState() => _AdsPageState();
}

class _AdsPageState extends State<AdsPage> {
  double? _ppcPrice = 0.6;
  double? _maxBudget = 0.6;
  void pickImage({required ImageSource source}) async {
    //  File selectedImage = await Utils.pickImage(source: source);
    // _storageMethods.uploadImage(
    //     image: selectedImage,
    //     receiverId: widget.receiver.uid,
    //     senderId: _currentUserId,
    //     imageUploadProvider: _imageUploadProvider);
  }

  File? _image, _video, _thumbnail;
  late VideoPlayerController controller;

  void _onCrossIconPressed() {
    setState(() {
      _image = null;
      _video = null;
      _thumbnail = null;
    });
  }

  void _onCrossThumbnail() async {
    // File file = await ImagePicker.pickImage(
    //     source: ImageSource.gallery, imageQuality: 85);
    // setState(() {
    //   _image = null;
    //   _thumbnail = file;
    // });
  }

  _addMediaModal(context) {
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
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: <Widget>[
                      TextButton(
                        child: const Icon(
                          Icons.close,
                        ),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Media Size Max 2mb",
                            style: TextStyle(
                                color: Colors.yellow[800],
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: ListView(
                    children: <Widget>[
                      ModalTile(
                        title: "Gallary",
                        subtitle: "image from gallary",
                        icon: Icons.tab,
                        onTap: () async {
                          // Navigator.maybePop(context);
                          // File file = await ImagePicker.pickImage(
                          //     source: ImageSource.gallery, imageQuality: 85);
                          // if (file.lengthSync() > 10000000) {
                          //   setState(() {
                          //     file = null;
                          //     _video = null;
                          //     _thumbnail = null;
                          //     _image = null;
                          //   });
                          //   Navigator.maybePop(context);
                          //   _showDialog();
                          // } else {
                          //   setState(() {
                          //     _image = file;
                          //     _thumbnail = null;
                          //   });
                          // }
                        },
                      ),
                      ModalTile(
                        title: "Camera",
                        subtitle: "image through camera",
                        icon: Icons.tab,
                        onTap: () async {
                          // Navigator.maybePop(context);
                          // File file = await ImagePicker.pickImage(
                          //     source: ImageSource.gallery, imageQuality: 85);
                          // if (file.lengthSync() > 10000000) {
                          //   setState(() {
                          //     file = null;
                          //     _video = null;
                          //     _thumbnail = null;
                          //     _image = null;
                          //   });
                          //   Navigator.maybePop(context);
                          //   _showDialog();
                          // } else {
                          //   setState(() {
                          //     _image = file;
                          //     _thumbnail = null;
                          //   });
                          // }
                        },
                      ),
                      ModalTile(
                        title: "Video",
                        subtitle: "Uplaod Video",
                        icon: Icons.tab,
                        onTap: () async {
                          // File file = await ImagePicker.pickVideo(
                          //     source: ImageSource.gallery,
                          //     maxDuration: Duration(seconds: 45));

                          // if (file.lengthSync() > 20000000) {
                          //   setState(() {
                          //     file = null;
                          //     _video = null;
                          //     _thumbnail = null;
                          //     _image = null;
                          //   });
                          //   Navigator.maybePop(context);
                          //   _showDialog();
                          // } else {
                          //   final _thumbnailPath =
                          //       await VideoThumbnail.thumbnailFile(
                          //           video: file.path,
                          //           imageFormat: ImageFormat.PNG,
                          //           quality: 30);

                          //   setState(() {
                          //     _thumbnail = File(_thumbnailPath);
                          //   });

                          //   setState(() {
                          //     _image = null;
                          //     _video = file;
                          //   });

                          //   Navigator.maybePop(context);
                          //   if (_video != null) {
                          //     setState(() {
                          //       controller = VideoPlayerController.file(_video)
                          //         ..initialize();
                          //     });
                          //   }
                          // }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  _link(context) {
    showModalBottomSheet(
        context: context,
        elevation: 0,
        backgroundColor: Colors.transparent,

        //  backgroundColor: Colors.black,
        // UniversalVariables.blackColor,
        builder: (context) {
          return frostedYellow(
            SizedBox(
              width: fullWidth(context),
              height: fullWidth(context) * 0.3,
              child: Column(
                children: <Widget>[
                  _widgetBottomSheetRow(context, AppIcon.report,
                      text: 'Mobile App', isEnable: true),
                  _widgetBottomSheetRow(context, AppIcon.report,
                      text: 'Web App', isEnable: true),
                ],
              ),
            ),
          );
        });
  }

  void _industries(
    BuildContext context,
  ) async {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return frostedPink(
          SizedBox(
            width: fullWidth(context),
            height: fullWidth(context),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: fullWidth(context) * .1,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: fullWidth(context),
                    height: fullWidth(context),
                    child: ListView.separated(
                      itemCount: 20,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: customInkWell(
                            context: context,
                            onPressed: () {
                              // if (onPressed != null)
                              //   onPressed();
                              // else {
                              //   Navigator.pop(context);
                              // }
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: <Widget>[
                                  // customIcon(
                                  //   context,
                                  //   icon: icon,

                                  //   istwitterIcon: true,
                                  //   size: 25,
                                  //   paddingIcon: 8,
                                  //   iconColor:  Colors.teal,
                                  // ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  customText(
                                    'Law',
                                    context: context,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _marketOption(
    BuildContext context,
  ) {
    // var authState = Provider.of<AuthState>(context, listen: false);
    return Column(
      children: <Widget>[
        Container(
          width: fullWidth(context) * .1,
          height: 5,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        _widgetBottomSheetRow(context, AppIcon.report,
            text: 'Iphone', isEnable: true),
        _widgetBottomSheetRow(context, AppIcon.report,
            text: 'MacBook', isEnable: true),
        _widgetBottomSheetRow(context, AppIcon.report,
            text: 'Shoe', isEnable: true),
        _widgetBottomSheetRow(context, AppIcon.report,
            text: 'Shirts', isEnable: true),
      ],
    );
  }

  void _marketPlaceSearchWords(
    BuildContext context,
  ) async {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return frostedOrange(
          Container(
              padding: const EdgeInsets.only(top: 5, bottom: 0),
              height: fullHeight(context) * 0.52,
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
                  _marketOption(
                    context,
                  ),
                ],
              )),
        );
      },
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
              customText(
                text,
                context: context,
                style: TextStyle(
                  color: isEnable ? AppColor.white : AppColor.lightGrey,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
      decimalDigits: 2,
      locale: Localizations.localeOf(context).toString(),
    );
    double clicks = (_maxBudget! / _ppcPrice!).roundToDouble();
    //var authState = Provider.of<AuthState>(context, listen: false);

    //var state = Provider.of<FeedState>(context, listen: false);
    List<FeedModel>? list = feedState.getAllProductList(
      authState.userId,
    );
    return Scaffold(
      backgroundColor: TwitterColor.mystic,
      body: SafeArea(
          child: Stack(
        children: [
          frostedYellow(
            Container(
              height: fullHeight(context),
              width: fullWidth(context),
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(100),
                //color: Colors.blueGrey[50]
                gradient: LinearGradient(
                  colors: [
                    Colors.blue[100]!.withOpacity(0.3),
                    Colors.green[200]!.withOpacity(0.1),
                    Colors.yellowAccent[100]!.withOpacity(0.2)
                    // Color(0xfffbfbfb),
                    // Color(0xfff7f7f7),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Positioned(
            top: -160,
            right: -140,
            child: Transform.rotate(
              angle: 90,
              child: Container(
                height: fullWidth(context) * 0.8,
                width: fullWidth(context),
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
                height: fullWidth(context) * 0.8,
                width: fullWidth(context),
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
                height: fullWidth(context) * 0.8,
                width: fullWidth(context),
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
                height: fullWidth(context) * 0.8,
                width: fullWidth(context),
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/ankkara1.jpg'))),
              ),
            ),
          ),
          // frostedWhite(
          //   Container(
          //     height: fullHeight(context),
          //     width: fullWidth(context),
          //   ),
          // ),
          PageView(
            children: [
              Stack(
                children: [
                  Positioned(
                    top: fullWidth(context) * 0.4,
                    child: SizedBox(
                      width: fullWidth(context),
                      height: fullHeight(context) * 0.8,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(),
                                GestureDetector(
                                  onTap: () {
                                    _industries(context);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: frostedYellow(Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: customTitleText(
                                              'Industry',
                                            ),
                                          )),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                              Icons.arrow_forward_ios_rounded),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        _addMediaModal(context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: frostedYellow(Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: customTitleText(
                                                      'Media Type',
                                                    ),
                                                  )),
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Icon(Icons
                                                      .arrow_forward_ios_rounded),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    ComposeTweetImage(
                                      image: _image,
                                      onCrossIconPressed: _onCrossIconPressed,
                                    ),

                                    // viewState._video != null
                                    //    ?
                                    //AspectRatio(
                                    //     aspectRatio: 16 / 9,
                                    //     child: ComposeDuctVideo(file: viewState._video)

                                    //     // VideoPlayer(
                                    //     //   VideoPlayerController.file(viewState._video),
                                    //     )

                                    _video == null
                                        ? Container()
                                        : Stack(
                                            children: [
                                              Column(
                                                children: [
                                                  Material(
                                                    elevation: 20,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    child: Container(
                                                      height:
                                                          fullWidth(context) *
                                                              0.5,
                                                      width: fullWidth(context),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: SizedBox.expand(
                                                        child: FittedBox(
                                                            //spectRatio: 2 / 2,
                                                            fit: BoxFit.cover,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              child:
                                                                  frostedTeal(
                                                                SizedBox(
                                                                    height: fullWidth(
                                                                        context),
                                                                    width: fullWidth(
                                                                        context),
                                                                    child:
                                                                        Stack(
                                                                      children: [
                                                                        GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            if (controller.value.isPlaying) {
                                                                              controller.pause();
                                                                            } else {
                                                                              controller.play();
                                                                            }
                                                                          },
                                                                          child:
                                                                              VideoPlayer(controller),
                                                                        ),
                                                                        _video ==
                                                                                null
                                                                            ? Container()
                                                                            : Positioned(
                                                                                top: fullWidth(context) * 0.42,
                                                                                left: 2,
                                                                                child: Container(
                                                                                  padding: const EdgeInsets.all(0),
                                                                                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black54),
                                                                                  child: IconButton(
                                                                                    padding: const EdgeInsets.all(0),
                                                                                    iconSize: 20,
                                                                                    onPressed: _onCrossIconPressed,
                                                                                    icon: Icon(
                                                                                      Icons.close,
                                                                                      color: Theme.of(context).colorScheme.onPrimary,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                      ],
                                                                    )),
                                                              ),
                                                            )),
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        _thumbnail == null
                                                            ? Container()
                                                            : SizedBox(
                                                                height: fullWidth(
                                                                        context) *
                                                                    0.3,
                                                                width: fullWidth(
                                                                        context) *
                                                                    0.3,
                                                                child: Stack(
                                                                  children: [
                                                                    FittedBox(
                                                                      child:
                                                                          ComposeThumbnail(
                                                                        image:
                                                                            _thumbnail,
                                                                        onCrossIconPressed:
                                                                            _onCrossThumbnail,
                                                                      ),
                                                                    ),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Container(
                                                                        padding:
                                                                            const EdgeInsets.all(0),
                                                                        decoration: const BoxDecoration(
                                                                            shape:
                                                                                BoxShape.circle,
                                                                            color: Colors.black54),
                                                                        child: InkWell(
                                                                            onTap: _onCrossThumbnail,
                                                                            child: frostedBlack(
                                                                              Text('thumbnail', style: TextStyle(color: Colors.white, fontSize: fullWidth(context) * 0.05)),
                                                                            )),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                      ])
                                                ],
                                              ),
                                            ],
                                          ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _link(context);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child:
                                                        frostedYellow(Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: customTitleText(
                                                        'Link',
                                                      ),
                                                    )),
                                                  ),
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Icon(Icons
                                                        .arrow_forward_ios_rounded),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      frostedWhite(
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: TextField(
                                            // controller: captionController,
                                            // onChanged: (text) {
                                            //   Provider.of<ComposeTweetState>(context, listen: false)
                                            //       .onDescriptionChanged(text, searchState);
                                            // },
                                            maxLines: null,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText:
                                                    'Your App/Website link',
                                                hintStyle:
                                                    TextStyle(fontSize: 18)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _marketPlaceSearchWords(context);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: frostedYellow(Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: customTitleText(
                                              'MarketPlace Search Category',
                                            ),
                                          )),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                              Icons.arrow_forward_ios_rounded),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _marketPlaceSearchWords(context);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: frostedYellow(Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: customTitleText(
                                              'Viewers Location',
                                            ),
                                          )),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Icon(
                                              Icons.arrow_forward_ios_rounded),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                const Divider(),
                                // Column(
                                //   mainAxisAlignment: MainAxisAlignment.start,
                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                //   children: [
                                //     Padding(
                                //       padding: const EdgeInsets.all(8.0),
                                //       child: Row(
                                //         mainAxisAlignment: MainAxisAlignment.center,
                                //         children: [
                                //           Padding(
                                //             padding: const EdgeInsets.all(8.0),
                                //             child: frostedYellow(Padding(
                                //               padding: const EdgeInsets.all(8.0),
                                //               child: customTitleText(
                                //                 'Schedule',
                                //               ),
                                //             )),
                                //           ),
                                //         ],
                                //       ),
                                //     ),
                                //     frostedPink(
                                //       Container(
                                //         decoration: BoxDecoration(
                                //           // borderRadius: BorderRadius.circular(100),
                                //           //color: Colors.blueGrey[50]
                                //           gradient: LinearGradient(
                                //             colors: [
                                //               Colors.blue[100].withOpacity(0.3),
                                //               Colors.green[200].withOpacity(0.1),
                                //               Colors.yellowAccent[100].withOpacity(0.2)
                                //               // Color(0xfffbfbfb),
                                //               // Color(0xfff7f7f7),
                                //             ],
                                //             begin: Alignment.topCenter,
                                //             end: Alignment.bottomCenter,
                                //           ),
                                //         ),
                                //         child: SfDateRangePicker(
                                //           showNavigationArrow: true,
                                //           onSelectionChanged: _onSelectionChange,
                                //           selectionMode:
                                //               DateRangePickerSelectionMode.range,
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                // Divider(),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: frostedYellow(Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: customTitleText(
                                                'Budget',
                                              ),
                                            )),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          frostedYellow(Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                customTitleText(
                                                  'Monthly Budget Spending',
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      SfSlider(
                                                          min: 0.0,
                                                          max: 10000.0,
                                                          interval: 2000,
                                                          activeColor:
                                                              Colors.teal,
                                                          showLabels: true,
                                                          inactiveColor:
                                                              Colors.grey,
                                                          enableTooltip: true,
                                                          value: _maxBudget,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              _maxBudget =
                                                                  value;
                                                            });
                                                          }),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          formatter.format(
                                                              _maxBudget),
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.red,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                          frostedYellow(Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: customTitleText(
                                              'Bid',
                                            ),
                                          )),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SfSlider(
                                                    min: 0.65,
                                                    max: 100.0,
                                                    interval: 20,
                                                    activeColor: Colors.green,
                                                    showLabels: true,
                                                    inactiveColor: Colors.grey,
                                                    enableTooltip: true,
                                                    value: _ppcPrice,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _ppcPrice = value;
                                                      });
                                                    }),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        formatter
                                                            .format(_ppcPrice),
                                                        style: const TextStyle(
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: customText(
                                                          'Pay Per Click(PPC)',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          frostedYellow(Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(children: [
                                                customTitleText(
                                                  'Estimated Clicks ',
                                                ),
                                                customText(
                                                    '$clicks - ${clicks * 1.5} ',
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize:
                                                            fullWidth(context) *
                                                                0.05)),
                                                customTitleText(
                                                  'Clicks',
                                                ),
                                              ]))),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: frostedYellow(Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: customTitleText(
                                          'Marketing Caption',
                                        ),
                                      )),
                                    ),
                                    frostedWhite(
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: TextField(
                                          // controller: captionController,
                                          // onChanged: (text) {
                                          //   Provider.of<ComposeTweetState>(context, listen: false)
                                          //       .onDescriptionChanged(text, searchState);
                                          // },
                                          maxLines: null,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText:
                                                  'Your Marketing Words for Your Viewers',
                                              hintStyle:
                                                  TextStyle(fontSize: 18)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Material(
                                        elevation: 20,
                                        borderRadius: BorderRadius.circular(20),
                                        child: frostedGreen(Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: customTitleText(
                                            'Stake It',
                                          ),
                                        )),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: fullWidth(context) * 0.4,
                                )
                              ],
                            ),
                            const Divider(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  Positioned(
                    top: fullWidth(context) * 0.3,
                    child: SizedBox(
                      width: fullWidth(context),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Material(
                            //   borderRadius: BorderRadius.circular(20),
                            //   color: Colors.transparent,
                            //   child: Padding(
                            //       padding: const EdgeInsets.symmetric(
                            //           horizontal: 8.0, vertical: 3),
                            //       child: customText(
                            //         'VAds',
                            //         style: TextStyle(
                            //             color: Colors.green,
                            //             fontSize: 35,
                            //             fontWeight: FontWeight.bold),
                            //       )),
                            // ),
                            list == null
                                ? Container()
                                : InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushNamed('/MarketingInSight/');
                                    },
                                    child: frostedWhite(Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          customTitleText(
                                            'Marketing Insight',
                                          ),
                                          const Icon(
                                              Icons.arrow_forward_ios_rounded)
                                        ],
                                      ),
                                    )),
                                  ),
                            const Divider(),
                            list == null
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: fullWidth(context) * 0.1,
                                      ),
                                      GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              image: const DecorationImage(
                                                  image: AssetImage(
                                                      'assets/shopping-bag.png'))),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30),
                                        child: frostedOrange(
                                          Align(
                                            alignment: Alignment.topCenter,
                                            child: SizedBox(
                                              height: fullWidth(context) * 0.5,
                                              child: const EmptyList(
                                                'No Advert Placement Yet',
                                                subTitle:
                                                    'Start by clicking the button Below',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10.0),
                                      ButtonTheme(
                                        height: 45.0,
                                        minWidth: 100.0,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(7.0))),
                                        child: ElevatedButton(
                                          //  color: const Color(0xff313134),
                                          onPressed: () async {
                                            // Navigator.of(context).push(
                                            //   MaterialPageRoute(
                                            //       builder: (context) =>
                                            //           Home()),
                                            // );

                                            //   Map<String,dynamic> args = new Map();
                                            // //  Loader.showLoadingScreen(context, _keyLoader);
                                            //   List<Map<String,String>> categoryList = await _productService.listCategories();
                                            //   args['category'] = categoryList;
                                            //   Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
                                            //   Navigator.pushReplacementNamed(context, '/shop',arguments: args);
                                          },
                                          child: const Text(
                                            'Swipe Right to Place Ads Now',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      // margin: EdgeInsets.symmetric(vertical: 10),
                                      width: list == null
                                          ? 0
                                          : AppTheme.fullWidth(context) * 0.8,

                                      child: Column(
                                        children: list
                                            .map((product) => _ItemCard(
                                                  ductProduct: product,
                                                ))
                                            .toList(),
                                      ),
                                    ),
                                  ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                  Positioned(
                    bottom: fullWidth(context),
                    right: 10,
                    child: InkWell(
                      onTap: () {
                        // setState(() {
                        //   if (isDropdown) {
                        //     floatingMenu.remove();
                        //   } else {
                        //     //  _postProsductoption();
                        //     floatingMenu = _listings(context);
                        //     Overlay.of(context).insert(floatingMenu);
                        //   }

                        //   isDropdown = !isDropdown;
                        // });
                      },
                      child: Material(
                        elevation: 20,
                        borderRadius: BorderRadius.circular(20),
                        child: frostedTeal(Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: customTitleText(
                            'Listings',
                          ),
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: fullWidth(context),
            right: 10,
            child: InkWell(
              onTap: () {
                // setState(() {
                //   if (isDropdown) {
                //     floatingMenu.remove();
                //   } else {
                //     //  _postProsductoption();
                //     floatingMenu = _listings(context);
                //     Overlay.of(context).insert(floatingMenu);
                //   }

                //   isDropdown = !isDropdown;
                // });
              },
              child: Material(
                elevation: 20,
                borderRadius: BorderRadius.circular(20),
                child: frostedTeal(Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: customTitleText(
                    'Preview',
                  ),
                )),
              ),
            ),
          ),
          Positioned(
            top: fullWidth(context) * 0.25,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
                child: customText(
                  'Ads Placement',
                  style: TextStyle(
                      color: Colors.blueGrey[200],
                      fontSize: 35,
                      fontWeight: FontWeight.bold),
                )),
          ),
          Positioned(
            right: 10,
            top: 0,
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
                      icon: const Icon(CupertinoIcons.clear_circled_solid),
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
          Positioned(
            top: 20,
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
                        child: customTitleText('ViewDucts Ads'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: fullWidth(context) * 0.15,
            left: 0,
            child: frostedPink(Padding(
              padding: const EdgeInsets.all(8.0),
              child: customTitleText(
                'Swipe Left',
              ),
            )),
          ),
        ],
      )),
    );
  }
}

class _ItemCard extends StatefulWidget {
  const _ItemCard({
    this.imageAspectRatio = 33 / 49,
    this.ductProduct,
    this.type,
    this.profileId,
    this.isDisplayOnProfile,
  }) : assert(imageAspectRatio > 0);
  final DuctType? type;
  final double imageAspectRatio;
  final String? profileId;
  // final Products products;
  final FeedModel? ductProduct;
  final bool? isDisplayOnProfile;

  @override
  __ItemCardState createState() => __ItemCardState();
}

ValueNotifier<bool> imageNotready = ValueNotifier(false);

class __ItemCardState extends State<_ItemCard> {
  DuctType? type;

  Stack _ads(BuildContext context, NumberFormat formatter, FeedModel model) {
    return Stack(
      children: <Widget>[
        Material(
          borderRadius: BorderRadius.circular(20),
          shadowColor: Colors.yellow[50],
          elevation: 20,
          child: frostedOrange(
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: frostedBlack(
                AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    alignment: Alignment.centerRight,
                    child: model.imagePath == null
                        ? const SizedBox.shrink()
                        : Padding(
                            padding: const EdgeInsets.only(
                              top: 8,
                            ),
                            child: InkWell(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(20),
                              ),
                              onTap: () {},
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                child: SizedBox(
                                  width: fullWidth(context) *
                                          (type == DuctType.Detail ? .95 : .8) -
                                      8,
                                  //decoration: BoxDecoration(),
                                  child: AspectRatio(
                                    aspectRatio: 4 / 3,
                                    child: customNetworkImage(
                                      model.imagePath,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: fullWidth(context) * 0.1,
          right: 10,
          child: GestureDetector(
            onTap: () {},
            child: frostedBlueGray(
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  'Ad',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.purple[500]),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 5,
          left: 0,
          child: GestureDetector(
            onTap: () {},
            child: frostedBlueGray(
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Active',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueGrey[500]),
                      ),
                      IconButton(
                          icon: const Icon(Icons.arrow_forward_ios_rounded),
                          onPressed: () {})
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 5,
          top: 5,
          child: frostedOrange(
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'MacBook',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: fullWidth(context) * 0.05,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 10,
          child: Material(
            elevation: 10,
            shadowColor: TwitterColor.mystic,
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(100),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 5),
                  shape: BoxShape.circle),
              child: RippleButton(
                child: customImage(
                  context,
                  widget.ductProduct!.user!.profilePic,
                  height: 30,
                ),
                borderRadius: BorderRadius.circular(50),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed("/Stores/${widget.ductProduct!.user!.userId}");
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
      decimalDigits: 0,
      locale: Localizations.localeOf(context).toString(),
    );
    // var authState = Provider.of<AuthState>(context);
    //var state = Provider.of<FeedState>(context);

    if (feedState.feedlist != null && feedState.feedlist!.isNotEmpty) {}

    // final Image imageWidget = Image.asset(
    //   widget.ductProduct.productName,
    //   package: widget.ductProduct.imageList[0],
    //   fit: BoxFit.cover,
    // );

    return Consumer<FeedState>(
      builder: (
        context,
        value,
        child,
      ) {
        return
            // widget.ductProduct.caption == 'product'
            //     ? Container()
            //     :
            GestureDetector(
          onTap: () {},
          child: child,
        );
      },
      child: SizedBox(
        width: fullWidth(context),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _ads(context, formatter, widget.ductProduct!),
              SizedBox(
                width: fullWidth(context),
                child: Column(
                  children: [
                    Material(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.transparent,
                      child: ExpandableNotifier(
                          child: ScrollOnExpand(
                              child: Column(
                        children: [
                          ExpandablePanel(
                            theme: const ExpandableThemeData(
                              headerAlignment:
                                  ExpandablePanelHeaderAlignment.center,
                              tapBodyToExpand: true,
                              tapBodyToCollapse: true,
                              hasIcon: false,
                            ),
                            header: Stack(
                              children: [
                                Row(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            frostedPink(Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: customTitleText(
                                                'Performance',
                                              ),
                                            )),
                                          ],
                                        ),
                                        ExpandableIcon(
                                          theme: const ExpandableThemeData(
                                            expandIcon:
                                                Icons.keyboard_arrow_right,
                                            collapseIcon:
                                                Icons.keyboard_arrow_down,
                                            iconSize: 28.0,
                                            iconRotationAngle: math.pi / 2,
                                            iconPadding:
                                                EdgeInsets.only(right: 5),
                                            hasIcon: false,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                            expanded: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15.0),
                              child: frostedWhite(
                                SizedBox(
                                  width: fullWidth(context),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          // setState(() {
                                          //   if (isDropdown) {
                                          //     floatingMenu.remove();
                                          //   } else {
                                          //     //  _postProsductoption();
                                          //     floatingMenu = _profits(context);
                                          //     Overlay.of(context)
                                          //         .insert(floatingMenu);
                                          //   }

                                          //   isDropdown = !isDropdown;
                                          // });
                                          // Navigator.of(context)
                                          //     .pushNamed('/Profit/');
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                frostedPink(Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: customTitleText(
                                                    'Clicks:',
                                                  ),
                                                )),
                                                const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(
                                                    '53446',
                                                    style: TextStyle(
                                                      color: Colors.blueGrey,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(Icons
                                                  .arrow_forward_ios_rounded),
                                            )
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          // setState(() {
                                          //   if (isDropdown) {
                                          //     floatingMenu.remove();
                                          //   } else {
                                          //     //  _postProsductoption();
                                          //     floatingMenu = _profits(context);
                                          //     Overlay.of(context)
                                          //         .insert(floatingMenu);
                                          //   }

                                          //   isDropdown = !isDropdown;
                                          // });
                                          // Navigator.of(context)
                                          //     .pushNamed('/Profit/');
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                frostedPink(Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: customTitleText(
                                                    'Impression:',
                                                  ),
                                                )),
                                                const Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(
                                                    '6475872',
                                                    style: TextStyle(
                                                      color: Colors.blueGrey,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(Icons
                                                  .arrow_forward_ios_rounded),
                                            )
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          // setState(() {
                                          //   if (isDropdown) {
                                          //     floatingMenu.remove();
                                          //   } else {
                                          //     //  _postProsductoption();
                                          //     floatingMenu = _profits(context);
                                          //     Overlay.of(context)
                                          //         .insert(floatingMenu);
                                          //   }

                                          //   isDropdown = !isDropdown;
                                          // });
                                          // Navigator.of(context)
                                          //     .pushNamed('/Profit/');
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                frostedPink(Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: customTitleText(
                                                    'invested:',
                                                  ),
                                                )),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    formatter.format(34556),
                                                    style: const TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Icon(Icons
                                                  .arrow_forward_ios_rounded),
                                            )
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            collapsed: Container(),
                            // expanded: Column(
                            //   children: [],
                            // ),
                          )
                        ],
                      ))),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

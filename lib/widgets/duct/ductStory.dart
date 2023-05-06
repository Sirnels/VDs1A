// ignore_for_file: file_names, unnecessary_null_comparison, deprecated_member_use

import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:appwrite/appwrite.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:lottie/lottie.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

import 'package:video_player/video_player.dart';

import 'dart:ui' as ui;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:viewducts/app_theme/app_theme_constant.dart';
import 'package:viewducts/features/ducts/duct_controller.dart';
import 'package:viewducts/helper/constant.dart';
import 'package:viewducts/helper/theme.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/page/common/general_dialog.dart';
import 'package:viewducts/page/message/item_Search_bar.dart';
import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/duct/ductStoryPage.dart';
import 'package:viewducts/widgets/duct/ductsaudioplayer.dart';
import 'package:viewducts/widgets/frosted.dart';
import 'package:viewducts/widgets/newWidget/customUrlText.dart';
import 'package:viewducts/widgets/newWidget/title_text.dart';
import 'package:viewducts/widgets/rating_star.dart';

/// Indicates where the progress indicators should be placed.
enum ProgressPosition { top, bottom }

/// This is used to specify the height of the progress indicator. Inline stories
/// should use [small]
enum IndicatorHeight { small, large }

/// This is a representation of a story item (or page).
class DuctStoryItem {
  /// Specifies how long the page should be displayed. It should be a reasonable
  /// amount of time greater than 0 milliseconds.
  final Duration duration;

  /// Has this page been shown already? This is used to indicate that the page
  /// has been displayed. If some pages are supposed to be skipped in a story,
  /// mark them as shown `shown = true`.
  ///
  /// However, during initialization of the story view, all pages after the
  /// last unshown page will have their `shown` attribute altered to false. This
  /// is because the next item to be displayed is taken by the last unshown
  /// story item.
  bool shown;

  /// The page content
  final Widget view;
  DuctStoryItem(
    this.view, {
    required this.duration,
    this.shown = false,
  });

  /// Short hand to create text-only page.
  ///
  /// [title] is the text to be displayed on [backgroundColor]. The text color
  /// alternates between [Colors.black] and [Colors.white] depending on the
  /// calculated contrast. This is to ensure readability of text.
  ///
  /// Works for inline and full-page stories. See [DuctstoryView.inline] for more on
  /// what inline/full-page means.
  static DuctStoryItem text({
    required String title,
    required Color backgroundColor,
    Key? key,
    String? time,
    String? id,
    String? userId,
    String? audioTage,
    AudioPlayer? audioPlayer,
    required BuildContext context,
    required DuctStoryModel currentStory,
    required WidgetRef ref,
    required ViewductsUser currentUser,
    required ViewductsUser secondUser,
    required FeedModel model,
    required ViewductsUser vendor,
    //String? imagePath,
    //Function? onTapchat,
    String? userName,
    String? cImage,
    String? comment,
    String? cName,
    String? cPrice,
    String? productDescription,
    TextStyle? textStyle,
    bool shown = false,
    bool roundedTop = false,
    bool roundedBottom = false,
    Duration? duration,
  }) {
    double contrast = ContrastHelper.contrast([
      backgroundColor.red,
      backgroundColor.green,
      backgroundColor.blue,
    ], [
      255,
      255,
      255
    ] /** white text */);

    // feedState.addUserSeenStoryView(id, userId);

    return DuctStoryItem(
      //  feedState.addUserSeenStoryView(id),
      Stack(
        children: [
          Container(
            key: key,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(roundedTop ? 8 : 0),
                bottom: Radius.circular(roundedBottom ? 8 : 0),
              ),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black.withOpacity(.5),
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
                        text: title,
                        style: textStyle?.copyWith(
                              color: contrast > 1.8
                                  ? CupertinoColors.systemYellow
                                  : Colors.yellow,
                            ) ??
                            TextStyle(
                              color: contrast > 1.8
                                  ? CupertinoColors.systemYellow
                                  : Colors.yellow,
                              fontSize: 18,
                            ),
                        textAlign: TextAlign.center,
                        linkStyle: TextStyle(color: Colors.blueGrey))),
              ),
            ),
            //color: backgroundColor,
          ),
          Positioned(
              top: Get.height * 0.11,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  customText(userName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.yellow)),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.blueGrey.withOpacity(.5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 4),
                          child: time == null
                              ? Container()
                              : customText(
                                  timeago
                                      .format(Timestamp.fromDate(
                                              DateTime.parse(time.toString()))
                                          .toDate())
                                      .toString(),
                                  //getWhen(time),
                                  style: const TextStyle(color: Colors.white)),
                        ),
                      ),
                      // frostedTeal(
                      //   Padding(
                      //     padding: const EdgeInsets.all(2.0),
                      //     child: customText(
                      //       ':${getChatTime(time)}',
                      //       style: const TextStyle(color: Colors.white
                      //           //  Theme.of(context)
                      //           //     .colorScheme
                      //           //     .onPrimary,
                      //           ),
                      //       //style: userNameStyle
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              )),
          audioTage == null
              ? Container()
              : Positioned(
                  top: Get.height * 0.11,
                  left: 20,
                  child: DuctsAudioPlayer(
                    audioFile: audioTage,
                  )),
        ],
      ),
      shown: shown,
      duration: duration ?? const Duration(seconds: 15),
    );
  }

  static DuctStoryItem widget({
    Widget? widget,
    Color? backgroundColor,
    Key? key,
    TextStyle? textStyle,
    bool shown = false,
    bool roundedTop = false,
    bool roundedBottom = false,
    Duration? duration,
  }) {
    // double contrast = ContrastHelper.contrast([
    //   backgroundColor.red,
    //   backgroundColor.green,
    //   backgroundColor.blue,
    // ], [
    //   255,
    //   255,
    //   255
    // ] /** white text */);

    return DuctStoryItem(
      Container(
        key: key,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(roundedTop ? 8 : 0),
            bottom: Radius.circular(roundedBottom ? 8 : 0),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        child: Center(child: widget
            // Text(
            //   title,
            //   style: textStyle?.copyWith(
            //         color: contrast > 1.8 ? Colors.white : Colors.black,
            //       ) ??
            //       TextStyle(
            //         color: contrast > 1.8 ? Colors.white : Colors.black,
            //         fontSize: 18,
            //       ),
            //   textAlign: TextAlign.center,
            // ),
            ),
        //color: backgroundColor,
      ),
      shown: shown,
      duration: duration ?? const Duration(seconds: 10),
    );
  }

  /// Factory constructor for page images. [controller] should be same instance as
  /// one passed to the `DuctstoryView`
  factory DuctStoryItem.pageImage({
    String? url,
    DuctStoryController? controller,
    Key? key,
    AudioPlayer? audioPlayer,
    String? time,
    String? id,
    String? userId,
    String? audioTage,
    String? imagePath,
    String? productDescription,
    Function? onTapchat,
    String? userName,
    String? cImage,
    String? comment,
    String? cName,
    String? cPrice,
    required BuildContext context,
    BoxFit imageFit = BoxFit.fitWidth,
    String? caption,
    bool shown = false,
    Map<String, dynamic>? requestHeaders,
    Duration? duration,
  }) {
    // feedState.addUserSeenStoryView(id, userId);
    cprint(url.toString());

    return DuctStoryItem(
      Container(
        key: key,
        color: Colors.black,
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: SizedBox(
                  height: Get.height,
                  width: Get.width,
                  child: customNetworkImage(url.toString(), fit: BoxFit.cover)
                  //  FutureBuilder(
                  //   future: storage.getFileView(
                  //       bucketId: ductFile,
                  //       fileId: url
                  //           .toString()), //works for both public file and private file, for private files you need to be logged in
                  //   builder: (context, snapshot) {
                  //     return snapshot.data != null
                  //         ? Image.memory(snapshot.data as Uint8List,
                  //             width: Get.height * 0.3,
                  //             height: Get.height * 0.4,
                  //             fit: BoxFit.cover)
                  //         : Center(
                  //             child: SizedBox(
                  //             width: Get.height * 0.2,
                  //             height: Get.height * 0.2,
                  //             child: LoadingIndicator(
                  //                 indicatorType: Indicator.ballTrianglePath,

                  //                 /// Required, The loading type of the widget
                  //                 colors: const [
                  //                   Colors.pink,
                  //                   Colors.green,
                  //                   Colors.blue
                  //                 ],

                  //                 /// Optional, The color collections
                  //                 strokeWidth: 0.5,

                  //                 /// Optional, The stroke of the line, only applicable to widget which contains line
                  //                 backgroundColor: Colors.transparent,

                  //                 /// Optional, Background of the widget
                  //                 pathBackgroundColor: Colors.blue

                  //                 /// Optional, the stroke backgroundColor
                  //                 ),
                  //           )
                  //             //  CircularProgressIndicator
                  //             //     .adaptive()
                  //             );
                  //   },
                  // ),
                  //  customNetworkImage(
                  //   url,
                  //   fit: BoxFit.cover,
                  // ),
                  ),
            ),
            // DuctStoryImage.url(
            //   url,
            //   controller: controller,
            //   fit: imageFit,
            //   requestHeaders: requestHeaders,
            // ),
            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(
                    bottom: 24,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  color: caption != null ? Colors.black54 : Colors.transparent,
                  child: caption != null
                      ? Text(
                          caption,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        )
                      : const SizedBox(),
                ),
              ),
            ),

            // Positioned(
            //   bottom: Get.height * 0.01,
            //   left: 0,
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            //         Padding(
            //           padding: const EdgeInsets.all(8.0),
            //           child: Container(
            //             alignment: Alignment.center,
            //             child: SizedBox(
            //                 height: Get.width * 0.2,
            //                 width: Get.width * 0.2,
            //                 child: FutureBuilder(
            //                     future: storage.getFileView(
            //                         bucketId: productBucketId,
            //                         fileId: cImage.toString()),
            //                     builder: (context, snap) {
            //                       return urls?.image != null
            //                           ? Container(
            //                               decoration: BoxDecoration(
            //                                   borderRadius:
            //                                       BorderRadius.circular(5),
            //                                   image: DecorationImage(
            //                                       image: urls?.image ??
            //                                           customAdvanceNetworkImage(
            //                                               dummyProfilePic),
            //                                       fit: BoxFit.cover),
            //                                   color: Colors.blueGrey[50],
            //                                   gradient: LinearGradient(
            //                                     colors: [
            //                                       Colors.yellow
            //                                           .withOpacity(0.1),
            //                                       Colors.white60
            //                                           .withOpacity(0.2),
            //                                       Colors.pink.withOpacity(0.3)
            //                                     ],
            //                                     // begin: Alignment.topCenter,
            //                                     // end: Alignment.bottomCenter,
            //                                   )),
            //                             )
            //                           : Center(
            //                               child: LoadingIndicator(
            //                                   indicatorType:
            //                                       Indicator.ballTrianglePath,

            //                                   /// Required, The loading type of the widget
            //                                   colors: const [
            //                                     Colors.pink,
            //                                     Colors.green,
            //                                     Colors.blue
            //                                   ],

            //                                   /// Optional, The color collections
            //                                   strokeWidth: 0.5,

            //                                   /// Optional, The stroke of the line, only applicable to widget which contains line
            //                                   backgroundColor:
            //                                       Colors.transparent,

            //                                   /// Optional, Background of the widget
            //                                   pathBackgroundColor: Colors.blue

            //                                   /// Optional, the stroke backgroundColor
            //                                   )
            //                               //  CircularProgressIndicator
            //                               //     .adaptive()
            //                               );
            //                     })
            //                 //  customNetworkImage(
            //                 //   cImage,
            //                 //   fit: BoxFit.cover,
            //                 // ),
            //                 ),
            //           ),
            //         ),
            //         Column(
            //           crossAxisAlignment: CrossAxisAlignment.end,
            //           children: [
            //             customText(cName,
            //                 style: const TextStyle(
            //                     fontWeight: FontWeight.bold,
            //                     color: Colors.yellow)),
            //             frostedTeal(
            //               Padding(
            //                 padding: const EdgeInsets.all(2.0),
            //                 child: Row(
            //                   children: [
            //                     customText(
            //                       NumberFormat.currency(
            //                               name: authState.userModel!.location ==
            //                                       'Nigeria'
            //                                   ? '₦'
            //                                   : '£')
            //                           .format(double.parse(cPrice.toString())),

            //                       style: TextStyle(
            //                           color: Colors.white,
            //                           fontSize: Get.width * 0.08
            //                           //  Theme.of(context)
            //                           //     .colorScheme
            //                           //     .onPrimary,
            //                           ),
            //                       //style: userNameStyle
            //                     ),
            //                   ],
            //                 ),
            //               ),
            //             ),
            //           ],
            //         )
            //       ]),
            //     ],
            //   ),
            // ),
            audioTage == null
                ? Container()
                : Positioned(
                    top: Get.height * 0.11,
                    left: 20,
                    child: DuctsAudioPlayer(
                      audioFile: audioTage,
                    ))
          ],
        ),
      ),
      shown: shown,
      duration: duration ?? const Duration(seconds: 30),
    );
  }

  /// Factory constructor for page images. [controller] should be same instance as
  /// one passed to the `DuctstoryView`
  factory DuctStoryItem.productViewImage({
    String? url,
    DuctStoryController? controller,
    Key? key,
    String? time,
    String? imagePath,
    dynamic sizeValue,
    bool selected = false,
    // Function? onTapchat,
    // Function? addItems,
    List<dynamic>? colors,
    String? price,
    String? productDescription,
    Duration? duration,
    BoxFit imageFit = BoxFit.fitWidth,
    String? caption,
    bool shown = false,
    required BuildContext context,
    Map<String, dynamic>? requestHeaders,
  }) {
    //  feedState.addUserSeenStoryView(id, userId);
    Storage storage = Storage(clientConnect());
    Image? urls;
    storage
        .getFileView(bucketId: productBucketId, fileId: imagePath.toString())
        .then((bytes) {
      urls = Image.memory(bytes);
    });

    return DuctStoryItem(
        Container(
          key: key,
          color: Colors.black,
          child: Stack(
            children: <Widget>[
              // FutureBuilder(
              //     future: storage.getFileView(
              //         bucketId: productBucketId, fileId: imagePath.toString()),
              //     builder: (context, snap) {
              //       return urls?.image != null
              //           ? Container(
              //               decoration: BoxDecoration(
              //                   borderRadius: BorderRadius.circular(5),
              //                   image: DecorationImage(
              //                       image: urls?.image ??
              //                           customAdvanceNetworkImage(
              //                               dummyProfilePic),
              //                       fit: BoxFit.fill),
              //                   color: Colors.blueGrey[50],
              //                   gradient: LinearGradient(
              //                     colors: [
              //                       Colors.yellow.withOpacity(0.1),
              //                       Colors.yellow.withOpacity(0.2),
              //                       Colors.yellow.withOpacity(0.3)
              //                     ],
              //                     // begin: Alignment.topCenter,
              //                     // end: Alignment.bottomCenter,
              //                   )),
              //             )
              //           : CircularProgressIndicator.adaptive();
              //     }),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(
                  color: (Colors.white12).withOpacity(0.4),
                ),
              ),
              FutureBuilder(
                  future: storage.getFileView(
                      bucketId: productBucketId, fileId: imagePath.toString()),
                  builder: (context, snap) {
                    return urls?.image != null
                        ? Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(
                                    image: urls?.image ??
                                        customAdvanceNetworkImage(
                                            dummyProfilePic),
                                    fit: BoxFit.fitWidth),
                                color: Colors.blueGrey[50],
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.yellow.withOpacity(0.1),
                                    Colors.yellow.withOpacity(0.2),
                                    Colors.yellow.withOpacity(0.3)
                                  ],
                                  // begin: Alignment.topCenter,
                                  // end: Alignment.bottomCenter,
                                )),
                          )
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
                  }),
              SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 24),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    color:
                        caption != null ? Colors.black54 : Colors.transparent,
                    child: caption != null
                        ? Text(
                            caption,
                            style: const TextStyle(
                                fontSize: 15, color: Colors.white),
                            textAlign: TextAlign.center,
                          )
                        : const SizedBox(),
                  ),
                ),
              ),
              Positioned(
                bottom: Get.height * 0.05,
                left: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(20),
                      child: SizedBox(
                          width: context.responsiveValue(
                              mobile: Get.height * 0.1,
                              tablet: Get.height * 0.1,
                              desktop: Get.height * 0.1),
                          height: context.responsiveValue(
                              mobile: Get.height * 0.1,
                              tablet: Get.height * 0.1,
                              desktop: Get.height * 0.1),
                          child: FutureBuilder(
                              future: storage.getFileView(
                                  bucketId: productBucketId,
                                  fileId: imagePath.toString()),
                              builder: (context, snap) {
                                return snap.hasData && snap.data != null ||
                                        urls?.image != null
                                    ? Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            image: DecorationImage(
                                                image: urls?.image ??
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
                              })
                          //  customNetworkImage(
                          //   imagePath,
                          //   fit: BoxFit.cover,
                          // ),
                          ),
                    ),
                    SingleChildScrollView(
                      child: SizedBox(
                        width: Get.width - 100,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: frostedBlack(
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: UrlText(
                                      text: 'Description',
                                      onHashTagPressed: (tag) {
                                        cprint(tag);
                                      },
                                      style: TextStyle(
                                          color: Theme.of(Get.context!)
                                              .colorScheme
                                              .onPrimary,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                      urlStyle: const TextStyle(
                                          color: Colors.blue,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                              frostedBlack(
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: UrlText(
                                    text: productDescription,
                                    onHashTagPressed: (tag) {
                                      cprint(tag);
                                    },
                                    style: TextStyle(
                                        color: Theme.of(Get.context!)
                                            .colorScheme
                                            .onPrimary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                    urlStyle: const TextStyle(
                                        color: Colors.blue,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
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
              Positioned(
                top: 30,
                left: 10,
                child: Container(
                    height: context.responsiveValue(
                        mobile: Get.height * 0.08,
                        tablet: Get.height * 0.09,
                        desktop: Get.height * 0.12),
                    //  width: Get.width * 0.2,
                    padding: const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blueGrey[50],
                      gradient: LinearGradient(
                        colors: [
                          Colors.yellow.withOpacity(0.7),
                          Colors.white54.withOpacity(0.8),
                          Colors.orange.shade200.withOpacity(0.9)
                          // Color(0xfffbfbfb),
                          // Color(0xfff7f7f7),
                        ],
                        // begin: Alignment.topCenter,
                        // end: Alignment.bottomCenter,
                      ),
                    ),
                    // decoration: BoxDecoration(
                    //     shape: BoxShape.circle,
                    //     color: Colors.white),
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
                                  NumberFormat.currency(
                                          name: authState.userModel!.location ==
                                                  'Nigeria'
                                              ? '₦'
                                              : '£')
                                      .format(double.parse(price.toString())),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: context.responsiveValue(
                                        mobile: Get.height * 0.025,
                                        tablet: Get.height * 0.025,
                                        desktop: Get.height * 0.028),
                                  ),
                                  context: context),
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ),
        shown: shown,
        duration: duration ?? const Duration(seconds: 10));
  }

  /// Shorthand for creating inline image. [controller] should be same instance as
  /// one passed to the `DuctstoryView`
  factory DuctStoryItem.inlineImage({
    String? url,
    Text? caption,
    DuctStoryController? controller,
    Key? key,
    BoxFit imageFit = BoxFit.cover,
    Map<String, dynamic>? requestHeaders,
    bool shown = false,
    bool roundedTop = true,
    bool roundedBottom = false,
    Duration? duration,
  }) {
    return DuctStoryItem(
      ClipRRect(
        key: key,
        child: Container(
          color: Colors.grey[100],
          child: Container(
            color: Colors.black,
            child: Stack(
              children: <Widget>[
                DuctStoryImage.url(
                  url,
                  controller: controller,
                  fit: imageFit,
                  requestHeaders: requestHeaders,
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: SizedBox(
                      child: caption ?? const SizedBox(),
                      width: double.infinity,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(roundedTop ? 8 : 0),
          bottom: Radius.circular(roundedBottom ? 8 : 0),
        ),
      ),
      shown: shown,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  /// Shorthand for creating page video. [controller] should be same instance as
  /// one passed to the `productstoryView`
  factory DuctStoryItem.productView(
    String? url, {
    DuctStoryController? controller,
    VideoPlayerController? controlleronline,
    Key? key,
    String? time,
    String? imagePath,
    dynamic sizeValue,
    ViewductsUser? currentUser,
    int? rating,
    bool selected = false,
    // Function? onTapchat,
    // Function? addItems,
    List<dynamic>? colors,
    String? price,
    int? salePrice,
    // String? productDescription,
    Duration? duration,
    BoxFit imageFit = BoxFit.fitWidth,
    String? caption,
    bool shown = false,
    required BuildContext context,
    Map<String, dynamic>? requestHeaders,
  }) {
    // Image? urls;
    // storage
    //     .getFileView(bucketId: productBucketId, fileId: imagePath.toString())
    //     .then((bytes) {
    //   urls = Image.memory(bytes);
    // });
    return DuctStoryItem(
        Container(
          key: key,
          color: Colors.black,
          child: Stack(
            children: <Widget>[
              // DuctStoryProduct.url(
              //   url,
              //   controller: controller,
              //   requestHeaders: requestHeaders,
              // ),
              SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 24),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    color:
                        caption != null ? Colors.black54 : Colors.transparent,
                    child: caption != null
                        ? Text(
                            caption,
                            style: const TextStyle(
                                fontSize: 15, color: Colors.white),
                            textAlign: TextAlign.center,
                          )
                        : const SizedBox(),
                  ),
                ),
              ),

              Positioned(
                top: 30,
                left: 10,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                            height: Get.height * 0.08,
                            //  width: Get.width * 0.2,
                            padding: const EdgeInsets.all(0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.blueGrey[50],
                              gradient: LinearGradient(
                                colors: [
                                  Colors.yellow.withOpacity(0.7),
                                  Colors.white54.withOpacity(0.8),
                                  Colors.orange.shade200.withOpacity(0.9)
                                  // Color(0xfffbfbfb),
                                  // Color(0xfff7f7f7),
                                ],
                                // begin: Alignment.topCenter,
                                // end: Alignment.bottomCenter,
                              ),
                            ),
                            // decoration: BoxDecoration(
                            //     shape: BoxShape.circle,
                            //     color: Colors.white),
                            child: Material(
                              elevation: 10,
                              //borderRadius: BorderRadius.circular(100),
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: salePrice == 0 || salePrice == null
                                          ? customText(
                                              NumberFormat.currency(
                                                      name: currentUser
                                                                  ?.location ==
                                                              'Nigeria'
                                                          ? '₦'
                                                          : '£')
                                                  .format(double.parse(
                                                      price ?? '0')),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              context: context)
                                          : customText(
                                              NumberFormat.currency(
                                                      name: currentUser
                                                                  ?.location ==
                                                              'Nigeria'
                                                          ? '₦'
                                                          : '£')
                                                  .format(double.parse(
                                                      salePrice.toString())),
                                              style: TextStyle(
                                                color:
                                                    CupertinoColors.systemRed,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              context: context),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        salePrice == 0 || salePrice == null
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              offset: const Offset(0, 11),
                                              blurRadius: 11,
                                              color: Colors.black
                                                  .withOpacity(0.06))
                                        ],
                                        borderRadius: BorderRadius.circular(18),
                                        color: CupertinoColors.systemRed),
                                    padding: const EdgeInsets.all(5.0),
                                    child: TitleText(
                                      'On Sale',
                                      color:
                                          CupertinoColors.lightBackgroundGray,
                                    )),
                              ),
                      ],
                    ),
                    // rating == null
                    //     ? Container()
                    //     : SingleChildScrollView(
                    //         scrollDirection: Axis.horizontal,
                    //         child: Row(
                    //           children: [
                    //             RatingStatWidget(
                    //                 // ignore: division_optimization
                    //                 rating: rating),
                    //             Container(
                    //               decoration: BoxDecoration(
                    //                   boxShadow: [
                    //                     BoxShadow(
                    //                         offset: const Offset(0, 11),
                    //                         blurRadius: 11,
                    //                         color:
                    //                             Colors.black.withOpacity(0.06))
                    //                   ],
                    //                   borderRadius: BorderRadius.circular(5),
                    //                   color:
                    //                       CupertinoColors.lightBackgroundGray),
                    //               padding: const EdgeInsets.symmetric(
                    //                   horizontal: 5.0),
                    //               child: TitleText(
                    //                 userCartController
                    //                     .productReviewModelComment.length
                    //                     .toString(),
                    //                 color: CupertinoColors.darkBackgroundGray,
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                  ],
                ),
              ),
            ],
          ),
        ),
        shown: shown,
        duration: duration ?? const Duration(seconds: 10));
  }

  /// Shorthand for creating page video. [controller] should be same instance as
  /// one passed to the `DuctstoryView`
  factory DuctStoryItem.pageVideo(
    String? url, {
    DuctStoryController? controller,
    Key? key,
    String? time,
    String? imagePath,
    Function? onTapchat,
    String? id,
    String? userId,
    String? cImage,
    String? comment,
    String? cName,
    String? cPrice,
    String? productDescription,
    Duration? duration,
    BoxFit imageFit = BoxFit.fitWidth,
    String? caption,
    bool shown = false,
    required BuildContext context,
    Map<String, dynamic>? requestHeaders,
  }) {
    // feedState.addUserSeenStoryView(id, userId);
    return DuctStoryItem(
        Container(
          key: key,
          color: Colors.black,
          child: Stack(
            children: <Widget>[
              DuctStoryVideo.url(
                url,
                controller: controller,
                requestHeaders: requestHeaders,
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                      bottom: 24,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    color:
                        caption != null ? Colors.black54 : Colors.transparent,
                    child: caption != null
                        ? Text(
                            caption,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          )
                        : const SizedBox(),
                  ),
                ),
              ),
              Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    height: Get.height * 0.3,
                    width: Get.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      //color: Colors.blueGrey[50]
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF212332).withOpacity(0.1),
                          const Color(0xFF212332).withOpacity(0.3),
                          const Color(0xFF212332).withOpacity(0.5)
                          // Color(0xfffbfbfb),
                          // Color(0xfff7f7f7),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  )),
              Positioned(
                bottom: Get.height * 0.01,
                left: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          alignment: Alignment.center,
                          child: SizedBox(
                            height: Get.width * 0.2,
                            width: Get.width * 0.2,
                            child: customNetworkImage(
                              cImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          customText(cName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.yellow)),
                          frostedTeal(
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Row(
                                children: [
                                  customText(
                                    NumberFormat.currency(
                                            name:
                                                authState.userModel!.location ==
                                                        'Nigeria'
                                                    ? '₦'
                                                    : '£')
                                        .format(
                                            double.parse(cPrice.toString())),

                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Get.width * 0.08
                                        //  Theme.of(context)
                                        //     .colorScheme
                                        //     .onPrimary,
                                        ),
                                    //style: userNameStyle
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
        shown: shown,
        duration: duration ?? const Duration(seconds: 10));
  }

  /// Shorthand for creating page video. [controller] should be same instance as
  /// one passed to the `DuctstoryView`
  factory DuctStoryItem.addDuctVideo(
    String? url, {
    DuctStoryController? controller,
    Key? key,
    String? time,
    String? imagePath,
    Function? onTapchat,
    String? comment,
    String? productDescription,
    Duration? duration,
    BoxFit imageFit = BoxFit.fitWidth,
    String? caption,
    bool shown = false,
    required BuildContext context,
    Map<String, dynamic>? requestHeaders,
  }) {
    return DuctStoryItem(
        Container(
          key: key,
          color: Colors.black,
          child: Stack(
            children: <Widget>[
              AddDuctVideo.url(
                url,
                controller: controller,
                requestHeaders: requestHeaders,
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 24),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    color:
                        caption != null ? Colors.black54 : Colors.transparent,
                    child: caption != null
                        ? Text(
                            caption,
                            style: const TextStyle(
                                fontSize: 15, color: Colors.white),
                            textAlign: TextAlign.center,
                          )
                        : const SizedBox(),
                  ),
                ),
              ),
              // Positioned(
              //   bottom: Get.height * 0.01,
              //   left: 0,
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Material(
              //         elevation: 10,
              //         borderRadius: BorderRadius.circular(20),
              //         child: SizedBox(
              //           width: fullWidth(context) * 0.2,
              //           height: fullWidth(context) * 0.2,
              //           child: customNetworkImage(
              //             imagePath,
              //             fit: BoxFit.cover,
              //           ),
              //         ),
              //       ),
              //       Container(
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(25),
              //           color: Colors.blueGrey.withOpacity(.5),
              //         ),
              //         child: Padding(
              //           padding: const EdgeInsets.symmetric(
              //               horizontal: 4, vertical: 4),
              //           child: customText(
              //               timeago
              //                   .format(Timestamp.fromDate(
              //                           DateTime.parse(time.toString()))
              //                       .toDate())
              //                   .toString(),
              //               //getWhen(time),
              //               style: const TextStyle(color: Colors.white)),
              //         ),
              //       ),
              //       SizedBox(
              //         width: Get.width - 100,
              //         child: Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.start,
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               frostedBlack(
              //                 Padding(
              //                   padding: const EdgeInsets.all(4.0),
              //                   child: UrlText(
              //                     text: comment,
              //                     onHashTagPressed: (tag) {
              //                       cprint(tag);
              //                     },
              //                     style: TextStyle(
              //                         color: Theme.of(Get.context!)
              //                             .colorScheme
              //                             .onPrimary,
              //                         fontSize: 14,
              //                         fontWeight: FontWeight.w400),
              //                     urlStyle: const TextStyle(
              //                         color: Colors.blue,
              //                         fontSize: 14,
              //                         fontWeight: FontWeight.w400),
              //                   ),
              //                 ),
              //               ),
              //               frostedBlack(
              //                 Padding(
              //                   padding: const EdgeInsets.all(4.0),
              //                   child: UrlText(
              //                     text: 'Description',
              //                     onHashTagPressed: (tag) {
              //                       cprint(tag);
              //                     },
              //                     style: TextStyle(
              //                         color: Theme.of(Get.context!)
              //                             .colorScheme
              //                             .onPrimary,
              //                         fontSize: 18,
              //                         fontWeight: FontWeight.w600),
              //                     urlStyle: const TextStyle(
              //                         color: Colors.blue,
              //                         fontSize: 18,
              //                         fontWeight: FontWeight.w600),
              //                   ),
              //                 ),
              //               ),
              //               frostedBlack(
              //                 Padding(
              //                   padding: const EdgeInsets.all(4.0),
              //                   child: UrlText(
              //                     text: productDescription,
              //                     onHashTagPressed: (tag) {
              //                       cprint(tag);
              //                     },
              //                     style: TextStyle(
              //                         color: Theme.of(Get.context!)
              //                             .colorScheme
              //                             .onPrimary,
              //                         fontSize: 14,
              //                         fontWeight: FontWeight.w400),
              //                     urlStyle: const TextStyle(
              //                         color: Colors.blue,
              //                         fontSize: 14,
              //                         fontWeight: FontWeight.w400),
              //                   ),
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // Positioned(
              //   bottom: 10,
              //   right: 10,
              //   child: Column(
              //     children: [
              //       Padding(
              //         padding: const EdgeInsets.all(8.0),
              //         child: GestureDetector(
              //           onTap: () {},
              //           child: Container(
              //               padding: const EdgeInsets.all(0),
              //               decoration: BoxDecoration(
              //                 shape: BoxShape.circle,
              //                 color: Colors.yellow.withOpacity(0.9),
              //               ),
              //               child: const Padding(
              //                 padding: EdgeInsets.all(8.0),
              //                 child: Text(
              //                   'Buy',
              //                   style: TextStyle(
              //                     color: Colors.black87,
              //                     fontFamily: 'HelveticaNeue',
              //                     fontWeight: FontWeight.w900,
              //                     fontSize: 20,
              //                   ),
              //                 ),
              //               )),
              //         ),
              //       ),
              //       customInkWell(
              //         context: context,
              //         onPressed: () {
              //           if (onTapchat != null) {
              //             onTapchat();
              //           }
              //         },
              //         child: CircleAvatar(
              //             radius: Get.height * 0.05,
              //             backgroundColor: Colors.black87.withOpacity(0.5),
              //             child: Lottie.asset(
              //               'assets/lottie/chat-box-animation.json',
              //             )),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
        shown: shown,
        duration: duration ?? const Duration(seconds: 10));
  }

  /// Shorthand for creating a story item from an image provider such as `AssetImage`
  /// or `NetworkImage`. However, the story continues to play while the image loads
  /// up.
  factory DuctStoryItem.pageProviderImage(
    ImageProvider image, {
    Key? key,
    BoxFit imageFit = BoxFit.fitWidth,
    String? caption,
    bool shown = false,
    Duration? duration,
  }) {
    return DuctStoryItem(
        Container(
          key: key,
          color: Colors.black,
          child: Stack(
            children: <Widget>[
              Center(
                child: Image(
                  image: image,
                  height: double.infinity,
                  width: double.infinity,
                  fit: imageFit,
                ),
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                      bottom: 24,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    color:
                        caption != null ? Colors.black54 : Colors.transparent,
                    child: caption != null
                        ? Text(
                            caption,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          )
                        : const SizedBox(),
                  ),
                ),
              )
            ],
          ),
        ),
        shown: shown,
        duration: duration ?? const Duration(seconds: 3));
  }

  /// Shorthand for creating an inline story item from an image provider such as `AssetImage`
  /// or `NetworkImage`. However, the story continues to play while the image loads
  /// up.
  factory DuctStoryItem.inlineProviderImage(
    ImageProvider image, {
    Key? key,
    Text? caption,
    bool shown = false,
    bool roundedTop = true,
    bool roundedBottom = false,
    Duration? duration,
  }) {
    return DuctStoryItem(
      Container(
        key: key,
        decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(roundedTop ? 8 : 0),
              bottom: Radius.circular(roundedBottom ? 8 : 0),
            ),
            image: DecorationImage(
              image: image,
              fit: BoxFit.cover,
            )),
        child: Container(
          margin: const EdgeInsets.only(
            bottom: 16,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 8,
          ),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: SizedBox(
              child: caption ?? const SizedBox(),
              width: double.infinity,
            ),
          ),
        ),
      ),
      shown: shown,
      duration: duration ?? const Duration(seconds: 3),
    );
  }
}

/// Widget to display stories just like Whatsapp and Instagram. Can also be used
/// inline/inside [ListView] or [Column] just like Google News app. Comes with
/// gestures to pause, forward and go to previous page.
class DuctstoryView extends StatefulWidget {
  /// The pages to displayed.
  final List<DuctStoryItem?> storyItems;

  /// Callback for when a full cycle of story is shown. This will be called
  /// each time the full story completes when [repeat] is set to `true`.
  final VoidCallback? onComplete;

  /// Callback for when a vertical swipe gesture is detected. If you do not
  /// want to listen to such event, do not provide it. For instance,
  /// for inline stories inside ListViews, it is preferrable to not to
  /// provide this callback so as to enable scroll events on the list view.
  final Function(Direction?)? onVerticalSwipeComplete;

  /// Callback for when a story is currently being shown.
  final ValueChanged<DuctStoryItem>? onStoryShow;

  /// Where the progress indicator should be placed.
  final ProgressPosition progressPosition;

  /// Should the story be repeated forever?
  final bool repeat;

  /// If you would like to display the story as full-page, then set this to
  /// `false`. But in case you would display this as part of a page (eg. in
  /// a [ListView] or [Column]) then set this to `true`.
  final bool inline;

  // Controls the playback of the stories
  final DuctStoryController? controller;

  const DuctstoryView({
    Key? key,
    required this.storyItems,
    required this.controller,
    this.onComplete,
    this.onStoryShow,
    this.progressPosition = ProgressPosition.top,
    this.repeat = false,
    this.inline = false,
    this.onVerticalSwipeComplete,
  }) : super(key: key);
  // : assert(storyItems != null && storyItems.isNotEmpty,
  //           "[storyItems] should not be null or empty"),
  //       super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DuctstoryViewState();
  }
}

class DuctstoryViewState extends State<DuctstoryView>
    with TickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _currentAnimation;
  Timer? _nextDebouncer;

  StreamSubscription<PlaybackState>? _playbackSubscription;

  VerticalDragInfo? verticalDragInfo;

  DuctStoryItem? get _currentStory {
    return widget.storyItems.firstWhereOrNull((it) => !it!.shown);
  }

  Widget get _currentView {
    var item = widget.storyItems.firstWhereOrNull((it) => !it!.shown);
    item ??= widget.storyItems.last;
    return item?.view ?? Container();
  }

  @override
  void initState() {
    super.initState();

    // All pages after the first unshown page should have their shown value as
    // false
    final firstPage = widget.storyItems.firstWhereOrNull((it) => !it!.shown);
    if (firstPage == null) {
      for (var it2 in widget.storyItems) {
        it2!.shown = false;
      }
    } else {
      final lastShownPos = widget.storyItems.indexOf(firstPage);
      widget.storyItems.sublist(lastShownPos).forEach((it) {
        it!.shown = false;
      });
    }

    _playbackSubscription =
        widget.controller!.playbackNotifier.listen((playbackStatus) {
      switch (playbackStatus) {
        case PlaybackState.play:
          _removeNextHold();
          _animationController?.forward();
          break;

        case PlaybackState.pause:
          _holdNext(); // then pause animation
          _animationController?.stop(canceled: false);
          break;

        case PlaybackState.next:
          _removeNextHold();
          _goForward();
          break;

        case PlaybackState.previous:
          _removeNextHold();
          _goBack();
          break;
      }
    });

    _play();
  }

  @override
  void dispose() {
    _clearDebouncer();

    _animationController?.dispose();
    _playbackSubscription?.cancel();

    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void _play() {
    _animationController?.dispose();
    // final item =
    //     DuctStoryItem(Container(), duration: Duration(seconds: 10));
    // get the next playing page
    final storyItem = widget.storyItems.firstWhere(
      (it) => !it!.shown,
      // orElse: () => DuctStoryItem.text(
      //     title: '', backgroundColor: Colors.transparent, context: context)
      //DuctStoryItem(Column(children: []), duration: Duration()),
    );

    if (widget.onStoryShow != null) {
      widget.onStoryShow!(storyItem!);
    }

    _animationController =
        AnimationController(duration: storyItem?.duration, vsync: this);

    _animationController!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        storyItem?.shown = true;
        if (widget.storyItems.last != storyItem) {
          _beginPlay();
        } else {
          // done playing
          _onComplete();
        }
      }
    });

    _currentAnimation =
        Tween(begin: 0.0, end: 1.0).animate(_animationController!);

    widget.controller!.play();
  }

  void _beginPlay() {
    setState(() {});
    _play();
  }

  void _onComplete() {
    if (widget.onComplete != null) {
      widget.controller!.pause();
      widget.onComplete!();
    }

    if (widget.repeat) {
      for (var it in widget.storyItems) {
        it!.shown = false;
      }

      _beginPlay();
    }
  }

  void _goBack() {
    _animationController!.stop();

    if (_currentStory == null) {
      widget.storyItems.last!.shown = false;
    }

    if (_currentStory == widget.storyItems.first) {
      _beginPlay();
    } else {
      _currentStory!.shown = false;
      int lastPos = widget.storyItems.indexOf(_currentStory);
      final previous = widget.storyItems[lastPos - 1]!;

      previous.shown = false;

      _beginPlay();
    }
  }

  void _goForward() {
    if (_currentStory != widget.storyItems.last) {
      _animationController!.stop();

      // get last showing
      final _last = _currentStory;

      if (_last != null) {
        _last.shown = true;
        if (_last != widget.storyItems.last) {
          _beginPlay();
        }
      }
    } else {
      // this is the last page, progress animation should skip to end
      _animationController!
          .animateTo(1.0, duration: const Duration(milliseconds: 10));
    }
  }

  void _clearDebouncer() {
    _nextDebouncer?.cancel();
    _nextDebouncer = null;
  }

  void _removeNextHold() {
    _nextDebouncer?.cancel();
    _nextDebouncer = null;
  }

  void _holdNext() {
    _nextDebouncer?.cancel();
    _nextDebouncer = Timer(const Duration(milliseconds: 500), () {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          _currentView,
          Align(
            alignment: widget.progressPosition == ProgressPosition.top
                ? Alignment.topCenter
                : Alignment.bottomCenter,
            child: SafeArea(
              bottom: widget.inline ? false : true,
              // we use SafeArea here for notched and bezeles phones
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: PageBar(
                  widget.storyItems
                      .map((it) => PageData(it!.duration, it.shown))
                      .toList(),
                  _currentAnimation,
                  key: UniqueKey(),
                  indicatorHeight: widget.inline
                      ? IndicatorHeight.small
                      : IndicatorHeight.large,
                ),
              ),
            ),
          ),
          Align(
              alignment: Alignment.centerRight,
              heightFactor: 1,
              child: GestureDetector(
                onTapDown: (details) {
                  widget.controller!.pause();
                },
                onTapCancel: () {
                  widget.controller!.play();
                },
                onTapUp: (details) {
                  // if debounce timed out (not active) then continue anim
                  if (_nextDebouncer?.isActive == false) {
                    widget.controller!.play();
                  } else {
                    widget.controller!.next();
                  }
                },
                onVerticalDragStart: widget.onVerticalSwipeComplete == null
                    ? null
                    : (details) {
                        widget.controller!.pause();
                      },
                onVerticalDragCancel: widget.onVerticalSwipeComplete == null
                    ? null
                    : () {
                        widget.controller!.play();
                      },
                onVerticalDragUpdate: widget.onVerticalSwipeComplete == null
                    ? null
                    : (details) {
                        verticalDragInfo ??= VerticalDragInfo();

                        verticalDragInfo!.update(details.primaryDelta!);

                        // ignore: todo
                        // TODO: provide callback interface for animation purposes
                      },
                onVerticalDragEnd: widget.onVerticalSwipeComplete == null
                    ? null
                    : (details) {
                        widget.controller!.play();
                        // finish up drag cycle
                        if (!verticalDragInfo!.cancel &&
                            widget.onVerticalSwipeComplete != null) {
                          widget.onVerticalSwipeComplete!(
                              verticalDragInfo!.direction);
                        }

                        verticalDragInfo = null;
                      },
              )),
          Align(
            alignment: Alignment.centerLeft,
            heightFactor: 1,
            child: SizedBox(
                child: GestureDetector(onTap: () {
                  widget.controller!.previous();
                }),
                width: 70),
          ),
        ],
      ),
    );
  }
}

/// Capsule holding the duration and shown property of each story. Passed down
/// to the pages bar to render the page indicators.
class PageData {
  Duration duration;
  bool shown;

  PageData(this.duration, this.shown);
}

/// Horizontal bar displaying a row of [DuctStoryProgressIndicator] based on the
/// [pages] provided.
class PageBar extends StatefulWidget {
  final List<PageData> pages;
  final Animation<double>? animation;
  final IndicatorHeight indicatorHeight;

  const PageBar(
    this.pages,
    this.animation, {
    this.indicatorHeight = IndicatorHeight.large,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PageBarState();
  }
}

class PageBarState extends State<PageBar> {
  double spacing = 4;

  @override
  void initState() {
    super.initState();

    int count = widget.pages.length;
    spacing = (count > 15) ? 1 : ((count > 10) ? 2 : 4);

    widget.animation!.addListener(() {
      setState(() {});
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool isPlaying(PageData page) {
    return widget.pages.firstWhereOrNull((it) => !it.shown) == page;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: widget.pages.map((it) {
        return Expanded(
          child: Container(
            padding:
                EdgeInsets.only(right: widget.pages.last == it ? 0 : spacing),
            child: DuctStoryProgressIndicator(
              isPlaying(it) ? widget.animation!.value : (it.shown ? 1 : 0),
              indicatorHeight:
                  widget.indicatorHeight == IndicatorHeight.large ? 5 : 3,
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Custom progress bar. Supposed to be lighter than the
/// original [ProgressIndicator], and rounded at the sides.
class DuctStoryProgressIndicator extends StatelessWidget {
  /// From `0.0` to `1.0`, determines the progress of the indicator
  final double value;
  final double indicatorHeight;

  const DuctStoryProgressIndicator(
    this.value, {
    Key? key,
    this.indicatorHeight = 5,
  })  : assert(indicatorHeight > 0,
            "[indicatorHeight] should not be null or less than 1"),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.fromHeight(
        indicatorHeight,
      ),
      foregroundPainter: IndicatorOval(
        Colors.white.withOpacity(0.8),
        value,
      ),
      painter: IndicatorOval(
        Colors.white.withOpacity(0.4),
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

/// Concept source: https://stackoverflow.com/a/9733420
class ContrastHelper {
  static double luminance(int? r, int? g, int? b) {
    final a = [r, g, b].map((it) {
      double value = it!.toDouble() / 255.0;
      return value <= 0.03928
          ? value / 12.92
          : pow((value + 0.055) / 1.055, 2.4);
    }).toList();

    return a[0] * 0.2126 + a[1] * 0.7152 + a[2] * 0.0722;
  }

  static double contrast(rgb1, rgb2) {
    return luminance(rgb2[0], rgb2[1], rgb2[2]) /
        luminance(rgb1[0], rgb1[1], rgb1[2]);
  }
}

enum PlaybackState { pause, play, next, previous }

/// Controller to sync playback between animated child (story) views. This
/// helps make sure when stories are paused, the animation (gifs/slides) are
/// also paused.
/// Another reason for using the controller is to place the stories on `paused`
/// state when a media is loading.
class DuctStoryController {
  /// Stream that broadcasts the playback state of the stories.
  final playbackNotifier = BehaviorSubject<PlaybackState>();

  /// Notify listeners with a [PlaybackState.pause] state
  void pause() {
    playbackNotifier.add(PlaybackState.pause);
  }

  /// Notify listeners with a [PlaybackState.play] state
  void play() {
    playbackNotifier.add(PlaybackState.play);
  }

  void next() {
    playbackNotifier.add(PlaybackState.next);
  }

  void previous() {
    playbackNotifier.add(PlaybackState.previous);
  }

  /// Remember to call dispose when the story screen is disposed to close
  /// the notifier stream.
  void dispose() {
    playbackNotifier.close();
  }
}

/// Utitlity to load image (gif, png, jpg, etc) media just once. Resource is
/// cached to disk with default configurations of [DefaultCacheManager].
class DuctImageLoader {
  ui.Codec? frames;

  String? url;

  Map<String, dynamic>? requestHeaders;

  LoadState state = LoadState.loading; // by default

  DuctImageLoader(this.url, {this.requestHeaders});

  /// Load image from disk cache first, if not found then load from network.
  /// `onComplete` is called when [imageBytes] become available.
  void loadImage(VoidCallback onComplete) {
    if (frames != null) {
      state = LoadState.success;
      onComplete();
    }

    final fileStream = DefaultCacheManager()
        .getFileStream(url!, headers: requestHeaders as Map<String, String>?);

    fileStream.listen(
      (fileResponse) {
        if (fileResponse is! FileInfo) return;
        // the reason for this is that, when the cache manager fetches
        // the image again from network, the provided `onComplete` should
        // not be called again
        if (frames != null) {
          return;
        }

        // ignore: unnecessary_type_check
        if (fileResponse is FileInfo) {
          final imageBytes = fileResponse.file.readAsBytesSync();

          state = LoadState.success;

          PaintingBinding.instance.instantiateImageCodec(imageBytes).then(
              (codec) {
            frames = codec;
            onComplete();
          }, onError: (error) {
            state = LoadState.failure;
            onComplete();
          });
        }
      },
      onError: (error) {
        state = LoadState.failure;
        onComplete();
      },
    );
  }
}

/// Widget to display animated gifs or still images. Shows a loader while image
/// is being loaded. Listens to playback states from [controller] to pause and
/// forward animated media.
class DuctStoryImage extends StatefulWidget {
  final DuctImageLoader imageLoader;

  final BoxFit? fit;

  final DuctStoryController? controller;

  DuctStoryImage(
    this.imageLoader, {
    Key? key,
    this.controller,
    this.fit,
  }) : super(key: key ?? UniqueKey());

  /// Use this shorthand to fetch images/gifs from the provided [url]
  factory DuctStoryImage.url(
    String? url, {
    DuctStoryController? controller,
    Map<String, dynamic>? requestHeaders,
    BoxFit fit = BoxFit.fitWidth,
    Key? key,
  }) {
    return DuctStoryImage(
        DuctImageLoader(
          url,
          requestHeaders: requestHeaders,
        ),
        controller: controller,
        fit: fit,
        key: key);
  }

  @override
  State<StatefulWidget> createState() => StoryImageState();
}

class StoryImageState extends State<DuctStoryImage> {
  ui.Image? currentFrame;

  Timer? _timer;

  StreamSubscription<PlaybackState>? _streamSubscription;

  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      _streamSubscription =
          widget.controller!.playbackNotifier.listen((playbackState) {
        // for the case of gifs we need to pause/play
        if (widget.imageLoader.frames == null) {
          return;
        }

        if (playbackState == PlaybackState.pause) {
          _timer?.cancel();
        } else {
          forward();
        }
      });
    }

    widget.controller?.pause();

    widget.imageLoader.loadImage(() async {
      if (mounted) {
        if (widget.imageLoader.state == LoadState.success) {
          widget.controller?.play();
          forward();
        } else {
          // refresh to show error
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _streamSubscription?.cancel();

    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void forward() async {
    _timer?.cancel();

    if (widget.controller != null &&
        widget.controller?.playbackNotifier.value == PlaybackState.pause) {
      return;
    }

    final nextFrame = await widget.imageLoader.frames!.getNextFrame();

    currentFrame = nextFrame.image;

    if (nextFrame.duration > const Duration(milliseconds: 0)) {
      _timer = Timer(nextFrame.duration, forward);
    }

    setState(() {});
  }

  Widget getContentView() {
    switch (widget.imageLoader.state) {
      case LoadState.success:
        return RawImage(
          image: currentFrame,
          fit: widget.fit,
        );
      case LoadState.failure:
        return const Center(
            child: Text(
          "Image failed to load.",
          style: TextStyle(
            color: Colors.white,
          ),
        ));
      default:
        // ignore: prefer_const_constructors
        return Center(
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: getContentView(),
    );
  }
}

enum LoadState { loading, success, failure }

enum Direction { up, down, left, right }

class VerticalDragInfo {
  bool cancel = false;

  Direction? direction;

  void update(double primaryDelta) {
    Direction tmpDirection;

    if (primaryDelta > 0) {
      tmpDirection = Direction.down;
    } else {
      tmpDirection = Direction.up;
    }

    if (direction != null && tmpDirection != direction) {
      cancel = true;
    }

    direction = tmpDirection;
  }
}

class VideoLoader {
  String? url;

  File? videoFile;

  Map<String, dynamic>? requestHeaders;

  LoadState state = LoadState.loading;

  VideoLoader(this.url, {this.requestHeaders});

  void loadVideo(VoidCallback onComplete) {
    if (videoFile != null) {
      state = LoadState.success;
      onComplete();
    }

    final fileStream = DefaultCacheManager()
        .getFileStream(url!, headers: requestHeaders as Map<String, String>?);

    fileStream.listen((fileResponse) {
      if (fileResponse is FileInfo) {
        if (videoFile == null) {
          state = LoadState.success;
          videoFile = fileResponse.file;
          onComplete();
        }
      }
    });
  }
}

class AddVideoLoader {
  String? url;

  File? videoFile;

  Map<String, dynamic>? requestHeaders;

  LoadState state = LoadState.loading;

  AddVideoLoader(this.url, {this.requestHeaders});

  void loadVideo(VoidCallback onComplete) {
    if (url != null) {
      state = LoadState.success;
      onComplete();
    }

    // final fileStream = DefaultCacheManager()
    //     .getFileStream(url!, headers: requestHeaders as Map<String, String>?);

    // fileStream.listen((fileResponse) {
    //   if (fileResponse is FileInfo) {
    //     if (videoFile == null) {
    //       state = LoadState.success;
    //       videoFile = fileResponse.file;
    //       onComplete();
    //     }
    //   }
    //});
  }
}

class DuctStoryVideo extends StatefulWidget {
  final DuctStoryController? storyController;
  final VideoLoader videoLoader;

  DuctStoryVideo(this.videoLoader, {this.storyController, Key? key})
      : super(key: key ?? UniqueKey());

  static DuctStoryVideo url(String? url,
      {DuctStoryController? controller,
      Map<String, dynamic>? requestHeaders,
      Key? key}) {
    return DuctStoryVideo(
      VideoLoader(url, requestHeaders: requestHeaders),
      storyController: controller,
      key: key,
    );
  }

  @override
  State<StatefulWidget> createState() {
    return StoryVideoState();
  }
}

class StoryVideoState extends State<DuctStoryVideo> {
  Future<void>? playerLoader;

  StreamSubscription? _streamSubscription;

  VideoPlayerController? playerController;

  @override
  void initState() {
    super.initState();

    //  widget.storyController!.pause();

    widget.videoLoader.loadVideo(() {
      if (widget.videoLoader.state == LoadState.success) {
        playerController =
            VideoPlayerController.file(widget.videoLoader.videoFile!);

        playerController!.initialize().then((v) {
          setState(() {});
          widget.storyController?.play();
        });

        if (widget.storyController != null) {
          _streamSubscription =
              widget.storyController!.playbackNotifier.listen((playbackState) {
            if (playbackState == PlaybackState.pause) {
              playerController!.pause();
            } else {
              playerController!.play();
            }
          });
        }
      } else {
        setState(() {});
      }
    });
  }

  Widget getContentView() {
    if (widget.videoLoader.state == LoadState.success &&
        playerController!.value.isInitialized) {
      return Center(
        child: AspectRatio(
          aspectRatio: playerController!.value.aspectRatio,
          child: VideoPlayer(playerController!),
        ),
      );
    }

    return widget.videoLoader.state == LoadState.loading
        ? Center(
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
            )
        : const Center(
            child: Text(
            "Media failed to load.",
            style: TextStyle(
              color: Colors.white,
            ),
          ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: double.infinity,
      width: double.infinity,
      child: getContentView(),
    );
  }

  @override
  void dispose() {
    playerController?.dispose();
    _streamSubscription?.cancel();
    widget.storyController?.dispose();
    super.dispose();
  }
}

class DuctStoryProduct extends StatefulWidget {
  final DuctStoryController? storyController;
  final VideoLoader videoLoader;

  DuctStoryProduct(this.videoLoader, {this.storyController, Key? key})
      : super(key: key ?? UniqueKey());

  static DuctStoryProduct url(String? url,
      {DuctStoryController? controller,
      Map<String, dynamic>? requestHeaders,
      Key? key}) {
    return DuctStoryProduct(
      VideoLoader(url, requestHeaders: requestHeaders),
      storyController: controller,
      key: key,
    );
  }

  @override
  State<StatefulWidget> createState() {
    return DuctStoryProductState();
  }
}

class DuctStoryProductState extends State<DuctStoryProduct> {
  Future<void>? playerLoader;

  StreamSubscription? _streamSubscription;

  VideoPlayerController? playerController;

  @override
  void initState() {
    super.initState();

    //widget.storyController!.pause();

    widget.videoLoader.loadVideo(() {
      if (widget.videoLoader.state == LoadState.success) {
        playerController =
            VideoPlayerController.file(widget.videoLoader.videoFile!);

        playerController!.initialize().then((v) {
          // setState(() {});
          // widget.storyController?.play();
        });

        if (widget.storyController != null) {
          _streamSubscription =
              widget.storyController!.playbackNotifier.listen((playbackState) {
            if (playbackState == PlaybackState.pause) {
              playerController!.pause();
            } else {
              playerController!.play();
            }
          });
        }
      } else {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    playerController?.dispose();
    _streamSubscription?.cancel();
    widget.storyController?.dispose();
    super.dispose();
  }

  Widget getContentView() {
    if (widget.videoLoader.state == LoadState.success &&
        playerController!.value.isInitialized) {
      return Center(
        child: AspectRatio(
          aspectRatio: playerController!.value.aspectRatio,
          child: VideoPlayer(playerController!),
        ),
      );
    }

    return widget.videoLoader.state == LoadState.loading
        ? Center(
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
            )
        : const Center(
            child: Text(
            "Media failed to load.",
            style: TextStyle(
              color: Colors.white,
            ),
          ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: double.infinity,
      width: double.infinity,
      child: getContentView(),
    );
  }
}

class AddDuctVideo extends StatefulWidget {
  final DuctStoryController? storyController;
  final AddVideoLoader videoLoader;

  AddDuctVideo(this.videoLoader, {this.storyController, Key? key})
      : super(key: key ?? UniqueKey());

  static AddDuctVideo url(String? url,
      {DuctStoryController? controller,
      Map<String, dynamic>? requestHeaders,
      Key? key}) {
    return AddDuctVideo(
      AddVideoLoader(url, requestHeaders: requestHeaders),
      storyController: controller,
      key: key,
    );
  }

  @override
  State<StatefulWidget> createState() {
    return AddDuctVideoState();
  }
}

class AddDuctVideoState extends State<AddDuctVideo> {
  Future<void>? playerLoader;

  StreamSubscription? _streamSubscription;

  VideoPlayerController? playerController;

  @override
  void initState() {
    super.initState();

    //widget.storyController!.pause();

    widget.videoLoader.loadVideo(() {
      if (widget.videoLoader.state == LoadState.success) {
        playerController =
            VideoPlayerController.file(File(widget.videoLoader.url!));

        playerController!.initialize().then((v) {
          setState(() {});
          widget.storyController?.play();
        });

        if (widget.storyController != null) {
          _streamSubscription =
              widget.storyController!.playbackNotifier.listen((playbackState) {
            if (playbackState == PlaybackState.pause) {
              playerController!.pause();
            } else {
              playerController!.play();
            }
          });
        }
      } else {
        setState(() {});
      }
    });
  }

  Widget getContentView() {
    if (widget.videoLoader.state == LoadState.success &&
        playerController!.value.isInitialized) {
      return Center(
        child: AspectRatio(
          aspectRatio: playerController!.value.aspectRatio,
          child: VideoPlayer(playerController!),
        ),
      );
    }

    return
        // widget.videoLoader.state == LoadState.loading
        //     ?
        Center(
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
    // : const Center(
    //     child: Text(
    //     "Media failed to load.",
    //     style: TextStyle(
    //       color: Colors.white,
    //     ),
    //   ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: double.infinity,
      width: double.infinity,
      child: getContentView(),
    );
  }

  @override
  void dispose() {
    playerController?.dispose();
    _streamSubscription?.cancel();
    widget.storyController?.dispose();
    super.dispose();
  }
}

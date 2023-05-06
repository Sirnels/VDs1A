// ignore_for_file: file_names, prefer_typing_uninitialized_variables, unused_local_variable, unused_element, unnecessary_null_comparison

import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/appwrite.dart';
//import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:lottie/lottie.dart';
//import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:video_player/video_player.dart';
import 'package:viewducts/admin/Admin_dashbord/responsive.dart';
import 'package:viewducts/admin/screens/video_admin_upload.dart';
import 'package:viewducts/apis/chat_api.dart';
import 'package:viewducts/app_theme/app_theme_constant.dart';
import 'package:viewducts/common/common.dart';
import 'package:viewducts/common/duct_share_page.dart';
import 'package:viewducts/features/auth/controller/auth_controller.dart';
import 'package:viewducts/features/ducts/duct_controller.dart';
import 'package:viewducts/features/products/product_controller.dart';
import 'package:viewducts/helper/enum.dart';
import 'package:viewducts/helper/theme.dart';
//import 'package:story_view/story_view.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/chatModel.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/page/common/general_dialog.dart';
import 'package:viewducts/page/message/item_Search_bar.dart';
import 'package:viewducts/page/message/storyChat.dart';
import 'package:viewducts/page/responsiveView.dart';
//import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/duct/ductStory.dart';
import 'package:viewducts/widgets/frosted.dart';
import 'package:viewducts/widgets/newWidget/customUrlText.dart';
import 'package:viewducts/widgets/newWidget/title_text.dart';

import '../customWidgets.dart';

extension SplitString on String {
  List<String> splitByLength(int length) =>
      [substring(0, length), substring(length)];
}

// ignore: must_be_immutable
class ProductStoryView extends ConsumerStatefulWidget {
  final FeedModel? model;
  final String? commissionUser;
  final ViewductsUser? currentUser;
  final ViewductsUser? vendor;
  final bool isVduct;
  final int? rating;
  ProductStoryView({
    Key? key,
    this.model,
    this.commissionUser,
    this.isVduct = false,
    this.rating,
    this.currentUser,
    this.vendor,
  }) : super(key: key);

  @override
  ConsumerState<ProductStoryView> createState() => _ProductStoryViewState();
}

class _ProductStoryViewState extends ConsumerState<ProductStoryView> {
  DuctStoryController controller = DuctStoryController();

  VideoPlayerController? contr;

  Rx<bool> isPlaying = true.obs;

  VideoPlayerController? videocontroller;

  RxList<AppPlayStoreModel> appPlayStoreState = RxList<AppPlayStoreModel>();

  Rx<ViewductsUser> ductUser = ViewductsUser().obs;

  String colorValue = "";

  String sizeValue = "";

  @override
  Widget build(BuildContext context) {
    // final setState = (() {});

    // final appPlayStoreState = (authState.appPlayStore);
    // bool isPlaying = true;

    // final profileDataState = (searchState.viewUserlist);
    Storage storage = Storage(clientConnect());
    final isloading = ref.watch(productControllerProvider);
    void _imageView(
      BuildContext context,
    ) {
      Future.delayed(Duration(milliseconds: 400), () {
        ViewDialogs().customeDialog(context,
            height: fullHeight(context),
            width: fullWidth(context),
            ref: ref,
            body: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  children: [
                    Expanded(
                      // height: fullHeight(context) * 0.8,
                      // width: fullWidth(context),
                      // decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(18),
                      //     color: Pallete.scafoldBacgroundColor),
                      child: Container(
                        height: fullHeight(context),
                        width: fullWidth(context),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Pallete.scafoldBacgroundColor),
                        child: Scaffold(
                          backgroundColor: CupertinoColors.darkBackgroundGray,
                          body: SafeArea(
                              child: Responsive(
                            mobile: Hero(
                              tag: widget.model!.imagePath.toString(),
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    height: Get.height,
                                    width: Get.width,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                    ),
                                    child: FutureBuilder(
                                      future: storage.getFileView(
                                          bucketId: productBucketId,
                                          fileId: widget.model!.imagePath
                                              .toString()), //works for both public file and private file, for private files you need to be logged in
                                      builder: (context, snapshot) {
                                        return snapshot.hasData &&
                                                snapshot.data != null
                                            ? Image.memory(
                                                snapshot.data as Uint8List,
                                                width: Get.height * 0.3,
                                                height: Get.height * 0.4,
                                                fit: BoxFit.contain)
                                            : Center(
                                                child: SizedBox(
                                                width: Get.height * 0.2,
                                                height: Get.height * 0.2,
                                                child: LoadingIndicator(
                                                    indicatorType: Indicator
                                                        .ballTrianglePath,

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
                                                    pathBackgroundColor:
                                                        Colors.blue

                                                    /// Optional, the stroke backgroundColor
                                                    ),
                                              )
                                                //  CircularProgressIndicator
                                                //     .adaptive()
                                                );
                                      },
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 10,
                                    child: SingleChildScrollView(
                                      child: SizedBox(
                                        width: Get.width,
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
                                                    text: 'Description',
                                                    onHashTagPressed: (tag) {
                                                      cprint(tag);
                                                    },
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .onPrimary,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                    urlStyle: const TextStyle(
                                                        color: Colors.blue,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ),
                                              frostedBlack(
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                                offset:
                                                                    const Offset(
                                                                        0, 11),
                                                                blurRadius: 11,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.06))
                                                          ],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: CupertinoColors
                                                              .lightBackgroundGray),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      width: Get.width,
                                                      height: Get.height * 0.2,
                                                      child: Markdown(
                                                          styleSheetTheme:
                                                              MarkdownStyleSheetBaseTheme
                                                                  .cupertino,
                                                          data: widget.model!
                                                              .productDescription
                                                              .toString()),
                                                    )

                                                    //  UrlText(
                                                    //   text: productDescription,
                                                    //   onHashTagPressed: (tag) {
                                                    //     cprint(tag);
                                                    //   },
                                                    //   style: TextStyle(
                                                    //       color: Theme.of(Get.context!)
                                                    //           .colorScheme
                                                    //           .onPrimary,
                                                    //       fontSize: 14,
                                                    //       fontWeight: FontWeight.w400),
                                                    //   urlStyle: const TextStyle(
                                                    //       color: Colors.blue,
                                                    //       fontSize: 14,
                                                    //       fontWeight: FontWeight.w400),
                                                    // ),
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
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
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                            ),
                                            child: FutureBuilder(
                                              future: storage.getFileView(
                                                  bucketId: productBucketId,
                                                  fileId: widget
                                                      .model!.imagePath
                                                      .toString()), //works for both public file and private file, for private files you need to be logged in
                                              builder: (context, snapshot) {
                                                return snapshot.hasData &&
                                                        snapshot.data != null
                                                    ? Image.memory(
                                                        snapshot.data
                                                            as Uint8List,
                                                        width: Get.height * 0.3,
                                                        height:
                                                            Get.height * 0.4,
                                                        fit: BoxFit.contain)
                                                    : Center(
                                                        child: SizedBox(
                                                        width: Get.height * 0.2,
                                                        height:
                                                            Get.height * 0.2,
                                                        child: LoadingIndicator(
                                                            indicatorType: Indicator
                                                                .ballTrianglePath,

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
                                                                Colors
                                                                    .transparent,

                                                            /// Optional, Background of the widget
                                                            pathBackgroundColor:
                                                                Colors.blue

                                                            /// Optional, the stroke backgroundColor
                                                            ),
                                                      )
                                                        //  CircularProgressIndicator
                                                        //     .adaptive()
                                                        );
                                              },
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
                                  filter:
                                      ImageFilter.blur(sigmaX: 4, sigmaY: 4),
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
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10)),
                                            ),
                                            child: FutureBuilder(
                                              future: storage.getFileView(
                                                  bucketId: productBucketId,
                                                  fileId: widget
                                                      .model!.imagePath
                                                      .toString()), //works for both public file and private file, for private files you need to be logged in
                                              builder: (context, snapshot) {
                                                return snapshot.hasData &&
                                                        snapshot.data != null
                                                    ? Image.memory(
                                                        snapshot.data
                                                            as Uint8List,
                                                        width: Get.height * 0.3,
                                                        height:
                                                            Get.height * 0.4,
                                                        fit: BoxFit.contain)
                                                    : Center(
                                                        child: SizedBox(
                                                        width: Get.height * 0.2,
                                                        height:
                                                            Get.height * 0.2,
                                                        child: LoadingIndicator(
                                                            indicatorType: Indicator
                                                                .ballTrianglePath,

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
                                                                Colors
                                                                    .transparent,

                                                            /// Optional, Background of the widget
                                                            pathBackgroundColor:
                                                                Colors.blue

                                                            /// Optional, the stroke backgroundColor
                                                            ),
                                                      )
                                                        //  CircularProgressIndicator
                                                        //     .adaptive()
                                                        );
                                              },
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
                        ),
                      ),
                    )
                  ],
                ),
                // Positioned(
                //   bottom: 10,
                //   left: 0,
                //   right: 0,
                //   child: Lottie.asset('assets/lottie/discount.json',
                //       width: 100, height: 100),
                // ),
                Positioned(
                  top: -10,
                  right: 100,
                  child: Container(
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
                    child: TitleText('PinDucts',
                        // color: Colors.white,
                        // fontSize: 16,
                        // fontWeight: FontWeight.w800,
                        overflow: TextOverflow.ellipsis),
                  ),
                ),

                Positioned(
                  bottom: -10,
                  right: 50,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
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
                      child: Icon(Icons.close,
                          color: CupertinoColors.darkBackgroundGray),
                    ),
                  ),
                ),

                // Positioned(
                //   top: -10,
                //   left: 10,
                //   child: GestureDetector(
                //     onTap: () {
                //       ref.watch(expandPinDucts.notifier).state == false
                //           ? setState(() {
                //               ref.watch(expandPinDucts.notifier).state ==
                //                   true;
                //               // expand = true;
                //               cprint(
                //                   "${ref.watch(expandPinDucts.notifier).state} active");
                //             })
                //           : setState(() {
                //               ref.watch(expandPinDucts.notifier).state ==
                //                   false;
                //               // expand = true;
                //               cprint(
                //                   "${ref.watch(expandPinDucts.notifier).state} active");
                //             });
                //       // if (ref.watch(expandPinDucts.notifier).state ==
                //       //     true) {
                //       //   setState(() {
                //       //     ref.watch(expandPinDucts.notifier).state ==
                //       //         false;
                //       //     cprint("$expand active");
                //       //     expand = false;
                //       //   });
                //       // } else {
                //       //   setState(() {
                //       //     ref.watch(expandPinDucts.notifier).state ==
                //       //         true;
                //       //     expand = true;
                //       //     cprint("$expand active");
                //       //   });
                //       // }
                //     },
                //     child: Container(
                //       // width: 60,
                //       decoration: BoxDecoration(
                //           boxShadow: [
                //             BoxShadow(
                //                 offset: const Offset(0, 11),
                //                 blurRadius: 11,
                //                 color: Colors.black.withOpacity(0.06))
                //           ],
                //           borderRadius: BorderRadius.circular(5),
                //           color: Pallete.scafoldBacgroundColor),
                //       padding: const EdgeInsets.all(5.0),
                //       child: Image.asset(
                //         'assets/expand.png',
                //         width: 30,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
            dx: 0,
            dy: -1,
            horizontal: 16,
            vertical: 0.1);
      });
    }

    final database = Databases(
      clientConnect(),
    );
    // database
    //     .getDocument(
    //         databaseId: databaseId,
    //         collectionId: profileUserColl,
    //         documentId: model!.userId.toString())
    //     .then((item) {
    //   ductUser.value = ViewductsUser.fromJson(item.data);
    // });

    Future<bool?> _showDialogs() {
      return showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return frostedYellow(
            Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Colors.transparent,
              child: frostedYellow(
                Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      height: Get.height * 0.4,
                      child: Column(
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
                                    'Downlod App to Countinue',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w200),
                                  ),
                                )),
                          ),
                          appPlayStoreState
                                  .where(
                                      (data) => data.operatingSystem == 'IOS')
                                  .isNotEmpty
                              ? GestureDetector(
                                  onTap: () {},
                                  child: Image.asset(
                                    'assets/app-store.png',
                                    height: context.responsiveValue(
                                        mobile: Get.height * 0.1,
                                        tablet: Get.height * 0.1,
                                        desktop: Get.height * 0.1),
                                  ),
                                )
                              : Container(),
                          appPlayStoreState
                                  .where((data) =>
                                      data.operatingSystem == 'Android')
                                  .isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    // String? appDownload = appPlayStoreState
                                    //     .value
                                    //     .firstWhere((data) =>
                                    //         data.operatingSystem == 'Android')
                                    //     .downloadApp;
                                    // String? storeUrl = appPlayStoreState.value
                                    //     .firstWhere((data) =>
                                    //         data.operatingSystem == 'Android')
                                    //     .storeUrl;
                                    // String? downlodUrl = appPlayStoreState.value
                                    //     .firstWhere((data) =>
                                    //         data.operatingSystem == 'Android')
                                    //     .downloadUrl;
                                    // final minio = Minio(
                                    //     endPoint: userCartController
                                    //         .wasabiAws.value.endPoint
                                    //         .toString(),
                                    //     accessKey: userCartController
                                    //         .wasabiAws.value.accessKey
                                    //         .toString(),
                                    //     secretKey: userCartController
                                    //         .wasabiAws.value.secretKey
                                    //         .toString(),
                                    //     region: userCartController
                                    //         .wasabiAws.value.region
                                    //         .toString());
                                    // appDownload == ''
                                    //     ? minio.getObject(
                                    //         userCartController
                                    //             .wasabiAws.value.buckedId
                                    //             .toString(),
                                    //         '$downlodUrl')
                                    //     : launchURL("$storeUrl");
                                  },
                                  child: Image.asset(
                                    'assets/google-play.png',
                                    height: context.responsiveValue(
                                        mobile: Get.height * 0.15,
                                        tablet: Get.height * 0.15,
                                        desktop: Get.height * 0.15),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    String chatUsersId =
        '${widget.currentUser?.userId!.splitByLength((widget.currentUser!.userId!.length) ~/ 2)[0]}_${widget.model!.userId?.splitByLength((widget.model!.userId!.length) ~/ 2)[0]}';
    String uniqueId =
        '${widget.model!.key?.splitByLength((widget.model!.key!.length) ~/ 2)[0]}_${widget.currentUser!.userId!.splitByLength((widget.currentUser!.userId!.length) ~/ 2)[0]}';
    cprint('product unique idea $uniqueId');
    return Scaffold(
      //   floatingActionButton: _newMessageButton(context),
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
                width: Get.width,
                height: Get.height,
                child: DuctstoryView(
                    //progressPosition: ProgressPosition.bottom,
                    storyItems: [
                      DuctStoryItem.productView(
                        widget.model!.videoPath,
                        context: context,
                        rating: widget.rating,
                        currentUser: widget.currentUser,
                        controlleronline: videocontroller,
                        salePrice: widget.model!.salePrice,
                        // url: widget.model!.imagePath,
                        price: widget.model!.price,
                        controller: controller,
                        // productDescription: widget.model!.productDescription,
                        time: widget.model!.createdAt,
                        imagePath: widget.model!.imagePath,
                        duration: Duration(seconds: 1
                            // int.parse(widget.model!.duration.toString())
                            ),
                      ),
                    ],
                    controller: controller)),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.grey.withOpacity(.3),
                ),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.4,
                child: VideoUploadAdmin(
                  isOnline: true,
                  videoPath: widget.model!.videoPath,
                  currentUser: widget.currentUser,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      _imageView(
                        context,
                      );
                    },
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        width: Get.height * 0.08,
                        height: Get.height * 0.08,
                        child: FutureBuilder(
                          future: storage.getFileView(
                              bucketId: productBucketId,
                              fileId: widget.model!.imagePath
                                  .toString()), //works for both public file and private file, for private files you need to be logged in
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
                                        ),
                                  )
                                    //  CircularProgressIndicator
                                    //     .adaptive()
                                    );
                          },
                        ),
                        //  customNetworkImage(
                        //   imagePath,
                        //   fit: BoxFit.cover,
                        // ),
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: SizedBox(
                      width: Get.height - 100,
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
                                  text: 'Description',
                                  onHashTagPressed: (tag) {
                                    cprint(tag);
                                  },
                                  style: TextStyle(
                                      color: Theme.of(context)
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
                            frostedBlack(
                              Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              offset: const Offset(0, 11),
                                              blurRadius: 11,
                                              color: Colors.black
                                                  .withOpacity(0.06))
                                        ],
                                        borderRadius: BorderRadius.circular(5),
                                        color: CupertinoColors
                                            .lightBackgroundGray),
                                    padding: const EdgeInsets.all(5.0),
                                    width: Get.width - 100,
                                    height: Get.height * 0.15,
                                    child: Markdown(
                                        styleSheetTheme:
                                            MarkdownStyleSheetBaseTheme
                                                .cupertino,
                                        data: widget.model!.productDescription
                                            .toString()),
                                  )

                                  //  UrlText(
                                  //   text: productDescription,
                                  //   onHashTagPressed: (tag) {
                                  //     cprint(tag);
                                  //   },
                                  //   style: TextStyle(
                                  //       color: Theme.of(Get.context!)
                                  //           .colorScheme
                                  //           .onPrimary,
                                  //       fontSize: 14,
                                  //       fontWeight: FontWeight.w400),
                                  //   urlStyle: const TextStyle(
                                  //       color: Colors.blue,
                                  //       fontSize: 14,
                                  //       fontWeight: FontWeight.w400),
                                  // ),
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
            widget.currentUser?.userId == null
                ? Positioned(
                    top: Get.height * 0.03,
                    right: Get.width * 0.01,
                    child: GestureDetector(
                      onTap: () {
                        _showDialogs();
                        // Get.toNamed(
                        //   '/signin',
                        // );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 11),
                                  blurRadius: 11,
                                  color: Colors.black.withOpacity(0.06))
                            ],
                            borderRadius: BorderRadius.circular(5),
                            color: CupertinoColors.systemYellow),
                        padding: const EdgeInsets.all(5.0),
                        child: customText('Login To Buy',
                            style: const TextStyle(fontSize: 20)),
                      ),
                    ),
                  )
                : Positioned(
                    top: Get.height * 0.03,
                    right: Get.width * 0.01,
                    child: Material(
                      borderRadius: BorderRadius.circular(100),
                      elevation: 20,
                      child: SizedBox(
                        width: Get.height * 0.08,
                        height: Get.height * 0.08,
                        child: GestureDetector(
                          onTap: () {
                            // If tweet is displaying on someone's profile then no need to navigate to same user's profile again.
                            // if (isDisplayOnProfile) {
                            //   return;
                            // }
                            Get.back();
                            Get.to(() => ProfileResponsiveView(
                                  profileId: ductUser.value.userId,
                                  profileType: ProfileType.Store,
                                ));
                            // Navigator.of(context)
                            //     .pushNamed('/ProfilePage/' + model?.userId);
                          },
                          child:
                              customImage(context, widget.vendor?.profilePic),
                        ),
                      ),
                    ),
                  ),
            widget.currentUser?.userId == null
                ? Container()
                : widget.model!.section == 'Children' ||
                        widget.model!.section == 'Adult Fashion'
                    ? colorValue.isEmpty && sizeValue.isEmpty
                        ? Container()
                        : Positioned(
                            bottom: 0,
                            right: 10,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    // _productDetails(context);
                                    // EasyLoading.show(
                                    //     status: 'Adding to Cart',
                                    //     dismissOnTap: true);
                                    // await userCartController.addItemToCart(
                                    //     widget.model,
                                    //     widget.commissionUser,
                                    //     colorValue,
                                    //     sizeValue,
                                    //     ductUser: ductUser);

                                    ref
                                        .read(
                                            productControllerProvider.notifier)
                                        .addProductToCart(
                                            product: widget.model,
                                            commissionUser:
                                                widget.commissionUser,
                                            color: colorValue,
                                            size: sizeValue,
                                            ductUser: widget.currentUser,
                                            context: context,
                                            uniqueId: uniqueId);
                                    // EasyLoading.dismiss();
                                  },
                                  color: Colors.amber,
                                  icon: Icon(CupertinoIcons.add,
                                      size: Get.height * 0.08),
                                ),
                                customInkWell(
                                  context: context,
                                  onPressed: () {
                                    ref
                                        .read(chatUserIdProvider.notifier)
                                        .state = chatUsersId;
                                    // Get.back();
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => OpenContainer(
                                                  closedBuilder:
                                                      (context, action) {
                                                    return ChatResponsive(
                                                        chatIdUsers:
                                                            chatUsersId,
                                                        userProfileId: widget
                                                            .model!.userId,
                                                        productId:
                                                            widget.model!.key,
                                                        isVductProduct: true);
                                                  },
                                                  openBuilder:
                                                      (context, action) {
                                                    return ChatResponsive(
                                                        chatIdUsers:
                                                            chatUsersId,
                                                        userProfileId: widget
                                                            .model!.userId,
                                                        productId:
                                                            widget.model!.key,
                                                        isVductProduct: true);
                                                  },
                                                )));
                                  },
                                  child: CircleAvatar(
                                      radius: Get.height * 0.04,
                                      backgroundColor:
                                          Colors.black87.withOpacity(0.5),
                                      child: Lottie.asset(
                                        'assets/lottie/chat-box-animation.json',
                                      )),
                                ),
                              ],
                            ),
                          )
                    : colorValue.isEmpty
                        ? Container()
                        : Positioned(
                            bottom: 0,
                            right: 10,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                colorValue == ""
                                    ? Container()
                                    : IconButton(
                                        onPressed: () async {
                                          // cprint('${sizeValue} data');
                                          // _productDetails(context);
                                          // EasyLoading.show(
                                          //     status: 'Adding to Cart',
                                          //     dismissOnTap: true);
                                          ref
                                              .read(productControllerProvider
                                                  .notifier)
                                              .addProductToCart(
                                                  product: widget.model,
                                                  commissionUser:
                                                      widget.commissionUser,
                                                  color: colorValue,
                                                  size: sizeValue,
                                                  ductUser: widget.currentUser,
                                                  context: context,
                                                  uniqueId: uniqueId);
                                          // EasyLoading.dismiss();
                                        },
                                        color: Colors.amber,
                                        icon: Icon(CupertinoIcons.add,
                                            size: Get.height * 0.05),
                                      ),
                                customInkWell(
                                  context: context,
                                  onPressed: () {
                                    ref
                                        .read(chatUserIdProvider.notifier)
                                        .state = chatUsersId;
                                    // Get.back();
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => OpenContainer(
                                                  closedBuilder:
                                                      (context, action) {
                                                    return ChatResponsive(
                                                        chatIdUsers:
                                                            chatUsersId,
                                                        userProfileId: widget
                                                            .model!.userId,
                                                        productId:
                                                            widget.model!.key,
                                                        isVductProduct: true);
                                                  },
                                                  openBuilder:
                                                      (context, action) {
                                                    return ChatResponsive(
                                                        chatIdUsers:
                                                            chatUsersId,
                                                        userProfileId: widget
                                                            .model!.userId,
                                                        productId:
                                                            widget.model!.key,
                                                        isVductProduct: true);
                                                  },
                                                )));
                                    // if (widget.isVduct == true) {
                                    //   if (searchState.viewUserlist.any((x) =>
                                    //       x.userId == widget.commissionUser)) {
                                    //     chatState.setChatUser = widget.vendor;
                                    //     // String? productId = feedState.productlist!
                                    //     //     .firstWhere(
                                    //     //       (e) => e.key == widget.model!.key,
                                    //     //       orElse: () => widget.model!,
                                    //     //     )
                                    //     //     .key;
                                    //     //}

                                    //     // if (authState.userModel!.locked != null &&
                                    //     //     authState.userModel!.locked!
                                    //     //         .contains(chatState.chatUser!.userId))
                                    //     //         {

                                    //     Get.to(() => ChatResponsive(
                                    //         userProfileId: widget.commissionUser,
                                    //         productId: widget.model!.key,
                                    //         isVductProduct: true));
                                    //   }
                                    // } else {
                                    //   if (searchState.viewUserlist.any((x) =>
                                    //       x.userId == widget.model!.userId)) {
                                    //     chatState.setChatUser = widget.vendor;
                                    //     // String? productId = feedState.productlist!
                                    //     //     .firstWhere(
                                    //     //       (e) => e.key == widget.model!.key,
                                    //     //       orElse: () => widget.model!,
                                    //     //     )
                                    //     //     .key;
                                    //     //}

                                    //     // if (authState.userModel!.locked != null &&
                                    //     //     authState.userModel!.locked!
                                    //     //         .contains(chatState.chatUser!.userId))
                                    //     //         {

                                    //     Get.to(() => ChatResponsive(
                                    //         userProfileId: widget.model!.userId,
                                    //         productId: widget.model!.key,
                                    //         isVductProduct: true));
                                    //   }
                                    // }
                                  },
                                  child: CircleAvatar(
                                      radius: Get.height * 0.04,
                                      backgroundColor:
                                          Colors.black87.withOpacity(0.5),
                                      child: Lottie.asset(
                                        'assets/lottie/chat-box-animation.json',
                                      )),
                                ),
                              ],
                            ),
                          ),
            // authState.appUser?.$id == null
            //     ? Container()
            //     :
            Positioned(
                top: Get.height * 0.16,
                left: 0,
                child: widget.model?.stockQuantity == 0
                    ? Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                            // width:
                            //    Get.width * 0.3,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      offset: const Offset(0, 11),
                                      blurRadius: 11,
                                      color: Colors.black.withOpacity(0.06))
                                ],
                                borderRadius: BorderRadius.circular(18),
                                color: CupertinoColors.systemRed),
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              'Out of Stock',
                              style: TextStyle(
                                  color: CupertinoColors.darkBackgroundGray,
                                  fontWeight: FontWeight.w900),
                            )),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                            widget.model!.colors == null
                                ? Container()
                                : SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text('Select Color:',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                        Row(
                                          children: widget.model!.colors!
                                              .map((color) => GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        colorValue = color;
                                                      });

                                                      // setState(() {});
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        color: colorValue ==
                                                                color
                                                            ? Colors.cyan
                                                            : Colors.grey
                                                                .withOpacity(
                                                                    .3),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 12,
                                                                vertical: 9),
                                                        child: Text(
                                                            color.toString(),
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .yellow)),
                                                      ),
                                                    ),
                                                  ))
                                              .toList(),
                                        ),
                                      ],
                                    ),
                                  ),
                            widget.model!.section == 'Adult Fashion'
                                ? widget.model!.shoeSize!.isEmpty
                                    ? Container()
                                    : SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text('Select Size:',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: widget.model!.shoeSize!
                                                  .map((shoeSize) =>
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            sizeValue =
                                                                shoeSize;
                                                          });
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25),
                                                            color: sizeValue ==
                                                                    shoeSize
                                                                ? Colors.cyan
                                                                : Colors.white,
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical:
                                                                        4),
                                                            child: Text(shoeSize
                                                                .toString()),
                                                          ),
                                                        ),
                                                      ))
                                                  .toList(),
                                            ),
                                          ],
                                        ),
                                      )
                                : Container(),
                            widget.model!.section == 'Adult Fashion'
                                ? widget.model!.sizes!.isEmpty
                                    ? Container()
                                    : SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text('Select Size:',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: widget.model!.sizes!
                                                  .map((size) =>
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            sizeValue = size;
                                                          });
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25),
                                                            color: sizeValue ==
                                                                    size
                                                                ? Colors.cyan
                                                                : Colors.white,
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical:
                                                                        4),
                                                            child: Text(size
                                                                .toString()),
                                                          ),
                                                        ),
                                                      ))
                                                  .toList(),
                                            ),
                                          ],
                                        ),
                                      )
                                : Container(),
                            widget.model!.section == 'Children'
                                ? widget.model!.shoeSize!.isEmpty
                                    ? Container()
                                    : SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text('Select Size:',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: widget.model!.shoeSize!
                                                  .map((shoeSize) =>
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            sizeValue =
                                                                shoeSize;
                                                          });
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25),
                                                            color: sizeValue ==
                                                                    shoeSize
                                                                ? Colors.cyan
                                                                : Colors.white,
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical:
                                                                        4),
                                                            child: Text(shoeSize
                                                                .toString()),
                                                          ),
                                                        ),
                                                      ))
                                                  .toList(),
                                            ),
                                          ],
                                        ),
                                      )
                                : Container(),
                            widget.model!.section == 'Children'
                                ? widget.model!.sizes!.isEmpty
                                    ? Container()
                                    : SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text('Select Size:',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: widget.model!.sizes!
                                                  .map((size) =>
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            sizeValue = size;
                                                          });
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        25),
                                                            color: sizeValue ==
                                                                    size
                                                                ? Colors.cyan
                                                                : Colors.white,
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        12,
                                                                    vertical:
                                                                        4),
                                                            child: Text(size
                                                                .toString()),
                                                          ),
                                                        ),
                                                      ))
                                                  .toList(),
                                            ),
                                          ],
                                        ),
                                      )
                                : Container(),
                          ])),
            isloading
                ? Container(
                    child: Loader(),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}

class AddDuctVideoPage extends StatefulWidget {
  final String? url;
  const AddDuctVideoPage({Key? key, this.url}) : super(key: key);

  @override
  State<AddDuctVideoPage> createState() => _AddDuctVideoPageState();
}

class _AddDuctVideoPageState extends State<AddDuctVideoPage> {
  DuctStoryController controller = DuctStoryController();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: Get.width,
        height: Get.height,
        child: DuctstoryView(
            //progressPosition: ProgressPosition.bottom,
            storyItems: [
              DuctStoryItem.addDuctVideo(
                widget.url,
                context: context,
              )
            ],
            controller: controller));
  }
}

class MainStoryPage extends ConsumerStatefulWidget {
  final FeedModel? product;
  final FeedModel? model;
  final List<DuctStoryModel>? storylist;
  final ViewductsUser? currentUser;
  final ViewductsUser? secondUser;
  final String vendorId;
  MainStoryPage({
    Key? key,
    this.product,
    this.storylist,
    this.currentUser,
    this.secondUser,
    required this.model,
    required this.vendorId,
  }) : super(key: key);

  @override
  ConsumerState<MainStoryPage> createState() => _MainStoryPageState();
}

class _MainStoryPageState extends ConsumerState<MainStoryPage> {
  final audioPlayer = AudioPlayer();

  // final _animController = useAnimationController();
  DuctStoryController controller = DuctStoryController();

  MainUserViewsModel views = MainUserViewsModel(viewerId: '0');

  HeartViewsModel viewsHearts = HeartViewsModel(viewerId: '0');

  // final userVierState = (feedState.userViers);

  RxString id = "".obs;

  RxString messageId = "".obs;

  final storyItems = <DuctStoryItem>[].obs;

  String chatId = "";

  Rx<DuctStoryModel> currentStorys = DuctStoryModel().obs;

  var currentStory = DuctStoryModel();

  final videoUrl = (DuctStoryModel().videoPath);

  var storyProduct = FeedModel();

  //final _currentIndex = (0);
  Rx<ViewductsUser> ductUser = ViewductsUser().obs;
  ViewductsUser? vendor = ViewductsUser();
  final storyUserViewSetState = RxList<ViewsModel>;

  final heartLikesSetState = RxList<HeartViewsModel>;

  final storyChatsSetState = RxList<ChatStoryModel>;
  @override
  void initState() {
    super.initState();
    addStoryItems(context);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void addStoryItems(BuildContext context) async {
    for (final story in widget.storylist!) {
      // product =
      //     ref.watch(getOneProductProvider(story.cProduct.toString())).value ??
      //         FeedModel();
      // vendor = ref.watch(userDetailsProvider('${product.userId}')).value;

      //  currentStory = story;

      switch (story.storyType) {
        case 0:
          storyItems.add(
            DuctStoryItem.text(
              currentStory: story,
              currentUser: widget.currentUser!,
              secondUser: widget.secondUser!,
              model: widget.model!,
              vendor: vendor!,
              ref: ref,
              title: story.ductComment!,
              backgroundColor: Pallete.scafoldBacgroundColor,
              // const Color(0xFF212332),
              context: context,
              id: story.key,
              userId: story.userId,
              audioTage: story.audioTag,
              cName:
                  "feedState.productlist!.firstWhere((e) => e.key == story.cProduct, orElse: () => FeedModel())this.currentUser, this.secondUser,.productName",
              cPrice:
                  "feedState.productlist!.firstWhere((e) => e.key == story.cProduct,orElse: () => FeedModel()).price",

              userName: widget.model?.user?.displayName,
              cImage:
                  "feedState.productlist!.firstWhere((e) => e.key == story.cProduct, orElse: () => FeedModel()).imagePath",

              time: story.createdAt,

              //  imagePath: model!.imagePath,
            ),
          );
          break;
        case 1:
          storyItems.add(
            DuctStoryItem.pageImage(
              imageFit: BoxFit.cover,
              url: story.imagePath.toString(),
              controller: controller,
              context: context,
              id: story.key,
              audioTage: story.audioTag,
              userId: story.userId,
              productDescription: story.ductComment,
              comment: story.ductComment,
              time: story.createdAt,
              imagePath: story.imagePath,
              cName:
                  "feedState.productlist!.firstWhere((e) => e.key == story.cProduct, orElse: () => FeedModel())this.currentUser, this.secondUser,.productName",
              cPrice:
                  "feedState.productlist!.firstWhere((e) => e.key == story.cProduct,orElse: () => FeedModel()).price",
              userName: widget.secondUser!.displayName.toString(),
              cImage:
                  "feedState.productlist!.firstWhere((e) => e.key == story.cProduct, orElse: () => FeedModel()).imagePath",
            ),
          );
          break;
        case 2:
          storyItems.add(
            DuctStoryItem.pageVideo(story.videoPath,
                context: context,
                controller: controller,
                comment: story.ductComment,
                id: story.key,
                userId: story.userId,
                productDescription: story.ductComment,
                time: story.createdAt,
                cName:
                    "feedState.productlist!.firstWhere((e) => e.key == story.cProduct, orElse: () => FeedModel())this.currentUser, this.secondUser,.productName",
                cPrice:
                    "feedState.productlist!.firstWhere((e) => e.key == story.cProduct,orElse: () => FeedModel()).price",
                cImage:
                    "feedState.productlist!.firstWhere((e) => e.key == story.cProduct, orElse: () => FeedModel()).imagePath",
                duration:
                    Duration(seconds: int.parse(story.duration.toString())),
                imagePath:
                    //  feedState.productlist!
                    //     .firstWhere((e) => e.key == story.cProduct,
                    //         orElse: feedState.storyId)
                    story.imagePath,
                onTapchat: Get.back),
          );
          break;
        // default:
      }
    }
  }

  _seenUsers(DuctStoryModel? story, {BuildContext? context}) {
    // List<ViewductsUser>? list =
    //     searchState.getVendors(authState.userModel?.location);
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        elevation: 20.0,
        //  barrierColor: Colors.transparent,
        // bounce: true,
        context: context!,
        builder: (context) => SizedBox(
              width: Get.width,
              height: Get.height * 0.7,
              child: Stack(
                children: <Widget>[
                  Container(
                    width: Get.width,
                    height: Get.height * 0.7,
                    color: const Color(0xFF212332),
                  ),
                  SizedBox(
                    //color: Colors.black26,

                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      // child: ListView(
                      //     //reverse: true,
                      //     children:
                      //     storyUserViewSetState.value.map((chat) {
                      //   feedState.getMainUserViews(chat.senderId, chatId);
                      //   itsViewing() async {
                      //     final database = Databases(
                      //       clientConnect(),
                      //     );
                      //     return await database.listDocuments(
                      //         databaseId: databaseId,
                      //         collectionId: mainUserViews,
                      //         queries: [
                      //           Query.equal(
                      //               'viewerId', authState.appUser!.$id),
                      //           Query.equal('viewductUser', chat.senderId),
                      //         ]).then((data) {
                      //       var value = data.documents
                      //           .map((e) =>
                      //               MainUserViewsModel.fromJson(e.data))
                      //           .toList();
                      //       userVierState.value = value.obs;
                      //     });
                      //   }

                      //   itsViewing();
                      //   //     ViewductsUser model = ViewductsUser();
                      //   ViewductsUser model =
                      //       searchState.viewUserlist.firstWhere(
                      //     (x) => x.userId == chat.senderId,
                      //     orElse: () => ViewductsUser(),
                      //   );
                      //   return Padding(
                      //     padding: const EdgeInsets.all(2.0),
                      //     child: Row(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         Row(
                      //           children: [
                      //             GestureDetector(
                      //               onTap: () {
                      //                 chatState.setChatUser = model;

                      //                 // If tweet is displaying on someone's profile then no need to navigate to same user's profile again.
                      //                 // if (isDisplayOnProfile) {
                      //                 //   return;
                      //                 // }
                      //                 // Get.back();
                      //                 // Get.back();
                      //                 Get.to(
                      //                     () => ProfileResponsiveView(
                      //                           profileId: chat.senderId,
                      //                           profileType:
                      //                               ProfileType.Store,
                      //                         ),

                      //                     //  ChatScreenPage(
                      //                     //     userProfileId: model.userId,
                      //                     //     productId: feedState
                      //                     //         .productlist!
                      //                     //         .firstWhere(
                      //                     //             (e) => e.key == id,
                      //                     //             orElse: () =>
                      //                     //                 FeedModel())
                      //                     //         .key,
                      //                     //     isVductProduct: true),
                      //                     transition: Transition.downToUp);
                      //               },
                      //               // child: Badge(
                      //               //   badgeColor: Colors.brown,
                      //               //   position: BadgePosition.topStart(),
                      //               //   badgeContent: Padding(
                      //               //       padding: const EdgeInsets.all(2.0),
                      //               //       child: Obx(
                      //               //         () => Text(
                      //               //           // ignore: invalid_use_of_protected_member
                      //               //           feedState.userViers.value.length
                      //               //               .toString(),
                      //               //           style: const TextStyle(
                      //               //               color: Colors.white),
                      //               //         ),
                      //               //       )),
                      //               child: CircleAvatar(
                      //                 backgroundColor: Colors.transparent,
                      //                 backgroundImage:
                      //                     customAdvanceNetworkImage(
                      //                         chat.senderImage),
                      //               ),
                      //               // ),
                      //             ),
                      //             BubbleSpecialThree(
                      //                 isSender: false,
                      //                 tail: false,
                      //                 textStyle:
                      //                     const TextStyle(color: Colors.grey),
                      //                 color: Colors.black12,
                      //                 text: chat.senderName.toString()),
                      //           ],
                      //         ),
                      //         Padding(
                      //           padding: const EdgeInsets.all(5.0),
                      //           child: Column(
                      //             crossAxisAlignment: CrossAxisAlignment.end,
                      //             mainAxisAlignment: MainAxisAlignment.end,
                      //             children: [
                      //               GestureDetector(
                      //                 onTap: () {
                      //                   Get.to(
                      //                       () => ProfileResponsiveView(
                      //                             profileId: chat.senderId,
                      //                             profileType:
                      //                                 ProfileType.Store,
                      //                           ),

                      //                       //  ChatScreenPage(
                      //                       //     userProfileId: model.userId,
                      //                       //     productId: feedState
                      //                       //         .productlist!
                      //                       //         .firstWhere(
                      //                       //             (e) => e.key == id,
                      //                       //             orElse: () =>
                      //                       //                 FeedModel())
                      //                       //         .key,
                      //                       //     isVductProduct: true),
                      //                       transition: Transition.downToUp);
                      //                 },
                      //                 child: Container(
                      //                     // height: Get.width * 0.1,
                      //                     decoration: BoxDecoration(
                      //                         boxShadow: [
                      //                           BoxShadow(
                      //                               offset:
                      //                                   const Offset(0, 11),
                      //                               blurRadius: 11,
                      //                               color: Colors.black
                      //                                   .withOpacity(0.06))
                      //                         ],
                      //                         borderRadius:
                      //                             BorderRadius.circular(18),
                      //                         color: CupertinoColors
                      //                             .lightBackgroundGray),
                      //                     padding: const EdgeInsets.all(5.0),
                      //                     child: const Text(
                      //                       'Visit Business',
                      //                       style: TextStyle(
                      //                           color: CupertinoColors
                      //                               .darkBackgroundGray,
                      //                           fontWeight: FontWeight.w900),
                      //                     )),
                      //               ),
                      //               Padding(
                      //                 padding: EdgeInsets.all(4.0),
                      //                 child: Text(
                      //                   model.state ?? '',
                      //                   style: TextStyle(
                      //                       color: CupertinoColors.white,
                      //                       fontWeight: FontWeight.w900),
                      //                 ),
                      //               )
                      //             ],
                      //           ),
                      //         )
                      //       ],
                      //     ),
                      //   );
                      // }).toList()),
                    ),
                  )
                ],
              ),
            ));
  }

  // _loadStory({DuctStoryModel? story, bool animatedToPage = true}) {
  Future<bool?> isLiked(bool state) async {
    // state == true
    //     ? feedState.removeHearts(
    //         currentStory.value.value.key, authState.userModel?.userId)
    //     : feedState.addHearts(
    //         currentStory.value.value.key, authState.userModel?.userId);
    return true;
  }

  // FeedModel product = FeedModel();
  @override
  Widget build(BuildContext context) {
    Storage storage = Storage(clientConnect());
    // addStoryItems(context);

    cprint('${currentStory.cProduct} product');
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // if (isPause.value.value = true) {
          //   controller.play();
          //   isPause.value.value = false;
          // }
        },
        child: Stack(
          children: [
            SizedBox(
                width: Get.width,
                height: Get.height,
                child: DuctstoryView(
                    //progressPosition: ProgressPosition.bottom,
                    storyItems: storyItems,
                    onStoryShow: (storyItem) async {
                      final index = storyItems.indexOf(storyItem);
                      currentStory = widget.storylist![index];
                      // storyProduct = ref
                      //         .watch(getOneProductProvider(
                      //             '${currentStory.cProduct}'))
                      //         .value ??
                      //     FeedModel();
                      vendor =
                          ref.watch(userDetailsProvider(widget.vendorId)).value;

                      Future.delayed(Duration(milliseconds: 800), () {
                        ref
                            .read(ductControllerProvider.notifier)
                            .seePinDuctStory(currentStory, widget.currentUser!,
                                model: widget.model);
                      });
                      // product = ref
                      //         .watch(getOneProductProvider(
                      //             '${currentStory.cProduct}'))
                      //         .value ??
                      // FeedModel();
                      Future.delayed(Duration(milliseconds: 100), () {
                        setState(() {});
                      });
                    },
                    controller: controller)),
            Positioned(
              top: Get.height * 0.03,
              right: Get.width * 0.02,
              child: Material(
                borderRadius: BorderRadius.circular(100),
                elevation: 20,
                child: SizedBox(
                  width: Get.height * 0.07,
                  height: Get.height * 0.07,
                  child: GestureDetector(
                    onTap: () {
                      // ViewductsUser model;
                      // model = ductUser.value;
                      //  chatState.setChatUser = ductUser.value;

                      // If tweet is displaying on someone's profile then no need to navigate to same user's profile again.
                      // if (isDisplayOnProfile) {
                      //   return;
                      // }
                      //controller.dispose();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileResponsiveView(
                                    profileId: widget.secondUser?.userId,
                                    profileType: ProfileType.Store,
                                  )));
                      //Get.back();
                      // Get.to(
                      //     () => ChatScreenPage(
                      //         userProfileId: widget.model!.userId,
                      //         productId: product.key,
                      //         isVductProduct: true),
                      //     transition: Transition.downToUp);
                      // Get.to(() => ProfileResponsiveView(
                      //       profileId: widget.secondUser?.userId,
                      //       profileType: ProfileType.Store,
                      //     ));
                      // Navigator.of(context)
                      //     .pushNamed('/ProfilePage/' + model?.userId);
                    },
                    child: customImage(context, widget.secondUser!.profilePic),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: Get.height * 0.1,
              right: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LikeButton(
                    size: 50,
                    onTap: (isLiked) async {
                      ref.read(ductControllerProvider.notifier).likeDuct(
                          currentStory, widget.currentUser!,
                          model: widget.model);
                      return !isLiked;
                    },
                    isLiked:
                        currentStory.hearts?.contains(widget.currentUser?.key),
                    likeBuilder: (isLiked) {
                      return isLiked
                          ? Icon(
                              size: 50,
                              CupertinoIcons.heart_circle_fill,
                              color: CupertinoColors.systemRed,
                            )
                          //  SvgPicture.asset(
                          //     AssetsConstants
                          //         .likeFilledIcon,
                          //     color: Pallete.redColor,
                          //   )
                          : Icon(
                              size: 50,
                              CupertinoIcons.heart_circle_fill,
                              color: CupertinoColors.lightBackgroundGray,
                            );
                    },
                    likeCount: currentStory.hearts?.length,
                    countBuilder: (likeCount, isLiked, text) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: Text(
                          text,
                          style: TextStyle(
                            color: isLiked
                                ? CupertinoColors.systemRed
                                : CupertinoColors.lightBackgroundGray,
                            fontSize: 16,
                          ),
                        ),
                      );
                    },
                  ),
                  LikeButton(
                    size: 50,
                    // onTap: (isLiked) async {
                    //   // ref.read(ductControllerProvider.notifier).likeDuct(
                    //   //     currentStory, widget.currentUser!,
                    //   //     model: widget.model);
                    //   // return !isLiked;
                    // },
                    isLiked: currentStory.userViwed?.length != 0,
                    likeBuilder: (isLiked) {
                      return isLiked
                          ? Image.asset(
                              'assets/vgroup.png',
                              width: 50,
                            )
                          //  SvgPicture.asset(
                          //     AssetsConstants
                          //         .likeFilledIcon,
                          //     color: Pallete.redColor,
                          //   )
                          : Image.asset(
                              'assets/vgroup.png',
                              width: 50,
                            );
                    },
                    likeCount: currentStory.userViwed?.length,
                    countBuilder: (likeCount, isLiked, text) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 2.0),
                        child: Text(
                          text,
                          style: TextStyle(
                            color: isLiked
                                ? CupertinoColors.darkBackgroundGray
                                : CupertinoColors.lightBackgroundGray,
                            fontSize: 16,
                          ),
                        ),
                      );
                    },
                  ),

                  widget.currentUser?.userId == widget.secondUser!.userId
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              controller.pause();
                              // isPause.value.value = true;
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.red,
                                  // bounce: true,
                                  context: context,
                                  builder: (context) => Container(
                                        height: fullHeight(context) * 0.95,
                                        child: ProductStoryView(
                                          model: widget.product,
                                          commissionUser:
                                              widget.secondUser!.userId,
                                          currentUser: widget.currentUser,
                                          vendor: vendor,
                                        ),
                                      ));
                            },
                            child: Container(
                                padding: const EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.yellow.withOpacity(0.9),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Buy',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontFamily: 'HelveticaNeue',
                                      fontWeight: FontWeight.w900,
                                      fontSize: Get.width * 0.04,
                                    ),
                                  ),
                                )),
                          ),
                        ),

                  // feedState.productlist!
                  //                 .firstWhere((e) => e.userId == commissionUser,
                  //                     orElse: feedState.storyId)
                  //                 .userId ==
                  //             currentUser?.userId ||
                  //         widget.model!.userId == currentUser?.userId
                  //     ? Container()
                  //     :
                  // Padding(
                  //   padding: const EdgeInsets.all(2.0),
                  //   child: GestureDetector(
                  //     // context: context,
                  //     onTap: () {
                  //       // controller.pause();
                  //       // Future.delayed(Duration(milliseconds: 400), () {
                  //       //   ViewDialogs().customeDialog(context,
                  //       //       height: fullHeight(context),
                  //       //       width: fullWidth(context),
                  //       //       body: GestureDetector(
                  //       //         onHorizontalDragUpdate: (details) {
                  //       //           // Note: Sensitivity is integer used when you don't want to mess up vertical drag
                  //       //           int sensitivity = 8;
                  //       //           if (details.delta.dx > sensitivity) {
                  //       //             // Right Swipe
                  //       //             Navigator.pop(context);
                  //       //           } else if (details.delta.dx < -sensitivity) {
                  //       //             Navigator.pop(context);

                  //       //             //Left Swipe
                  //       //           }
                  //       //         },
                  //       //         child: Stack(
                  //       //           clipBehavior: Clip.none,
                  //       //           children: [
                  //       //             Container(
                  //       //                 height: fullHeight(context),
                  //       //                 width: fullWidth(context),
                  //       //                 decoration: BoxDecoration(
                  //       //                   borderRadius:
                  //       //                       BorderRadius.circular(18),
                  //       //                 ),
                  //       //                 child: Column(
                  //       //                   children: [
                  //       //                     Expanded(
                  //       //                       // height: fullHeight(context) * 0.8,
                  //       //                       // width: fullWidth(context),
                  //       //                       // decoration: BoxDecoration(
                  //       //                       //     borderRadius: BorderRadius.circular(18),
                  //       //                       //     color: Pallete.scafoldBacgroundColor),
                  //       //                       child: Container(
                  //       //                         decoration: BoxDecoration(
                  //       //                             borderRadius:
                  //       //                                 BorderRadius.circular(
                  //       //                                     18),
                  //       //                             color: Pallete
                  //       //                                 .scafoldBacgroundColor),
                  //       //                       ),
                  //       //                     ),
                  //       //                     Container(
                  //       //                       height: 50,
                  //       //                       decoration: BoxDecoration(
                  //       //                           borderRadius:
                  //       //                               BorderRadius.circular(18),
                  //       //                           color: Pallete
                  //       //                               .scafoldBacgroundColor),
                  //       //                     ),
                  //       //                     // Container(
                  //       //                     //   height: fullHeight(context) * 0.7,
                  //       //                     //   decoration: BoxDecoration(
                  //       //                     //       borderRadius: BorderRadius.circular(18),
                  //       //                     //       color: Pallete.scafoldBacgroundColor),
                  //       //                     // )
                  //       //                   ],
                  //       //                 )),
                  //       //             // Positioned(
                  //       //             //   bottom: 10,
                  //       //             //   left: 0,
                  //       //             //   right: 0,
                  //       //             //   child: Lottie.asset('assets/lottie/discount.json',
                  //       //             //       width: 100, height: 100),
                  //       //             // ),
                  //       //             Positioned(
                  //       //               top: -10,
                  //       //               right: 100,
                  //       //               child: Container(
                  //       //                 // width: 60,
                  //       //                 decoration: BoxDecoration(
                  //       //                     boxShadow: [
                  //       //                       BoxShadow(
                  //       //                           offset: const Offset(0, 11),
                  //       //                           blurRadius: 11,
                  //       //                           color: Colors.black
                  //       //                               .withOpacity(0.06))
                  //       //                     ],
                  //       //                     borderRadius:
                  //       //                         BorderRadius.circular(20),
                  //       //                     color:
                  //       //                         CupertinoColors.systemYellow),
                  //       //                 padding: const EdgeInsets.all(5.0),
                  //       //                 child: TitleText('PinDucts Views',
                  //       //                     // color: Colors.white,
                  //       //                     // fontSize: 16,
                  //       //                     // fontWeight: FontWeight.w800,
                  //       //                     overflow: TextOverflow.ellipsis),
                  //       //               ),
                  //       //             ),
                  //       //           ],
                  //       //         ),
                  //       //       ),
                  //       //       dx: -1,
                  //       //       dy: 0,
                  //       //       horizontal: 16,
                  //       //       vertical: 0.1);
                  //       // });
                  //     },
                  //     child: currentStory.userViwed?.length == 0
                  //         ? Image.asset(
                  //             'assets/vgroup.png',
                  //             width: 50,
                  //           )
                  //         : Badge(
                  //             alignment: AlignmentDirectional.topStart,
                  //             backgroundColor:
                  //                 CupertinoColors.lightBackgroundGray,
                  //             textColor: CupertinoColors.systemRed,
                  //             label: Text(
                  //                 currentStory.userViwed?.length.toString() ??
                  //                     '0'),
                  //             child: Image.asset(
                  //               'assets/vgroup.png',
                  //               width: 50,
                  //             ),
                  //           ),
                  //   ),
                  // ),

                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: customInkWell(
                      context: context,
                      onPressed: () {
                        controller.pause();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StoryChat(
                                  storyId: currentStory.key,
                                  currentStory: currentStory,
                                  currentUser: widget.currentUser!),
                            ));
                        // Future.delayed(Duration(milliseconds: 400), () {
                        //   ViewDialogs().customeDialog(context,
                        //       height: fullHeight(context),
                        //       width: fullWidth(context),
                        //       body: GestureDetector(
                        //         onHorizontalDragUpdate: (details) {
                        //           // Note: Sensitivity is integer used when you don't want to mess up vertical drag
                        //           int sensitivity = 8;
                        //           if (details.delta.dx > sensitivity) {
                        //             // Right Swipe
                        //             Navigator.pop(context);
                        //           } else if (details.delta.dx < -sensitivity) {
                        //             Navigator.pop(context);

                        //             //Left Swipe
                        //           }
                        //         },
                        //         child: Stack(
                        //           clipBehavior: Clip.none,
                        //           children: [
                        //             Container(
                        //                 height: fullHeight(context),
                        //                 width: fullWidth(context),
                        //                 decoration: BoxDecoration(
                        //                   borderRadius:
                        //                       BorderRadius.circular(18),
                        //                 ),
                        //                 child: Column(
                        //                   children: [
                        //                     Expanded(
                        //                       // height: fullHeight(context) * 0.8,
                        //                       // width: fullWidth(context),
                        //                       // decoration: BoxDecoration(
                        //                       //     borderRadius: BorderRadius.circular(18),
                        //                       //     color: Pallete.scafoldBacgroundColor),
                        //                       child: Container(
                        //                         decoration: BoxDecoration(
                        //                             borderRadius:
                        //                                 BorderRadius.circular(
                        //                                     18),
                        //                             color: Pallete
                        //                                 .scafoldBacgroundColor),
                        //                         child: StoryChat(
                        //                             storyId: currentStory.key),
                        //                       ),
                        //                     ),

                        //                     // Container(
                        //                     //   height: fullHeight(context) * 0.7,
                        //                     //   decoration: BoxDecoration(
                        //                     //       borderRadius: BorderRadius.circular(18),
                        //                     //       color: Pallete.scafoldBacgroundColor),
                        //                     // )
                        //                   ],
                        //                 )),
                        //             // Positioned(
                        //             //   bottom: 10,
                        //             //   left: 0,
                        //             //   right: 0,
                        //             //   child: Lottie.asset('assets/lottie/discount.json',
                        //             //       width: 100, height: 100),
                        //             // ),
                        //             Positioned(
                        //               top: -10,
                        //               right: 100,
                        //               child: Container(
                        //                 // width: 60,
                        //                 decoration: BoxDecoration(
                        //                     boxShadow: [
                        //                       BoxShadow(
                        //                           offset: const Offset(0, 11),
                        //                           blurRadius: 11,
                        //                           color: Colors.black
                        //                               .withOpacity(0.06))
                        //                     ],
                        //                     borderRadius:
                        //                         BorderRadius.circular(20),
                        //                     color:
                        //                         CupertinoColors.systemYellow),
                        //                 padding: const EdgeInsets.all(5.0),
                        //                 child: TitleText('PinDucts Chats',
                        //                     // color: Colors.white,
                        //                     // fontSize: 16,
                        //                     // fontWeight: FontWeight.w800,
                        //                     overflow: TextOverflow.ellipsis),
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //       dx: -1,
                        //       dy: 0,
                        //       horizontal: 16,
                        //       vertical: 0.1);
                        // });
                      },
                      child: CircleAvatar(
                        radius: Get.height * 0.03,
                        backgroundColor: Colors.black87.withOpacity(0.3),
                        child: Lottie.asset(
                          'assets/lottie/chat-box-animation.json',
                        ),
                      ),
                    ),
                  ),

                  //feedState.storyId.value.userId == currentUser?.userId ||
                  currentStory.userId == widget.currentUser?.userId
                      ? ViewDuctMenuHolder(
                          onPressed: () {
                            controller.pause();
                          },
                          menuItems: <DuctFocusedMenuItem>[
                            DuctFocusedMenuItem(
                                backgroundColor: Colors.transparent,
                                title: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
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
                                        color: CupertinoColors.systemYellow),
                                    padding: const EdgeInsets.all(5.0),
                                    child: const Text(
                                      'Edit this Duct',
                                      style: TextStyle(
                                        //fontSize: Get.width * 0.03,
                                        color: AppColor.darkGrey,
                                      ),
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => DuctSharePage(
                                                isUpdating: true,
                                                ductStory: currentStory,
                                                editedDuct: currentStory
                                                            .storyType ==
                                                        2
                                                    ? currentStory.videoPath
                                                    : currentStory.storyType ==
                                                            1
                                                        ? currentStory.imagePath
                                                        : currentStory
                                                            .ductComment,
                                                currentUser:
                                                    widget.currentUser!,
                                                ductPostType: currentStory
                                                            .storyType ==
                                                        2
                                                    ? DuctPostType.video
                                                    : currentStory.storyType ==
                                                            1
                                                        ? DuctPostType.image
                                                        : DuctPostType.text,
                                              )));
                                  // controller.next();
                                },
                                trailingIcon: const Icon(CupertinoIcons.app)),
                            DuctFocusedMenuItem(
                                backgroundColor: Colors.transparent,
                                title: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
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
                                        color: CupertinoColors.systemYellow),
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      currentStory.pinDuct != null
                                          ? 'Unpin this Duct'
                                          : 'Pin this Duct',
                                      style: TextStyle(
                                        //fontSize: Get.width * 0.03,
                                        color: AppColor.darkGrey,
                                      ),
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  if (currentStory.pinDuct == null) {
                                    ref
                                        .read(ductControllerProvider.notifier)
                                        .pinDuctStory(currentStory,
                                            pinState: 'yes');
                                    setState(() {});
                                  } else {
                                    ref
                                        .read(ductControllerProvider.notifier)
                                        .pinDuctStory(currentStory,
                                            pinState: null);
                                    setState(() {});
                                  }
                                  // controller.next();
                                },
                                trailingIcon: Icon(
                                  currentStory.pinDuct == null
                                      ? CupertinoIcons.pin_fill
                                      : CupertinoIcons.pin_slash,
                                  color: CupertinoColors.darkBackgroundGray,
                                )),
                            DuctFocusedMenuItem(
                                backgroundColor: Colors.transparent,
                                title: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
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
                                        color: CupertinoColors.systemYellow),
                                    padding: const EdgeInsets.all(5.0),
                                    child: const Text(
                                      'Share this Duct',
                                      style: TextStyle(
                                        //fontSize: Get.width * 0.03,
                                        color: AppColor.darkGrey,
                                      ),
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  ref
                                      .read(ductControllerProvider.notifier)
                                      .reShareDuct(
                                          storyType: currentStory.storyType!,
                                          // image: currentStory.imagePath,
                                          // videoPath: currentStory.videoPath,
                                          // images: images,
                                          ductStory: currentStory,
                                          reshare: true,
                                          product: widget.product,
                                          text: currentStory.ductComment,
                                          context: context,
                                          user: widget.currentUser!);
                                  // // await userCartController.deleteDuctStory(
                                  // //     currentStory.value.value.key.toString());
                                  //controller.next();
                                },
                                trailingIcon:
                                    const Icon(CupertinoIcons.share_solid)),
                          ],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Container(
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
                                child: Icon(CupertinoIcons.app_badge),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            ref.watch(getOneProductProvider('${currentStory.cProduct}')).when(
                data: (product) {
                  return Positioned(
                    bottom: Get.height * 0.01,
                    left: 0,
                    child: GestureDetector(
                      onTap: () {
                        controller.pause();
                        //  isPause.value.value = true;
                        showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: Colors.red,
                            // bounce: true,
                            context: context,
                            builder: (context) => Container(
                                  height: fullHeight(context) * 0.95,
                                  child: ProductStoryView(
                                    model: widget.product,
                                    commissionUser: widget.secondUser!.userId,
                                    currentUser: widget.currentUser,
                                    vendor: vendor,
                                  ),
                                ));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    alignment: Alignment.center,
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
                                              BorderRadius.circular(2),
                                          color: CupertinoColors.systemYellow),
                                      padding: const EdgeInsets.all(5.0),
                                      height: Get.height * 0.08,
                                      width: Get.height * 0.08,
                                      child: FutureBuilder(
                                        future: storage.getFileView(
                                            bucketId: productBucketId,
                                            fileId: product.imagePath
                                                .toString()), //works for both public file and private file, for private files you need to be logged in
                                        builder: (context, snapshot) {
                                          return snapshot.data != null
                                              ? Image.memory(
                                                  snapshot.data as Uint8List,
                                                  width: Get.height * 0.3,
                                                  height: Get.height * 0.4,
                                                  fit: BoxFit.contain)
                                              : Center(
                                                  child: SizedBox(
                                                  width: Get.height * 0.2,
                                                  height: Get.height * 0.2,
                                                  child: LoadingIndicator(
                                                      indicatorType: Indicator
                                                          .ballTrianglePath,

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
                                                      pathBackgroundColor:
                                                          Colors.blue

                                                      /// Optional, the stroke backgroundColor
                                                      ),
                                                )
                                                  //  CircularProgressIndicator
                                                  //     .adaptive()
                                                  );
                                        },
                                      ),

                                      //  customNetworkImage(
                                      //   cImage,
                                      //   fit: BoxFit.cover,
                                      // ),
                                    ),
                                  ),
                                ),
                                product.price == null
                                    ? Container()
                                    : product.stockQuantity == 0
                                        ? Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 3),
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child:
                                                customTitleText('Out of Stock'),
                                          )
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              product.salePrice == 0 ||
                                                      product.salePrice == null
                                                  ? Container()
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Container(
                                                          decoration: BoxDecoration(
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    offset:
                                                                        const Offset(0,
                                                                            11),
                                                                    blurRadius:
                                                                        11,
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.06))
                                                              ],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          18),
                                                              color:
                                                                  CupertinoColors
                                                                      .systemRed),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: TitleText(
                                                            'On Sale',
                                                            color: CupertinoColors
                                                                .lightBackgroundGray,
                                                          )),
                                                    ),
                                              customText(product.productName,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.yellow)),
                                              Row(
                                                children: [
                                                  product.salePrice == 0 ||
                                                          product.salePrice ==
                                                              null
                                                      ? Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  offset:
                                                                      const Offset(
                                                                          0, 11),
                                                                  blurRadius:
                                                                      11,
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.06))
                                                            ],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        18),
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: frostedTeal(
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(2.0),
                                                              child: Wrap(
                                                                children: [
                                                                  customText(
                                                                    NumberFormat.currency(
                                                                            name: product.productLocation == 'Nigeria'
                                                                                ? '₦'
                                                                                : '£')
                                                                        .format(double.parse(product
                                                                            .price
                                                                            .toString())),

                                                                    style: TextStyle(
                                                                        color: CupertinoColors
                                                                            .lightBackgroundGray,
                                                                        fontSize:
                                                                            Get.height *
                                                                                0.04
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
                                                        )
                                                      : Row(
                                                          children: [
                                                            Container(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      8.0,
                                                                  vertical: 3),
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .black54,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10)),
                                                              child: customText(
                                                                  NumberFormat.currency(
                                                                          name: product.productLocation == 'Nigeria'
                                                                              ? '₦'
                                                                              : '£')
                                                                      .format(double.parse(product
                                                                          .salePrice
                                                                          .toString())),
                                                                  //'N ${widget.ductProduct!.price}',
                                                                  style:
                                                                      TextStyle(
                                                                    color: CupertinoColors
                                                                        .systemRed,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize: context.responsiveValue(
                                                                        mobile: Get.height *
                                                                            0.03,
                                                                        tablet: Get.height *
                                                                            0.03,
                                                                        desktop:
                                                                            Get.height *
                                                                                0.03),
                                                                  )),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          2.0),
                                                              child: Container(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        8.0,
                                                                    vertical:
                                                                        3),
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .black54,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                child: customText(
                                                                    NumberFormat.currency(
                                                                            name: product.productLocation == 'Nigeria'
                                                                                ? '₦'
                                                                                : '£')
                                                                        .format(double.parse(product
                                                                            .price
                                                                            .toString())),

                                                                    //'N ${widget.ductProduct!.price}',

                                                                    style:
                                                                        TextStyle(
                                                                      decoration:
                                                                          TextDecoration
                                                                              .lineThrough,
                                                                      color: CupertinoColors
                                                                          .systemYellow,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize: context.responsiveValue(
                                                                          mobile: Get.height *
                                                                              0.02,
                                                                          tablet: Get.height *
                                                                              0.02,
                                                                          desktop:
                                                                              Get.height * 0.02),
                                                                    )),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                ],
                                              ),
                                            ],
                                          )
                              ]),
                        ],
                      ),
                    ),
                  );
                },
                error: (error, stackTrace) => ErrorText(
                      error: error.toString(),
                    ),
                loading: () => const LoaderAll()),
            currentStory.userId != widget.currentUser!.userId
                ? Container()
                : currentStory.pinDuct == null
                    ? Container()
                    : Positioned(
                        top: fullHeight(context) * 0.1,
                        left: 10,
                        child: Icon(
                          size: 50,
                          CupertinoIcons.pin_fill,
                          color: Colors.blueGrey.withOpacity(.5),
                        ))
          ],
        ),
      ),
    );
  }
}

class AnimatedBar extends HookWidget {
  final AnimationController animController;
  final int position;
  final int currentIndex;
  const AnimatedBar(
      {Key? key,
      required this.animController,
      required this.position,
      required this.currentIndex})
      : super(key: key);
  _buildContainer(double width, Color color) {
    return Container(
        height: 5.0,
        width: width,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: Colors.black26,
            width: 0.8,
          ),
          borderRadius: BorderRadius.circular(3.0),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.5),
            child: LayoutBuilder(builder: (context, constraints) {
              return Stack(children: <Widget>[
                _buildContainer(
                    double.infinity,
                    position < currentIndex
                        ? Colors.white
                        : Colors.white.withOpacity(0.5)),
                position == currentIndex
                    ? AnimatedBuilder(
                        animation: animController,
                        builder: (context, child) {
                          return _buildContainer(
                              constraints.maxWidth * animController.value,
                              Colors.white);
                        })
                    : SizedBox.shrink(),
              ]);
            })));
  }
}

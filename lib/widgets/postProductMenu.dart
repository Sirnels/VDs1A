// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:viewducts/app_theme/app_theme_constant.dart';
import 'package:viewducts/common/common.dart';
import 'package:viewducts/common/duct_share_page.dart';
import 'package:viewducts/constants/constants.dart';
import 'package:viewducts/features/auth/controller/auth_controller.dart';
import 'package:viewducts/features/products/product_controller.dart';
import 'package:viewducts/helper/enum.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/page/common/general_dialog.dart';
import 'package:viewducts/page/message/item_Search_bar.dart';
import 'package:viewducts/page/responsiveView.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/frosted.dart';
import 'package:viewducts/widgets/newWidget/title_text.dart';

class PostProductMenu extends ConsumerWidget {
  final ViewductsUser currentUser;
  PostProductMenu({
    Key? key,
    required this.currentUser,
  }) : super(key: key);
  GlobalKey? actionKey;

  Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //  final currentUser = ref.watch(currentUserDetailsProvider).value;
    final textEditingController = TextEditingController();
    // final appPlayStoreState = useState(authState.appPlayStore);
    Future<bool?> _showDialogs() {
      return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return frostedYellow(
            Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Colors.transparent,
              child: frostedYellow(
                Container(
                  height: Get.height * 0.2,
                  width: 100,
                  child: Column(
                    children: [
                      Wrap(
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
                                    borderRadius: BorderRadius.circular(5),
                                    color: CupertinoColors.systemRed),
                                padding: const EdgeInsets.all(5.0),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: const Text(
                                    'Are you sure you want to delete your account? it will not be recovered',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w200,
                                        color: CupertinoColors
                                            .lightBackgroundGray),
                                  ),
                                )),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.maybePop(context);
                              },
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
                                      color: CupertinoColors.inactiveGray),
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    children: [
                                      Icon(CupertinoIcons.back),
                                      const Text(
                                        'Cancel',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w200),
                                      )
                                    ],
                                  )),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {},
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
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
                                      color: CupertinoColors.systemRed),
                                  padding: const EdgeInsets.all(5.0),
                                  child: const Text(
                                    'Delect',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w200),
                                  )),
                            ),
                          ),
                        ],
                      )
                      // Container(
                      //   height: Get.height * 0.3,
                      //   width: Get.height * 0.2,
                      //   decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(20)),
                      //   child: SafeArea(
                      //     child: Stack(
                      //       children: <Widget>[
                      //         Center(
                      //           child: ModalTile(
                      //             title: "File Exceeds Limit",
                      //             subtitle: "Please reduce your file size",
                      //             icon: Icons.tab,
                      //             onTap: () async {
                      //               Navigator.maybePop(context);
                      //             },
                      //           ),
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    Future<bool?> _showDialog() {
      return showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Container();
          //  frostedYellow(
          //   Dialog(
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(20),
          //     ),
          //     backgroundColor: Colors.transparent,
          //     child: frostedYellow(
          //       Center(
          //         child: SingleChildScrollView(
          //           scrollDirection: Axis.vertical,
          //           child: Container(
          //             height: Get.height * 0.5,
          //             child: Column(
          //               children: [
          //                 Padding(
          //                   padding: const EdgeInsets.all(5.0),
          //                   child: Container(
          //                       decoration: BoxDecoration(
          //                           boxShadow: [
          //                             BoxShadow(
          //                                 offset: const Offset(0, 11),
          //                                 blurRadius: 11,
          //                                 color: Colors.black.withOpacity(0.06))
          //                           ],
          //                           borderRadius: BorderRadius.circular(18),
          //                           color: CupertinoColors.white),
          //                       padding: const EdgeInsets.all(5.0),
          //                       child: GestureDetector(
          //                         onTap: () {
          //                           Navigator.maybePop(context);
          //                         },
          //                         child: const Text(
          //                           'Downlod App to Countinue',
          //                           style:
          //                               TextStyle(fontWeight: FontWeight.w200),
          //                         ),
          //                       )),
          //                 ),
          //                 authState.appPlayStore
          //                         .where(
          //                             (data) => data.operatingSystem == 'IOS')
          //                         .isNotEmpty
          //                     ? GestureDetector(
          //                         onTap: () {
          //                           String? appDownload = appPlayStoreState
          //                               .value
          //                               .firstWhere((data) =>
          //                                   data.operatingSystem == 'IOS')
          //                               .downloadApp;
          //                           String? storeUrl = appPlayStoreState.value
          //                               .firstWhere((data) =>
          //                                   data.operatingSystem == 'IOS')
          //                               .storeUrl;
          //                           String? downlodUrl = appPlayStoreState.value
          //                               .firstWhere((data) =>
          //                                   data.operatingSystem == 'IOS')
          //                               .downloadUrl;
          //                           final minio = Minio(
          //                               endPoint: userCartController
          //                                   .wasabiAws.value.endPoint
          //                                   .toString(),
          //                               accessKey: userCartController
          //                                   .wasabiAws.value.accessKey
          //                                   .toString(),
          //                               secretKey: userCartController
          //                                   .wasabiAws.value.secretKey
          //                                   .toString(),
          //                               region: userCartController
          //                                   .wasabiAws.value.region
          //                                   .toString());
          //                           appDownload == ''
          //                               ? minio.getObject(
          //                                   userCartController
          //                                       .wasabiAws.value.buckedId
          //                                       .toString(),
          //                                   '$downlodUrl')
          //                               : launchURL("$storeUrl");
          //                         },
          //                         child: Image.asset(
          //                           'assets/app-store.png',
          //                           height: context.responsiveValue(
          //                               mobile: Get.height * 0.1,
          //                               tablet: Get.height * 0.1,
          //                               desktop: Get.height * 0.1),
          //                         ),
          //                       )
          //                     : Container(),
          //                 authState.appPlayStore
          //                         .where((data) =>
          //                             data.operatingSystem == 'Android')
          //                         .isNotEmpty
          //                     ? GestureDetector(
          //                         onTap: () {
          //                           String? appDownload = appPlayStoreState
          //                               .value
          //                               .firstWhere((data) =>
          //                                   data.operatingSystem == 'Android')
          //                               .downloadApp;
          //                           String? storeUrl = appPlayStoreState.value
          //                               .firstWhere((data) =>
          //                                   data.operatingSystem == 'Android')
          //                               .storeUrl;
          //                           String? downlodUrl = appPlayStoreState.value
          //                               .firstWhere((data) =>
          //                                   data.operatingSystem == 'Android')
          //                               .downloadUrl;
          //                           final minio = Minio(
          //                               endPoint: userCartController
          //                                   .wasabiAws.value.endPoint
          //                                   .toString(),
          //                               accessKey: userCartController
          //                                   .wasabiAws.value.accessKey
          //                                   .toString(),
          //                               secretKey: userCartController
          //                                   .wasabiAws.value.secretKey
          //                                   .toString(),
          //                               region: userCartController
          //                                   .wasabiAws.value.region
          //                                   .toString());
          //                           appDownload == ''
          //                               ? minio.getObject(
          //                                   userCartController
          //                                       .wasabiAws.value.buckedId
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
          //                     : Container(),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // );
        },
      );
    }

    // app() async {
    //   try {
    //     final database = Databases(
    //       clientConnect(),
    //     );
    //     await database.listDocuments(
    //         databaseId: databaseId,
    //         collectionId: playAppStoreColl,
    //         queries: [Query.equal('active', true)]).then((data) {
    //       var value = data.documents
    //           .map((e) => AppPlayStoreModel.fromJson(e.data))
    //           .toList();

    //       appPlayStoreState.value.value = value.obs;
    //     });
    //   } on AppwriteException catch (e) {
    //     cprint(e.toString());
    //   }
    // }

    // useEffect(
    //   () {
    //     app();

    //     return () {};
    //   },
    //   [],
    // );
    return GestureDetector(
        key: actionKey,
        onTap: () {
          Future.delayed(Duration(milliseconds: 400), () {
            ViewDialogs().customeDialog(context,
                height: fullHeight(context),
                width: fullWidth(context),
                body: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                        height: fullHeight(context),
                        width: fullWidth(context),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          // color: Pallete.scafoldBacgroundColor
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 180,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  color: Pallete.scafoldBacgroundColor),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    // mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: InkWell(
                                          onTap: () {},
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                'assets/vdocument.png',
                                                width: 50,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              DuctSharePage(
                                                                editedDuct: '',
                                                                currentUser:
                                                                    currentUser,
                                                                ductPostType:
                                                                    DuctPostType
                                                                        .text,
                                                              )));
                                                  // Future.delayed(
                                                  //     Duration(
                                                  //         milliseconds: 400),
                                                  //     () {
                                                  //   ViewDialogs()
                                                  //       .customeDialog(context,
                                                  //           isDuct: true,
                                                  //           height: fullHeight(
                                                  //               context),
                                                  //           width: fullWidth(
                                                  //               context),
                                                  //           body: Stack(
                                                  //             clipBehavior:
                                                  //                 Clip.none,
                                                  //             children: [
                                                  //               Container(
                                                  //                   height: fullHeight(
                                                  //                       context),
                                                  //                   width: fullWidth(
                                                  //                       context),
                                                  //                   decoration:
                                                  //                       BoxDecoration(
                                                  //                     borderRadius:
                                                  //                         BorderRadius.circular(
                                                  //                             18),
                                                  //                     // color: Pallete.scafoldBacgroundColor
                                                  //                   ),
                                                  //                   child:
                                                  //                       DuctSharePage(
                                                  //                     ductPostType:
                                                  //                         DuctPostType
                                                  //                             .text,
                                                  //                   )),
                                                  //               Positioned(
                                                  //                 top: -10,
                                                  //                 right: 100,
                                                  //                 child:
                                                  //                     Container(
                                                  //                   width: 60,
                                                  //                   decoration: BoxDecoration(
                                                  //                       boxShadow: [
                                                  //                         BoxShadow(
                                                  //                             offset: const Offset(0, 11),
                                                  //                             blurRadius: 11,
                                                  //                             color: Colors.black.withOpacity(0.06))
                                                  //                       ],
                                                  //                       borderRadius:
                                                  //                           BorderRadius.circular(
                                                  //                               20),
                                                  //                       color: Pallete
                                                  //                           .scafoldBacgroundColor),
                                                  //                   padding:
                                                  //                       const EdgeInsets.all(
                                                  //                           5.0),
                                                  //                   child: TitleText(
                                                  //                       'Text',
                                                  //                       // color: Colors.white,
                                                  //                       // fontSize: 16,
                                                  //                       // fontWeight: FontWeight.w800,
                                                  //                       overflow:
                                                  //                           TextOverflow.ellipsis),
                                                  //                 ),
                                                  //               ),
                                                  //             ],
                                                  //           ),
                                                  //           dx: -1,
                                                  //           dy: 0,
                                                  //           horizontal: 16,
                                                  //           vertical: 0.2);
                                                  // });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                            offset:
                                                                const Offset(
                                                                    0, 11),
                                                            blurRadius: 11,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.06))
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color: CupertinoColors
                                                          .lightBackgroundGray),
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: TitleText('Write Text',
                                                      // color: Colors.white,
                                                      // fontSize: 16,
                                                      // fontWeight: FontWeight.w800,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: InkWell(
                                          onTap: () {},
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                'assets/vuploadimage.png',
                                                width: 50,
                                              ),
                                              Container(
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
                                                            5),
                                                    color: CupertinoColors
                                                        .lightBackgroundGray),
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: TitleText('Upload Image',
                                                    // color: Colors.white,
                                                    // fontSize: 16,
                                                    // fontWeight: FontWeight.w800,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: InkWell(
                                          onTap: () {},
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                'assets/vuploadvideo.png',
                                                width: 50,
                                              ),
                                              Container(
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
                                                            5),
                                                    color: CupertinoColors
                                                        .lightBackgroundGray),
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: TitleText('Upload Video',
                                                    // color: Colors.white,
                                                    // fontSize: 16,
                                                    // fontWeight: FontWeight.w800,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 180,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  color: Pallete.scafoldBacgroundColor),
                              child: Column(
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
                                        borderRadius: BorderRadius.circular(5),
                                        color: CupertinoColors.systemYellow),
                                    padding: const EdgeInsets.all(5.0),
                                    child: TitleText('Your Orders:',
                                        // color: Colors.white,
                                        // fontSize: 16,
                                        // fontWeight: FontWeight.w800,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  ref
                                      .watch(getUserOrdersProvider(
                                          '${currentUser.userId}'))
                                      .when(
                                        data: (myorders) => ListView(
                                          children: myorders.map((orders) {
                                            var vendor = ref
                                                .read(userDetailsProvider(
                                                    orders.sellerId!))
                                                .value;
                                            return DuctStatusView(
                                                isProfile: true,
                                                radius: Get.height * 0.05,
                                                numberOfStatus:
                                                    orders.items!.length,
                                                bucketId: AppwriteConstants
                                                    .productBucketId,
                                                centerImageUrl: vendor!
                                                    .profilePic
                                                    .toString());
                                          }).toList(),
                                        ),
                                        error: (error, stackTrace) => ErrorText(
                                          error: error.toString(),
                                        ),
                                        loading: () => LoaderAll(),
                                      ),
                                ],
                              ),
                            )
                          ],
                        )),
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Lottie.asset('assets/lottie/discount.json',
                          width: 100, height: 100),
                    ),
                    Positioned(
                      top: -10,
                      right: 100,
                      child: Container(
                        width: 60,
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
                        child: TitleText('Ducts',
                            // color: Colors.white,
                            // fontSize: 16,
                            // fontWeight: FontWeight.w800,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    // Positioned(
                    //     top: 50,
                    //     right: 10,
                    //     child: Container(
                    //         padding: EdgeInsets.all(11),
                    //         height: 100,
                    //         width: 100,
                    //         decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.circular(5)),
                    //         child: Image(
                    //           image: NetworkImage(currentUser.profilePic!),
                    //           fit: BoxFit.cover,
                    //         )))
                  ],
                ),
                dx: -1,
                dy: 0,
                horizontal: 16,
                vertical: 0.2);
          });

          // kIsWeb
          //     ? _showDialog()
          //     : Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => CompoaseDuctsPageResponsive(
          //               isRetweet: false, isTweet: true),
          //         ));
        },
        child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 25,
            child: Image.asset(
              'assets/plus.png',
            )));
  }
}

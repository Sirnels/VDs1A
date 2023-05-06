// ignore_for_file: invalid_use_of_protected_member, file_names, void_checks, unnecessary_null_comparison, unused_element

import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart' as fireStore;
import 'package:animations/animations.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/appwrite.dart' as query;
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:loading_indicator/loading_indicator.dart';
//import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:viewducts/admin/screens/video_admin_upload.dart';
import 'package:viewducts/common/common.dart';
import 'package:viewducts/common/duct_loading_page.dart';
import 'package:viewducts/common/ducts_stream_view.dart';
import 'package:viewducts/common/offline_message.dart';
import 'package:viewducts/common/user_avatar.dart';
import 'package:viewducts/constants/constants.dart';
import 'package:viewducts/features/auth/controller/auth_controller.dart';
import 'package:viewducts/features/ducts/duct_controller.dart';
import 'package:viewducts/features/products/product_controller.dart';
import 'package:viewducts/helper/enum.dart';
import 'package:viewducts/helper/theme.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/chatModel.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/page/message/item_Search_bar.dart';
import 'package:viewducts/page/message/local_database.dart';
import 'package:viewducts/page/responsive.dart';
import 'package:viewducts/page/responsiveView.dart';
import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/cartIcon.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/duct/duct.dart';
import 'package:viewducts/widgets/duct/widgets/ductBottomSheet.dart';
import 'package:viewducts/widgets/frosted.dart';
import 'package:viewducts/widgets/newWidget/emptyList.dart';
import 'package:viewducts/widgets/newWidget/title_text.dart';
import 'package:viewducts/widgets/postProductMenu.dart';

class FeedPage extends ConsumerWidget {
  final bool isDesktop;
  final bool isTablet;
  final bool desk2;
  final bool shop;
  final bool? isDeskLeft;
  FeedPage(
      {Key? key,
      this.feedPagKey,
      this.refreshIndicatorKey,
      this.isDesktop = false,
      this.isTablet = false,
      this.isDeskLeft = false,
      this.shop = false,
      this.desk2 = false})
      : super(key: key);

  final GlobalKey<ScaffoldState>? feedPagKey;

  final GlobalKey<RefreshIndicatorState>? refreshIndicatorKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    final _textEditingController = TextEditingController();
    // Rx<Bible> bible = Bible().obs;
    // Rx<KeyViewducts> keysView = KeyViewducts().obs;
    // final animationController = useAnimationController(
    //   duration: Duration(milliseconds: 700),
    // );

    // void _bibleTips(BuildContext context) {
    //   showBarModalBottomSheet(
    //       backgroundColor: Colors.red,
    //       bounce: true,
    //       context: context,
    //       builder: (context) => Scaffold(
    //             backgroundColor: CupertinoColors.darkBackgroundGray,
    //             body: SafeArea(
    //                 child: Responsive(
    //               mobile: Obx(
    //                 () => Stack(
    //                   children: <Widget>[
    //                     Container(
    //                       decoration: BoxDecoration(
    //                           boxShadow: [
    //                             BoxShadow(
    //                                 offset: const Offset(0, 11),
    //                                 blurRadius: 11,
    //                                 color: Colors.black.withOpacity(0.06))
    //                           ],
    //                           borderRadius: BorderRadius.circular(18),
    //                           color: CupertinoColors.darkBackgroundGray),
    //                       padding: const EdgeInsets.all(5.0),
    //                       child: Column(
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         mainAxisAlignment: MainAxisAlignment.start,
    //                         children: [
    //                           Padding(
    //                             padding: const EdgeInsets.all(8.0),
    //                             child: Wrap(
    //                               children: [
    //                                 Container(
    //                                   decoration: BoxDecoration(
    //                                       boxShadow: [
    //                                         BoxShadow(
    //                                             offset: const Offset(0, 11),
    //                                             blurRadius: 11,
    //                                             color: Colors.black
    //                                                 .withOpacity(0.06))
    //                                       ],
    //                                       borderRadius:
    //                                           BorderRadius.circular(18),
    //                                       color: CupertinoColors.systemYellow),
    //                                   padding: const EdgeInsets.all(5.0),
    //                                   child: Text(
    //                                     'Theme:',
    //                                     style: TextStyle(
    //                                         color: CupertinoColors
    //                                             .darkBackgroundGray),
    //                                   ),
    //                                 ),
    //                                 Padding(
    //                                   padding: const EdgeInsets.all(8.0),
    //                                   child: Text(
    //                                     '${bible.value.theme}',
    //                                     style: TextStyle(
    //                                         color: CupertinoColors
    //                                             .lightBackgroundGray),
    //                                   ),
    //                                 ),
    //                               ],
    //                             ),
    //                           ),
    //                           Padding(
    //                             padding: const EdgeInsets.all(8.0),
    //                             child: Wrap(
    //                               children: [
    //                                 Container(
    //                                   decoration: BoxDecoration(
    //                                       boxShadow: [
    //                                         BoxShadow(
    //                                             offset: const Offset(0, 11),
    //                                             blurRadius: 11,
    //                                             color: Colors.black
    //                                                 .withOpacity(0.06))
    //                                       ],
    //                                       borderRadius:
    //                                           BorderRadius.circular(18),
    //                                       color: CupertinoColors.systemYellow),
    //                                   padding: const EdgeInsets.all(5.0),
    //                                   child: Text(
    //                                     'Topic:',
    //                                     style: TextStyle(
    //                                         color: CupertinoColors
    //                                             .darkBackgroundGray),
    //                                   ),
    //                                 ),
    //                                 Padding(
    //                                   padding: const EdgeInsets.all(8.0),
    //                                   child: Text(
    //                                     '${bible.value.topic}',
    //                                     style: TextStyle(
    //                                         color: CupertinoColors
    //                                             .lightBackgroundGray),
    //                                   ),
    //                                 ),
    //                               ],
    //                             ),
    //                           ),
    //                           Padding(
    //                             padding: const EdgeInsets.all(8.0),
    //                             child: Wrap(
    //                               children: [
    //                                 Container(
    //                                   decoration: BoxDecoration(
    //                                       boxShadow: [
    //                                         BoxShadow(
    //                                             offset: const Offset(0, 11),
    //                                             blurRadius: 11,
    //                                             color: Colors.black
    //                                                 .withOpacity(0.06))
    //                                       ],
    //                                       borderRadius:
    //                                           BorderRadius.circular(18),
    //                                       color: CupertinoColors.systemYellow),
    //                                   padding: const EdgeInsets.all(5.0),
    //                                   child: Text(
    //                                     'Bible Verse:',
    //                                     style: TextStyle(
    //                                         color: CupertinoColors
    //                                             .darkBackgroundGray),
    //                                   ),
    //                                 ),
    //                                 Padding(
    //                                   padding: const EdgeInsets.all(8.0),
    //                                   child: Text(
    //                                     '${bible.value.text}',
    //                                     style: TextStyle(
    //                                         color: CupertinoColors
    //                                             .lightBackgroundGray),
    //                                   ),
    //                                 ),
    //                               ],
    //                             ),
    //                           ),
    //                           bible.value.videoPath == null
    //                               ? Container()
    //                               : const Divider(
    //                                   color: CupertinoColors.systemYellow,
    //                                 ),
    //                           bible.value.videoPath == null
    //                               ? Container()
    //                               : Wrap(
    //                                   children: [
    //                                     Hero(
    //                                       tag: bible.value.videoPath.toString(),
    //                                       child: Center(
    //                                         child: frostedWhite(
    //                                           Container(
    //                                             decoration: BoxDecoration(
    //                                               boxShadow: [
    //                                                 BoxShadow(
    //                                                     offset:
    //                                                         const Offset(0, 11),
    //                                                     blurRadius: 11,
    //                                                     color: Colors.black
    //                                                         .withOpacity(0.06))
    //                                               ],
    //                                               borderRadius:
    //                                                   BorderRadius.circular(18),
    //                                             ),
    //                                             padding:
    //                                                 const EdgeInsets.all(5.0),
    //                                             width: MediaQuery.of(context)
    //                                                     .size
    //                                                     .height *
    //                                                 0.4,
    //                                             height: MediaQuery.of(context)
    //                                                     .size
    //                                                     .height *
    //                                                 0.25,
    //                                             child: Stack(
    //                                               children: [
    //                                                 VideoUploadAdmin(
    //                                                   isBible: true,

    //                                                   // playNow: true,
    //                                                   videoFile: File(bible
    //                                                       .value.videoPath
    //                                                       .toString()),
    //                                                   videoPath: bible
    //                                                       .value.videoPath
    //                                                       .toString(),
    //                                                 ),
    //                                               ],
    //                                             ),
    //                                           ),
    //                                         ),
    //                                       ),
    //                                     ),
    //                                   ],
    //                                 ),
    //                           const Divider(
    //                             color: CupertinoColors.systemYellow,
    //                           ),
    //                           Padding(
    //                             padding: const EdgeInsets.all(8.0),
    //                             child: Wrap(
    //                               children: [
    //                                 Linkify(
    //                                   onOpen: (link) async {
    //                                     if (await canLaunchUrl(
    //                                         Uri.parse(link.url))) {
    //                                       await launchURL(link.url);
    //                                     } else {
    //                                       throw 'Could not launch $link';
    //                                     }
    //                                   },
    //                                   text: bible.value.body.toString(),
    //                                   style: TextStyle(
    //                                       color: CupertinoColors.systemYellow),
    //                                   linkStyle: onPrimarySubTitleText.copyWith(
    //                                       color: Colors.white),
    //                                 ),
    //                               ],
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     )
    //                   ],
    //                 ),
    //               ),
    //               tablet: Stack(
    //                 children: [
    //                   Row(
    //                     children: [
    //                       Expanded(
    //                         child: Stack(
    //                           children: <Widget>[],
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ],
    //               ),
    //               desktop: Stack(
    //                 children: [
    //                   BackdropFilter(
    //                     filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
    //                     child: Container(
    //                       color: (Colors.white12).withOpacity(0.1),
    //                     ),
    //                   ),
    //                   Row(
    //                     children: [
    //                       // Once our width is less then 1300 then it start showing errors
    //                       // Now there is no error if our width is less then 1340

    //                       Expanded(
    //                         flex: Get.width > 1340 ? 3 : 5,
    //                         child: PlainScaffold(),
    //                       ),
    //                       Expanded(
    //                         flex: Get.width > 1340 ? 8 : 10,
    //                         child: Stack(
    //                           children: <Widget>[],
    //                         ),
    //                       ),
    //                       Expanded(
    //                         flex: Get.width > 1340 ? 2 : 4,
    //                         child: PlainScaffold(),
    //                       ),
    //                     ],
    //                   ),
    //                 ],
    //               ),
    //             )),
    //           ));
    // }

    // getData() async {
    //   try {
    //     final database = Databases(
    //       clientConnect(),
    //     );

    //     await database
    //         .getDocument(
    //             databaseId: databaseId,
    //             collectionId: 'keyViewducts',
    //             documentId: 'keysViewKeys')
    //         .then((doc) {
    //       keysView.value = KeyViewducts.fromSnapshot(doc.data);
    //     });
    //     await database
    //         .getDocument(
    //             databaseId: databaseId,
    //             collectionId: 'clipsBible',
    //             documentId: keysView.value.viewductKey.toString())
    //         .then((doc) {
    //       bible.value = Bible.fromSnapshot(doc.data);
    //     });
    //     //snap.documents;
    //   } on AppwriteException catch (e) {
    //     cprint("$e Bible");
    //   }
    // }

    // useEffect(
    //   () {
    //     animationController.forward();
    //     getData();
    //     return () {};
    //   },
    //   [],
    // );

    return Scaffold(
        body: SafeArea(
            child: Stack(
      children: [
        SizedBox(
          height: fullHeight(context),
          width: context.responsiveValue(
              mobile: Get.width, tablet: Get.width, desktop: Get.width),
          child: _FeedPageBody(
            refreshIndicatorKey: refreshIndicatorKey,
            feedPagKey: feedPagKey,
            isDesktop: isDesktop,
            isTablet: isTablet,
            isDeskLeft: isDeskLeft,
          ),
        ),
        Positioned(
          bottom: 35,
          right: 10,
          child: Material(
            elevation: 20,
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            child: Wrap(
              children: [
                GestureDetector(
                  onTap: () {
                    // Get.to(
                    //   () => CompoaseDuctsPageResponsive(
                    //       isRetweet: false, isTweet: true),
                    // );
                  },
                  child: Padding(
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
                        child: TitleText('Duct Now')),
                  ),
                ),
                frostedOrange(
                  Stack(
                    children: [
                      OpenContainer(
                        closedColor: Color.fromARGB(255, 246, 182, 8),
                        openColor: Color.fromARGB(255, 246, 182, 8),
                        closedBuilder: (context, action) {
                          return PostProductMenu(
                            currentUser: currentUser ?? ViewductsUser(),
                          );
                        },
                        openBuilder: (context, action) {
                          return PostProductMenu(
                            currentUser: currentUser ?? ViewductsUser(),
                          );
                        },
                      ),
                      // const Icon(CupertinoIcons.add_circled_solid,
                      //     color: CupertinoColors.darkBackgroundGray),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        isDesktop == true || isTablet == true
            ? Container()
            : Positioned(
                top: 10,
                // left: appSize.width * 0.7,
                right: fullWidth(context) * 0.4,
                child: Row(
                  children: const <Widget>[AdminNotificationForUsers()],
                ),
              ),
        isDesktop == true || isTablet == true
            ? Container()
            : Positioned(
                top: 10,
                right: 10,
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
                    child: UserAvater(
                      userModel: currentUser ?? ViewductsUser(),
                      profileType: ProfileType.Store,
                    )),
              ),
        shop == true
            ? Container()
            : desk2 == true
                ? Container()
                : Positioned(
                    top: 20,
                    left: 10,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: frostedOrange(
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
                                      child:
                                          Image.asset('assets/delicious.png'),
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
                        ),
                        Container(
                          width: 50,
                          height: 50,
                          child: CartIcon(
                            sellerId: currentUser?.userId,
                            allProduct: true,
                            currentUser: currentUser,
                          ),
                        ),
                        // ref
                        //     .watch(getProductInCartProvider(
                        //         '${currentUser?.userId!}'))
                        //     .when(
                        //       data: (cart) {
                        //         return cart.isEmpty
                        //             ? Container()
                        //             : GestureDetector(
                        //                 onTap: () {
                        //                   Navigator.push(
                        //                       context,
                        //                       MaterialPageRoute(
                        //                           builder: (context) =>
                        //                               OpenContainer(
                        //                                 closedBuilder:
                        //                                     (context, action) {
                        //                                   return ChatlistPageResponsive(
                        //                                     isCart: true,
                        //                                   );
                        //                                 },
                        //                                 openBuilder:
                        //                                     (context, action) {
                        //                                   return ChatlistPageResponsive(
                        //                                     isCart: true,
                        //                                   );
                        //                                 },
                        //                               )));

                        //                   // appState.pageIndex == 0;
                        //                   // Navigator.pop(context);
                        //                   // appState.pageIndex == 0;
                        //                 },
                        //                 child: Container(
                        //                     child: cart.isEmpty ||
                        //                             cart == null ||
                        //                             cart.length == 0
                        //                         //  ? userCartController.orders.isEmpty
                        //                         ? Container()
                        //                         : Container(
                        //                             width: 50,
                        //                             height: 50,
                        //                             decoration: BoxDecoration(
                        //                                 boxShadow: [
                        //                                   BoxShadow(
                        //                                       offset:
                        //                                           const Offset(
                        //                                               0, 11),
                        //                                       blurRadius: 11,
                        //                                       color: Colors
                        //                                           .black
                        //                                           .withOpacity(
                        //                                               0.06))
                        //                                 ],
                        //                                 borderRadius:
                        //                                     BorderRadius
                        //                                         .circular(100),
                        //                                 color: CupertinoColors
                        //                                     .lightBackgroundGray),
                        //                             padding:
                        //                                 const EdgeInsets.all(
                        //                                     5.0),
                        //                             child: Padding(
                        //                               padding:
                        //                                   const EdgeInsets.all(
                        //                                       8.0),
                        //                               child: Badge(
                        //                                 backgroundColor:
                        //                                     CupertinoColors
                        //                                         .systemOrange,
                        //                                 label: Text(
                        //                                   cart.isEmpty ||
                        //                                           cart.length ==
                        //                                               0 ||
                        //                                           cart == null
                        //                                       ? ''
                        //                                       : cart.length
                        //                                           .toString(),
                        //                                   style: TextStyle(
                        //                                     color: Colors.white,
                        //                                     fontSize: context.responsiveValue(
                        //                                         mobile:
                        //                                             Get.height *
                        //                                                 0.015,
                        //                                         tablet:
                        //                                             Get.height *
                        //                                                 0.02,
                        //                                         desktop:
                        //                                             Get.height *
                        //                                                 0.02),
                        //                                   ),
                        //                                 ),
                        //                                 child: Image.asset(
                        //                                   'assets/carts.png',
                        //                                   width: 50,
                        //                                 ),
                        //                               ),
                        //                             ),
                        //                           )
                        //                     // }
                        //                     // ),

                        //                     ),
                        //               );
                        //       },
                        //       error: (error, stackTrace) => Container(),
                        //       loading: () => Container(),
                        //     )
                      ],
                    ),
                  ),
        // Positioned(
        //     bottom: 0,
        //     left: 10,
        //     right: 100,
        //     child: bible.value.body == null
        //         ? Container()
        //         : GestureDetector(
        //             onTap: () {
        //               _bibleTips(context);
        //             },
        //             child: Container(
        //               decoration: BoxDecoration(
        //                   color: darkBackground,
        //                   borderRadius: BorderRadius.circular(10)),
        //               width: context.responsiveValue(
        //                   mobile: Get.height * 0.35,
        //                   tablet: Get.height * 0.45,
        //                   desktop: Get.height * 0.45),
        //               child: SingleChildScrollView(
        //                   scrollDirection: Axis.horizontal,
        //                   child: Wrap(
        //                     children: [
        //                       Container(
        //                         decoration: BoxDecoration(
        //                             boxShadow: [
        //                               BoxShadow(
        //                                   offset: const Offset(0, 11),
        //                                   blurRadius: 11,
        //                                   color: Colors.black.withOpacity(0.06))
        //                             ],
        //                             borderRadius: BorderRadius.circular(5),
        //                             color: CupertinoColors.systemYellow),
        //                         padding: const EdgeInsets.all(5.0),
        //                         child: Text(
        //                           'Bible:',
        //                           style: TextStyle(
        //                               color:
        //                                   CupertinoColors.darkBackgroundGray),
        //                         ),
        //                       ),
        //                       Padding(
        //                         padding: const EdgeInsets.all(8.0),
        //                         child: Text(
        //                             '${getLastMessage(bible.value.body)}',
        //                             style: TextStyle(
        //                                 color: darkAccent,
        //                                 fontSize: context.responsiveValue(
        //                                     mobile: Get.height * 0.025,
        //                                     tablet: Get.height * 0.025,
        //                                     desktop: Get.height * 0.025),
        //                                 fontWeight: FontWeight.w100)),
        //                       ),
        //                     ],
        //                   )),
        //             ),
        //           )))
      ],
    )));
  }
}

// ignore: must_be_immutable
class _FeedPageBody extends ConsumerWidget {
  final GlobalKey<ScaffoldState>? feedPagKey;
  final bool? showCheckBox;
  final bool? isDeskLeft;
  bool isDesktop;
  bool isTablet;
  ValueNotifier<bool>? visibleSwitch = ValueNotifier(false);
  ValueNotifier<bool> productsOnSales = ValueNotifier(false);
  ValueNotifier<bool> trendingProducts = ValueNotifier(false);
  ValueNotifier<bool> topDucts = ValueNotifier(false);

  final GlobalKey<RefreshIndicatorState>? refreshIndicatorKey;

  _FeedPageBody({
    Key? key,
    this.feedPagKey,
    this.refreshIndicatorKey,
    this.isDeskLeft = true,
    this.showCheckBox,
    this.visibleSwitch,
    this.isDesktop = false,
    this.isTablet = false,
  }) : super(key: key);

  bool closeCircle = false;
  double topDuct = 0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // RxString start = 'starting'.obs;
    // final networkConnect = useState(start);
    // String? lastId;
    // final animationController = useAnimationController(
    //   duration: Duration(milliseconds: 600),
    // );
    // final _controller = useScrollController();
    // // final feedListSetState = useState(feedState.feedlist);
    // final productSetState = useState(feedState.feedListProductlist);
    // final mainUserViersState = useState(feedState.mainUserViers);
    // final storyState = useState(feedState.storylist);
    // final realtime = Realtime(clientConnect());
    // final subscriptionPro = useStream(realtime.subscribe(
    //     ["databases.$databaseId.collections.$procold.documents"]).stream);
    // final ductListStream = useStream(realtime.subscribe(
    //     ["databases.$databaseId.collections.$dctCollid.documents"]).stream);
    // final storyStream = useStream(realtime.subscribe(
    //     ["databases.$databaseId.collections.$storyCollId.documents"]).stream);
    // RxList<DuctStoryModel> storylisting = RxList<DuctStoryModel>([]);
    // final storylist = useState(storylisting);
    // getData({String? pageIndex}) async {
    //   try {
    //     final database = Databases(
    //       clientConnect(),
    //     );

    //     feedState.localDucts!.value = await SQLHelper.findLocalDucts(
    //         authState.userModel!.userId.toString());
    //     await database.listDocuments(
    //         databaseId: databaseId,
    //         collectionId: storyCollId,
    //         queries: [
    //           query.Query.equal('userId', authState.userModel?.key),
    //           //   query.Query.greaterThanEqual('date', time)
    //         ]).then((data) {
    //       // Map map = data.toMap();

    //       var value = data.documents
    //           .map((e) => DuctStoryModel.fromMap(e.data))
    //           .toList();
    //       //data.documents;
    //       storylist.value.value = value.where((storyData) {
    //         if (DateTime.now()
    //                 .toUtc()
    //                 .difference(DateTime.parse(storyData.createdAt.toString()))
    //                 .inHours <
    //             24) {
    //           return true;
    //         } else {
    //           return false;
    //         }
    //       }).toList();
    //       // cprint('${data.documents.map((e) => FeedModel.fromJson(e.data))}');
    //       //cprint('${feedState.feedlist?.value.map((e) => e.key)}');
    //     });
    //     if (pageIndex == 'top') {
    //       await database.listDocuments(
    //           databaseId: databaseId,
    //           collectionId: mainUserViews,
    //           queries: [
    //             query.Query.orderDesc('createdAt'),
    //             query.Query.limit(10),
    //             query.Query.equal('viewerId', authState.appUser!.$id),
    //           ]).then((data) {
    //         var value = data.documents
    //             .map((e) => MainUserViewsModel.fromJson(e.data))
    //             .toList();
    //         mainUserViersState.value.value = value;
    //       });

    //       await database.listDocuments(
    //           databaseId: databaseId,
    //           collectionId: dctCollid,
    //           queries: [
    //             query.Query.orderDesc('createdAt'),
    //             query.Query.limit(10),
    //             query.Query.cursorAfter(lastId.toString()),
    //             query.Query.equal(
    //                 'userId',
    //                 mainUserViersState.value.value
    //                     .map((data) => data.viewductUser)
    //                     .toList()),
    //           ]).then((data) {
    //         var value =
    //             data.documents.map((e) => FeedModel.fromJson(e.data)).toList();

    //         feedState.feedlist = value
    //             .where((feedData) {
    //               if (DateTime.now()
    //                       .toUtc()
    //                       .difference(
    //                           DateTime.parse(feedData.createdAt.toString()))
    //                       .inHours <
    //                   23) {
    //                 return true;
    //               } else {
    //                 return false;
    //               }
    //             })
    //             .toList()
    //             .obs;
    //         lastId = data.documents.last.$id;
    //       });
    //       await database.listDocuments(
    //           databaseId: databaseId,
    //           collectionId: procold,
    //           queries: [
    //             query.Query.equal('key',
    //                 feedState.feedlist!.map((data) => data.cProduct).toList())
    //           ]).then((data) {
    //         productSetState.value!.value =
    //             data.documents.map((e) => FeedModel.fromJson(e.data)).toList();
    //       });
    //     } else if (pageIndex == 'bottom') {
    //       await database.listDocuments(
    //           databaseId: databaseId,
    //           collectionId: mainUserViews,
    //           queries: [
    //             query.Query.orderDesc('createdAt'),
    //             query.Query.limit(10),
    //             query.Query.equal('viewerId', authState.appUser!.$id),
    //           ]).then((data) {
    //         var value = data.documents
    //             .map((e) => MainUserViewsModel.fromJson(e.data))
    //             .toList();
    //         mainUserViersState.value.value = value;
    //       });

    //       await database.listDocuments(
    //           databaseId: databaseId,
    //           collectionId: dctCollid,
    //           queries: [
    //             query.Query.orderDesc('createdAt'),
    //             query.Query.limit(10),
    //             query.Query.cursorAfter(lastId.toString()),
    //             query.Query.equal(
    //                 'userId',
    //                 mainUserViersState.value.value
    //                     .map((data) => data.viewductUser)
    //                     .toList())
    //           ]).then((data) {
    //         var value =
    //             data.documents.map((e) => FeedModel.fromJson(e.data)).toList();

    //         feedState.feedlist = value
    //             .where((feedData) {
    //               if (
    //                   // mainUserViersState.value
    //                   //       .where((data) => data.viewductUser == feedData.key)
    //                   //       .isNotEmpty &&
    //                   DateTime.now()
    //                           .toUtc()
    //                           .difference(
    //                               DateTime.parse(feedData.createdAt.toString()))
    //                           .inHours <
    //                       24) {
    //                 return true;
    //               } else {
    //                 return false;
    //               }
    //             })
    //             .toList()
    //             .obs;
    //         lastId = data.documents.last.$id;
    //       });
    //       await database.listDocuments(
    //           databaseId: databaseId,
    //           collectionId: procold,
    //           queries: [
    //             query.Query.equal('key',
    //                 feedState.feedlist!.map((data) => data.cProduct).toList())
    //           ]).then((data) {
    //         productSetState.value!.value =
    //             data.documents.map((e) => FeedModel.fromJson(e.data)).toList();
    //       });
    //     } else {
    //       await database.listDocuments(
    //           databaseId: databaseId,
    //           collectionId: mainUserViews,
    //           queries: [
    //             query.Query.orderDesc('createdAt'),
    //             query.Query.limit(10),
    //             query.Query.equal('viewerId', authState.appUser!.$id),
    //           ]).then((data) {
    //         var value = data.documents
    //             .map((e) => MainUserViewsModel.fromJson(e.data))
    //             .toList();
    //         mainUserViersState.value.value = value;
    //       });

    //       await database.listDocuments(
    //           databaseId: databaseId,
    //           collectionId: dctCollid,
    //           queries: [
    //             query.Query.orderDesc('createdAt'),
    //             query.Query.limit(10),
    //             query.Query.equal(
    //                 'userId',
    //                 mainUserViersState.value.value
    //                     .map((data) => data.viewductUser)
    //                     .toList())
    //           ]).then((data) {
    //         var value =
    //             data.documents.map((e) => FeedModel.fromJson(e.data)).toList();
    //         feedState.feedlist = value
    //             .where((feedData) {
    //               if (
    //                   // mainUserViersState.value
    //                   //       .where((data) => data.viewductUser == feedData.key)
    //                   //       .isNotEmpty &&
    //                   DateTime.now()
    //                           .toUtc()
    //                           .difference(
    //                               DateTime.parse(feedData.createdAt.toString()))
    //                           .inHours <
    //                       24) {
    //                 return true;
    //               } else {
    //                 return false;
    //               }
    //             })
    //             .toList()
    //             .obs;
    //       });
    //       await database.listDocuments(
    //           databaseId: databaseId,
    //           collectionId: procold,
    //           queries: [
    //             query.Query.equal('key',
    //                 feedState.feedlist!.map((data) => data.cProduct).toList())
    //           ]).then((data) {
    //         productSetState.value!.value =
    //             data.documents.map((e) => FeedModel.fromJson(e.data)).toList();
    //       });
    //     }
    //     //snap.documents;
    //     await database.listDocuments(
    //         databaseId: databaseId,
    //         collectionId: profileUserColl,
    //         queries: [
    //           Query.equal('key',
    //               feedState.feedlist!.map((data) => data.userId).toList())
    //         ]
    //         //  queries: [query.Query.equal('key', ductId)]
    //         ).then((data) {
    //       if (data.documents.isNotEmpty) {
    //         var value = data.documents
    //             .map((e) => ViewductsUser.fromJson(e.data))
    //             .toList();

    //         searchState.viewUserlist.value = value;
    //         chatState.chatUser ==
    //             value
    //                 .firstWhere((data) => data.key == authState.appUser?.$id,
    //                     orElse: () => ViewductsUser())
    //                 .obs;
    //       }
    //     });
    //   } on AppwriteException catch (e) {
    //     cprint("$e");
    //   }
    // }

    // subs() {
    //   ductListStream.data;
    //   if (feedState.feedlist != null) {
    //     switch (ductListStream.data?.events) {
    //       case ["collections.*.documents"]:
    //         // setState(() {});
    //         feedState.feedlist!
    //             .add(FeedModel.fromJson(ductListStream.data?.payload));

    //         break;
    //       case ["collections.*.documents.*.delete"]:
    //         // setState(() {});
    //         feedState.feedlist!.removeWhere(
    //             (datas) => datas.key == ductListStream.data!.payload['key']);

    //         break;

    //       default:
    //         break;
    //     }
    //   } else {}
    // }

    // storySubs() {
    //   storyStream.data;
    //   if (storyState.value.value != null) {
    //     switch (storyStream.data?.events) {
    //       case ["collections.*.documents"]:
    //         // setState(() {});
    //         storyState.value.value
    //             .add(DuctStoryModel.fromMap(storyStream.data?.payload));

    //         break;
    //       case ["collections.*.documents.*.delete"]:
    //         // setState(() {});
    //         storyState.value.value.removeWhere(
    //             (datas) => datas.key == storyStream.data!.payload['key']);

    //         break;

    //       default:
    //         break;
    //     }
    //   } else {}
    // }

    // productSubs() {
    //   subscriptionPro.data;
    //   if (productSetState.value!.value != null) {
    //     switch (subscriptionPro.data?.events) {
    //       case ["collections.*.documents"]:
    //         // setState(() {});
    //         productSetState.value!.value
    //             .add(FeedModel.fromJson(subscriptionPro.data?.payload));

    //         break;
    //       case ["collections.*.documents.*.delete"]:
    //         // setState(() {});
    //         productSetState.value!.value.removeWhere(
    //             (datas) => datas.key == subscriptionPro.data!.payload['key']);

    //         break;

    //       default:
    //         break;
    //     }
    //   } else {}
    // }

    // final networkStreaming = kIsWeb
    //     ? useState('')
    //     : useMemoized(
    //         () => DataConnectionChecker().onStatusChange.listen((status) {
    //               switch (status) {
    //                 case DataConnectionStatus.connected:
    //                   networkConnect.value.value = 'Connected';
    //                   authState.networkConnectionState.value = 'Connected';
    //                   break;
    //                 case DataConnectionStatus.disconnected:
    //                   networkConnect.value.value = 'Not Connected';
    //                   authState.networkConnectionState.value = 'Not Connected';
    //                   break;
    //               }
    //             }));
    // final subStreaming = useMemoized(() => subs());
    // final productStreaming = useMemoized(() => productSubs());
    // final storyStreaming = useMemoized(() => storySubs());
    // useEffect(
    //   () {
    //     animationController.forward();
    //     networkStreaming;
    //     // loading.value = true;
    //     getData();
    //     subStreaming;
    //     productStreaming;

    //     storyStreaming;
    //     return () {};
    //   },
    //   [
    //     feedState.feedlist,
    //     feedState.feedListProductlist,
    //     feedState.storylist,
    //     start,
    //     feedState.mainUserViers,
    //     networkStreaming
    //   ],
    // );
    // //getStory();
    // //getData();
    // // var authState = Provider.of<AuthState>(context, listen: false);
    var appSize = MediaQuery.of(context).size;

    // // final List<FeedModel>? list = feedState.getDuctList(authState.userModel);

    return Stack(
      fit: StackFit.expand,
      children: [
        // ThemeMode.system == ThemeMode.light
        //     ? frostedYellow(
        //         Container(
        //           height: appSize.height,
        //           width: appSize.width,
        //           decoration: BoxDecoration(
        //             // borderRadius: BorderRadius.circular(100),
        //             //color: Colors.blueGrey[50]
        //             gradient: LinearGradient(
        //               colors: [
        //                 Colors.yellow[100]!.withOpacity(0.3),
        //                 Colors.yellow[200]!.withOpacity(0.1),
        //                 Colors.yellowAccent[100]!.withOpacity(0.2)
        //                 // Color(0xfffbfbfb),
        //                 // Color(0xfff7f7f7),
        //               ],
        //               begin: Alignment.topCenter,
        //               end: Alignment.bottomCenter,
        //             ),
        //           ),
        //         ),
        //       )
        //     : Container(),
        // Container(
        //   height: fullHeight(context),
        //   width: fullWidth(context),
        //   decoration: const BoxDecoration(
        //       image: DecorationImage(image: AssetImage('assets/africa.png'))),
        // ),
        // BackdropFilter(
        //   filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        //   child: Container(
        //     color: (Colors.white12).withOpacity(0.1),
        //   ),
        // ),

        // Obx(
        //   () =>
        //    networkConnect.value.value == 'Not Connected'
        //       ? Center(
        //           child: SizedBox(
        //           width: Get.height * 0.2,
        //           height: Get.height * 0.2,
        //           child: LoadingIndicator(
        //               indicatorType: Indicator.ballTrianglePath,

        //               /// Required, The loading type of the widget
        //               colors: const [
        //                 Colors.pink,
        //                 Colors.green,
        //                 Colors.blue
        //               ],

        //               /// Optional, The color collections
        //               strokeWidth: 0.5,

        //               /// Optional, The stroke of the line, only applicable to widget which contains line
        //               backgroundColor: Colors.transparent,

        //               /// Optional, Background of the widget
        //               pathBackgroundColor: Colors.blue

        //               /// Optional, the stroke backgroundColor
        //               ),
        //         )
        //           //  CircularProgressIndicator
        //           //     .adaptive()
        //           )
        //       : feedState.feedlist?.value == null ||
        //               feedState.feedlist!.isEmpty
        //           ? Center(
        //               child: Align(
        //                 alignment: Alignment.center,
        //                 child: SingleChildScrollView(
        //                   scrollDirection: Axis.vertical,
        //                   child: frostedWhite(
        //                     SizedBox(
        //                       width: Get.height * 0.4,
        //                       height: Get.height * 0.2,
        //                       child: const EmptyList(
        //                         'Chai!! No Ducts Yet ',
        //                         subTitle:
        //                             'Start Ducting by pressing the button at bottom right!',
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             )
        //           : FractionallySizedBox(
        //               heightFactor: feedState.localDucts!.isEmpty ||
        //                       feedState.localDucts == null ||
        //                       kIsWeb
        //                   ? 1 - 0.185
        //                   : 1 - 0.3,
        //               alignment: Alignment.bottomCenter,
        //               child: SizedBox(
        //                 width: isDeskLeft == true
        //                     ? context.responsiveValue(
        //                         mobile: Get.width * 0.8,
        //                         tablet: Get.width * 0.3,
        //                         desktop: Get.width * 0.15)
        //                     : context.responsiveValue(
        //                         mobile: Get.width * 0.4,
        //                         tablet: Get.width * 0.4,
        //                         desktop: Get.width * 0.4),
        //                 child: Obx(
        //                   () => SizedBox(
        //                     width: context.responsiveValue(
        //                         mobile: Get.height * 0.4,
        //                         tablet: Get.height * 0.4,
        //                         desktop: Get.height * 0.4),
        //                     child:
        //                         NotificationListener<ScrollEndNotification>(
        //                       child: ListView(
        //                         children: feedState.feedlist!.map(
        //                           (model) {
        //                             return

        //                                 // model.createdAt !=
        //                                 //         DateFormat("E MMM d y")
        //                                 //             .format(Timestamp.now().toDate())
        //                                 //             .toString()
        //                                 //     ? const SizedBox()
        //                                 //     :
        //                                 Padding(
        //                               padding: const EdgeInsets.symmetric(
        //                                   vertical: 8.0),
        //                               child: model.key == null
        //                                   ? Container()
        //                                   : model.caption == 'product'
        //                                       ? Container()
        //                                       : model.userId ==
        //                                                   authState.appUser
        //                                                       ?.$id &&
        //                                               !kIsWeb
        //                                           ? Container()
        //                                           : SizedBox(
        //                                               width: context
        //                                                   .responsiveValue(
        //                                                       mobile:
        //                                                           Get.height *
        //                                                               0.4,
        //                                                       tablet:
        //                                                           Get.height *
        //                                                               0.4,
        //                                                       desktop:
        //                                                           Get.height *
        //                                                               0.4),
        //                                               child: Wrap(
        //                                                 children: [
        //                                                   Duct(
        //                                                     model: model,
        //                                                     commissionProduct:
        //                                                         productSetState
        //                                                             .value,
        //                                                     trailing:
        //                                                         DuctBottomSheet()
        //                                                             .ductOptionIcon(
        //                                                       context,
        //                                                       model,
        //                                                       DuctType.Duct,
        //                                                     ),
        //                                                     isDeskLeft:
        //                                                         isDesktop,
        //                                                     // storylist:
        //                                                     //     storyState.value
        //                                                   ),
        //                                                 ],
        //                                               ),
        //                                             ),
        //                             );
        //                           },
        //                         ).toList(),
        //                         controller: _controller,
        //                         physics: BouncingScrollPhysics(),
        //                         //reverse: true,
        //                         shrinkWrap: true,
        //                       ),
        //                       onNotification: (notification) {
        //                         // if (t is ScrollEndNotification) {
        //                         //  cprint(_controller.position.pixels.toString());
        //                         // cprint(_controller.position.minScrollExtent.toString());
        //                         if (notification.metrics.atEdge) {
        //                           if (notification.metrics.pixels == 0) {
        //                             getData(pageIndex: 'top');

        //                             // cprint(lastId.toString());
        //                           } else {
        //                             getData(pageIndex: 'bottom');
        //                           }
        //                         }
        //                         // }
        //                         //How many pixels scrolled from pervious frame
        //                         // print(t!.scrollDelta);

        //                         // //List scroll position
        //                         // print(t.metrics.pixels);
        //                         return true;
        //                       },
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ),
        // ),
        ref.watch(currentDuctListDetailsProvider).when(
              data: (ductList) {
                return ref.watch(getDuctStreamProvider).when(
                      data: (data) {
                        if (data.events.contains(
                          'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.dctCollid}.documents.*.create',
                        )) {
                          ductList.insert(0, FeedModel.fromJson(data.payload));
                        } else if (data.events.contains(
                          'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.dctCollid}.documents.*.update',
                        )) {
                          // get id of original duct
                          final startingPoint =
                              data.events[0].lastIndexOf('documents.');
                          final endPoint =
                              data.events[0].lastIndexOf('.update');
                          final ductId = data.events[0]
                              .substring(startingPoint + 10, endPoint);

                          var duct = ductList
                              .where((element) => element.key == ductId)
                              .first;

                          final ductIndex = ductList.indexOf(duct);
                          ductList
                              .removeWhere((element) => element.key == ductId);

                          duct = FeedModel.fromJson(data.payload);
                          ductList.insert(ductIndex, duct);
                        } else if (data.events.contains(
                          'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.dctCollid}.documents.*.delete',
                        )) {
                          ductList.remove(FeedModel.fromJson(data.payload));
                        }

                        return DuctStreamScreen(
                          ductList: ductList,
                          storyList: [],
                        );
                      },
                      error: (error, stackTrace) => OfflinePage(),
                      loading: () {
                        return DuctStreamScreen(
                          ductList: ductList,
                          storyList: [],
                        );
                      },
                    );
              },
              error: (error, stackTrace) => OfflinePage(),
              loading: () => const DuctLoadingPage(),
            ),

        // Positioned(
        //     left: 0,
        //     top: fullHeight(context) * 0.1,
        //     child: SizedBox(
        //         //height: 50,
        //         width: fullWidth(context) * 0.8,
        //         child: Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Row(
        //               children: [
        //                 Material(
        //                   borderRadius: BorderRadius.circular(20),
        //                   color: Colors.transparent,
        //                   child: Padding(
        //                       padding: const EdgeInsets.symmetric(
        //                           horizontal: 8.0, vertical: 3),
        //                       child: customText(
        //                         'Ducts',
        //                         style: const TextStyle(
        //                             //    color: Colors.black45,
        //                             fontSize: 35,
        //                             fontWeight: FontWeight.bold),
        //                       )),
        //                 ),
        //                 //  kIsWeb
        //                 //       ? Container()
        //                 //       : authState.networkConnectionState.value ==
        //                 //               'Not Connected'
        //                 //           ? Container(
        //                 //               decoration: BoxDecoration(
        //                 //                   color: darkBackground,
        //                 //                   borderRadius:
        //                 //                       BorderRadius.circular(10)),
        //                 //               width: context.responsiveValue(
        //                 //                   mobile: Get.height * 0.25,
        //                 //                   tablet: Get.height * 0.25,
        //                 //                   desktop: Get.height * 0.25),
        //                 //               child: SingleChildScrollView(
        //                 //                   child: Padding(
        //                 //                 padding: const EdgeInsets.all(3.0),
        //                 //                 child: Row(
        //                 //                   mainAxisAlignment:
        //                 //                       MainAxisAlignment.start,
        //                 //                   crossAxisAlignment:
        //                 //                       CrossAxisAlignment.start,
        //                 //                   children: [
        //                 //                     Icon(
        //                 //                         color: darkAccent,
        //                 //                         CupertinoIcons.wifi_slash),
        //                 //                     Padding(
        //                 //                       padding:
        //                 //                           const EdgeInsets.all(3.0),
        //                 //                       child: Text('You\'re Offline',
        //                 //                           style: TextStyle(
        //                 //                               color:
        //                 //                                   Colors.redAccent,
        //                 //                               fontSize: context
        //                 //                                   .responsiveValue(
        //                 //                                       mobile:
        //                 //                                           Get.height *
        //                 //                                               0.025,
        //                 //                                       tablet:
        //                 //                                           Get.height *
        //                 //                                               0.025,
        //                 //                                       desktop:
        //                 //                                           Get.height *
        //                 //                                               0.025),
        //                 //                               fontWeight:
        //                 //                                   FontWeight.w100)),
        //                 //                     ),
        //                 //                   ],
        //                 //                 ),
        //                 //               )),
        //                 //             )
        //                 //           : SizedBox(),
        //               ],
        //             ),
        //             // kIsWeb
        //             //     ? Container()
        //             //     : feedState.localDucts!.isEmpty ||
        //             //             feedState.localDucts == null
        //             //         ? Container()
        //             //         : Column(
        //             //             children:
        //             //                 feedState.localDucts!.where((feedData) {
        //             //             if (DateTime.now()
        //             //                     .toUtc()
        //             //                     .difference(DateTime.parse(
        //             //                         feedData.createdAt ??
        //             //                             fireStore.Timestamp.now()
        //             //                                 .toDate()
        //             //                                 .toString()))
        //             //                     .inHours <
        //             //                 23) {
        //             //               return true;
        //             //             } else {
        //             //               return false;
        //             //             }
        //             //           }).map((localData) {
        //             //             cprint(localData.imagePath.toString());
        //             //             return Container(
        //             //               width: Get.height * 0.5,
        //             //               decoration: BoxDecoration(
        //             //                   boxShadow: [
        //             //                     BoxShadow(
        //             //                         offset: const Offset(0, 11),
        //             //                         blurRadius: 11,
        //             //                         color: Colors.black
        //             //                             .withOpacity(0.06))
        //             //                   ],
        //             //                   borderRadius:
        //             //                       BorderRadius.circular(7),
        //             //                   color: CupertinoColors
        //             //                       .lightBackgroundGray
        //             //                       .withOpacity(0.2)),
        //             //               padding: const EdgeInsets.all(5.0),
        //             //               child: ListTile(
        //             //                 leading: Padding(
        //             //                   padding: const EdgeInsets.all(8.0),
        //             //                   child: GestureDetector(
        //             //                     onTap: () async {
        //             //                       // if (storylist.value.isNotEmpty) {
        //             //                       //   showBarModalBottomSheet(
        //             //                       //       backgroundColor: Colors.red,
        //             //                       //       bounce: true,
        //             //                       //       context: context,
        //             //                       //       builder: (context) =>
        //             //                       //           MainStoryResponsiveView(
        //             //                       //               model: localData,
        //             //                       //               storylist: storylist
        //             //                       //                   .value));
        //             //                       // }
        //             //                     },
        //             //                     child: localData.imagePath != null
        //             //                         ? DuctStatusView(
        //             //                             radius: Get.height * 0.03,
        //             //                             isDucts: false,
        //             //                             isLocalDucts: true,
        //             //                             numberOfStatus: 0,
        //             //                             //  storylist.value.length,
        //             //                             bucketId: ductFile,
        //             //                             centerImageUrl: localData
        //             //                                 .imagePath
        //             //                                 .toString())
        //             //                         : localData.thumbPath != null
        //             //                             ? DuctStatusView(
        //             //                                 radius:
        //             //                                     Get.height * 0.03,
        //             //                                 isDucts: false,
        //             //                                 isLocalDucts: true,
        //             //                                 numberOfStatus: 0,
        //             //                                 bucketId: ductFile,
        //             //                                 centerImageUrl:
        //             //                                     localData.thumbPath
        //             //                                         .toString())
        //             //                             : DuctStatusView(
        //             //                                 radius:
        //             //                                     Get.height * 0.03,
        //             //                                 isDucts: true,
        //             //                                 ducts: Container(
        //             //                                   decoration: BoxDecoration(
        //             //                                       boxShadow: [
        //             //                                         BoxShadow(
        //             //                                             offset:
        //             //                                                 const Offset(0,
        //             //                                                     11),
        //             //                                             blurRadius:
        //             //                                                 11,
        //             //                                             color: Colors
        //             //                                                 .black
        //             //                                                 .withOpacity(
        //             //                                                     0.06))
        //             //                                       ],
        //             //                                       borderRadius:
        //             //                                           BorderRadius
        //             //                                               .circular(
        //             //                                                   18),
        //             //                                       color: CupertinoColors
        //             //                                           .systemYellow),
        //             //                                   padding:
        //             //                                       const EdgeInsets
        //             //                                           .all(5.0),
        //             //                                   child: Text(
        //             //                                     localData
        //             //                                         .ductComment
        //             //                                         .toString(),
        //             //                                     style: TextStyle(
        //             //                                       fontSize: 12.0,
        //             //                                     ),
        //             //                                     textAlign: TextAlign
        //             //                                         .center,
        //             //                                   ),
        //             //                                 ),
        //             //                                 numberOfStatus: 0,
        //             //                                 bucketId:
        //             //                                     productBucketId,
        //             //                                 centerImageUrl:
        //             //                                     localData.imagePath
        //             //                                         .toString()),
        //             //                   ),
        //             //                 ),
        //             //                 title: TitleText('Your Ducts'),
        //             //                 subtitle: Text(getChatTime(
        //             //                     localData.createdAt ?? '')),
        //             //                 trailing: localData.audioTag == null
        //             //                     ? Container(
        //             //                         width: 50,
        //             //                         height: 50,
        //             //                       )
        //             //                     : Icon(
        //             //                         CupertinoIcons.music_note_2,
        //             //                         color:
        //             //                             CupertinoColors.systemTeal,
        //             //                         size: 50,
        //             //                       ),
        //             //               ),
        //             //             );
        //             //           }).toList()),

        //             const Divider(
        //               color: CupertinoColors.darkBackgroundGray,
        //             ),
        //           ],
        //         ))),
      ],
    );
  }
}

// FractionallySizedBox(
//   heightFactor: 1 - 0.18,
//   alignment: Alignment.bottomCenter,
//   child: Column(
//     children: [
//       Expanded(
//         child: FutureBuilder(
//           future: getData(),
//           initialData: feedState.feedlist,
//           builder: (context, AsyncSnapshot snapshot) {
//             if (snapshot.data == null) {
//               return Center(
//                 child: Align(
//                   alignment: Alignment.center,
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.vertical,
//                     child: frostedWhite(
//                       SizedBox(
//                         width: Get.height * 0.4,
//                         height: Get.height * 0.2,
//                         child: const EmptyList(
//                           'Chai!! No Ducts Yet ',
//                           subTitle:
//                               'Start Ducting by pressing the button at bottom right!',
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             }
//             ;
//             return NotificationListener<ScrollEndNotification>(
//               onNotification: (notification) {
//                 // if (t is ScrollEndNotification) {
//                 //  cprint(_controller.position.pixels.toString());
//                 // cprint(_controller.position.minScrollExtent.toString());
//                 if (notification.metrics.atEdge) {
//                   if (notification.metrics.pixels == 0) {
//                     getData(pageIndex: 'top');
//                     cprint('At top');
//                     // cprint(lastId.toString());
//                   } else {
//                     getData(pageIndex: 'bottom');
//                     cprint('At bottom');
//                   }
//                 }
//                 // }
//                 //How many pixels scrolled from pervious frame
//                 // print(t!.scrollDelta);

//                 // //List scroll position
//                 // print(t.metrics.pixels);
//                 return true;
//               },
//               child: ListView.builder(
//                 itemCount: snapshot.data.length,
//                 controller: _controller,
//                 physics: BouncingScrollPhysics(),
//                 //reverse: true,
//                 shrinkWrap: true,
//                 itemBuilder: (context, index) {
//                   FeedModel model = snapshot.data[index];
//                   return SizedBox(
//                     width: isDeskLeft == true
//                         ? context.responsiveValue(
//                             mobile: Get.width * 0.8,
//                             tablet: Get.width * 0.3,
//                             desktop: Get.width * 0.15)
//                         : context.responsiveValue(
//                             mobile: Get.width * 0.4,
//                             tablet: Get.width * 0.4,
//                             desktop: Get.width * 0.4),
//                     child: //Obx(
//                         // () =>
//                         SizedBox(
//                             width: context.responsiveValue(
//                                 mobile: Get.height * 0.4,
//                                 tablet: Get.height * 0.4,
//                                 desktop: Get.height * 0.4),
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   vertical: 8.0),
//                               child: model.caption == 'product'
//                                   ? Container()
//                                   : SizedBox(
//                                       width: context.responsiveValue(
//                                           mobile: Get.height * 0.4,
//                                           tablet: Get.height * 0.4,
//                                           desktop: Get.height * 0.4),
//                                       child: Wrap(
//                                         children: [
//                                           Duct(
//                                             model: model,
//                                             commissionProduct:
//                                                 productSetState.value,
//                                             trailing: DuctBottomSheet()
//                                                 .ductOptionIcon(
//                                               context,
//                                               model,
//                                               DuctType.Duct,
//                                             ),
//                                             isDeskLeft: isDesktop,
//                                             // storylist:
//                                             //     storyState.value
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                             )),
//                     //),
//                   );
//                 },
//               ),
//             );
//           },
//         ),
//       ),
//     ],
//   ),
// ),

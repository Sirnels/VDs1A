// ignore_for_file: unnecessary_null_comparison, unused_element, must_be_immutable, invalid_use_of_protected_member

import 'dart:ui';
import 'package:dart_appwrite/dart_appwrite.dart' as apprt;
import 'package:appwrite/appwrite.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
//import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:viewducts/admin/Admin_dashbord/adminUserOrders.dart';
import 'package:viewducts/common/common.dart';
import 'package:viewducts/features/auth/controller/auth_controller.dart';
import 'package:viewducts/features/products/product_controller.dart';

import 'package:viewducts/helper/constant.dart';
import 'package:viewducts/helper/enum.dart';
import 'package:viewducts/helper/theme.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/chatModel.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/page/message/chatScreenPage.dart';
import 'package:viewducts/page/message/local_database.dart';
import 'package:viewducts/page/product/shopingCart.dart';
import 'package:viewducts/page/responsive.dart';
import 'package:viewducts/page/responsiveView.dart';

import 'package:viewducts/state/authState.dart';
import 'package:viewducts/state/feedState.dart';
import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/cartIcon.dart';

import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/duct/profile_orders.dart';
import 'package:viewducts/widgets/duct/widgets/ductBottomSheet.dart';
import 'package:viewducts/widgets/duct/widgets/postAsymmetricView.dart';

import 'package:viewducts/widgets/frosted.dart';
import 'package:viewducts/widgets/newWidget/emptyList.dart';
import 'package:viewducts/widgets/newWidget/rippleButton.dart';
import 'package:viewducts/widgets/newWidget/title_text.dart';
import 'package:viewducts/widgets/postProductMenu.dart';

class Stores extends ConsumerStatefulWidget {
  final String? profileId;

  Stores({
    Key? key,
    this.profileId,
  }) : super(key: key);

  @override
  ConsumerState<Stores> createState() => _StoresState();
}

class _StoresState extends ConsumerState<Stores> {
  bool isMyProfile = false;

  Widget _emptyBox() {
    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }

  // Widget _storeProducts(BuildContext context, AuthState authState,
  //     List<FeedModel> ductedList, bool isreply, bool isMedia, FeedState state) {
  //   List<FeedModel>? list =
  //       feedState.getStoreProductList(authState.userModel!.userId);

  //   /// If user hasn't Ducted yet
  //   if (ductedList == null) {
  //     // cprint('No Duct avalible');
  //   } else {
  //     if (isMedia) {
  //       /// Display all Ducts with media file

  //       list = ductedList.where((x) => x.imagePath != null).toList();
  //     } else if (!isreply) {
  //       /// Display all independent Ducts
  //       /// No comments Duct will display

  //       list = ductedList
  //           .where((x) => x.parentkey == null || x.childVductkey != null)
  //           .toList();
  //     } else {
  //       /// Display all reply Ducts
  //       /// No intependent Duct will display
  //       list = ductedList
  //           .where((x) => x.parentkey != null && x.childVductkey == null)
  //           .toList();
  //     }
  //   }

  //   /// if [authState.isbusy] is true then an loading indicator will be displayed on screen.
  //   return list == null || list.isEmpty
  //       ? Container(
  //           padding: const EdgeInsets.only(top: 50, left: 30, right: 30),
  //           child: NotifyText(
  //             title: isMyProfile
  //                 ? 'You haven\'t ${isreply ? 'reply to any Ducts' : isMedia ? 'post any media Duct yet' : 'post any Duct yet'}'
  //                 : '${authState.profileUserModel!.userName} hasn\'t ${isreply ? 'reply to any Duct' : isMedia ? 'post any media Duct yet' : 'post any Duct yet'}',
  //             subTitle: isMyProfile
  //                 ? 'Tap Ducts button to add new'
  //                 : 'Once he\'ll do, they will be shown up here',
  //           ),
  //         )

  //       /// If Ducts available then Duct list will displayed
  //       : PostAsymmetricView(
  //           model: list,
  //         );

  //   // ListView.builder(
  //   //   padding: EdgeInsets.symmetric(vertical: 0),
  //   //   itemCount: list.length,
  //   //   itemBuilder: (context, index) => Duct(
  //   //     model: list[index],
  //   //     isDisplayOnProfile: true,
  //   //     trailing: DuctBottomSheet().ductOptionIcon(
  //   //       context,
  //   //       list[index],
  //   //       DuctType.Duct,
  //   //     ),
  //   //   ),
  //   // );
  // }

  @override
  Widget build(BuildContext context) {
    var appSize = MediaQuery.of(context).size;
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    final secondUser =
        ref.watch(userDetailsProvider(widget.profileId!.toString())).value;

    //final chatSetState = useState(userCartController.shoppingCart);
    RxList<FeedModel>? productlist = RxList<FeedModel>([]);
    // final productState = useState(productlist);
    // final orderState = useState(userCartController.orders);

    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    Future<bool?> _showDialogChats() {
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
                                    color: CupertinoColors.systemYellow),
                                padding: const EdgeInsets.all(5.0),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: const Text(
                                    'Download App to Chat',
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
                            onTap: () async {
                              try {
                                Navigator.maybePop(context);
                              } on AppwriteException catch (e) {
                                cprint('$e deleting Account');
                              }
                            },
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
                                      color: CupertinoColors.systemGreen),
                                  padding: const EdgeInsets.all(5.0),
                                  child: const Text(
                                    'Download',
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

    Future<bool?> _showDialog(BuildContext context) {
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Container(
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: frostedYellow(
                  Container(
                    height: Get.height * 0.3,
                    width: Get.width * 0.8,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 11),
                              blurRadius: 11,
                              color: Colors.black.withOpacity(0.06))
                        ],
                        borderRadius: BorderRadius.circular(5),
                        color: CupertinoColors.lightBackgroundGray),
                    padding: const EdgeInsets.all(5.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
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
                                      color: CupertinoColors.systemYellow),
                                  padding: const EdgeInsets.all(5.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      // Navigator.maybePop(context);
                                    },
                                    child: Text(
                                      'USD ${userCartController.subscriptionModel.firstWhere((data) => data.subType == 'basic', orElse: () => SubscriptionViewDuctsModel()).price ?? '1.99'}/year',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w200),
                                    ),
                                  )),
                            ),
                            Padding(
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
                                      borderRadius: BorderRadius.circular(5),
                                      color: userCartController
                                                  .venDor.value.active ==
                                              false
                                          ? CupertinoColors.systemRed
                                          : CupertinoColors.white),
                                  padding: const EdgeInsets.all(5.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      // Navigator.maybePop(context);
                                    },
                                    child: Text(
                                      userCartController.venDor.value.active ==
                                              false
                                          ? 'Your yearly Subscription has expire'
                                          : 'Offer your services with us and create more jobs for the unemployed,One Year Subscripton of your business in ViewDucts.',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w200),
                                    ),
                                  )),
                            ),
                            // authState.appPlayStore
                            //         .where((data) => data.operatingSystem == 'IOS')
                            //         .isNotEmpty
                            //     ?

                            //: Container(),
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
                                                  color: Colors.black
                                                      .withOpacity(0.06))
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            color:
                                                CupertinoColors.inactiveGray),
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
                                  onTap: () async {
                                    try {
                                      await Navigator.maybePop(context);
                                      Get.to(
                                          () => SellersSignUpPageResponsiveView(
                                              loginCallback:
                                                  authState.getCurrentUser),
                                          transition: Transition.downToUp);
                                      await feedState.addProductIncartTotalPrice(
                                          userCartController.subscriptionModel
                                                  .firstWhere(
                                                      (data) =>
                                                          data.subType ==
                                                          'basic',
                                                      orElse: () =>
                                                          SubscriptionViewDuctsModel())
                                                  .price!
                                                  .toDouble() *
                                              userCartController.exchangeRate
                                                  .firstWhere(
                                                      (curr) =>
                                                          curr.currency ==
                                                          'dollar',
                                                      orElse: () =>
                                                          ExchangeRateModel())
                                                  .rate!
                                                  .toDouble(),
                                          authState.appUser!.$id,
                                          '');
                                    } on AppwriteException catch (e) {
                                      cprint('$e Subscribe');
                                    }
                                  },
                                  child: Padding(
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
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            color: CupertinoColors.systemGreen),
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          children: [
                                            const Text(
                                              'Subscribe',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w200),
                                            ),
                                            Icon(CupertinoIcons.forward),
                                          ],
                                        )),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
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

    _sendingMails() async {
      var url = Uri.parse("mailto:feedback@geeksforgeeks.org");
      if (await launchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    // final Uri emailLaunchUri = Uri(
    //   scheme: 'mailto',
    //   path: 'help@viewducts.com',
    //   query: encodeQueryParameters(<String, String>{
    //     'subject': 'A request/enquiry to own a ViewDucts Store ',
    //   }),
    // );
    //final userVierState = useState(feedState.userViers);
    String input = '';
    final database = Databases(
      clientConnect(),
    );
    // final realtime = Realtime(clientConnect());
    // final productStream = useStream(realtime.subscribe(
    //     ["databases.$databaseId.collections.$procold.documents"]).stream);
    // getData() async {
    //   try {
    //     userCartController.shoppingCart = RxList<CartItemModel>();
    //     final database = Databases(
    //       clientConnect(),
    //     );
    //     final server = apprt.Databases(
    //       serverApi.serverClientConnect(),
    //     );
    //     FToast().init(Get.context!);
    //     if (authState.networkConnectionState.value == 'Not Connected') {
    //       Fluttertoast.showToast(
    //         msg: 'You are offline',
    //         // toastLength: Toast.LENGTH_SHORT,
    //         gravity: ToastGravity.TOP_LEFT,
    //         timeInSecForIosWeb: 8,
    //         backgroundColor: CupertinoColors.systemRed,
    //       );
    //     } else if (authState.networkConnectionState.value == 'Connected') {
    //       Fluttertoast.showToast(
    //         msg: 'You are online',
    //         // toastLength: Toast.LENGTH_SHORT,
    //         gravity: ToastGravity.TOP_LEFT,
    //         timeInSecForIosWeb: 8,
    //         backgroundColor: CupertinoColors.systemGreen,
    //       );
    //       authState.networkConnectionState.value == '';
    //     }

    //     await database
    //         .listDocuments(
    //       databaseId: databaseId,
    //       collectionId: exchangeRateColl,
    //     )
    //         .then((data) {
    //       userCartController.exchangeRate.value = data.documents
    //           .map((e) => ExchangeRateModel.fromJson(e.data))
    //           .toList();
    //       cprint(
    //           '${userCartController.exchangeRate.firstWhere((curr) => curr.currency == 'dollar', orElse: () => ExchangeRateModel()).rate!.toDouble()} exchange rate');
    //     });
    //     await database
    //         .listDocuments(
    //       databaseId: databaseId,
    //       collectionId: subscrptionColl,
    //     )
    //         .then((data) {
    //       userCartController.subscriptionModel.value = data.documents
    //           .map((e) => SubscriptionViewDuctsModel.fromJson(e.data))
    //           .toList();
    //       cprint(
    //           '${userCartController.subscriptionModel.map((data) => data.price)} subscription');
    //     });
    //     await database.listDocuments(
    //         databaseId: databaseId,
    //         collectionId: vendorColl,
    //         queries: [
    //           Query.equal('vendorId', authState.appUser!.$id.toString())
    //         ]).then((data) {
    //       var value =
    //           data.documents.map((e) => VendorModel.fromJson(e.data)).toList();

    //       userCartController.venDor.value = value.firstWhere(
    //           (data) => data.vendorId == authState.appUser!.$id.toString(),
    //           orElse: () => VendorModel());
    //       cprint("${userCartController.venDor.value.active} activeness");
    //     });

    //     await server.listDocuments(
    //         databaseId: databaseId,
    //         collectionId: userOrdersCollection,
    //         queries: [
    //           Query.equal('sellerId', authState.userModel?.userId)
    //         ]).then((data) {
    //       var value = data.documents
    //           .map((e) => OrderViewProduct.fromSnapshot(e.data))
    //           .toList();

    //       orderState.value.value = value.obs;
    //     });

    //     await database.listDocuments(
    //         databaseId: databaseId,
    //         collectionId: profileUserColl,
    //         queries: [Query.equal('key', widget.profileId)]).then((data) {
    //       var value = data.documents
    //           .map((e) => ViewductsUser.fromJson(e.data))
    //           .toList();

    //       searchState.viewUserlist.value = value;
    //       chatState.chatUser ==
    //           value.firstWhere((data) => data.key == widget.profileId).obs;
    //     });

    //     await database.listDocuments(
    //         databaseId: databaseId,
    //         collectionId: shoppingCartCollection,
    //         queries: [
    //           Query.equal('vendorId', chatState.chatUser?.userId.toString())
    //         ]).then((data) {
    //       // if (data.documents.isNotEmpty) {
    //       var value =
    //           data.documents.map((e) => CartItemModel.fromMap(e.data)).toList();

    //       chatSetState.value.value = value;
    //       // }
    //     });
    //     //   if (input.value.value == '') {
    //     await database.listDocuments(
    //         databaseId: databaseId,
    //         collectionId: procold,
    //         queries: [
    //           Query.equal('userId', chatState.chatUser?.userId.toString()),
    //         ]).then((data) {
    //       productState.value.value =
    //           data.documents.map((e) => FeedModel.fromJson(e.data)).toList();
    //     });
    //     await database.listDocuments(
    //         databaseId: databaseId,
    //         collectionId: mainUserViews,
    //         queries: [
    //           Query.equal('viewerId', authState.appUser!.$id),
    //           Query.equal('viewductUser', widget.profileId),
    //         ]).then((data) {
    //       var value = data.documents
    //           .map((e) => MainUserViewsModel.fromJson(e.data))
    //           .toList();
    //       userVierState.value.value = value;
    //     });
    //     // }
    //   } on AppwriteException catch (e) {
    //     cprint("$e storeData");
    //   }
    // }

    searchProducts(String query) {
      // final sugestion = productState.value.where((product) {
      //   final productTitle = product.productName!.toLowerCase();
      //   input = query.toLowerCase();
      //   return productTitle.contains(input);
      // }).toList();
      // productState.value = sugestion.obs;
    }

    ;

    // final chatStream = useStream(realtime.subscribe([
    //   "databases.$databaseId.collections.$shoppingCartCollection.documents"
    // ]).stream);

    // subs() {
    //   productStream.data;
    //   if (productState.value.isNotEmpty) {
    //     switch (productStream.data?.events) {
    //       case ["collections.*.documents"]:
    //         // setState(() {});
    //         productState.value.value
    //             .add(FeedModel.fromJson(productStream.data?.payload));

    //         break;
    //       case ["collections.*.documents.*.delete"]:
    //         // setState(() {});
    //         productState.value.value.removeWhere(
    //             (datas) => datas.key == productStream.data!.payload['key']);

    //         break;

    //       default:
    //         break;
    //     }
    //   } else {
    //     cprint('it is empty');
    //   }
    // }

    // final orderStream = useStream(realtime.subscribe([
    //   "databases.$databaseId.collections.$userOrdersCollection.documents"
    // ]).stream);
    // listenToOrdersSub() {
    //   orderStream.data;
    //   if (orderState.value.value != null) {
    //     switch (orderStream.data?.events) {
    //       case ["collections.*.documents"]:
    //         // setState(() {});
    //         orderState.value.value
    //             .add(OrderViewProduct.fromSnapshot(orderStream.data?.payload));

    //         break;
    //       case ["collections.*.documents.*.delete"]:
    //         // setState(() {});
    //         orderState.value.value.removeWhere(
    //             (datas) => datas.key == orderStream.data!.payload['key']);

    //         break;

    //       default:
    //         break;
    //     }
    //   } else {
    //     cprint('it is empty');
    //   }
    // }

    // final subStreaming = useMemoized(() => subs());
    // useEffect(
    //   () {
    //     animationController.forward();
    //     getData();

    //     subStreaming;
    //     return () {};
    //   },
    //   [
    //     //productlist, feedState.state
    //   ],
    // );

    return Scaffold(
      //backgroundColor: TwitterColor.mystic,
      body: SafeArea(
        child:
            // List<FeedModel> list =
            //     feedState.getStoreProductList(authState.userModel.userId);

            // if (feedState.getStoreProductList(authState.userModel.userId) != null &&
            //     feedState.getStoreProductList(authState.userModel.userId).length >
            //         0) {
            //   list = state
            //       .getStoreProductList(authState.userModel.userId)
            //       .where((x) => x.userId == id)
            //       .toList();
            // }

            // if (feedState.feedlist != null && feedState.feedlist!.length > 0) {
            //   list = feedState.getStoreProductList(authState.userId);
            //   // .where((x) => x.userId == id)
            //   // .toList();
            // }
            Stack(
          fit: StackFit.expand,
          children: <Widget>[
            ThemeMode.system == ThemeMode.light
                ? frostedYellow(
                    Container(
                      height: appSize.height,
                      width: appSize.width,
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(100),
                        //color: Colors.blueGrey[50]
                        gradient: LinearGradient(
                          colors: [
                            Colors.yellow[100]!.withOpacity(0.3),
                            Colors.yellow[200]!.withOpacity(0.1),
                            Colors.yellowAccent[100]!.withOpacity(0.2)
                            // Color(0xfffbfbfb),
                            // Color(0xfff7f7f7),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  )
                : Container(),
            Positioned(
              bottom: 0,
              left: 0,
              child: Transform.rotate(
                angle: 90,
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/ankkara1.jpg'))),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: -10,
              child: Transform.rotate(
                angle: 90,
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/ankara3.jpg'))),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Transform.rotate(
                angle: 30,
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/ankkara1.jpg'))),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: -10,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(
                  width: Get.height * 0.4,
                  height: Get.height * 0.4,
                  color: (Colors.white12).withOpacity(0.1),
                ),
              ),
            ),
            //getGroupOfProductsByVendorsProvider
            FractionallySizedBox(
                heightFactor: 1 - 0.2,
                alignment: Alignment.bottomCenter,
                child: ref
                    .watch(getGroupOfProductsByVendorsProvider(
                        '${secondUser?.userId}'))
                    .when(
                        data: (product) {
                          // cprint(
                          //     productList.map((e) => e.productState).toString());
                          return product.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: fullWidth(context) * 0.1,
                                          ),
                                          Container(
                                            height: 100,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                image: const DecorationImage(
                                                    image: AssetImage(
                                                        'assets/shopping-bag.png'))),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 30),
                                            child: frostedWhite(
                                              Align(
                                                alignment: Alignment.topCenter,
                                                child: SizedBox(
                                                  height:
                                                      context.responsiveValue(
                                                          mobile:
                                                              Get.height * 0.4,
                                                          tablet:
                                                              Get.height * 0.3,
                                                          desktop:
                                                              Get.height * 0.3),
                                                  child: const EmptyList(
                                                    'No Product in Your Location ',
                                                    subTitle:
                                                        // authState.userModel!.vendor ==
                                                        //         true
                                                        //     ? 'You can Add product to this Category'
                                                        //     :
                                                        'Try Again later!',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          // authState.userModel!.vendor == true
                                          //     ? Container()
                                          //     : Column(
                                          //         mainAxisAlignment: MainAxisAlignment.center,
                                          //         crossAxisAlignment: CrossAxisAlignment.center,
                                          //         children: [
                                          //           customButton(
                                          //             'Register',
                                          //             Image.asset(
                                          //               'assets/home 1.png',
                                          //               height: 20,
                                          //               width: 20,
                                          //             ),
                                          //           ),
                                          //           customText(' or ',
                                          //               style: TextStyle(
                                          //                   fontSize: 20,
                                          //                   color: Colors.blueGrey)),
                                          //           customButton(
                                          //             'Invite and Earn',
                                          //             Image.asset(
                                          //               'assets/home 1.png',
                                          //               height: 20,
                                          //               width: 20,
                                          //             ),
                                          //           )
                                          //         ],
                                          //       )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : PostAsymmetricView(
                                  // isWelcomePage: widget.isWelcomePage,
                                  // category: widget.category,
                                  // location: widget.location,
                                  // product: widget.product,
                                  // section: widget.section,
                                  // state: widget.state,
                                  model: product
                                  // .where(
                                  //     (data) => data.productState == 'Enugu')
                                  // .toList(),
                                  );
                        },
                        error: (error, stackTrace) => ErrorText(
                              error: error.toString(),
                            ),
                        loading: () => const LoaderAll())

                // FutureBuilder(
                //     future: database.listDocuments(
                //         databaseId: databaseId,
                //         collectionId: procold,
                //         queries: [
                //           //  Query.equal('userId', chatState.chatUser?.userId),
                //         ]),
                //     builder: ((context, snapshot) {
                //       return Container();

                //       //  snapshot.hasData == true
                //       //     ? Obx(() => productState.value.isEmpty
                //       //         ? Padding(
                //       //             padding: const EdgeInsets.all(8.0),
                //       //             child: Align(
                //       //               alignment: Alignment.centerLeft,
                //       //               child: SingleChildScrollView(
                //       //                 scrollDirection: Axis.vertical,
                //       //                 child: Column(
                //       //                   mainAxisAlignment:
                //       //                       MainAxisAlignment.center,
                //       //                   crossAxisAlignment:
                //       //                       CrossAxisAlignment.center,
                //       //                   children: [
                //       //                     SizedBox(
                //       //                       height: fullWidth(context) * 0.1,
                //       //                     ),
                //       //                     Container(
                //       //                       height: 100,
                //       //                       width: 100,
                //       //                       decoration: BoxDecoration(
                //       //                           borderRadius:
                //       //                               BorderRadius.circular(100),
                //       //                           image: const DecorationImage(
                //       //                               image: AssetImage(
                //       //                                   'assets/shopping-bag.png'))),
                //       //                     ),
                //       //                     Padding(
                //       //                       padding: const EdgeInsets.symmetric(
                //       //                           horizontal: 30),
                //       //                       child: frostedWhite(
                //       //                         Align(
                //       //                           alignment: Alignment.topCenter,
                //       //                           child: SizedBox(
                //       //                             height: context.responsiveValue(
                //       //                                 mobile: Get.height * 0.4,
                //       //                                 tablet: Get.height * 0.3,
                //       //                                 desktop: Get.height * 0.3),
                //       //                             child: EmptyList(
                //       //                               authState.userModel?.userId ==
                //       //                                       widget.profileId
                //       //                                   ? 'Chai!! No Product in Your '
                //       //                                   : 'Chai!! No Product in ${chatState.chatUser?.displayName ?? ''} View ',
                //       //                               subTitle:
                //       //                                   // authState.userModel!.vendor ==
                //       //                                   //         true
                //       //                                   //     ? 'You can Add product to this Category'
                //       //                                   //     :
                //       //                                   authState.userModel
                //       //                                               ?.userId ==
                //       //                                           widget.profileId
                //       //                                       ? "View Yet"
                //       //                                       : 'Try Again later!',
                //       //                             ),
                //       //                           ),
                //       //                         ),
                //       //                       ),
                //       //                     ),
                //       //                     // authState.userModel!.vendor == true
                //       //                     //     ? Container()
                //       //                     //     : Column(
                //       //                     //         mainAxisAlignment: MainAxisAlignment.center,
                //       //                     //         crossAxisAlignment: CrossAxisAlignment.center,
                //       //                     //         children: [
                //       //                     //           customButton(
                //       //                     //             'Register',
                //       //                     //             Image.asset(
                //       //                     //               'assets/home 1.png',
                //       //                     //               height: 20,
                //       //                     //               width: 20,
                //       //                     //             ),
                //       //                     //           ),
                //       //                     //           customText(' or ',
                //       //                     //               style: TextStyle(
                //       //                     //                   fontSize: 20,
                //       //                     //                   color: Colors.blueGrey)),
                //       //                     //           customButton(
                //       //                     //             'Invite and Earn',
                //       //                     //             Image.asset(
                //       //                     //               'assets/home 1.png',
                //       //                     //               height: 20,
                //       //                     //               width: 20,
                //       //                     //             ),
                //       //                     //           )
                //       //                     //         ],
                //       //                     //       )
                //       //                   ],
                //       //                 ),
                //       //               ),
                //       //             ),
                //       //           )
                //       //         : DateFormat("E").format(DateTime.now()) == 'Sun'
                //       //             ? Container()
                //       //             : PostAsymmetricView(
                //       //                 model: productState.value.value,
                //       //               ))
                //       //     : Obx(() => productState.value.isEmpty
                //       //         ? Padding(
                //       //             padding: const EdgeInsets.all(8.0),
                //       //             child: Align(
                //       //               alignment: Alignment.centerLeft,
                //       //               child: Column(
                //       //                 mainAxisAlignment: MainAxisAlignment.center,
                //       //                 crossAxisAlignment:
                //       //                     CrossAxisAlignment.center,
                //       //                 children: [
                //       //                   SizedBox(
                //       //                     height: fullWidth(context) * 0.1,
                //       //                   ),
                //       //                   Container(
                //       //                     height: 100,
                //       //                     width: 100,
                //       //                     decoration: BoxDecoration(
                //       //                         borderRadius:
                //       //                             BorderRadius.circular(100),
                //       //                         image: const DecorationImage(
                //       //                             image: AssetImage(
                //       //                                 'assets/shopping-bag.png'))),
                //       //                   ),
                //       //                   Padding(
                //       //                     padding: const EdgeInsets.symmetric(
                //       //                         horizontal: 30),
                //       //                     child: frostedWhite(
                //       //                       Align(
                //       //                         alignment: Alignment.topCenter,
                //       //                         child: SizedBox(
                //       //                           height: context.responsiveValue(
                //       //                               mobile: Get.height * 0.4,
                //       //                               tablet: Get.height * 0.3,
                //       //                               desktop: Get.height * 0.3),
                //       //                           child: EmptyList(
                //       //                             authState.userModel?.userId ==
                //       //                                     widget.profileId
                //       //                                 ? 'Chai!! No Product in Your View '
                //       //                                 : 'Chai!! No Product in ${chatState.chatUser?.displayName ?? ''} View ',
                //       //                             subTitle:
                //       //                                 // authState.userModel!.vendor ==
                //       //                                 //         true
                //       //                                 //     ? 'You can Add product to this Category'
                //       //                                 //     :
                //       //                                 'Try Again later!',
                //       //                           ),
                //       //                         ),
                //       //                       ),
                //       //                     ),
                //       //                   ),
                //       //                   // authState.userModel!.vendor == true
                //       //                   //     ? Container()
                //       //                   //     : Column(
                //       //                   //         mainAxisAlignment: MainAxisAlignment.center,
                //       //                   //         crossAxisAlignment: CrossAxisAlignment.center,
                //       //                   //         children: [
                //       //                   //           customButton(
                //       //                   //             'Register',
                //       //                   //             Image.asset(
                //       //                   //               'assets/home 1.png',
                //       //                   //               height: 20,
                //       //                   //               width: 20,
                //       //                   //             ),
                //       //                   //           ),
                //       //                   //           customText(' or ',
                //       //                   //               style: TextStyle(
                //       //                   //                   fontSize: 20,
                //       //                   //                   color: Colors.blueGrey)),
                //       //                   //           customButton(
                //       //                   //             'Invite and Earn',
                //       //                   //             Image.asset(
                //       //                   //               'assets/home 1.png',
                //       //                   //               height: 20,
                //       //                   //               width: 20,
                //       //                   //             ),
                //       //                   //           )
                //       //                   //         ],
                //       //                   //       )
                //       //                 ],
                //       //               ),
                //       //             ),
                //       //           )
                //       //         : Padding(
                //       //             padding: const EdgeInsets.all(8.0),
                //       //             child: Align(
                //       //               alignment: Alignment.centerLeft,
                //       //               child: Column(
                //       //                 mainAxisAlignment: MainAxisAlignment.center,
                //       //                 crossAxisAlignment:
                //       //                     CrossAxisAlignment.center,
                //       //                 children: [
                //       //                   SizedBox(
                //       //                     height: fullWidth(context) * 0.1,
                //       //                   ),
                //       //                   Container(
                //       //                     height: 100,
                //       //                     width: 100,
                //       //                     decoration: BoxDecoration(
                //       //                         borderRadius:
                //       //                             BorderRadius.circular(100),
                //       //                         image: const DecorationImage(
                //       //                             image: AssetImage(
                //       //                                 'assets/shopping-bag.png'))),
                //       //                   ),
                //       //                   Padding(
                //       //                     padding: const EdgeInsets.symmetric(
                //       //                         horizontal: 30),
                //       //                     child: frostedWhite(
                //       //                       Align(
                //       //                         alignment: Alignment.topCenter,
                //       //                         child: SizedBox(
                //       //                           height: context.responsiveValue(
                //       //                               mobile: Get.height * 0.3,
                //       //                               tablet: Get.height * 0.2,
                //       //                               desktop: Get.height * 0.2),
                //       //                           child: EmptyList(
                //       //                             authState.userModel?.userId ==
                //       //                                     widget.profileId
                //       //                                 ? 'Chai!! No Product in Your View '
                //       //                                 : 'Chai!! No Product in ${chatState.chatUser?.displayName ?? ''} View ',
                //       //                             subTitle:
                //       //                                 // authState.userModel!.vendor ==
                //       //                                 //         true
                //       //                                 //     ? 'You can Add product to this Category'
                //       //                                 //     :
                //       //                                 'Try Again later!',
                //       //                           ),
                //       //                         ),
                //       //                       ),
                //       //                     ),
                //       //                   ),
                //       //                 ],
                //       //               ),
                //       //             ),
                //       //           ));
                //     })),

                ),

            // Positioned(
            //   top: appSize.width,
            //   left: -50,
            //   child: ClipOval(
            //     child: Container(
            //       height: appSize.height,
            //       width: appSize.height,
            //       decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(100),
            //           color: Colors.white.withOpacity(0.4)),
            //     ),
            //   ),
            // ),

            // list == null
            //     ? Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         children: [
            //           SizedBox(
            //             height: fullWidth(context) * 0.1,
            //           ),
            //           Container(
            //             height: 100,
            //             width: 100,
            //             decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(100),
            //                 image: const DecorationImage(
            //                     image: AssetImage('assets/shopping-bag.png'))),
            //           ),
            //           Padding(
            //             padding: const EdgeInsets.symmetric(horizontal: 30),
            //             child: frostedWhite(
            //               Align(
            //                 alignment: Alignment.topCenter,
            //                 child: SizedBox(
            //                   height: fullWidth(context) * 0.5,
            //                   child: const EmptyList(
            //                     'Chai!! No Product Added ',
            //                     subTitle:
            //                         'Start adding your product by pressing the button at bottom right!',
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ],
            //       )
            //     : Positioned(
            //         top: appSize.width * 0.4,
            //         left: 0,
            //         right: 0,
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           mainAxisAlignment: MainAxisAlignment.start,
            //           children: [
            //             SizedBox(
            //                 // decoration: BoxDecoration(
            //                 //     borderRadius:
            //                 //         BorderRadius.circular(20),
            //                 //     color: Colors.blueGrey[50],
            //                 //     gradient: LinearGradient(
            //                 //       colors: [
            //                 //         Colors.yellow.withOpacity(0.1),
            //                 //         Colors.white60.withOpacity(0.2),
            //                 //         Colors.orange.withOpacity(0.3)
            //                 //       ],
            //                 //       // begin: Alignment.topCenter,
            //                 //       // end: Alignment.bottomCenter,
            //                 //     )),
            //                 height: appSize.height * 0.8,
            //                 width: appSize.width,
            //                 child: PostAsymmetricView(
            //                   model: list,
            //                   isDisplayOnProfile: true,
            //                 )
            //                 // _storeProducts(context, authState, list,
            //                 //     false, false, state)

            //                 //     AsymmetricView(
            //                 //   products:
            //                 //       ProductsRepository.loadProducts(Category.all),
            //                 // ),
            //                 ),
            //           ],
            //         ),
            //       ),
            // Positioned(
            //   top: 0,
            //   // left: appSize.width * 0.4,
            //   right: Get.width * 0.3,
            //   child: CartIcon(),
            // ),

            Positioned(
              top: appSize.height * 0.1,
              left: appSize.width * 0.03,
              child: frostedYellow(
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 3),
                            child: currentUser!.userId == widget.profileId
                                ? customText(
                                    'Your View',
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  )
                                : customText(
                                    secondUser!.displayName == null
                                        ? 'View'
                                        // : userCartController
                                        //             .venDor.value.active ==
                                        //         true
                                        //     ? userCartController
                                        //                 .venDor
                                        //                 .value
                                        //                 .businessName ==
                                        //             null
                                        //         ?
                                        // '${secondUser.displayName}\'s View'
                                        // : '${userCartController.venDor.value.businessName}\'s View'
                                        : '${secondUser.displayName}\'s View',
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    Material(
                      elevation: 20,
                      borderRadius: BorderRadius.circular(100),
                      child: SizedBox(
                        width: context.responsiveValue(
                            mobile: Get.height * 0.35,
                            tablet: Get.height * 0.38,
                            desktop: Get.height * 0.5),
                        height: context.responsiveValue(
                            mobile: Get.height * 0.05,
                            tablet: Get.height * 0.05,
                            desktop: Get.height * 0.05),
                        child: CupertinoSearchTextField(onChanged: (data) {
                          return searchProducts(data);
                        }),
                      ),
                    ),
                    currentUser.userId == widget.profileId ||
                            currentUser.userId! == null
                        ? Container()
                        : Container(
                            width: context.responsiveValue(
                                mobile: Get.height * 0.35,
                                tablet: Get.height * 0.38,
                                desktop: Get.height * 0.5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: frostedWhite(
                                    Container(
                                      child:
                                          // authState.userId ==
                                          //         authState.profileUserModel?.userId
                                          //     ? Container()
                                          //     :
                                          RippleButton(
                                        splashColor: TwitterColor.dodgetBlue_50
                                            .withAlpha(100),
                                        onPressed: () async {
                                          if (kIsWeb) {
                                            _showDialogChats();
                                          } else {
                                            chatState.chatMessage.value =
                                                await SQLHelper.findLocalMessages(
                                                    '${currentUser.userId!.splitByLengths((authState.appUser!.$id.length) ~/ 2)[0]}_${widget.profileId!.splitByLengths((widget.profileId!.length) ~/ 2)[0]}');
                                            if (chatState
                                                .chatMessage.value.isEmpty) {
                                              chatState.chatMessage.value =
                                                  await SQLHelper.findLocalMessages(
                                                      '${widget.profileId!.splitByLengths((widget.profileId!.length) ~/ 2)[0]}_${authState.appUser!.$id.splitByLengths((authState.appUser!.$id.length) ~/ 2)[0]}');
                                            }
                                            // final chatState =
                                            //     Provider.of<ChatState>(
                                            //         context,
                                            //         listen: false);

                                            Get.to(() => ChatResponsive(
                                                  userProfileId:
                                                      widget.profileId,
                                                ));
                                            //   Navigator.pushNamed(
                                            //       context, '/ChatScreenPage');
                                          }
                                        },
                                        child: SizedBox(
                                            height: 50,
                                            width: 50,
                                            child: Lottie.asset(
                                              'assets/lottie/chat-box-animation.json',
                                            )),
                                      ),
                                    ),
                                  ),
                                ),
                                // SizedBox(
                                //   child: Obx(
                                //     () => userVierState.value
                                //                 .firstWhere(
                                //                   (id) => true,
                                //                   orElse: () =>
                                //                       MainUserViewsModel(),
                                //                 )
                                //                 .viewerId ==
                                //             null
                                //         ? Container()
                                //         : userVierState.value
                                //                     .firstWhere(
                                //                       (id) => true,
                                //                       orElse: () =>
                                //                           MainUserViewsModel(),
                                //                     )
                                //                     .viewerId ==
                                //                 authState.appUser!.$id
                                //             ? GestureDetector(
                                //                 onTap: () {
                                //                   feedState.deletViewUser(
                                //                       authState.appUser!.$id,
                                //                       chatState.chatUser);
                                //                 },
                                //                 child: Container(
                                //                     // height: Get.width * 0.1,
                                //                     decoration: BoxDecoration(
                                //                         boxShadow: [
                                //                           BoxShadow(
                                //                               offset:
                                //                                   const Offset(
                                //                                       0, 11),
                                //                               blurRadius: 11,
                                //                               color: Colors
                                //                                   .black
                                //                                   .withOpacity(
                                //                                       0.06))
                                //                         ],
                                //                         borderRadius:
                                //                             BorderRadius
                                //                                 .circular(18),
                                //                         color: CupertinoColors
                                //                             .systemGreen),
                                //                     padding:
                                //                         const EdgeInsets.all(
                                //                             5.0),
                                //                     child: const Text(
                                //                       'Viewing',
                                //                       style: TextStyle(
                                //                           color: CupertinoColors
                                //                               .darkBackgroundGray,
                                //                           fontWeight:
                                //                               FontWeight.w900),
                                //                     )),
                                //               )
                                //             : GestureDetector(
                                //                 onTap: () async {
                                //                   await feedState.viewUser(
                                //                       authState.appUser!.$id,
                                //                       viewductUser: widget.profileId);
                                //                   // setState(() {});
                                //                   // await Future.delayed(
                                //                   //     const Duration(
                                //                   //         seconds: 8),
                                //                   //     () {});

                                //                   FToast().showToast(
                                //                       child: Padding(
                                //                         padding:
                                //                             const EdgeInsets
                                //                                 .all(5.0),
                                //                         child: Container(
                                //                             // width:
                                //                             //    Get.width * 0.3,
                                //                             decoration: BoxDecoration(
                                //                                 boxShadow: [
                                //                                   BoxShadow(
                                //                                       offset:
                                //                                           const Offset(
                                //                                               0,
                                //                                               11),
                                //                                       blurRadius:
                                //                                           11,
                                //                                       color: Colors
                                //                                           .black
                                //                                           .withOpacity(
                                //                                               0.06))
                                //                                 ],
                                //                                 borderRadius:
                                //                                     BorderRadius
                                //                                         .circular(
                                //                                             18),
                                //                                 color: CupertinoColors
                                //                                     .activeGreen),
                                //                             padding:
                                //                                 const EdgeInsets
                                //                                     .all(5.0),
                                //                             child: Text(
                                //                               'You are now Viewing ',
                                //                               style: TextStyle(
                                //                                   color: CupertinoColors
                                //                                       .darkBackgroundGray,
                                //                                   fontWeight:
                                //                                       FontWeight
                                //                                           .w900),
                                //                             )),
                                //                       ),
                                //                       gravity:
                                //                           ToastGravity.TOP_LEFT,
                                //                       toastDuration:
                                //                           Duration(seconds: 3));
                                //                   // setState(() {});
                                //                 },
                                //                 child: Container(
                                //                     // height: Get.width * 0.1,
                                //                     decoration: BoxDecoration(
                                //                         boxShadow: [
                                //                           BoxShadow(
                                //                               offset:
                                //                                   const Offset(
                                //                                       0, 11),
                                //                               blurRadius: 11,
                                //                               color: Colors
                                //                                   .black
                                //                                   .withOpacity(
                                //                                       0.06))
                                //                         ],
                                //                         borderRadius:
                                //                             BorderRadius
                                //                                 .circular(18),
                                //                         color: Colors.cyan),
                                //                     padding:
                                //                         const EdgeInsets.all(
                                //                             5.0),
                                //                     child: const Text(
                                //                       'Start Viewing',
                                //                       style: TextStyle(
                                //                           color: CupertinoColors
                                //                               .darkBackgroundGray,
                                //                           fontWeight:
                                //                               FontWeight.w900),
                                //                     )),
                                //               ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),

              //  Text(
              //   'Shoes',
              //   style: TextStyle(
              //       color: Colors.blueGrey[200],
              //       fontSize: 40,
              //       fontWeight: FontWeight.bold),
              // ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Column(
                children: [
                  Hero(
                    tag: 'profilePic',
                    child: Material(
                      elevation: 20,
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
                          child: Stack(
                            children: [
                              customImage(
                                context,
                                secondUser!.profilePic,
                                height: 70,
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: secondUser.isVerified == true
                                    ? Material(
                                        elevation: 10,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: CircleAvatar(
                                          radius: 9,
                                          backgroundColor: Colors.transparent,
                                          child: Image.asset(
                                              'assets/delicious.png'),
                                        ),
                                      )
                                    : Container(),
                              )
                            ],
                          ),
                          borderRadius: BorderRadius.circular(50),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProfileResponsiveView(
                                      profileId: widget.profileId,
                                      profileType: ProfileType.Profile,
                                    )));
                            // Navigator.pushNamed(
                            //     context, "/ProfileImageView");
                          },
                        ),
                      ),
                    ),
                  ),
                  // Obx(
                  //   () => authState.networkConnectionState.value ==
                  //           'Not Connected'
                  //       ? Container()
                  //       : authState.userModel?.userId != widget.profileId
                  //           ? Container()
                  //           : userCartController.venDor.value.active == true
                  //               ? Padding(
                  //                   padding: const EdgeInsets.all(4.0),
                  //                   child: Container(
                  //                       // width:
                  //                       //    Get.width * 0.3,
                  //                       decoration: BoxDecoration(
                  //                           boxShadow: [
                  //                             BoxShadow(
                  //                                 offset: const Offset(0, 11),
                  //                                 blurRadius: 11,
                  //                                 color: Colors.black
                  //                                     .withOpacity(0.06))
                  //                           ],
                  //                           borderRadius:
                  //                               BorderRadius.circular(18),
                  //                           color: CupertinoColors.activeGreen),
                  //                       padding: const EdgeInsets.all(5.0),
                  //                       child: Text(
                  //                         'Aproved',
                  //                         style: TextStyle(
                  //                             color: CupertinoColors
                  //                                 .darkBackgroundGray,
                  //                             fontWeight: FontWeight.w900),
                  //                       )),
                  //                 )
                  //               : userCartController.venDor.value.active == null
                  //                   ? Container()
                  //                   : Padding(
                  //                       padding: const EdgeInsets.all(4.0),
                  //                       child: Container(
                  //                           // width:
                  //                           //    Get.width * 0.3,
                  //                           decoration: BoxDecoration(
                  //                               boxShadow: [
                  //                                 BoxShadow(
                  //                                     offset:
                  //                                         const Offset(0, 11),
                  //                                     blurRadius: 11,
                  //                                     color: Colors.black
                  //                                         .withOpacity(0.06))
                  //                               ],
                  //                               borderRadius:
                  //                                   BorderRadius.circular(18),
                  //                               color:
                  //                                   CupertinoColors.systemRed),
                  //                           padding: const EdgeInsets.all(5.0),
                  //                           child: Text(
                  //                             'Deactivate',
                  //                             style: TextStyle(
                  //                                 color: CupertinoColors
                  //                                     .darkBackgroundGray,
                  //                                 fontWeight: FontWeight.w900),
                  //                           )),
                  //                     ),
                  // )
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 10,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.black,
                    icon: const Icon(CupertinoIcons.back),
                  ),
                  Material(
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
                              child: customTitleText('ViewDucts'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Container(
                      width: 50,
                      height: 50,
                      child: CartIcon(
                        sellerId: secondUser.userId,
                        allProduct: false,
                        currentUser: currentUser,
                      ),
                    ),
                  ),
                  // DateFormat("E").format(DateTime.now()) == 'Sun'
                  //     ? Container()
                  //     : chatSetState.value.isEmpty
                  //         ? Container()
                  //         : GestureDetector(
                  //             onTap: () {
                  //               showBarModalBottomSheet(
                  //                   backgroundColor: Colors.red,
                  //                   bounce: true,
                  //                   context: context,
                  //                   builder: (context) => ShoppingCart(
                  //                         cart: userCartController.cart,
                  //                         sellerId: widget.profileId,
                  //                         buyerId: authState.userModel?.key,
                  //                         sellersName:
                  //                             chatState.chatUser?.displayName,
                  //                       ));
                  //             },
                  //             child: Badge(
                  //               badgeColor: CupertinoColors.lightBackgroundGray,
                  //               // position: BadgePosition.topStart(
                  //               //     top: -2, start: -4),
                  //               badgeContent:
                  //                   TitleText('${chatSetState.value.length}'),

                  //               child: Padding(
                  //                 padding: const EdgeInsets.all(5.0),
                  //                 child: Container(
                  //                     decoration: BoxDecoration(
                  //                         boxShadow: [
                  //                           BoxShadow(
                  //                               offset: const Offset(0, 11),
                  //                               blurRadius: 11,
                  //                               color: Colors.black
                  //                                   .withOpacity(0.06))
                  //                         ],
                  //                         borderRadius:
                  //                             BorderRadius.circular(18),
                  //                         color: CupertinoColors.systemRed),
                  //                     padding: const EdgeInsets.all(5.0),
                  //                     child: TitleText(
                  //                       'Cart',
                  //                       color:
                  //                           CupertinoColors.lightBackgroundGray,
                  //                     )),
                  //               ),
                  //             ),
                  //           ),
                ],
              ),
            ),
            DateFormat("E").format(DateTime.now()) == 'Sun' ||
                    currentUser.userId! == null
                ? Container()
                : Positioned(
                    bottom: 10,
                    right: 10,
                    child:
                        // authState.networkConnectionState.value ==
                        //         'Not Connected'
                        //     ? Padding(
                        //         padding: const EdgeInsets.all(5.0),
                        //         child: Container(
                        //             decoration: BoxDecoration(
                        //                 boxShadow: [
                        //                   BoxShadow(
                        //                       offset: const Offset(0, 11),
                        //                       blurRadius: 11,
                        //                       color: Colors.black.withOpacity(0.06))
                        //                 ],
                        //                 borderRadius: BorderRadius.circular(18),
                        //                 color: CupertinoColors.systemRed),
                        //             padding: const EdgeInsets.all(5.0),
                        //             child: TitleText(
                        //               'Offline',
                        //               color: CupertinoColors.lightBackgroundGray,
                        //             )),
                        //       )
                        //     :
                        frostedOrange(
                      Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 11),
                                  blurRadius: 11,
                                  color: Colors.black.withOpacity(0.06))
                            ],
                            borderRadius: BorderRadius.circular(5),
                            color: CupertinoColors.lightBackgroundGray),
                        padding: const EdgeInsets.all(5.0),
                        child: Stack(
                          children: [
                            currentUser.userId! == widget.profileId
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          if (userCartController
                                                      .venDor.value.active ==
                                                  true ||
                                              authState.userModel!.email ==
                                                  'viewducts@gmail.com') {
                                            Get.to(() =>
                                                AddProductPageResponsiveView(
                                                  isTweet: true,
                                                ));
                                            await feedState.addProductIncartTotalPrice(
                                                userCartController
                                                        .subscriptionModel
                                                        .firstWhere(
                                                            (data) =>
                                                                data.subType ==
                                                                'product',
                                                            orElse: () =>
                                                                SubscriptionViewDuctsModel())
                                                        .price!
                                                        .toDouble() *
                                                    userCartController
                                                        .exchangeRate
                                                        .firstWhere(
                                                            (curr) =>
                                                                curr.currency ==
                                                                'dollar',
                                                            orElse: () =>
                                                                ExchangeRateModel())
                                                        .rate!
                                                        .toDouble(),
                                                authState.appUser!.$id,
                                                '');
                                          } else {
                                            // Get.to(
                                            //     () =>
                                            //         SellersSignUpPageResponsiveView(
                                            //             loginCallback: authState
                                            //                 .getCurrentUser),
                                            //     transition:
                                            //         Transition.downToUp);
                                            //   _sendingMails();
                                            _showDialog(context);
                                            // if (await canLaunchUrl(
                                            //     emailLaunchUri)) {
                                            //   launchUrl(emailLaunchUri);
                                            // }
                                          }
                                        },
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(
                                              // currentUser.email ==
                                              //         'viewducts@gmail.com'
                                              //     ?
                                              CupertinoIcons.add,
                                              // : userCartController.venDor
                                              //             .value.active ==
                                              //         false
                                              //     ? CupertinoIcons
                                              //         .arrow_2_squarepath
                                              //     : CupertinoIcons.add,
                                              size: Get.height * 0.05,
                                              color: CupertinoColors.black,
                                            ),
                                            Container(
                                                // width:
                                                //    Get.width * 0.3,
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
                                                    color:
                                                        // userCartController
                                                        //             .venDor
                                                        //             .value
                                                        //             .active !=
                                                        //         true
                                                        //     ? CupertinoColors
                                                        //         .systemGreen
                                                        //     :
                                                        CupertinoColors
                                                            .systemYellow),
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Text(
                                                  // authState.userModel!.email ==
                                                  //         'viewducts@gmail.com'
                                                  //     ? 'Add Product'
                                                  //     : userCartController
                                                  //                 .venDor
                                                  //                 .value
                                                  //                 .active ==
                                                  //             false
                                                  //         ? 'Subscribe'
                                                  //         : userCartController
                                                  //                     .venDor
                                                  //                     .value
                                                  //                     .active ==
                                                  //                 null
                                                  //             ?
                                                  'Setup View',
                                                  // :
                                                  //  'Add Product',
                                                  style: TextStyle(
                                                      color: CupertinoColors
                                                          .darkBackgroundGray,
                                                      fontWeight:
                                                          FontWeight.w900),
                                                )),
                                          ],
                                        ),
                                      ),
                                      // userCartController.venDor.value.active !=
                                      //             true ||
                                      currentUser.email != 'viewducts@gmail.com'
                                          ? Container()
                                          : GestureDetector(
                                              onTap: () {
                                                showModalBottomSheet(
                                                    // backgroundColor: TwitterColor.mystic,
                                                    //bounce: true,
                                                    context: context,
                                                    builder:
                                                        (context) => Scaffold(
                                                              body: SafeArea(
                                                                  child:
                                                                      Responsive(
                                                                mobile: Stack(
                                                                  children: [
                                                                    SingleChildScrollView(
                                                                      scrollDirection:
                                                                          Axis.vertical,
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Icon(
                                                                                CupertinoIcons.person,
                                                                                // size: Get.height * 0.1,
                                                                                color: CupertinoColors.extraLightBackgroundGray,
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(4.0),
                                                                                child: Container(
                                                                                    // width:
                                                                                    //    Get.width * 0.3,
                                                                                    decoration: BoxDecoration(boxShadow: [
                                                                                      BoxShadow(offset: const Offset(0, 11), blurRadius: 11, color: Colors.black.withOpacity(0.06))
                                                                                    ], borderRadius: BorderRadius.circular(18), color: CupertinoColors.systemOrange),
                                                                                    padding: const EdgeInsets.all(5.0),
                                                                                    child: Text(
                                                                                      'Customers orders',
                                                                                      style: TextStyle(color: CupertinoColors.darkBackgroundGray, fontWeight: FontWeight.w900),
                                                                                    )),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          // Obx(
                                                                          //   () =>
                                                                          //       // userCartController
                                                                          //       //               .orders.value.items!.length ==
                                                                          //       //           0 ||
                                                                          //       //       userCartController
                                                                          //       //           .orders.value.items!.isEmpty
                                                                          //       //   ? Container()
                                                                          //       //   :
                                                                          //       orderState.value.isEmpty
                                                                          //           ? Column(
                                                                          //               mainAxisAlignment: MainAxisAlignment.center,
                                                                          //               crossAxisAlignment: CrossAxisAlignment.center,
                                                                          //               children: [
                                                                          //                 SizedBox(
                                                                          //                   height: fullWidth(context) * 0.3,
                                                                          //                 ),
                                                                          //                 Container(
                                                                          //                   height: 100,
                                                                          //                   width: 100,
                                                                          //                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), image: const DecorationImage(image: AssetImage('assets/shopping-bag.png'))),
                                                                          //                 ),
                                                                          //                 Container(
                                                                          //                   decoration: BoxDecoration(
                                                                          //                     boxShadow: [
                                                                          //                       BoxShadow(offset: const Offset(0, 11), blurRadius: 11, color: Colors.black.withOpacity(0.06))
                                                                          //                     ],
                                                                          //                     borderRadius: BorderRadius.circular(18),
                                                                          //                   ),
                                                                          //                   child: Padding(
                                                                          //                     padding: const EdgeInsets.symmetric(horizontal: 30),
                                                                          //                     child: frostedWhite(
                                                                          //                       Align(
                                                                          //                         alignment: Alignment.topCenter,
                                                                          //                         child: SizedBox(
                                                                          //                           height: fullWidth(context) * 0.5,
                                                                          //                           child: const EmptyList(
                                                                          //                             'No Orders',
                                                                          //                             subTitle: 'When customer\s pays for orders it will be shown here',
                                                                          //                           ),
                                                                          //                         ),
                                                                          //                       ),
                                                                          //                     ),
                                                                          //                   ),
                                                                          //                 ),
                                                                          //               ],
                                                                          //             )
                                                                          //           : Column(
                                                                          //               children: orderState.value
                                                                          //                   .map((cartItem) => ProfileOrders(
                                                                          //                         cartItem: cartItem.obs,
                                                                          //                       ))
                                                                          //                   .toList(),
                                                                          //             ),
                                                                          // ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                tablet: Stack(
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  Icon(
                                                                                    CupertinoIcons.person,
                                                                                    // size: Get.height * 0.1,
                                                                                    color: CupertinoColors.extraLightBackgroundGray,
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.all(4.0),
                                                                                    child: Container(
                                                                                        // width:
                                                                                        //    Get.width * 0.3,
                                                                                        decoration: BoxDecoration(boxShadow: [
                                                                                          BoxShadow(offset: const Offset(0, 11), blurRadius: 11, color: Colors.black.withOpacity(0.06))
                                                                                        ], borderRadius: BorderRadius.circular(18), color: CupertinoColors.systemOrange),
                                                                                        padding: const EdgeInsets.all(5.0),
                                                                                        child: Text(
                                                                                          'Customers orders',
                                                                                          style: TextStyle(color: CupertinoColors.darkBackgroundGray, fontWeight: FontWeight.w900),
                                                                                        )),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              // Obx(
                                                                              //   () =>
                                                                              //       // userCartController
                                                                              //       //               .orders.value.items!.length ==
                                                                              //       //           0 ||
                                                                              //       //       userCartController
                                                                              //       //           .orders.value.items!.isEmpty
                                                                              //       //   ? Container()
                                                                              //       //   :
                                                                              //       Column(
                                                                              //     children: orderState.value
                                                                              //         .map((cartItem) => UserProfileOrders(
                                                                              //               cartItem: cartItem.obs,
                                                                              //             ))
                                                                              //         .toList(),
                                                                              //   ),
                                                                              // ),
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
                                                                      filter: ImageFilter.blur(
                                                                          sigmaX:
                                                                              4,
                                                                          sigmaY:
                                                                              4),
                                                                      child:
                                                                          Container(
                                                                        color: (Colors.white12)
                                                                            .withOpacity(0.1),
                                                                      ),
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        // Once our width is less then 1300 then it start showing errors
                                                                        // Now there is no error if our width is less then 1340

                                                                        Expanded(
                                                                          flex: Get.width > 1340
                                                                              ? 3
                                                                              : 5,
                                                                          child:
                                                                              PlainScaffold(),
                                                                        ),
                                                                        Expanded(
                                                                          flex: Get.width > 1340
                                                                              ? 8
                                                                              : 10,
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  Icon(
                                                                                    CupertinoIcons.person,
                                                                                    // size: Get.height * 0.1,
                                                                                    color: CupertinoColors.extraLightBackgroundGray,
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.all(4.0),
                                                                                    child: Container(
                                                                                        // width:
                                                                                        //    Get.width * 0.3,
                                                                                        decoration: BoxDecoration(boxShadow: [
                                                                                          BoxShadow(offset: const Offset(0, 11), blurRadius: 11, color: Colors.black.withOpacity(0.06))
                                                                                        ], borderRadius: BorderRadius.circular(18), color: CupertinoColors.systemOrange),
                                                                                        padding: const EdgeInsets.all(5.0),
                                                                                        child: Text(
                                                                                          'Customers orders',
                                                                                          style: TextStyle(color: CupertinoColors.darkBackgroundGray, fontWeight: FontWeight.w900),
                                                                                        )),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              // Obx(
                                                                              //   () =>
                                                                              //       // userCartController
                                                                              //       //               .orders.value.items!.length ==
                                                                              //       //           0 ||
                                                                              //       //       userCartController
                                                                              //       //           .orders.value.items!.isEmpty
                                                                              //       //   ? Container()
                                                                              //       //   :
                                                                              //       Column(
                                                                              //     children: orderState.value
                                                                              //         .map((cartItem) => UserProfileOrders(
                                                                              //               cartItem: cartItem.obs,
                                                                              //             ))
                                                                              //         .toList(),
                                                                              //   ),
                                                                              // ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          flex: Get.width > 1340
                                                                              ? 2
                                                                              : 4,
                                                                          child:
                                                                              PlainScaffold(),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              )),
                                                            ));
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    CupertinoIcons.person,
                                                    // size: Get.height * 0.1,
                                                    color: CupertinoColors
                                                        .activeOrange,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Container(
                                                        // width:
                                                        //    Get.width * 0.3,
                                                        decoration: BoxDecoration(
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
                                                            color: CupertinoColors
                                                                .systemOrange),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: Text(
                                                          'Customers orders',
                                                          style: TextStyle(
                                                              color: CupertinoColors
                                                                  .darkBackgroundGray,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900),
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                    ],
                                  )
                                : PostProductMenu(
                                    currentUser: currentUser,
                                  ),
                            // const Icon(CupertinoIcons.add_circled_solid),
                          ],
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class _TweetIconsRow extends StatefulWidget {
  final FeedModel? model;
  final Color? iconColor;
  final Color? iconEnableColor;
  final double? size;
  final bool isTweetDetail;
  final DuctType? type;
  const _TweetIconsRow(
      {Key? key,
      this.model,
      this.iconColor,
      this.iconEnableColor,
      this.size,
      this.isTweetDetail = false,
      this.type})
      : super(key: key);

  @override
  __TweetIconsRowState createState() => __TweetIconsRowState();
}

class __TweetIconsRowState extends State<_TweetIconsRow> {
  Widget _likeCommentsIcons(BuildContext context, FeedModel model) {
    //  var authState = Provider.of<AuthState>(context, listen: false);

    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.only(bottom: 0, top: 0, left: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              InkWell(
                  child: ImageIcon(
                    const AssetImage('assets/comment.png'),
                    size: 25,
                    color: Colors.blueGrey[300],
                  ),
                  onTap: () {
                    //  var state = Provider.of<FeedState>(context, listen: false);
                    feedState.setDuctToReply = model.obs;
                    Navigator.of(context).pushNamed('/ComposeTweetPage');
                  }),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.isTweetDetail ? '' : model.commentCount.toString(),
                ),
              )
            ],
          ),
          Row(
            children: [
              InkWell(
                  child: const Icon(CupertinoIcons.circle),
                  onTap: () {
                    DuctBottomSheet()
                        .openvDuctbottomSheet(context, widget.type, model);
                  }),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.isTweetDetail ? '' : model.vductCount.toString(),
                ),
              )
            ],
          ),

          _iconWidget(
            context,
            text: widget.isTweetDetail ? '' : model.likeCount.toString(),
            icon: model.likeList!.any((userId) => userId == authState.userId)
                ? AppIcon.heartFill
                : AppIcon.heartEmpty,
            onPressed: () {
              addLikeToDuct(context);
            },
            iconColor:
                model.likeList!.any((userId) => userId == authState.userId)
                    ? widget.iconEnableColor
                    : widget.iconColor,
            size: widget.size ?? 20,
          ),
          // _iconWidget(context, text: '', icon: null, sysIcon: Icons.share,
          //     onPressed: () {
          //   share('${model.description}',
          //       subject: '${model.user.displayName}\'s post');
          // }, iconColor: iconColor, size: size ?? 20),
          Row(
            children: [
              IconButton(
                  iconSize: 25,
                  icon: const Icon(CupertinoIcons.check_mark_circled),
                  onPressed: () {
                    // final model =
                    //     Provider.of<AppState>(context, listen: false);
                    // model.addProductToCart(product.id);
                  }),
              const Text(
                'N78',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontSize: 18),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconWidget(BuildContext context,
      {String? text,
      int? icon,
      Function? onPressed,
      IconData? sysIcon,
      Color? iconColor,
      double size = 20}) {
    return Expanded(
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: () {
              if (onPressed != null) onPressed();
            },
            icon: sysIcon != null
                ? Icon(sysIcon, color: iconColor, size: size)
                : customIcon(
                    context,
                    size: size,
                    icon: icon!,
                    istwitterIcon: true,
                    iconColor: iconColor,
                  ),
          ),
          customText(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: iconColor,
              fontSize: size - 5,
            ),
            context: context,
          ),
        ],
      ),
    );
  }

  void addLikeToDuct(BuildContext context) {
    // var state = Provider.of<FeedState>(context, listen: false);
    // var authState = Provider.of<AuthState>(context, listen: false);
    feedState.addLikeToDuct(widget.model!, authState.userId, widget.model!.key);
  }

  void onLikeTextPressed(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // isTweetDetail ? _timeWidget(context) : SizedBox(),
        // isTweetDetail ? _likeCommentWidget(context) : SizedBox(),
        _likeCommentsIcons(context, widget.model!)
      ],
    );
  }
}

// ignore_for_file: must_be_immutable, invalid_use_of_protected_member, file_names, unnecessary_null_comparison

import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:appwrite/appwrite.dart';
import 'package:badges/badges.dart' as bages;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
//import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:viewducts/admin/Admin_dashbord/responsive.dart';
import 'package:viewducts/app_theme/app_theme_constant.dart';
import 'package:viewducts/common/common.dart';
import 'package:viewducts/constants/constants.dart';
import 'package:viewducts/features/auth/controller/auth_controller.dart';
import 'package:viewducts/features/products/product_controller.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/page/common/general_dialog.dart';
import 'package:viewducts/page/responsiveView.dart';
import 'package:viewducts/state/appState.dart';
import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/duct/profile_orders.dart';
import 'package:viewducts/widgets/frosted.dart';
import 'package:viewducts/widgets/newWidget/emptyList.dart';
import 'package:viewducts/widgets/newWidget/title_text.dart';

class CartIcon extends ConsumerWidget {
  final AppState? model;
  bool? allProduct;
  ViewductsUser? currentUser;
  //final Rx<ViewProduct>? cart;
  final String? sellerId;
  final String? buyerId;
  final String? sellersName;
  int? orderType;
  CartIcon(
      {Key? key,
      this.model,
      //  this.cart,
      this.orderType,
      this.sellerId,
      this.sellersName,
      this.currentUser,
      this.allProduct,
      this.buyerId})
      : super(key: key);

  List<dynamic> bagItemList = [];

  FeedModel user = FeedModel();

  void listCartItems(BuildContext context, WidgetRef ref) async {
    final secondUser =
        ref.watch(userDetailsProvider(sellerId.toString())).value;
    Future.delayed(Duration(milliseconds: 400), () {
      ViewDialogs().customeDialog(context,
          height: fullHeight(context),
          width: fullWidth(context),
          isCart: true,
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                  height: fullHeight(context),
                  width: fullWidth(context),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Pallete.scafoldBacgroundColor),
                  child: Column(
                    children: [
                      // Container(
                      //   // height: fullHeight(context),
                      //   // width: fullWidth(context),
                      //   decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(18),
                      //       color: Pallete.scafoldBacgroundColor),
                      // )
                      Expanded(
                          child: GestureDetector(
                        onHorizontalDragUpdate: (details) {
                          // Note: Sensitivity is integer used when you don't want to mess up vertical drag
                          int sensitivity = 8;
                          if (details.delta.dx > sensitivity) {
                            // Right Swipe
                            Navigator.pop(context);
                          } else if (details.delta.dx < -sensitivity) {
                            Navigator.pop(context);

                            //Left Swipe
                          }
                        },
                        child: ShoppingCartResponsive(
                            cart: carts,
                            sellerId: sellerId,
                            buyerId: buyerId,
                            sellersName: sellersName),
                      ))
                    ],
                  )),
              Positioned(
                top: -10,
                left: 10,
                child: Container(
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
                  child: TitleText('Your Cart',
                      // color: Colors.white,
                      // fontSize: 16,
                      // fontWeight: FontWeight.w800,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
              Positioned(
                top: -10,
                right: 5,
                child: Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            offset: const Offset(0, 11),
                            blurRadius: 11,
                            color: Colors.black.withOpacity(0.06))
                      ],
                      borderRadius: BorderRadius.circular(20),
                      color: CupertinoColors.darkBackgroundGray),
                  padding: const EdgeInsets.all(5.0),
                  child: TitleText('${secondUser?.displayName ?? ''} View',
                      color: Pallete.scafoldBacgroundColor,
                      // fontSize: 16,
                      // fontWeight: FontWeight.w800,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
            ],
          ),
          dx: 0,
          dy: -1,
          horizontal: 16,
          vertical: 100);
    });
  }

  final RxList<OrderViewProduct> orders = RxList<OrderViewProduct>();

  void listOrdersItems(BuildContext context) async {
    showModalBottomSheet(
        backgroundColor: Colors.red,
        // bounce: true,
        context: context,
        builder: (context) => Scaffold(
              body: Stack(
                children: [
                  // frostedYellow(
                  //   Container(
                  //     height: Get.height,
                  //     width: Get.width,
                  //     decoration: BoxDecoration(
                  //       // borderRadius: BorderRadius.circular(100),
                  //       //color: Colors.blueGrey[50]
                  //       gradient: LinearGradient(
                  //         colors: [
                  //           Colors.yellow[100]!.withOpacity(0.3),
                  //           Colors.yellow[200]!.withOpacity(0.1),
                  //           Colors.yellowAccent[100]!.withOpacity(0.2)
                  //           // Color(0xfffbfbfb),
                  //           // Color(0xfff7f7f7),
                  //         ],
                  //         begin: Alignment.topCenter,
                  //         end: Alignment.bottomCenter,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(10),
                          child: frostedOrange(
                            Container(
                              width: Get.width * 0.4,
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
                        Material(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.transparent,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 3),
                              child: customText(
                                'Your Orders',
                                style: const TextStyle(
                                    color: Colors.black45,
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                        Obx(
                          () =>
                              // userCartController
                              //               .orders.value.items!.length ==
                              //           0 ||
                              //       userCartController
                              //           .orders.value.items!.isEmpty
                              //   ? Container()
                              //   :
                              orders.value.isEmpty || orders.value.length == 0
                                  ? Container()
                                  : Column(
                                      children: orders.value
                                          .map((cartItem) => UserProfileOrders(
                                              cartItem: cartItem.obs,
                                              currentUser!))
                                          .toList(),
                                    ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }

  final Rx<ViewProduct> carts = ViewProduct(products: []).obs;

  RealtimeSubscription? subscriptions;

  Widget build(BuildContext context, WidgetRef ref) {
    return allProduct == true
        ? ref.watch(getProductInCartProvider('${currentUser?.userId!}')).when(
              data: (cartList) {
                return ref
                    .watch(getCartStreamProvider('${currentUser?.userId!}'))
                    .when(
                      data: (data) {
                        if (data.events.contains(
                          'databases.*.collections.${AppwriteConstants.shoppingCartCollection}.documents.*.create',
                        )) {
                          cartList.insert(
                              0, CartItemModel.fromMap(data.payload));
                        } else if (data.events.contains(
                          'databases.*.collections.${AppwriteConstants.shoppingCartCollection}.documents.*.delete',
                        )) {
                          cartList.remove(CartItemModel.fromMap(data.payload));
                        } else if (data.events.contains(
                          'databases.*.collections.${AppwriteConstants.shoppingCartCollection}.documents.*.update',
                        )) {
                          // get id of original cart
                          final startingPoint =
                              data.events[0].lastIndexOf('documents.');
                          final endPoint =
                              data.events[0].lastIndexOf('.update');
                          final cartId = data.events[0]
                              .substring(startingPoint + 10, endPoint);

                          var cart = cartList
                              .where((element) => element.id == cartId)
                              .first;

                          final cartIndex = cartList.indexOf(cart);
                          cartList
                              .removeWhere((element) => element.id == cartId);

                          cart = CartItemModel.fromMap(data.payload);
                          cartList.insert(cartIndex, cart);
                        }

                        return Container(
                            child: cartList.isEmpty ||
                                    cartList == null ||
                                    cartList.length == 0
                                //  ? userCartController.orders.isEmpty
                                ? Container()
                                : Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              offset: const Offset(0, 11),
                                              blurRadius: 11,
                                              color: Colors.black
                                                  .withOpacity(0.06))
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: CupertinoColors
                                            .lightBackgroundGray),
                                    padding: const EdgeInsets.all(5.0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OpenContainer(
                                                        closedBuilder:
                                                            (context, action) {
                                                          return ChatlistPageResponsive(
                                                            isCart: true,
                                                          );
                                                        },
                                                        openBuilder:
                                                            (context, action) {
                                                          return ChatlistPageResponsive(
                                                            isCart: true,
                                                          );
                                                        },
                                                      )));
                                        },
                                        child: Badge(
                                          backgroundColor:
                                              CupertinoColors.systemOrange,
                                          label: Text(
                                            cartList.isEmpty ||
                                                    cartList.length == 0 ||
                                                    cartList == null
                                                ? ''
                                                : cartList.length.toString(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: context.responsiveValue(
                                                  mobile: Get.height * 0.015,
                                                  tablet: Get.height * 0.02,
                                                  desktop: Get.height * 0.02),
                                            ),
                                          ),
                                          child: Image.asset(
                                            'assets/carts.png',
                                            width: 50,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                            // }
                            // ),

                            );
                      },
                      error: (error, stackTrace) => ErrorText(
                        error: error.toString(),
                      ),
                      loading: () {
                        return Container(
                            child: cartList.isEmpty ||
                                    cartList == null ||
                                    cartList.length == 0
                                //  ? userCartController.orders.isEmpty
                                ? Container()
                                : Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              offset: const Offset(0, 11),
                                              blurRadius: 11,
                                              color: Colors.black
                                                  .withOpacity(0.06))
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: CupertinoColors
                                            .lightBackgroundGray
                                            .withOpacity(0.5)),
                                    padding: const EdgeInsets.all(5.0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OpenContainer(
                                                        closedBuilder:
                                                            (context, action) {
                                                          return ChatlistPageResponsive(
                                                            isCart: true,
                                                          );
                                                        },
                                                        openBuilder:
                                                            (context, action) {
                                                          return ChatlistPageResponsive(
                                                            isCart: true,
                                                          );
                                                        },
                                                      )));
                                        },
                                        child: Badge(
                                          backgroundColor:
                                              CupertinoColors.systemRed,
                                          label: Text(
                                            cartList.isEmpty ||
                                                    cartList.length == 0 ||
                                                    cartList == null
                                                ? ''
                                                : cartList.length.toString(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: context.responsiveValue(
                                                  mobile: Get.height * 0.015,
                                                  tablet: Get.height * 0.02,
                                                  desktop: Get.height * 0.02),
                                            ),
                                          ),
                                          child: Image.asset(
                                            'assets/carts.png',
                                            width: 50,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                            // }
                            // ),

                            );
                      },
                    );
              },
              error: (error, stackTrace) => ErrorText(
                error: error.toString(),
              ),
              loading: () => const Loader(),
            )
        : ref.watch(getProductsInCartByVendorsProvider(sellerId!)).when(
              data: (cart) => Container(
                  child: cart.isEmpty || cart == null || cart.length == 0
                      //  ? userCartController.orders.isEmpty
                      ? Container()
                      : Container(
                          width: 50,
                          height: 50,
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
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () => listCartItems(context, ref),
                              child: Badge(
                                backgroundColor: CupertinoColors.systemRed,
                                label: Text(
                                  cart.isEmpty ||
                                          cart.length == 0 ||
                                          cart == null
                                      ? ''
                                      : cart.length.toString(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: context.responsiveValue(
                                        mobile: Get.height * 0.015,
                                        tablet: Get.height * 0.02,
                                        desktop: Get.height * 0.02),
                                  ),
                                ),
                                child: Image.asset(
                                  'assets/carts.png',
                                  width: 50,
                                ),
                              ),
                            ),
                          ),
                        )
                  // }
                  // ),

                  ),
              error: (error, stackTrace) => Container(),
              loading: () => Container(),
            );
  }
}

class AdminNotificationForUsers extends StatelessWidget {
  const AdminNotificationForUsers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // userCartController.adminAnouncement();
    return
        // bagItemList.isEmpty || bagItemList == null
        //     ? Container()
        //     :
        GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  backgroundColor: Colors.red,
                  // bounce: true,
                  context: context,
                  builder: (context) => Scaffold(
                          body: Responsive(
                        mobile: Stack(
                          children: [
                            Stack(
                              children: [
                                // frostedYellow(
                                //   Container(
                                //     height: Get.height,
                                //     width: Get.width,
                                //     decoration: BoxDecoration(
                                //       // borderRadius: BorderRadius.circular(100),
                                //       //color: Colors.blueGrey[50]
                                //       gradient: LinearGradient(
                                //         colors: [
                                //           Colors.yellow[100]!.withOpacity(0.3),
                                //           Colors.yellow[200]!.withOpacity(0.1),
                                //           Colors.yellowAccent[100]!.withOpacity(0.2)
                                //           // Color(0xfffbfbfb),
                                //           // Color(0xfff7f7f7),
                                //         ],
                                //         begin: Alignment.topCenter,
                                //         end: Alignment.bottomCenter,
                                //       ),
                                //     ),
                                //   ),
                                // ),

                                SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Material(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.transparent,
                                        child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 3),
                                            child: customText(
                                              'Notification',
                                              style: const TextStyle(
                                                  //color: Colors.black45,
                                                  fontSize: 35,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                      ),
                                      // Obx(() => userCartController.announce ==
                                      //             null ||
                                      //         userCartController
                                      //             .announce.isEmpty
                                      //     ? Column(
                                      //         mainAxisAlignment:
                                      //             MainAxisAlignment.center,
                                      //         crossAxisAlignment:
                                      //             CrossAxisAlignment.center,
                                      //         children: [
                                      //           SizedBox(
                                      //             height: Get.height * 0.15,
                                      //           ),
                                      //           Container(
                                      //             height: 100,
                                      //             width: 100,
                                      //             decoration: BoxDecoration(
                                      //                 borderRadius:
                                      //                     BorderRadius.circular(
                                      //                         100),
                                      //                 image: const DecorationImage(
                                      //                     image: AssetImage(
                                      //                         'assets/shopping-bag.png'))),
                                      //           ),
                                      //           Container(
                                      //             decoration: BoxDecoration(
                                      //               boxShadow: [
                                      //                 BoxShadow(
                                      //                     offset: const Offset(
                                      //                         0, 11),
                                      //                     blurRadius: 11,
                                      //                     color: Colors.black
                                      //                         .withOpacity(
                                      //                             0.06))
                                      //               ],
                                      //               borderRadius:
                                      //                   BorderRadius.circular(
                                      //                       18),
                                      //             ),
                                      //             child: Padding(
                                      //               padding: const EdgeInsets
                                      //                       .symmetric(
                                      //                   horizontal: 30),
                                      //               child: frostedWhite(
                                      //                 Align(
                                      //                   alignment:
                                      //                       Alignment.topCenter,
                                      //                   child: SizedBox(
                                      //                     height:
                                      //                         Get.height * 0.3,
                                      //                     child:
                                      //                         const EmptyList(
                                      //                       'No Notification',
                                      //                       subTitle:
                                      //                           'Updates from Viewducts will be Notified here',
                                      //                     ),
                                      //                   ),
                                      //                 ),
                                      //               ),
                                      //             ),
                                      //           ),
                                      //         ],
                                      //       )
                                      //     : Column(
                                      //         crossAxisAlignment:
                                      //             CrossAxisAlignment.start,
                                      //         children: userCartController
                                      //             .announce
                                      //             .map((text) => Container(
                                      //                 padding:
                                      //                     const EdgeInsets.all(
                                      //                         15),
                                      //                 margin:
                                      //                     const EdgeInsets.all(
                                      //                         10),
                                      //                 decoration: BoxDecoration(
                                      //                     boxShadow: [
                                      //                       BoxShadow(
                                      //                           offset:
                                      //                               const Offset(
                                      //                                   0, 11),
                                      //                           blurRadius: 11,
                                      //                           color: Colors
                                      //                               .black
                                      //                               .withOpacity(
                                      //                                   0.06))
                                      //                     ],
                                      //                     borderRadius:
                                      //                         BorderRadius
                                      //                             .circular(5),
                                      //                     color: CupertinoColors
                                      //                         .darkBackgroundGray),
                                      //                 child: Text(
                                      //                     text.announce
                                      //                         .toString(),
                                      //                     style: const TextStyle(
                                      //                         color: CupertinoColors
                                      //                             .systemYellow))))
                                      //             .toList(),
                                      //       ))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        tablet: Stack(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Stack(
                                    children: [
                                      // frostedYellow(
                                      //   Container(
                                      //     height: Get.height,
                                      //     width: Get.width,
                                      //     decoration: BoxDecoration(
                                      //       // borderRadius: BorderRadius.circular(100),
                                      //       //color: Colors.blueGrey[50]
                                      //       gradient: LinearGradient(
                                      //         colors: [
                                      //           Colors.yellow[100]!.withOpacity(0.3),
                                      //           Colors.yellow[200]!.withOpacity(0.1),
                                      //           Colors.yellowAccent[100]!.withOpacity(0.2)
                                      //           // Color(0xfffbfbfb),
                                      //           // Color(0xfff7f7f7),
                                      //         ],
                                      //         begin: Alignment.topCenter,
                                      //         end: Alignment.bottomCenter,
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),

                                      SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Material(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.transparent,
                                              child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 3),
                                                  child: customText(
                                                    'Notification',
                                                    style: const TextStyle(
                                                        //color: Colors.black45,
                                                        fontSize: 35,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                            ),
                                            // Obx(() => userCartController
                                            //                 .announce ==
                                            //             null ||
                                            //         userCartController
                                            //             .announce.isEmpty
                                            //     ? Column(
                                            //         mainAxisAlignment:
                                            //             MainAxisAlignment
                                            //                 .center,
                                            //         crossAxisAlignment:
                                            //             CrossAxisAlignment
                                            //                 .center,
                                            //         children: [
                                            //           SizedBox(
                                            //             height:
                                            //                 Get.height * 0.3,
                                            //           ),
                                            //           Container(
                                            //             height: 100,
                                            //             width: 100,
                                            //             decoration: BoxDecoration(
                                            //                 borderRadius:
                                            //                     BorderRadius
                                            //                         .circular(
                                            //                             100),
                                            //                 image: const DecorationImage(
                                            //                     image: AssetImage(
                                            //                         'assets/shopping-bag.png'))),
                                            //           ),
                                            //           Container(
                                            //             decoration:
                                            //                 BoxDecoration(
                                            //               boxShadow: [
                                            //                 BoxShadow(
                                            //                     offset:
                                            //                         const Offset(
                                            //                             0, 11),
                                            //                     blurRadius: 11,
                                            //                     color: Colors
                                            //                         .black
                                            //                         .withOpacity(
                                            //                             0.06))
                                            //               ],
                                            //               borderRadius:
                                            //                   BorderRadius
                                            //                       .circular(18),
                                            //             ),
                                            //             child: Padding(
                                            //               padding:
                                            //                   const EdgeInsets
                                            //                           .symmetric(
                                            //                       horizontal:
                                            //                           30),
                                            //               child: frostedWhite(
                                            //                 Align(
                                            //                   alignment:
                                            //                       Alignment
                                            //                           .topCenter,
                                            //                   child: SizedBox(
                                            //                     height:
                                            //                         Get.height *
                                            //                             0.3,
                                            //                     child:
                                            //                         const EmptyList(
                                            //                       'No Notification',
                                            //                       subTitle:
                                            //                           'Updates from Viewducts will be Notified',
                                            //                     ),
                                            //                   ),
                                            //                 ),
                                            //               ),
                                            //             ),
                                            //           ),
                                            //         ],
                                            //       )
                                            //     : Column(
                                            //         crossAxisAlignment:
                                            //             CrossAxisAlignment
                                            //                 .start,
                                            //         children: userCartController
                                            //             .announce
                                            //             .map((text) => Container(
                                            //                 padding:
                                            //                     const EdgeInsets.all(
                                            //                         15),
                                            //                 margin:
                                            //                     const EdgeInsets.all(
                                            //                         10),
                                            //                 decoration: BoxDecoration(
                                            //                     color: Colors
                                            //                         .grey
                                            //                         .shade200,
                                            //                     borderRadius:
                                            //                         BorderRadius.circular(
                                            //                             30)),
                                            //                 child: Text(
                                            //                     text.announce.toString(),
                                            //                     style: const TextStyle(color: Colors.blueGrey))))
                                            //             .toList(),
                                            //       ))
                                          ],
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
                              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
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
                                    children: [
                                      // frostedYellow(
                                      //   Container(
                                      //     height: Get.height,
                                      //     width: Get.width,
                                      //     decoration: BoxDecoration(
                                      //       // borderRadius: BorderRadius.circular(100),
                                      //       //color: Colors.blueGrey[50]
                                      //       gradient: LinearGradient(
                                      //         colors: [
                                      //           Colors.yellow[100]!.withOpacity(0.3),
                                      //           Colors.yellow[200]!.withOpacity(0.1),
                                      //           Colors.yellowAccent[100]!.withOpacity(0.2)
                                      //           // Color(0xfffbfbfb),
                                      //           // Color(0xfff7f7f7),
                                      //         ],
                                      //         begin: Alignment.topCenter,
                                      //         end: Alignment.bottomCenter,
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),

                                      SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Material(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.transparent,
                                              child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 3),
                                                  child: customText(
                                                    'Notification',
                                                    style: const TextStyle(
                                                        //color: Colors.black45,
                                                        fontSize: 35,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                            ),
                                            // Obx(() => userCartController
                                            //                 .announce ==
                                            //             null ||
                                            //         userCartController
                                            //             .announce.isEmpty
                                            //     ? Column(
                                            //         mainAxisAlignment:
                                            //             MainAxisAlignment
                                            //                 .center,
                                            //         crossAxisAlignment:
                                            //             CrossAxisAlignment
                                            //                 .center,
                                            //         children: [
                                            //           SizedBox(
                                            //             height:
                                            //                 Get.height * 0.3,
                                            //           ),
                                            //           Container(
                                            //             height: 100,
                                            //             width: 100,
                                            //             decoration: BoxDecoration(
                                            //                 borderRadius:
                                            //                     BorderRadius
                                            //                         .circular(
                                            //                             100),
                                            //                 image: const DecorationImage(
                                            //                     image: AssetImage(
                                            //                         'assets/shopping-bag.png'))),
                                            //           ),
                                            //           Container(
                                            //             decoration:
                                            //                 BoxDecoration(
                                            //               boxShadow: [
                                            //                 BoxShadow(
                                            //                     offset:
                                            //                         const Offset(
                                            //                             0, 11),
                                            //                     blurRadius: 11,
                                            //                     color: Colors
                                            //                         .black
                                            //                         .withOpacity(
                                            //                             0.06))
                                            //               ],
                                            //               borderRadius:
                                            //                   BorderRadius
                                            //                       .circular(18),
                                            //             ),
                                            //             child: Padding(
                                            //               padding:
                                            //                   const EdgeInsets
                                            //                           .symmetric(
                                            //                       horizontal:
                                            //                           30),
                                            //               child: frostedWhite(
                                            //                 Align(
                                            //                   alignment:
                                            //                       Alignment
                                            //                           .topCenter,
                                            //                   child: SizedBox(
                                            //                     height:
                                            //                         Get.height *
                                            //                             0.3,
                                            //                     child:
                                            //                         const EmptyList(
                                            //                       'No Notification',
                                            //                       subTitle:
                                            //                           'Updates from Viewducts will be Notified',
                                            //                     ),
                                            //                   ),
                                            //                 ),
                                            //               ),
                                            //             ),
                                            //           ),
                                            //         ],
                                            //       )
                                            //     : Column(
                                            //         crossAxisAlignment:
                                            //             CrossAxisAlignment
                                            //                 .start,
                                            //         children: userCartController
                                            //             .announce
                                            //             .map((text) => Container(
                                            //                 padding:
                                            //                     const EdgeInsets.all(
                                            //                         15),
                                            //                 margin:
                                            //                     const EdgeInsets.all(
                                            //                         10),
                                            //                 decoration: BoxDecoration(
                                            //                     color: Colors
                                            //                         .grey
                                            //                         .shade200,
                                            //                     borderRadius:
                                            //                         BorderRadius.circular(
                                            //                             30)),
                                            //                 child: Text(
                                            //                     text.announce.toString(),
                                            //                     style: const TextStyle(color: Colors.blueGrey))))
                                            //             .toList(),
                                            //       ))
                                          ],
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
                      )));
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => ShoppingCart(),
              //   ),
              // );
            },
            child: Container()
            //  Obx(
            //   () => Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: userCartController.announce == null ||
            //             userCartController.announce.isEmpty
            //         ? Container()
            //         : Badge(
            //             badgeContent: Text(
            //               userCartController.announce.length.toString(),
            //               style: const TextStyle(color: Colors.white),
            //             ),
            //             child: Image.asset(
            //               'assets/notification-bell.png',
            //               width: 50,
            //             ),
            //           ),
            //   ),
            // )
            );
  }
}

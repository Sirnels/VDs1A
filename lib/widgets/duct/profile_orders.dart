// ignore_for_file: unrelated_type_equality_checks, unnecessary_null_comparison, invalid_use_of_protected_member

import 'dart:ui';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:viewducts/app_theme/app_theme_constant.dart';
import 'package:viewducts/common/common.dart';
import 'package:viewducts/features/auth/controller/auth_controller.dart';
import 'package:viewducts/features/products/product_controller.dart';
//import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:viewducts/helper/theme.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/page/message/item_Search_bar.dart';
import 'package:viewducts/page/responsive.dart';
import 'package:viewducts/page/responsiveView.dart';
import 'package:viewducts/page/settings/widgets/settingsRowWidget.dart';
//import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/duct/duct.dart';
import 'package:viewducts/widgets/duct/widgets/pdf_api.dart';
import 'package:viewducts/widgets/frosted.dart';
import 'package:viewducts/widgets/newWidget/title_text.dart';
import 'package:viewducts/widgets/review_dialog.dart';

class UserProfileOrders extends ConsumerStatefulWidget {
  final Rx<OrderViewProduct>? cartItem;
  final ViewductsUser currentUser;
  const UserProfileOrders(this.currentUser, {Key? key, this.cartItem})
      : super(key: key);

  @override
  ConsumerState<UserProfileOrders> createState() => _UserProfileOrdersState();
}

class _UserProfileOrdersState extends ConsumerState<UserProfileOrders> {
  Widget invoiceHeader() {
    return frostedYellow(
      Container(
        width: Get.width,
        //  width: ScreenConfig.deviceWidth,
        //height: ScreenConfig.getProportionalHeight(374),
        color: Pallete.scafoldBacgroundColor,
        padding: EdgeInsets.only(
          top: Get.width * 0.04,
          left: Get.width * 0.04,
          // right: ScreenConfig.getProportionalWidth(40)
        ),
        child: SingleChildScrollView(
            child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Get.height * 0.06,
                  ),
                  Text(
                    "Orders",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: Get.height * 0.06),
                  ),
                  // SizedBox(
                  //   height: Get.width * 0.04,
                  // ),
                  // topHeaderText("#20/07/1203"),
                  SizedBox(
                    height: Get.height * 0.04,
                  ),

                  // ignore: todo
                  // TODO: form get actual date and format it accondingly
                  Text(DateFormat.yMMMd()
                      .add_jm()
                      .format(widget.cartItem!.value.placedDate!.toDate()))
                ],
              ),
              SizedBox(
                height: Get.height * 0.04,
              ),
              SingleChildScrollView(
                child: SizedBox(
                  width: Get.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "assets/groceries.png",
                        height: Get.height * 0.1,
                      ),
                      SizedBox(width: Get.width * 0.7, child: addressColumn())
                    ],
                  ),
                ),
              )
            ],
          ),
        )),
      ),
    );
  }

  Column addressColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: const [
            Text(
              "Delivery address",
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Obx(
          () => Text(
            widget.cartItem!.value.shippingAddress.toString(),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        // Text("Kimihurura")
      ],
    );
  }

  Text topHeaderText(String label) {
    return Text(label,
        style: TextStyle(
            color: Colors.white.withOpacity(0.6), fontSize: Get.height * 0.04));
  }

  _orderList(
    BuildContext context,
  ) async {
    // final database = Databases(
    //   clientConnect(),
    // );
    // await database.listDocuments(
    //     databaseId: databaseId,
    //     collectionId: profileUserColl,
    //     queries: [Query.equal('key', cartItem!.value.sellerId)]
    //     //  queries: [query.Query.equal('key', ductId)]
    //     ).then((data) {
    //   if (data.documents.isNotEmpty) {
    //     var value =
    //         data.documents.map((e) => ViewductsUser.fromJson(e.data)).toList();

    //     searchState.vendorOrdersCountry = value.obs;
    //   }
    // });

    showModalBottomSheet(
        isScrollControlled: true,
        // backgroundColor: Pallete.scafoldBacgroundColor,
        // isDismissible: false,
        // bounce: true,
        context: context,
        builder: (context) => Container(
              height: fullHeight(context) * 0.96,
              width: fullWidth(context),
              child: Responsive(
                mobile: Stack(
                  children: [
                    Stack(
                      children: <Widget>[
                        SizedBox(
                          width: Get.width,
                          height: Get.height,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Expanded(
                                //   flex: 4,
                                //   child: CustomScrollView(
                                //     slivers: <Widget>[
                                //       CupertinoSliverNavigationBar(
                                //         backgroundColor: Colors.transparent,
                                //         leading: Container(),
                                //         largeTitle: Text(
                                //           'Placed Orders',
                                //           style: TextStyle(color: Colors.blueGrey[200]),
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                invoiceHeader(),
                                Stack(
                                  children: [
                                    Container(
                                      height: Get.height,
                                      width: Get.width,
                                      decoration: BoxDecoration(
                                        // borderRadius: BorderRadius.circular(100),
                                        //color: Colors.blueGrey[50]
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.yellow[100]!
                                                .withOpacity(0.3),
                                            Colors.yellow[200]!
                                                .withOpacity(0.1),
                                            Colors.yellowAccent[100]!
                                                .withOpacity(0.2)
                                            // Color(0xfffbfbfb),
                                            // Color(0xfff7f7f7),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
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
                                                  image: AssetImage(
                                                      'assets/ankara3.jpg'))),
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
                                                  image: AssetImage(
                                                      'assets/ankkara1.jpg'))),
                                        ),
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      child: Obx(
                                        () => Column(
                                          children: [
                                            // userCartController.venDor.value.active ==
                                            //             true ||
                                            //         authState.userModel?.email ==
                                            //             'viewducts@gmail.com' ||
                                            //         adminStaffController
                                            //                 .staff.value
                                            //                 .firstWhere((e) => e.id == authState.userId,
                                            //                     orElse:
                                            //                         adminStaffController
                                            //                             .staffRole)
                                            //                 .role ==
                                            //             'Admin' ||
                                            //         adminStaffController
                                            //                 .staff.value
                                            //                 .firstWhere((e) => e.id == authState.userId,
                                            //                     orElse:
                                            //                         adminStaffController
                                            //                             .staffRole)
                                            //                 .role ==
                                            //             'Sales Agent' ||
                                            //         adminStaffController
                                            //                 .staff.value
                                            //                 .firstWhere(
                                            //                     (e) =>
                                            //                         e.id ==
                                            //                         authState
                                            //                             .userId,
                                            //                     orElse:
                                            //                         adminStaffController
                                            //                             .staffRole)
                                            //                 .role ==
                                            //             'General Manager' ||
                                            widget.cartItem!.value.sellerId ==
                                                    widget.currentUser.userId
                                                ? Row(
                                                    children: [
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text("Item State:",
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: context.responsiveValue(
                                                                mobile:
                                                                    Get.height *
                                                                        0.03,
                                                                tablet:
                                                                    Get.height *
                                                                        0.03,
                                                                desktop:
                                                                    Get.height *
                                                                        0.03),
                                                          )),
                                                      SizedBox(
                                                        width: Get.width * 0.04,
                                                      ),
                                                      ViewDuctMenuHolder(
                                                        onPressed: () {},
                                                        menuItems: <
                                                            DuctFocusedMenuItem>[
                                                          DuctFocusedMenuItem(
                                                              title: const Text(
                                                                'Processing',
                                                                style:
                                                                    TextStyle(
                                                                  //fontSize: Get.width * 0.03,
                                                                  color: AppColor
                                                                      .darkGrey,
                                                                ),
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                // userCartController
                                                                //     .adminUsersOrdersStateUpdate(
                                                                //         cartItem!.value
                                                                //             .userId,
                                                                //         'processing',
                                                                //         cartItem!
                                                                //             .value
                                                                //             .key,
                                                                //         authState
                                                                //             .userId);
                                                              },
                                                              trailingIcon: const Icon(
                                                                  CupertinoIcons
                                                                      .printer)),
                                                          DuctFocusedMenuItem(
                                                              title: const Text(
                                                                'Order Confirm',
                                                                style:
                                                                    TextStyle(
                                                                  //fontSize: Get.width * 0.03,
                                                                  color: AppColor
                                                                      .darkGrey,
                                                                ),
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                // userCartController
                                                                //     .adminUsersOrdersStateUpdate(
                                                                //         cartItem!.value
                                                                //             .userId,
                                                                //         'confirm',
                                                                //         cartItem!
                                                                //             .value
                                                                //             .key,
                                                                //         authState
                                                                //             .userId);
                                                              },
                                                              trailingIcon: const Icon(
                                                                  CupertinoIcons
                                                                      .printer)),
                                                          DuctFocusedMenuItem(
                                                              title: const Text(
                                                                'Shipping',
                                                                style:
                                                                    TextStyle(
                                                                  //fontSize: Get.width * 0.03,
                                                                  color: AppColor
                                                                      .darkGrey,
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                // userCartController
                                                                //     .adminUsersOrdersStateUpdate(
                                                                //         cartItem!
                                                                //             .value
                                                                //             .userId,
                                                                //         'shipping',
                                                                //         cartItem!
                                                                //             .value
                                                                //             .key,
                                                                //         authState
                                                                //             .userId);
                                                              },
                                                              trailingIcon: const Icon(
                                                                  CupertinoIcons
                                                                      .shopping_cart)),
                                                          DuctFocusedMenuItem(
                                                              title: const Text(
                                                                'Delivered',
                                                                style:
                                                                    TextStyle(
                                                                  //fontSize: Get.width * 0.03,
                                                                  color: AppColor
                                                                      .darkGrey,
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                // userCartController
                                                                //     .adminUsersOrdersStateUpdate(
                                                                //         cartItem!.value
                                                                //             .userId,
                                                                //         'delivered',
                                                                //         cartItem!
                                                                //             .value
                                                                //             .key,
                                                                //         authState
                                                                //             .userId);
                                                              },
                                                              trailingIcon: const Icon(
                                                                  CupertinoIcons
                                                                      .shopping_cart)),
                                                        ],
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                          child: Container(
                                                            height:
                                                                Get.width * 0.1,

                                                            decoration:
                                                                BoxDecoration(
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
                                                              color: widget
                                                                          .cartItem!
                                                                          .value
                                                                          .orderState ==
                                                                      'shipping'
                                                                  ? Colors
                                                                      .yellow
                                                                  : widget.cartItem!.value
                                                                              .orderState ==
                                                                          'delivered'
                                                                      ? Colors
                                                                          .green[200]
                                                                      : iAccentColor2,
                                                            ),
                                                            // shape: RoundedRectangleBorder(
                                                            //     borderRadius:
                                                            //         BorderRadius.circular(18)),
                                                            child: Row(
                                                              children: [
                                                                const Icon(
                                                                    Icons.add),
                                                                widget.cartItem!.value
                                                                            .orderState ==
                                                                        'confirm'
                                                                    ? const Text(
                                                                        'Order Confirmed',
                                                                        style: TextStyle(
                                                                            //fontSize: 17.0,
                                                                            // color: Colors.white,
                                                                            ),
                                                                      )
                                                                    : widget.cartItem!.value.orderState ==
                                                                            'shipping'
                                                                        ? const Text(
                                                                            'Shipping',
                                                                            style: TextStyle(
                                                                                //fontSize: 17.0,
                                                                                // color: Colors.white,
                                                                                ),
                                                                          )
                                                                        : widget.cartItem!.value.orderState ==
                                                                                'delivered'
                                                                            ? const Text(
                                                                                'Delivered',
                                                                                style: TextStyle(
                                                                                    //  fontSize: 17.0,
                                                                                    // color: Colors.white,
                                                                                    ),
                                                                              )
                                                                            : widget.cartItem!.value.orderState == 'products recieved'
                                                                                ? const Text(
                                                                                    'Products Recieved',
                                                                                    style: TextStyle(
                                                                                        //  fontSize: 17.0,
                                                                                        // color: Colors.white,
                                                                                        ),
                                                                                  )
                                                                                : const Text(
                                                                                    'Processing',
                                                                                    style: TextStyle(
                                                                                        // fontSize: 17.0,
                                                                                        //color: Colors.white,
                                                                                        ),
                                                                                  )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                : Container(),
                                            Column(
                                              children: widget
                                                  .cartItem!.value.items!
                                                  .map((item) =>
                                                      ProfileItemImageOrders(
                                                        item: item,
                                                      ))
                                                  .toList(),
                                            ),
                                            ref
                                                .watch(userDetailsProvider(
                                                    widget.cartItem!.value
                                                        .sellerId
                                                        .toString()))
                                                .when(
                                                  data: (vendor) {
                                                    return Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Total: ",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.6),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      Get.height *
                                                                          0.02),
                                                            ),
                                                            SizedBox(
                                                              width: Get.width *
                                                                  0.04,
                                                            ),
                                                            Text(
                                                              NumberFormat
                                                                      .currency(
                                                                          name: vendor.location ==
                                                                                  'Nigeria'
                                                                              ? '₦'
                                                                              : vendor.location ==
                                                                                      null
                                                                                  ? ''
                                                                                  : '£')
                                                                  .format(double.parse(widget
                                                                      .cartItem!
                                                                      .value
                                                                      .totalPrice
                                                                      .toString())),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      Get.height *
                                                                          0.02),
                                                            ),
                                                            SizedBox(
                                                                height:
                                                                    Get.height *
                                                                        0.06)
                                                          ],
                                                        ),
                                                        SizedBox(
                                                            height: Get.height *
                                                                0.02),
                                                      ],
                                                    );
                                                  },
                                                  error: (error, stackTrace) =>
                                                      Container(),
                                                  loading: () => Container(),
                                                )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                //color: Colors.black,
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
                                            Pallete.scafoldBacgroundColor
                                                .withOpacity(0.1),
                                            Pallete.scafoldBacgroundColor
                                                .withOpacity(0.2),
                                            Pallete.scafoldBacgroundColor
                                                .withOpacity(0.3)
                                          ],
                                          // begin: Alignment.topCenter,
                                          // end: Alignment.bottomCenter,
                                        )),
                                    child: Row(
                                      children: [
                                        Material(
                                          elevation: 10,
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: CircleAvatar(
                                            radius: 14,
                                            backgroundColor: Colors.transparent,
                                            child: Image.asset(
                                                'assets/delicious.png'),
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
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                tablet: Stack(
                  children: [
                    Stack(
                      children: <Widget>[
                        SizedBox(
                          width: Get.width,
                          height: Get.height,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Expanded(
                                //   flex: 4,
                                //   child: CustomScrollView(
                                //     slivers: <Widget>[
                                //       CupertinoSliverNavigationBar(
                                //         backgroundColor: Colors.transparent,
                                //         leading: Container(),
                                //         largeTitle: Text(
                                //           'Placed Orders',
                                //           style: TextStyle(color: Colors.blueGrey[200]),
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                invoiceHeader(),
                                Stack(
                                  children: [
                                    Container(
                                      height: Get.height,
                                      width: Get.width,
                                      decoration: BoxDecoration(
                                        // borderRadius: BorderRadius.circular(100),
                                        //color: Colors.blueGrey[50]
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.yellow[100]!
                                                .withOpacity(0.3),
                                            Colors.yellow[200]!
                                                .withOpacity(0.1),
                                            Colors.yellowAccent[100]!
                                                .withOpacity(0.2)
                                            // Color(0xfffbfbfb),
                                            // Color(0xfff7f7f7),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
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
                                                  image: AssetImage(
                                                      'assets/ankara3.jpg'))),
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
                                                  image: AssetImage(
                                                      'assets/ankkara1.jpg'))),
                                        ),
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      child: Obx(
                                        () => Column(
                                          children: [
                                            // userCartController.venDor.value.active ==
                                            //             true ||
                                            //         authState.userModel?.email ==
                                            //             'viewducts@gmail.com' ||
                                            //         adminStaffController
                                            //                 .staff.value
                                            //                 .firstWhere((e) => e.id == authState.userId,
                                            //                     orElse:
                                            //                         adminStaffController
                                            //                             .staffRole)
                                            //                 .role ==
                                            //             'Admin' ||
                                            //         adminStaffController
                                            //                 .staff.value
                                            //                 .firstWhere((e) => e.id == authState.userId,
                                            //                     orElse:
                                            //                         adminStaffController
                                            //                             .staffRole)
                                            //                 .role ==
                                            //             'Sales Agent' ||
                                            //         adminStaffController
                                            //                 .staff.value
                                            //                 .firstWhere(
                                            //                     (e) =>
                                            //                         e.id ==
                                            //                         authState
                                            //                             .userId,
                                            //                     orElse:
                                            //                         adminStaffController
                                            //                             .staffRole)
                                            //                 .role ==
                                            //             'General Manager' ||
                                            widget.cartItem!.value.sellerId ==
                                                    widget.currentUser.userId
                                                ? Row(
                                                    children: [
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text("Item State:",
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: context.responsiveValue(
                                                                mobile:
                                                                    Get.height *
                                                                        0.03,
                                                                tablet:
                                                                    Get.height *
                                                                        0.03,
                                                                desktop:
                                                                    Get.height *
                                                                        0.03),
                                                          )),
                                                      SizedBox(
                                                        width: Get.width * 0.04,
                                                      ),
                                                      ViewDuctMenuHolder(
                                                        onPressed: () {},
                                                        menuItems: <
                                                            DuctFocusedMenuItem>[
                                                          DuctFocusedMenuItem(
                                                              title: const Text(
                                                                'Processing',
                                                                style:
                                                                    TextStyle(
                                                                  //fontSize: Get.width * 0.03,
                                                                  color: AppColor
                                                                      .darkGrey,
                                                                ),
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                // userCartController
                                                                //     .adminUsersOrdersStateUpdate(
                                                                //         cartItem!.value
                                                                //             .userId,
                                                                //         'processing',
                                                                //         cartItem!
                                                                //             .value
                                                                //             .key,
                                                                //         authState
                                                                //             .userId);
                                                              },
                                                              trailingIcon: const Icon(
                                                                  CupertinoIcons
                                                                      .printer)),
                                                          DuctFocusedMenuItem(
                                                              title: const Text(
                                                                'Order Confirm',
                                                                style:
                                                                    TextStyle(
                                                                  //fontSize: Get.width * 0.03,
                                                                  color: AppColor
                                                                      .darkGrey,
                                                                ),
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                // userCartController
                                                                //     .adminUsersOrdersStateUpdate(
                                                                //         cartItem!.value
                                                                //             .userId,
                                                                //         'confirm',
                                                                //         cartItem!
                                                                //             .value
                                                                //             .key,
                                                                //         authState
                                                                //             .userId);
                                                              },
                                                              trailingIcon: const Icon(
                                                                  CupertinoIcons
                                                                      .printer)),
                                                          DuctFocusedMenuItem(
                                                              title: const Text(
                                                                'Shipping',
                                                                style:
                                                                    TextStyle(
                                                                  //fontSize: Get.width * 0.03,
                                                                  color: AppColor
                                                                      .darkGrey,
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                // userCartController
                                                                //     .adminUsersOrdersStateUpdate(
                                                                //         cartItem!
                                                                //             .value
                                                                //             .userId,
                                                                //         'shipping',
                                                                //         cartItem!
                                                                //             .value
                                                                //             .key,
                                                                //         authState
                                                                //             .userId);
                                                              },
                                                              trailingIcon: const Icon(
                                                                  CupertinoIcons
                                                                      .shopping_cart)),
                                                          DuctFocusedMenuItem(
                                                              title: const Text(
                                                                'Delivered',
                                                                style:
                                                                    TextStyle(
                                                                  //fontSize: Get.width * 0.03,
                                                                  color: AppColor
                                                                      .darkGrey,
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                // userCartController
                                                                //     .adminUsersOrdersStateUpdate(
                                                                //         cartItem!.value
                                                                //             .userId,
                                                                //         'delivered',
                                                                //         cartItem!
                                                                //             .value
                                                                //             .key,
                                                                //         authState
                                                                //             .userId);
                                                              },
                                                              trailingIcon: const Icon(
                                                                  CupertinoIcons
                                                                      .shopping_cart)),
                                                        ],
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                          child: Container(
                                                            height:
                                                                Get.width * 0.1,

                                                            decoration:
                                                                BoxDecoration(
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
                                                              color: widget
                                                                          .cartItem!
                                                                          .value
                                                                          .orderState ==
                                                                      'shipping'
                                                                  ? Colors
                                                                      .yellow
                                                                  : widget.cartItem!.value
                                                                              .orderState ==
                                                                          'delivered'
                                                                      ? Colors
                                                                          .green[200]
                                                                      : iAccentColor2,
                                                            ),
                                                            // shape: RoundedRectangleBorder(
                                                            //     borderRadius:
                                                            //         BorderRadius.circular(18)),
                                                            child: Row(
                                                              children: [
                                                                const Icon(
                                                                    Icons.add),
                                                                widget.cartItem!.value
                                                                            .orderState ==
                                                                        'confirm'
                                                                    ? const Text(
                                                                        'Order Confirmed',
                                                                        style: TextStyle(
                                                                            //fontSize: 17.0,
                                                                            // color: Colors.white,
                                                                            ),
                                                                      )
                                                                    : widget.cartItem!.value.orderState ==
                                                                            'shipping'
                                                                        ? const Text(
                                                                            'Shipping',
                                                                            style: TextStyle(
                                                                                //fontSize: 17.0,
                                                                                // color: Colors.white,
                                                                                ),
                                                                          )
                                                                        : widget.cartItem!.value.orderState ==
                                                                                'delivered'
                                                                            ? const Text(
                                                                                'Delivered',
                                                                                style: TextStyle(
                                                                                    //  fontSize: 17.0,
                                                                                    // color: Colors.white,
                                                                                    ),
                                                                              )
                                                                            : widget.cartItem!.value.orderState == 'products recieved'
                                                                                ? const Text(
                                                                                    'Products Recieved',
                                                                                    style: TextStyle(
                                                                                        //  fontSize: 17.0,
                                                                                        // color: Colors.white,
                                                                                        ),
                                                                                  )
                                                                                : const Text(
                                                                                    'Processing',
                                                                                    style: TextStyle(
                                                                                        // fontSize: 17.0,
                                                                                        //color: Colors.white,
                                                                                        ),
                                                                                  )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )
                                                : Container(),
                                            Column(
                                              children: widget
                                                  .cartItem!.value.items!
                                                  .map((item) =>
                                                      ProfileItemImageOrders(
                                                        item: item,
                                                      ))
                                                  .toList(),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "Total: ",
                                                      style: TextStyle(
                                                          color: Colors.black
                                                              .withOpacity(0.6),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: Get.height *
                                                              0.02),
                                                    ),
                                                    SizedBox(
                                                      width: Get.width * 0.04,
                                                    ),
                                                    Text(
                                                      NumberFormat.currency(
                                                              name: widget.currentUser
                                                                          .location ==
                                                                      'Nigeria'
                                                                  ? '₦'
                                                                  : '£')
                                                          .format(double.parse(
                                                              widget
                                                                  .cartItem!
                                                                  .value
                                                                  .totalPrice
                                                                  .toString())),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: Get.height *
                                                              0.02),
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            Get.height * 0.06)
                                                  ],
                                                ),
                                                SizedBox(
                                                    height: Get.height * 0.02),
                                              ],
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
                        ),
                        Positioned(
                          top: 10,
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
                        ),
                      ],
                    )
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
                              Stack(
                                children: <Widget>[
                                  SizedBox(
                                    width: Get.width,
                                    height: Get.height,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Expanded(
                                          //   flex: 4,
                                          //   child: CustomScrollView(
                                          //     slivers: <Widget>[
                                          //       CupertinoSliverNavigationBar(
                                          //         backgroundColor: Colors.transparent,
                                          //         leading: Container(),
                                          //         largeTitle: Text(
                                          //           'Placed Orders',
                                          //           style: TextStyle(color: Colors.blueGrey[200]),
                                          //         ),
                                          //       ),
                                          //     ],
                                          //   ),
                                          // ),
                                          invoiceHeader(),
                                          Stack(
                                            children: [
                                              Container(
                                                height: Get.height,
                                                width: Get.width,
                                                decoration: BoxDecoration(
                                                  // borderRadius: BorderRadius.circular(100),
                                                  //color: Colors.blueGrey[50]
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Colors.yellow[100]!
                                                          .withOpacity(0.3),
                                                      Colors.yellow[200]!
                                                          .withOpacity(0.1),
                                                      Colors.yellowAccent[100]!
                                                          .withOpacity(0.2)
                                                      // Color(0xfffbfbfb),
                                                      // Color(0xfff7f7f7),
                                                    ],
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: 0,
                                                right: -250,
                                                child: Transform.rotate(
                                                  angle: 90,
                                                  child: Container(
                                                    height: fullWidth(context) *
                                                        0.8,
                                                    width: fullWidth(context),
                                                    decoration: const BoxDecoration(
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                                'assets/ankara3.jpg'))),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 40,
                                                right: -260,
                                                child: Transform.rotate(
                                                  angle: 30,
                                                  child: Container(
                                                    height: fullWidth(context) *
                                                        0.8,
                                                    width: fullWidth(context),
                                                    decoration: const BoxDecoration(
                                                        image: DecorationImage(
                                                            image: AssetImage(
                                                                'assets/ankkara1.jpg'))),
                                                  ),
                                                ),
                                              ),
                                              SingleChildScrollView(
                                                child: Obx(
                                                  () => Column(
                                                    children: [
                                                      // userCartController
                                                      //                 .venDor
                                                      //                 .value
                                                      //                 .active ==
                                                      //             true ||
                                                      //         authState.userModel?.email ==
                                                      //             'viewducts@gmail.com' ||
                                                      //         adminStaffController
                                                      //                 .staff.value
                                                      //                 .firstWhere((e) => e.id == authState.userId,
                                                      //                     orElse: adminStaffController
                                                      //                         .staffRole)
                                                      //                 .role ==
                                                      //             'Admin' ||
                                                      //         adminStaffController
                                                      //                 .staff.value
                                                      //                 .firstWhere((e) => e.id == authState.userId,
                                                      //                     orElse: adminStaffController
                                                      //                         .staffRole)
                                                      //                 .role ==
                                                      //             'Sales Agent' ||
                                                      //         adminStaffController
                                                      //                 .staff.value
                                                      //                 .firstWhere((e) => e.id == authState.userId, orElse: adminStaffController.staffRole)
                                                      //                 .role ==
                                                      //             'General Manager' ||
                                                      widget.cartItem!.value
                                                                  .sellerId ==
                                                              widget.currentUser
                                                                  .userId
                                                          ? Row(
                                                              children: [
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Text(
                                                                    "Item State:",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize: context.responsiveValue(
                                                                          mobile: Get.height *
                                                                              0.03,
                                                                          tablet: Get.height *
                                                                              0.03,
                                                                          desktop:
                                                                              Get.height * 0.03),
                                                                    )),
                                                                SizedBox(
                                                                  width:
                                                                      Get.width *
                                                                          0.04,
                                                                ),
                                                                ViewDuctMenuHolder(
                                                                  onPressed:
                                                                      () {},
                                                                  menuItems: <
                                                                      DuctFocusedMenuItem>[
                                                                    DuctFocusedMenuItem(
                                                                        title:
                                                                            const Text(
                                                                          'Processing',
                                                                          style:
                                                                              TextStyle(
                                                                            //fontSize: Get.width * 0.03,
                                                                            color:
                                                                                AppColor.darkGrey,
                                                                          ),
                                                                        ),
                                                                        onPressed:
                                                                            () async {
                                                                          // userCartController.adminUsersOrdersStateUpdate(
                                                                          //     cartItem!.value.userId,
                                                                          //     'processing',
                                                                          //     cartItem!.value.key,
                                                                          //     authState.userId);
                                                                        },
                                                                        trailingIcon:
                                                                            const Icon(CupertinoIcons.printer)),
                                                                    DuctFocusedMenuItem(
                                                                        title:
                                                                            const Text(
                                                                          'Order Confirm',
                                                                          style:
                                                                              TextStyle(
                                                                            //fontSize: Get.width * 0.03,
                                                                            color:
                                                                                AppColor.darkGrey,
                                                                          ),
                                                                        ),
                                                                        onPressed:
                                                                            () async {
                                                                          // userCartController.adminUsersOrdersStateUpdate(
                                                                          //     cartItem!.value.userId,
                                                                          //     'confirm',
                                                                          //     cartItem!.value.key,
                                                                          //     authState.userId);
                                                                        },
                                                                        trailingIcon:
                                                                            const Icon(CupertinoIcons.printer)),
                                                                    DuctFocusedMenuItem(
                                                                        title:
                                                                            const Text(
                                                                          'Shipping',
                                                                          style:
                                                                              TextStyle(
                                                                            //fontSize: Get.width * 0.03,
                                                                            color:
                                                                                AppColor.darkGrey,
                                                                          ),
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          // userCartController.adminUsersOrdersStateUpdate(
                                                                          //     cartItem!.value.userId,
                                                                          //     'shipping',
                                                                          //     cartItem!.value.key,
                                                                          //     authState.userId);
                                                                        },
                                                                        trailingIcon:
                                                                            const Icon(CupertinoIcons.shopping_cart)),
                                                                    DuctFocusedMenuItem(
                                                                        title:
                                                                            const Text(
                                                                          'Delivered',
                                                                          style:
                                                                              TextStyle(
                                                                            //fontSize: Get.width * 0.03,
                                                                            color:
                                                                                AppColor.darkGrey,
                                                                          ),
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          // userCartController.adminUsersOrdersStateUpdate(
                                                                          //     cartItem!.value.userId,
                                                                          //     'delivered',
                                                                          //     cartItem!.value.key,
                                                                          //     authState.userId);
                                                                        },
                                                                        trailingIcon:
                                                                            const Icon(CupertinoIcons.shopping_cart)),
                                                                  ],
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            4.0),
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          Get.width *
                                                                              0.1,

                                                                      decoration:
                                                                          BoxDecoration(
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                              offset: const Offset(0, 11),
                                                                              blurRadius: 11,
                                                                              color: Colors.black.withOpacity(0.06))
                                                                        ],
                                                                        borderRadius:
                                                                            BorderRadius.circular(18),
                                                                        color: widget.cartItem!.value.orderState ==
                                                                                'shipping'
                                                                            ? Colors.yellow
                                                                            : widget.cartItem!.value.orderState == 'delivered'
                                                                                ? Colors.green[200]
                                                                                : iAccentColor2,
                                                                      ),
                                                                      // shape: RoundedRectangleBorder(
                                                                      //     borderRadius:
                                                                      //         BorderRadius.circular(18)),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          const Icon(
                                                                              Icons.add),
                                                                          widget.cartItem!.value.orderState == 'confirm'
                                                                              ? const Text(
                                                                                  'Order Confirmed',
                                                                                  style: TextStyle(
                                                                                      //fontSize: 17.0,
                                                                                      // color: Colors.white,
                                                                                      ),
                                                                                )
                                                                              : widget.cartItem!.value.orderState == 'shipping'
                                                                                  ? const Text(
                                                                                      'Shipping',
                                                                                      style: TextStyle(
                                                                                          //fontSize: 17.0,
                                                                                          // color: Colors.white,
                                                                                          ),
                                                                                    )
                                                                                  : widget.cartItem!.value.orderState == 'delivered'
                                                                                      ? const Text(
                                                                                          'Delivered',
                                                                                          style: TextStyle(
                                                                                              //  fontSize: 17.0,
                                                                                              // color: Colors.white,
                                                                                              ),
                                                                                        )
                                                                                      : widget.cartItem!.value.orderState == 'products recieved'
                                                                                          ? const Text(
                                                                                              'Products Recieved',
                                                                                              style: TextStyle(
                                                                                                  //  fontSize: 17.0,
                                                                                                  // color: Colors.white,
                                                                                                  ),
                                                                                            )
                                                                                          : const Text(
                                                                                              'Processing',
                                                                                              style: TextStyle(
                                                                                                  // fontSize: 17.0,
                                                                                                  //color: Colors.white,
                                                                                                  ),
                                                                                            )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            )
                                                          : Container(),
                                                      Column(
                                                        children: widget
                                                            .cartItem!
                                                            .value
                                                            .items!
                                                            .map((item) =>
                                                                ProfileItemImageOrders(
                                                                  item: item,
                                                                ))
                                                            .toList(),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                "Total: ",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.6),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        Get.height *
                                                                            0.02),
                                                              ),
                                                              SizedBox(
                                                                width:
                                                                    Get.width *
                                                                        0.04,
                                                              ),
                                                              Text(
                                                                NumberFormat.currency(
                                                                        name: widget.currentUser.location ==
                                                                                'Nigeria'
                                                                            ? '₦'
                                                                            : '£')
                                                                    .format(double.parse(widget
                                                                        .cartItem!
                                                                        .value
                                                                        .totalPrice
                                                                        .toString())),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        Get.height *
                                                                            0.02),
                                                              ),
                                                              SizedBox(
                                                                  height:
                                                                      Get.height *
                                                                          0.06)
                                                            ],
                                                          ),
                                                          SizedBox(
                                                              height:
                                                                  Get.height *
                                                                      0.02),
                                                        ],
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
                                  ),
                                  Positioned(
                                    top: 10,
                                    left: 10,
                                    child: Material(
                                      elevation: 10,
                                      borderRadius: BorderRadius.circular(10),
                                      child: frostedOrange(
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.blueGrey[50],
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.yellow
                                                      .withOpacity(0.1),
                                                  Colors.white60
                                                      .withOpacity(0.2),
                                                  Colors.orange.withOpacity(0.3)
                                                ],
                                                // begin: Alignment.topCenter,
                                                // end: Alignment.bottomCenter,
                                              )),
                                          child: Row(
                                            children: [
                                              Material(
                                                elevation: 10,
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: CircleAvatar(
                                                  radius: 14,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  child: Image.asset(
                                                      'assets/delicious.png'),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 3),
                                                child: customTitleText(
                                                    'ViewDucts'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
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
              ),
            ));
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    // getData();
    // final currentUser = ref.watch(currentUserDetailsProvider).value;
    // userCartController.listenUserCommission(cartItem!.value.userId);
    return Responsive(
      mobile: Stack(
        children: [
          ViewDuctMenuHolder(
            onPressed: () {},
            menuItems: <DuctFocusedMenuItem>[
              DuctFocusedMenuItem(
                  title: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                      child: const Text(
                        'View Shopped Products',
                        style: TextStyle(
                          //fontSize: Get.width * 0.03,
                          color: AppColor.darkGrey,
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {
                    _orderList(
                      context,
                    );
                  },
                  trailingIcon: const Icon(CupertinoIcons.shopping_cart)),
            ],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                frostedWhite(
                  Container(
                      //height: ,
                      width: context.responsiveValue(
                          mobile: Get.height * 0.4,
                          tablet: Get.height * 0.4,
                          desktop: Get.height * 0.4),
                      padding: const EdgeInsets.only(top: 5, bottom: 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 11),
                              blurRadius: 11,
                              color: Colors.black.withOpacity(0.06))
                        ],
                        color: CupertinoColors.lightBackgroundGray,
                        gradient: LinearGradient(
                          colors: [
                            CupertinoColors.lightBackgroundGray
                                .withOpacity(0.1),
                            CupertinoColors.lightBackgroundGray
                                .withOpacity(0.2),
                            CupertinoColors.lightBackgroundGray.withOpacity(0.1)
                            // Color(0xfffbfbfb),
                            // Color(0xfff7f7f7),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      child: Material(
                        //color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        elevation: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
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
                                    child: Text("View>",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: context.responsiveValue(
                                              mobile: Get.height * 0.02,
                                              tablet: Get.height * 0.02,
                                              desktop: Get.height * 0.02),
                                        )),
                                  ),
                                ),
                                SizedBox(
                                  width: Get.height * 0.04,
                                ),
                                Container(
                                  height: Get.height * 0.04,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: widget.cartItem!.value.orderState ==
                                            'shipping'
                                        ? Colors.yellow
                                        : widget.cartItem!.value.orderState ==
                                                'delivered'
                                            ? Colors.green[200]
                                            : iAccentColor2,
                                  ),

                                  // shape: RoundedRectangleBorder(
                                  //     borderRadius: BorderRadius.circular(18)),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.add),
                                      widget.cartItem!.value.orderState ==
                                              'confirm'
                                          ? const Text(
                                              'Order Confirmed',
                                              style: TextStyle(
                                                  //fontSize: 17.0,
                                                  // color: Colors.white,
                                                  ),
                                            )
                                          : widget.cartItem!.value.orderState ==
                                                  'shipping'
                                              ? const Text(
                                                  'Shipping',
                                                  style: TextStyle(
                                                      //fontSize: 17.0,
                                                      // color: Colors.white,
                                                      ),
                                                )
                                              : widget.cartItem!.value
                                                          .orderState ==
                                                      'delivered'
                                                  ? const Text(
                                                      'Delivered',
                                                      style: TextStyle(
                                                          //  fontSize: 17.0,
                                                          // color: Colors.white,
                                                          ),
                                                    )
                                                  : widget.cartItem!.value
                                                              .orderState ==
                                                          'products recieved'
                                                      ? const Text(
                                                          'Products Recieved',
                                                          style: TextStyle(
                                                              //  fontSize: 17.0,
                                                              // color: Colors.white,
                                                              ),
                                                        )
                                                      : const Text(
                                                          'Processing',
                                                          style: TextStyle(
                                                              // fontSize: 17.0,
                                                              //color: Colors.white,
                                                              ),
                                                        )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            OrderPostBar(
                              list: widget.cartItem!.value.items,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Shipping Method',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(widget.cartItem!.value.shippingMethod
                                      .toString()),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Order Date',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(DateFormat.yMMMd().add_jm().format(widget
                                          .cartItem!.value.placedDate!
                                          .toDate())
                                      // DateTime.parse(cartItem!.value.placedDate!
                                      //           .toDate()
                                      //           .toString())
                                      //       .toString()
                                      // timeago
                                      //     .format(
                                      //         cartItem!.value.placedDate!.toDate())
                                      //     .toString(),
                                      ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        offset: const Offset(0, 11),
                                        blurRadius: 11,
                                        color: Colors.black.withOpacity(0.06))
                                  ],
                                  //borderRadius: BorderRadius.circular(5),
                                  color: Color.fromARGB(255, 193, 187, 169)),
                              padding: const EdgeInsets.all(5.0),
                              child: SettingRowWidget(
                                NumberFormat.currency(
                                        name: widget.currentUser.location ==
                                                'Nigeria'
                                            ? '₦'
                                            : '£')
                                    .format(double.parse(
                                  '${widget.cartItem!.value.totalPrice ?? 0.0}',
                                )),
                                fontSize: context.responsiveValue(
                                    mobile: Get.height * 0.03,
                                    tablet: Get.height * 0.03,
                                    desktop: Get.height * 0.03),
                                onPressed: () {
                                  // _orderList(context);
                                },
                                fontWeight: FontWeight.bold,
                                textColor: CupertinoColors.white,
                                subtitle: 'Total Price',
                              ),
                            ),
                            // authState.userModel?.email ==
                            //             'viewducts@gmail.com' ||
                            //         adminStaffController.staff.value
                            //                 .firstWhere(
                            //                     (e) => e.id == authState.userId,
                            //                     orElse: adminStaffController
                            //                         .staffRole)
                            //                 .role ==
                            //             'Admin' ||
                            //         adminStaffController.staff.value
                            //                 .firstWhere(
                            //                     (e) => e.id == authState.userId,
                            //                     orElse: adminStaffController
                            //                         .staffRole)
                            //                 .role ==
                            //             'Sales Agent' ||
                            //         adminStaffController.staff.value
                            //                 .firstWhere(
                            //                     (e) => e.id == authState.userId,
                            //                     orElse: adminStaffController
                            //                         .staffRole)
                            //                 .role ==
                            //             'General Manager' ||
                            //         cartItem!.value.sellerId ==
                            //             authState.appUser!.$id
                            //     ? cartItem?.value.staff == null
                            //         ? Container()
                            //         :
                            // Padding(
                            //   padding: const EdgeInsets.all(5.0),
                            //   child: Container(
                            //       width: Get.width * 0.8,
                            //       decoration: BoxDecoration(
                            //           borderRadius: BorderRadius.circular(18),
                            //           color:
                            //               CupertinoColors.darkBackgroundGray),
                            //       padding: const EdgeInsets.all(5.0),
                            //       child: Row(
                            //         children: [
                            //           const Text(
                            //             'Handled by: ',
                            //             style: TextStyle(
                            //                 color: CupertinoColors.systemGrey,
                            //                 fontWeight: FontWeight.w700),
                            //           ),
                            //           // Text(
                            //           //   searchState.viewUserlist
                            //           //           .firstWhere(
                            //           //               (e) =>
                            //           //                   e.key ==
                            //           //                   cartItem!.value.staff
                            //           //                       .toString(),
                            //           //               orElse: () =>
                            //           //                   ViewductsUser())
                            //           //           .displayName ??
                            //           //       '',
                            //           //   style: const TextStyle(
                            //           //       color: CupertinoColors.systemYellow,
                            //           //       fontWeight: FontWeight.w700),
                            //           // ),
                            //         ],
                            //       )),
                            // ),
                            // : Container(),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(
                                  () => widget.cartItem!.value.userId ==
                                          widget.currentUser.userId
                                      ? widget.cartItem!.value.orderState ==
                                              'products recieved'
                                          ? Container(
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                        offset:
                                                            const Offset(0, 11),
                                                        blurRadius: 11,
                                                        color: Colors.black
                                                            .withOpacity(0.06))
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: CupertinoColors
                                                      .systemGreen),
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: TitleText(
                                                'Confirm',
                                                color: CupertinoColors
                                                    .lightBackgroundGray,
                                              ))
                                          : GestureDetector(
                                              onTap: () async {
                                                ref
                                                    .read(
                                                        productControllerProvider
                                                            .notifier)
                                                    .adminUsersOrdersStateUpdate(
                                                        widget.cartItem!.value
                                                            .userId,
                                                        'products recieved',
                                                        widget.cartItem!.value
                                                            .key,
                                                        widget
                                                            .currentUser.userId,
                                                        context);
                                                setState(() {});
                                                // await userCartController
                                                //     .adminUsersOrdersStateUpdate(
                                                //         cartItem!.value.userId,
                                                //         'products recieved',
                                                //         cartItem!.value.key,
                                                //         authState.userId);
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
                                                          .systemRed),
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: TitleText(
                                                    'Tap to confirm order recieved',
                                                    color: CupertinoColors
                                                        .lightBackgroundGray,
                                                  )),
                                            )
                                      : Container(),
                                ),
                                ref
                                    .watch(userDetailsProvider(widget
                                        .cartItem!.value.sellerId!
                                        .toString()))
                                    .when(
                                        data: (vendor) {
                                          return Container(
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                        offset:
                                                            const Offset(0, 11),
                                                        blurRadius: 11,
                                                        color: Colors.black
                                                            .withOpacity(0.06))
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: CupertinoColors
                                                      .lightBackgroundGray),
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: TitleText(
                                                vendor.displayName,
                                                color: CupertinoColors
                                                    .darkBackgroundGray,
                                              ));
                                        },
                                        error: (error, stackTrace) =>
                                            Container(),
                                        loading: () => Container())
                              ],
                            ),
                          ],
                        ),
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          )
        ],
      ),
      tablet: Stack(
        children: [
          Row(
            children: [
              Expanded(
                  child: ViewDuctMenuHolder(
                onPressed: () {},
                menuItems: <DuctFocusedMenuItem>[
                  DuctFocusedMenuItem(
                      title: const Text(
                        'Print Receipt',
                        style: TextStyle(
                          //fontSize: Get.width * 0.03,
                          color: AppColor.darkGrey,
                        ),
                      ),
                      onPressed: () async {
                        // final date = DateTime.now();
                        // final dueDate = date.add(const Duration(days: 14));

                        // final invoice = Invoice(
                        //     supplier: Supplier(
                        //       name: feedState.productlist!
                        //           .firstWhere(
                        //               (e) => e.key == cartItem!.value.userId)
                        //           .user!
                        //           .displayName
                        //           .toString(),
                        //       address: 'Sarah Street 9, Beijing, China',
                        //       paymentInfo: 'Paid Successfully',
                        //     ),
                        //     customer: Customer(
                        //       name: 'Apple Inc.',
                        //       address:
                        //           cartItem!.value.shippingAddress.toString(),
                        //     ),
                        //     info: InvoiceInfo(
                        //       date: date,
                        //       dueDate: dueDate,
                        //       description: 'My description...',
                        //       number: '${DateTime.now().year}-9999',
                        //     ),
                        //     items: cartItem!.value.items!
                        //         .map(
                        //           (orders) => InvoiceItem(
                        //             description: orders.name.toString(),
                        //             date: DateTime.now(),
                        //             quantity: orders.quantity as int,
                        //             vat: 0.19,
                        //             unitPrice:
                        //                 double.parse(orders.price.toString()),
                        //           ),
                        //         )
                        //         .toList());

                        // final pdfFile = await PdfInvoiceApi.generate(invoice);

                        // PdfApi.openFile(pdfFile);
                      },
                      trailingIcon: const Icon(CupertinoIcons.printer)),
                  DuctFocusedMenuItem(
                      title: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(0, 11),
                                    blurRadius: 11,
                                    color: Colors.black.withOpacity(0.06))
                              ],
                              borderRadius: BorderRadius.circular(18),
                              color: CupertinoColors.systemYellow),
                          padding: const EdgeInsets.all(5.0),
                          child: const Text(
                            'Orders',
                            style: TextStyle(
                              //fontSize: Get.width * 0.03,
                              color: AppColor.darkGrey,
                            ),
                          ),
                        ),
                      ),
                      onPressed: () {
                        // _orderList(
                        //   context,
                        // );
                      },
                      trailingIcon: const Icon(CupertinoIcons.shopping_cart)),
                ],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    frostedWhite(
                      Container(
                          //height: ,
                          width: context.responsiveValue(
                              mobile: Get.height * 0.45,
                              tablet: Get.height * 0.45,
                              desktop: Get.height * 0.45),
                          padding: const EdgeInsets.only(top: 5, bottom: 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 11),
                                  blurRadius: 11,
                                  color: Colors.black.withOpacity(0.06))
                            ],
                            color: Colors.white54,
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.1),
                                Colors.white.withOpacity(0.2),
                                Colors.white.withOpacity(0.1)
                                // Color(0xfffbfbfb),
                                // Color(0xfff7f7f7),
                              ],
                              // begin: Alignment.topCenter,
                              // end: Alignment.bottomCenter,
                            ),
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          child: Material(
                            //color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            elevation: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text("State",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: context.responsiveValue(
                                              mobile: Get.height * 0.03,
                                              tablet: Get.height * 0.03,
                                              desktop: Get.height * 0.03),
                                        )),
                                    SizedBox(
                                      width: Get.height * 0.04,
                                    ),
                                    Container(
                                      height: Get.height * 0.06,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color:
                                            widget.cartItem!.value.orderState ==
                                                    'shipping'
                                                ? Colors.yellow
                                                : widget.cartItem!.value
                                                            .orderState ==
                                                        'delivered'
                                                    ? Colors.green[200]
                                                    : iAccentColor2,
                                      ),

                                      // shape: RoundedRectangleBorder(
                                      //     borderRadius: BorderRadius.circular(18)),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.add),
                                          widget.cartItem!.value.orderState ==
                                                  'confirm'
                                              ? const Text(
                                                  'Order Confirmed',
                                                  style: TextStyle(
                                                      //fontSize: 17.0,
                                                      // color: Colors.white,
                                                      ),
                                                )
                                              : widget.cartItem!.value
                                                          .orderState ==
                                                      'shipping'
                                                  ? const Text(
                                                      'Shipping',
                                                      style: TextStyle(
                                                          //fontSize: 17.0,
                                                          // color: Colors.white,
                                                          ),
                                                    )
                                                  : widget.cartItem!.value
                                                              .orderState ==
                                                          'delivered'
                                                      ? const Text(
                                                          'Delivered',
                                                          style: TextStyle(
                                                              //  fontSize: 17.0,
                                                              // color: Colors.white,
                                                              ),
                                                        )
                                                      : widget.cartItem!.value
                                                                  .orderState ==
                                                              'products recieved'
                                                          ? const Text(
                                                              'Products Recieved',
                                                              style: TextStyle(
                                                                  //  fontSize: 17.0,
                                                                  // color: Colors.white,
                                                                  ),
                                                            )
                                                          : const Text(
                                                              'Processing',
                                                              style: TextStyle(
                                                                  // fontSize: 17.0,
                                                                  //color: Colors.white,
                                                                  ),
                                                            )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                OrderPostBar(
                                  list: widget.cartItem!.value.items,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Shipping Method',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(widget.cartItem!.value.shippingMethod
                                          .toString()),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Order Date',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(DateFormat.yMMMd().add_jm().format(
                                              widget.cartItem!.value.placedDate!
                                                  .toDate())
                                          // DateTime.parse(cartItem!.value.placedDate!
                                          //           .toDate()
                                          //           .toString())
                                          //       .toString()
                                          // timeago
                                          //     .format(
                                          //         cartItem!.value.placedDate!.toDate())
                                          //     .toString(),
                                          ),
                                    ],
                                  ),
                                ),
                                SettingRowWidget(
                                  NumberFormat.currency(
                                          name: widget.currentUser.location ==
                                                  'Nigeria'
                                              ? '₦'
                                              : '£')
                                      .format(double.parse(
                                    widget.cartItem!.value.totalPrice
                                        .toString(),
                                  )),
                                  fontSize: context.responsiveValue(
                                      mobile: Get.height * 0.04,
                                      tablet: Get.height * 0.04,
                                      desktop: Get.height * 0.04),
                                  onPressed: () {
                                    // _orderList(context);
                                  },
                                  fontWeight: FontWeight.bold,
                                  textColor: Colors.green,
                                  subtitle: 'Total Price',
                                ),
                                // authState.userModel?.email ==
                                //             'viewducts@gmail.com' ||
                                //         adminStaffController.staff.value
                                //                 .firstWhere(
                                //                     (e) =>
                                //                         e.id ==
                                //                         authState.userId,
                                //                     orElse: adminStaffController
                                //                         .staffRole)
                                //                 .role ==
                                //             'Admin' ||
                                //         adminStaffController.staff.value
                                //                 .firstWhere(
                                //                     (e) =>
                                //                         e.id ==
                                //                         authState.userId,
                                //                     orElse: adminStaffController
                                //                         .staffRole)
                                //                 .role ==
                                //             'Sales Agent' ||
                                //         adminStaffController.staff.value
                                //                 .firstWhere(
                                //                     (e) =>
                                //                         e.id ==
                                //                         authState.userId,
                                //                     orElse: adminStaffController
                                //                         .staffRole)
                                //                 .role ==
                                //             'General Manager' ||
                                //         cartItem!.value.sellerId ==
                                //             authState.appUser!.$id
                                //     ? cartItem?.value.staff == null
                                //         ? Container()
                                //         :
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                      width: Get.width * 0.8,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          color: CupertinoColors
                                              .darkBackgroundGray),
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        children: [
                                          const Text(
                                            'Handled by: ',
                                            style: TextStyle(
                                                color:
                                                    CupertinoColors.systemGrey,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          // Text(
                                          //   searchState.viewUserlist
                                          //           .firstWhere(
                                          //               (e) =>
                                          //                   e.key ==
                                          //                   cartItem!
                                          //                       .value.staff
                                          //                       .toString(),
                                          //               orElse: () =>
                                          //                   ViewductsUser())
                                          //           .displayName ??
                                          //       '',
                                          //   style: const TextStyle(
                                          //       color: CupertinoColors
                                          //           .systemYellow,
                                          //       fontWeight: FontWeight.w700),
                                          // ),
                                        ],
                                      )),
                                ),
                                //  : Container(),
                                Obx(
                                  () => widget.cartItem!.value.userId ==
                                          widget.currentUser.userId
                                      ? widget.cartItem!.value.orderState ==
                                              'products recieved'
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
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
                                                              18),
                                                      color: CupertinoColors
                                                          .systemGreen),
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: TitleText(
                                                    'Confirm',
                                                    color: CupertinoColors
                                                        .lightBackgroundGray,
                                                  )),
                                            )
                                          : GestureDetector(
                                              onTap: () async {
                                                FToast().init(Get.context!);
                                                // await userCartController
                                                //     .adminUsersOrdersStateUpdate(
                                                //         cartItem!.value.userId,
                                                //         'products recieved',
                                                //         cartItem!.value.key,
                                                //         authState.userId);
                                                FToast().showToast(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Container(
                                                          // width:
                                                          //    Get.width * 0.3,
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
                                                              color: CupertinoColors
                                                                  .activeGreen),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: Text(
                                                            'Orders Confirm',
                                                            style: TextStyle(
                                                                color: CupertinoColors
                                                                    .darkBackgroundGray,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900),
                                                          )),
                                                    ),
                                                    gravity:
                                                        ToastGravity.TOP_LEFT,
                                                    toastDuration:
                                                        Duration(seconds: 3));
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
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
                                                                .circular(18),
                                                        color: CupertinoColors
                                                            .systemRed),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: TitleText(
                                                      'Confirm Products Recieved',
                                                      color: CupertinoColors
                                                          .lightBackgroundGray,
                                                    )),
                                              ),
                                            )
                                      : Container(),
                                ),
                              ],
                            ),
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              )),
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
                  child: ViewDuctMenuHolder(
                    onPressed: () {},
                    menuItems: <DuctFocusedMenuItem>[
                      DuctFocusedMenuItem(
                          title: const Text(
                            'Print Receipt',
                            style: TextStyle(
                              //fontSize: Get.width * 0.03,
                              color: AppColor.darkGrey,
                            ),
                          ),
                          onPressed: () async {
                            // final date = DateTime.now();
                            // final dueDate = date.add(const Duration(days: 14));

                            // final invoice = Invoice(
                            //     supplier: Supplier(
                            //       name: feedState.productlist!
                            //           .firstWhere((e) =>
                            //               e.key == cartItem!.value.userId)
                            //           .user!
                            //           .displayName
                            //           .toString(),
                            //       address: 'Sarah Street 9, Beijing, China',
                            //       paymentInfo: 'Paid Successfully',
                            //     ),
                            //     customer: Customer(
                            //       name: 'Apple Inc.',
                            //       address: cartItem!.value.shippingAddress
                            //           .toString(),
                            //     ),
                            //     info: InvoiceInfo(
                            //       date: date,
                            //       dueDate: dueDate,
                            //       description: 'My description...',
                            //       number: '${DateTime.now().year}-9999',
                            //     ),
                            //     items: cartItem!.value.items!
                            //         .map(
                            //           (orders) => InvoiceItem(
                            //             description: orders.name.toString(),
                            //             date: DateTime.now(),
                            //             quantity: orders.quantity as int,
                            //             vat: 0.19,
                            //             unitPrice: double.parse(
                            //                 orders.price.toString()),
                            //           ),
                            //         )
                            //         .toList());

                            // final pdfFile =
                            //     await PdfInvoiceApi.generate(invoice);

                            // PdfApi.openFile(pdfFile);
                          },
                          trailingIcon: const Icon(CupertinoIcons.printer)),
                      DuctFocusedMenuItem(
                          title: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        offset: const Offset(0, 11),
                                        blurRadius: 11,
                                        color: Colors.black.withOpacity(0.06))
                                  ],
                                  borderRadius: BorderRadius.circular(18),
                                  color: CupertinoColors.systemYellow),
                              padding: const EdgeInsets.all(5.0),
                              child: const Text(
                                'Orders',
                                style: TextStyle(
                                  //fontSize: Get.width * 0.03,
                                  color: AppColor.darkGrey,
                                ),
                              ),
                            ),
                          ),
                          onPressed: () {
                            // _orderList(
                            //   context,
                            // );
                          },
                          trailingIcon:
                              const Icon(CupertinoIcons.shopping_cart)),
                    ],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        frostedWhite(
                          Container(
                              //height: ,
                              width: context.responsiveValue(
                                  mobile: Get.height * 0.45,
                                  tablet: Get.height * 0.45,
                                  desktop: Get.height * 0.45),
                              padding: const EdgeInsets.only(top: 5, bottom: 0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                      offset: const Offset(0, 11),
                                      blurRadius: 11,
                                      color: Colors.black.withOpacity(0.06))
                                ],
                                color: Colors.white54,
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.1),
                                    Colors.white.withOpacity(0.2),
                                    Colors.white.withOpacity(0.1)
                                    // Color(0xfffbfbfb),
                                    // Color(0xfff7f7f7),
                                  ],
                                  // begin: Alignment.topCenter,
                                  // end: Alignment.bottomCenter,
                                ),
                              ),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Material(
                                //color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                elevation: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text("State",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: context.responsiveValue(
                                                  mobile: Get.height * 0.03,
                                                  tablet: Get.height * 0.03,
                                                  desktop: Get.height * 0.03),
                                            )),
                                        SizedBox(
                                          width: Get.height * 0.04,
                                        ),
                                        Container(
                                          height: Get.height * 0.06,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: widget.cartItem!.value
                                                        .orderState ==
                                                    'shipping'
                                                ? Colors.yellow
                                                : widget.cartItem!.value
                                                            .orderState ==
                                                        'delivered'
                                                    ? Colors.green[200]
                                                    : iAccentColor2,
                                          ),

                                          // shape: RoundedRectangleBorder(
                                          //     borderRadius: BorderRadius.circular(18)),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.add),
                                              widget.cartItem!.value
                                                          .orderState ==
                                                      'confirm'
                                                  ? const Text(
                                                      'Order Confirmed',
                                                      style: TextStyle(
                                                          //fontSize: 17.0,
                                                          // color: Colors.white,
                                                          ),
                                                    )
                                                  : widget.cartItem!.value
                                                              .orderState ==
                                                          'shipping'
                                                      ? const Text(
                                                          'Shipping',
                                                          style: TextStyle(
                                                              //fontSize: 17.0,
                                                              // color: Colors.white,
                                                              ),
                                                        )
                                                      : widget.cartItem!.value
                                                                  .orderState ==
                                                              'delivered'
                                                          ? const Text(
                                                              'Delivered',
                                                              style: TextStyle(
                                                                  //  fontSize: 17.0,
                                                                  // color: Colors.white,
                                                                  ),
                                                            )
                                                          : widget
                                                                      .cartItem!
                                                                      .value
                                                                      .orderState ==
                                                                  'products recieved'
                                                              ? const Text(
                                                                  'Products Recieved',
                                                                  style: TextStyle(
                                                                      //  fontSize: 17.0,
                                                                      // color: Colors.white,
                                                                      ),
                                                                )
                                                              : const Text(
                                                                  'Processing',
                                                                  style: TextStyle(
                                                                      // fontSize: 17.0,
                                                                      //color: Colors.white,
                                                                      ),
                                                                )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    OrderPostBar(
                                      list: widget.cartItem!.value.items,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Shipping Method',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(widget
                                              .cartItem!.value.shippingMethod
                                              .toString()),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Order Date',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(DateFormat.yMMMd()
                                                  .add_jm()
                                                  .format(widget.cartItem!.value
                                                      .placedDate!
                                                      .toDate())
                                              // DateTime.parse(cartItem!.value.placedDate!
                                              //           .toDate()
                                              //           .toString())
                                              //       .toString()
                                              // timeago
                                              //     .format(
                                              //         cartItem!.value.placedDate!.toDate())
                                              //     .toString(),
                                              ),
                                        ],
                                      ),
                                    ),
                                    SettingRowWidget(
                                      NumberFormat.currency(
                                              name:
                                                  widget.currentUser.location ==
                                                          'Nigeria'
                                                      ? '₦'
                                                      : '£')
                                          .format(double.parse(
                                        widget.cartItem!.value.totalPrice
                                            .toString(),
                                      )),
                                      fontSize: context.responsiveValue(
                                          mobile: Get.height * 0.04,
                                          tablet: Get.height * 0.04,
                                          desktop: Get.height * 0.04),
                                      onPressed: () {
                                        // _orderList(context);
                                      },
                                      fontWeight: FontWeight.bold,
                                      textColor: Colors.green,
                                      subtitle: 'Total Price',
                                    ),
                                    // authState.userModel?.email ==
                                    //             'viewducts@gmail.com' ||
                                    //         adminStaffController.staff.value
                                    //                 .firstWhere(
                                    //                     (e) =>
                                    //                         e.id ==
                                    //                         authState.userId,
                                    //                     orElse:
                                    //                         adminStaffController
                                    //                             .staffRole)
                                    //                 .role ==
                                    //             'Admin' ||
                                    //         adminStaffController.staff.value
                                    //                 .firstWhere(
                                    //                     (e) =>
                                    //                         e.id ==
                                    //                         authState.userId,
                                    //                     orElse:
                                    //                         adminStaffController
                                    //                             .staffRole)
                                    //                 .role ==
                                    //             'Sales Agent' ||
                                    //         adminStaffController.staff.value
                                    //                 .firstWhere(
                                    //                     (e) =>
                                    //                         e.id ==
                                    //                         authState.userId,
                                    //                     orElse:
                                    //                         adminStaffController
                                    //                             .staffRole)
                                    //                 .role ==
                                    //             'General Manager' ||
                                    widget.cartItem!.value.sellerId ==
                                            widget.currentUser.userId
                                        ? widget.cartItem?.value.staff == null
                                            ? Container()
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Container(
                                                    width: Get.width * 0.8,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(18),
                                                        color: CupertinoColors
                                                            .darkBackgroundGray),
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Row(
                                                      children: [
                                                        const Text(
                                                          'Handled by: ',
                                                          style: TextStyle(
                                                              color:
                                                                  CupertinoColors
                                                                      .systemGrey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                        // Text(
                                                        //   searchState
                                                        //           .viewUserlist
                                                        //           .firstWhere(
                                                        //               (e) =>
                                                        //                   e.key ==
                                                        //                   cartItem!
                                                        //                       .value
                                                        //                       .staff
                                                        //                       .toString(),
                                                        //               orElse: () =>
                                                        //                   ViewductsUser())
                                                        //           .displayName ??
                                                        //       '',
                                                        //   style: const TextStyle(
                                                        //       color: CupertinoColors
                                                        //           .systemYellow,
                                                        //       fontWeight:
                                                        //           FontWeight
                                                        //               .w700),
                                                        // ),
                                                      ],
                                                    )),
                                              )
                                        : Container(),
                                    Obx(
                                      () => widget.cartItem!.value.userId ==
                                              widget.currentUser.userId
                                          ? widget.cartItem!.value.orderState ==
                                                  'products recieved'
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
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
                                                                  .circular(18),
                                                          color: CupertinoColors
                                                              .systemGreen),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: TitleText(
                                                        'Confirm',
                                                        color: CupertinoColors
                                                            .lightBackgroundGray,
                                                      )),
                                                )
                                              : GestureDetector(
                                                  onTap: () async {
                                                    FToast().init(Get.context!);
                                                    // await userCartController
                                                    //     .adminUsersOrdersStateUpdate(
                                                    //         cartItem!
                                                    //             .value.userId,
                                                    //         'products recieved',
                                                    //         cartItem!.value.key,
                                                    //         authState.userId);
                                                    FToast().showToast(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                          child: Container(
                                                              // width:
                                                              //    Get.width * 0.3,
                                                              decoration: BoxDecoration(
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                        offset: const Offset(
                                                                            0,
                                                                            11),
                                                                        blurRadius:
                                                                            11,
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(0.06))
                                                                  ],
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              18),
                                                                  color: CupertinoColors
                                                                      .activeGreen),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              child: Text(
                                                                'Orders Confirm',
                                                                style: TextStyle(
                                                                    color: CupertinoColors
                                                                        .darkBackgroundGray,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900),
                                                              )),
                                                        ),
                                                        gravity: ToastGravity
                                                            .TOP_LEFT,
                                                        toastDuration: Duration(
                                                            seconds: 3));
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Container(
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
                                                            color:
                                                                CupertinoColors
                                                                    .systemRed),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: TitleText(
                                                          'Confirm Products Recieved',
                                                          color: CupertinoColors
                                                              .lightBackgroundGray,
                                                        )),
                                                  ),
                                                )
                                          : Container(),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  )),
              Expanded(
                flex: Get.width > 1340 ? 2 : 4,
                child: PlainScaffold(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// class ScreenConfig {
//   static double? deviceWidth;
//   static double? deviceHeight;
//   static double designHeight = 1300;
//   static double designWidth = 600;
//   static init(BuildContext context) {
//     deviceWidth = MediaQuery.of(context).size.width;
//     deviceHeight = MediaQuery.of(context).size.height;
//   }

//   // Designer user 1300 device height,
//   // so I have to normalize to the device height
//   static double getProportionalHeight(height) {
//     return (height / designHeight) * deviceHeight;
//   }

//   static double getProportionalWidth(width) {
//     return (width / designWidth) * deviceWidth;
//   }
//}

// Colors
const iPrimarryColor = Color(0xFFF9FCFF);
const iAccentColor = Color(0xFFFFB44B);
const iAccentColor2 = Color(0xFFFFEAC9);

class Customer {
  final String name;
  final String address;

  const Customer({
    required this.name,
    required this.address,
  });
}

class Supplier {
  final String name;
  final String address;
  final String paymentInfo;

  const Supplier({
    required this.name,
    required this.address,
    required this.paymentInfo,
  });
}

class Invoice {
  final InvoiceInfo info;
  final Supplier supplier;
  final Customer customer;
  final List<InvoiceItem> items;

  const Invoice({
    required this.info,
    required this.supplier,
    required this.customer,
    required this.items,
  });
}

class InvoiceInfo {
  final String description;
  final String number;
  final DateTime date;
  final DateTime dueDate;

  const InvoiceInfo({
    required this.description,
    required this.number,
    required this.date,
    required this.dueDate,
  });
}

class InvoiceItem {
  final String description;
  final DateTime date;
  final int quantity;
  final double vat;
  final double unitPrice;

  const InvoiceItem({
    required this.description,
    required this.date,
    required this.quantity,
    required this.vat,
    required this.unitPrice,
  });
}

class Utils {
  static formatPrice(double price) => '\$ ${price.toStringAsFixed(2)}';
  static formatDate(DateTime date) => DateFormat.yMd().format(date);
}

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(40),
        ),
        child: FittedBox(
          child: Text(
            text,
            style: const TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
        onPressed: onClicked,
      );
}

class TitleWidget extends StatelessWidget {
  final IconData icon;
  final String text;

  const TitleWidget({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Icon(icon, size: 100, color: Colors.white),
          const SizedBox(height: 16),
          Text(
            text,
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
}

class PdfPage extends StatefulWidget {
  const PdfPage({Key? key}) : super(key: key);

  @override
  _PdfPageState createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Invoice'),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const TitleWidget(
                  icon: Icons.picture_as_pdf,
                  text: 'Generate Invoice',
                ),
                const SizedBox(height: 48),
                ButtonWidget(
                  text: 'Invoice PDF',
                  onClicked: () async {
                    final date = DateTime.now();
                    final dueDate = date.add(const Duration(days: 7));

                    final invoice = Invoice(
                      supplier: const Supplier(
                        name: 'Sarah Field',
                        address: 'Sarah Street 9, Beijing, China',
                        paymentInfo: 'https://paypal.me/sarahfieldzz',
                      ),
                      customer: const Customer(
                        name: 'Apple Inc.',
                        address: 'Apple Street, Cupertino, CA 95014',
                      ),
                      info: InvoiceInfo(
                        date: date,
                        dueDate: dueDate,
                        description: 'My description...',
                        number: '${DateTime.now().year}-9999',
                      ),
                      items: [
                        InvoiceItem(
                          description: 'Coffee',
                          date: DateTime.now(),
                          quantity: 3,
                          vat: 0.19,
                          unitPrice: 5.99,
                        ),
                        InvoiceItem(
                          description: 'Water',
                          date: DateTime.now(),
                          quantity: 8,
                          vat: 0.19,
                          unitPrice: 0.99,
                        ),
                        InvoiceItem(
                          description: 'Orange',
                          date: DateTime.now(),
                          quantity: 3,
                          vat: 0.19,
                          unitPrice: 2.99,
                        ),
                        InvoiceItem(
                          description: 'Apple',
                          date: DateTime.now(),
                          quantity: 8,
                          vat: 0.19,
                          unitPrice: 3.99,
                        ),
                        InvoiceItem(
                          description: 'Mango',
                          date: DateTime.now(),
                          quantity: 1,
                          vat: 0.19,
                          unitPrice: 1.59,
                        ),
                        InvoiceItem(
                          description: 'Blue Berries',
                          date: DateTime.now(),
                          quantity: 5,
                          vat: 0.19,
                          unitPrice: 0.99,
                        ),
                        InvoiceItem(
                          description: 'Lemon',
                          date: DateTime.now(),
                          quantity: 4,
                          vat: 0.19,
                          unitPrice: 1.29,
                        ),
                      ],
                    );

                    final pdfFile = await PdfInvoiceApi.generate(invoice);

                    PdfApi.openFile(pdfFile);
                  },
                ),
              ],
            ),
          ),
        ),
      );
}

class ProfileItemImageOrders extends ConsumerWidget {
  final OrderItemModel item;
  const ProfileItemImageOrders({Key? key, required this.item})
      : super(key: key);
  // getData() async {
  //   try {
  //     final database = Databases(
  //       clientConnect(),
  //     );

  //     await database
  //         .listDocuments(
  //       databaseId: databaseId,
  //       collectionId: procold,
  //     )
  //         .then((data) {
  //       // Map map = data.toMap();

  //       // var value =
  //       //     data.documents.map((e) => FeedModel.fromJson(e.data)).toList();
  //       //data.documents;
  //       // setState(() {
  //       feedState.productlist =
  //           data.documents.map((e) => FeedModel.fromJson(e.data)).toList().obs;
  //       //});
  //       // cprint('${data.documents.map((e) => FeedModel.fromJson(e.data))}');
  //       //cprint('${productlist?.value.map((e) => e.key)}');
  //     });

  //     //snap.documents;
  //   } on AppwriteException catch (e) {
  //     cprint("$e");
  //   }
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Storage storage = Storage(clientConnect());

    return ref.watch(getOneProductProvider('${item.productId}')).when(
        data: (product) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: Get.width * 0.45,
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
                color: iPrimarryColor,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: Get.width * 0.04),

                      //   addItemAction(),
                      // SizedBox(
                      //   height: Get.width *
                      //       0.04,
                      // ),
                      Container(
                        height: Get.width * 0.2,
                        padding:
                            EdgeInsets.symmetric(horizontal: Get.width * 0.04),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 11),
                                  blurRadius: 11,
                                  color: Colors.black.withOpacity(0.06))
                            ],
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.quantity.toString(),
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6),
                                  fontWeight: FontWeight.bold),
                            ),
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.transparent,
                              child: FutureBuilder(
                                future: storage.getFileView(
                                    bucketId: productBucketId,
                                    fileId: product.imagePath
                                        .toString()), //works for both public file and private file, for private files you need to be logged in
                                builder: (context, snapshot) {
                                  return snapshot.hasData &&
                                          snapshot.data != null
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
                                              backgroundColor:
                                                  Colors.transparent,

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
                            ),

                            Text(
                              '${item.name}',
                              style: TextStyle(
                                  color: Colors.black.withOpacity(0.6),
                                  fontWeight: FontWeight.bold),
                            ),
                            // SizedBox(
                            //   width: ScreenConfig.getProportionalWidth(145),
                            //   child: Text(
                            //     itemDesc,
                            //     style: TextStyle(color: Colors.black),
                            //   ),
                            // ),

                            Text(
                              NumberFormat.currency(
                                      name: product.productLocation == 'Nigeria'
                                          ? '₦'
                                          : product.productLocation == null
                                              ? ''
                                              : '£')
                                  .format(double.parse(item.price!.toString()) *
                                      int.parse(item.quantity!.toString())),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                            width: Get.width * 0.8,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                color: CupertinoColors.darkBackgroundGray),
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                const Text(
                                  'Commission when Ducts: ',
                                  style: TextStyle(
                                      color: CupertinoColors.systemGrey,
                                      fontWeight: FontWeight.w700),
                                ),
                                // authState.userModel?.email == 'viewducts@gmail.com' ||
                                //         adminStaffController.staff.value
                                //                 .firstWhere(
                                //                     (e) => e.id == authState.userId,
                                //                     orElse: adminStaffController
                                //                         .staffRole)
                                //                 .role ==
                                //             'Admin' ||
                                //         adminStaffController.staff.value
                                //                 .firstWhere(
                                //                     (e) => e.id == authState.userId,
                                //                     orElse: adminStaffController
                                //                         .staffRole)
                                //                 .role ==
                                //             'Sales Agent' ||
                                //         adminStaffController.staff.value
                                //                 .firstWhere(
                                //                     (e) => e.id == authState.userId,
                                //                     orElse: adminStaffController
                                //                         .staffRole)
                                //                 .role ==
                                //             'General Manager'
                                //     ? Text(
                                //         searchState.viewUserlist.value
                                //                 .firstWhere(
                                //                     (e) =>
                                //                         e.key ==
                                //                         item.commissionUser
                                //                             .toString(),
                                //                     orElse: () => vUser)
                                //                 .displayName
                                //                 ?.toString() ??
                                //             '',
                                //         style: const TextStyle(
                                //             color: CupertinoColors.systemYellow,
                                //             fontWeight: FontWeight.w700),
                                //       )
                                //     : Container(),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                    product.productLocation == 'Nigeria'
                                        ? '₦  ${item.commissionPrice}'
                                        : product.productLocation == null
                                            ? ' ${item.commissionPrice}'
                                            : '£ ${item.commissionPrice}',
                                    // NumberFormat.currency(name: 'N ')
                                    //     .format(double.parse(
                                    //   item.commissionPrice.toString(),
                                    // )),
                                    style: const TextStyle(
                                        color: CupertinoColors.systemYellow,
                                        fontWeight: FontWeight.w200)),
                              ],
                            )),
                      ),

                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: ((context) => ReviewDialog(
                                  productUid: item.productId.toString())));
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
                                  color: CupertinoColors.systemYellow),
                              padding: const EdgeInsets.all(5.0),
                              child: TitleText(
                                'Write your review',
                                color: CupertinoColors.darkBackgroundGray,
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        error: (error, stackTrace) => Container(),
        loading: () => Container());
  }
}

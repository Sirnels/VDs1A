// ignore_for_file: unrelated_type_equality_checks, unnecessary_null_comparison, invalid_use_of_protected_member

import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
//import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:viewducts/helper/constant.dart';
import 'package:viewducts/helper/theme.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/page/message/item_Search_bar.dart';
import 'package:viewducts/page/settings/widgets/settingsRowWidget.dart';
import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/duct/duct.dart';
import 'package:viewducts/widgets/frosted.dart';

class ProfileOrders extends HookWidget {
  final Rx<OrderViewProduct>? cartItem;
  final String? country;
  const ProfileOrders({
    Key? key,
    this.cartItem,
    this.country,
  }) : super(key: key);

  Widget invoiceHeader() {
    return frostedYellow(
      Container(
        width: Get.width,
        //  width: ScreenConfig.deviceWidth,
        //height: ScreenConfig.getProportionalHeight(374),
        color: Colors.yellow[100],
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
                    height: Get.width * 0.1,
                  ),
                  Text(
                    "Orders",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: Get.width * 0.06),
                  ),
                  // SizedBox(
                  //   height: Get.width * 0.04,
                  // ),
                  // topHeaderText("#20/07/1203"),
                  SizedBox(
                    height: Get.width * 0.04,
                  ),

                  // ignore: todo
                  // TODO: form get actual date and format it accondingly
                  Text(DateFormat.yMMMd()
                      .add_jm()
                      .format(cartItem!.value.placedDate!.toDate()))
                ],
              ),
              SizedBox(
                height: Get.width * 0.04,
              ),
              SizedBox(
                width: Get.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "assets/groceries.png",
                      height: Get.width * 0.2,
                    ),
                    SizedBox(width: Get.width * 0.7, child: addressColumn())
                  ],
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
            cartItem!.value.shippingAddress.toString(),
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
            color: Colors.white.withOpacity(0.6), fontSize: Get.width * 0.04));
  }

  void _orderList(
    BuildContext context,
  ) {
    // double height =
    //     ScreenConfig.deviceHeight! - ScreenConfig.getProportionalHeight(374);
    // List<ViewductsUser>? list =
    //     searchState.getVendors(authState.userModel?.location);
    showModalBottomSheet(
        backgroundColor: Colors.red,
        //bounce: true,
        context: context,
        builder: (context) => Stack(
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
                                    authState.userModel?.email ==
                                                'viewducts@gmail.com' ||
                                            adminStaffController.staff.value
                                                    .firstWhere(
                                                        (e) =>
                                                            e.id ==
                                                            authState.userId,
                                                        orElse:
                                                            adminStaffController
                                                                .staffRole)
                                                    .role ==
                                                'Admin' ||
                                            adminStaffController.staff.value
                                                    .firstWhere(
                                                        (e) =>
                                                            e.id ==
                                                            authState.userId,
                                                        orElse:
                                                            adminStaffController
                                                                .staffRole)
                                                    .role ==
                                                'Sales Agent' ||
                                            adminStaffController.staff.value
                                                    .firstWhere(
                                                        (e) =>
                                                            e.id ==
                                                            authState.userId,
                                                        orElse:
                                                            adminStaffController
                                                                .staffRole)
                                                    .role ==
                                                'General Manager' ||
                                            cartItem!.value.sellerId ==
                                                authState.appUser!.$id
                                        ? Row(
                                            children: [
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text("State",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        context.responsiveValue(
                                                            mobile: Get.height *
                                                                0.03,
                                                            tablet: Get.height *
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
                                                        style: TextStyle(
                                                          //fontSize: Get.width * 0.03,
                                                          color:
                                                              AppColor.darkGrey,
                                                        ),
                                                      ),
                                                      onPressed: () async {
                                                        adminStaffController
                                                            .adminUsersOrdersStateUpdates(
                                                                cartItem!.value
                                                                    .userId,
                                                                'processing',
                                                                cartItem!
                                                                    .value.key,
                                                                authState
                                                                    .appUser
                                                                    ?.$id);
                                                        //  Get.to(() => SettingsAndPrivacyPage());
                                                      },
                                                      trailingIcon: const Icon(
                                                          CupertinoIcons
                                                              .printer)),
                                                  DuctFocusedMenuItem(
                                                      title: const Text(
                                                        'Order Confirm',
                                                        style: TextStyle(
                                                          //fontSize: Get.width * 0.03,
                                                          color:
                                                              AppColor.darkGrey,
                                                        ),
                                                      ),
                                                      onPressed: () async {
                                                        adminStaffController
                                                            .adminUsersOrdersStateUpdates(
                                                                cartItem!.value
                                                                    .userId,
                                                                'confirm',
                                                                cartItem!
                                                                    .value.key,
                                                                authState
                                                                    .appUser
                                                                    ?.$id);
                                                        //  Get.to(() => SettingsAndPrivacyPage());
                                                      },
                                                      trailingIcon: const Icon(
                                                          CupertinoIcons
                                                              .printer)),
                                                  DuctFocusedMenuItem(
                                                      title: const Text(
                                                        'Shipping',
                                                        style: TextStyle(
                                                          //fontSize: Get.width * 0.03,
                                                          color:
                                                              AppColor.darkGrey,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        adminStaffController
                                                            .adminUsersOrdersStateUpdates(
                                                                cartItem!.value
                                                                    .userId,
                                                                'shipping',
                                                                cartItem!
                                                                    .value.key,
                                                                authState
                                                                    .appUser
                                                                    ?.$id);
                                                        // _orderList(
                                                        //   context,
                                                        // );
                                                        // Get.back();

                                                        // swipeMessage(message);
                                                        // setState(() {});
                                                        // textFieldFocus.nextFocus();
                                                      },
                                                      trailingIcon: const Icon(
                                                          CupertinoIcons
                                                              .shopping_cart)),
                                                  DuctFocusedMenuItem(
                                                      title: const Text(
                                                        'Delivered',
                                                        style: TextStyle(
                                                          //fontSize: Get.width * 0.03,
                                                          color:
                                                              AppColor.darkGrey,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        adminStaffController
                                                            .adminUsersOrdersStateUpdates(
                                                                cartItem!.value
                                                                    .userId,
                                                                'delivered',
                                                                cartItem!
                                                                    .value.key,
                                                                authState
                                                                    .appUser
                                                                    ?.$id);
                                                        // _orderList(
                                                        //   context,
                                                        // );
                                                        // Get.back();

                                                        // swipeMessage(message);
                                                        // setState(() {});
                                                        // textFieldFocus.nextFocus();
                                                      },
                                                      trailingIcon: const Icon(
                                                          CupertinoIcons
                                                              .shopping_cart)),
                                                ],
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Container(
                                                    height: Get.width * 0.1,

                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18),
                                                      color: cartItem!.value
                                                                  .orderState ==
                                                              'shipping'
                                                          ? Colors.yellow
                                                          : cartItem!.value
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
                                                        const Icon(Icons.add),
                                                        cartItem!.value
                                                                    .orderState ==
                                                                'confirm'
                                                            ? const Text(
                                                                'Order Confirmed',
                                                                style: TextStyle(
                                                                    //fontSize: 17.0,
                                                                    // color: Colors.white,
                                                                    ),
                                                              )
                                                            : cartItem!.value
                                                                        .orderState ==
                                                                    'shipping'
                                                                ? const Text(
                                                                    'Shipping',
                                                                    style: TextStyle(
                                                                        //fontSize: 17.0,
                                                                        // color: Colors.white,
                                                                        ),
                                                                  )
                                                                : cartItem!.value
                                                                            .orderState ==
                                                                        'delivered'
                                                                    ? const Text(
                                                                        'Delivered',
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
                                      children: cartItem!.value.items!
                                          .map((item) => ProfileItemImageOrders(
                                                item: item,
                                              ))
                                          .toList(),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Total: ",
                                              style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.6),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: Get.width * 0.04),
                                            ),
                                            SizedBox(
                                              width: Get.width * 0.04,
                                            ),
                                            Text(
                                              NumberFormat.currency(
                                                      name: country == 'Nigeria'
                                                          ? 'N '
                                                          : '£')
                                                  .format(double.parse(cartItem!
                                                      .value.totalPrice
                                                      .toString())),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: Get.width * 0.04),
                                            ),
                                            SizedBox(height: Get.width * 0.1)
                                          ],
                                        ),
                                        SizedBox(height: Get.width * 0.04),
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
                ),
              ],
            ));
  }

  getData() async {
    try {
      final database = Databases(
        clientConnect(),
      );

      await database
          .listDocuments(
        databaseId: databaseId,
        collectionId: procold,
      )
          .then((data) {
        // Map map = data.toMap();

        // var value =
        //     data.documents.map((e) => FeedModel.fromJson(e.data)).toList();
        //data.documents;
        // setState(() {
        feedState.productlist =
            data.documents.map((e) => FeedModel.fromJson(e.data)).toList().obs;
        //});
        // cprint('${data.documents.map((e) => FeedModel.fromJson(e.data))}');
        //cprint('${productlist?.value.map((e) => e.key)}');
      });

      //snap.documents;
    } on AppwriteException catch (e) {
      cprint("$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    data() async {
      await userCartController.listenUserCommission(cartItem!.value.userId);
      await getData();
      cprint('${cartItem!.value.orderState}');
    }

    useEffect(
      () {
        data();

        return () {};
      },
      [],
    );
    return ViewDuctMenuHolder(
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
              // final pdfFile = await PdfInvoiceApi.generate(invoice);

              // PdfApi.openFile(pdfFile);
            },
            trailingIcon: const Icon(CupertinoIcons.printer)),
        DuctFocusedMenuItem(
            title: const Text(
              'Orders',
              style: TextStyle(
                //fontSize: Get.width * 0.03,
                color: AppColor.darkGrey,
              ),
            ),
            onPressed: () {
              _orderList(
                context,
              );
              // Get.back();

              // swipeMessage(message);
              // setState(() {});
              // textFieldFocus.nextFocus();
            },
            trailingIcon: const Icon(CupertinoIcons.shopping_cart)),
      ],
      child: Obx(
        () => Column(
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
                                color: cartItem!.value.orderState == 'shipping'
                                    ? Colors.yellow
                                    : cartItem!.value.orderState == 'delivered'
                                        ? Colors.green[200]
                                        : iAccentColor2,
                              ),

                              // shape: RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(18)),
                              child: Row(
                                children: [
                                  const Icon(Icons.add),
                                  cartItem!.value.orderState == 'confirm'
                                      ? const Text(
                                          'Order Confirmed',
                                          style: TextStyle(
                                              //fontSize: 17.0,
                                              // color: Colors.white,
                                              ),
                                        )
                                      : Container(),
                                  cartItem!.value.orderState == 'shipping'
                                      ? const Text(
                                          'Shipping',
                                          style: TextStyle(
                                              //fontSize: 17.0,
                                              // color: Colors.white,
                                              ),
                                        )
                                      : Container(),
                                  cartItem!.value.orderState == 'delivered'
                                      ? const Text(
                                          'Delivered',
                                          style: TextStyle(
                                              //  fontSize: 17.0,
                                              // color: Colors.white,
                                              ),
                                        )
                                      : Container(),
                                  cartItem!.value.orderState == 'processing'
                                      ? const Text(
                                          'Processing',
                                          style: TextStyle(
                                              // fontSize: 17.0,
                                              //color: Colors.white,
                                              ),
                                        )
                                      : Container()
                                ],
                              ),
                            )
                          ],
                        ),
                        OrderPostBar(
                          list: cartItem!.value.items,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Shipping Method',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(cartItem!.value.shippingMethod.toString()),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Order Date',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(DateFormat.yMMMd().add_jm().format(
                                      cartItem!.value.placedDate!.toDate())
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
                                  name: country == 'Nigeria' ? 'N ' : '£')
                              .format(int.parse(
                            cartItem!.value.totalPrice.toString(),
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
                        authState.userModel?.email == 'viewducts@gmail.com' ||
                                adminStaffController.staff.value
                                        .firstWhere(
                                            (e) => e.id == authState.userId,
                                            orElse:
                                                adminStaffController.staffRole)
                                        .role ==
                                    'Admin' ||
                                adminStaffController.staff.value
                                        .firstWhere(
                                            (e) => e.id == authState.userId,
                                            orElse:
                                                adminStaffController.staffRole)
                                        .role ==
                                    'Sales Agent' ||
                                adminStaffController.staff.value
                                        .firstWhere(
                                            (e) => e.id == authState.userId,
                                            orElse:
                                                adminStaffController.staffRole)
                                        .role ==
                                    'General Manager' ||
                                cartItem!.value.sellerId ==
                                    authState.appUser!.$id
                            ? cartItem?.value.staff == null
                                ? Container()
                                : Padding(
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
                                                  color: CupertinoColors
                                                      .systemGrey,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            Text(
                                              searchState.viewUserlist
                                                      .firstWhere(
                                                          (e) =>
                                                              e.key ==
                                                              cartItem
                                                                  ?.value.staff
                                                                  .toString(),
                                                          orElse: () =>
                                                              ViewductsUser())
                                                      .displayName ??
                                                  '',
                                              style: const TextStyle(
                                                  color: CupertinoColors
                                                      .systemYellow,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ],
                                        )),
                                  )
                            : Container()
                      ],
                    ),
                  )),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
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
                    // final pdfFile = await PdfInvoiceApi.generate(invoice);

                    // PdfApi.openFile(pdfFile);
                  },
                ),
              ],
            ),
          ),
        ),
      );
}

class ProfileItemImageOrders extends StatelessWidget {
  final OrderItemModel item;
  const ProfileItemImageOrders({Key? key, required this.item})
      : super(key: key);
  getData() async {
    try {
      final database = Databases(
        clientConnect(),
      );

      await database
          .listDocuments(
        databaseId: databaseId,
        collectionId: procold,
      )
          .then((data) {
        // Map map = data.toMap();

        // var value =
        //     data.documents.map((e) => FeedModel.fromJson(e.data)).toList();
        //data.documents;
        // setState(() {
        feedState.productlist =
            data.documents.map((e) => FeedModel.fromJson(e.data)).toList().obs;
        //});
        // cprint('${data.documents.map((e) => FeedModel.fromJson(e.data))}');
        //cprint('${productlist?.value.map((e) => e.key)}');
      });

      //snap.documents;
    } on AppwriteException catch (e) {
      cprint("$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    FeedModel model = FeedModel();
    ViewductsUser vUser = ViewductsUser();
    cprint('${item.productId}');
    getData();
    Storage storage = Storage(clientConnect());
    Image? url;
    if (feedState.productlist!
            .firstWhere(
              (e) => e.key == item.productId,
              orElse: () => model,
            )
            .imagePath ==
        null) {
    } else {
      storage
          .getFileView(
              bucketId: productBucketId,
              fileId: feedState.productlist!
                      .firstWhere(
                        (e) => e.key == item.productId,
                        orElse: () => model,
                      )
                      .imagePath ??
                  '')
          .then((bytes) {
        url = Image.memory(bytes);
      });
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: Get.width * 0.3,
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
          color: iPrimarryColor,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: Get.width * 0.04),

                //   addItemAction(),
                // SizedBox(
                //   height: Get.width *
                //       0.04,
                // ),
                Container(
                  height: Get.width * 0.2,
                  padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
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
                                fileId: feedState.productlist!
                                    .firstWhere(
                                      (e) => e.key == item.productId,
                                      orElse: () => model,
                                    )
                                    .imagePath
                                    .toString()),
                            builder: (context, snap) {
                              return snap.hasData && snap.data != null ||
                                      url?.image != null
                                  ? Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          image: DecorationImage(
                                              image: url?.image ??
                                                  customAdvanceNetworkImage(
                                                      dummyProfilePic),
                                              fit: BoxFit.contain),
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
                            }),
                      ),

                      Text(
                        NumberFormat.currency(name: 'N ')
                            .format(double.parse(item.price.toString())),
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
                        NumberFormat.currency(name: 'N ').format(
                            double.parse(item.price!.toString()) *
                                int.parse(item.quantity!.toString())),
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),

                //invoiceTotal(totalAmount),

                // FlatButton(
                //   color: iAccentColor,
                //   shape: RoundedRectangleBorder(
                //       borderRadius:
                //           BorderRadius
                //               .circular(
                //                   15)),
                //   child: SizedBox(
                //     height: ScreenConfig
                //         .getProportionalHeight(
                //             80),
                //     child: Row(
                //       mainAxisAlignment:
                //           MainAxisAlignment
                //               .center,
                //       children: [
                //         Icon(Icons
                //             .file_download),
                //         SizedBox(
                //           width: ScreenConfig
                //               .getProportionalWidth(
                //                   21),
                //         ),
                //         Text(
                //           "Download now",
                //           style: TextStyle(
                //               fontSize: ScreenConfig
                //                   .getProportionalHeight(
                //                       27),
                //               fontWeight:
                //                   FontWeight
                //                       .bold),
                //         )
                //       ],
                //     ),
                //   ),
                //   onPressed: () {},
                // )
              ],
            ),
          ),
        ),
        item.commissionUser == null
            ? const SizedBox()
            : authState.userModel?.email == 'viewducts@gmail.com' ||
                    adminStaffController.staff.value
                            .firstWhere((e) => e.id == authState.userId,
                                orElse: adminStaffController.staffRole)
                            .role ==
                        'Admin' ||
                    adminStaffController.staff.value
                            .firstWhere((e) => e.id == authState.userId,
                                orElse: adminStaffController.staffRole)
                            .role ==
                        'Sales Agent' ||
                    adminStaffController.staff.value
                            .firstWhere((e) => e.id == authState.userId,
                                orElse: adminStaffController.staffRole)
                            .role ==
                        'General Manager'
                ? ViewDuctMenuHolder(
                    onPressed: () {},
                    menuItems: <DuctFocusedMenuItem>[
                      DuctFocusedMenuItem(
                          title: const Text(
                            'Add Commission',
                            style: TextStyle(
                              //fontSize: Get.width * 0.03,
                              color: AppColor.darkGrey,
                            ),
                          ),
                          onPressed: () async {
                            adminStaffController.addUnpaidCommissionAmount(
                                item.commissionUser,
                                item.commissionPrice,
                                item.productId,
                                item.commissionId);

                            //  Get.to(() => SettingsAndPrivacyPage());
                          },
                          trailingIcon:
                              const Icon(CupertinoIcons.money_dollar_circle)),
                    ],
                    child: Padding(
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
                                'CommissionUser: ',
                                style: TextStyle(
                                    color: CupertinoColors.systemGrey,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                searchState.viewUserlist.value
                                        .firstWhere(
                                            (e) =>
                                                e.key ==
                                                item.commissionUser.toString(),
                                            orElse: () => vUser)
                                        .displayName
                                        ?.toString() ??
                                    '',
                                style: const TextStyle(
                                    color: CupertinoColors.systemYellow,
                                    fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                  searchState.viewUserlist.value
                                              .firstWhere(
                                                  (e) =>
                                                      e.key ==
                                                      item.commissionUser
                                                          .toString(),
                                                  orElse: () => vUser)
                                              .location ==
                                          'Nigeria'
                                      ? '₦  ${item.commissionPrice}'
                                      : '£ ${item.commissionPrice}',
                                  // NumberFormat.currency(name: 'N ')
                                  //     .format(int.parse(
                                  //   item.commissionPrice.toString(),
                                  // )),
                                  style: const TextStyle(
                                      color: CupertinoColors.systemYellow,
                                      fontWeight: FontWeight.w200)),
                            ],
                          )),
                    ),
                  )
                : Container()
      ],
    );
  }
}

// ignore_for_file: invalid_use_of_protected_member, must_be_immutable, unused_element, unnecessary_null_comparison

import 'dart:ui';

import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
//import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:status_view/status_view.dart';
import 'package:viewducts/admin/Admin_dashbord/adminUserOrders.dart';
import 'package:viewducts/admin/Admin_dashbord/constants.dart';
import 'package:viewducts/admin/Admin_dashbord/responsive.dart';
import 'package:viewducts/admin/Admin_dashbord/screens/controllers.dart';
import 'package:viewducts/admin/Admin_dashbord/screens/dashboard/components/storage_info_card.dart';
import 'package:viewducts/admin/screens/add_product.dart';
import 'package:viewducts/admin/screens/admin.dart';
import 'package:viewducts/helper/theme.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/page/message/chatScreenPage.dart';
import 'package:viewducts/page/message/item_Search_bar.dart';
import 'package:viewducts/page/message/local_database.dart';
import 'package:viewducts/page/responsiveView.dart';
import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/frosted.dart';
import 'package:viewducts/widgets/newWidget/title_text.dart';

class AdminUserAccountBalance extends HookWidget {
  final ViewductsUser? user;
  AdminUserAccountBalance({Key? key, this.user}) : super(key: key);
  Rx<UserBankAccountModel> account = UserBankAccountModel(amount: []).obs;
  TextEditingController otp = TextEditingController();
  void _bankDetails(BuildContext context, UserAccountAmount money) {
    showModalBottomSheet(
        backgroundColor: Colors.red,
        // bounce: true,
        context: context,
        builder: (context) => SizedBox(
              height: Get.height * 0.5,
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
                  ),
                  SizedBox(
                    width: Get.width,
                    height: Get.height * 0.7,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                // color: bgColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(.5),
                                    blurRadius: 10,
                                  )
                                ],
                                borderRadius: BorderRadius.circular(20)),
                            child: Wrap(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          1.2,
                                      margin: const EdgeInsets.only(top: 30),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: Colors.grey.withOpacity(.3),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 4),
                                        child: TextField(
                                          controller: otp,
                                          decoration: const InputDecoration(
                                              icon: Icon(Icons.email_outlined),
                                              fillColor: Colors.white,
                                              border: InputBorder.none,
                                              hintText: "OTP"),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(25),
                                  child: GestureDetector(
                                      // bgColor: Colors.yellow[200],
                                      // txtColor: Colors.black,
                                      child: Container(
                                          // margin: EdgeInsets.all(10),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: bgColor,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(.5),
                                                  blurRadius: 10,
                                                )
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: const Text(
                                            "Transfer",
                                            style: TextStyle(
                                                color: Colors.white70),
                                          )),
                                      //  shadowColor: Colors.black87,
                                      onTap: () async {
                                        //adminStaffController.signIn();
                                        if (otp.text.isNotEmpty) {
                                          userCartController
                                              .adminPaymentproccessed(
                                                  user!.userId,
                                                  money.amount,
                                                  money.monthPay,
                                                  'Paid',
                                                  money: account.value.amount!
                                                      .firstWhere((e) =>
                                                          e.monthPay ==
                                                          money.monthPay),
                                                  otp: otp.text.trim());
                                          Get.back();
                                          Get.snackbar(
                                            "Account Added",
                                            "Nice job!",
                                            icon: Container(
                                              height: Get.width * 0.1,
                                              width: Get.width * 0.1,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  image: const DecorationImage(
                                                      image: AssetImage(
                                                          'assets/folder.png'))),
                                            ),
                                          );
                                        } else {
                                          Get.snackbar(
                                            "fill in the",
                                            "Account details!",
                                            backgroundColor: Colors.yellow,
                                            icon: Container(
                                              height: Get.width * 0.1,
                                              width: Get.width * 0.1,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  image: const DecorationImage(
                                                      image: AssetImage(
                                                          'assets/folder.png'))),
                                            ),
                                          );
                                        }
                                      }),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    final paidCommissionState = useState(userCartController.paidCommission);
    data() async {
      await userCartController.listenUserCommission(user!.userId);
      await adminStaffController.listenToUserBankAccount(user!.userId);
      await userCartController
          .changePaidComissionAmount(paidCommissionState.value);
      userCartController.listenUserPaidCommission(user!.userId,
          paidCommissionState: paidCommissionState.value);
      // await adminStaffController.adminIndividualUsersOrders(id);
    }

    void _paymentHistory(BuildContext context) {
      showModalBottomSheet(
          backgroundColor: Colors.red,
          // bounce: true,
          context: context,
          builder: (context) => Scaffold(
                  body: Responsive(
                mobile: SizedBox(
                  height: Get.height * 0.7,
                  child: Stack(
                    children: [
                      ThemeMode.system == ThemeMode.light
                          ? frostedYellow(
                              Container(
                                height: fullHeight(context),
                                width: fullWidth(context),
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
                      SizedBox(
                        width: Get.width,
                        height: Get.height * 0.7,
                        child: userCartController
                                    .totalPaidCommissionAmount.value ==
                                0
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: Get.height * 0.08,
                                    backgroundColor: Colors.transparent,
                                    child: Image.asset('assets/sad.png'),
                                  ),
                                  const Center(
                                    child: Text('No Commission Recieved Yet'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                        // width:
                                        //    Get.width * 0.3,
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
                                                CupertinoColors.activeOrange),
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          'Duct smarter to get commission',
                                          style: TextStyle(
                                              color: CupertinoColors
                                                  .darkBackgroundGray,
                                              fontWeight: FontWeight.w900),
                                        )),
                                  ),
                                ],
                              )
                            : SingleChildScrollView(
                                child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                          padding: const EdgeInsets.all(5.0),
                                          child: Container(
                                              // width:
                                              //    Get.width * 0.3,
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
                                                      BorderRadius.circular(18),
                                                  color: CupertinoColors
                                                      .activeGreen),
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                'Your vDuct commission',
                                                style: TextStyle(
                                                    color: CupertinoColors
                                                        .darkBackgroundGray,
                                                    fontWeight:
                                                        FontWeight.w900),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Obx(
                                    () => Column(
                                      children: paidCommissionState.value
                                          .map((money) => SizedBox(
                                                width: Get.width * 0.9,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                        backgroundColor:
                                                            Colors.red,
                                                        // bounce: true,
                                                        context: context,
                                                        builder: (context) =>
                                                            ProductResponsiveView(
                                                              model: feedState
                                                                  .productlist!
                                                                  .firstWhere(
                                                                      (e) =>
                                                                          e.key ==
                                                                          money
                                                                              .productId,
                                                                      orElse: feedState
                                                                          .storyId),
                                                            ));
                                                  },
                                                  child: StorageCardView(
                                                    svgSrc: "assets/folder.png",
                                                    title: Text(
                                                      "Commission",
                                                    ),
                                                    textStyle: const TextStyle(
                                                        color: CupertinoColors
                                                            .darkBackgroundGray),
                                                    amountOfFiles: Text(
                                                      money.month.toString(),
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    numOfFiles: Row(
                                                      children: [
                                                        Text(
                                                          NumberFormat.currency(
                                                                  name: authState
                                                                              .userModel!
                                                                              .location ==
                                                                          'Nigeria'
                                                                      ? '₦'
                                                                      : '£')
                                                              .format(
                                                                  double.parse(
                                                            money.amount
                                                                .toString(),
                                                          )),
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .caption!
                                                              .copyWith(
                                                                  color: Colors
                                                                      .cyan),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          money.paidState
                                                              .toString(),
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .caption!
                                                              .copyWith(
                                                                  color: Colors
                                                                      .black87),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                ],
                              )),
                      ),
                    ],
                  ),
                ),
                tablet: Stack(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: Get.height * 0.7,
                            child: Stack(
                              children: [
                                ThemeMode.system == ThemeMode.light
                                    ? frostedYellow(
                                        Container(
                                          height: fullHeight(context),
                                          width: fullWidth(context),
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
                                      )
                                    : Container(),
                                SizedBox(
                                  width: Get.width,
                                  height: Get.height * 0.7,
                                  child: userCartController
                                              .totalPaidCommissionAmount
                                              .value ==
                                          0
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              radius: Get.height * 0.08,
                                              backgroundColor:
                                                  Colors.transparent,
                                              child:
                                                  Image.asset('assets/sad.png'),
                                            ),
                                            const Center(
                                              child: Text(
                                                  'No Commission Recieved Yet'),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Container(
                                                  // width:
                                                  //    Get.width * 0.3,
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
                                                          .activeOrange),
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    'Duct smarter to get commission',
                                                    style: TextStyle(
                                                        color: CupertinoColors
                                                            .darkBackgroundGray,
                                                        fontWeight:
                                                            FontWeight.w900),
                                                  )),
                                            ),
                                          ],
                                        )
                                      : SingleChildScrollView(
                                          child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Material(
                                                    elevation: 10,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
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
                                                        const EdgeInsets.all(
                                                            5.0),
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
                                                                .activeGreen),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: Text(
                                                          'Your vDuct commission',
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
                                            Obx(
                                              () => Column(
                                                children:
                                                    paidCommissionState.value
                                                        .map(
                                                            (money) => SizedBox(
                                                                  width:
                                                                      Get.width *
                                                                          0.9,
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      showModalBottomSheet(
                                                                          backgroundColor: Colors
                                                                              .red,
                                                                          // bounce:
                                                                          //     true,
                                                                          context:
                                                                              context,
                                                                          builder: (context) =>
                                                                              ProductResponsiveView(
                                                                                model: feedState.productlist!.firstWhere((e) => e.key == money.productId, orElse: feedState.storyId),
                                                                              ));
                                                                    },
                                                                    child:
                                                                        StorageCardView(
                                                                      svgSrc:
                                                                          "assets/folder.png",
                                                                      title:
                                                                          Text(
                                                                        "Commission",
                                                                      ),
                                                                      textStyle:
                                                                          const TextStyle(
                                                                              color: CupertinoColors.darkBackgroundGray),
                                                                      amountOfFiles:
                                                                          Text(
                                                                        money
                                                                            .month
                                                                            .toString(),
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.bold),
                                                                      ),
                                                                      numOfFiles:
                                                                          Row(
                                                                        children: [
                                                                          Text(
                                                                            NumberFormat.currency(name: authState.userModel!.location == 'Nigeria' ? '₦' : '£').format(double.parse(
                                                                              money.amount.toString(),
                                                                            )),
                                                                            style:
                                                                                Theme.of(context).textTheme.caption!.copyWith(color: Colors.cyan),
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                5,
                                                                          ),
                                                                          Text(
                                                                            money.paidState.toString(),
                                                                            style:
                                                                                Theme.of(context).textTheme.caption!.copyWith(color: Colors.black87),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ))
                                                        .toList(),
                                              ),
                                            ),
                                          ],
                                        )),
                                ),
                              ],
                            ),
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
                          child: SizedBox(
                            height: Get.height * 0.7,
                            child: Stack(
                              children: [
                                ThemeMode.system == ThemeMode.light
                                    ? frostedYellow(
                                        Container(
                                          height: fullHeight(context),
                                          width: fullWidth(context),
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
                                      )
                                    : Container(),
                                SizedBox(
                                  width: Get.width,
                                  height: Get.height * 0.7,
                                  child: userCartController
                                              .totalPaidCommissionAmount
                                              .value ==
                                          0
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CircleAvatar(
                                              radius: Get.height * 0.08,
                                              backgroundColor:
                                                  Colors.transparent,
                                              child:
                                                  Image.asset('assets/sad.png'),
                                            ),
                                            const Center(
                                              child: Text(
                                                  'No Commission Recieved Yet'),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Container(
                                                  // width:
                                                  //    Get.width * 0.3,
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
                                                          .activeOrange),
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Text(
                                                    'Duct smarter to get commission',
                                                    style: TextStyle(
                                                        color: CupertinoColors
                                                            .darkBackgroundGray,
                                                        fontWeight:
                                                            FontWeight.w900),
                                                  )),
                                            ),
                                          ],
                                        )
                                      : SingleChildScrollView(
                                          child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Material(
                                                    elevation: 10,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
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
                                                        const EdgeInsets.all(
                                                            5.0),
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
                                                                .activeGreen),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: Text(
                                                          'Your vDuct commission',
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
                                            Obx(
                                              () => Column(
                                                children:
                                                    paidCommissionState.value
                                                        .map(
                                                            (money) => SizedBox(
                                                                  width:
                                                                      Get.width *
                                                                          0.9,
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      showModalBottomSheet(
                                                                          backgroundColor: Colors
                                                                              .red,
                                                                          // bounce:
                                                                          //     true,
                                                                          context:
                                                                              context,
                                                                          builder: (context) =>
                                                                              ProductResponsiveView(
                                                                                model: feedState.productlist!.firstWhere((e) => e.key == money.productId, orElse: feedState.storyId),
                                                                              ));
                                                                    },
                                                                    child:
                                                                        StorageCardView(
                                                                      svgSrc:
                                                                          "assets/folder.png",
                                                                      title:
                                                                          Text(
                                                                        "Commission",
                                                                      ),
                                                                      textStyle:
                                                                          const TextStyle(
                                                                              color: CupertinoColors.darkBackgroundGray),
                                                                      amountOfFiles:
                                                                          Text(
                                                                        money
                                                                            .month
                                                                            .toString(),
                                                                        style: const TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.bold),
                                                                      ),
                                                                      numOfFiles:
                                                                          Row(
                                                                        children: [
                                                                          Text(
                                                                            NumberFormat.currency(name: authState.userModel!.location == 'Nigeria' ? '₦' : '£').format(double.parse(
                                                                              money.amount.toString(),
                                                                            )),
                                                                            style:
                                                                                Theme.of(context).textTheme.caption!.copyWith(color: Colors.cyan),
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                5,
                                                                          ),
                                                                          Text(
                                                                            money.paidState.toString(),
                                                                            style:
                                                                                Theme.of(context).textTheme.caption!.copyWith(color: Colors.black87),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ))
                                                        .toList(),
                                              ),
                                            ),
                                          ],
                                        )),
                                ),
                              ],
                            ),
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
    }

    useEffect(
      () {
        data();

        return () {};
      },
      [],
    );
    return Scaffold(
      body: SafeArea(
        child: PageView(
          children: [
            SizedBox(
                width: Get.width,
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: Colors.white,
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
                      ],
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     feedState.createAccountValues(
                    //         balance: 2347,
                    //         withdrawed: 5678,
                    //         sales: 23456);
                    //   },
                    //   child: Text('add Balance'),
                    // ),
                    Material(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.transparent,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 3),
                          child: customText(
                            'DashView',
                            style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 35,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                    // _ductOptions(
                    //   context,
                    // )
                    frostedOrange(
                      Container(
                        width: Get.width * 0.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.blueGrey[50],
                            gradient: LinearGradient(
                              colors: [
                                Colors.yellow.withOpacity(0.1),
                                Colors.white60.withOpacity(0.2),
                                Colors.yellow.withOpacity(0.3)
                              ],
                              // begin: Alignment.topCenter,
                              // end: Alignment.bottomCenter,
                            )),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 3),
                              child: customTitleText('Account Details'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: Get.width * .6,
                        padding: const EdgeInsets.only(top: 5, bottom: 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blueGrey[50],
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.6),
                              Colors.white.withOpacity(0.8),
                              Colors.white.withOpacity(0.1)
                              // Color(0xfffbfbfb),
                              // Color(0xfff7f7f7),
                            ],
                            // begin: Alignment.topCenter,
                            // end: Alignment.bottomCenter,
                          ),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Commission Balance',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                          NumberFormat.currency(name: 'N ')
                                              .format(double.parse(
                                            userCartController
                                                .totalCommissionAmount.value
                                                .toString(),
                                          )),
                                          style: const TextStyle(
                                              color: Colors.cyan,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // authState.userId != user!.userId
                            //     ? Container()
                            //     :
                            Obx(() => ViewDuctMenuHolder(
                                  onPressed: () {},
                                  menuItems: <DuctFocusedMenuItem>[
                                    userCartController.adminpaymentActiv.value
                                                .paymentStatus ==
                                            'activate'
                                        ? userCartController
                                                    .totalCommissionAmount
                                                    .value <
                                                10000
                                            ? DuctFocusedMenuItem(
                                                title: const Text(
                                                  'Balance < 10000',
                                                  style: TextStyle(
                                                    //fontSize: Get.width * 0.03,
                                                    color: CupertinoColors
                                                        .systemRed,
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  //  Get.to(() => SettingsAndPrivacyPage());
                                                },
                                              )
                                            : DuctFocusedMenuItem(
                                                title: const Text(
                                                  'Request your commission',
                                                  style: TextStyle(
                                                    //fontSize: Get.width * 0.03,
                                                    color: AppColor.darkGrey,
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  userCartController
                                                      .userRequestPayment(
                                                          authState.userId,
                                                          userCartController
                                                              .totalCommissionAmount
                                                              .value
                                                              .toString(),
                                                          DateFormat("MMM yyy")
                                                              .format(DateTime
                                                                  .now()));

                                                  //  Get.to(() => SettingsAndPrivacyPage());
                                                },
                                                trailingIcon: const Icon(
                                                    CupertinoIcons
                                                        .money_dollar_circle))
                                        : DuctFocusedMenuItem(
                                            title: const Text(
                                              'Payment Date not Due',
                                              style: TextStyle(
                                                //fontSize: Get.width * 0.03,
                                                color: Colors.red,
                                              ),
                                            ),
                                            onPressed: () async {
                                              //  Get.to(() => SettingsAndPrivacyPage());
                                            },
                                          ),
                                    DuctFocusedMenuItem(
                                        title: const Text(
                                          'Payment history',
                                          style: TextStyle(
                                            //fontSize: Get.width * 0.03,
                                            color: AppColor.darkGrey,
                                          ),
                                        ),
                                        onPressed: () async {
                                          _paymentHistory(
                                            context,
                                          );
                                          //  Get.to(() => SettingsAndPrivacyPage());
                                        },
                                        trailingIcon: const Icon(CupertinoIcons
                                            .money_dollar_circle)),
                                  ],
                                  child: userCartController
                                              .totalCommissionAmount.value <
                                          10000
                                      ? Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Container(
                                              width: Get.width * 0.2,
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
                                                      BorderRadius.circular(18),
                                                  color: Colors.cyan),
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: const Text(
                                                'HISTORY',
                                                style: TextStyle(
                                                    color: CupertinoColors
                                                        .darkBackgroundGray,
                                                    fontWeight:
                                                        FontWeight.w900),
                                              )),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Container(
                                              width: Get.width * 0.3,
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
                                                      BorderRadius.circular(18),
                                                  color: CupertinoColors
                                                      .systemGreen),
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: const Text(
                                                'WITHDRAW',
                                                style: TextStyle(
                                                    color: CupertinoColors
                                                        .darkBackgroundGray,
                                                    fontWeight:
                                                        FontWeight.w900),
                                              )),
                                        ),
                                ))
                          ],
                        ),
                      ),
                    ),

                    Obx(
                      () => account.value.account == null
                          ? ListTile(
                              onTap: () {
                                // _bankDetails(
                                //   context,
                                // );
                              },
                              leading: Image.asset('assets/folder.png'),
                              title: Text(
                                "Add",
                                style: TextStyle(
                                  fontSize: Get.width * 0.04,
                                  // color: Colors.white,
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                              subtitle: Text(
                                "Account Number",
                                style: TextStyle(
                                  fontSize: Get.width * 0.04,
                                  //color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : SizedBox(
                              width: Get.width * 0.8,
                              child: StorageInfoCard(
                                svgSrc: "assets/folder.png",
                                title: "Bank Account",
                                textStyle: const TextStyle(
                                    color: CupertinoColors.systemYellow),
                                amountOfFiles: Text(
                                  account.value.bank.toString(),
                                  style: const TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.bold),
                                ),
                                numOfFiles: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          account.value.account.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(color: Colors.white70),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          account.value.country.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(color: Colors.cyan),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      account.value.name.toString(),
                                      style: const TextStyle(
                                          color: Colors.white70,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                    Obx(
                      () => SingleChildScrollView(
                          child: Column(
                        children: account.value.amount!
                            .map((money) => ViewDuctMenuHolder(
                                  onPressed: () {},
                                  menuItems: <DuctFocusedMenuItem>[
                                    DuctFocusedMenuItem(
                                      backgroundColor:
                                          CupertinoColors.darkBackgroundGray,
                                      title: const Text(
                                        'Proccessed Payment',
                                        style: TextStyle(
                                          //fontSize: Get.width * 0.03,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      onPressed: () async {
                                        _bankDetails(context, money);
                                        // userCartController
                                        //     .adminPaymentproccessed(
                                        //         user!.userId,
                                        //         money.amount,
                                        //         money.monthPay,
                                        //         'Paid',
                                        //         money: account.value.amount!
                                        //             .firstWhere((e) =>
                                        //                 e.monthPay ==
                                        //                 money.monthPay));
                                        //  Get.to(() => SettingsAndPrivacyPage());
                                      },
                                    ),
                                  ],
                                  child: SizedBox(
                                    width: Get.width * 0.9,
                                    child: StorageInfoCard(
                                      svgSrc: "assets/folder.png",
                                      title: "Commission",
                                      textStyle: const TextStyle(
                                          color: CupertinoColors
                                              .lightBackgroundGray),
                                      amountOfFiles: Text(
                                        money.monthPay.toString(),
                                        style: const TextStyle(
                                            color: Colors.yellow,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      numOfFiles: Row(
                                        children: [
                                          Text(
                                            NumberFormat.currency(name: 'N ')
                                                .format(int.parse(
                                              money.amount.toString(),
                                            )),
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption!
                                                .copyWith(color: Colors.cyan),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            money.paymentState.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption!
                                                .copyWith(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      )),
                    )
                    // Material(
                    //   elevation: 1,
                    //   borderRadius: BorderRadius.circular(10),
                    //   child: frostedOrange(
                    //     Container(
                    //       width: Get.width * 0.4,
                    //       decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(20),
                    //           color: Colors.blueGrey[50],
                    //           gradient: LinearGradient(
                    //             colors: [
                    //               Colors.yellow.withOpacity(0.1),
                    //               Colors.white60.withOpacity(0.2),
                    //               Colors.green.withOpacity(0.3)
                    //             ],
                    //             // begin: Alignment.topCenter,
                    //             // end: Alignment.bottomCenter,
                    //           )),
                    //       child: Row(
                    //         children: [
                    //           Padding(
                    //             padding: const EdgeInsets.symmetric(
                    //                 horizontal: 8.0, vertical: 3),
                    //             child: customTitleText('Your Orders'),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // Container(
                    //   child: Obx(
                    //     () =>
                    //         // userCartController
                    //         //               .orders.value.items!.length ==
                    //         //           0 ||
                    //         //       userCartController
                    //         //           .orders.value.items!.isEmpty
                    //         //   ? Container()
                    //         //   :
                    //         Column(
                    //       children: userCartController.orders.value
                    //           .map((cartItem) => ProfileOrders(
                    //                 cartItem: cartItem.obs,
                    //               ))
                    //           .toList(),
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // )
                  ],
                ))),
          ],
        ),
      ),
    );
  }
}

class AdminUsers extends StatelessWidget {
  AdminUsers({Key? key}) : super(key: key);
  RxString? searchValue = ''.obs;

  void itemProduct(String value) {
    searchValue = value.obs;

    cprint(searchValue?.value);
  }

  void _searchUser(BuildContext context) {
    // List<ViewductsUser>? list =
    //     searchState.getVendors(authState.userModel?.location);
    showModalBottomSheet(
        backgroundColor: Colors.red,
        // bounce: true,
        context: context,
        builder: (context) => Stack(
              children: <Widget>[
                Container(
                  width: Get.width,
                  height: Get.height,
                  color: bgColor,
                ),
                SizedBox(
                  width: Get.width,
                  height: Get.height,
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      CupertinoSearchTextField(onChanged: (data) {
                        return itemProduct(data);
                      }),
                      // AdvancedSearch(
                      //     data: [listSearch.value.toString()],
                      //     //  feedState.keywords.value.keywords!
                      //     //     .map((e) => e.keyword.toString())
                      //     //     .toList(),
                      //     maxElementsToDisplay: 10,
                      //     onItemTap: (index, value) {
                      //       return itemProduct(index, value);
                      //     },
                      //     onSubmitted: (data, value) {
                      //       searchValue?.value = data;
                      //       cprint(data);
                      //     },
                      //     searchResultsBgColor: Colors.transparent,
                      //     onSearchClear: () {}),
                      Obx(() => SizedBox(
                            width: Get.width,
                            height: Get.height,
                            child: ListView.separated(
                              addAutomaticKeepAlives: false,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: _UserTile(
                                  user: listSearch.value[index],
                                ),
                              ),
                              separatorBuilder: (_, index) => const Divider(
                                height: 0,
                              ),
                              itemCount: listSearch.value.length,
                            ),
                          ))
                    ],
                  )),
                  // child: ListView.separated(
                  //   addAutomaticKeepAlives: false,
                  //   physics: const BouncingScrollPhysics(),
                  //   itemBuilder: (context, index) => Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: UserTile(user: list![index]),
                  //   ),
                  //   separatorBuilder: (_, index) => const Divider(
                  //     height: 0,
                  //   ),
                  //   itemCount: list?.length ?? 0,
                  // ),
                ),
              ],
            ));
  }

  RxList<ViewductsUser> listSearch = RxList<ViewductsUser>();
  @override
  Widget build(BuildContext context) {
    listSearch
        .bindStream(feedState.getadminProfileFromDatabase(searchValue?.value));
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: Get.width * 0.15,
              left: 0,
              child: SingleChildScrollView(
                child: SizedBox(
                  width: Get.width,
                  height: Get.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                          onTap: () {
                            _searchUser(context);
                          },
                          child: Container(
                            width: Get.width * 0.8,
                            //  height: Get.width * 0.6,
                            margin: const EdgeInsets.only(top: 30),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.grey.withOpacity(.2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              child: Row(
                                children: const [
                                  Text('Search'),
                                ],
                              ),
                            ),
                          )),
                      Expanded(
                        flex: 20,
                        child: SizedBox(
                          width: Get.width,
                          height: searchState.viewUserlist.length == 1
                              ? Get.width * 0.2
                              : context.width * 0.5,
                          child: ListView.separated(
                            addAutomaticKeepAlives: false,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: _UserTile(
                                user: searchState.viewUserlist[index],
                              ),
                            ),
                            separatorBuilder: (_, index) => const Divider(
                              height: 0,
                            ),
                            itemCount: searchState.viewUserlist.length,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 1,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.white,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminUsersRequestPayment extends HookWidget {
  AdminUsersRequestPayment({Key? key}) : super(key: key);
  RxString? searchValue = ''.obs;

  void itemProduct(String value) {
    searchValue = value.obs;

    // cprint(searchValue?.value);
  }

  void _searchUser(BuildContext context) {
    // List<ViewductsUser>? list =
    //     searchState.getVendors(authState.userModel?.location);
    showModalBottomSheet(
        backgroundColor: Colors.red,
        // bounce: true,
        context: context,
        builder: (context) => Stack(
              children: <Widget>[
                Container(
                  width: Get.width,
                  height: Get.height,
                  color: bgColor,
                ),
                SizedBox(
                  width: Get.width,
                  height: Get.height,
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      CupertinoSearchTextField(onChanged: (data) {
                        return itemProduct(data);
                      }),
                      // AdvancedSearch(
                      //     data: [listSearch.value.toString()],
                      //     //  feedState.keywords.value.keywords!
                      //     //     .map((e) => e.keyword.toString())
                      //     //     .toList(),
                      //     maxElementsToDisplay: 10,
                      //     onItemTap: (index, value) {
                      //       return itemProduct(index, value);
                      //     },
                      //     onSubmitted: (data, value) {
                      //       searchValue?.value = data;
                      //       cprint(data);
                      //     },
                      //     searchResultsBgColor: Colors.transparent,
                      //     onSearchClear: () {}),
                      Obx(() => SizedBox(
                            width: Get.width,
                            height: Get.height,
                            child: ListView.separated(
                              addAutomaticKeepAlives: false,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: _UserTile(
                                  user: listSearch.value[index],
                                ),
                              ),
                              separatorBuilder: (_, index) => const Divider(
                                height: 0,
                              ),
                              itemCount: listSearch.value.length,
                            ),
                          ))
                    ],
                  )),
                  // child: ListView.separated(
                  //   addAutomaticKeepAlives: false,
                  //   physics: const BouncingScrollPhysics(),
                  //   itemBuilder: (context, index) => Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: UserTile(user: list![index]),
                  //   ),
                  //   separatorBuilder: (_, index) => const Divider(
                  //     height: 0,
                  //   ),
                  //   itemCount: list?.length ?? 0,
                  // ),
                ),
              ],
            ));
  }

  RxList<ViewductsUser> listSearch = RxList<ViewductsUser>();
  @override
  Widget build(BuildContext context) {
    data() async {
      searchState.viewUserlist = RxList<ViewductsUser>();
      final database = Databases(
        serverApi.serverClientConnect(),
      );
      await database
          .listDocuments(
        databaseId: databaseId,
        collectionId: monthlycommisionPayment,
        //queries: [Query.equal('userId', user?.key.toString())]
      )
          .then((data) {
        adminStaffController.commissionRequested.value = data.documents
            .map((e) => RequestedCommissionState.fromSnapshot(e.data))
            .toList();
      });
      await database.listDocuments(
          databaseId: databaseId,
          collectionId: profileUserColl,
          queries: [
            Query.equal(
                'key',
                adminStaffController.commissionRequested.value
                    .map((data) => data.userId.toString())
                    .toList())
          ]
          //  queries: [query.Query.equal('key', ductId)]
          ).then((data) {
        if (data.documents.isNotEmpty) {
          var value = data.documents
              .map((e) => ViewductsUser.fromJson(e.data))
              .toList();

          searchState.viewUserlist.value = value;
        }
      });
      // await adminStaffController.adminIndividualUsersOrders(id);
    }

    useEffect(
      () {
        data();

        return () {};
      },
      [],
    );
    // listSearch
    //     .bindStream(feedState.getadminProfileFromDatabase(searchValue?.value));
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: Get.width * 0.15,
              left: 0,
              child: SingleChildScrollView(
                child: SizedBox(
                  width: Get.width,
                  height: Get.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                          onTap: () {
                            _searchUser(context);
                          },
                          child: Container(
                            width: Get.width * 0.8,
                            //  height: Get.width * 0.6,
                            margin: const EdgeInsets.only(top: 30),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.grey.withOpacity(.2),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              child: Row(
                                children: const [
                                  Text('Search'),
                                ],
                              ),
                            ),
                          )),
                      Expanded(
                        flex: 20,
                        child: Obx(
                          () => SizedBox(
                            width: Get.width,
                            height: searchState.viewUserlist.length == 1
                                ? Get.width * 0.2
                                : context.width * 0.5,
                            child: ListView.separated(
                              addAutomaticKeepAlives: false,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: _UserTileRequst(
                                  user: searchState.viewUserlist[index],
                                ),
                              ),
                              separatorBuilder: (_, index) => const Divider(
                                height: 0,
                              ),
                              itemCount: searchState.viewUserlist.length,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 1,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.white,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminAddStaff extends StatelessWidget {
  final ViewductsUser? user;
  const AdminAddStaff({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AuthenticationScreen(user: user),
      ),
    );
  }
}

class AdminAddCountry extends StatelessWidget {
  AdminAddCountry({Key? key}) : super(key: key);
  final TextEditingController country = TextEditingController();
  _clearControllers() {
    country.clear();
  }

  Widget _submitButton(BuildContext? context) {
    return SizedBox(
      // margin: EdgeInsets.symmetric(vertical: 15),
      width: Get.width * 0.3,
      child: TextButton(
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        // color: TwitterColor.dodgetBlue,
        // color: Colors.blueGrey[100],
        onPressed: () {
          feedState.createCountry(authState.userId, country.text.trim());
          _clearControllers();
        },

        // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //   Icon(CupertinoIcons.back),
            Text(
              'Submit',
              style: TextStyle(
                color: Colors.blueGrey[700],
              ),
            ),
            const Icon(CupertinoIcons.forward),
          ],
        ),
      ),
    );
  }

  Widget _entryFeild(String hint,
      {TextEditingController? controller,
      bool isPassword = false,
      bool isEmail = false}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: frostedYellow(
        Container(
          //margin: EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextField(
            controller: controller,
            keyboardType:
                isEmail ? TextInputType.emailAddress : TextInputType.text,
            style: const TextStyle(
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.normal,
            ),
            obscureText: isPassword,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(30.0),
                ),
                borderSide: BorderSide(color: Colors.blueGrey[100]!),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: Colors.white,
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
              ],
            ),
            Material(
              borderRadius: BorderRadius.circular(20),
              color: Colors.transparent,
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
                  child: customText(
                    'Add Country',
                    style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 35,
                        fontWeight: FontWeight.bold),
                  )),
            ),
            _entryFeild('country', controller: country),
            _submitButton(context),
            Obx(() => userCartController.announce == null ||
                    userCartController.announce.isEmpty
                ? const Text('No data')
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: userCartController.announce
                        .map((text) => Container(
                            padding: const EdgeInsets.all(15),
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(30)),
                            child: Text(text.announce.toString(),
                                style:
                                    const TextStyle(color: Colors.blueGrey))))
                        .toList(),
                  ))
          ],
        ),
      ),
    );
  }
}

class AdminAnnouncement extends StatelessWidget {
  AdminAnnouncement({Key? key}) : super(key: key);
  final TextEditingController announcement = TextEditingController();
  _clearControllers() {
    announcement.clear();
  }

  Widget _submitButton(BuildContext? context) {
    return SizedBox(
      // margin: EdgeInsets.symmetric(vertical: 15),
      width: Get.width * 0.3,
      child: TextButton(
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        // color: TwitterColor.dodgetBlue,
        // color: Colors.blueGrey[100],
        onPressed: () {
          adminStaffController.generalAnouncement(
              authState.userId, announcement.text.trim());
          _clearControllers();
        },

        // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //   Icon(CupertinoIcons.back),
            Text(
              'Submit',
              style: TextStyle(
                color: Colors.blueGrey[700],
              ),
            ),
            const Icon(CupertinoIcons.forward),
          ],
        ),
      ),
    );
  }

  Widget _entryFeild(String hint,
      {TextEditingController? controller,
      bool isPassword = false,
      bool isEmail = false}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: frostedYellow(
        Container(
          //margin: EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextField(
            controller: controller,
            keyboardType:
                isEmail ? TextInputType.emailAddress : TextInputType.text,
            style: const TextStyle(
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.normal,
            ),
            obscureText: isPassword,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(30.0),
                ),
                borderSide: BorderSide(color: Colors.blueGrey[100]!),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: Colors.white,
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
              ],
            ),
            Material(
              borderRadius: BorderRadius.circular(20),
              color: Colors.transparent,
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
                  child: customText(
                    'Announcement',
                    style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 35,
                        fontWeight: FontWeight.bold),
                  )),
            ),
            _entryFeild('Announcement', controller: announcement),
            _submitButton(context),
            Obx(() => userCartController.announce == null ||
                    userCartController.announce.isEmpty
                ? const Text('No data')
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: userCartController.announce
                        .map((text) => Container(
                            padding: const EdgeInsets.all(15),
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(30)),
                            child: Text(text.announce.toString(),
                                style:
                                    const TextStyle(color: Colors.blueGrey))))
                        .toList(),
                  ))
          ],
        ),
      ),
    );
  }
}

class AdminStaffProfile extends StatelessWidget {
  final Rx<StaffUserModel>? staffs;
  AdminStaffProfile({Key? key, this.staffs}) : super(key: key);
  Rx<StaffProfileModel> account = StaffProfileModel(amount: []).obs;

  TextEditingController bank = TextEditingController();
  TextEditingController accountNumber = TextEditingController();
  TextEditingController salary = TextEditingController();
  void _salary(
    BuildContext context,
  ) {
    // double height =
    //     ScreenConfig.deviceHeight! - ScreenConfig.getProportionalHeight(374);
    // List<ViewductsUser>? list =
    //     searchState.getVendors(authState.userModel?.location);
    showModalBottomSheet(
        backgroundColor: Colors.red,
        // bounce: true,
        context: context,
        builder: (context) => Material(
              color: bgColor,
              child: SizedBox(
                width: Get.width,
                height: Get.height * 0.7,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: bgColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(.5),
                                blurRadius: 10,
                              )
                            ],
                            borderRadius: BorderRadius.circular(20)),
                        child: Wrap(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                  margin: const EdgeInsets.only(top: 30),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.grey.withOpacity(.3),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    child: TextField(
                                      controller: salary,
                                      //  keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                          icon: Icon(Icons.email_outlined),
                                          fillColor: Colors.white,
                                          border: InputBorder.none,
                                          hintText: "Salary"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(25),
                              child: GestureDetector(
                                  child: const Text("Pay Salary"),
                                  onTap: () async {
                                    await userCartController.staffSalary(
                                        staffs!.value.id,
                                        int.parse(salary.text.trim()),
                                        DateFormat("MMM yyy")
                                            .format(DateTime.now()));

                                    Get.back();
                                  }),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }

  void _bankDetails(
    BuildContext context,
  ) {
    // double height =
    //     ScreenConfig.deviceHeight! - ScreenConfig.getProportionalHeight(374);
    // List<ViewductsUser>? list =
    //     searchState.getVendors(authState.userModel?.location);
    showModalBottomSheet(
        backgroundColor: Colors.red,
        // bounce: true,
        context: context,
        builder: (context) => Material(
              color: bgColor,
              child: SizedBox(
                width: Get.width,
                height: Get.height * 0.7,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: bgColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(.5),
                                blurRadius: 10,
                              )
                            ],
                            borderRadius: BorderRadius.circular(20)),
                        child: Wrap(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                  margin: const EdgeInsets.only(top: 30),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.grey.withOpacity(.3),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    child: TextField(
                                      controller: bank,
                                      decoration: const InputDecoration(
                                          icon: Icon(Icons.email_outlined),
                                          fillColor: Colors.white,
                                          border: InputBorder.none,
                                          hintText: "Bank"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                  margin: const EdgeInsets.only(top: 30),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.grey.withOpacity(.3),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    child: TextField(
                                      controller: accountNumber,
                                      //    keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                          icon: Icon(Icons.email_outlined),
                                          fillColor: Colors.white,
                                          border: InputBorder.none,
                                          hintText: "Account Number"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(25),
                              child: GestureDetector(
                                  // bgColor: Colors.yellow[200],
                                  // txtColor: Colors.black,
                                  child: const Text("add Acount"),
                                  //  shadowColor: Colors.black87,
                                  onTap: () async {
                                    //adminStaffController.signIn();
                                    if (bank.text.isNotEmpty &&
                                        accountNumber.text.isNotEmpty) {
                                      await adminStaffController
                                          .adminStaffAccount(
                                              staffs!.value.id,
                                              bank.text.trim(),
                                              accountNumber.text.trim());
                                      Get.back();
                                      Get.snackbar(
                                        "Account Added",
                                        "Nice job!",
                                        icon: Container(
                                          height: Get.width * 0.1,
                                          width: Get.width * 0.1,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              image: const DecorationImage(
                                                  image: AssetImage(
                                                      'assets/folder.png'))),
                                        ),
                                      );
                                    } else {
                                      Get.snackbar(
                                        "fill in the",
                                        "Account details!",
                                        icon: Container(
                                          height: Get.width * 0.1,
                                          width: Get.width * 0.1,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              image: const DecorationImage(
                                                  image: AssetImage(
                                                      'assets/folder.png'))),
                                        ),
                                      );
                                    }
                                  }),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    adminStaffController.viewductsStaffActivd();
    adminStaffController.account
        .bindStream(adminStaffController.listenToAccount(staffs!.value.id));
    account.bindStream(adminStaffController.listenToAccount(staffs!.value.id));
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.white,
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
                ],
              ),
              ListTile(
                onTap: () {},
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StatusView(
                    unSeenColor: staffs!.value.role == 'Accountant'
                        ? Colors.green
                        : staffs!.value.role == 'Sales Agent'
                            ? Colors.blue
                            : staffs!.value.role == 'General Manager'
                                ? Colors.yellow
                                : staffs!.value.role == 'Sales Manager'
                                    ? Colors.red
                                    : Colors.pink,
                    radius: Get.width * 0.08,
                    numberOfStatus: 1,
                    centerImageUrl: searchState.viewUserlist
                        .firstWhere((user) => user.userId == staffs?.value.id,
                            orElse: () => authState.profileUser.value)
                        .profilePic
                        .toString(),
                  ),
                ),
                title: customText(
                  staffs!.value.name.toString(),
                  style: const TextStyle(
                      // color: Colors.white70,

                      //fontSize: 35,
                      fontWeight: FontWeight.w400),
                ),
                subtitle: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customText(
                      staffs!.value.state.toString(),
                      style: const TextStyle(
                          //  color: Colors.white24,

                          //fontSize: 35,
                          fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(width: 5),
                    customText(
                      staffs!.value.country.toString(),
                      style: const TextStyle(
                          color: Colors.yellow,

                          //fontSize: 35,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
                trailing: customText(
                  staffs!.value.role.toString(),
                  style: const TextStyle(
                      // color: Colors.white38,

                      //fontSize: 35,
                      fontWeight: FontWeight.w600),
                ),
              ),
              // staffs!.value.role != 'owner'
              //     ||
              // userCartController.staff
              //                 .firstWhere(
              //                     (id) => id.id == authState.appUser?.$id)
              //                 .role !=
              //             'General Manager' ||
              //         userCartController.staff
              //                 .firstWhere(
              //                     (id) => id.id == authState.appUser?.$id)
              //                 .role !=
              //             'Accountant' ||
              userCartController.staff
                          .firstWhere((id) => id.id == authState.appUser?.$id)
                          .role !=
                      'owner'
                  ? Container()
                  : GestureDetector(
                      onTap: () {
                        _salary(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 3),
                        decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.circular(10)),
                        child:
                            customTitleText('Pay ${staffs!.value.name} Salary'),
                      ),
                    ),
              // userCartController.staff
              //                 .firstWhere(
              //                     (id) => id.id == authState.appUser?.$id)
              //                 .role !=
              //             'General Manager' ||
              userCartController.staff
                          .firstWhere((id) => id.id == authState.appUser?.$id)
                          .role !=
                      'Accountant'
                  ? Container()
                  : GestureDetector(
                      onTap: () {
                        _salary(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 3),
                        decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.circular(10)),
                        child:
                            customTitleText('Pay ${staffs!.value.name} Salary'),
                      ),
                    ),
              userCartController.staff
                          .firstWhere((id) => id.id == authState.appUser?.$id)
                          .role !=
                      'General Manager'
                  ? Container()
                  : GestureDetector(
                      onTap: () {
                        _salary(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 3),
                        decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.circular(10)),
                        child:
                            customTitleText('Pay ${staffs!.value.name} Salary'),
                      ),
                    ),
              if (Responsive.isMobile(context))
                const SizedBox(height: defaultPadding),
              if (Responsive.isMobile(context))
                Container(
                  padding: const EdgeInsets.all(defaultPadding),
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      account.value.account == null
                          ? ListTile(
                              onTap: () {
                                _bankDetails(
                                  context,
                                );
                              },
                              leading: Image.asset('assets/folder.png'),
                              title: Text(
                                "Add",
                                style: TextStyle(
                                  fontSize: Get.width * 0.04,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                              subtitle: Text(
                                "Account Number",
                                style: TextStyle(
                                  fontSize: Get.width * 0.04,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: const Icon(
                                CupertinoIcons.add_circled_solid,
                                color: Colors.yellow,
                              ),
                            )
                          : StorageInfoCard(
                              svgSrc: "assets/folder.png",
                              title: "Bank Account",
                              amountOfFiles: Text(
                                account.value.bank.toString(),
                                style: const TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold),
                              ),
                              numOfFiles: Text(
                                account.value.account.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(color: Colors.yellow),
                              ),
                            ),

                      account.value.amount!.isEmpty
                          ? Container()
                          : const Text(
                              "Salary Paid",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                      const SizedBox(height: defaultPadding),
                      //  Chart(),
                      account.value.amount == null
                          ? Container()
                          : Column(
                              children: account.value.amount!
                                  .map(
                                    (salary) => StorageInfoCard(
                                      svgSrc: "assets/book.png",
                                      title: salary.month.toString(),
                                      amountOfFiles: const Text(
                                        'Paid',
                                        style: TextStyle(
                                            color: Colors.white70,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      numOfFiles: Text(
                                        salary.amount.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption!
                                            .copyWith(color: Colors.yellow),
                                      ),
                                    ),
                                  )
                                  .toList())
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

class AdminStaff extends StatelessWidget {
  const AdminStaff({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: Get.width * 0.15,
              left: 0,
              child: SingleChildScrollView(
                child: SizedBox(
                  width: Get.width,
                  height: Get.height,
                  child: Column(
                    children: userCartController.staff.value
                        .map((staffs) => Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    Get.to(
                                      () => AdminStaffProfile(
                                        staffs: staffs.obs,
                                      ),
                                    );
                                  },
                                  leading: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: StatusView(
                                      unSeenColor: staffs.role == 'Accountant'
                                          ? Colors.green
                                          : staffs.role == 'Sales Agent'
                                              ? Colors.blue
                                              : staffs.role == 'General Manager'
                                                  ? Colors.yellow
                                                  : staffs.role ==
                                                          'Sales Manager'
                                                      ? Colors.red
                                                      : Colors.pink,
                                      radius: Get.width * 0.08,
                                      numberOfStatus: 1,
                                      centerImageUrl: searchState.viewUserlist
                                          .firstWhere(
                                              (user) =>
                                                  user.userId == staffs.id,
                                              orElse: () =>
                                                  authState.profileUser.value)
                                          .profilePic
                                          .toString(),
                                    ),
                                  ),
                                  title: customText(
                                    staffs.name.toString(),
                                    style: const TextStyle(

                                        //fontSize: 35,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customText(
                                        staffs.state.toString(),
                                        style: const TextStyle(

                                            //fontSize: 35,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      customText(
                                        staffs.country.toString(),
                                        style: const TextStyle(
                                            color: Colors.yellow,

                                            //fontSize: 35,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  trailing: customText(
                                    staffs.role.toString(),
                                    style: const TextStyle(

                                        //fontSize: 35,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Divider(
                                    height: 3,
                                  ),
                                )
                              ],
                            ))
                        .toList(),
                    // Expanded(
                    //   flex: 20,
                    //   child: Container(
                    //     width: Get.width,
                    //     height: searchState.userlist?.length == 1
                    //         ? Get.width * 0.2
                    //         : context.width * 0.5,
                    //     child: ListView.separated(
                    //       addAutomaticKeepAlives: false,
                    //       physics: BouncingScrollPhysics(),
                    //       itemBuilder: (context, index) => Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: _UserTile(
                    //           user: searchState.userlist![index],
                    //         ),
                    //       ),
                    //       separatorBuilder: (_, index) => Divider(
                    //         height: 0,
                    //       ),
                    //       itemCount: searchState.userlist?.length ?? 0,
                    //     ),
                    //   ),
                    //   //  ListView.separated(
                    //   //   physics: BouncingScrollPhysics(),
                    //   //   itemBuilder: (context, index) => _UserTile(
                    //   //     user: searchState.userlist[index],
                    //   //   ),
                    //   //   separatorBuilder: (_, index) => Divider(
                    //   //     height: 0,
                    //   //   ),
                    //   //   itemCount: searchState.userlist?.length,
                    //   // ),
                    // )
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 1,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.white,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminAllUserOrdersDetails extends StatelessWidget {
  final String? id;
  AdminAllUserOrdersDetails({Key? key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    adminStaffController.orders = RxList<OrderViewProduct>();

    adminStaffController.adminIndividualUsersOrders(id);
    // orders.bindStream(userCartController.adminAllUsersOrders(id));
    return Scaffold(
      body: SafeArea(
        //backgroundColor: bgColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: Get.width,
                height: Get.width * 0.2,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: Colors.white,
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
                  ],
                ),
              ),
              SingleChildScrollView(
                  child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: adminStaffController.orders.value
                      .map((cartItem) => ProfileOrders(
                            cartItem: cartItem.obs,
                          ))
                      .toList(),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class AdminUserOrdersDetails extends HookWidget {
  final String? id;
  AdminUserOrdersDetails({Key? key, this.id}) : super(key: key);
  // final RxList<OrderViewProduct> orders = RxList<OrderViewProduct>();
  @override
  Widget build(BuildContext context) {
    data() async {
      await adminStaffController.adminIndividualUsersOrders(id);
    }

    useEffect(
      () {
        data();

        return () {};
      },
      [adminStaffController.orders],
    );
    // orders.bindStream(userCartController.adminAllUsersOrders(id));
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: Get.width,
                height: Get.width * 0.2,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: Colors.white,
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
                  ],
                ),
              ),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: adminStaffController.proccessedorders.value
                      // .where(
                      //     (id) => id.staff == authState.appUser?.$id.toString())
                      .map((cartItem) => ProfileOrders(
                            cartItem: cartItem.obs,
                            country: searchState.viewUserlist
                                .firstWhere(
                                    (user) => user.userId == cartItem.userId,
                                    orElse: () => ViewductsUser())
                                .location
                                .toString(),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AdminUserOrders extends HookWidget {
  const AdminUserOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // userCartController.adminUserOrders
    //     .bindStream(adminStaffController.listenAdminUserOrders());

    data() async {
      searchState.viewUserlist = RxList<ViewductsUser>();
      final database = Databases(
        serverApi.serverClientConnect(),
      );

      await database
          .listDocuments(
        databaseId: databaseId,
        collectionId: profileUserColl,

        //  queries: [query.Query.equal('key', ductId)]
      )
          .then((data) {
        if (data.documents.isNotEmpty) {
          var value = data.documents
              .map((e) => ViewductsUser.fromJson(e.data))
              .toList();

          searchState.viewUserlist.value = value;
        }
      });
      await adminStaffController.listenAdminUserOrders();
    }

    useEffect(
      () {
        data();

        return () {};
      },
      [],
    );
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: Get.width * 0.15,
              left: 0,
              child: SingleChildScrollView(
                child: SizedBox(
                  width: Get.width,
                  height: Get.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: Get.height,
                          //  width: fullWidth(context),
                          child: Obx(
                            () => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // scrollDirection: Axis.horizontal,
                              children: adminStaffController
                                  .adminUserOrders.value
                                  .map((cartItem) {
                                // adminStaffController.adminIndividualUsersOrders(
                                //     cartItem.userId);
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        Get.to(
                                          () => AdminAllUserOrdersDetails(
                                            id: cartItem.userId,
                                          ),
                                        );
                                      },
                                      leading: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: StatusView(
                                          unSeenColor:
                                              cartItem.orderState == 'New'
                                                  ? Colors.orange
                                                  : Colors.grey,
                                          radius: Get.width * 0.08,
                                          numberOfStatus:
                                              adminStaffController.orders
                                                  .where(
                                                    (data) =>
                                                        data.userId ==
                                                        cartItem.userId,
                                                  )
                                                  .length,
                                          centerImageUrl: searchState
                                              .viewUserlist
                                              .firstWhere(
                                                  (user) =>
                                                      user.userId ==
                                                      cartItem.userId,
                                                  orElse: () => ViewductsUser())
                                              .profilePic
                                              .toString(),
                                        ),
                                      ),
                                      title: customText(
                                        searchState.viewUserlist
                                            .firstWhere(
                                                (user) =>
                                                    user.userId ==
                                                    cartItem.userId,
                                                orElse: () => ViewductsUser())
                                            .displayName
                                            .toString(),
                                        style: const TextStyle(
                                            //  color: Colors.white70,

                                            //fontSize: 35,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      subtitle: customText(
                                        DateTime.parse(cartItem.placedDate!
                                                .toDate()
                                                .toString())
                                            .toString(),
                                        style: const TextStyle(
                                            // color: Colors.white38,

                                            //fontSize: 35,
                                            fontWeight: FontWeight.w400),
                                      ),
                                      trailing: customText(
                                        cartItem.orderState.toString(),
                                        style: const TextStyle(
                                            // color: CupertinoColors
                                            //     .lightBackgroundGray,

                                            //fontSize: 35,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Container(
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
                                          color: CupertinoColors
                                              .lightBackgroundGray),
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        children: [
                                          Text(
                                            cartItem.state.toString(),
                                            style: const TextStyle(
                                                // color: CupertinoColors
                                                //     .systemYellow,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(cartItem.country.toString(),
                                              style: const TextStyle(
                                                  // color: CupertinoColors
                                                  //     .systemYellow,
                                                  fontWeight: FontWeight.w200)),
                                        ],
                                      ),
                                    )
                                  ],
                                );
                              }).toList(),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 1,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    color: Colors.white,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminUserProccessedOrders extends HookWidget {
  AdminUserProccessedOrders({Key? key}) : super(key: key);

  // final RxList<OrderViewProduct> orders = RxList<OrderViewProduct>();
  @override
  Widget build(BuildContext context) {
    data() async {
      searchState.viewUserlist = RxList<ViewductsUser>();
      final database = Databases(
        serverApi.serverClientConnect(),
      );

      await database.listDocuments(
          databaseId: databaseId,
          collectionId: profileUserColl,
          queries: [
            Query.equal(
                'key',
                adminStaffController.staffprocessedUserOrders.value
                    .map((data) => data.userId.toString())
                    .toList())
          ]
          //  queries: [query.Query.equal('key', ductId)]
          ).then((data) {
        if (data.documents.isNotEmpty) {
          var value = data.documents
              .map((e) => ViewductsUser.fromJson(e.data))
              .toList();

          searchState.viewUserlist.value = value;
        }
      });
      await adminStaffController
          .listenStaffprocessedOrders(authState.appUser?.$id);
    }

    useEffect(
      () {
        data();

        return () {};
      },
      [],
    );
    // userCartController.staffprocessedUserOrders.bindStream(
    //     adminStaffController.listenStaffprocessedOrders(authState.userId));
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: Get.width * 0.15,
              left: 0,
              child: SingleChildScrollView(
                child: SizedBox(
                    width: Get.width,
                    height: Get.height,
                    child: Obx(
                      () => adminStaffController
                              .staffprocessedUserOrders.value.isEmpty
                          ? Center(
                              child: frostedYellow(
                              Container(
                                width: Get.width * 0.5,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 3),
                                decoration: BoxDecoration(
                                    color: Colors.yellow,
                                    borderRadius: BorderRadius.circular(10)),
                                child: customTitleText(
                                    'You have not processed any product'),
                              ),
                            ))
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: Get.height,
                                  //  width: fullWidth(context),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    // scrollDirection: Axis.horizontal,
                                    children: adminStaffController
                                        .staffprocessedUserOrders.value

                                        //  .where((id) => id.staff == authState.userId)
                                        .map((cartItem) {
                                      adminStaffController
                                          .adminIndividualUsersOrders(
                                              cartItem.userId);
                                      // orders.bindStream( adminStaffController.
                                      //     .adminAllUsersOrders(
                                      //         cartItem.userId));
                                      return ListTile(
                                        onTap: () {
                                          Get.to(
                                            () => AdminUserOrdersDetails(
                                              id: cartItem.userId,
                                            ),
                                          );
                                        },
                                        leading: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: StatusView(
                                            unSeenColor: Colors.cyan,
                                            radius: Get.width * 0.08,
                                            numberOfStatus: adminStaffController
                                                .orders.value.length,
                                            centerImageUrl: searchState
                                                .viewUserlist
                                                .firstWhere(
                                                    (user) =>
                                                        user.userId ==
                                                        cartItem.userId,
                                                    orElse: () =>
                                                        ViewductsUser())
                                                .profilePic
                                                .toString(),
                                          ),
                                        ),
                                        title: customText(
                                          searchState.viewUserlist
                                              .firstWhere(
                                                  (user) =>
                                                      user.userId ==
                                                      cartItem.userId,
                                                  orElse: () => ViewductsUser())
                                              .displayName
                                              .toString(),
                                          style: const TextStyle(
                                              // color: Colors.white70,

                                              //fontSize: 35,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        subtitle: Container(
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
                                              color: CupertinoColors
                                                  .lightBackgroundGray),
                                          padding: const EdgeInsets.all(5.0),
                                          child: customText(
                                            DateTime.parse(cartItem.placedDate!
                                                    .toDate()
                                                    .toString())
                                                .toString(),
                                            style: const TextStyle(
                                                // color: Colors.white38,

                                                //fontSize: 35,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                    )),
              ),
            ),
            Positioned(
              top: 10,
              left: 1,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    //color: Colors.white,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminMarketCategory extends StatelessWidget {
  const AdminMarketCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Admin();
  }
}

class AdminAddProduct extends StatelessWidget {
  const AdminAddProduct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Material(
        child: AddProduct(
      isTweet: true,
    ));
  }
}

class _UserTile extends StatelessWidget {
  _UserTile({Key? key, this.user}) : super(key: key);
  final ViewductsUser? user;

  Rx<UserBankAccountModel> account = UserBankAccountModel(amount: []).obs;
  @override
  Widget build(BuildContext context) {
    account
        .bindStream(adminStaffController.listenToUserBankAccount(user!.userId));
    return
        //  authState.userId == user.userId
        //     ? Container()
        //     :
        Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(0),
            bottomLeft: Radius.circular(20)),
      ),
      child:
          //  Obx(
          //   () =>
          ViewDuctMenuHolder(
        onPressed: () {},
        menuItems: <DuctFocusedMenuItem>[
          DuctFocusedMenuItem(
              backgroundColor: CupertinoColors.darkBackgroundGray,
              title: const Text(
                'Register as Staff',
                style: TextStyle(color: CupertinoColors.lightBackgroundGray),
              ),
              onPressed: () async {
                Get.to(() => AdminAddStaff(user: user));
                //  Get.to(() => SettingsAndPrivacyPage());
              },
              trailingIcon: const Icon(
                CupertinoIcons.person,
                color: CupertinoColors.lightBackgroundGray,
              )),
          DuctFocusedMenuItem(
              backgroundColor: CupertinoColors.darkBackgroundGray,
              title: const Text(
                'chat',
                style: TextStyle(color: CupertinoColors.lightBackgroundGray),
              ),
              onPressed: () async {
                kAnalytics.logViewSearchResults(searchTerm: user!.userName!);
                // final chatState = Provider.of<ChatState>(context, listen: false);
                chatState.setChatUser = user;
                // Get.back();
                // Navigator.pop(Get.context);
                Get.to(
                    () => ChatScreenPage(
                          userProfileId: user!.userId,
                        ),
                    transition: Transition.downToUp);
                // Navigator.pushNamed(context, '/ChatScreenPage');
                //  Get.to(() => SettingsAndPrivacyPage());
              },
              trailingIcon: const Icon(CupertinoIcons.chat_bubble,
                  color: CupertinoColors.lightBackgroundGray)),
          DuctFocusedMenuItem(
              backgroundColor: CupertinoColors.darkBackgroundGray,
              title: const Text(
                'Account',
                style: TextStyle(color: CupertinoColors.lightBackgroundGray),
              ),
              onPressed: () async {
                Get.to(() => AdminUserAccountBalance(user: user),
                    transition: Transition.downToUp);
                // Navigator.pushNamed(context, '/ChatScreenPage');
                //  Get.to(() => SettingsAndPrivacyPage());
              },
              trailingIcon: const Icon(CupertinoIcons.money_rubl_circle,
                  color: CupertinoColors.lightBackgroundGray)),
        ],
        child: ListTile(
          // onTap: () {

          // },
          leading: Stack(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.transparent,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.yellow.shade200,
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.transparent,
                            child: Material(
                              elevation: 20,
                              borderRadius: BorderRadius.circular(100),
                              child: customImage(context, user!.profilePic,
                                  height: Get.height * 0.06),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: user!.isVerified == true
                        ? Material(
                            elevation: 10,
                            borderRadius: BorderRadius.circular(100),
                            child: CircleAvatar(
                              radius: 9,
                              backgroundColor: Colors.transparent,
                              child: Image.asset('assets/delicious.png'),
                            ),
                          )
                        : Container(),
                  )
                ],
              ),
            ],
          ),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: TitleText(user!.displayName,
                    // color: Colors.white38,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(width: 3),
              // user!.isVerified!
              //     ? CircleAvatar(
              //         radius: 10,
              //         backgroundColor: Colors.transparent,
              //         child: Image.asset('assets/shopping-bag.png'),
              //       )
              //     : const SizedBox(width: 0),
            ],
          ),
          subtitle: Row(
            children: [
              Text(
                user!.state.toString(),
                style: const TextStyle(
                    // color: CupertinoColors.systemYellow,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(user!.location.toString(),
                  style: const TextStyle(
                      // color: CupertinoColors.systemYellow,
                      fontWeight: FontWeight.w200)),
            ],
          ),

          // trailing: SizedBox(
          //   width: 10,
          //   height: 10,
          //   child: Row(
          //     children: [
          //       account.value.amount!
          //               .where((e) => e.paymentState == 'requested')
          //               .isEmpty
          //           ? Container()
          //           : const SizedBox(
          //               width: 10,
          //               height: 10,
          //               child: CircleAvatar(
          //                 backgroundColor: Colors.red,
          //                 radius: 5,
          //               ),
          //             ),
          //     ],
          //   ),
          //  ),
        ),
      ),
      //)
    );
  }
}

class _UserTileRequst extends HookWidget {
  _UserTileRequst({Key? key, this.user}) : super(key: key);
  final ViewductsUser? user;

  @override
  Widget build(BuildContext context) {
    data() async {
      // final database = Databases(
      //   serverApi.serverClientConnect(),
      // );
      // await database.listDocuments(
      //     databaseId: databaseId,
      //     collectionId: monthlycommisionPayment,
      //     queries: [Query.equal('userId', user?.key.toString())]).then((data) {
      //   adminStaffController.commissionRequested.value = data.documents
      //       .map((e) => RequestedCommissionState.fromSnapshot(e.data))
      //       .toList();
      // });
    }

    useEffect(
      () {
        data();

        return () {};
      },
      [adminStaffController.commissionRequested],
    );
    // account
    //     .bindStream(adminStaffController.listenToUserBankAccount(user!.userId));
    return
        //  authState.userId == user.userId
        //     ? Container()
        //     :
        Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(0),
                  bottomLeft: Radius.circular(20)),
            ),
            child: Obx(
              () => adminStaffController.commissionRequested
                      .where((e) => e.paymentState == 'requested')
                      .isEmpty
                  ? Container()
                  : ViewDuctMenuHolder(
                      onPressed: () {},
                      menuItems: <DuctFocusedMenuItem>[
                        DuctFocusedMenuItem(
                            backgroundColor: CupertinoColors.darkBackgroundGray,
                            title: const Text(
                              'Register as Staff',
                              style: TextStyle(
                                  color: CupertinoColors.lightBackgroundGray),
                            ),
                            onPressed: () async {
                              Get.to(() => AdminAddStaff(user: user));
                              //  Get.to(() => SettingsAndPrivacyPage());
                            },
                            trailingIcon: const Icon(
                              CupertinoIcons.person,
                              color: CupertinoColors.lightBackgroundGray,
                            )),
                        DuctFocusedMenuItem(
                            backgroundColor: CupertinoColors.darkBackgroundGray,
                            title: const Text(
                              'chat',
                              style: TextStyle(
                                  color: CupertinoColors.lightBackgroundGray),
                            ),
                            onPressed: () async {
                              kAnalytics.logViewSearchResults(
                                  searchTerm: user!.userName!);
                              // final chatState = Provider.of<ChatState>(context, listen: false);
                              chatState.setChatUser = user;
                              // Get.back();
                              // Navigator.pop(Get.context);
                              chatState.chatMessage.value =
                                  await SQLHelper.findLocalMessages(
                                      '${authState.appUser?.$id.splitByLengths((authState.appUser!.$id.length) ~/ 2)[0]}_${user!.userId!.splitByLengths((user!.userId!.length) ~/ 2)[0]}');
                              if (chatState.chatMessage.value.isEmpty) {
                                chatState.chatMessage.value =
                                    await SQLHelper.findLocalMessages(
                                        '${user!.userId!.splitByLengths((user!.userId!.length) ~/ 2)[0]}_${authState.appUser!.$id.splitByLengths((authState.appUser!.$id.length) ~/ 2)[0]}');
                              }
                              Get.to(
                                  () => ChatResponsive(
                                        userProfileId: user!.userId,
                                      ),
                                  transition: Transition.downToUp);
                              // Navigator.pushNamed(context, '/ChatScreenPage');
                              //  Get.to(() => SettingsAndPrivacyPage());
                            },
                            trailingIcon: const Icon(CupertinoIcons.chat_bubble,
                                color: CupertinoColors.lightBackgroundGray)),
                        DuctFocusedMenuItem(
                            backgroundColor: CupertinoColors.darkBackgroundGray,
                            title: const Text(
                              'Account',
                              style: TextStyle(
                                  color: CupertinoColors.lightBackgroundGray),
                            ),
                            onPressed: () async {
                              Get.to(() => AdminUserAccountBalance(user: user),
                                  transition: Transition.downToUp);
                              // Navigator.pushNamed(context, '/ChatScreenPage');
                              //  Get.to(() => SettingsAndPrivacyPage());
                            },
                            trailingIcon: const Icon(
                                CupertinoIcons.money_rubl_circle,
                                color: CupertinoColors.lightBackgroundGray)),
                        DuctFocusedMenuItem(
                            backgroundColor: CupertinoColors.darkBackgroundGray,
                            title: const Text(
                              'Confirm Payment',
                              style: TextStyle(
                                  color: CupertinoColors.lightBackgroundGray),
                            ),
                            onPressed: () async {
                              adminStaffController.userConfirmCommissionPayment(
                                user!.key,
                                adminStaffController.commissionRequested
                                    .firstWhere((e) => e.userId == user!.key,
                                        orElse: () =>
                                            RequestedCommissionState())
                                    .monthPay,
                              );
                            },
                            trailingIcon: const Icon(CupertinoIcons.creditcard,
                                color: CupertinoColors.lightBackgroundGray)),
                      ],
                      child: ListTile(
                        // onTap: () {

                        // },
                        leading: Stack(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.transparent,
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: CircleAvatar(
                                      radius: 24,
                                      backgroundColor: Colors.yellow.shade200,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: CircleAvatar(
                                      radius: 22,
                                      backgroundColor: Colors.transparent,
                                      child: Material(
                                        elevation: 20,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: customImage(
                                            context, user!.profilePic,
                                            height: Get.height * 0.06),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: user!.isVerified!
                                  ? Material(
                                      elevation: 10,
                                      borderRadius: BorderRadius.circular(100),
                                      child: CircleAvatar(
                                        radius: 9,
                                        backgroundColor: Colors.transparent,
                                        child:
                                            Image.asset('assets/delicious.png'),
                                      ),
                                    )
                                  : const SizedBox(width: 0),
                            )
                          ],
                        ),
                        title: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: TitleText(user!.displayName,
                                  //  color: Colors.white38,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            const SizedBox(width: 3),
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                              user!.state.toString(),
                              style: const TextStyle(
                                  // color: CupertinoColors.systemYellow,
                                  fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(user!.location.toString(),
                                style: const TextStyle(
                                    // color: CupertinoColors.systemYellow,
                                    fontWeight: FontWeight.w200)),
                          ],
                        ),

                        trailing: SizedBox(
                          width: 10,
                          height: 10,
                          child: Row(
                            children: [
                              adminStaffController.commissionRequested
                                          .firstWhere(
                                              (e) => user!.key == e.userId,
                                              orElse: () =>
                                                  RequestedCommissionState())
                                          .paymentState ==
                                      'requested'
                                  ? const SizedBox(
                                      width: 10,
                                      height: 10,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.red,
                                        radius: 5,
                                      ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    ),
            ));
  }
}

class _AdminStaffProfile extends StatelessWidget {
  const _AdminStaffProfile({Key? key, this.user}) : super(key: key);
  final ViewductsUser? user;

  @override
  Widget build(BuildContext context) {
    //var authstate = Provider.of<AuthState>(context, listen: false);
    return
        //  authState.userId == user.userId
        //     ? Container()
        //     :
        Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(0),
            bottomLeft: Radius.circular(20)),
      ),
      child: ListTile(
        onTap: () {
          kAnalytics.logViewSearchResults(searchTerm: user!.userName!);
          // final chatState = Provider.of<ChatState>(context, listen: false);
          chatState.setChatUser = user;
          Get.back();
          // Navigator.pop(Get.context);
          Get.to(() => ChatScreenPage(), transition: Transition.downToUp);
          // Navigator.pushNamed(context, '/ChatScreenPage');
        },
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.transparent,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.yellow.shade200,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.transparent,
                      child: Material(
                        elevation: 20,
                        borderRadius: BorderRadius.circular(100),
                        child: customImage(context, user!.profilePic,
                            height: Get.height * 0.06),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: TitleText(user!.displayName,
                  color: Colors.white38,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(width: 3),
            user!.isVerified!
                ? CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.transparent,
                    child: Image.asset('assets/shopping-bag.png'),
                  )
                : const SizedBox(width: 0),
          ],
        ),
        subtitle: Text(
          user!.userName!,
          style: const TextStyle(color: Colors.white),
        ),
        trailing: Column(
          children: const [],
        ),
      ),
    );
  }
}

class StorageCardView extends StatelessWidget {
  const StorageCardView({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.amountOfFiles,
    required this.numOfFiles,
    this.textStyle,
  }) : super(key: key);
  final TextStyle? textStyle;
  final Widget title;
  final String svgSrc;
  final Widget amountOfFiles, numOfFiles;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: defaultPadding),
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: primaryColor.withOpacity(0.15)),
        borderRadius: const BorderRadius.all(
          Radius.circular(defaultPadding),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            height: 20,
            width: 20,
            child: Image.asset(svgSrc),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title,
                  numOfFiles,
                ],
              ),
            ),
          ),
          amountOfFiles,
        ],
      ),
    );
  }
}

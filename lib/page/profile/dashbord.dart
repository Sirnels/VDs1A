// ignore_for_file: invalid_use_of_protected_member, must_be_immutable, unnecessary_null_comparison, duplicate_ignore

import 'dart:ui';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:viewducts/admin/Admin_dashbord/main.dart';
import 'package:viewducts/apis/auth_api.dart';
import 'package:viewducts/common/common.dart';
import 'package:viewducts/features/auth/controller/auth_controller.dart';
import 'package:viewducts/features/products/product_controller.dart';
import 'package:viewducts/helper/theme.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/page/message/item_Search_bar.dart';
import 'package:viewducts/page/responsiveView.dart';
//import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/duct/profile_orders.dart';
import 'package:viewducts/widgets/frosted.dart';

class Dashboard extends ConsumerWidget {
  final String? profileId;
  final bool isTablet;
  final bool isDesktop;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  Dashboard(
      {Key? key,
      this.profileId,
      this.scaffoldKey,
      this.isTablet = false,
      this.isDesktop = false})
      : super(key: key);

  ValueNotifier<bool> isDuctFeeds = ValueNotifier(false);

  Rx<ValueNotifier<bool>> authorizeState = ValueNotifier(false).obs;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    // final bank = useTextEditingController();
    // final bvn = useTextEditingController();
    // final animationController = useAnimationController(
    //   duration: Duration(milliseconds: 600),
    // );
    // final accountNumber = useTextEditingController();
    // final country = useTextEditingController();
    // final name = useTextEditingController();
    // final pin = useTextEditingController();
    // final bankName = useState(''.obs);
    // final bankCode = useState(''.obs);
    // final bankCountry = useState(''.obs);
    Rx<AdminPaymentActivate> adminpaymentActivState =
        AdminPaymentActivate().obs;
    // final adminpaymentActivState =
    //     useState(userCartController.adminpaymentActiv);
    // final unPaidCommissionState = useState(userCartController.unPaidCommission);
    Rx<double> unPaidTotalCommissionAmountState = 0.0.obs;
    RxList<OrderViewProduct> orderState = RxList<OrderViewProduct>();
    // final unPaidTotalCommissionAmountState =
    //     useState(userCartController.totalCommissionAmount);
    // final paidCommissionState = useState(userCartController.paidCommission);
    // final indexes = useState(0);
    // final viewBanksState = useState(userCartController.viewBanks);
    // final paymentsMethodState = useState(userCartController.paymentMethods);

    // final chipperState = useState(userCartController.userChipperCash);
    Rx<UserBankAccountModel> bankAccountState =
        UserBankAccountModel(amount: []).obs;
    //final bankAccountState = useState(userCartController.useraccounts);
    final realtime = Realtime(clientConnect());
    // data() async {
    //   final database = Databases(
    //     clientConnect(),
    //   );
    //   try {
    //     await database.listDocuments(
    //         databaseId: databaseId,
    //         collectionId: fincraVirtualAccColl,
    //         queries: [Query.equal('key', authState.appUser?.$id)]).then((data) {
    //       var value = data.documents
    //           .map((e) => VirtualSignUpAccountModel.fromSnapshot(e.data))
    //           .toList();

    //       fincraVirtualAccountState.value.value = value;
    //     });
    //   } on AppwriteException catch (e) {
    //     cprint('$e allChatMessage');
    //   }
    // }

    // final viewBanksStream = useStream(realtime.subscribe(
    //     ["databases.$databaseId.collections.banks.documents"]).stream);
    // final fincraStream = useStream(realtime.subscribe([
    //   "databases.$databaseId.collections.$fincraVirtualAccColl.documents"
    // ]).stream);
    // final orderStream = useStream(realtime.subscribe([
    //   "databases.$databaseId.collections.$userOrdersCollection.documents"
    // ]).stream);
    // final unPaidCommissionStream = useStream(realtime.subscribe([
    //   "databases.$databaseId.collections.$unPaidcommision.documents"
    // ]).stream);
    // final paidCommissionStream = useStream(realtime.subscribe([
    //   "databases.$databaseId.collections.$unPaidcommision.documents"
    // ]).stream);
    // final adminpaymentActivStream = useStream(realtime.subscribe([
    //   "databases.$databaseId.collections.$paymentActivate.documents"
    // ]).stream);
    // final bankAccountStream = useStream(realtime.subscribe(
    //     ["databases.$databaseId.collections.$bankAccounts.documents"]).stream);

    // final chipperStream = useStream(realtime.subscribe(
    //     ["databases.$databaseId.collections.$chipperCash.documents"]).stream);

    // void _paymentHistory(BuildContext context) {
    //   showBarModalBottomSheet(
    //       backgroundColor: Colors.red,
    //       bounce: true,
    //       context: context,
    //       builder: (context) => Scaffold(
    //               body: Responsive(
    //             mobile: SizedBox(
    //               height: Get.height * 0.7,
    //               child: Stack(
    //                 children: [
    //                   ThemeMode.system == ThemeMode.light
    //                       ? frostedYellow(
    //                           Container(
    //                             height: fullHeight(context),
    //                             width: fullWidth(context),
    //                             decoration: BoxDecoration(
    //                               // borderRadius: BorderRadius.circular(100),
    //                               //color: Colors.blueGrey[50]
    //                               gradient: LinearGradient(
    //                                 colors: [
    //                                   Colors.yellow[100]!.withOpacity(0.3),
    //                                   Colors.yellow[200]!.withOpacity(0.1),
    //                                   Colors.yellowAccent[100]!.withOpacity(0.2)
    //                                   // Color(0xfffbfbfb),
    //                                   // Color(0xfff7f7f7),
    //                                 ],
    //                                 begin: Alignment.topCenter,
    //                                 end: Alignment.bottomCenter,
    //                               ),
    //                             ),
    //                           ),
    //                         )
    //                       : Container(),
    //                   SizedBox(
    //                     width: Get.width,
    //                     height: Get.height * 0.7,
    //                     child: userCartController
    //                                 .totalPaidCommissionAmount.value ==
    //                             0
    //                         ? Column(
    //                             crossAxisAlignment: CrossAxisAlignment.center,
    //                             mainAxisAlignment: MainAxisAlignment.center,
    //                             children: [
    //                               CircleAvatar(
    //                                 radius: Get.height * 0.08,
    //                                 backgroundColor: Colors.transparent,
    //                                 child: Image.asset('assets/sad.png'),
    //                               ),
    //                               const Center(
    //                                 child: Text('No Commission Recieved Yet'),
    //                               ),
    //                               Padding(
    //                                 padding: const EdgeInsets.all(5.0),
    //                                 child: Container(
    //                                     // width:
    //                                     //    Get.width * 0.3,
    //                                     decoration: BoxDecoration(
    //                                         boxShadow: [
    //                                           BoxShadow(
    //                                               offset: const Offset(0, 11),
    //                                               blurRadius: 11,
    //                                               color: Colors.black
    //                                                   .withOpacity(0.06))
    //                                         ],
    //                                         borderRadius:
    //                                             BorderRadius.circular(18),
    //                                         color:
    //                                             CupertinoColors.activeOrange),
    //                                     padding: const EdgeInsets.all(5.0),
    //                                     child: Text(
    //                                       'Duct smarter to get commission',
    //                                       style: TextStyle(
    //                                           color: CupertinoColors
    //                                               .darkBackgroundGray,
    //                                           fontWeight: FontWeight.w900),
    //                                     )),
    //                               ),
    //                             ],
    //                           )
    //                         : SingleChildScrollView(
    //                             child: Column(
    //                             crossAxisAlignment: CrossAxisAlignment.start,
    //                             mainAxisAlignment: MainAxisAlignment.start,
    //                             children: [
    //                               Padding(
    //                                 padding: const EdgeInsets.all(8.0),
    //                                 child: Row(
    //                                   crossAxisAlignment:
    //                                       CrossAxisAlignment.start,
    //                                   mainAxisAlignment:
    //                                       MainAxisAlignment.start,
    //                                   children: [
    //                                     Material(
    //                                       elevation: 10,
    //                                       borderRadius:
    //                                           BorderRadius.circular(100),
    //                                       child: CircleAvatar(
    //                                         radius: 14,
    //                                         backgroundColor: Colors.transparent,
    //                                         child: Image.asset(
    //                                             'assets/delicious.png'),
    //                                       ),
    //                                     ),
    //                                     Padding(
    //                                       padding: const EdgeInsets.all(5.0),
    //                                       child: Container(
    //                                           // width:
    //                                           //    Get.width * 0.3,
    //                                           decoration: BoxDecoration(
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
    //                                               color: CupertinoColors
    //                                                   .activeGreen),
    //                                           padding:
    //                                               const EdgeInsets.all(5.0),
    //                                           child: Text(
    //                                             'Your vDuct commission',
    //                                             style: TextStyle(
    //                                                 color: CupertinoColors
    //                                                     .darkBackgroundGray,
    //                                                 fontWeight:
    //                                                     FontWeight.w900),
    //                                           )),
    //                                     ),
    //                                   ],
    //                                 ),
    //                               ),
    //                               Obx(
    //                                 () => Column(
    //                                   children: paidCommissionState.value
    //                                       .map((money) => SizedBox(
    //                                             width: Get.width * 0.9,
    //                                             child: GestureDetector(
    //                                               onTap: () {
    //                                                 showBarModalBottomSheet(
    //                                                     backgroundColor:
    //                                                         Colors.red,
    //                                                     bounce: true,
    //                                                     context: context,
    //                                                     builder: (context) =>
    //                                                         ProductResponsiveView(
    //                                                           model: feedState
    //                                                               .productlist!
    //                                                               .firstWhere(
    //                                                                   (e) =>
    //                                                                       e.key ==
    //                                                                       money
    //                                                                           .productId,
    //                                                                   orElse: feedState
    //                                                                       .storyId),
    //                                                         ));
    //                                               },
    //                                               child: StorageCard(
    //                                                 svgSrc: "assets/folder.png",
    //                                                 title: Text(
    //                                                   "Commission",
    //                                                 ),
    //                                                 textStyle: const TextStyle(
    //                                                     color: CupertinoColors
    //                                                         .darkBackgroundGray),
    //                                                 amountOfFiles: Text(
    //                                                   money.month.toString(),
    //                                                   style: const TextStyle(
    //                                                       color: Colors.black,
    //                                                       fontWeight:
    //                                                           FontWeight.bold),
    //                                                 ),
    //                                                 numOfFiles: Row(
    //                                                   children: [
    //                                                     Text(
    //                                                       NumberFormat.currency(
    //                                                               name: authState
    //                                                                           .userModel!
    //                                                                           .location ==
    //                                                                       'Nigeria'
    //                                                                   ? '₦'
    //                                                                   : '£')
    //                                                           .format(
    //                                                               double.parse(
    //                                                         money.amount
    //                                                             .toString(),
    //                                                       )),
    //                                                       style: Theme.of(
    //                                                               context)
    //                                                           .textTheme
    //                                                           .caption!
    //                                                           .copyWith(
    //                                                               color: Colors
    //                                                                   .cyan),
    //                                                     ),
    //                                                     const SizedBox(
    //                                                       width: 5,
    //                                                     ),
    //                                                     Text(
    //                                                       money.paidState
    //                                                           .toString(),
    //                                                       style: Theme.of(
    //                                                               context)
    //                                                           .textTheme
    //                                                           .caption!
    //                                                           .copyWith(
    //                                                               color: Colors
    //                                                                   .black87),
    //                                                     ),
    //                                                   ],
    //                                                 ),
    //                                               ),
    //                                             ),
    //                                           ))
    //                                       .toList(),
    //                                 ),
    //                               ),
    //                             ],
    //                           )),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             tablet: Stack(
    //               children: [
    //                 Row(
    //                   children: [
    //                     Expanded(
    //                       child: SizedBox(
    //                         height: Get.height * 0.7,
    //                         child: Stack(
    //                           children: [
    //                             ThemeMode.system == ThemeMode.light
    //                                 ? frostedYellow(
    //                                     Container(
    //                                       height: fullHeight(context),
    //                                       width: fullWidth(context),
    //                                       decoration: BoxDecoration(
    //                                         // borderRadius: BorderRadius.circular(100),
    //                                         //color: Colors.blueGrey[50]
    //                                         gradient: LinearGradient(
    //                                           colors: [
    //                                             Colors.yellow[100]!
    //                                                 .withOpacity(0.3),
    //                                             Colors.yellow[200]!
    //                                                 .withOpacity(0.1),
    //                                             Colors.yellowAccent[100]!
    //                                                 .withOpacity(0.2)
    //                                             // Color(0xfffbfbfb),
    //                                             // Color(0xfff7f7f7),
    //                                           ],
    //                                           begin: Alignment.topCenter,
    //                                           end: Alignment.bottomCenter,
    //                                         ),
    //                                       ),
    //                                     ),
    //                                   )
    //                                 : Container(),
    //                             SizedBox(
    //                               width: Get.width,
    //                               height: Get.height * 0.7,
    //                               child: userCartController
    //                                           .totalPaidCommissionAmount
    //                                           .value ==
    //                                       0
    //                                   ? Column(
    //                                       crossAxisAlignment:
    //                                           CrossAxisAlignment.center,
    //                                       mainAxisAlignment:
    //                                           MainAxisAlignment.center,
    //                                       children: [
    //                                         CircleAvatar(
    //                                           radius: Get.height * 0.08,
    //                                           backgroundColor:
    //                                               Colors.transparent,
    //                                           child:
    //                                               Image.asset('assets/sad.png'),
    //                                         ),
    //                                         const Center(
    //                                           child: Text(
    //                                               'No Commission Recieved Yet'),
    //                                         ),
    //                                         Padding(
    //                                           padding:
    //                                               const EdgeInsets.all(5.0),
    //                                           child: Container(
    //                                               // width:
    //                                               //    Get.width * 0.3,
    //                                               decoration: BoxDecoration(
    //                                                   boxShadow: [
    //                                                     BoxShadow(
    //                                                         offset:
    //                                                             const Offset(
    //                                                                 0, 11),
    //                                                         blurRadius: 11,
    //                                                         color: Colors.black
    //                                                             .withOpacity(
    //                                                                 0.06))
    //                                                   ],
    //                                                   borderRadius:
    //                                                       BorderRadius.circular(
    //                                                           18),
    //                                                   color: CupertinoColors
    //                                                       .activeOrange),
    //                                               padding:
    //                                                   const EdgeInsets.all(5.0),
    //                                               child: Text(
    //                                                 'Duct smarter to get commission',
    //                                                 style: TextStyle(
    //                                                     color: CupertinoColors
    //                                                         .darkBackgroundGray,
    //                                                     fontWeight:
    //                                                         FontWeight.w900),
    //                                               )),
    //                                         ),
    //                                       ],
    //                                     )
    //                                   : SingleChildScrollView(
    //                                       child: Column(
    //                                       crossAxisAlignment:
    //                                           CrossAxisAlignment.start,
    //                                       mainAxisAlignment:
    //                                           MainAxisAlignment.start,
    //                                       children: [
    //                                         Padding(
    //                                           padding:
    //                                               const EdgeInsets.all(8.0),
    //                                           child: Row(
    //                                             crossAxisAlignment:
    //                                                 CrossAxisAlignment.start,
    //                                             mainAxisAlignment:
    //                                                 MainAxisAlignment.start,
    //                                             children: [
    //                                               Material(
    //                                                 elevation: 10,
    //                                                 borderRadius:
    //                                                     BorderRadius.circular(
    //                                                         100),
    //                                                 child: CircleAvatar(
    //                                                   radius: 14,
    //                                                   backgroundColor:
    //                                                       Colors.transparent,
    //                                                   child: Image.asset(
    //                                                       'assets/delicious.png'),
    //                                                 ),
    //                                               ),
    //                                               Padding(
    //                                                 padding:
    //                                                     const EdgeInsets.all(
    //                                                         5.0),
    //                                                 child: Container(
    //                                                     // width:
    //                                                     //    Get.width * 0.3,
    //                                                     decoration: BoxDecoration(
    //                                                         boxShadow: [
    //                                                           BoxShadow(
    //                                                               offset:
    //                                                                   const Offset(
    //                                                                       0, 11),
    //                                                               blurRadius:
    //                                                                   11,
    //                                                               color: Colors
    //                                                                   .black
    //                                                                   .withOpacity(
    //                                                                       0.06))
    //                                                         ],
    //                                                         borderRadius:
    //                                                             BorderRadius
    //                                                                 .circular(
    //                                                                     18),
    //                                                         color: CupertinoColors
    //                                                             .activeGreen),
    //                                                     padding:
    //                                                         const EdgeInsets
    //                                                             .all(5.0),
    //                                                     child: Text(
    //                                                       'Your vDuct commission',
    //                                                       style: TextStyle(
    //                                                           color: CupertinoColors
    //                                                               .darkBackgroundGray,
    //                                                           fontWeight:
    //                                                               FontWeight
    //                                                                   .w900),
    //                                                     )),
    //                                               ),
    //                                             ],
    //                                           ),
    //                                         ),
    //                                         Obx(
    //                                           () => Column(
    //                                             children:
    //                                                 paidCommissionState.value
    //                                                     .map(
    //                                                         (money) => SizedBox(
    //                                                               width:
    //                                                                   Get.width *
    //                                                                       0.9,
    //                                                               child:
    //                                                                   GestureDetector(
    //                                                                 onTap: () {
    //                                                                   showBarModalBottomSheet(
    //                                                                       backgroundColor: Colors
    //                                                                           .red,
    //                                                                       bounce:
    //                                                                           true,
    //                                                                       context:
    //                                                                           context,
    //                                                                       builder: (context) =>
    //                                                                           ProductResponsiveView(
    //                                                                             model: feedState.productlist!.firstWhere((e) => e.key == money.productId, orElse: feedState.storyId),
    //                                                                           ));
    //                                                                 },
    //                                                                 child:
    //                                                                     StorageCard(
    //                                                                   svgSrc:
    //                                                                       "assets/folder.png",
    //                                                                   title:
    //                                                                       Text(
    //                                                                     "Commission",
    //                                                                   ),
    //                                                                   textStyle:
    //                                                                       const TextStyle(
    //                                                                           color: CupertinoColors.darkBackgroundGray),
    //                                                                   amountOfFiles:
    //                                                                       Text(
    //                                                                     money
    //                                                                         .month
    //                                                                         .toString(),
    //                                                                     style: const TextStyle(
    //                                                                         color:
    //                                                                             Colors.black,
    //                                                                         fontWeight: FontWeight.bold),
    //                                                                   ),
    //                                                                   numOfFiles:
    //                                                                       Row(
    //                                                                     children: [
    //                                                                       Text(
    //                                                                         NumberFormat.currency(name: authState.userModel!.location == 'Nigeria' ? '₦' : '£').format(double.parse(
    //                                                                           money.amount.toString(),
    //                                                                         )),
    //                                                                         style:
    //                                                                             Theme.of(context).textTheme.caption!.copyWith(color: Colors.cyan),
    //                                                                       ),
    //                                                                       const SizedBox(
    //                                                                         width:
    //                                                                             5,
    //                                                                       ),
    //                                                                       Text(
    //                                                                         money.paidState.toString(),
    //                                                                         style:
    //                                                                             Theme.of(context).textTheme.caption!.copyWith(color: Colors.black87),
    //                                                                       ),
    //                                                                     ],
    //                                                                   ),
    //                                                                 ),
    //                                                               ),
    //                                                             ))
    //                                                     .toList(),
    //                                           ),
    //                                         ),
    //                                       ],
    //                                     )),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //             desktop: Stack(
    //               children: [
    //                 BackdropFilter(
    //                   filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
    //                   child: Container(
    //                     color: (Colors.white12).withOpacity(0.1),
    //                   ),
    //                 ),
    //                 Row(
    //                   children: [
    //                     // Once our width is less then 1300 then it start showing errors
    //                     // Now there is no error if our width is less then 1340

    //                     Expanded(
    //                       flex: Get.width > 1340 ? 3 : 5,
    //                       child: PlainScaffold(),
    //                     ),
    //                     Expanded(
    //                       flex: Get.width > 1340 ? 8 : 10,
    //                       child: SizedBox(
    //                         height: Get.height * 0.7,
    //                         child: Stack(
    //                           children: [
    //                             ThemeMode.system == ThemeMode.light
    //                                 ? frostedYellow(
    //                                     Container(
    //                                       height: fullHeight(context),
    //                                       width: fullWidth(context),
    //                                       decoration: BoxDecoration(
    //                                         // borderRadius: BorderRadius.circular(100),
    //                                         //color: Colors.blueGrey[50]
    //                                         gradient: LinearGradient(
    //                                           colors: [
    //                                             Colors.yellow[100]!
    //                                                 .withOpacity(0.3),
    //                                             Colors.yellow[200]!
    //                                                 .withOpacity(0.1),
    //                                             Colors.yellowAccent[100]!
    //                                                 .withOpacity(0.2)
    //                                             // Color(0xfffbfbfb),
    //                                             // Color(0xfff7f7f7),
    //                                           ],
    //                                           begin: Alignment.topCenter,
    //                                           end: Alignment.bottomCenter,
    //                                         ),
    //                                       ),
    //                                     ),
    //                                   )
    //                                 : Container(),
    //                             SizedBox(
    //                               width: Get.width,
    //                               height: Get.height * 0.7,
    //                               child: userCartController
    //                                           .totalPaidCommissionAmount
    //                                           .value ==
    //                                       0
    //                                   ? Column(
    //                                       crossAxisAlignment:
    //                                           CrossAxisAlignment.center,
    //                                       mainAxisAlignment:
    //                                           MainAxisAlignment.center,
    //                                       children: [
    //                                         CircleAvatar(
    //                                           radius: Get.height * 0.08,
    //                                           backgroundColor:
    //                                               Colors.transparent,
    //                                           child:
    //                                               Image.asset('assets/sad.png'),
    //                                         ),
    //                                         const Center(
    //                                           child: Text(
    //                                               'No Commission Recieved Yet'),
    //                                         ),
    //                                         Padding(
    //                                           padding:
    //                                               const EdgeInsets.all(5.0),
    //                                           child: Container(
    //                                               // width:
    //                                               //    Get.width * 0.3,
    //                                               decoration: BoxDecoration(
    //                                                   boxShadow: [
    //                                                     BoxShadow(
    //                                                         offset:
    //                                                             const Offset(
    //                                                                 0, 11),
    //                                                         blurRadius: 11,
    //                                                         color: Colors.black
    //                                                             .withOpacity(
    //                                                                 0.06))
    //                                                   ],
    //                                                   borderRadius:
    //                                                       BorderRadius.circular(
    //                                                           18),
    //                                                   color: CupertinoColors
    //                                                       .activeOrange),
    //                                               padding:
    //                                                   const EdgeInsets.all(5.0),
    //                                               child: Text(
    //                                                 'Duct smarter to get commission',
    //                                                 style: TextStyle(
    //                                                     color: CupertinoColors
    //                                                         .darkBackgroundGray,
    //                                                     fontWeight:
    //                                                         FontWeight.w900),
    //                                               )),
    //                                         ),
    //                                       ],
    //                                     )
    //                                   : SingleChildScrollView(
    //                                       child: Column(
    //                                       crossAxisAlignment:
    //                                           CrossAxisAlignment.start,
    //                                       mainAxisAlignment:
    //                                           MainAxisAlignment.start,
    //                                       children: [
    //                                         Padding(
    //                                           padding:
    //                                               const EdgeInsets.all(8.0),
    //                                           child: Row(
    //                                             crossAxisAlignment:
    //                                                 CrossAxisAlignment.start,
    //                                             mainAxisAlignment:
    //                                                 MainAxisAlignment.start,
    //                                             children: [
    //                                               Material(
    //                                                 elevation: 10,
    //                                                 borderRadius:
    //                                                     BorderRadius.circular(
    //                                                         100),
    //                                                 child: CircleAvatar(
    //                                                   radius: 14,
    //                                                   backgroundColor:
    //                                                       Colors.transparent,
    //                                                   child: Image.asset(
    //                                                       'assets/delicious.png'),
    //                                                 ),
    //                                               ),
    //                                               Padding(
    //                                                 padding:
    //                                                     const EdgeInsets.all(
    //                                                         5.0),
    //                                                 child: Container(
    //                                                     // width:
    //                                                     //    Get.width * 0.3,
    //                                                     decoration: BoxDecoration(
    //                                                         boxShadow: [
    //                                                           BoxShadow(
    //                                                               offset:
    //                                                                   const Offset(
    //                                                                       0, 11),
    //                                                               blurRadius:
    //                                                                   11,
    //                                                               color: Colors
    //                                                                   .black
    //                                                                   .withOpacity(
    //                                                                       0.06))
    //                                                         ],
    //                                                         borderRadius:
    //                                                             BorderRadius
    //                                                                 .circular(
    //                                                                     18),
    //                                                         color: CupertinoColors
    //                                                             .activeGreen),
    //                                                     padding:
    //                                                         const EdgeInsets
    //                                                             .all(5.0),
    //                                                     child: Text(
    //                                                       'Your vDuct commission',
    //                                                       style: TextStyle(
    //                                                           color: CupertinoColors
    //                                                               .darkBackgroundGray,
    //                                                           fontWeight:
    //                                                               FontWeight
    //                                                                   .w900),
    //                                                     )),
    //                                               ),
    //                                             ],
    //                                           ),
    //                                         ),
    //                                         Obx(
    //                                           () => Column(
    //                                             children:
    //                                                 paidCommissionState.value
    //                                                     .map(
    //                                                         (money) => SizedBox(
    //                                                               width:
    //                                                                   Get.width *
    //                                                                       0.9,
    //                                                               child:
    //                                                                   GestureDetector(
    //                                                                 onTap: () {
    //                                                                   showBarModalBottomSheet(
    //                                                                       backgroundColor: Colors
    //                                                                           .red,
    //                                                                       bounce:
    //                                                                           true,
    //                                                                       context:
    //                                                                           context,
    //                                                                       builder: (context) =>
    //                                                                           ProductResponsiveView(
    //                                                                             model: feedState.productlist!.firstWhere((e) => e.key == money.productId, orElse: feedState.storyId),
    //                                                                           ));
    //                                                                 },
    //                                                                 child:
    //                                                                     StorageCard(
    //                                                                   svgSrc:
    //                                                                       "assets/folder.png",
    //                                                                   title:
    //                                                                       Text(
    //                                                                     "Commission",
    //                                                                   ),
    //                                                                   textStyle:
    //                                                                       const TextStyle(
    //                                                                           color: CupertinoColors.darkBackgroundGray),
    //                                                                   amountOfFiles:
    //                                                                       Text(
    //                                                                     money
    //                                                                         .month
    //                                                                         .toString(),
    //                                                                     style: const TextStyle(
    //                                                                         color:
    //                                                                             Colors.black,
    //                                                                         fontWeight: FontWeight.bold),
    //                                                                   ),
    //                                                                   numOfFiles:
    //                                                                       Row(
    //                                                                     children: [
    //                                                                       Text(
    //                                                                         NumberFormat.currency(name: authState.userModel!.location == 'Nigeria' ? '₦' : '£').format(double.parse(
    //                                                                           money.amount.toString(),
    //                                                                         )),
    //                                                                         style:
    //                                                                             Theme.of(context).textTheme.caption!.copyWith(color: Colors.cyan),
    //                                                                       ),
    //                                                                       const SizedBox(
    //                                                                         width:
    //                                                                             5,
    //                                                                       ),
    //                                                                       Text(
    //                                                                         money.paidState.toString(),
    //                                                                         style:
    //                                                                             Theme.of(context).textTheme.caption!.copyWith(color: Colors.black87),
    //                                                                       ),
    //                                                                     ],
    //                                                                   ),
    //                                                                 ),
    //                                                               ),
    //                                                             ))
    //                                                     .toList(),
    //                                           ),
    //                                         ),
    //                                       ],
    //                                     )),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                     ),
    //                     Expanded(
    //                       flex: Get.width > 1340 ? 2 : 4,
    //                       child: PlainScaffold(),
    //                     ),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //           )));
    // }

    // void _bankAccountNumber(BuildContext context) {
    //   showBarModalBottomSheet(
    //       backgroundColor: Colors.red,
    //       bounce: true,
    //       context: context,
    //       builder: (context) => SizedBox(
    //             height: Get.height * 0.7,
    //             child: Scaffold(
    //                 body: Responsive(
    //               mobile: Stack(
    //                 children: [
    //                   SizedBox(
    //                     width: Get.width,
    //                     height: Get.height * 0.7,
    //                     child: SingleChildScrollView(
    //                       child: Column(
    //                         children: <Widget>[
    //                           Container(
    //                             margin: const EdgeInsets.all(10),
    //                             decoration: BoxDecoration(
    //                                 // color: bgColor,
    //                                 boxShadow: [
    //                                   BoxShadow(
    //                                     color: Colors.grey.withOpacity(.5),
    //                                     blurRadius: 10,
    //                                   )
    //                                 ], borderRadius: BorderRadius.circular(20)),
    //                             child: Wrap(
    //                               children: [
    //                                 //  Row(
    //                                 //   mainAxisAlignment:
    //                                 //       MainAxisAlignment.center,
    //                                 //   children: [
    //                                 //     Container(
    //                                 //       width: MediaQuery.of(context)
    //                                 //               .size
    //                                 //               .width /
    //                                 //           1.2,
    //                                 //       margin:
    //                                 //           const EdgeInsets.only(top: 30),
    //                                 //       decoration: BoxDecoration(
    //                                 //         borderRadius:
    //                                 //             BorderRadius.circular(25),
    //                                 //         color: Colors.grey.withOpacity(.3),
    //                                 //       ),
    //                                 //       child: Padding(
    //                                 //         padding: const EdgeInsets.symmetric(
    //                                 //             horizontal: 12, vertical: 4),
    //                                 //         child: TextField(
    //                                 //           controller: name,
    //                                 //           decoration: const InputDecoration(
    //                                 //               icon: Icon(Icons.person),
    //                                 //               fillColor: Colors.white,
    //                                 //               border: InputBorder.none,
    //                                 //               hintText: "Account Name"),
    //                                 //         ),
    //                                 //       ),
    //                                 //     ),
    //                                 //   ],
    //                                 // ),
    //                                 authState.userModel?.location != 'Nigeria'
    //                                     ? Container()
    //                                     : GestureDetector(
    //                                         onTap: () {
    //                                           showCupertinoModalPopup(
    //                                               context: Get.context!,
    //                                               builder:
    //                                                   (context) =>
    //                                                       CupertinoActionSheet(
    //                                                         actions: [
    //                                                           Padding(
    //                                                             padding:
    //                                                                 const EdgeInsets
    //                                                                         .all(
    //                                                                     8.0),
    //                                                             child: Obx(
    //                                                               () =>
    //                                                                   SizedBox(
    //                                                                 height:
    //                                                                     Get.height *
    //                                                                         0.3,
    //                                                                 child: CupertinoPicker(
    //                                                                     looping: true,
    //                                                                     itemExtent: Get.height * 0.1,
    //                                                                     onSelectedItemChanged: (index) {
    //                                                                       indexes.value =
    //                                                                           index;

    //                                                                       bankName.value.value = userCartController
    //                                                                           .viewBanks
    //                                                                           .value
    //                                                                           .allBanks![indexes.value]
    //                                                                           .name!;
    //                                                                       bankCountry.value.value = userCartController
    //                                                                           .viewBanks
    //                                                                           .value
    //                                                                           .allBanks![indexes.value]
    //                                                                           .country!;
    //                                                                       bankCode.value.value = userCartController
    //                                                                           .viewBanks
    //                                                                           .value
    //                                                                           .allBanks![indexes.value]
    //                                                                           .code!;

    //                                                                       //  bankName = value[];
    //                                                                     },
    //                                                                     children: userCartController.viewBanks.value.allBanks!
    //                                                                         .map((data) => GestureDetector(
    //                                                                               onTap: () {
    //                                                                                 bankName.value.value = data.name!;
    //                                                                                 bankCode.value.value = data.code!;
    //                                                                               },
    //                                                                               child: Center(child: Text(data.name.toString())),
    //                                                                             ))
    //                                                                         .toList()),
    //                                                               ),
    //                                                             ),
    //                                                           ),
    //                                                         ],
    //                                                       ));
    //                                         },
    //                                         child: Row(
    //                                           mainAxisAlignment:
    //                                               MainAxisAlignment.center,
    //                                           children: [
    //                                             Container(
    //                                               width: MediaQuery.of(context)
    //                                                       .size
    //                                                       .width /
    //                                                   1.2,
    //                                               margin: const EdgeInsets.only(
    //                                                   top: 30),
    //                                               decoration: BoxDecoration(
    //                                                 borderRadius:
    //                                                     BorderRadius.circular(
    //                                                         25),
    //                                                 color: Colors.grey
    //                                                     .withOpacity(.3),
    //                                               ),
    //                                               child: Column(
    //                                                 crossAxisAlignment:
    //                                                     CrossAxisAlignment
    //                                                         .start,
    //                                                 mainAxisAlignment:
    //                                                     MainAxisAlignment.start,
    //                                                 children: [
    //                                                   Container(
    //                                                     decoration:
    //                                                         BoxDecoration(
    //                                                       borderRadius:
    //                                                           BorderRadius
    //                                                               .circular(25),
    //                                                       color: Colors.blue
    //                                                           .withOpacity(.3),
    //                                                     ),
    //                                                     child: const Padding(
    //                                                       padding:
    //                                                           EdgeInsets.all(
    //                                                               8.0),
    //                                                       child: Text(
    //                                                           'Select Bank',
    //                                                           style: TextStyle(
    //                                                             fontWeight:
    //                                                                 FontWeight
    //                                                                     .bold,
    //                                                           )),
    //                                                     ),
    //                                                   ),
    //                                                   Obx(
    //                                                     () => Padding(
    //                                                         padding:
    //                                                             const EdgeInsets
    //                                                                     .symmetric(
    //                                                                 horizontal:
    //                                                                     12,
    //                                                                 vertical:
    //                                                                     12),
    //                                                         // ignore: unnecessary_null_comparison
    //                                                         child: bankName.obs ==
    //                                                                     null &&
    //                                                                 // ignore: unnecessary_null_comparison
    //                                                                 bankCode.obs ==
    //                                                                     null
    //                                                             ? const Text(
    //                                                                 'Sellect Bank')
    //                                                             : SingleChildScrollView(
    //                                                                 scrollDirection:
    //                                                                     Axis.horizontal,
    //                                                                 child: Row(
    //                                                                     crossAxisAlignment:
    //                                                                         CrossAxisAlignment
    //                                                                             .start,
    //                                                                     mainAxisAlignment:
    //                                                                         MainAxisAlignment.spaceBetween,
    //                                                                     children: [
    //                                                                       Text(userCartController
    //                                                                           .viewBanks
    //                                                                           .value
    //                                                                           .allBanks![indexes.value]
    //                                                                           .name
    //                                                                           .toString()),
    //                                                                       Text(userCartController
    //                                                                           .viewBanks
    //                                                                           .value
    //                                                                           .allBanks![indexes.value]
    //                                                                           .code
    //                                                                           .toString()),
    //                                                                       // Text(bankName!),
    //                                                                       // Text(bankCode!)
    //                                                                     ]),
    //                                                               )),
    //                                                   ),
    //                                                 ],
    //                                               ),
    //                                             ),
    //                                           ],
    //                                         ),
    //                                       ),
    //                                 Row(
    //                                   mainAxisAlignment:
    //                                       MainAxisAlignment.center,
    //                                   children: [
    //                                     Container(
    //                                       width: MediaQuery.of(context)
    //                                               .size
    //                                               .width /
    //                                           1.2,
    //                                       margin:
    //                                           const EdgeInsets.only(top: 30),
    //                                       decoration: BoxDecoration(
    //                                         borderRadius:
    //                                             BorderRadius.circular(25),
    //                                         color: Colors.grey.withOpacity(.3),
    //                                       ),
    //                                       child: Padding(
    //                                         padding: const EdgeInsets.symmetric(
    //                                             horizontal: 12, vertical: 4),
    //                                         child: TextField(
    //                                           controller: accountNumber,
    //                                           // keyboardType:
    //                                           //     TextInputType.number,
    //                                           decoration: InputDecoration(
    //                                               icon: Icon(
    //                                                   Icons.email_outlined),
    //                                               fillColor: Colors.white,
    //                                               border: InputBorder.none,
    //                                               hintText: authState.userModel
    //                                                           ?.location !=
    //                                                       'Nigeria'
    //                                                   ? 'Paypal Account'
    //                                                   : "Account Number"),
    //                                         ),
    //                                       ),
    //                                     ),
    //                                   ],
    //                                 ),
    //                                 authState.userModel?.location != 'Nigeria'
    //                                     ? Container()
    //                                     : Row(
    //                                         mainAxisAlignment:
    //                                             MainAxisAlignment.center,
    //                                         children: [
    //                                           Container(
    //                                             width: MediaQuery.of(context)
    //                                                     .size
    //                                                     .width /
    //                                                 1.2,
    //                                             margin: const EdgeInsets.only(
    //                                                 top: 30),
    //                                             decoration: BoxDecoration(
    //                                               borderRadius:
    //                                                   BorderRadius.circular(25),
    //                                               color: Colors.grey
    //                                                   .withOpacity(.3),
    //                                             ),
    //                                             child: Padding(
    //                                               padding: const EdgeInsets
    //                                                       .symmetric(
    //                                                   horizontal: 12,
    //                                                   vertical: 4),
    //                                               child: TextField(
    //                                                 controller: bvn,
    //                                                 inputFormatters: [
    //                                                   LengthLimitingTextInputFormatter(
    //                                                       11),
    //                                                 ],
    //                                                 keyboardType:
    //                                                     TextInputType.number,
    //                                                 decoration:
    //                                                     const InputDecoration(
    //                                                         icon: Icon(Icons
    //                                                             .email_outlined),
    //                                                         fillColor:
    //                                                             Colors.white,
    //                                                         border: InputBorder
    //                                                             .none,
    //                                                         hintText: "BVN"),
    //                                               ),
    //                                             ),
    //                                           ),
    //                                         ],
    //                                       ),
    //                                 Row(
    //                                   mainAxisAlignment:
    //                                       MainAxisAlignment.center,
    //                                   children: [
    //                                     Container(
    //                                       width: MediaQuery.of(context)
    //                                               .size
    //                                               .width /
    //                                           1.2,
    //                                       margin:
    //                                           const EdgeInsets.only(top: 30),
    //                                       decoration: BoxDecoration(
    //                                         borderRadius:
    //                                             BorderRadius.circular(25),
    //                                         color: Colors.grey.withOpacity(.3),
    //                                       ),
    //                                       child: Padding(
    //                                         padding: const EdgeInsets.symmetric(
    //                                             horizontal: 12, vertical: 12),
    //                                         child: Text(bankCountry
    //                                                 .value.value =
    //                                             viewBanksState
    //                                                 .value
    //                                                 .value
    //                                                 .allBanks![indexes.value]
    //                                                 .country!
    //                                                 .toString()),
    //                                         //  TextField(
    //                                         //   controller: country,
    //                                         //   //    keyboardType: TextInputType.number,
    //                                         //   decoration: const InputDecoration(
    //                                         //       icon: Icon(Icons.email_outlined),
    //                                         //       fillColor: Colors.white,
    //                                         //       border: InputBorder.none,
    //                                         //       hintText: "Country"),
    //                                         //),
    //                                       ),
    //                                     ),
    //                                   ],
    //                                 ),
    //                                 Padding(
    //                                   padding: const EdgeInsets.all(25),
    //                                   child: GestureDetector(
    //                                       // bgColor: Colors.yellow[200],
    //                                       // txtColor: Colors.black,
    //                                       child: Container(
    //                                           // margin: EdgeInsets.all(10),
    //                                           padding: const EdgeInsets.all(10),
    //                                           decoration: BoxDecoration(
    //                                               color: bgColor,
    //                                               boxShadow: [
    //                                                 BoxShadow(
    //                                                   color: Colors.grey
    //                                                       .withOpacity(.5),
    //                                                   blurRadius: 10,
    //                                                 )
    //                                               ],
    //                                               borderRadius:
    //                                                   BorderRadius.circular(
    //                                                       20)),
    //                                           child: Text(
    //                                             authState.userModel?.location !=
    //                                                     'Nigeria'
    //                                                 ? 'Add your paypal Account'
    //                                                 : "add/update Account Number",
    //                                             style: TextStyle(
    //                                                 color: Colors.white70),
    //                                           )),
    //                                       //  shadowColor: Colors.black87,
    //                                       onTap: () async {
    //                                         //adminStaffController.signIn();
    //                                         if (accountNumber.text.isNotEmpty) {
    //                                           await userCartController
    //                                               .userBankAccounts(
    //                                                   '',
    //                                                   accountNumber.text.trim(),
    //                                                   authState.userModel
    //                                                               ?.location !=
    //                                                           'Nigeria'
    //                                                       ? 'Paypal'
    //                                                       : bankName
    //                                                           .value.value,
    //                                                   authState.userModel
    //                                                               ?.location !=
    //                                                           'Nigeria'
    //                                                       ? 'Paypal'
    //                                                       : bankCode
    //                                                           .value.value,
    //                                                   bankCountry.value.value,
    //                                                   bvn.text.trim());
    //                                           Get.back();
    //                                           FToast().showToast(
    //                                               child: Padding(
    //                                                 padding:
    //                                                     const EdgeInsets.all(
    //                                                         5.0),
    //                                                 child: Container(
    //                                                     // width:
    //                                                     //    Get.width * 0.3,
    //                                                     decoration: BoxDecoration(
    //                                                         boxShadow: [
    //                                                           BoxShadow(
    //                                                               offset:
    //                                                                   const Offset(
    //                                                                       0, 11),
    //                                                               blurRadius:
    //                                                                   11,
    //                                                               color: Colors
    //                                                                   .black
    //                                                                   .withOpacity(
    //                                                                       0.06))
    //                                                         ],
    //                                                         borderRadius:
    //                                                             BorderRadius
    //                                                                 .circular(
    //                                                                     18),
    //                                                         color: CupertinoColors
    //                                                             .activeGreen),
    //                                                     padding:
    //                                                         const EdgeInsets
    //                                                             .all(5.0),
    //                                                     child: Text(
    //                                                       'Account Added',
    //                                                       style: TextStyle(
    //                                                           color: CupertinoColors
    //                                                               .darkBackgroundGray,
    //                                                           fontWeight:
    //                                                               FontWeight
    //                                                                   .w900),
    //                                                     )),
    //                                               ),
    //                                               gravity:
    //                                                   ToastGravity.TOP_LEFT,
    //                                               toastDuration:
    //                                                   Duration(seconds: 3));
    //                                           // Get.snackbar(
    //                                           //   "Account Added",
    //                                           //   "Nice job!",
    //                                           //   icon: Container(
    //                                           //     height: Get.width * 0.1,
    //                                           //     width: Get.width * 0.1,
    //                                           //     decoration: BoxDecoration(
    //                                           //         borderRadius:
    //                                           //             BorderRadius.circular(
    //                                           //                 100),
    //                                           //         image: const DecorationImage(
    //                                           //             image: AssetImage(
    //                                           //                 'assets/folder.png'))),
    //                                           //   ),
    //                                           // );
    //                                         } else {
    //                                           FToast().showToast(
    //                                               child: Padding(
    //                                                 padding:
    //                                                     const EdgeInsets.all(
    //                                                         5.0),
    //                                                 child: Container(
    //                                                     // width:
    //                                                     //    Get.width * 0.3,
    //                                                     decoration: BoxDecoration(
    //                                                         boxShadow: [
    //                                                           BoxShadow(
    //                                                               offset:
    //                                                                   const Offset(
    //                                                                       0, 11),
    //                                                               blurRadius:
    //                                                                   11,
    //                                                               color: Colors
    //                                                                   .black
    //                                                                   .withOpacity(
    //                                                                       0.06))
    //                                                         ],
    //                                                         borderRadius:
    //                                                             BorderRadius
    //                                                                 .circular(
    //                                                                     18),
    //                                                         color:
    //                                                             CupertinoColors
    //                                                                 .systemRed),
    //                                                     padding:
    //                                                         const EdgeInsets
    //                                                             .all(5.0),
    //                                                     child: Text(
    //                                                       'Fill all the necessay details',
    //                                                       style: TextStyle(
    //                                                           color: CupertinoColors
    //                                                               .darkBackgroundGray,
    //                                                           fontWeight:
    //                                                               FontWeight
    //                                                                   .w900),
    //                                                     )),
    //                                               ),
    //                                               gravity:
    //                                                   ToastGravity.TOP_LEFT,
    //                                               toastDuration:
    //                                                   Duration(seconds: 3));
    //                                         }
    //                                       }),
    //                                 )
    //                               ],
    //                             ),
    //                           )
    //                         ],
    //                       ),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //               tablet: Stack(
    //                 children: [
    //                   Row(
    //                     children: [
    //                       Expanded(
    //                         child: Stack(
    //                           children: [
    //                             SizedBox(
    //                               width: Get.width,
    //                               height: Get.height * 0.7,
    //                               child: SingleChildScrollView(
    //                                 child: Column(
    //                                   children: <Widget>[
    //                                     Container(
    //                                       margin: const EdgeInsets.all(10),
    //                                       decoration: BoxDecoration(
    //                                           // color: bgColor,
    //                                           boxShadow: [
    //                                             BoxShadow(
    //                                               color: Colors.grey
    //                                                   .withOpacity(.5),
    //                                               blurRadius: 10,
    //                                             )
    //                                           ],
    //                                           borderRadius:
    //                                               BorderRadius.circular(20)),
    //                                       child: Wrap(
    //                                         children: [
    //                                           //  Row(
    //                                           //   mainAxisAlignment:
    //                                           //       MainAxisAlignment.center,
    //                                           //   children: [
    //                                           //     Container(
    //                                           //       width: MediaQuery.of(context)
    //                                           //               .size
    //                                           //               .width /
    //                                           //           1.2,
    //                                           //       margin:
    //                                           //           const EdgeInsets.only(top: 30),
    //                                           //       decoration: BoxDecoration(
    //                                           //         borderRadius:
    //                                           //             BorderRadius.circular(25),
    //                                           //         color: Colors.grey.withOpacity(.3),
    //                                           //       ),
    //                                           //       child: Padding(
    //                                           //         padding: const EdgeInsets.symmetric(
    //                                           //             horizontal: 12, vertical: 4),
    //                                           //         child: TextField(
    //                                           //           controller: name,
    //                                           //           decoration: const InputDecoration(
    //                                           //               icon: Icon(Icons.person),
    //                                           //               fillColor: Colors.white,
    //                                           //               border: InputBorder.none,
    //                                           //               hintText: "Account Name"),
    //                                           //         ),
    //                                           //       ),
    //                                           //     ),
    //                                           //   ],
    //                                           // ),
    //                                           GestureDetector(
    //                                             onTap: () {
    //                                               showCupertinoModalPopup(
    //                                                   context: Get.context!,
    //                                                   builder: (context) =>
    //                                                       CupertinoActionSheet(
    //                                                         actions: [
    //                                                           Padding(
    //                                                             padding:
    //                                                                 const EdgeInsets
    //                                                                         .all(
    //                                                                     8.0),
    //                                                             child: Obx(
    //                                                               () =>
    //                                                                   SizedBox(
    //                                                                 height:
    //                                                                     Get.height *
    //                                                                         0.3,
    //                                                                 child: CupertinoPicker(
    //                                                                     looping: true,
    //                                                                     itemExtent: Get.height * 0.1,
    //                                                                     onSelectedItemChanged: (index) {
    //                                                                       indexes.value =
    //                                                                           index;

    //                                                                       bankName.value.value = userCartController
    //                                                                           .viewBanks
    //                                                                           .value
    //                                                                           .allBanks![indexes.value]
    //                                                                           .name!;
    //                                                                       bankCountry.value.value = userCartController
    //                                                                           .viewBanks
    //                                                                           .value
    //                                                                           .allBanks![indexes.value]
    //                                                                           .country!;
    //                                                                       bankCode.value.value = userCartController
    //                                                                           .viewBanks
    //                                                                           .value
    //                                                                           .allBanks![indexes.value]
    //                                                                           .code!;

    //                                                                       //  bankName = value[];
    //                                                                     },
    //                                                                     children: userCartController.viewBanks.value.allBanks!
    //                                                                         .map((data) => GestureDetector(
    //                                                                               onTap: () {
    //                                                                                 bankName.value.value = data.name!;
    //                                                                                 bankCode.value.value = data.code!;
    //                                                                               },
    //                                                                               child: Center(child: Text(data.name.toString())),
    //                                                                             ))
    //                                                                         .toList()),
    //                                                               ),
    //                                                             ),
    //                                                           ),
    //                                                         ],
    //                                                       ));
    //                                             },
    //                                             child: Row(
    //                                               mainAxisAlignment:
    //                                                   MainAxisAlignment.center,
    //                                               children: [
    //                                                 Container(
    //                                                   width:
    //                                                       MediaQuery.of(context)
    //                                                               .size
    //                                                               .width /
    //                                                           1.2,
    //                                                   margin:
    //                                                       const EdgeInsets.only(
    //                                                           top: 30),
    //                                                   decoration: BoxDecoration(
    //                                                     borderRadius:
    //                                                         BorderRadius
    //                                                             .circular(25),
    //                                                     color: Colors.grey
    //                                                         .withOpacity(.3),
    //                                                   ),
    //                                                   child: Column(
    //                                                     crossAxisAlignment:
    //                                                         CrossAxisAlignment
    //                                                             .start,
    //                                                     mainAxisAlignment:
    //                                                         MainAxisAlignment
    //                                                             .start,
    //                                                     children: [
    //                                                       Container(
    //                                                         decoration:
    //                                                             BoxDecoration(
    //                                                           borderRadius:
    //                                                               BorderRadius
    //                                                                   .circular(
    //                                                                       25),
    //                                                           color: Colors.blue
    //                                                               .withOpacity(
    //                                                                   .3),
    //                                                         ),
    //                                                         child:
    //                                                             const Padding(
    //                                                           padding:
    //                                                               EdgeInsets
    //                                                                   .all(8.0),
    //                                                           child: Text(
    //                                                               'Sellect Bank',
    //                                                               style:
    //                                                                   TextStyle(
    //                                                                 fontWeight:
    //                                                                     FontWeight
    //                                                                         .bold,
    //                                                               )),
    //                                                         ),
    //                                                       ),
    //                                                       Obx(
    //                                                         () => Padding(
    //                                                             padding: const EdgeInsets
    //                                                                     .symmetric(
    //                                                                 horizontal:
    //                                                                     12,
    //                                                                 vertical:
    //                                                                     12),
    //                                                             // ignore: unnecessary_null_comparison
    //                                                             child: bankName.obs ==
    //                                                                         null &&
    //                                                                     // ignore: unnecessary_null_comparison
    //                                                                     bankCode.obs ==
    //                                                                         null
    //                                                                 ? const Text(
    //                                                                     'Sellect Bank')
    //                                                                 : SingleChildScrollView(
    //                                                                     scrollDirection:
    //                                                                         Axis.horizontal,
    //                                                                     child: Row(
    //                                                                         crossAxisAlignment:
    //                                                                             CrossAxisAlignment.start,
    //                                                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                                                                         children: [
    //                                                                           Text(userCartController.viewBanks.value.allBanks![indexes.value].name.toString()),
    //                                                                           Text(userCartController.viewBanks.value.allBanks![indexes.value].code.toString()),
    //                                                                           // Text(bankName!),
    //                                                                           // Text(bankCode!)
    //                                                                         ]),
    //                                                                   )),
    //                                                       ),
    //                                                     ],
    //                                                   ),
    //                                                 ),
    //                                               ],
    //                                             ),
    //                                           ),
    //                                           Row(
    //                                             mainAxisAlignment:
    //                                                 MainAxisAlignment.center,
    //                                             children: [
    //                                               Container(
    //                                                 width:
    //                                                     MediaQuery.of(context)
    //                                                             .size
    //                                                             .width /
    //                                                         1.2,
    //                                                 margin:
    //                                                     const EdgeInsets.only(
    //                                                         top: 30),
    //                                                 decoration: BoxDecoration(
    //                                                   borderRadius:
    //                                                       BorderRadius.circular(
    //                                                           25),
    //                                                   color: Colors.grey
    //                                                       .withOpacity(.3),
    //                                                 ),
    //                                                 child: Padding(
    //                                                   padding: const EdgeInsets
    //                                                           .symmetric(
    //                                                       horizontal: 12,
    //                                                       vertical: 4),
    //                                                   child: TextField(
    //                                                     controller:
    //                                                         accountNumber,
    //                                                     keyboardType:
    //                                                         TextInputType
    //                                                             .number,
    //                                                     decoration: const InputDecoration(
    //                                                         icon: Icon(Icons
    //                                                             .email_outlined),
    //                                                         fillColor:
    //                                                             Colors.white,
    //                                                         border: InputBorder
    //                                                             .none,
    //                                                         hintText:
    //                                                             "Account Number"),
    //                                                   ),
    //                                                 ),
    //                                               ),
    //                                             ],
    //                                           ),
    //                                           Row(
    //                                             mainAxisAlignment:
    //                                                 MainAxisAlignment.center,
    //                                             children: [
    //                                               Container(
    //                                                 width:
    //                                                     MediaQuery.of(context)
    //                                                             .size
    //                                                             .width /
    //                                                         1.2,
    //                                                 margin:
    //                                                     const EdgeInsets.only(
    //                                                         top: 30),
    //                                                 decoration: BoxDecoration(
    //                                                   borderRadius:
    //                                                       BorderRadius.circular(
    //                                                           25),
    //                                                   color: Colors.grey
    //                                                       .withOpacity(.3),
    //                                                 ),
    //                                                 child: Padding(
    //                                                   padding: const EdgeInsets
    //                                                           .symmetric(
    //                                                       horizontal: 12,
    //                                                       vertical: 4),
    //                                                   child: TextField(
    //                                                     controller: bvn,
    //                                                     inputFormatters: [
    //                                                       LengthLimitingTextInputFormatter(
    //                                                           11),
    //                                                     ],
    //                                                     keyboardType:
    //                                                         TextInputType
    //                                                             .number,
    //                                                     decoration:
    //                                                         const InputDecoration(
    //                                                             icon: Icon(Icons
    //                                                                 .email_outlined),
    //                                                             fillColor:
    //                                                                 Colors
    //                                                                     .white,
    //                                                             border:
    //                                                                 InputBorder
    //                                                                     .none,
    //                                                             hintText:
    //                                                                 "BVN"),
    //                                                   ),
    //                                                 ),
    //                                               ),
    //                                             ],
    //                                           ),
    //                                           Row(
    //                                             mainAxisAlignment:
    //                                                 MainAxisAlignment.center,
    //                                             children: [
    //                                               Container(
    //                                                 width:
    //                                                     MediaQuery.of(context)
    //                                                             .size
    //                                                             .width /
    //                                                         1.2,
    //                                                 margin:
    //                                                     const EdgeInsets.only(
    //                                                         top: 30),
    //                                                 decoration: BoxDecoration(
    //                                                   borderRadius:
    //                                                       BorderRadius.circular(
    //                                                           25),
    //                                                   color: Colors.grey
    //                                                       .withOpacity(.3),
    //                                                 ),
    //                                                 child: Padding(
    //                                                   padding: const EdgeInsets
    //                                                           .symmetric(
    //                                                       horizontal: 12,
    //                                                       vertical: 12),
    //                                                   child: Text(bankCountry
    //                                                           .value.value =
    //                                                       viewBanksState
    //                                                           .value
    //                                                           .value
    //                                                           .allBanks![
    //                                                               indexes.value]
    //                                                           .country!
    //                                                           .toString()),
    //                                                   //  TextField(
    //                                                   //   controller: country,
    //                                                   //   //    keyboardType: TextInputType.number,
    //                                                   //   decoration: const InputDecoration(
    //                                                   //       icon: Icon(Icons.email_outlined),
    //                                                   //       fillColor: Colors.white,
    //                                                   //       border: InputBorder.none,
    //                                                   //       hintText: "Country"),
    //                                                   //),
    //                                                 ),
    //                                               ),
    //                                             ],
    //                                           ),
    //                                           Padding(
    //                                             padding:
    //                                                 const EdgeInsets.all(25),
    //                                             child: GestureDetector(
    //                                                 // bgColor: Colors.yellow[200],
    //                                                 // txtColor: Colors.black,
    //                                                 child: Container(
    //                                                     // margin: EdgeInsets.all(10),
    //                                                     padding:
    //                                                         const EdgeInsets
    //                                                             .all(10),
    //                                                     decoration:
    //                                                         BoxDecoration(
    //                                                             color: bgColor,
    //                                                             boxShadow: [
    //                                                               BoxShadow(
    //                                                                 color: Colors
    //                                                                     .grey
    //                                                                     .withOpacity(
    //                                                                         .5),
    //                                                                 blurRadius:
    //                                                                     10,
    //                                                               )
    //                                                             ],
    //                                                             borderRadius:
    //                                                                 BorderRadius
    //                                                                     .circular(
    //                                                                         20)),
    //                                                     child: const Text(
    //                                                       "add/update Account Number",
    //                                                       style: TextStyle(
    //                                                           color: Colors
    //                                                               .white70),
    //                                                     )),
    //                                                 //  shadowColor: Colors.black87,
    //                                                 onTap: () async {
    //                                                   //adminStaffController.signIn();
    //                                                   if (accountNumber
    //                                                       .text.isNotEmpty) {
    //                                                     await userCartController
    //                                                         .userBankAccounts(
    //                                                             '',
    //                                                             accountNumber
    //                                                                 .text
    //                                                                 .trim(),
    //                                                             bankName.value
    //                                                                 .value,
    //                                                             bankCode.value
    //                                                                 .value,
    //                                                             bankCountry
    //                                                                 .value
    //                                                                 .value,
    //                                                             bvn.text
    //                                                                 .trim());
    //                                                     Get.back();
    //                                                     FToast().showToast(
    //                                                         child: Padding(
    //                                                           padding:
    //                                                               const EdgeInsets
    //                                                                   .all(5.0),
    //                                                           child: Container(
    //                                                               // width:
    //                                                               //    Get.width * 0.3,
    //                                                               decoration: BoxDecoration(
    //                                                                   boxShadow: [
    //                                                                     BoxShadow(
    //                                                                         offset: const Offset(
    //                                                                             0, 11),
    //                                                                         blurRadius:
    //                                                                             11,
    //                                                                         color:
    //                                                                             Colors.black.withOpacity(0.06))
    //                                                                   ],
    //                                                                   borderRadius:
    //                                                                       BorderRadius.circular(
    //                                                                           18),
    //                                                                   color: CupertinoColors
    //                                                                       .activeGreen),
    //                                                               padding:
    //                                                                   const EdgeInsets
    //                                                                           .all(
    //                                                                       5.0),
    //                                                               child: Text(
    //                                                                 'Account Added',
    //                                                                 style: TextStyle(
    //                                                                     color: CupertinoColors
    //                                                                         .darkBackgroundGray,
    //                                                                     fontWeight:
    //                                                                         FontWeight.w900),
    //                                                               )),
    //                                                         ),
    //                                                         gravity:
    //                                                             ToastGravity
    //                                                                 .TOP_LEFT,
    //                                                         toastDuration:
    //                                                             Duration(
    //                                                                 seconds:
    //                                                                     3));
    //                                                     // Get.snackbar(
    //                                                     //   "Account Added",
    //                                                     //   "Nice job!",
    //                                                     //   icon: Container(
    //                                                     //     height: Get.width * 0.1,
    //                                                     //     width: Get.width * 0.1,
    //                                                     //     decoration: BoxDecoration(
    //                                                     //         borderRadius:
    //                                                     //             BorderRadius.circular(
    //                                                     //                 100),
    //                                                     //         image: const DecorationImage(
    //                                                     //             image: AssetImage(
    //                                                     //                 'assets/folder.png'))),
    //                                                     //   ),
    //                                                     // );
    //                                                   } else {
    //                                                     FToast().showToast(
    //                                                         child: Padding(
    //                                                           padding:
    //                                                               const EdgeInsets
    //                                                                   .all(5.0),
    //                                                           child: Container(
    //                                                               // width:
    //                                                               //    Get.width * 0.3,
    //                                                               decoration: BoxDecoration(
    //                                                                   boxShadow: [
    //                                                                     BoxShadow(
    //                                                                         offset: const Offset(
    //                                                                             0, 11),
    //                                                                         blurRadius:
    //                                                                             11,
    //                                                                         color:
    //                                                                             Colors.black.withOpacity(0.06))
    //                                                                   ],
    //                                                                   borderRadius:
    //                                                                       BorderRadius.circular(
    //                                                                           18),
    //                                                                   color: CupertinoColors
    //                                                                       .systemRed),
    //                                                               padding:
    //                                                                   const EdgeInsets
    //                                                                           .all(
    //                                                                       5.0),
    //                                                               child: Text(
    //                                                                 'Fill all the necessay details',
    //                                                                 style: TextStyle(
    //                                                                     color: CupertinoColors
    //                                                                         .darkBackgroundGray,
    //                                                                     fontWeight:
    //                                                                         FontWeight.w900),
    //                                                               )),
    //                                                         ),
    //                                                         gravity:
    //                                                             ToastGravity
    //                                                                 .TOP_LEFT,
    //                                                         toastDuration:
    //                                                             Duration(
    //                                                                 seconds:
    //                                                                     3));
    //                                                   }
    //                                                 }),
    //                                           )
    //                                         ],
    //                                       ),
    //                                     )
    //                                   ],
    //                                 ),
    //                               ),
    //                             ),
    //                           ],
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
    //                           children: [
    //                             SizedBox(
    //                               width: Get.width,
    //                               height: Get.height * 0.7,
    //                               child: SingleChildScrollView(
    //                                 child: Column(
    //                                   children: <Widget>[
    //                                     Container(
    //                                       margin: const EdgeInsets.all(10),
    //                                       decoration: BoxDecoration(
    //                                           // color: bgColor,
    //                                           boxShadow: [
    //                                             BoxShadow(
    //                                               color: Colors.grey
    //                                                   .withOpacity(.5),
    //                                               blurRadius: 10,
    //                                             )
    //                                           ],
    //                                           borderRadius:
    //                                               BorderRadius.circular(20)),
    //                                       child: Wrap(
    //                                         children: [
    //                                           //  Row(
    //                                           //   mainAxisAlignment:
    //                                           //       MainAxisAlignment.center,
    //                                           //   children: [
    //                                           //     Container(
    //                                           //       width: MediaQuery.of(context)
    //                                           //               .size
    //                                           //               .width /
    //                                           //           1.2,
    //                                           //       margin:
    //                                           //           const EdgeInsets.only(top: 30),
    //                                           //       decoration: BoxDecoration(
    //                                           //         borderRadius:
    //                                           //             BorderRadius.circular(25),
    //                                           //         color: Colors.grey.withOpacity(.3),
    //                                           //       ),
    //                                           //       child: Padding(
    //                                           //         padding: const EdgeInsets.symmetric(
    //                                           //             horizontal: 12, vertical: 4),
    //                                           //         child: TextField(
    //                                           //           controller: name,
    //                                           //           decoration: const InputDecoration(
    //                                           //               icon: Icon(Icons.person),
    //                                           //               fillColor: Colors.white,
    //                                           //               border: InputBorder.none,
    //                                           //               hintText: "Account Name"),
    //                                           //         ),
    //                                           //       ),
    //                                           //     ),
    //                                           //   ],
    //                                           // ),
    //                                           GestureDetector(
    //                                             onTap: () {
    //                                               showCupertinoModalPopup(
    //                                                   context: Get.context!,
    //                                                   builder: (context) =>
    //                                                       CupertinoActionSheet(
    //                                                         actions: [
    //                                                           Padding(
    //                                                             padding:
    //                                                                 const EdgeInsets
    //                                                                         .all(
    //                                                                     8.0),
    //                                                             child: Obx(
    //                                                               () =>
    //                                                                   SizedBox(
    //                                                                 height:
    //                                                                     Get.height *
    //                                                                         0.3,
    //                                                                 child: CupertinoPicker(
    //                                                                     looping: true,
    //                                                                     itemExtent: Get.height * 0.1,
    //                                                                     onSelectedItemChanged: (index) {
    //                                                                       indexes.value =
    //                                                                           index;

    //                                                                       bankName.value.value = userCartController
    //                                                                           .viewBanks
    //                                                                           .value
    //                                                                           .allBanks![indexes.value]
    //                                                                           .name!;
    //                                                                       bankCountry.value.value = userCartController
    //                                                                           .viewBanks
    //                                                                           .value
    //                                                                           .allBanks![indexes.value]
    //                                                                           .country!;
    //                                                                       bankCode.value.value = userCartController
    //                                                                           .viewBanks
    //                                                                           .value
    //                                                                           .allBanks![indexes.value]
    //                                                                           .code!;

    //                                                                       //  bankName = value[];
    //                                                                     },
    //                                                                     children: userCartController.viewBanks.value.allBanks!
    //                                                                         .map((data) => GestureDetector(
    //                                                                               onTap: () {
    //                                                                                 bankName.value.value = data.name!;
    //                                                                                 bankCode.value.value = data.code!;
    //                                                                               },
    //                                                                               child: Center(child: Text(data.name.toString())),
    //                                                                             ))
    //                                                                         .toList()),
    //                                                               ),
    //                                                             ),
    //                                                           ),
    //                                                         ],
    //                                                       ));
    //                                             },
    //                                             child: Row(
    //                                               mainAxisAlignment:
    //                                                   MainAxisAlignment.center,
    //                                               children: [
    //                                                 Container(
    //                                                   width:
    //                                                       MediaQuery.of(context)
    //                                                               .size
    //                                                               .width /
    //                                                           1.2,
    //                                                   margin:
    //                                                       const EdgeInsets.only(
    //                                                           top: 30),
    //                                                   decoration: BoxDecoration(
    //                                                     borderRadius:
    //                                                         BorderRadius
    //                                                             .circular(25),
    //                                                     color: Colors.grey
    //                                                         .withOpacity(.3),
    //                                                   ),
    //                                                   child: Column(
    //                                                     crossAxisAlignment:
    //                                                         CrossAxisAlignment
    //                                                             .start,
    //                                                     mainAxisAlignment:
    //                                                         MainAxisAlignment
    //                                                             .start,
    //                                                     children: [
    //                                                       Container(
    //                                                         decoration:
    //                                                             BoxDecoration(
    //                                                           borderRadius:
    //                                                               BorderRadius
    //                                                                   .circular(
    //                                                                       25),
    //                                                           color: Colors.blue
    //                                                               .withOpacity(
    //                                                                   .3),
    //                                                         ),
    //                                                         child:
    //                                                             const Padding(
    //                                                           padding:
    //                                                               EdgeInsets
    //                                                                   .all(8.0),
    //                                                           child: Text(
    //                                                               'Sellect Bank',
    //                                                               style:
    //                                                                   TextStyle(
    //                                                                 fontWeight:
    //                                                                     FontWeight
    //                                                                         .bold,
    //                                                               )),
    //                                                         ),
    //                                                       ),
    //                                                       Obx(
    //                                                         () => Padding(
    //                                                             padding: const EdgeInsets
    //                                                                     .symmetric(
    //                                                                 horizontal:
    //                                                                     12,
    //                                                                 vertical:
    //                                                                     12),
    //                                                             // ignore: unnecessary_null_comparison
    //                                                             child: bankName.obs ==
    //                                                                         null &&
    //                                                                     // ignore: unnecessary_null_comparison
    //                                                                     bankCode.obs ==
    //                                                                         null
    //                                                                 ? const Text(
    //                                                                     'Sellect Bank')
    //                                                                 : SingleChildScrollView(
    //                                                                     scrollDirection:
    //                                                                         Axis.horizontal,
    //                                                                     child: Row(
    //                                                                         crossAxisAlignment:
    //                                                                             CrossAxisAlignment.start,
    //                                                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                                                                         children: [
    //                                                                           Text(userCartController.viewBanks.value.allBanks![indexes.value].name.toString()),
    //                                                                           Text(userCartController.viewBanks.value.allBanks![indexes.value].code.toString()),
    //                                                                           // Text(bankName!),
    //                                                                           // Text(bankCode!)
    //                                                                         ]),
    //                                                                   )),
    //                                                       ),
    //                                                     ],
    //                                                   ),
    //                                                 ),
    //                                               ],
    //                                             ),
    //                                           ),
    //                                           Row(
    //                                             mainAxisAlignment:
    //                                                 MainAxisAlignment.center,
    //                                             children: [
    //                                               Container(
    //                                                 width:
    //                                                     MediaQuery.of(context)
    //                                                             .size
    //                                                             .width /
    //                                                         1.2,
    //                                                 margin:
    //                                                     const EdgeInsets.only(
    //                                                         top: 30),
    //                                                 decoration: BoxDecoration(
    //                                                   borderRadius:
    //                                                       BorderRadius.circular(
    //                                                           25),
    //                                                   color: Colors.grey
    //                                                       .withOpacity(.3),
    //                                                 ),
    //                                                 child: Padding(
    //                                                   padding: const EdgeInsets
    //                                                           .symmetric(
    //                                                       horizontal: 12,
    //                                                       vertical: 4),
    //                                                   child: TextField(
    //                                                     controller:
    //                                                         accountNumber,
    //                                                     keyboardType:
    //                                                         TextInputType
    //                                                             .number,
    //                                                     decoration: const InputDecoration(
    //                                                         icon: Icon(Icons
    //                                                             .email_outlined),
    //                                                         fillColor:
    //                                                             Colors.white,
    //                                                         border: InputBorder
    //                                                             .none,
    //                                                         hintText:
    //                                                             "Account Number"),
    //                                                   ),
    //                                                 ),
    //                                               ),
    //                                             ],
    //                                           ),
    //                                           Row(
    //                                             mainAxisAlignment:
    //                                                 MainAxisAlignment.center,
    //                                             children: [
    //                                               Container(
    //                                                 width:
    //                                                     MediaQuery.of(context)
    //                                                             .size
    //                                                             .width /
    //                                                         1.2,
    //                                                 margin:
    //                                                     const EdgeInsets.only(
    //                                                         top: 30),
    //                                                 decoration: BoxDecoration(
    //                                                   borderRadius:
    //                                                       BorderRadius.circular(
    //                                                           25),
    //                                                   color: Colors.grey
    //                                                       .withOpacity(.3),
    //                                                 ),
    //                                                 child: Padding(
    //                                                   padding: const EdgeInsets
    //                                                           .symmetric(
    //                                                       horizontal: 12,
    //                                                       vertical: 4),
    //                                                   child: TextField(
    //                                                     controller: bvn,
    //                                                     inputFormatters: [
    //                                                       LengthLimitingTextInputFormatter(
    //                                                           11),
    //                                                     ],
    //                                                     keyboardType:
    //                                                         TextInputType
    //                                                             .number,
    //                                                     decoration:
    //                                                         const InputDecoration(
    //                                                             icon: Icon(Icons
    //                                                                 .email_outlined),
    //                                                             fillColor:
    //                                                                 Colors
    //                                                                     .white,
    //                                                             border:
    //                                                                 InputBorder
    //                                                                     .none,
    //                                                             hintText:
    //                                                                 "BVN"),
    //                                                   ),
    //                                                 ),
    //                                               ),
    //                                             ],
    //                                           ),
    //                                           Row(
    //                                             mainAxisAlignment:
    //                                                 MainAxisAlignment.center,
    //                                             children: [
    //                                               Container(
    //                                                 width:
    //                                                     MediaQuery.of(context)
    //                                                             .size
    //                                                             .width /
    //                                                         1.2,
    //                                                 margin:
    //                                                     const EdgeInsets.only(
    //                                                         top: 30),
    //                                                 decoration: BoxDecoration(
    //                                                   borderRadius:
    //                                                       BorderRadius.circular(
    //                                                           25),
    //                                                   color: Colors.grey
    //                                                       .withOpacity(.3),
    //                                                 ),
    //                                                 child: Padding(
    //                                                   padding: const EdgeInsets
    //                                                           .symmetric(
    //                                                       horizontal: 12,
    //                                                       vertical: 12),
    //                                                   child: Text(bankCountry
    //                                                           .value.value =
    //                                                       viewBanksState
    //                                                           .value
    //                                                           .value
    //                                                           .allBanks![
    //                                                               indexes.value]
    //                                                           .country!
    //                                                           .toString()),
    //                                                   //  TextField(
    //                                                   //   controller: country,
    //                                                   //   //    keyboardType: TextInputType.number,
    //                                                   //   decoration: const InputDecoration(
    //                                                   //       icon: Icon(Icons.email_outlined),
    //                                                   //       fillColor: Colors.white,
    //                                                   //       border: InputBorder.none,
    //                                                   //       hintText: "Country"),
    //                                                   //),
    //                                                 ),
    //                                               ),
    //                                             ],
    //                                           ),
    //                                           Padding(
    //                                             padding:
    //                                                 const EdgeInsets.all(25),
    //                                             child: GestureDetector(
    //                                                 // bgColor: Colors.yellow[200],
    //                                                 // txtColor: Colors.black,
    //                                                 child: Container(
    //                                                     // margin: EdgeInsets.all(10),
    //                                                     padding:
    //                                                         const EdgeInsets
    //                                                             .all(10),
    //                                                     decoration:
    //                                                         BoxDecoration(
    //                                                             color: bgColor,
    //                                                             boxShadow: [
    //                                                               BoxShadow(
    //                                                                 color: Colors
    //                                                                     .grey
    //                                                                     .withOpacity(
    //                                                                         .5),
    //                                                                 blurRadius:
    //                                                                     10,
    //                                                               )
    //                                                             ],
    //                                                             borderRadius:
    //                                                                 BorderRadius
    //                                                                     .circular(
    //                                                                         20)),
    //                                                     child: const Text(
    //                                                       "add/update Account Number",
    //                                                       style: TextStyle(
    //                                                           color: Colors
    //                                                               .white70),
    //                                                     )),
    //                                                 //  shadowColor: Colors.black87,
    //                                                 onTap: () async {
    //                                                   //adminStaffController.signIn();
    //                                                   if (accountNumber
    //                                                       .text.isNotEmpty) {
    //                                                     await userCartController
    //                                                         .userBankAccounts(
    //                                                             '',
    //                                                             accountNumber
    //                                                                 .text
    //                                                                 .trim(),
    //                                                             bankName.value
    //                                                                 .value,
    //                                                             bankCode.value
    //                                                                 .value,
    //                                                             bankCountry
    //                                                                 .value
    //                                                                 .value,
    //                                                             bvn.text
    //                                                                 .trim());
    //                                                     Get.back();
    //                                                     FToast().showToast(
    //                                                         child: Padding(
    //                                                           padding:
    //                                                               const EdgeInsets
    //                                                                   .all(5.0),
    //                                                           child: Container(
    //                                                               // width:
    //                                                               //    Get.width * 0.3,
    //                                                               decoration: BoxDecoration(
    //                                                                   boxShadow: [
    //                                                                     BoxShadow(
    //                                                                         offset: const Offset(
    //                                                                             0, 11),
    //                                                                         blurRadius:
    //                                                                             11,
    //                                                                         color:
    //                                                                             Colors.black.withOpacity(0.06))
    //                                                                   ],
    //                                                                   borderRadius:
    //                                                                       BorderRadius.circular(
    //                                                                           18),
    //                                                                   color: CupertinoColors
    //                                                                       .activeGreen),
    //                                                               padding:
    //                                                                   const EdgeInsets
    //                                                                           .all(
    //                                                                       5.0),
    //                                                               child: Text(
    //                                                                 'Account Added',
    //                                                                 style: TextStyle(
    //                                                                     color: CupertinoColors
    //                                                                         .darkBackgroundGray,
    //                                                                     fontWeight:
    //                                                                         FontWeight.w900),
    //                                                               )),
    //                                                         ),
    //                                                         gravity:
    //                                                             ToastGravity
    //                                                                 .TOP_LEFT,
    //                                                         toastDuration:
    //                                                             Duration(
    //                                                                 seconds:
    //                                                                     3));
    //                                                     // Get.snackbar(
    //                                                     //   "Account Added",
    //                                                     //   "Nice job!",
    //                                                     //   icon: Container(
    //                                                     //     height: Get.width * 0.1,
    //                                                     //     width: Get.width * 0.1,
    //                                                     //     decoration: BoxDecoration(
    //                                                     //         borderRadius:
    //                                                     //             BorderRadius.circular(
    //                                                     //                 100),
    //                                                     //         image: const DecorationImage(
    //                                                     //             image: AssetImage(
    //                                                     //                 'assets/folder.png'))),
    //                                                     //   ),
    //                                                     // );
    //                                                   } else {
    //                                                     FToast().showToast(
    //                                                         child: Padding(
    //                                                           padding:
    //                                                               const EdgeInsets
    //                                                                   .all(5.0),
    //                                                           child: Container(
    //                                                               // width:
    //                                                               //    Get.width * 0.3,
    //                                                               decoration: BoxDecoration(
    //                                                                   boxShadow: [
    //                                                                     BoxShadow(
    //                                                                         offset: const Offset(
    //                                                                             0, 11),
    //                                                                         blurRadius:
    //                                                                             11,
    //                                                                         color:
    //                                                                             Colors.black.withOpacity(0.06))
    //                                                                   ],
    //                                                                   borderRadius:
    //                                                                       BorderRadius.circular(
    //                                                                           18),
    //                                                                   color: CupertinoColors
    //                                                                       .systemRed),
    //                                                               padding:
    //                                                                   const EdgeInsets
    //                                                                           .all(
    //                                                                       5.0),
    //                                                               child: Text(
    //                                                                 'Fill all the necessay details',
    //                                                                 style: TextStyle(
    //                                                                     color: CupertinoColors
    //                                                                         .darkBackgroundGray,
    //                                                                     fontWeight:
    //                                                                         FontWeight.w900),
    //                                                               )),
    //                                                         ),
    //                                                         gravity:
    //                                                             ToastGravity
    //                                                                 .TOP_LEFT,
    //                                                         toastDuration:
    //                                                             Duration(
    //                                                                 seconds:
    //                                                                     3));
    //                                                   }
    //                                                 }),
    //                                           )
    //                                         ],
    //                                       ),
    //                                     )
    //                                   ],
    //                                 ),
    //                               ),
    //                             ),
    //                           ],
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

    // listenToAllBanksSubs() {
    //   viewBanksStream.data;
    //   if (viewBanksState.value.value != null) {
    //     switch (viewBanksStream.data?.events) {
    //       case ["collections.*.documents"]:
    //         // setState(() {});
    //         viewBanksState.value.value =
    //             (ViewBanks.fromSnapshot(viewBanksStream.data?.payload));

    //         break;
    //       case ["collections.*.documents.*.delete"]:
    //         // setState(() {});
    //         // viewBanksState.value!.value.removeWhere(
    //         //     (datas) => datas.key == viewBanksStream.data!.payload['key']);

    //         break;

    //       default:
    //         break;
    //     }
    //   } else {
    //     cprint('it is empty');
    //   }
    // }

    // listenToUnPaidCommissionSubs() {
    //   unPaidCommissionStream.data;
    //   if (unPaidCommissionState.value.value.isNotEmpty) {
    //     switch (unPaidCommissionStream.data?.events) {
    //       case ["collections.*.documents"]:
    //         // setState(() {});
    //         unPaidCommissionState.value.value.add(UnPaidCommission.fromSnapshot(
    //             unPaidCommissionStream.data?.payload));

    //         break;
    //       case ["collections.*.documents.*.delete"]:
    //         // setState(() {});
    //         // viewBanksState.value!.value.removeWhere(
    //         //     (datas) => datas.key == viewBanksStream.data!.payload['key']);

    //         break;

    //       default:
    //         break;
    //     }
    //   } else {
    //     cprint('it is empty');
    //   }
    // }

    // listenTopaidCommissionSubs() {
    //   paidCommissionStream.data;
    //   if (paidCommissionState.value.value.isNotEmpty) {
    //     switch (paidCommissionStream.data?.events) {
    //       case ["collections.*.documents"]:
    //         // setState(() {});
    //         paidCommissionState.value.value.add(PaidCommission.fromSnapshot(
    //             paidCommissionStream.data?.payload));

    //         break;
    //       case ["collections.*.documents.*.delete"]:
    //         // setState(() {});
    //         // viewBanksState.value!.value.removeWhere(
    //         //     (datas) => datas.key == viewBanksStream.data!.payload['key']);

    //         break;

    //       default:
    //         break;
    //     }
    //   } else {
    //     cprint('it is empty');
    //   }
    // }

    // listenToAdminpaymentActivSubs() {
    //   adminpaymentActivStream.data;
    //   if (adminpaymentActivState.value != null) {
    //     switch (adminpaymentActivStream.data?.events) {
    //       case ["collections.*.documents"]:
    //         // setState(() {});
    //         adminpaymentActivState.value = AdminPaymentActivate.fromSnapshot(
    //                 adminpaymentActivStream.data?.payload)
    //             .obs;

    //         break;
    //       case ["collections.*.documents.*.delete"]:
    //         // setState(() {});
    //         // viewBanksState.value!.value.removeWhere(
    //         //     (datas) => datas.key == viewBanksStream.data!.payload['key']);

    //         break;

    //       default:
    //         break;
    //     }
    //   } else {
    //     cprint('it is empty');
    //   }
    // }

    // listenToFincraVirtualSubs() {
    //   fincraStream.data;
    //   if (fincraVirtualAccountState.value.value != null) {
    //     switch (fincraStream.data?.events) {
    //       case ["collections.*.documents"]:
    //         // setState(() {});
    //         fincraVirtualAccountState.value.add(
    //             VirtualSignUpAccountModel.fromSnapshot(
    //                 fincraStream.data?.payload));

    //         break;
    //       case ["collections.*.documents.*.delete"]:
    //         // setState(() {});
    //         fincraVirtualAccountState.value.value.removeWhere(
    //             (datas) => datas.key == fincraStream.data!.payload['key']);

    //         break;

    //       default:
    //         break;
    //     }
    //   } else {
    //     cprint('it is empty');
    //   }
    // }

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

    // listenToUserBankAccountSubs() {
    //   bankAccountStream.data;
    //   if (bankAccountState.value != null) {
    //     switch (bankAccountStream.data?.events) {
    //       case ["collections.*.documents"]:
    //         // setState(() {});
    //         bankAccountState.value = UserBankAccountModel.fromSnapshot(
    //                 bankAccountStream.data?.payload)
    //             .obs;

    //         break;
    //       case ["collections.*.documents.*.delete"]:
    //         // setState(() {});
    //         // bankAccountState.value.removeWhere(
    //         //     (datas) => datas.key == chatStream.data!.payload['key']);

    //         break;

    //       default:
    //         break;
    //     }
    //   } else {
    //     cprint('it is empty');
    //   }
    // }

    // userChipperCashAccountSub() {
    //   chipperStream.data;
    //   if (chipperState.value.value != null) {
    //     switch (chipperStream.data?.events) {
    //       case ["collections.*.documents"]:
    //         // setState(() {});
    //         chipperState.value =
    //             ChipperCash.fromMap(chipperStream.data!.payload).obs;

    //         break;
    //       case ["collections.*.documents.*.delete"]:
    //         // setState(() {});
    //         // chipperState.value!.value.removeWhere(
    //         //     (datas) => datas.key == chipperStream.data!.payload['key']);

    //         break;

    //       default:
    //         break;
    //     }
    //   } else {
    //     cprint('it is empty');
    //   }
    // }

    // final listenToAllBanksStreaming = useMemoized(() => listenToAllBanksSubs());
    // final listenToUnPaidCommissionStreaming =
    //     useMemoized(() => listenToUnPaidCommissionSubs());
    // final listenTopaidCommissionStreaming =
    //     useMemoized(() => listenTopaidCommissionSubs());
    // final listenToadminpaymentActivStreaming =
    //     useMemoized(() => listenToAdminpaymentActivSubs());
    // final listenToOrdersStreaming = useMemoized(() => listenToOrdersSub());
    // final listenToUserBankAccountStreaming =
    //     useMemoized(() => listenToUserBankAccountSubs());
    // final userChipperCashAccountStreaming =
    //     useMemoized(() => userChipperCashAccountSub());
    // final fincraVirtualAccStreaming =
    //     useMemoized(() => userChipperCashAccountSub());
    // useEffect(
    //   () {
    //     animationController.forward();
    //     userCartController.listenUserCommission(authState.appUser?.$id,
    //         unPaidCommissionState: unPaidCommissionState.value);
    //     userCartController.changeComissionAmount(unPaidCommissionState.value);
    //     userCartController.listenUserPaidCommission(authState.appUser?.$id,
    //         paidCommissionState: paidCommissionState.value);
    //     userCartController.changePaidComissionAmount(paidCommissionState.value);
    //     userCartController.adminUserPaymentActivate(
    //         adminpaymentActivState: adminpaymentActivState.value);
    //     // userCartController.userChipperCashAccount(
    //     //     chipperState: chipperState.value);x
    //     userCartController.listenToPaymentMethod(
    //         pay: paymentsMethodState.value, payment: 'fincra');
    //     userCartController.listenToOrders(order: orderState.value);
    //     userCartController.listenToAllBanks(viewBanks: viewBanksState.value);

    //     userCartController.listenToUserBankAccount(
    //         bankAccountState: bankAccountState.value);
    //     // data();
    //     FToast().init(context);
    //     listenToUnPaidCommissionStreaming;
    //     listenTopaidCommissionStreaming;
    //     listenToAllBanksStreaming;
    //     listenToOrdersStreaming;
    //     listenToUserBankAccountStreaming;
    //     userChipperCashAccountStreaming;
    //     listenToadminpaymentActivStreaming;
    //     fincraVirtualAccStreaming;

    //     return () {};
    //   },
    //   [
    //     userCartController.unPaidCommission,
    //     userCartController.viewBanks,
    //     userCartController.orders,
    //     userCartController.userChipperCash,
    //     userCartController.useraccounts,
    //     userCartController.adminpaymentActiv,
    //     userCartController.paidCommission,
    //     userCartController.totalCommissionAmount,
    //     userCartController.fincraVitualAccount
    //   ],
    // );

    return Scaffold(
        body: SafeArea(
            child: GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Note: Sensitivity is integer used when you don't want to mess up vertical drag
        int sensitivity = 8;
        if (details.delta.dx > sensitivity) {
          // Right Swipe
          if (ref.read(numberProvider.notifier).state == 4) {
            ref.read(numberProvider.notifier).state = 3;
          }
        } else if (details.delta.dx < -sensitivity) {
          if (ref.read(numberProvider.notifier).state == 4) {
            ref.read(numberProvider.notifier).state = 0;
          }

          //Left Swipe
        }
      },
      child: Stack(
        fit: StackFit.expand,
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
          FractionallySizedBox(
            heightFactor: 1 - 0.2,
            alignment: Alignment.center,
            child: PageView(
              children: [
                SizedBox(
                    width: Get.width,
                    child: SingleChildScrollView(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Material(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.transparent,
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 3),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                        offset: const Offset(0, 11),
                                        blurRadius: 11,
                                        color: Colors.black.withOpacity(0.06))
                                  ],
                                ),
                                child: customText(
                                  'DashView',
                                  style: const TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                        ),

                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Container(
                                width: Get.height * 0.28,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                      onTap: () {},
                                      child: frostedRed(Container(
                                        //   width: Get.height * 0.3,
                                        //  height: Get.height * 0.26,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                offset: const Offset(0, 11),
                                                blurRadius: 11,
                                                color: Colors.black
                                                    .withOpacity(0.06))
                                          ],
                                        ),
                                        child: SingleChildScrollView(
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5.0),
                                                            child: Container(
                                                                decoration: BoxDecoration(
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                          offset: const Offset(0,
                                                                              11),
                                                                          blurRadius:
                                                                              11,
                                                                          color: Colors
                                                                              .black
                                                                              .withOpacity(0.06))
                                                                    ],
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            18),
                                                                    color: CupertinoColors
                                                                        .lightBackgroundGray),
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        5.0),
                                                                child:
                                                                    const Text(
                                                                  'ViewDucts Commission',
                                                                  style: TextStyle(
                                                                      color: CupertinoColors
                                                                          .darkBackgroundGray,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w200),
                                                                )),
                                                          ),
                                                        ],
                                                      ),
                                                      SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              child: Container(
                                                                  decoration: BoxDecoration(
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                            offset: const Offset(
                                                                                0, 11),
                                                                            blurRadius:
                                                                                11,
                                                                            color:
                                                                                Colors.black.withOpacity(0.06))
                                                                      ],
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              18),
                                                                      color: CupertinoColors
                                                                          .systemGreen),
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          5.0),
                                                                  child:
                                                                      const Text(
                                                                    'Paid  Commission:',
                                                                    style: TextStyle(
                                                                        color: CupertinoColors
                                                                            .darkBackgroundGray,
                                                                        fontWeight:
                                                                            FontWeight.w200),
                                                                  )),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              child: Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                          offset: const Offset(0,
                                                                              11),
                                                                          blurRadius:
                                                                              11,
                                                                          color: Colors
                                                                              .black
                                                                              .withOpacity(0.06))
                                                                    ],
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            18),
                                                                  ),
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          5.0),
                                                                  child: Text(
                                                                    '',
                                                                    // NumberFormat.currency(
                                                                    //         name: authState.userModel!.location == 'Nigeria'
                                                                    //             ? '₦'
                                                                    //             : '£')
                                                                    //     .format(
                                                                    //         double.parse(
                                                                    //   userCartController
                                                                    //       .totalPaidCommissionAmount
                                                                    //       .value
                                                                    //       .toString(),
                                                                    // )),
                                                                    style: TextStyle(
                                                                        color: CupertinoColors
                                                                            .lightBackgroundGray,
                                                                        fontWeight:
                                                                            FontWeight.w200),
                                                                  )),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Row(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              child: Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                          offset: const Offset(0,
                                                                              11),
                                                                          blurRadius:
                                                                              11,
                                                                          color: Colors
                                                                              .black
                                                                              .withOpacity(0.06))
                                                                    ],
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            18),
                                                                  ),
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          5.0),
                                                                  child: Text(
                                                                    ''
                                                                    // NumberFormat.currency(name: authState.userModel!.location == 'Nigeria' ? '₦' : '£')
                                                                    //     .format(double.parse(
                                                                    //   '${unPaidTotalCommissionAmountState.value}',
                                                                    // ))
                                                                    ,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            Get.height *
                                                                                0.085,
                                                                        color: CupertinoColors
                                                                            .darkBackgroundGray,
                                                                        fontWeight:
                                                                            FontWeight.w900),
                                                                  )),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ]),

                                                // Obx(() => ViewDuctMenuHolder(
                                                //       onPressed: () {},
                                                //       menuItems: <
                                                //           DuctFocusedMenuItem>[
                                                //         adminpaymentActivState
                                                //                     .value

                                                //                     .paymentStatus ==
                                                //                 'activate'
                                                //             ? userCartController
                                                //                         .monthCommPay
                                                //                         .value
                                                //                         .monthPay ==
                                                //                     adminpaymentActivState
                                                //                         .value

                                                //                         .date
                                                //                 ? DuctFocusedMenuItem(
                                                //                     title:
                                                //                         const Text(
                                                //                       '',
                                                //                       style:
                                                //                           TextStyle(
                                                //                         //fontSize: Get.width * 0.03,
                                                //                         color: AppColor
                                                //                             .darkGrey,
                                                //                       ),
                                                //                     ),
                                                //                     onPressed:
                                                //                         () async {},
                                                //                   )
                                                //                 : unPaidTotalCommissionAmountState
                                                //                                 .value
                                                //                                  <
                                                //                             10000 &&
                                                //                         authState
                                                //                                 .userModel!
                                                //                                 .location ==
                                                //                             'Nigeria'
                                                //                     ? DuctFocusedMenuItem(
                                                //                         title:
                                                //                             const Text(
                                                //                           'Balance < 10000',
                                                //                           style:
                                                //                               TextStyle(
                                                //                             //fontSize: Get.width * 0.03,
                                                //                             color:
                                                //                                 CupertinoColors.systemRed,
                                                //                           ),
                                                //                         ),
                                                //                         onPressed:
                                                //                             () async {
                                                //                           //  Get.to(() => SettingsAndPrivacyPage());
                                                //                         },
                                                //                       )
                                                //                     : unPaidTotalCommissionAmountState.value <
                                                //                                 200 &&
                                                //                             authState.userModel!.location !=
                                                //                                 'Nigeria'
                                                //                         ? DuctFocusedMenuItem(
                                                //                             title:
                                                //                                 const Text(
                                                //                               'Balance < 200',
                                                //                               style:
                                                //                                   TextStyle(
                                                //                                 //fontSize: Get.width * 0.03,
                                                //                                 color: CupertinoColors.systemRed,
                                                //                               ),
                                                //                             ),
                                                //                             onPressed:
                                                //                                 () async {
                                                //                               //  Get.to(() => SettingsAndPrivacyPage());
                                                //                             },
                                                //                           )
                                                //                         : DuctFocusedMenuItem(
                                                //                             title:
                                                //                                 const Text(
                                                //                               'Request your commission',
                                                //                               style:
                                                //                                   TextStyle(
                                                //                                 //fontSize: Get.width * 0.03,
                                                //                                 color: AppColor.darkGrey,
                                                //                               ),
                                                //                             ),
                                                //                             onPressed:
                                                //                                 () async {
                                                //                               userCartController.userRequestPayment(
                                                //                                   authState.appUser?.$id,
                                                //                                   unPaidTotalCommissionAmountState.value.toString(),
                                                //                                   adminpaymentActivState.value.date);

                                                //                               //  Get.to(() => SettingsAndPrivacyPage());
                                                //                             },
                                                //                             trailingIcon:
                                                //                                 const Icon(CupertinoIcons.money_dollar_circle))
                                                //             : DuctFocusedMenuItem(
                                                //                 title: const Text(
                                                //                   'Payment Date not Due',
                                                //                   style:
                                                //                       TextStyle(
                                                //                     //fontSize: Get.width * 0.03,
                                                //                     color: Colors
                                                //                         .red,
                                                //                   ),
                                                //                 ),
                                                //                 onPressed:
                                                //                     () async {
                                                //                   //  Get.to(() => SettingsAndPrivacyPage());
                                                //                 },
                                                //               ),
                                                //         DuctFocusedMenuItem(
                                                //             title: Padding(
                                                //               padding:
                                                //                   const EdgeInsets
                                                //                           .symmetric(
                                                //                       horizontal:
                                                //                           20.0),
                                                //               child: Container(
                                                //                 decoration: BoxDecoration(
                                                //                     boxShadow: [
                                                //                       BoxShadow(
                                                //                           offset: const Offset(
                                                //                               0,
                                                //                               11),
                                                //                           blurRadius:
                                                //                               11,
                                                //                           color: Colors
                                                //                               .black
                                                //                               .withOpacity(0.06))
                                                //                     ],
                                                //                     borderRadius:
                                                //                         BorderRadius
                                                //                             .circular(
                                                //                                 18),
                                                //                     color: CupertinoColors
                                                //                         .systemYellow),
                                                //                 padding:
                                                //                     const EdgeInsets
                                                //                         .all(5.0),
                                                //                 child: const Text(
                                                //                   'Payment history',
                                                //                   style:
                                                //                       TextStyle(
                                                //                     //fontSize: Get.width * 0.03,
                                                //                     color: AppColor
                                                //                         .darkGrey,
                                                //                   ),
                                                //                 ),
                                                //               ),
                                                //             ),
                                                //             onPressed: () async {
                                                //               // _paymentHistory(
                                                //               //   context,
                                                //               // );

                                                //             },
                                                //             trailingIcon: const Icon(
                                                //                 CupertinoIcons
                                                //                     .money_dollar_circle)),
                                                //       ],
                                                //       child:
                                                //           unPaidTotalCommissionAmountState
                                                //                       .value
                                                //                        <
                                                //                   10000
                                                //               ? Padding(
                                                //                   padding:
                                                //                       const EdgeInsets
                                                //                               .all(
                                                //                           5.0),
                                                //                   child:
                                                //                       Container(
                                                //                           width: context.responsiveValue(
                                                //                               mobile: Get.height *
                                                //                                   0.15,
                                                //                               tablet: Get.height *
                                                //                                   0.15,
                                                //                               desktop: Get.height *
                                                //                                   0.15),
                                                //                           decoration: BoxDecoration(
                                                //                               boxShadow: [
                                                //                                 BoxShadow(offset: const Offset(0, 11), blurRadius: 11, color: Colors.black.withOpacity(0.06))
                                                //                               ],
                                                //                               borderRadius: BorderRadius.circular(
                                                //                                   18),
                                                //                               color: Colors
                                                //                                   .cyan),
                                                //                           padding:
                                                //                               const EdgeInsets.all(
                                                //                                   5.0),
                                                //                           child:
                                                //                               const Text(
                                                //                             'HISTORY>',
                                                //                             style: TextStyle(
                                                //                                 color: CupertinoColors.darkBackgroundGray,
                                                //                                 fontWeight: FontWeight.w900),
                                                //                           )),
                                                //                 )
                                                //               : Padding(
                                                //                   padding:
                                                //                       const EdgeInsets
                                                //                               .all(
                                                //                           5.0),
                                                //                   child:
                                                //                       Container(
                                                //                           width: Get.width *
                                                //                               0.3,
                                                //                           decoration: BoxDecoration(
                                                //                               boxShadow: [
                                                //                                 BoxShadow(offset: const Offset(0, 11), blurRadius: 11, color: Colors.black.withOpacity(0.06))
                                                //                               ],
                                                //                               borderRadius: BorderRadius.circular(
                                                //                                   18),
                                                //                               color: CupertinoColors
                                                //                                   .systemGreen),
                                                //                           padding:
                                                //                               const EdgeInsets.all(
                                                //                                   5.0),
                                                //                           child:
                                                //                               const Text(
                                                //                             'WITHDRAW',
                                                //                             style: TextStyle(
                                                //                                 color: CupertinoColors.darkBackgroundGray,
                                                //                                 fontWeight: FontWeight.w900),
                                                //                           )),
                                                //                 ),
                                                //     ))
                                              ]),
                                        ),
                                      ))),
                                ),
                              ),

                              // Container(
                              //   width: Get.height * .3,
                              //   height: Get.height * 0.2,
                              //   padding: const EdgeInsets.only(top: 5, bottom: 0),
                              //   decoration: BoxDecoration(
                              //     borderRadius: BorderRadius.circular(20),
                              //     boxShadow: [
                              //       BoxShadow(
                              //           offset: const Offset(0, 11),
                              //           blurRadius: 11,
                              //           color: Colors.black.withOpacity(0.06))
                              //     ],
                              //     color: Colors.blueGrey[50],
                              //     gradient: LinearGradient(
                              //       colors: [
                              //         Colors.yellow.withOpacity(0.1),
                              //         Colors.yellow.withOpacity(0.2),
                              //         Colors.yellow.withOpacity(0.1)
                              //         // Color(0xfffbfbfb),
                              //         // Color(0xfff7f7f7),
                              //       ],
                              //       // begin: Alignment.topCenter,
                              //       // end: Alignment.bottomCenter,
                              //     ),
                              //   ),
                              //   margin:
                              //       const EdgeInsets.symmetric(horizontal: 12),
                              //   child: Column(
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       Obx(
                              //         () => Padding(
                              //           padding: const EdgeInsets.all(5.0),
                              //           child: Column(
                              //             mainAxisAlignment:
                              //                 MainAxisAlignment.spaceBetween,
                              //             children: [
                              //               const Text(
                              //                 'Unpaid Commission:',
                              //                 style: TextStyle(
                              //                     fontWeight: FontWeight.bold),
                              //               ),
                              //               SingleChildScrollView(
                              //                 scrollDirection: Axis.horizontal,
                              //                 child: Row(
                              //                   children: [
                              //                     Text(
                              //                         NumberFormat.currency(
                              //                                 name: 'N ')
                              //                             .format(double.parse(
                              //                           userCartController
                              //                               .totalCommissionAmount
                              //                               .value
                              //                               .toString(),
                              //                         )),
                              //                         style: TextStyle(
                              //                             color: Colors.cyan,
                              //                             fontSize:
                              //                                 Get.height * 0.07,
                              //                             fontWeight:
                              //                                 FontWeight.bold)),
                              //                   ],
                              //                 ),
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       ),

                              //     ],
                              //   ),
                              // ),

                              Obx(() => orderState.value.isEmpty
                                  ? Container()
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          // _bankAccountNumber(context);
                                        },
                                        child: frostedRed(Container(
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                    offset: const Offset(0, 11),
                                                    blurRadius: 11,
                                                    color: Colors.black
                                                        .withOpacity(0.06))
                                              ],
                                            ),
                                            child:
                                                bankAccountState
                                                            .value.account !=
                                                        null
                                                    ? Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              child: Container(
                                                                  decoration: BoxDecoration(
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                            offset: const Offset(
                                                                                0, 11),
                                                                            blurRadius:
                                                                                11,
                                                                            color:
                                                                                Colors.black.withOpacity(0.06))
                                                                      ],
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              18),
                                                                      color: CupertinoColors
                                                                          .lightBackgroundGray),
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          5.0),
                                                                  child:
                                                                      const Text(
                                                                    'Your Account Details:',
                                                                    style: TextStyle(
                                                                        color: CupertinoColors
                                                                            .darkBackgroundGray,
                                                                        fontWeight:
                                                                            FontWeight.w200),
                                                                  )),
                                                            ),
                                                            Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  SingleChildScrollView(
                                                                    scrollDirection:
                                                                        Axis.horizontal,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(5.0),
                                                                          child: Container(
                                                                              decoration: BoxDecoration(boxShadow: [
                                                                                BoxShadow(offset: const Offset(0, 11), blurRadius: 11, color: Colors.black.withOpacity(0.06))
                                                                              ], borderRadius: BorderRadius.circular(18), color: CupertinoColors.darkBackgroundGray),
                                                                              padding: const EdgeInsets.all(5.0),
                                                                              child: const Text(
                                                                                'Acc Name:',
                                                                                style: TextStyle(color: CupertinoColors.lightBackgroundGray, fontWeight: FontWeight.w200),
                                                                              )),
                                                                        ),
                                                                        Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            boxShadow: [
                                                                              BoxShadow(offset: const Offset(0, 11), blurRadius: 11, color: Colors.black.withOpacity(0.06))
                                                                            ],
                                                                            borderRadius:
                                                                                BorderRadius.circular(18),
                                                                          ),
                                                                          padding:
                                                                              const EdgeInsets.all(5.0),
                                                                          child:
                                                                              Text(
                                                                            '${bankAccountState.value.name}',
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.w300,
                                                                              fontSize: context.responsiveValue(mobile: Get.height * 0.02, tablet: Get.height * 0.02, desktop: Get.height * 0.02),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SingleChildScrollView(
                                                                    scrollDirection:
                                                                        Axis.horizontal,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(5.0),
                                                                          child: Container(
                                                                              decoration: BoxDecoration(boxShadow: [
                                                                                BoxShadow(offset: const Offset(0, 11), blurRadius: 11, color: Colors.black.withOpacity(0.06))
                                                                              ], borderRadius: BorderRadius.circular(18), color: CupertinoColors.darkBackgroundGray),
                                                                              padding: const EdgeInsets.all(5.0),
                                                                              child: const Text(
                                                                                'Acc Number:',
                                                                                style: TextStyle(color: CupertinoColors.lightBackgroundGray, fontWeight: FontWeight.w200),
                                                                              )),
                                                                        ),
                                                                        Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            boxShadow: [
                                                                              BoxShadow(offset: const Offset(0, 11), blurRadius: 11, color: Colors.black.withOpacity(0.06))
                                                                            ],
                                                                            borderRadius:
                                                                                BorderRadius.circular(18),
                                                                          ),
                                                                          padding:
                                                                              const EdgeInsets.all(5.0),
                                                                          child:
                                                                              Text(
                                                                            '${bankAccountState.value.account}',
                                                                            style:
                                                                                TextStyle(
                                                                              // fontSize: Get.height * 0.07,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: context.responsiveValue(mobile: Get.height * 0.02, tablet: Get.height * 0.02, desktop: Get.height * 0.02),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SingleChildScrollView(
                                                                    scrollDirection:
                                                                        Axis.horizontal,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(5.0),
                                                                          child: Container(
                                                                              decoration: BoxDecoration(boxShadow: [
                                                                                BoxShadow(offset: const Offset(0, 11), blurRadius: 11, color: Colors.black.withOpacity(0.06))
                                                                              ], borderRadius: BorderRadius.circular(18), color: CupertinoColors.darkBackgroundGray),
                                                                              padding: const EdgeInsets.all(5.0),
                                                                              child: const Text(
                                                                                'Bank:',
                                                                                style: TextStyle(color: CupertinoColors.lightBackgroundGray, fontWeight: FontWeight.w200),
                                                                              )),
                                                                        ),
                                                                        Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            boxShadow: [
                                                                              BoxShadow(offset: const Offset(0, 11), blurRadius: 11, color: Colors.black.withOpacity(0.06))
                                                                            ],
                                                                            borderRadius:
                                                                                BorderRadius.circular(18),
                                                                          ),
                                                                          padding:
                                                                              const EdgeInsets.all(5.0),
                                                                          child:
                                                                              Text(
                                                                            '${bankAccountState.value.bank}',
                                                                            style:
                                                                                TextStyle(
                                                                              fontWeight: FontWeight.w100,
                                                                              fontSize: context.responsiveValue(mobile: Get.height * 0.02, tablet: Get.height * 0.02, desktop: Get.height * 0.02),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ]),
                                                            bankAccountState
                                                                        .value
                                                                        .status ==
                                                                    'Verified'
                                                                ? Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            5.0),
                                                                    child: Container(
                                                                        decoration: BoxDecoration(boxShadow: [
                                                                          BoxShadow(
                                                                              offset: const Offset(0, 11),
                                                                              blurRadius: 11,
                                                                              color: Colors.black.withOpacity(0.06))
                                                                        ], borderRadius: BorderRadius.circular(18), color: CupertinoColors.systemGreen),
                                                                        padding: const EdgeInsets.all(5.0),
                                                                        child: Text(
                                                                          'Verified',
                                                                          style: TextStyle(
                                                                              color: CupertinoColors.darkBackgroundGray,
                                                                              fontWeight: FontWeight.w900),
                                                                        )),
                                                                  )
                                                                : Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            5.0),
                                                                    child: Container(
                                                                        decoration: BoxDecoration(boxShadow: [
                                                                          BoxShadow(
                                                                              offset: const Offset(0, 11),
                                                                              blurRadius: 11,
                                                                              color: Colors.black.withOpacity(0.06))
                                                                        ], borderRadius: BorderRadius.circular(18), color: CupertinoColors.systemRed),
                                                                        padding: const EdgeInsets.all(5.0),
                                                                        child: Text(
                                                                          'Not Verified',
                                                                          style: TextStyle(
                                                                              color: CupertinoColors.darkBackgroundGray,
                                                                              fontWeight: FontWeight.w900),
                                                                        )),
                                                                  ),
                                                          ])
                                                    : Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Column(
                                                            children: [
                                                              Text(
                                                                '',
                                                                // authState.userModel
                                                                //             ?.location !=
                                                                //         'Nigeria'
                                                                //     ? 'PayPal'
                                                                //     : 'Acc Number:',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              SingleChildScrollView(
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                child: Row(
                                                                  children: [
                                                                    // Text(
                                                                    //     NumberFormat.currency(name: 'N ')
                                                                    //         .format(double.parse(
                                                                    //       userCartController
                                                                    //           .totalCommissionAmount.value
                                                                    //           .toString(),
                                                                    //     )),
                                                                    //     style: TextStyle(
                                                                    //         color: Colors.white,
                                                                    //         fontSize: Get.height * 0.06,
                                                                    //         fontWeight: FontWeight.bold)),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                decoration: BoxDecoration(
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                          offset: const Offset(0,
                                                                              11),
                                                                          blurRadius:
                                                                              11,
                                                                          color: Colors
                                                                              .black
                                                                              .withOpacity(0.06))
                                                                    ],
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            18),
                                                                    color: Colors
                                                                        .blueAccent),
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        5.0),
                                                                child: Text(
                                                                  'Add Account',
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .caption!
                                                                      .copyWith(
                                                                          color:
                                                                              Colors.black),
                                                                ),
                                                              )
                                                            ]),
                                                      ))),
                                      ),
                                    )),
                            ],
                          ),
                        ),

                        // Obx(
                        //   () => paymentsMethodState.value.value.state == false
                        //       ? Container()
                        //       : userCartController
                        //                   .userChipperCash.value.chipperCashTag ==
                        //               null
                        //           ? GestureDetector(
                        //               onTap: () {
                        //                 _bankDetails(
                        //                   context,
                        //                 );
                        //               },
                        //               child: Row(
                        //                 children: [
                        //                   Padding(
                        //                     padding: const EdgeInsets.all(2.0),
                        //                     child: Container(
                        //                       width: Get.height * 0.06,
                        //                       height: Get.height * 0.06,
                        //                       decoration: BoxDecoration(
                        //                           image: DecorationImage(
                        //                               image: AssetImage(
                        //                                   'assets/chippercash.png'),
                        //                               fit: BoxFit.cover),
                        //                           boxShadow: [
                        //                             BoxShadow(
                        //                                 offset:
                        //                                     const Offset(0, 11),
                        //                                 blurRadius: 11,
                        //                                 color: Colors.black
                        //                                     .withOpacity(0.06))
                        //                           ],
                        //                           borderRadius:
                        //                               BorderRadius.circular(18),
                        //                           color: CupertinoColors.white),
                        //                       padding: const EdgeInsets.all(5.0),
                        //                     ),
                        //                   ),
                        //                   Padding(
                        //                     padding: const EdgeInsets.all(5.0),
                        //                     child: Container(
                        //                         // width:
                        //                         //    Get.width * 0.3,
                        //                         decoration: BoxDecoration(
                        //                             boxShadow: [
                        //                               BoxShadow(
                        //                                   offset:
                        //                                       const Offset(0, 11),
                        //                                   blurRadius: 11,
                        //                                   color: Colors.black
                        //                                       .withOpacity(0.06))
                        //                             ],
                        //                             borderRadius:
                        //                                 BorderRadius.circular(18),
                        //                             color: CupertinoColors
                        //                                 .inactiveGray),
                        //                         padding:
                        //                             const EdgeInsets.all(5.0),
                        //                         child: Text(
                        //                           'Add ChipperCash',
                        //                           style: TextStyle(
                        //                               color: CupertinoColors
                        //                                   .darkBackgroundGray,
                        //                               fontWeight:
                        //                                   FontWeight.w900),
                        //                         )),
                        //                   ),
                        //                 ],
                        //               ),
                        //             )
                        //           : Padding(
                        //               padding: const EdgeInsets.all(8.0),
                        //               child: frostedBlueGray(
                        //                 Padding(
                        //                   padding: const EdgeInsets.all(8.0),
                        //                   child: SizedBox(
                        //                       width: context.responsiveValue(
                        //                           mobile: Get.height * 0.5,
                        //                           tablet: Get.height * 0.5,
                        //                           desktop: Get.height * 0.5),
                        //                       child: Column(
                        //                           mainAxisAlignment:
                        //                               MainAxisAlignment
                        //                                   .spaceBetween,
                        //                           crossAxisAlignment:
                        //                               CrossAxisAlignment.center,
                        //                           children: [
                        //                             Column(children: [
                        //                               Row(
                        //                                 mainAxisAlignment:
                        //                                     MainAxisAlignment
                        //                                         .spaceBetween,
                        //                                 crossAxisAlignment:
                        //                                     CrossAxisAlignment
                        //                                         .center,
                        //                                 children: [
                        //                                   Text(
                        //                                       "Chipper Cash Account"),
                        //                                   Text(
                        //                                     userCartController
                        //                                         .userChipperCash
                        //                                         .value
                        //                                         .fullName
                        //                                         .toString(),
                        //                                     style: const TextStyle(
                        //                                         fontWeight:
                        //                                             FontWeight
                        //                                                 .bold),
                        //                                   ),
                        //                                 ],
                        //                               ),
                        //                               Row(
                        //                                 mainAxisAlignment:
                        //                                     MainAxisAlignment
                        //                                         .spaceBetween,
                        //                                 crossAxisAlignment:
                        //                                     CrossAxisAlignment
                        //                                         .center,
                        //                                 children: [
                        //                                   Text("Tag"),
                        //                                   Container(
                        //                                     decoration: BoxDecoration(
                        //                                         boxShadow: [
                        //                                           BoxShadow(
                        //                                               offset:
                        //                                                   const Offset(0,
                        //                                                       11),
                        //                                               blurRadius:
                        //                                                   11,
                        //                                               color: Colors
                        //                                                   .black
                        //                                                   .withOpacity(
                        //                                                       0.06))
                        //                                         ],
                        //                                         borderRadius:
                        //                                             BorderRadius
                        //                                                 .circular(
                        //                                                     18),
                        //                                         color: Colors
                        //                                             .yellowAccent),
                        //                                     padding:
                        //                                         const EdgeInsets
                        //                                             .all(5.0),
                        //                                     child: Text(
                        //                                       userCartController
                        //                                           .userChipperCash
                        //                                           .value
                        //                                           .chipperCashTag
                        //                                           .toString(),
                        //                                       style: Theme.of(
                        //                                               context)
                        //                                           .textTheme
                        //                                           .caption!
                        //                                           .copyWith(
                        //                                               color: Colors
                        //                                                   .black),
                        //                                     ),
                        //                                   ),
                        //                                 ],
                        //                               )
                        //                             ]),
                        //                             Row(
                        //                               mainAxisAlignment:
                        //                                   MainAxisAlignment
                        //                                       .spaceBetween,
                        //                               crossAxisAlignment:
                        //                                   CrossAxisAlignment
                        //                                       .center,
                        //                               children: [
                        //                                 GestureDetector(
                        //                                   onTap: () {
                        //                                     _bankDetails(
                        //                                       context,
                        //                                     );
                        //                                   },
                        //                                   child: Padding(
                        //                                     padding:
                        //                                         const EdgeInsets
                        //                                             .all(5.0),
                        //                                     child: Container(
                        //                                         // width:
                        //                                         //    Get.width * 0.3,
                        //                                         decoration: BoxDecoration(
                        //                                             boxShadow: [
                        //                                               BoxShadow(
                        //                                                   offset: const Offset(
                        //                                                       0,
                        //                                                       11),
                        //                                                   blurRadius:
                        //                                                       11,
                        //                                                   color: Colors
                        //                                                       .black
                        //                                                       .withOpacity(0.06))
                        //                                             ],
                        //                                             borderRadius:
                        //                                                 BorderRadius
                        //                                                     .circular(
                        //                                                         18),
                        //                                             color: CupertinoColors
                        //                                                 .inactiveGray),
                        //                                         padding:
                        //                                             const EdgeInsets
                        //                                                 .all(5.0),
                        //                                         child: Text(
                        //                                           'Update Tag',
                        //                                           style: TextStyle(
                        //                                               color: CupertinoColors
                        //                                                   .darkBackgroundGray,
                        //                                               fontWeight:
                        //                                                   FontWeight
                        //                                                       .w900),
                        //                                         )),
                        //                                   ),
                        //                                 ),
                        //                                 Obx(() => GestureDetector(
                        //                                       onTap: () async {
                        //                                         if (userCartController
                        //                                                     .userChipperCash
                        //                                                     .value
                        //                                                     .status ==
                        //                                                 'Authorizing' ||
                        //                                             userCartController
                        //                                                     .userChipperCash
                        //                                                     .value
                        //                                                     .status ==
                        //                                                 'confirmed') {
                        //                                           await authorizeState
                        //                                                   .value
                        //                                                   .value ==
                        //                                               true;
                        //                                           await userCartController
                        //                                               .addChipperCashAccount(
                        //                                             '',
                        //                                             '',
                        //                                             authorize:
                        //                                                 'Authorized',
                        //                                           );
                        //                                           FToast()
                        //                                               .showToast(
                        //                                                   child:
                        //                                                       Padding(
                        //                                                     padding:
                        //                                                         const EdgeInsets.all(5.0),
                        //                                                     child: Container(
                        //                                                         // width:
                        //                                                         //    Get.width * 0.3,
                        //                                                         decoration: BoxDecoration(boxShadow: [
                        //                                                           BoxShadow(offset: const Offset(0, 11), blurRadius: 11, color: Colors.black.withOpacity(0.06))
                        //                                                         ], borderRadius: BorderRadius.circular(18), color: CupertinoColors.activeGreen),
                        //                                                         padding: const EdgeInsets.all(5.0),
                        //                                                         child: Text(
                        //                                                           'Waiting for Aproval',
                        //                                                           style: TextStyle(color: CupertinoColors.darkBackgroundGray, fontWeight: FontWeight.w900),
                        //                                                         )),
                        //                                                   ),
                        //                                                   gravity:
                        //                                                       ToastGravity
                        //                                                           .TOP_LEFT,
                        //                                                   toastDuration:
                        //                                                       Duration(seconds: 3));
                        //                                         } else {
                        //                                           await userCartController
                        //                                               .addChipperCashAccount(
                        //                                             '',
                        //                                             '',
                        //                                             authorize:
                        //                                                 'confirmed',
                        //                                           );
                        //                                           FToast()
                        //                                               .showToast(
                        //                                                   child:
                        //                                                       Padding(
                        //                                                     padding:
                        //                                                         const EdgeInsets.all(5.0),
                        //                                                     child: Container(
                        //                                                         // width:
                        //                                                         //    Get.width * 0.3,
                        //                                                         decoration: BoxDecoration(boxShadow: [
                        //                                                           BoxShadow(offset: const Offset(0, 11), blurRadius: 11, color: Colors.black.withOpacity(0.06))
                        //                                                         ], borderRadius: BorderRadius.circular(18), color: CupertinoColors.activeGreen),
                        //                                                         padding: const EdgeInsets.all(5.0),
                        //                                                         child: Text(
                        //                                                           'Granting Authorization',
                        //                                                           style: TextStyle(color: CupertinoColors.darkBackgroundGray, fontWeight: FontWeight.w900),
                        //                                                         )),
                        //                                                   ),
                        //                                                   gravity:
                        //                                                       ToastGravity
                        //                                                           .TOP_LEFT,
                        //                                                   toastDuration:
                        //                                                       Duration(seconds: 3));
                        //                                         }
                        //                                         ;
                        //                                       },
                        //                                       child: Padding(
                        //                                         padding:
                        //                                             const EdgeInsets
                        //                                                 .all(5.0),
                        //                                         child: Container(
                        //                                             //  width: Get.width * 0.3,
                        //                                             decoration: BoxDecoration(
                        //                                                 boxShadow: [
                        //                                                   BoxShadow(
                        //                                                       offset: const Offset(
                        //                                                           0, 11),
                        //                                                       blurRadius:
                        //                                                           11,
                        //                                                       color:
                        //                                                           Colors.black.withOpacity(0.06))
                        //                                                 ],
                        //                                                 borderRadius:
                        //                                                     BorderRadius.circular(
                        //                                                         18),
                        //                                                 color: chipperState.value.value.status ==
                        //                                                         'Authorizing'
                        //                                                     ? CupertinoColors
                        //                                                         .activeOrange
                        //                                                     : CupertinoColors
                        //                                                         .activeGreen),
                        //                                             padding:
                        //                                                 const EdgeInsets
                        //                                                         .all(
                        //                                                     5.0),
                        //                                             child: Text(
                        //                                               authorizeState.value ==
                        //                                                       true
                        //                                                   ? 'waiting for aproval'
                        //                                                   : chipperState.value.value.status == 'Authorizing' ||
                        //                                                           chipperState.value.value.status == 'confirmed'
                        //                                                       ? 'Click to Authorize'
                        //                                                       : '${chipperState.value.value.status}',
                        //                                               style: TextStyle(
                        //                                                   color: CupertinoColors
                        //                                                       .darkBackgroundGray,
                        //                                                   fontWeight:
                        //                                                       FontWeight.w900),
                        //                                             )),
                        //                                       ),
                        //                                     ))
                        //                               ],
                        //                             )
                        //                           ])

                        //                       ),
                        //                 ),
                        //               ),
                        //             ),
                        // ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(0, 11),
                                    blurRadius: 11,
                                    color: Colors.black.withOpacity(0.06))
                              ],
                              borderRadius: BorderRadius.circular(18),
                            ),
                            padding: const EdgeInsets.all(5.0),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 3),
                              child: customTitleText('Your Orders'),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ref
                            .watch(
                                getUserOrdersProvider('${currentUser?.userId}'))
                            .when(
                                data: (orderState) {
                                  cprint(orderState.length.toString());
                                  return SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: orderState
                                          .map((cartItem) => UserProfileOrders(
                                                currentUser!,
                                                cartItem: cartItem.obs,
                                              ))
                                          .toList(),
                                    ),
                                  );
                                },
                                error: (error, stackTrace) => ErrorText(
                                      error: error.toString(),
                                    ),
                                loading: () => const LoaderAll()),

                        const SizedBox(
                          height: 30,
                        )
                      ],
                    ))),
              ],
            ),
          ),
          Positioned(
            top: 20,
            left: 10,
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
          Positioned(
            top: 35,
            right: 10,
            child:

                //  authState.userModel?.email == 'viewducts@gmail.com' ||
                //         userCartController.staff.value
                //                 .firstWhere((e) => e.id == authState.appUser?.$id,
                //                     orElse: adminStaffController.staffRole)
                //                 .role ==
                //             'admin' ||
                //         userCartController.staff.value
                //                 .firstWhere((e) => e.id == authState.appUser?.$id,
                //                     orElse: adminStaffController.staffRole)
                //                 .role ==
                //             'Sales Agent' ||
                //         userCartController.staff.value
                //                 .firstWhere((e) => e.id == authState.appUser?.$id,
                //                     orElse: adminStaffController.staffRole)
                //                 .role ==
                //             'General Manager'
                //     ? ViewDuctMenuHolder(
                //         onPressed: () {},
                //         menuItems: <DuctFocusedMenuItem>[
                //           DuctFocusedMenuItem(
                //               title: Padding(
                //                 padding: const EdgeInsets.symmetric(horizontal: 10.0),
                //                 child: Container(
                //                   decoration: BoxDecoration(
                //                       boxShadow: [
                //                         BoxShadow(
                //                             offset: const Offset(0, 11),
                //                             blurRadius: 11,
                //                             color: Colors.black.withOpacity(0.06))
                //                       ],
                //                       borderRadius: BorderRadius.circular(18),
                //                       color: CupertinoColors.systemYellow),
                //                   padding: const EdgeInsets.all(5.0),
                //                   child: const Text(
                //                     'Settings and Privacy',
                //                     style: TextStyle(
                //                       //fontSize: Get.width * 0.03,
                //                       color: AppColor.darkGrey,
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //               onPressed: () {
                //                 Get.to(() =>
                //                     const SettingsAndPrivacyPageResponsiveView());
                //               },
                //               trailingIcon:
                //                   const Icon(CupertinoIcons.settings_solid)),
                //           DuctFocusedMenuItem(
                //               title: Padding(
                //                 padding: const EdgeInsets.symmetric(horizontal: 40.0),
                //                 child: Container(
                //                   decoration: BoxDecoration(
                //                       boxShadow: [
                //                         BoxShadow(
                //                             offset: const Offset(0, 11),
                //                             blurRadius: 11,
                //                             color: Colors.black.withOpacity(0.06))
                //                       ],
                //                       borderRadius: BorderRadius.circular(18),
                //                       color: CupertinoColors.lightBackgroundGray),
                //                   padding: const EdgeInsets.all(5.0),
                //                   child: const Text(
                //                     'Dashboard',
                //                     style: TextStyle(
                //                       //fontSize: Get.width * 0.03,
                //                       color: AppColor.darkGrey,
                //                     ),
                //                   ),
                //                 ),
                //               ),
                //               onPressed: () {
                //                 Get.to(() => const DashAdmin());
                //               },
                //               trailingIcon: const Icon(CupertinoIcons.folder))
                //         ],
                //         child: Padding(
                //           padding: const EdgeInsets.all(8.0),
                //           child: frostedWhite(
                //             Padding(
                //               padding: EdgeInsets.all(8.0),
                //               child: Container(
                //                 decoration: BoxDecoration(
                //                     boxShadow: [
                //                       BoxShadow(
                //                           offset: const Offset(0, 11),
                //                           blurRadius: 11,
                //                           color: Colors.black.withOpacity(0.06))
                //                     ],
                //                     borderRadius: BorderRadius.circular(100),
                //                     color: CupertinoColors.lightBackgroundGray),
                //                 padding: const EdgeInsets.all(5.0),
                //                 child: Icon(CupertinoIcons.app_badge),
                //               ),
                //             ),
                //           ),
                //         ),
                //       )
                //     :
                ViewDuctMenuHolder(
              onPressed: () {},
              menuItems: <DuctFocusedMenuItem>[
                DuctFocusedMenuItem(
                    title: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
                          'Settings and Privacy',
                          style: TextStyle(
                            //fontSize: Get.width * 0.03,
                            color: AppColor.darkGrey,
                          ),
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SettingsAndPrivacyPageResponsiveView()));
                    },
                    trailingIcon: const Icon(CupertinoIcons.settings_solid)),
              ],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: frostedWhite(
                  Padding(
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
              ),
            ),
          )
        ],
      ),
    )));
  }
}

class StorageInfoCard extends StatelessWidget {
  const StorageInfoCard({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.amountOfFiles,
    required this.numOfFiles,
    this.textStyle,
  }) : super(key: key);
  final TextStyle? textStyle;
  final String title, svgSrc;
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
                  Text(
                    title,
                    maxLines: 1,
                    style: textStyle ?? const TextStyle(color: Colors.white70),
                    overflow: TextOverflow.ellipsis,
                  ),
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

class StorageCard extends StatelessWidget {
  const StorageCard({
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

const primaryColor = Color(0xFF2697FF);
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFF212332);

const defaultPadding = 16.0;

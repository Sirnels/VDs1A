// ignore_for_file: must_be_immutable

import 'dart:ui';

import 'package:appwrite/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:viewducts/apis/auth_api.dart';
import 'package:viewducts/common/market_widget.dart';
import 'package:viewducts/common/user_avatar.dart';
import 'package:viewducts/features/auth/controller/auth_controller.dart';
import 'package:viewducts/features/products/product_controller.dart';
import 'package:viewducts/helper/enum.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/user.dart';
//import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/cartIcon.dart';
import 'package:viewducts/widgets/categoryManu.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/frosted.dart';
import 'package:viewducts/widgets/tabText.dart';

class Home extends ConsumerStatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  bool isDesktop;
  bool isTablet;
  bool desk2;
  Home(
      {Key? key,
      this.scaffoldKey,
      this.isDesktop = false,
      this.isTablet = false,
      this.desk2 = false})
      : super(key: key);

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  // List<Document>? groceriesCategory = <Document>[];

  // List<Document>? electronicsCategory = <Document>[];

  // List<Document>? fashionCategory = <Document>[];

  // List<Document>? section = <Document>[];

  // List<Document>? childrenCategory = <Document>[];

  // List<Document>? carsCategory = <Document>[];

  // List<Document>? housingCategory = <Document>[];

  // List<Document>? booksCategory = <Document>[];

  // List<Document>? farmsCategory = <Document>[];

  RxInt selectedTab = 0.obs;

  double topCategory = 0;

  String? product;

  bool closeTopContainer = false;

  onTapSelected(int index) {
    setState(() {
      selectedTab.value = index;
    });
  }

  // Widget _getUserAvatar(BuildContext context) {
  @override
  Widget build(BuildContext context) {
    var appSize = MediaQuery.of(context).size;
    final currentUser = ref.watch(currentUserDetailsProvider).value;

    RxString start = 'starting'.obs;
    // final networkConnect = useState(start);
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

    // connectStatus() async {
    //   var connectivityResult = await (Connectivity().checkConnectivity());
    //   if (connectivityResult == ConnectivityResult.mobile) {
    //     networkConnect.value = 'mobie';
    //   } else if (connectivityResult == ConnectivityResult.wifi) {
    //     networkConnect.value = 'wifi';
    //   }
    // }

    // final connectivityStream = useStream(Connectivity().onConnectivityChanged);

    Widget _title(BuildContext context) {
      return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Material(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.transparent,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 3),
                            child: customText(
                              'MarketPlace',
                              style: TextStyle(
                                  //  color: Colors.black45,
                                  fontSize: context.responsiveValue(
                                      mobile: Get.height * 0.05,
                                      tablet: Get.height * 0.05,
                                      desktop: Get.height * 0.05),
                                  fontWeight: FontWeight.w400),
                            )),
                      ),
                      Material(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.transparent,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 3),
                            child: customText(
                              'Products',
                              style: TextStyle(
                                  //color: Colors.black45,
                                  fontSize: context.responsiveValue(
                                      mobile: Get.height * 0.05,
                                      tablet: Get.height * 0.05,
                                      desktop: Get.height * 0.05),
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                      // Text(
                      //   'MarketPlace',
                      //   style: TextStyle(
                      //       fontSize: 27,
                      //       fontWeight: FontWeight.w400,
                      //       color: Colors.blueGrey[400]),
                      // ),
                      // Text(
                      //   'Products',
                      //   style: TextStyle(
                      //       fontSize: 27,
                      //       fontWeight: FontWeight.w700,
                      //       color: Colors.blueGrey[400]),
                      // ),
                    ],
                  ),
                ],
              ),
            ],
          ));
    }

    Widget _category(Size appSize, BuildContext context) {
      return frostedYellow(Obx(
        () => Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          width: appSize.width * 0.84,
          height: Get.height * 0.10,
          // decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(20),
          //     color: Colors.blueGrey[50],
          //     gradient: LinearGradient(
          //       colors: [
          //         Colors.yellow.withOpacity(0.1),
          //         Colors.white60.withOpacity(0.2),
          //         Colors.orange.withOpacity(0.3)
          //       ],
          //       // begin: Alignment.topCenter,
          //       // end: Alignment.bottomCenter,
          //     )),
          //decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              const SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    onTapSelected(0);
                  });
                },
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          frostedWhite(
                            SizedBox(
                                height: Get.height * 0.08,
                                width: Get.height * 0.08,
                                // decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(20),
                                //     color: Colors.blueGrey[50],
                                //     gradient: LinearGradient(
                                //       colors: [
                                //         Colors.yellow.withOpacity(0.1),
                                //         Colors.white60.withOpacity(0.2),
                                //         Colors.pink.withOpacity(0.3)
                                //       ],
                                //       // begin: Alignment.topCenter,
                                //       // end: Alignment.bottomCenter,
                                //     )),
                                child: Center(
                                  child: IconButton(
                                      iconSize: context.responsiveValue(
                                          mobile: Get.height * 0.2,
                                          tablet: Get.height * 0.2,
                                          desktop: Get.height * 0.2),
                                      icon: ImageIcon(
                                        AssetImage('assets/toys.png'),
                                      ),
                                      onPressed: null),
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TabText(
                          text: 'Kids World',
                          isSelected: selectedTab == 0.obs,
                          onTapTab: () {
                            setState(() {
                              onTapSelected(0);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    onTapSelected(1);
                  });
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          frostedWhite(
                            SizedBox(
                                height: Get.height * 0.10,
                                width: Get.height * 0.10,
                                // decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(20),
                                //     color: Colors.blueGrey[50],
                                //     gradient: LinearGradient(
                                //       colors: [
                                //         Colors.yellow.withOpacity(0.1),
                                //         Colors.white60.withOpacity(0.2),
                                //         Colors.green.withOpacity(0.3)
                                //       ],
                                //       // begin: Alignment.topCenter,
                                //       // end: Alignment.bottomCenter,
                                //     )),
                                child: Center(
                                  child: Image.asset(
                                    'assets/tv.png',
                                    height: Get.height * 0.10,
                                    width: Get.height * 0.10,
                                  ),
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TabText(
                          text: 'Electronics',
                          isSelected: selectedTab == 1.obs,
                          onTapTab: () {
                            setState(() {
                              onTapSelected(1);
                            });
                          },
                          // fontSize: 15,
                          // fontWeight: FontWeight.w500,
                          // color: Colors.blueGrey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    onTapSelected(2);
                  });
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          frostedYellow(
                            SizedBox(
                                height: Get.height * 0.10,
                                width: Get.height * 0.10,
                                // decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(20),
                                //     color: Colors.blueGrey[50],
                                //     gradient: LinearGradient(
                                //       colors: [
                                //         Colors.yellow.withOpacity(0.1),
                                //         Colors.white60.withOpacity(0.2),
                                //         Colors.orange.withOpacity(0.3)
                                //       ],
                                //       // begin: Alignment.topCenter,
                                //       // end: Alignment.bottomCenter,
                                //     )),
                                child: Center(
                                  child: Image.asset(
                                    'assets/groceries.png',
                                    height: Get.height * 0.10,
                                    width: Get.height * 0.10,
                                  ),
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TabText(
                          text: 'Grocery',
                          isSelected: selectedTab == 2.obs,
                          onTapTab: () {
                            setState(() {
                              onTapSelected(2);
                            });
                          },
                          // fontSize: 15,
                          // fontWeight: FontWeight.w500,
                          // color: Colors.blueGrey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    onTapSelected(3);
                  });
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          frostedOrange(
                            SizedBox(
                                height: Get.height * 0.10,
                                width: Get.height * 0.10,
                                // decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(20),
                                //     color: Colors.blueGrey[50],
                                //     gradient: LinearGradient(
                                //       colors: [
                                //         Colors.yellow.withOpacity(0.1),
                                //         Colors.white60.withOpacity(0.2),
                                //         Colors.teal.withOpacity(0.3)
                                //       ],
                                //       // begin: Alignment.topCenter,
                                //       // end: Alignment.bottomCenter,
                                //     )),
                                child: Center(
                                  child: Image.asset(
                                    'assets/high-heels.png',
                                    height: Get.height * 0.10,
                                    width: Get.height * 0.10,
                                  ),
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TabText(
                          text: 'Fashion',
                          isSelected: selectedTab == 3.obs,
                          onTapTab: () {
                            setState(() {
                              onTapSelected(3);
                            });
                          },
                          // fontSize: 15,
                          // fontWeight: FontWeight.w500,
                          // color: Colors.blueGrey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    onTapSelected(4);
                  });
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          frostedOrange(
                            SizedBox(
                                height: Get.height * 0.10,
                                width: Get.height * 0.10,
                                // decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(20),
                                //     color: Colors.blueGrey[50],
                                //     gradient: LinearGradient(
                                //       colors: [
                                //         Colors.yellow.withOpacity(0.1),
                                //         Colors.white60.withOpacity(0.2),
                                //         Colors.teal.withOpacity(0.3)
                                //       ],
                                //       // begin: Alignment.topCenter,
                                //       // end: Alignment.bottomCenter,
                                //     )),
                                child: Center(
                                  child: Image.asset(
                                    'assets/house.png',
                                    height: Get.height * 0.10,
                                    width: Get.height * 0.10,
                                  ),
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TabText(
                          text: 'Housing',
                          isSelected: selectedTab == 4.obs,
                          onTapTab: () {
                            setState(() {
                              onTapSelected(4);
                            });
                          },
                          // fontSize: 15,
                          // fontWeight: FontWeight.w500,
                          // color: Colors.blueGrey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    onTapSelected(5);
                  });
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          frostedOrange(
                            SizedBox(
                                height: Get.height * 0.10,
                                width: Get.height * 0.10,
                                // decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(20),
                                //     color: Colors.blueGrey[50],
                                //     gradient: LinearGradient(
                                //       colors: [
                                //         Colors.yellow.withOpacity(0.1),
                                //         Colors.white60.withOpacity(0.2),
                                //         Colors.teal.withOpacity(0.3)
                                //       ],
                                //       // begin: Alignment.topCenter,
                                //       // end: Alignment.bottomCenter,
                                //     )),
                                child: Center(
                                  child: Image.asset(
                                    'assets/plant.png',
                                    height: Get.height * 0.10,
                                    width: Get.height * 0.10,
                                  ),
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TabText(
                          text: 'Farms',
                          isSelected: selectedTab == 5.obs,
                          onTapTab: () {
                            setState(() {
                              onTapSelected(5);
                            });
                          },
                          // fontSize: 15,
                          // fontWeight: FontWeight.w500,
                          // color: Colors.blueGrey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    onTapSelected(6);
                  });
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          frostedOrange(
                            SizedBox(
                                height: Get.height * 0.10,
                                width: Get.height * 0.10,
                                // decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(20),
                                //     color: Colors.blueGrey[50],
                                //     gradient: LinearGradient(
                                //       colors: [
                                //         Colors.yellow.withOpacity(0.1),
                                //         Colors.white60.withOpacity(0.2),
                                //         Colors.teal.withOpacity(0.3)
                                //       ],
                                //       // begin: Alignment.topCenter,
                                //       // end: Alignment.bottomCenter,
                                //     )),
                                child: Center(
                                  child: Image.asset(
                                    'assets/car.png',
                                    height: Get.height * 0.10,
                                    width: Get.height * 0.10,
                                  ),
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TabText(
                          text: 'Cars',
                          isSelected: selectedTab == 6.obs,
                          onTapTab: () {
                            setState(() {
                              onTapSelected(6);
                            });
                          },
                          // fontSize: 15,
                          // fontWeight: FontWeight.w500,
                          // color: Colors.blueGrey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    onTapSelected(7);
                  });
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          frostedOrange(
                            SizedBox(
                                height: Get.height * 0.10,
                                width: Get.height * 0.10,
                                // decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(20),
                                //     color: Colors.blueGrey[50],
                                //     gradient: LinearGradient(
                                //       colors: [
                                //         Colors.yellow.withOpacity(0.1),
                                //         Colors.white60.withOpacity(0.2),
                                //         Colors.teal.withOpacity(0.3)
                                //       ],
                                //       // begin: Alignment.topCenter,
                                //       // end: Alignment.bottomCenter,
                                //     )),
                                child: Center(
                                  child: Image.asset(
                                    'assets/books.png',
                                    height: Get.height * 0.10,
                                    width: Get.height * 0.10,
                                  ),
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TabText(
                          text: 'Books',
                          isSelected: selectedTab == 7.obs,
                          onTapTab: () {
                            setState(() {
                              onTapSelected(7);
                            });
                          },
                          // fontSize: 15,
                          // fontWeight: FontWeight.w500,
                          // color: Colors.blueGrey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
        ),
      ));
    }

    // useEffect(
    //   () {
    //     //  subStreaming;
    //     animationController.forward();
    //     _getChildrenCategories();
    //     _getElectronicsCategories();
    //     _getFashionCategories();
    //     _getGroceriesCategories();
    //     _getCarsCategories();
    //     _getFarmCategories();
    //     _getHousingCategories();
    //     _getBooksCategories();
    //   //  networkStreaming;
    //     _getSections();
    //     _scrollController.addListener(() {
    //       double value = _scrollController.offset / Get.height;
    //       // setState(() {
    //       topCategory = value;
    //       closeTopContainer = _scrollController.offset > 50;
    //       //});
    //     });
    //     return () {};
    //   },
    //   [
    //     kIsWeb ? useState('') : DataConnectionChecker().onStatusChange,
    //    // networkConnect,
    //     _scrollController,
    //     childrenCategoryState.value,
    //     electronicsCategoryState.value,
    //     groceriesCategoryState.value,
    //     fashionCategoryState.value,
    //     housingCategoryState.value,
    //     farmsCategoryState.value,
    //     carsCategoryState.value,
    //     booksCategoryState.value
    //   ],
    // );

    return Scaffold(
      // backgroundColor: ThemeMode.system == ThemeMode.light
      //     ? TwitterColor.mystic
      //     : const Color(0xFF212332),
      body: SafeArea(
          child: GestureDetector(
        onHorizontalDragUpdate: (details) {
          // Note: Sensitivity is integer used when you don't want to mess up vertical drag
          int sensitivity = 8;
          if (details.delta.dx > sensitivity) {
            // Right Swipe
            if (ref.read(numberProvider.notifier).state == 2) {
              ref.read(numberProvider.notifier).state = 1;
            }
          } else if (details.delta.dx < -sensitivity) {
            if (ref.read(numberProvider.notifier).state == 2) {
              ref.read(numberProvider.notifier).state = 3;
            }

            //Left Swipe
          }
        },
        child: Stack(
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
            FractionallySizedBox(
              heightFactor: 200 / 667,
              alignment: Alignment.topCenter,
              child: _title(context),
            ),
            kIsWeb
                ? FractionallySizedBox(
                    heightFactor: 1 - (400 / 667),
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            getOption(selectedTab, ref, currentUser!, false),
                      ),
                    ))

                // : Obx(
                //     () => authState.networkConnectionState.value ==
                //             'Not Connected'
                //         ? FractionallySizedBox(
                //             heightFactor: 1 - (400 / 667),
                //             widthFactor: 1 - 0.3,
                //             alignment: Alignment.center,
                //             child: Container(
                //               decoration: BoxDecoration(
                //                   color: darkBackground,
                //                   borderRadius: BorderRadius.circular(10)),
                //               width: context.responsiveValue(
                //                   mobile: Get.height * 0.4,
                //                   tablet: Get.height * 0.4,
                //                   desktop: Get.height * 0.4),
                //               height: context.responsiveValue(
                //                   mobile: Get.height * 0.4,
                //                   tablet: Get.height * 0.4,
                //                   desktop: Get.height * 0.4),
                //               child: SingleChildScrollView(
                //                   child: Center(
                //                 child: Column(
                //                   mainAxisAlignment: MainAxisAlignment.center,
                //                   crossAxisAlignment: CrossAxisAlignment.center,
                //                   children: [
                //                     Icon(
                //                         size: Get.height * 0.2,
                //                         color: darkAccent,
                //                         CupertinoIcons.wifi_slash),
                //                     Text('NetWork',
                //                         style: TextStyle(
                //                             color: darkAccent,
                //                             fontSize: context.responsiveValue(
                //                                 mobile: Get.height * 0.04,
                //                                 tablet: Get.height * 0.04,
                //                                 desktop: Get.height * 0.04),
                //                             fontWeight: FontWeight.w800)),
                //                     Text('You\'re Offline',
                //                         style: TextStyle(
                //                             color: darkAccent,
                //                             fontSize: context.responsiveValue(
                //                                 mobile: Get.height * 0.025,
                //                                 tablet: Get.height * 0.025,
                //                                 desktop: Get.height * 0.025),
                //                             fontWeight: FontWeight.w100)),
                //                   ],
                //                 ),
                //               )),
                //             ))
                : FractionallySizedBox(
                    heightFactor: 1 - (400 / 667),
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: getOption(selectedTab, ref,
                            currentUser ?? ViewductsUser(), false),
                      ),
                    )),
            FractionallySizedBox(
              heightFactor: 1 - (530 / 667),
              alignment: Alignment.bottomCenter,
              child: _category(appSize, context),
            ),
            widget.isDesktop == true || widget.isTablet == true
                ? Container()
                : Positioned(
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
            currentUser?.userId == null
                ? Container()
                : widget.desk2 == true
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
            Positioned(
              top: 10,
              // left: appSize.width * 0.7,
              right: widget.isDesktop == true
                  ? Get.width * 0.45
                  : widget.isTablet == true
                      ? Get.width * 0.52
                      : fullWidth(context) * 0.4,
              child: Row(
                children: const <Widget>[AdminNotificationForUsers()],
              ),
            ),
          ],
        ),
      )),
    );
  }
}

const Color darkAccent = Color.fromRGBO(160, 160, 160, 1);
const Color lightAccent = Color.fromRGBO(90, 90, 90, 1);

const Color darkBackground = Color.fromRGBO(66, 66, 66, 0.95);
const Color lightBackground = Color.fromRGBO(220, 220, 220, 0.95);

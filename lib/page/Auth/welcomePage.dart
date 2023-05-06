// ignore_for_file: file_names, unused_local_variable, invalid_use_of_protected_member, unnecessary_null_comparison

import 'dart:async';
import 'package:appwrite/appwrite.dart' as acc;
import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:uni_links/uni_links.dart';
import 'package:viewducts/app_theme/app_theme_constant.dart';
import 'package:viewducts/common/market_widget.dart';
import 'package:viewducts/features/products/product_controller.dart';
import 'package:viewducts/helper/enum.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/page/common/general_dialog.dart';
import 'package:viewducts/page/settings/accountSettings/policy.dart';
import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/duct/ductStoryPage.dart';
import 'package:viewducts/widgets/frosted.dart';
import 'package:viewducts/widgets/newWidget/title_text.dart' as tab;
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:viewducts/widgets/tabText.dart';
//import 'package:viewducts/widgets/tabText.dart';
import '../homePage.dart';
import 'signin.dart';

class WelcomePage extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => SignIn(),
      );
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

final _textEditingController = TextEditingController();

class _WelcomePageState extends ConsumerState<WelcomePage> {
  RxInt selectedTab = 0.obs;
  onTapSelected(int index) {
    setState(() {
      selectedTab.value = index;
    });
  }

  Widget _category(Size appSize, BuildContext context) {
    return frostedYellow(
      Container(
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
                                    onPressed: () {
                                      setState(() {
                                        onTapSelected(0);
                                      });
                                    }),
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
                        isSelected: selectedTab.value == 0,
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
                        isSelected: selectedTab.value == 1,
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
                onTapSelected(2);
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
                          onTapSelected(2);
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
                onTapSelected(3);
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
                          onTapSelected(3);
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
                onTapSelected(4);
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
                          onTapSelected(4);
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
                onTapSelected(5);
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
                          onTapSelected(5);
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
                onTapSelected(6);
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
                          onTapSelected(6);
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
                onTapSelected(7);
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
                          onTapSelected(7);
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
    );
  }

  @override
  Widget build(BuildContext context) {
    var appSize = MediaQuery.of(context).size;
    // final groceriesCategory = ref.watch(getGroceryCategoryProvider).value;

    // final electronicsCategory = ref.watch(getElectronicsCategoryProvider).value;

    // final fashionCategory = ref.watch(getFashionCategoryProvider).value;

    // final section = ref.watch(getSectionProvider).value;

    // final childrenCategory = ref.watch(getChildernCategoryProvider).value;

    // final carsCategory = ref.watch(getCarsProvider).value;

    // final housingCategory = ref.watch(getHousingProvider).value;

    // final booksCategory = ref.watch(getBookstProvider).value;

    // final farmsCategory = ref.watch(getFarmsProvider).value;
    // // final authTypeState = useState(authState.authType);
    // // final appPlayStoreState = useState(authState.appPlayStore);
    // RxList<FeedModel> listSearch = RxList<FeedModel>();

    // RxString searchingText = ''.obs;
    // RxString productsSearchingText = ''.obs;
    // RxList<FeedModel> emptySearchProductSugestion = RxList<FeedModel>();
    // final emptySearchProductSugestionState = emptySearchProductSugestion;
    // // final keyWordState = (feedState.keywords);
    // final listSearchState = (listSearch);
    // final searchValue = (searchingText);
    // // final animationController = useAnimationController(
    // //   duration: Duration(seconds: 3),
    // // );
    // final productsSearchingTextState = (productsSearchingText);

    // Uri? _latestUri;
    // Object? _err;
    // StreamSubscription? sub;
    _cookies() async {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (kIsWeb && authState.acceptCookies.value == false) {
          return showDialog(
            context: Get.context!,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Container(
                  width: Get.height * 0.5,
                  height: Get.height * 0.5,
                  child: Column(children: [
                    Expanded(
                        child: Policy(
                      active: true,
                      mdFileName: 'cookie_policy',
                      name: "Cookie",
                    )),
                    GestureDetector(
                        onTap: () {
                          authState.acceptCookies.value = true;
                          Navigator.maybePop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(0, 11),
                                    blurRadius: 11,
                                    color: Colors.black.withOpacity(0.06))
                              ],
                              borderRadius: BorderRadius.circular(18),
                              color: CupertinoColors.inactiveGray),
                          padding: const EdgeInsets.all(5.0),
                          child: Text('Countinue'),
                        ))
                  ]),
                ),
              );
            },
          );
        }
      });
    }

    Widget _body(BuildContext context) {
      _cookies();
      return SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            // ThemeMode.system == ThemeMode.light
            //     ?
            frostedBlueGray(
              Container(
                height: Get.height,
                width: Get.width,
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(100),
                  //color: Colors.blueGrey[50]
                  gradient: LinearGradient(
                    colors: [
                      Colors.yellow[300]!.withOpacity(0.1),
                      Colors.yellow[200]!.withOpacity(0.05),
                      Colors.yellowAccent[100]!.withOpacity(0.08)
                      // Color(0xfffbfbfb),
                      // Color(0xfff7f7f7),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            //: Container(),
            // Positioned(
            //   bottom: 0,
            //   left: Get.height * -0.6,
            //   child: ClipOval(
            //     child: frostedPink(
            //       Container(
            //         height: Get.height,
            //         width: Get.height,
            //         decoration: BoxDecoration(
            //           // borderRadius: BorderRadius.circular(100),
            //           //color: Colors.blueGrey[50]
            //           gradient: LinearGradient(
            //             colors: [
            //               Colors.yellow[300]!.withOpacity(0.3),
            //               Colors.yellow[200]!.withOpacity(0.1),
            //               Colors.yellowAccent[100]!.withOpacity(0.2)
            //               // Color(0xfffbfbfb),
            //               // Color(0xfff7f7f7),
            //             ],
            //             begin: Alignment.topCenter,
            //             end: Alignment.bottomCenter,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            // Positioned(
            //   bottom: -100,
            //   right: Get.height * -0.6,
            //   child: ClipOval(
            //     child: frostedBlueGray(
            //       Container(
            //         height: Get.width,
            //         width: Get.height,
            //         decoration: BoxDecoration(
            //             // borderRadius: BorderRadius.circular(100),
            //             color: Colors.blueGrey[50]!.withOpacity(0.2)),
            //       ),
            //     ),
            //   ),
            // ),
            // frostedYellow(
            //   Container(
            //     height: Get.height,
            //     width: Get.width,
            //     decoration: BoxDecoration(
            //       gradient: LinearGradient(
            //         colors: [
            //           Colors.yellow[100]!.withOpacity(0.3),
            //           Colors.yellow[200]!.withOpacity(0.1),
            //           Colors.yellowAccent[100]!.withOpacity(0.2)
            //         ],
            //         begin: Alignment.topCenter,
            //         end: Alignment.bottomCenter,
            //       ),
            //     ),
            //   ),
            // ),
            Positioned(
              top: 0,
              right: 0,
              child: Transform.rotate(
                angle: 90,
                child: Image.asset(
                  'assets/ankkara1.jpg',
                  height: context.responsiveValue(
                      mobile: Get.height * 0.15,
                      tablet: Get.height * 0.15,
                      desktop: Get.height * 0.15),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Transform.rotate(
                  angle: 90,
                  child: Image.asset(
                    'assets/ankkara1.jpg',
                    height: context.responsiveValue(
                        mobile: Get.height * 0.15,
                        tablet: Get.height * 0.15,
                        desktop: Get.height * 0.15),
                  )),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Transform.rotate(
                  angle: 90,
                  child: Image.asset(
                    'assets/ankkara1.jpg',
                    height: context.responsiveValue(
                        mobile: Get.height * 0.15,
                        tablet: Get.height * 0.15,
                        desktop: Get.height * 0.15),
                  )),
            ),
            Positioned(
              bottom: 40,
              right: 0,
              child: Transform.rotate(
                  angle: 30,
                  child: Image.asset(
                    'assets/ankkara1.jpg',
                    height: context.responsiveValue(
                        mobile: Get.height * 0.15,
                        tablet: Get.height * 0.15,
                        desktop: Get.height * 0.15),
                  )),
            ),

            FractionallySizedBox(
              heightFactor: 1 - 0.8,
              alignment: Alignment.bottomCenter,
              child: _category(appSize, context),
            ),
            FractionallySizedBox(
              heightFactor: 1 - 0.1,
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Container(
                  width: Get.width,
                  height: Get.height * 0.3,
                  child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Container(
                      //   width: Get.width - 80,
                      //   height: 40,
                      //   child: Image.asset('assets/images/icon-480.png'),
                      // ),
                      const Spacer(
                        flex: 1,
                      ),
                      // SizedBox(
                      //   height: Get.width * 0.5,
                      // ),
                      // Lottie.asset(
                      //   'assets/lottie/shopping-cart.json',
                      // ),
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Material(
                              color: Colors.yellow[50],
                              elevation: 20,
                              borderRadius: BorderRadius.circular(100),
                              shadowColor: Colors.yellow[100],
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: Image.asset('assets/delicious.png'),
                                radius: context.responsiveValue(
                                    mobile: Get.height * 0.04,
                                    tablet: Get.height * 0.06,
                                    desktop: Get.height * 0.06),
                              ),
                            ),
                            tab.TitleText(
                              'View',
                              color: Colors.blueGrey[100],
                              fontSize: context.responsiveValue(
                                  mobile: Get.height * 0.06,
                                  tablet: Get.height * 0.08,
                                  desktop: Get.height * 0.08),
                            ),
                            tab.TitleText(
                              'Ducts',
                              color: Colors.blueGrey[300],
                              fontSize: context.responsiveValue(
                                  mobile: Get.height * 0.06,
                                  tablet: Get.height * 0.08,
                                  desktop: Get.height * 0.08),
                            ),
                          ],
                        ),
                      ),
                      Text('Social, Shop And Get Paid ',

                          //  'Global Market at Your Door Step ',
                          style: TextStyle(
                            fontSize: context.responsiveValue(
                                mobile: Get.height * 0.02,
                                tablet: Get.height * 0.025,
                                desktop: Get.height * 0.025),
                          )
                          //color: Colors.blueGrey[700],
                          ),
                      const SizedBox(
                        height: 16,
                      ),

                      Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 11),
                                  blurRadius: 11,
                                  color: Colors.black.withOpacity(0.06))
                            ],
                            borderRadius: BorderRadius.circular(4),
                            color: Pallete.scafoldBacgroundColor),
                        padding: const EdgeInsets.all(5.0),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: <Widget>[
                            kIsWeb
                                ? Text(
                                    '© 2023 ViewDucts | ',
                                    style: TextStyle(
                                      fontSize: context.responsiveValue(
                                          mobile: Get.height * 0.02,
                                          tablet: Get.height * 0.02,
                                          desktop: Get.height * 0.02),
                                      fontWeight: FontWeight.w300,
                                    ),
                                  )
                                : Container(),
                            GestureDetector(
                              onTap: () {
                                Get.toNamed('/policy');
                              },
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
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'About and Privacy',
                                    style: TextStyle(
                                      fontSize: context.responsiveValue(
                                          mobile: Get.height * 0.02,
                                          tablet: Get.height * 0.02,
                                          desktop: Get.height * 0.02),
                                      color: CupertinoColors.darkBackgroundGray,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            kIsWeb
                                ? Container()
                                : Text(
                                    ' | Start Shopping',
                                    style: TextStyle(
                                      fontSize: context.responsiveValue(
                                          mobile: Get.height * 0.02,
                                          tablet: Get.height * 0.02,
                                          desktop: Get.height * 0.02),
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                            GestureDetector(
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
                              onTap: () {
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
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(18),
                                                        color: Pallete
                                                            .scafoldBacgroundColor),
                                                    child: SignIn()),
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
                                                        offset:
                                                            const Offset(0, 11),
                                                        blurRadius: 11,
                                                        color: Colors.black
                                                            .withOpacity(0.06))
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Pallete
                                                      .scafoldBacgroundColor),
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: tab.TitleText('Sign In',
                                                  // color: Colors.white,
                                                  // fontSize: 16,
                                                  // fontWeight: FontWeight.w800,
                                                  overflow:
                                                      TextOverflow.ellipsis),
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
                                      dx: -1,
                                      dy: 0,
                                      horizontal: 16,
                                      vertical: 0.1);
                                });

                                // Navigator.push(context, WelcomePage.route());
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2, vertical: 10),
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
                                      color: CupertinoColors.black),
                                  padding: const EdgeInsets.all(5.0),
                                  child: tab.TitleText(
                                    ' Log in',
                                    fontSize: context.responsiveValue(
                                        mobile: Get.height * 0.025,
                                        tablet: Get.height * 0.025,
                                        desktop: Get.height * 0.025),
                                    color: CupertinoColors.white,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FractionallySizedBox(
                heightFactor: 1 - 0.6,
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children:
                        getOption(selectedTab, ref, ViewductsUser(), true),
                  ),
                )),
            // kIsWeb
            //     ? Positioned(
            //         top: 0,
            //         left: 0,
            //         child: Row(
            //           children: [
            //             appPlayStoreState.value
            //                     .where((data) => data.operatingSystem == 'IOS')
            //                     .isNotEmpty
            //                 ? GestureDetector(
            //                     onTap: () {
            //                       String? appDownload = appPlayStoreState.value
            //                           .firstWhere((data) =>
            //                               data.operatingSystem == 'IOS')
            //                           .downloadApp;
            //                       String? storeUrl = appPlayStoreState.value
            //                           .firstWhere((data) =>
            //                               data.operatingSystem == 'IOS')
            //                           .storeUrl;
            //                       String? downlodUrl = appPlayStoreState.value
            //                           .firstWhere((data) =>
            //                               data.operatingSystem == 'IOS')
            //                           .downloadUrl;
            //                       final minio = Minio(
            //                           endPoint: userCartController
            //                               .wasabiAws.value.endPoint
            //                               .toString(),
            //                           accessKey: userCartController
            //                               .wasabiAws.value.accessKey
            //                               .toString(),
            //                           secretKey: userCartController
            //                               .wasabiAws.value.secretKey
            //                               .toString(),
            //                           region: userCartController
            //                               .wasabiAws.value.region
            //                               .toString());
            //                       appDownload == ''
            //                           ? minio.getObject(
            //                               userCartController
            //                                   .wasabiAws.value.buckedId
            //                                   .toString(),
            //                               '$downlodUrl')
            //                           : launchURL("$storeUrl");
            //                     },
            //                     child: Image.asset(
            //                       'assets/app-store.png',
            //                       height: context.responsiveValue(
            //                           mobile: Get.height * 0.1,
            //                           tablet: Get.height * 0.1,
            //                           desktop: Get.height * 0.1),
            //                     ),
            //                   )
            //                 : Container(),
            //             appPlayStoreState.value
            //                     .where(
            //                         (data) => data.operatingSystem == 'Android')
            //                     .isNotEmpty
            //                 ? GestureDetector(
            //                     onTap: () {
            //                       String? appDownload = appPlayStoreState.value
            //                           .firstWhere((data) =>
            //                               data.operatingSystem == 'Android')
            //                           .downloadApp;
            //                       String? storeUrl = appPlayStoreState.value
            //                           .firstWhere((data) =>
            //                               data.operatingSystem == 'Android')
            //                           .storeUrl;
            //                       String? downlodUrl = appPlayStoreState.value
            //                           .firstWhere((data) =>
            //                               data.operatingSystem == 'Android')
            //                           .downloadUrl;
            //                       final minio = Minio(
            //                           endPoint: userCartController
            //                               .wasabiAws.value.endPoint
            //                               .toString(),
            //                           accessKey: userCartController
            //                               .wasabiAws.value.accessKey
            //                               .toString(),
            //                           secretKey: userCartController
            //                               .wasabiAws.value.secretKey
            //                               .toString(),
            //                           region: userCartController
            //                               .wasabiAws.value.region
            //                               .toString());
            //                       appDownload == ''
            //                           ? minio.getObject(
            //                               userCartController
            //                                   .wasabiAws.value.buckedId
            //                                   .toString(),
            //                               '$downlodUrl')
            //                           : launchURL("$storeUrl");
            //                     },
            //                     child: Image.asset(
            //                       'assets/google-play.png',
            //                       height: context.responsiveValue(
            //                           mobile: Get.height * 0.15,
            //                           tablet: Get.height * 0.15,
            //                           desktop: Get.height * 0.15),
            //                     ),
            //                   )
            //                 : Container(),
            //           ],
            //         ),
            //       )
            //     : Container(),
          ],
        ),
      );
    }

    //final authState = Get.find<AuthState>();
    return Scaffold(

        // backgroundColor: TwitterColor.mystic,
        body: KeyboardDismisser(gestures: const [
      GestureType.onTap,
      GestureType.onPanUpdateUpDirection,
    ], child: _body(context)));
  }
}

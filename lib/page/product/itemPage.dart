// ignore_for_file: invalid_use_of_protected_member, file_names, unused_element, must_be_immutable, unnecessary_null_comparison

import 'dart:ui';

import 'package:animations/animations.dart';
//import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:viewducts/common/common.dart';
import 'package:viewducts/features/auth/controller/auth_controller.dart';
import 'package:viewducts/features/country/country_controller.dart';
import 'package:viewducts/features/products/product_controller.dart';
import 'package:viewducts/helper/constant.dart';
import 'package:viewducts/helper/enum.dart';
import 'package:viewducts/helper/theme.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/page/message/item_Search_bar.dart';
import 'package:viewducts/page/responsiveView.dart';
import 'package:viewducts/widgets/cartIcon.dart';

// import 'package:viewducts/state/stateController.dart';

import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/duct/widgets/ductBottomSheet.dart';
import 'package:viewducts/widgets/duct/widgets/postAsymmetricView.dart';

import 'package:viewducts/widgets/frosted.dart';
import 'package:viewducts/widgets/newWidget/emptyList.dart';
import 'package:viewducts/widgets/newWidget/title_text.dart';

class ItemPage extends ConsumerStatefulWidget {
  final String? product;
  final String? section;
  final String? category;
  String? location;
  String? state;
  final bool isWelcomePage;
  ItemPage(
      {Key? key,
      required this.product,
      required this.section,
      required this.category,
      required this.location,
      required this.isWelcomePage,
      this.state})
      : super(key: key);

  @override
  ConsumerState<ItemPage> createState() => _ItemPageState();
}

class _ItemPageState extends ConsumerState<ItemPage> {
  String? country, culture;

  // RxList<FeedModel>? productlist;
  FeedModel? modle;
  final _textEditingController = TextEditingController();
  var input = '';
  List<FeedModel> productList = <FeedModel>[];
  void searchProducts(String query) async {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    final data = ref.watch(getProductCategoriesProvider(ProductCategoryInput(
        category: widget.category!,
        section: widget.section!,
        country: currentUser!.location!)));
    final sugestion = productList.where((product) {
      final productTitle = product.productName!.toLowerCase();
      input = query.toLowerCase();
      return productTitle.contains(input);
    }).toList();

    // ref
    //     .watch(getProductCategoriesProvider(ProductCategoryInput(
    //         category: widget.category!,
    //         section: widget.section!,
    //         country: currentUser!.location!)))
    //     .value!
    //     .where((product) {
    //   final productTitle = product.productName!.toLowerCase();
    //   input = query.toLowerCase();
    //   return productTitle.contains(input);
    // }).toList();
    // setState(() {
    //   productItemCollection.value = sugestion;
    // });
    if (query == '' || query == null) {
      input = '';

      //  getData();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var appSize = MediaQuery.of(context).size;
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    var productItemCollection = ref.watch(getProductCategoriesProvider(
        ProductCategoryInput(
            category: widget.category!,
            section: widget.section!,
            country: currentUser!.location!)));

    //final pro = useState(product);
    // final sec = useState(widget.section);
    // final cate = useState(widget.category);
    // final loca = useState(widget.location);
    // final stat = useState(widget.state);
    // final productState = useState(feedState.productlist);
    //final stateSetState = useState(feedState.state);
    // final input = useState(''.obs);
    // final database = Databases(
    //   clientConnect(),
    // );
    // final realtime = Realtime(clientConnect());
    // final productStream = useStream(realtime.subscribe(
    //     ["databases.$databaseId.collections.$procold.documents"]).stream);
    // getData() async {
    //   try {
    //     final database = Databases(
    //       clientConnect(),
    //     );
    //     await database
    //         .listDocuments(
    //       databaseId: databaseId,
    //       collectionId: shoppingCartCollection,
    //       //  queries: [Query.equal('id', authState.appUser?.$id)]
    //     )
    //         .then((data) {
    //       // if (data.documents.isNotEmpty) {
    //       var value =
    //           data.documents.map((e) => CartItemModel.fromMap(e.data)).toList();

    //       userCartController.shoppingCartAppState.value = value.obs;

    //       // } else {
    //       //   userCartController.shoppingCartAppState = [CartItemModel()].obs;
    //       // }
    //     });

    //     if (input.value.value == '') {
    //       authState.appUser?.$id == null
    //           ? await database.listDocuments(
    //               databaseId: databaseId,
    //               collectionId: procold,
    //               queries: [
    //                   Query.orderDesc('createdAt'),
    //                   // Query.equal('productLocation', loca.value),

    //                   Query.equal('section', sec.value.toString()),
    //                   Query.equal('productCategory', cate.value.toString()),
    //                   // Query.equal('activeState', 'active'),

    //                   Query.limit(10),
    //                 ]).then((data) {
    //               productState.value!.value = data.documents
    //                   .map((e) => FeedModel.fromJson(e.data))
    //                   .toList();
    //             })
    //           : await database.listDocuments(
    //               databaseId: databaseId,
    //               collectionId: procold,
    //               queries: [
    //                   Query.orderDesc('createdAt'),
    //                   // Query.equal('productLocation', loca.value),
    //                   Query.equal('productState', stat.value.toString()),
    //                   Query.equal('section', sec.value.toString()),
    //                   Query.equal('productCategory', cate.value.toString()),
    //                   //Query.equal('activeState', 'active'),
    //                   Query.limit(10),
    //                 ]).then((data) {
    //               productState.value!.value = data.documents
    //                   .map((e) => FeedModel.fromJson(e.data))
    //                   .toList();
    //             });
    //     }
    //   } on AppwriteException catch (e) {
    //     cprint("$e");
    //   }
    // }

    // final cartStream = useStream(realtime.subscribe([
    //   "databases.$databaseId.collections.$shoppingCartCollection.documents"
    // ]).stream);
    // cartSub() {
    //   cartStream.data;
    //   if (userCartController.shoppingCartAppState.value != null) {
    //     switch (cartStream.data?.events) {
    //       case ["collections.*.documents"]:
    //         // setState(() {});
    //         userCartController.shoppingCartAppState.value
    //             .add(CartItemModel.fromMap(cartStream.data!.payload));

    //         break;
    //       case ["collections.*.documents.*.delete"]:
    //         // setState(() {});
    //         userCartController.shoppingCartAppState.value.removeWhere(
    //             (datas) => datas.key == cartStream.data!.payload['key']);

    //         break;

    //       default:
    //         break;
    //     }
    //   } else {
    //     cprint('it is empty');
    //   }
    // }

    // cities() async {
    //   try {
    //     final database = Databases(
    //       clientConnect(),
    //     );
    //     await database.listDocuments(
    //         databaseId: databaseId,
    //         collectionId: countryColl,
    //         queries: [Query.equal('country', loca.value)]).then((data) {
    //       var value = data.documents
    //           .map((e) => CountryModel.fromSnapshot(e.data))
    //           .first;

    //      // stateSetState.value.value = value;
    //     });
    //   } on AppwriteException catch (e) {
    //     cprint('$e');
    //   }
    // }

    // subs() {
    //   productStream.data;
    //   if (productState.value!.isNotEmpty) {
    //     switch (productStream.data?.events) {
    //       case ["collections.*.documents"]:
    //         // setState(() {});
    //         productState.value!.value
    //             .add(FeedModel.fromJson(productStream.data?.payload));

    //         break;
    //       case ["collections.*.documents.*.delete"]:
    //         // setState(() {});
    //         productState.value!.value.removeWhere(
    //             (datas) => datas.key == productStream.data!.payload['key']);

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
    //     getData();
    //     cities();
    //     subStreaming;
    //     cartStreaming;
    //     return () {
    //       sec.value == null;
    //       cate.value == null;
    //       loca.value == null;
    //       stat.value == null;
    //     };
    //   },
    //   [
    //     feedState.productlist,
    //     product,
    //     section,
    //     category,
    //     location,
    //     feedState.state,
    //     userCartController.shoppingCartAppState
    //   ],
    // );

    return Scaffold(
      //backgroundColor: TwitterColor.mystic,
      body: SafeArea(
        child: KeyboardDismisser(
          gestures: const [
            GestureType.onTap,
            GestureType.onPanUpdateUpDirection,
          ],
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
                top: -160,
                right: -240,
                child: Transform.rotate(
                  angle: 90,
                  child: Container(
                    height: fullWidth(context) * 0.8,
                    width: fullWidth(context),
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/ankkara1.jpg'))),
                  ),
                ),
              ),
              Positioned(
                bottom: -80,
                left: -250,
                child: Transform.rotate(
                  angle: 90,
                  child: Container(
                    height: fullWidth(context) * 0.8,
                    width: fullWidth(context),
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/ankkara1.jpg'))),
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
                            image: AssetImage('assets/ankara3.jpg'))),
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
                            image: AssetImage('assets/ankkara1.jpg'))),
                  ),
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(
                  color: (Colors.white12).withOpacity(0.1),
                ),
              ),
              FractionallySizedBox(
                  heightFactor: 1 - 0.18,
                  alignment: Alignment.bottomCenter,
                  child: productItemCollection.when(
                      data: (product) {
                        setState(() {
                          productList = product;
                        });
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
                                                height: context.responsiveValue(
                                                    mobile: Get.height * 0.4,
                                                    tablet: Get.height * 0.3,
                                                    desktop: Get.height * 0.3),
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
                                isWelcomePage: widget.isWelcomePage,
                                category: widget.category,
                                location: widget.location,
                                product: widget.product,
                                section: widget.section,
                                state: widget.state,
                                model: productList
                                // .where(
                                //     (data) => data.productState == 'Enugu')
                                // .toList(),
                                );
                      },
                      error: (error, stackTrace) => ErrorText(
                            error: error.toString(),
                          ),
                      loading: () => const LoaderAll())

                  //  FutureBuilder(
                  //     future: database.listDocuments(
                  //         databaseId: databaseId,
                  //         collectionId: procold,
                  //         queries: [
                  //           Query.orderDesc('createdAt'),
                  //           //  Query.equal('productLocation', loca.value.toString()),
                  //           Query.equal('productState', stat.value.toString()),
                  //           Query.equal('section', sec.value.toString()),
                  //           Query.equal('productCategory', cate.value.toString())
                  //         ]),
                  //     builder: ((context, snapshot) {
                  //       return snapshot.hasData == true
                  //           ? productState.value!.isEmpty
                  //               ? Padding(
                  //                   padding: const EdgeInsets.all(8.0),
                  //                   child: Align(
                  //                     alignment: Alignment.centerLeft,
                  //                     child: SingleChildScrollView(
                  //                       scrollDirection: Axis.vertical,
                  //                       child: Column(
                  //                         mainAxisAlignment:
                  //                             MainAxisAlignment.center,
                  //                         crossAxisAlignment:
                  //                             CrossAxisAlignment.center,
                  //                         children: [
                  //                           SizedBox(
                  //                             height: fullWidth(context) * 0.1,
                  //                           ),
                  //                           Container(
                  //                             height: 100,
                  //                             width: 100,
                  //                             decoration: BoxDecoration(
                  //                                 borderRadius:
                  //                                     BorderRadius.circular(100),
                  //                                 image: const DecorationImage(
                  //                                     image: AssetImage(
                  //                                         'assets/shopping-bag.png'))),
                  //                           ),
                  //                           Padding(
                  //                             padding: const EdgeInsets.symmetric(
                  //                                 horizontal: 30),
                  //                             child: frostedWhite(
                  //                               Align(
                  //                                 alignment: Alignment.topCenter,
                  //                                 child: SizedBox(
                  //                                   height:
                  //                                       context.responsiveValue(
                  //                                           mobile:
                  //                                               Get.height * 0.4,
                  //                                           tablet:
                  //                                               Get.height * 0.3,
                  //                                           desktop:
                  //                                               Get.height * 0.3),
                  //                                   child: const EmptyList(
                  //                                     'Chai!! No Product in Your Location ',
                  //                                     subTitle:
                  //                                         // authState.userModel!.vendor ==
                  //                                         //         true
                  //                                         //     ? 'You can Add product to this Category'
                  //                                         //     :
                  //                                         'Try Again later!',
                  //                                   ),
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                           ),
                  //                           // authState.userModel!.vendor == true
                  //                           //     ? Container()
                  //                           //     : Column(
                  //                           //         mainAxisAlignment: MainAxisAlignment.center,
                  //                           //         crossAxisAlignment: CrossAxisAlignment.center,
                  //                           //         children: [
                  //                           //           customButton(
                  //                           //             'Register',
                  //                           //             Image.asset(
                  //                           //               'assets/home 1.png',
                  //                           //               height: 20,
                  //                           //               width: 20,
                  //                           //             ),
                  //                           //           ),
                  //                           //           customText(' or ',
                  //                           //               style: TextStyle(
                  //                           //                   fontSize: 20,
                  //                           //                   color: Colors.blueGrey)),
                  //                           //           customButton(
                  //                           //             'Invite and Earn',
                  //                           //             Image.asset(
                  //                           //               'assets/home 1.png',
                  //                           //               height: 20,
                  //                           //               width: 20,
                  //                           //             ),
                  //                           //           )
                  //                           //         ],
                  //                           //       )
                  //                         ],
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 )
                  //               : PostAsymmetricView(
                  //                   category: cate.value,
                  //                   location: loca.value,
                  //                   product: widget.product,
                  //                   section: sec.value,
                  //                   state: stat.value,
                  //                   model: productState.value?.value,
                  //                 )
                  //           : productState.value!.isEmpty
                  //               ? Center(
                  //                   child: SizedBox(
                  //                   width: Get.height * 0.2,
                  //                   height: Get.height * 0.2,
                  //                   child: LoadingIndicator(
                  //                       indicatorType: Indicator.ballTrianglePath,

                  //                       /// Required, The loading type of the widget
                  //                       colors: const [
                  //                         Colors.pink,
                  //                         Colors.green,
                  //                         Colors.blue
                  //                       ],

                  //                       /// Optional, The color collections
                  //                       strokeWidth: 0.5,

                  //                       /// Optional, The stroke of the line, only applicable to widget which contains line
                  //                       backgroundColor: Colors.transparent,

                  //                       /// Optional, Background of the widget
                  //                       pathBackgroundColor: Colors.blue

                  //                       /// Optional, the stroke backgroundColor
                  //                       ),
                  //                 )
                  //                   //  CircularProgressIndicator
                  //                   //     .adaptive()
                  //                   )
                  //               : Center(
                  //                   child: SizedBox(
                  //                   width: Get.height * 0.2,
                  //                   height: Get.height * 0.2,
                  //                   child: LoadingIndicator(
                  //                       indicatorType: Indicator.ballTrianglePath,

                  //                       /// Required, The loading type of the widget
                  //                       colors: const [
                  //                         Colors.pink,
                  //                         Colors.green,
                  //                         Colors.blue
                  //                       ],

                  //                       /// Optional, The color collections
                  //                       strokeWidth: 0.5,

                  //                       /// Optional, The stroke of the line, only applicable to widget which contains line
                  //                       backgroundColor: Colors.transparent,

                  //                       /// Optional, Background of the widget
                  //                       pathBackgroundColor: Colors.blue

                  //                       /// Optional, the stroke backgroundColor
                  //                       ),
                  //                 )
                  //                   //  CircularProgressIndicator
                  //                   //     .adaptive()
                  //                   );
                  //     })),

                  ),

              Positioned(
                top: 10,
                left: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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

                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Container(
                            width: 50,
                            height: 50,
                            child: CartIcon(
                              sellerId: currentUser.userId,
                              allProduct: true,
                              currentUser: currentUser,
                            ),
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child:  userCartController
                        //             .shoppingCartAppState.isEmpty
                        //         ? Container()
                        //         : GestureDetector(
                        //             onTap: () {
                        //               Get.to(() => OpenContainer(
                        //                     closedBuilder: (context, action) {
                        //                       return ChatlistPageResponsive(
                        //                         isCart: true,
                        //                       );
                        //                     },
                        //                     openBuilder: (context, action) {
                        //                       return ChatlistPageResponsive(
                        //                         isCart: true,
                        //                       );
                        //                     },
                        //                   ));
                        //               // appState.pageIndex == 0;
                        //               // Navigator.pop(context);
                        //               // appState.pageIndex == 0;
                        //             },
                        //             child: Badge(
                        //               badgeColor:
                        //                   CupertinoColors.lightBackgroundGray,
                        //               // position: BadgePosition.topStart(
                        //               //     top: -2, start: -4),
                        //               badgeContent: TitleText(
                        //                   '${userCartController.shoppingCartAppState.length}'),

                        //               child: Padding(
                        //                 padding: const EdgeInsets.all(5.0),
                        //                 child: Container(
                        //                     decoration: BoxDecoration(
                        //                         boxShadow: [
                        //                           BoxShadow(
                        //                               offset:
                        //                                   const Offset(0, 11),
                        //                               blurRadius: 11,
                        //                               color: Colors.black
                        //                                   .withOpacity(0.06))
                        //                         ],
                        //                         borderRadius:
                        //                             BorderRadius.circular(18),
                        //                         color:
                        //                             CupertinoColors.systemRed),
                        //                     padding: const EdgeInsets.all(5.0),
                        //                     child: TitleText(
                        //                       'Cart',
                        //                       color: CupertinoColors
                        //                           .lightBackgroundGray,
                        //                     )),
                        //               ),
                        //             ),
                        //           ),

                        // ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Material(
                            elevation: 20,
                            borderRadius: BorderRadius.circular(100),
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
                              child: Container(
                                width: context.responsiveValue(
                                    mobile: Get.height * 0.4,
                                    tablet: Get.height * 0.4,
                                    desktop: Get.height * 0.5),
                                height: context.responsiveValue(
                                    mobile: Get.height * 0.05,
                                    tablet: Get.height * 0.05,
                                    desktop: Get.height * 0.05),
                                child: CupertinoSearchTextField(
                                  onSuffixTap: () {
                                    setState(() {
                                      input = '';
                                    });
                                    //  getData();
                                    _textEditingController.clear();
                                  },
                                  onChanged: (data) {
                                    cprint(data.toString());
                                    return searchProducts(data);
                                  },
                                  controller: _textEditingController,
                                ),
                              ),
                            ),
                          ),
                          ref
                              .watch(getCountryCitryProvider(widget.location!))
                              .when(
                                data: (data) {
                                  return ViewDuctMenuHolder(
                                    onPressed: () {},
                                    menuItems: data.first.states!.map((city) {
                                      return DuctFocusedMenuItem(
                                          title: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20.0),
                                            child: Container(
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
                                                      .systemYellow),
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text(
                                                city.state.toString(),
                                                style: TextStyle(
                                                  //fontSize: Get.width * 0.03,
                                                  color: AppColor.darkGrey,
                                                ),
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              widget.state = city.state;
                                            });

                                            // Get.to(() => const SettingsAndPrivacyPage());
                                          },
                                          trailingIcon: const Icon(
                                              CupertinoIcons.location));
                                    }).toList(),
                                    // <DuctFocusedMenuItem>[

                                    //   DuctFocusedMenuItem(
                                    //       title: Column(
                                    //         children: feedState.country.value
                                    //             .map((city) => Container(
                                    //                   child: Column(
                                    //                     children: city.states!
                                    //                         .map((data) => Container(
                                    //                               child: Padding(
                                    //                                 padding:
                                    //                                     const EdgeInsets
                                    //                                         .all(8.0),
                                    //                                 child: Text(
                                    //                                   data.state.toString(),
                                    //                                   style: TextStyle(
                                    //                                     //fontSize: Get.width * 0.03,
                                    //                                     color: AppColor
                                    //                                         .darkGrey,
                                    //                                   ),
                                    //                                 ),
                                    //                               ),
                                    //                             ))
                                    //                         .toList(),
                                    //                   ),
                                    //                 ))
                                    //             .toList(),
                                    //       ),
                                    //       onPressed: () {
                                    //         // Get.to(() => const SettingsAndPrivacyPage());
                                    //       },
                                    //       trailingIcon:
                                    //           const Icon(CupertinoIcons.add_circled_solid)),

                                    // ],
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: frostedWhite(
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
                                                  BorderRadius.circular(5),
                                              color: CupertinoColors
                                                  .lightBackgroundGray),
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 14,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  child: Image.asset(
                                                      'assets/location.png'),
                                                ),
                                                // CircleAvatar(
                                                //   radius: 14,
                                                //   backgroundColor: Colors.transparent,
                                                //   child: Image.asset('assets/megaphone.png'),
                                                // ),
                                                widget.state == null
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 8.0,
                                                                vertical: 3),
                                                        child: customTitleText(
                                                            'Select Location'),
                                                      )
                                                    : Row(
                                                        children: [
                                                          customTitleText(
                                                              'Location'),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        8.0,
                                                                    vertical:
                                                                        3),
                                                            child: Container(
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
                                                                              5),
                                                                  color: CupertinoColors
                                                                      .systemYellow),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5.0),
                                                              child: customTitleText(
                                                                  widget.state
                                                                      .toString()),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                error: (error, stackTrace) => Container(),
                                loading: () => Container(),
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
                          borderRadius: BorderRadius.circular(5),
                          color: CupertinoColors.darkBackgroundGray),
                      child: Text(
                        widget.category.toString(),
                        style: TextStyle(
                            color: Colors.blueGrey[200],
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

              // authState.userModel!.vendor == true
              //     ? Positioned(
              //         bottom: fullWidth(context) * 0.2,
              //         right: 10,
              //         child: Material(
              //           elevation: 20,
              //           color: Colors.transparent,
              //           borderRadius: BorderRadius.circular(10),
              //           child: GestureDetector(
              //             onTap: () {
              //               Navigator.of(context)
              //                   .pushNamed('/CreateFeedPage/tweet');
              //             },
              //             child: frostedOrange(
              //               Stack(
              //                 children: [
              //                   CircleAvatar(
              //                       backgroundColor: Colors.transparent,
              //                       radius: 25,
              //                       child: Image.asset(
              //                         'assets/shopping-bag.png',
              //                       )),
              //                   const Icon(CupertinoIcons.add_circled_solid),
              //                 ],
              //               ),
              //             ),
              //           ),
              //         ),
              //       )
              //     : Container()
            ],
          ),
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
    //var authState = Provider.of<AuthState>(context, listen: false);

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
                    //   var state = Provider.of<FeedState>(context, listen: false);
                    // feedState.setDuctToReply = model.obs;
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
            icon: model.likeList!.any((userId) => userId == "authState.userId")
                ? AppIcon.heartFill
                : AppIcon.heartEmpty,
            onPressed: () {
              addLikeToDuct(context);
            },
            iconColor:
                model.likeList!.any((userId) => userId == "authState.userId")
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
    //feedState.addLikeToDuct(widget.model!, "authState.userId", widget.model!.key);
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

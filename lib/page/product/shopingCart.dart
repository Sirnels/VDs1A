// ignore_for_file: file_names, prefer_typing_uninitialized_variables, unrelated_type_equality_checks, unused_element, must_be_immutable

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
//import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:viewducts/admin/Admin_dashbord/responsive.dart';
import 'package:viewducts/app_theme/app_theme_constant.dart';
import 'package:viewducts/common/common.dart';
import 'package:viewducts/constants/constants.dart';
import 'package:viewducts/features/auth/controller/auth_controller.dart';
import 'package:viewducts/features/products/product_controller.dart';
import 'package:viewducts/helper/enum.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/page/common/general_dialog.dart';

import 'package:viewducts/page/responsiveView.dart';
import 'package:viewducts/page/search/SearchPage.dart';
// import 'package:viewducts/state/appState.dart';
// import 'package:viewducts/state/feedState.dart';
// import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/duct/widgets/ductImage.dart';
import 'package:viewducts/widgets/frosted.dart';
import 'package:viewducts/widgets/newWidget/customLoader.dart';
import 'package:viewducts/widgets/tabText.dart';

class ShoppingCart extends ConsumerStatefulWidget {
  final Rx<ViewProduct>? cart;
  final String? sellerId;
  final String? buyerId;
  final String? sellersName;
  ShoppingCart({
    Key? key,
    this.cart,
    this.sellerId,
    this.buyerId,
    this.sellersName,
  }) : super(key: key);

  @override
  ConsumerState<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends ConsumerState<ShoppingCart> {
//   @override
  late String selectedSize, selectedColor, totalPrice, subTotalPrice;

  // String shippingfeeKg;
  FeedModel user = FeedModel();

  DuctType? type;

  // int userCartController.quantity = 1;
  String? route;

  Function(String colorName)? colorLists;

  var accessCode;

  CustomLoader loader = CustomLoader();

  ValueNotifier<bool> imageNotready = ValueNotifier(false);

  bool isToolAvailable = true;

  bool isMyProfile = false;

  // FocusNode _focusNode;
  final GlobalKey<State> keyLoader = GlobalKey<State>();

  List<dynamic>? size;

  // FeedState? productState;
  String sizeValue = "";

  String colorValue = "";

  bool? editProduct;

  String? image, name;

  //final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var itemDetails;

  // VideoPlayerController _controller;
  bool isDropdown = false;

  double? height, width, xPosiion, yPosition;

  late OverlayEntry floatingMenu;

  // Future<void> _initializeVideoplayerfuture;
  var playstate;

  // @override
  void _shop(BuildContext context) async {
    showModalBottomSheet(
        // backgroundColor: Colors.red,
        // bounce: true,
        context: context,
        builder: (context) => SafeArea(
                child: Responsive(
              mobile: SearchPage(),
              tablet: Stack(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SearchPage(),
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
                        child: SearchPage(),
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

  // void removeItemAlertBox(BuildContext context, Map id) {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Stack(
  //           children: [
  //             Positioned(
  //               top: fullWidth(context) * 0.5,
  //               left: 30,
  //               right: 30,
  //               child: frostedYellow(
  //                 Container(
  //                     padding: const EdgeInsets.only(top: 5, bottom: 0),
  //                     height: fullHeight(context) * .25,
  //                     width: fullWidth(context),
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(20),
  //                       color: Colors.blueGrey[50],
  //                       gradient: LinearGradient(
  //                         colors: [
  //                           Colors.yellow.withOpacity(0.1),
  //                           Colors.black87.withOpacity(0.2),
  //                           Colors.teal.withOpacity(0.3)
  //                           // Color(0xfffbfbfb),
  //                           // Color(0xfff7f7f7),
  //                         ],
  //                         // begin: Alignment.topCenter,
  //                         // end: Alignment.bottomCenter,
  //                       ),
  //                     ),
  //                     // decoration: BoxDecoration(
  //                     //   borderRadius: BorderRadius.only(
  //                     //     topLeft: Radius.circular(20),
  //                     //     topRight: Radius.circular(20),
  //                     //   ),
  //                     // ),
  //                     child: Column(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         const Text(
  //                           'Remove from cart',
  //                           textAlign: TextAlign.center,
  //                           style: TextStyle(
  //                               color: AppColor.lightGrey,
  //                               fontSize: 24.0,
  //                               fontWeight: FontWeight.bold,
  //                               letterSpacing: 1.0),
  //                         ),
  //                         const Divider(),
  //                         const Text(
  //                           'This product will be removed from cart',
  //                           textAlign: TextAlign.center,
  //                           style: TextStyle(
  //                               color: AppColor.lightGrey, fontSize: 16.0),
  //                         ),
  //                         const Divider(),
  //                         Row(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           crossAxisAlignment: CrossAxisAlignment.center,
  //                           children: <Widget>[
  //                             ButtonTheme(
  //                               minWidth:
  //                                   (MediaQuery.of(context).size.width - 120) /
  //                                       2,
  //                               child: GestureDetector(
  //                                 onTap: () {
  //                                   // userCartController.removeItem(id, context);
  //                                   // Navigator.of(context, rootNavigator: true)
  //                                   //     .pop();
  //                                 },
  //                                 child: const Padding(
  //                                   padding: EdgeInsets.all(5.0),
  //                                   child: Text(
  //                                     'Remove',
  //                                     style: TextStyle(
  //                                         fontSize: 20.0,
  //                                         color: Colors.redAccent),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                             const SizedBox(width: 10.0),
  //                             ButtonTheme(
  //                               minWidth:
  //                                   (MediaQuery.of(context).size.width - 120) /
  //                                       2,
  //                               child: GestureDetector(
  //                                 onTap: () {
  //                                   Navigator.of(context, rootNavigator: true)
  //                                       .pop();
  //                                 },
  //                                 child: const Padding(
  //                                   padding: EdgeInsets.all(5.0),
  //                                   child: Text(
  //                                     'Cancel',
  //                                     style: TextStyle(
  //                                         fontSize: 20.0, color: Colors.blue),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                             const SizedBox(width: 10.0)
  //                           ],
  //                         )
  //                       ],
  //                     )),
  //               ),
  //             ),
  //           ],
  //         );
  //       });
  // }

  // void shippingAlertBox(
  //   BuildContext context,
  // ) {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return Stack(
  //           children: [
  //             Positioned(
  //               top: fullWidth(context) * 0.5,
  //               left: 30,
  //               right: 30,
  //               child: frostedYellow(
  //                 Container(
  //                     padding: const EdgeInsets.only(top: 5, bottom: 0),
  //                     height: fullHeight(context) * .16,
  //                     width: fullWidth(context),
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(20),
  //                       color: Colors.blueGrey[50],
  //                       gradient: LinearGradient(
  //                         colors: [
  //                           Colors.yellow.withOpacity(0.1),
  //                           Colors.black87.withOpacity(0.2),
  //                           Colors.teal.withOpacity(0.3)
  //                           // Color(0xfffbfbfb),
  //                           // Color(0xfff7f7f7),
  //                         ],
  //                         // begin: Alignment.topCenter,
  //                         // end: Alignment.bottomCenter,
  //                       ),
  //                     ),
  //                     child: Column(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       crossAxisAlignment: CrossAxisAlignment.center,
  //                       children: [
  //                         ButtonTheme(
  //                           minWidth:
  //                               (MediaQuery.of(context).size.width - 120) / 2,
  //                           child: GestureDetector(
  //                             onTap: () {
  //                               // removeItem(id, context);
  //                               Navigator.of(context, rootNavigator: true)
  //                                   .pop();
  //                             },
  //                             child: Container(
  //                               decoration: BoxDecoration(
  //                                 borderRadius: BorderRadius.circular(20),
  //                                 //color: Colors.blueGrey[50],
  //                                 gradient: LinearGradient(
  //                                   colors: [
  //                                     Colors.black.withOpacity(0.1),
  //                                     Colors.black.withOpacity(0.2),
  //                                     Colors.black.withOpacity(0.3)
  //                                     // Color(0xfffbfbfb),
  //                                     // Color(0xfff7f7f7),
  //                                   ],
  //                                   // begin: Alignment.topCenter,
  //                                   // end: Alignment.bottomCenter,
  //                                 ),
  //                               ),
  //                               child: const Padding(
  //                                 padding: EdgeInsets.all(8.0),
  //                                 child: Text(
  //                                   'Pick at Store',
  //                                   style: TextStyle(
  //                                     fontSize: 20.0,
  //                                     color: AppColor.lightGrey,
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         const SizedBox(width: 10.0),
  //                         const Divider(
  //                           color: Colors.white,
  //                         ),
  //                         ButtonTheme(
  //                           minWidth:
  //                               (MediaQuery.of(context).size.width - 120) / 2,
  //                           child: GestureDetector(
  //                             onTap: () {
  //                               // Map<String, dynamic> args =
  //                               //     new Map<String, dynamic>();
  //                               // args['price'] =
  //                               //     userCartController.subTotalPrice.toString();
  //                               Navigator.of(context, rootNavigator: true)
  //                                   .pop();
  //                               Get.to(
  //                                   () => CheckoutResponsive(
  //                                       cart: widget.cart!,
  //                                       sellerId: widget.sellerId),
  //                                   transition: Transition.downToUp);
  //                               // Navigator.of(context).pushNamed(
  //                               //     "/ShippingAddress/",
  //                               //     arguments: args);
  //                             },
  //                             child: Container(
  //                               decoration: BoxDecoration(
  //                                 borderRadius: BorderRadius.circular(20),
  //                                 //color: Colors.blueGrey[50],
  //                                 gradient: LinearGradient(
  //                                   colors: [
  //                                     Colors.black.withOpacity(0.1),
  //                                     Colors.black.withOpacity(0.2),
  //                                     Colors.black.withOpacity(0.3)
  //                                     // Color(0xfffbfbfb),
  //                                     // Color(0xfff7f7f7),
  //                                   ],
  //                                   // begin: Alignment.topCenter,
  //                                   // end: Alignment.bottomCenter,
  //                                 ),
  //                               ),
  //                               child: const Padding(
  //                                 padding: EdgeInsets.all(8.0),
  //                                 child: Text(
  //                                   'Home Delivery',
  //                                   style: TextStyle(
  //                                     fontSize: 20.0,
  //                                     color: AppColor.lightGrey,
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         const SizedBox(width: 10.0)
  //                       ],
  //                     )),
  //               ),
  //             ),
  //           ],
  //         );
  //       });
  // }

  // nonExistingBagItems() {
  //   return Container(
  //     padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0),
  //     child: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           EmptyWidget(
  //             image: null,
  //             packageImage: PackageImage.Image_2,
  //             title: 'Empty Cart',
  //             subTitle: 'Click the button below to  shop',
  //             subtitleTextStyle: const TextStyle(color: Color(0xffabb8d6)),
  //             titleTextStyle: const TextStyle(color: Color(0xff9da9c7)),
  //           ),
  //           // const Text(
  //           //   'No items existed. Shop for new products',
  //           //   style: TextStyle(fontSize: 20.0),
  //           // ),
  //           const SizedBox(height: 10.0),
  //           ButtonTheme(
  //             height: 45.0,
  //             minWidth: 100.0,
  //             shape: const RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.all(Radius.circular(7.0))),
  //             child: TextButton(
  //               onPressed: () async {
  //                 _shop(Get.context!);
  //               },
  //               child: Container(
  //                 decoration: BoxDecoration(
  //                     boxShadow: [
  //                       BoxShadow(
  //                           offset: const Offset(0, 11),
  //                           blurRadius: 11,
  //                           color: Colors.black.withOpacity(0.06))
  //                     ],
  //                     borderRadius: BorderRadius.circular(5),
  //                     color: CupertinoColors.systemOrange),
  //                 padding: const EdgeInsets.all(5.0),
  //                 child: const Text(
  //                   'Shop Now',
  //                   style: TextStyle(
  //                       color: CupertinoColors.darkBackgroundGray,
  //                       // color: Colors.white,
  //                       fontSize: 20.0,
  //                       fontWeight: FontWeight.bold),
  //                 ),
  //               ),
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // // @override
  @override
  Widget build(
    BuildContext context,
  ) {
    var appSize = MediaQuery.of(context).size;
    final openCart = true.obs;
    // RxList<CartItemModel> cartOrders = RxList<CartItemModel>();

    var price = StateProvider<double>((ref) {
      return 0.0;
    });
    var finalPrice = StateProvider<double>((ref) {
      return 0.0;
    });
    var totalShipping = StateProvider<double>((ref) {
      return 0.0;
    });
    var totalWeight = StateProvider<double>((ref) {
      return 0.0;
    });
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    final vendor = ref.watch(userDetailsProvider('${widget.sellerId}')).value;
    calculatePrice() {
      ref.watch(finalPrice.notifier).state = ref.watch(price.notifier).state +
          ref.watch(totalShipping.notifier).state.toDouble();
    }

    void _checkout(BuildContext context, List<CartItemModel> product) {
      //  userPayment.value = RxList<InitPaymentModel>();
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
                          child: SizedBox(
                              width: Get.width,
                              height: Get.height * 0.7,
                              child: CheckoutResponsive(
                                currentUser: currentUser,
                                cart: widget.cart!,
                                product: product,
                                sellerId: vendor?.userId,
                              )),
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
                    child: Text('Checkout',
                        // color: Colors.white,
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

      // showModalBottomSheet(
      //     backgroundColor: Colors.red,
      //     //bounce: true,
      //     context: context,
      //     builder: (context) => Stack(
      //           children: <Widget>[
      //             SizedBox(
      //                 width: Get.width,
      //                 height: Get.height * 0.7,
      //                 child: CheckoutResponsive(
      //                     cart: widget.cart!, sellerId: vendor?.userId)),
      //           ],
      //         ));
    }

    processment() async {
      Navigator.pop(context);

      //_checkout(context);
    }

    // final isloading = ref.watch(productControllerProvider);
    checkout() {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (openCart.value == false) {
          return processment();
        }
      });
    }

    body(CartItemModel cartItem, FeedModel product,
        {double price = 0.0, double weight = 0.0, double shipping = 0.0}) {
      checkout();
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: fullWidth(context),
                  child: ListTile(
                    leading: Container(
                      height: 50,
                      width: 50,
                      child: ProductDuctImage(
                          model: product,
                          type: DuctType.Duct,
                          currentUser: currentUser,
                          vendor: vendor),
                    ),
                    title: product.productName == null
                        ? Container()
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              customTitleText('${product.productName}')
                            ],
                          ),
                    subtitle: Column(
                      children: [
                        cartItem.size == null || cartItem.size!.isEmpty
                            ? Container()
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.blueGrey[50],
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.white.withOpacity(0.1),
                                            Colors.white.withOpacity(0.2),
                                            Colors.white.withOpacity(0.3)
                                            // Color(0xfffbfbfb),
                                            // Color(0xfff7f7f7),
                                          ],
                                          // begin: Alignment.topCenter,
                                          // end: Alignment.bottomCenter,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: customText(
                                          'Size : ${cartItem.size}',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        // item['color'] == null
                        //     ? Container()
                        //     :
                        cartItem.color == null || cartItem.color!.isEmpty
                            ? Container()
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.blueGrey[50],
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.white.withOpacity(0.1),
                                          Colors.white.withOpacity(0.2),
                                          Colors.white.withOpacity(0.3)
                                          // Color(0xfffbfbfb),
                                          // Color(0xfff7f7f7),
                                        ],
                                        // begin: Alignment.topCenter,
                                        // end: Alignment.bottomCenter,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: customText(
                                        'Color : ${cartItem.color}',
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        product.price == null
                            ? Container()
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [customTitleText('${product.price}')],
                              ),

                        const SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                    trailing: Container(
                      width: 140,
                      height: 50,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: fullWidth(context) * 0.3,
                            child: Row(
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () async {
                                    // EasyLoading.show(
                                    //     status:
                                    //         'Viewducting');
                                    await ref
                                        .read(
                                            productControllerProvider.notifier)
                                        .decreaseQuantity(cartItem);
                                    setState(() {
                                      // productPrice = int.tryParse(
                                      //         product.price.toString()) ??
                                      //     0 *
                                      //         int.tryParse(cartItem.quantity
                                      //             .toString())!;
                                    });
                                    // await Future.delayed(
                                    //     const Duration(
                                    //         seconds: 8),
                                    //     () {});
                                    // EasyLoading.dismiss();
                                  },
                                  child: const Icon(
                                    CupertinoIcons.minus_circled,
                                    size: 30,
                                    color: Colors.black,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text('${cartItem.quantity}',
                                      style:
                                          const TextStyle(color: Colors.black)),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    // EasyLoading.show(
                                    //     status:
                                    //         'Viewducting');
                                    await ref
                                        .read(
                                            productControllerProvider.notifier)
                                        .increaseQuantity(cartItem);
                                    setState(() {
                                      // productPrice = int.tryParse(
                                      //         product.price.toString()) ??
                                      //     0 *
                                      //         int.tryParse(cartItem.quantity
                                      //             .toString())!;
                                    });
                                    // await Future.delayed(
                                    //     const Duration(
                                    //         seconds: 8),
                                    //     () {});
                                    // EasyLoading.dismiss();
                                    //  // setState(() {});
                                  },
                                  child: const Icon(
                                    CupertinoIcons.add_circled_solid,
                                    size: 30,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )),
          Divider()
        ],
      );
    }

    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    // cartOrders = ref
    //     .watch(getProductsInCartByVendorsProvider('${widget.sellerId}'))
    //     .value!
    //     .obs;
    Rx<double> totalCartPrice = 0.0.obs;

    // Rx<double> totalCartWeight = 0.0.obs;
    // Rx<double> totalCartShipping = 0.0.obs;
    // double total;
    return Scaffold(
        key: _scaffoldKey,
        //  backgroundColor: TwitterColor.mystic,
        body: SafeArea(
          child: Stack(
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
              ref
                  .watch(
                      getProductsInCartByVendorsProvider('${widget.sellerId}'))
                  .when(
                    data: (cartItemList) {
                      return ref
                          .watch(getCartStreamProvider('${widget.sellerId}'))
                          .when(
                            data: (data) {
                              if (data.events.contains(
                                'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.shoppingCartCollection}.documents.*.create',
                              )) {
                                cartItemList.insert(
                                    0, CartItemModel.fromMap(data.payload));
                              } else if (data.events.contains(
                                'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.shoppingCartCollection}.documents.*.update',
                              )) {
                                // get id of original cart
                                final startingPoint =
                                    data.events[0].lastIndexOf('documents.');
                                final endPoint =
                                    data.events[0].lastIndexOf('.update');
                                final cartId = data.events[0]
                                    .substring(startingPoint + 10, endPoint);

                                var cart = cartItemList
                                    .where((element) => element.id == cartId)
                                    .first;

                                final cartItemIndex =
                                    cartItemList.indexOf(cart);
                                cartItemList.removeWhere(
                                    (element) => element.id == cartId);

                                cart = CartItemModel.fromMap(data.payload);
                                cartItemList.insert(cartItemIndex, cart);
                              }

                              return ListView.builder(
                                itemCount: cartItemList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final cart = cartItemList[index];
                                  // final product = ref
                                  //     .watch(getOneProductProvider(
                                  //         '${cart.productId}'))
                                  //     .value;
                                  // // ref.read(price.notifier).state  = 0;

                                  return ref
                                      .watch(getOneProductProvider(
                                          '${cart.productId}'))
                                      .when(
                                          data: (product) {
                                            // Future.delayed(
                                            //     Duration(milliseconds: 10), () {
                                            //   ref.watch(price.notifier).state =
                                            //       0;

                                            //   if (cartItemList.isNotEmpty) {
                                            //     for (var cartItem
                                            //         in cartItemList) {
                                            //       // product?.reservedFee != 0 ||
                                            //       //         product?.reservedFee != null
                                            //       //     ? price.value +=
                                            //       //         ((double.parse(product?.reservedFee.toString() ?? '0.0') * int.parse(cartItem.quantity.toString())))
                                            //       //             .toDouble()
                                            //       // :
                                            //       // product?.salePrice == 0 ||
                                            //       //         product?.salePrice == null
                                            //       //     ?
                                            //       ref
                                            //           .watch(price.notifier)
                                            //           .state += ((double.parse(
                                            //                   product.price
                                            //                       .toString()) *
                                            //               int.parse(cartItem
                                            //                   .quantity
                                            //                   .toString())))
                                            //           .toDouble();
                                            //       // : price.value += ((double.parse(
                                            //       //             product?.salePrice.toString() ??
                                            //       //                 '0.0') *
                                            //       //         int.parse(cartItem.quantity.toString())))
                                            //       //     .toDouble();
                                            //     }
                                            //   }
                                            //   ref
                                            //       .watch(totalWeight.notifier)
                                            //       .state = 0.0;
                                            //   if (cartItemList.isNotEmpty) {
                                            //     for (var cartItem
                                            //         in cartItemList) {
                                            //       ref
                                            //           .watch(
                                            //               totalWeight.notifier)
                                            //           .state += (int.parse(
                                            //                   product.weight
                                            //                       .toString()) *
                                            //               int.parse(cartItem
                                            //                   .quantity
                                            //                   .toString()))
                                            //           .toDouble();
                                            //     }
                                            //   }
                                            //   ref
                                            //       .watch(totalShipping.notifier)
                                            //       .state = 0.0;
                                            //   if (cartItemList.isNotEmpty) {
                                            //     for (var cartItem
                                            //         in cartItemList) {
                                            //       ref
                                            //           .watch(totalShipping
                                            //               .notifier)
                                            //           .state += ((int.parse(
                                            //                   product
                                            //                       .shippingFee
                                            //                       .toString()) *
                                            //               int.parse(cartItem
                                            //                   .quantity
                                            //                   .toString()))
                                            //           //      *
                                            //           // 0
                                            //           )
                                            //           .toDouble();
                                            //     }
                                            //   }
                                            // });

                                            // calculatePrice();
                                            // cprint(
                                            //     '${ref.watch(finalPrice.notifier).state}');
                                            return Container(
                                                height: 100,
                                                width: fullWidth(context),
                                                child: body(cart, product));
                                          },
                                          error: (error, stackTrace) =>
                                              ErrorText(
                                                error: error.toString(),
                                              ),
                                          loading: () => Container());
                                },
                              );
                            },
                            error: (error, stackTrace) => ErrorText(
                              error: error.toString(),
                            ),
                            loading: () {
                              return ListView.builder(
                                itemCount: cartItemList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final cart = cartItemList[index];

                                  return ref
                                      .watch(getOneProductProvider(
                                          '${cart.productId}'))
                                      .when(
                                          data: (product) {
                                            // double itemPriceAdded() {
                                            //   if (cartItemList.isNotEmpty) {
                                            //     for (var cartItem
                                            //         in cartItemList) {
                                            //       // product?.reservedFee != 0 ||
                                            //       //         product?.reservedFee != null
                                            //       //     ? price.value +=
                                            //       //         ((double.parse(product?.reservedFee.toString() ?? '0.0') * int.parse(cartItem.quantity.toString())))
                                            //       //             .toDouble()
                                            //       // :
                                            //       // product?.salePrice == 0 ||
                                            //       //         product?.salePrice == null
                                            //       //     ?
                                            //       totalCartPrice.value +=
                                            //           ((double.parse(product
                                            //                       .price
                                            //                       .toString()) *
                                            //                   int.parse(cartItem
                                            //                       .quantity
                                            //                       .toString())))
                                            //               .toDouble();

                                            //       // : price.value += ((double.parse(
                                            //       //             product?.salePrice.toString() ??
                                            //       //                 '0.0') *
                                            //       //         int.parse(cartItem.quantity.toString())))
                                            //       //     .toDouble();
                                            //     }
                                            //   }
                                            //   return totalCartPrice.value;
                                            // }

                                            // itemWeightAdded() {
                                            //   if (cartItemList.isNotEmpty) {
                                            //     for (var cartItem
                                            //         in cartItemList) {
                                            //       totalCartWeight += (int.parse(
                                            //                   product.weight
                                            //                       .toString()) *
                                            //               int.parse(cartItem
                                            //                   .quantity
                                            //                   .toString()))
                                            //           .toDouble();
                                            //     }
                                            //   }
                                            //   return totalCartWeight.value;
                                            // }

                                            // double itemShippingFee() {
                                            //   if (cartItemList.isNotEmpty) {
                                            //     for (var cartItem
                                            //         in cartItemList) {
                                            //       ref
                                            //           .watch(totalShipping
                                            //               .notifier)
                                            //           .state += ((int.parse(
                                            //                   product
                                            //                       .shippingFee
                                            //                       .toString()) *
                                            //               int.parse(cartItem
                                            //                   .quantity
                                            //                   .toString()))
                                            //           //      *
                                            //           // 0
                                            //           )
                                            //           .toDouble();
                                            //     }
                                            //   }
                                            //   return totalCartShipping.value;
                                            // }

                                            // Future.delayed(
                                            //     Duration(milliseconds: 0), () {
                                            //   cprint(
                                            //       '${itemShippingFee() + itemWeightAdded() + itemPriceAdded()} summation');
                                            //   // ref
                                            //   //         .read(finalPrice.notifier)
                                            //   //         .state =
                                            //   //     itemShippingFee() +
                                            //   //         itemWeightAdded() +
                                            //   //         itemPriceAdded();
                                            //   // ref.watch(price.notifier).state =
                                            //   //     0;

                                            //   // ref
                                            //   //     .watch(totalWeight.notifier)
                                            //   //     .state = 0.0;

                                            //   // ref
                                            //   //     .watch(totalShipping.notifier)
                                            //   //     .state = 0.0;
                                            // });

                                            return Container(
                                                height: 100,
                                                width: fullWidth(context),
                                                child: body(
                                                  cart,
                                                  product,
                                                ));
                                          },
                                          error: (error, stackTrace) =>
                                              ErrorText(
                                                error: error.toString(),
                                              ),
                                          loading: () => Container());
                                },
                              );
                            },
                          );
                    },
                    error: (error, stackTrace) => ErrorText(
                      error: error.toString(),
                    ),
                    loading: () => Container(),
                  ),
              ref
                  .watch(
                      getProductsInCartByVendorsProvider('${widget.sellerId}'))
                  .when(
                      data: (cartItemList) {
                        final isloading = ref.watch(productControllerProvider);
                        totalCartPrice = cartItemList
                            .map<double>((item) =>
                                item.quantity!.toDouble() *
                                double.parse(item.price.toString()))
                            .reduce((value1, value2) => value1 + value2)
                            .obs;
                        cprint('${totalCartPrice.value} pricing');
                        return Positioned(
                          bottom: 10,
                          left: 10,
                          right: 10,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.blueGrey[50],
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.1),
                                  Colors.white.withOpacity(0.2),
                                  Colors.white.withOpacity(0.3)
                                  // Color(0xfffbfbfb),
                                  // Color(0xfff7f7f7),
                                ],
                                // begin: Alignment.topCenter,
                                // end: Alignment.bottomCenter,
                              ),
                            ),
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.end,
                                    //   crossAxisAlignment:
                                    //       CrossAxisAlignment.end,
                                    //   children: [
                                    //     Column(
                                    //       children: [
                                    //         Container(
                                    //           decoration: BoxDecoration(
                                    //             borderRadius:
                                    //                 BorderRadius.circular(20),
                                    //             color: Colors.blueGrey[50],
                                    //             gradient: LinearGradient(
                                    //               colors: [
                                    //                 Colors.white
                                    //                     .withOpacity(0.1),
                                    //                 Colors.white
                                    //                     .withOpacity(0.2),
                                    //                 Colors.white
                                    //                     .withOpacity(0.3)
                                    //               ],
                                    //               // begin: Alignment.topCenter,
                                    //               // end: Alignment.bottomCenter,
                                    //             ),
                                    //           ),
                                    //           child: Padding(
                                    //             padding:
                                    //                 const EdgeInsets.all(5.0),
                                    //             child: customText(
                                    //               'Total Weight : ${ref.watch(totalWeight.notifier).state} g',
                                    //               style: const TextStyle(
                                    //                   fontSize: 15,
                                    //                   fontWeight:
                                    //                       FontWeight.w100),
                                    //             ),
                                    //           ),
                                    //         ),
                                    //         GestureDetector(
                                    //           onTap: () {
                                    //             // showModalBottomSheet(
                                    //             //     backgroundColor: Colors.red,
                                    //             //     bounce: true,
                                    //             //     context: context,
                                    //             //     builder: (context) => Container(
                                    //             //         //     child: DuctStoryView(
                                    //             //         //   model: model,
                                    //             //         // )
                                    //             //         ));
                                    //           },
                                    //           child: Padding(
                                    //             padding:
                                    //                 const EdgeInsets.all(2.0),
                                    //             child: Row(
                                    //               children: [
                                    //                 customText(
                                    //                   '',
                                    //                   //  'Delivering Fee : ${NumberFormat.currency(name: authState.userModel?.location == 'Nigeria' ? '₦' : '£').format(double.parse(totalShipping.value.toString()))}',
                                    //                   style: const TextStyle(
                                    //                       fontSize: 15,
                                    //                       fontWeight:
                                    //                           FontWeight.w100),
                                    //                 ),

                                    //                 // IconButton(
                                    //                 //   onPressed: () {
                                    //                 //     shippingCompany(
                                    //                 //         context);

                                    //                 //     // Navigator.pop(context);
                                    //                 //   },
                                    //                 //   color: Colors.black,
                                    //                 //   icon: Icon(
                                    //                 //       CupertinoIcons
                                    //                 //           .forward),
                                    //                 // ),
                                    //               ],
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ],
                                    //     )
                                    //   ],
                                    // ),

                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8.0, 0.0, 12.0, 4.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          const Text(
                                            'Total',
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Obx(
                                            () => customText(
                                              //   '',
                                              NumberFormat.currency(
                                                      name: currentUser
                                                                  ?.location ==
                                                              'Nigeria'
                                                          ? '₦'
                                                          : '£')
                                                  .format(double.parse((totalCartPrice

                                                      // ((int.parse(cartItem.price.toString()) *
                                                      //             int.parse(cartItem.quantity
                                                      //                 .toString())) +
                                                      //         (int.parse(cartItem.weight
                                                      //                 .toString()) *
                                                      //             100 *
                                                      //             int.parse(cartItem.quantity
                                                      //                 .toString())))
                                                      //     .toString(),
                                                      )
                                                      .toString())),
                                              style: const TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                // sellerId == authState.userId
                                //     ? Container()
                                //     :
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    // frostedRed(
                                    //   Container(
                                    //     height: Get.width * 0.1,
                                    //     width: Get.width * 0.3,
                                    //     child: Center(
                                    //       child: GestureDetector(
                                    //         onTap: () async {
                                    //           // var feedState =
                                    //           //     Provider.of<FeedState>(context,
                                    //           //         listen: false);
                                    //           // var auth = Provider.of<AuthState>(
                                    //           //     context,
                                    //           //     listen: false);

                                    //           if (userCartController
                                    //                   .bagItemList.length !=
                                    //               0) {
                                    //             await feedState
                                    //                 .deleteProductInCart(
                                    //                     authState.userId);
                                    //           }
                                    //         },
                                    //         child: frostedOrange(
                                    //           Container(
                                    //             decoration: BoxDecoration(
                                    //                 borderRadius:
                                    //                     BorderRadius
                                    //                         .circular(20),
                                    //                 color:
                                    //                     Colors.blueGrey[50],
                                    //                 gradient:
                                    //                     LinearGradient(
                                    //                   colors: [
                                    //                     Colors.yellow
                                    //                         .withOpacity(
                                    //                             0.1),
                                    //                     Colors.white60
                                    //                         .withOpacity(
                                    //                             0.2),
                                    //                     Colors.red
                                    //                         .withOpacity(
                                    //                             0.3)
                                    //                   ],
                                    //                   // begin: Alignment.topCenter,
                                    //                   // end: Alignment.bottomCenter,
                                    //                 )),
                                    //             child: Row(
                                    //               children: [
                                    //                 Icon(CupertinoIcons
                                    //                     .clear_circled_solid),
                                    //                 Padding(
                                    //                   padding:
                                    //                       const EdgeInsets
                                    //                               .symmetric(
                                    //                           horizontal:
                                    //                               8.0,
                                    //                           vertical: 3),
                                    //                   child:
                                    //                       customTitleText(
                                    //                           'Clear'),
                                    //                 ),
                                    //               ],
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),

                                    // DateFormat("E").format(DateTime.now()) == 'Sun'
                                    //     ? Container()
                                    //     :
                                    // totalCartPrice.value == 0
                                    //     ? SizedBox()
                                    //     :
                                    GestureDetector(
                                      onTap: () async {
                                        ref
                                            .read(productControllerProvider
                                                .notifier)
                                            .initializePayment(
                                                totalCartPrice.value,
                                                currentUser?.userId,
                                                vendor?.userId,
                                                'NG',
                                                context,
                                                currentUser?.email);
                                        //Navigator.pop(context);
                                        _checkout(context, cartItemList);
                                      },
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
                                                  Colors.greenAccent
                                                      .withOpacity(0.3)
                                                ],
                                                // begin: Alignment.topCenter,
                                                // end: Alignment.bottomCenter,
                                              )),
                                          child: Row(
                                            children: [
                                              isloading
                                                  ? Loader()
                                                  : Container(),
                                              Container(
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
                                                            18),
                                                    color: CupertinoColors
                                                        .activeGreen),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 8.0,
                                                      vertical: 3),
                                                  child: customTitleText(
                                                      'CheckOut'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      error: (error, stackTrace) => ErrorText(
                            error: error.toString(),
                          ),
                      loading: () => const LoaderAll()),
            ],
          ),
        ));
  }

  Future<dynamic> shippingCompany(BuildContext context) {
    return showModalBottomSheet(
        backgroundColor: Colors.red,
        //bounce: true,
        context: context,
        builder: (context) => Container(
            //     child: DuctStoryView(
            //   model: model,
            // )
            ));
  }
}

class CartItems extends StatelessWidget {
  final FeedModel product;
  final int index;
  final bool lastItem;
  final int qauntity;
  final NumberFormat formatter;
  final FeedModel? ductProduct;
  final DuctType? type;
  const CartItems(
      {Key? key,
      required this.product,
      required this.formatter,
      required this.index,
      required this.lastItem,
      required this.qauntity,
      this.ductProduct,
      this.type})
      : super(key: key);
  Widget _imageFeed(String? _image) {
    return _image == null
        ? Container()
        : Container(
            alignment: Alignment.center,
            child: customNetworkImage(
              _image,
              fit: BoxFit.fitWidth,
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    var appSize = MediaQuery.of(context).size;
    // var state = Provider.of<FeedState>(context);
    // final productIndex = index - 4;
    return Scaffold(
        body: Material(
            elevation: 10,
            color: Colors.white.withOpacity(0.8),
            child: frostedYellow(
              Stack(
                children: <Widget>[
                  SizedBox(
                    height: appSize.width * 0.2,
                    width: fullWidth(context),
                    child: Row(
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: 1.2,
                          child: Stack(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: SizedBox(
                                  height: 70,
                                  width: 70,
                                  child: Stack(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Material(
                                          elevation: 30,
                                          child: frostedOrange(
                                            //                  DuctImage(
                                            // feedState: ductProduct,
                                            // type: type,)
                                            _imageFeed(''
                                                // feedState
                                                //   .ductDetailModel!
                                                //   .last!
                                                //   .imagePath
                                                ),
                                            // Container(
                                            //   decoration: BoxDecoration(
                                            //     //color: LightColor.lightGrey,
                                            //     borderRadius:
                                            //         BorderRadius.circular(10),
                                            //     image: DecorationImage(
                                            //         image: AssetImage(
                                            //             product.imagePath),
                                            //         fit: BoxFit.cover),
                                            //   ),
                                            // ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: ListTile(
                                title: TitleText(
                                  text: product.productName,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                                subtitle: Row(
                                  children: <Widget>[
                                    TitleText(
                                      text: formatter.format(
                                          qauntity * int.parse(product.price!)),
                                      fontSize: 14,
                                    ),
                                  ],
                                ),
                                trailing: Material(
                                  elevation: 10,
                                  color: Colors.yellow[100]!.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(50),
                                  child: frostedYellow(
                                    Container(
                                      width: 120,
                                      height: 35,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          //color: LightColor.lightGrey.withAlpha(150),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: TitleText(
                                        text:
                                            '${qauntity > 1 ? '$qauntity x' : ''}'
                                            '${formatter.format(product.price)}',
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                )))
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: appSize.width * 0.9,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          // final feedState =
                          //     Provider.of<FeedState>(context, listen: false);
                          //   feedState.removeItemFromCart(product.key!.length);
                        },
                        child: const Icon(CupertinoIcons.clear_thick_circled),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: appSize.width * 0.45,
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            // final feedState =
                            //     Provider.of<FeedState>(context, listen: false);
                            // feedState.removeItemFromCart(product.key!.length);
                          },
                          child: Icon(
                            CupertinoIcons.minus_circled,
                            size: 30,
                            color: Colors.blueGrey[900],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(qauntity > 0 ? '$qauntity ' : ''),
                        ),
                        GestureDetector(
                          onTap: () {
                            // final feedState =
                            //     Provider.of<FeedState>(context, listen: false);
                            // feedState.addProductToCart(product.key!.length);
                          },
                          child: Icon(
                            CupertinoIcons.add_circled_solid,
                            size: 30,
                            color: Colors.blueGrey[900],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )));
  }
}

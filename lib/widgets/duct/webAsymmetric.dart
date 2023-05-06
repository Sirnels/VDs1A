// ignore_for_file: file_names, sized_box_for_whitespace, use_key_in_widget_constructors, prefer_typing_uninitialized_variables, deprecated_member_use, unused_local_variable, unused_element, invalid_use_of_protected_member

import 'dart:io';

import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
//import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:viewducts/helper/enum.dart';
import 'package:viewducts/helper/theme.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/page/responsiveView.dart';

import 'package:viewducts/state/feedState.dart';
import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/customWidgets.dart';

import 'package:viewducts/widgets/duct/widgets/ductImage.dart';
import 'package:viewducts/widgets/frosted.dart';
import 'package:viewducts/widgets/newWidget/title_text.dart';

class NormalView extends HookWidget {
  const NormalView(
      {Key? key,
      this.model,
      this.trailing,
      this.type,
      this.isDisplayOnProfile,
      this.item})
      : super(key: key);
  final List<FeedModel>? item;
  final FeedModel? model;
  final Widget? trailing;
  final DuctType? type;
  final bool? isDisplayOnProfile;

//   @override
//   _NormalViewState createState() => _NormalViewState();
// }

// class _NormalViewState extends State<NormalView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: fullWidth(context) * 0.5,
      height: fullHeight(context) * 0.8,
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        const double spacerHeight = 44.0;

        final double heightOfCards =
            (constraints.biggest.height - spacerHeight) / 2.0;
        final double heightOfImages = heightOfCards - _ItemCard.kTextBoxHeight;
        final double imageAspectRatio = (heightOfImages >= 0.0 &&
                constraints.biggest.width > heightOfImages)
            ? constraints.biggest.width / heightOfImages
            : 33 / 49;

        return ListView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children:
                // <Widget>[
                // Padding(
                //   padding: const EdgeInsetsDirectional.only(start: 28.0),
                //   child: top != null
                //       ? _ItemCard(
                //           imageAspectRatio: imageAspectRatio,
                //           ductProduct: top,
                //         )
                //       : SizedBox(
                //           height: heightOfCards > 0 ? heightOfCards : spacerHeight,
                //         ),
                // ),
                // const SizedBox(height: spacerHeight),
                item!
                    .map(
                      (model) => Padding(
                        padding: const EdgeInsetsDirectional.only(end: 55.0),
                        child: Container(
                          width: Get.height * 0.25,
                          child: _ItemCard(
                            imageAspectRatio: imageAspectRatio,
                            ductProduct: model,
                          ),
                        ),
                      ),
                    )
                    .toList()

            //   ],
            );
      }),
    );
    // Column(
    //   children: [
    //     // Container(
    //     //   width: fullWidth(context) * 0.2,
    //     //   height: fullWidth(context) * 0.2,
    //     //   child: _imageFeed(widget.model?.imagePath),
    //     // ),
    //     _ItemCard(
    //       ductProduct: widget.model,
    //       isDisplayOnProfile: widget.isDisplayOnProfile,
    //     ),
    //   ],
    // );
  }
}

class ItemModel {
  String title;
  IconData icon;

  ItemModel(this.title, this.icon);
}

class _ItemCard extends StatefulWidget {
  const _ItemCard({
    this.imageAspectRatio = 33 / 49,
    this.ductProduct,
    this.type,
    this.profileId,
    this.isDisplayOnProfile,
  }) : assert(imageAspectRatio > 0);
  final DuctType? type;
  final double imageAspectRatio;
  final String? profileId;

  // final Products products;
  final FeedModel? ductProduct;
  final bool? isDisplayOnProfile;
  static const double kTextBoxHeight = 65.0;

  @override
  __ItemCardState createState() => __ItemCardState();
}

ValueNotifier<bool> imageNotready = ValueNotifier(false);

class __ItemCardState extends State<_ItemCard> {
  var isDropdown = false.obs;
  double? height, width, xPosiion, yPosition;
  late OverlayEntry floatingMenu;
  DuctType? type;
  Color? iconColor;
  Color? iconEnableColor;
  double? size;
  bool isDuctDetail = false;
  String? ductId;

  String? senderId;

  String? userImage;

  bool? isContinuing;

  FocusNode textFieldFocus = FocusNode();

  FocusNode imageTextFieldFocus = FocusNode();

  //ChatState state = ChatState();

  // AuthState authState = AuthState();

  // FeedState feedState = FeedState();

  ValueNotifier<bool> isSelected = ValueNotifier(false);

  String? chatUserProductId, myOrders;

  String? peerAvatar, peerNo, currentUserNo, privateKey, sharedSecret;

  bool locked = false;
  bool hidden = false;

  int? chatStatus, unread;

  GlobalKey? actionKey;

  dynamic lastSeen;

  String? chatId;

  bool isWriting = false;

  var showEmojiPicker = false.obs;

  File? imageFile;

  bool isLoading = false;
  String? postId;
  String? imageUrl;
  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController imageTextEditingController =
      TextEditingController();
  ViewductsUser? viewductsUser;
  final ScrollController realtime = ScrollController();
  final ScrollController saved = ScrollController();
  int quantity = 1;
  String sizeValue = "";
  String colorValue = "";
  bool? editProduct;
  String? image, name;
  String? selectedColor;
  var itemDetails;
  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ValueNotifier<bool> imageNotready = ValueNotifier(false);
  bool isToolAvailable = true;
  bool isMyProfile = false;

  final GlobalKey<State> keyLoader = GlobalKey<State>();
  // List<dynamic> size;
  FeedState? productState;

  Widget _timeWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            const SizedBox(width: 5),
            customText(widget.ductProduct!.store, style: textStyle14),
            const SizedBox(width: 10),
          ],
        ),
        // Row(
        //   children: <Widget>[
        //     SizedBox(width: 5),
        //     customText(getPostTime2(widget.ductProduct!.createdAt),
        //         style: textStyle14),
        //     SizedBox(width: 10),
        //   ],
        // ),
        const Divider(),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              customText(
                ' ${widget.ductProduct!.productName}',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // customText(' Brand',
              //     style: TextStyle(
              //         fontWeight: FontWeight.bold,
              //         color: Theme.of(context).primaryColor,
              //         fontSize: 16)),
              widget.ductProduct?.stockQuantity == 0
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 3),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10)),
                      child: customTitleText('Out of Stock'),
                    )
                  : widget.ductProduct?.salePrice == 0 ||
                          widget.ductProduct?.salePrice == null
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 3),
                          decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(10)),
                          child: customText(
                              NumberFormat.currency(
                                      name:
                                          widget.ductProduct?.productLocation ==
                                                  'Nigeria'
                                              ? '₦'
                                              : '£')
                                  .format(double.parse(
                                      widget.ductProduct!.price.toString())),
                              //'N ${widget.ductProduct!.price}',
                              style: TextStyle(
                                color: Colors.yellow,
                                fontWeight: FontWeight.bold,
                                fontSize: context.responsiveValue(
                                    mobile: Get.height * 0.03,
                                    tablet: Get.height * 0.03,
                                    desktop: Get.height * 0.03),
                              )),
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 3),
                          decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(10)),
                          child: customText(
                              NumberFormat.currency(
                                      name:
                                          widget.ductProduct?.productLocation ==
                                                  'Nigeria'
                                              ? '₦'
                                              : '£')
                                  .format(double.parse(widget
                                      .ductProduct!.salePrice
                                      .toString())),
                              //'N ${widget.ductProduct!.price}',
                              style: TextStyle(
                                color: CupertinoColors.systemRed,
                                fontWeight: FontWeight.bold,
                                fontSize: context.responsiveValue(
                                    mobile: Get.height * 0.03,
                                    tablet: Get.height * 0.03,
                                    desktop: Get.height * 0.03),
                              )),
                        ),
            ],
          ),
        ),
        widget.ductProduct?.stockQuantity == 0
            ? Container()
            : widget.ductProduct?.salePrice == 0 ||
                    widget.ductProduct?.salePrice == null
                ? Container()
                : Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 3),
                      decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(10)),
                      child: customText(
                          NumberFormat.currency(
                                  name: widget.ductProduct?.productLocation ==
                                          'Nigeria'
                                      ? '₦'
                                      : '£')
                              .format(double.parse(
                                  widget.ductProduct!.price.toString())),

                          //'N ${widget.ductProduct!.price}',

                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: CupertinoColors.systemYellow,
                            fontWeight: FontWeight.bold,
                            fontSize: context.responsiveValue(
                                mobile: Get.height * 0.02,
                                tablet: Get.height * 0.02,
                                desktop: Get.height * 0.02),
                          )),
                    ),
                  ),
        Row(
          children: <Widget>[
            const Icon(Icons.place),
            Row(
              children: [
                customText(widget.ductProduct!.productState,
                    // ductProduct == null
                    //     ? ''
                    //     : formatter.format(ductProduct.price),
                    style: TextStyle(
                      color: Colors.blueGrey[800],
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    )),
                customText(', ${widget.ductProduct!.productLocation}',
                    // ductProduct == null
                    //     ? ''
                    //     : formatter.format(ductProduct.price),
                    style: TextStyle(
                      color: Colors.blueGrey[800],
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    )),
              ],
            ),
          ],
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  List<ItemModel> menuItems = [
    ItemModel('App', CupertinoIcons.app),
  ];
  String appPackageName = 'com.whatsapp';
  @override
  Widget build(BuildContext context) {
    // var authState = Provider.of<AuthState>(context);
    // var state = Provider.of<FeedState>(context);
    String? id = widget.profileId ?? authState.userId;
    List<FeedModel> list;

    if (feedState.feedlist != null && feedState.feedlist!.isNotEmpty) {
      list = feedState.feedlist!.where((x) => x.userId == id).toList();
    }
    final ThemeData theme = Theme.of(context);

    return widget.ductProduct!.activeState != 'Aproved' &&
            authState.userId.obs != widget.ductProduct?.userId.obs
        ? Container()
        : GestureDetector(
            onTap: () {},
            child: Stack(
              children: <Widget>[
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                height: 100,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          offset: const Offset(0, 11),
                                          blurRadius: 11,
                                          color: Colors.black.withOpacity(0.06))
                                    ],
                                    borderRadius: BorderRadius.circular(5),
                                    color: CupertinoColors.lightBackgroundGray),
                                padding: const EdgeInsets.all(10),
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
                                              BorderRadius.circular(5),
                                          color: CupertinoColors.systemYellow),
                                      padding: const EdgeInsets.all(5.0),
                                      child: TitleText(
                                        'This is the commission you get after buying the product and ducting it to your friends and family in ViewDucts',
                                        color:
                                            CupertinoColors.darkBackgroundGray,
                                      )),
                                ),
                              );
                            },
                          );
                        },
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              frostedWhite(Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: customTitleText(
                                  'Duct:',
                                ),
                              )),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  NumberFormat.currency(
                                          name: widget.ductProduct!
                                                      .productLocation ==
                                                  'Nigeria'
                                              ? '₦'
                                              : '£')
                                      .format(double.parse(
                                    widget.ductProduct!.commissionPrice
                                        .toString(),
                                  )),
                                  style: const TextStyle(
                                    color: Colors.cyan,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      frostedOrange(
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
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                frostedYellow(
                                  Container(
                                      width: context.responsiveValue(
                                          mobile: Get.height * 0.25,
                                          tablet: Get.height * 0.4,
                                          desktop: Get.height * 0.4),
                                      height: context.responsiveValue(
                                          mobile: Get.height * 0.25,
                                          tablet: Get.height * 0.2,
                                          desktop: Get.height * 0.2),
                                      child: Stack(
                                        children: [
                                          ProductDuctImage(
                                            model: widget.ductProduct,
                                            type: widget.type,
                                          ),
                                          widget.ductProduct?.salePrice == 0 ||
                                                  widget.ductProduct
                                                          ?.salePrice ==
                                                      null
                                              ? Container()
                                              : Positioned(
                                                  left: 0,
                                                  bottom: 0,
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
                                                          'On Sale',
                                                          color: CupertinoColors
                                                              .lightBackgroundGray,
                                                        )),
                                                  ),
                                                ),
                                        ],
                                      )),
                                ),
                                _timeWidget(context),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      //   _likeCommentsIcons(context, widget.ductProduct!)
                    ],
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: context.responsiveValue(
                      mobile: Get.height * 0.2,
                      tablet: Get.height * 0.2,
                      desktop: Get.height * 0.2),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        padding: const EdgeInsets.all(0),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.yellow),
                        child: GestureDetector(
                          onTap: () async {
                            showModalBottomSheet(
                                backgroundColor: Colors.red,
                                // isDismissible: false,
                                // bounce: true,
                                context: context,
                                builder: (context) => OpenContainer(
                                      closedBuilder: (context, action) {
                                        return ProductResponsiveView(
                                          model: widget.ductProduct,
                                        );
                                      },
                                      openBuilder: (context, action) {
                                        return ProductResponsiveView(
                                          model: widget.ductProduct,
                                        );
                                      },
                                    ));
                            // authState.deepApplinkProductKey.value =
                            //     widget.ductProduct!.key.toString();
                            // final Account account = Account(
                            //   clientConnect(),
                            // );
                            // account.get().then((value) {
                            //   if (value.status != true) {
                            // Get.to(() => EditPhonePageResponsiveView(),
                            //     // SignIn(
                            //     //     loginCallback:
                            //     //         authState.getCurrentUser),
                            //     transition: Transition.leftToRightWithFade);
                            // launchURL(
                            //     "https://viewducts.page.link/products?id=${widget.ductProduct!.key}");
                            // }
                            // });
                            // authState.deepApplinkProductKey ==
                            //     widget.ductProduct!.key.toString();
                            // kIsWeb
                            //     ? launchURL(
                            //         "https://viewducts.page.link/products?id=${widget.ductProduct!.key}")
                            //     :
                            // Get.toNamed(
                            //   '/signin',
                            //   // SignIn(
                            //   //     loginCallback:
                            //   //         authState.getCurrentUser),
                            // );
                            // ;
                            //  cprint("${authState.deepApplinkProductKey.value}");
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: customTitleText('Buy'),
                          ),
                        )),

                    // CustomPopupMenu(
                    //   child: Container(
                    //       padding: const EdgeInsets.all(0),
                    //       decoration: const BoxDecoration(
                    //           shape: BoxShape.circle, color: Colors.yellow),
                    //       child: Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: customTitleText('Buy'),
                    //       )),
                    //   menuBuilder: () => ClipRRect(
                    //     borderRadius: BorderRadius.circular(5),
                    //     child: Container(
                    //       color: const Color(0xFF4C4C4C),
                    //       child: IntrinsicWidth(
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.stretch,
                    //           children: menuItems
                    //               .map(
                    //                 (item) => GestureDetector(
                    //                   behavior: HitTestBehavior.translucent,
                    //                   onTap: () async {
                    //                     print("onTap");
                    //                     _controller.hideMenu();

                    //                     launchURL(
                    //                         "https://www.viewducts.com/?id=${widget.ductProduct!.key}");
                    //                   },
                    //                   child: Padding(
                    //                     padding: const EdgeInsets.all(4.0),
                    //                     child: Container(
                    //                       height: 40,
                    //                       decoration: BoxDecoration(
                    //                         boxShadow: [
                    //                           BoxShadow(
                    //                               offset: const Offset(0, 11),
                    //                               blurRadius: 11,
                    //                               color: Colors.black
                    //                                   .withOpacity(0.06))
                    //                         ],
                    //                         borderRadius: BorderRadius.circular(18),
                    //                       ),
                    //                       padding:
                    //                           EdgeInsets.symmetric(horizontal: 20),
                    //                       child: Row(
                    //                         children: <Widget>[
                    //                           Icon(
                    //                             item.icon,
                    //                             size: 15,
                    //                             color: Colors.white,
                    //                           ),
                    //                           Expanded(
                    //                             child: Container(
                    //                               margin: EdgeInsets.only(left: 10),
                    //                               padding: EdgeInsets.symmetric(
                    //                                   vertical: 10),
                    //                               child: Text(
                    //                                 item.title,
                    //                                 style: TextStyle(
                    //                                   color: Colors.white,
                    //                                   fontSize: 12,
                    //                                 ),
                    //                               ),
                    //                             ),
                    //                           ),
                    //                         ],
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               )
                    //               .toList(),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    //   pressType: PressType.singleClick,
                    //   verticalMargin: -10,
                    //   controller: _controller,
                    // ),

                    // GestureDetector(
                    //   onTap: () async {
                    //     // showBarModalBottomSheet(
                    //     //     backgroundColor: Colors.red,
                    //     //     bounce: true,
                    //     //     context: context,
                    //     //     builder: (context) => ProductResponsiveView(
                    //     //           model: widget.ductProduct,
                    //     //         ));
                    //   },
                    //   child: Container(
                    //       padding: const EdgeInsets.all(0),
                    //       decoration: const BoxDecoration(
                    //           shape: BoxShape.circle, color: Colors.yellow),
                    //       child: Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: customTitleText('Buy'),
                    //       )),
                    // ),
                  ),
                ),
              ],
            ));
  }
}

class _Customers extends StatelessWidget {
  const _Customers({Key? key, this.user, this.id}) : super(key: key);
  final ViewductsUser? user;
  final String? id;

  @override
  Widget build(BuildContext context) {
    // var authState = Provider.of<AuthState>(context, listen: false);
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(0),
            bottomLeft: Radius.circular(20)),
      ),
      child: frostedOrange(
        ListTile(
          onTap: () {
            kAnalytics.logViewSearchResults(searchTerm: user!.userName!);
            // Navigator.of(context)
            //     .pushNamed("/Stores/", arguments: _Customers(id: user.userId));
//Navigator.of(context).pushNamed('/ProfilePage/' + user?.userId);
          },
          leading: Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(100),
              child: customImage(context, user!.profilePic, height: 40)),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: TitleText(user!.displayName,
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
          subtitle: Text(user!.userName!),
        ),
      ),
    );
  }
}

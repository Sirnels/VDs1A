import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:tiktok_tutorial/constants.dart';
// import 'package:tiktok_tutorial/controllers/video_controller.dart';
// import 'package:tiktok_tutorial/views/screens/comment_screen.dart';
// import 'package:tiktok_tutorial/views/widgets/circle_animation.dart';
// import 'package:tiktok_tutorial/views/widgets/video_player_iten.dart';
// import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:viewducts/apis/auth_api.dart';
import 'package:viewducts/app_theme/app_theme_constant.dart';
import 'package:viewducts/common/cirecle_animation.dart';
import 'package:viewducts/common/common.dart';
import 'package:viewducts/common/v_player.dart';
import 'package:viewducts/constants/constants.dart';
import 'package:viewducts/features/auth/controller/auth_controller.dart';
import 'package:viewducts/features/ducts/duct_controller.dart';
import 'package:viewducts/features/products/product_controller.dart';
import 'package:viewducts/helper/constant.dart';
import 'package:viewducts/helper/enum.dart';
import 'package:viewducts/helper/theme.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/page/common/general_dialog.dart';
import 'package:viewducts/page/responsiveView.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/duct/widgets/ductImage.dart';
import 'package:viewducts/widgets/duct/widgets/story_bar.dart';
import 'package:viewducts/widgets/frosted.dart';
import 'package:viewducts/widgets/newWidget/title_text.dart';
import 'package:timeago/timeago.dart' as timeago;

class DuctStreamScreen extends ConsumerWidget {
  final List<FeedModel> ductList;
  final List<DuctStoryModel> storyList;
  DuctStreamScreen({Key? key, required this.ductList, required this.storyList})
      : super(key: key);

//   @override
//   ConsumerState<DuctStreamScreen> createState() => _DuctStreamScreenState();
// }

// class _DuctStreamScreenState extends ConsumerState<DuctStreamScreen> {
  buildProfile(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(children: [
        Positioned(
          left: 5,
          child: Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image(
                image: NetworkImage(profilePhoto),
                fit: BoxFit.cover,
              ),
            ),
          ),
        )
      ]),
    );
  }

  buildMusicAlbum(String profilePhoto) {
    return SizedBox(
      width: 60,
      height: 60,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.all(11),
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Colors.grey,
                        Colors.white,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Image(
                    image: NetworkImage(profilePhoto),
                    fit: BoxFit.cover,
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget _pageView({required int index, required FeedModel data}) {
    switch (index) {
      case 0:
        return Container(
          decoration: BoxDecoration(
            color: Pallete.scafoldBacgroundColor,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(0),
              bottom: Radius.circular(0),
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 35,
            vertical: 16,
          ),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CupertinoColors.darkBackgroundGray,
              ),
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Linkify(
                      onOpen: (link) async {
                        if (await canLaunchUrl(Uri.parse(link.url))) {
                          await launchURL(link.url);
                        } else {
                          throw 'Could not launch $link';
                        }
                      },
                      text: data.ductComment.toString(),
                      style: TextStyle(
                        color: CupertinoColors.lightBackgroundGray,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                      linkStyle: TextStyle(color: Colors.blueGrey))),
            ),
          ),
          //color: backgroundColor,
        );

      case 1:
        return Container(
          color: CupertinoColors.black,
          alignment: Alignment.center,
          child: SizedBox(
              height: Get.height,
              width: Get.width,
              child: customNetworkImage(data.imagePath, fit: BoxFit.cover)),
        );

      case 2:
        return VideoPlayerItem(
          videoUrl: data.videoPath.toString(),
        );

      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    return PageView.builder(
      itemCount: ductList.length,
      controller: PageController(initialPage: 0, viewportFraction: 1),
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        final data = ductList[index];
        FeedModel? product =
            ref.watch(getOneProductProvider('${data.cProduct}')).value;
        ViewductsUser? user =
            ref.watch(userDetailsProvider('${data.userId}')).value;

        // List<DuctStoryModel>? storyList =
        //     ref.watch(currentDuctStoryListProvider('${data.userId}')).value;
        ViewductsUser vendor =
            ref.watch(userDetailsProvider('${data.productVendorId}')).value ??
                ViewductsUser();

        return ref.watch(currentDuctStoryListProvider('${data.userId}')).when(
              data: (storyList) {
                return GestureDetector(
                  onTap: () {
                    if (storyList.isEmpty) {
                    } else {
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
                                                BorderRadius.circular(18),
                                            color:
                                                Pallete.scafoldBacgroundColor),
                                        child: MainStoryResponsiveView(
                                            vendorId: data.productVendorId!,
                                            model: data,
                                            product: product,
                                            storylist: storyList,
                                            currentUser: currentUser,
                                            secondUser: user),
                                      ),
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
                                              offset: const Offset(0, 11),
                                              blurRadius: 11,
                                              color: Colors.black
                                                  .withOpacity(0.06))
                                        ],
                                        borderRadius: BorderRadius.circular(20),
                                        color: Pallete.scafoldBacgroundColor),
                                    padding: const EdgeInsets.all(5.0),
                                    child: TitleText('PinDucts',
                                        // color: Colors.white,
                                        // fontSize: 16,
                                        // fontWeight: FontWeight.w800,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                                Positioned(
                                  bottom: -10,
                                  right: 100,
                                  child: GestureDetector(
                                    onTap: () {
                                      //Navigator.pop(context);
                                    },
                                    child: Container(
                                      // width: 60,
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                offset: const Offset(0, 11),
                                                blurRadius: 11,
                                                color: Colors.black
                                                    .withOpacity(0.06))
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: CupertinoColors
                                              .darkBackgroundGray),
                                      padding: const EdgeInsets.all(5.0),
                                      child: Icon(Icons.close,
                                          color: Pallete.scafoldBacgroundColor),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            dx: 0,
                            dy: -1,
                            horizontal: 5,
                            vertical: 0.06);
                      });
                    }
                  },
                  // onVerticalDragUpdate: (details) {
                  //   int sensitivity = 8;
                  //   if (details.delta.dy > sensitivity) {
                  //     // Down Swipe
                  //     ref.read(hideSideBar.notifier).state = true;

                  //   } else if (details.delta.dy < -sensitivity) {
                  //     // Up Swipe
                  //     ref.read(hideSideBar.notifier).state = true;
                  //   }
                  // },
                  onHorizontalDragUpdate: (details) {
                    // Note: Sensitivity is integer used when you don't want to mess up vertical drag
                    int sensitivity = 8;
                    if (details.delta.dx > sensitivity) {
                      // Right Swipe
                      if (ref.read(numberProvider.notifier).state == 1) {
                        ref.read(hideSideBar.notifier).state = false;
                        ref.read(numberProvider.notifier).state = 0;
                      }
                    } else if (details.delta.dx < -sensitivity) {
                      if (ref.read(numberProvider.notifier).state == 1) {
                        ref.read(hideSideBar.notifier).state = false;
                        ref.read(numberProvider.notifier).state = 2;
                      }

                      //Left Swipe
                    }
                  },
                  child: Container(
                    width: size.width,
                    height: size.height,
                    child: Stack(
                      children: [
                        _pageView(index: data.ductType ?? 0, data: data),
                        Column(
                          children: [
                            const SizedBox(
                              height: 100,
                            ),
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  user?.profilePic == null
                                      ? Container()
                                      : CircleAnimation(
                                          child: buildMusicAlbum(
                                              '${user?.profilePic}'),
                                        ),
                                  Expanded(
                                      child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            TitleText(user?.displayName ?? '',
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w800,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                            // user.isVerified == true
                                            //     ? customIcon(
                                            //         context,
                                            //         icon: AppIcon.blueTick,
                                            //         istwitterIcon: true,
                                            //         iconColor: AppColor.primary,
                                            //         size: 9,
                                            //         paddingIcon: 3,
                                            //       )
                                            //     : const SizedBox(width: 0),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Container(
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
                                                      .inactiveGray),
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Text('Viewers: ',
                                                  // color: Colors.white,
                                                  // fontSize: 16,
                                                  // fontWeight: FontWeight.w800,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: TitleText(
                                                  user?.viewers?.length
                                                          .toString() ??
                                                      '0',
                                                  color: CupertinoColors
                                                      .systemYellow,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w800,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: frostedBlack(
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: customText(
                                                    data.createdAt == null
                                                        ? ''
                                                        : timeago
                                                            .format(Timestamp.fromDate(
                                                                    DateTime.parse(
                                                                        '${data.createdAt}'))
                                                                .toDate())
                                                            .toString(),
                                                    //   '${getWhen(model!.createdAt)}',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: CupertinoColors
                                                            .lightBackgroundGray
                                                        // color: Theme.of(context)
                                                        //     .colorScheme
                                                        //     .onPrimary,
                                                        ),
                                                    //style: userNameStyle
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ))
                                ],
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: LikeButton(
                                    size: 80,
                                    onTap: (isLiked) async {
                                      ref
                                          .read(ductControllerProvider.notifier)
                                          .likeDuct(
                                              storyList.firstWhere(
                                                  (st) =>
                                                      st.key == data.storyId,
                                                  orElse: () =>
                                                      DuctStoryModel()),
                                              currentUser!,
                                              model: data);
                                      return !isLiked;
                                    },
                                    isLiked: data.likeList
                                        ?.contains(currentUser!.key),
                                    likeBuilder: (isLiked) {
                                      return isLiked
                                          ? Icon(
                                              size: 80,
                                              CupertinoIcons.heart_circle_fill,
                                              color: CupertinoColors.systemRed,
                                            )
                                          //  SvgPicture.asset(
                                          //     AssetsConstants
                                          //         .likeFilledIcon,
                                          //     color: Pallete.redColor,
                                          //   )
                                          : Icon(
                                              size: 80,
                                              CupertinoIcons.heart_circle_fill,
                                              color: CupertinoColors
                                                  .lightBackgroundGray,
                                            );
                                    },
                                    likeCount: data.likeList?.length,
                                    countBuilder: (likeCount, isLiked, text) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(left: 2.0),
                                        child: Text(
                                          text,
                                          style: TextStyle(
                                            color: isLiked
                                                ? CupertinoColors.systemRed
                                                : CupertinoColors
                                                    .lightBackgroundGray,
                                            fontSize: 16,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                // feedState.productlist!
                                //                 .firstWhere((e) => e.userId == commissionUser,
                                //                     orElse: feedState.storyId)
                                //                 .userId ==
                                //             currentUser?.userId ||
                                //         widget.model!.userId == currentUser?.userId
                                //     ? Container()
                                //     :
                              ],
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {},
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
                                        color: CupertinoColors
                                            .lightBackgroundGray),
                                    padding: const EdgeInsets.all(5.0),
                                    child: TitleText('Start Viewing',
                                        // color: Colors.white,
                                        // fontSize: 16,
                                        // fontWeight: FontWeight.w800,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                              ],
                            ),
                            product?.userId == null || vendor.userId == null
                                ? Container()
                                : Row(
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 100,
                                        child: ProductDuctImage(
                                            model: product,
                                            type: DuctType.Duct,
                                            currentUser: currentUser,
                                            vendor: vendor),
                                      ),
                                      Container(
                                        width: Get.height * 0.4,
                                        child: ListTile(
                                          title: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    product?.salePrice == 0 ||
                                                            product?.salePrice ==
                                                                null
                                                        ? Container()
                                                        : Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              product?.salePrice ==
                                                                          0 ||
                                                                      product?.salePrice ==
                                                                          null
                                                                  ? Container()
                                                                  : Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Container(
                                                                          padding: const EdgeInsets.symmetric(
                                                                              horizontal: 8.0,
                                                                              vertical: 3),
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.black54,
                                                                              borderRadius: BorderRadius.circular(10)),
                                                                          child: customText(
                                                                              NumberFormat.currency(name: product?.productLocation == 'Nigeria' ? '₦' : '£').format(double.parse(product?.salePrice.toString() ?? '0')),
                                                                              //'N ${widget.ductProduct!.price}',
                                                                              style: TextStyle(
                                                                                color: CupertinoColors.systemRed,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: context.responsiveValue(mobile: Get.height * 0.03, tablet: Get.height * 0.03, desktop: Get.height * 0.03),
                                                                              )),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(vertical: 2.0),
                                                                          child:
                                                                              Container(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
                                                                            decoration:
                                                                                BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(10)),
                                                                            child: customText(NumberFormat.currency(name: product?.productLocation == 'Nigeria' ? '₦' : '£').format(double.parse(product?.price.toString() ?? '0')),

                                                                                //'N ${widget.ductProduct!.price}',

                                                                                style: TextStyle(
                                                                                  decoration: TextDecoration.lineThrough,
                                                                                  color: CupertinoColors.systemYellow,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontSize: context.responsiveValue(mobile: Get.height * 0.02, tablet: Get.height * 0.02, desktop: Get.height * 0.02),
                                                                                )),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                            ],
                                                          ),
                                                    product?.price == null
                                                        ? SizedBox()
                                                        : Container(
                                                            height: context.responsiveValue(
                                                                mobile:
                                                                    Get.width *
                                                                        0.1,
                                                                tablet:
                                                                    Get.height *
                                                                        0.06,
                                                                desktop:
                                                                    Get.height *
                                                                        0.06),
                                                            //width: 70,
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(0),

                                                            // decoration: BoxDecoration(
                                                            //     shape: BoxShape.circle, color: Colors.white),
                                                            child: Material(
                                                              elevation: 10,
                                                              //borderRadius: BorderRadius.circular(100),
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .blueGrey[50],
                                                                  gradient:
                                                                      LinearGradient(
                                                                    colors: [
                                                                      Colors
                                                                          .yellow
                                                                          .withOpacity(
                                                                              0.1),
                                                                      Colors
                                                                          .white54
                                                                          .withOpacity(
                                                                              0.2),
                                                                      Colors
                                                                          .orange
                                                                          .shade200
                                                                          .withOpacity(
                                                                              0.3)
                                                                      // Color(0xfffbfbfb),
                                                                      // Color(0xfff7f7f7),
                                                                    ],
                                                                    // begin: Alignment.topCenter,
                                                                    // end: Alignment.bottomCenter,
                                                                  ),
                                                                ),
                                                                child: Stack(
                                                                  children: [
                                                                    product?.salePrice ==
                                                                                0 ||
                                                                            product?.salePrice ==
                                                                                null
                                                                        ? Align(
                                                                            alignment:
                                                                                Alignment.center,
                                                                            child: Padding(
                                                                                padding: const EdgeInsets.all(10.0),
                                                                                child: customText(
                                                                                  NumberFormat.currency(name: product?.productLocation == 'Nigeria' ? '₦' : '£').format(double.parse("${product?.price}")),
                                                                                  // formatter.format(
                                                                                  //     int.parse(model!.price.toString())),
                                                                                  style: TextStyle(
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontSize: context.responsiveValue(mobile: Get.width * 0.05, tablet: Get.width * 0.02, desktop: Get.width * 0.02),
                                                                                  ),
                                                                                )),
                                                                          )
                                                                        : Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(5.0),
                                                                            child: Container(
                                                                                decoration: BoxDecoration(boxShadow: [
                                                                                  BoxShadow(offset: const Offset(0, 11), blurRadius: 11, color: Colors.black.withOpacity(0.06))
                                                                                ], borderRadius: BorderRadius.circular(18), color: CupertinoColors.systemRed),
                                                                                padding: const EdgeInsets.all(5.0),
                                                                                child: TitleText(
                                                                                  'On Sale',
                                                                                  color: CupertinoColors.lightBackgroundGray,
                                                                                )),
                                                                          ),
                                                                  ],
                                                                ),
                                                              ),
                                                            )),
                                                  ],
                                                ),
                                                frostedOrange(Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Colors.blueGrey[50],
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Colors.white54
                                                            .withOpacity(0.1),
                                                        Colors.white54
                                                            .withOpacity(0.2),
                                                        Colors.white54
                                                            .withOpacity(0.3)
                                                        // Color(0xfffbfbfb),
                                                        // Color(0xfff7f7f7),
                                                      ],
                                                      // begin: Alignment.topCenter,
                                                      // end: Alignment.bottomCenter,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            2.0),
                                                    child: customText(
                                                        product?.productName,
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                        )),
                                                  ),
                                                )),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child:
                                                      frostedOrange(Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      color:
                                                          Colors.blueGrey[50],
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Colors.red
                                                              .withOpacity(0.1),
                                                          Colors.green
                                                              .withOpacity(0.2),
                                                          Colors.blue
                                                              .withOpacity(0.3)
                                                          // Color(0xfffbfbfb),
                                                          // Color(0xfff7f7f7),
                                                        ],
                                                        // begin: Alignment.topCenter,
                                                        // end: Alignment.bottomCenter,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2.0),
                                                      child: customText(
                                                          product?.section,
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.black,
                                                          )),
                                                    ),
                                                  )),
                                                ),
                                                product?.userId ==
                                                            user?.userId ||
                                                        data.userId ==
                                                            user?.userId
                                                    ? Container()
                                                    : GestureDetector(
                                                        onTap: () {
                                                          // showModalBottomSheet(
                                                          //     backgroundColor: Colors
                                                          //         .red,
                                                          //     // bounce:
                                                          //     //     true,
                                                          //     context:
                                                          //         context,
                                                          //     builder: (context) =>
                                                          //         ProductStoryView(
                                                          //           model:  product?,
                                                          //           commissionUser: model!.userId,
                                                          //           isVduct: true,
                                                          //         ));
                                                        },
                                                        child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(0),
                                                            decoration:
                                                                const BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: Colors
                                                                        .yellow),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child:
                                                                  customTitleText(
                                                                      'Buy'),
                                                            )),
                                                      ),
                                              ],
                                            ),
                                          ),
                                          // Expanded(child: Container()),
                                        ),
                                      )
                                    ],
                                  ),
                            storyList.isEmpty
                                ? SizedBox(
                                    height: 20,
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: frostedYellow(
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
                                                .darkBackgroundGray),
                                        padding: const EdgeInsets.all(5.0),
                                        width: 250,
                                        child: DuctPostBar(
                                          list: storyList,
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
              loading: () => GestureDetector(
                onTap: () {
                  if (storyList.isEmpty) {
                  } else {
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
                                              BorderRadius.circular(18),
                                          color: Pallete.scafoldBacgroundColor),
                                      child: MainStoryResponsiveView(
                                          vendorId: data.productVendorId!,
                                          model: data,
                                          product: product,
                                          storylist: storyList,
                                          currentUser: currentUser,
                                          secondUser: user),
                                    ),
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
                                            offset: const Offset(0, 11),
                                            blurRadius: 11,
                                            color:
                                                Colors.black.withOpacity(0.06))
                                      ],
                                      borderRadius: BorderRadius.circular(20),
                                      color: Pallete.scafoldBacgroundColor),
                                  padding: const EdgeInsets.all(5.0),
                                  child: TitleText('PinDucts',
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
                          vertical: 0.1);
                    });
                  }
                },
                // onVerticalDragUpdate: (details) {
                //   int sensitivity = 8;
                //   if (details.delta.dy > sensitivity) {
                //     // Down Swipe
                //     ref.read(hideSideBar.notifier).state = true;

                //   } else if (details.delta.dy < -sensitivity) {
                //     // Up Swipe
                //     ref.read(hideSideBar.notifier).state = true;
                //   }
                // },
                onHorizontalDragUpdate: (details) {
                  // Note: Sensitivity is integer used when you don't want to mess up vertical drag
                  int sensitivity = 8;
                  if (details.delta.dx > sensitivity) {
                    // Right Swipe
                    if (ref.read(numberProvider.notifier).state == 1) {
                      ref.read(hideSideBar.notifier).state = false;
                      ref.read(numberProvider.notifier).state = 0;
                    }
                  } else if (details.delta.dx < -sensitivity) {
                    if (ref.read(numberProvider.notifier).state == 1) {
                      ref.read(hideSideBar.notifier).state = false;
                      ref.read(numberProvider.notifier).state = 2;
                    }

                    //Left Swipe
                  }
                },
                child: Container(
                  width: size.width,
                  height: size.height,
                  child: Stack(
                    children: [
                      _pageView(index: data.ductType ?? 0, data: data),
                      Column(
                        children: [
                          const SizedBox(
                            height: 100,
                          ),
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                user?.profilePic == null
                                    ? Container()
                                    : CircleAnimation(
                                        child: buildMusicAlbum(
                                            '${user?.profilePic}'),
                                      ),
                                Expanded(
                                    child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        TitleText(user?.displayName ?? '',
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                            overflow: TextOverflow.ellipsis),
                                        // user.isVerified == true
                                        //     ? customIcon(
                                        //         context,
                                        //         icon: AppIcon.blueTick,
                                        //         istwitterIcon: true,
                                        //         iconColor: AppColor.primary,
                                        //         size: 9,
                                        //         paddingIcon: 3,
                                        //       )
                                        //     : const SizedBox(width: 0),
                                      ],
                                    ),
                                    Row(
                                      children: [
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
                                              color:
                                                  CupertinoColors.inactiveGray),
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text('Viewers: ',
                                              // color: Colors.white,
                                              // fontSize: 16,
                                              // fontWeight: FontWeight.w800,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: TitleText(
                                              user?.viewers?.length
                                                      .toString() ??
                                                  '0',
                                              color:
                                                  CupertinoColors.systemYellow,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: frostedBlack(
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: customText(
                                                data.createdAt == null
                                                    ? ''
                                                    : timeago
                                                        .format(Timestamp.fromDate(
                                                                DateTime.parse(
                                                                    '${data.createdAt}'))
                                                            .toDate())
                                                        .toString(),
                                                //   '${getWhen(model!.createdAt)}',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: CupertinoColors
                                                        .lightBackgroundGray
                                                    // color: Theme.of(context)
                                                    //     .colorScheme
                                                    //     .onPrimary,
                                                    ),
                                                //style: userNameStyle
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ))
                              ],
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: LikeButton(
                                  size: 80,
                                  onTap: (isLiked) async {
                                    ref
                                        .read(ductControllerProvider.notifier)
                                        .likeDuct(
                                            storyList.firstWhere(
                                                (st) => st.key == data.storyId,
                                                orElse: () => DuctStoryModel()),
                                            currentUser!,
                                            model: data);
                                    return !isLiked;
                                  },
                                  isLiked:
                                      data.likeList?.contains(currentUser!.key),
                                  likeBuilder: (isLiked) {
                                    return isLiked
                                        ? Icon(
                                            size: 80,
                                            CupertinoIcons.heart_circle_fill,
                                            color: CupertinoColors.systemRed,
                                          )
                                        //  SvgPicture.asset(
                                        //     AssetsConstants
                                        //         .likeFilledIcon,
                                        //     color: Pallete.redColor,
                                        //   )
                                        : Icon(
                                            size: 80,
                                            CupertinoIcons.heart_circle_fill,
                                            color: CupertinoColors
                                                .lightBackgroundGray,
                                          );
                                  },
                                  likeCount: data.likeList?.length,
                                  countBuilder: (likeCount, isLiked, text) {
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 2.0),
                                      child: Text(
                                        text,
                                        style: TextStyle(
                                          color: isLiked
                                              ? CupertinoColors.systemRed
                                              : CupertinoColors
                                                  .lightBackgroundGray,
                                          fontSize: 16,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              // feedState.productlist!
                              //                 .firstWhere((e) => e.userId == commissionUser,
                              //                     orElse: feedState.storyId)
                              //                 .userId ==
                              //             currentUser?.userId ||
                              //         widget.model!.userId == currentUser?.userId
                              //     ? Container()
                              //     :
                            ],
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {},
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
                                      color:
                                          CupertinoColors.lightBackgroundGray),
                                  padding: const EdgeInsets.all(5.0),
                                  child: TitleText('Start Viewing',
                                      // color: Colors.white,
                                      // fontSize: 16,
                                      // fontWeight: FontWeight.w800,
                                      overflow: TextOverflow.ellipsis),
                                ),
                              ),
                            ],
                          ),
                          product?.userId == null || vendor.userId == null
                              ? Container()
                              : Row(
                                  children: [
                                    Container(
                                      height: 100,
                                      width: 100,
                                      child: ProductDuctImage(
                                          model: product,
                                          type: DuctType.Duct,
                                          currentUser: currentUser,
                                          vendor: vendor),
                                    ),
                                    Container(
                                      width: Get.height * 0.4,
                                      child: ListTile(
                                        title: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  product?.salePrice == 0 ||
                                                          product?.salePrice ==
                                                              null
                                                      ? Container()
                                                      : Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            product?.salePrice ==
                                                                        0 ||
                                                                    product?.salePrice ==
                                                                        null
                                                                ? Container()
                                                                : Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Container(
                                                                        padding: const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                8.0,
                                                                            vertical:
                                                                                3),
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.black54,
                                                                            borderRadius: BorderRadius.circular(10)),
                                                                        child: customText(
                                                                            NumberFormat.currency(name: product?.productLocation == 'Nigeria' ? '₦' : '£').format(double.parse(product?.salePrice.toString() ??
                                                                                '0')),
                                                                            //'N ${widget.ductProduct!.price}',
                                                                            style:
                                                                                TextStyle(
                                                                              color: CupertinoColors.systemRed,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: context.responsiveValue(mobile: Get.height * 0.03, tablet: Get.height * 0.03, desktop: Get.height * 0.03),
                                                                            )),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(vertical: 2.0),
                                                                        child:
                                                                            Container(
                                                                          padding: const EdgeInsets.symmetric(
                                                                              horizontal: 8.0,
                                                                              vertical: 3),
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.black54,
                                                                              borderRadius: BorderRadius.circular(10)),
                                                                          child: customText(
                                                                              NumberFormat.currency(name: product?.productLocation == 'Nigeria' ? '₦' : '£').format(double.parse(product?.price.toString() ?? '0')),

                                                                              //'N ${widget.ductProduct!.price}',

                                                                              style: TextStyle(
                                                                                decoration: TextDecoration.lineThrough,
                                                                                color: CupertinoColors.systemYellow,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: context.responsiveValue(mobile: Get.height * 0.02, tablet: Get.height * 0.02, desktop: Get.height * 0.02),
                                                                              )),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                          ],
                                                        ),
                                                  product?.price == null
                                                      ? SizedBox()
                                                      : Container(
                                                          height: context
                                                              .responsiveValue(
                                                                  mobile:
                                                                      Get.width *
                                                                          0.1,
                                                                  tablet:
                                                                      Get.height *
                                                                          0.06,
                                                                  desktop:
                                                                      Get.height *
                                                                          0.06),
                                                          //width: 70,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(0),

                                                          // decoration: BoxDecoration(
                                                          //     shape: BoxShape.circle, color: Colors.white),
                                                          child: Material(
                                                            elevation: 10,
                                                            //borderRadius: BorderRadius.circular(100),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .blueGrey[50],
                                                                gradient:
                                                                    LinearGradient(
                                                                  colors: [
                                                                    Colors
                                                                        .yellow
                                                                        .withOpacity(
                                                                            0.1),
                                                                    Colors
                                                                        .white54
                                                                        .withOpacity(
                                                                            0.2),
                                                                    Colors
                                                                        .orange
                                                                        .shade200
                                                                        .withOpacity(
                                                                            0.3)
                                                                    // Color(0xfffbfbfb),
                                                                    // Color(0xfff7f7f7),
                                                                  ],
                                                                  // begin: Alignment.topCenter,
                                                                  // end: Alignment.bottomCenter,
                                                                ),
                                                              ),
                                                              child: Stack(
                                                                children: [
                                                                  product?.salePrice ==
                                                                              0 ||
                                                                          product?.salePrice ==
                                                                              null
                                                                      ? Align(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child: Padding(
                                                                              padding: const EdgeInsets.all(10.0),
                                                                              child: customText(
                                                                                NumberFormat.currency(name: product?.productLocation == 'Nigeria' ? '₦' : '£').format(double.parse("${product?.price}")),
                                                                                // formatter.format(
                                                                                //     int.parse(model!.price.toString())),
                                                                                style: TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontSize: context.responsiveValue(mobile: Get.width * 0.05, tablet: Get.width * 0.02, desktop: Get.width * 0.02),
                                                                                ),
                                                                              )),
                                                                        )
                                                                      : Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(5.0),
                                                                          child: Container(
                                                                              decoration: BoxDecoration(boxShadow: [
                                                                                BoxShadow(offset: const Offset(0, 11), blurRadius: 11, color: Colors.black.withOpacity(0.06))
                                                                              ], borderRadius: BorderRadius.circular(18), color: CupertinoColors.systemRed),
                                                                              padding: const EdgeInsets.all(5.0),
                                                                              child: TitleText(
                                                                                'On Sale',
                                                                                color: CupertinoColors.lightBackgroundGray,
                                                                              )),
                                                                        ),
                                                                ],
                                                              ),
                                                            ),
                                                          )),
                                                ],
                                              ),
                                              frostedOrange(Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  color: Colors.blueGrey[50],
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Colors.white54
                                                          .withOpacity(0.1),
                                                      Colors.white54
                                                          .withOpacity(0.2),
                                                      Colors.white54
                                                          .withOpacity(0.3)
                                                      // Color(0xfffbfbfb),
                                                      // Color(0xfff7f7f7),
                                                    ],
                                                    // begin: Alignment.topCenter,
                                                    // end: Alignment.bottomCenter,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: customText(
                                                      product?.productName,
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                      )),
                                                ),
                                              )),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: frostedOrange(Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Colors.blueGrey[50],
                                                    gradient: LinearGradient(
                                                      colors: [
                                                        Colors.red
                                                            .withOpacity(0.1),
                                                        Colors.green
                                                            .withOpacity(0.2),
                                                        Colors.blue
                                                            .withOpacity(0.3)
                                                        // Color(0xfffbfbfb),
                                                        // Color(0xfff7f7f7),
                                                      ],
                                                      // begin: Alignment.topCenter,
                                                      // end: Alignment.bottomCenter,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            2.0),
                                                    child: customText(
                                                        product?.section,
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                        )),
                                                  ),
                                                )),
                                              ),
                                              product?.userId == user?.userId ||
                                                      data.userId ==
                                                          user?.userId
                                                  ? Container()
                                                  : GestureDetector(
                                                      onTap: () {
                                                        // showModalBottomSheet(
                                                        //     backgroundColor: Colors
                                                        //         .red,
                                                        //     // bounce:
                                                        //     //     true,
                                                        //     context:
                                                        //         context,
                                                        //     builder: (context) =>
                                                        //         ProductStoryView(
                                                        //           model:  product?,
                                                        //           commissionUser: model!.userId,
                                                        //           isVduct: true,
                                                        //         ));
                                                      },
                                                      child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(0),
                                                          decoration:
                                                              const BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: Colors
                                                                      .yellow),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child:
                                                                customTitleText(
                                                                    'Buy'),
                                                          )),
                                                    ),
                                            ],
                                          ),
                                        ),
                                        // Expanded(child: Container()),
                                      ),
                                    )
                                  ],
                                ),
                          storyList.isEmpty
                              ? SizedBox(
                                  height: 20,
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: frostedYellow(
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
                                              .darkBackgroundGray),
                                      padding: const EdgeInsets.all(5.0),
                                      width: 250,
                                      child: DuctPostBar(
                                        list: storyList,
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
      },
    );
  }
}

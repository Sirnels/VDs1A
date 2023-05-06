// ignore_for_file: deprecated_member_use, unused_local_variable, unused_element, file_names, must_be_immutable, unnecessary_null_comparison

import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
//import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:viewducts/features/auth/controller/auth_controller.dart';
import 'package:viewducts/helper/constant.dart';
import 'package:viewducts/helper/enum.dart';
import 'package:viewducts/helper/theme.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/page/message/chatScreenPage.dart';
import 'package:viewducts/page/message/local_database.dart';

import 'package:viewducts/page/product/store.dart';
import 'package:viewducts/page/profile/EditProfilePage.dart';
import 'package:viewducts/page/profile/profileImageView.dart';
import 'package:viewducts/page/responsiveView.dart';
//import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/cartIcon.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/frosted.dart';
import 'package:viewducts/widgets/newWidget/customLoader.dart';
import 'package:viewducts/widgets/newWidget/customUrlText.dart';
import 'package:viewducts/widgets/newWidget/rippleButton.dart';
import 'package:viewducts/widgets/postProductMenu.dart';

class ProfilePage extends ConsumerStatefulWidget {
  ProfilePage({Key? key, this.profileId, this.profileType}) : super(key: key);
  final ProfileType? profileType;
  final String? profileId;

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
//   @override
  ValueNotifier<bool> isDuctFeeds = ValueNotifier(false);

  bool isMyProfile = false;

  int pageIndex = 0;

  FeedModel? model;

  ViewductsUser? viewductsUser;

  CustomLoader? loader;

  // List<dynamic> itemList = [];
  bool isDropdown = false;

  double? height, width, xPosiion, yPosition;

  late OverlayEntry floatingMenu;

  @override
  build(BuildContext context) {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    final secondUser =
        ref.watch(userDetailsProvider(widget.profileId!.toString())).value;
    // final chatSetState = useState(authState.profileData);
    // final realtime = Realtime(clientConnect());
    // final animationController = useAnimationController(
    //   duration: Duration(seconds: 2),
    // );
    Future<bool?> _showDialogs() {
      return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return frostedYellow(
            Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Colors.transparent,
              child: frostedYellow(
                Container(
                  height: Get.height * 0.2,
                  width: 100,
                  child: Column(
                    children: [
                      Wrap(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          offset: const Offset(0, 11),
                                          blurRadius: 11,
                                          color: Colors.black.withOpacity(0.06))
                                    ],
                                    borderRadius: BorderRadius.circular(5),
                                    color: CupertinoColors.systemYellow),
                                padding: const EdgeInsets.all(5.0),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: const Text(
                                    'Download App to Chat',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w200,
                                        color: CupertinoColors
                                            .lightBackgroundGray),
                                  ),
                                )),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.maybePop(context);
                              },
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
                                      color: CupertinoColors.inactiveGray),
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    children: [
                                      Icon(CupertinoIcons.back),
                                      const Text(
                                        'Cancel',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w200),
                                      )
                                    ],
                                  )),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              try {
                                Navigator.maybePop(context);
                              } on AppwriteException catch (e) {
                                cprint('$e deleting Account');
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
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
                                      color: CupertinoColors.systemGreen),
                                  padding: const EdgeInsets.all(5.0),
                                  child: const Text(
                                    'Download',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w200),
                                  )),
                            ),
                          ),
                        ],
                      )
                      // Container(
                      //   height: Get.height * 0.3,
                      //   width: Get.height * 0.2,
                      //   decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(20)),
                      //   child: SafeArea(
                      //     child: Stack(
                      //       children: <Widget>[
                      //         Center(
                      //           child: ModalTile(
                      //             title: "File Exceeds Limit",
                      //             subtitle: "Please reduce your file size",
                      //             icon: Icons.tab,
                      //             onTap: () async {
                      //               Navigator.maybePop(context);
                      //             },
                      //           ),
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    // allChatMessage() async {
    //   final database = Databases(
    //     clientConnect(),
    //   );
    //   try {
    //     await database.listDocuments(
    //         databaseId: databaseId,
    //         collectionId: profileUserColl,
    //         queries: [Query.equal('key', profileId)]).then((data) {
    //       var value = data.documents
    //           .map((e) => ViewductsUser.fromJson(e.data))
    //           .toList();

    //       chatSetState.value.value = value;
    //       authState.userModel ==
    //           chatSetState.value.firstWhere((data) => data.key == profileId,
    //               orElse: () => chatState.chatUser!);
    //     });
    //   } on AppwriteException catch (e) {
    //     cprint('$e allChatMessage');
    //   }
    // }

    // final profileStream = useStream(realtime.subscribe([
    //   "databases.$databaseId.collections.$profileUserColl.documents"
    // ]).stream);
    // subs() {
    //   profileStream.data;
    //   if (chatSetState.value != null) {
    //     switch (profileStream.data?.events) {
    //       case ["collections.*.documents"]:
    //         // setState(() {});
    //         chatSetState.value
    //             .add(ViewductsUser.fromJson(profileStream.data?.payload));

    //         break;
    //       case ["collections.*.documents.*.delete"]:
    //         //  setState(() {});
    //         chatSetState.value.removeWhere(
    //             (datas) => datas.key == profileStream.data!.payload['key']);

    //         break;

    //       default:
    //         break;
    //     }
    //   } else {
    //     cprint('it is empty');
    //   }
    // }

    // final subStreaming = useMemoized(() => subs());

    Widget _floatingActionButton() {
      return FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/CreateFeedPage');
        },
        child: customIcon(
          context,
          icon: AppIcon.fabTweet,
          istwitterIcon: true,
          iconColor: Theme.of(context).colorScheme.onPrimary,
          size: 25,
        ),
      );
    }

    Widget _emptyBox() {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    isFollower(BuildContext context) {
      //var authState = Provider.of<AuthState>(context, listen: false);
      // if (authState.profileUserModel!.viewersList != null &&
      //     authState.profileUserModel!.viewersList!.isNotEmpty) {
      //   return (authState.profileUserModel!.viewersList!
      //       .any((x) => x == authState.userId));
      // } else
      {
        return false;
      }
    }

    /// This meathod called when user pressed back button
    /// When profile page is about to close
    /// Maintain minimum user's profile in profile page list
    Future<bool> _onWillPop() async {
      //final feedState = Provider.of<AuthState>(context, listen: false);

      /// It will remove last user's profile from profileUserModelList
      //authState.removeLastUser();
      return true;
    }

    Widget _imageFeed(String? _image) {
      return _image == null || _image.isEmpty
          ? Container()
          : Container(
              alignment: Alignment.center,
              height: fullHeight(context),
              width: fullWidth(context),
              child: customNetworkImage(_image, fit: BoxFit.cover),
            );
    }

    isMyProfile =
        widget.profileId == null || widget.profileId == currentUser!.userId;
    // var feedState = Provider.of<FeedState>(context);
    // var authState = Provider.of<AuthState>(context, listen: false);
    Storage storage = Storage(clientConnect());
    Image? url;
    if (secondUser?.userProfilePic == null) {
    } else {
      storage
          .getFilePreview(
              bucketId: profileImageBudgetId,
              fileId: secondUser!.userProfilePic.toString())
          .then((bytes) {
        url = Image.memory(bytes);
      });
    }
    String? id = widget.profileId ?? currentUser!.userId;
    FeedModel model = FeedModel();

    /// Filter user's Duct among all Ducts available in home page Ducts list
    // if (feedState.feedlist != null && feedState.feedlist!.isNotEmpty) {}
    var appSize = MediaQuery.of(context).size;
    // var pre = authState.userModel!.premium;
    //  cprint('$pre');

    // useEffect(
    //   () {
    //     animationController.forward();
    //     allChatMessage();

    //     subStreaming;
    //     return () {};
    //   },
    //   [authState.profileData],
    // );
    return WillPopScope(
      onWillPop: _onWillPop,
      child: widget.profileType == ProfileType.Store
          ? Stores(profileId: widget.profileId)
          : Scaffold(
              //      floatingActionButton: !isMyProfile ? null : _floatingActionButton(),
              // backgroundColor:
              //     // authState.userModel.premium == true
              //     //     ? TwitterColor.spindle
              //     //     : !isMyProfile &&
              //     //             authState.profileUserModel.subscription == true
              //     //         ? TwitterColor.spindle
              //     //         :
              //     TwitterColor.mystic,
              body: Stack(
                children: [
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
                  SizedBox(
                    width: fullWidth(context),
                    height: fullHeight(context),
                    child: PageView(
                      // enableLoop: true,
                      // waveType: WaveType.liquidReveal,
                      // fullTransitionValue: 300,
                      // initialPage: 0,
                      children: [
                        Stack(
                          children: [
                            Hero(
                              tag: 'profilePic',
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ProfileImageView(
                                                profileImage:
                                                    secondUser!.profilePic,
                                              )));

                                  // Navigator.pushNamed(
                                  //     context, "/ProfileImageView");
                                },
                                child: ColorFiltered(
                                  colorFilter: const ColorFilter.mode(
                                      Colors.white70, BlendMode.modulate),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: secondUser!.userProfilePic == null
                                        ? _imageFeed(
                                            secondUser.profilePic,
                                          )
                                        : FutureBuilder(
                                            future: storage.getFilePreview(
                                                bucketId: profileImageBudgetId,
                                                fileId: secondUser
                                                    .userProfilePic
                                                    .toString()),
                                            builder: (context, snap) {
                                              return snap.hasData &&
                                                          snap.data != null ||
                                                      url?.image != null
                                                  ? Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          image: DecorationImage(
                                                              image: url
                                                                      ?.image ??
                                                                  customAdvanceNetworkImage(
                                                                      dummyProfilePic),
                                                              fit:
                                                                  BoxFit.cover),
                                                          color: Colors
                                                              .blueGrey[50],
                                                          gradient:
                                                              LinearGradient(
                                                            colors: [
                                                              Colors.yellow
                                                                  .withOpacity(
                                                                      0.1),
                                                              Colors.white60
                                                                  .withOpacity(
                                                                      0.2),
                                                              Colors.pink
                                                                  .withOpacity(
                                                                      0.3)
                                                            ],
                                                            // begin: Alignment.topCenter,
                                                            // end: Alignment.bottomCenter,
                                                          )),
                                                    )
                                                  : SizedBox();
                                            }),
                                  ),
                                ),
                              ),
                            ),
                            // Positioned(
                            //   top: -200,
                            //   right: -140,
                            //   child: Transform.rotate(
                            //     angle: 90,
                            //     child: Container(
                            //       height: fullWidth(context) * 0.8,
                            //       width: fullWidth(context),
                            //       decoration: const BoxDecoration(
                            //           image: DecorationImage(
                            //               image: AssetImage(
                            //                   'assets/ankkara1.jpg'))),
                            //     ),
                            //   ),
                            // ),
                            // Positioned(
                            //   bottom: -80,
                            //   left: -250,
                            //   child: Transform.rotate(
                            //     angle: 90,
                            //     child: Container(
                            //       height: fullHeight(context) * 0.2,
                            //       width: fullWidth(context),
                            //       decoration: const BoxDecoration(
                            //           image: DecorationImage(
                            //               image: AssetImage(
                            //                   'assets/ankkara1.jpg'))),
                            //     ),
                            //   ),
                            // ),
                            // Positioned(
                            //   top: 0,
                            //   right: -250,
                            //   child: Transform.rotate(
                            //     angle: 90,
                            //     child: Container(
                            //       height: fullHeight(context) * 0.2,
                            //       width: fullWidth(context),
                            //       decoration: const BoxDecoration(
                            //           image: DecorationImage(
                            //               image: AssetImage(
                            //                   'assets/ankara3.jpg'))),
                            //     ),
                            //   ),
                            // ),
                            // Positioned(
                            //   bottom: 40,
                            //   right: -260,
                            //   child: Transform.rotate(
                            //     angle: 30,
                            //     child: Container(
                            //       height: fullHeight(context) * 0.2,
                            //       width: fullWidth(context),
                            //       decoration: const BoxDecoration(
                            //           image: DecorationImage(
                            //               image: AssetImage(
                            //                   'assets/ankkara1.jpg'))),
                            //     ),
                            //   ),
                            // ),
                            // Positioned(
                            //   bottom: 250,
                            //   left: -200,
                            //   child: Transform.rotate(
                            //     angle: 30,
                            //     child: Container(
                            //       height: fullHeight(context) * 0.2,
                            //       width: fullWidth(context),
                            //       decoration: const BoxDecoration(
                            //           image: DecorationImage(
                            //               image: AssetImage(
                            //                   'assets/ankara2.jpg'))),
                            //     ),
                            //   ),
                            // ),
                            // Positioned(
                            //   bottom: -200,
                            //   right: -60,
                            //   child: Transform.rotate(
                            //     angle: 30,
                            //     child: Container(
                            //       height: fullHeight(context) * 0.2,
                            //       width: fullWidth(context),
                            //       decoration: const BoxDecoration(
                            //           image: DecorationImage(
                            //               image: AssetImage(
                            //                   'assets/ankkara1.jpg'))),
                            //     ),
                            //   ),
                            // ),
                            //  borderRadius: BorderRadius.circular(50),
                            //     onPressed: () {
                            //       Navigator.pushNamed(
                            //           context, "/ProfileImageView");
                            //     },
                            Positioned(
                              bottom: context.responsiveValue(
                                  mobile: Get.height * 0.26,
                                  tablet: Get.height * 0.24,
                                  desktop: Get.height * 0.24),
                              right: 10,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  isMyProfile
                                      ? RippleButton(
                                          splashColor: Colors.orange[50],
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(60)),
                                          onPressed: () {
                                            showModalBottomSheet(
                                                // backgroundColor: TwitterColor.mystic,
                                                // bounce: true,
                                                context: context,
                                                builder: (context) =>
                                                    EditProfilePage(
                                                        // profileData: currentUser
                                                        //     .profileData,
                                                        profileId:
                                                            widget.profileId));
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                            decoration: BoxDecoration(
                                              color: TwitterColor.white,
                                              border: Border.all(
                                                  color: Colors.black87
                                                      .withAlpha(180),
                                                  width: 1),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),

                                            /// If [isMyProfile] is true then Edit profile button will display
                                            // Otherwise Follow/Following button will be display
                                            child: Text(
                                              'Edit Profile',
                                              style: TextStyle(
                                                color: Colors.black87
                                                    .withAlpha(180),
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        )
                                      : RippleButton(
                                          splashColor: Colors.orange[50],
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(60)),
                                          onPressed: () {
                                            // if (isMyProfile) {
                                            //   Navigator.pushNamed(
                                            //       context, '/EditProfile');
                                            // } else

                                            // currentUser.followUser(
                                            //     authState
                                            //         .profileUserModel?.userId,
                                            //     removeFollower:
                                            //         isFollower(context));
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 5,
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),

                            Positioned(
                              bottom: 0,
                              left: 0,
                              // right: 0,
                              child: frostedWhite(
                                Container(
                                  height: context.responsiveValue(
                                      mobile: Get.height * 0.25,
                                      tablet: Get.height * 0.23,
                                      desktop: Get.height * 0.23),
                                  width: appSize.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    //color: Colors.blueGrey[50]
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.yellow[100]!.withOpacity(0.3),
                                        Colors.yellow[200]!.withOpacity(0.1),
                                        Colors.yellowAccent[100]!
                                            .withOpacity(0.2)
                                        // Color(0xfffbfbfb),
                                        // Color(0xfff7f7f7),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: UserNameRowWidget(
                                      user: secondUser,
                                      isMyProfile: isMyProfile,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Positioned(
                              left: 1,
                              top: Get.height * 0.07,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(CupertinoIcons.back),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Profile',
                                          style: TextStyle(
                                              // color: Colors.blueGrey.shade500,
                                              fontSize: Get.height * 0.05,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  // !isMyProfile
                                  //     ? Container()
                                  //     : frostedWhite(Padding(
                                  //         padding: const EdgeInsets.all(8.0),
                                  //         child: Row(
                                  //           children: [
                                  //             customTitleText(
                                  //               'Earnings:',
                                  //             ),
                                  //             customTitleText(
                                  //               '20.0',
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       )),
                                ],
                              ),
                            ),
                            // authState.userId !=
                            //         authState.profileUserModel!.userId
                            //     ? Container()
                            //     : Positioned(
                            //         top: fullWidth(context) * 0.15,
                            //         right: 5,
                            //         child: Padding(
                            //           padding:
                            //               const EdgeInsets.only(left: 20.0),
                            //           child: frostedOrange(
                            //             GestureDetector(
                            //               onTap: () {
                            //                 setState(() {
                            //                   if (isDropdown) {
                            //                     floatingMenu.remove();
                            //                   } else {
                            //                     //  _postProsductoption();
                            //                     floatingMenu = _ordersView(
                            //                       context,
                            //                     );
                            //                     Overlay.of(context)!
                            //                         .insert(floatingMenu);
                            //                   }

                            //                   isDropdown = !isDropdown;
                            //                 });
                            //               },
                            //               child: Row(
                            //                 children: [
                            //                   Material(
                            //                     elevation: 10,
                            //                     color: Colors.transparent,
                            //                     borderRadius:
                            //                         BorderRadius.circular(
                            //                             100),
                            //                     child: CircleAvatar(
                            //                       radius: 14,
                            //                       backgroundColor:
                            //                           Colors.transparent,
                            //                       child: Image.asset(
                            //                         'assets/online-shopping.png',
                            //                       ),
                            //                     ),
                            //                   ),
                            //                   Padding(
                            //                     padding: const EdgeInsets
                            //                             .symmetric(
                            //                         horizontal: 8.0,
                            //                         vertical: 3),
                            //                     child:
                            //                         customTitleText('Orders'),
                            //                   ),
                            //                 ],
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            currentUser!.userId == widget.profileId ||
                                    currentUser.userId == null
                                ? Container()
                                : Positioned(
                                    bottom: context.responsiveValue(
                                        mobile: Get.height * 0.28,
                                        tablet: Get.height * 0.25,
                                        desktop: Get.height * 0.25),
                                    left: appSize.width * 0.04,
                                    //  left: 0,
                                    child: frostedWhite(
                                      Container(
                                        child:
                                            // authState.userId ==
                                            //         authState.profileUserModel?.userId
                                            //     ? Container()
                                            //     :
                                            RippleButton(
                                          splashColor: TwitterColor
                                              .dodgetBlue_50
                                              .withAlpha(100),
                                          onPressed: () async {
                                            if (kIsWeb) {
                                              _showDialogs();
                                            } else {
                                              // chatState.chatMessage.value =
                                              //     await SQLHelper.findLocalMessages(
                                              //         '${authState.appUser?.$id.splitByLengths((authState.appUser!.$id.length) ~/ 2)[0]}_${widget.profileId!.splitByLengths((widget.profileId!.length) ~/ 2)[0]}');
                                              // if (chatState
                                              //     .chatMessage.isEmpty) {
                                              //   chatState.chatMessage.value =
                                              //       await SQLHelper
                                              //           .findLocalMessages(
                                              //               '${widget.profileId!.splitByLengths((widget.profileId!.length) ~/ 2)[0]}_${authState.appUser!.$id.splitByLengths((authState.appUser!.$id.length) ~/ 2)[0]}');
                                              // }
                                              // chatState.chatMessage.value = [];
                                              // feedState
                                              //         .dataBaseChatsId?.value ==
                                              //     null;
                                              Get.to(() => ChatResponsive(
                                                  userProfileId:
                                                      widget.profileId));
                                              //   Navigator.pushNamed(
                                              //       context, '/ChatScreenPage');
                                            }
                                          },
                                          child: SizedBox(
                                              height: 50,
                                              width: 50,
                                              child: Lottie.asset(
                                                'assets/lottie/chat-box-animation.json',
                                              )),
                                        ),
                                      ),
                                    ),
                                  ),
                            DateFormat("E").format(DateTime.now()) == 'Sun'
                                ? Container()
                                : !isMyProfile
                                    ? Container()
                                    : Positioned(
                                        bottom: 20,
                                        right: 10,
                                        child: Material(
                                          elevation: 20,
                                          color: CupertinoColors.systemYellow,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: frostedOrange(
                                            Stack(
                                              children: [
                                                //PostProductMenu(),
                                                // const Icon(CupertinoIcons
                                                //     .add_circled_solid),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                            !isMyProfile
                                ? Container()
                                : Positioned(
                                    left: 0,
                                    // left: appSize.width * 0.7,
                                    bottom: context.responsiveValue(
                                        mobile: Get.height * 0.55,
                                        tablet: Get.height * 0.53,
                                        desktop: Get.height * 0.53),
                                    child: Row(
                                      children: const <Widget>[
                                        //AdminNotificationForUsers()
                                      ],
                                    ),
                                  ),
                          ],
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

class UserNameRowWidget extends StatelessWidget {
  const UserNameRowWidget({
    Key? key,
    required this.user,
    required this.isMyProfile,
  }) : super(key: key);

  final bool isMyProfile;
  final ViewductsUser? user;

  String? getBio(String? bio) {
    if (isMyProfile) {
      return bio;
    } else if (bio == "Edit profile to update bio") {
      return "Update your bio ";
    } else {
      return bio;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Row(
              children: <Widget>[
                UrlText(
                  text: user?.displayName ?? '',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(
                  width: 3,
                ),
                user!.isVerified!
                    ? customIcon(context,
                        icon: AppIcon.blueTick,
                        istwitterIcon: true,
                        iconColor: AppColor.primary,
                        size: 9,
                        paddingIcon: 3)
                    : const SizedBox(width: 0),
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 9),
          //   child: customText(
          //     '${user?.userName}',
          //     style: subtitleStyle.copyWith(fontSize: 13),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
              child: customText(
                getBio(user?.bio),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: customText(
                    user?.location.toString(),
                    style: const TextStyle(
                        color: CupertinoColors.lightBackgroundGray),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: <Widget>[
                customText(
                  getJoiningDate(user?.createdAt),
                  style: const TextStyle(
                      color: CupertinoColors.lightBackgroundGray),
                ),
              ],
            ),
          ),
          // Container(
          //   alignment: Alignment.center,
          //   child: Row(
          //     children: <Widget>[
          //       SizedBox(
          //         width: 10,
          //         height: 30,
          //       ),
          //       Obx(
          //         () => _tappbleText(context, '${user!.getViewers().obs}',
          //             ' Viewers', 'FollowerListPage'),
          //       ),
          //       SizedBox(width: 40),
          //       Obx(
          //         () => _tappbleText(context, '${user!.getViewing().obs}',
          //             ' Viewing', 'FollowingListPage'),
          //       )
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final IconData? icon;
  final String? title;
}

const List<Choice> choices = <Choice>[
  Choice(title: 'Share', icon: Icons.directions_car),
  Choice(title: 'Draft', icon: Icons.directions_bike),
  Choice(title: 'View Lists', icon: Icons.directions_boat),
  Choice(title: 'View Moments', icon: Icons.directions_bus),
  Choice(title: 'QR code', icon: Icons.directions_railway),
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key? key, this.choice}) : super(key: key);

  final Choice? choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.bodyText1!;
    return Card(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(choice!.icon, size: 128.0, color: textStyle.color),
            Text(choice!.title!, style: textStyle),
          ],
        ),
      ),
    );
  }
}

class _Orders extends StatefulWidget {
  const _Orders({
    Key? key,
    required this.model,
    this.list,
  }) : super(key: key);

  final FeedModel model;
  final FeedModel? list;

  @override
  __OrdersState createState() => __OrdersState();
}

class __OrdersState extends State<_Orders> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 20,
        borderRadius: BorderRadius.circular(20),
        child: frostedBlack(
          Container(
            width: fullWidth(context) * 0.3,
            height: fullWidth(context) * 0.001,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/show_1.png"),
                    fit: BoxFit.fitWidth)),
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: customText(
                      'Shoe',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[600],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class DuctsTimeline extends StatefulWidget {
//   final ImageIcon imageIcon;
//   final String text;

//   const DuctsTimeline({Key key, this.imageIcon, this.text}) : super(key: key);
//   @override
//   _DuctsTimelineState createState() => _DuctsTimelineState();
// }

// class _DuctsTimelineState extends State<DuctsTimeline>
//     with SingleTickerProviderStateMixin {
//   AnimationController _controller;
//   Animation<Offset> _slideAnimation;
//   GlobalKey _actionKey;
//   bool isDropdown = false;
//   double height, width, xPosiion, yPosition;
//   OverlayEntry floatingMenu;
//   @override
//   void initState() {
//     super.initState();
//     _actionKey = LabeledGlobalKey(text);
//     _controller =
//         AnimationController(vsync: this, duration: Duration(milliseconds: 1));
//     _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(-0.05, 0))
//         .animate(_controller);
//   }

//   _playAnimation() {
//     _controller.reset();
//     _controller.forward();
//   }

//   void _postProsductoption() {
//     RenderBox renderBox = _actionKey.currentContext.findRenderObject();
//     height = renderBox.size.height;
//     width = renderBox.size.width;
//     Offset offset = renderBox.localToGlobal(Offset.zero);
//     xPosiion = offset.dx;
//     yPosition = offset.dy;
//   }

//   void _navigateTo(String path) {
//     // Navigator.pop(context);
//     Navigator.of(context).pushNamed('/$path');
//   }

//   OverlayEntry _createPostMenu() {
//     var appSize = MediaQuery.of(context).size;
//     return OverlayEntry(
//       builder: (context) {
//         return FutureBuilder(
//           future: _playAnimation(),
//           //initialData: InitialData,
//           builder: (BuildContext context, AsyncSnapshot snapshot) {
//             return GestureDetector(
//               onTap: () {
//                 // setState(() {
//                 //   if (isDropdown) {
//                 //     floatingMenu.remove();
//                 //   } else {
//                 //     _postProsductoption();
//                 //     floatingMenu = _createPostMenu();
//                 //     Overlay.of(context).insert(floatingMenu);
//                 //   }

//                 //   isDropdown = !isDropdown;
//                 // });
//               },
//               child: frostedWhite(
//                 SafeArea(
//                   child: Container(
//                     height: appSize.height,
//                     width: appSize.width,
//                     child: Stack(
//                       children: [
//                         Positioned(
//                           top: 0,
//                           right: xPosiion,
//                           left: 10,
//                           //right: xPosiion,
//                           // width: width,
//                           // height: 4 + height + 40,
//                           child: Material(
//                             color: Colors.transparent,
//                             borderRadius: BorderRadius.circular(20),
//                             child: frostedYellow(
//                               Container(
//                                 height: appSize.height,
//                                 width: appSize.width,
//                                 child: Stack(
//                                   children: [
//                                     Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         children: [
//                                           Row(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.end,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.end,
//                                             children: [
//                                               InkWell(
//                                                   onTap: () {
//                                                     setState(() {
//                                                       if (isDropdown) {
//                                                         floatingMenu.remove();
//                                                       } else {
//                                                         _postProsductoption();
//                                                         floatingMenu =
//                                                             _createPostMenu();
//                                                         Overlay.of(context)
//                                                             .insert(
//                                                                 floatingMenu);
//                                                       }

//                                                       isDropdown = !isDropdown;
//                                                     });
//                                                   },
//                                                   child: Row(
//                                                     children: <Widget>[
//                                                       IconButton(
//                                                         onPressed: () {
//                                                           setState(() {
//                                                             if (isDropdown) {
//                                                               floatingMenu
//                                                                   .remove();
//                                                             } else {
//                                                               _postProsductoption();
//                                                               floatingMenu =
//                                                                   _createPostMenu();
//                                                               Overlay.of(
//                                                                       context)
//                                                                   .insert(
//                                                                       floatingMenu);
//                                                             }

//                                                             isDropdown =
//                                                                 !isDropdown;
//                                                           });
//                                                         },
//                                                         color: Colors.black,
//                                                         icon: Icon(CupertinoIcons
//                                                             .clear_circled_solid),
//                                                       ),
//                                                       Text(
//                                                         'Back',
//                                                         style: TextStyle(
//                                                             fontSize: 20,
//                                                             fontWeight:
//                                                                 FontWeight.w600,
//                                                             color: Colors
//                                                                 .blueGrey[300]),
//                                                       ),
//                                                     ],
//                                                   )),
//                                             ],
//                                           ),
//                                           Divider(),
//                                           // DuctTimlineFeeds(
//                                           //   isDropdown: true,
//                                           // ),
//                                         ]),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   Widget child;
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       key: _actionKey,
//       onTap: () {
//         setState(() {
//           if (isDropdown) {
//             floatingMenu.remove();
//           } else {
//             _postProsductoption();
//             floatingMenu = _createPostMenu();
//             Overlay.of(context).insert(floatingMenu);
//           }

//           isDropdown = !isDropdown;
//         });
//         // Navigator.of(context).pushNamed('/CreateFeedPage/tweet');
//       },
//       child: customButton(
//         'Duct',
//         Image.asset('assets/cool.png'),
//       ),
//     );
//   }
// }

// class DuctTimlineFeeds extends StatefulWidget {
//   final String profileId;
//   final bool isDropdown;
//   final String text;
//   DuctTimlineFeeds(
//       {Key key, this.profileId, this.text, this.isDropdown = false})
//       : super(key: key);
//   @override
//   _DuctTimeLineFeedsState createState() => _DuctTimeLineFeedsState();
// }

// class _DuctTimeLineFeedsState extends State<DuctTimlineFeeds>
//     with SingleTickerProviderStateMixin {
//   bool isMyProfile = false;
//   int pageIndex = 0;
//   TabController _tabController;

//   double height, width, xPosiion, yPosition;
//   OverlayEntry floatingMenu;
//   GlobalKey _actionKey;
//   @override
//   void initState() {
//     super.initState();
//     _actionKey = LabeledGlobalKey(text);
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       var authState = Provider.of<AuthState>(context, listen: false);
//       authState.getProfileUser(userProfileId: profileId);
//       isMyProfile =
//           profileId == null || profileId == authState.userId;
//     });
//     _tabController = TabController(length: 2, vsync: this);
//   }

//   Future<bool> _showDialog() {
//     var appSize = MediaQuery.of(context).size;
//     return showDialog(
//       context: context,
//       barrierDismissible: true,
//       builder: (BuildContext context) {
//         return frostedYellow(
//           Dialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: frostedYellow(
//               Container(
//                 height: appSize.width,
//                 width: appSize.width,
//                 decoration:
//                     BoxDecoration(borderRadius: BorderRadius.circular(20)),
//                 child: SafeArea(
//                   child: Stack(
//                     children: <Widget>[
//                       Center(
//                         child: SingleChildScrollView(
//                           child: Column(
//                             children: <Widget>[
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text(
//                                   'Apple',
//                                   style: TextStyle(
//                                       fontSize: 20,
//                                       color: Colors.blueGrey[500]),
//                                 ),
//                               ),
//                               Container(
//                                 height: 0.5,
//                                 color: Colors.blueGrey[300],
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text(
//                                   'Samsung',
//                                   style: TextStyle(
//                                       fontSize: 20,
//                                       color: Colors.blueGrey[500]),
//                                 ),
//                               ),
//                               Container(
//                                 height: 0.5,
//                                 color: Colors.blueGrey[300],
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text(
//                                   'Tecno',
//                                   style: TextStyle(
//                                       fontSize: 20,
//                                       color: Colors.blueGrey[500]),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _options() {
//     return Row(
//       //mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         SizedBox(
//           width: 10,
//         ),
//         GestureDetector(
//           onTap: () {
//             _showDialog();
//           },
//           child: Row(
//             children: <Widget>[
//               frostedYellow(
//                 IconButton(
//                     icon: Icon(
//                       Icons.filter_list,
//                       size: 30,
//                     ),
//                     onPressed: null),
//               ),
//               Text(
//                 'Brands',
//                 style: TextStyle(fontSize: 20, color: Colors.blueGrey[500]),
//               ),
//             ],
//           ),
//         )
//       ],
//     );
//   }

//   void _postProsductoption() {
//     RenderBox renderBox = _actionKey.currentContext.findRenderObject();
//     height = renderBox.size.height;
//     width = renderBox.size.width;
//     Offset offset = renderBox.localToGlobal(Offset.zero);
//     xPosiion = offset.dx;
//     yPosition = offset.dy;
//   }

//   Widget _ductList(BuildContext context, AuthState authState,
//       List<FeedModel> ductedList, bool isreply, bool isMedia) {
//     List<FeedModel> list;

//     /// If user hasn't Ducted yet
//     if (ductedList == null) {
//       // cprint('No Duct avalible');
//     } else if (isMedia) {
//       /// Display all Ducts with media file

//       list = ductedList.where((x) => x.imagePath != null).toList();
//     } else if (!isreply) {
//       /// Display all independent Ducts
//       /// No comments Duct will display

//       list = ductedList
//           .where((x) => x.parentkey == null || x.childVductkey != null)
//           .toList();
//     } else {
//       /// Display all reply Ducts
//       /// No intependent Duct will display
//       list = ductedList
//           .where((x) => x.parentkey != null && x.childVductkey == null)
//           .toList();
//     }

//     /// if [authState.isbusy] is true then an loading indicator will be displayed on screen.
//     return authState.isbusy
//         ? Container(
//             height: fullHeight(context) - 180,
//             child: CustomScreenLoader(
//               height: double.infinity,
//               width: fullWidth(context),
//               backgroundColor: Colors.white,
//             ),
//           )

//         /// if Duct list is empty or null then need to show user a message
//         : list == null || list.length < 1
//             ? Container(
//                 padding: EdgeInsets.only(top: 50, left: 30, right: 30),
//                 child: NotifyText(
//                   title: isMyProfile
//                       ? 'You haven\'t ${isreply ? 'reply to any Ducts' : isMedia ? 'post any media Duct yet' : 'Ducted a Product'}'
//                       : '${authState.profileUserModel.displayName} hasn\'t ${isreply ? 'reply to any Ducted Product' : isMedia ? 'post any media Duct yet' : 'Ducted a Product'}',
//                   subTitle: isMyProfile
//                       ? 'Tap Duct a New Product'
//                       : 'Once he\'ll do, they will be shown up here',
//                 ),
//               )

//             /// If Ducts available then Duct list will displayed
//             : ListView.builder(
//                 padding: EdgeInsets.symmetric(vertical: 0),
//                 itemCount: list.length,
//                 itemBuilder: (context, index) => Container(
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           if (isDropdown) {
//                             DuctsTimeline().createState().floatingMenu.remove();
//                           } else {
//                             DuctsTimeline().createState()._postProsductoption();
//                             floatingMenu =
//                                 DuctsTimeline().createState()._createPostMenu();
//                             Overlay.of(context).insert(floatingMenu);
//                           }
//                         });
//                       },
//                       child: Duct(
//                         model: list[index],
//                         isDisplayOnProfile: true,
//                         trailing: DuctBottomSheet().ductOptionIcon(
//                           context,
//                           list[index],
//                           DuctType.Duct,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//   }

//   Widget _emptyBox() {
//     return SliverToBoxAdapter(child: SizedBox.shrink());
//   }

//   @override
//   Widget build(BuildContext context) {
//     var appSize = MediaQuery.of(context).size;
//     var feedState = Provider.of<FeedState>(context);
//     var authState = Provider.of<AuthState>(context, listen: false);
//     List<FeedModel> list;
//     String id = profileId ?? authState.userId;

//     /// Filter user's tweet among all tweets available in home page tweets list
//     if (feedState.feedlist != null && feedState.feedlist.length > 0) {
//       list = feedState.feedlist.where((x) => x.userId == id).toList();
//     }
//     return Scaffold(
//       body: SafeArea(
//         child: GetX<AppState>(
//           builder: (context, value, child) {
//             return SingleChildScrollView(
//               child: Container(
//                 width: fullWidth(context),
//                 height: fullHeight(context),
//                 color: Colors.grey[50],
//                 child: authState.isbusy
//                     ? _emptyBox()
//                     : Stack(
//                         children: <Widget>[
//                           frostedBlueGray(
//                             Container(
//                               height: appSize.height,
//                               width: appSize.width,
//                               decoration: BoxDecoration(
//                                 // borderRadius: BorderRadius.circular(100),
//                                 //color: Colors.blueGrey[50]
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     Colors.yellow[300].withOpacity(0.3),
//                                     Colors.yellow[200].withOpacity(0.1),
//                                     Colors.yellowAccent[100].withOpacity(0.2)
//                                     // Color(0xfffbfbfb),
//                                     // Color(0xfff7f7f7),
//                                   ],
//                                   begin: Alignment.topCenter,
//                                   end: Alignment.bottomCenter,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             top: 0,
//                             left: 1,
//                             right: fullWidth(context) * 0.1,
//                             child: Container(
//                               width: fullWidth(context),
//                               child: TabBar(
//                                 isScrollable: true,
//                                 controller: _tabController,
//                                 indicator: TabIndicator(),
//                                 tabs: [
//                                   Padding(
//                                     padding: const EdgeInsets.only(left: 14.0),
//                                     child: frostedOrange(
//                                       Row(
//                                         children: [
//                                           Material(
//                                             elevation: 10,
//                                             borderRadius:
//                                                 BorderRadius.circular(100),
//                                             child: CircleAvatar(
//                                               radius: 14,
//                                               backgroundColor:
//                                                   Colors.transparent,
//                                               child: Image.asset(
//                                                   'assets/cool.png'),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 8.0, vertical: 3),
//                                             child: customTitleText('Ducts'),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.only(left: 20.0),
//                                     child: frostedOrange(
//                                       Row(
//                                         children: [
//                                           Material(
//                                             elevation: 10,
//                                             color: Colors.transparent,
//                                             borderRadius:
//                                                 BorderRadius.circular(100),
//                                             child: CircleAvatar(
//                                               radius: 14,
//                                               backgroundColor:
//                                                   Colors.transparent,
//                                               child: Image.asset(
//                                                 'assets/comment.png',
//                                                 color: Colors.grey,
//                                               ),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 8.0, vertical: 3),
//                                             child: customTitleText('Response'),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             top: appSize.width * 0.15,
//                             child: frostedBlack(
//                               Container(
//                                 height: appSize.height,
//                                 width: appSize.width,
//                                 decoration: BoxDecoration(
//                                   // borderRadius: BorderRadius.circular(100),
//                                   //color: Colors.blueGrey[50]
//                                   gradient: LinearGradient(
//                                     colors: [
//                                       Colors.yellow[100].withOpacity(0.3),
//                                       Colors.yellow[200].withOpacity(0.1),
//                                       Colors.yellowAccent[100].withOpacity(0.2)
//                                       // Color(0xfffbfbfb),
//                                       // Color(0xfff7f7f7),
//                                     ],
//                                     begin: Alignment.topCenter,
//                                     end: Alignment.bottomCenter,
//                                   ),
//                                 ),
//                                 child: TabBarView(
//                                   controller: _tabController,
//                                   children: [
//                                     /// Display all independent tweers list
//                                     _ductList(
//                                         context, authState, list, false, false),

//                                     /// Display all reply tweet list
//                                     _ductList(
//                                         context, authState, list, true, false),

//                                     /// Display all reply and comments tweet list
//                                     // _ductList(context, authState, list, false, true)
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             right: 10,
//                             top: 0,
//                             child: InkWell(
//                                 onTap: () {
//                                   Navigator.pop(context);
//                                 },
//                                 child: Row(
//                                   children: <Widget>[
//                                     IconButton(
//                                       onPressed: () {
//                                         Navigator.pop(context);
//                                       },
//                                       color: Colors.black,
//                                       icon: Icon(
//                                           CupertinoIcons.clear_circled_solid),
//                                     ),
//                                     Text(
//                                       'Back',
//                                       style: TextStyle(
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.w600,
//                                           color: Colors.blueGrey[300]),
//                                     ),
//                                   ],
//                                 )),
//                           ),
//                         ],
//                       ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

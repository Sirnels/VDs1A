// ignore_for_file: file_names, unnecessary_null_comparison, invalid_use_of_protected_member, unused_local_variable

import 'package:appwrite/appwrite.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
//import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
//import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viewducts/apis/auth_api.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/page/message/chatScreenPage.dart';
import 'package:viewducts/page/product/market.dart';
import 'package:viewducts/page/profile/dashbord.dart';
import 'package:viewducts/page/responsive.dart';
import 'package:viewducts/widgets/bottomMenuBar/bottomMenuBar.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'feed/feedPage.dart';
import 'message/chatListPage.dart';
import 'search/SearchPage.dart';

// ignore: must_be_immutable
class HomePage extends ConsumerWidget {
  static route() => MaterialPageRoute(
        builder: (context) => HomePage(
            // loginCallback:
            //     getCurrentUser
            ),
      );
  HomePage({Key? key}) : super(key: key);

  final Key feedPage = const PageStorageKey('feedPage');
  final Key _home = const PageStorageKey('_home');
  final Key _searchPage = const PageStorageKey('_searchPage');
  final Key _dashboardPage = const PageStorageKey('DashboardPage');
  final Key _chatPage = const PageStorageKey('_chatPage');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  int pageIndex = 0;
  bool biometricEnabled = false;

  GlobalKey<ScaffoldState>? scaffoldKeys;
  SharedPreferences? prefs;
  String shortcut = 'no action set';

  // var listener = DataConnectionChecker().onStatusChange.listen((event) {
  //   switch (event) {
  //     case DataConnectionStatus.connected:
  //       cprint('connected to the internet');

  //       break;
  //     case DataConnectionStatus.disconnected:
  //       cprint('disconnected to the internet');
  //       break;
  //     default:
  //   }
  // });

  // networkState() async {
  //   bool result = await DataConnectionChecker().hasConnection;
  //   if (result = true) {
  //     connected = true.obs;
  //   } else {
  //     connected = false.obs;
  //   }
  //   cprint('$result');
  //   cprint('$connected');
  //   // return result;
  // }

  // Widget network() {
  //   if (networkState() == false) {
  //     return Container();
  //   }

  //   if (networkState() == true) {
  //     return Container(
  //       height: Get.height,
  //       width: Get.width,
  //       color: const Color(0xFF212332).withOpacity(0.9),
  //     );
  //   }
  //   return Container();
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final realtime = Realtime(clientConnect());
    // Rx<AuthModel> authType = AuthModel().obs;
    // final chatSetState = useState(authState.profileData);
    // final authTypeState = useState(authState.authType);
    // final authTypeStream = useStream(realtime.subscribe(
    //     ["databases.$databaseId.collections.$authTypeColl.documents"]).stream);
    // final chatSetSStream = useStream(realtime.subscribe([
    //   "databases.$databaseId.collections.$profileUserColl.documents.${authState.appUser?.$id ?? authState.userModel!.key}"
    // ]).stream);

    // allUser() async {
    //   try {
    //     DynamicLinksService.initDynamicLinks();
    //     //   initPlatformState();
    //     // await lookupUserCountry();

    //     // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    //     // print('Running on ${androidInfo.model}'); // e.g. "Moto G (4)"

    //     // IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    //     // print('Running on ${iosInfo.utsname.machine}'); // e.g. "iPod7,1"

    //     // WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
    //     // // cprint('Running on ${webBrowserInfo.userAgent}');
    //     // MacOsDeviceInfo macInfo = await deviceInfo.macOsInfo;
    //     // cprint('Running on ${macInfo.model}');
    //     final database = Databases(
    //       clientConnect(),
    //     );
    //     await database.listDocuments(
    //         databaseId: databaseId,
    //         collectionId: profileUserColl,
    //         queries: [Query.equal('key', authState.appUser?.$id)]).then((data) {
    //       var value = data.documents
    //           .map((e) => ViewductsUser.fromJson(e.data))
    //           .toList();

    //       chatSetState.value.value = value;
    //       authState.userModel ==
    //           chatSetState.value.firstWhere(
    //               (data) => data.key == authState.appUser!.$id,
    //               orElse: () => chatState.chatUser!);
    //     });
    //     await database
    //         .listDocuments(
    //       databaseId: databaseId,
    //       collectionId: authTypeColl,
    //     )
    //         .then((data) {
    //       var value =
    //           data.documents.map((e) => AuthModel.fromJson(e.data)).toList();

    //       authTypeState.value.value = value;
    //     });
    //   } on AppwriteException catch (e) {
    //     cprint('$e');
    //   }
    // }

    // subs() {
    //   authTypeStream.data;
    //   if (authTypeState.value.value != null) {
    //     switch (authTypeStream.data?.events) {
    //       case ["collections.*.documents"]:
    //         // setState(() {});
    //         authTypeState.value.value
    //             .add(AuthModel.fromJson(authTypeStream.data!.payload));

    //         break;
    //       case ["collections.*.documents.*.delete"]:
    //         // setState(() {});
    //         authTypeState.value.value.removeWhere((datas) =>
    //             datas.authType == authTypeStream.data!.payload['authType']);

    //         break;

    //       default:
    //         break;
    //     }
    //   } else {
    //     cprint('it is empty');
    //   }
    // }

    // subsProfile() {
    //   chatSetSStream.data;
    //   if (chatSetState.value.value != null) {
    //     switch (chatSetSStream.data?.events) {
    //       case ["collections.*.documents"]:
    //         // setState(() {});
    //         chatSetState.value.value
    //             .add(ViewductsUser.fromJson(chatSetSStream.data!.payload));

    //         break;
    //       case ["collections.*.documents.*.delete"]:
    //         // setState(() {});
    //         chatSetState.value.value.removeWhere(
    //             (datas) => datas.key == chatSetSStream.data!.payload['key']);

    //         break;

    //       default:
    //         break;
    //     }
    //   } else {
    //     cprint('it is empty');
    //   }
    // }

    // // handleMylink(Uri uri) {
    // //   cprint('testing the products');
    // //   final queryParams = uri.queryParameters;
    // //   List<String> seperatedLinks = [];

    // //   seperatedLinks.addAll(uri.path.split('/'));
    // //   cprint("this is the token ${seperatedLinks[1]}");

    // //   // DateFormat("E").format(DateTime.now()) == 'Sun'
    // //   //     ? Container()
    // //   //     : showBarModalBottomSheet(
    // //   //         backgroundColor: Colors.red,
    // //   //         // isDismissible: false,
    // //   //         bounce: true,
    // //   //         context: context,
    // //   //         builder: (context) => OpenContainer(
    // //   //               closedBuilder: (context, action) {
    // //   //                 return ProductResponsiveView(
    // //   //                   model: feedState.productlist!
    // //   //                       .where(
    // //   //                           (data) => data.key == uri.queryParameters['id'])
    // //   //                       .first,
    // //   //                 );
    // //   //               },
    // //   //               openBuilder: (context, action) {
    // //   //                 return ProductResponsiveView(
    // //   //                   model: feedState.productlist!
    // //   //                       .where(
    // //   //                           (data) => data.key == uri.queryParameters['id'])
    // //   //                       .first,
    // //   //                 );
    // //   //               },
    // //   //             ));
    // // }

    // final authTypeStreaming = useMemoized(() => subs());
    // final chatStreaming = useMemoized(() => subsProfile());

    // // Future<void> initDynamicLinks(BuildContext context) async {
    // //   try {
    // //     final PendingDynamicLinkData? data =
    // //         await FirebaseDynamicLinks.instance.getInitialLink();
    // //     final Uri? deepLink = data?.link;

    // //     if (deepLink != null) {
    // //       cprint('testing the products');
    // //     }

    // //     FirebaseDynamicLinks.instance.onLink.listen((dynamiclink) async {
    // //       final Uri? deeplink = dynamiclink.link;
    // //       cprint('testing the link');
    // //       if (deeplink != null) {
    // //         cprint('testing the deeplink');
    // //         await handleMylink(deeplink);
    // //       } else {
    // //         cprint('testing the view');
    // //       }
    // //     }, onError: (e) {
    // //       cprint('we got an error: $e');
    // //     }, onDone: () {
    // //       cprint('testing the done');
    // //     });
    // //   } catch (e) {
    // //     cprint(e.toString());
    // //   }
    // // }

    void _checkNotification() {
      // final authState = Provider.of<AuthState>(context, listen: false);
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        try {
          // DynamicLinksService.initDynamicLinks();
          // //  initDynamicLinks(Get.context!);
          // // final networkStreaming = kIsWeb
          // //     ? useState('')
          // //     : useMemoized(
          // //         () => DataConnectionChecker().onStatusChange.listen((status) {
          // //               switch (status) {
          // //                 case DataConnectionStatus.connected:
          // //                   authState.networkConnectionState.value =
          // //                       'Connected';
          // //                   break;
          // //                 case DataConnectionStatus.disconnected:
          // //                   authState.networkConnectionState.value =
          // //                       'Not Connected';
          // //                   break;
          // //               }
          // //             }));
          // // networkStreaming;
          // FToast().init(Get.context!);
          // if (authState.networkConnectionState.value == 'Not Connected') {
          //   Fluttertoast.showToast(
          //     msg: 'You are offline',
          //     // toastLength: Toast.LENGTH_SHORT,
          //     gravity: ToastGravity.TOP_LEFT,
          //     timeInSecForIosWeb: 8,
          //     backgroundColor: CupertinoColors.systemRed,
          //   );
          // } else if (authState.networkConnectionState.value == 'Connected') {
          //   Fluttertoast.showToast(
          //     msg: 'You are online',
          //     // toastLength: Toast.LENGTH_SHORT,
          //     gravity: ToastGravity.TOP_LEFT,
          //     timeInSecForIosWeb: 8,
          //     backgroundColor: CupertinoColors.systemGreen,
          //   );
          //   authState.networkConnectionState.value = '';
          // }

          // cprint('${authState.networkConnectionState.value} to network');

          // cprint('${firebaseAuth.currentUser?.email} login email');

          // FirebaseMassagingHandler.config();
          // if (firebaseAuth.currentUser?.email == null) {
          //   showBarModalBottomSheet(
          //       backgroundColor: Colors.red,
          //       bounce: true,
          //       context: context,
          //       builder: (context) => PhoneProfile());
          // }
          // // DuctNotificationController.init();
          // // DuctNotificationController.onNotification.listen((payload) {
          // //   Get.to(() => ChatScreenPage(
          // //         userProfileId: payload,
          // //       ));
          // // });

          // // FirebaseMessaging.onMessage.listen(showFlutterNotification);

          // // await FirebaseMessaging.onMessageOpenedApp
          // //     .listen((RemoteMessage message) {
          // //   if (message.data['messageType'] == 'chat') {
          // //     Get.to(() => ChatScreenPage(
          // //           userProfileId: message.data['senderId'],
          // //         ));
          // //   } else {}
          // // });
          // //  FirebaseMessaging.onMessage.listen(showFlutterNotification);
          // StreamSubscription? _sub;
          // // userCartController.shoppingCartAppState = [CartItemModel()].obs;
          // final database = Databases(
          //   clientConnect(),
          // );
          // if (authState.logginType == 'local') {
          //   final account = Account(clientConnect());
          //   account.get().then((data) async {
          //     try {
          //       if (data.status == true) {
          //         await authState.getUserProfileOnline(clientConnect());
          //         authState.logginType.value = 'online';
          //       }
          //     } on AppwriteException catch (e) {
          //       cprint(e.message);
          //     }
          //   });
          // }
          // await database
          //     .listDocuments(
          //   databaseId: databaseId,
          //   collectionId: shoppingCartCollection,
          //   //  queries: [Query.equal('id', authState.appUser?.$id)]
          // )
          //     .then((data) {
          //   // if (data.documents.isNotEmpty) {
          //   var value = data.documents
          //       .map((e) => CartItemModel.fromMap(e.data))
          //       .toList();

          //   userCartController.shoppingCartAppState.value = value.obs;

          //   // } else {
          //   //   userCartController.shoppingCartAppState = [CartItemModel()].obs;
          //   // }
          // });

          // await database.listDocuments(
          //     databaseId: databaseId,
          //     collectionId: chatsColl,
          //     queries: [
          //       Query.equal('clicked', 'false'),
          //       Query.notEqual('userId', authState.userModel?.key)
          //     ]).then((data) async {
          //   //if (data.documents.isNotEmpty) {
          //   var value = data.documents
          //       .map((e) => ChatMessage.fromJson(e.data))
          //       .toList();

          //   userCartController.chatListUnreadMessage = value.obs;
          //   //} else {}
          // });
          // final Account account = Account(
          //   clientConnect(),
          // );
          // Future<String?> _getAppVersionFromFirebaseConfig() async {
          //   final FirebaseRemoteConfig remoteConfig =
          //       FirebaseRemoteConfig.instance;
          //   await remoteConfig.fetch();
          //   await remoteConfig.fetchAndActivate();
          //   var data = remoteConfig.getString('app_Version_latest');
          //   if (data.isNotEmpty) {
          //     return jsonDecode(data)["ke_y"];
          //   } else {
          //     cprint(
          //         "Please add your app's current version into Remote config in firebase",
          //         errorIn: "_getAppVersionFromFirebaseConfig");
          //     return null;
          //   }
          // }

          // Future<bool> _checkAppVersion() async {
          //   PackageInfo packageInfo = await PackageInfo.fromPlatform();
          //   final currentAppVersion = packageInfo.version;

          //   final appVersion = await _getAppVersionFromFirebaseConfig();
          //   if (appVersion != currentAppVersion) {
          //     if (kDebugMode) {
          //       cprint("Latest version of app is not installed on your system");
          //       cprint(
          //           "In debug mode we are not restrict devlopers to redirect to update screen");
          //       cprint(
          //           "Redirect devs to update screen can put other devs in confusion");
          //       return true;
          //     }

          //     showBarModalBottomSheet(
          //         // backgroundColor: TwitterColor.mystic,
          //         bounce: true,
          //         context: context,
          //         builder: (context) => OpenContainer(
          //               closedBuilder: (context, action) {
          //                 return const UpdateApp();
          //               },
          //               openBuilder: (context, action) {
          //                 return const UpdateApp();
          //               },
          //             ));
          //     return false;
          //   } else {
          //     return true;
          //   }
          // }

          // _checkAppVersion();
          // // if (authState.appUser!.status == true) {
          // //   // if (authTypeState.value
          // //   //         .firstWhere((data) => data.authType == 'phone',
          // //   //             orElse: () => authType.value)
          // //   //         .active ==
          // //   //     true) {
          // //   account.get().then((value) {
          // //     if (value.prefs.data['newDevice'] == true) {
          // //       Get.to(() => OpenContainer(
          // //                 closedBuilder: (context, action) {
          // //                   return PhoneProfile();
          // //                 },
          // //                 openBuilder: (context, action) {
          // //                   return PhoneProfile();
          // //                 },
          // //               )

          // //           //PhoneProfile()

          // //           );
          // //     }
          // //   });
          // // }
          // if (authTypeState.value
          //         .firstWhere((data) => data.authType == 'email',
          //             orElse: () => authType.value)
          //         .active ==
          //     true) {
          //   if (authState.appUser?.emailVerification == false) {
          //     Get.to(() => VerifyEmailPage());
          //   }
          // }
          // //  }

          // if (!kIsWeb) {
          //   // It will handle app links while the app is already started - be it in
          //   // the foreground or in the background.
          //   _sub = uriLinkStream.listen((Uri? uri) async {
          //     if (uri != null) {
          //       authState.deepApplinkProductKey ==
          //           uri.queryParameters['id'].obs;
          //       authState.deepApplinkProductCommUser ==
          //           uri.queryParameters['comusr'].obs;
          //       Rx<FeedModel> model = feedState.productlist!
          //           .where((data) =>
          //               data.key == authState.deepApplinkProductKey.value)
          //           .first
          //           .obs;

          //       Get.to(() => ProductStoryView(
          //             model: model.value,
          //             commissionUser:
          //                 authState.deepApplinkProductCommUser!.value,
          //           ));
          //     } else {}
          //   }, onError: (Object err) {
          //     cprint('got err: $err');
          //   });
          //   //  });

          // }
          // FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
          //   final Uri uri = dynamicLinkData.link;
          //   final queryParams = uri.queryParameters;
          //   if (queryParams.isNotEmpty && queryParams['id'] != null) {
          //     showBarModalBottomSheet(
          //       // backgroundColor: TwitterColor.mystic,
          //       bounce: true,
          //       context: Get.context!,
          //       builder: (context) => ProductResponsiveView(
          //         commissionUser: queryParams['comusr'],
          //         model: feedState.productlist!
          //             .where((data) => data.key == queryParams['id'])
          //             .first,
          //       ),
          //     );
          //   }
          // }).onError((error) {
          //   // Handle errors
          // });
          // // Rx<FeedModel> prduct = FeedModel().obs;
          // // if (authState.deepApplinkProductKey != null) {
          // //   Rx<String> key;
          // //   key = authState.deepApplinkProductKey;
          // //   // authState.deepApplinkProductKey == null;
          // //   showBarModalBottomSheet(
          // //     // backgroundColor: TwitterColor.mystic,
          // //     bounce: true,
          // //     context: Get.context!,
          // //     builder: (context) => ProductResponsiveView(
          // //       model: feedState.productlist!.firstWhere(
          // //           (data) => data.key == key,
          // //           orElse: () => prduct.value),
          // //     ),
          // //   );
          // // }
          // const QuickActions quickActions = QuickActions();
          // await quickActions.initialize((String shortcutType) {
          //   if (shortcutType != null) {
          //     shortcut = shortcutType;
          //   } else if (shortcutType == 'duct') {
          //     appState.setpageIndex = 0.obs;
          //   } else if (shortcutType == 'search') {
          //     appState.setpageIndex = 3.obs;
          //   } else if (shortcutType == 'action_help') {
          //     Get.to(
          //       () => SettingsAndPrivacyPage(),
          //     );
          //   }
          // });
          // quickActions.setShortcutItems(<ShortcutItem>[
          //   const ShortcutItem(
          //       type: 'duct', localizedTitle: 'Ducts', icon: 'smile'),
          //   const ShortcutItem(
          //       type: 'search', localizedTitle: 'Search', icon: 'search'),
          //   const ShortcutItem(
          //       type: 'action_help',
          //       localizedTitle: 'Settings',
          //       icon: 'settings')
          // ]);
        } on AppwriteException catch (e) {
          cprint('$e _checkNotification');
        }
      });
    }

    Widget _getPage(int index) {
      switch (index) {
        case 0:
          return Responsive(
            mobile: Stack(
              children: [
                ChatListPage(
                  scaffoldKey: _scaffoldKey,
                  key: _chatPage,
                ),
                Positioned(
                  right: 5,
                  top: Get.height * 0.15,
                  //bottom: 9,
                  child: Column(
                    children: [
                      // DateFormat("E").format(DateTime.now()) == 'Sun'
                      //     ? Container()
                      //     :
                      SideMenubar(),
                    ],
                  ),
                ),
              ],
            ),
            tablet: Stack(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: ChatListPage(
                        scaffoldKey: _scaffoldKey,
                        key: _chatPage,
                        isTablet: true,
                      ),
                    ),
                    DateFormat("E").format(DateTime.now()) == 'Sun'
                        ? Container()
                        : Expanded(
                            flex: 9,
                            child: Home(
                              scaffoldKey: _scaffoldKey,
                              key: _home,
                              isTablet: true,
                            ),
                          ),
                  ],
                ),
                DateFormat("E").format(DateTime.now()) == 'Sun'
                    ? Container()
                    : Positioned(
                        right: 5,
                        top: Get.height * 0.15,
                        //bottom: 9,
                        child: Column(
                          children: [
                            SideMenubar(),
                          ],
                        ),
                      ),
              ],
            ),
            desktop: Row(
              children: [
                // Once our width is less then 1300 then it start showing errors
                // Now there is no error if our width is less then 1340

                Expanded(
                  flex: Get.width > 1340 ? 4 : 6,
                  child: ChatListPage(
                    scaffoldKey: _scaffoldKey,
                    key: _chatPage,
                    isDesktop: true,
                  ),
                ),
                Expanded(
                  flex: Get.width > 1340 ? 8 : 10,
                  child: DateFormat("E").format(DateTime.now()) == 'Sun'
                      ? Container()
                      : Home(
                          scaffoldKey: _scaffoldKey,
                          key: _home,
                          isDesktop: true,
                        ),
                ),
                Expanded(
                  flex: Get.width > 1340 ? 2 : 2,
                  child: DateFormat("E").format(DateTime.now()) == 'Sun'
                      ? Container()
                      : SideMenubar(isDesktop: true),
                ),
              ],
            ),
          );

        case 1:
          return Responsive(
            mobile: Container(
              height: fullHeight(context),
              width: fullWidth(context),
              child: Stack(
                children: [
                  FeedPage(
                    feedPagKey: _scaffoldKey,
                    key: feedPage,
                    refreshIndicatorKey: refreshIndicatorKey,
                  ),
                  Positioned(
                    right: 5,
                    top: Get.height * 0.15,
                    //bottom: 9,
                    child: Column(
                      children: [
                        SideMenubar(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            tablet: Stack(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Home(
                        scaffoldKey: _scaffoldKey,
                        key: _home,
                        desk2: true,
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: FeedPage(
                        feedPagKey: _scaffoldKey,
                        key: feedPage,
                        refreshIndicatorKey: refreshIndicatorKey,
                        isTablet: true,
                        desk2: true,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: 5,
                  top: Get.height * 0.15,
                  //bottom: 9,
                  child: Column(
                    children: [
                      SideMenubar(),
                    ],
                  ),
                ),
              ],
            ),
            desktop: Row(
              children: [
                // Once our width is less then 1300 then it start showing errors
                // Now there is no error if our width is less then 1340

                Expanded(
                  flex: Get.width > 1340 ? 4 : 6,
                  child: Home(
                    scaffoldKey: _scaffoldKey,
                    key: _home,
                    desk2: true,
                  ),
                ),
                Expanded(
                  flex: Get.width > 1340 ? 8 : 10,
                  child: FeedPage(
                    feedPagKey: _scaffoldKey,
                    key: feedPage,
                    refreshIndicatorKey: refreshIndicatorKey,
                    desk2: true,
                    // isDesktop: true,
                  ),
                ),
                Expanded(
                  flex: Get.width > 1340 ? 2 : 2,
                  child: SideMenubar(isDesktop: true),
                ),
              ],
            ),
          );

        case 2:
          return Responsive(
            mobile: Stack(
              children: [
                Home(
                  scaffoldKey: _scaffoldKey,
                  key: _home,
                ),
                Positioned(
                  right: 5,
                  top: Get.height * 0.15,
                  child: Column(
                    children: [
                      SideMenubar(),
                    ],
                  ),
                ),
              ],
            ),
            tablet: Stack(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: FeedPage(
                        feedPagKey: _scaffoldKey,
                        key: feedPage,
                        refreshIndicatorKey: refreshIndicatorKey,
                        isTablet: true,
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: Home(
                        scaffoldKey: _scaffoldKey,
                        key: _home,
                        isTablet: true,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: 5,
                  top: Get.height * 0.15,
                  //bottom: 9,
                  child: Column(
                    children: [
                      SideMenubar(),
                    ],
                  ),
                ),
              ],
            ),
            desktop: Row(
              children: [
                // Once our width is less then 1300 then it start showing errors
                // Now there is no error if our width is less then 1340

                Expanded(
                  flex: Get.width > 1340 ? 4 : 6,
                  child: FeedPage(
                      feedPagKey: _scaffoldKey,
                      key: feedPage,
                      refreshIndicatorKey: refreshIndicatorKey,
                      isDesktop: true,
                      isDeskLeft: true),
                ),
                Expanded(
                  flex: Get.width > 1340 ? 8 : 10,
                  child: Home(
                    scaffoldKey: _scaffoldKey,
                    key: _home,
                    isDesktop: true,
                  ),
                ),
                Expanded(
                  flex: Get.width > 1340 ? 2 : 2,
                  child: SideMenubar(isDesktop: true),
                ),
              ],
            ),
          );

        case 3:
          return Responsive(
            mobile: Stack(
              children: [
                SearchPage(
                  scaffoldKey: _scaffoldKey,
                  key: _searchPage,
                ),
                Positioned(
                  right: 5,
                  top: Get.height * 0.15,
                  //bottom: 9,
                  child: Column(
                    children: [
                      SideMenubar(),
                    ],
                  ),
                ),
              ],
            ),
            tablet: Stack(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: FeedPage(
                        feedPagKey: _scaffoldKey,
                        key: feedPage,
                        refreshIndicatorKey: refreshIndicatorKey,
                        isTablet: true,
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: SearchPage(
                        scaffoldKey: _scaffoldKey,
                        key: _searchPage,
                        isTablet: true,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: 5,
                  top: Get.height * 0.15,
                  //bottom: 9,
                  child: Column(
                    children: [
                      SideMenubar(),
                    ],
                  ),
                ),
              ],
            ),
            desktop: Row(
              children: [
                // Once our width is less then 1300 then it start showing errors
                // Now there is no error if our width is less then 1340

                Expanded(
                  flex: Get.width > 1340 ? 4 : 6,
                  child: FeedPage(
                      feedPagKey: _scaffoldKey,
                      key: feedPage,
                      refreshIndicatorKey: refreshIndicatorKey,
                      isDesktop: true,
                      isDeskLeft: true),
                ),
                Expanded(
                  flex: Get.width > 1340 ? 8 : 10,
                  child: SearchPage(
                    scaffoldKey: _scaffoldKey,
                    key: _searchPage,
                    isDesktop: true,
                  ),
                ),
                Expanded(
                  flex: Get.width > 1340 ? 2 : 2,
                  child: SideMenubar(isDesktop: true),
                ),
              ],
            ),
          );

        case 4:
          return Responsive(
            mobile: Stack(
              children: [
                Dashboard(
                  scaffoldKey: _scaffoldKey,
                  key: _dashboardPage,
                ),
                Positioned(
                  right: 5,
                  top: Get.height * 0.15,
                  //bottom: 9,
                  child: Column(
                    children: [
                      SideMenubar(),
                    ],
                  ),
                ),
              ],
            ),
            tablet: Stack(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: FeedPage(
                        feedPagKey: _scaffoldKey,
                        key: feedPage,
                        refreshIndicatorKey: refreshIndicatorKey,
                        isTablet: true,
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: Dashboard(
                        scaffoldKey: _scaffoldKey,
                        key: _dashboardPage,
                        isTablet: true,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: 5,
                  top: Get.height * 0.15,
                  //bottom: 9,
                  child: Column(
                    children: [
                      SideMenubar(),
                    ],
                  ),
                ),
              ],
            ),
            desktop: Row(
              children: [
                // Once our width is less then 1300 then it start showing errors
                // Now there is no error if our width is less then 1340

                Expanded(
                  flex: Get.width > 1340 ? 4 : 6,
                  child: FeedPage(
                      feedPagKey: _scaffoldKey,
                      key: feedPage,
                      refreshIndicatorKey: refreshIndicatorKey,
                      isDesktop: true,
                      isDeskLeft: true),
                ),
                Expanded(
                  flex: Get.width > 1340 ? 8 : 10,
                  child: Dashboard(
                    scaffoldKey: _scaffoldKey,
                    key: _dashboardPage,
                    isDesktop: true,
                  ),
                ),
                Expanded(
                  flex: Get.width > 1340 ? 2 : 2,
                  child: SideMenubar(isDesktop: true),
                ),
              ],
            ),
          );

        default:
          return Responsive(
            mobile: Stack(
              children: [
                ChatListPage(
                  scaffoldKey: _scaffoldKey,
                  key: _chatPage,
                ),
                Positioned(
                  right: 5,
                  top: Get.width * 0.35,
                  //bottom: 9,
                  child: Column(
                    children: [
                      SideMenubar(),
                    ],
                  ),
                ),
              ],
            ),
            tablet: Stack(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: FeedPage(
                        feedPagKey: _scaffoldKey,
                        key: feedPage,
                        refreshIndicatorKey: refreshIndicatorKey,
                        isTablet: true,
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: ChatScreenPage(),
                    ),
                  ],
                ),
                Positioned(
                  right: 5,
                  top: Get.width * 0.35,
                  //bottom: 9,
                  child: Column(
                    children: [
                      SideMenubar(),
                    ],
                  ),
                ),
              ],
            ),
            desktop: Row(
              children: [
                // Once our width is less then 1300 then it start showing errors
                // Now there is no error if our width is less then 1340

                Expanded(
                  flex: Get.width > 1340 ? 4 : 6,
                  child: ChatListPage(
                    scaffoldKey: _scaffoldKey,
                    key: _chatPage,
                  ),
                ),
                Expanded(
                  flex: Get.width > 1340 ? 8 : 10,
                  child: ChatScreenPage(),
                ),
                Expanded(
                  flex: Get.width > 1340 ? 2 : 2,
                  child: SideMenubar(isDesktop: true),
                ),
              ],
            ),
          );
      }
    }

    Widget _body() {
      _checkNotification();

      return
          //   Obx(
          // () =>
          _getPage(ref.watch(numberProvider));
    }

    // final chatlistUnreadMessageStream = useStream(realtime.subscribe(
    //     ["databases.$databaseId.collections.$chatsColl.documents"]).stream);
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

    // chatlistUnreadMessagesubs() {
    //   chatlistUnreadMessageStream.data;
    //   if (userCartController.chatListUnreadMessage.value.isNotEmpty) {
    //     switch (chatlistUnreadMessageStream.data?.events) {
    //       case ["collections.*.documents"]:
    //         // setState(() {});
    //         userCartController.chatListUnreadMessage.value.add(
    //             ChatMessage.fromJson(
    //                 chatlistUnreadMessageStream.data?.payload));

    //         break;
    //       case ["collections.*.documents.*.delete"]:
    //         // setState(() {});
    //         userCartController.chatListUnreadMessage.value.removeWhere(
    //             (datas) =>
    //                 datas.key ==
    //                 chatlistUnreadMessageStream.data!.payload['key']);

    //         break;

    //       default:
    //         break;
    //     }
    //   } else {}
    // }

    // final chatlistUnreadMessagesubsStreaming =
    //     useMemoized(() => chatlistUnreadMessagesubs());
    // final cartStreaming = useMemoized(() => cartSub());
    // useEffect(
    //   () {
    //     // initDynamicLinks();
    //     allUser();

    //     authTypeStreaming;
    //     chatStreaming;
    //     cartStreaming;
    //     chatlistUnreadMessagesubsStreaming;
    //     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    //     return () {
    //       //  AwesomeNotifications().cancelAll();
    //     };
    //   },
    //   [
    //     authState.authType,
    //     userCartController.shoppingCartAppState,
    //     userCartController.chatListUnreadMessage
    //   ],
    // );

    return Scaffold(
      key: _scaffoldKey,
      // bottomNavigationBar: BottomMenubar(),
      //  drawer: SidebarMenu(),
      body: SafeArea(
          child:
              //  GetBuilder<AppState>(
              //     //init: appState,
              //     builder: (_) =>
              // authState.user!.emailVerified
              //     ?
              _body()
          // : const VerifyEmailPage()
          // )
          ),
    );
  }
}

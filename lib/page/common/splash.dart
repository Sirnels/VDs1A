import 'dart:async';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/appwrite.dart' as acc;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:viewducts/app_theme/colors_pallete.dart';
import 'package:viewducts/app_theme/theme.dart';
import 'package:viewducts/helper/enum.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/page/Auth/welcomePage.dart';
import 'package:viewducts/page/homePage.dart';
import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/state/viewDuctsNotification.dart';
// import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/frosted.dart';
import 'package:viewducts/widgets/newWidget/title_text.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({Key? key}) : super(key: key);

  /// Return installed app version
  /// For testing purpose in debug mode update screen will not be open up
  /// In  an old version of  realease app is installed on user's device then
  /// User will not be able to see home screen
  /// User will redirected to update app screen.
  /// Once user update app with latest verson and back to app then user automatically redirected to welcome / Home page

  /// Returns app version from firebase config
  /// Fecth Latest app version from firebase Remote config
  /// To check current installed app version check [version] in pubspec.yaml
  /// you have to add latest app version in firebase remote config
  /// To fetch this key go to project setting in firebase
  /// Click on `cloud messaging` tab
  /// Copy server key from `Project credentials`
  /// Now goto `Remote Congig` section in fireabse
  /// Add [appVersion]  as paramerter key and below json in Default vslue
  ///  ``` json
  ///  {
  ///    "key": "1.0.0"
  ///  } ```
  /// After adding app version key click on Publish Change button
  /// For package detail check:-  https://pub.dev/packages/firebase_remote_config#-readme-tab-

  Widget _body(BuildContext context) {
    return frostedWhite(
      SizedBox(
        height: Get.height,
        width: Get.width,
        child: Container(
          // padding: const EdgeInsets.all(50),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              // Platform.isIOS
              //     ? Center(
              //         child: SizedBox(
              //           height: Get.height,
              //           width: Get.width,
              //           child: customText('Checking Your Connection...'),
              //           // child: LinearProgressIndicator(),
              //         ),
              //       )
              //     :
              Center(
                child: SizedBox(
                  height: Get.height,
                  width: Get.width,
                  child: customText('Checking Your Connection...'),
                  // child: LinearProgressIndicator(),
                ),
              ),
              // Lottie.asset(
              //   'assets/lottie/mobile-shopping.json',
              // ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Material(
                            color: Colors.yellow[50],
                            elevation: 20,
                            borderRadius: BorderRadius.circular(100),
                            shadowColor: Colors.yellow[100],
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Image.asset(
                                'assets/delicious.png',
                              ),
                              radius: context.responsiveValue(
                                  mobile: Get.height * 0.06,
                                  tablet: Get.height * 0.08,
                                  desktop: Get.height * 0.1),
                            ),
                          ),
                          TitleText(
                            'View',
                            color: Colors.blueGrey[100],
                            fontSize: context.responsiveValue(
                                mobile: Get.height * 0.06,
                                tablet: Get.height * 0.09,
                                desktop: Get.height * 0.11),
                          ),
                          TitleText(
                            'Ducts',
                            color: Colors.blueGrey[300],
                            fontSize: context.responsiveValue(
                                mobile: Get.height * 0.06,
                                tablet: Get.height * 0.09,
                                desktop: Get.height * 0.11),
                          ),
                        ],
                      ),
                      TitleText(
                        'Social, Shop And Get Paid ',
                        fontSize: context.responsiveValue(
                            mobile: Get.height * 0.02,
                            tablet: Get.height * 0.025,
                            desktop: Get.height * 0.02),
                        color: Colors.blueGrey[700],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  // var listener = DataConnectionChecker().onStatusChange.listen((event) {
  //   switch (event) {
  //     case DataConnectionStatus.connected:
  //       Fluttertoast.showToast(
  //         msg: 'You are online',
  //         // toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.TOP_LEFT,
  //         timeInSecForIosWeb: 8,
  //         backgroundColor: Colors.green,
  //       );
  //       // Get.snackbar(
  //       //   "online",
  //       //   "You are connected",
  //       //   backgroundColor: AppColors.green.withOpacity(0.4),
  //       //   icon: Container(
  //       //     height: 100,
  //       //     width: 100,
  //       //     decoration: BoxDecoration(
  //       //         borderRadius: BorderRadius.circular(100),
  //       //         image: const DecorationImage(
  //       //             image: AssetImage('assets/eagle.png'))),
  //       //   ),
  //       // );

  //       break;
  //     case DataConnectionStatus.disconnected:
  //       Fluttertoast.showToast(
  //         msg: 'You are Offline',
  //         //toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.TOP_RIGHT,
  //         timeInSecForIosWeb: 8,
  //         backgroundColor: Colors.red,
  //       );
  //       // Get.snackbar(
  //       //   "Offline",
  //       //   "You are disconnected",
  //       //   backgroundColor: AppColors.red.withOpacity(0.4),
  //       //   icon: Container(
  //       //     height: 100,
  //       //     width: 100,
  //       //     decoration: BoxDecoration(
  //       //         borderRadius: BorderRadius.circular(100),
  //       //         image: const DecorationImage(
  //       //             image: AssetImage('assets/lion.png'))),
  //       //   ),
  //       // );

  //       break;
  //     default:
  //   }
  // });
  // var connected;
  // networkState() async {
  //   listener.onData((data) {
  //     connected = data.name.obs;
  //     cprint(connected?.value);
  //   });
  // }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Session? session;
    // final authenticationState = useState(authState.authStatus);
    // Account? appUser;
    // @override
    // void initState() {
    //   // ViewDucts.internetLookUp();
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     timer();
    //     // listener;
    //   });
    //   super.initState();
    // }

    // void timer() async {
    //   try {
    //     //  final isAppUpdated = true;
    //     final account = acc.Account(clientConnect());
    //     final storage = const FlutterSecureStorage();

    //     final localStorageProfileData = await storage.read(key: 'profile');
    //     // appUser = await account.get();
    //     // final authState = Get.find<AuthState>();
    //     //    await _checkAppVersion();
    //     // if (isAppUpdated) {
    //     // if (localStorageProfileData != null) {
    //     //   await authState.locaSecureProfile();
    //     //   cprint('local profile ');
    //     // } else {
    //     account.get().then((data) async {
    //       try {
    //         if (kIsWeb) {
    //           if (data.status == true) {
    //             await authState.setInitialScreen(clientConnect());
    //             cprint('online  profile');
    //           } else {
    //             await authState.authStatus.value == AuthStatus.NOT_LOGGED_IN;
    //             cprint('offline ');
    //             Get.offAll(
    //               () => const WelcomePage(),
    //             );
    //           }
    //         } else {
    //           if (data.status == true) {
    //             await authState.setInitialScreen(clientConnect());
    //             cprint('online  profile');
    //           } else if (localStorageProfileData != null) {
    //             await authState.locaSecureProfile();
    //             cprint('local profile ');
    //           } else {
    //             await authState.authStatus.value == AuthStatus.NOT_LOGGED_IN;
    //             cprint('offline ');
    //             Get.offAll(
    //               () => const WelcomePage(),
    //             );
    //           }
    //         }
    //       } on AppwriteException catch (e) {
    //         cprint(e.message);
    //       }
    //     }).onError((e, stackTrace) async {
    //       //  if (e == 401) {
    //       try {
    //         if (localStorageProfileData != null) {
    //           await authState.locaSecureProfile();
    //           cprint('local profile ');
    //         } else {
    //           cprint("NOT_LOGGED_IN. you are Offline/no Profile");
    //           authState.authStatus.value == AuthStatus.NOT_LOGGED_IN;
    //           Get.offAll(
    //             () => const WelcomePage(),
    //           );
    //         }

    //         //  cprint('${appUser?.status}');
    //       } on AppwriteException catch (e) {
    //         if (kDebugMode) {
    //           cprint("$e timer()");
    //         }
    //       }
    //       ;
    //       // }
    //     });
    //     // }

    //     //}
    //   } on AppwriteException catch (e) {
    //     cprint(e.message);
    //   }
    //   ;
    // }

    // useEffect(
    //   () {
    //     WidgetsBinding.instance.addPostFrameCallback((_) {
    //       timer();
    //       DynamicLinksService.initDynamicLinks();
    //       FirebaseMessaging.onMessageOpenedApp
    //           .listen((RemoteMessage message) async {
    //         // if (message.data["messageType"] == "chat") {
    //         cprint("onMessageOpenedApp}");
    //         // return await Get.to(() => ChatResponsive(
    //         //       userProfileId: message.data['senderId'],
    //         //     ));
    //         // // } else {}
    //       });
    //       FirebaseMessaging.onBackgroundMessage((message) async {
    //         // return await Get.to(() => ChatResponsive(
    //         //       userProfileId: message.data['senderId'],
    //         //     ));
    //         cprint("onBackgroundMessage}");
    //       });
    //       // listener;
    //     });
    //     return () {};
    //   },
    //   [authState.authStatus],
    // );

    return Scaffold(
        backgroundColor: Pallete.scafoldBacgroundColor,
        body: SafeArea(
            child:
                // Obx(() => authState.authStatus.value == AuthStatus.NOT_DETERMINED
                //     ?
                Stack(
          children: [
            // frostedBlueGray(
            //   Container(
            //     height: Get.height,
            //     width: Get.width,
            //     decoration: BoxDecoration(
            //       // borderRadius: BorderRadius.circular(100),
            //       //color: Colors.blueGrey[50]
            //       gradient: LinearGradient(
            //         colors: [
            //           Colors.yellow[100]!.withOpacity(0.3),
            //           Colors.yellow[200]!.withOpacity(0.1),
            //           Colors.yellowAccent[100]!.withOpacity(0.2)
            //           // Color(0xfffbfbfb),
            //           // Color(0xfff7f7f7),
            //         ],
            //         begin: Alignment.topCenter,
            //         end: Alignment.bottomCenter,
            //       ),
            //     ),
            //   ),
            // ),
            _body(context),
          ],
        )
            // :
            // // authState.setInitialScreen(authState.user)
            // authState.authStatus.value == AuthStatus.NOT_LOGGED_IN
            //     ? const
            //         //AddDataBaseCollectionsApi()
            //         WelcomePage()
            //     : HomePage()),
            ));
  }
}

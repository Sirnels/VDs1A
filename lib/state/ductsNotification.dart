// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart'
//     as local;
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:rxdart/rxdart.dart';
// import 'package:viewducts/page/homePage.dart';
import 'package:viewducts/state/appState.dart';
// import 'package:viewducts/state/stateController.dart';

///  *********************************************
///     NOTIFICATION CONTROLLER
///  *********************************************
///
class DuctNotificationController extends AppState {
  static DuctNotificationController instance =
      Get.find<DuctNotificationController>();
  // static ReceivedAction? initialAction;
  // String _firebaseToken = '';
  // String get firebaseToken => _firebaseToken;

  // String _nativeToken = '';
  // String get nativeToken => _nativeToken;
  // static final _appNotification = local.FlutterLocalNotificationsPlugin();
  // static final onNotification = BehaviorSubject<String?>();
  // static Future init() async {
  //   final settings = local.InitializationSettings();
  //   final details = await _appNotification.getNotificationAppLaunchDetails();
  //   if (details != null && details.didNotificationLaunchApp) {
  //     onNotification.add(details.payload);
  //   }
  //   await _appNotification.initialize(settings,
  //       onSelectNotification: (payload) async {
  //     onNotification.add(payload ?? '');
  //   });
  // }

  // ///  *********************************************
  // ///     INITIALIZATIONS
  // ///  *********************************************
  // ///
  // static Future<void> initializeLocalNotifications() async {
  //   await AwesomeNotifications().initialize(
  //       'resource://drawable/res_logo', //'resource://drawable/res_app_icon',//
  //       [
  //         NotificationChannel(
  //           channelKey: 'basic_channel',
  //           channelName: 'Notifications',
  //           channelDescription: 'Notification',
  //           playSound: true,
  //           onlyAlertOnce: true,
  //           groupAlertBehavior: GroupAlertBehavior.Children,
  //           importance: NotificationImportance.High,
  //           defaultPrivacy: NotificationPrivacy.Private,
  //           defaultColor: CupertinoColors.systemYellow,
  //           ledColor: CupertinoColors.systemYellow,
  //         )
  //       ],
  //       debug: true);

  //   // Get initial notification action is optional
  //   initialAction = await AwesomeNotifications()
  //       .getInitialNotificationAction(removeFromActionEvents: false);
  // }

  // ///  *********************************************
  // ///     NOTIFICATION EVENTS LISTENER
  // ///  *********************************************
  // ///  Notifications events are only delivered after call this method
  // static Future<void> startListeningNotificationEvents() async {
  //   AwesomeNotifications()
  //       .setListeners(onActionReceivedMethod: onActionReceivedMethod);
  // }

  // ///  *********************************************
  // ///     NOTIFICATION EVENTS
  // ///  *********************************************
  // ///
  // @pragma('vm:entry-point')
  // static Future<void> onActionReceivedMethod(
  //     ReceivedAction receivedAction) async {
  //   if (receivedAction.actionType == ActionType.SilentAction ||
  //       receivedAction.actionType == ActionType.SilentBackgroundAction) {
  //     // For background actions, you must hold the execution until the end
  //     print(
  //         'Message sent via notification input: "${receivedAction.buttonKeyInput}"');
  //     await executeLongTaskInBackground();
  //   } else {
  //     Get.offAll(() => HomePage());
  //     // MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
  //     //     '/notification-page',
  //     //         (route) =>
  //     //     (route.settings.name != '/notification-page') || route.isFirst,
  //     //     arguments: receivedAction);
  //   }
  // }

  // ///  *********************************************
  // ///     REQUESTING NOTIFICATION PERMISSIONS
  // ///  *********************************************
  // ///
  // static Future<bool> displayNotificationRationale() async {
  //   bool userAuthorized = false;
  //   BuildContext context = Get.context!;
  //   // MyApp.navigatorKey.currentContext!;
  //   await showDialog(
  //       context: Get.context!,
  //       builder: (BuildContext ctx) {
  //         return AlertDialog(
  //           title: Text('Get Notified!',
  //               style: Theme.of(context).textTheme.titleLarge),
  //           content: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Row(
  //                 children: [
  //                   Expanded(
  //                     child: Image.asset(
  //                       'assets/notification-bell.png',
  //                       height: MediaQuery.of(context).size.height * 0.3,
  //                       fit: BoxFit.fitWidth,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 20),
  //               const Text(
  //                   'Allow ViewDucts to send you beautiful notifications!'),
  //             ],
  //           ),
  //           actions: [
  //             TextButton(
  //                 onPressed: () {
  //                   Navigator.of(ctx).pop();
  //                 },
  //                 child: Text(
  //                   'Deny',
  //                   style: Theme.of(context)
  //                       .textTheme
  //                       .titleLarge
  //                       ?.copyWith(color: Colors.red),
  //                 )),
  //             TextButton(
  //                 onPressed: () async {
  //                   userAuthorized = true;
  //                   Navigator.of(ctx).pop();
  //                 },
  //                 child: Text(
  //                   'Allow',
  //                   style: Theme.of(context)
  //                       .textTheme
  //                       .titleLarge
  //                       ?.copyWith(color: Colors.deepPurple),
  //                 )),
  //           ],
  //         );
  //       });
  //   return userAuthorized &&
  //       await AwesomeNotifications().requestPermissionToSendNotifications();
  // }

  // ///  *********************************************
  // ///     BACKGROUND TASKS TEST
  // ///  *********************************************
  // static Future<void> executeLongTaskInBackground() async {
  //   print("starting long task");
  //   await Future.delayed(const Duration(seconds: 4));
  //   final url = Uri.parse("http://google.com");
  //   final re = await http.get(url);
  //   print(re.body);
  //   print("long task done");
  // }

  // ///  *********************************************
  // ///     NOTIFICATION CREATION METHODS
  // ///  *********************************************
  // ///
  // static Future<void> createNewNotification(FcmSilentData message) async {
  //   bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  //   if (!isAllowed) isAllowed = await displayNotificationRationale();
  //   if (!isAllowed) return;

  //   await AwesomeNotifications().createNotification(
  //       content: NotificationContent(
  //           id:
  //               // notification.hashCode,
  //               DateTime.now().microsecondsSinceEpoch.remainder(1000000),
  //           channelKey: 'basic_channel',
  //           title: message.data!["title"],
  //           body: message.data!["body"],
  //           // notificationLayout: NotificationLayout.Messaging,
  //           showWhen: true,
  //           displayOnBackground: true,
  //           backgroundColor: Color(0xFFF3BB1C),
  //           color: Color(0xFFF3BB1C),
  //           roundedLargeIcon: true,
  //           category: NotificationCategory.Message,
  //           summary: message.data!['senderId'],
  //           largeIcon: message.data!['messageType'] == 'order'
  //               ? "asset://assets/online-shopping.png"
  //               : message.data!["senderPicture"]),
  //       //  NotificationContent(
  //       //     id: -1, // -1 is replaced by a random number
  //       //     channelKey: 'alerts',
  //       //     title: 'Huston! The eagle has landed!',
  //       //     body:
  //       //         "A small step for a man, but a giant leap to Flutter's community!",
  //       //     bigPicture: 'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
  //       //     largeIcon: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
  //       //     //'asset://assets/images/balloons-in-sky.jpg',
  //       //     notificationLayout: NotificationLayout.BigPicture,
  //       //     payload: {'notificationId': '1234567890'}),
  //       actionButtons: [
  //         // NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
  //         NotificationActionButton(
  //             key: 'REPLY',
  //             label: 'Reply Message',
  //             requireInputText: true,
  //             actionType: ActionType.SilentAction),
  //         NotificationActionButton(
  //             key: 'DISMISS',
  //             label: 'Dismiss',
  //             actionType: ActionType.DismissAction,
  //             isDangerousOption: true)
  //       ]);
  // }

  // Future<void> initializeRemoteNotifications({required bool debug}) async {
  //   await Firebase.initializeApp();
  //   await AwesomeNotificationsFcm().initialize(
  //       onFcmSilentDataHandle: mySilentDataHandle,
  //       onFcmTokenHandle: myFcmTokenHandle,
  //       onNativeTokenHandle: myNativeTokenHandle,
  //       licenseKey:
  //           'B3J3yxQbzzyz0KmkQR6rDlWB5N68sTWTEMV7k9HcPBroUh4RZ/Og2Fv6Wc/lE'
  //           '2YaKuVY4FUERlDaSN4WJ0lMiiVoYIRtrwJBX6/fpPCbGNkSGuhrx0Rekk'
  //           '+yUTQU3C3WCVf2D534rNF3OnYKUjshNgQN8do0KAihTK7n83eUD60=',
  //       // On this example app, the app ID / Bundle Id are different
  //       // for each platform, so i used the main Bundle ID + 1 variation
  //       // [
  //       //     // me.carda.awesomeNotificationsFcmExample
  //       //     'B3J3yxQbzzyz0KmkQR6rDlWB5N68sTWTEMV7k9HcPBroUh4RZ/Og2Fv6Wc/lE'
  //       //     '2YaKuVY4FUERlDaSN4WJ0lMiiVoYIRtrwJBX6/fpPCbGNkSGuhrx0Rekk'
  //       //     '+yUTQU3C3WCVf2D534rNF3OnYKUjshNgQN8do0KAihTK7n83eUD60=',

  //       //     // me.carda.awesome_notifications_fcm_example
  //       //     'UzRlt+SJ7XyVgmD1WV+7dDMaRitmKCKOivKaVsNkfAQfQfechRveuKblFnCp4'
  //       //     'zifTPgRUGdFmJDiw1R/rfEtTIlZCBgK3Wa8MzUV4dypZZc5wQIIVsiqi0Zhaq'
  //       //     'YtTevjLl3/wKvK8fWaEmUxdOJfFihY8FnlrSA48FW94XWIcFY=',
  //       // ],
  //       debug: debug);
  // }
  // //  static Future<void> startListeningNotificationEvents() async {
  // //   AwesomeNotifications()
  // //       .setListeners(onActionReceivedMethod: onActionReceivedMethod);
  // // }

  // ///  *********************************************
  // ///     LOCAL NOTIFICATION EVENTS
  // ///  *********************************************

  // static Future<void> getInitialNotificationAction() async {
  //   ReceivedAction? receivedAction = await AwesomeNotifications()
  //       .getInitialNotificationAction(removeFromActionEvents: true);
  //   if (receivedAction == null) return;

  //   // Fluttertoast.showToast(
  //   //     msg: 'Notification action launched app: $receivedAction',
  //   //   backgroundColor: Colors.deepPurple
  //   // );
  //   print('Notification action launched app: $receivedAction');
  // }

  // // @pragma('vm:entry-point')
  // // static Future<void> onActionReceivedMethod(
  // //     ReceivedAction receivedAction) async {
  // //   MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
  // //       '/notification-page',
  // //       (route) =>
  // //           (route.settings.name != '/notification-page') || route.isFirst,
  // //       arguments: receivedAction);
  // // }

  // ///  *********************************************
  // ///     REMOTE NOTIFICATION EVENTS
  // ///  *********************************************

  // /// Use this method to execute on background when a silent data arrives
  // /// (even while terminated)
  // @pragma("vm:entry-point")
  // static Future<void> mySilentDataHandle(FcmSilentData silentData) async {
  //   Fluttertoast.showToast(
  //       msg: 'Silent data received',
  //       backgroundColor: CupertinoColors.systemYellow,
  //       textColor: CupertinoColors.darkBackgroundGray,
  //       fontSize: 16);

  //   print('"SilentData": ${silentData.toString()}');

  //   if (silentData.createdLifeCycle != NotificationLifeCycle.Foreground) {
  //     print("bg");
  //   } else {
  //     print("FOREGROUND");
  //   }

  //   print('mySilentDataHandle received a FcmSilentData execution');
  //   await executeLongTaskInBackground();
  // }

  // /// Use this method to detect when a new fcm token is received
  // @pragma("vm:entry-point")
  // Future<void> myFcmTokenHandle(String token) async {
  //   Fluttertoast.showToast(
  //       msg: 'token received',
  //       backgroundColor: CupertinoColors.systemYellow,
  //       textColor: CupertinoColors.darkBackgroundGray,
  //       fontSize: 16);
  //   debugPrint('Firebase Token:"${authState.userModel!.fcmToken.toString()}"');

  //   _firebaseToken = authState.userModel!.fcmToken.toString();
  //   ;
  //   //_instance.notifyListeners();
  // }

  // /// Use this method to detect when a new native token is received
  // @pragma("vm:entry-point")
  // Future<void> myNativeTokenHandle(String token) async {
  //   Fluttertoast.showToast(
  //       msg: 'Token received',
  //       backgroundColor: Colors.blueAccent,
  //       textColor: Colors.white,
  //       fontSize: 16);
  //   debugPrint('Native Token:"$token"');

  //   _nativeToken = authState.userModel!.fcmToken.toString();
  //   // _instance.notifyListeners();
  // }

  // static Future<void> scheduleNewNotification() async {
  //   bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  //   if (!isAllowed) isAllowed = await displayNotificationRationale();
  //   if (!isAllowed) return;

  //   await AwesomeNotifications().createNotification(
  //       content: NotificationContent(
  //           id: -1, // -1 is replaced by a random number
  //           channelKey: 'alerts',
  //           title: "Huston! The eagle has landed!",
  //           body:
  //               "A small step for a man, but a giant leap to Flutter's community!",
  //           bigPicture: 'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
  //           largeIcon: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
  //           //'asset://assets/images/balloons-in-sky.jpg',
  //           notificationLayout: NotificationLayout.BigPicture,
  //           payload: {
  //             'notificationId': '1234567890'
  //           }),
  //       actionButtons: [
  //         NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
  //         NotificationActionButton(
  //             key: 'DISMISS',
  //             label: 'Dismiss',
  //             actionType: ActionType.DismissAction,
  //             isDangerousOption: true)
  //       ],
  //       schedule: NotificationCalendar.fromDate(
  //           date: DateTime.now().add(const Duration(seconds: 10))));
  // }

  // static Future<void> resetBadgeCounter() async {
  //   await AwesomeNotifications().resetGlobalBadge();
  // }

  // static Future<void> cancelNotifications() async {
  //   await AwesomeNotifications().cancelAll();
  // }
}

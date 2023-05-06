import 'package:animations/animations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:flutter/widgets.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
//import 'package:package_info/package_info.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/page/message/local_database.dart';
import 'package:viewducts/page/responsiveView.dart';
import 'package:viewducts/state/stateController.dart';

class FirebaseMassagingHandler {
  FirebaseMassagingHandler._();
  // static AndroidNotificationChannel channel = const AndroidNotificationChannel(
  //   'com.viewducts.viewducts', // id
  //   'Notifications', // title
  //   description: 'Notification',
  //   importance: Importance.high,
  // );
  // static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();

  static Future<void> config() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    try {
      // UserController _userController = Get.put(UserController());
      RemoteMessage newMessage = const RemoteMessage();
      await messaging.requestPermission(
        sound: true,
        badge: true,
        alert: true,
        announcement: false,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
      );

      RemoteMessage? initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        // PayloadModel payloadRes = PayloadModel.fromJson(initialMessage.data);
        // firebasePageRouter(page: payloadRes.page!, id: payloadRes.id);
      }

      // var initializationSettingsAndroid =
      //     const AndroidInitializationSettings("res_logo");
      // var initializationSettings =
      //     InitializationSettings(android: initializationSettingsAndroid);
      // flutterLocalNotificationsPlugin.initialize(
      //   initializationSettings,
      //   onSelectNotification: (value) async {
      //     // PayloadModel payloadRes = PayloadModel.fromJson(newMessage.data);
      //     // firebasePageRouter(page: payloadRes.page!, id: payloadRes.id);
      //   },
      // );
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
              alert: true, badge: true, sound: true);

      //String? token = await FirebaseMessaging.instance.getToken();
      // _userController.token = token;
      FirebaseMessaging.onMessageOpenedApp
          .listen((RemoteMessage message) async {
        cprint("\n notification on onMessageOpenedApp function \n");
        newMessage = message;
        chatState.setChatUser = searchState.viewUserlistChatList
            .where((x) => x.userId == message.data['senderId'])
            .first;
        //}
        chatState.chatMessage.value = await SQLHelper.findLocalMessages(
            message.data['chatlistKey'].toString());
        chatState.upDateChatListMessages(
            currentUser: authState.userModel?.key,
            secondUser: message.data['senderId']);
        Get.to(() => OpenContainer(
              closedBuilder: (context, action) {
                return ChatResponsive(
                  chatIdUsers: message.data['chatlistKey'],
                  userProfileId: message.data['senderId'],
                );
              },
              openBuilder: (context, action) {
                return ChatResponsive(
                  chatIdUsers: message.data['chatlistKey'],
                  userProfileId: message.data['senderId'],
                );
              },
            ));
        // Get.to(() => ChatScreenPage(
        //     userProfileId: newMessage.senderId, chatIdUsers: message.data['']));
        // PayloadModel payloadRes = PayloadModel.fromJson(newMessage.data);
        // firebasePageRouter(
        //     page: payloadRes.page!, id: payloadRes.id, goToMain: true);
      });
      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        cprint("\n notification on onMessage function \n");
        newMessage = message;
        await _showNotification(message: newMessage);
      });
      FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
        cprint("\n notification on onBackgroundMessage function \n");
        newMessage = message;
        await _showNotification(message: newMessage);
      });
    } on Exception catch (e) {
      cprint("$e");
    }
  }

  static Future<void> _showNotification({RemoteMessage? message}) async {
    RemoteNotification? notification = message!.notification;
    AndroidNotification? androidNotification = message.notification!.android;
    AppleNotification? appleNotification = message.notification!.apple;

    if (notification != null &&
        (androidNotification != null || appleNotification != null)) {
      // flutterLocalNotificationsPlugin.show(
      //   notification.hashCode,
      //   notification.title,
      //   notification.body,
      //   NotificationDetails(
      //     android: AndroidNotificationDetails(
      //       channel.id,
      //       channel.name,
      //       icon: "res_logo",
      //       playSound: true,
      //       channelDescription: channel.description,
      //       sound:
      //           RawResourceAndroidNotificationSound('res_custom_notification'),
      //       color: Color(0xFFF3BB1C),
      //       largeIcon: message.data['senderPicture'],
      //       enableVibration: true,
      //       priority: Priority.high,
      //       channelShowBadge: true,
      //       importance: Importance.high,
      //     ),
      //     iOS: const IOSNotificationDetails(
      //       presentAlert: true,
      //       presentBadge: true,
      //       presentSound: true,
      //     ),
      //   ),
      //   payload: message.data.toString(),
      // );
    }
    // PlascoRequests().initReport();
  }

  static Future<void> firebaseMessagingBackground(RemoteMessage message) async {
    await Firebase.initializeApp();
    cprint("message data: ${message.data}");
  }
}

class DynamicLinksService {
  static Future<String> createDynamicLink(String parameter) async {
    // PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // print(packageInfo.packageName);
    // String uriPrefix = "https://flutterdevs.page.link";

    // final DynamicLinkParameters parameters = DynamicLinkParameters(
    //   uriPrefix: uriPrefix,
    //   link: Uri.parse('https://example.com/$parameter'),
    //   androidParameters: AndroidParameters(
    //     packageName: packageInfo.packageName,
    //     minimumVersion: 125,
    //   ),
    //   iosParameters: IOSParameters(
    //     bundleId: packageInfo.packageName,
    //     minimumVersion: packageInfo.version,
    //     appStoreId: '123456789',
    //   ),
    //   googleAnalyticsParameters: GoogleAnalyticsParameters(
    //     campaign: 'example-promo',
    //     medium: 'social',
    //     source: 'orkut',
    //   ),
    //   // itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
    //   //   providerToken: '123456',
    //   //   campaignToken: 'example-promo',
    //   // ),
    //   socialMetaTagParameters: SocialMetaTagParameters(
    //       title: 'Example of a Dynamic Link',
    //       description: 'This link works whether app is installed or not!',
    //       imageUrl: Uri.parse(
    //           "https://images.pexels.com/photos/3841338/pexels-photo-3841338.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260")),
    // );

    // final Uri dynamicUrl = await parameters.buildUrl();
    ShortDynamicLink? shortDynamicLink;
    //= await parameters.buildShortLink();
    final Uri shortUrl = shortDynamicLink!.shortUrl;
    return shortUrl.toString();
  }

  static void initDynamicLinks() async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();

    _handleDynamicLink(data);

    FirebaseDynamicLinks.instance.onLink.listen((dynamiclink) async {
      final Uri? deeplink = dynamiclink.link;
      cprint('testing the link');
      if (deeplink != null) {
        cprint('testing the deeplink');
        // await handleMylink(deeplink);
      } else {
        cprint('testing the view');
      }
    }, onError: (e) {
      cprint('we got an error: $e');
    }, onDone: () {
      cprint('testing the done');
    });
  }

  static _handleDynamicLink(PendingDynamicLinkData? data) async {
    final Uri? deepLink = data?.link;

    if (deepLink == null) {
      return cprint("deepLink is empty");
    } else {
      cprint("deeplink is active");
    }

    // if (deepLink.pathSegments.contains('refer')) {
    //   var title = deepLink.queryParameters['code'];
    //   if (title != null) {
    //     cprint("refercode=$title");
    //   }
    // }
  }
}

import 'package:flutter/material.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:seo_renderer/seo_renderer.dart';
import 'package:url_strategy/url_strategy.dart';
//import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/state/viewDuctsNotification.dart';
import 'src/app.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'helper/utility.dart';
import 'firebase_options.dart';

// import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   await setupFlutterNotifications();
//   showFlutterNotification(message);
//   cprint('Handling a background message: ${message.messageId}');

//   // if (!AwesomeStringUtils.isNullOrEmpty(message.notification?.title,
//   //         considerWhiteSpaceAsEmpty: true) ||
//   //     !AwesomeStringUtils.isNullOrEmpty(message.notification?.body,
//   //         considerWhiteSpaceAsEmpty: true)) {
//   //   cprint('message also contained a notification: ${message.notification}');

//   //   String? imageUrl;
//   //   imageUrl ??= message.notification!.android?.imageUrl;
//   //   imageUrl ??= message.notification!.apple?.imageUrl;

//   //   Map<String, dynamic> notificationAdapter = {
//   //     NOTIFICATION_CHANNEL_KEY: 'basic_channel',
//   //     NOTIFICATION_ID: message.data[NOTIFICATION_CONTENT]?[NOTIFICATION_ID] ??
//   //         message.messageId ??
//   //         Random().nextInt(2147483647),
//   //     NOTIFICATION_TITLE: message.data[NOTIFICATION_CONTENT]
//   //             ?[NOTIFICATION_TITLE] ??
//   //         message.notification?.title,
//   //     NOTIFICATION_BODY: message.data[NOTIFICATION_CONTENT]
//   //             ?[NOTIFICATION_BODY] ??
//   //         message.notification?.body,
//   //     NOTIFICATION_LAYOUT:
//   //         AwesomeStringUtils.isNullOrEmpty(imageUrl) ? 'Default' : 'BigPicture',
//   //     NOTIFICATION_BIG_PICTURE: imageUrl
//   //   };

//   //   AwesomeNotifications().createNotificationFromJsonData(notificationAdapter);
//   // } else {
//   //   AwesomeNotifications().createNotificationFromJsonData(message.data);
//   // }
// }

// /// Create a [AndroidNotificationChannel] for heads up notifications
// late AndroidNotificationChannel channel;
// final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// bool isFlutterLocalNotificationsInitialized = false;

// Future<void> setupFlutterNotifications() async {
//   // AwesomeNotifications().initialize('resource://drawable/res_logo', [
//   //   NotificationChannel(
//   //       //channelGroupKey: 'basic_tests',
//   //       channelKey: 'basic_channel',
//   //       channelName: 'Notifications',
//   //       channelDescription: 'Notification',
//   //       channelShowBadge: true,
//   //       // defaultColor: Color(0xFFF3BB1C),
//   //       importance: NotificationImportance.High,
//   //       soundSource: 'resource://raw/res_custom_notification'
//   //       // ledColor: Colors.yellow
//   //       ),
//   // ]);
//   if (isFlutterLocalNotificationsInitialized) {
//     return;
//   }
//   channel = const AndroidNotificationChannel(
//     'basic_channel', // id
//     'Notifications', // title
//     description: 'Notification', // description
//     importance: Importance.high,
//   );

//   /// Create an Android Notification Channel.
//   ///
//   /// We use this channel in the `AndroidManifest.xml` file to override the
//   /// default FCM channel to enable heads up notifications.
//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);

//   /// Update the iOS foreground notification presentation options to allow
//   /// heads up notifications.
//   await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
//   isFlutterLocalNotificationsInitialized = true;
// }

// //resource://raw/res_custom_notification
// void showFlutterNotification(RemoteMessage message) {
//   RemoteNotification? notification = message.notification;
//   authState.messageFirebase = message;
//   AndroidNotification? android = message.notification?.android;

//   if (notification != null && android != null && !kIsWeb ||
//       notification!.apple != null) {
//     // AwesomeNotifications().createNotification(
//     //     content: NotificationContent(
//     //         id: notification.hashCode,
//     //         // DateTime.now().microsecondsSinceEpoch.remainder(1000000),
//     //         channelKey: 'basic_channel',
//     //         title: "${notification.title}",
//     //         body: notification.body,
//     //         // notificationLayout: NotificationLayout.Messaging,
//     //         showWhen: true,
//     //         displayOnBackground: true,
//     //         backgroundColor: Color(0xFFF3BB1C),
//     //         color: Color(0xFFF3BB1C),
//     //         roundedLargeIcon: true,
//     //         category: NotificationCategory.Message,
//     //         summary: message.data['senderId'],
//     //         largeIcon: message.data['messageType'] == 'order'
//     //             ? "asset://assets/online-shopping.png"
//     //             : message.data["senderPicture"]));
//     flutterLocalNotificationsPlugin.show(
//       0,
//       notification.title,
//       notification.body,
//       payload: message.data['senderId'].toString(),
//       NotificationDetails(
//           android: AndroidNotificationDetails(channel.id, channel.name,
//               channelDescription: channel.description,
//               sound: RawResourceAndroidNotificationSound(
//                   'res_custom_notification'),
//               icon: 'res_logo',
//               color: Color(0xFFF3BB1C),
//               largeIcon: message.data['senderPicture'],
//               channelShowBadge: true),
//           iOS: IOSNotificationDetails(sound: 'res_custom_notification.m4a'),
//           macOS: MacOSNotificationDetails(),
//           linux: LinuxNotificationDetails()),
//     );
//   }
// }

void main() async {
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.

  // final settingsController = SettingsController(SettingsService());
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(
    FirebaseMassagingHandler.firebaseMessagingBackground,
  );
  if (!kIsWeb) {
    // FirebaseMassagingHandler.flutterLocalNotificationsPlugin
    //     .resolvePlatformSpecificImplementation<
    //         AndroidFlutterLocalNotificationsPlugin>()!
    //     .createNotificationChannel(FirebaseMassagingHandler.channel);
  }

  setPathUrlStrategy();
  DynamicLinksService.initDynamicLinks();
  runApp(ProviderScope(child: RobotDetector(child: MyApp())));
}





















// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Invoke "debug painting" (press "p" in the console, choose the
//           // "Toggle Debug Paint" action from the Flutter Inspector in Android
//           // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//           // to see the wireframe for each widget.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }

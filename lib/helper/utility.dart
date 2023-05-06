// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
//import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:viewducts/helper/constant.dart';
import 'package:viewducts/helper/enum.dart';
import 'package:viewducts/state/authState.dart';
//import 'package:viewducts/widgets/customWidgets.dart';
import 'dart:developer' as developer;

import 'package:viewducts/widgets/newWidget/customLoader.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:crypto/crypto.dart';

import 'package:ntp/ntp.dart';
//import 'package:sentry/sentry.dart';
import 'dart:convert';
import 'dart:math';
// import 'package:image/image.dart' as Im;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:appwrite/appwrite.dart';

final FirebaseAnalytics kAnalytics = FirebaseAnalytics.instance;
final FirebaseFirestore vDatabase = FirebaseFirestore.instance;
final DatabaseReference kDatabase = FirebaseDatabase.instance.ref();
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
final Future<FirebaseApp> initialization = Firebase.initializeApp();
// final endPoint = 'http://10.0.2.2/v1';
// final projectID = '6294ee161c2975bd19ba';
final kScreenloader = CustomLoader();
final bankAccounts = '62fae0c6b900b22e9dac';
final govementData = '63206b02d47f0e88b5d9';
final productBucketId = '62e4e64b558fc499a8e6';
final profileImageBudgetId = '62e4e6778b35ca7e7c27';
final productReviews = '63a35533758591963598';
final ductFile = '62e4e604ccef714f5637';
final procold = '62e4e35f491bdc0366af';
final dctCollid = '62e4e35d7fab7fcc38b4';
final storyCollId = '62e4e3611f8bdfc52ac9';
final storyChtsId = "62e4e36308409f35a36f";
final storyuserviews = "62e4e36473def0753c65";
final profileUserColl = '62e4e36979f06dade37d';
final heartLikes = "62e4e365ea69de91c05e";
final mainUserViews = "62e4e36b16fa3f5b33e7";
final chatsColl = "634f143fe24dd364e85b";
final ductImageColid = "62e4e604ccef714f5637";
final keyWordsColl = "62e4e382d97a12f3e673";
//final keyWords = "62e4e382d97a12f3e673";
final countryColl = "62e4e380e6c7b10775ff";
final databaseId = '62e0a9bd1081c368da0e';
final projectId = '62e0a2f7680479a72579';
final sectionCollection = "62e4e3742b1e36b1a5f1";
final typeCollection = '62e4e37657e211963821';
final fashionCollection = '62e4e36e1a49c4dbfb8e';
final childrenCollection = '62e4e36c55bb74aff308';
final electronicsCollection = '62e4e370b75d74d8999d';
final groceryCollection = '62e4e37247a8dd5ec930';
final booksCollection = '62e944f661ff02bc028a';
final housingCollection = '62e944f8d4e10026aec9';
final farmCollection = '62e960845db3584e26aa';
final carsCollection = '62e952ecbf185d868220';
final shoppingCartCollection = '62e4e37b49246b08da55';
final shippingAdress = '62e4efbd0d2c9e6688ef';
final userOrdersCollection = '62e4e38ebfa432fc40e6';
final initPayment = '62e4e391db8003fd00a9';
final orderStateCollection = '62e4e38b6a3eabbb8153';
final chatDatabase = '63bdac43682fabef2540';
final chipperCash = '62e4e39744ee4ef4c20f';
final cdarPay = "634189e95e8a6d44a655";
final paymentsMethods = "62f125d04e448dcb2cf5";
final paymentActivate = '630eb73a077165fd31f0';
final unPaidcommision = '62e4e39a88b791ff1e5f';
final monthlycommisionPayment = '6312827c0822de9ac227';
final announcementColl = '631cfc654b7a125d9176';
final fincraVirtualAccColl = '63039302c4b8d9d03987';
final fincraSubAccColl = '63039349ea9631525341';
final fincraTransaction = '63203ed99295e5eaeabc';
final playAppStoreColl = '6328262c8ea2e82efb76';
final wasabiAcesss = 'awsWasabiApi';
final chatsMedia = "6330beaa550c79f360ea";
final chatActiveColl = "633551e84b05311f3008";
final vendorColl = "63389c4fa098a765f235";
final staffColl = "6338c6b97f479f2a1fcc";
final oficialNameColl = "633b025451d82bb960cc";
final authTypeColl = "633c023327a3556bfd0f";
final policyColl = "633b2cdde8db2634160b";
final orderTransactionModel = "62eef40972d4b1bb2103";
final exchangeRateColl = '6345dbea491c4cf8bb99';
final sellersVendors = '63389c4fa098a765f235';
final subscrptionColl = '6388e754af560e82b8b4';
clientConnect() {
  final client = Client();
  client
      .addHeader("Access-Control-Allow-Origin", "*")
      .setEndpoint('https://6357.viewducts.com/v1') // Your Appwrite Endpoint
      .setProject(projectId);

  return client;
}

String getPostTime2(String? date) {
  if (date == null || date.isEmpty) {
    return '';
  }
  var dt = DateTime.parse(date).toLocal();
  var dat =
      DateFormat.jm().format(dt) + ' - ' + DateFormat("dd MMM yy").format(dt);
  return dat;
}

const Color darkAccent = Color.fromRGBO(160, 160, 160, 1);
const Color lightAccent = Color.fromRGBO(90, 90, 90, 1);

const Color darkBackground = Color.fromRGBO(66, 66, 66, 0.95);
const Color lightBackground = Color.fromRGBO(220, 220, 220, 0.95);
String getdob(String? date) {
  if (date == null || date.isEmpty) {
    return 'Date of Birth';
  }
  var dt = DateTime.parse(date).toLocal();
  var dat = DateFormat.yMMMd().format(dt);
  return dat;
}

String getJoiningDate(String? date) {
  if (date == null || date.isEmpty) {
    return '';
  }
  var dt = DateTime.parse(date).toLocal();
  var dat = DateFormat("MMMM yyyy").format(dt);
  return 'Joined $dat';
}

String getChatTime(String? date) {
  if (date == null || date.isEmpty) {
    return '';
  }
  var dt = DateTime.parse(date).toLocal();
  var dat = DateFormat.jm().format(dt);
  return dat;
  // if (date == null || date.isEmpty) {
  //   return '';
  // }
  // String msg = '';
  // var dt = DateTime.parse(date).toLocal();

  // if (DateTime.now().toLocal().isBefore(dt)) {
  //   return DateFormat.jm().format(DateTime.parse(date).toLocal()).toString();
  // }

  // var dur = DateTime.now().toLocal().difference(dt);
  // if (dur.inDays > 0) {
  //   msg = '${dur.inDays} d';
  //   return dur.inDays == 1 ? '1d' : DateFormat("dd MMM").format(dt);
  // } else if (dur.inHours > 0) {
  //   msg = '${dur.inHours} h';
  // } else if (dur.inMinutes > 0) {
  //   msg = '${dur.inMinutes} m';
  // } else if (dur.inSeconds > 0) {
  //   msg = '${dur.inSeconds} s';
  // } else {
  //   msg = 'now';
  // }
  // return msg;
}

String getPollTime(String date) {
  int hr, mm;
  String msg = 'Poll ended';
  var enddate = DateTime.parse(date);
  if (DateTime.now().isAfter(enddate)) {
    return msg;
  }
  msg = 'Poll ended in';
  var dur = enddate.difference(DateTime.now());
  hr = dur.inHours - dur.inDays * 24;
  mm = dur.inMinutes - (dur.inHours * 60);
  if (dur.inDays > 0) {
    msg = ' ' + dur.inDays.toString() + (dur.inDays > 1 ? ' Days ' : ' Day');
  }
  if (hr > 0) {
    msg += ' ' + hr.toString() + ' hour';
  }
  if (mm > 0) {
    msg += ' ' + mm.toString() + ' min';
  }
  return (dur.inDays).toString() +
      ' Days ' +
      ' ' +
      hr.toString() +
      ' Hours ' +
      mm.toString() +
      ' min';
}

String? getSocialLinks(String url) {
  if (url.isNotEmpty) {
    url = url.contains("https://www") || url.contains("http://www")
        ? url
        : url.contains("www") &&
                (!url.contains('https') && !url.contains('http'))
            ? 'https://' + url
            : 'https://www.' + url;
  } else {
    return null;
  }
  cprint('Launching URL : $url');
  return url;
}

launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    cprint('Could not launch $url');
  }
}

void cprint(dynamic data, {String? errorIn, String? event}) {
  if (errorIn != null) {
    if (kDebugMode) {
      print(
          '****************************** error ******************************');
    }
    developer.log('[Error]', time: DateTime.now(), error: data, name: errorIn);
    if (kDebugMode) {
      print(
          '****************************** error ******************************');
    }
  } else if (data != null) {
    developer.log(
      data,
      time: DateTime.now(),
    );
  }
  if (event != null) {
    // logEvent(event);
  }
}

void logEvent(String event, {Map<String?, dynamic>? parameter}) {
  kReleaseMode
      ? kAnalytics.logEvent(
          name: event, parameters: parameter as Map<String, Object?>?)
      // ignore: avoid_print
      : cprint("[EVENT]: $event");
}

void debugLog(String log, {dynamic param = ""}) {
  final String time = DateFormat("mm:ss:mmm").format(DateTime.now());
  if (kDebugMode) {
    cprint("[$time][Log]: $log, $param");
  }
}

void share(String message, {String? subject}) {
  // Share.share(message, subject: subject);
}

List<String?> getHashTags(String text) {
  RegExp reg = RegExp(
      r"([#])\w+|(https?|ftp|file|#)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]*");
  Iterable<Match> _matches = reg.allMatches(text);
  List<String?> resultMatches = <String?>[];
  for (Match match in _matches) {
    if (match.group(0)!.isNotEmpty) {
      var tag = match.group(0);
      resultMatches.add(tag);
    }
  }
  return resultMatches;
}

String getUserName({
  required String id,
  required String name,
}) {
  String userName = '';
  if (name.length > 15) {
    name = name.substring(0, 6);
  }
  name = name.split(' ')[0];
  id = id.substring(0, 4).toLowerCase();
  userName = '@$name$id';
  return userName;
}

bool validateCredentials(String email, String password) {
  if (email.isEmpty) {
    Get.snackbar("Email", 'Please enter email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100);
    // customSnackBar(_scaffoldKey, 'Please enter email id');
    return false;
  } else if (password.isEmpty) {
    Get.snackbar("Password", 'Please enter password ',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100);
    // customSnackBar(_scaffoldKey, 'Please enter password');
    return false;
  } else if (password.length < 8) {
    Get.snackbar("Password", 'Password must be at least 8 character long',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100);
    // customSnackBar(_scaffoldKey, 'Password must me 8 character long');
    return false;
  }

  var status = validateEmal(email);
  if (!status) {
    Get.snackbar("Email", 'Please Enter a valid email id ',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100);
    // customSnackBar(_scaffoldKey, 'Please enter valid email id');
    return false;
  }
  return true;
}

bool validateEmal(String email) {
  String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regExp = RegExp(p);

  var status = regExp.hasMatch(email);
  return status;
}

class ViewDucts {
  // static final SentryClient _sentry = SentryClient(
  //     dsn:
  //         "https://e96f914599044d00a8243f83752be697@o456060.ingest.sentry.io/5448546");

  static bool get isInDebugMode {
    // Assume you're in production mode
    bool inDebugMode = false;

    // Assert expressions are only evaluated during development. They are ignored
    // in production. Therefore, this code only sets `inDebugMode` to true
    // in a development environment.
    assert(inDebugMode = true);

    return inDebugMode;
  }

  static Future<void> reportError(dynamic error, dynamic stackTrace) async {
    // Print the exception to the console
    if (kDebugMode) {
      print('Caught error: $error');
    }
    if (isInDebugMode) {
      // Print the full stacktrace in debug mode
      if (kDebugMode) {
        print(stackTrace);
      }
      return;
    } else {
      // Send the Exception and Stacktrace to Sentry in Production mode
      // await _sentry.captureException(
      //   exception: error,
      //   stackTrace: stackTrace,
      // );
    }
  }

  static String? getNickname(Map<String, dynamic> user) =>
      user[ALIAS_NAME] ?? user[NICKNAME];

  static void toast(String message) {
    // Fluttertoast.showToast(
    //     msg: message,
    //     backgroundColor: viewductBlack.withOpacity(0.95),
    //     textColor: viewductWhite);
  }

  // static void internetLookUp() {
  //   try {
  //     InternetAddress.lookup('https://www.google.com').catchError((e) {
  //       ViewDucts.toast('No internet connection.');
  //       cprint('No internet Connection');
  //     });
  //   } catch (_) {
  //     ViewDucts.toast('No internet connection.');
  //   }
  // }

  static void invite() {
    // Share.share(
    //     'Let\'s chat on ViewDucts, join me at - https://play.google.com/store/apps/details?id=com.viewducts.app');
  }

  static Widget avatar(Map<String, dynamic> user,
      {File? image, double radius = 22.5}) {
    if (image == null) {
      if (user[ALIAS_AVATAR] == null) {
        return (user[PHOTO_URL] ?? '').isNotEmpty
            ? CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(user[PHOTO_URL]),
                radius: radius)
            : CircleAvatar(
                backgroundColor: viewductBlue,
                foregroundColor: Colors.white,
                child: Text(getInitials(ViewDucts.getNickname(user)!)),
                radius: radius,
              );
      }
      return CircleAvatar(
        backgroundImage: Image.file(File(user[ALIAS_AVATAR])).image,
        radius: radius,
      );
    }
    return CircleAvatar(
        backgroundImage: Image.file(image).image, radius: radius);
  }

  static Future<int> getNTPOffset() {
    return NTP.getNtpOffset();
  }

  static Widget getNTPWrappedWidget(Widget child) {
    return FutureBuilder(
        future: NTP.getNtpOffset(),
        builder: (context, AsyncSnapshot<int> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            if (snapshot.data! > const Duration(minutes: 1).inMilliseconds ||
                snapshot.data! < -const Duration(minutes: 1).inMilliseconds) {
              return const Material(
                  color: viewductBlack,
                  child: Center(
                      child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.0),
                          child: Text(
                            "Your clock time is out of sync with the server time. Please set it right to continue.",
                            style:
                                TextStyle(color: viewductWhite, fontSize: 18),
                          ))));
            }
          }
          return child;
        });
  }

  static void showRationale(rationale) async {
    ViewDucts.toast(rationale);
    await Future.delayed(const Duration(seconds: 2));
    ViewDucts.toast(
        'If you change your mind, you can grant the permission through App Settings > Permissions');
  }

  // static Future<bool> checkAndRequestPermission(PermissionGroup permission) {
  //   Completer<bool> completer = new Completer<bool>();
  //   PermissionHandler().checkPermissionStatus(permission).then((status) {
  //     if (status != PermissionStatus.granted) {
  //       PermissionHandler().requestPermissions([permission]).then((_status) {
  //         bool granted = _status.values.first == PermissionStatus.granted;
  //         completer.complete(granted);
  //       });
  //     } else
  //       completer.complete(true);
  //   });
  //   return completer.future;
  // }

  static String getInitials(String name) {
    try {
      List<String> names =
          name.trim().replaceAll(RegExp(r'[\W]'), '').toUpperCase().split(' ');
      names.retainWhere((s) => s.trim().isNotEmpty);
      if (names.length >= 2) {
        return names.elementAt(0)[0] + names.elementAt(1)[0];
      } else if (names.elementAt(0).length >= 2) {
        return names.elementAt(0).substring(0, 2);
      } else {
        return names.elementAt(0)[0];
      }
    } catch (e) {
      return '?';
    }
  }

  static String getChatId(String? currentUserNo, String? peerNo) {
    if (currentUserNo.hashCode <= peerNo.hashCode) {
      return '$currentUserNo-$peerNo';
    }
    return '$peerNo-$currentUserNo';
  }

  static AuthenticationType getAuthenticationType(
      bool biometricEnabled, AuthState model) {
    if (biometricEnabled && model.userModel!.userId != null) {
      return AuthenticationType.values[model.userModel!.authenticationType!];
    }
    return AuthenticationType.passcode;
  }

  static ChatStatus getChatStatus(int index) => ChatStatus.values[index];

  static String normalizePhone(String phone) =>
      phone.replaceAll(RegExp(r"\s+\b|\b\s"), "");

  static String getHashedAnswer(String answer) {
    answer = answer.toLowerCase().replaceAll(RegExp(r"[^a-z0-9]"), "");
    var bytes = utf8.encode(answer); // data being hashed
    Digest digest = sha1.convert(bytes);
    return digest.toString();
  }

  static String getHashedString(String str) {
    var bytes = utf8.encode(str); // data being hashed
    Digest digest = sha1.convert(bytes);
    return digest.toString();
  }
}

class Utils {
  static String getUsername(String email) {
    return "live:${email.split('@')[0]}";
  }

  static String getInitials(String name) {
    List<String> nameSplit = name.split(" ");
    String firstNameInitial = nameSplit[0][0];
    String lastNameInitial = nameSplit[1][0];
    return firstNameInitial + lastNameInitial;
  }

  // this is new

  static Future<PickedFile> pickImage({required ImageSource source}) async {
    PickedFile? selectedImage = await ImagePicker().getImage(source: source);
    return await compressImage(selectedImage);
  }

  static Future<PickedFile> compressImage(PickedFile? imageToCompress) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Random().nextInt(10000);

    // Im.Image image = Im.decodeImage(imageToCompress.readAsBytesSync());
    // Im.copyResize(image, width: 500, height: 500);

    return PickedFile('$path/img_$rand.jpg');
    //..writeAsBytesSync(Im.encodeJpg(image, quality: 85));
  }

  static int stateToNum(UserState userState) {
    switch (userState) {
      case UserState.Offline:
        return 0;

      case UserState.Online:
        return 1;

      default:
        return 2;
    }
  }

  static UserState numToState(int number) {
    switch (number) {
      case 0:
        return UserState.Offline;

      case 1:
        return UserState.Online;

      default:
        return UserState.Waiting;
    }
  }

  static String formatDateString(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    var formatter = DateFormat('dd/MM/yy');
    return formatter.format(dateTime);
  }
}

class Permissions {
  // static Future<bool> cameraAndMicrophonePermissionsGranted() async {
  //   PermissionStatus cameraPermissionStatus = await _getCameraPermission();
  //   PermissionStatus microphonePermissionStatus =
  //       await _getMicrophonePermission();

  //   if (cameraPermissionStatus == PermissionStatus.granted &&
  //       microphonePermissionStatus == PermissionStatus.granted) {
  //     return true;
  //   } else {
  //     _handleInvalidPermissions(
  //         cameraPermissionStatus, microphonePermissionStatus);
  //     return false;
  //   }
  // }

  // // static Future<PermissionStatus> _getCameraPermission() async {
  // //   PermissionStatus permission =
  // //       await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
  // //   if (permission != PermissionStatus.granted &&
  // //       permission != PermissionStatus.disabled) {
  // //     Map<PermissionGroup, PermissionStatus> permissionStatus =
  // //         await PermissionHandler()
  // //             .requestPermissions([PermissionGroup.camera]);
  // //     return permissionStatus[PermissionGroup.camera] ??
  // //         PermissionStatus.unknown;
  // //   } else {
  // //     return permission;
  // //   }

  // // }

  // static Future<PermissionStatus> _getMicrophonePermission() async {
  //   PermissionStatus permission = await PermissionHandler()
  //       .checkPermissionStatus(PermissionGroup.microphone);
  //   if (permission != PermissionStatus.granted &&
  //       permission != PermissionStatus.disabled) {
  //     Map<PermissionGroup, PermissionStatus> permissionStatus =
  //         await PermissionHandler()
  //             .requestPermissions([PermissionGroup.microphone]);
  //     return permissionStatus[PermissionGroup.microphone] ??
  //         PermissionStatus.unknown;
  //   } else {
  //     return permission;
  //   }
  // }

  // static void _handleInvalidPermissions(
  //   PermissionStatus cameraPermissionStatus,
  //   PermissionStatus microphonePermissionStatus,
  // ) {
  //   if (cameraPermissionStatus == PermissionStatus.denied &&
  //       microphonePermissionStatus == PermissionStatus.denied) {
  //     throw new PlatformException(
  //         code: "PERMISSION_DENIED",
  //         message: "Access to camera and microphone denied",
  //         details: null);
  //   }
  //   //  else if (cameraPermissionStatus == PermissionStatus.disabled &&
  //   //     microphonePermissionStatus == PermissionStatus.disabled) {
  //   //   throw new PlatformException(
  //   //       code: "PERMISSION_DISABLED",
  //   //       message: "Location data is not available on device",
  //   //       details: null);
  //   // }
  // }
}

class Util {
  static String getUsername(String email) {
    return "live:${email.split('@')[0]}";
  }

  static String getInitials(String name) {
    List<String> nameSplit = name.split(" ");
    String firstNameInitial = nameSplit[0][0];
    String lastNameInitial = nameSplit[1][0];
    return firstNameInitial + lastNameInitial;
  }

  // this is new

  static Future<PickedFile> pickImage({required ImageSource source}) async {
    PickedFile? selectedImage = await ImagePicker().getImage(source: source);
    return await compressImage(selectedImage);
  }

  static Future<PickedFile> compressImage(PickedFile? imageToCompress) async {
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    int rand = Random().nextInt(10000);

    // Im.Image image = Im.decodeImage(imageToCompress.readAsBytesSync());
    // Im.copyResize(image, width: 500, height: 500);

    return PickedFile('$path/img_$rand.jpg');
    // ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));
  }

  static int stateToNum(UserState userState) {
    switch (userState) {
      case UserState.Offline:
        return 0;

      case UserState.Online:
        return 1;

      default:
        return 2;
    }
  }

  static UserState numToState(int number) {
    switch (number) {
      case 0:
        return UserState.Offline;

      case 1:
        return UserState.Online;

      default:
        return UserState.Waiting;
    }
  }

  static String formatDateString(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    var formatter = DateFormat('dd/MM/yy');
    return formatter.format(dateTime);
  }
}

Map<String, dynamic> readAndroidBuildData(AndroidDeviceInfo build) {
  return <String, dynamic>{
    'version.securityPatch': build.version.securityPatch,
    'version.sdkInt': build.version.sdkInt,
    'version.release': build.version.release,
    'version.previewSdkInt': build.version.previewSdkInt,
    'version.incremental': build.version.incremental,
    'version.codename': build.version.codename,
    'version.baseOS': build.version.baseOS,
    'board': build.board,
    'bootloader': build.bootloader,
    'brand': build.brand,
    'device': build.device,
    'display': build.display,
    'fingerprint': build.fingerprint,
    'hardware': build.hardware,
    'host': build.host,
    'id': build.id,
    'manufacturer': build.manufacturer,
    'model': build.model,
    'product': build.product,
    'supported32BitAbis': build.supported32BitAbis,
    'supported64BitAbis': build.supported64BitAbis,
    'supportedAbis': build.supportedAbis,
    'tags': build.tags,
    'type': build.type,
    'isPhysicalDevice': build.isPhysicalDevice,
    'systemFeatures': build.systemFeatures,
  };
}

Map<String, dynamic> readIosDeviceInfo(IosDeviceInfo data) {
  return <String, dynamic>{
    'name': data.name,
    'systemName': data.systemName,
    'systemVersion': data.systemVersion,
    'model': data.model,
    'localizedModel': data.localizedModel,
    'identifierForVendor': data.identifierForVendor,
    'isPhysicalDevice': data.isPhysicalDevice,
    'utsname.sysname:': data.utsname.sysname,
    'utsname.nodename:': data.utsname.nodename,
    'utsname.release:': data.utsname.release,
    'utsname.version:': data.utsname.version,
    'utsname.machine:': data.utsname.machine,
  };
}

Map<String, dynamic> readLinuxDeviceInfo(LinuxDeviceInfo data) {
  return <String, dynamic>{
    'name': data.name,
    'version': data.version,
    'id': data.id,
    'idLike': data.idLike,
    'versionCodename': data.versionCodename,
    'versionId': data.versionId,
    'prettyName': data.prettyName,
    'buildId': data.buildId,
    'variant': data.variant,
    'variantId': data.variantId,
    'machineId': data.machineId,
  };
}

Map<String, dynamic> readWebBrowserInfo(WebBrowserInfo data) {
  return <String, dynamic>{
    'browserName': describeEnum(data.browserName),
    'appCodeName': data.appCodeName,
    'appName': data.appName,
    'appVersion': data.appVersion,
    'deviceMemory': data.deviceMemory,
    'language': data.language,
    'languages': data.languages,
    'platform': data.platform,
    'product': data.product,
    'productSub': data.productSub,
    'userAgent': data.userAgent,
    'vendor': data.vendor,
    'vendorSub': data.vendorSub,
    'hardwareConcurrency': data.hardwareConcurrency,
    'maxTouchPoints': data.maxTouchPoints,
  };
}

Map<String, dynamic> readMacOsDeviceInfo(MacOsDeviceInfo data) {
  return <String, dynamic>{
    'computerName': data.computerName,
    'hostName': data.hostName,
    'arch': data.arch,
    'model': data.model,
    'kernelVersion': data.kernelVersion,
    'osRelease': data.osRelease,
    'activeCPUs': data.activeCPUs,
    'memorySize': data.memorySize,
    'cpuFrequency': data.cpuFrequency,
    'systemGUID': data.systemGUID,
  };
}

Map<String, dynamic> readWindowsDeviceInfo(WindowsDeviceInfo data) {
  return <String, dynamic>{
    'numberOfCores': data.numberOfCores,
    'computerName': data.computerName,
    'systemMemoryInMegabytes': data.systemMemoryInMegabytes,
  };
}

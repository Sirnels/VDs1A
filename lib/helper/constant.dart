import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

String dummyProfilePic =
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ6TaCLCqU4K0ieF27ayjl51NmitWaJAh_X0r1rLX4gMvOe0MDaYw&s';
String appFont = 'HelveticaNeuea';
List<String> dummyProfilePicList = [
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ6TaCLCqU4K0ieF27ayjl51NmitWaJAh_X0r1rLX4gMvOe0MDaYw&s',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTFDjXj1F8Ix-rRFgY_r3GerDoQwfiOMXVt-tZdv_Mcou_yIlUC&s',
  'http://www.azembelani.co.za/wp-content/uploads/2016/07/20161014_58006bf6e7079-3.png',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRzDG366qY7vXN2yng09wb517WTWqp-oua-mMsAoCadtncPybfQ&s',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTq7BgpG1CwOveQ_gEFgOJASWjgzHAgVfyozkIXk67LzN1jnj9I&s',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRPxjRIYT8pG0zgzKTilbko-MOv8pSnmO63M9FkOvfHoR9FvInm&s',
  'https://cdn5.f-cdn.com/contestentries/753244/11441006/57c152cc68857_thumb900.jpg',
  'https://cdn6.f-cdn.com/contestentries/753244/20994643/57c189b564237_thumb900.jpg'
];

class AppIcon {
  static const int fabTweet = 0xf029;
  static const int messageEmpty = 0xf187;
  static const int messageFill = 0xf554;
  static const int search = 0xf058;
  static const int searchFill = 0xf558;
  static const int notification = 0xf055;
  static const int notificationFill = 0xf019;
  static const int messageFab = 0xf053;
  static const int home = 0xf053;
  static const int homeFill = 0xF553;
  static const int heartEmpty = 0xf148;
  static const int heartFill = 0xf015;
  static const int settings = 0xf059;
  static const int adTheRate = 0xf064;
  static const int reply = 0xf151;
  static const int retweet = 0xf152;
  static const int image = 0xf109;
  static const int camera = 0xf110;
  static const int arrowDown = 0xf196;
  static const int blueTick = 0xf099;

  static const int link = 0xf098;
  static const int unFollow = 0xf097;
  static const int mute = 0xf101;
  static const int viewHidden = 0xf156;
  static const int block = 0xe609;
  static const int report = 0xf038;
  static const int pin = 0xf088;
  static const int delete = 0xf154;

  static const int profile = 0xf056;
  static const int lists = 0xf094;
  static const int bookmark = 0xf155;
  static const int moments = 0xf160;
  static const int twitterAds = 0xf504;
  static const int bulb = 0xf567;
  static const int newMessage = 0xf035;

  static const int sadFace = 0xf430;
  static const int bulbOn = 0xf066;
  static const int bulbOff = 0xf567;
  static const int follow = 0xf175;
  static const int thumbpinFill = 0xf003;
  static const int calender = 0xf203;
  static const int locationPin = 0xf031;
  static const int edit = 0xf112;
}

const viewductBlack = Color(0xFF1E1E1E);
const viewductBlue = Color(0xFF007ACC);
const viewductgreen = Color(0xFF27C784);
const viewductWhite = Color(0xFFE0E0E0);
// ignore: constant_identifier_names
const IS_TOKEN_GENERATED = 'isTokenGenerated';
// ignore: constant_identifier_names
const NOTIFICATION_TOKENS = 'notificationTokens';
// ignore: constant_identifier_names
const PHOTO_URL = 'profilePic';
// ignore: constant_identifier_names
const USERS = 'profile';
// ignore: constant_identifier_names
const MESSAGES = 'messages';
// ignore: constant_identifier_names
const ANSWER_TRIES = 'answerTries';
// ignore: constant_identifier_names
const PASSCODE_TRIES = 'passcodeTries';
// ignore: constant_identifier_names
const ABOUT_ME = 'bio';
// ignore: constant_identifier_names
const NICKNAME = 'displayName';
// ignore: constant_identifier_names
const TYPE = 'type';
// ignore: constant_identifier_names
const FROM = 'sender_id';
// ignore: constant_identifier_names
const TO = 'recieverId';
// ignore: constant_identifier_names
const CONTENT = 'message';
// ignore: constant_identifier_names
const CHATS_WITH = 'chatsWith';
// ignore: constant_identifier_names
const CHAT_STATUS = 'chatStatus';
// ignore: constant_identifier_names
const LAST_SEEN = 'lastSeen';
// ignore: constant_identifier_names
const PHONE = 'contact';
// ignore: constant_identifier_names
const ID = 'userId';
// ignore: constant_identifier_names
const ANSWER = 'answer';
// ignore: constant_identifier_names
const QUESTION = 'question';
// ignore: constant_identifier_names
const PASSCODE = 'passcode';
// ignore: constant_identifier_names
const HIDDEN = 'hidden';
// ignore: constant_identifier_names
const LOCKED = 'locked';
// ignore: constant_identifier_names
const DELETE_UPTO = 'deleteUpto';
// ignore: constant_identifier_names
const TIMESTAMP = 'timestamp';
// ignore: constant_identifier_names
const LAST_ANSWERED = 'lastAnswered';
// ignore: constant_identifier_names
const LAST_ATTEMPT = 'lastAttempt';
// ignore: constant_identifier_names
const AUTHENTICATION_TYPE = 'authenticationType';
// ignore: constant_identifier_names
const CACHED_CONTACTS = 'cachedContacts';
// ignore: constant_identifier_names
const SAVED = 'saved';
// ignore: constant_identifier_names
const ALIAS_NAME = 'aliasName';
// ignore: constant_identifier_names
const ALIAS_AVATAR = 'aliasAvatar';
// ignore: constant_identifier_names
const PUBLIC_KEY = 'publicKey';
// ignore: constant_identifier_names
const PRIVATE_KEY = 'privateKey';
// ignore: constant_identifier_names
const PRIVACY_POLICY_URL = 'https://www.viewducts.com/Privacy_Policy';
// ignore: constant_identifier_names
const COUNTRY_CODE = 'countryCode';
// ignore: constant_identifier_names
const WALLPAPER = 'wallpaper';
// ignore: constant_identifier_names
const CRC_SEPARATOR = '&';
// ignore: constant_identifier_names
const TRIES_THRESHOLD = 3;
// ignore: constant_identifier_names
const TIME_BASE = 2;
// ignore: constant_identifier_names
Logger logger = Logger();

// ignore: non_constant_identifier_names
final ViewDuctsTheme = ThemeData(
  backgroundColor: viewductBlack,
  dialogBackgroundColor: Colors.black,
  primaryColorDark: Colors.black,
  indicatorColor: viewductBlue.withOpacity(0.8),
  dialogTheme:
      const DialogTheme(backgroundColor: Colors.black, elevation: 48.0),
  brightness: Brightness.dark,
  scaffoldBackgroundColor: viewductBlack,
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.light,
  ),
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
      .copyWith(secondary: viewductBlue),
  textSelectionTheme: const TextSelectionThemeData(cursorColor: viewductBlue),
);

enum ChatStatus { blocked, waiting, requested, accepted }
enum MessageType { text, image }
enum AuthenticationType { passcode, biometric }
void unawaited(Future<void> future) {}
// ignore: constant_identifier_names
const List<List<String>> CountryCode_TrunkCode = [
  ["93", "0"],
  ["355", "0"],
  ["213", "0"],
  ["1", "1"],
  ["376", "-"],
  ["244", "-"],
  ["1", "1"],
  ["1", "1"],
  ["54", "0"],
  ["374", "0"],
  ["297", "-"],
  ["247", "-"],
  ["61", "0"],
  ["43", "0"],
  ["994", "0"],
  ["1", "1"],
  ["973", "-"],
  ["880", "0"],
  ["1", "1"],
  ["375", "80"],
  ["32", "0"],
  ["501", "-"],
  ["229", "-"],
  ["1", "1"],
  ["975", "-"],
  ["591", "0"],
  ["387", "0"],
  ["267", "-"],
  ["55", "0"],
  ["1", "1"],
  ["673", "-"],
  ["359", "0"],
  ["226", "-"],
  ["257", "-"],
  ["855", "0"],
  ["237", "-"],
  ["1", "1"],
  ["238", "-"],
  ["1", "1"],
  ["236", "-"],
  ["235", "-"],
  ["56", "-"],
  ["86", "0"],
  ["57", "0"],
  ["269", "-"],
  ["242", "-"],
  ["682", "-"],
  ["506", "-"],
  ["385", "0"],
  ["53", "0"],
  ["599", "0"],
  ["357", "-"],
  ["420", "-"],
  ["243", "0"],
  ["45", "-"],
  ["246", "-"],
  ["253", "-"],
  ["1", "1"],
  ["1", "1"],
  ["670", "-"],
  ["593", "0"],
  ["20", "0"],
  ["503", "-"],
  ["240", "-"],
  ["291", "0"],
  ["372", "-"],
  ["251", "0"],
  ["500", "-"],
  ["298", "-"],
  ["679", "-"],
  ["358", "0"],
  ["33", "0"],
  ["594", "0"],
  ["689", "-"],
  ["241", "-"],
  ["220", "-"],
  ["995", "0"],
  ["49", "0"],
  ["233", "0"],
  ["350", "-"],
  ["30", "-"],
  ["299", "-"],
  ["1", "1"],
  ["590", "0"],
  ["1", "1"],
  ["502", "-"],
  ["224", "-"],
  ["245", "-"],
  ["592", "-"],
  ["509", "-"],
  ["504", "-"],
  ["852", "-"],
  ["36", "06"],
  ["354", "-"],
  ["91", "0"],
  ["62", "0"],
  ["870", "-"],
  ["98", "0"],
  ["964", "-"],
  ["353", "0"],
  ["8816", "-"],
  ["8817", "-"],
  ["972", "0"],
  ["39", "-"],
  ["225", "-"],
  ["1", "1"],
  ["81", "0"],
  ["962", "0"],
  ["7", "8"],
  ["254", "0"],
  ["686", "-"],
  ["965", "-"],
  ["996", "0"],
  ["856", "0"],
  ["371", "-"],
  ["961", "0"],
  ["266", "-"],
  ["231", "-"],
  ["218", "0"],
  ["423", "-"],
  ["370", "8"],
  ["352", "-"],
  ["853", "-"],
  ["389", "0"],
  ["261", "0"],
  ["265", "-"],
  ["60", "0"],
  ["960", "-"],
  ["223", "-"],
  ["356", "-"],
  ["692", "1"],
  ["596", "0"],
  ["222", "-"],
  ["230", "-"],
  ["262", "0"],
  ["52", "01|044|045"],
  ["691", "1"],
  ["373", "0"],
  ["377", "-"],
  ["976", "0"],
  ["382", "0"],
  ["1", "1"],
  ["212", "0"],
  ["258", "-"],
  ["95", "0"],
  ["264", "0"],
  ["674", "-"],
  ["977", "0"],
  ["31", "0"],
  ["599", "0"],
  ["687", "-"],
  ["64", "0"],
  ["505", "-"],
  ["227", "-"],
  ["234", "0"],
  ["683", "-"],
  ["6723", "-"],
  ["850", "-"],
  ["1", "1"],
  ["47", "-"],
  ["968", "-"],
  ["92", "0"],
  ["680", "-"],
  ["970", "0"],
  ["507", "-"],
  ["675", "-"],
  ["595", "0"],
  ["51", "0"],
  ["63", "0"],
  ["48", "-"],
  ["351", "-"],
  ["1", "1"],
  ["974", "-"],
  ["262", "0"],
  ["40", "0"],
  ["7", "8"],
  ["250", "-"],
  ["290", "-"],
  ["1", "1"],
  ["1", "1"],
  ["590", "0"],
  ["590", "0"],
  ["508", "-"],
  ["1", "1"],
  ["685", "-"],
  ["378", "-"],
  ["239", "-"],
  ["966", "0"],
  ["221", "-"],
  ["381", "0"],
  ["248", "-"],
  ["232", "0"],
  ["65", "-"],
  ["1", "1"],
  ["421", "0"],
  ["386", "0"],
  ["677", "-"],
  ["252", "-"],
  ["27", "0"],
  ["82", "0"],
  ["211", "-"],
  ["34", "-"],
  ["94", "0"],
  ["249", "0"],
  ["597", "0"],
  ["268", "-"],
  ["46", "0"],
  ["41", "0"],
  ["963", "0"],
  ["886", "0"],
  ["992", "8"],
  ["255", "0"],
  ["66", "0"],
  ["882 16", "-"],
  ["228", "-"],
  ["690", "-"],
  ["676", "-"],
  ["1", "1"],
  ["216", "-"],
  ["90", "0"],
  ["993", "8"],
  ["1", "1"],
  ["688", "-"],
  ["256", "0"],
  ["380", "0"],
  ["971", "0"],
  ["44", "0"],
  ["1", "1"],
  ["1", "1"],
  ["598", "0"],
  ["998", "0"],
  ["678", "-"],
  ["379", "-"],
  ["39", "-"],
  ["58", "0"],
  ["84", "0"],
  ["681", "-"],
  ["967", "0"],
  ["260", "0"],
  ["263", "0"]
];

class UniversalVariables {
  static const Color blueColor = Color(0xff2b9ed4);
  static const Color blackColor = Color(0xff19191b);
  static const Color greyColor = Color(0xff8f8f8f);
  static const Color userCircleBackground = Color(0xff2b2b33);
  static const Color onlineDotColor = Color(0xff46dc64);
  static const Color lightBlueColor = Color(0xff0077d7);
  static const Color separatorColor = Color(0xff272c35);

  static const Color gradientColorStart = Color(0xff00b6f3);
  static const Color gradientColorEnd = Color(0xff0184dc);

  static const Color senderColor = Color(0xff2b343b);
  static const Color receiverColor = Color(0xff1e2225);

  static const Gradient fabGradient = LinearGradient(
      colors: [gradientColorStart, gradientColorEnd],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight);
}

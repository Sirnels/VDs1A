// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:viewducts/helper/enum.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/state/searchState.dart';

class ComposeDuctState extends GetxController {
  static ComposeDuctState instance = Get.find<ComposeDuctState>();
  var showUserList = false.obs;
  var enableSubmitButton = false.obs;
  var hideUserList = false.obs;
  var description = "".obs;
  String? serverToken;
  final usernameRegex = r'(@\w*[a-zA-Z1-9]$)';

  final _isScrollingDown = false.obs;
  bool get isScrollingDown => _isScrollingDown.value;
  set setIsScrolllingDown(bool value) {
    _isScrollingDown.value = value;
    update();
  }

  /// Display/Hide userlist on the basis of username availability in description.value
  /// To display userlist in compose screen two condion is required
  /// First is value of `status` should be true
  /// Second value of  `hideUserList.value` should be false
  bool get displayUserList {
    RegExp regExp = RegExp(usernameRegex);
    var status = regExp.hasMatch(description.value);
    if (status && !hideUserList.value) {
      return true;
    } else {
      return false;
    }
  }

  /// Hide userlist when a  user select a username from userlist
  void onUserSelected() {
    hideUserList.value = true;
    update();
  }

  /// This method will trigger every time when user writes tweet description.value.
  /// `hideUserList.value` is set to false to reset user list show flag.
  /// If description.value is not empty and its lenth is lesser then 280 characters
  /// then value of `enableSubmitButton` is set to true.
  ///
  /// `enableSubmitButton` is responsible to enable/disable tweet submit button
  void onDescriptionChanged(String text, SearchState searchState) {
    description.value = text;
    hideUserList.value = false;
    if (text.isEmpty || text.length > 280) {
      /// Disable submit button if description.value is not availabele
      enableSubmitButton.value = false;
      update();
      return;
    }

    /// Enable submit button if description.value is availabele
    enableSubmitButton.value = true;
    var last = text.substring(text.length - 1, text.length);

    /// Regex to search last username available from description.value
    /// Ex. `Hello @john do you know @ricky`
    /// In above description.value reegex is serch for last username ie. `@ricky`.

    RegExp regExp = RegExp(usernameRegex);
    var status = regExp.hasMatch(text);
    if (status) {
      Iterable<Match> _matches = regExp.allMatches(text);
      var name = text.substring(_matches.last.start, _matches.last.end);

      /// If last character is `@` then reset search user list
      if (last == "@") {
        /// Reset user list
        searchState.filterByUsername("");
      } else {
        /// Filter user list according to name
        searchState.filterByUsername(name);
      }
    } else {
      /// Hide userlist if no matched username found
      hideUserList.value = false;
      update();
    }
  }

  /// When user select user from userlist it will add username in description.value
  String getDescription(String username) {
    RegExp regExp = RegExp(usernameRegex);
    Iterable<Match> _matches = regExp.allMatches(description.value);
    var name = description.value.substring(0, _matches.last.start);
    description.value = '$name $username';
    return description.value;
  }

  /// Fetch FCM server key from firebase Remote config
  /// FCM server key is stored in firebase remote config
  /// you have to add server key in firebase remote config
  /// To fetch this key go to project setting in firebase
  /// Click on `cloud messaging` tab
  /// Copy server key from `Project credentials`
  /// Now goto `Remote Congig` section in fireabse
  /// Add [FcmServerKey]  as paramerter key and below json in Default vslue
  ///  ``` json
  ///  {
  ///    "key": "FCM server key here"
  ///  } ```
  /// For more detail visit:- https://github.com/TheAlphamerc/flutter_twitter_clone/issues/28#issue-611695533
  /// For package detail check:-  https://pub.dev/packages/firebase_remote_config#-readme-tab-
  Future<void> getFCMServerKey() async {
    /// If FCM server key is already fetched then no need to fetch it again.
    if (serverToken != null && serverToken!.isNotEmpty) {
      return Future.value(null);
    }
    final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetch();
    await remoteConfig.fetchAndActivate();
    var data = remoteConfig.getString('FcmServerKey');

    serverToken = jsonDecode(data)["key"];
  }

  /// Fecth FCM server key from firebase Remote config
  /// send notification to user once fcmToken is retrieved from firebase
  Future<void> sendNotification(FeedModel model, SearchState state) async {
    const usernameRegex = r"(@\w*[a-zA-Z1-9])";
    RegExp regExp = RegExp(usernameRegex);
    var status = regExp.hasMatch(description.value);

    /// Check if username is availeble in description.value or not
    if (status) {
      /// Get FCM server key from firebase remote config
      getFCMServerKey().then((val) async {
        /// Reset userlist
        state.filterByUsername("");

        /// Search all username from description.value
        Iterable<Match> _matches = regExp.allMatches(description.value);
        if (kDebugMode) {
          print("${_matches.length} name found in description.value");
        }

        /// Send notification to user one by one
        await Future.forEach(_matches, (Match match) async {
          var name = description.value.substring(match.start, match.end);
          if (state.userlist!.any((x) => x.userName == name)) {
            /// Fetch user model from userlist
            /// UserId, FCMtoken is needed to send notification
            final user = state.userlist!.firstWhere((x) => x.userName == name);
            await sendNotificationToUser(model, user);
          } else {
            cprint("Name: $name ,", errorIn: "UserNot found");
          }
        });
      });
    }
  }

  Future<void> sendProductNotification(
      FeedModel model, SearchState state) async {
    const usernameRegex = r"(@\w*[a-zA-Z1-9])";
    RegExp regExp = RegExp(usernameRegex);
    var status = regExp.hasMatch(description.value);

    /// Check if username is availeble in description.value or not
    if (status) {
      /// Get FCM server key from firebase remote config
      getFCMServerKey().then((val) async {
        /// Reset userlist
        state.filterByUsername("");

        /// Search all username from description.value
        Iterable<Match> _matches = regExp.allMatches(description.value);
        if (kDebugMode) {
          print("${_matches.length} name found in description.value");
        }

        /// Send notification to user one by one
        await Future.forEach(_matches, (Match match) async {
          var name = description.value.substring(match.start, match.end);
          if (state.userlist!.any((x) => x.userName == name)) {
            /// Fetch user model from userlist
            /// UserId, FCMtoken is needed to send notification
            final user = state.userlist!.firstWhere((x) => x.userName == name);
            await sendNotificationToUser(model, user);
          } else {
            cprint("Name: $name ,", errorIn: "UserNot found");
          }
        });
      });
    }
  }

  /// Send notificatinn by using firebase notification rest api;
  Future<void> sendNotificationToUser(
      FeedModel model, ViewductsUser user) async {
    if (kDebugMode) {
      print("Send notification to: ${user.userName}");
    }

    /// Return from here if fcmToken is null
    if (user.fcmToken == null) {
      return;
    }

    /// Create notification payload
    var body = jsonEncode(<String, dynamic>{
      'notification': <String, dynamic>{
        'body': model.ductComment,
        'title': "${model.user!.displayName} metioned you in a Duct"
      },
      'priority': 'high',
      'data': <String, dynamic>{
        'click_action': 'Notification click',
        'id': '1',
        'status': 'done',
        "type": NotificationType.Mention.toString(),
        "senderId": model.user!.userId,
        "receiverId": user.userId,
        "title": "title",
        "body": "",
        "tweetId": ""
      },
      'to': user.fcmToken
    });

    var response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: body,
    );
    cprint(response.body.toString());
  }
}

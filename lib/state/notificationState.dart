// ignore_for_file: file_names, overridden_fields, unnecessary_null_comparison

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:viewducts/helper/enum.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/notificationModel.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/state/appState.dart';

class NotificationState extends AppState {
  static NotificationState instance = Get.find<NotificationState>();
  @override
  RxDouble totalCartPrice = 0.0.obs;
  @override
  void onReady() {
    super.onReady();
    // user = Rx<User>(_firebaseAuth.currentUser);
    // // user.bindStream(_firebaseAuth.userChanges());
    // databaseInit(authState.userId);
    // ever(authState.userModel.obs, getDataFromDatabase);
  }

  String? fcmToken;
  NotificationType? _notificationType = NotificationType.NOT_DETERMINED;
  String? notificationReciverId, notificationDuctId;
  FeedModel? notificationDuctModel;
  NotificationType? get notificationType => _notificationType;
  set setNotificationType(NotificationType? type) {
    _notificationType = type;
  }

  // FcmNotificationModel notification;
  String? notificationSenderId;

  List<ViewductsUser> userList = [];

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  List<NotificationModel>? _notificationList;

  List<NotificationModel>? get notificationList => _notificationList;

  /// [Intitilise firebase notification vDatabase]
  Future<bool> databaseInit(String? userId) {
    Stream<QuerySnapshot>? _query;
    try {
      if (_query != null) {
        vDatabase
            .collection("notification")
            .where('$userId')
            .snapshots()
            .listen((event) {
          for (var element in event.docChanges) {
            if (element.type == DocumentChangeType.added) {
              _onNotificationAdded(element);
            } else if (element.type == DocumentChangeType.modified) {
              _onNotificationChanged(element);
            } else if (element.type == DocumentChangeType.removed) {
              _onNotificationRemoved(element);
            }
          }
        });

        // query.onChildAdded.listen(_onNotificationAdded);
        // query.onChildChanged.listen(_onNotificationChanged);
        // query.onChildRemoved.listen(_onNotificationRemoved);
      }

      return Future.value(true);
    } catch (error) {
      cprint(error, errorIn: 'databaseInit notification');
      return Future.value(false);
    }
  }

  /// get [Notification list] from firebase realtime database
  getDataFromDatabase(ViewductsUser? userId) {
    try {
      // loading = true;
      _notificationList = [];
      vDatabase
          .collection('notification')
          .doc(userId!.userId)
          .get()
          .then((DocumentSnapshot snapshot) {
        var map = snapshot;
        map.get(snapshot).forEach((ductKey, value) {
          var model = NotificationModel.fromJson(
              ductKey, value["updatedAt"], snapshot["type"]);
          _notificationList!.add(model);
        });
        _notificationList!.sort((x, y) {
          if (x.updatedAt != null && y.updatedAt != null) {
            return DateTime.parse(y.updatedAt!)
                .compareTo(DateTime.parse(x.updatedAt!));
          } else if (x.updatedAt != null) {
            return 1;
          } else {
            return 0;
          }
        });
        // loading = false;
      });
    } catch (error) {
      //loading = false;
      cprint(error, errorIn: 'getDataFromDatabase');
    }
  }

  /// get `duct` present in notification
  Future<FeedModel?> getDuctDetail(String? ductId) async {
    FeedModel _ductDetail;
    var snapshot = await vDatabase.collection('duct').doc(ductId).get();
    if (snapshot != null) {
      var map = snapshot;
      _ductDetail = FeedModel.fromJson(map.data()!);
      _ductDetail.key = snapshot.id;
      return _ductDetail;
    } else {
      return null;
    }
  }

  /// get user who liked your duct
  Future<Object?> getuserDetail(String? userId) async {
    ViewductsUser user;
    if (userList.isNotEmpty && userList.any((x) => x.userId == userId)) {
      return Future.value(userList.firstWhere((x) => x.userId == userId));
    }
    var snapshot = await vDatabase.collection('profile').doc(userId).get();
    if (snapshot != null) {
      var map = snapshot;
      user = ViewductsUser.fromJson(map.data());
      user.key = snapshot.id;
      userList.add(user);
      return user;
    } else {
      return null;
    }
  }

  /// Remove notification if related duct is not found or deleted
  void removeNotification(String? userId, String ductkey) async {
    vDatabase
        .collection('notification')
        .doc(userId)
        .update({ductkey: FieldValue.delete()});
  }

  /// Trigger when somneone like your duct
  void _onNotificationAdded(DocumentChange event) {
    var model = NotificationModel.fromJson(
        event.doc.id, event.doc["updatedAt"], event.doc["type"]);
    _notificationList ??= <NotificationModel>[];
    vDatabase.runTransaction((transaction) async {
      _notificationList!.add(model);
    });

    // added notification to list
    if (kDebugMode) {
      print("Notification added");
    }
  }

  /// Trigger when someone changed his like preference
  void _onNotificationChanged(DocumentChange event) {
    var model = NotificationModel.fromJson(
        event.doc.id, event.doc["updatedAt"], event.doc["type"]);
    model.ductKey = event.doc.id;
    //update notification list
    _notificationList!.firstWhere((x) => x.ductKey == model.ductKey).ductKey =
        model.ductKey;

    cprint("Notification changed");
  }

  /// Trigger when someone undo his like on duct
  void _onNotificationRemoved(DocumentChange event) {
    var model = NotificationModel.fromJson(
        event.doc.id, event.doc["updatedAt"], event.doc["type"]);
    // remove notification from list
    _notificationList!.removeWhere((x) => x.ductKey == model.ductKey);

    if (kDebugMode) {
      print("Notification Removed");
    }
  }

  /// Configure notification services
  void initfirebaseService() {
    // _firebaseMessaging
    //   ..configure(
    //     onMessage: (Map<String, dynamic> message) async {
    //       // print("onMessage: $message");
    //       print(message['data()']);
    //     },
    //     onLaunch: (Map<String, dynamic> message) async {
    //       cprint("Notification ", event: "onLaunch");
    //       var data = message['data()'];
    //       // print(message['data()']);
    //       notificationSenderId = data()["senderId"];
    //       notificationReciverId = data()["receiverId"];
    //       notificationReciverId = data()["receiverId"];
    //       if (data()["type"] == "NotificationType.Mention") {
    //         setNotificationType = NotificationType.Mention;
    //       } else if (data()["type"] == "NotificationType.Message") {
    //         setNotificationType = NotificationType.Message;
    //       }
    //     },
    //     onResume: (Map<String, dynamic> message) async {
    //       cprint("Notification ", event: "onResume");
    //       var data = message['data()'];
    //       // print(message['data()']);
    //       notificationSenderId = data()["senderId"];
    //       notificationReciverId = data()["receiverId"];
    //       if (data()["type"] == "NotificationType.Mention") {
    //         setNotificationType = NotificationType.Mention;
    //       } else if (data()["type"] == "NotificationType.Message") {
    //         setNotificationType = NotificationType.Message;
    //       }
    //     },
    //   );
    _firebaseMessaging.requestPermission(
        sound: true, badge: true, alert: true, provisional: true
        // const IosNotificationSettings(
        //     sound: true, badge: true, alert: true, provisional: true)
        );
    _firebaseMessaging.getNotificationSettings();
    //     .listen((IosNotificationSettings settings) {
    //   print("Settings registered: $settings");
    // });
    _firebaseMessaging.getToken().then((String? token) {
      assert(token != null);
      fcmToken = token;
      if (kDebugMode) {
        print(token);
      }
    });
  }
}

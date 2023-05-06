// ignore_for_file: file_names

import 'package:viewducts/admin/Admin_dashbord/screens/controllers.dart';
import 'package:viewducts/admin/dataBaseApi.dart';
import 'package:viewducts/page/feed/composeTweet/state/composeTweetState.dart';
import 'package:viewducts/state/appState.dart';
import 'package:viewducts/state/authState.dart';
import 'package:viewducts/state/bossBabyState.dart';
import 'package:viewducts/state/chats/chatState.dart';
import 'package:viewducts/state/ductsNotification.dart';
import 'package:viewducts/state/feedState.dart';
import 'package:viewducts/state/notificationState.dart';
import 'package:viewducts/state/pagesController.dart';
import 'package:viewducts/state/searchState.dart';
import 'package:viewducts/state/serverApi.dart';

AuthState authState = AuthState.instance;
DataBaseApi dataBaseApi = DataBaseApi.instance;
AppState appState = AppState.instance;
ServerApi serverApi = ServerApi.instance;
ChatState chatState = ChatState.instance;
FeedState feedState = FeedState.instance;
SearchState searchState = SearchState.instance;
DuctNotificationController ductsNotificationContollerState =
    DuctNotificationController.instance;
NotificationState notificationState = NotificationState.instance;
BossBabyState bossbabyState = BossBabyState.instance;
ComposeDuctState composeductState = ComposeDuctState.instance;
AdminStaffUserController adminStaffController =
    AdminStaffUserController.instance;
AdminAppController adminAppController = AdminAppController.instance;
UserCartViewController userCartController = UserCartViewController.instance;

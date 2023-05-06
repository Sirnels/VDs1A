// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:viewducts/admin/Admin_dashbord/screens/controllers.dart';
import 'package:viewducts/admin/dataBaseApi.dart';
import 'package:viewducts/page/feed/composeTweet/state/composeTweetState.dart';
import 'package:viewducts/state/ductsNotification.dart';
import 'package:viewducts/state/pagesController.dart';
import 'package:viewducts/state/serverApi.dart';

import 'appState.dart';
import 'authState.dart';
import 'chats/chatState.dart';
import 'feedState.dart';
import 'notificationState.dart';
import 'searchState.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthState>(AuthState());
    Get.put<AppState>(AppState());
    Get.put<FeedState>(FeedState());
    Get.put<ServerApi>(ServerApi());
    Get.put<DataBaseApi>(DataBaseApi());
    Get.put<SearchState>(SearchState());
    Get.put<NotificationState>(NotificationState());
    Get.put<ChatState>(ChatState());
    Get.lazyPut<DuctNotificationController>(() => DuctNotificationController());
    //  Get.put<BossBabyState>(BossBabyState());
    // Get.put<DuctNotificationController>(DuctNotificationController());
    Get.put<ComposeDuctState>(ComposeDuctState());
    Get.put<AdminAppController>(AdminAppController());
    Get.put<AdminStaffUserController>(AdminStaffUserController());
    Get.lazyPut<UserCartViewController>(() => UserCartViewController());

    // Get.put<ProductController>(ProductController());
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viewducts/apis/ducts_api.dart';
import 'package:viewducts/apis/user_api.dart';
import 'package:viewducts/core/utils.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';

final userProfileControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  return UserProfileController(
    ductAPI: ref.watch(ductAPIProvider),
    // storageAPI: ref.watch(storageAPIProvider),
    userAPI: ref.watch(userAPIProvider),
    // notificationController: ref.watch(notificationControllerProvider.notifier),
  );
});

// final getUserTweetsProvider = FutureProvider.family((ref, String uid) async {
//   final userProfileController =
//       ref.watch(userProfileControllerProvider.notifier);
//   return userProfileController.getUserTweets(uid);
// });

final getLatestUserProfileDataProvider = StreamProvider((ref) {
  final userAPI = ref.watch(userAPIProvider);
  return userAPI.getLatestUserProfileData();
});

class UserProfileController extends StateNotifier<bool> {
  final DuctsAPI _ductAPI;
  //final StorageAPI _storageAPI;
  final UserAPI _userAPI;
  // final NotificationController _notificationController;
  UserProfileController({
    required DuctsAPI ductAPI,
    // required StorageAPI storageAPI,
    required UserAPI userAPI,
    // required NotificationController notificationController,
  })  : _ductAPI = ductAPI,
        //_storageAPI = storageAPI,
        _userAPI = userAPI,
        // _notificationController = notificationController,
        super(false);

  // Future<List<FeedModel>> getUserDuct(String uid) async {
  //   final tweets = await _ductAPI.getUserTweets(uid);
  //   return tweets.map((e) => Tweet.fromMap(e.data)).toList();
  // }

  void updateUserProfile({
    required ViewductsUser userModel,
    required BuildContext context,
    required File? bannerFile,
    required File? profileFile,
  }) async {
    state = true;
    if (bannerFile != null) {
      // final bannerUrl = await _storageAPI.uploadImage([bannerFile]);
      // userModel = userModel.copyWith(
      //   bannerPic: bannerUrl[0],
      // );
    }

    if (profileFile != null) {
      // final profileUrl = await _storageAPI.uploadImage([profileFile]);
      // userModel = userModel.copyWith(
      //   profilePic: profileUrl[0],
      // );
    }

    final res = await _userAPI.updateUserData(userModel);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Navigator.pop(context),
    );
  }

  void followUser({
    required ViewductsUser user,
    required BuildContext context,
    required ViewductsUser currentUser,
  }) async {
    // already following
    // if (currentUser.following.contains(user.uid)) {
    //   user.followers.remove(currentUser.uid);
    //   currentUser.following.remove(user.uid);
    // } else {
    //   user.followers.add(currentUser.uid);
    //   currentUser.following.add(user.uid);
    // }

    // user = user.copyWith(followers: user.followers);
    // currentUser = currentUser.copyWith(
    //   following: currentUser.following,
    // );

    final res = await _userAPI.followUser(user);
    res.fold((l) => showSnackBar(context, l.message), (r) async {
      final res2 = await _userAPI.addToFollowing(currentUser);
      res2.fold((l) => showSnackBar(context, l.message), (r) {
        // _notificationController.createNotification(
        //   text: '${currentUser.name} followed you!',
        //   postId: '',
        //   notificationType: NotificationType.follow,
        //   uid: user.uid,
        // );
      });
    });
  }
}

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart' as fireStore;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:viewducts/apis/ducts_api.dart';
import 'package:viewducts/core/utils.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';

final ductControllerProvider = StateNotifierProvider<DuctController, bool>(
  (ref) {
    return DuctController(
      ref: ref,
      ductApi: ref.watch(ductAPIProvider),
    );
  },
);
final currentDuctListDetailsProvider = FutureProvider.autoDispose((ref) {
  final ductController = ref.watch(ductControllerProvider.notifier);
  return ductController.getDuctList();
});
final currentDuctStoryListProvider =
    FutureProvider.family.autoDispose((ref, String userId) {
  final ductController = ref.watch(ductControllerProvider.notifier);
  return ductController.getDuctStory(userId);
});

final getDuctStreamProvider = StreamProvider((ref) {
  final ductAPI = ref.watch(ductAPIProvider);
  return ductAPI.getLatestDucts();
});
final getDuctStoryStreamProvider = StreamProvider((ref) {
  final ductAPI = ref.watch(ductAPIProvider);
  return ductAPI.getLatestDuctStory();
});

class DuctController extends StateNotifier<bool> {
  final DuctsAPI _ductApi;
  final Ref _ref;
  DuctController({
    required DuctsAPI ductApi,
    required Ref ref,
  })  : _ref = ref,
        _ductApi = ductApi,
        super(false);

  Future<List<FeedModel>> getDuctList() async {
    final ductList = await _ductApi.getDucts();
    return ductList.map((duct) => FeedModel.fromJson(duct.data)).toList();
  }

  Future<List<DuctStoryModel>> getDuctStory(String userId) async {
    final storyList = await _ductApi.getStoryByUserId(userId);
    return storyList
        .map((story) => DuctStoryModel.fromMap(story.data))
        .toList();
  }

  void _ductText(
      {required String text,
      required BuildContext context,
      String? productId,
      required ViewductsUser user,
      required int storyType,
      FeedModel? product,
      required bool reshare,
      required bool isUpdating,
      DuctStoryModel? ductStorys}) async {
    state = true;
    FToast().init(context);
    // final hashtags = _getHashtagsFromText(text);
    // String link = _getLinkFromText(text);
    // final user = _ref.read(currentUserDetailsProvider).value!;
    // final product = _ref.read(getOneProductProvider(productId ?? '')).value;
    if (isUpdating == true) {
      DuctStoryModel ductStory = DuctStoryModel(
        key: ductStorys!.key,
        ductComment: text,
        commissionUser: ductStorys.commissionUser,
        cProduct: ductStorys.cProduct,
        profilePic: ductStorys.profilePic,
        displayName: ductStorys.displayName,
        storyType: ductStorys.storyType,
        userId: ductStorys.userId,
        hearts: ductStorys.hearts,
        pinDuct: ductStorys.pinDuct,
        imagePath: ductStorys.imagePath,
        videoPath: ductStorys.videoPath,
        timeDifference: ductStorys.timeDifference,
        createdAt: ductStorys.createdAt,
        date: ductStorys.date,
        userViwed: ductStorys.userViwed,
      );
      FeedModel models = FeedModel(
          key: ductStorys.userId,
          ductId: ductStorys.userId,
          ductComment: ductStorys.ductComment,
          user: user,
          commissionUser: ductStorys.commissionUser,
          storyId: ductStorys.key,
          likeList: ductStorys.hearts,
          cProduct: ductStorys.cProduct,
          timeDifference: DateTime.now().toString(),
          createdAt: DateTime.now().toUtc().toString(),
          productVendorId: product?.userId,
          ductType: ductStorys.storyType,
          //tags: tags,

          userId: ductStorys.userId);
      var res = await _ductApi.updatePinDuct(models,
          story: ductStory, key: ductStory.userId);
      res.fold((l) => showSnackBar(context, l.message), (r) {
        Fluttertoast.showToast(
          msg: 'Duct reshared',
          // toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP_LEFT,
          timeInSecForIosWeb: 8,
          backgroundColor: Colors.cyan,
        );
        //  Navigator.pop(context);
        // if (repliedToUserId.isNotEmpty) {
        //   _notificationController.createNotification(
        //     text: '${user.name} replied to your tweet!',
        //     postId: r.$id,
        //     notificationType: NotificationType.reply,
        //     uid: repliedToUserId,
        //   );
        // }
      });
      state = false;
    } else if (reshare == true) {
      DuctStoryModel ductStory = DuctStoryModel(
        key: ductStorys!.key,
        ductComment: ductStorys.ductComment,
        commissionUser: ductStorys.commissionUser,
        cProduct: ductStorys.cProduct,
        profilePic: ductStorys.profilePic,
        displayName: ductStorys.displayName,
        storyType: ductStorys.storyType,
        userId: ductStorys.userId,
        hearts: ductStorys.hearts,
        pinDuct: ductStorys.pinDuct,
        imagePath: ductStorys.imagePath,
        videoPath: ductStorys.videoPath,
        timeDifference: ductStorys.timeDifference,
        createdAt: ductStorys.createdAt,
        date: ductStorys.date,
        userViwed: ductStorys.userViwed,
      );
      FeedModel models = FeedModel(
          key: ductStorys.userId,
          ductId: ductStorys.userId,
          ductComment: ductStorys.ductComment,
          user: user,
          commissionUser: ductStorys.commissionUser,
          storyId: ductStorys.key,
          likeList: ductStorys.hearts,
          cProduct: ductStorys.cProduct,
          timeDifference: DateTime.now().toString(),
          createdAt: DateTime.now().toUtc().toString(),
          productVendorId: product?.userId,
          ductType: ductStorys.storyType,
          //tags: tags,

          userId: ductStorys.userId);
      var res = await _ductApi.reSharePinDuct(models,
          story: ductStory, key: ductStory.userId);
      res.fold((l) => showSnackBar(context, l.message), (r) {
        Fluttertoast.showToast(
          msg: 'Duct reshared',
          // toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP_LEFT,
          timeInSecForIosWeb: 8,
          backgroundColor: Colors.cyan,
        );
        //  Navigator.pop(context);
        // if (repliedToUserId.isNotEmpty) {
        //   _notificationController.createNotification(
        //     text: '${user.name} replied to your tweet!',
        //     postId: r.$id,
        //     notificationType: NotificationType.reply,
        //     uid: repliedToUserId,
        //   );
        // }
      });
      state = false;
    } else {
      var id = Uuid().v1();
      DuctStoryModel ductStory = DuctStoryModel(
        key: id,
        ductComment: text,
        commissionUser: user.key,
        cProduct: product?.key,
        profilePic: user.profilePic,
        displayName: user.displayName,
        storyType: storyType,
        userId: user.key,
        timeDifference: DateTime.now().toString(),
        createdAt: fireStore.Timestamp.now().toDate().toString(),
        date: DateFormat("E MMM d y")
            .format(DateTime.fromMicrosecondsSinceEpoch(
                fireStore.Timestamp.now().microsecondsSinceEpoch))
            .toString(),
        userViwed: [],
      );
      FeedModel model = FeedModel(
          key: user.key,
          ductId: user.key,
          ductComment: text,
          user: user,
          commissionUser: user.key,
          storyId: id,
          cProduct: product?.key,
          timeDifference: DateTime.now().toString(),
          createdAt: DateTime.now().toUtc().toString(),
          productVendorId: product?.userId,
          ductType: 0,
          //tags: tags,

          userId: user.userId);
      await _ductApi.creatDuct(model, story: ductStory, key: user.key);
      // res.fold((l) => showSnackBar(context, l.message), (r) {
      //   //  Navigator.pop(context);
      //   // if (repliedToUserId.isNotEmpty) {
      //   //   _notificationController.createNotification(
      //   //     text: '${user.name} replied to your tweet!',
      //   //     postId: r.$id,
      //   //     notificationType: NotificationType.reply,
      //   //     uid: repliedToUserId,
      //   //   );
      //   // }
      // });
      state = false;
    }
  }
  //  void _ductImage({
  //   required File image,
  //   // required String text,
  //    required BuildContext context,
  //   // required String repliedTo,
  //   // required String repliedToUserId,

  // }) async {
  //   state = true;
  //   // final hashtags = _getHashtagsFromText(text);
  //   // String link = _getLinkFromText(text);
  //   // final user = _ref.read(currentUserDetailsProvider).value!;
  //   // final imageLinks = await _storageAPI.uploadImage(images);
  //   // Tweet tweet = Tweet(
  //   //   text: text,
  //   //   hashtags: hashtags,
  //   //   link: link,
  //   //   imageLinks: imageLinks,
  //   //   uid: user.uid,
  //   //   tweetType: TweetType.image,
  //   //   tweetedAt: DateTime.now(),
  //   //   likes: const [],
  //   //   commentIds: const [],
  //   //   id: '',
  //   //   reshareCount: 0,
  //   //   retweetedBy: '',
  //   //   repliedTo: repliedTo,
  //   // );
  //   // final res = await _tweetAPI.shareTweet(tweet);

  //   res.fold((l) => showSnackBar(context, l.message), (r) {
  //     // if (repliedToUserId.isNotEmpty) {
  //     //   _notificationController.createNotification(
  //     //     text: '${user.name} replied to your tweet!',
  //     //     postId: r.$id,
  //     //     notificationType: NotificationType.reply,
  //     //     uid: repliedToUserId,
  //     //   );
  //     // }
  //   });
  //   state = false;
  // }
  void likeDuct(DuctStoryModel ductStory, ViewductsUser user,
      {FeedModel? model}) async {
    // List? likes = ductStory.hearts;
    // FeedModel model = FeedModel();

    if (ductStory.hearts!.contains(user.key) ||
        model!.likeList!.contains(user.key)) {
      ductStory.hearts?.remove(user.key);
      model!.likeList!.remove(user.key);

      final res =
          await _ductApi.likeDuctsStory(ductStory: ductStory, model: model);
      cprint(ductStory.hearts.toString());
      cprint('remove');
      res.fold((l) => null, (r) {
        cprint('you just like this duct');
        // _notificationController.createNotification(
        //   text: '${user.name} liked your tweet!',
        //   postId: tweet.id,
        //   notificationType: NotificationType.like,
        //   uid: tweet.uid,
        // );
      });
    } else {
      ductStory.hearts?.add(user.key);
      model.likeList!.add(user.key);

      cprint(ductStory.hearts.toString());
      final res =
          await _ductApi.likeDuctsStory(ductStory: ductStory, model: model);
      res.fold((l) => null, (r) {
        cprint('you just like this duct');
        // _notificationController.createNotification(
        //   text: '${user.name} liked your tweet!',
        //   postId: tweet.id,
        //   notificationType: NotificationType.like,
        //   uid: tweet.uid,
        // );
      });
      cprint('added');
    }
  }

  void seePinDuctStory(DuctStoryModel ductStory, ViewductsUser user,
      {FeedModel? model}) async {
    if (ductStory.userViwed!.contains(user.key) ||
        model!.userSeen!.contains(user.key)) {
    } else {
      ductStory.userViwed?.add(user.key);
      model.userSeen!.add(user.key.toString());

      cprint(ductStory.userViwed.toString());
      final res =
          await _ductApi.viewPinDuctsStory(ductStory: ductStory, model: model);
      res.fold((l) => null, (r) {});
    }
  }

  void pinDuctStory(DuctStoryModel ductStory, {dynamic pinState}) async {
    ductStory.pinDuct = pinState;

    final res = await _ductApi.pinDuctsStory(ductStory: ductStory);
    res.fold((l) => null, (r) {});
  }

  void ducting({
    File? image,
    String? text,
    required BuildContext context,
    String? productId,
    required ViewductsUser user,
    required int storyType,
    FeedModel? product,
  }) {
    if (text!.isEmpty || text == 'Duct Text') {
      showSnackBar(context, 'Please enter text');
      return;
    }

    if (image != null) {
      // _ductImage(
      //   image: image,

      //   context: context,

      // );
    } else {
      _ductText(
          isUpdating: false,
          reshare: false,
          storyType: storyType,
          text: text,
          context: context,
          productId: productId,
          user: user,
          product: product);
    }
  }

  void updateduct({
    String? image,
    String? videoPath,
    String? text,
    DuctStoryModel? ductStory,
    required BuildContext context,
    String? productId,
    required ViewductsUser user,
    required int storyType,
    FeedModel? product,
  }) {
    if (text!.isEmpty || text == 'Duct Text') {
      showSnackBar(context, 'Please enter text');
      return;
    }

    if (image != null) {
      // _ductImage(
      //   image: image,

      //   context: context,

      // );
    } else {
      _ductText(
          ductStorys: ductStory,
          isUpdating: true,
          reshare: false,
          storyType: storyType,
          text: text,
          context: context,
          productId: productId,
          user: user,
          product: product);
    }
  }

  void reShareDuct(
      {String? image,
      String? videoPath,
      String? text,
      required BuildContext context,
      String? productId,
      required ViewductsUser user,
      required int storyType,
      FeedModel? product,
      bool? reshare,
      DuctStoryModel? ductStory}) {
    if (text!.isEmpty || text == 'Duct Text') {
      showSnackBar(context, 'Please enter text');
      return;
    }

    if (image != null) {
      // _ductImage(
      //   image: image,

      //   context: context,

      // );
    } else if (videoPath != null) {
    } else {
      _ductText(
          isUpdating: false,
          reshare: true,
          storyType: storyType,
          text: text,
          context: context,
          productId: productId,
          user: user,
          ductStorys: ductStory,
          product: product);
    }
  }
}

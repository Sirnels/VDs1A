// ignore_for_file: invalid_use_of_protected_member, unnecessary_null_comparison, file_names, unused_element, duplicate_ignore, invalid_use_of_visible_for_testing_member, deprecated_member_use

import 'dart:io';
import 'dart:ui';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/appwrite.dart' as query;
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as fireStore;
import 'package:file_picker/file_picker.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aws_s3_client/flutter_aws_s3_client.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:path/path.dart' as path;
import 'package:minio/io.dart';
import 'package:minio/minio.dart';
import 'package:uuid/uuid.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:lottie/lottie.dart';
import 'package:timeago/timeago.dart' as timeago;
//import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
//import 'package:storage_path/storage_path.dart';
import 'package:video_player/video_player.dart';
import 'package:viewducts/admin/screens/add_product.dart';
import 'package:viewducts/admin/screens/video_admin_upload.dart';
import 'package:viewducts/helper/constant.dart';
import 'package:viewducts/helper/theme.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler/permission_handler.dart' as camera;
// import 'package:viewducts/page/feed/composeTweet/feedState/composeTweetState.dart';
import 'package:viewducts/page/feed/composeTweet/widget/composeTweetImage.dart';
import 'package:viewducts/page/feed/composeTweet/widget/widgetView.dart';
import 'package:viewducts/page/message/item_Search_bar.dart';
import 'package:viewducts/page/message/local_database.dart';
import 'package:viewducts/page/responsive.dart';
import 'package:viewducts/page/responsiveView.dart';
import 'package:viewducts/page/search/SearchPage.dart';
// import 'package:viewducts/state/feedState.dart';
// import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/cartIcon.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/duct/profile_orders.dart';
import 'package:viewducts/widgets/frosted.dart';
import 'package:viewducts/widgets/newWidget/emptyList.dart';
import 'package:viewducts/widgets/newWidget/title_text.dart';
import 'package:viewducts/model/fileModel.dart';

// ignore: must_be_immutable
class ComposeDuctsPage extends StatefulWidget {
  ComposeDuctsPage(
      {Key? key,
      this.isRetweet,
      this.isTweet = true,
      this.visibleSwitch = true,
      this.viewState,
      this.ductIds,
      this.isVendor = false})
      : super(key: key);
  final bool visibleSwitch;
  final bool? isRetweet;
  final bool isTweet;
  final bool isVendor;
  String? ductIds;
  final _ComposeTweetReplyPageState? viewState;
  @override
  _ComposeTweetReplyPageState createState() => _ComposeTweetReplyPageState();
}

class _ComposeTweetReplyPageState extends State<ComposeDuctsPage> {
  bool isScrollingDown = false;
  FeedModel? model;
  ScrollController scrollcontroller = ScrollController();
  ValueNotifier<bool> visibleSwitch = ValueNotifier(false);
  ValueNotifier<bool> isSelected = ValueNotifier(false);
  ValueNotifier<bool> isTyping = ValueNotifier(false);
  String? ductId;
  File? _image, _video, _thumbnail;
  bool isDropdown = false;
  double? height, width, xPosiion, yPosition;
  late OverlayEntry floatingMenu;
  final TextEditingController _textEditingController = TextEditingController();
  bool typing = false;

  final bool _isPlaying = false;
  bool _progressVisibility = false;
  VideoPlayerController? _videoPlayerController;
  Duration? _duration;
  List<dynamic> itemList = [];
  final audioPlayer = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  File? audioFile;
  bool isPlaying = false;
  @override
  void initState() {
    super.initState();
    getOrders();
    ductId = widget.ductIds;
    widget.isVendor == true
        ? isSelected.value = true
        : isSelected.value = false;
    audioPlayer.onPlayerStateChanged.listen((state) {
      //  setState(() {
      isPlaying = state == PlayerState.playing;
      // });
    });
    audioPlayer.onDurationChanged.listen((durationChange) {
      setState(() {
        duration = durationChange;
      });
    });
  }

  getOrders() async {
    // await userCartController.listenToOrders();
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  Future<bool?> _showDialog() {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return frostedYellow(
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.transparent,
            child: frostedYellow(
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(0, 11),
                                    blurRadius: 11,
                                    color: Colors.black.withOpacity(0.06))
                              ],
                              borderRadius: BorderRadius.circular(18),
                              color: CupertinoColors.white),
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.maybePop(context);
                            },
                            child: const Text(
                              'File Size Must be less than 20mb',
                              style: TextStyle(fontWeight: FontWeight.w200),
                            ),
                          )),
                    ),
                    // Container(
                    //   height: Get.height * 0.3,
                    //   width: Get.height * 0.2,
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(20)),
                    //   child: SafeArea(
                    //     child: Stack(
                    //       children: <Widget>[
                    //         Center(
                    //           child: ModalTile(
                    //             title: "File Exceeds Limit",
                    //             subtitle: "Please reduce your file size",
                    //             icon: Icons.tab,
                    //             onTap: () async {
                    //               Navigator.maybePop(context);
                    //             },
                    //           ),
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void initListOrdershistory(String? user) async {
    // // final feedState = Provider.of<FeedState>(context, listen: false);
    // //final auth = Provider.of<AuthState>(context, listen: false);
    // List data = await feedState.listPlacedOrder(user);
    // //Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    // setState(() {
    //   itemList = data;

    // });
  }

  void _onCrossIconPressed() {
    setState(() {
      isUploading = false;
      _image = null;
      _video = null;
      _thumbnail = null;
    });
  }

  void _onCrossThumbnail() async {
    // File file = await ImagePicker.pickImage(
    //     source: ImageSource.gallery, imageQuality: 85);
    // setState(() {
    //   _image = null;
    //   _thumbnail = file;
    // });
  }

  Future<Directory> getTempDir() async {
    return Directory.systemTemp;
  }

  int qaulity = 30;
  var id = Uuid().v1();
  String region = "us-east-1";
  String bucketId = "storage-viewduct";
  // String accessKey = "I6AC8ZFJQ5Z75PC9HXLA";
  // String secretKey = "qdiwW0clT8558Ual2NT8IVcqq7kByFMLCBBkERuO";
  bool isUploading = false;
  bool isUploadingStateError = false;

  /// Submit tweet to save in firebase database
  void _submitButton() async {
    try {
//       FToast().init(Get.context!);
//       // var feedState = Provider.of<FeedState>(context, listen: false);

//       FeedModel tweetModel = createTweetModel();
//       FeedModel localDucts = createTweetModel();
//       DuctStoryModel ductStoryModel = createDuctStory();
//       // kScreenloader.showLoader(context);

//       /// If tweet contain image
//       /// First image is uploaded on firebase storage
//       /// After sucessfull image upload to firebase storage it returns image path
//       /// Add this image path to tweet model and save to firebase database
//       if (_image != null) {
//         setState(() {
//           isUploading = true;
//           isUploadingStateError = false;
//         });
//         //  await Future.delayed(const Duration(seconds: 8), () {});
//         // //   kScreenloader.showLoader(context);
//         // //  Storage storage = Storage(clientConnect());
//         final keyImagePath =
//             '${DateTime.now().toUtc().toString().replaceAll(RegExp(r'\.\d*Z$'), 'Z').replaceAll(RegExp(r'[:-]|\.\d{3}'), '').split(' ').join('T')}${path.extension(_image!.path.toString())}';
//         final AwsS3Client s3client = AwsS3Client(
//             region: userCartController.wasabiAws.value.region.toString(),
//             host: "s3.wasabisys.com",
//             bucketId: "storage-viewduct",
//             accessKey: userCartController.wasabiAws.value.accessKey.toString(),
//             secretKey: userCartController.wasabiAws.value.secretKey.toString());
//         final minio = Minio(
//             endPoint: userCartController.wasabiAws.value.endPoint.toString(),
//             accessKey: userCartController.wasabiAws.value.accessKey.toString(),
//             secretKey: userCartController.wasabiAws.value.secretKey.toString(),
//             region: userCartController.wasabiAws.value.region.toString());

//         await minio
//             .fPutObject(userCartController.wasabiAws.value.buckedId.toString(),
//                 keyImagePath, _image!.path.toString())
//             .onError((error, stackTrace) {
//           setState(() {
//             isUploading = false;
//             isUploadingStateError = true;
//           });
//           Fluttertoast.showToast(
//             msg: 'Network timeout',
//             // toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.TOP_LEFT,
//             timeInSecForIosWeb: 10,
//             backgroundColor: CupertinoColors.systemRed,
//           );
//           if (kDebugMode) {
//             cprint(error.toString());
//           }
//           return error.toString();
//         });

//         var uplodedImagePath =
//             await s3client.buildSignedGetParams(key: keyImagePath).uri;
//         // await storage
//         //     .createFile(
//         //         bucketId: ductFile,
//         //         fileId: "unique()",
//         //         permissions: [query.Permission.read(Role.users())],
//         //         file: InputFile(
//         //             path: '${_image!.path}',
//         //             filename:
//         //                 '${DateTime.now().toUtc().toString().replaceAll(RegExp(r'\.\d*Z$'), 'Z').replaceAll(RegExp(r'[:-]|\.\d{3}'), '').split(' ').join('T')}${path.extension(_image!.path)}'))
//         //     .then((storageFilePath) {
//         localDucts.imagePath = _image!.path;
//         tweetModel.imagePath = uplodedImagePath.toString();
//         ductStoryModel.imagePath = uplodedImagePath.toString();
//         ductStoryModel.storyType = 1;
//         // }).then((value) async {
//         if (audioFile != null) {
//           final AwsS3Client s3client = AwsS3Client(
//               region: userCartController.wasabiAws.value.region.toString(),
//               host: "s3.wasabisys.com",
//               bucketId: "storage-viewduct",
//               accessKey:
//                   userCartController.wasabiAws.value.accessKey.toString(),
//               secretKey:
//                   userCartController.wasabiAws.value.secretKey.toString());
//           final key =
//               '${DateTime.now().toUtc().toString().replaceAll(RegExp(r'\.\d*Z$'), 'Z').replaceAll(RegExp(r'[:-]|\.\d{3}'), '').split(' ').join('T')}${path.extension(audioFile!.path)}';
//           var uplodedaudioTagPath =
//               await s3client.buildSignedGetParams(key: key).uri;
//           final minio = Minio(
//               endPoint: userCartController.wasabiAws.value.endPoint.toString(),
//               accessKey:
//                   userCartController.wasabiAws.value.accessKey.toString(),
//               secretKey:
//                   userCartController.wasabiAws.value.secretKey.toString(),
//               region: userCartController.wasabiAws.value.region.toString());

//           await minio
//               .fPutObject(
//                   userCartController.wasabiAws.value.buckedId.toString(),
//                   key,
//                   audioFile!.path)
//               .onError((error, stackTrace) {
//             setState(() {
//               isUploading = false;
//               isUploadingStateError = true;
//             });
//             Fluttertoast.showToast(
//               msg: 'Network timeout',
//               // toastLength: Toast.LENGTH_SHORT,
//               gravity: ToastGravity.TOP_LEFT,
//               timeInSecForIosWeb: 10,
//               backgroundColor: CupertinoColors.systemRed,
//             );
//             if (kDebugMode) {
//               cprint(error.toString());
//             }
//             return error.toString();
//           });
//           cprint(uplodedaudioTagPath.toString());
//           localDucts.audioTag = uplodedaudioTagPath.toString();
//           ductStoryModel.audioTag = uplodedaudioTagPath.toString();
//           tweetModel.audioTag = uplodedaudioTagPath.toString();
//         }

//         /// If type of tweet is new tweet
//         if (widget.isTweet && isUploadingStateError == false) {
//           await SQLHelper.createLocalDucts(localDucts);
//           await feedState.createDuct(tweetModel, key: authState.appUser!.$id);
//           await feedState.createDuctStory(ductStoryModel, key: id);
//         }

//         /// If type of tweet is  retweet
//         else if (widget.isRetweet!) {
//           await feedState.createvDuct(tweetModel);
//         }

//         /// If type of tweet is new comment tweet
//         else {
//           await feedState.addcommentToPost(tweetModel);
//         }
//         //  });
// //kScreenloader.showLoader(context);
//         if (isUploadingStateError == false) {
//           setState(() {
//             isUploading = false;
//           });
//           //    kScreenloader.hideLoader();
//           Fluttertoast.showToast(
//             msg: 'You just ducted',
//             // toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.TOP_LEFT,
//             timeInSecForIosWeb: 8,
//             backgroundColor: Colors.cyan,
//           );

//           /// Navigate back to home page
//           Navigator.pop(context);
//           //  });
//         }
//       }

//       /// if duct has a video
//       else if (_video != null && _thumbnail != null) {
//         kScreenloader.showLoader(context);
//         final keyThumbnailPath =
//             '${DateTime.now().toUtc().toString().replaceAll(RegExp(r'\.\d*Z$'), 'Z').replaceAll(RegExp(r'[:-]|\.\d{3}'), '').split(' ').join('T')}${path.extension(_thumbnail!.path.toString())}';
//         final AwsS3Client s3clients = AwsS3Client(
//             region: userCartController.wasabiAws.value.region.toString(),
//             host: "s3.wasabisys.com",
//             bucketId: "storage-viewduct",
//             accessKey: userCartController.wasabiAws.value.accessKey.toString(),
//             secretKey: userCartController.wasabiAws.value.secretKey.toString());
//         final minio = Minio(
//             endPoint: userCartController.wasabiAws.value.endPoint.toString(),
//             accessKey: userCartController.wasabiAws.value.accessKey.toString(),
//             secretKey: userCartController.wasabiAws.value.secretKey.toString(),
//             region: userCartController.wasabiAws.value.region.toString());

//         await minio
//             .fPutObject(userCartController.wasabiAws.value.buckedId.toString(),
//                 keyThumbnailPath, _thumbnail!.path.toString())
//             .onError((error, stackTrace) {
//           setState(() {
//             isUploading = false;
//             isUploadingStateError = true;
//           });
//           Fluttertoast.showToast(
//             msg: 'Network timeout',
//             // toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.TOP_LEFT,
//             timeInSecForIosWeb: 10,
//             backgroundColor: CupertinoColors.systemRed,
//           );
//           if (kDebugMode) {
//             cprint(error.toString());
//           }
//           return error.toString();
//         });
//         var uplodeThumbnailPath =
//             await s3clients.buildSignedGetParams(key: keyThumbnailPath).uri;
//         // Storage storage = Storage(clientConnect());
//         // await storage
//         //     .createFile(
//         //         bucketId: ductFile,
//         //         fileId: "unique()",
//         //         permissions: [query.Permission.read(Role.users())],
//         //         file: InputFile(path: _thumbnail?.path))
//         //     .then((storageFilePath) {
//         localDucts.imagePath = _thumbnail!.path;
//         tweetModel.imagePath = uplodeThumbnailPath.toString();
//         // }).then((value) async {
//         final videoKeypath =
//             '${DateTime.now().toUtc().toString().replaceAll(RegExp(r'\.\d*Z$'), 'Z').replaceAll(RegExp(r'[:-]|\.\d{3}'), '').split(' ').join('T')}${path.extension(_video!.path)}';
//         final AwsS3Client s3client = AwsS3Client(
//             region: userCartController.wasabiAws.value.region.toString(),
//             host: "s3.wasabisys.com",
//             bucketId: "storage-viewduct",
//             accessKey: userCartController.wasabiAws.value.accessKey.toString(),
//             secretKey: userCartController.wasabiAws.value.secretKey.toString());
//         var uplodedVideoPath =
//             await s3client.buildSignedGetParams(key: videoKeypath).uri;

//         await minio
//             .fPutObject(userCartController.wasabiAws.value.buckedId.toString(),
//                 videoKeypath, _video!.path)
//             .onError((error, stackTrace) {
//           setState(() {
//             isUploading = false;
//             isUploadingStateError = true;
//           });
//           Fluttertoast.showToast(
//             msg: 'Network timeout',
//             // toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.TOP_LEFT,
//             timeInSecForIosWeb: 10,
//             backgroundColor: CupertinoColors.systemRed,
//           );
//           if (kDebugMode) {
//             cprint(error.toString());
//           }
//           return error.toString();
//         });
//         localDucts.videoPath = uplodedVideoPath.toString();
//         localDucts.duration = _duration?.inSeconds.toString();
//         tweetModel.videoPath = uplodedVideoPath.toString();
//         tweetModel.duration = _duration?.inSeconds.toString();
//         ductStoryModel.duration = _duration!.inSeconds.toString();
//         ductStoryModel.videoPath = uplodedVideoPath.toString();
//         ductStoryModel.storyType = 2;
//         // Storage storage = Storage(clientConnect());
//         // await storage
//         //     .createFile(
//         //         bucketId: ductFile,
//         //         fileId: "unique()",
//         //         read: [
//         //           'role:member',
//         //         ],
//         //         file: InputFile(path: _video?.path))
//         //     .then((storageFilePath) {
//         //   tweetModel.videoPath = '$uplodedVideoPath';
//         //   tweetModel.duration = _duration?.inSeconds.toString();
//         //   ductStoryModel.duration = _duration!.inSeconds.toString();
//         // });
//         if (widget.isTweet) {
//           await SQLHelper.createLocalDucts(localDucts);
//           await feedState.createDuct(tweetModel, key: authState.appUser!.$id);
//           await feedState.createDuctStory(ductStoryModel, key: id);
//         }

//         /// If type of tweet is  retweet
//         else if (widget.isRetweet!) {
//           await feedState.createvDuct(tweetModel);
//         }

//         /// If type of tweet is new comment tweet
//         else {
//           await feedState.addcommentToPost(tweetModel);
//         }
//         //});   kScreenloader.hideLoader();
//         if (isUploadingStateError == false) {
//           setState(() {
//             isUploading = false;
//           });
//           //    kScreenloader.hideLoader();
//           Fluttertoast.showToast(
//             msg: 'You just ducted',
//             // toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.TOP_LEFT,
//             timeInSecForIosWeb: 8,
//             backgroundColor: Colors.cyan,
//           );

//           /// Navigate back to home page
//           Navigator.pop(context);
//           //  });
//         }
//       }

//       /// If tweet did not contain image
//       else {
//         if (audioFile != null) {
//           kScreenloader.showLoader(context);
//           final AwsS3Client s3client = AwsS3Client(
//               region: userCartController.wasabiAws.value.region.toString(),
//               host: "s3.wasabisys.com",
//               bucketId: "storage-viewduct",
//               accessKey:
//                   userCartController.wasabiAws.value.accessKey.toString(),
//               secretKey:
//                   userCartController.wasabiAws.value.secretKey.toString());
//           var uplodedaudioTagPath = await s3client
//               .buildSignedGetParams(
//                   key:
//                       '${DateTime.now().toUtc().toString().replaceAll(RegExp(r'\.\d*Z$'), 'Z').replaceAll(RegExp(r'[:-]|\.\d{3}'), '').split(' ').join('T')}${path.extension(audioFile!.path)}')
//               .uri;
//           final minio = Minio(
//               endPoint: userCartController.wasabiAws.value.endPoint.toString(),
//               accessKey:
//                   userCartController.wasabiAws.value.accessKey.toString(),
//               secretKey:
//                   userCartController.wasabiAws.value.secretKey.toString(),
//               region: userCartController.wasabiAws.value.region.toString());

//           await minio
//               .fPutObject(
//                   userCartController.wasabiAws.value.buckedId.toString(),
//                   '${DateTime.now().toUtc().toString().replaceAll(RegExp(r'\.\d*Z$'), 'Z').replaceAll(RegExp(r'[:-]|\.\d{3}'), '').split(' ').join('T')}${path.extension(audioFile!.path)}',
//                   audioFile!.path)
//               .onError((error, stackTrace) {
//             setState(() {
//               isUploading = false;
//               isUploadingStateError = true;
//             });
//             Fluttertoast.showToast(
//               msg: 'Network timeout',
//               // toastLength: Toast.LENGTH_SHORT,
//               gravity: ToastGravity.TOP_LEFT,
//               timeInSecForIosWeb: 10,
//               backgroundColor: CupertinoColors.systemRed,
//             );
//             if (kDebugMode) {
//               cprint(error.toString());
//             }
//             return error.toString();
//           });
//           cprint(uplodedaudioTagPath.toString());
//           ductStoryModel.audioTag = uplodedaudioTagPath.toString();
//           tweetModel.audioTag = uplodedaudioTagPath.toString();
//         }

//         /// If type of tweet is new tweet
//         if (widget.isTweet) {
//           if (_textEditingController.text.isEmpty ||
//               _textEditingController.text.length > 280) {
//             Fluttertoast.showToast(
//               msg: 'Ducts can\'t be Empty ',
//               // toastLength: Toast.LENGTH_SHORT,
//               gravity: ToastGravity.TOP_LEFT,
//               timeInSecForIosWeb: 8,
//               backgroundColor: CupertinoColors.systemRed,
//             );
//             ;
//           } else if (isUploadingStateError == false) {
//             ductStoryModel.storyType = 0;
//             await SQLHelper.createLocalDucts(localDucts);
//             feedState.createDuct(tweetModel, key: authState.appUser!.$id);
//             feedState.createDuctStory(ductStoryModel, key: id);
//             kScreenloader.hideLoader();
//             Fluttertoast.showToast(
//               msg: 'You just ducted',
//               // toastLength: Toast.LENGTH_SHORT,
//               gravity: ToastGravity.TOP_LEFT,
//               timeInSecForIosWeb: 8,
//               backgroundColor: Colors.cyan,
//             );

//             /// Navigate back to home page
//             Navigator.pop(context);
//             //  });
//           }
//         }

//         /// If type of tweet is  retweet
//         else if (widget.isRetweet!) {
//           await feedState.createDuct(tweetModel, key: authState.appUser!.$id);
//         }

//         /// If type of tweet is new comment tweet
//         else {
//           await feedState.addcommentToPost(tweetModel);
//         }
//       }
    } on AppwriteException catch (e) {
      kScreenloader.hideLoader();
      FToast().showToast(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
                // width:
                //    Get.width * 0.3,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(0, 11),
                          blurRadius: 11,
                          color: Colors.black.withOpacity(0.06))
                    ],
                    borderRadius: BorderRadius.circular(18),
                    color: CupertinoColors.systemRed),
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  'please check your file',
                  style: TextStyle(
                      color: CupertinoColors.darkBackgroundGray,
                      fontWeight: FontWeight.w900),
                )),
          ),
          gravity: ToastGravity.TOP_LEFT,
          toastDuration: Duration(seconds: 3));
      cprint('$e submiste');
    }
  }

  /// Return Tweet model which is either a new Tweet , retweet model or comment model
  /// If tweet is new tweet then `parentkey` and `childRetwetkey` should be null
  /// IF tweet is a comment then it should have `parentkey`
  /// IF tweet is a retweet then it should have `childRetwetkey`
  DuctStoryModel createDuctStory() {
    DuctStoryModel ductStory = DuctStoryModel(
        // key: id,
        // ductComment: _textEditingController.text,
        // commissionUser: authState.userModel?.key,
        // cProduct: ductId,
        // profilePic: authState.userModel?.profilePic,
        // displayName: authState.userModel?.displayName,
        // userId: authState.userModel?.key,
        // timeDifference: DateTime.now().toString(),
        // createdAt: fireStore.Timestamp.now().toDate().toString(),
        // date: DateFormat("E MMM d y")
        //     .format(DateTime.fromMicrosecondsSinceEpoch(
        //         fireStore.Timestamp.now().microsecondsSinceEpoch))
        //     .toString(),
        // userViwed: [],
        );
    return ductStory;
  }

  FeedModel createTweetModel() {
    // var feedState = Provider.of<FeedState>(context, listen: false);
    // var feedState = Provider.of<AuthState>(context, listen: false);
    // var myUser = authState.userModel!;
    // var profilePic = myUser.profilePic ?? dummyProfilePic;
    // var commentedUser = ViewductsUser(
    //     displayName: myUser.displayName ?? myUser.email!.split('@')[0],
    //     profilePic: profilePic,
    //     userId: myUser.userId,
    //     isVerified: authState.userModel!.isVerified,
    //     userName: authState.userModel!.userName);
    // var tags = getHashTags(_textEditingController.text);

    FeedModel reply = FeedModel(
        // key: authState.userModel?.key,
        // ductId: authState.userModel?.key,
        // ductComment: _textEditingController.text,
        // user: commentedUser,
        // commissionUser: authState.userModel?.key,
        // cProduct: ductId,
        // timeDifference: DateTime.now().toString(),
        // createdAt: DateTime.now().toUtc().toString(),
        // tags: tags,
        // parentkey: widget.isTweet
        //     ? null
        //     : widget.isRetweet!
        //         ? null
        //         : feedState.ductToReplyModel!.value!.key,
        // childVductkey: widget.isTweet
        //     ? null
        //     : widget.isRetweet!
        //         ? model!.key
        //         : null,
        // userId: myUser.userId
        );
    return reply;
  }

  // ignore: unused_element
  OverlayEntry _mediaOverlayView(BuildContext context) {
    return OverlayEntry(builder: (context) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () {
            setState(() {
              if (isDropdown) {
                floatingMenu.remove();
              } else {
                // _postProsductoption();
                floatingMenu = _mediaOverlayView(
                  context,
                );
                Overlay.of(context).insert(floatingMenu);
              }

              isDropdown = !isDropdown;
            });
          },
          child: frostedYellow(Stack(
            children: [
              ComposeMediaView(image: image, selectedModel: selectedModel)
            ],
          )),
        ),
      );
    });
  }

  // ignore: unused_element
  OverlayEntry _videoView(
    BuildContext contexts,
  ) {
    var appSize = MediaQuery.of(context).size;

    // double heightFactor = 300 / fullHeight(context);
    //  var authState = Provider.of<AuthState>(context, listen: false);
    //  var feedState = Provider.of<FeedState>(context, listen: false);
    // final List<FeedModel> productlist =
    //     feedState.getAllProductList(authState.userId);

    Future<File?> _saveVideo() async {
      setState(() {
        _progressVisibility = true;
      });
      File? _trimVideo;

      // await trimmer
      //     .saveTrimmedVideo(startValue: _startValue, endValue: _endValue)
      //     .then((value) {
      //   //trimmer.getVideoFile();

      //   setState(() {
      //     _progressVisibility = false;

      //     _trimVideo = File(value);
      //   });
      // });
      // final _thumbnailPath = await VideoThumbnail.thumbnailFile(
      //     video: _trimVideo.path, imageFormat: ImageFormat.PNG, quality: 30);

      // setState(() {
      //   _thumbnail = File(_thumbnailPath);
      // });
      // cprint('$_thumbnailPath');
      // cprint('Original: ${_trimVideo.length()}');

      return _trimVideo;
    }
    // var userImage = feedState.chatUser.profilePic;
    // String id = widget.userProfileId ?? feedState.chatUser.userId;

    return OverlayEntry(builder: (context) {
      // if (feedState.productlist != null && feedState.productlist!.isNotEmpty) {
      //   // .where((x) => x.userId == id)
      //   // .toList();
      // }
      return GestureDetector(
        onTap: () {
          setState(() {
            _video = null;
            _image = null;
            if (isDropdown) {
              floatingMenu.remove();
            } else {
              // _postProsductoption();
              floatingMenu = _videoView(
                context,
              );
              Overlay.of(context).insert(floatingMenu);
            }

            isDropdown = !isDropdown;
          });
        },
        child: SafeArea(
          child: frostedPink(
            SizedBox(
              height: appSize.width,
              width: appSize.width,
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    child: Material(
                      color: Colors.transparent,
                      child: SizedBox(
                        height: fullHeight(context),
                        width: fullWidth(context),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: _progressVisibility
                                        ? null
                                        : () async {
                                            _saveVideo().then((filePath) {
                                              setState(() {
                                                _video = filePath;
                                              });
                                              // cprint('$_video');

                                              // if (isDropdown) {
                                              //   floatingMenu.remove();
                                              // } else {
                                              //   // _postProsductoption();
                                              //   floatingMenu = _videoView(
                                              //       context, trimmer);
                                              //   Overlay.of(context)
                                              //       .insert(floatingMenu);
                                              // }

                                              isDropdown = !isDropdown;
                                              if (_video != null) {
                                                setState(() {
                                                  _videoPlayerController =
                                                      VideoPlayerController
                                                          .file(_video!)
                                                        ..initialize();
                                                });
                                              }
                                              if (_video == null) {
                                                return Container();
                                              }
                                            });
                                          },
                                    child: Material(
                                      elevation: 20,
                                      borderRadius: BorderRadius.circular(20),
                                      child: frostedGreen(Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: customTitleText(
                                          'Save',
                                        ),
                                      )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Stack(
                              children: [
                                Visibility(
                                  visible: _progressVisibility,
                                  child: const LinearProgressIndicator(
                                    backgroundColor: Colors.yellow,
                                  ),
                                ),
                              ],
                            ),
                            // Stack(
                            //   children: [
                            //     Expanded(child: VideoViewer()),
                            //   ],
                            // ),
                            // Center(
                            //   child: TrimEditor(
                            //     borderPaintColor: Colors.yellow[200],
                            //     maxVideoLength: Duration(seconds: 15),
                            //     viewerWidth: fullWidth(context),
                            //     viewerHeight: fullWidth(context) * 0.25,
                            //     onChangeStart: (startValue) {
                            //       _startValue = startValue;
                            //     },
                            //     onChangeEnd: (endValue) {
                            //       _endValue = endValue;
                            //     },
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(100),
                      child: InkWell(
                        onTap: () async {
                          // bool playbackState =
                          //     trimmer.videPlaybackControl(
                          //         startValue: _startValue,
                          //         endValue: _endValue);
                          // setState(() {
                          //   _isPlaying = playbackState;
                          // });
                        },
                        child: _isPlaying
                            ? CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.transparent,
                                child: Image.asset('assets/pause.png'),
                              )
                            : CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.transparent,
                                child: Image.asset('assets/play-button.png'),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  // ignore: unused_element
  OverlayEntry _mediaView(
    BuildContext contexts,
  ) {
    // double heightFactor = 300 / fullHeight(context);
    // var authState = Provider.of<AuthState>(context, listen: false);

    return OverlayEntry(
      builder: (context) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _video = null;
              _image = null;
              if (isDropdown) {
                floatingMenu.remove();
              } else {
                // _postProsductoption();
                floatingMenu = _mediaView(
                  context,
                );
                Overlay.of(context).insert(floatingMenu);
              }

              isDropdown = !isDropdown;
            });
          },
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: frostedPink(
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: const Icon(Icons.close),
                              ),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      // if (_image == null) {
                                      //   _image = File(image);
                                      // }
                                      if (isDropdown) {
                                        floatingMenu.remove();
                                      } else {
                                        // _postProsductoption();
                                        floatingMenu = _mediaView(
                                          context,
                                        );
                                        Overlay.of(context)
                                            .insert(floatingMenu);
                                      }

                                      isDropdown = !isDropdown;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      customTitleText('Next'),
                                      const Icon(Icons.arrow_forward_ios)
                                    ],
                                  ))
                            ],
                          ),
                          ComposeMediaView(
                              image: image, selectedModel: selectedModel),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void setImage(ImageSource source) async {
    /// status can either be: granted, denied, restricted or permanentlyDenied
    var status = await camera.Permission.camera.status;
    if (status.isGranted) {
      XTypeGroup typeGroup = XTypeGroup(
        extensions: <String>['jpg', 'png'],
      );

      if (Platform.isMacOS || Platform.isWindows) {
        final file =
            await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);
        setState(() {
          _image = File(file!.path);
        });
      } else {
        PickedFile? file = await ImagePicker.platform
            .pickImage(source: ImageSource.gallery, imageQuality: 100);
        cprint('${file?.path} file path');
        setState(() {
          _image = File(file!.path);
        });
      }
    } else if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
      if (await camera.Permission.camera.request().isGranted) {
        XTypeGroup typeGroup = XTypeGroup(
          extensions: <String>['jpg', 'png'],
        );

        if (Platform.isMacOS || Platform.isWindows) {
          final file =
              await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);
          setState(() {
            _image = File(file!.path);
          });
        } else {
          PickedFile? file = await ImagePicker.platform
              .pickImage(source: ImageSource.gallery, imageQuality: 100);
          cprint('${file?.path} file path');
          setState(() {
            _image = File(file!.path);
          });
        }
      }
    }
  }

  void setVideo(ImageSource source) async {
    // ignore: invalid_use_of_visible_for_testing_member
    await ImagePicker.platform
        .pickVideo(
      source: ImageSource.gallery,
    )
        .then((value) {
      setState(() {
        _video = File(value!.path);
      });
    });
  }

  FileModel? selectedModel;
  String? image;

  late List<FileModel> imageFiles;
  // List<Widget>getFiles() {
  //   return imageFiles.map((e) => customTitleText(e.folder));
  // }
  List<DropdownMenuItem> getFiles() {
    return imageFiles
        .map((e) => DropdownMenuItem(
              child: frostedOrange(
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: customTitleText(
                    e.folder,
                    //style: TextStyle(fontWeight: FontWeight.bold)
                  ),
                ),
              ),
              value: e,
            ))
        .toList();
  }

  Widget invoiceHeader(OrderViewProduct? cartItem) {
    return frostedYellow(
      Container(
        width: Get.width,
        //  width: ScreenConfig.deviceWidth,
        //height: ScreenConfig.getProportionalHeight(374),
        color: CupertinoColors.systemYellow,
        padding: EdgeInsets.only(
          top: Get.width * 0.04,
          left: Get.width * 0.04,
          // right: ScreenConfig.getProportionalWidth(40)
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Get.width * 0.1,
                  ),
                  Text(
                    "Orders",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: Get.width * 0.06),
                  ),
                  // SizedBox(
                  //   height: Get.width * 0.04,
                  // ),
                  // topHeaderText("#20/07/1203"),
                  SizedBox(
                    height: Get.width * 0.04,
                  ),

                  // ignore: todo
                  // TODO: form get actual date and format it accondingly
                  customText(
                    timeago.format(cartItem!.placedDate!.toDate()).toString(),
                  ),
                ],
              ),
              SizedBox(
                height: Get.width * 0.04,
              ),
              SizedBox(
                width: Get.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "assets/groceries.png",
                      height: Get.width * 0.2,
                    ),
                    SizedBox(
                        width: Get.width * 0.7, child: addressColumn(cartItem))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Column addressColumn(OrderViewProduct? cartItem) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: const [
            Text(
              "Delivery address",
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          cartItem!.shippingAddress.toString(),
        ),
        const SizedBox(
          height: 10,
        ),
        // Text("Kimihurura")
      ],
    );
  }

  Text topHeaderText(String label) {
    return Text(label,
        style: TextStyle(
            color: Colors.white.withOpacity(0.6), fontSize: Get.width * 0.04));
  }

  void _orderList(BuildContext context, OrderViewProduct? cartItem) async {
    showModalBottomSheet(
        backgroundColor: Colors.red,
        // bounce: true,
        context: context,
        builder: (context) => Stack(
              children: <Widget>[
                SizedBox(
                  width: Get.width,
                  height: Get.height,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        invoiceHeader(cartItem),
                        Stack(
                          children: [
                            Container(
                              height: Get.height,
                              width: Get.width,
                              decoration: BoxDecoration(
                                // borderRadius: BorderRadius.circular(100),
                                //color: Colors.blueGrey[50]
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.yellow[100]!.withOpacity(0.3),
                                    Colors.yellow[200]!.withOpacity(0.1),
                                    Colors.yellowAccent[100]!.withOpacity(0.2)
                                    // Color(0xfffbfbfb),
                                    // Color(0xfff7f7f7),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: -250,
                              child: Transform.rotate(
                                angle: 90,
                                child: Container(
                                  height: fullWidth(context) * 0.8,
                                  width: fullWidth(context),
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/ankara3.jpg'))),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 40,
                              right: -260,
                              child: Transform.rotate(
                                angle: 30,
                                child: Container(
                                  height: fullWidth(context) * 0.8,
                                  width: fullWidth(context),
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/ankkara1.jpg'))),
                                ),
                              ),
                            ),
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text("State",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: Get.width * 0.04)),
                                      SizedBox(
                                        width: Get.width * 0.04,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          height: Get.width * 0.1,

                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            color: cartItem?.orderState ==
                                                    'shipping'
                                                ? Colors.yellow
                                                : cartItem?.orderState ==
                                                            'delivered' ||
                                                        cartItem?.orderState ==
                                                            'products recieved'
                                                    ? CupertinoColors
                                                        .systemGreen
                                                    : iAccentColor2,
                                          ),
                                          // shape: RoundedRectangleBorder(
                                          //     borderRadius:
                                          //         BorderRadius.circular(18)),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.add),
                                              cartItem?.orderState == 'shipping'
                                                  ? const Text(
                                                      'Shipping',
                                                      style: TextStyle(
                                                          //fontSize: 17.0,
                                                          // color: Colors.white,
                                                          ),
                                                    )
                                                  : cartItem?.orderState ==
                                                          'delivered'
                                                      ? const Text(
                                                          'Delivered',
                                                          style: TextStyle(
                                                              //  fontSize: 17.0,
                                                              // color: Colors.white,
                                                              ),
                                                        )
                                                      : cartItem?.orderState ==
                                                              'products recieved'
                                                          ? const Text(
                                                              'Products Recieved',
                                                              style: TextStyle(
                                                                //  fontSize: 17.0,
                                                                color: CupertinoColors
                                                                    .lightBackgroundGray,
                                                              ),
                                                            )
                                                          : cartItem?.orderState ==
                                                                  'confirm'
                                                              ? const Text(
                                                                  'Order Confirmed',
                                                                  style: TextStyle(
                                                                      //  fontSize: 17.0,
                                                                      // color: Colors.white,
                                                                      ),
                                                                )
                                                              : const Text(
                                                                  'Processing',
                                                                  style: TextStyle(
                                                                      // fontSize: 17.0,
                                                                      //color: Colors.white,
                                                                      ),
                                                                )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: cartItem!.items!
                                        .map((item) => GestureDetector(
                                              onTap: () {
                                                if (isSelected.value) {
                                                  setState(() {
                                                    ductId =
                                                        // itemList[
                                                        //     index]['id'];
                                                        item.productId;
                                                    isSelected.value;
                                                  });
                                                  Get.back();
                                                  setState(() {});
                                                } else {
                                                  setState(() {
                                                    ductId = item.productId;
                                                    // itemList[
                                                    //     index]['id'];
                                                    isSelected.value =
                                                        !isSelected.value;
                                                  });
                                                  Get.back();
                                                  setState(() {});
                                                }
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                    height: Get.height * 0.23,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                Get.width *
                                                                    0.04),
                                                    color: iPrimarryColor,
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                              height:
                                                                  Get.width *
                                                                      0.04),

                                                          //   addItemAction(),
                                                          // SizedBox(
                                                          //   height: Get.width *
                                                          //       0.04,
                                                          // ),
                                                          Container(
                                                            height:
                                                                Get.width * 0.2,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        Get.width *
                                                                            0.04),
                                                            decoration:
                                                                BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                          offset: const Offset(0,
                                                                              11),
                                                                          blurRadius:
                                                                              11,
                                                                          color: Colors
                                                                              .black
                                                                              .withOpacity(0.06))
                                                                    ],
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20)),
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  item.quantity
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.6),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                // CircleAvatar(
                                                                //   radius: 25,
                                                                //   backgroundColor:
                                                                //       Colors
                                                                //           .transparent,
                                                                //   child:
                                                                //       FutureBuilder(
                                                                //     future: storage.getFileView(
                                                                //         bucketId: productBucketId,
                                                                //         fileId: feedState.productlist!
                                                                //             .firstWhere(
                                                                //               (e) => e.key == item.productId,
                                                                //               orElse: () => model,
                                                                //             )
                                                                //             .imagePath
                                                                //             .toString()), //works for both public file and private file, for private files you need to be logged in
                                                                //     builder:
                                                                //         (context,
                                                                //             snapshot) {
                                                                //       return snapshot.hasData &&
                                                                //               snapshot.data !=
                                                                //                   null
                                                                //           ? Image.memory(
                                                                //               snapshot.data as Uint8List,
                                                                //               width: Get.height * 0.3,
                                                                //               height: Get.height * 0.4,
                                                                //               fit: BoxFit.contain)
                                                                //           : Center(
                                                                //               child: SizedBox(
                                                                //               width: Get.height * 0.2,
                                                                //               height: Get.height * 0.2,
                                                                //               child: LoadingIndicator(
                                                                //                   indicatorType: Indicator.ballTrianglePath,

                                                                //                   /// Required, The loading type of the widget
                                                                //                   colors: const [Colors.pink, Colors.green, Colors.blue],

                                                                //                   /// Optional, The color collections
                                                                //                   strokeWidth: 0.5,

                                                                //                   /// Optional, The stroke of the line, only applicable to widget which contains line
                                                                //                   backgroundColor: Colors.transparent,

                                                                //                   /// Optional, Background of the widget
                                                                //                   pathBackgroundColor: Colors.blue

                                                                //                   /// Optional, the stroke backgroundColor
                                                                //                   ),
                                                                //             )
                                                                //               //  CircularProgressIndicator
                                                                //               //     .adaptive()
                                                                //               );
                                                                //     },
                                                                //   ),
                                                                // ),

                                                                Text(
                                                                  "${item.name}",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.6),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                // SizedBox(
                                                                //   width: ScreenConfig.getProportionalWidth(145),
                                                                //   child: Text(
                                                                //     itemDesc,
                                                                //     style: TextStyle(color: Colors.black),
                                                                //   ),
                                                                // ),
                                                                // Text(
                                                                //   NumberFormat.currency(
                                                                //           name: feedState.productlist!
                                                                //                       .firstWhere(
                                                                //                         (e) => e.key == item.productId,
                                                                //                         orElse: () => model,
                                                                //                       )
                                                                //                       .productLocation ==
                                                                //                   'Nigeria'
                                                                //               ? '₦'
                                                                //               : feedState.productlist!
                                                                //                           .firstWhere(
                                                                //                             (e) => e.key == item.productId,
                                                                //                             orElse: () => model,
                                                                //                           )
                                                                //                           .productLocation ==
                                                                //                       null
                                                                //                   ? ''
                                                                //                   : '£')
                                                                //       .format(double.parse(
                                                                //     "${(double.parse(item.price!.toString()) * int.parse(item.quantity!.toString()))}",
                                                                //   )),
                                                                //   style: const TextStyle(
                                                                //       color: Colors
                                                                //           .black,
                                                                //       fontWeight:
                                                                //           FontWeight
                                                                //               .bold),
                                                                // )
                                                              ],
                                                            ),
                                                          ),

                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5.0),
                                                            child: Container(
                                                                width:
                                                                    Get.width *
                                                                        0.8,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            18),
                                                                    color: CupertinoColors
                                                                        .darkBackgroundGray),
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        5.0),
                                                                child: Row(
                                                                  children: [
                                                                    const Text(
                                                                      'Commission you get when Ducts: ',
                                                                      style: TextStyle(
                                                                          color: CupertinoColors
                                                                              .systemGrey,
                                                                          fontWeight:
                                                                              FontWeight.w700),
                                                                    ),
                                                                    // Text(
                                                                    //     feedState.productlist!
                                                                    //                 .firstWhere(
                                                                    //                   (e) => e.key == item.productId,
                                                                    //                   orElse: () => model,
                                                                    //                 )
                                                                    //                 .productLocation ==
                                                                    //             'Nigeria'
                                                                    //         ? '₦  ${item.commissionPrice}'
                                                                    //         : feedState.productlist!
                                                                    //                     .firstWhere(
                                                                    //                       (e) => e.key == item.productId,
                                                                    //                       orElse: () => model,
                                                                    //                     )
                                                                    //                     .productLocation ==
                                                                    //                 null
                                                                    //             ? ' ${item.commissionPrice}'
                                                                    //             : '£ ${item.commissionPrice}',
                                                                    //     // NumberFormat.currency(name: 'N ')
                                                                    //     //     .format(int.parse(
                                                                    //     //   item.commissionPrice.toString(),
                                                                    //     // )),
                                                                    //     style: const TextStyle(color: CupertinoColors.systemYellow, fontWeight: FontWeight.w200)),
                                                                  ],
                                                                )),
                                                          ),
                                                          // GestureDetector(
                                                          //   onTap: () {
                                                          //     if (feedState
                                                          //             .productlist!
                                                          //             .firstWhere(
                                                          //               (e) =>
                                                          //                   e.key ==
                                                          //                   item.productId,
                                                          //               orElse: () =>
                                                          //                   model,
                                                          //             )
                                                          //             .stockQuantity !=
                                                          //         0) {
                                                          //       if (isSelected
                                                          //           .value) {
                                                          //         setState(() {
                                                          //           ductId =
                                                          //               // itemList[
                                                          //               //     index]['id'];
                                                          //               item.productId;
                                                          //           isSelected
                                                          //               .value;
                                                          //         });
                                                          //         Get.back();
                                                          //         setState(
                                                          //             () {});
                                                          //       } else {
                                                          //         setState(() {
                                                          //           ductId = item
                                                          //               .productId;
                                                          //           // itemList[
                                                          //           //     index]['id'];
                                                          //           isSelected
                                                          //                   .value =
                                                          //               !isSelected
                                                          //                   .value;
                                                          //         });
                                                          //         Get.back();
                                                          //         setState(
                                                          //             () {});
                                                          //       }
                                                          //     } else {}
                                                          //   },
                                                          //   child: feedState
                                                          //               .productlist!
                                                          //               .firstWhere(
                                                          //                 (e) =>
                                                          //                     e.key ==
                                                          //                     item.productId,
                                                          //                 orElse: () =>
                                                          //                     model,
                                                          //               )
                                                          //               .stockQuantity ==
                                                          //           0
                                                          //       ? Container(
                                                          //           padding: const EdgeInsets
                                                          //                   .symmetric(
                                                          //               horizontal:
                                                          //                   8.0,
                                                          //               vertical:
                                                          //                   3),
                                                          //           decoration: BoxDecoration(
                                                          //               color: Colors
                                                          //                   .red,
                                                          //               borderRadius:
                                                          //                   BorderRadius.circular(10)),
                                                          //           child: customTitleText(
                                                          //               'Out of Stock'),
                                                          //         )
                                                          //       : Container(
                                                          //           decoration: BoxDecoration(
                                                          //               boxShadow: [
                                                          //                 BoxShadow(
                                                          //                     offset: const Offset(0, 11),
                                                          //                     blurRadius: 11,
                                                          //                     color: Colors.black.withOpacity(0.06))
                                                          //               ],
                                                          //               borderRadius:
                                                          //                   BorderRadius.circular(
                                                          //                       18),
                                                          //               color: CupertinoColors
                                                          //                   .systemYellow),
                                                          //           padding:
                                                          //               const EdgeInsets.all(
                                                          //                   5.0),
                                                          //           child:
                                                          //               TitleText(
                                                          //             'Select to Duct',
                                                          //             color: CupertinoColors
                                                          //                 .darkBackgroundGray,
                                                          //           )),
                                                          // ),

                                                          //invoiceTotal(totalAmount),

                                                          // FlatButton(
                                                          //   color: iAccentColor,
                                                          //   shape: RoundedRectangleBorder(
                                                          //       borderRadius:
                                                          //           BorderRadius
                                                          //               .circular(
                                                          //                   15)),
                                                          //   child: SizedBox(
                                                          //     height: ScreenConfig
                                                          //         .getProportionalHeight(
                                                          //             80),
                                                          //     child: Row(
                                                          //       mainAxisAlignment:
                                                          //           MainAxisAlignment
                                                          //               .center,
                                                          //       children: [
                                                          //         Icon(Icons
                                                          //             .file_download),
                                                          //         SizedBox(
                                                          //           width: ScreenConfig
                                                          //               .getProportionalWidth(
                                                          //                   21),
                                                          //         ),
                                                          //         Text(
                                                          //           "Download now",
                                                          //           style: TextStyle(
                                                          //               fontSize: ScreenConfig
                                                          //                   .getProportionalHeight(
                                                          //                       27),
                                                          //               fontWeight:
                                                          //                   FontWeight
                                                          //                       .bold),
                                                          //         )
                                                          //       ],
                                                          //     ),
                                                          //   ),
                                                          //   onPressed: () {},
                                                          // )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Total: ",
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                fontWeight: FontWeight.bold,
                                                fontSize: Get.width * 0.04),
                                          ),
                                          SizedBox(
                                            width: Get.width * 0.04,
                                          ),
                                          // Text(
                                          //   NumberFormat.currency(
                                          //           name: searchState
                                          //                       .vendorOrdersCountry
                                          //                       .firstWhere(
                                          //                         (e) =>
                                          //                             e.key ==
                                          //                             cartItem
                                          //                                 .sellerId,
                                          //                         orElse: () =>
                                          //                             ViewductsUser(),
                                          //                       )
                                          //                       .location ==
                                          //                   'Nigeria'
                                          //               ? '₦'
                                          //               : searchState
                                          //                           .vendorOrdersCountry
                                          //                           .firstWhere(
                                          //                             (e) =>
                                          //                                 e.key ==
                                          //                                 cartItem
                                          //                                     .sellerId,
                                          //                             orElse: () =>
                                          //                                 ViewductsUser(),
                                          //                           )
                                          //                           .location ==
                                          //                       null
                                          //                   ? ''
                                          //                   : '£')
                                          //       .format(double.parse(
                                          //     "${cartItem.totalPrice}",
                                          //   )),
                                          //   style: TextStyle(
                                          //       color: Colors.black,
                                          //       fontWeight: FontWeight.bold,
                                          //       fontSize: Get.width * 0.04),
                                          // ),

                                          SizedBox(height: Get.width * 0.1)
                                        ],
                                      ),
                                      SizedBox(height: Get.width * 0.04),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Row(
                    children: [
                      Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(10),
                        child: frostedOrange(
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.blueGrey[50],
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.yellow.withOpacity(0.1),
                                    Colors.white60.withOpacity(0.2),
                                    Colors.orange.withOpacity(0.3)
                                  ],
                                  // begin: Alignment.topCenter,
                                  // end: Alignment.bottomCenter,
                                )),
                            child: Row(
                              children: [
                                Material(
                                  elevation: 10,
                                  borderRadius: BorderRadius.circular(100),
                                  child: CircleAvatar(
                                    radius: 14,
                                    backgroundColor: Colors.transparent,
                                    child: Image.asset('assets/delicious.png'),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 3),
                                  child: customTitleText('ViewDucts'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ));
  }

  RxList<FeedModel> listSearch = RxList<FeedModel>();
  void _shop(BuildContext context) async {
    showModalBottomSheet(
        // backgroundColor: Colors.red,
        // bounce: true,
        context: context,
        builder: (context) => SafeArea(
                child: Responsive(
              mobile: SearchPage(),
              tablet: Stack(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SearchPage(),
                      ),
                    ],
                  ),
                ],
              ),
              desktop: Stack(
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                    child: Container(
                      color: (Colors.white12).withOpacity(0.1),
                    ),
                  ),
                  Row(
                    children: [
                      // Once our width is less then 1300 then it start showing errors
                      // Now there is no error if our width is less then 1340

                      Expanded(
                        flex: Get.width > 1340 ? 3 : 5,
                        child: PlainScaffold(),
                      ),
                      Expanded(
                        flex: Get.width > 1340 ? 8 : 10,
                        child: SearchPage(),
                      ),
                      Expanded(
                        flex: Get.width > 1340 ? 2 : 4,
                        child: PlainScaffold(),
                      ),
                    ],
                  ),
                ],
              ),
            )));
  }

  String? searchValue;
  void itemProduct(int id, String value) {
    setState(() {
      searchValue = value;
    });
    cprint('$searchValue serchValue');
  }

  RxList<FeedModel>? commissionProduct;
  FeedModel? mod;
  getData() async {
    try {
      final database = Databases(
        clientConnect(),
      );
      if (ductId != null) {
        await database.listDocuments(
            databaseId: databaseId,
            collectionId: procold,
            queries: [query.Query.equal('key', ductId)]).then((data) {
          // Map map = data.toMap();

          var value =
              data.documents.map((e) => FeedModel.fromJson(e.data)).toList();
          //data.documents;

          commissionProduct = value.obs;

          // cprint('${data.documents.map((e) => FeedModel.fromJson(e.data))}');
          //cprint('${productlist?.value.map((e) => e.key)}');
        });
      }

      //snap.documents;
    } on AppwriteException catch (e) {
      cprint("$e commissionProduct");
    }
  }

  @override
  Widget build(BuildContext context) {
    var appSize = MediaQuery.of(context).size;
    FeedModel model = FeedModel();
    getData();
    // listSearch
    //     .bindStream(feedState.getViewductProductFromDatabase('$searchValue'));
    // final List<FeedModel>? commissionProduct =
    //     feedState.commissionProducts(authState.userModel, ductId);

    return KeyboardDismisser(
      gestures: const [
        GestureType.onTap,
        GestureType.onPanUpdateUpDirection,
      ],
      child: Scaffold(
        //  backgroundColor: TwitterColor.mystic,
        body: _image != null
            ? Stack(
                children: [
                  ComposeTweetImage(
                    image: _image,
                    onCrossIconPressed: _onCrossIconPressed,
                  ),
                  Positioned(
                    top: appSize.height * 0.08,
                    right: 10,
                    child: isUploading == true
                        ? Container(
                            height: 30,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      offset: const Offset(0, 11),
                                      blurRadius: 11,
                                      color: Colors.black.withOpacity(0.06))
                                ],
                                borderRadius: BorderRadius.circular(18),
                                color: CupertinoColors.lightBackgroundGray),
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                TitleText('Ducting...'),
                                Stack(
                                  alignment: Alignment.center,
                                  children: <Widget>[
                                    // Platform.isIOS
                                    //     ?
                                    const CupertinoActivityIndicator(
                                      radius: 10,
                                    )
                                    // : const CircularProgressIndicator(
                                    //     strokeWidth: 2,
                                    //   ),
                                    // Image.asset(
                                    //   'assets/cool.png',
                                    //   height: 30,
                                    //   width: 30,
                                    // )
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: _submitButton,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              offset: const Offset(0, 11),
                                              blurRadius: 11,
                                              color: Colors.black
                                                  .withOpacity(0.06))
                                        ],
                                        borderRadius: BorderRadius.circular(18),
                                        color: CupertinoColors
                                            .lightBackgroundGray),
                                    padding: const EdgeInsets.all(5.0),
                                    child: TitleText('Ducts Now')),
                              ),
                            ),
                          ),
                  ),
                  Positioned(
                    bottom: fullWidth(context) * 0.1,
                    right: 5,
                    child: SizedBox(
                      width: fullWidth(context) * 0.25,
                      height: fullWidth(context) * 0.3,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        addAutomaticKeepAlives: false,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      offset: const Offset(0, 11),
                                      blurRadius: 11,
                                      color: Colors.black.withOpacity(0.06))
                                ],
                                borderRadius: BorderRadius.circular(18),
                              ),
                              height: fullWidth(context) * 0.3,
                              width: fullWidth(context) * 0.3,
                              child: Stack(
                                children: [
                                  _Orders(
                                    list: commissionProduct?[index],
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isUploading = false;
                                          ductId = null;
                                          isSelected.value = !isSelected.value;
                                        });
                                      },
                                      iconSize: Get.width * 0.1,
                                      icon: const Icon(Icons.delete),
                                      color: Colors.red,
                                    ),
                                  )
                                ],
                              )),
                        ),
                        itemCount: commissionProduct?.length,
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 20,
                      left: 10,
                      child: Wrap(children: [
                        Icon(
                          CupertinoIcons.music_note_2,
                          color: CupertinoColors.systemYellow,
                          size: 50,
                        ),
                        GestureDetector(
                          onTap: () async {
                            final pickedFile =
                                // ignore: deprecated_member_use
                                await FilePicker.platform
                                    .pickFiles(type: FileType.audio);
                            // File files = File(pickedFile!.path);
                            // XTypeGroup typeGroup = XTypeGroup(
                            //   extensions: <String>['mp3', 'wav'],
                            // );

                            // final files = await openFile(
                            //     acceptedTypeGroups: <XTypeGroup>[typeGroup]);
                            //  setState(() async {
                            File file =
                                File(pickedFile!.files.single.path.toString());
                            cprint('${file.lengthSync()}');
                            if (file.lengthSync() > 5000000) {
                              setState(() {
                                //file = null;
                                audioFile = null;
                              });

                              _showDialog();
                            } else {
                              setState(() {
                                audioFile = file;
                              });
                              if (audioFile != null) {
                                setState(() {
                                  isPlaying == true;
                                  audioPlayer.play(UrlSource(audioFile!.path));
                                });

                                setState(() {
                                  audioFile = file;
                                });
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          offset: const Offset(0, 11),
                                          blurRadius: 11,
                                          color: Colors.black.withOpacity(0.06))
                                    ],
                                    borderRadius: BorderRadius.circular(18),
                                    color: CupertinoColors.lightBackgroundGray),
                                padding: const EdgeInsets.all(5.0),
                                child: isPlaying
                                    ? TitleText('Playing Now')
                                    : audioFile == null
                                        ? TitleText('Add Music Tag')
                                        : TitleText('Music Tag Added!')),
                          ),
                        ),
                        audioFile == null
                            ? Container()
                            : GestureDetector(
                                onTap: () async {
                                  if (isPlaying) {
                                    await audioPlayer.pause();
                                  } else {
                                    await audioPlayer
                                        .play(UrlSource(audioFile!.path));
                                  }
                                },
                                child: isPlaying
                                    ? Icon(
                                        CupertinoIcons.pause_fill,
                                        color:
                                            CupertinoColors.lightBackgroundGray,
                                        size: 20,
                                      )
                                    : Icon(
                                        CupertinoIcons.play_arrow,
                                        color:
                                            CupertinoColors.lightBackgroundGray,
                                        size: 20,
                                      ),
                              )
                      ]))
                ],
              )
            : _video != null
                ? Stack(
                    children: [
                      Container(
                        height: appSize.height,
                        width: appSize.width,
                        decoration: BoxDecoration(
                          // borderRadius: BorderRadius.circular(100),
                          //color: Colors.blueGrey[50]
                          gradient: LinearGradient(
                            colors: [
                              Colors.black45.withOpacity(0.9),
                              Colors.black45.withOpacity(0.88),
                              Colors.black45.withOpacity(0.95)
                              // Color(0xfffbfbfb),
                              // Color(0xfff7f7f7),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.grey.withOpacity(.3),
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: Center(
                            child: VideoUploadAdmin(
                              videoFile: _video,
                              videoPath: _video!.path,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                          top: Get.width * 0.2,
                          right: 10,
                          child: isUploading == true
                              ? Container(
                                  height: 30,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            offset: const Offset(0, 11),
                                            blurRadius: 11,
                                            color:
                                                Colors.black.withOpacity(0.06))
                                      ],
                                      borderRadius: BorderRadius.circular(18),
                                      color:
                                          CupertinoColors.lightBackgroundGray),
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    children: [
                                      TitleText('Ducting...'),
                                      Stack(
                                        alignment: Alignment.center,
                                        children: <Widget>[
                                          // Platform.isIOS
                                          //     ?
                                          const CupertinoActivityIndicator(
                                            radius: 10,
                                          )
                                          // : const CircularProgressIndicator(
                                          //     strokeWidth: 2,
                                          //   ),
                                          // Image.asset(
                                          //   'assets/cool.png',
                                          //   height: 30,
                                          //   width: 30,
                                          // )
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              : GestureDetector(
                                  onTap: _submitButton,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  offset: const Offset(0, 11),
                                                  blurRadius: 11,
                                                  color: Colors.black
                                                      .withOpacity(0.06))
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            color: CupertinoColors
                                                .lightBackgroundGray),
                                        padding: const EdgeInsets.all(5.0),
                                        child: TitleText('Ducts Now')),
                                  ),
                                )),
                      Positioned(
                        bottom: fullWidth(context) * 0.1,
                        right: 5,
                        child: SizedBox(
                          width: fullWidth(context) * 0.25,
                          height: fullWidth(context) * 0.3,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            addAutomaticKeepAlives: false,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                  height: fullWidth(context) * 0.3,
                                  width: fullWidth(context) * 0.3,
                                  child: Stack(
                                    children: [
                                      _Orders(
                                        list: commissionProduct?[index],
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _image = null;
                                              _video = null;
                                              _thumbnail = null;
                                              ductId = null;
                                              isSelected.value =
                                                  !isSelected.value;
                                            });
                                          },
                                          iconSize: Get.width * 0.1,
                                          icon: const Icon(Icons.delete),
                                          color: Colors.red,
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                            itemCount: commissionProduct?.length,
                          ),
                        ),
                      ),
                      Positioned(
                        //      alignment: Alignment.topLeft,
                        top: Get.height * 0.08,
                        left: 10,
                        child: IconButton(
                          padding: const EdgeInsets.all(0),
                          iconSize: Get.width * 0.07,
                          onPressed: () {
                            setState(() {
                              isUploading = false;
                              _image = null;
                              _video = null;
                              _thumbnail = null;
                              ductId = null;
                              isSelected.value = !isSelected.value;
                            });
                          },
                          icon: const Icon(CupertinoIcons.clear_circled_solid,
                              color: CupertinoColors.systemYellow),
                        ),
                      )
                    ],
                  )
                : SafeArea(
                    child: Stack(
                    children: <Widget>[
                      ThemeMode.system == ThemeMode.light
                          ? frostedYellow(
                              Container(
                                height: appSize.height,
                                width: appSize.width,
                                decoration: BoxDecoration(
                                  // borderRadius: BorderRadius.circular(100),
                                  //color: Colors.blueGrey[50]
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.yellow[100]!.withOpacity(0.3),
                                      Colors.yellow[200]!.withOpacity(0.1),
                                      Colors.yellowAccent[100]!.withOpacity(0.2)
                                      // Color(0xfffbfbfb),
                                      // Color(0xfff7f7f7),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      Positioned(
                        top: -220,
                        right: -140,
                        child: Transform.rotate(
                          angle: 90,
                          child: Container(
                            height: fullWidth(context) * 0.8,
                            width: fullWidth(context),
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/ankkara1.jpg'))),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -80,
                        left: -250,
                        child: Transform.rotate(
                          angle: 90,
                          child: Container(
                            height: fullWidth(context) * 0.8,
                            width: fullWidth(context),
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/ankkara1.jpg'))),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: -250,
                        child: Transform.rotate(
                          angle: 90,
                          child: Container(
                            height: fullWidth(context) * 0.8,
                            width: fullWidth(context),
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/ankara3.jpg'))),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 40,
                        right: -260,
                        child: Transform.rotate(
                          angle: 30,
                          child: Container(
                            height: fullWidth(context) * 0.8,
                            width: fullWidth(context),
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/ankkara1.jpg'))),
                          ),
                        ),
                      ),
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                        child: Container(
                          color: (Colors.white12).withOpacity(0.1),
                        ),
                      ),
                      !isSelected.value
                          ? Container()
                          : visibleSwitch.value
                              ? Container()
                              : Positioned(
                                  top: appSize.height * 0.01,
                                  right: 10,
                                  child: isUploading == true
                                      ? Container(
                                          height: 30,
                                          decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                    offset: const Offset(0, 11),
                                                    blurRadius: 11,
                                                    color: Colors.black
                                                        .withOpacity(0.06))
                                              ],
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              color: CupertinoColors
                                                  .lightBackgroundGray),
                                          padding: const EdgeInsets.all(5.0),
                                          child: Row(
                                            children: [
                                              TitleText('Ducting...'),
                                              Stack(
                                                alignment: Alignment.center,
                                                children: <Widget>[
                                                  // Platform.isIOS
                                                  //     ?
                                                  const CupertinoActivityIndicator(
                                                    radius: 10,
                                                  )
                                                  // : const CircularProgressIndicator(
                                                  //     strokeWidth: 2,
                                                  //   ),
                                                  // Image.asset(
                                                  //   'assets/cool.png',
                                                  //   height: 30,
                                                  //   width: 30,
                                                  // )
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                            onTap: _submitButton,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      boxShadow: [
                                                        BoxShadow(
                                                            offset:
                                                                const Offset(
                                                                    0, 11),
                                                            blurRadius: 11,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.06))
                                                      ],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              18),
                                                      color: CupertinoColors
                                                          .lightBackgroundGray),
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child:
                                                      TitleText('Ducts Now')),
                                            ),
                                          ),
                                        ),
                                ),
                      // Positioned(
                      //   top: appSize.height * 0.1,
                      //   left: 0,
                      //   right: 0,
                      //   child: SizedBox(
                      //     height: appSize.height,
                      //     width: appSize.width,
                      //     child: SingleChildScrollView(
                      //       controller: scrollcontroller,
                      //       child: widget.isRetweet!
                      //           ? _ComposeRetweet(this)
                      //           : visibleSwitch.value
                      //               ? SizedBox(
                      //                   height: fullHeight(context) * 0.8,
                      //                   width: fullWidth(context),
                      //                   child: SingleChildScrollView(
                      //                     child: Column(
                      //                       children: [
                      //                         visibleSwitch.value
                      //                             ? widget.isTweet
                      //                                 ? SizedBox(
                      //                                     height: fullHeight(
                      //                                             context) *
                      //                                         0.7,
                      //                                     width: fullWidth(
                      //                                         context),
                      //                                     child:
                      //                                         const AddProduct(
                      //                                       isTweet: true,
                      //                                       isRetweet: false,
                      //                                     ),
                      //                                   )
                      //                                 : Container()
                      //                             : Container(),
                      //                       ],
                      //                     ),
                      //                   ),
                      //                 )
                      //               :
                      //               //itemList.isEmpty
                      //               widget.isVendor == true
                      //                   ? _ComposeTweet(
                      //                       this,
                      //                       visibleSwitch,
                      //                       model,
                      //                       ductId,
                      //                       _isPlaying,
                      //                       _videoPlayerController,
                      //                       isTyping)
                      //                   : userCartController.orders.value ==
                      //                               null ||
                      //                           userCartController
                      //                               .orders.value.isEmpty
                      //                       ? Column(
                      //                           mainAxisAlignment:
                      //                               MainAxisAlignment.center,
                      //                           crossAxisAlignment:
                      //                               CrossAxisAlignment.center,
                      //                           children: [
                      //                             SizedBox(
                      //                               height:
                      //                                   fullHeight(context) *
                      //                                       0.1,
                      //                             ),
                      //                             Lottie.asset(
                      //                                 'assets/lottie/discount.json',
                      //                                 width: Get.height * 0.3,
                      //                                 height: Get.height * 0.3),
                      //                             Padding(
                      //                               padding: const EdgeInsets
                      //                                       .symmetric(
                      //                                   horizontal: 30),
                      //                               child: frostedOrange(
                      //                                 Align(
                      //                                   alignment:
                      //                                       Alignment.topCenter,
                      //                                   child: SizedBox(
                      //                                     height:
                      //                                         Get.height * 0.2,
                      //                                     child:
                      //                                         const EmptyList(
                      //                                       'is Like You Haven\'t Shopped Yet',
                      //                                       subTitle:
                      //                                           'Start Shopping product by clicking the button Below',
                      //                                     ),
                      //                                   ),
                      //                                 ),
                      //                               ),
                      //                             ),
                      //                             const SizedBox(height: 10.0),
                      //                             ButtonTheme(
                      //                               height: 45.0,
                      //                               minWidth: 100.0,
                      //                               shape: const RoundedRectangleBorder(
                      //                                   borderRadius:
                      //                                       BorderRadius.all(
                      //                                           Radius.circular(
                      //                                               7.0))),
                      //                               child: ElevatedButton(
                      //                                 style: ElevatedButton.styleFrom(
                      //                                     backgroundColor: authState
                      //                                                 .networkConnectionState
                      //                                                 .value ==
                      //                                             'Not Connected'
                      //                                         ? CupertinoColors
                      //                                             .systemRed
                      //                                         : const Color(
                      //                                             0xff313134)),
                      //                                 // color: Color(0xff313134),
                      //                                 onPressed: () async {
                      //                                   if (authState
                      //                                           .networkConnectionState
                      //                                           .value ==
                      //                                       'Not Connected') {
                      //                                   } else {
                      //                                     _shop(context);
                      //                                   }

                      //                                   // Navigator.of(context).push(
                      //                                   //   MaterialPageRoute(
                      //                                   //       builder: (context) => More()),
                      //                                   // );

                      //                                   //   Map<String,dynamic> args = new Map();
                      //                                   // //  Loader.showLoadingScreen(context, _keyLoader);
                      //                                   //   List<Map<String,String>> categoryList = await _productService.listCategories();
                      //                                   //   args['category'] = categoryList;
                      //                                   //   Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
                      //                                   //   Navigator.pushReplacementNamed(context, '/shop',arguments: args);
                      //                                 },
                      //                                 child: Text(
                      //                                   authState.networkConnectionState
                      //                                               .value ==
                      //                                           'Not Connected'
                      //                                       ? 'You are offline'
                      //                                       : 'Shop',
                      //                                   style: TextStyle(
                      //                                       color: Colors.white,
                      //                                       fontSize: 20.0,
                      //                                       fontWeight:
                      //                                           FontWeight
                      //                                               .bold),
                      //                                 ),
                      //                               ),
                      //                             )
                      //                           ],
                      //                         )
                      //                       : !isSelected.value
                      //                           ? Column(
                      //                               mainAxisAlignment:
                      //                                   MainAxisAlignment
                      //                                       .center,
                      //                               crossAxisAlignment:
                      //                                   CrossAxisAlignment
                      //                                       .center,
                      //                               children: [
                      //                                 SizedBox(
                      //                                   height: fullHeight(
                      //                                           context) *
                      //                                       0.3,
                      //                                 ),
                      //                                 Container(
                      //                                   height: 100,
                      //                                   width: 100,
                      //                                   decoration: BoxDecoration(
                      //                                       borderRadius:
                      //                                           BorderRadius
                      //                                               .circular(
                      //                                                   100),
                      //                                       image: const DecorationImage(
                      //                                           image: AssetImage(
                      //                                               'assets/shopping-bag.png'))),
                      //                                 ),
                      //                                 Padding(
                      //                                   padding:
                      //                                       const EdgeInsets
                      //                                               .symmetric(
                      //                                           horizontal: 30),
                      //                                   child: frostedWhite(
                      //                                     Align(
                      //                                       alignment: Alignment
                      //                                           .topCenter,
                      //                                       child: SizedBox(
                      //                                         height: fullWidth(
                      //                                                 context) *
                      //                                             0.5,
                      //                                         child:
                      //                                             const EmptyList(
                      //                                           'Duct a Product By',
                      //                                           subTitle:
                      //                                               'Selecting From your Orders!',
                      //                                         ),
                      //                                       ),
                      //                                     ),
                      //                                   ),
                      //                                 ),
                      //                               ],
                      //                             )
                      //                           : Column(
                      //                               children: [
                      //                                 _ComposeTweet(
                      //                                     this,
                      //                                     visibleSwitch,
                      //                                     model,
                      //                                     ductId,
                      //                                     _isPlaying,
                      //                                     _videoPlayerController,
                      //                                     isTyping),
                      //                                 !isSelected.value
                      //                                     ? Container()
                      //                                     : visibleSwitch.value
                      //                                         ? Container()
                      //                                         : GestureDetector(
                      //                                             onTap: () {
                      //                                               // setState(() {
                      //                                               //   if (isDropdown) {
                      //                                               //     floatingMenu.remove();
                      //                                               //   } else {
                      //                                               //     //  _postProsductoption();
                      //                                               //     floatingMenu = _mediaView(context);
                      //                                               //     Overlay.of(context).insert(floatingMenu);
                      //                                               //   }

                      //                                               //   isDropdown = !isDropdown;
                      //                                               // });
                      //                                               //  _mediaViewModal(context);
                      //                                               // _addMediaModal(context);
                      //                                             },
                      //                                             child:
                      //                                                 ViewDuctMenuHolder(
                      //                                               onPressed:
                      //                                                   () {},
                      //                                               menuItems: <
                      //                                                   DuctFocusedMenuItem>[
                      //                                                 DuctFocusedMenuItem(
                      //                                                     title:
                      //                                                         Padding(
                      //                                                       padding:
                      //                                                           const EdgeInsets.symmetric(horizontal: 20.0),
                      //                                                       child:
                      //                                                           Container(
                      //                                                         decoration: BoxDecoration(boxShadow: [
                      //                                                           BoxShadow(offset: const Offset(0, 11), blurRadius: 11, color: Colors.black.withOpacity(0.06))
                      //                                                         ], borderRadius: BorderRadius.circular(18), color: CupertinoColors.lightBackgroundGray),
                      //                                                         padding: const EdgeInsets.all(5.0),
                      //                                                         child: const Text(
                      //                                                           'Gallary',
                      //                                                           style: TextStyle(
                      //                                                             //fontSize: Get.width * 0.03,
                      //                                                             color: AppColor.darkGrey,
                      //                                                           ),
                      //                                                         ),
                      //                                                       ),
                      //                                                     ),
                      //                                                     onPressed: () => setImage(ImageSource
                      //                                                         .gallery),
                      //                                                     trailingIcon:
                      //                                                         const Icon(CupertinoIcons.photo)),
                      //                                                 DuctFocusedMenuItem(
                      //                                                     title:
                      //                                                         Padding(
                      //                                                       padding:
                      //                                                           const EdgeInsets.symmetric(horizontal: 20.0),
                      //                                                       child:
                      //                                                           Container(
                      //                                                         decoration: BoxDecoration(boxShadow: [
                      //                                                           BoxShadow(offset: const Offset(0, 11), blurRadius: 11, color: Colors.black.withOpacity(0.06))
                      //                                                         ], borderRadius: BorderRadius.circular(18), color: CupertinoColors.systemYellow),
                      //                                                         padding: const EdgeInsets.all(5.0),
                      //                                                         child: const Text(
                      //                                                           'Video Files',
                      //                                                           style: TextStyle(
                      //                                                             //fontSize: Get.width * 0.03,
                      //                                                             color: AppColor.darkGrey,
                      //                                                           ),
                      //                                                         ),
                      //                                                       ),
                      //                                                     ),
                      //                                                     onPressed:
                      //                                                         () async {
                      //                                                       /// status can either be: granted, denied, restricted or permanentlyDenied
                      //                                                       var status =
                      //                                                           await camera.Permission.camera.status;
                      //                                                       if (status.isGranted) {
                      //                                                         XTypeGroup typeGroup = XTypeGroup(
                      //                                                           extensions: <String>[
                      //                                                             'mp4'
                      //                                                           ],
                      //                                                         );

                      //                                                         if (Platform.isMacOS || Platform.isWindows) {
                      //                                                           final files = await openFile(acceptedTypeGroups: <XTypeGroup>[
                      //                                                             typeGroup
                      //                                                           ]);
                      //                                                           //  setState(() async {
                      //                                                           File file = File(files!.path);
                      //                                                           cprint('${file.lengthSync()}');
                      //                                                           if (file.lengthSync() > 50000000) {
                      //                                                             setState(() {
                      //                                                               //file = null;
                      //                                                               _video = null;
                      //                                                             });

                      //                                                             _showDialog();
                      //                                                           } else {
                      //                                                             setState(() {
                      //                                                               _video = file;
                      //                                                             });
                      //                                                             if (_video != null) {
                      //                                                               setState(() {
                      //                                                                 _videoPlayerController = VideoPlayerController.file(_video!)
                      //                                                                   ..initialize().then((value) {
                      //                                                                     setState(() {
                      //                                                                       _duration = _videoPlayerController!.value.duration;
                      //                                                                     });
                      //                                                                   });
                      //                                                               });
                      //                                                               var thumb = await VideoThumbnail.thumbnailFile(imageFormat: ImageFormat.PNG, maxHeight: 64, quality: 100, video: file.path);
                      //                                                               setState(() {
                      //                                                                 _video = file;
                      //                                                                 _thumbnail = File(thumb!);
                      //                                                               });
                      //                                                             }
                      //                                                           }
                      //                                                           // });
                      //                                                         } else {
                      //                                                           PickedFile? pickedFile =
                      //                                                               // ignore: deprecated_member_use
                      //                                                               await (ImagePicker().getVideo(source: ImageSource.gallery, maxDuration: const Duration(seconds: 45)));
                      //                                                           File file = File(pickedFile!.path);
                      //                                                           cprint('${file.lengthSync()}');
                      //                                                           if (file.lengthSync() > 20000000) {
                      //                                                             setState(() {
                      //                                                               //file = null;
                      //                                                               _video = null;
                      //                                                             });

                      //                                                             _showDialog();
                      //                                                           } else {
                      //                                                             final thumb = await VideoThumbnail.thumbnailFile(imageFormat: ImageFormat.PNG, maxHeight: 64, quality: 100, video: file.path);
                      //                                                             setState(() {
                      //                                                               _video = file;
                      //                                                               _thumbnail = File(thumb!);
                      //                                                             });

                      //                                                             if (_video != null) {
                      //                                                               setState(() {
                      //                                                                 _videoPlayerController = VideoPlayerController.file(_video!)
                      //                                                                   ..initialize().then((value) {
                      //                                                                     setState(() {
                      //                                                                       _duration = _videoPlayerController!.value.duration;
                      //                                                                     });
                      //                                                                   });
                      //                                                               });
                      //                                                             }
                      //                                                           }
                      //                                                         }
                      //                                                       } else if (status.isDenied) {
                      //                                                         // We didn't ask for permission yet or the permission has been denied before but not permanently.
                      //                                                         if (await camera.Permission.camera.request().isGranted) {
                      //                                                           // Either the permission was already granted before or the user just granted it.

                      //                                                           XTypeGroup typeGroup = XTypeGroup(
                      //                                                             extensions: <String>[
                      //                                                               'mp4'
                      //                                                             ],
                      //                                                           );

                      //                                                           if (Platform.isMacOS || Platform.isWindows) {
                      //                                                             final files = await openFile(acceptedTypeGroups: <XTypeGroup>[
                      //                                                               typeGroup
                      //                                                             ]);
                      //                                                             //  setState(() async {
                      //                                                             File file = File(files!.path);
                      //                                                             cprint('${file.lengthSync()}');
                      //                                                             if (file.lengthSync() > 20000000) {
                      //                                                               setState(() {
                      //                                                                 //file = null;
                      //                                                                 _video = null;
                      //                                                               });

                      //                                                               _showDialog();
                      //                                                             } else {
                      //                                                               setState(() {
                      //                                                                 _video = file;
                      //                                                               });
                      //                                                               if (_video != null) {
                      //                                                                 setState(() {
                      //                                                                   _videoPlayerController = VideoPlayerController.file(_video!)
                      //                                                                     ..initialize().then((value) {
                      //                                                                       setState(() {
                      //                                                                         _duration = _videoPlayerController!.value.duration;
                      //                                                                       });
                      //                                                                     });
                      //                                                                 });
                      //                                                                 var thumb = await VideoThumbnail.thumbnailFile(imageFormat: ImageFormat.PNG, maxHeight: 64, quality: 100, video: file.path);
                      //                                                                 setState(() {
                      //                                                                   _video = file;
                      //                                                                   _thumbnail = File(thumb!);
                      //                                                                 });
                      //                                                               }
                      //                                                             }
                      //                                                             // });
                      //                                                           } else {
                      //                                                             PickedFile? pickedFile =
                      //                                                                 // ignore: deprecated_member_use
                      //                                                                 await (ImagePicker().getVideo(source: ImageSource.gallery, maxDuration: const Duration(seconds: 45)));
                      //                                                             File file = File(pickedFile!.path);
                      //                                                             cprint('${file.lengthSync()}');
                      //                                                             if (file.lengthSync() > 20000000) {
                      //                                                               setState(() {
                      //                                                                 //file = null;
                      //                                                                 _video = null;
                      //                                                               });

                      //                                                               _showDialog();
                      //                                                             } else {
                      //                                                               final thumb = await VideoThumbnail.thumbnailFile(imageFormat: ImageFormat.PNG, maxHeight: 64, quality: 100, video: file.path);
                      //                                                               setState(() {
                      //                                                                 _video = file;
                      //                                                                 _thumbnail = File(thumb!);
                      //                                                               });

                      //                                                               if (_video != null) {
                      //                                                                 setState(() {
                      //                                                                   _videoPlayerController = VideoPlayerController.file(_video!)
                      //                                                                     ..initialize().then((value) {
                      //                                                                       setState(() {
                      //                                                                         _duration = _videoPlayerController!.value.duration;
                      //                                                                       });
                      //                                                                     });
                      //                                                                 });
                      //                                                               }
                      //                                                             }
                      //                                                           }
                      //                                                         }
                      //                                                       }
                      //                                                     },
                      //                                                     trailingIcon:
                      //                                                         const Icon(
                      //                                                       CupertinoIcons.video_camera,
                      //                                                       color:
                      //                                                           AppColor.darkGrey,
                      //                                                     )),
                      //                                                 DuctFocusedMenuItem(
                      //                                                     title:
                      //                                                         Padding(
                      //                                                       padding:
                      //                                                           const EdgeInsets.symmetric(horizontal: 20.0),
                      //                                                       child:
                      //                                                           Container(
                      //                                                         decoration: BoxDecoration(boxShadow: [
                      //                                                           BoxShadow(offset: const Offset(0, 11), blurRadius: 11, color: Colors.black.withOpacity(0.06))
                      //                                                         ], borderRadius: BorderRadius.circular(18), color: CupertinoColors.systemOrange),
                      //                                                         padding: const EdgeInsets.all(5.0),
                      //                                                         child: const Text(
                      //                                                           'Comment',
                      //                                                           style: TextStyle(
                      //                                                             //fontSize: Get.width * 0.03,
                      //                                                             color: AppColor.darkGrey,
                      //                                                           ),
                      //                                                         ),
                      //                                                       ),
                      //                                                     ),
                      //                                                     onPressed: () =>
                      //                                                         _onCrossIconPressed(),
                      //                                                     trailingIcon:
                      //                                                         const Icon(CupertinoIcons.chat_bubble_2)),
                      //                                               ],
                      //                                               child:
                      //                                                   Padding(
                      //                                                 padding:
                      //                                                     const EdgeInsets.all(
                      //                                                         2.0),
                      //                                                 child:
                      //                                                     Row(
                      //                                                   children: [
                      //                                                     const CircleAvatar(
                      //                                                       radius:
                      //                                                           14,
                      //                                                       backgroundColor:
                      //                                                           Colors.yellow,
                      //                                                       child:
                      //                                                           Icon(
                      //                                                         CupertinoIcons.add_circled_solid,
                      //                                                         color: Colors.black,
                      //                                                       ),
                      //                                                       // Image.asset('assets/folder.png'),
                      //                                                     ),
                      //                                                     Padding(
                      //                                                       padding:
                      //                                                           const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
                      //                                                       child:
                      //                                                           customTitleText('Media'),
                      //                                                     ),
                      //                                                   ],
                      //                                                 ),
                      //                                               ),
                      //                                             ),
                      //                                             //  customButton(
                      //                                             //   'Media',
                      //                                             //   Image.asset('assets/folder.png'),
                      //                                             // ),
                      //                                           ),
                      //                               ],
                      //                             ),
                      //     ),
                      //   ),
                      // ),

                      // isTyping.value
                      //     ? Container()
                      //     :
                      // Obx(
                      //   () => !widget.isTweet
                      //       ? Container()
                      //       : userCartController.orders.value == null ||
                      //               userCartController.orders.value.isEmpty

                      //           // itemList.isEmpty
                      //           ? Container()
                      //           : visibleSwitch.value
                      //               ? Container()
                      //               : isSelected.value
                      //                   ? Container()
                      //                   : Positioned(
                      //                       bottom: MediaQuery.of(context)
                      //                           .viewInsets
                      //                           .bottom,
                      //                       left: 10,
                      //                       child: Column(
                      //                         crossAxisAlignment:
                      //                             CrossAxisAlignment.start,
                      //                         children: [
                      //                           Container(
                      //                             padding: const EdgeInsets
                      //                                     .symmetric(
                      //                                 horizontal: 8.0,
                      //                                 vertical: 3),
                      //                             decoration: BoxDecoration(
                      //                                 color: authState
                      //                                             .networkConnectionState
                      //                                             .value ==
                      //                                         'Not Connected'
                      //                                     ? CupertinoColors
                      //                                         .systemRed
                      //                                     : Colors.white54,
                      //                                 borderRadius:
                      //                                     BorderRadius.circular(
                      //                                         10)),
                      //                             child: customTitleText(
                      //                                 authState.networkConnectionState
                      //                                             .value ==
                      //                                         'Not Connected'
                      //                                     ? 'Offline'
                      //                                     : 'Your Orders'),
                      //                           ),
                      //                           authState.networkConnectionState
                      //                                       .value ==
                      //                                   'Not Connected'
                      //                               ? Container()
                      //                               : SizedBox(
                      //                                   height: fullHeight(
                      //                                           context) *
                      //                                       0.13,
                      //                                   width:
                      //                                       fullWidth(context),
                      //                                   child: ListView(
                      //                                     scrollDirection:
                      //                                         Axis.horizontal,
                      //                                     children:
                      //                                         userCartController
                      //                                             .orders.value
                      //                                             .map(
                      //                                               (cartItem) =>
                      //                                                   Padding(
                      //                                                 padding:
                      //                                                     const EdgeInsets.all(
                      //                                                         8.0),
                      //                                                 child:
                      //                                                     GestureDetector(
                      //                                                   onTap:
                      //                                                       () {
                      //                                                     _orderList(
                      //                                                         context,
                      //                                                         cartItem);
                      //                                                   },
                      //                                                   child: DuctStatusView(
                      //                                                       radius: Get.height * 0.05,
                      //                                                       numberOfStatus: cartItem.items!.length,
                      //                                                       bucketId: productBucketId,
                      //                                                       centerImageUrl: feedState.productlist!
                      //                                                           .firstWhere(
                      //                                                             (e) => e.key == cartItem.items![0].productId.toString(),
                      //                                                             orElse: () => model,
                      //                                                           )
                      //                                                           .imagePath
                      //                                                           .toString()),
                      //                                                 ),
                      //                                               ),
                      //                                             )
                      //                                             .toList(),
                      //                                   ),

                      //                                   // ),
                      //                                 ),
                      //                         ],
                      //                       ),
                      //                     ),
                      // ),

                      visibleSwitch.value
                          ? Container()
                          : _video == null
                              ? Container()
                              : Positioned(
                                  top: fullWidth(context) * 0.42,
                                  left: 2,
                                  child: IconButton(
                                    padding: const EdgeInsets.all(0),
                                    iconSize: 20,
                                    onPressed: _onCrossIconPressed,
                                    icon: const Icon(
                                        CupertinoIcons.clear_circled_solid),
                                  ),
                                ),
                      visibleSwitch.value
                          ? Container()
                          : _video == null
                              ? Container()
                              : _videoPlayerController!.value.isPlaying
                                  ? Positioned(
                                      bottom: fullHeight(context) * 0.55,
                                      left: fullWidth(context) * 0.45,
                                      child: Container(
                                        padding: const EdgeInsets.all(0),
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.black54),
                                        child: IconButton(
                                          padding: const EdgeInsets.all(0),
                                          iconSize: 20,
                                          onPressed: _onCrossIconPressed,
                                          icon: Icon(
                                            Icons.pause,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                      visibleSwitch.value
                          ? Container()
                          : Positioned(
                              bottom: fullWidth(context) * 0.4,
                              left: 5,
                              child: _thumbnail == null
                                  ? Container()
                                  : SizedBox(
                                      height: fullWidth(context) * 0.3,
                                      width: fullWidth(context) * 0.3,
                                      child: Stack(
                                        children: [
                                          FittedBox(
                                            child: ComposeThumbnail(
                                              image: _thumbnail,
                                              onCrossIconPressed:
                                                  _onCrossThumbnail,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Container(
                                              padding: const EdgeInsets.all(0),
                                              decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.black54),
                                              child: InkWell(
                                                  onTap: _onCrossThumbnail,
                                                  child: frostedBlack(
                                                    Text('thumbnail',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: fullWidth(
                                                                    context) *
                                                                0.05)),
                                                  )),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                      Positioned(
                        top: 10,
                        left: 1,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              // color: Colors.black,
                              icon: const Icon(CupertinoIcons.back),
                            ),
                            Material(
                              elevation: 10,
                              borderRadius: BorderRadius.circular(10),
                              child: frostedOrange(
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.blueGrey[50],
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.yellow.withOpacity(0.1),
                                          Colors.white60.withOpacity(0.2),
                                          Colors.orange.withOpacity(0.3)
                                        ],
                                        // begin: Alignment.topCenter,
                                        // end: Alignment.bottomCenter,
                                      )),
                                  child: Row(
                                    children: [
                                      Material(
                                        elevation: 10,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: CircleAvatar(
                                          radius: 14,
                                          backgroundColor: Colors.transparent,
                                          child: Image.asset(
                                              'assets/delicious.png'),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 3),
                                        child: customTitleText('ViewDucts'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            // Obx(
                            //   () => kIsWeb
                            //       ? Container()
                            //       : authState.networkConnectionState.value ==
                            //               'Not Connected'
                            //           ? Container(
                            //               decoration: BoxDecoration(
                            //                   color: darkBackground,
                            //                   borderRadius:
                            //                       BorderRadius.circular(10)),
                            //               width: context.responsiveValue(
                            //                   mobile: Get.height * 0.25,
                            //                   tablet: Get.height * 0.25,
                            //                   desktop: Get.height * 0.25),
                            //               child: SingleChildScrollView(
                            //                   child: Padding(
                            //                 padding: const EdgeInsets.all(3.0),
                            //                 child: Row(
                            //                   mainAxisAlignment:
                            //                       MainAxisAlignment.start,
                            //                   crossAxisAlignment:
                            //                       CrossAxisAlignment.start,
                            //                   children: [
                            //                     Icon(
                            //                         color: darkAccent,
                            //                         CupertinoIcons.wifi_slash),
                            //                     Padding(
                            //                       padding:
                            //                           const EdgeInsets.all(3.0),
                            //                       child: Text('You\'re Offline',
                            //                           style: TextStyle(
                            //                               color:
                            //                                   Colors.redAccent,
                            //                               fontSize: context
                            //                                   .responsiveValue(
                            //                                       mobile:
                            //                                           Get.height *
                            //                                               0.025,
                            //                                       tablet:
                            //                                           Get.height *
                            //                                               0.025,
                            //                                       desktop:
                            //                                           Get.height *
                            //                                               0.025),
                            //                               fontWeight:
                            //                                   FontWeight.w100)),
                            //                     ),
                            //                   ],
                            //                 ),
                            //               )),
                            //             )
                            //           : SizedBox(),
                            // ),
                          ],
                        ),
                      ),

                      Positioned(
                        top: 1,
                        // left: appSize.width * 0.7,
                        right: appSize.width * 0.3,
                        child: Row(
                          children: const <Widget>[
                            AdminNotificationForUsers(),
                          ],
                        ),
                      ),

                      !isSelected.value
                          ? Container()
                          : visibleSwitch.value
                              ? Container()
                              : commissionProduct == null
                                  ? Container()
                                  : Positioned(
                                      bottom: fullWidth(context) * 0.1,
                                      right: 5,
                                      child: frostedYellow(
                                        SizedBox(
                                          width: fullWidth(context) * 0.25,
                                          height: fullWidth(context) * 0.3,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            addAutomaticKeepAlives: false,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemBuilder: (context, index) =>
                                                Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                  height:
                                                      fullWidth(context) * 0.3,
                                                  width:
                                                      fullWidth(context) * 0.3,
                                                  child: Stack(
                                                    children: [
                                                      _Orders(
                                                        list:
                                                            commissionProduct![
                                                                index],
                                                      ),
                                                      Positioned(
                                                        bottom: 0,
                                                        left: 0,
                                                        child: IconButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              ductId = null;
                                                              isSelected.value =
                                                                  !isSelected
                                                                      .value;
                                                            });
                                                          },
                                                          iconSize:
                                                              Get.width * 0.1,
                                                          icon: const Icon(
                                                              Icons.delete),
                                                          color: Colors.red,
                                                        ),
                                                      )
                                                    ],
                                                  )),
                                            ),
                                            itemCount:
                                                commissionProduct!.length,
                                          ),
                                        ),
                                      ),
                                    ),
                      !isSelected.value
                          ? Container()
                          : Positioned(
                              bottom: 20,
                              left: 10,
                              child: Wrap(children: [
                                Icon(
                                  CupertinoIcons.music_note_2,
                                  color: CupertinoColors.systemTeal,
                                  size: 50,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    final pickedFile =
                                        // ignore: deprecated_member_use
                                        await FilePicker.platform
                                            .pickFiles(type: FileType.audio);
                                    // File files = File(pickedFile!.path);
                                    // XTypeGroup typeGroup = XTypeGroup(
                                    //   extensions: <String>['mp3', 'wav'],
                                    // );

                                    // final files = await openFile(
                                    //     acceptedTypeGroups: <XTypeGroup>[typeGroup]);
                                    //  setState(() async {
                                    File file = File(pickedFile!
                                        .files.single.path
                                        .toString());
                                    cprint('${file.lengthSync()}');
                                    if (file.lengthSync() > 5000000) {
                                      setState(() {
                                        //file = null;
                                        audioFile = null;
                                      });

                                      _showDialog();
                                    } else {
                                      setState(() {
                                        audioFile = file;
                                      });
                                      if (audioFile != null) {
                                        setState(() {
                                          isPlaying == true;
                                          audioPlayer
                                              .play(UrlSource(audioFile!.path));
                                        });

                                        setState(() {
                                          audioFile = file;
                                        });
                                      }
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  offset: const Offset(0, 11),
                                                  blurRadius: 11,
                                                  color: Colors.black
                                                      .withOpacity(0.06))
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            color: CupertinoColors
                                                .lightBackgroundGray),
                                        padding: const EdgeInsets.all(5.0),
                                        child: isPlaying
                                            ? TitleText('Playing Now')
                                            : audioFile == null
                                                ? TitleText('Add Music Tag')
                                                : TitleText(
                                                    'Music Tag Added!')),
                                  ),
                                ),
                                audioFile == null
                                    ? Container()
                                    : GestureDetector(
                                        onTap: () async {
                                          if (isPlaying) {
                                            await audioPlayer.pause();
                                          } else {
                                            await audioPlayer.play(
                                                UrlSource(audioFile!.path));
                                          }
                                        },
                                        child: isPlaying
                                            ? Icon(
                                                CupertinoIcons.pause_fill,
                                                color: CupertinoColors
                                                    .lightBackgroundGray,
                                                size: 20,
                                              )
                                            : Icon(
                                                CupertinoIcons.play_arrow,
                                                color: CupertinoColors
                                                    .lightBackgroundGray,
                                                size: 20,
                                              ),
                                      )
                              ]))
                    ],
                  )),
      ),
    );
  }
}

// ignore: must_be_immutable
class _Orders extends StatefulWidget {
  const _Orders({
    Key? key,
    this.isSelected,
//    required this.model,
    this.list,
    //this.ductId,
  }) : super(key: key);

  final ValueNotifier<bool>? isSelected;
  //final FeedModel? model;
  final FeedModel? list;
  //String? ductId;

  @override
  __OrdersState createState() => __OrdersState();
}

class __OrdersState extends State<_Orders> {
  Widget _imageFeed(String? _image) {
    return _image == null
        ? Container()
        : Container(
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 11),
                        blurRadius: 11,
                        color: Colors.black.withOpacity(0.06))
                  ],
                  borderRadius: BorderRadius.circular(18),
                  color: CupertinoColors.lightBackgroundGray),
              padding: const EdgeInsets.all(5.0),
              // height: fullHeight(context),
              // width: fullWidth(context),
              child: customNetworkImage(
                _image,
                fit: BoxFit.cover,
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    Storage storage = Storage(clientConnect());
    // Image? url;
    // storage
    //     .getFileView(
    //         bucketId: productBucketId, fileId: '${widget.list?.imagePath}')
    //     .then((bytes) {
    //   url = Image.memory(bytes);
    // });
    return Stack(
      children: [
        SizedBox(
          width: fullWidth(context) * 0.2,
          height: fullWidth(context) * 0.2,
          child: FutureBuilder(
            future: storage.getFileView(
                bucketId: productBucketId,
                fileId:
                    '${widget.list?.imagePath}'), //works for both public file and private file, for private files you need to be logged in
            builder: (context, snapshot) {
              return snapshot.hasData && snapshot.data != null
                  ? Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 11),
                                blurRadius: 11,
                                color: Colors.black.withOpacity(0.06))
                          ],
                          borderRadius: BorderRadius.circular(5),
                          color: CupertinoColors.systemYellow),
                      child: Image.memory(snapshot.data as Uint8List,
                          width: Get.height * 0.3,
                          height: Get.height * 0.4,
                          fit: BoxFit.contain),
                    )
                  : Center(
                      child: SizedBox(
                      width: Get.height * 0.2,
                      height: Get.height * 0.2,
                      child: LoadingIndicator(
                          indicatorType: Indicator.ballTrianglePath,

                          /// Required, The loading type of the widget
                          colors: const [
                            Colors.pink,
                            Colors.green,
                            Colors.blue
                          ],

                          /// Optional, The color collections
                          strokeWidth: 0.5,

                          /// Optional, The stroke of the line, only applicable to widget which contains line
                          backgroundColor: Colors.transparent,

                          /// Optional, Background of the widget
                          pathBackgroundColor: Colors.blue

                          /// Optional, the stroke backgroundColor
                          ),
                    )
                      //  CircularProgressIndicator
                      //     .adaptive()
                      );
            },
          ),
          //_imageFeed(widget.list?.imagePath),
        ),
      ],
    );
  }
}

class _ComposeRetweet
    extends WidgetView<ComposeDuctsPage, _ComposeTweetReplyPageState> {
  const _ComposeRetweet(this.viewState) : super(viewState);

  final _ComposeTweetReplyPageState viewState;

  @override
  Widget build(BuildContext context) {
    // var feedState = Provider.of<AuthState>(context);
    return SizedBox(
      height: fullHeight(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: _TextField(
                isTweet: false,
                isRetweet: true,
                textEditingController: viewState._textEditingController,
              ),
            ),
          ),
          const SizedBox(
            width: 16,
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class _ComposeTweet
    extends WidgetView<ComposeDuctsPage, _ComposeTweetReplyPageState> {
  _ComposeTweet(this.viewState, this.visibleSwitch, this.model, this.ductId,
      this._isPlaying, this.controller, this.isTyping)
      : super(viewState);
  final FeedModel? model;
  final _ComposeTweetReplyPageState viewState;
  final ValueNotifier<bool> visibleSwitch;
  final ValueNotifier<bool> isTyping;
  VideoPlayerController? controller;
  // ignore: unused_field
  final bool _isPlaying;
  ValueNotifier<bool> isSelected = ValueNotifier(false);
  String? ductId;
  // Trimmer trimmer = Trimmer();
  VideoPlayerController? videoPlayerController;

  @override
  Widget build(BuildContext context) {
    // var feedState = Provider.of<FeedState>(context, listen: false);
    // var feedState = Provider.of<AuthState>(context, listen: false);
    return Stack(
      children: [
        visibleSwitch.value
            ? Container()
            : SizedBox(
                width: Get.height * 0.8,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // customImage(context, feedState.user?.photoURL, height: 40),

                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: _TextField(
                                isTweet: widget.isTweet,
                                textEditingController:
                                    viewState._textEditingController,
                              ),
                            ),
                          ),

                          // customImage(context, authState.userModel?.profilePic,
                          //     height: 40),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }
}

// ignore: must_be_immutable
class _TextField extends StatefulWidget {
  _TextField(
      {Key? key,
      this.textEditingController,
      this.isTweet = false,
      this.isRetweet = false,
      this.isTyping})
      : super(key: key);
  final TextEditingController? textEditingController;
  ValueNotifier<bool>? isTyping = ValueNotifier(false);
  final bool isTweet;
  final bool isRetweet;

  @override
  __TextFieldState createState() => __TextFieldState();
}

class __TextFieldState extends State<_TextField> {
  setWritingTo(bool val) {
    setState(() {
      widget.isTyping!.value = val;
    });
  }
//  _textEditing() {
//     if (_textEditingController.text.isNotEmpty && typing == false) {
//       // lastSeen = feedState.chatUser.userId;
//       // feedState.lastSeen(feedState.chatUser.userId, contacts);
//       isTyping.value = true;
//       typing = true;
//     }
//     if (_textEditingController.text.isEmpty && typing == true) {
//       // lastSeen = true;
//       // feedState.lastSeen2(feedState.chatUser.userId, contacts);
//       isTyping.value = true;
//       typing = false;
//     }
//   }

  @override
  Widget build(BuildContext context) {
    // final searchState = Provider.of<SearchState>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 11),
                blurRadius: 11,
                color: Colors.black.withOpacity(0.06))
          ],
          borderRadius: BorderRadius.circular(5),
          color: CupertinoColors.lightBackgroundGray),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TextField(
          controller: widget.textEditingController,
          onChanged: (text) {
            if (text.isNotEmpty || text.isNotEmpty || text.trim() != "") {}
            if (text.isEmpty || text.trim() == "") {}
          },
          maxLines: null,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: widget.isTweet
                  ? 'Duct your experence '
                  : widget.isRetweet
                      ? 'Add a comment'
                      : 'Duct your reply',
              hintStyle: TextStyle(
                fontSize: context.responsiveValue(
                    mobile: Get.height * 0.025,
                    tablet: Get.height * 0.025,
                    desktop: Get.height * 0.025),
              )),
        ),
      ),
    );
  }
}

class _UserList extends StatelessWidget {
  const _UserList({Key? key, this.list, this.textEditingController})
      : super(key: key);
  final List<ViewductsUser>? list;
  final TextEditingController? textEditingController;

  @override
  Widget build(BuildContext context) {
    return
        // !Provider.of<ComposeTweetState>(context).displayUserList ||
        //         list == null ||
        //         list.length < 0 ||
        //         list.length == 0
        //     ? SizedBox.shrink()
        //     :
        Container(
      padding: const EdgeInsetsDirectional.only(bottom: 50),
      color: TwitterColor.white,
      constraints:
          const BoxConstraints(minHeight: 30, maxHeight: double.infinity),
      child: SizedBox(
        width: Get.width,
        height: Get.height,
        child: ListView.builder(
          itemCount: list!.length,
          itemBuilder: (context, index) {
            return _UserTile(
              user: list![index],
              onUserSelected: (user) {
                // textEditingController.text =
                //     Provider.of<ComposeTweetState>(context)
                //             .getDescription(user.userName) +
                //         " ";
                // textEditingController.selection = TextSelection.collapsed(
                //     offset: textEditingController.text.length);
                // Provider.of<ComposeTweetState>(context).onUserSelected();
              },
            );
          },
        ),
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile({Key? key, this.user, this.onUserSelected}) : super(key: key);
  final ViewductsUser? user;
  final ValueChanged<ViewductsUser?>? onUserSelected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onUserSelected!(user);
      },
      leading:
          Material(child: customImage(context, user!.profilePic, height: 35)),
      title: Row(
        children: <Widget>[
          ConstrainedBox(
            constraints:
                BoxConstraints(minWidth: 0, maxWidth: fullWidth(context) * .5),
            child: TitleText(user!.displayName,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                overflow: TextOverflow.ellipsis),
          ),
          const SizedBox(width: 3),
          user!.isVerified!
              ? customIcon(
                  context,
                  icon: AppIcon.blueTick,
                  istwitterIcon: true,
                  iconColor: AppColor.primary,
                  size: 13,
                  paddingIcon: 3,
                )
              : const SizedBox(width: 0),
        ],
      ),
      subtitle: Text(user!.userName!),
    );
  }
}

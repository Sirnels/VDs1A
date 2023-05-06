import 'dart:io';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aws_s3_client/flutter_aws_s3_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:native_video_view/native_video_view.dart';
import 'package:universal_html/html.dart' as html;
//import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:viewducts/features/products/product_controller.dart';
import 'package:viewducts/helper/theme.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/chatModel.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/page/responsive.dart';
import 'package:viewducts/page/responsiveView.dart';
import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/duct/ductsaudioplayer.dart';

class VideoUploadAdmin extends ConsumerStatefulWidget {
  final File? videoFile;
  final String? videoPath;
  final bool? isBible;
  final bool? isLocal;
  final bool? playNow;
  final bool? isOnline;
  final bool? isLocalPlaying;
  final ViewductsUser? currentUser;
  final ChatMessage? chat;
  final bool? isChatOnline;

  const VideoUploadAdmin({
    Key? key,
    this.videoFile,
    this.videoPath,
    this.isLocal,
    this.playNow,
    this.isOnline,
    this.isChatOnline,
    this.chat,
    this.isBible,
    this.isLocalPlaying,
    this.currentUser,
  }) : super(key: key);

  @override
  ConsumerState<VideoUploadAdmin> createState() => _VideoUploadAdminState();
}

class _VideoUploadAdminState extends ConsumerState<VideoUploadAdmin> {
  late VideoPlayerController controller;

  // UploadVideoController uploadVideoController =
  //     Get.put(UploadVideoController());
  bool isPlaying = false;
  var imagePathOnline;
  @override
  void initState() {
    super.initState();
    // final wasabiAws = ref.read(getDataApiKeywasabiAwsProvider).value;
    // final AwsS3Client s3client = AwsS3Client(
    //     region: wasabiAws?.region ?? '',
    //     host: "s3.wasabisys.com",
    //     bucketId: "storage-viewduct",
    //     accessKey: wasabiAws?.accessKey.toString() ?? '',
    //     secretKey: wasabiAws?.secretKey.toString() ?? '');

    // imagePathOnline =
    //     s3client.buildSignedGetParams(key: widget.videoPath.toString()).uri;
    // if (widget.isLocal == true || widget.isChatOnline == true) {
    //   controller = VideoPlayerController.file(widget.videoFile!);
    //   setState(() {
    //     controller = VideoPlayerController.network(imagePathOnline.toString());
    //   });
    //   controller.initialize();

    //   controller.pause();
    // } else if (kIsWeb) {
    //   setState(() {
    //     controller = VideoPlayerController.network(widget.videoPath.toString());
    //   });
    //   controller.initialize();

    //   controller.play();
    //   isPlaying = true;
    // }
    // if (widget.isOnline == true || widget.isBible == true) {
    //   setState(() {
    //     controller = VideoPlayerController.network(widget.videoPath!);
    //   });
    // } else if (widget.isChatOnline == true) {
    //   setState(() {
    //     controller = VideoPlayerController.network(imagePathOnline.toString());
    //   });
    // } else {
    //   setState(() {
    //     controller = VideoPlayerController.file(widget.videoFile!);
    //   });
    // }

    // controller.initialize();
    // if (widget.playNow == true || widget.isOnline == true) {
    //   isPlaying = true;
    //   controller.play();
    // } else {
    //   controller.pause();
    // }

    // //
    // controller.setVolume(1);
    // controller.setLooping(true);
  }

  void _chatVideo(BuildContext context) {
    setState(() {
      isPlaying = true;
      // controller.play();
    });

    showModalBottomSheet(
        backgroundColor: Colors.black12,
        isDismissible: false,
        //bounce: true,
        context: context,
        builder: (context) => Scaffold(
              backgroundColor: CupertinoColors.darkBackgroundGray,
              body: SafeArea(
                  child: Responsive(
                mobile: Stack(
                  children: <Widget>[
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 11),
                                  blurRadius: 11,
                                  color: Colors.black.withOpacity(0.06))
                            ],
                            borderRadius: BorderRadius.circular(18),
                            color: CupertinoColors.darkBackgroundGray),
                        padding: const EdgeInsets.all(5.0),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: Stack(
                          children: [
                            NativeVideoView(
                              keepAspectRatio: true,
                              showMediaController: true,
                              onCreated: (controller) {
                                if (widget.isOnline == true ||
                                    widget.isBible == true) {
                                  setState(() {
                                    controller.setVideoSource(widget.videoPath!,
                                        sourceType: VideoSourceType.network);
                                    //= VideoPlayerController.network(widget.videoPath!);
                                  });
                                } else if (widget.isChatOnline == true) {
                                  setState(() {
                                    controller.setVideoSource(
                                        imagePathOnline.toString(),
                                        sourceType: VideoSourceType.network);
                                    // controller = VideoPlayerController.network(
                                    //     imagePathOnline.toString());
                                  });
                                } else {
                                  setState(() {
                                    controller.setVideoSource(
                                        widget.videoPath.toString(),
                                        sourceType: VideoSourceType.file);
                                    // controller = VideoPlayerController.file(
                                    //     widget.videoFile!);
                                  });
                                }
                                // controller.setVideoSource(
                                //   'assets/example.mp4',
                                //   sourceType: VideoSourceType.asset,
                                // );
                              },
                              onPrepared: (controller, info) {
                                controller.play();
                              },
                              onError: (controller, what, extra, message) {
                                cprint(
                                    'Player Error ($what | $extra | $message)');
                              },
                              onCompletion: (controller) {
                                cprint('Video completed');
                              },
                              onProgress: (progress, duration) {
                                cprint('$progress | $duration');
                              },
                            ),
                            //VideoPlayer(controller),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: Get.height * 0.02,
                      left: 10,
                      child: GestureDetector(
                        onTap: () async {
                          NativeVideoView(
                            keepAspectRatio: true,
                            showMediaController: true,
                            onCreated: (controller) {
                              if (widget.isOnline == true ||
                                  widget.isBible == true) {
                                setState(() {
                                  controller.setVideoSource(widget.videoPath!,
                                      sourceType: VideoSourceType.network);
                                  //= VideoPlayerController.network(widget.videoPath!);
                                });
                              } else if (widget.isChatOnline == true) {
                                setState(() {
                                  controller.setVideoSource(
                                      imagePathOnline.toString(),
                                      sourceType: VideoSourceType.network);
                                  // controller = VideoPlayerController.network(
                                  //     imagePathOnline.toString());
                                });
                              } else {
                                setState(() {
                                  controller.setVideoSource(
                                      widget.videoPath.toString(),
                                      sourceType: VideoSourceType.file);
                                  // controller = VideoPlayerController.file(
                                  //     widget.videoFile!);
                                });
                              }
                              // controller.setVideoSource(
                              //   'assets/example.mp4',
                              //   sourceType: VideoSourceType.asset,
                              // );
                            },
                            onPrepared: (controller, info) {
                              controller.play();
                            },
                            onError: (controller, what, extra, message) {
                              cprint(
                                  'Player Error ($what | $extra | $message)');
                            },
                            onCompletion: (controller) {
                              cprint('Video completed');
                            },
                            onProgress: (progress, duration) {
                              cprint('$progress | $duration');
                            },
                          );
                          // controller.pause();

                          Navigator.maybePop(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(0, 11),
                                    blurRadius: 11,
                                    color: Colors.black.withOpacity(0.06))
                              ],
                              borderRadius: BorderRadius.circular(18),
                              color: CupertinoColors.inactiveGray),
                          padding: const EdgeInsets.all(5.0),
                          child: const Icon(
                            CupertinoIcons.back,
                            color: CupertinoColors.lightBackgroundGray,
                            size: 20,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                tablet: Stack(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Stack(
                            children: <Widget>[
                              Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.grey.withOpacity(.3),
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  child: Stack(
                                    children: [
                                      NativeVideoView(
                                        keepAspectRatio: true,
                                        showMediaController: true,
                                        onCreated: (controller) {
                                          if (widget.isOnline == true ||
                                              widget.isBible == true) {
                                            setState(() {
                                              controller.setVideoSource(
                                                  widget.videoPath!,
                                                  sourceType:
                                                      VideoSourceType.network);
                                              //= VideoPlayerController.network(widget.videoPath!);
                                            });
                                          } else if (widget.isChatOnline ==
                                              true) {
                                            setState(() {
                                              controller.setVideoSource(
                                                  imagePathOnline.toString(),
                                                  sourceType:
                                                      VideoSourceType.network);
                                              // controller = VideoPlayerController.network(
                                              //     imagePathOnline.toString());
                                            });
                                          } else {
                                            setState(() {
                                              controller.setVideoSource(
                                                  widget.videoPath.toString(),
                                                  sourceType:
                                                      VideoSourceType.file);
                                              // controller = VideoPlayerController.file(
                                              //     widget.videoFile!);
                                            });
                                          }
                                          // controller.setVideoSource(
                                          //   'assets/example.mp4',
                                          //   sourceType: VideoSourceType.asset,
                                          // );
                                        },
                                        onPrepared: (controller, info) {
                                          controller.play();
                                        },
                                        onError:
                                            (controller, what, extra, message) {
                                          cprint(
                                              'Player Error ($what | $extra | $message)');
                                        },
                                        onCompletion: (controller) {
                                          cprint('Video completed');
                                        },
                                        onProgress: (progress, duration) {
                                          cprint('$progress | $duration');
                                        },
                                      ),
                                      // VideoPlayer(controller),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
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
                          child: Stack(
                            children: <Widget>[
                              Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.grey.withOpacity(.3),
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  child: Stack(
                                    children: [
                                      NativeVideoView(
                                        keepAspectRatio: true,
                                        showMediaController: true,
                                        onCreated: (controller) {
                                          if (widget.isOnline == true ||
                                              widget.isBible == true) {
                                            setState(() {
                                              controller.setVideoSource(
                                                  widget.videoPath!,
                                                  sourceType:
                                                      VideoSourceType.network);
                                              //= VideoPlayerController.network(widget.videoPath!);
                                            });
                                          } else if (widget.isChatOnline ==
                                              true) {
                                            setState(() {
                                              controller.setVideoSource(
                                                  imagePathOnline.toString(),
                                                  sourceType:
                                                      VideoSourceType.network);
                                              // controller = VideoPlayerController.network(
                                              //     imagePathOnline.toString());
                                            });
                                          } else {
                                            setState(() {
                                              controller.setVideoSource(
                                                  widget.videoPath.toString(),
                                                  sourceType:
                                                      VideoSourceType.file);
                                              // controller = VideoPlayerController.file(
                                              //     widget.videoFile!);
                                            });
                                          }
                                          // controller.setVideoSource(
                                          //   'assets/example.mp4',
                                          //   sourceType: VideoSourceType.asset,
                                          // );
                                        },
                                        onPrepared: (controller, info) {
                                          controller.play();
                                        },
                                        onError:
                                            (controller, what, extra, message) {
                                          cprint(
                                              'Player Error ($what | $extra | $message)');
                                        },
                                        onCompletion: (controller) {
                                          cprint('Video completed');
                                        },
                                        onProgress: (progress, duration) {
                                          cprint('$progress | $duration');
                                        },
                                      ),
                                      // VideoPlayer(controller),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: Get.width > 1340 ? 2 : 4,
                          child: PlainScaffold(),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
            ));
  }

  void _uploadChatImge(BuildContext context) {
    cprint('${widget.chat!.fileDownloaded} video path');
    showModalBottomSheet(
        backgroundColor: Colors.red,
        // bounce: true,
        context: context,
        builder: (context) => Scaffold(
              backgroundColor: CupertinoColors.darkBackgroundGray,
              body: SafeArea(
                  child: Responsive(
                mobile: Stack(
                  children: <Widget>[
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.grey.withOpacity(.3),
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: Stack(
                          children: [
                            Center(
                              child: Container(
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          offset: const Offset(0, 11),
                                          blurRadius: 11,
                                          color: Colors.black.withOpacity(0.06))
                                    ],
                                    borderRadius: BorderRadius.circular(18),
                                    color: CupertinoColors.darkBackgroundGray),
                                padding: const EdgeInsets.all(5.0),
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                child: NativeVideoView(
                                  keepAspectRatio: true,
                                  showMediaController: true,
                                  onCreated: (controller) {
                                    if (widget.isOnline == true ||
                                        widget.isBible == true) {
                                      setState(() {
                                        controller.setVideoSource(
                                            widget.videoPath!,
                                            sourceType:
                                                VideoSourceType.network);
                                        //= VideoPlayerController.network(widget.videoPath!);
                                      });
                                    } else if (widget.isChatOnline == true) {
                                      setState(() {
                                        controller.setVideoSource(
                                            imagePathOnline.toString(),
                                            sourceType:
                                                VideoSourceType.network);
                                        // controller = VideoPlayerController.network(
                                        //     imagePathOnline.toString());
                                      });
                                    } else {
                                      setState(() {
                                        controller.setVideoSource(
                                            widget.videoPath.toString(),
                                            sourceType: VideoSourceType.file);
                                        // controller = VideoPlayerController.file(
                                        //     widget.videoFile!);
                                      });
                                    }
                                    // controller.setVideoSource(
                                    //   'assets/example.mp4',
                                    //   sourceType: VideoSourceType.asset,
                                    // );
                                  },
                                  onPrepared: (controller, info) {
                                    controller.play();
                                  },
                                  onError: (controller, what, extra, message) {
                                    cprint(
                                        'Player Error ($what | $extra | $message)');
                                  },
                                  onCompletion: (controller) {
                                    cprint('Video completed');
                                  },
                                  onProgress: (progress, duration) {
                                    cprint('$progress | $duration');
                                  },
                                ),
                                // VideoPlayer(controller),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                tablet: Stack(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Stack(
                            children: <Widget>[
                              Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.grey.withOpacity(.3),
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  child: Stack(
                                    children: [
                                      VideoUploadAdmin(
                                        isLocal: true,
                                        playNow: true,
                                        videoFile:
                                            File(widget.videoPath.toString()),
                                        videoPath: widget.videoPath.toString(),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
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
                          child: Stack(
                            children: <Widget>[
                              Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.grey.withOpacity(.3),
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  child: Stack(
                                    children: [
                                      VideoUploadAdmin(
                                        playNow: true,
                                        isLocal: true,
                                        videoFile:
                                            File(widget.videoPath.toString()),
                                        videoPath: widget.videoPath.toString(),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: Get.width > 1340 ? 2 : 4,
                          child: PlainScaffold(),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
            ));
  }

  RxString savedFile = ''.obs;
  RxBool isdownloading = false.obs;
  Future<void> _downloadFile() async {
    setState(() {});
    isdownloading.value = true;
    final localMessage = widget.chat;
    cprint('${localMessage?.videoKey} video path');
    DownloadService downloadService =
        kIsWeb ? WebDownloadService() : MobileDownloadService();
    await downloadService.download(
        url: widget.videoPath.toString(), savedFile: savedFile.value);

    widget.chat?.fileDownloaded = 'downloded';
    localMessage?.fileDownloaded = 'downloded';
    localMessage!.videoKey = chatState.savedFile!.value.toString();
    cprint('${localMessage.videoKey} video path');
    await chatState.updateDownlodImageMessage(
        chat: widget.chat,
        currentUser: widget.currentUser!.userId.toString(),
        secondUser: widget.chat!.senderId.toString(),
        localMessage: localMessage);
    isdownloading.value = false;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    //controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.4,
      color: CupertinoColors.darkBackgroundGray,
      child: Stack(
        children: [
          widget.isLocal == true || widget.isChatOnline == true || kIsWeb
              ? SingleChildScrollView(
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        _uploadChatImge(context);
                        // if (widget.playNow == true) {
                        //   if (!isPlaying) {
                        //     setState(() {
                        //       isPlaying = true;
                        //       controller.play();
                        //     });
                        //   } else {
                        //     setState(() {
                        //       isPlaying = false;
                        //       controller.pause();
                        //     });
                        //   }
                        // }
                      },
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(0, 11),
                                    blurRadius: 11,
                                    color: Colors.black.withOpacity(0.06))
                              ],
                              borderRadius: BorderRadius.circular(18),
                              color: CupertinoColors.darkBackgroundGray),
                          padding: const EdgeInsets.all(5.0),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: VideoPlayer(controller),
                          // VideoPlayer(controller),
                        ),
                      ),
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        // if (widget.playNow == true) {
                        //   if (!isPlaying) {
                        //     setState(() {
                        //       isPlaying = true;
                        //       controller.play();
                        //     });
                        //   } else {
                        //     setState(() {
                        //       isPlaying = false;
                        //       controller.pause();
                        //     });
                        //   }
                        // }
                      },
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    offset: const Offset(0, 11),
                                    blurRadius: 11,
                                    color: Colors.black.withOpacity(0.06))
                              ],
                              borderRadius: BorderRadius.circular(18),
                              color: CupertinoColors.darkBackgroundGray),
                          padding: const EdgeInsets.all(5.0),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: NativeVideoView(
                            keepAspectRatio: true,
                            showMediaController: true,
                            onCreated: (controller) {
                              if (widget.isOnline == true ||
                                  widget.isBible == true) {
                                setState(() {
                                  controller.setVideoSource(
                                      '${widget.videoPath}',
                                      sourceType: VideoSourceType.network);
                                  //= VideoPlayerController.network(widget.videoPath!);
                                });
                              } else if (widget.isChatOnline == true) {
                                setState(() {
                                  controller.setVideoSource(
                                      imagePathOnline.toString(),
                                      sourceType: VideoSourceType.network);
                                  // controller = VideoPlayerController.network(
                                  //     imagePathOnline.toString());
                                });
                              } else {
                                setState(() {
                                  controller.setVideoSource(
                                      widget.videoPath.toString(),
                                      sourceType: VideoSourceType.file);
                                  // controller = VideoPlayerController.file(
                                  //     widget.videoFile!);
                                });
                              }
                              // controller.setVideoSource(
                              //   'assets/example.mp4',
                              //   sourceType: VideoSourceType.asset,
                              // );
                            },
                            onPrepared: (controller, info) {
                              controller.play();
                            },
                            onError: (controller, what, extra, message) {
                              cprint(
                                  'Player Error ($what | $extra | $message)');
                            },
                            onCompletion: (controller) {
                              cprint('Video completed');
                            },
                            onProgress: (progress, duration) {
                              cprint('$progress | $duration');
                            },
                          ),
                          // VideoPlayer(controller),
                        ),
                      ),
                    ),
                  ),
                ),
          Center(
            child: widget.isLocal == true || widget.isChatOnline == true
                ? GestureDetector(
                    onTap: () {
                      widget.isLocalPlaying == true
                          ? setState(() {
                              isPlaying = true;
                              controller.play();
                            })
                          : widget.isLocal == true
                              ? _uploadChatImge(context)
                              : widget.isChatOnline == true
                                  ? _chatVideo(context)
                                  : setState(() {
                                      isPlaying = true;
                                      controller.play();
                                    });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 11),
                                blurRadius: 11,
                                color: Colors.black.withOpacity(0.06))
                          ],
                          borderRadius: BorderRadius.circular(100),
                          color: CupertinoColors.darkBackgroundGray),
                      padding: const EdgeInsets.all(5.0),
                      child: Icon(
                        CupertinoIcons.play,
                        color: CupertinoColors.systemGrey,
                        size: Get.height * 0.07,
                      ),
                    ),
                  )
                : Container(),
          ),
          widget.isLocal == true
              ? Container()
              : widget.chat?.fileDownloaded != 'downloded' &&
                      widget.chat?.senderId != widget.currentUser?.userId
                  ? isdownloading.value == true
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'downloding...',
                            style:
                                TextStyle(color: CupertinoColors.systemYellow),
                          ),
                        )
                      : widget.isBible == true
                          ? Container()
                          : widget.isChatOnline == true
                              ? Positioned(
                                  child: GestureDetector(
                                    onTap: _downloadFile,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        color: CupertinoColors.systemYellow,
                                        CupertinoIcons.arrow_down_doc_fill,
                                        size: 40,
                                      ),
                                    ),
                                  ),
                                )
                              : Container()
                  : Container(),
          kIsWeb
              ? Center(
                  child: GestureDetector(
                    onTap: () async {
                      if (isPlaying == true) {
                        setState(() {
                          isPlaying = false;
                          controller.pause();
                        });
                      } else {
                        setState(() {
                          isPlaying = true;
                          controller.play();
                        });
                      }
                    },
                    child: isPlaying == true
                        ? Icon(
                            CupertinoIcons.pause_fill,
                            color: CupertinoColors.lightBackgroundGray,
                            size: 50,
                          )
                        : Icon(
                            CupertinoIcons.play_arrow,
                            color: CupertinoColors.lightBackgroundGray,
                            size: 50,
                          ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}

class AudioUploadAdmin extends StatefulWidget {
  final String? audioPickedFile;
  final bool? loacalFile;
  const AudioUploadAdmin({
    Key? key,
    this.audioPickedFile,
    this.loacalFile,
  }) : super(key: key);

  @override
  State<AudioUploadAdmin> createState() => _AudioUploadAdminState();
}

class _AudioUploadAdminState extends State<AudioUploadAdmin> {
  late VideoPlayerController controller;

  final audioPlayer = AudioPlayer();
  Duration duration = (Duration.zero);
  Duration position = Duration.zero;

  bool isPlaying = false;
  // UploadVideoController uploadVideoController =
  //     Get.put(UploadVideoController());

  @override
  void initState() {
    super.initState();
    setState(() {
      isPlaying == true;
      audioPlayer.play(UrlSource('${widget.audioPickedFile}'));
    });
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

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CupertinoColors.darkBackgroundGray,
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.grey.withOpacity(.3),
            ),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.35,
            child: Stack(
              children: [
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      widget.loacalFile == true
                          ? DuctsAudioPlayer(
                              audioFile: widget.audioPickedFile,
                            )
                          : Row(
                              children: [
                                Padding(
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
                                          color: CupertinoColors.inactiveGray),
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text('Audio File')),
                                ),
                                const Icon(
                                  CupertinoIcons.music_note_2,
                                  color: AppColor.darkGrey,
                                )
                              ],
                            ),
                      widget.loacalFile == true
                          ? Container()
                          : GestureDetector(
                              onTap: () async {
                                if (isPlaying == true) {
                                  setState(() {
                                    audioPlayer.pause();
                                    isPlaying == false;
                                  });
                                } else {
                                  await audioPlayer.play(UrlSource(
                                      widget.audioPickedFile!.toString()));
                                }
                              },
                              child: isPlaying == true
                                  ? Icon(
                                      CupertinoIcons.pause_fill,
                                      color:
                                          CupertinoColors.lightBackgroundGray,
                                      size: 50,
                                    )
                                  : Icon(
                                      CupertinoIcons.play_arrow,
                                      color:
                                          CupertinoColors.lightBackgroundGray,
                                      size: 50,
                                    ),
                            ),
                      AudioVisualizer(
                          isPlaying: isPlaying.obs,
                          duration: duration.inMilliseconds),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isObscure;
  final IconData icon;
  const TextInputField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.isObscure = false,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        labelStyle: const TextStyle(
          fontSize: 20,
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: borderColor,
            )),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: const BorderSide(
              color: borderColor,
            )),
      ),
      obscureText: isObscure,
    );
  }
}

// COLORS
const backgroundColor = Colors.black;
var buttonColor = Colors.red[400];
const borderColor = Colors.grey;

abstract class DownloadService {
  Future<void> download({required String url, String? savedFile});
}

class WebDownloadService implements DownloadService {
  @override
  Future<void> download({required String url, String? savedFile}) async {
    final AwsS3Client s3client = AwsS3Client(
        region: userCartController.wasabiAws.value.region.toString(),
        host: "s3.wasabisys.com",
        bucketId: "storage-viewduct",
        accessKey: userCartController.wasabiAws.value.accessKey.toString(),
        secretKey: userCartController.wasabiAws.value.secretKey.toString());

    var urls = s3client.buildSignedGetParams(key: url).uri;
    html.window.open(urls.toString(), "_blank");
  }
}

class MobileDownloadService implements DownloadService {
  @override
  Future<void> download({required String url, String? savedFile}) async {
    final AwsS3Client s3client = AwsS3Client(
        region: userCartController.wasabiAws.value.region.toString(),
        host: "s3.wasabisys.com",
        bucketId: "storage-viewduct",
        accessKey: userCartController.wasabiAws.value.accessKey.toString(),
        secretKey: userCartController.wasabiAws.value.secretKey.toString());

    var urls = s3client.buildSignedGetParams(key: url).uri;
    // requests permission for downloading the file
    bool hasPermission = await _requestWritePermission();
    if (!hasPermission) return;

    // gets the directory where we will download the file.
    var dir = await getApplicationDocumentsDirectory();

    // You should put the name you want for the file here.
    // Take in account the extension.
    String fileName = url;

    // downloads the file
    Dio dio = Dio();
    await dio.download(urls.toString(), "${dir.path}/$fileName");
    chatState.savedFile!.value = await "${dir.path}/$fileName";
    cprint('${chatState.savedFile!.value} video path');
    //     var response = await dio.get(
    //    urls.toString(),
    //     options: Options(responseType: ResponseType.bytes));
    // final result = await ImageGallerySaver.saveImage(
    //     Uint8List.fromList(response.data),
    //     quality: 100,
    //     name: savedFile);
    // cprint(result.toString());

    await ImageGallerySaver.saveFile(
      "${dir.path}/$fileName",
    );
    // opens the file
    // OpenFile.open("${dir.path}/$fileName", type: 'application/pdf');
  }

  // requests storage permission
  Future<bool> _requestWritePermission() async {
    await Permission.storage.request();
    return await Permission.storage.request().isGranted;
  }
}

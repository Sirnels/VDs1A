// ignore_for_file: must_be_immutable, file_names

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:storage_path/storage_path.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/model/fileModel.dart';

class ComposeTweetImage extends StatefulWidget {
  final File? image;
  final Function? onCrossIconPressed;
  const ComposeTweetImage({Key? key, this.image, this.onCrossIconPressed})
      : super(key: key);
  //String image;

  @override
  _ComposeTweetImageState createState() => _ComposeTweetImageState();
}

class _ComposeTweetImageState extends State<ComposeTweetImage> {
  List<FileModel>? imageFiles;

  FileModel? selectedModel;

  // getImagesPath() async {
  //   var imagePath = await StoragePath.imagesPath;
  //   var images = jsonDecode(imagePath) as List;
  //   imageFiles = images.map<FileModel>((e) => FileModel.fromJson(e)).toList();
  //   setState(() {
  //     selectedModel = imageFiles[0];
  //     widget.image = File(imageFiles[0].files[0]);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        child: widget.image == null
            ? Container()
            : Stack(
                children: <Widget>[
                  Container(
                    height: Get.height,
                    width: fullWidth(context),
                    decoration: BoxDecoration(
                      //  borderRadius: const BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                          image: FileImage(widget.image!), fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    //      alignment: Alignment.topLeft,
                    top: Get.height * 0.08,
                    left: 10,
                    child: IconButton(
                      padding: const EdgeInsets.all(0),
                      iconSize: Get.width * 0.07,
                      onPressed: widget.onCrossIconPressed as void Function()?,
                      icon: const Icon(CupertinoIcons.clear_circled_solid),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}

// class ComposeDuctVideo extends StatefulWidget {
//   final File file;
//   ComposeDuctVideo({Key key, @required this.file}) : super(key: key);

//   @override
//   _ComposeDuctVideoState createState() => _ComposeDuctVideoState();
// }

// class _ComposeDuctVideoState extends State<ComposeDuctVideo> {
//   VideoPlayerController _videoPlayerController;
//   @override
//   void initState() {
//     _videoPlayerController = VideoPlayerController.file(widget.file);
//     _videoPlayerController.setVolume(1.0);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(child: VideoPlayer(_videoPlayerController));
//   }

//   @override
//   void dispose() {
// ignore: todo
//     // TODO: implement dispose
//     super.dispose();
//     _videoPlayerController.dispose();
//   }
// }

class ComposeThumbnail extends StatelessWidget {
  final File? image;
  final Function? onCrossIconPressed;
  const ComposeThumbnail({Key? key, this.image, this.onCrossIconPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: image == null
            ? Container()
            : Stack(
                children: <Widget>[
                  InkWell(
                    onTap: onCrossIconPressed as void Function()?,
                    child: Material(
                      elevation: 10,
                      child: Container(
                        height: fullWidth(context) * 0.8,
                        width: fullWidth(context) * 0.8,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                              image: FileImage(image!), fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class ComposeMediaView extends StatefulWidget {
  String? image;
  File? selectedImage;
  final Function? onCrossIconPressed;

  FileModel? selectedModel;
  ComposeMediaView(
      {Key? key,
      this.image,
      this.selectedImage,
      this.onCrossIconPressed,
      this.selectedModel})
      : super(key: key);

  @override
  _ComposeMediaViewState createState() => _ComposeMediaViewState();
}

class _ComposeMediaViewState extends State<ComposeMediaView> {
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    getImagesPath();
  }

  List<FileModel>? imageFiles;
  // List<DropdownMenuItem> getFiles() {
  //   return imageFiles
  //           .map((e) => DropdownMenuItem(
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: customText(e.folder,
  //                       style: TextStyle(fontWeight: FontWeight.bold)),
  //                 ),
  //                 value: e,
  //               ))
  //           .toList() ??
  //       [];
  // }

  getImagesPath() async {
    //String imagePath = '';
    try {
      // var imagePath = await StoragePath.imagesPath;

      // var images = jsonDecode(imagePath) as List;
      // imageFiles = images.map<FileModel>((e) => FileModel.fromJson(e)).toList();
      // if (imageFiles != null && imageFiles.length > 0)
      //   setState(() {
      //     widget.selectedModel = imageFiles[0];
      //     widget.image = imageFiles[0].files[0];
      //   });
    } catch (e) {
      cprint('$e');
    }
    //  return imagePath;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          widget.selectedModel == null && widget.selectedModel!.files!.isEmpty
              ? Container()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: fullWidth(context) * 0.2,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              crossAxisSpacing: 1,
                              mainAxisSpacing: 1),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, i) {
                        var file = widget.selectedModel!.files![i];
                        return GestureDetector(
                          child: Image.file(File(file), fit: BoxFit.cover),
                          onTap: () {
                            setState(() {
                              widget.image = file;
                              widget.selectedImage = File(file);
                            });
                          },
                        );
                      },
                      itemCount: widget.selectedModel!.files!.length,
                    ),
                  ),
                ),
          // Row(
          //   children: [
          //     DropdownButtonHideUnderline(
          //         child: DropdownButton(
          //       items: getFiles(),
          //       onChanged: (d) {},
          //     )),
          //   ],
          // ),
          widget.image == null
              ? widget.selectedImage == null
                  ? Container()
                  : Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            height: fullWidth(context) * 0.55,
                            width: fullWidth(context) * 0.55,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              image: DecorationImage(
                                  image: FileImage(widget.selectedImage!),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        // Align(
                        //   alignment: Alignment.topRight,
                        //   child: Container(
                        //     padding: EdgeInsets.all(0),
                        //     decoration: BoxDecoration(
                        //         shape: BoxShape.circle, color: Colors.black54),
                        //     child: IconButton(
                        //       padding: EdgeInsets.all(0),
                        //       iconSize: 20,
                        //       onPressed: widget.onCrossIconPressed,
                        //       icon: Icon(
                        //         Icons.close,
                        //         color: Theme.of(context).colorScheme.onPrimary,
                        //       ),
                        //     ),
                        //   ),
                        // )
                      ],
                    )
              : Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        height: fullWidth(context) * 0.55,
                        width: fullWidth(context) * 0.55,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          image: DecorationImage(
                              image: FileImage(File(widget.image!)),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    // Align(
                    //   alignment: Alignment.topRight,
                    //   child: Container(
                    //     padding: EdgeInsets.all(0),
                    //     decoration: BoxDecoration(
                    //         shape: BoxShape.circle, color: Colors.black54),
                    //     child: IconButton(
                    //       padding: EdgeInsets.all(0),
                    //       iconSize: 20,
                    //       onPressed: widget.onCrossIconPressed,
                    //       icon: Icon(
                    //         Icons.close,
                    //         color: Theme.of(context).colorScheme.onPrimary,
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
        ],
      ),
    );
  }
}

// ignore_for_file: invalid_use_of_visible_for_testing_member, file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:viewducts/widgets/customWidgets.dart';

class ComposeBottomIconWidget extends StatefulWidget {
  final TextEditingController? textEditingController;
  final Function(File)? onImageIconSelcted;
  const ComposeBottomIconWidget(
      {Key? key, this.textEditingController, this.onImageIconSelcted})
      : super(key: key);

  @override
  _ComposeBottomIconWidgetState createState() =>
      _ComposeBottomIconWidgetState();
}

class _ComposeBottomIconWidgetState extends State<ComposeBottomIconWidget> {
  bool reachToWarning = false;
  bool reachToOver = false;
  Color? wordCountColor;
  String tweet = '';

  @override
  void initState() {
    wordCountColor = Colors.blue;
    widget.textEditingController!.addListener(updateUI);
    super.initState();
  }

  void updateUI() {
    setState(() {
      tweet = widget.textEditingController!.text;
      if (widget.textEditingController!.text.isNotEmpty) {
        if (widget.textEditingController!.text.length > 259 &&
            widget.textEditingController!.text.length < 280) {
          wordCountColor = Colors.orange;
        } else if (widget.textEditingController!.text.length >= 280) {
          wordCountColor = Theme.of(context).errorColor;
        } else {
          wordCountColor = Colors.blue;
        }
      }
    });
  }

  Widget _bottomIconWidget() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.transparent,
                  child: Image.asset('assets/image-gallery.png'),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blueGrey[50],
                      gradient: LinearGradient(
                        colors: [
                          Colors.yellow.withOpacity(0.1),
                          Colors.white60.withOpacity(0.2),
                          Colors.white60.withOpacity(0.3)
                          // Color(0xfffbfbfb),
                          // Color(0xfff7f7f7),
                        ],
                        // begin: Alignment.topCenter,
                        // end: Alignment.bottomCenter,
                      )),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 3),
                    child: customTitleText('Gallary'),
                  ),
                ),
              ],
            ),
            onTap: () => setImage(ImageSource.gallery),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.transparent,
                  child: Image.asset('assets/camera.png'),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blueGrey[50],
                      gradient: LinearGradient(
                        colors: [
                          Colors.yellow.withOpacity(0.1),
                          Colors.white60.withOpacity(0.2),
                          Colors.white60.withOpacity(0.3)
                          // Color(0xfffbfbfb),
                          // Color(0xfff7f7f7),
                        ],
                        // begin: Alignment.topCenter,
                        // end: Alignment.bottomCenter,
                      )),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 3),
                    child: customTitleText('Camera'),
                  ),
                ),
              ],
            ),
            onTap: () => setImage(ImageSource.camera),
          ),
        ),
      ],
    );

    // Row(
    //   children: <Widget>[
    //     Row(
    //       children: [
    //         IconButton(
    //             onPressed: () {
    //               setImage(ImageSource.gallery);
    //             },
    //             icon: Image.asset('assets/folder.png')
    //             // customIcon(context,
    //             //     icon: AppIcon.image,
    //             //     istwitterIcon: true,
    //             //     iconColor: AppColor.primary),
    //             ),
    //         IconButton(
    //             onPressed: () {
    //               setImage(ImageSource.camera);
    //             },
    //             icon: Image.asset('assets/camera.png')
    //             //  customIcon(context,
    //             //     icon: AppIcon.camera,
    //             //     istwitterIcon: true,
    //             //     iconColor: AppColor.primary)

    //             ),
    //       ],
    //     ),

    // Expanded(
    //     child: Align(
    //   alignment: Alignment.centerRight,
    //   child: Padding(
    //       padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
    //       child: tweet != null && tweet.length > 289
    //           ? Padding(
    //               padding: EdgeInsets.only(right: 10),
    //               child: customText('${280 - tweet.length}',
    //                   style: TextStyle(
    //                       color: Theme.of(context).errorColor)),
    //             )
    //           : Stack(
    //               alignment: Alignment.center,
    //               children: <Widget>[
    //                 CircularProgressIndicator(
    //                   value: getTweetLimit(),
    //                   backgroundColor: Colors.grey,
    //                   valueColor:
    //                       AlwaysStoppedAnimation<Color>(wordCountColor),
    //                 ),
    //                 tweet.length > 259
    //                     ? customText('${280 - tweet.length}',
    //                         style: TextStyle(color: wordCountColor))
    //                     : customText('',
    //                         style: TextStyle(color: wordCountColor))
    //               ],
    //             )),
    // ))
    //   ],
    // );
  }

  void setImage(ImageSource source) async {
    await ImagePicker.platform
        .pickImage(source: ImageSource.gallery, imageQuality: 50)
        .then((value) {
      setState(() {
        // _image = file;
        widget.onImageIconSelcted!(File(value!.path));
      });
    });

//_image = File(file!.path);
    // ImagePicker.platform.pickImage(source: source, imageQuality: 20).then((File file) {
    // setState(() {
    //   // _image = file;
    //   widget.onImageIconSelcted!(file);
    // });
    // });
  }

  void setVideo(ImageSource source) {
    // ImagePicker.pickVideo(
    //   source: source,
    // ).then((File file) {
    //   setState(() {
    //     // _image = file;
    //     widget.onImageIconSelcted(file);
    //   });
    // });
  }

  double getTweetLimit() {
    if (tweet.isEmpty) {
      return 0.0;
    }
    if (tweet.length > 280) {
      return 1.0;
    }
    var length = tweet.length;
    var val = length * 100 / 28000.0;
    return val;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _bottomIconWidget(),
    );
  }
}

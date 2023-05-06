// ignore_for_file: file_names, unnecessary_null_comparison, deprecated_member_use

import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aws_s3_client/flutter_aws_s3_client.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:minio/io.dart';
import 'package:minio/minio.dart';
import 'package:path/path.dart' as path;
import 'package:video_player/video_player.dart';
import 'package:viewducts/admin/screens/video_admin_upload.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/chatModel.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/page/message/chatProductsAndOrders.dart';
import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/frosted.dart';
import 'package:viewducts/widgets/newWidget/title_text.dart';

class EditProductPage extends StatefulWidget {
  final RxList<ViewductsUser>? profileData;
  final FeedModel? product;
  final String? profileId;
  final bool error;
  EditProductPage(
      {Key? key,
      this.profileId,
      this.profileData,
      this.product,
      this.error = false})
      : super(
          key: key,
        );
  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  File? _image;
  File? _video;
  late VideoPlayerController _controller;
  Duration? _duration;
  TextEditingController? _name;
  TextEditingController? salePrice;
  TextEditingController? _location;
  TextEditingController? _stockQauntity;
  TextEditingController? _sellingPrice;
  TextEditingController? _dob;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? dob;
  @override
  void initState() {
    getData();
    _name = TextEditingController();
    salePrice = TextEditingController();
    _location = TextEditingController();
    _dob = TextEditingController();
    _sellingPrice = TextEditingController();
    _stockQauntity = TextEditingController();
    //var state = Provider.of<AuthState>(context, listen: false);
    _name!.text = widget.product!.productName!;
    salePrice!.text = widget.product!.salePrice.toString();
    _stockQauntity!.text = widget.product!.stockQuantity.toString();
    _sellingPrice!.text = widget.product!.selllingPrice.toString();

    // _location!.text = widget.profileData!
    //     .firstWhere((data) => data.key == widget.profileId,
    //         orElse: () => chatState.chatUser!)
    //     .location!;
    //_dob!.text = getdob('${authState.userModel?.dob}');
    super.initState();
  }

  @override
  void dispose() {
    _name!.dispose();
    salePrice!.dispose();
    _location!.dispose();
    _dob!.dispose();
    _sellingPrice!.dispose();
    _stockQauntity!.dispose();
    super.dispose();
  }

  getData() async {
    final database = Databases(
      clientConnect(),
    );
    await database
        .listDocuments(
      databaseId: databaseId,
      collectionId: sectionCollection,
//   queries: [
//  query.Query.equal('userId',model.)
//       ]
    )
        .then((data) {
      // Map map = data.toMap();

      var value =
          data.documents.map((e) => CategoryModel.fromJson(e.data)).toList();
      //data.documents;
      feedState.categoryModel!.value = value;
      finalSalesPrice?.value = (double.tryParse(salePrice!.text)! +
              (feedState.categoryModel!
                      .firstWhere(
                          (data) => data.section == widget.product!.section,
                          orElse: () => CategoryModel())
                      .categoryCommission!
                      .toDouble() *
                  (double.tryParse(salePrice!.text))!) +
              widget.product!.commissionPrice!.toDouble())
          .toString();
      totalPrice?.value = (double.tryParse(_sellingPrice!.text)! +
              (feedState.categoryModel!
                      .firstWhere(
                          (data) => data.section == widget.product!.section,
                          orElse: () => CategoryModel())
                      .categoryCommission!
                      .toDouble() *
                  (double.tryParse(_sellingPrice!.text))!) +
              widget.product!.commissionPrice!.toDouble())
          .toString();

      // cprint('${data.documents.map((e) => FeedModel.fromJson(e.data))}');
      //cprint('${feedState.feedlist?.value.map((e) => e.key)}');
    });
  }

  Widget _entry(String title,
      {TextEditingController? controller,
      int? maxLine = 1,
      bool isenable = true}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          customText(title, style: const TextStyle(color: Colors.black54)),
          TextField(
            onChanged: (data) {
              setState(() {});
            },
            enabled: isenable,
            controller: controller,
            maxLines: maxLine,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
            ),
          )
        ],
      ),
    );
  }

  void showCalender() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2019, DateTime.now().month, DateTime.now().day),
      firstDate: DateTime(1950, DateTime.now().month, DateTime.now().day + 3),
      lastDate: DateTime.now().add(const Duration(days: 7)),
    );
    setState(() {
      if (picked != null) {
        dob = picked.toString();
        _dob!.text = getdob(dob);
      }
    });
  }

  void _submitButton() async {
    EasyLoading.show(status: 'Updating', dismissOnTap: true);
    var product = widget.product;
    if (_name!.text.length > 27) {
      customSnackBar(_scaffoldKey, 'Name length cannot exceed 27 character');
      return;
    }

    if (_image != null && _video != null) {
      // kScreenloader.showLoader(context);
      Storage storage = Storage(clientConnect());
      String imageName =
          '${DateTime.now().toUtc().toString().replaceAll(RegExp(r'\.\d*Z$'), 'Z').replaceAll(RegExp(r'[:-]|\.\d{3}'), '').split(' ').join('T')}${path.extension(_image!.path)}';
      await storage
          .createFile(
              bucketId: productBucketId,
              fileId: "unique()",
              file: InputFile(path: _image?.path, filename: imageName))
          .then((storageFilePath) {
        product!.imagePath = storageFilePath.$id;
      }).then((value) async {
        final AwsS3Client s3client = AwsS3Client(
            region: userCartController.wasabiAws.value.region.toString(),
            host: "s3.wasabisys.com",
            bucketId: "storage-viewduct",
            accessKey: userCartController.wasabiAws.value.accessKey.toString(),
            secretKey: userCartController.wasabiAws.value.secretKey.toString());
        var uplodedVideoPath = await s3client
            .buildSignedGetParams(
                key:
                    '${DateTime.now().toUtc().toString().replaceAll(RegExp(r'\.\d*Z$'), 'Z').replaceAll(RegExp(r'[:-]|\.\d{3}'), '').split(' ').join('T')}${path.extension(_video!.path)}')
            .uri;
        final minio = Minio(
            endPoint: 's3.wasabisys.com',
            accessKey: userCartController.wasabiAws.value.accessKey.toString(),
            secretKey: userCartController.wasabiAws.value.secretKey.toString(),
            region: 'us-east-1');

        await minio.fPutObject(
            'storage-viewduct',
            '${DateTime.now().toUtc().toString().replaceAll(RegExp(r'\.\d*Z$'), 'Z').replaceAll(RegExp(r'[:-]|\.\d{3}'), '').split(' ').join('T')}${path.extension(_video!.path)}',
            _video!.path);
        product!.videoPath = uplodedVideoPath.toString();
        product.duration = _duration?.inSeconds.toString();
        product.stockQuantity = int.parse(_stockQauntity!.text.toString());
        if (salePrice?.text != '0') {
          product.salePrice = int.parse(finalSalesPrice!.value);
          product.sellersSalesPrice = int.parse(salePrice!.text.toString());
        }

        product.selllingPrice = _sellingPrice!.text.toString();
        product.price = totalPrice!.value;
        product.duration = _duration?.inSeconds.toString();
        ;
        if (widget.error == true) {
          product.activeState = 'active';
        }

        /// If type of tweet is new tweet

        await feedState.updateProDuctItems(product, key: product.key);
        await EasyLoading.dismiss();
        Navigator.of(context).pop();
      });
    } else if (_video != null) {
      final AwsS3Client s3client = AwsS3Client(
          region: userCartController.wasabiAws.value.region.toString(),
          host: "s3.wasabisys.com",
          bucketId: "storage-viewduct",
          accessKey: userCartController.wasabiAws.value.accessKey.toString(),
          secretKey: userCartController.wasabiAws.value.secretKey.toString());
      var uplodedVideoPath = await s3client
          .buildSignedGetParams(
              key:
                  '${DateTime.now().toUtc().toString().replaceAll(RegExp(r'\.\d*Z$'), 'Z').replaceAll(RegExp(r'[:-]|\.\d{3}'), '').split(' ').join('T')}${path.extension(_video!.path)}')
          .uri;
      final minio = Minio(
          endPoint: 's3.wasabisys.com',
          accessKey: userCartController.wasabiAws.value.accessKey.toString(),
          secretKey: userCartController.wasabiAws.value.secretKey.toString(),
          region: 'us-east-1');

      await minio.fPutObject(
          'storage-viewduct',
          '${DateTime.now().toUtc().toString().replaceAll(RegExp(r'\.\d*Z$'), 'Z').replaceAll(RegExp(r'[:-]|\.\d{3}'), '').split(' ').join('T')}${path.extension(_video!.path)}',
          _video!.path);
      product!.videoPath = uplodedVideoPath.toString();
      product.duration = _duration?.inSeconds.toString();
      product.stockQuantity = int.parse(_stockQauntity!.text.toString());
      if (widget.error == true) {
        product.activeState = 'active';
      }
      if (salePrice?.text != '0') {
        product.salePrice =
            double.parse(finalSalesPrice!.value.toString()).toInt();
        product.sellersSalesPrice =
            double.parse(salePrice!.text.toString()).toInt();
      }

      product.selllingPrice = _sellingPrice!.text.toString();
      product.price = totalPrice!.value;
      product.duration = _duration?.inSeconds.toString();
      ;

      /// If type of tweet is new tweet

      feedState.updateProDuctItems(product, key: product.key);
      await EasyLoading.dismiss();
      Navigator.of(context).pop();
    } else if (_image != null) {
      kScreenloader.showLoader(context);
      Storage storage = Storage(clientConnect());
      String imageName =
          '${DateTime.now().toUtc().toString().replaceAll(RegExp(r'\.\d*Z$'), 'Z').replaceAll(RegExp(r'[:-]|\.\d{3}'), '').split(' ').join('T')}${path.extension(_image!.path)}';
      await storage
          .createFile(
              bucketId: productBucketId,
              fileId: "unique()",
              file: InputFile(path: _image?.path, filename: imageName))
          .then((storageFilePath) {
        widget.product!.imagePath = storageFilePath.$id;
      }).then((value) async {
        product!.stockQuantity = int.parse(_stockQauntity!.text.toString());
        if (widget.error == true) {
          product.activeState = 'active';
        }
        if (salePrice?.text != '0') {
          product.salePrice =
              double.parse(finalSalesPrice!.value.toString()).toInt();
          product.sellersSalesPrice =
              double.parse(salePrice!.text.toString()).toInt();
        }

        product.selllingPrice = _sellingPrice!.text.toString();
        product.price = totalPrice!.value;
        product.duration = _duration?.inSeconds.toString();
        ;
        feedState.updateProDuctItems(product, key: product.key);

        await EasyLoading.dismiss();
        Navigator.of(context).pop();
      });
    } else {
      product!.stockQuantity = int.parse(_stockQauntity!.text.toString());
      if (widget.error == true) {
        product.activeState = 'active';
      }
      if (salePrice?.text != '0') {
        product.salePrice =
            double.parse(finalSalesPrice!.value.toString()).toInt();
        product.sellersSalesPrice =
            double.parse(salePrice!.text.toString()).toInt();
      }

      product.selllingPrice = _sellingPrice!.text.toString();
      product.price = totalPrice!.value;

      ;
      feedState.updateProDuctItems(product, key: product.key);
      await EasyLoading.dismiss();
      Navigator.of(context).pop();
    }

    //var state = Provider.of<AuthState>(context, listen: false);
  }

  void uploadImage() {
    openImagePicker(context, (file) {
      setState(() {
        _image = file;
      });
    });
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
            child: frostedTeal(
              Container(
                height: fullWidth(context) * 0.4,
                width: fullWidth(context),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: SafeArea(
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child: Column(
                          children: [
                            ModalTile(
                              title: "File Exceeds Limit",
                              subtitle: "Please reduce your file size",
                              icon: Icons.tab,
                              onTap: () async {
                                Navigator.maybePop(context);
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.maybePop(context);
                                },
                                child: Container(
                                    padding: const EdgeInsets.all(0),
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.yellow),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: customTitleText('Ok'),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  RxString? totalPrice;
  RxString? finalSalesPrice;
  @override
  Widget build(BuildContext context) {
    Storage storage = Storage(clientConnect());
    totalPrice = ((double.tryParse(_sellingPrice!.text) ?? 0.0) +
            ((feedState.categoryModel!
                        .firstWhere(
                            (data) => data.section == widget.product!.section,
                            orElse: () => CategoryModel())
                        .categoryCommission ??
                    0.08) *
                (double.tryParse(_sellingPrice!.text) ?? 0.0)) +
            widget.product!.commissionPrice!.toDouble())
        .toString()
        .obs;
    finalSalesPrice = ((double.tryParse(salePrice!.text) ?? 0.0) +
            (feedState.categoryModel!
                    .firstWhere(
                        (data) => data.section == widget.product!.section,
                        orElse: () => CategoryModel())
                    .categoryCommission
                    ?.toDouble() ??
                0.0 * (double.tryParse(salePrice!.text) ?? 0.0)) +
            widget.product!.commissionPrice!.toDouble())
        .toString()
        .obs;
    cprint("${finalSalesPrice} sales price");
    // var authState = Provider.of<AuthState>(context, listen: false);
    return Scaffold(
      key: _scaffoldKey,
      //  backgroundColor: TwitterColor.mystic,
      // appBar: AppBar(

      //   iconTheme: IconThemeData(color: Colors.blue),
      //   title: customTitleText('Profile Edit'),
      //   actions: <Widget>[
      //     InkWell(
      //       onTap: _submitButton,
      //       child: Center(
      //         child: Text(
      //           'Save',
      //           style: TextStyle(
      //             color: Colors.blue,
      //             fontSize: 17,
      //             fontWeight: FontWeight.bold,
      //           ),
      //         ),
      //       ),
      //     ),
      //     SizedBox(width: 20),
      //   ],
      // ),
      body: Stack(
        children: [
          frostedYellow(
            Container(
              height: fullHeight(context),
              width: fullWidth(context),
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(100),
                //color: Colors.blueGrey[50]
                gradient: LinearGradient(
                  colors: [
                    Colors.yellowAccent[100]!.withOpacity(0.3),
                    Colors.yellowAccent[200]!.withOpacity(0.1),
                    Colors.yellowAccent[100]!.withOpacity(0.2)
                    // Color(0xfffbfbfb),
                    // Color(0xfff7f7f7),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                widget.error == true
                    ? Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      offset: const Offset(0, 11),
                                      blurRadius: 11,
                                      color: Colors.black.withOpacity(0.06))
                                ],
                                borderRadius: BorderRadius.circular(5),
                                color: CupertinoColors.lightBackgroundGray),
                            padding: const EdgeInsets.all(5.0),
                            child: TitleText(
                              widget.product!.erroMessage.toString(),
                              color: CupertinoColors.systemRed,
                            )),
                      )
                    : Container(),
                // Stack(
                //   children: <Widget>[
                //     Align(
                //       alignment: Alignment.bottomLeft,
                //       child: _userImage(),
                //     ),
                //   ],
                // ),
                Stack(
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
                              child: _video != null
                                  ? Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: Colors.grey.withOpacity(.3),
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.4,
                                      child: Stack(
                                        children: [
                                          VideoUploadAdmin(
                                            videoFile: File(_video!.path),
                                            videoPath: _video!.path,
                                          ),
                                        ],
                                      ),
                                    )
                                  : Stack(
                                      children: [
                                        VideoUploadAdmin(
                                          isOnline: true,
                                          videoPath: widget.product!.videoPath,
                                        ),
                                      ],
                                    ),
                            ),
                            _image != null
                                ? Positioned(
                                    right: 0,
                                    top: 0,
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundImage: FileImage(_image!),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.black38,
                                        ),
                                        child: Center(
                                          child: IconButton(
                                            onPressed: uploadImage,
                                            icon: const Icon(Icons.camera_alt,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      width: Get.height * 0.1,
                                      height: Get.height * 0.1,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 5),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Stack(
                                        children: [
                                          FutureBuilder(
                                            future: storage.getFileView(
                                              bucketId: productBucketId,
                                              fileId: widget.product!.imagePath
                                                  .toString(),
                                            ), //works for both public file and private file, for private files you need to be logged in
                                            builder: (context, snapshot) {
                                              return snapshot.hasData &&
                                                      snapshot.data != null
                                                  ? Image.memory(
                                                      snapshot.data
                                                          as Uint8List,
                                                      width: Get.height * 0.3,
                                                      height: Get.height * 0.4,
                                                      fit: BoxFit.contain)
                                                  : Center(
                                                      child: SizedBox(
                                                      width: Get.height * 0.2,
                                                      height: Get.height * 0.2,
                                                      child: LoadingIndicator(
                                                          indicatorType: Indicator
                                                              .ballTrianglePath,

                                                          /// Required, The loading type of the widget
                                                          colors: const [
                                                            Colors.pink,
                                                            Colors.green,
                                                            Colors.blue
                                                          ],

                                                          /// Optional, The color collections
                                                          strokeWidth: 0.5,

                                                          /// Optional, The stroke of the line, only applicable to widget which contains line
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,

                                                          /// Optional, Background of the widget
                                                          pathBackgroundColor:
                                                              Colors.blue

                                                          /// Optional, the stroke backgroundColor
                                                          ),
                                                    )
                                                      //  CircularProgressIndicator
                                                      //     .adaptive()
                                                      );
                                            },
                                          ),
                                          Container(
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.black38,
                                            ),
                                            child: Center(
                                              child: IconButton(
                                                onPressed: uploadImage,
                                                icon: const Icon(
                                                    Icons.camera_alt,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Row(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black38,
                            ),
                            child: Center(
                              child: IconButton(
                                onPressed: () async {
                                  XTypeGroup typeGroup = XTypeGroup(
                                    extensions: <String>['mp4', 'mov'],
                                  );
                                  // Navigator.maybePop(context);
                                  if (Platform.isMacOS || Platform.isWindows) {
                                    final files = await openFile(
                                        acceptedTypeGroups: <XTypeGroup>[
                                          typeGroup
                                        ]);

                                    File file = File(files!.path);
                                    if (file.lengthSync() > 80000000) {
                                      setState(() {
                                        //file = null;
                                        _video = null;
                                      });

                                      _showDialog();
                                    } else {
                                      setState(() {
                                        _video = file;
                                      });

                                      if (_video != null) {
                                        setState(() {
                                          _controller = VideoPlayerController
                                              .file(_video!)
                                            ..initialize().then((value) {
                                              setState(() {
                                                _duration =
                                                    _controller.value.duration;
                                              });
                                            });
                                        });
                                      }
                                    }
                                  } else {
                                    PickedFile? pickedFile =
                                        await (ImagePicker().getVideo(
                                            source: ImageSource.gallery,
                                            maxDuration:
                                                const Duration(seconds: 45)));
                                    File file = File(pickedFile!.path);
                                    cprint('${file.lengthSync()}');
                                    if (file.lengthSync() > 20000000) {
                                      setState(() {
                                        //file = null;
                                        _video = null;
                                      });

                                      _showDialog();
                                    } else {
                                      setState(() {
                                        _video = file;
                                      });

                                      if (_video != null) {
                                        setState(() {
                                          _controller = VideoPlayerController
                                              .file(_video!)
                                            ..initialize().then((value) {
                                              setState(() {
                                                _duration =
                                                    _controller.value.duration;
                                              });
                                            });
                                        });
                                      }
                                    }
                                  }
                                },
                                icon: const Icon(Icons.edit_rounded,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              XTypeGroup typeGroup = XTypeGroup(
                                extensions: <String>['mp4', 'mov'],
                              );
                              // Navigator.maybePop(context);
                              if (Platform.isMacOS || Platform.isWindows) {
                                final files = await openFile(
                                    acceptedTypeGroups: <XTypeGroup>[
                                      typeGroup
                                    ]);

                                File file = File(files!.path);
                                if (file.lengthSync() > 80000000) {
                                  setState(() {
                                    //file = null;
                                    _video = null;
                                  });

                                  _showDialog();
                                } else {
                                  setState(() {
                                    _video = file;
                                  });

                                  if (_video != null) {
                                    setState(() {
                                      _controller =
                                          VideoPlayerController.file(_video!)
                                            ..initialize().then((value) {
                                              setState(() {
                                                _duration =
                                                    _controller.value.duration;
                                              });
                                            });
                                    });
                                  }
                                }
                              } else {
                                PickedFile? pickedFile = await (ImagePicker()
                                    .getVideo(
                                        source: ImageSource.gallery,
                                        maxDuration:
                                            const Duration(seconds: 45)));
                                File file = File(pickedFile!.path);
                                cprint('${file.lengthSync()}');
                                if (file.lengthSync() > 20000000) {
                                  setState(() {
                                    //file = null;
                                    _video = null;
                                  });

                                  _showDialog();
                                } else {
                                  setState(() {
                                    _video = file;
                                  });

                                  if (_video != null) {
                                    setState(() {
                                      _controller =
                                          VideoPlayerController.file(_video!)
                                            ..initialize().then((value) {
                                              setState(() {
                                                _duration =
                                                    _controller.value.duration;
                                              });
                                            });
                                    });
                                  }
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
                                            color:
                                                Colors.black.withOpacity(0.06))
                                      ],
                                      borderRadius: BorderRadius.circular(18),
                                      color: CupertinoColors.systemRed),
                                  padding: const EdgeInsets.all(5.0),
                                  child: TitleText(
                                    'Update Video',
                                    color: CupertinoColors.lightBackgroundGray,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                _entry('Product Name', controller: _name),
                _entry(
                  'Sale Price',
                  controller: salePrice,
                ),
                _entry('Stock Qauntity', controller: _stockQauntity),
                _entry('Selling Price', controller: _sellingPrice),
                salePrice!.text == '0'
                    ? Container()
                    : Padding(
                        padding:
                            const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 4.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
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
                                child: const Text(
                                  'Sales Price',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Obx(
                                () => Row(
                                  children: [
                                    Text(
                                      authState.userModel?.location == 'Nigeria'
                                          ? ' ₦$finalSalesPrice'
                                          : ' £$finalSalesPrice',
                                      style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    ButtonTheme(
                                      height: 45.0,
                                      minWidth: 100.0,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7.0))),
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                            const Color(0xff313134),
                                          ),
                                        ),
                                        onPressed: _submitButton,
                                        child: const Text(
                                          'Update',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 4.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
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
                          child: const Text(
                            'Total Price',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Obx(
                          () => Row(
                            children: [
                              Text(
                                authState.userModel?.location == 'Nigeria'
                                    ? ' ₦$totalPrice'
                                    : ' £$totalPrice',
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600),
                              ),
                              ButtonTheme(
                                height: 45.0,
                                minWidth: 100.0,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7.0))),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                      const Color(0xff313134),
                                    ),
                                  ),
                                  onPressed: _submitButton,
                                  child: const Text(
                                    'Update',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                // _entry('Location', controller: _location),
                // InkWell(
                //   onTap: showCalender,
                //   child: _entry('Date of birth',
                //       isenable: false, controller: _dob),
                // ),
                const SizedBox(height: 10.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

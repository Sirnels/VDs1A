// ignore_for_file: file_names

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_aws_s3_client/flutter_aws_s3_client.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:minio/io.dart';
import 'package:minio/minio.dart';
import 'package:path/path.dart' as path;
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/frosted.dart';

class EditProfilePage extends StatefulWidget {
  final RxList<ViewductsUser>? profileData;
  final String? profileId;
  EditProfilePage({Key? key, this.profileId, this.profileData})
      : super(
          key: key,
        );
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _image;
  TextEditingController? _name;
  TextEditingController? _bio;
  TextEditingController? _location;
  TextEditingController? _dob;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? dob;
  @override
  void initState() {
    _name = TextEditingController();
    _bio = TextEditingController();
    _location = TextEditingController();
    _dob = TextEditingController();
    //var state = Provider.of<AuthState>(context, listen: false);
    _name!.text = widget.profileData!
        .firstWhere((data) => data.key == widget.profileId,
            orElse: () => chatState.chatUser!)
        .displayName!;
    _bio!.text = widget.profileData!
        .firstWhere((data) => data.key == widget.profileId,
            orElse: () => chatState.chatUser!)
        .bio!;
    _location!.text = widget.profileData!
        .firstWhere((data) => data.key == widget.profileId,
            orElse: () => chatState.chatUser!)
        .location!;
    //_dob!.text = getdob('${authState.userModel?.dob}');
    super.initState();
  }

  @override
  void dispose() {
    _name!.dispose();
    _bio!.dispose();
    _location!.dispose();
    _dob!.dispose();
    super.dispose();
  }

  Widget _userImage() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      height: 90,
      width: 90,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 5),
        shape: BoxShape.circle,
        image: DecorationImage(
            image: customAdvanceNetworkImage(authState.userModel!.profilePic),
            fit: BoxFit.cover),
      ),
      child: CircleAvatar(
        radius: 40,
        backgroundImage: _image != null
            ? FileImage(_image!)
            : customAdvanceNetworkImage(authState.userModel!.profilePic),
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black38,
          ),
          child: Center(
            child: IconButton(
              onPressed: uploadImage,
              icon: const Icon(Icons.camera_alt, color: Colors.white),
            ),
          ),
        ),
      ),
    );
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
    final storage = FlutterSecureStorage();
    if (_name!.text.length > 27) {
      customSnackBar(_scaffoldKey, 'Name length cannot exceed 27 character');
      return;
    }
    if (_image != null) {
      final AwsS3Client s3client = AwsS3Client(
          region: userCartController.wasabiAws.value.region.toString(),
          host: userCartController.wasabiAws.value.endPoint.toString(),
          bucketId: userCartController.wasabiAws.value.buckedId.toString(),
          accessKey: userCartController.wasabiAws.value.accessKey.toString(),
          secretKey: userCartController.wasabiAws.value.secretKey.toString());
      var uplodedImagePath = await s3client
          .buildSignedGetParams(
              key:
                  '${DateTime.now().toUtc().toString().replaceAll(RegExp(r'\.\d*Z$'), 'Z').replaceAll(RegExp(r'[:-]|\.\d{3}'), '').split(' ').join('T')}${path.extension(_image!.path)}')
          .uri;
      final minio = Minio(
          endPoint: userCartController.wasabiAws.value.endPoint.toString(),
          accessKey: userCartController.wasabiAws.value.accessKey.toString(),
          secretKey: userCartController.wasabiAws.value.secretKey.toString(),
          region: userCartController.wasabiAws.value.region.toString());
      authState.userModel!.profilePic = uplodedImagePath.toString();
      await minio
          .fPutObject(
              userCartController.wasabiAws.value.buckedId.toString(),
              '${DateTime.now().toUtc().toString().replaceAll(RegExp(r'\.\d*Z$'), 'Z').replaceAll(RegExp(r'[:-]|\.\d{3}'), '').split(' ').join('T')}${path.extension(_image!.path)}',
              _image!.path)

          //       ;
          // await storage
          //     .createFile(
          //         bucketId: productBucketId,
          //         fileId: "unique()",
          //         permissions: [Permission.read(Role.users())],
          //         // read: [
          //         //   'role:member',
          //         // ],
          //         file: InputFile(path: _image?.path))
          //     .then((storageFilePath) {
          //   authState.userModel!.userProfilePic = storageFilePath.$id;
          // })
          .then((value) async {
        var model = authState.userModel!.copyWith(
          key: authState.userModel!.userId,
          displayName: authState.userModel!.displayName,
          bio: authState.userModel!.bio,
          contact: authState.userModel!.contact,
          userProfilePic: authState.userModel!.userProfilePic,
          dob: authState.userModel!.dob,
          email: authState.userModel!.email,
          location: authState.userModel!.location,
          profilePic: authState.userModel!.profilePic,
          userId: authState.userModel!.userId,
        );
        if (_name!.text.isNotEmpty) {
          model.displayName = _name!.text;
        }
        if (_bio!.text.isNotEmpty) {
          model.bio = _bio!.text;
        }
        if (_location!.text.isNotEmpty) {
          model.location = _location!.text;
        }
        if (dob != null) {
          model.dob = dob;
        }
        authState.updateUserProfile(model, image: _image);
        final profileData = json.encode(model);
        storage.write(key: 'profile', value: profileData);
        await EasyLoading.dismiss();
        Navigator.of(context).pop();
      });
    } else {
      var model = authState.userModel!.copyWith(
        key: authState.userModel!.userId,
        displayName: authState.userModel!.displayName,
        bio: authState.userModel!.bio,
        contact: authState.userModel!.contact,
        userProfilePic: authState.userModel!.userProfilePic,
        dob: authState.userModel!.dob,
        email: authState.userModel!.email,
        location: authState.userModel!.location,
        profilePic: authState.userModel!.profilePic,
        userId: authState.userModel!.userId,
      );
      if (_name!.text.isNotEmpty) {
        model.displayName = _name!.text;
      }
      if (_bio!.text.isNotEmpty) {
        model.bio = _bio!.text;
      }
      if (_location!.text.isNotEmpty) {
        model.location = _location!.text;
      }
      if (dob != null) {
        model.dob = dob;
      }

      await authState.updateUserProfile(model, image: _image);
      final profileData = json.encode(model);
      storage.write(key: 'profile', value: profileData);
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

  @override
  Widget build(BuildContext context) {
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
                    Colors.red[100]!.withOpacity(0.3),
                    Colors.green[200]!.withOpacity(0.1),
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
          Positioned(
            top: -160,
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
          Positioned(
            bottom: -200,
            right: -60,
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
          SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: _userImage(),
                    ),
                  ],
                ),
                _entry('Display Name', controller: _name),
                _entry('Bio', controller: _bio, maxLine: null),
                // _entry('Location', controller: _location),
                // InkWell(
                //   onTap: showCalender,
                //   child: _entry('Date of birth',
                //       isenable: false, controller: _dob),
                // ),
                const SizedBox(height: 10.0),
                ButtonTheme(
                  height: 45.0,
                  minWidth: 100.0,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(7.0))),
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
          ),
        ],
      ),
    );
  }
}

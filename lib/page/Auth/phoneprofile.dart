import 'dart:convert';
import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aws_s3_client/flutter_aws_s3_client.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:minio/io.dart';
import 'package:minio/minio.dart';
import 'package:path/path.dart' as path;
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/page/Auth/forgetPasswordPage.dart';
import 'package:viewducts/page/homePage.dart';
import 'package:viewducts/page/message/local_database.dart';
import 'package:viewducts/state/authState.dart';
import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/customWidgets.dart';

import 'package:viewducts/widgets/frosted.dart';
import 'package:viewducts/widgets/newWidget/customLoader.dart';
import 'package:viewducts/widgets/newWidget/title_text.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// ignore: must_be_immutable
class PhoneProfile extends StatelessWidget {
  final VoidCallback? loginCallback;

  PhoneProfile({Key? key, this.loginCallback}) : super(key: key);

  CustomLoader loader = CustomLoader();
  final storage = const FlutterSecureStorage();
  File? _image;
  void uploadImage() {
    openImagePicker(Get.context!, (file) {
      _image = file;
    });
  }

  Widget _body(BuildContext context) {
    var appSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: frostedYellow(
        Center(
          child: Container(
            height: appSize.height,
            width: context.responsiveValue(
                mobile: Get.height * 0.9,
                tablet: Get.height * 0.9,
                desktop: Get.height * 0.9),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 100),
            child: frostedBlueGray(
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      height: Get.height * 0.25,
                      width: Get.height * 0.25,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 5),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: customAdvanceNetworkImage(
                                authState.userModel!.profilePic),
                            fit: BoxFit.cover),
                      ),
                      child: CircleAvatar(
                        radius: Get.height * 0.3,
                        backgroundImage: _image != null
                            ? FileImage(_image!)
                            : customAdvanceNetworkImage(
                                authState.userModel!.profilePic),
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
                    ),
                    _entryFeild('display Name',
                        controller: authState.displayName, isPassword: false),
                    _entryFeild('Your State in your Country ',
                        controller: authState.state, isPassword: false),
                    _entryFeild('Enter email',
                        controller: authState.emailController),
                    _entryFeild(
                        authState.userModel?.secret == true
                            ? "Enter Your Old secret key"
                            : 'Enter Your New secret key',
                        controller: authState.passwordController,
                        isPassword: false),
                    _emailLoginButton(context),
                    const SizedBox(height: 5),
                    // _labelButton('Forget password?', onPressed: () {
                    //   Get.to(() => const ForgetPasswordPage());
                    //   // Navigator.of(context).pushNamed('/ForgetPasswordPage');
                    // }),
                    const Divider(
                      height: 20,
                    ),
                    // Wrap(
                    //   alignment: WrapAlignment.center,
                    //   crossAxisAlignment: WrapCrossAlignment.center,
                    //   children: <Widget>[
                    //     Text(
                    //       'Don\'t have an account?',
                    //       style: TextStyle(
                    //         fontSize: context.responsiveValue(
                    //             mobile: Get.height * 0.02,
                    //             tablet: Get.height * 0.02,
                    //             desktop: Get.height * 0.02),
                    //         fontWeight: FontWeight.w300,
                    //       ),
                    //     ),
                    //     InkWell(
                    //       onTap: () {
                    //         Get.to(
                    //             () => SignUpPageResponsiveView(
                    //                 loginCallback: authState.getCurrentUser),
                    //             transition: Transition.downToUp);
                    //       },
                    //       child: Padding(
                    //         padding: EdgeInsets.symmetric(
                    //             horizontal: 2, vertical: 10),
                    //         child: TitleText(
                    //           ' SignUp',
                    //           fontSize: context.responsiveValue(
                    //               mobile: Get.height * 0.02,
                    //               tablet: Get.height * 0.02,
                    //               desktop: Get.height * 0.02),
                    //           color: TwitterColor.dodgetBlue,
                    //           fontWeight: FontWeight.w300,
                    //         ),
                    //       ),
                    //     )
                    //   ],
                    // ),
                    // const SizedBox(
                    //   height: 2,
                    // ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _entryFeild(String hint,
      {TextEditingController? controller, bool isPassword = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
        ),
        obscureText: isPassword,
        decoration: InputDecoration(
            hintText: hint,
            border: InputBorder.none,
            focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                borderSide: BorderSide(color: Colors.blue)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 10)),
      ),
    );
  }

  Widget _emailLoginButton(BuildContext context) {
    return frostedOrange(
      GestureDetector(
        onTap: _emailLogin,
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
            child: TitleText('Countinue', color: Colors.blueGrey[500])),
      ),
    );
  }

  update() async {
    FToast().init(Get.context!);
    if (authState.userModel!.email != null &&
        authState.emailController!.text != authState.userModel!.email) {
      return FToast().showToast(
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
                  'The Email is not associated with this Account',
                  style: TextStyle(
                      color: CupertinoColors.darkBackgroundGray,
                      fontWeight: FontWeight.w900),
                )),
          ),
          gravity: ToastGravity.BOTTOM_RIGHT,
          toastDuration: Duration(seconds: 5));
    }
    EasyLoading.show(status: 'ViewDucting', dismissOnTap: true);
    final storage = FlutterSecureStorage();
    await SQLHelper.db();
    final database = Databases(
      clientConnect(),
    );
    final Account account = Account(clientConnect());
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

    final userName = await getUserName(
        id: authState.appUser!.$id, name: authState.displayName!.text);
    await firebaseAuth
        .createUserWithEmailAndPassword(
      email: authState.emailController!.text,
      password: authState.passwordController!.text,
    )
        .then((data) async {
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
          await account.updateName(name: authState.displayName!.text);
          await account.updatePrefs(prefs: {
            "name": authState.displayName!.text,
            "email": authState.emailController!.text,
            "newDevice": false
          });

          String? fcmToken;
          await _firebaseMessaging.getToken().then((String? token) async {
            assert(token != null);
            fcmToken = token;
          });
          authState.userModel ==
              authState.userModel!.copyWith(
                  email: authState.emailController!.text,
                  displayName: authState.displayName!.text,
                  profilePic: model.profilePic,
                  userName: userName,
                  fcmToken: fcmToken,
                  state: authState.state!.text,
                  newDevice: false);
          await database.updateDocument(
              databaseId: databaseId,
              collectionId: profileUserColl,
              documentId: authState.appUser!.$id,
              data: {
                "email": authState.emailController!.text,
                "displayName": authState.displayName!.text,
                "profilePic": model.profilePic,
                "userName": userName,
                "fcmToken": fcmToken,
                "state": authState.state!.text,
                "newDevice": false,
                "secret": true,
              },
              permissions: [
                Permission.read(Role.users())
              ]);
          final doc = await database.getDocument(
              databaseId: databaseId,
              collectionId: profileUserColl,
              documentId: '${authState.appUser?.$id}');
          ViewductsUser.fromJson(doc.data);
          authState.userModel == ViewductsUser.fromJson(doc.data);
          final profileData = json.encode(authState.userModel);
          storage.write(key: 'profile', value: profileData);
          // await account
          //     .createVerification(url: 'www.viewducts.com')
          //     .then((value) {
          //   FToast().showToast(
          //       child: Padding(
          //         padding: const EdgeInsets.all(5.0),
          //         child: Container(
          //             // width:
          //             //    Get.width * 0.3,
          //             decoration: BoxDecoration(
          //                 boxShadow: [
          //                   BoxShadow(
          //                       offset: const Offset(0, 11),
          //                       blurRadius: 11,
          //                       color: Colors.black.withOpacity(0.06))
          //                 ],
          //                 borderRadius: BorderRadius.circular(18),
          //                 color: CupertinoColors.activeOrange),
          //             padding: const EdgeInsets.all(5.0),
          //             child: Text(
          //               'link sent to your mail for verification',
          //               style: TextStyle(
          //                   color: CupertinoColors.darkBackgroundGray,
          //                   fontWeight: FontWeight.w900),
          //             )),
          //       ),
          //       gravity: ToastGravity.TOP_LEFT,
          //       toastDuration: Duration(seconds: 3));
          // });
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
        String? fcmToken;
        await _firebaseMessaging.getToken().then((String? token) async {
          assert(token != null);
          fcmToken = token;
        });
        await account.updateName(name: authState.displayName!.text);
        await account.updatePrefs(prefs: {
          "name": authState.displayName!.text,
          "email": authState.emailController!.text,
          "newDevice": false
        });
        authState.userModel ==
            authState.userModel!.copyWith(
                email: authState.emailController!.text,
                displayName: authState.displayName!.text,
                profilePic: model.profilePic,
                userName: userName,
                fcmToken: fcmToken,
                state: authState.state!.text,
                newDevice: false);
        await database.updateDocument(
            databaseId: databaseId,
            collectionId: profileUserColl,
            documentId: authState.appUser!.$id,
            data: {
              "email": authState.emailController!.text,
              "displayName": authState.displayName!.text,
              "profilePic": model.profilePic,
              "userName": userName,
              "fcmToken": fcmToken,
              "state": authState.state!.text,
              "newDevice": false,
              "secret": true,
            },
            permissions: [
              Permission.read(Role.users())
            ]);
        final doc = await database.getDocument(
            databaseId: databaseId,
            collectionId: profileUserColl,
            documentId: '${authState.appUser?.$id}');
        ViewductsUser.fromJson(doc.data);
        authState.userModel == ViewductsUser.fromJson(doc.data);
        final profileData = json.encode(authState.userModel);
        storage.write(key: 'profile', value: profileData);
        // await account
        //     .createVerification(url: 'www.viewducts.com')
        //     .then((value) {
        //   FToast().showToast(
        //       child: Padding(
        //         padding: const EdgeInsets.all(5.0),
        //         child: Container(
        //             // width:
        //             //    Get.width * 0.3,
        //             decoration: BoxDecoration(
        //                 boxShadow: [
        //                   BoxShadow(
        //                       offset: const Offset(0, 11),
        //                       blurRadius: 11,
        //                       color: Colors.black.withOpacity(0.06))
        //                 ],
        //                 borderRadius: BorderRadius.circular(18),
        //                 color: CupertinoColors.activeOrange),
        //             padding: const EdgeInsets.all(5.0),
        //             child: Text(
        //               'link sent to your mail for verification',
        //               style: TextStyle(
        //                   color: CupertinoColors.darkBackgroundGray,
        //                   fontWeight: FontWeight.w900),
        //             )),
        //       ),
        //       gravity: ToastGravity.TOP_LEFT,
        //       toastDuration: Duration(seconds: 3));
        // });
      }
      await EasyLoading.dismiss();
      Get.offAll(
        () => HomePage(),
      );
    }).onError((error, stackTrace) async {
      await firebaseAuth
          .signInWithEmailAndPassword(
        email: authState.emailController!.text,
        password: authState.passwordController!.text,
      )
          .then((value) async {
        if (_image != null) {
          final AwsS3Client s3client = AwsS3Client(
              region: userCartController.wasabiAws.value.region.toString(),
              host: userCartController.wasabiAws.value.endPoint.toString(),
              bucketId: userCartController.wasabiAws.value.buckedId.toString(),
              accessKey:
                  userCartController.wasabiAws.value.accessKey.toString(),
              secretKey:
                  userCartController.wasabiAws.value.secretKey.toString());
          var uplodedImagePath = await s3client
              .buildSignedGetParams(
                  key:
                      '${DateTime.now().toUtc().toString().replaceAll(RegExp(r'\.\d*Z$'), 'Z').replaceAll(RegExp(r'[:-]|\.\d{3}'), '').split(' ').join('T')}${path.extension(_image!.path)}')
              .uri;
          final minio = Minio(
              endPoint: userCartController.wasabiAws.value.endPoint.toString(),
              accessKey:
                  userCartController.wasabiAws.value.accessKey.toString(),
              secretKey:
                  userCartController.wasabiAws.value.secretKey.toString(),
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
            String? fcmToken;
            await _firebaseMessaging.getToken().then((String? token) async {
              assert(token != null);
              fcmToken = token;
            });
            await account.updateName(name: authState.displayName!.text);
            await account.updatePrefs(prefs: {
              "name": authState.displayName!.text,
              "email": authState.emailController!.text,
              "newDevice": false
            });
            authState.userModel ==
                authState.userModel!.copyWith(
                    email: authState.emailController!.text,
                    displayName: authState.displayName!.text,
                    profilePic: model.profilePic,
                    userName: userName,
                    fcmToken: fcmToken,
                    state: authState.state!.text,
                    newDevice: false);
            await database.updateDocument(
                databaseId: databaseId,
                collectionId: profileUserColl,
                documentId: authState.appUser!.$id,
                data: {
                  "email": authState.emailController!.text,
                  "displayName": authState.displayName!.text,
                  "profilePic": model.profilePic,
                  "userName": userName,
                  "fcmToken": fcmToken,
                  "state": authState.state!.text,
                  "newDevice": false,
                  "secret": true,
                },
                permissions: [
                  Permission.read(Role.users())
                ]);
            final doc = await database.getDocument(
                databaseId: databaseId,
                collectionId: profileUserColl,
                documentId: '${authState.appUser?.$id}');
            ViewductsUser.fromJson(doc.data);
            authState.userModel == ViewductsUser.fromJson(doc.data);
            await account
                .createVerification(url: 'www.viewducts.com')
                .then((value) {
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
                            color: CupertinoColors.activeOrange),
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          'link sent to your mail for verification',
                          style: TextStyle(
                              color: CupertinoColors.darkBackgroundGray,
                              fontWeight: FontWeight.w900),
                        )),
                  ),
                  gravity: ToastGravity.TOP_LEFT,
                  toastDuration: Duration(seconds: 3));
            });
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
          String? fcmToken;
          await _firebaseMessaging.getToken().then((String? token) async {
            assert(token != null);
            fcmToken = token;
          });
          await account.updateName(name: authState.displayName!.text);
          await account.updatePrefs(prefs: {
            "name": authState.displayName!.text,
            "email": authState.emailController!.text,
            "newDevice": false
          });
          authState.userModel ==
              authState.userModel!.copyWith(
                  email: authState.emailController!.text,
                  displayName: authState.displayName!.text,
                  profilePic: model.profilePic,
                  userName: userName,
                  fcmToken: fcmToken,
                  state: authState.state!.text,
                  newDevice: false);
          await database.updateDocument(
              databaseId: databaseId,
              collectionId: profileUserColl,
              documentId: authState.appUser!.$id,
              data: {
                "email": authState.emailController!.text,
                "displayName": authState.displayName!.text,
                "profilePic": model.profilePic,
                "userName": userName,
                "fcmToken": fcmToken,
                "state": authState.state!.text,
                "newDevice": false,
                "secret": true,
              },
              permissions: [
                Permission.read(Role.users())
              ]);
          final doc = await database.getDocument(
              databaseId: databaseId,
              collectionId: profileUserColl,
              documentId: '${authState.appUser?.$id}');

          authState.userModel == ViewductsUser.fromJson(doc.data);
          final profileData = json.encode(authState.userModel);
          storage.write(key: 'profile', value: profileData);
          // await account
          //     .createVerification(url: 'www.viewducts.com')
          //     .then((value) {
          //   FToast().showToast(
          //       child: Padding(
          //         padding: const EdgeInsets.all(5.0),
          //         child: Container(
          //             // width:
          //             //    Get.width * 0.3,
          //             decoration: BoxDecoration(
          //                 boxShadow: [
          //                   BoxShadow(
          //                       offset: const Offset(0, 11),
          //                       blurRadius: 11,
          //                       color: Colors.black.withOpacity(0.06))
          //                 ],
          //                 borderRadius: BorderRadius.circular(18),
          //                 color: CupertinoColors.activeOrange),
          //             padding: const EdgeInsets.all(5.0),
          //             child: Text(
          //               'link sent to your mail for verification',
          //               style: TextStyle(
          //                   color: CupertinoColors.darkBackgroundGray,
          //                   fontWeight: FontWeight.w900),
          //             )),
          //       ),
          //       gravity: ToastGravity.TOP_LEFT,
          //       toastDuration: Duration(seconds: 3));
          // });
        }
        await EasyLoading.dismiss();
        Get.offAll(
          () => HomePage(),
        );
      }).onError((error, stackTrace) {
        cprint("${error}");
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
                    'Wrong secret key!',
                    style: TextStyle(
                        color: CupertinoColors.darkBackgroundGray,
                        fontWeight: FontWeight.w900),
                  )),
            ),
            gravity: ToastGravity.TOP_LEFT,
            toastDuration: Duration(seconds: 3));
        EasyLoading.dismiss();
      });
    });
  }

  _emailLogin() {
    final authState = Get.find<AuthState>();

    if (authState.emailController!.text.isEmpty) {
      Get.snackbar("Email", 'Please enter email',
          snackPosition: SnackPosition.BOTTOM, colorText: Colors.red);
      // customSnackBar(_scaffoldKey, 'Please enter email id');
      return false;
    } else if (authState.passwordController!.text.isEmpty) {
      Get.snackbar("Password", 'Please enter password ',
          snackPosition: SnackPosition.BOTTOM, colorText: Colors.red);
      // customSnackBar(_scaffoldKey, 'Please enter password');
      return false;
    } else if (authState.passwordController!.text.length < 8) {
      Get.snackbar("Password", 'Password must be at least 8 character long',
          snackPosition: SnackPosition.BOTTOM, colorText: Colors.red);
      // customSnackBar(_scaffoldKey, 'Password must me 8 character long');
      return false;
    }

    var status = validateEmal(authState.emailController!.text);
    if (!status) {
      Get.snackbar("Email", 'Please Enter a valid email id ',
          snackPosition: SnackPosition.BOTTOM, colorText: Colors.red);
      // customSnackBar(_scaffoldKey, 'Please enter valid email id');
      return false;
    }
    return update();
  }

  Widget _labelButton(String title, {Function? onPressed}) {
    return TextButton(
      onPressed: () {
        if (onPressed != null) {
          onPressed();
        }
      },
      child: Text(
        title,
        style: const TextStyle(
            color: CupertinoColors.darkBackgroundGray,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      key: _scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            // LoginScreen(),
            _body(context),
            Positioned(
              right: 0,
              top: 0,
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
                child: Center(
                  child: _labelButton('Forget secret key?', onPressed: () {
                    Get.to(() => const ForgetPasswordPage());
                    // Navigator.of(context).pushNamed('/ForgetPasswordPage');
                  }),
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
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
                            borderRadius: BorderRadius.circular(5),
                            color: CupertinoColors.systemOrange),
                        padding: const EdgeInsets.all(5.0),
                        child: TitleText(
                          'Notification Settings',
                          color: CupertinoColors.lightBackgroundGray,
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

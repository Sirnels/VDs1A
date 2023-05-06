import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:viewducts/E2EE/e2ee.dart' as e2ee;
import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viewducts/helper/constant.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/newWidget/title_text.dart';

enum Status { Waiting, Error }

class VerifyNumber extends StatefulWidget {
  const VerifyNumber(
      {Key? key, this.number, this.country, this.code, this.phoneNoCode})
      : super(key: key);
  final number;
  final phoneNoCode;
  final String? country;
  final String? code;
  @override
  _VerifyNumberState createState() => _VerifyNumberState(number);
}

class _VerifyNumberState extends State<VerifyNumber> {
  final phoneNumber;
  var _status = Status.Waiting;
  var _verificationId;
  var _userId;
  var _textEditingController = TextEditingController();
  _VerifyNumberState(this.phoneNumber);
  late SharedPreferences prefs;
  final storage = const FlutterSecureStorage();
  Rx<KeyViewducts> keysView = KeyViewducts().obs;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    viewVerify();
  }

  viewVerify() async {
    await _verifyPhoneNumber();
    await data();
  }

  data() async {
    try {
      final database = Databases(
        clientConnect(),
      );

      await database
          .getDocument(
              databaseId: databaseId,
              collectionId: 'keyViewducts',
              documentId: 'keysViewKeys')
          .then((doc) {
        setState(() {
          keysView.value = KeyViewducts.fromSnapshot(doc.data);
        });
      });
    } on AppwriteException catch (e) {
      cprint('$e signupPage');
    }
  }

  Future _verifyPhoneNumber() async {
    try {
      final account = await Account(clientConnect());
      FToast().init(Get.context!);
      await account
          .createPhoneSession(userId: "unique()", phone: phoneNumber.toString())
          .then((data) {
        setState(() {
          this._verificationId = data.userId;
          this._userId = data.$id;
        });
        if (kDebugMode) {
          cprint(
              'userId:$_verificationId id:$_userId phone:${widget.phoneNoCode} country:${widget.country}');
        }
      }).onError((error, stackTrace) {
        cprint(error, errorIn: 'phone sign up');
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
                    'Check your network',
                    style: TextStyle(
                        color: CupertinoColors.darkBackgroundGray,
                        fontWeight: FontWeight.w900),
                  )),
            ),
            gravity: ToastGravity.TOP_LEFT,
            toastDuration: Duration(seconds: 3));
      });
    } on AppwriteException catch (error) {
      // EasyLoading.dismiss();
      // dismissLoadingWidget();
      cprint(error, errorIn: 'signUp');
      // Get.snackbar("Connection", "${error.type}" 'signUp');
      // return 'Error in signing up';
    }
    //   _auth.verifyPhoneNumber(
    //       phoneNumber: phoneNumber,
    //       verificationCompleted: (phonesAuthCredentials) async {},
    //       verificationFailed: (verificationFailed) async {},
    //       codeSent: (verificationId, resendingToken) async {
    //         setState(() {
    //           this._verificationId = verificationId;
    //         });
    //       },
    //       codeAutoRetrievalTimeout: (verificationId) async {});
  }

  Future _sendCodeToFirebase({String? code}) async {
    if (_verificationId != null) {
      FToast().init(Get.context!);
      final account = await Account(clientConnect());

      await account
          .updatePhoneSession(
              userId: _verificationId.toString(), secret: code.toString())
          .then((data) async {
        authState.appUser = await account.get();
        Random random = Random();
        int randomNumber = random.nextInt(8);

        prefs = await SharedPreferences.getInstance();
        final pair = await const e2ee.X25519().generateKeyPair();
        await storage.write(key: PRIVATE_KEY, value: pair.secretKey.toBase64());
        // await account.updatePrefs(prefs: {
        //   "name": authState.displayName?.text,
        //   "email": authState.emailController?.text,
        //   "newDevice": true
        // });
        ViewductsUser user = ViewductsUser(
          countryCode: widget.code,
          email: '',
          bio: 'I love ViewDucts',
          firstName: 'Your First Name',
          lastName: 'Your Last Name',
          contact: int.parse(widget.phoneNoCode.toString()),
          displayName: '',
          dob: 'Date of Birth',
          location: widget.country,
          newDevice: true,
          secret: false,
          state: '',
          profilePic: dummyProfilePicList[randomNumber],

          //contact: phoneNo,
          publicKey: pair.publicKey.toBase64(),
          // countryCode: phoneCode,
          authenticationType: AuthenticationType.passcode.index,
          isVerified: false,
        );
        await authState
            .phoneAuth(user, keysView.value.viewductKey.toString(),
                scaffoldKey: _scaffoldKey, userId: _userId.toString())
            .then((status) async {
          if (kDebugMode) {
            cprint(status.toString());
          }

          // currentUser = firebaseUser;
        });
        // .whenComplete(
        //   () {
        //     authState.authStatus == AuthStatus.LOGGED_IN.obs;
        //     if (authState.authStatus.value == AuthStatus.LOGGED_IN) {
        //       Get.offAll(
        //         () => HomePage(),
        //       );

        //       // ViewDucts.toast('Welcome to ViewDucts!');
        //       // widget.loginCallback!();
        //       //  Navigator.pop(context);
        //     }
        //   },
        // );
      }).onError((error, stackTrace) {
        if (kDebugMode) {
          cprint('$error');
        }
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
                    'Code Expires!!',
                    style: TextStyle(
                        color: CupertinoColors.darkBackgroundGray,
                        fontWeight: FontWeight.w900),
                  )),
            ),
            gravity: ToastGravity.TOP_LEFT,
            toastDuration: Duration(seconds: 3));
        setState(() {
          this._status = Status.Error;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Container(child: Text("Verify Number")),
          previousPageTitle: "Edit Number",
        ),
        child: _status != Status.Error
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Material(
                            color: Colors.yellow[50],
                            elevation: 20,
                            borderRadius: BorderRadius.circular(100),
                            shadowColor: Colors.yellow[100],
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Image.asset('assets/delicious.png'),
                              radius: context.responsiveValue(
                                  mobile: Get.height * 0.04,
                                  tablet: Get.height * 0.06,
                                  desktop: Get.height * 0.06),
                            ),
                          ),
                          TitleText(
                            'View',
                            color: Colors.blueGrey[100],
                            fontSize: context.responsiveValue(
                                mobile: Get.height * 0.06,
                                tablet: Get.height * 0.08,
                                desktop: Get.height * 0.08),
                          ),
                          TitleText(
                            'Ducts',
                            color: Colors.blueGrey[300],
                            fontSize: context.responsiveValue(
                                mobile: Get.height * 0.06,
                                tablet: Get.height * 0.08,
                                desktop: Get.height * 0.08),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Verify ",
                          style: TextStyle(
                              color: Color(0xFF08C187).withOpacity(0.7),
                              fontSize: 20)),
                      Text("OTP sent to",
                          style: TextStyle(
                              color: CupertinoColors.secondaryLabel,
                              fontSize: 20)),
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
                          child: Text(phoneNumber == null ? "" : phoneNumber)),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: Get.height * 0.5,
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
                      child: TextField(
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(color: Colors.blueGrey
                                //color: UniversalVariables.greyColor,
                                ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50.0),
                                ),
                                borderSide: BorderSide.none),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            filled: true,
                            //fillColor: UniversalVariables.separatorColor,
                          ),
                          onChanged: (value) async {
                            print(value);
                            if (value.length == 6) {
                              //perform the auth verification
                              _sendCodeToFirebase(code: value);
                            }
                          },
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              letterSpacing: 30,
                              fontSize: 30,
                              color: CupertinoColors.black),
                          // maxLength: 6,
                          controller: _textEditingController,
                          keyboardType: TextInputType.number),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Didn't receive the OTP?"),
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
                        padding: const EdgeInsets.all(10.0),
                        child: GestureDetector(
                            child: Text("RESEND OTP"),
                            onTap: () async {
                              setState(() {
                                this._status = Status.Waiting;
                              });
                              _verifyPhoneNumber();
                            }),
                      )
                    ],
                  )
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Text("OTP Verification",
                        style: TextStyle(
                            color: Color(0xFF08C187).withOpacity(0.7),
                            fontSize: 30)),
                  ),
                  Text("The code used is invalid!"),
                  Padding(
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
                          color: CupertinoColors.lightBackgroundGray),
                      child: CupertinoButton(
                          child: Text("Edit Number"),
                          onPressed: () => Navigator.pop(context)),
                    ),
                  ),
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
                    child: CupertinoButton(
                        child: Text("Resend Code"),
                        onPressed: () async {
                          setState(() {
                            this._status = Status.Waiting;
                          });

                          _verifyPhoneNumber();
                        }),
                  ),
                ],
              ),
      ),
    );
  }
}

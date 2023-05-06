import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:viewducts/common/common.dart';
import 'package:viewducts/features/auth/controller/auth_controller.dart';

import 'package:viewducts/helper/theme.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/page/Auth/forgetPasswordPage.dart';
import 'package:viewducts/page/responsiveView.dart';
import 'package:viewducts/widgets/customWidgets.dart';

import 'package:viewducts/widgets/frosted.dart';
import 'package:viewducts/widgets/newWidget/customLoader.dart';
import 'package:viewducts/widgets/newWidget/title_text.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// ignore: must_be_immutable
class SignIn extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => SignUpPageResponsiveView(
            // loginCallback:
            //     getCurrentUser
            ),
      );
  final VoidCallback? loginCallback;
  final bool? phoneAuth;

  SignIn({Key? key, this.loginCallback, this.phoneAuth}) : super(key: key);

  @override
  ConsumerState<SignIn> createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignIn> {
  CustomLoader loader = CustomLoader();

  final storage = const FlutterSecureStorage();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController? emailController = TextEditingController();
  TextEditingController? passwordController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    emailController?.dispose();
    passwordController?.dispose();
  }

  void onLogin() {
    ref.read(authControllerProvider.notifier).login(
          email: emailController!.text,
          password: passwordController!.text,
          context: context,
        );
  }

  Widget _body(BuildContext context) {
    //var appSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Center(
        child: Container(
          //height: appSize.height,
          width: context.responsiveValue(
              mobile: Get.height * 0.8,
              tablet: Get.height * 0.8,
              desktop: Get.height * 0.8),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 100),
          child: frostedBlueGray(
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 50),
                  _entryFeild('Enter email', controller: emailController),
                  _entryFeild('Enter password',
                      controller: passwordController, isPassword: true),
                  _emailLoginButton(context),
                  const SizedBox(height: 5),
                  _labelButton('Forget password?', onPressed: () {
                    Get.to(() => const ForgetPasswordPage());
                    // Navigator.of(context).pushNamed('/ForgetPasswordPage');
                  }),
                  const Divider(
                    height: 30,
                  ),
                  widget.phoneAuth == true
                      ? Container()
                      : Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: <Widget>[
                            Text(
                              'Don\'t have an account?',
                              style: TextStyle(
                                fontSize: context.responsiveValue(
                                    mobile: Get.height * 0.02,
                                    tablet: Get.height * 0.02,
                                    desktop: Get.height * 0.02),
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(context, SignIn.route());

                                // Get.to(
                                //     () => SignUpPageResponsiveView(
                                //         // loginCallback:
                                //         //     getCurrentUser
                                //         ),
                                //     transition: Transition.downToUp);
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 2, vertical: 10),
                                child: TitleText(
                                  ' SignUp',
                                  fontSize: context.responsiveValue(
                                      mobile: Get.height * 0.02,
                                      tablet: Get.height * 0.02,
                                      desktop: Get.height * 0.02),
                                  color: TwitterColor.dodgetBlue,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            )
                          ],
                        ),
                  const SizedBox(
                    height: 2,
                  ),
                  const SizedBox(height: 20),
                ],
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
        //color: Colors.grey.shade200,
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
              const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
    );
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
            color: TwitterColor.dodgetBlue, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _emailLoginButton(BuildContext context) {
    final isloading = ref.watch(authControllerProvider);
    return isloading
        ? TextButton(
            onPressed: () {},
            child: Container(
              height: 30,
              width: 120,
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
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    TitleText('Signing In...'),
                    Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Loader()

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
              ),
            ),
          )
        : Material(
            elevation: 20,
            borderRadius: BorderRadius.circular(50),
            child: frostedOrange(
              SizedBox(
                // width: MediaQuery.of(context).size.width * 0.5,
                // margin: EdgeInsets.symmetric(vertical: 35),
                child: TextButton(
                  onPressed: onLogin,
                  child: TitleText('Submit', color: Colors.blueGrey[500]),
                ),
              ),
            ),
          );
  }

  // _emailLogin() {
  //   // final authState = Get.find<AuthState>();

  //   if (emailController!.text.isEmpty) {
  //     Get.snackbar("Email", 'Please enter email',
  //         snackPosition: SnackPosition.BOTTOM, colorText: Colors.red);
  //     // customSnackBar(_scaffoldKey, 'Please enter email id');
  //     return false;
  //   } else if (passwordController!.text.isEmpty) {
  //     Get.snackbar("Password", 'Please enter password ',
  //         snackPosition: SnackPosition.BOTTOM, colorText: Colors.red);
  //     // customSnackBar(_scaffoldKey, 'Please enter password');
  //     return false;
  //   } else if (passwordController!.text.length < 8) {
  //     Get.snackbar("Password", 'Password must be at least 8 character long',
  //         snackPosition: SnackPosition.BOTTOM, colorText: Colors.red);
  //     // customSnackBar(_scaffoldKey, 'Password must me 8 character long');
  //     return false;
  //   }

  //   var status = validateEmal(emailController!.text);
  //   if (!status) {
  //     Get.snackbar("Email", 'Please Enter a valid email id ',
  //         snackPosition: SnackPosition.BOTTOM, colorText: Colors.red);
  //     // customSnackBar(_scaffoldKey, 'Please enter valid email id');
  //     return false;
  //   }
  //   return onLogin;
  //   // kIsWeb
  //   // ? isWEbSignin(
  //   //     emailController!.text, passwordController!.text,
  //   //     scaffoldKey: _scaffoldKey)
  //   // : signIn(
  //   //     emailController!.text, passwordController!.text,
  //   //     scaffoldKey: _scaffoldKey);
  //   //     .then((status) {
  //   //   emailController!.clear();
  //   //   passwordController!.clear();
  //   // }).whenComplete(() {
  //   //   EasyLoading.dismiss();
  //   //   Get.offAll(
  //   //     () => HomePage(),
  //   //   );
  //   // });
  // }

  @override
  Widget build(BuildContext context) {
    var appSize = MediaQuery.of(context).size;
    return Scaffold(
//      key: _scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            // LoginScreen(),
            _body(context),
            // Positioned(
            //   top: appSize.height * 0.1,
            //   left: appSize.width * 0.45,
            //   child: Row(
            //     children: <Widget>[
            //       Text(
            //         'Sign',
            //         style: TextStyle(
            //           fontSize: 50,
            //           fontWeight: FontWeight.w600,
            //           // color: Colors.blueGrey[200]
            //         ),
            //       ),
            //       Text(
            //         'In',
            //         style: TextStyle(
            //           fontSize: 25,
            //           fontWeight: FontWeight.w600,
            //           // color: Colors.amber[700]
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // Positioned(
            //   top: 10,
            //   left: 1,
            //   child: Row(
            //     children: [
            //       IconButton(
            //         onPressed: () {
            //           Navigator.pop(context);
            //         },
            //         // color: Colors.black,
            //         icon: const Icon(CupertinoIcons.back),
            //       ),
            //       Material(
            //         elevation: 10,
            //         borderRadius: BorderRadius.circular(10),
            //         child: frostedOrange(
            //           Container(
            //             decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(20),
            //                 color: Colors.blueGrey[50],
            //                 gradient: LinearGradient(
            //                   colors: [
            //                     Colors.yellow.withOpacity(0.1),
            //                     Colors.white60.withOpacity(0.2),
            //                     Colors.orange.withOpacity(0.3)
            //                   ],
            //                   // begin: Alignment.topCenter,
            //                   // end: Alignment.bottomCenter,
            //                 )),
            //             child: Row(
            //               children: [
            //                 Material(
            //                   elevation: 10,
            //                   borderRadius: BorderRadius.circular(100),
            //                   child: CircleAvatar(
            //                     radius: 14,
            //                     backgroundColor: Colors.transparent,
            //                     child: Image.asset('assets/delicious.png'),
            //                   ),
            //                 ),
            //                 Padding(
            //                   padding: const EdgeInsets.symmetric(
            //                       horizontal: 8.0, vertical: 3),
            //                   child: customTitleText('ViewDucts'),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

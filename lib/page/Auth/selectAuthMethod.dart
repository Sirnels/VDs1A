// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:viewducts/helper/enum.dart';
import 'package:viewducts/helper/theme.dart';
import 'package:viewducts/page/Auth/signup.dart';
import 'package:viewducts/state/authState.dart';
import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/frosted.dart';
import 'package:viewducts/widgets/newWidget/title_text.dart';
import '../homePage.dart';
import 'signin.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  Widget _submitButton() {
    return Material(
      elevation: 20,
      borderRadius: BorderRadius.circular(100),
      child: SizedBox(
        // margin: EdgeInsets.symmetric(vertical: 15),
        width: Get.width * 0.5,
        child: frostedYellow(
          TextButton(
            // shape:
            //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            // color: TwitterColor.dodgetBlue,
            //color: Colors.blueGrey[100],
            onPressed: () {
              //var state = Provider.of<AuthState>(context, listen: false);

              Get.to(() => Signup(loginCallback: authState.getCurrentUser),
                  transition: Transition.downToUp);
            },
            // padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: TitleText(
              'Start Shopping',
              color: Colors.blueGrey[600],
            ),
          ),
        ),
      ),
    );
  }

  Widget _body() {
    // var appSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Stack(
        children: <Widget>[
          frostedBlueGray(
            Container(
              height: Get.height,
              width: Get.width,
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(100),
                //color: Colors.blueGrey[50]
                gradient: LinearGradient(
                  colors: [
                    Colors.yellow[300]!.withOpacity(0.3),
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
          ),
          Positioned(
            bottom: 0,
            left: Get.height * -0.6,
            child: ClipOval(
              child: frostedPink(
                Container(
                  height: Get.height,
                  width: Get.height,
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(100),
                    //color: Colors.blueGrey[50]
                    gradient: LinearGradient(
                      colors: [
                        Colors.yellow[300]!.withOpacity(0.3),
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
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            right: Get.height * -0.6,
            child: ClipOval(
              child: frostedBlueGray(
                Container(
                  height: Get.width,
                  width: Get.height,
                  decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(100),
                      color: Colors.blueGrey[50]!.withOpacity(0.2)),
                ),
              ),
            ),
          ),
          frostedYellow(
            Container(
              height: Get.height,
              width: Get.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.yellow[100]!.withOpacity(0.3),
                    Colors.yellow[200]!.withOpacity(0.1),
                    Colors.yellowAccent[100]!.withOpacity(0.2)
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
                height: Get.width * 0.8,
                width: Get.width,
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
                height: Get.width * 0.8,
                width: Get.width,
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
                height: Get.width * 0.8,
                width: Get.width,
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
                height: Get.width * 0.8,
                width: Get.width,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/ankkara1.jpg'))),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Container(
                //   width: Get.width - 80,
                //   height: 40,
                //   child: Image.asset('assets/images/icon-480.png'),
                // ),
                const Spacer(),
                // SizedBox(
                //   height: Get.width * 0.5,
                // ),
                Lottie.asset(
                  'assets/lottie/shopping-cart.json',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Material(
                      color: Colors.yellow[50],
                      elevation: 20,
                      borderRadius: BorderRadius.circular(100),
                      shadowColor: Colors.yellow[100],
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        child: Image.asset('assets/delicious.png'),
                      ),
                    ),
                    TitleText(
                      'View',
                      color: Colors.blueGrey[100],
                      fontSize: Get.width * 0.12,
                    ),
                    TitleText(
                      'Ducts',
                      color: Colors.blueGrey[300],
                      fontSize: Get.width * 0.12,
                    ),
                  ],
                ),
                TitleText(
                  'Social, Shop And Get Paid ',
                  //  'Global Market at Your Door Step ',
                  fontSize: 16,
                  color: Colors.blueGrey[700],
                ),
                const SizedBox(
                  height: 16,
                ),
                Material(
                  elevation: 20,
                  borderRadius: BorderRadius.circular(100),
                  child: frostedYellow(
                    _submitButton(),
                  ),
                ),
                const Spacer(),
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    const TitleText(
                      'Have an account already?',
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(
                            () =>
                                SignIn(loginCallback: authState.getCurrentUser),
                            transition: Transition.leftToRightWithFade);
                      },
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                        child: TitleText(
                          ' Log in',
                          fontSize: 14,
                          color: TwitterColor.dodgetBlue,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20)
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = Get.find<AuthState>();
    return Scaffold(
        backgroundColor: TwitterColor.mystic,
        body: Obx(
          () => authState.authStatus == AuthStatus.NOT_LOGGED_IN.obs ||
                  authState.authStatus == AuthStatus.NOT_DETERMINED.obs
              ? _body()
              : HomePage(),
        ));
  }
}

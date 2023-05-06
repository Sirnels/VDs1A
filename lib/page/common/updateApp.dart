// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viewducts/helper/theme.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/page/common/splash.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/newWidget/title_text.dart';

class UpdateApp extends StatefulWidget {
  const UpdateApp({Key? key}) : super(key: key);

  @override
  _UpdateAppState createState() => _UpdateAppState();
}

class _UpdateAppState extends State<UpdateApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const SplashPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SingleChildScrollView(
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
            const TitleText(
              "New Update is available",
              fontSize: 25,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const TitleText(
              "The current version of app is no longer supported. We aploigize for any inconveiience we may have caused you",
              fontSize: 14,
              color: AppColor.darkGrey,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Container(
              width: fullWidth(context),
              margin: const EdgeInsets.symmetric(vertical: 35),
              // ignore: deprecated_member_use
              child: TextButton(
                style: ButtonStyle(
                    //       shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(30)),
                    // color: CupertinoColors.darkBackgroundGray,
//  padding:
//                     const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    ),
                onPressed: () {
                  launchURL(
                      "https://play.google.com/store/apps/details?id=com.viewducts.viewducts");
                },
                child: const TitleText('Update now', color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}

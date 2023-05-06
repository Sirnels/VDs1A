import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viewducts/page/product/market.dart';

class OffLineMessagePage extends StatelessWidget {
  //final String error;
  const OffLineMessagePage({
    super.key,
    //required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              color: darkBackground, borderRadius: BorderRadius.circular(10)),
          width: context.responsiveValue(
              mobile: Get.height * 0.4,
              tablet: Get.height * 0.4,
              desktop: Get.height * 0.4),
          height: context.responsiveValue(
              mobile: Get.height * 0.4,
              tablet: Get.height * 0.4,
              desktop: Get.height * 0.4),
          child: SingleChildScrollView(
              child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                    size: Get.height * 0.2,
                    color: darkAccent,
                    CupertinoIcons.wifi_slash),
                Text('NetWork',
                    style: TextStyle(
                        color: darkAccent,
                        fontSize: context.responsiveValue(
                            mobile: Get.height * 0.04,
                            tablet: Get.height * 0.04,
                            desktop: Get.height * 0.04),
                        fontWeight: FontWeight.w800)),
                Text('You\'re Offline',
                    style: TextStyle(
                        color: darkAccent,
                        fontSize: context.responsiveValue(
                            mobile: Get.height * 0.025,
                            tablet: Get.height * 0.025,
                            desktop: Get.height * 0.025),
                        fontWeight: FontWeight.w100)),
              ],
            ),
          )),
        ),
      ),
    );
  }
}

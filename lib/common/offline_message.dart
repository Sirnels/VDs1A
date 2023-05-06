import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:viewducts/helper/utility.dart';

class OfflineText extends StatelessWidget {
  final String error;
  final errorCode;
  const OfflineText({
    super.key,
    required this.error,
    this.errorCode,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          width: 200,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 11),
                    blurRadius: 11,
                    color:
                        CupertinoColors.lightBackgroundGray.withOpacity(0.06))
              ],
              borderRadius: BorderRadius.circular(5),
              color: CupertinoColors.systemRed),
          padding: const EdgeInsets.all(5.0),
          child: Text(error)),
    );
  }
}

class OfflinePage extends StatelessWidget {
  final String? error;
  const OfflinePage({
    super.key,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

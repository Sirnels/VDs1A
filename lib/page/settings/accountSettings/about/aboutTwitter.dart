// ignore_for_file: file_names

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/page/settings/accountSettings/policy.dart';
import 'package:viewducts/page/settings/widgets/settingsRowWidget.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/frosted.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AboutPage extends HookWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Email email = Email(
      body: 'I want to Enquire about',
      subject: 'Help Station',
      recipients: ['info@viewducts.com'],
      cc: ['info@viewducts.com'],
      bcc: ['info@viewducts.com'],
      isHTML: false,
    );

    Future<bool?> _showDialog() {
      return showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Container(
            // shape: RoundedRectangleBorder(
            //   borderRadius: BorderRadius.circular(20),
            // ),
            // backgroundColor: Colors.transparent,
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: frostedYellow(
                  Container(
                    height: Get.height * 0.2,
                    width: Get.width * 0.7,
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
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
                                      color: CupertinoColors.systemIndigo),
                                  padding: const EdgeInsets.all(5.0),
                                  child: GestureDetector(
                                    onTap: () async {},
                                    child: const Text(
                                      'Help Station Email',
                                      style: TextStyle(
                                          color: CupertinoColors
                                              .lightBackgroundGray,
                                          fontWeight: FontWeight.w200),
                                    ),
                                  )),
                            ),
                            GestureDetector(
                              onTap: () async {
                                cprint('email sent');
                                await FlutterEmailSender.send(email);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              offset: const Offset(0, 11),
                                              blurRadius: 11,
                                              color: Colors.black
                                                  .withOpacity(0.06))
                                        ],
                                        borderRadius: BorderRadius.circular(18),
                                        color: CupertinoColors.white),
                                    padding: const EdgeInsets.all(5.0),
                                    child: const SelectableText(
                                      'Email: info@viewducts.com',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w200),
                                    )),
                              ),
                            ),
                            SizedBox(
                              height: 0.5,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                offset: const Offset(0, 11),
                                                blurRadius: 11,
                                                color: Colors.black
                                                    .withOpacity(0.06))
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          color: CupertinoColors.systemRed),
                                      padding: const EdgeInsets.all(5.0),
                                      child: GestureDetector(
                                        onTap: () async {
                                          Navigator.maybePop(context);
                                        },
                                        child: const Text(
                                          'Cancel ',
                                          style: TextStyle(
                                              color: CupertinoColors
                                                  .lightBackgroundGray,
                                              fontWeight: FontWeight.w200),
                                        ),
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                offset: const Offset(0, 11),
                                                blurRadius: 11,
                                                color: Colors.black
                                                    .withOpacity(0.06))
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          color: CupertinoColors.systemYellow),
                                      padding: const EdgeInsets.all(5.0),
                                      child: GestureDetector(
                                        onTap: () async {
                                          FToast().init(context);
                                          try {
                                            cprint('email sent');
                                            await FlutterEmailSender.send(
                                                email);
                                          } catch (e) {
                                            cprint(e.toString());
                                            FToast().showToast(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Container(
                                                      // width:
                                                      //    Get.width * 0.3,
                                                      decoration: BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                                offset:
                                                                    const Offset(
                                                                        0, 11),
                                                                blurRadius: 11,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.06))
                                                          ],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(18),
                                                          color: CupertinoColors
                                                              .systemRed),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Text(
                                                        'No Email Client',
                                                        style: TextStyle(
                                                            color: CupertinoColors
                                                                .darkBackgroundGray,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w900),
                                                      )),
                                                ),
                                                gravity: ToastGravity.TOP_LEFT,
                                                toastDuration:
                                                    Duration(seconds: 3));
                                          }
                                        },
                                        child: const Text(
                                          'Email Us',
                                          style: TextStyle(
                                              color: CupertinoColors
                                                  .darkBackgroundGray,
                                              fontWeight: FontWeight.w200),
                                        ),
                                      )),
                                ),
                              ],
                            )
                            // authState.appPlayStore
                            //         .where((data) => data.operatingSystem == 'IOS')
                            //         .isNotEmpty
                            //     ?

                            //: Container(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    var appSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ThemeMode.system == ThemeMode.light
                ? frostedYellow(
                    Container(
                      height: appSize.height,
                      width: appSize.width,
                      decoration: BoxDecoration(
                        // borderRadius: BorderRadius.circular(100),
                        //color: Colors.blueGrey[50]
                        gradient: LinearGradient(
                          colors: [
                            Colors.yellow[100]!.withOpacity(0.3),
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
                  )
                : Container(),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(
                color: (Colors.white12).withOpacity(0.1),
              ),
            ),
            Positioned(
              top: appSize.height * 0.08,
              left: 10,
              right: 10,
              child: SizedBox(
                height: appSize.height,
                width: appSize.width,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: <Widget>[
                    Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(10),
                      child: frostedOrange(
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 3),
                              child: customTitleText('Help'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SettingRowWidget(
                      "Help Station",
                      vPadding: 0,
                      showDivider: false,
                      onPressed: () {
                        _showDialog();
                      },
                    ),
                    Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(10),
                      child: frostedOrange(
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 3),
                              child: customTitleText('Legal'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SettingRowWidget("Terms of Service", showDivider: true,
                        onPressed: () {
                      Get.to(() => Policy(
                            mdFileName: 'term_condition',
                            name: "Terms of Service",
                          ));
                      // launchURL("https://www.viewducts.com/terms");
                    }),
                    SettingRowWidget("Privacy policy", showDivider: true,
                        onPressed: () {
                      Get.to(() => Policy(
                            mdFileName: 'privacy_policy',
                            name: "Privacy policy",
                          ));
                      //launchURL("https://www.viewducts.com/privacy");
                    }),
                    SettingRowWidget("EULA policy", showDivider: true,
                        onPressed: () {
                      Get.to(() => Policy(
                            mdFileName: 'eula',
                            name: "EULA policy",
                          ));
                      //launchURL("https://www.viewducts.com/privacy");
                    }),
                    SettingRowWidget("Refund/Return policy", showDivider: true,
                        onPressed: () {
                      Get.to(() => Policy(
                            mdFileName: 'return_refund_policy',
                            name: "Refund/Return policy",
                          ));
                      // launchURL("https://www.viewducts.com/shipping");
                    }),
                    SettingRowWidget("Cookie", showDivider: true,
                        onPressed: () {
                      Get.to(() => Policy(
                            mdFileName: 'cookie_policy',
                            name: "Cookie",
                          ));
                      //launchURL("https://www.viewducts.com/privacy");
                    }),
                    SettingRowWidget("Disclamer", showDivider: true,
                        onPressed: () {
                      Get.to(() => Policy(
                            mdFileName: 'disclaimer',
                            name: "Disclamer",
                          ));
                      //launchURL("https://www.viewducts.com/privacy");
                    }),
                    //  SettingRowWidget(
                    //   "Cookie use",
                    //   showDivider: true,

                    // ),
                    // SettingRowWidget(
                    //   "Legal notices",
                    //   showDivider: true,
                    //   onPressed: () async {
                    //     launchURL("https://www.viewducts.com/legal");
                    //     // showLicensePage(
                    //     //   context: context,
                    //     //   applicationName: 'Viewducts',
                    //     //   applicationVersion: '1.0.0+1',
                    //     //   useRootNavigator: true,
                    //     // );
                    //   },
                    //),
                    Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(10),
                      child: frostedOrange(
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 3),
                              child: customTitleText('Social'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    kIsWeb
                        ? Container()
                        : SettingRowWidget("Website", showDivider: true,
                            onPressed: () {
                            launchURL("https://www.viewducts.com");
                          }),
                    SettingRowWidget("facebook Page", showDivider: true,
                        onPressed: () {
                      launchURL("https://www.facebook.com/viewducts");
                    }),
                    SettingRowWidget("Twitter Account", showDivider: true,
                        onPressed: () {
                      launchURL("https://twitter.com/viewducts");
                    }),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 1,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(CupertinoIcons.back),
                  ),
                  Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(10),
                    child: frostedOrange(
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 3),
                        child: customTitleText('About Us'),
                      ),
                    ),
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

// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viewducts/page/responsiveView.dart';

import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/frosted.dart';
import 'widgets/settingsRowWidget.dart';

class SettingsAndPrivacyPage extends StatelessWidget {
  const SettingsAndPrivacyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appSize = MediaQuery.of(context).size;
//var user = Provider.of<AuthState>(context).userModel ?? ViewductsUser();
    return Scaffold(
      //  backgroundColor: TwitterColor.mystic,
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
            Positioned(
              top: appSize.width * 0.2,
              left: 10,
              right: 10,
              child: SizedBox(
                width: appSize.width,
                height: appSize.height,
                child: ListView(
                  children: <Widget>[
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
                                  Colors.red.withOpacity(0.3)
                                ],
                                // begin: Alignment.topCenter,
                                // end: Alignment.bottomCenter,
                              )),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 3),
                                child: customTitleText('Profile Settings'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SettingRowWidget(
                      "Account",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AccountSettingsPageResponsiveView()));
                      },
                      // navigateTo: 'AccountSettingsPage',
                    ),
                    const Divider(height: 0),
                    SettingRowWidget(
                      "Ducts Settings",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PrivacyAndSaftyPagePageResponsiveView()));
                      },
                      //navigateTo: 'PrivacyAndSaftyPage'
                    ),
                    // SettingRowWidget("Notification",
                    //     navigateTo: 'NotificationPage'),

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
                                  Colors.teal.withOpacity(0.3)
                                ],
                                // begin: Alignment.topCenter,
                                // end: Alignment.bottomCenter,
                              )),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 3),
                                child: customTitleText('Others'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // SettingRowWidget("Display and Sound",
                    //     navigateTo: 'DisplayAndSoundPage'),
                    // SettingRowWidget("Data usage", navigateTo: 'DataUsagePage'),
                    // SettingRowWidget("Accessibility",
                    //     navigateTo: 'AccessibilityPage'),
                    // SettingRowWidget("Proxy", navigateTo: "ProxyPage"),
                    SettingRowWidget(
                      "About Viewducts",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AboutPageResponsiveView()));
                      },
                      // navigateTo: "AboutPage",
                    ),
                    const SettingRowWidget(
                      null,
                      showDivider: false,
                      vPadding: 10,
                      subtitle:
                          'These settings affects your Vieducts accounts on this devce.',
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: 20,
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
                        child: customTitleText('Settings and privacy'),
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

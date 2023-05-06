// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viewducts/page/settings/widgets/settingsRowWidget.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/frosted.dart';

class ContentPrefrencePage extends StatelessWidget {
  const ContentPrefrencePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appSize = MediaQuery.of(context).size;
    // var user = Provider.of<AuthState>(context).userModel ?? ViewductsUser();
    return Scaffold(
      // backgroundColor: TwitterColor.white,
      // appBar: SettingsAppBar(
      //   title: 'Content preferences',
      //   subtitle: user.userName,
      // ),
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
                              child: customTitleText('Adjusting Prefernces'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SettingRowWidget(
                      "Trends",
                      navigateTo: 'TrendsPage',
                    ),
                    const Divider(height: 0),
                    const SettingRowWidget(
                      "Search settings",
                      navigateTo: null,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: 10,
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(10),
                child: frostedOrange(
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        color: Colors.black,
                        icon: const Icon(CupertinoIcons.back),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 3),
                        child: customTitleText('MarketPlace Content'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Positioned(
            //   right: 0,
            //   child: SizedBox(
            //     height: appSize.width * 0.1,
            //     width: appSize.width * 0.3,
            //     child: Center(
            //       child: InkWell(
            //           onTap: () {
            //             Navigator.pop(context);
            //           },
            //           child: Row(
            //             children: <Widget>[
            //               IconButton(
            //                 onPressed: () {
            //                   Navigator.pop(context);
            //                 },
            //                 color: Colors.black,
            //                 icon:
            //                     const Icon(CupertinoIcons.clear_circled_solid),
            //               ),
            //               Text(
            //                 'Back',
            //                 style: TextStyle(
            //                     fontSize: 20,
            //                     fontWeight: FontWeight.w600,
            //                     color: Colors.blueGrey[300]),
            //               ),
            //             ],
            //           )),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

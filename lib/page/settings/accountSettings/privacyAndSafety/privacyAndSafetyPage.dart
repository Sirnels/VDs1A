// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viewducts/page/settings/widgets/settingsRowWidget.dart';
import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/frosted.dart';

class PrivacyAndSaftyPage extends StatelessWidget {
  const PrivacyAndSaftyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var appSize = MediaQuery.of(context).size;
    //var user = Provider.of<AuthState>(context).userModel ?? ViewductsUser();
    return Scaffold(
      //backgroundColor: TwitterColor.white,
      // appBar: SettingsAppBar(
      //   title: 'Privacy ',
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
                width: appSize.width,
                height: appSize.height,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: <Widget>[
                    Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(10),
                      child: frostedOrange(
                        Row(
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
                    const SettingRowWidget(
                      "Protect the Products you Duct",
                      subtitle:
                          'Only current Viewers and people you approve in future will be able to see your Your Products in the Store.',
                      vPadding: 15,
                      showDivider: false,
                      // visibleSwitch: true,
                    ),
                    const SettingRowWidget(
                      "Product tagging",
                      subtitle: 'Anyone can tag you for  now',
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
                              child: customTitleText('Location'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SettingRowWidget(
                      "Exact location",
                      subtitle:
                          '${authState.userModel!.location ?? 'Somewhere'} \n\n\n Viewducts  uses your device\'s precise location to display the right Ducts. This helps Viewducts improve your experience.',
                    ),
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
                    color: Colors.black,
                    icon: const Icon(CupertinoIcons.back),
                  ),
                  Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(10),
                    child: frostedOrange(
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 3),
                        child: customTitleText('Ducts Settings'),
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

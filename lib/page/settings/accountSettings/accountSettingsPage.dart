// ignore_for_file: file_names

import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/page/common/splash.dart';
import 'package:viewducts/page/settings/widgets/settingsRowWidget.dart';
import 'package:viewducts/state/serverApi.dart';
import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/frosted.dart';

class AccountSettingsPage extends HookWidget {
  const AccountSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<bool?> _showDialogs() {
      return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return frostedYellow(
            Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Colors.transparent,
              child: frostedYellow(
                Container(
                  height: Get.height * 0.2,
                  width: 100,
                  child: Column(
                    children: [
                      Wrap(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          offset: const Offset(0, 11),
                                          blurRadius: 11,
                                          color: Colors.black.withOpacity(0.06))
                                    ],
                                    borderRadius: BorderRadius.circular(5),
                                    color: CupertinoColors.systemRed),
                                padding: const EdgeInsets.all(5.0),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: const Text(
                                    'Are you sure you want to delete your account? it will not be recovered',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w200,
                                        color: CupertinoColors
                                            .lightBackgroundGray),
                                  ),
                                )),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.maybePop(context);
                              },
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
                                      color: CupertinoColors.inactiveGray),
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(
                                    children: [
                                      Icon(CupertinoIcons.back),
                                      const Text(
                                        'Cancel',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w200),
                                      )
                                    ],
                                  )),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              try {
                                EasyLoading.show(
                                    status: 'Deleting', dismissOnTap: true);
                                final data = Databases(
                                    ServerApi.instance.serverClientConnect());
                                final user = Users(
                                    ServerApi.instance.serverClientConnect());
                                await user.delete(
                                    userId: '${authState.appUser?.$id}');
                                await data.deleteDocument(
                                    databaseId: databaseId,
                                    collectionId: profileUserColl,
                                    documentId: '${authState.appUser?.$id}');
                                data.deleteDocument(
                                    databaseId: databaseId,
                                    collectionId: bankAccounts,
                                    documentId: '${authState.appUser?.$id}');
                                data.deleteDocument(
                                    databaseId: databaseId,
                                    collectionId: govementData,
                                    documentId: '${authState.appUser?.$id}');

                                cprint('account deeted');

                                await EasyLoading.dismiss();
                                Get.offAll(
                                  () => SplashPage(),
                                );
                              } on AppwriteException catch (e) {
                                cprint('$e deleting Account');
                              }
                            },
                            child: Padding(
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
                                      color: CupertinoColors.systemRed),
                                  padding: const EdgeInsets.all(5.0),
                                  child: const Text(
                                    'Delect',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w200),
                                  )),
                            ),
                          ),
                        ],
                      )
                      // Container(
                      //   height: Get.height * 0.3,
                      //   width: Get.height * 0.2,
                      //   decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(20)),
                      //   child: SafeArea(
                      //     child: Stack(
                      //       children: <Widget>[
                      //         Center(
                      //           child: ModalTile(
                      //             title: "File Exceeds Limit",
                      //             subtitle: "Please reduce your file size",
                      //             icon: Icons.tab,
                      //             onTap: () async {
                      //               Navigator.maybePop(context);
                      //             },
                      //           ),
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    //var appSize = MediaQuery.of(context).size;
    //var authState.userModel .value= Provider.of<AuthState>(context).userModel ?? ViewductsUser();
    return Scaffold(
      // backgroundColor: TwitterColor.white,
      // appBar: SettingsAppBar(
      //   title: 'Account',
      //   subtitle: authState.userModel?.value.userName,
      // ),
      body: SafeArea(
        child: Stack(
          children: [
            ThemeMode.system == ThemeMode.light
                ? frostedYellow(
                    Container(
                      height: Get.height,
                      width: Get.width,
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
              top: Get.width * 0.2,
              left: 10,
              right: 10,
              child: SizedBox(
                height: Get.height,
                width: Get.width,
                child: ListView(
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
                              child: customTitleText('Login Details'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SettingRowWidget(
                      "Username",
                      subtitle: authState.userModel!.userName,
                      // navigateTo: 'AccountSettingsPage',
                    ),
                    const Divider(height: 0),
                    SettingRowWidget(
                      "Phone",
                      subtitle: authState.userModel!.contact.toString(),
                    ),
                    SettingRowWidget(
                      "Email address",
                      subtitle: authState.userModel!.email,
                    ),
                    const SettingRowWidget("Password"),
                    // SettingRowWidget("Security"),
                    Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(10),
                      child: frostedOrange(
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 3),
                              child: customTitleText('Data and Permission'),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SettingRowWidget("Country"),
                    SettingRowWidget(textColor: CupertinoColors.systemRed,
                        onPressed: () async {
                      _showDialogs();
                    }, "Delete Account"),
                    // SettingRowWidget("Your Fwitter data"),
                    // SettingRowWidget("Apps and sessions"),
                    // SettingRowWidget(
                    //   "Log out",
                    //   textColor: TwitterColor.ceriseRed,
                    //   onPressed: () {
                    //     appState.setpageIndex = 0.obs;
                    //     authState.logoutCallback();
                    //     // Navigator.popUntil(context, ModalRoute.withName('/'));
                    //     // final state = Provider.of<AuthState>(context);
                    //     // state.logoutCallback();
                    //   },
                    // ),
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
                        child: customTitleText('Account'),
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

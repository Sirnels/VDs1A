import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viewducts/admin/Admin_dashbord/screens/admin_users.dart';
import 'package:viewducts/admin/Admin_dashbord/screens/dashboard/addDatabaseCollection.dart';
import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/frosted.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xFFF3BB1C),
      child: frostedYellow(
        ListView(
          children: [
            // DrawerHeader(
            //   child: customImage(
            //     context,
            //     authState.userModel?.profilePic,
            //   ),
            // ),
            // DrawerListTile(
            //   title: "Dashboard",
            //   svgSrc: "assets/icons/menu_dashbord.svg",
            //   press: () {},
            // ),
            authState.userModel?.email == 'viewducts@gmail.com'
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Get.to(() => AdminAnnouncement());
                      },
                      child: frostedYellow(
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 3),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(.5),
                                  blurRadius: 10,
                                )
                              ],
                              color: Colors.yellow,
                              borderRadius: BorderRadius.circular(10)),
                          child: customTitleText('Announcement'),
                        ),
                      ),
                    ),
                  )
                : Container(),
            authState.userModel?.email == 'viewducts@gmail.com'
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Get.to(() => AdminAddCountry());
                      },
                      child: frostedYellow(
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 3),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(.5),
                                  blurRadius: 10,
                                )
                              ],
                              color: Colors.cyan,
                              borderRadius: BorderRadius.circular(10)),
                          child: customTitleText('Add Country'),
                        ),
                      ),
                    ),
                  )
                : Container(),
            authState.userModel?.email == 'viewducts@gmail.com'
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Get.to(() => AddDataBaseCollectionsApi());
                      },
                      child: frostedYellow(
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 3),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(.5),
                                  blurRadius: 10,
                                )
                              ],
                              color: Colors.yellowAccent,
                              borderRadius: BorderRadius.circular(10)),
                          child: customTitleText('DataBase Api'),
                        ),
                      ),
                    ),
                  )
                : Container()
            // DrawerListTile(
            //   title: "Annoucement",
            //   svgSrc: "assets/notification-bell.png",
            //   press: () {
            //     Navigator.pop(context);
            //     Get.to(() => AdminAnnouncement());
            //   },
            // ),
            //           DrawerListTile(
            //             title: "Add Country",
            //             svgSrc: "assets/megaphone.png",
            //             press: () {
            //  Navigator.pop(context);

            //             },
            //           ),
            // DrawerListTile(
            //   title: "Commision",
            //   svgSrc: "assets/happy.png",
            //   press: () {},
            // ),
            // DrawerListTile(
            //   title: "Store",
            //   svgSrc: "assets/icons/menu_store.svg",
            //   press: () {},
            // ),
            // DrawerListTile(
            //   title: "Notification",
            //   svgSrc: "assets/icons/menu_notification.svg",
            //   press: () {},
            // ),
            // DrawerListTile(
            //   title: "Profile",
            //   svgSrc: "assets/icons/menu_profile.svg",
            //   press: () {},
            // ),
            // DrawerListTile(
            //   title: "Settings",
            //   svgSrc: "assets/icons/menu_setting.svg",
            //   press: () {},
            // ),
          ],
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Image.asset(
        svgSrc,
        //color: Colors.white54,
        height: 16,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white54),
      ),
    );
  }
}

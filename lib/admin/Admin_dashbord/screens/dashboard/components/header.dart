import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:viewducts/admin/Admin_dashbord/controllers/MenuController.dart';
import 'package:viewducts/admin/Admin_dashbord/responsive.dart';
import 'package:viewducts/admin/Admin_dashbord/screens/admin_users.dart';
import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/frosted.dart';

import '../../../constants.dart';

class Header extends HookWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              // color: Colors.black,
              icon: const Icon(CupertinoIcons.back),
            ),
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
                          Colors.orange.withOpacity(0.3)
                        ],
                        // begin: Alignment.topCenter,
                        // end: Alignment.bottomCenter,
                      )),
                  child: Row(
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
            ),
          ],
        ),
        if (!Responsive.isDesktop(context))
          authState.userModel?.email == 'viewducts@gmail.com'
              ? IconButton(icon: const Icon(Icons.menu), onPressed: () {}
                  //context.read<MenuController>().controlMenu,
                  )
              : Container(),
        if (!Responsive.isMobile(context))
          Text(
            "Dashboard",
            style: Theme.of(context).textTheme.headline6,
          ),
        if (!Responsive.isMobile(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        const Expanded(child: SizedBox()),
        const ProfileCard()
      ],
    );
  }
}

class ProfileCard extends HookWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);
  Widget _getUserAvatar(BuildContext context) {
    // var authState = Provider.of<AuthState>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.blueGrey[50],
          gradient: LinearGradient(
            colors: [
              Colors.yellow.withOpacity(0.1),
              Colors.white60.withOpacity(0.2),
              Colors.orange.withOpacity(0.3)
            ],
            // begin: Alignment.topCenter,
            // end: Alignment.bottomCenter,
          )),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: customInkWell(
          context: context,
          onPressed: () {
            Get.to(
              () => AdminStaffProfile(
                staffs: userCartController.staff
                    .firstWhere((id) => id.id == authState.appUser!.$id,
                        orElse: adminStaffController.staffRole)
                    .obs,
              ),
            );
            // Get.to(() => ProfilePage(
            //       profileId: authState.user!.uid,
            //     ));
            //_opTions(context);
            //  widget.scaffoldKey.currentState.openDrawer();
          },
          child:
              customImage(context, authState.userModel?.profilePic, height: 30),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    useEffect(
      () {
        adminStaffController.viewductsStaffActivd();
        // FirebaseMessaging.onMessageOpenedApp
        //     .listen((RemoteMessage message) async {
        //   // if (message.data["messageType"] == "chat") {
        //   cprint("onMessageOpenedApp}");
        //   // return await Get.to(() => ChatResponsive(
        //   //       userProfileId: message.data['senderId'],
        //   //     ));
        //   // // } else {}
        // });

        //  FirebaseMessaging.onMessage.listen(showFlutterNotification);

        // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        //   print('A new onMessageOpenedApp event was published!');
        //   Get.to(() => ChatResponsive(
        //         userProfileId: message.senderId,
        //       ));
        // });

        return () {};
      },
      [chatState.msgCount, chatState.chatUserList],
    );
    return _getUserAvatar(context);

    // Container(
    //   margin: const EdgeInsets.only(left: defaultPadding),
    //   padding: const EdgeInsets.symmetric(
    //     horizontal: defaultPadding,
    //     vertical: defaultPadding / 2,
    //   ),
    //   decoration: BoxDecoration(
    //     color: secondaryColor,
    //     borderRadius: const BorderRadius.all(Radius.circular(10)),
    //     border: Border.all(color: Colors.white10),
    //   ),
    //   child: Row(
    //     children: [
    //       _getUserAvatar(context),
    //       // Image.asset(
    //       //   "assets/images/profile_pic.png",
    //       //   height: 38,
    //       // ),
    //       if (!Responsive.isMobile(context))
    //         Padding(
    //           padding:
    //               const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
    //           child: Text(authState.user!.displayName.toString()),
    //         ),
    //       const Icon(Icons.keyboard_arrow_down),
    //     ],
    //   ),
    // );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search",
        fillColor: secondaryColor,
        filled: true,
        border: const OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(defaultPadding * 0.75),
            margin: const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration: const BoxDecoration(
              // color: primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Image.asset(
              "assets/search.png",
              height: Get.width * 0.06,
            ),
          ),
        ),
      ),
    );
  }
}

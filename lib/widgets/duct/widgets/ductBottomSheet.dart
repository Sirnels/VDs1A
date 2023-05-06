// ignore_for_file: file_names

import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:viewducts/helper/constant.dart';
import 'package:viewducts/helper/enum.dart';
import 'package:viewducts/helper/theme.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/page/message/item_Search_bar.dart';
import 'package:viewducts/page/responsiveView.dart';
import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/frosted.dart';

import '../../customWidgets.dart';

class DuctBottomSheet {
  Widget ductOptionIcon(BuildContext context, FeedModel? model, DuctType type) {
    return ViewDuctMenuHolder(
      onPressed: () {},
      menuItems: <DuctFocusedMenuItem>[
        DuctFocusedMenuItem(
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(0, 11),
                          blurRadius: 11,
                          color: Colors.black.withOpacity(0.06))
                    ],
                    borderRadius: BorderRadius.circular(18),
                    color: CupertinoColors.systemYellow),
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  model?.userId == authState.appUser?.$id ? 'Store' : 'Chat',
                  style: TextStyle(
                    //fontSize: Get.width * 0.03,
                    color: AppColor.darkGrey,
                  ),
                ),
              ),
            ),
            onPressed: () {
              cprint('${model?.userId}');
              if (model!.userId != null) {
                chatState.chatUser ==
                    searchState.viewUserlist
                        .firstWhere((data) => data.key == model.userId,
                            orElse: () => ViewductsUser())
                        .obs;
                if (model.userId == authState.appUser?.$id) {
                  Get.to(() => OpenContainer(
                        closedBuilder: (context, action) {
                          return ProfileResponsiveView(
                            profileId: model.userId,
                            profileType: ProfileType.Store,
                          );
                        },
                        openBuilder: (context, action) {
                          return ProfileResponsiveView(
                            profileId: model.userId,
                            profileType: ProfileType.Store,
                          );
                        },
                      ));
                } else {
                  Get.to(() => OpenContainer(
                        closedBuilder: (context, action) {
                          return ChatResponsive(
                            userProfileId: model.userId,
                          );
                        },
                        openBuilder: (context, action) {
                          return ChatResponsive(
                            userProfileId: model.userId,
                          );
                        },
                      ));
                }
              }
            },
            trailingIcon: Icon(model!.userId == authState.appUser?.$id
                ? CupertinoIcons.app_badge
                : CupertinoIcons.chat_bubble_2_fill)),
        // DuctFocusedMenuItem(
        //     title: const Text(
        //       'Share',
        //       style: TextStyle(
        //         //fontSize: Get.width * 0.03,
        //         color: AppColor.darkGrey,
        //       ),
        //     ),
        //     onPressed: () {
        //       // Get.back();

        //       // swipeMessage(message);
        //       // setState(() {});
        //       // textFieldFocus.nextFocus();
        //     },
        //     trailingIcon: const Icon(CupertinoIcons.reply)),
      ],
      child: Container(
        width: 25,
        height: 25,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: const Icon(CupertinoIcons.app_badge),
        //  customIcon(context,
        //     icon: AppIcon.arrowDown,
        //     istwitterIcon: true,
        //     iconColor: AppColor.lightGrey),
      ),
    );
  }

  Widget _widgetBottomSheetRow(BuildContext context, int icon,
      {String? text, Function? onPressed, bool isEnable = false}) {
    return Expanded(
      child: customInkWell(
        context: context,
        onPressed: () {
          if (onPressed != null) {
            onPressed();
          } else {
            Navigator.pop(context);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: <Widget>[
              customIcon(
                context,
                icon: icon,
                istwitterIcon: true,
                size: 25,
                paddingIcon: 8,
                iconColor: isEnable ? AppColor.lightGrey : AppColor.lightGrey,
              ),
              const SizedBox(
                width: 15,
              ),
              customText(
                text,
                context: context,
                style: TextStyle(
                  color: isEnable ? AppColor.lightGrey : AppColor.lightGrey,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void openvDuctbottomSheet(
      BuildContext context, DuctType? type, FeedModel model) async {
    var appSize = MediaQuery.of(context).size;
    await showDialog(
      // backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Stack(
          children: [
            Positioned(
              top: appSize.width * 0.5,
              left: 50,
              right: 50,
              child: frostedYellow(
                Container(
                    padding: const EdgeInsets.only(top: 5, bottom: 0),
                    height: 130,
                    width: fullWidth(context),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blueGrey[50],
                      gradient: LinearGradient(
                        colors: [
                          Colors.black87.withOpacity(0.1),
                          Colors.black87.withOpacity(0.2),
                          Colors.black87.withOpacity(0.3)
                          // Color(0xfffbfbfb),
                          // Color(0xfff7f7f7),
                        ],
                        // begin: Alignment.topCenter,
                        // end: Alignment.bottomCenter,
                      ),
                    ),
                    // decoration: BoxDecoration(
                    //   color: Theme.of(context).bottomSheetTheme.backgroundColor,
                    //   borderRadius: BorderRadius.only(
                    //     topLeft: Radius.circular(20),
                    //     topRight: Radius.circular(20),
                    //   ),
                    // ),
                    child: _vDuct(context, model, type)),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _vDuct(BuildContext context, FeedModel model, DuctType? type) {
    return Column(
      children: <Widget>[
        Container(
          width: fullWidth(context) * .1,
          height: 5,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
        _widgetBottomSheetRow(
          context,
          AppIcon.retweet,
          text: 'Duct',
        ),
        _widgetBottomSheetRow(
          context,
          AppIcon.edit,
          text: 'Vduct with comment',
          isEnable: true,
          onPressed: () {
            //var state = Provider.of<FeedState>(context, listen: false);
            // Prepare current Duct model to reply
            feedState.setDuctToReply = model.obs;
            Navigator.pop(context);

            /// `/ComposeTweetPage/vDuct` route is used to identify that tweet is going to be vDuct.
            /// To simple reply on any `Duct` use `ComposeTweetPage` route.
            Navigator.of(context).pushNamed('/ComposeTweetPage/vDuct');
          },
        )
      ],
    );
  }
}

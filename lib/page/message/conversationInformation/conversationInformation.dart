// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:viewducts/helper/constant.dart';
import 'package:viewducts/helper/theme.dart';

import 'package:viewducts/page/settings/widgets/headerWidget.dart';
import 'package:viewducts/page/settings/widgets/settingsRowWidget.dart';

import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/customAppBar.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/newWidget/customUrlText.dart';
import 'package:viewducts/widgets/newWidget/rippleButton.dart';

class ConversationInformation extends StatelessWidget {
  const ConversationInformation({Key? key}) : super(key: key);

  Widget _header(
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: SizedBox(
                height: 80,
                width: 80,
                child: RippleButton(
                  onPressed: () {
                    // Navigator.of(context).pushNamed(
                    //     '/ProfilePage/' + authState.userModel!.userId);
                  },
                  borderRadius: BorderRadius.circular(40),
                  child: customImage(context, authState.userModel!.profilePic,
                      height: 80),
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              UrlText(
                text: authState.userModel!.displayName,
                style: onPrimaryTitleText.copyWith(
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                width: 3,
              ),
              authState.userModel!.isVerified!
                  ? customIcon(
                      context,
                      icon: AppIcon.blueTick,
                      istwitterIcon: true,
                      iconColor: AppColor.primary,
                      size: 18,
                      paddingIcon: 3,
                    )
                  : const SizedBox(width: 0),
            ],
          ),
          customText(
            authState.userModel!.userName,
            style: onPrimarySubTitleText.copyWith(
              color: Colors.black54,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // var user = Provider.of<ChatState>(context).chatUser ?? ViewductsUser();
    return Scaffold(
      backgroundColor: TwitterColor.white,
      appBar: CustomAppBar(
        isBackButton: true,
        title: customTitleText(
          'Conversation information',
        ),
      ),
      body: ListView(
        children: <Widget>[
          _header(context),
          const HeaderWidget('Notifications'),
          const SettingRowWidget(
            "Mute conversation",
            visibleSwitch: true,
          ),
          Container(
            height: 15,
            color: TwitterColor.mystic,
          ),
          SettingRowWidget(
            "Block ${authState.userModel!.userName}",
            textColor: TwitterColor.dodgetBlue,
            showDivider: false,
          ),
          SettingRowWidget("Report ${authState.userModel!.userName}",
              textColor: TwitterColor.dodgetBlue, showDivider: false),
          const SettingRowWidget("Delete conversation",
              textColor: TwitterColor.ceriseRed, showDivider: false),
        ],
      ),
    );
  }
}

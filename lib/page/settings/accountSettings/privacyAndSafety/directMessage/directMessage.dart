// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:viewducts/helper/theme.dart';

import 'package:viewducts/page/settings/widgets/headerWidget.dart';
import 'package:viewducts/page/settings/widgets/settingsAppbar.dart';
import 'package:viewducts/page/settings/widgets/settingsRowWidget.dart';
import 'package:viewducts/state/stateController.dart';

class DirectMessagesPage extends StatelessWidget {
  const DirectMessagesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var authState = Provider.of<AuthState>(context).userModel ?? ViewductsUser();
    return Scaffold(
      backgroundColor: TwitterColor.white,
      appBar: SettingsAppBar(
        title: 'Direct Messages',
        subtitle: authState.userModel!.userName,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: const <Widget>[
          HeaderWidget(
            'Direct Messages',
            secondHeader: true,
          ),
          SettingRowWidget(
            "Receive message requests",
            navigateTo: null,
            showDivider: false,
            visibleSwitch: true,
            vPadding: 20,
            subtitle:
                'You will be able to receive Direct Message requests from anyone on Fwitter, even if you don\'t follow them.',
          ),
          SettingRowWidget(
            "Show read receipts",
            navigateTo: null,
            showDivider: false,
            visibleSwitch: true,
            subtitle:
                'When someone sends you a message, people in the conversation will know you\'ve seen it. If you turn off this setting, you won\'t be able to see read receipt from others.',
          ),
        ],
      ),
    );
  }
}

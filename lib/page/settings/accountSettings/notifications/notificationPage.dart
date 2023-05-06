// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:viewducts/helper/theme.dart';
import 'package:viewducts/page/settings/widgets/headerWidget.dart';
import 'package:viewducts/page/settings/widgets/settingsAppbar.dart';
import 'package:viewducts/page/settings/widgets/settingsRowWidget.dart';
import 'package:viewducts/state/stateController.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //var authState = Provider.of<AuthState>(context).userModel ?? ViewductsUser();
    return Scaffold(
      backgroundColor: TwitterColor.white,
      appBar: SettingsAppBar(
        title: 'Notifications',
        subtitle: authState.userModel!.userName,
      ),
      body: ListView(
        children: const <Widget>[
          HeaderWidget('Filters'),
          SettingRowWidget(
            "Quality filter",
            showCheckBox: true,
            subtitle:
                'Filter lower-quality from your notifications. This won\'t filter out notifications from people you follow or account you\'ve inteacted with recently.',
            // navigateTo: 'AccountSettingsPage',
          ),
          Divider(height: 0),
          SettingRowWidget("Advanced filter"),
          SettingRowWidget("Muted word"),
          HeaderWidget(
            'Preferences',
            secondHeader: true,
          ),
          SettingRowWidget(
            "Unread notification count badge",
            showCheckBox: false,
            subtitle:
                'Display a badge with the number of notifications waiting for you inside the Fwitter app.',
          ),
          SettingRowWidget("Push notifications"),
          SettingRowWidget("SMS notifications"),
          SettingRowWidget(
            "Email notifications",
            subtitle: 'Control when how often Fwitter sends emails to you.',
          ),
        ],
      ),
    );
  }
}

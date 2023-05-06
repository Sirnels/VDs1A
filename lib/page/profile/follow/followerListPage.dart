// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:viewducts/page/common/usersListPage.dart';
import 'package:viewducts/state/stateController.dart';

class FollowerListPage extends StatelessWidget {
  const FollowerListPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return UsersListPage(
      pageTitle: 'Viewers',
      // userIdsList: authState.profileUserModel!.viewersList,
      appBarIcon: const AssetImage('assets/user.png'),
      emptyScreenText:
          '${authState.profileUserModel!.displayName ?? authState.userModel!.displayName} doesn\'t have any viewers',
      emptyScreenSubTileText:
          'When someone view them, they\'ll be listed here.',
    );
  }
}

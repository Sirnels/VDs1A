// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:viewducts/page/common/usersListPage.dart';
import 'package:viewducts/state/stateController.dart';

class FollowingListPage extends StatelessWidget {
  const FollowingListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var state = Provider.of<AuthState>(context);
    return UsersListPage(
        pageTitle: 'Viewing',
        // userIdsList: authState.profileUserModel!.viewingList,
        appBarIcon: const AssetImage('assets/user.png'),
        emptyScreenText:
            '${authState.profileUserModel?.displayName ?? authState.userModel!.displayName} isn\'t viewing anyone',
        emptyScreenSubTileText: 'When they do they\'ll be listed here.');
  }
}

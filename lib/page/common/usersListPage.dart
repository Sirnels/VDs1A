// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viewducts/helper/theme.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/state/searchState.dart';
import 'package:viewducts/page/profile/allUsers.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/frosted.dart';
import 'package:viewducts/widgets/newWidget/emptyList.dart';

import 'widget/userListWidget.dart';

class UsersListPage extends StatelessWidget {
  const UsersListPage({
    Key? key,
    this.pageTitle = "",
    this.appBarIcon,
    this.emptyScreenText,
    this.emptyScreenSubTileText,
    this.userIdsList,
  }) : super(key: key);

  final String pageTitle;
  final String? emptyScreenText;
  final String? emptyScreenSubTileText;
  final AssetImage? appBarIcon;
  final List<String?>? userIdsList;

  Widget _floatingActionButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AllUsersPage()),
        );
      },
      child: Align(
        alignment: Alignment.center,
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(100),
              image: DecorationImage(image: appBarIcon!)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<ViewductsUser>? userList;
    return Scaffold(
      backgroundColor: TwitterColor.mystic,
      // appBar: CustomAppBar(
      //     isBackButton: true,
      //     title: customTitleText(pageTitle),
      //     icon: appBarIcon),
      body: SafeArea(
        child: Stack(
          children: [
            frostedYellow(
              Container(
                height: fullHeight(context),
                width: fullWidth(context),
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
            ),
            Positioned(
              top: -160,
              right: -140,
              child: Transform.rotate(
                angle: 90,
                child: Container(
                  height: fullWidth(context) * 0.8,
                  width: fullWidth(context),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/ankkara1.jpg'))),
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              left: -250,
              child: Transform.rotate(
                angle: 90,
                child: Container(
                  height: fullWidth(context) * 0.8,
                  width: fullWidth(context),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/ankkara1.jpg'))),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: -250,
              child: Transform.rotate(
                angle: 90,
                child: Container(
                  height: fullWidth(context) * 0.8,
                  width: fullWidth(context),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/ankara3.jpg'))),
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              right: -260,
              child: Transform.rotate(
                angle: 30,
                child: Container(
                  height: fullWidth(context) * 0.8,
                  width: fullWidth(context),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/ankkara1.jpg'))),
                ),
              ),
            ),
            Positioned(
              bottom: 300,
              left: -200,
              child: Transform.rotate(
                angle: 30,
                child: Container(
                  height: fullWidth(context) * 0.8,
                  width: fullWidth(context),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/ankara2.jpg'))),
                ),
              ),
            ),
            Positioned(
              bottom: -200,
              right: -60,
              child: Transform.rotate(
                angle: 30,
                child: Container(
                  height: fullWidth(context) * 0.8,
                  width: fullWidth(context),
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/ankkara1.jpg'))),
                ),
              ),
            ),
            Consumer<SearchState>(
              builder: (context, state, child) {
                if (userIdsList != null && userIdsList!.isNotEmpty) {
                  userList = state.getuserDetail(userIdsList);
                }
                return !(userList != null && userList!.isNotEmpty)
                    ? Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            SizedBox(
                              height: fullWidth(context) * 0.5,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed('/CreateFeedPage/tweet');
                              },
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      image:
                                          DecorationImage(image: appBarIcon!)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: fullWidth(context) * 0.08,
                            ),
                            Container(
                              width: fullWidth(context),
                              padding: const EdgeInsets.only(
                                  top: 0, left: 30, right: 30),
                              child: NotifyText(
                                title: emptyScreenText,
                                subTitle: emptyScreenSubTileText,
                              ),
                            ),
                          ],
                        ),
                      )
                    : UserListWidget(
                        list: userList,
                        emptyScreenText: emptyScreenText,
                        emptyScreenSubTileText: emptyScreenSubTileText,
                      );
              },
            ),
            Positioned(
              top: 10,
              right: 5,
              child: SizedBox(
                height: fullWidth(context) * 0.1,
                //width: fullWidth(context) * 0.3,
                child: Center(
                  child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: frostedYellow(
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(
                                    CupertinoIcons.clear_circled_solid),
                              ),
                              const Text('Back',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                            ],
                          ),
                        ),
                      )),
                ),
              ),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
                child: customText(
                  pageTitle,
                  style: TextStyle(
                      color: Colors.blueGrey[200],
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                )),
            Positioned(
              bottom: 20,
              right: 10,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
                child: _floatingActionButton(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: void_checks, file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viewducts/helper/enum.dart';
import 'package:viewducts/helper/theme.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/page/settings/widgets/settingsRowWidget.dart';
import 'package:viewducts/state/authState.dart';
import 'package:viewducts/state/searchState.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/frosted.dart';
import 'package:viewducts/widgets/newWidget/emptyList.dart';
import 'package:viewducts/widgets/newWidget/title_text.dart';

class AllUsersPage extends StatefulWidget {
  const AllUsersPage(
      {Key? key,
      this.scaffoldKey,
      this.submitButtonText,
      this.textController,
      this.title,
      this.onSearchChanged,
      this.icon,
      this.isBackButton = false,
      this.isbootomLine = true,
      this.isCrossButton = false,
      this.isSubmitDisable = true,
      this.leading,
      this.onActionPressed})
      : super(key: key);
  final Size appBarHeight = const Size.fromHeight(56.0);
  final int? icon;
  final bool isBackButton;
  final bool isbootomLine;
  final bool isCrossButton;
  final bool isSubmitDisable;
  final Widget? leading;
  final Function? onActionPressed;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final String? submitButtonText;
  final TextEditingController? textController;
  final Widget? title;
  final ValueChanged<String>? onSearchChanged;
  @override
  State<StatefulWidget> createState() => _AllUsersPageState();
}

class _AllUsersPageState extends State<AllUsersPage> {
  Widget? title;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = Provider.of<SearchState>(context, listen: false);
      state.resetFilterList();
    });
    super.initState();
  }

  void onSettingIconPressed() {
    Navigator.pushNamed(context, '/TrendsPage');
  }

  Widget _searchField() {
    final state = Provider.of<SearchState>(context);
    return Container(
        height: 50,
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: TextField(
          onChanged: (text) {
            state.filterByUsername(text);
          },
          controller: widget.textController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 0, style: BorderStyle.none),
              borderRadius: BorderRadius.all(
                Radius.circular(25.0),
              ),
            ),
            hintText: 'Search ViewDucts Users',
            fillColor: AppColor.extraLightGrey,
            filled: true,
            focusColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          ),
        ));
  }

  // Widget _floatingActionButton(BuildContext context) {
  //   return FloatingActionButton(
  //       backgroundColor: Colors.yellow[50],
  //       onPressed: () {
  //         onSettingIconPressed();
  //         // Navigator.of(context).pushNamed('/CreateFeedPage/tweet');
  //       },
  //       child: Icon(
  //         CupertinoIcons.settings_solid,
  //         color: Colors.black,
  //         size: 50,
  //       ));
  // }

  String sortBy = "";

  void openBottomSheet(
      BuildContext context, double height, Widget child) async {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          height: height,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: child,
        );
      },
    );
  }

  void openUserSortSettings(BuildContext context) {
    openBottomSheet(
      context,
      340,
      frostedPink(
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.blueGrey[50],
              gradient: LinearGradient(
                colors: [
                  Colors.yellow.withOpacity(0.1),
                  Colors.white60.withOpacity(0.2),
                  Colors.red.withOpacity(0.3)
                ],
                // begin: Alignment.topCenter,
                // end: Alignment.bottomCenter,
              )),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 5),
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: TwitterColor.paleSky50,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: TitleText('Sort user list'),
              ),
              const Divider(height: 0),
              _row(context, "Verified user first", SortUser.ByVerified),
              const Divider(height: 0),
              _row(context, "alphabetically", SortUser.ByAlphabetically),
              const Divider(height: 0),
              _row(context, "Newest user first", SortUser.ByNewest),
              const Divider(height: 0),
              _row(context, "Oldest user first", SortUser.ByOldest),
              const Divider(height: 0),
              _row(context, "User with max Viewers", SortUser.ByMaxFollower),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(BuildContext context, String text, SortUser sortBy) {
    final state = Provider.of<SearchState>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
      child: RadioListTile<SortUser>(
        value: sortBy,
        activeColor: Colors.orange.shade200,
        groupValue: state.sortBy,
        onChanged: (val) {
          state.updateUserSortPrefrence = val;
          Navigator.pop(context);
        },
        title: Text(text, style: const TextStyle(color: Colors.white)),
        controlAffinity: ListTileControlAffinity.trailing,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<SearchState>(context);
    var appSize = MediaQuery.of(context).size;
    List<ViewductsUser>? list = state.userlist;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = Provider.of<SearchState>(context, listen: false);
      sortBy = state.selectedFilter;
    });
    var settingRowWidget = SettingRowWidget(
      "Search Filter",
      subtitle: sortBy,
      onPressed: () {
        openUserSortSettings(context);
      },
      showDivider: false,
    );
    return Scaffold(
      backgroundColor: TwitterColor.mystic,
      body: SafeArea(
        child: Stack(
          children: [
            frostedYellow(
              Container(
                height: appSize.height,
                width: appSize.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.yellow[100]!.withOpacity(0.3),
                      Colors.yellow[200]!.withOpacity(0.1),
                      Colors.yellowAccent[100]!.withOpacity(0.2)
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
              top: appSize.width * 0.4,
              child: SizedBox(
                width: appSize.width * 0.9,
                height: appSize.height * 0.8,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      RefreshIndicator(
                        onRefresh: () async {
                          state.getDataFromDatabase();
                          return Future.value(true);
                        },
                        child: list == null || list.isEmpty
                            ? Align(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: fullWidth(context) * 0.1,
                                    ),
                                    Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          image: const DecorationImage(
                                              image: AssetImage(
                                                  'assets/user.png'))),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30),
                                      child: frostedWhite(
                                        Align(
                                          alignment: Alignment.topCenter,
                                          child: SizedBox(
                                            height: fullWidth(context) * 0.5,
                                            child: const EmptyList(
                                              'Oops No Sellers in Your Location/Country ',
                                              subTitle:
                                                  'Be the First to Invite/Start Your Own Store ',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        customButton(
                                          'Register',
                                          Image.asset(
                                            'assets/home 1.png',
                                            height: 20,
                                            width: 20,
                                          ),
                                        ),
                                        customText(' or ',
                                            style: const TextStyle(
                                                fontSize: 20,
                                                color: Colors.blueGrey)),
                                        customButton(
                                          'Invite and Earn',
                                          Image.asset(
                                            'assets/home 1.png',
                                            height: 20,
                                            width: 20,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            : SizedBox(
                                height: fullHeight(context) * 0.95,
                                width: fullWidth(context),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: appSize.width,
                                      height: appSize.width * 0.5,
                                      child: ListView.separated(
                                        addAutomaticKeepAlives: false,
                                        physics: const BouncingScrollPhysics(),
                                        itemBuilder: (context, index) =>
                                            Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: _UserTile(user: list[index]),
                                        ),
                                        separatorBuilder: (_, index) =>
                                            const Divider(
                                          height: 0,
                                        ),
                                        itemCount: list.length,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: appSize.width * 0.2,
              top: appSize.width * 0.15,
              left: appSize.width * 0.01,
              child: Column(
                children: [
                  Material(
                    elevation: 1,
                    borderRadius: BorderRadius.circular(100),
                    child: frostedOrange(
                      _searchField(),
                    ),
                  ),
                  settingRowWidget,
                ],
              ),
            ),
            Positioned(
              top: 20,
              left: 10,
              child: Material(
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
                            child: Image.asset('assets/search.png'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 3),
                          child: customTitleText('Search'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Positioned(
            //   top: 10,
            //   right: 5,
            //   child: Container(
            //     height: fullWidth(context) * 0.1,
            //     //width: fullWidth(context) * 0.3,
            //     child: Center(
            //       child: InkWell(
            //           onTap: () {
            //             Navigator.pop(context);
            //           },
            //           child: frostedYellow(
            //             Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: Row(
            //                 children: <Widget>[
            //                   IconButton(
            //                     onPressed: () {
            //                       Navigator.of(context).pop();
            //                     },
            //                     icon: Icon(CupertinoIcons.clear_circled_solid),
            //                   ),
            //                   Text('Back',
            //                       style: TextStyle(
            //                         fontSize: 20,
            //                         fontWeight: FontWeight.w600,
            //                         color: Colors.white,
            //                       )),
            //                 ],
            //               ),
            //             ),
            //           )),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

isFollower(BuildContext context) {
  //var authState = Provider.of<AuthState>(context, listen: false);
  // if (authState.profileUserModel!.viewersList != null &&
  //     authState.profileUserModel!.viewersList!.isNotEmpty) {
  //   return (authState.profileUserModel!.viewersList!
  //       .any((x) => x == authState.userModel!.userId));
  // } else
  {
    return false;
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile({Key? key, this.user}) : super(key: key);
  final ViewductsUser? user;
  // Widget _vendorChecker(ViewductsUser? model, BuildContext context) {
  //   var authState = Provider.of<AuthState>(context, listen: false);
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 8),
  //     child: Container(
  //       height: authState.userId == user!.userId
  //           ? fullWidth(context) * 0.04
  //           : fullWidth(context) * 0.03,
  //       width: authState.userId == user!.userId
  //           ? fullWidth(context) * 0.04
  //           : fullWidth(context) * 0.03,
  //       padding: const EdgeInsets.all(7.0),
  //       decoration: BoxDecoration(
  //         shape: BoxShape.circle,
  //         color: user!.lastSeen == true ? Colors.green : Colors.grey,
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    var authState = Provider.of<AuthState>(context, listen: false);
    return authState.userId == user!.userId
        ? Container()
        : Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blueGrey[50],
                gradient: LinearGradient(
                  colors: [
                    Colors.yellow.withOpacity(0.1),
                    Colors.white60.withOpacity(0.2),
                    Colors.orange.shade200.withOpacity(0.3)
                  ],
                  // begin: Alignment.topCenter,
                  // end: Alignment.bottomCenter,
                )),
            child: frostedOrange(
              ListTile(
                onTap: () {
                  kAnalytics.logViewSearchResults(searchTerm: user!.userName!);
                  Navigator.of(context)
                      .pushNamed('/ProfilePage/' + user!.userId!);
                },
                leading: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(100),
                    child: customImage(context, user!.profilePic, height: 40)),
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: TitleText(user!.displayName,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          overflow: TextOverflow.ellipsis),
                    ),
                    const SizedBox(width: 3),
                    user!.isVerified!
                        ? CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.transparent,
                            child: Image.asset('assets/shopping-bag.png'),
                          )
                        : const SizedBox(width: 0),
                  ],
                ),
                subtitle: Text(user!.userName!),
                trailing: Column(
                  children: const [
                    // _vendorChecker(user, context),
                    // authState.userId == user!.userId
                    //     ? const SizedBox(
                    //         height: 0,
                    //         width: 0,
                    //       )
                    //     : RippleButton(
                    //         splashColor: Colors.orange[50],
                    //         borderRadius:
                    //             const BorderRadius.all(Radius.circular(60)),
                    //         onPressed: () {
                    //           authState.followUser(user!.userId,
                    //               removeFollower: isFollower(context));
                    //         },
                    //         child: Container(
                    //           padding: const EdgeInsets.symmetric(
                    //             horizontal: 10,
                    //             vertical: 5,
                    //           ),
                    //           decoration: BoxDecoration(
                    //             color: isFollower(context) ||
                    //                     authState.userModel!.viewingList!
                    //                         .contains(user!.userId) ||
                    //                     authState.userModel!.viewersList!
                    //                         .contains(user!.userId)
                    //                 ? TwitterColor.ceriseRed
                    //                 : TwitterColor.white,
                    //             border: Border.all(
                    //                 color: Colors.black87.withAlpha(180),
                    //                 width: 1),
                    //             borderRadius: BorderRadius.circular(20),
                    //           ),

                    //           /// If [isMyProfile] is true then Edit profile button will display
                    //           // Otherwise Follow/Following button will be display
                    //           child: Text(
                    //             isFollower(context) ||
                    //                     authState.userModel!.viewingList!
                    //                         .contains(user!.userId) ||
                    //                     authState.userModel!.viewersList!
                    //                         .contains(user!.userId)
                    //                 ? 'Viewing'
                    //                 : 'View',
                    //             style: TextStyle(
                    //               color: isFollower(context) ||
                    //                       authState.userModel!.viewingList!
                    //                           .contains(user!.userId) ||
                    //                       authState.userModel!.viewersList!
                    //                           .contains(user!.userId)
                    //                   ? TwitterColor.white
                    //                   : Colors.blueGrey[500],
                    //               fontSize: 17,
                    //               fontWeight: FontWeight.bold,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                  ],
                ),
              ),
            ),
          );
  }
}

// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viewducts/helper/enum.dart';
import 'package:viewducts/helper/theme.dart';
import 'package:viewducts/page/settings/widgets/settingsRowWidget.dart';
import 'package:viewducts/state/searchState.dart';
// ignore: unused_import
import 'package:viewducts/widgets/customAppBar.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/frosted.dart';
import 'package:viewducts/widgets/newWidget/title_text.dart';

class TrendsPage extends StatefulWidget {
  const TrendsPage({Key? key}) : super(key: key);

  @override
  _TrendsPageState createState() => _TrendsPageState();
}

class _TrendsPageState extends State<TrendsPage> {
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
        Column(
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
            _row(context, "User with max follower", SortUser.ByMaxFollower),
          ],
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
        activeColor: Colors.yellow,
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
    var appSize = MediaQuery.of(context).size;
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
      // backgroundColor: TwitterColor.white,
      // appBar: CustomAppBar(
      //   isBackButton: true,
      //   title: customTitleText(
      //     'Trends',
      //   ),
      // ),
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
            frostedYellow(
              SizedBox(
                height: appSize.height,
                width: appSize.width,
              ),
            ),
            Positioned(
              top: appSize.width * 0.2,
              child: SizedBox(
                width: appSize.width,
                height: appSize.height,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: <Widget>[
                    settingRowWidget,
                    const SettingRowWidget(
                      "Trends location",
                      navigateTo: null,
                      subtitle: 'Selected location',
                      showDivider: false,
                    ),
                    const SettingRowWidget(
                      null,
                      subtitle:
                          'You can see what\'s trending in a specfic location by selecting which location appears in your Trending tab.',
                      navigateTo: null,
                      showDivider: false,
                      vPadding: 12,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: 10,
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(10),
                child: frostedOrange(
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 3),
                        child: customTitleText('MarketPlace Content'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              child: SizedBox(
                height: appSize.width * 0.1,
                width: appSize.width * 0.3,
                child: Center(
                  child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            color: Colors.black,
                            icon:
                                const Icon(CupertinoIcons.clear_circled_solid),
                          ),
                          Text(
                            'Back',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.blueGrey[300]),
                          ),
                        ],
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

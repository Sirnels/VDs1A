// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viewducts/helper/constant.dart';
import 'package:viewducts/helper/theme.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/notificationModel.dart';
import 'package:viewducts/state/notificationState.dart';
import 'package:viewducts/state/stateController.dart';

import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/frosted.dart';
import 'package:viewducts/widgets/newWidget/customUrlText.dart';
import 'package:viewducts/widgets/newWidget/emptyList.dart';
import 'package:viewducts/widgets/newWidget/title_text.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key, this.scaffoldKey}) : super(key: key);

  /// scaffoldKey used to open sidebaar drawer
  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     var state = Provider.of<NotificationState>(context, listen: false);
  //     var authState = Provider.of<AuthState>(context, listen: false);
  //     authState.getDataFromDatabase(authState.userId);
  //   });
  // }

  void onSettingIconPressed() {
    Navigator.pushNamed(context, '/NotificationPage');
  }

  @override
  Widget build(BuildContext context) {
    var appSize = MediaQuery.of(context).size;
    return SafeArea(
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
              top: 60,
              right: appSize.width * 0.15,
              left: 10,
              child: SizedBox(
                  height: appSize.height,
                  width: appSize.width,
                  child: const NotificationPageBody())),
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
                          Colors.red.withOpacity(0.3)
                        ],
                        // begin: Alignment.topCenter,
                        // end: Alignment.bottomCenter,
                      )),
                  child: Row(
                    children: [
                      Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(100),
                        child: const CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.transparent,
                            child: Icon(
                              CupertinoIcons.bell_solid,
                              color: Colors.black,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 3),
                        child: customTitleText('Notifications'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Positioned(
          //   top: 10,
          //   right: 10,
          //   child: Material(
          //     elevation: 10,
          //     borderRadius: BorderRadius.circular(100),
          //     child: frostedOrange(
          //       _getUserAvatar(context),
          //     ),
          //   ),
          // ),
          // Positioned(
          //   top: 0,
          //   // left: appSize.width * 0.7,
          //   right: fullWidth(context) * 0.3,
          //   child: Row(
          //     children: <Widget>[
          //       CartIcon(),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}

class NotificationPageBody extends StatelessWidget {
  const NotificationPageBody({Key? key}) : super(key: key);

  Widget _notificationRow(BuildContext context, NotificationModel model) {
    return Container();
    // var state = Provider.of<NotificationState>(context);
    // return FutureBuilder(
    //   future: notificationState.getDuctDetail(model.ductKey),
    //   builder: (BuildContext context, AsyncSnapshot<FeedModel> snapshot) {
    //     if (snapshot.hasData) {
    //       return NotificationTile(
    //         model: snapshot.data,
    //       );
    //     } else if (snapshot.connectionState == ConnectionState.waiting ||
    //         snapshot.connectionState == ConnectionState.active) {
    //       return Center(
    //         child: Container(
    //           height: fullHeight(context),
    //           width: fullWidth(context),
    //           child: customText('Checking Your Connection...'),
    //           // child: LinearProgressIndicator(),
    //         ),
    //       );
    //     } else {
    //       cprint('Unavalible Notification Removed');

    //       /// remove notification from firebase db if dcut in not available or deleted.
    //       // var authState = Provider.of<AuthState>(context);
    //       notificationState.removeNotification(authState.userId, model.ductKey!);
    //       return SizedBox();
    //     }
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    // var state = Provider.of<NotificationState>(context);
    var list = notificationState.notificationList;
    if ((list == null || list.isEmpty)) {
      return Center(
        child: SizedBox(
          height: fullHeight(context),
          width: fullWidth(context),
          child: customText('Checking Your Connection...'),
          // child: LinearProgressIndicator(),
        ),
      );
    } else if (list.isEmpty) {
      return Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            SizedBox(
              height: fullWidth(context) * 0.4,
            ),
            Container(
              height: 100,
              width: 100,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/notification-bell.png'))),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: fullWidth(context) * 0.5,
                  child: const EmptyList(
                    'No Notification available yet',
                    subTitle:
                        'When new notifiction found, they\'ll show up here.',
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    return SizedBox(
      height: fullHeight(context) * 0.8,
      width: fullWidth(context),
      child: ListView.builder(
        addAutomaticKeepAlives: true,
        itemBuilder: (context, index) => _notificationRow(context, list[index]),
        itemCount: list.length,
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final FeedModel? model;
  const NotificationTile({Key? key, this.model}) : super(key: key);
  Widget _userList(BuildContext context, List<String?> list) {
    // List<String> names = [];
    var length = list.length;
    List<Widget> avaterList = [];
    final int noOfUser = list.length;
    // var state = Provider.of<NotificationState>(context);
    if (list.length > 5) {
      list = list.take(5).toList();
    }
    avaterList = list.map((userId) {
      return _userAvater(userId, notificationState, (name) {
        // names.add(name);
      });
    }).toList();
    if (noOfUser > 5) {
      avaterList.add(
        Text(
          " +${noOfUser - 5}",
          style: subtitleStyle.copyWith(fontSize: 16),
        ),
      );
    }

    var col = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            const SizedBox(width: 20),
            customIcon(context,
                icon: AppIcon.heartFill,
                iconColor: TwitterColor.ceriseRed,
                istwitterIcon: true,
                size: 25),
            const SizedBox(width: 10),
            Row(children: avaterList),
          ],
        ),
        // names.length > 0 ? Text(names[0]) : SizedBox(),
        Padding(
          padding: const EdgeInsets.only(left: 60, bottom: 5, top: 5),
          child: TitleText(
            '$length customer like your Product',
            fontSize: 18,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
    return col;
  }

  Widget _userAvater(
      String? userId, NotificationState state, ValueChanged<String?> name) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0),
      // child: Material(
      //   elevation: 10,
      //   borderRadius: BorderRadius.circular(100),
      //   child: FutureBuilder(
      //     future: authState.getuserDetail(userId),
      //     //  initialData: InitialData,
      //     builder:
      //         (BuildContext context, AsyncSnapshot<ViewductsUser> snapshot) {
      //       if (snapshot.hasData) {
      //         name(snapshot.data!.displayName);
      //         return Padding(
      //           padding: EdgeInsets.symmetric(horizontal: 3),
      //           child: GestureDetector(
      //             onTap: () {
      //               Navigator.of(context)
      //                   .pushNamed('/ProfilePage/' + snapshot.data?.userId!);
      //             },
      //             child: customImage(context, snapshot.data!.profilePic,
      //                 height: 30),
      //           ),
      //         );
      //       } else {
      //         return Container();
      //       }
      //     },
      //   ),
      //   ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var ductComment = model!.ductComment!.length > 150
        ? model!.ductComment!.substring(0, 150) + '...'
        : model!.ductComment;
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            //color: TwitterColor.white,
            child: ListTile(
              onTap: () {
                // var state = Provider.of<FeedState>(context, listen: false);
                feedState.getpostDetailFromDatabase(null, model: model);
                Navigator.of(context)
                    .pushNamed('/FeedPostDetail/' + model!.key!);
              },
              // title: _userList(context, model!.likeList!),
              subtitle: Padding(
                padding: const EdgeInsets.only(left: 60),
                child: UrlText(
                  text: ductComment,
                  style: const TextStyle(
                    color: AppColor.darkGrey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ),
        const Divider(height: 0, thickness: .6)
      ],
    );
  }
}

// ignore_for_file: deprecated_member_use, file_names, unnecessary_null_comparison

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import 'package:viewducts/helper/constant.dart';
import 'package:viewducts/helper/theme.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/state/feedState.dart';
import 'package:viewducts/widgets/frosted.dart';

import 'newWidget/customUrlText.dart';

Widget customTitleText(String? title, {BuildContext? context, Color? colors}) {
  return Text(
    title ?? '',
    style: TextStyle(
      color: colors,
      fontFamily: 'HelveticaNeue',
      fontWeight: FontWeight.w900,
      fontSize: 20,
    ),
  );
}

Widget customeGrideView(Iterable<Widget> list,
    {required BuildContext context}) {
  return SizedBox(
    // margin: EdgeInsets.symmetric(vertical: 10),
    width: AppTheme.fullWidth(context) * 0.83,
    height: AppTheme.fullWidth(context) * 0.7,

    child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 4 / 3,
            mainAxisSpacing: 30,
            crossAxisSpacing: 20),
        padding: const EdgeInsets.only(left: 20),
        scrollDirection: Axis.horizontal,
        children: list as List<Widget>),
  );
}

Widget customButton(String title, Image image, {BuildContext? context}) {
  return Column(
    children: [
      Row(
        children: [
          CircleAvatar(
              radius: 14, backgroundColor: Colors.transparent, child: image),
          Material(
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
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
                  child: customTitleText(title),
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

Widget heading(String heading,
    {double horizontalPadding = 10, BuildContext? context}) {
  double fontSize = 16;
  if (context != null) {
    fontSize = getDimention(context, 16);
  }
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
    child: Text(
      heading,
      style: AppTheme.apptheme.typography.dense.bodyText1!
          .copyWith(fontSize: fontSize),
    ),
  );
}

Widget userImage(String path, {double height = 100}) {
  return Container(
    width: height,
    height: height,
    alignment: FractionalOffset.topCenter,
    decoration: BoxDecoration(
      boxShadow: shadow,
      border: Border.all(color: Colors.white, width: 1),
      borderRadius: BorderRadius.circular(height / 2),
      image: DecorationImage(image: NetworkImage(path)),
    ),
  );
}

Widget customIcon(
  BuildContext? context, {
  required int icon,
  bool isEnable = false,
  double size = 18,
  bool istwitterIcon = true,
  bool isFontAwesomeRegular = false,
  bool isFontAwesomeSolid = false,
  Color? iconColor,
  double paddingIcon = 10,
}) {
  iconColor = iconColor ?? Theme.of(context!).textTheme.caption!.color;
  return Padding(
    padding: EdgeInsets.only(bottom: istwitterIcon ? paddingIcon : 0),
    child: CircleAvatar(
      radius: size,
      backgroundColor: Colors.transparent,
      child: Image.asset('assets/verify.png'),
    ),
    //  Icon(CupertinoIcons.square_fill_line_vertical_square_fill
    //     // IconData(icon,
    //     //     fontFamily: istwitterIcon
    //     //         ? 'TwitterIcon'
    //     //         : isFontAwesomeRegular
    //     //             ? 'AwesomeRegular'
    //     //             : isFontAwesomeSolid
    //     //                 ? 'AwesomeSolid'
    //     //                 : 'Fontello'),
    //     // size: size,
    //     // color: isEnable ? Theme.of(context!).primaryColor : iconColor,
    //     ),
  );
}

Widget customTappbleIcon(BuildContext context, int icon,
    {double size = 16,
    bool isEnable = false,
    Function(bool?, int?)? onPressed1,
    bool? isBoolValue,
    int? id,
    Function? onPressed2,
    bool isFontAwesomeRegular = false,
    bool istwitterIcon = false,
    bool isFontAwesomeSolid = false,
    Color? iconColor,
    EdgeInsetsGeometry? padding}) {
  padding ??= const EdgeInsets.all(10);
  return MaterialButton(
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    minWidth: 10,
    height: 10,
    padding: padding,
    shape: const CircleBorder(),
    color: Colors.transparent,
    elevation: 0,
    onPressed: () {
      if (onPressed1 != null) {
        onPressed1(isBoolValue, id);
      } else if (onPressed2 != null) {
        onPressed2();
      }
    },
    child: customIcon(context,
        icon: icon,
        size: size,
        isEnable: isEnable,
        istwitterIcon: istwitterIcon,
        isFontAwesomeRegular: isFontAwesomeRegular,
        isFontAwesomeSolid: isFontAwesomeSolid,
        iconColor: iconColor),
  );
}

Widget customText(String? msg,
    {Key? key,
    TextStyle? style,
    TextAlign textAlign = TextAlign.justify,
    TextOverflow overflow = TextOverflow.visible,
    BuildContext? context,
    bool softwrap = true}) {
  if (msg == null) {
    return const SizedBox(
      height: 0,
      width: 0,
    );
  } else {
    if (context != null && style != null) {
      var fontSize =
          style.fontSize ?? Theme.of(context).textTheme.bodyText1!.fontSize!;
      style = style.copyWith(
        fontSize: fontSize - (fullWidth(context) <= 375 ? 2 : 0),
      );
    }
    return Text(
      msg,
      style: style,
      textAlign: textAlign,
      overflow: overflow,
      softWrap: softwrap,
      key: key,
    );
  }
}

Widget customImage(
  BuildContext context,
  String? path, {
  double height = 50,
  bool isBorder = false,
}) {
  return Container(
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
            offset: const Offset(0, 11),
            blurRadius: 11,
            color: Colors.black.withOpacity(0.06))
      ],
      shape: BoxShape.circle,
      border: Border.all(color: Colors.grey.shade100, width: isBorder ? 2 : 0),
    ),
    child: CircleAvatar(
      maxRadius: height / 2,
      backgroundColor: Theme.of(context).cardColor,
      backgroundImage: customAdvanceNetworkImage(path ?? dummyProfilePic),
    ),
  );
}

Widget customMarketOptionImage(
  BuildContext context,
  String? path, {
  double height = 50,
  bool isBorder = false,
}) {
  return Container(
    decoration: BoxDecoration(
      //  shape: BoxShape.circle,
      //  border: Border.all(color: Colors.grey.shade100, width: isBorder ? 2 : 0),
      image: DecorationImage(
          image: customAdvanceNetworkImage(path ?? dummyProfilePic),
          fit: BoxFit.cover),
    ),
    //  child:Image(image:customAdvanceNetworkImage(path ?? dummyProfilePic)),
    // CircleAvatar(
    //   maxRadius: height / 2,
    //   backgroundColor: Theme.of(context).cardColor,
    //   backgroundImage: customAdvanceNetworkImage(path ?? dummyProfilePic),
    // ),
  );
}

Widget customNormalImage(
  BuildContext context,
  String path, {
  double height = 50,
  bool isBorder = false,
}) {
  return CircleAvatar(
    maxRadius: height / 2,
    backgroundColor: Colors.transparent,
    backgroundImage: customAdvanceNetworkImage(path),
  );
}

double fullWidth(BuildContext context) {
  // cprint(MediaQuery.of(context).size.width.toString());
  return MediaQuery.of(context).size.width;
}

double fullHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

Widget customInkWell(
    {Widget? child,
    BuildContext? context,
    Function(bool, int)? function1,
    Function? onPressed,
    bool isEnable = false,
    int no = 0,
    Color color = Colors.transparent,
    Color? splashColor,
    BorderRadius? radius}) {
  splashColor ??= Theme.of(context!).primaryColorLight;
  radius ??= BorderRadius.circular(0);
  return Material(
    color: color,
    child: InkWell(
      borderRadius: radius,
      onTap: () {
        if (function1 != null) {
          function1(isEnable, no);
        } else if (onPressed != null) {
          onPressed();
        }
      },
      splashColor: splashColor,
      child: child,
    ),
  );
}

SizedBox sizedBox({double height = 5, String? title}) {
  return SizedBox(
    height: title == null || title.isEmpty ? 0 : height,
  );
}

Widget customNetworkImage(String? path, {BoxFit fit = BoxFit.contain}) {
  return CachedNetworkImage(
    cacheKey: path,
    fit: fit,
    imageUrl: path ?? dummyProfilePic,
    imageBuilder: (context, imageProvider) => Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: imageProvider,
          fit: fit,
        ),
      ),
    ),
    placeholderFadeInDuration: const Duration(milliseconds: 500),
    placeholder: (context, url) =>
        Container(color: CupertinoColors.darkBackgroundGray),
    errorWidget: (context, url, error) => const Icon(Icons.error),
  );
}

dynamic customAdvanceNetworkImage(String? path) {
  path ??= dummyProfilePic;
  return CachedNetworkImageProvider(
    path,
  );
}

void showAlert(BuildContext context,
    {required Function onPressedOk,
    required String title,
    String okText = 'OK',
    String cancelText = 'Cancel'}) async {
  showDialog(
      context: context,
      builder: (context) {
        return customAlert(context,
            onPressedOk: onPressedOk,
            title: title,
            okText: okText,
            cancelText: cancelText);
      });
}

Widget customAlert(BuildContext context,
    {required Function onPressedOk,
    required String title,
    String okText = 'OK',
    String cancelText = 'Cancel'}) {
  return AlertDialog(
    title: Text('Alert',
        style: TextStyle(
            fontSize: getDimention(context, 25), color: Colors.black54)),
    content: customText(title, style: const TextStyle(color: Colors.black45)),
    actions: <Widget>[
      TextButton(
        // textColor: Colors.grey,
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(cancelText),
      ),
      TextButton(
        //  textColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.pop(context);
          onPressedOk();
        },
        child: Text(okText),
      )
    ],
  );
}

capitalizeHeading(String text) {
  if (text == null) {
    return text = "";
  } else {
    text = "${text[0].toUpperCase()}${text.substring(1)}";
    return text;
  }
}

Widget header(String headerText, GlobalKey<ScaffoldState> scaffoldKey,
    bool showIcon, BuildContext context) {
  final GlobalKey<State> keyLoader = GlobalKey<State>();
  late FeedModel productInCart = FeedModel();
  FeedState _shoppingBagService = FeedState();
  return AppBar(
    centerTitle: true,
    title: Text(
      capitalizeHeading(headerText),
      style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 22.0,
          fontFamily: 'NovaSquare'),
    ),
    backgroundColor: Colors.white,
    elevation: 1.0,
    automaticallyImplyLeading: false,
    leading: IconButton(
      icon: const Icon(Icons.menu, size: 35.0, color: Colors.black),
      onPressed: () {
        if (scaffoldKey.currentState!.isDrawerOpen == false) {
          scaffoldKey.currentState!.openDrawer();
        } else {
          scaffoldKey.currentState!.openEndDrawer();
        }
      },
    ),
    actions: <Widget>[
      Visibility(
        visible: showIcon,
        child: IconButton(
          icon: const Icon(
            Icons.shopping_basket,
            size: 35.0,
            color: Colors.black,
          ),
          onPressed: () async {
            Map<String, dynamic> args = {};
            // Loader.showLoadingScreen(context, keyLoader);
            List bagItems =
                await _shoppingBagService.listProductsInCart(productInCart);
            args['bagItems'] = bagItems;
            Navigator.of(keyLoader.currentContext!, rootNavigator: true).pop();
            Navigator.pushNamed(context, '/bag', arguments: args);
          },
        ),
      )
    ],
  );
}

void customSnackBar(GlobalKey<ScaffoldState> _scaffoldKey, String msg,
    {double height = 30, Color backgroundColor = Colors.black}) {
  if (_scaffoldKey.currentState == null) {
    return;
  }
  ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();
  final snackBar = SnackBar(
    backgroundColor: backgroundColor,
    content: Text(
      msg,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
  );
  ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);
}

Widget emptyListWidget(BuildContext context, String title,
    {String? subTitle, String image = 'emptyImage.png'}) {
  return Container(
    color: const Color(0xfffafafa),
    child: Center(
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: fullWidth(context) * .95,
            height: fullWidth(context) * .95,
            decoration: const BoxDecoration(
              // color: Color(0xfff1f3f6),
              boxShadow: <BoxShadow>[
                // BoxShadow(blurRadius: 50,offset: Offset(0, 0),color: Color(0xffe2e5ed),spreadRadius:20),
                BoxShadow(
                  offset: Offset(0, 0),
                  color: Color(0xffe2e5ed),
                ),
                BoxShadow(
                    blurRadius: 50,
                    offset: Offset(10, 0),
                    color: Color(0xffffffff),
                    spreadRadius: -5),
              ],
              shape: BoxShape.circle,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/$image', height: 170),
              const SizedBox(
                height: 20,
              ),
              customText(
                title,
                style: Theme.of(context)
                    .typography
                    .dense
                    .bodyText1!
                    .copyWith(color: const Color(0xff9da9c7)),
              ),
              customText(
                subTitle,
                style: Theme.of(context)
                    .typography
                    .dense
                    .bodyText2!
                    .copyWith(color: const Color(0xffabb8d6)),
              ),
            ],
          )
        ],
      ),
    ),
  );
}

Widget widgetBottonSheetRow(BuildContext context, widget,
    {String? text, Function? onPressed, bool isEnable = false}) {
  return Expanded(
    child: customInkWell(
      context: context,
      onPressed: () {
        if (onPressed != null) {
          onPressed();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: <Widget>[
            Container(child: widget),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blueGrey[50],
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.8)
                    // Color(0xfffbfbfb),
                    // Color(0xfff7f7f7),
                  ],
                  // begin: Alignment.topCenter,
                  // end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: customText(
                  text,
                  context: context,
                  style: TextStyle(
                    color: isEnable ? Colors.yellow : AppColor.lightGrey,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget loader() {
  if (Platform.isIOS) {
    return const Center(
      child: CupertinoActivityIndicator(),
    );
  } else {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
      ),
    );
  }
}

Widget customSwitcherWidget(
    {required child, Duration duraton = const Duration(milliseconds: 500)}) {
  return AnimatedSwitcher(
    duration: duraton,
    transitionBuilder: (Widget child, Animation<double> animation) {
      return ScaleTransition(child: child, scale: animation);
    },
    child: child,
  );
}

Widget customExtendedText(String text, bool isExpanded,
    {BuildContext? context,
    TextStyle? style,
    required Function onPressed,
    required TickerProvider provider,
    AlignmentGeometry alignment = Alignment.topRight,
    required EdgeInsetsGeometry padding,
    int wordLimit = 100,
    bool isAnimated = true}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      AnimatedSize(
        vsync: provider,
        duration: Duration(milliseconds: (isAnimated ? 500 : 0)),
        child: ConstrainedBox(
          constraints: isExpanded
              ? const BoxConstraints()
              : BoxConstraints(maxHeight: wordLimit == 100 ? 100.0 : 260.0),
          child: customText(text,
              softwrap: true,
              overflow: TextOverflow.fade,
              style: style,
              context: context,
              textAlign: TextAlign.start),
        ),
      ),
      text.length > wordLimit
          ? Container(
              alignment: alignment,
              child: InkWell(
                onTap: onPressed as void Function()?,
                child: Padding(
                  padding: padding,
                  child: Text(
                    !isExpanded ? 'more...' : 'Less...',
                    style: const TextStyle(color: Colors.blue, fontSize: 14),
                  ),
                ),
              ),
            )
          : Container()
    ],
  );
}

double getDimention(context, double unit) {
  if (fullWidth(context) <= 360.0) {
    return unit / 1.3;
  } else {
    return unit;
  }
}

Positioned theWord(BuildContext context) {
  return Positioned(
      bottom: 0,
      left: 5,
      child: Material(
        color: TwitterColor.mystic,
        borderRadius: BorderRadius.circular(100),
        child: Container(
          height: fullHeight(context) * 0.13,
          width: fullWidth(context) * 0.8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            //color: Colors.blueGrey[50]
            // gradient: LinearGradient(
            //   colors: [
            //     Colors.yellow[100].withOpacity(0.3),
            //     Colors.yellow[200].withOpacity(0.1),
            //     Colors.yellowAccent[100].withOpacity(0.2)
            //     // Color(0xfffbfbfb),
            //     // Color(0xfff7f7f7),
            //   ],
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            // ),
          ),
          child: Stack(
            children: [
              frostedYellow(
                Container(
                  height: fullHeight(context) * 0.13,
                  width: fullWidth(context) * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
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
                bottom: 5,
                left: 0,
                //right: 0,
                child: Container(
                  height: fullWidth(context) * 0.15,
                  width: fullWidth(context) * 0.15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.blueGrey[50],
                      gradient: LinearGradient(
                        colors: [
                          Colors.red.withOpacity(0.1),
                          Colors.green.withOpacity(0.2),
                          Colors.blue.withOpacity(0.3)
                          // Color(0xfffbfbfb),
                          // Color(0xfff7f7f7),
                        ],
                        // begin: Alignment.topCenter,
                        // end: Alignment.bottomCenter,
                      )),
                ),
              ),
              Positioned(
                bottom: 0,
                left: fullWidth(context) * 0.1,
                right: 0,
                child: Container(
                  width: fullWidth(context) - 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.blueGrey[50],
                      gradient: LinearGradient(
                        colors: [
                          Colors.yellow.withOpacity(0.1),
                          Colors.green.withOpacity(0.2),
                          Colors.grey.withOpacity(0.3)
                          // Color(0xfffbfbfb),
                          // Color(0xfff7f7f7),
                        ],
                        // begin: Alignment.topCenter,
                        // end: Alignment.bottomCenter,
                      )),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {},
                            child: Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.blueGrey[50],
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.yellow.withOpacity(0.1),
                                          Colors.white60.withOpacity(0.2),
                                          Colors.white60.withOpacity(0.3)
                                          // Color(0xfffbfbfb),
                                          // Color(0xfff7f7f7),
                                        ],
                                        // begin: Alignment.topCenter,
                                        // end: Alignment.bottomCenter,
                                      )),
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: customText(
                                      'Healing',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_back_ios_outlined,
                                  color: Colors.orange,
                                )
                              ],
                            ),
                          ),
                        ),
                        frostedBlack(
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.blueGrey[50],
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.6),
                                  Colors.black.withOpacity(0.7),
                                  Colors.black.withOpacity(0.8)
                                  // Color(0xfffbfbfb),
                                  // Color(0xfff7f7f7),
                                ],
                                // begin: Alignment.topCenter,
                                // end: Alignment.bottomCenter,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: UrlText(
                                text:
                                    'its all about Jesus. just know he loves you',
                                onHashTagPressed: (tag) {
                                  cprint(tag);
                                },
                                style: const TextStyle(
                                  color: Colors.white,
                                  // fontSize: descriptionFontSize,
                                  //fontWeight: descriptionFontWeight
                                ),
                                urlStyle: const TextStyle(
                                  color: Colors.blue,
                                  // fontSize: descriptionFontSize,
                                  // fontWeight: descriptionFontWeight),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ));
}

Positioned adsBottom(BuildContext context) {
  return Positioned(
      bottom: 0,
      left: 10,
      child: SizedBox(
        height: fullWidth(context) * 0.3,
        width: fullWidth(context) * 0.8,
        child: Stack(
          children: [
            Positioned(
              bottom: 5,
              left: 0,
              //right: 0,
              child: Container(
                height: fullWidth(context) * 0.15,
                width: fullWidth(context) * 0.15,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.blueGrey[50],
                    gradient: LinearGradient(
                      colors: [
                        Colors.red.withOpacity(0.1),
                        Colors.green.withOpacity(0.2),
                        Colors.blue.withOpacity(0.3)
                        // Color(0xfffbfbfb),
                        // Color(0xfff7f7f7),
                      ],
                      // begin: Alignment.topCenter,
                      // end: Alignment.bottomCenter,
                    )),
              ),
            ),
            Positioned(
              bottom: 0,
              left: fullWidth(context) * 0.1,
              right: 0,
              child: Container(
                width: fullWidth(context) - 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.blueGrey[50],
                    gradient: LinearGradient(
                      colors: [
                        Colors.yellow.withOpacity(0.1),
                        Colors.red.withOpacity(0.2),
                        Colors.grey.withOpacity(0.3)
                        // Color(0xfffbfbfb),
                        // Color(0xfff7f7f7),
                      ],
                      // begin: Alignment.topCenter,
                      // end: Alignment.bottomCenter,
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {},
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.blueGrey[50],
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.yellow.withOpacity(0.1),
                                        Colors.white60.withOpacity(0.2),
                                        Colors.white60.withOpacity(0.3)
                                        // Color(0xfffbfbfb),
                                        // Color(0xfff7f7f7),
                                      ],
                                      // begin: Alignment.topCenter,
                                      // end: Alignment.bottomCenter,
                                    )),
                                child: Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: customText(
                                    'Healing',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.arrow_back_ios_outlined,
                                color: Colors.orange,
                              )
                            ],
                          ),
                        ),
                      ),
                      frostedBlack(
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: UrlText(
                            text: 'its all about Jesus. just know he loves you',
                            onHashTagPressed: (tag) {
                              cprint(tag);
                            },
                            style: const TextStyle(
                              color: Colors.black,
                              // fontSize: descriptionFontSize,
                              //fontWeight: descriptionFontWeight
                            ),
                            urlStyle: const TextStyle(
                              color: Colors.blue,
                              // fontSize: descriptionFontSize,
                              // fontWeight: descriptionFontWeight),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            // ClipPath(
            //   clipper: PictureClipper(),
            //   child: Container(
            //     color: Colors.grey,
            //     height: fullWidth(context) * 0.2,
            //     width: fullWidth(context) * 0.2,
            //   ),
            // ),
            // Positioned(
            //   bottom: 0,
            //   left: 0,
            //   right: 0,
            //   child: ClipPath(
            //     clipper: BackgroundClipper(),
            //     child: Material(
            //       elevation: 20,
            //       color: TwitterColor.mystic,
            //       child: frostedYellow(
            //         Container(
            //           // decoration: BoxDecoration(
            //           //   // borderRadius: BorderRadius.circular(100),
            //           //   //color: Colors.blueGrey[50]
            //           //   gradient: LinearGradient(
            //           //     colors: [
            //           //       Colors.red[100].withOpacity(0.5),
            //           //       Colors.teal[200].withOpacity(0.1),
            //           //       Colors.yellowAccent[100].withOpacity(0.2)
            //           //       // Color(0xfffbfbfb),
            //           //       // Color(0xfff7f7f7),
            //           //     ],
            //           //     begin: Alignment.topCenter,
            //           //     end: Alignment.bottomCenter,
            //           //   ),
            //           // ),
            //           height: fullWidth(context) * 0.17,
            //           width: fullWidth(context) * 0.8,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ));
}

Widget customListTile(BuildContext context,
    {Widget? title,
    required Widget subtitle,
    Widget? leading,
    Widget? trailing,
    Function? onTap}) {
  return customInkWell(
    context: context,
    onPressed: () {
      if (onTap != null) {
        onTap();
      }
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 40,
            height: 40,
            child: leading,
          ),
          const SizedBox(
            width: 20,
          ),
          SizedBox(
            width: fullWidth(context) - 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(child: title ?? Container()),
                    trailing ?? Container(),
                  ],
                ),
                subtitle
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    ),
  );
}

openImagePicker(BuildContext context, Function onImageSelected) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        height: 100,
        padding: const EdgeInsets.all(10),
        child:
            // HybridImagePicker(
            //   title: authState.user.displayName,
            //   //callback: getImage(context, ImageSource.gallery, onImageSelected),
            // )

            Column(
          children: <Widget>[
            const Text(
              'Pick an image',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextButton(
                    // color: Theme.of(context).primaryColor,
                    child: Text(
                      'Use Camera',
                      style:
                          TextStyle(color: Theme.of(context).backgroundColor),
                    ),
                    onPressed: () {
                      getImage(context, ImageSource.camera, onImageSelected);
                    },
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextButton(
                    // color: Theme.of(context).primaryColor,
                    child: Text(
                      'Use Gallery',
                      style:
                          TextStyle(color: Theme.of(context).backgroundColor),
                    ),
                    onPressed: () {
                      getImage(context, ImageSource.gallery, onImageSelected);
                    },
                  ),
                )
              ],
            )
          ],
        ),
      );
    },
  );
}

getImage(BuildContext context, ImageSource source, Function onImageSelected) {
  // ignore: invalid_use_of_visible_for_testing_member
  ImagePicker.platform.pickImage(source: source, imageQuality: 50).then((file) {
    onImageSelected(File(file!.path));
    Navigator.pop(context);
  });
}

class ShoppingBagExpandedList extends StatefulWidget {
  final Map<dynamic, dynamic> item;
  final Function(String? colorName) colorList;
  final Function(Map items) openParticularItem;
  final Function(BuildContext context, Map item) removeItemAlertBox;

  const ShoppingBagExpandedList(this.item, this.colorList,
      this.openParticularItem, this.removeItemAlertBox,
      {Key? key})
      : super(key: key);
  @override
  _ShoppingBagExpandedListState createState() =>
      _ShoppingBagExpandedListState();
}

class _ShoppingBagExpandedListState extends State<ShoppingBagExpandedList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: Column(
                      children: <Widget>[
                        const Text(
                          'Size',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0),
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          widget.item['selectedSize'].toString().isEmpty
                              ? 'None'
                              : widget.item['selectedSize'],
                          style: const TextStyle(
                              fontSize: 18.0, letterSpacing: 1.0),
                        )
                      ],
                    )),
              ),
              Expanded(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: Column(
                      children: <Widget>[
                        const Text(
                          'Color',
                          style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0),
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          widget.colorList(widget.item['selectedColor']),
                          style: const TextStyle(fontSize: 18.0),
                        )
                      ],
                    )),
              ),
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: Column(
                    children: <Widget>[
                      const Text(
                        'Quantity',
                        style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        "${widget.item['quantity']}",
                        style: const TextStyle(fontSize: 18.0),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 7.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Ink(
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.indigoAccent, width: 4.0),
                      color: Colors.indigo[900],
                      shape: BoxShape.circle),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20.0),
                    onTap: () {
                      widget.openParticularItem(widget.item);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.edit,
                        size: 25.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5.0),
                Ink(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 4.0),
                      color: Colors.red[900],
                      shape: BoxShape.circle),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20.0),
                    onTap: () {
                      widget.removeItemAlertBox(context, widget.item);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Icon(
                        Icons.remove_shopping_cart,
                        size: 25.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

enum CustomTransitionType { upToDown, downToUp }

class CustomTransition<T> extends PageRouteBuilder<T> {
  final Widget child;
  final CustomTransitionType type;
  final Curve curve;
  final Alignment? alignment;
  final Duration duration;

  CustomTransition(
      {Key? key,
      required this.child,
      required this.type,
      this.curve = Curves.linear,
      this.alignment,
      this.duration = const Duration(milliseconds: 500)})
      : super(
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              return child;
            },
            transitionDuration: duration,
            transitionsBuilder: (BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child) {
              switch (type) {
                case CustomTransitionType.downToUp:
                  return SlideTransition(
                    transformHitTests: false,
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 1.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset.zero,
                        end: const Offset(0.0, -1.0),
                      ).animate(secondaryAnimation),
                      child: child,
                    ),
                  );

                case CustomTransitionType.upToDown:
                  return SlideTransition(
                    transformHitTests: false,
                    position: Tween<Offset>(
                      begin: const Offset(0.0, -1.0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset.zero,
                        end: const Offset(0.0, 1.0),
                      ).animate(secondaryAnimation),
                      child: child,
                    ),
                  );

                default:
                  return FadeTransition(opacity: animation, child: child);
              }
            });
}

class PictureClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    //path.moveTo(0, size.height * 0.4);
    path.lineTo(0, size.height - 20);
    // path.quadraticBezierTo(0, size.height, 20, size.height);
    path.lineTo(size.width, size.height);
    path.quadraticBezierTo(0, 0, 20, size.height);
    // path.quadraticBezierTo(
    //     size.width, size.height, size.width, size.height - 20);
    path.lineTo(size.width - 20, size.height * 0.4);
    path.quadraticBezierTo(0, 20, 0, size.height * 0.6);
    // path.lineTo(size.width, size.height * 0.1);
    // path.quadraticBezierTo(0, 0, 0, size.height - 20);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class BackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, size.height * 0.4);
    path.lineTo(0, size.height - 20);
    path.quadraticBezierTo(0, size.height, 20, size.height);
    path.lineTo(size.width - 20, size.height);
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - 20);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.1);
    path.quadraticBezierTo(0, 0, 0, size.height - 20);
    //path.lineTo(size.width - 20, size.height - 20);
    // path.moveTo(size.width * 0.8, size.height * 0.2);
    // path.lineTo(size.width * 0.8, 0);
    // path.lineTo(size.width, 20);
    //path.quadraticBezierTo(size.width - 20, 0, size.width, size.height * 0.6);
    // path.lineTo(size.width * 0.4, 0);
    //  path.quadraticBezierTo(size.width * 0.8, 0, size.width, size.height * 0.8);

    return path;
    //throw UnimplementedError();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

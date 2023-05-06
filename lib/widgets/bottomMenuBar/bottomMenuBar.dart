// import 'package:fancy_bottom_navigation/internal/tab_item.dart';
// ignore_for_file: unused_field, file_names

// import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:numeral/numeral.dart';
import 'package:viewducts/apis/auth_api.dart';
import 'package:viewducts/features/auth/controller/auth_controller.dart';
import 'package:viewducts/features/products/product_controller.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/page/homePage.dart';

// import 'package:viewducts/appState/appState.dart';
import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/bottomMenuBar/tabItem.dart';
import 'package:viewducts/widgets/frosted.dart';
import 'package:viewducts/widgets/newWidget/title_text.dart';
import '../customWidgets.dart';
import 'package:get/get.dart';

// import 'customBottomNavigationBar.dart';

// ignore: must_be_immutable
class SideMenubar extends ConsumerStatefulWidget {
  int sideBarindex;
  final bool isDesktop;
  SideMenubar({
    Key? key,
    this.isDesktop = false,
    this.sideBarindex = 0,
  }) : super(key: key);

  @override
  ConsumerState<SideMenubar> createState() => _SideMenubarState();
}

class _SideMenubarState extends ConsumerState<SideMenubar> {
//   _SideMenubarState createState() => _SideMenubarState();
  var _selectedIcon = 0;

  // @override
  barIndex(BuildContext contex) {}
  @override
  Widget build(BuildContext context) {
    final cartList = ref
            .watch(getProductInCartProvider(ref
                    .watch(currentUserDetailsProvider)
                    .value
                    ?.userId
                    .toString() ??
                ''))
            .value
            ?.length ??
        0;
    // }
    // RxList<ChatMessage> chatUserList = RxList<ChatMessage>();

    // final shoppinfState = useState(userCartController.shoppingCartAppState);
    // final chatSetState = useState(chatUserList);

    Widget _icon(Widget iconData, int index,
        {bool isCustomIcon = false,
        int? icon,
        bool isCart = false,
        String? text}) {
      return Expanded(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: AnimatedAlign(
            duration: const Duration(milliseconds: ANIM_DURATION),
            curve: Curves.easeIn,
            alignment: const Alignment(0, ICON_ON),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: ANIM_DURATION),
              opacity: ALPHA_ON,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  isCart == true
                      ? index == ref.read(numberProvider.notifier).state
                          ? Container()
                          // : authState.networkConnectionState.value ==
                          //         'Not Connected'
                          //     ? Container()
                          : cartList > 0
                              ? ref.read(numberProvider.notifier).state == 1
                                  ? Container()
                                  : Container(
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                offset: const Offset(0, 11),
                                                blurRadius: 11,
                                                color: Colors.black
                                                    .withOpacity(0.06))
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          color: CupertinoColors.systemRed),
                                      padding: const EdgeInsets.all(2.0),
                                      child: TitleText(
                                        'Cart',
                                        color:
                                            CupertinoColors.lightBackgroundGray,
                                        // ignore: unnecessary_null_comparison
                                      ))
                              : cartList == 0
                                  ? Container()
                                  : Container()
                      : Container(),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.blueGrey[50],
                      gradient: index == ref.read(numberProvider.notifier).state
                          ? LinearGradient(
                              colors: [
                                CupertinoColors.lightBackgroundGray,
                                CupertinoColors.lightBackgroundGray
                                    .withOpacity(0.7),
                                CupertinoColors.lightBackgroundGray
                                // Color(0xfffbfbfb),
                                // Color(0xfff7f7f7),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            )
                          : LinearGradient(
                              colors: [
                                Colors.white70.withOpacity(0.1),
                                Colors.white70.withOpacity(0.2),
                                Colors.white70.withOpacity(0.3)
                                // Color(0xfffbfbfb),
                                // Color(0xfff7f7f7),
                              ],
                              // begin: Alignment.topCenter,
                              // end: Alignment.bottomCenter,
                            ),
                    ),
                    child: Padding(
                      padding: index == ref.read(numberProvider.notifier).state
                          ? const EdgeInsets.all(8.0)
                          : const EdgeInsets.all(2),
                      child: CircleAvatar(
                        backgroundColor:
                            index == ref.read(numberProvider.notifier).state
                                ? Colors.transparent
                                : Colors.transparent,
                        radius: index == ref.read(numberProvider.notifier).state
                            ? 20
                            : 15,
                        child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          padding: const EdgeInsets.all(0),
                          alignment: const Alignment(0, 0),
                          icon: isCustomIcon
                              ? customIcon(Get.context,
                                  icon: icon!,
                                  size: index ==
                                          ref
                                              .read(numberProvider.notifier)
                                              .state
                                      ? 30
                                      : 22,
                                  istwitterIcon: true,
                                  isEnable: index ==
                                      ref.read(numberProvider.notifier).state)
                              : CircleAvatar(
                                  radius: index ==
                                          ref
                                              .read(numberProvider.notifier)
                                              .state
                                      ? Get.height * 0.03
                                      : Get.height * 0.016,
                                  backgroundColor: Colors.transparent,
                                  child: iconData,
                                ),
                          //  Icon(
                          //     iconData,
                          //     color: index == widget. sideBarindex
                          //         ? Theme.of(context).primaryColor
                          //         : Theme.of(context).textTheme.caption.color,
                          //   ),
                          onPressed: () {
                            setState(() {
                              _selectedIcon = index;
                              ref.read(numberProvider.notifier).state = index;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  // index == widget. sideBarindex
                  //     ? Text('')
                  //     : Container(
                  //         decoration: BoxDecoration(
                  //             boxShadow: [
                  //               BoxShadow(
                  //                   offset: const Offset(0, 11),
                  //                   blurRadius: 11,
                  //                   color: Colors.black.withOpacity(0.06))
                  //             ],
                  //             borderRadius: BorderRadius.circular(5),
                  //             color: CupertinoColors.lightBackgroundGray),
                  //         padding: const EdgeInsets.all(5.0),
                  //         child: customText(
                  //           text ?? '',
                  //           style: const TextStyle(
                  //               color: CupertinoColors.darkBackgroundGray,
                  //               fontFamily: 'Roboto-Regular',
                  //               fontWeight: FontWeight.bold),
                  //         ),
                  //       )
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget _iconDesktop(Widget iconData, int index,
        {bool isCustomIcon = false, int? icon}) {
      return Expanded(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: AnimatedAlign(
            duration: const Duration(milliseconds: ANIM_DURATION),
            curve: Curves.easeIn,
            alignment: const Alignment(0, ICON_ON),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: ANIM_DURATION),
              opacity: ALPHA_ON,
              child: Material(
                elevation: 20,
                borderRadius: BorderRadius.circular(100),
                color: Colors.transparent,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      index == 0
                          ? Row(
                              children: [
                                userCartController.shoppingCartAppState.length >
                                        0
                                    ? Badge(
                                        backgroundColor: Colors.red,
                                        label: Text(
                                          Numeral(int.parse(
                                            '${userCartController.chatListUnreadMessage.length + userCartController.shoppingCartAppState.length}',
                                          )).format(),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        child: ref
                                                    .read(
                                                        numberProvider.notifier)
                                                    .state ==
                                                1
                                            ? Container()
                                            : Container(
                                                decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                          offset: const Offset(
                                                              0, 11),
                                                          blurRadius: 11,
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.06))
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18),
                                                    color: CupertinoColors
                                                        .systemRed),
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: TitleText(
                                                  'Cart',
                                                  color: CupertinoColors
                                                      .lightBackgroundGray,
                                                )),
                                      )
                                    : Container(),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Badge(child: Text("Chats")),
                                ),
                              ],
                            )
                          : index == 1
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("Ducts"),
                                )
                              : index == 2
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Market"),
                                    )
                                  : index == 3
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("Search"),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("Board"),
                                        ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blueGrey[50],
                          gradient:
                              index == ref.read(numberProvider.notifier).state
                                  ? LinearGradient(
                                      colors: [
                                        Colors.yellow.withOpacity(0.7),
                                        Colors.yellow.withOpacity(0.8),
                                        Colors.yellow.withOpacity(0.9)
                                        // Color(0xfffbfbfb),
                                        // Color(0xfff7f7f7),
                                      ],
                                      // begin: Alignment.topCenter,
                                      // end: Alignment.bottomCenter,
                                    )
                                  : LinearGradient(
                                      colors: [
                                        Colors.white70.withOpacity(0.1),
                                        Colors.white70.withOpacity(0.2),
                                        Colors.white70.withOpacity(0.3)
                                        // Color(0xfffbfbfb),
                                        // Color(0xfff7f7f7),
                                      ],
                                      // begin: Alignment.topCenter,
                                      // end: Alignment.bottomCenter,
                                    ),
                        ),
                        child: frostedOrange(
                          Padding(
                            padding:
                                index == ref.read(numberProvider.notifier).state
                                    ? const EdgeInsets.all(4.0)
                                    : const EdgeInsets.all(2),
                            child: CircleAvatar(
                              backgroundColor: index ==
                                      ref.read(numberProvider.notifier).state
                                  ? Colors.transparent
                                  : Colors.transparent,
                              radius: index ==
                                      ref.read(numberProvider.notifier).state
                                  ? 20
                                  : 15,
                              child: IconButton(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                padding: const EdgeInsets.all(0),
                                alignment: const Alignment(0, 0),
                                icon: isCustomIcon
                                    ? customIcon(Get.context,
                                        icon: icon!,
                                        size: index ==
                                                ref
                                                    .read(
                                                        numberProvider.notifier)
                                                    .state
                                            ? 30
                                            : 22,
                                        istwitterIcon: true,
                                        isEnable: index ==
                                            ref
                                                .read(numberProvider.notifier)
                                                .state)
                                    : CircleAvatar(
                                        radius: index ==
                                                ref
                                                    .read(
                                                        numberProvider.notifier)
                                                    .state
                                            ? Get.height * 0.02
                                            : Get.height * 0.016,
                                        backgroundColor: Colors.transparent,
                                        child: iconData,
                                      ),
                                //  Icon(
                                //     iconData,
                                //     color: index == widget. sideBarindex
                                //         ? Theme.of(context).primaryColor
                                //         : Theme.of(context).textTheme.caption.color,
                                //   ),
                                onPressed: () {
                                  _selectedIcon = index;
                                  appState.setpageIndex = index;
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    Widget _iconRow() {
      return Container(
        width: 0 == ref.read(numberProvider.notifier).state
            ? Get.height * 0.1
            :
            // 4 == widget. sideBarindex
            //     ? Get.height * 0.08
            //     :
            Get.height * 0.12,
        height: Get.height * 0.5,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _icon(
              isCart: true,
              0 == ref.read(numberProvider.notifier).state
                  ? Stack(
                      children: [
                        Image.asset(
                          'assets/message.png',
                          width: 50,
                        ),
                      ],
                    )
                  : Stack(
                      children: [
                        // userCartController.chatListUnreadMessage.length > 0 ||

                        cartList > 0
                            ?
                            // authState.networkConnectionState.value ==
                            //         'Not Connected'
                            //     ? Image.asset(
                            //         'assets/message.png',
                            //       )
                            //     :
                            Badge(
                                backgroundColor: Colors.red,
                                // position:
                                //     BadgePosition.topStart(top: -2, start: -4),
                                label: Text(
                                  Numeral(int.parse(
                                    '${cartList}',
                                  )).format(),
                                  style: TextStyle(color: Colors.white),
                                ),
                                child: Image.asset(
                                  'assets/vchat.png',
                                  width: 50,
                                ),
                              )
                            : Image.asset(
                                'assets/vchat.png',
                              ),
                      ],
                    ),
              0,
              //shopping-bag
              //icon: 0 == widget. sideBarindex ? AppIcon.homeFill : AppIcon.home,
              isCustomIcon: false,
              // text: 0 == widget. sideBarindex ? '' : 'Chats'
            ),
            _icon(
                1 == ref.read(numberProvider.notifier).state
                    ? Lottie.asset(
                        'assets/lottie/cool-sticker.json',
                      )
                    : Image.asset(
                        'assets/plus.png',
                      ),
                1,
                // icon:
                //     1 == widget. sideBarindex ? AppIcon.searchFill : AppIcon.search,
                isCustomIcon: false,
                text: 1 == ref.read(numberProvider.notifier).state
                    ? ''
                    : 'Ducts'),
            _icon(
              2 == ref.read(numberProvider.notifier).state
                  ? Lottie.asset(
                      'assets/lottie/mobile-shopping.json',
                    )
                  : Image.asset(
                      'assets/home 1.png',
                    ),
              2,
              // icon: 2 == widget. sideBarindex
              //     ? AppIcon.notificationFill
              //     : AppIcon.notification,
              isCustomIcon: false,
              // text: 2 == widget. sideBarindex ? '' : 'Market'
            ),
            _icon(
              3 == ref.read(numberProvider.notifier).state
                  ? Lottie.asset(
                      'assets/lottie/search.json',
                    )
                  : Image.asset(
                      'assets/vsearch.png',
                    ),
              3,
              // icon: 3 == widget. sideBarindex
              //     ? AppIcon.messageFill
              //     : AppIcon.messageEmpty,
              isCustomIcon: false,
              // text: 3 == widget. sideBarindex ? '' : 'Search'
            ),
            _icon(
              4 == ref.read(numberProvider.notifier).state
                  ? Lottie.asset(
                      'assets/lottie/discount.json',
                    )
                  : Image.asset(
                      'assets/package.png',
                      fit: BoxFit.cover,
                      // color: Colors.purple,
                    ),
              4,
              isCustomIcon: false,
              // text: 4 == widget. sideBarindex ? '' : 'DBoard'
            ),
          ],
        ),
      );
    }

    Widget _iconRowDesktop() {
      return Container(
        width: Get.width * 0.3,
        height: Get.height * 0.5,
        decoration: const BoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _iconDesktop(
                  0 == ref.read(numberProvider.notifier).state
                      ? Lottie.asset(
                          'assets/lottie/cool-sticker.json',
                        )
                      : Stack(
                          children: [
                            userCartController.userSeenCart.value.state ==
                                    'added'
                                ? Badge(
                                    backgroundColor: Colors.red,
                                    // position: BadgePosition.bottomStart(
                                    //     bottom: -2, start: -4),
                                    label: const Text(
                                      '1',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    child: Image.asset(
                                      'assets/cool.png',
                                      width: 50,
                                    ),
                                  )
                                : Image.asset(
                                    'assets/cool.png',
                                  ),
                          ],
                        ),
                  0,
                  //icon: 0 == widget. sideBarindex ? AppIcon.homeFill : AppIcon.home,
                  isCustomIcon: false),
              _iconDesktop(
                  1 == ref.read(numberProvider.notifier).state
                      ? Lottie.asset(
                          'assets/lottie/discount.json',
                        )
                      : Image.asset(
                          'assets/shopping-bag.png',
                        ),
                  1,
                  // icon:
                  //     1 == widget. sideBarindex ? AppIcon.searchFill : AppIcon.search,
                  isCustomIcon: false),
              _iconDesktop(
                  2 == ref.read(numberProvider.notifier).state
                      ? Lottie.asset(
                          'assets/lottie/mobile-shopping.json',
                          width: 20,
                        )
                      : Image.asset(
                          'assets/home 1.png',
                        ),
                  2,
                  // icon: 2 == widget. sideBarindex
                  //     ? AppIcon.notificationFill
                  //     : AppIcon.notification,
                  isCustomIcon: false),
              _iconDesktop(
                  3 == ref.read(numberProvider.notifier).state
                      ? Lottie.asset(
                          'assets/lottie/search.json',
                        )
                      : Image.asset(
                          'assets/search.png',
                        ),
                  3,
                  // icon: 3 == widget. sideBarindex
                  //     ? AppIcon.messageFill
                  //     : AppIcon.messageEmpty,
                  isCustomIcon: false),
              _iconDesktop(
                  4 == ref.read(numberProvider.notifier).state
                      ? Image.asset('assets/dashboard.png')
                      : Image.asset(
                          'assets/books.png',
                          fit: BoxFit.cover,
                          // color: Colors.purple,
                        ),
                  4,
                  isCustomIcon: false),
            ],
          ),
        ),
      );
    }

    if (widget.isDesktop == true) {
      return Stack(
        children: [
          Positioned(top: 0, left: 0, right: 0, child: _iconRowDesktop()),
        ],
      );
    } else {
      return _iconRow();
    }
  }
}

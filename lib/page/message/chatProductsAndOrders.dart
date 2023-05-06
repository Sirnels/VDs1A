// ignore_for_file: file_names, unused_element

import 'package:flutter/material.dart';
import 'package:viewducts/helper/constant.dart';
import 'package:viewducts/helper/enum.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/page/message/chatScreenPage.dart';
import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/duct/widgets/ductImage.dart';
import 'package:viewducts/widgets/frosted.dart';

class ChatProductsAndOrders extends StatefulWidget {
  final ImageIcon? imageIcon;
  final String? text;
  final String? userProfileId;

  const ChatProductsAndOrders(
      {Key? key, this.imageIcon, this.text, this.userProfileId})
      : super(key: key);
  @override
  _ChatProductsAndOrdersState createState() => _ChatProductsAndOrdersState();
}

class _ChatProductsAndOrdersState extends State<ChatProductsAndOrders>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  GlobalKey? actionKey;
  bool isDropdown = false;
  double? height, width, xPosiion, yPosition;
  late OverlayEntry floatingMenu;
  late ViewductsUser models;
  @override
  void initState() {
    super.initState();
    actionKey = LabeledGlobalKey(widget.text);
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1));
  }

  _playAnimation() {
    _controller.reset();
    _controller.forward();
  }

  void _postProsductoption() {
    RenderBox renderBox =
        actionKey!.currentContext!.findRenderObject() as RenderBox;
    height = renderBox.size.height;
    width = renderBox.size.width;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    xPosiion = offset.dx;
    yPosition = offset.dy;
  }

  OverlayEntry _createPostMenu() {
    var appSize = MediaQuery.of(context).size;
    // var state = Provider.of<ChatState>(context, listen: false);
    // double heightFactor = 300 / fullHeight(context);
    // var authstate = Provider.of<AuthState>(context, listen: false);
    // var feedState = Provider.of<FeedState>(context, listen: false);

    //  var userImage = chatState.chatUser.value.profilePic;
    String? id = widget.userProfileId ?? chatState.chatUser!.userId;
    List<FeedModel>? list;

    if (feedState.feedlist != null && feedState.feedlist!.isNotEmpty) {
      list = feedState
          .getStoreProductList(models.userId)!
          .where((x) => x.userId == id)
          .toList();
    }
    FeedModel? model;
    return OverlayEntry(
      builder: (context) {
        return FutureBuilder(
          future: _playAnimation(),
          //initialData: InitialData,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isDropdown) {
                    floatingMenu.remove();
                  } else {
                    _postProsductoption();
                    floatingMenu = _createPostMenu();
                    Overlay.of(context).insert(floatingMenu);
                  }

                  isDropdown = !isDropdown;
                });
              },
              child: Container(
                height: appSize.width,
                width: appSize.width,
                color: Colors.transparent,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: appSize.width * 0.2,
//                        right: xPosiion - appSize.width * 0.5,
                      right: xPosiion,
                      // width: width,
                      // height: 4 + height + 40,
                      child: SizedBox(
                        //  height: appSize.width * 0.4,
                        width: appSize.width,
                        child: Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    frostedPink(
                                      SizedBox(
                                        width: fullWidth(context) * 0.8,
                                        height: fullWidth(context) * 0.3,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          addAutomaticKeepAlives: false,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemBuilder: (context, index) =>
                                              Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                                height:
                                                    fullWidth(context) * 0.3,
                                                width: fullWidth(context) * 0.2,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 12.0),
                                                  child: _Orders(
                                                      list: list![index],
                                                      //   isSelected: isSelected,
                                                      model: model),
                                                )),
                                          ),
                                          itemCount: list?.length ?? 0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  children: [
                                    frostedTeal(
                                      SizedBox(
                                        width: fullWidth(context) * 0.8,
                                        height: fullWidth(context) * 0.3,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          addAutomaticKeepAlives: false,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemBuilder: (context, index) =>
                                              Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                                height:
                                                    fullWidth(context) * 0.3,
                                                width: fullWidth(context) * 0.2,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 12.0),
                                                  child: _Orders(
                                                      list: list![index],
                                                      //   isSelected: isSelected,
                                                      model: model),
                                                )),
                                          ),
                                          itemCount: list?.length ?? 0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget? child;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: actionKey,
      onTap: () {
        setState(() {
          if (isDropdown) {
            floatingMenu.remove();
          } else {
            _postProsductoption();
            floatingMenu = _createPostMenu();
            Overlay.of(context).insert(floatingMenu);
          }

          isDropdown = !isDropdown;
        });
        //  Navigator.of(context).pushNamed('/CreateFeedPage/tweet');
      },
      child: customButton(
        'All Orders',
        Image.asset('assets/trolley.png'),
      ),
    );
  }
}

class _Orders extends StatefulWidget {
  const _Orders({
    Key? key,
    required this.model,
    this.list,
    this.type,
  }) : super(key: key);

  final FeedModel? model;
  final FeedModel? list;
  final DuctType? type;

  @override
  __OrdersState createState() => __OrdersState();
}

class __OrdersState extends State<_Orders> {
  @override
  Widget build(BuildContext context) {
    return DuctImage(
      model: widget.list,
      type: widget.type,
    );
  }
}

class ModalTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Function? onTap;

  const ModalTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: CustomTile(
        mini: false,
        onTap: onTap as void Function()?,
        leading: Container(
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: UniversalVariables.receiverColor,
          ),
          padding: const EdgeInsets.all(10),
          child: Icon(
            icon,
            color: UniversalVariables.greyColor,
            size: 38,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: UniversalVariables.greyColor,
            fontSize: 14,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

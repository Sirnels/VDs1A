// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/frosted.dart';

class MyOrders extends StatefulWidget {
  final ImageIcon? imageIcon;
  final String? text;

  const MyOrders({Key? key, this.imageIcon, this.text}) : super(key: key);
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  GlobalKey? actionKey;
  bool isDropdown = false;
  late double height, width, xPosiion, yPosition;
  late OverlayEntry floatingMenu;
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

  void _navigateTo(String path) {
    // Navigator.pop(context);
    Navigator.of(context).pushNamed('/$path');
  }

  OverlayEntry _createPostMenu() {
    var appSize = MediaQuery.of(context).size;
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
              child: frostedWhite(
                SizedBox(
                  height: appSize.width,
                  width: appSize.width,
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: appSize.width * 0.2,
                        right: xPosiion - appSize.width * 0.65,
                        //right: xPosiion,
                        // width: width,
                        // height: 4 + height + 40,
                        child: Material(
                          elevation: 5,
                          color: Colors.yellow[50],
                          borderRadius: BorderRadius.circular(20),
                          child: frostedYellow(
                            SizedBox(
                              //  height: appSize.width * 0.4,
                              width: appSize.width * 0.5,
                              child: Stack(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Divider(),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (isDropdown) {
                                              floatingMenu.remove();
                                            } else {
                                              _postProsductoption();
                                              floatingMenu = _createPostMenu();
                                              Overlay.of(context)
                                                  .insert(floatingMenu);
                                            }

                                            isDropdown = !isDropdown;
                                          });
                                          _navigateTo("Admin");
                                          //Navigator.of(context).pushNamed('Admin');
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: const [
                                              Text(
                                                'Admin',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.teal,
                                                    fontSize: 20),
                                              ),
                                              Icon(CupertinoIcons.forward),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Divider(),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (isDropdown) {
                                              floatingMenu.remove();
                                            } else {
                                              _postProsductoption();
                                              floatingMenu = _createPostMenu();
                                              Overlay.of(context)
                                                  .insert(floatingMenu);
                                            }

                                            isDropdown = !isDropdown;
                                          });
                                          Navigator.of(context).pushNamed(
                                              '/CreateFeedPage/tweet');
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: const [
                                              Text(
                                                'Duct A',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                  fontSize: 20,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                'Product',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.teal,
                                                    fontSize: 20),
                                              ),
                                              Icon(CupertinoIcons.forward),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Divider(),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (isDropdown) {
                                              floatingMenu.remove();
                                            } else {
                                              _postProsductoption();
                                              floatingMenu = _createPostMenu();
                                              Overlay.of(context)
                                                  .insert(floatingMenu);
                                            }

                                            isDropdown = !isDropdown;
                                          });
                                          //   Navigator.of(context).pushNamed('/CreateFeedPage/tweet');
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: const [
                                              Text(
                                                'List',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red,
                                                  fontSize: 20,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                'Product',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.teal,
                                                    fontSize: 20),
                                              ),
                                              Icon(CupertinoIcons.forward),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Divider()
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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

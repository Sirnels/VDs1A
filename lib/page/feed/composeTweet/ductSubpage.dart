// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:viewducts/model/product.dart';
import 'package:viewducts/state/appState.dart';
import 'package:viewducts/state/stateController.dart';

import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/frosted.dart';
import 'package:viewducts/widgets/tabText.dart';

class DuctSubPage extends StatefulWidget {
  const DuctSubPage({Key? key}) : super(key: key);

  @override
  _DuctSubPageState createState() => _DuctSubPageState();
}

class _DuctSubPageState extends State<DuctSubPage>
    with SingleTickerProviderStateMixin {
  int pageIndex = 0;
  TabController? _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var appSize = MediaQuery.of(context).size;
    // var authstate = Provider.of<AuthState>(context, listen: false);
    return Consumer<AppState>(
      builder: (context, value, child) {
        return Container(
          width: fullWidth(context),
          height: fullHeight(context) * 0.8,
          color: Colors.grey[50],
          child: Stack(
            children: <Widget>[
              frostedBlueGray(
                Container(
                  height: appSize.height,
                  width: appSize.width,
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(100),
                    //color: Colors.blueGrey[50]
                    gradient: LinearGradient(
                      colors: [
                        Colors.yellow[300]!.withOpacity(0.3),
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
                top: 0,
                left: 1,
                right: fullWidth(context) * 0.1,
                child: SizedBox(
                  width: fullWidth(context),
                  child: TabBar(
                    isScrollable: true,
                    controller: _tabController,
                    // indicator: TabIndicator(),
                    tabs: [
                      Padding(
                        padding: const EdgeInsets.only(left: 14.0),
                        child: frostedOrange(
                          Row(
                            children: [
                              Material(
                                elevation: 10,
                                borderRadius: BorderRadius.circular(100),
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: Colors.transparent,
                                  child: Image.asset('assets/happy.png'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 3),
                                child: customTitleText('Favourite'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: frostedOrange(
                          Row(
                            children: [
                              Material(
                                elevation: 10,
                                borderRadius: BorderRadius.circular(100),
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: Colors.transparent,
                                  child: Image.asset('assets/shopping.png'),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 3),
                                child: customTitleText('My Orders'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: appSize.width * 0.1,
                child: frostedBlack(
                  Container(
                    height: appSize.height,
                    width: appSize.width,
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
                    child: TabBarView(
                      controller: _tabController,
                      children: const [
                        FavouriteProductPage(),
                        MyOrderPage()
                        // /// Display all independent tweers list
                        // _tweetList(context, authstate, list, false, false),

                        // /// Display all reply tweet list
                        // _tweetList(context, authstate, list, true, false),

                        // /// Display all reply and comments tweet list
                        // _tweetList(context, authstate, list, false, true)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class FavouriteProductPage extends StatelessWidget {
  final Product? product;
  final int? index;
  final bool? lastItem;
  final int? qauntity;
  final NumberFormat? formatter;
  final bool? lastProduct;

  const FavouriteProductPage(
      {Key? key,
      this.product,
      this.lastProduct,
      this.formatter,
      this.index,
      this.lastItem,
      this.qauntity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // AppStateModel model;
    // final productIndex = index - 4;
    var appSize = MediaQuery.of(context).size;

    final row = Consumer<AppState>(
      builder: (context, model, child) {
        return Stack(
          children: <Widget>[
            SizedBox(
              height: 80,
              child: Row(
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 1.2,
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: SizedBox(
                            height: 70,
                            width: 70,
                            child: Stack(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: GestureDetector(
                                    onTap: () {
                                      // Navigator.of(context).push(
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             ProductDetails(
                                      //               product: product,
                                      //               heroTag: product.image,
                                      //             )));
                                    },
                                    child: Material(
                                      borderRadius: BorderRadius.circular(10),
                                      elevation: 30,
                                      child: frostedOrange(
                                        Container(
                                          decoration: BoxDecoration(
                                            //color: LightColor.lightGrey,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: const DecorationImage(
                                                image: AssetImage(
                                                    "assets/happy.png"),
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: frostedRed(
                    ListTile(
                        title: const TitleText(
                          text: 'shoe',
                          //product.name,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                        subtitle: Row(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: GestureDetector(
                                onTap: () {},
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      CupertinoIcons.heart,
                                      size: 30,
                                      color: Colors.blueGrey[900],
                                    ),
                                    Text(
                                      '400',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.red[400]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Row(
                                  children: <Widget>[
                                    ImageIcon(
                                      const AssetImage('assets/comment.png'),
                                      size: 30,
                                      color: Colors.blueGrey[300],
                                    ),
                                    // Text(
                                    //   '4k',
                                    //   style: TextStyle(
                                    //       fontSize: 18,
                                    //       fontWeight: FontWeight.w600,
                                    //       color: Colors.red[600]),
                                    // ),
                                  ],
                                ),
                              ),
                            ),

                            // TitleText(
                            //   text: '${product.price}',
                            //   fontSize: 14,
                            // ),
                          ],
                        ),
                        trailing: Material(
                          elevation: 10,
                          color: Colors.yellow[100]!.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(50),
                          child: frostedYellow(
                            Container(
                              width: 120,
                              height: 35,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  //color: LightColor.lightGrey.withAlpha(150),
                                  borderRadius: BorderRadius.circular(10)),
                              child: const TitleText(
                                text: '500',
                                // 'NGN${product.price}',
                                // '${qauntity > 1 ? '$qauntity x' : ''}'
                                // '${formatter.format(product.price)}',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        )),
                  ))
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: appSize.width * 0.86,
              right: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    // final model = Provider.of<AppState>(context, listen: false);
                    appState.addProductToCart(product!.id);
                  },
                  child: Icon(
                    CupertinoIcons.add_circled_solid,
                    size: 30,
                    color: Colors.blueGrey[900],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
    // if (lastProduct) {
    //   return row;
    // }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
      child: row,
    );
  }
}

class MyOrderPage extends StatelessWidget {
  final Product? product;
  final int? index;
  final bool? lastItem;
  final int? qauntity;
  final NumberFormat? formatter;
  final bool? lastProduct;

  const MyOrderPage(
      {Key? key,
      this.product,
      this.lastProduct,
      this.formatter,
      this.index,
      this.lastItem,
      this.qauntity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // AppStateModel model;
    // final productIndex = index - 4;
    var appSize = MediaQuery.of(context).size;

    final row = Consumer<AppState>(
      builder: (context, model, child) {
        return Stack(
          children: <Widget>[
            SizedBox(
              height: 80,
              child: Row(
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 1.2,
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: SizedBox(
                            height: 70,
                            width: 70,
                            child: Stack(
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: GestureDetector(
                                    onTap: () {
                                      // Navigator.of(context).push(
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             ProductDetails(
                                      //               product: product,
                                      //               heroTag: product.image,
                                      //             )));
                                    },
                                    child: Material(
                                      borderRadius: BorderRadius.circular(10),
                                      elevation: 30,
                                      child: frostedOrange(
                                        Container(
                                          decoration: BoxDecoration(
                                            //color: LightColor.lightGrey,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: const DecorationImage(
                                                image: AssetImage(
                                                    "assets/smartphone.png"),
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: frostedTeal(
                    ListTile(
                        title: const TitleText(
                          text: 'Iphone',
                          //product.name,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                        subtitle: Row(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: GestureDetector(
                                onTap: () {},
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      CupertinoIcons.heart,
                                      size: 30,
                                      color: Colors.blueGrey[900],
                                    ),
                                    Text(
                                      '400',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.red[400]),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // TitleText(
                            //   text: '${product.price}',
                            //   fontSize: 14,
                            // ),
                          ],
                        ),
                        trailing: Material(
                          elevation: 10,
                          color: Colors.yellow[100]!.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(50),
                          child: frostedYellow(
                            Container(
                              width: 120,
                              height: 35,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  //color: LightColor.lightGrey.withAlpha(150),
                                  borderRadius: BorderRadius.circular(10)),
                              child: const TitleText(
                                text: '500',
                                // 'NGN${product.price}',
                                // '${qauntity > 1 ? '$qauntity x' : ''}'
                                // '${formatter.format(product.price)}',
                                fontSize: 12,
                              ),
                            ),
                          ),
                        )),
                  ))
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: appSize.width * 0.86,
              right: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                    onTap: () {
                      // final model =
                      //     Provider.of<AppState>(context, listen: false);
                      appState.addProductToCart(product!.id);
                    },
                    child: const ImageIcon(AssetImage('assets/comment.png'))),
              ),
            ),
          ],
        );
      },
    );
    // if (lastProduct) {
    //   return row;
    // }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
      child: row,
    );
  }
}

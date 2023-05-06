// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:viewducts/state/authState.dart';
import 'package:viewducts/state/feedState.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  List<dynamic> itemList = <dynamic>[];
  //var itemList;
  @override
  void initState() {
    initListOrdershistory();
    super.initState();
  }

  void initListOrdershistory() async {
    final orderHistory = Provider.of<FeedState>(context, listen: false);
    final auth = Provider.of<AuthState>(context, listen: false);
    List data = await orderHistory.listPlacedOrder(auth.userId);
    setState(() {
      itemList = data;
      // totalPrice = setTotalPrice(data);
      // bagItemList = args['bagItems'];
      // totalPrice = setTotalPrice(args['bagItems']);
      // if (args.containsKey('route')) {
      //   route = args['route'];
      // }
    });
  }
  // void initListOrdershistory() async {
  //   final orderHistory = Provider.of<FeedState>(context, listen: false);
  //   final auth = Provider.of<AuthState>(context, listen: false);
  //   var data = orderHistory.listPlacedOrder(auth.userId);
  //   setState(() {
  //     itemList = data;
  //   });
  // }

  // void listOrderItems(context) async {
  //   Map<dynamic, dynamic> args = ModalRoute.of(context).settings.arguments;

  //   for (var items in args['data']) {
  //     int total = 0;
  //     for (int i = 0; i < items['orderDetails'].length; i++) {
  //       total = total +
  //           items['orderDetails'][i]['quantity'] *
  //               items['orderDetails'][i]['price'];
  //     }
  //     items['totalPrice'] = total.toString();
  //   }
  //   setState(() {
  //     itemList = args['data'];
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    // listOrderItems(context);
    return Scaffold(
      // backgroundColor: Colors.grey[200],
      key: _scaffoldKey,
      //  appBar: header('Orders', _scaffoldKey, showCartIcon, context),
      //     drawer: sidebar(context),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: ListView.builder(
          itemCount: itemList.length,
          itemBuilder: (BuildContext context, int index) {
            List item = itemList[index]['orderDetails'];
            String? totalPrice = itemList[index]['totalPrice'];
            String orderedDate = timeago
                .format(itemList[index]['orderDate'].toDate(), locale: 'fr');
            return Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
              child: Card(
                elevation: 3.0,
                child: Column(
                  children: <Widget>[
                    Container(
                      constraints: const BoxConstraints.expand(height: 200.0),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(item[0]['productImage']),
                              fit: BoxFit.fill,
                              colorFilter: const ColorFilter.mode(
                                  Color.fromRGBO(90, 90, 90, 0.8),
                                  BlendMode.modulate))),
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                'Ordered $orderedDate',
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white,
                                    letterSpacing: 1.0),
                              ),
                            ),
                          ),
                          const Center(
                            child: Text(
                              'Order Placed',
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: 'Novasquare',
                                letterSpacing: 1.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: item.length,
                      itemBuilder: (BuildContext context, int itemIndex) {
                        return ListTile(
                          leading: CircleAvatar(
                            radius: 30.0,
                            backgroundImage: NetworkImage(
                              item[itemIndex]['productImage'],
                            ),
                          ),
                          title: Text(
                            item[itemIndex]['productName'],
                            style: const TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            "\$ ${item[itemIndex]['price']}.00",
                            style: const TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w500),
                          ),
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          "Total: \$ $totalPrice.00",
                          style: const TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        ButtonTheme(
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(7.0))),
                          height: 50.0,
                          minWidth: 160.0,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              'REORDER',
                              style: TextStyle(
                                fontSize: 17.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10.0)
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

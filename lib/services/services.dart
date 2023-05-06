// ignore_for_file: deprecated_member_use, avoid_unnecessary_containers

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/feedModel.dart';

import 'package:viewducts/page/profile/shippingAdress.dart';
import 'package:viewducts/state/feedState.dart';
import 'package:viewducts/widgets/customWidgets.dart';

class ShippingMethod extends StatefulWidget {
  const ShippingMethod({Key? key}) : super(key: key);

  @override
  _ShippingMethodState createState() => _ShippingMethodState();
}

class _ShippingMethodState extends State<ShippingMethod> {
  String selectedShippingMethod = 'UPS Ground';

  checkoutShippingMethod() {
    // Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    String shippingMethod =
        '{"shippingMethod": "${selectedShippingMethod.toString()}"}';
    Map<String, dynamic> args = jsonDecode(shippingMethod);

    cprint(args["shippingMethod"]);

    Navigator.pushNamed(context, '/PaymentMethod/', arguments: args);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CheckoutAppBar('Back', 'Done', checkoutShippingMethod),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Text(
                //   'Shipping Method',
                //   style: TextStyle(
                //       fontFamily: 'NovaSquare',
                //       fontSize: 40.0,
                //       letterSpacing: 1.0,
                //       fontWeight: FontWeight.bold),
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 60.0, bottom: 30.0),
                //   child: Center(
                //     child: Image.asset(
                //       'assets/cool.png',
                //       width: 250.0,
                //       height: 250.0,
                //     ),
                //   ),
                // ),
                const Text('Shipping Method',
                    style: TextStyle(
                        fontSize: 20.0,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.bold)),
                ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    leading: const Icon(Icons.local_shipping),
                    title: const Text(
                      'UPS Ground',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const <Widget>[
                        SizedBox(height: 3.0),
                        Text(
                          'Arrives in 3-5 days',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Text(
                          'free',
                          style: TextStyle(fontSize: 16.0),
                        )
                      ],
                    ),
                    trailing: Radio(
                      value: 'UPS Ground',
                      groupValue: selectedShippingMethod,
                      onChanged: (dynamic value) {
                        setState(() {
                          selectedShippingMethod = 'UPS Ground';
                        });
                      },
                    )),
                ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    leading: const Icon(Icons.local_shipping),
                    title: const Text(
                      'FedEx',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const <Widget>[
                        Text(
                          'Arriving tomorrow',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Text(
                          '\$5.00',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    trailing: Radio(
                      value: 'FedEx',
                      groupValue: selectedShippingMethod,
                      onChanged: (dynamic value) {
                        setState(() {
                          selectedShippingMethod = 'FedEx';
                        });
                      },
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PaymentMethod extends StatefulWidget {
  const PaymentMethod({Key? key}) : super(key: key);

  @override
  _PaymentMethodState createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  final FeedState _checkoutService = FeedState();
  List<String> cardNumberList = <String>[];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? selectedPaymentCard;
  bool visibleInput = false;
  FeedModel user = FeedModel();
  checkoutPaymentMethod() {
    if (selectedPaymentCard != null) {
//Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
      String shippingMethod =
          '{"selectedCard": "${selectedPaymentCard.toString()}"}';
      Map<String, dynamic> args = jsonDecode(shippingMethod);

      cprint(args["selectedCard"]);

      Navigator.pushNamed(context, "/PlaceOrder/", arguments: args);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black,
          content: const Text('Select any card'),
          action: SnackBarAction(
            label: 'Close',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }

  listPaymentMethod() async {
    List data = await _checkoutService.listCreditCardDetails(user);
    setState(() {
      cardNumberList = data as List<String>;
    });
  }

  showSavedCreditCard() {
    return Column(
      children: <Widget>[
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cardNumberList.length,
          itemBuilder: (BuildContext context, int index) {
            var item = cardNumberList[index];
            return CheckboxListTile(
              secondary: const Icon(Icons.credit_card),
              title: Text('Visa Ending with $item'),
              onChanged: (value) {
                setState(() {
                  selectedPaymentCard = item;
                });
              },
              value: selectedPaymentCard == item,
            );
          },
        )
      ],
    );
  }

  setVisibileInput() {
    setState(() {
      visibleInput = !visibleInput;
    });
  }

  animatePaymentContainers() {
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 1000),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(child: child, scale: animation);
        },
        child: cardNumberList.isNotEmpty
            ? showSavedCreditCard()
            : const Text('No card found'));
  }

  @override
  void initState() {
    super.initState();
    listPaymentMethod();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CheckoutAppBar('Cancel', 'Next', checkoutPaymentMethod),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Payment Method',
                style: TextStyle(
                    fontSize: 35.0,
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.bold),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 20.0, bottom: 30.0),
              //   child: Center(
              //       child: Icon(
              //     Icons.credit_card,
              //     size: 200.0,
              //   )),
              // ),
              animatePaymentContainers(),
              const SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/AddCreditCard/');
                },
                child: const ListTile(
                  leading: Icon(Icons.add),
                  title: Text('Add new Card'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PlaceOrder extends StatefulWidget {
  const PlaceOrder({Key? key}) : super(key: key);

  @override
  _PlaceOrderState createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  void thirdFunction() {}
  Map<String, dynamic>? orderDetails;
  setOrderData() {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    setState(() {
      orderDetails = args;
    });
  }

  placeNewOrder() async {
    // var auth = Provider.of<AuthState>(context, listen: false);
    // await _checkoutService.placeNewOrder(orderDetails!, auth.userId,);
    // Navigator.pushReplacementNamed(context, '/Home');
  }

  @override
  Widget build(BuildContext context) {
    setOrderData();
//final Map args = ModalRoute.of(context).settings.arguments as Map;
    Map<String, dynamic>? args = (ModalRoute.of(context)!.settings.arguments
        as Map?) as Map<String, dynamic>?;
    //final data = args["shippingMethod"];
    String raw = '{"key":"${orderDetails.toString()}"}';
    args = jsonDecode(raw);
    //cprint(args["selectedCard"]);

    return Scaffold(
      appBar: CheckoutAppBar('Shopping Bag', 'Place Order', thirdFunction),
      body: Container(
        decoration: const BoxDecoration(color: Color(0xffF4F4F4)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          child: Column(
            children: <Widget>[
              const Text(
                'Check out',
                style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0),
              ),
              const SizedBox(height: 30.0),
              Card(
                color: Colors.white,
                shape: const ContinuousRectangleBorder(
                    borderRadius: BorderRadius.zero),
                borderOnForeground: true,
                elevation: 0,
                child: ListTile(
                  title: const Text('Payment'),
                  trailing: Text('Visa ${args!['selectedCard']}'),
                ),
              ),
              Card(
                color: Colors.white,
                shape: const ContinuousRectangleBorder(
                    borderRadius: BorderRadius.zero),
                borderOnForeground: true,
                elevation: 0,
                child: ListTile(
                  title: const Text('Shipping'),
                  trailing: customText(''),
//trailing: Text(orderDetails['shippingMethod']),
                ),
              ),
              const Card(
                color: Colors.white,
                shape:
                    ContinuousRectangleBorder(borderRadius: BorderRadius.zero),
                borderOnForeground: true,
                elevation: 0,
                child: ListTile(
                  title: Text('Total'),
                  //trailing: Text('\$ ${orderDetails['price']}.00'),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width / 1.5,
                    height: 50.0,
                    child: TextButton(
                        onPressed: () {
                          placeNewOrder();
                        },
                        child: const Text('Place order',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0)),
                        // color: const Color(0xff616161),
                        // textColor: Colors.white
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
}

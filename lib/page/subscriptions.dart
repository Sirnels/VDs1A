// ignore_for_file: deprecated_member_use

import 'dart:collection';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'package:viewducts/helper/enum.dart';
import 'package:viewducts/helper/theme.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/feedModel.dart';

import 'package:viewducts/state/authState.dart';
import 'package:viewducts/state/feedState.dart';

import 'package:viewducts/widgets/customWidgets.dart';

import 'package:viewducts/widgets/frosted.dart';
import 'package:viewducts/widgets/newWidget/customLoader.dart';
import 'package:viewducts/widgets/newWidget/customUrlText.dart';
import 'package:viewducts/widgets/newWidget/paystack_payment.dart';

class Subscriptions extends StatefulWidget {
  const Subscriptions({
    Key? key,
    required this.formatter,
    this.details,
    this.authstate,
  }) : super(key: key);
  final RegistrationType? details;

  final NumberFormat formatter;

  final AuthState? authstate;

  @override
  _SubscriptionsState createState() => _SubscriptionsState();
}

class _SubscriptionsState extends State<Subscriptions> {
  String? bossMemberPrice,
      babyVendorPrice,
      bossVendorPrice,
      bossMemberId,
      babyVendorId,
      bossVendorId,
      access;
  final _formKey = GlobalKey<FormState>();
  bool autoValidate = false;
  bool visibleInput = false;
  int? selectedAddress;
  CustomLoader? loader;
  List<dynamic> bagItemList = <dynamic>[];
  HashMap addressValues = HashMap();
  List shippingAddress = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FeedModel address = FeedModel();
  //FeedState _checkoutService = new FeedState();
  List<String> cardNumberList = <String>[];
  String? accessCode;
  Charge charge = Charge();
//final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String? selectedPaymentCard, totalPrice;
  String backendUrl = 'https://api.paystack.co';

  var publicKey = "pk_test_f7271f2c383423b470f90cfa9748d27be47b88bd";
  bool _inProgress = false;
  String? _cardNumber;
  String? _cvv;
  final int _expiryMonth = 0;
  final int _expiryYear = 0;
  String transcation = 'No transcation Yet';
  String? finalPrice;
  String? shippingfeeKg;

  String? totalWeight;

//bool visibleInput = false;
  FeedModel user = FeedModel();

  Map<String, dynamic>? orderDetails;
  @override
  void initState() {
    super.initState();
    //  PaystackPlugin.initialize(publicKey: publicKey);
    bossMemPrice();
    babyVenPrice();
    bossVenPrice();
    bossMemId();
    bossVenId();
    babyVenId();
    subAccessCode();
  }

  subAccessCode() async {
    final _sub = Provider.of<FeedState>(context, listen: false);
    var data = await _sub.subInitAccessGet(
      widget.authstate!.user!.uid,
    );
    setState(() {
      access = data;
    });
  }

  bossMemId() async {
    final _sub = Provider.of<FeedState>(context, listen: false);
    var data = await _sub.bossMemberPlanId();
    setState(() {
      bossMemberId = data;
    });
  }

  bossVenId() async {
    final _sub = Provider.of<FeedState>(context, listen: false);
    var data = await _sub.bossVendorPlanId();
    setState(() {
      bossVendorId = data;
    });
  }

  babyVenId() async {
    final _sub = Provider.of<FeedState>(context, listen: false);
    var data = await _sub.babyVendorPlanId();
    setState(() {
      babyVendorId = data;
    });
  }

  bossMemPrice() async {
    final _sub = Provider.of<FeedState>(context, listen: false);
    var data = await _sub.bossMemberPlanList();
    setState(() {
      bossMemberPrice = data;
    });
  }

  babyVenPrice() async {
    final _sub = Provider.of<FeedState>(context, listen: false);
    var data = await _sub.babyVendorPlanList();
    setState(() {
      babyVendorPrice = data;
    });
  }

  bossVenPrice() async {
    final _sub = Provider.of<FeedState>(context, listen: false);
    var data = await _sub.bossVendorPlanList();
    setState(() {
      bossVendorPrice = data;
    });
  }

  placeNewOrder(BuildContext contex) async {
    await subAccessCode();
    // Navigator.of(context).pop();
    //initializeCodes();
    //CircularNotchedRectangle();
    // connectPaystack();
    return _inProgress
        ? Container(
            alignment: Alignment.center,
            height: 50.0,
            child: Platform.isIOS
                ? const CupertinoActivityIndicator()
                : const CircularProgressIndicator(),
          )
        : _startAfreshCharge(context);
  }

  _startAfreshCharge(BuildContext context) async {
    //var state = Provider.of<AuthState>(context, listen: false);

    _formKey.currentState!.save();

    Charge charge = Charge();
    charge.card = _getCardFromUI();

    setState(() => _inProgress = true);
    // int price = int.tryParse(bossMemberPrice);
    setState(() => _inProgress = true);
    _formKey.currentState!.save();

    charge.accessCode = await _fetchAccessCodeFrmServer(_getReference());
    _chargeCard(charge);
    // if (_isLocal) {
    //   // Set transaction params directly in app (note that these params
    //   // are only used if an access_code is not set. In debug mode,
    //   // setting them after setting an access code would throw an exception

    //   charge
    //     ..amount = (price * 100) // In base currency
    //     ..email = state.user.email
    //     ..reference = _getReference()
    //     ..putCustomField('Charged From', 'Flutter SDK');
    //   _chargeCard(charge);
    // } else {
    //   // Perform transaction/initialize on Paystack server to get an access code
    //   // documentation: https://developers.paystack.co/reference#initialize-a-transaction
    //   charge.accessCode = await _fetchAccessCodeFrmServer(_getReference());
    //   _chargeCard(charge);
    // }
  }

  _chargeCard(Charge charge) async {
    // final response = await PaystackPlugin.chargeCard(context, charge: charge);

    // final reference = response.reference;

    // // Checking if the transaction is successful
    // if (response.status) {
    //   _verifyOnServer(reference);
    //   return _clear();
    // }

    // // The transaction failed. Checking if we should verify the transaction
    // if (response.verify) {
    //   _verifyOnServer(reference);
    //   _clear();
    // } else {
    //   setState(() => _inProgress = false);
    //   _updateStatus(reference, response.message);
    // }
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<String?> _fetchAccessCodeFrmServer(String reference) async {
    String? codeaccess = access;
    String url = '$backendUrl/$access';
    String? accessCode;
    try {
      cprint("Access code url = $url");
      // http.Response response = await http.get(url);
      accessCode = codeaccess;
      cprint('Response for access code = $accessCode');
    } catch (e) {
      setState(() => _inProgress = false);
      _updateStatus(
          reference,
          'There was a problem getting a new access code form'
          ' the backend: $e');
    }

    return accessCode;
  }

  _updateStatus(String reference, String message) {
    _showMessage('Reference: $reference \n Response: $message',
        const Duration(seconds: 7));
  }

  _showMessage(String message,
      [Duration duration = const Duration(seconds: 4)]) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: duration,
      action: SnackBarAction(
          label: 'CLOSE',
          onPressed: () =>
              ScaffoldMessenger.of(context).removeCurrentSnackBar()),
    ));
  }

  PaymentCard _getCardFromUI() {
    // Using just the must-required parameters.
    return PaymentCard(
      number: _cardNumber,
      cvc: _cvv,
      expiryMonth: _expiryMonth,
      expiryYear: _expiryYear,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: TwitterColor.mystic,
      body: Stack(
        children: [
          frostedYellow(
            Container(
              height: fullHeight(context),
              width: fullWidth(context),
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
            top: -200,
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
          Form(
            key: _formKey,
            child: ListView(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.orange,
                        )),
                  ],
                ),
              ),
              widget.details == RegistrationType.BabyVen
                  ? SizedBox(
                      width: fullWidth(context),
                      height: fullHeight(context) * 0.8,
                      child: ListView(
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: customText('Baby Vendor',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: fullWidth(context) * 0.08)),
                                ),
                                const Divider(
                                  color: Colors.yellow,
                                  height: 3,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: bossVendorPrice == null
                                            ? const Text('')
                                            : customText(
                                                '${widget.formatter.format(int.tryParse(babyVendorPrice!))}/yr',
                                                style: const TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          placeNewOrder(context);
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.red,
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Colors.yellow
                                                        .withOpacity(0.7),
                                                    Colors.yellow
                                                        .withOpacity(0.8),
                                                    Colors.yellow
                                                        .withOpacity(0.9)
                                                  ],
                                                  // begin: Alignment.topCenter,
                                                  // end: Alignment.bottomCenter,
                                                )),
                                            child: Row(
                                              children: const [
                                                Center(
                                                    child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text('SubScribe',
                                                      style: TextStyle(
                                                          color: Colors.black)),
                                                )),
                                                Icon(
                                                  Icons
                                                      .arrow_forward_ios_rounded,
                                                  color: Colors.black,
                                                )
                                              ],
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                              ]),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: customText(
                              'Feautures:',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Divider(color: Colors.purple),
                          frostedWhite(Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: UrlText(
                                  text: '-Maximum product to sell: x3 products',
                                  onHashTagPressed: (tag) {
                                    cprint(tag);
                                  },
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                  urlStyle: const TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              const Divider(color: Colors.black),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: UrlText(
                                  text:
                                      '-You don\'t need ViewBoard Analysis on Sales',
                                  onHashTagPressed: (tag) {
                                    cprint(tag);
                                  },
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                  urlStyle: const TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              const Divider(color: Colors.black),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: UrlText(
                                  text:
                                      '-Fixed vDuct Commission for your products',
                                  onHashTagPressed: (tag) {
                                    cprint(tag);
                                  },
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                  urlStyle: const TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              const Divider(color: Colors.yellow),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: UrlText(
                                  text:
                                      '-You don\'t want to sell on restricted category',
                                  onHashTagPressed: (tag) {
                                    cprint(tag);
                                  },
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                  urlStyle: const TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: bossVendorPrice == null
                                      ? const Text('')
                                      : customText(
                                          '${widget.formatter.format(int.tryParse(babyVendorPrice!))}/yr',
                                          style: const TextStyle(
                                              color: Colors.yellow,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    placeNewOrder(context);
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.red,
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.yellow.withOpacity(0.7),
                                              Colors.yellow.withOpacity(0.8),
                                              Colors.yellow.withOpacity(0.9)
                                            ],
                                            // begin: Alignment.topCenter,
                                            // end: Alignment.bottomCenter,
                                          )),
                                      child: Row(
                                        children: const [
                                          Center(
                                              child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text('SubScribe',
                                                style: TextStyle(
                                                    color: Colors.black)),
                                          )),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: Colors.black,
                                          )
                                        ],
                                      )),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              widget.details == RegistrationType.BossMem
                  ? SizedBox(
                      width: fullWidth(context),
                      height: fullHeight(context) * 0.8,
                      child: ListView(
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: customText('Boss Member',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: fullWidth(context) * 0.08)),
                                ),
                                const Divider(
                                  color: Colors.yellow,
                                  height: 3,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: bossVendorPrice == null
                                            ? const Text('')
                                            : customText(
                                                '${widget.formatter.format(int.tryParse(bossMemberPrice!))}/yr',
                                                style: const TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          placeNewOrder(context);
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.red,
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Colors.yellow
                                                        .withOpacity(0.7),
                                                    Colors.yellow
                                                        .withOpacity(0.8),
                                                    Colors.yellow
                                                        .withOpacity(0.9)
                                                  ],
                                                  // begin: Alignment.topCenter,
                                                  // end: Alignment.bottomCenter,
                                                )),
                                            child: Row(
                                              children: const [
                                                Center(
                                                    child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text('SubScribe',
                                                      style: TextStyle(
                                                          color: Colors.black)),
                                                )),
                                                Icon(
                                                  Icons
                                                      .arrow_forward_ios_rounded,
                                                  color: Colors.black,
                                                )
                                              ],
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                              ]),
                          SizedBox(
                            width: fullWidth(context),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  frostedWhite(
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: UrlText(
                                        text:
                                            'Become a ViewDucts BOSS MEMBER today and enjoy the following benefit',
                                        onHashTagPressed: (tag) {
                                          cprint(tag);
                                        },
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                        urlStyle: const TextStyle(
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: customText(
                                        'Fast Delivery',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Lottie.asset(
                                        'assets/lottie/shopping-cart.json',
                                        width: 150),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: fullWidth(context),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  frostedWhite(
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: UrlText(
                                        text:
                                            'One day, Two day Express shipping and Fast store pickup store packaging',
                                        onHashTagPressed: (tag) {
                                          cprint(tag);
                                        },
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                        urlStyle: const TextStyle(
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: customText(
                                        'Special Deals Offer',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Image.asset('assets/shopping-bag.png',
                                        width: 80),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: fullWidth(context),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  frostedWhite(
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: UrlText(
                                            text:
                                                '- Special prices on all the products in the MarketPlace',
                                            onHashTagPressed: (tag) {
                                              cprint(tag);
                                            },
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                            ),
                                            urlStyle: const TextStyle(
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                        const Divider(color: Colors.black),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: UrlText(
                                            text:
                                                '- High vDuct commission on all product in Vewducts',
                                            onHashTagPressed: (tag) {
                                              cprint(tag);
                                            },
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                            ),
                                            urlStyle: const TextStyle(
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                        const Divider(color: Colors.black),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: UrlText(
                                            text:
                                                '- vDuct commission made visible on all product in Vewducts',
                                            onHashTagPressed: (tag) {
                                              cprint(tag);
                                            },
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                            ),
                                            urlStyle: const TextStyle(
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                        const Divider(color: Colors.black),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: UrlText(
                                            text:
                                                '- End of the year speacial cashout ',
                                            onHashTagPressed: (tag) {
                                              cprint(tag);
                                            },
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18,
                                            ),
                                            urlStyle: const TextStyle(
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: bossVendorPrice == null
                                      ? const Text('')
                                      : customText(
                                          '${widget.formatter.format(int.tryParse(bossMemberPrice!))}/yr',
                                          style: const TextStyle(
                                              color: Colors.yellow,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    placeNewOrder(context);
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.red,
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.yellow.withOpacity(0.7),
                                              Colors.yellow.withOpacity(0.8),
                                              Colors.yellow.withOpacity(0.9)
                                            ],
                                            // begin: Alignment.topCenter,
                                            // end: Alignment.bottomCenter,
                                          )),
                                      child: Row(
                                        children: const [
                                          Center(
                                              child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text('SubScribe',
                                                style: TextStyle(
                                                    color: Colors.black)),
                                          )),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: Colors.black,
                                          )
                                        ],
                                      )),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),
              widget.details == RegistrationType.BossVen
                  ? SizedBox(
                      width: fullWidth(context),
                      height: fullHeight(context) * 0.8,
                      child: ListView(
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: customText('Boss Vendor',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: fullWidth(context) * 0.08)),
                                ),
                                const Divider(
                                  color: Colors.yellow,
                                  height: 3,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: bossVendorPrice == null
                                            ? const Text('')
                                            : customText(
                                                '${widget.formatter.format(int.tryParse(bossVendorPrice!))}/yr',
                                                style: const TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          placeNewOrder(context);
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.red,
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Colors.yellow
                                                        .withOpacity(0.7),
                                                    Colors.yellow
                                                        .withOpacity(0.8),
                                                    Colors.yellow
                                                        .withOpacity(0.9)
                                                  ],
                                                  // begin: Alignment.topCenter,
                                                  // end: Alignment.bottomCenter,
                                                )),
                                            child: Row(
                                              children: const [
                                                Center(
                                                    child: Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text('SubScribe',
                                                      style: TextStyle(
                                                          color: Colors.black)),
                                                )),
                                                Icon(
                                                  Icons
                                                      .arrow_forward_ios_rounded,
                                                  color: Colors.black,
                                                )
                                              ],
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                              ]),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: customText(
                              'Feautures:',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          frostedWhite(
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: UrlText(
                                    text:
                                        '- Unlimited number of products to sell',
                                    onHashTagPressed: (tag) {
                                      cprint(tag);
                                    },
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                    urlStyle: const TextStyle(
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                const Divider(color: Colors.black),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: UrlText(
                                    text:
                                        '- ViewBoard Analysis on Sales to maximize your sales',
                                    onHashTagPressed: (tag) {
                                      cprint(tag);
                                    },
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                    urlStyle: const TextStyle(
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                const Divider(color: Colors.black),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: UrlText(
                                    text:
                                        '- Flexible vDuct Commission for your products',
                                    onHashTagPressed: (tag) {
                                      cprint(tag);
                                    },
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                    urlStyle: const TextStyle(
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                const Divider(color: Colors.black),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: UrlText(
                                    text:
                                        '- Your will have acess to deals of the day',
                                    onHashTagPressed: (tag) {
                                      cprint(tag);
                                    },
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                    urlStyle: const TextStyle(
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                const Divider(color: Colors.black),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: UrlText(
                                    text:
                                        '- You want to sell on restricted category',
                                    onHashTagPressed: (tag) {
                                      cprint(tag);
                                    },
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                    urlStyle: const TextStyle(
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                const Divider(color: Colors.black),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: UrlText(
                                    text:
                                        '- Have acess to ViewTeam for your team',
                                    onHashTagPressed: (tag) {
                                      cprint(tag);
                                    },
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                    urlStyle: const TextStyle(
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                                const Divider(color: Colors.yellow),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: bossVendorPrice == null
                                      ? const Text('')
                                      : customText(
                                          '${widget.formatter.format(int.tryParse(babyVendorPrice!))}/yr',
                                          style: const TextStyle(
                                              color: Colors.yellow,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    placeNewOrder(context);
                                  },
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.red,
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.yellow.withOpacity(0.7),
                                              Colors.yellow.withOpacity(0.8),
                                              Colors.yellow.withOpacity(0.9)
                                            ],
                                            // begin: Alignment.topCenter,
                                            // end: Alignment.bottomCenter,
                                          )),
                                      child: Row(
                                        children: const [
                                          Center(
                                              child: Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text('Subscribe',
                                                style: TextStyle(
                                                    color: Colors.black)),
                                          )),
                                          Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: Colors.black,
                                          )
                                        ],
                                      )),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(),

              //   Registration(regType: regType, authstate: authstate),
            ]),
          ),
        ],
      ),
    );
  }
}

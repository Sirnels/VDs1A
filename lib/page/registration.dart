// ignore_for_file: deprecated_member_use, must_be_immutable, unused_field

import 'dart:collection';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:viewducts/helper/enum.dart';
import 'package:viewducts/helper/theme.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/page/subscriptions.dart';

import 'package:viewducts/state/authState.dart';
import 'package:viewducts/state/stateController.dart';

import 'package:viewducts/widgets/customWidgets.dart';

import 'package:viewducts/widgets/frosted.dart';
import 'package:viewducts/widgets/newWidget/customLoader.dart';
import 'package:viewducts/widgets/newWidget/customUrlText.dart';
import 'package:viewducts/widgets/newWidget/paystack_payment.dart';

class Registration extends StatefulWidget {
  Registration({
    Key? key,
    required this.regType,
    required this.authstate,
    this.upGrade,
  }) : super(key: key);

  RegistrationType? regType;
  final AuthState authstate;
  final RegistrationType? upGrade;
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
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
  String? buyerId;
  String? finalPrice;
  String? shippingfeeKg;

  String? totalWeight;

//bool visibleInput = false;
  FeedModel user = FeedModel();

  Map<String, dynamic>? orderDetails;
  @override
  void initState() {
    super.initState();
    // PaystackPlugin.initialize(publicKey: publicKey);
    bossMemPrice();
    babyVenPrice();
    bossVenPrice();
    bossMemId();
    bossVenId();
    babyVenId();
    // subAccessCode();
  }

  subAccessCode() async {
    var data = await feedState.subInitAccessGet(
      widget.authstate.user!.uid,
    );
    setState(() {
      access = data;
    });
  }

  bossMemId() async {
    var data = await feedState.bossMemberPlanId();
    setState(() {
      bossMemberId = data;
    });
  }

  bossVenId() async {
    var data = await feedState.bossVendorPlanId();
    setState(() {
      bossVendorId = data;
    });
  }

  babyVenId() async {
    var data = await feedState.babyVendorPlanId();
    setState(() {
      babyVendorId = data;
    });
  }

  bossMemPrice() async {
    var data = await feedState.bossMemberPlanList();
    setState(() {
      bossMemberPrice = data;
    });
  }

  babyVenPrice() async {
    var data = await feedState.babyVendorPlanList();
    setState(() {
      babyVendorPrice = data;
    });
  }

  bossVenPrice() async {
    var data = await feedState.bossVendorPlanList();
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
    // String access = orderDetails["initcode"];
    String url = '$backendUrl/$access';
    String? accessCode;
    try {
      cprint("Access code url = $url");
      // http.Response response = await http.get(url);
      accessCode = access;
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

  // _registerView(BuildContext context, RegistrationType details) {
  //   var authstate = Provider.of<AuthState>(context, listen: false);
  //   final NumberFormat formatter = NumberFormat.simpleCurrency(
  //     decimalDigits: 0,
  //     locale: Localizations.localeOf(context).toString(),
  //   );
  //   return showModalBottomSheet(
  //       isScrollControlled: true,
  //       backgroundColor: Colors.transparent,
  //       context: context,
  //       builder: (context) {
  //         return SafeArea(
  //           child: frostedWhite(DraggableScrollableSheet(
  //               initialChildSize: 0.9,
  //               minChildSize: 0.5,
  //               maxChildSize: 0.9,
  //               builder: (_, controller) => Container(
  //                     child: Subscriptions(

  //                         formatter: formatter,

  //                         authstate: authstate),
  //                   ))),
  //         );
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
      decimalDigits: 0,
      locale: Localizations.localeOf(context).toString(),
    );

    // bossMemPrice();
    // String setTotalPrice(List items) {
    //   int bossMemberPrice = 0;
    //   items.forEach((item) {
    //     bossMemberPrice = bossMemberPrice + item['price'];
    //   });
    //   return bossMemberPrice.toString();
    // }

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: widget.upGrade == RegistrationType.Upgrade
            ? Stack(children: [
                Container(
                  width: fullWidth(context),
                  height: widget.regType == RegistrationType.Personal ||
                          widget.regType != RegistrationType.Vendor
                      ? fullHeight(context) * 0.1
                      : fullHeight(context) * 0.9,
                  decoration: widget.regType == RegistrationType.Personal ||
                          widget.regType != RegistrationType.Vendor
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.red,
                          gradient: LinearGradient(
                            colors: [
                              Colors.teal.withOpacity(0.8),
                              Colors.teal.withOpacity(0.9),
                              Colors.teal.withOpacity(1.0)
                            ],
                            // begin: Alignment.topCenter,
                            // end: Alignment.bottomCenter,
                          ))
                      : BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.red,
                          gradient: LinearGradient(
                            colors: [
                              TwitterColor.mystic.withOpacity(0.8),
                              TwitterColor.mystic.withOpacity(0.9),
                              TwitterColor.mystic.withOpacity(1.0)
                            ],
                            // begin: Alignment.topCenter,
                            // end: Alignment.bottomCenter,
                          )),
                ),
                widget.regType == RegistrationType.Personal ||
                        widget.regType != RegistrationType.Vendor
                    ? Container()
                    : Positioned(
                        top: -160,
                        right: -140,
                        child: Transform.rotate(
                          angle: 90,
                          child: Container(
                            height: fullWidth(context) * 0.8,
                            width: fullWidth(context),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: const DecorationImage(
                                    image: AssetImage('assets/ankkara1.jpg'))),
                          ),
                        ),
                      ),
                widget.regType == RegistrationType.Personal ||
                        widget.regType != RegistrationType.Vendor
                    ? Container()
                    : Positioned(
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
                SizedBox(
                  width: fullWidth(context),
                  height: fullHeight(context) * 0.78,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: SizedBox(
                          width: fullWidth(context),
                          height: fullWidth(context) * 0.15,
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: widget.regType ==
                                                      RegistrationType
                                                          .Personal ||
                                                  widget.regType !=
                                                      RegistrationType.Vendor
                                              ? BorderRadius.circular(20)
                                              : const BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  bottomRight:
                                                      Radius.circular(20)),
                                          color: Colors.red,
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.teal.withOpacity(0.5),
                                              Colors.teal.withOpacity(0.6),
                                              Colors.teal.withOpacity(0.7)
                                            ],
                                            // begin: Alignment.topCenter,
                                            // end: Alignment.bottomCenter,
                                          )),
                                      child: const Center(
                                          child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('',
                                            style:
                                                TextStyle(color: Colors.white)),
                                      )))),
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(20),
                                              bottomLeft: Radius.circular(20)),
                                          color: Colors.white,
                                          gradient: LinearGradient(
                                            colors: [
                                              TwitterColor.mystic
                                                  .withOpacity(0.8),
                                              TwitterColor.mystic
                                                  .withOpacity(0.9),
                                              TwitterColor.mystic
                                                  .withOpacity(1.0)
                                            ],
                                            // begin: Alignment.topCenter,
                                            // end: Alignment.bottomCenter,
                                          )),
                                      child: const Center(
                                          child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child:
                                            Text('Vendor', style: TextStyle()),
                                      )))),
                              // Expanded(
                              //     flex: 1,
                              //     child: Card(
                              //       elevation: 10,
                              //       child: Container(
                              //           decoration: BoxDecoration(
                              //             color: Colors.white,
                              //           ),
                              //           child: Center(
                              //               child: Padding(
                              //             padding:
                              //                 const EdgeInsets.all(8.0),
                              //             child: Text('Vendor'),
                              //           ))),
                              //     )),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 25,
                          child: SizedBox(
                            width: fullWidth(context),
                            height: fullHeight(context) * 0.8,
                            child: ListView(
                              children: [
                                const Divider(color: Colors.teal),
                                Material(
                                  borderRadius: BorderRadius.circular(20),
                                  elevation: 10,
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.blueGrey[50],
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.teal.withOpacity(0.7),
                                              Colors.teal.withOpacity(0.8),
                                              Colors.teal.withOpacity(0.9)
                                            ],
                                            // begin: Alignment.topCenter,
                                            // end: Alignment.bottomCenter,
                                          )),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: customText('Boss Vendor',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          fullWidth(context) *
                                                              0.08)),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: customText(
                                                '${formatter.format(395.88)}/yr',
                                                style: const TextStyle(
                                                    color: Colors.yellow,
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: customText(
                                                'Feautures:',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            const Divider(
                                              color: Colors.yellow,
                                              height: 3,
                                            ),
                                            frostedWhite(
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: UrlText(
                                                      text:
                                                          '- Unlimited number of products to sell',
                                                      onHashTagPressed: (tag) {
                                                        cprint(tag);
                                                      },
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                      ),
                                                      urlStyle: const TextStyle(
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                  const Divider(
                                                      color: Colors.black),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: UrlText(
                                                      text:
                                                          '- You need ViewBoard Analysis on Sales to maximize your sales',
                                                      onHashTagPressed: (tag) {
                                                        cprint(tag);
                                                      },
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                      ),
                                                      urlStyle: const TextStyle(
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                  const Divider(
                                                      color: Colors.black),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: UrlText(
                                                      text:
                                                          '- Flexible vDuct Commission for your products',
                                                      onHashTagPressed: (tag) {
                                                        cprint(tag);
                                                      },
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                      ),
                                                      urlStyle: const TextStyle(
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                  const Divider(
                                                      color: Colors.black),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: UrlText(
                                                      text:
                                                          '- Your will have acess to deals of the day',
                                                      onHashTagPressed: (tag) {
                                                        cprint(tag);
                                                      },
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                      ),
                                                      urlStyle: const TextStyle(
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                  const Divider(
                                                      color: Colors.black),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: UrlText(
                                                      text:
                                                          '- You want to sell on restricted category',
                                                      onHashTagPressed: (tag) {
                                                        cprint(tag);
                                                      },
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                      ),
                                                      urlStyle: const TextStyle(
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                  const Divider(
                                                      color: Colors.black),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: UrlText(
                                                      text:
                                                          '- Have acess to ViewTeam for your team',
                                                      onHashTagPressed: (tag) {
                                                        cprint(tag);
                                                      },
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 15,
                                                      ),
                                                      urlStyle: const TextStyle(
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                  ),
                                                  const Divider(
                                                      color: Colors.yellow),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: customText(
                                                      '${formatter.format(395.88)}/yr',
                                                      style: const TextStyle(
                                                          color: Colors.yellow,
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color: Colors.red,
                                                          gradient:
                                                              LinearGradient(
                                                            colors: [
                                                              Colors.yellow
                                                                  .withOpacity(
                                                                      0.7),
                                                              Colors.yellow
                                                                  .withOpacity(
                                                                      0.8),
                                                              Colors.yellow
                                                                  .withOpacity(
                                                                      0.9)
                                                            ],
                                                            // begin: Alignment.topCenter,
                                                            // end: Alignment.bottomCenter,
                                                          )),
                                                      child: const Center(
                                                          child: Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Text('Upgrade',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black)),
                                                      )))
                                                ],
                                              ),
                                            ),
                                          ])),
                                )
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ])
            : Stack(children: [
                Container(
                  width: fullWidth(context),
                  height: widget.regType == RegistrationType.Personal ||
                          widget.regType != RegistrationType.Vendor
                      ? fullHeight(context) * 0.4
                      : fullHeight(context) * 0.5,
                  decoration: widget.regType == RegistrationType.Personal ||
                          widget.regType != RegistrationType.Vendor
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.red,
                          gradient: LinearGradient(
                            colors: [
                              Colors.teal.withOpacity(0.8),
                              Colors.teal.withOpacity(0.9),
                              Colors.teal.withOpacity(1.0)
                            ],
                            // begin: Alignment.topCenter,
                            // end: Alignment.bottomCenter,
                          ))
                      : BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.red,
                          gradient: LinearGradient(
                            colors: [
                              TwitterColor.mystic.withOpacity(0.8),
                              TwitterColor.mystic.withOpacity(0.9),
                              TwitterColor.mystic.withOpacity(1.0)
                            ],
                            // begin: Alignment.topCenter,
                            // end: Alignment.bottomCenter,
                          )),
                ),
                // widget.regType == RegistrationType.Personal ||
                //         widget.regType != RegistrationType.Vendor
                //     ? Container()
                //     : Positioned(
                //         top: -160,
                //         right: -200,
                //         child: Transform.rotate(
                //           angle: 90,
                //           child: Container(
                //             height: fullWidth(context) * 0.8,
                //             width: fullWidth(context),
                //             decoration: BoxDecoration(
                //                 borderRadius: BorderRadius.circular(20),
                //                 image: DecorationImage(
                //                     image: AssetImage('assets/ankkara1.jpg'))),
                //           ),
                //         ),
                //       ),
                widget.regType == RegistrationType.Personal ||
                        widget.regType != RegistrationType.Vendor
                    ? Container()
                    : Positioned(
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
                SizedBox(
                  width: fullWidth(context),
                  height: fullHeight(context) * 0.86,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: SizedBox(
                          width: fullWidth(context),
                          height: fullWidth(context) * 0.15,
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        widget.regType =
                                            RegistrationType.Personal;
                                      });
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: widget.regType ==
                                                        RegistrationType
                                                            .Personal ||
                                                    widget.regType !=
                                                        RegistrationType.Vendor
                                                ? BorderRadius.circular(20)
                                                : const BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20),
                                                    bottomRight:
                                                        Radius.circular(20)),
                                            color: Colors.red,
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.teal.withOpacity(0.5),
                                                Colors.teal.withOpacity(0.6),
                                                Colors.teal.withOpacity(0.7)
                                              ],
                                              // begin: Alignment.topCenter,
                                              // end: Alignment.bottomCenter,
                                            )),
                                        child: const Center(
                                            child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('Personal',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ))),
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        widget.regType =
                                            RegistrationType.Vendor;
                                      });
                                    },
                                    child: widget.regType ==
                                                RegistrationType.Personal ||
                                            widget.regType !=
                                                RegistrationType.Vendor
                                        ? Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(20),
                                                        bottomLeft:
                                                            Radius.circular(
                                                                20)),
                                                color: Colors.white,
                                                gradient: LinearGradient(
                                                  colors: [
                                                    TwitterColor.mystic
                                                        .withOpacity(0.8),
                                                    TwitterColor.mystic
                                                        .withOpacity(0.9),
                                                    TwitterColor.mystic
                                                        .withOpacity(1.0)
                                                  ],
                                                  // begin: Alignment.topCenter,
                                                  // end: Alignment.bottomCenter,
                                                )),
                                            child: const Center(
                                                child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('Vendor',
                                                  style: TextStyle()),
                                            )))
                                        : Container(
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(20),
                                              ),
                                              color: Colors.transparent,
                                            ),
                                            child: const Center(
                                                child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('Vendor',
                                                  style: TextStyle()),
                                            ))),
                                  )),
                              // Expanded(
                              //     flex: 1,
                              //     child: Card(
                              //       elevation: 10,
                              //       child: Container(
                              //           decoration: BoxDecoration(
                              //             color: Colors.white,
                              //           ),
                              //           child: Center(
                              //               child: Padding(
                              //             padding:
                              //                 const EdgeInsets.all(8.0),
                              //             child: Text('Vendor'),
                              //           ))),
                              //     )),
                            ],
                          ),
                        ),
                      ),
                      widget.regType == RegistrationType.Personal ||
                              widget.regType != RegistrationType.Vendor
                          ? Expanded(
                              flex: 5,
                              child: CustomScrollView(
                                slivers: <Widget>[
                                  CupertinoSliverNavigationBar(
                                    backgroundColor: Colors.transparent,
                                    leading: Container(),
                                    largeTitle: Text(
                                      'Boss Member',
                                      style: TextStyle(
                                          color: widget.regType ==
                                                      RegistrationType
                                                          .Personal ||
                                                  widget.regType !=
                                                      RegistrationType.Vendor
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Expanded(child: Container()),
                      widget.regType == RegistrationType.Personal ||
                              widget.regType != RegistrationType.Vendor
                          ? Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: customText(
                                            'Hi',
                                            style: TextStyle(
                                                color: widget.regType ==
                                                            RegistrationType
                                                                .Personal ||
                                                        widget.regType !=
                                                            RegistrationType
                                                                .Vendor
                                                    ? Colors.yellow
                                                    : Colors.black,
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: customText(
                                            widget.authstate.user!.displayName,
                                            style: TextStyle(
                                                color: widget.regType ==
                                                            RegistrationType
                                                                .Personal ||
                                                        widget.regType !=
                                                            RegistrationType
                                                                .Vendor
                                                    ? Colors.yellow
                                                    : Colors.black,
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                    ),
                                    GestureDetector(
                                        onTap: () async {
                                          await feedState
                                              .subInitializeTrasanction(
                                                  widget.authstate.user!
                                                      .displayName,
                                                  widget.authstate.user!.uid,
                                                  'plan',
                                                  widget.authstate.user!.email,
                                                  bossMemberId,
                                                  bossMemberPrice)
                                              .then((data) async {
                                            await subAccessCode();
                                          }).then((data) {
                                            Navigator.of(context).pop();
                                            Navigator.push(
                                                context,
                                                PageRouteBuilder(
                                                    transitionDuration:
                                                        const Duration(
                                                            seconds: 2),
                                                    transitionsBuilder:
                                                        (context,
                                                            animation,
                                                            secondaryAnimation,
                                                            child) {
                                                      var begin = const Offset(
                                                          0.0, 1.0);
                                                      var end = Offset.zero;
                                                      var curve = Curves.ease;
                                                      var tween = Tween(
                                                              begin: begin,
                                                              end: end)
                                                          .chain(CurveTween(
                                                              curve: curve));
                                                      return SlideTransition(
                                                        position: animation
                                                            .drive(tween),
                                                        child: child,
                                                      );
                                                    },
                                                    pageBuilder: (context,
                                                        animation,
                                                        secondaryAnimation) {
                                                      return Subscriptions(
                                                        formatter: formatter,
                                                        authstate:
                                                            widget.authstate,
                                                        details:
                                                            RegistrationType
                                                                .BossMem,
                                                      );
                                                    }));
                                          }
                                                  //as FutureOr<_> Function(Null)
                                                  );
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
                                                  padding: EdgeInsets.all(4.0),
                                                  child: Text('Benefits',
                                                      style: TextStyle(
                                                          color: Colors.black)),
                                                )),
                                                Icon(
                                                  Icons
                                                      .arrow_forward_ios_rounded,
                                                  color: Colors.black,
                                                )
                                              ],
                                            )))
                                  ],
                                ),
                              ),
                            )
                          : Expanded(child: Container()),
                      widget.regType == RegistrationType.Personal ||
                              widget.regType != RegistrationType.Vendor
                          ? Expanded(
                              flex: 18,
                              child: SizedBox(
                                width: fullWidth(context),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      frostedWhite(
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: UrlText(
                                            text:
                                                'Become a ViewDucts BOSS MEMBER today and enjoy special benefits',
                                            onHashTagPressed: (tag) {
                                              cprint(tag);
                                            },
                                            style: const TextStyle(
                                              color: Colors.white,
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
                              // _BossMember()
                            )
                          : Expanded(
                              flex: 25,
                              child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 20),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: customText('Baby Vendor',
                                            style: TextStyle(
                                                fontSize:
                                                    fullWidth(context) * 0.08)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: babyVendorPrice == null
                                                  ? const Text('')
                                                  : customText(
                                                      '${formatter.format(int.tryParse(babyVendorPrice!))}/yr',
                                                      style: const TextStyle(
                                                          color: Colors.purple,
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                await feedState
                                                    .subInitializeTrasanction(
                                                        widget.authstate.user!
                                                            .displayName,
                                                        widget.authstate.user!
                                                            .uid,
                                                        'plan',
                                                        widget.authstate.user!
                                                            .email,
                                                        babyVendorId,
                                                        babyVendorPrice)
                                                    .then((data) async {
                                                  await subAccessCode();
                                                }).then((data) {
                                                  Navigator.of(context).pop();
                                                  Navigator.push(
                                                      context,
                                                      PageRouteBuilder(
                                                          transitionDuration:
                                                              const Duration(
                                                                  seconds: 2),
                                                          transitionsBuilder:
                                                              (context,
                                                                  animation,
                                                                  secondaryAnimation,
                                                                  child) {
                                                            var begin =
                                                                const Offset(
                                                                    0.0, 1.0);
                                                            var end =
                                                                Offset.zero;
                                                            var curve =
                                                                Curves.ease;
                                                            var tween = Tween(
                                                                    begin:
                                                                        begin,
                                                                    end: end)
                                                                .chain(CurveTween(
                                                                    curve:
                                                                        curve));
                                                            return SlideTransition(
                                                              position: animation
                                                                  .drive(tween),
                                                              child: child,
                                                            );
                                                          },
                                                          pageBuilder: (context,
                                                              animation,
                                                              secondaryAnimation) {
                                                            return Subscriptions(
                                                              formatter:
                                                                  formatter,
                                                              authstate: widget
                                                                  .authstate,
                                                              details:
                                                                  RegistrationType
                                                                      .BabyVen,
                                                            );
                                                          }));
                                                }
                                                        //as FutureOr<_> Function(Null)
                                                        );
                                              },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      color: Colors.red,
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Colors.purple
                                                              .withOpacity(0.7),
                                                          Colors.purple
                                                              .withOpacity(0.8),
                                                          Colors.purple
                                                              .withOpacity(0.9)
                                                        ],
                                                        // begin: Alignment.topCenter,
                                                        // end: Alignment.bottomCenter,
                                                      )),
                                                  child: Row(
                                                    children: const [
                                                      Center(
                                                          child: Padding(
                                                        padding:
                                                            EdgeInsets.all(8.0),
                                                        child: Text('Benefits',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                      )),
                                                      Icon(
                                                        Icons
                                                            .arrow_forward_ios_rounded,
                                                        color: Colors.white,
                                                      )
                                                    ],
                                                  )),
                                            )
                                          ],
                                        ),
                                      ),
                                      frostedOrange(
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: UrlText(
                                            text:
                                                '-Basic tools to increase sales of your products',
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
                                      Material(
                                        borderRadius: BorderRadius.circular(20),
                                        elevation: 10,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.blueGrey[50],
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Colors.teal
                                                        .withOpacity(0.7),
                                                    Colors.teal
                                                        .withOpacity(0.8),
                                                    Colors.teal.withOpacity(0.9)
                                                  ],
                                                  // begin: Alignment.topCenter,
                                                  // end: Alignment.bottomCenter,
                                                )),
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: customText(
                                                        'Boss Vendor',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: fullWidth(
                                                                    context) *
                                                                0.08)),
                                                  ),
                                                  const Divider(
                                                    color: Colors.yellow,
                                                    height: 3,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child:
                                                              bossVendorPrice ==
                                                                      null
                                                                  ? const Text(
                                                                      '')
                                                                  : customText(
                                                                      '${formatter.format(int.tryParse(bossVendorPrice!))}/yr',
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .yellow,
                                                                          fontSize:
                                                                              25,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () async {
                                                            await feedState
                                                                .subInitializeTrasanction(
                                                                    widget
                                                                        .authstate
                                                                        .user!
                                                                        .displayName,
                                                                    widget
                                                                        .authstate
                                                                        .user!
                                                                        .uid,
                                                                    'plan',
                                                                    widget
                                                                        .authstate
                                                                        .user!
                                                                        .email,
                                                                    bossVendorId,
                                                                    bossVendorPrice)
                                                                .then(
                                                                    (data) async {
                                                              await subAccessCode();
                                                            }).then((data) {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              Navigator.push(
                                                                  context,
                                                                  PageRouteBuilder(
                                                                      transitionDuration: const Duration(
                                                                          seconds:
                                                                              2),
                                                                      transitionsBuilder: (context,
                                                                          animation,
                                                                          secondaryAnimation,
                                                                          child) {
                                                                        var begin = const Offset(
                                                                            0.0,
                                                                            1.0);
                                                                        var end =
                                                                            Offset.zero;
                                                                        var curve =
                                                                            Curves.ease;
                                                                        var tween =
                                                                            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                                                        return SlideTransition(
                                                                          position:
                                                                              animation.drive(tween),
                                                                          child:
                                                                              child,
                                                                        );
                                                                      },
                                                                      pageBuilder: (context,
                                                                          animation,
                                                                          secondaryAnimation) {
                                                                        return Subscriptions(
                                                                          formatter:
                                                                              formatter,
                                                                          authstate:
                                                                              widget.authstate,
                                                                          details:
                                                                              RegistrationType.BossVen,
                                                                        );
                                                                      }));
                                                            }

                                                                    //as FutureOr<_> Function(Null)
                                                                    );
                                                          },
                                                          child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20),
                                                                      color: Colors
                                                                          .red,
                                                                      gradient:
                                                                          LinearGradient(
                                                                        colors: [
                                                                          Colors
                                                                              .yellow
                                                                              .withOpacity(0.7),
                                                                          Colors
                                                                              .yellow
                                                                              .withOpacity(0.8),
                                                                          Colors
                                                                              .yellow
                                                                              .withOpacity(0.9)
                                                                        ],
                                                                        // begin: Alignment.topCenter,
                                                                        // end: Alignment.bottomCenter,
                                                                      )),
                                                              child: Row(
                                                                children: const [
                                                                  Center(
                                                                      child:
                                                                          Padding(
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            8.0),
                                                                    child: Text(
                                                                        'Benefits',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.black)),
                                                                  )),
                                                                  Icon(
                                                                    Icons
                                                                        .arrow_forward_ios_rounded,
                                                                    color: Colors
                                                                        .black,
                                                                  )
                                                                ],
                                                              )),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  frostedWhite(
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: UrlText(
                                                        text:
                                                            '-Advance tools to increase sales of your products',
                                                        onHashTagPressed:
                                                            (tag) {
                                                          cprint(tag);
                                                        },
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                        ),
                                                        urlStyle:
                                                            const TextStyle(
                                                          color: Colors.blue,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ])),
                                      )
                                    ],
                                  ),
                                ),
                              ])
                              // _Vendor(babyVendorPrice: babyVendorPrice, formatter: formatter, bossVendorPrice: bossVendorPrice)
                              ),
                    ],
                  ),
                ),
                widget.regType == RegistrationType.Personal ||
                        widget.regType != RegistrationType.Vendor
                    ? Positioned(
                        top: fullWidth(context) * 0.18,
                        right: 20,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: bossMemberPrice == null
                              ? const Text('')
                              : customText(
                                  '${formatter.format(int.tryParse(bossMemberPrice!))}/yr',
                                  style: const TextStyle(
                                      color: Colors.yellow,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      )
                    : Positioned(
                        top: fullWidth(context) * 0.18,
                        right: 0,
                        left: 200,
                        child: Column(
                          children: [
                            customText(
                              'Selling Plans',
                              style: const TextStyle(
                                  color: Colors.teal,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Divider(color: Colors.blue)
                          ],
                        ),
                      )
              ]),
      ),
    );
  }
}

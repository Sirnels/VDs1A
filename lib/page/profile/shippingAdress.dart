// ignore_for_file: invalid_use_of_protected_member, deprecated_member_use, unused_local_variable, unused_field, must_be_immutable, file_names

import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_paystack_payment/flutter_paystack_payment.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:status_alert/status_alert.dart';
import 'package:uuid/uuid.dart';
import 'package:viewducts/common/common.dart';
import 'package:viewducts/features/auth/controller/auth_controller.dart';
import 'package:viewducts/features/business_store/business_store_controller.dart';
import 'package:viewducts/features/products/product_controller.dart';
import 'package:viewducts/helper/showingLoading.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/helper/validator.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/state/stateController.dart';
// import 'package:viewducts/state/feedState.dart';
// import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/frosted.dart';
//import 'package:viewducts/widgets/newWidget/paystack_payment.dart';

class ShippingAddress extends ConsumerStatefulWidget {
  Rx<ViewProduct> cart;
  final ViewductsUser? currentUser;
  final String? sellerId;
  final List<CartItemModel> product;
  ShippingAddress({
    Key? key,
    required this.cart,
    this.currentUser,
    this.sellerId,
    required this.product,
  }) : super(key: key);
  @override
  _ShippingAddressState createState() => _ShippingAddressState();
}

class _ShippingAddressState extends ConsumerState<ShippingAddress> {
  final _formKey = GlobalKey<FormState>();
  bool autoValidate = false;
  bool visibleInput = false;
  int? selectedAddress;
  List<dynamic> bagItemList = <dynamic>[];
  //final FeedState _checkoutService = FeedState();
  HashMap addressValues = HashMap();
  List<Document> shippingAddress = <Document>[];
  List shipAddress = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FeedModel address = FeedModel();
  //FeedState _checkoutService = new FeedState();
  List<String> cardNumberList = <String>[];
  String? accessCode;
  CheckoutMethod? _method;
  Charge charge = Charge();
  Rx<ViewductsUser> sellersInfo = ViewductsUser().obs;
//final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String? selectedPaymentCard, totalPrice;
  // String backendUrl =
  //  userCartController.wasabiAws.value.payStackBackendUrl.toString();

  // var publicKey = '';
  // // userCartController.wasabiAws.value.payStackPublickey.toString();
  final int _radioValue = 0;
  bool _inProgress = false;
  String? _cardNumber;
  String? _cvv;
  final int _expiryMonth = 0;
  final int _expiryYear = 0;
  String transcation = 'No transcation Yet';
  String? buyerId;
  String? finalPrice;
  late String shippingfeeKg;
  InitPaymentModel? userPayment;
  RxList<OrderTransactionModel>? transactModel =
      RxList<OrderTransactionModel>();
  late String totalWeight;

//bool visibleInput = false;
  FeedModel user = FeedModel();

  Map<dynamic, dynamic>? orderDetails;
  // final plugin = PaystackPlugin();
  final plugin = PaystackPayment();
  @override
  void initState() {
    super.initState();

    plugin.initialize(
        publicKey:
            '${ref.read(getwasabiAwsApiProvider).value?.payStackPublickey}');
    listShippingAddress();
    listBagItems();
    // userCartController.listenToCart(widget.sellerId);
    //  initPaymentDatabase();
  }

  // initPaymentDatabase() async {
  //   try {
  //     userCartController.card.value = RxList<Atm>();
  //     final database = Databases(
  //       clientConnect(),
  //     );
  //     await database
  //         .getDocument(
  //             databaseId: databaseId,
  //             collectionId: initPayment,
  //             documentId: authState.appUser!.$id)
  //         .then((doc) {
  //       setState(() {
  //         userPayment = InitPaymentModel.fromJson(doc.data);
  //       });
  //     });

  //     await database
  //         .listDocuments(
  //       databaseId: databaseId,
  //       collectionId: cdarPay,
  //       //queries: [query.Query.equal('userId', id)]
  //     )
  //         .then((data) {
  //       if (data.documents.isNotEmpty) {
  //         var value =
  //             data.documents.map((e) => Atm.fromSnapshot(e.data)).toList();

  //         setState(() {
  //           userCartController.card.value = value;
  //         });
  //       }
  //     });
  //     //  await userCartController.listenToCard(authState.appUser?.$id);
  //     await database
  //         .getDocument(
  //             databaseId: databaseId,
  //             collectionId: profileUserColl,
  //             documentId: widget.sellerId.toString())
  //         .then((item) {
  //       sellersInfo.value = ViewductsUser.fromJson(item.data);
  //     });
  //     await database
  //         .listDocuments(
  //       databaseId: databaseId,
  //       collectionId: vendorColl,
  //     )
  //         .then((data) {
  //       var value = data.documents
  //           .map((e) => StaffUserModel.fromSnapshot(e.data))
  //           .toList();

  //       userCartController.staff.value = value;
  //     });
  //   } on AppwriteException catch (error) {
  //     cprint(error, errorIn: 'init');
  //     Get.snackbar("Database Reject", "try again");
  //   }
  // }

  void listBagItems() async {
    List<CartItemModel> data = ref
        .watch(getProductsInCartByVendorsProvider('${widget.sellerId}'))
        .value!;
    //await _checkoutService.listProductsInCart(user);
    Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    setState(() {
      bagItemList = data;
      totalPrice = setTotalPrice(data);
      totalWeight = setTotalWeight(data);
      shippingfeeKg = setTotalShippingPrice(data);
      finalPrice = setFinalPrice(data);
      buyerId = setBuyerId(data);
      // bagItemList = args['bagItems'];
      // totalPrice = setTotalPrice(args['bagItems']);
      // if (args.containsKey('route')) {
      //   route = args['route'];
      // }
    });
  }

  String? setBuyerId(List items) {
    // int totalPrice = 0;
    for (var item in items) {
      buyerId = item['buyerId'];
    }
    return buyerId;
  }

  String setTotalPrice(List items) {
    int totalPrice = 0;
    for (var item in items) {
      totalPrice =
          totalPrice + (int.parse(item['price']) * item['quantity'] as int);
    }
    return totalPrice.toString();
  }

  String setFinalPrice(List items) {
    int finalPrice = 0;
    for (var item in items) {
      finalPrice =
          finalPrice + int.parse(shippingfeeKg) + int.parse(totalPrice!);
    }
    return finalPrice.toString();
  }

  String setTotalShippingPrice(List items) {
    int shippingfeeKg = 100;
    for (var item in items) {
      shippingfeeKg =
          shippingfeeKg * (int.parse(totalWeight) * item['quantity'] as int);
    }
    return shippingfeeKg.toString();
  }

  String setTotalWeight(List items) {
    int totalWeight = 0;
    for (var item in items) {
      totalWeight =
          totalWeight + (int.parse(item['weight']) * item['quantity'] as int);
    }
    return totalWeight.toString();
  }

  setOrderData() {
    setState(() {
      orderDetails =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    });
    String? shippingAndCheckout =
        '{"initcode":"${userPayment?.initData.toString()}","price":"${userPayment?.totalPrice.toString()}","address":"${shippingAddress[selectedAddress!].data['address'].toString()}","state":"${shippingAddress[selectedAddress!].data['state'].toString()}","contact":"${shippingAddress[selectedAddress!].data['contact'].toString()}","country":"${shippingAddress[selectedAddress!].data['country'].toString()}","city":"${shippingAddress[selectedAddress!].data['city'].toString()}","name": "${shippingAddress[int.parse(selectedAddress.toString())].data['name']}","area": "${shippingAddress[int.parse(selectedAddress.toString())].data['area']}","shippingMethod": "${selectedShippingMethod.toString()}","selectedCard": "${selectedPaymentCard.toString()}"}';
    //cprint(shippingAndCheckout);
    orderDetails = jsonDecode(shippingAndCheckout);
    // final Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;

    // setState(() {
    //   orderDetails = args;
    // });
  }

  placeNewOrder() async {
    userPayment?.initData == null ? showLoading() : _startAfreshCharge();
  }

  Map<String, dynamic>? args;
  checkoutPaymentMethod() {
    if (selectedPaymentCard != null) {
//Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
      String shippingMethod =
          '{"selectedCard": "${selectedPaymentCard.toString()}"}';
      Map<String, dynamic> args = jsonDecode(shippingMethod);

      cprint(args["selectedCard"]);

      //   Navigator.pushNamed(context, "/PlaceOrder/", arguments: args);
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
    // List data = await _checkoutService.listCreditCardDetails(user);
    // setState(() {
    //   cardNumberList = data as List<String>;
    // });
  }

  initializeCodes() async {
    //var auth = Provider.of<AuthState>(context, listen: false);
    // String? data =
    //     await _checkoutService.initialzeCredentials(authState.userId);
    // setState(() {
    //   accessCode = data;
    // });
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

  checkoutAddress() {
    if (selectedAddress == null) {
      String msg = 'Select any address';
      showInSnackBar(msg, Colors.red);
    } else {
      //= ModalRoute.of(context).settings.arguments;
      String raw =
          '{"shippingAddress": "${shippingAddress[selectedAddress!].toString()}"}';
      Map<String, dynamic> args = jsonDecode(raw);

      cprint(args["shippingAddress"]);
      //Navigator.pushNamed(context, "/ShippingMethod/", arguments: args);
    }
  }

  void showInSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(msg),
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

  validateInput() async {
    final currentUser = ref.watch(currentUserDetailsProvider).value;
    // var authState = Provider.of<AuthState>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // await _checkoutService.newShippingAddress(
      //     addressValues, authState.userId);
      ref
          .read(productControllerProvider.notifier)
          .newShippingAddress(addressValues, currentUser?.userId, context);
      String msg = 'Address is saved';
      showInSnackBar(msg, Colors.black);
      setState(() {
        visibleInput = !visibleInput;
        shipAddress.add(addressValues);
      });
    } else {
      setState(() {
        autoValidate = true;
      });
    }
  }

  listShippingAddress() async {
    List<Document> data = ref.read(getShippingAdressProvider).value;
    setState(() {
      shippingAddress = data;
      // shipAddress = data;
    });
  }

  saveNewAddress() {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: Column(
          children: <Widget>[
            const Text(
              'No address saved',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blueGrey[50],
                gradient: LinearGradient(
                  colors: [
                    Colors.yellow.withOpacity(0.1),
                    Colors.white.withOpacity(0.2),
                    Colors.red.withOpacity(0.3)
                    // Color(0xfffbfbfb),
                    // Color(0xfff7f7f7),
                  ],
                  // begin: Alignment.topCenter,
                  // end: Alignment.bottomCenter,
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    visibleInput = true;
                  });
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Add new',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                // borderSide: BorderSide(color: Colors.black, width: 1.8),
                // shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(5.0)
                //     ),
              ),
            )
          ],
        ),
      ),
    );
  }

  showSavedAddress() {
    return Column(
      children: <Widget>[
        ref.watch(getShippingAdressProvider).when(
            data: (data) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data!.length,
                itemBuilder: (BuildContext context, int index) {
                  var item = data![index];
                  return Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    margin: const EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.grey.withOpacity(.3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      child: Wrap(
                        direction: Axis.horizontal,
                        children: <Widget>[
                          const Icon(Icons.home),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                item.data['name'],
                                style: const TextStyle(
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 5.0),
                              // Text(
                              //   item['address'],
                              //   style: const TextStyle(fontSize: 15.0),
                              // ),
                              Text(
                                "${item.data['address']}, ${item.data['area']}, ${item.data['city']},",
                                style: const TextStyle(fontSize: 15.0),
                              ),

                              Text(
                                " ${item.data['state']} ${item.data['country']}. ",
                                style: const TextStyle(fontSize: 15.0),
                              ),
                              Text("Phone number : ${item.data['contact']}")
                            ],
                          ),
                          Radio(
                            value: index,
                            groupValue: selectedAddress,
                            onChanged: (dynamic value) {
                              setState(() {
                                selectedAddress = index;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            error: (error, stackTrace) => ErrorText(
                  error: error.toString(),
                ),
            loading: () => const LoaderAll()),
        const SizedBox(height: 10.0),
        Container(
          width: MediaQuery.of(context).size.width * 0.3,
          margin: const EdgeInsets.only(top: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.grey.withOpacity(.3),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: ButtonTheme(
              minWidth: MediaQuery.of(context).size.width / 3.2,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    visibleInput = true;
                  });
                },
                child: const Text(
                  'Add new',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  showSavedShipAddress() {
    return Column(
      children: <Widget>[
        ref.watch(getShippingAdressProvider).when(
            data: (data) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  var item = data[index];
                  return Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    margin: const EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.grey.withOpacity(.3),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Icon(Icons.home),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  item['name'],
                                  style: const TextStyle(
                                      fontSize: 17.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 5.0),
                                // Text(
                                //   item['address'],
                                //   style: const TextStyle(fontSize: 15.0),
                                // ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    "${item['address']}, ${item['area']}, ${item['city']},",
                                    style: const TextStyle(fontSize: 15.0),
                                  ),
                                ),
                                Text(
                                  " ${item['state']} ${item['country']}. ",
                                  style: const TextStyle(fontSize: 15.0),
                                ),
                                Text("Phone number : ${item['contact']}")
                              ],
                            ),
                            Radio(
                              value: index,
                              groupValue: selectedAddress,
                              onChanged: (dynamic value) {
                                setState(() {
                                  selectedAddress = index;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            error: (error, stackTrace) => ErrorText(
                  error: error.toString(),
                ),
            loading: () => const LoaderAll()),
        const SizedBox(height: 10.0),
        Container(
          width: MediaQuery.of(context).size.width * 0.3,
          margin: const EdgeInsets.only(top: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.grey.withOpacity(.3),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: ButtonTheme(
              minWidth: MediaQuery.of(context).size.width / 3.2,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    visibleInput = true;
                  });
                },
                child: const Text(
                  'Add new',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  animateContainers() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1000),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(child: child, scale: animation);
      },
      child: !visibleInput
          ? (shipAddress.isNotEmpty)
              ? showSavedShipAddress()
              : (shippingAddress.isEmpty)
                  ? saveNewAddress()
                  : showSavedAddress()
          : ShippingAddressInput(addressValues, validateInput),
    );
  }

  String selectedShippingMethod = 'Beitq';

  checkoutShippingMethod() {
    // Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    String shippingMethod =
        '{"shippingMethod": "${selectedShippingMethod.toString()}"}';
    Map<String, dynamic> argShipping = jsonDecode(shippingMethod);

    cprint(argShipping["shippingMethod"]);

    //  Navigator.pushNamed(context, '/PaymentMethod/', arguments: argShipping);
  }

  _startAfreshCharge() async {
    // dismissLoadingWidget();

    _formKey.currentState!.save();
    // int amt = await int.tryParse(userPayment?.totalPrice.toString() ?? '0') ?? 0;
    // Charge charge = Charge();
    Charge charge = Charge()
      ..amount = int.tryParse(userPayment!.totalPrice!.toString())! * 100
      ..reference = _getReference()
      ..accessCode = await _fetchAccessCodeFrmServer(_getReference())
      // or ..accessCode = _getAccessCodeFrmInitialization()
      ..email = widget.currentUser?.email;

    // charge.card = _getCardFromUI();
    // charge.accessCode = await _fetchAccessCodeFrmServer(_getReference());
    _chargeCard(charge);
  }

  _clear({String? refs}) async {
    // var auth = Provider.of<AuthState>(context, listen: false);
    //setState(() => _inProgress = true);
    _formKey.currentState?.save();
    ref.read(productControllerProvider.notifier).placeNewOrder(
        orderDetails!, widget.currentUser?.userId, widget.sellerId, ref,
        context: context, refs: refs);
    // Future.delayed(Duration(seconds: 2), () {
    //   Navigator.pop(context);
    //   Navigator.pop(context);
    // });

    // await _checkoutService
    //     .placeNewOrder(orderDetails!, authState.userId, widget.sellerId,
    //         product: userCartController.shoppingCart, ref: ref)
    //     .then((value) async {
    //   await EasyLoading.dismiss();
    //   chatState.boughtItemMessageNotification(sellersInfo.value);
    //   StatusAlert.show(Get.context!,
    //       duration: const Duration(seconds: 2),
    //       // backgroundColor: Colors.red,
    //       title: 'Payment Sucessful',
    //       // subtitle: "${product.productName} already added to your cart",
    //       configuration: const IconConfiguration(icon: Icons.done));
    // }).then((value) => Future.delayed(const Duration(seconds: 2), () {
    //           Navigator.pop(context);
    //           //   _sucessPaymentAlertBox(context);
    //         }));
  }

  _chargeCard(Charge charge) async {
    //  final response = await plugin.chargeCard(context, charge: charge);
    CheckoutResponse response = await plugin.checkout(
      context,
      method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
      charge: charge,
      logo: Material(
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
            child: Row(
              children: [
                Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(100),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.transparent,
                    child: Image.asset('assets/delicious.png'),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
                  child: customTitleText('ViewDucts'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    final reference = response.reference;

    // Checking if the transaction is successful
    if (response.status) {
      //  EasyLoading.show(status: 'Viewducting');
      await _verifyOnServer(reference.toString());
      // await feedState.addNewCard(authState.userId,
      //     userPayment?.totalPrice.toString(), reference.toString(),
      //     authorizationCode: '');
      return _clear(refs: reference.toString());
    }

    // The transaction failed. Checking if we should verify the transaction
    if (response.verify) {
      //  EasyLoading.show(status: 'Viewducting');
      await _verifyOnServer(reference.toString());
      // await feedState.addNewCard(authState.userId,
      //     userPayment?.totalPrice.toString(), reference.toString(),
      //     authorizationCode: '');
      _clear(refs: reference.toString());
    } else {
      // setState(() => _inProgress = false);
      EasyLoading.dismiss();
      _updateStatus(reference.toString(), response.message);
    }
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
    String? access = userPayment?.initData.toString();

    cprint(access);
    String url =
        '${ref.read(getwasabiAwsApiProvider).value!.payStackBackendUrl}/$access';
    String? accessCode;
    try {
      if (kDebugMode) {
        print("Access code url = $url");
      }
      // http.Response response = await http.get(url);
      accessCode = access;
      if (kDebugMode) {
        print('Response for access code = $accessCode');
      }
    } catch (e) {
      setState(() => _inProgress = false);
      _updateStatus(
          reference,
          'There was a problem getting a new access code form'
          ' the backend: $e');
    }

    return accessCode;
  }

  _verifyOnServer(String reference) async {
    _updateStatus(reference, 'Verifying...');
    String url =
        '${ref.read(getwasabiAwsApiProvider).value!.payStackBackendUrl}/verify/$reference';
    try {
      http.Response response = await http.get(Uri.parse(url));
      var body = response.body;
      _updateStatus(reference, body);
    } catch (e) {
      _updateStatus(
          reference,
          'There was a problem verifying %s on the backend: '
          '$reference $e');
    }
    // setState(() => _inProgress = false);
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

  viewPay(BuildContext context) async {
    Charge charges = Charge()
      ..amount = 10000
      ..reference = _getReference()
      // or ..accessCode = _getAccessCodeFrmInitialization()
      ..email = 'customer@email.com';
    CheckoutResponse response = await plugin.checkout(
      context,
      method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
      charge: charges,
    );
  }

  var keys = Uuid().v1();
  signoutCheckout(String? userId, String? ref) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (userPayment!.initData != null) {
        Future.delayed(Duration(seconds: 10)).then((value) async {
          final id = '';
          // '${userId!.splitByLength((userId.length) ~/ 2)[0]}_${ref!.splitByLength((ref.length) ~/ 2)[0]}';

          final database = Databases(
            clientConnect(),
          );
          await database.listDocuments(
              databaseId: databaseId,
              collectionId: orderTransactionModel,
              queries: [
                Query.equal('ordered', userPayment!.initData.toString())
              ]).then((data) {
            if (data.documents.isNotEmpty) {
              var value = data.documents
                  .map((e) => OrderTransactionModel.fromJson(e.data))
                  .toList()
                  .obs;

              setState(() {
                transactModel?.value = value;
              });
            }
          });
          // final doc = await base.getDocument(
          //     databaseId: databaseId,
          //     collectionId: orderTransactionModel,
          //     documentId: id);

          // setState(() {
          //   transactModel = OrderTransactionModel.fromJson(doc.data);
          // });
          cprint(userPayment!.initData.toString());
          cprint(transactModel?.firstWhere((data) => true).message.toString());
          if (transactModel?.firstWhere((data) => true).message == 'Approved') {
            await _verifyOnServer(
                transactModel!.firstWhere((data) => true).ref.toString());

            _clear(
                refs: transactModel?.firstWhere((data) => true).ref.toString());
          } else {
            _updateStatus(
                transactModel!.firstWhere((data) => true).ref.toString(),
                'unsucessfull payment');
            await EasyLoading.dismiss();
          }
        });
      } else {}
    });
  }

  Future<bool?> _showDialogs(String? card) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return frostedYellow(
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.transparent,
            child: frostedYellow(
              Container(
                height: Get.height * 0.2,
                width: 100,
                child: Column(
                  children: [
                    Wrap(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        offset: const Offset(0, 11),
                                        blurRadius: 11,
                                        color: Colors.black.withOpacity(0.06))
                                  ],
                                  borderRadius: BorderRadius.circular(5),
                                  color: CupertinoColors.systemRed),
                              padding: const EdgeInsets.all(5.0),
                              child: GestureDetector(
                                onTap: () {},
                                child: const Text(
                                  'Are you sure you want to delete this card?',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w200,
                                      color:
                                          CupertinoColors.lightBackgroundGray),
                                ),
                              )),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.maybePop(context);
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          offset: const Offset(0, 11),
                                          blurRadius: 11,
                                          color: Colors.black.withOpacity(0.06))
                                    ],
                                    borderRadius: BorderRadius.circular(18),
                                    color: CupertinoColors.inactiveGray),
                                padding: const EdgeInsets.all(5.0),
                                child: Row(
                                  children: [
                                    Icon(CupertinoIcons.back),
                                    const Text(
                                      'Cancel',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w200),
                                    )
                                  ],
                                )),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            try {
                              cprint('$card account ');
                              EasyLoading.show(
                                  status: 'Deleting', dismissOnTap: true);
                              setState(() {});
                              // await userCartController
                              //     .deletCard(card.toString());
                              setState(() {});

                              cprint('account deleted');

                              await EasyLoading.dismiss();
                              //await initPaymentDatabase();
                              Navigator.maybePop(context);
                            } on AppwriteException catch (e) {
                              cprint('$e deleting Account');
                              Navigator.maybePop(context);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          offset: const Offset(0, 11),
                                          blurRadius: 11,
                                          color: Colors.black.withOpacity(0.06))
                                    ],
                                    borderRadius: BorderRadius.circular(18),
                                    color: CupertinoColors.systemRed),
                                padding: const EdgeInsets.all(5.0),
                                child: const Text(
                                  'Delect',
                                  style: TextStyle(fontWeight: FontWeight.w200),
                                )),
                          ),
                        ),
                      ],
                    )
                    // Container(
                    //   height: Get.height * 0.3,
                    //   width: Get.height * 0.2,
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(20)),
                    //   child: SafeArea(
                    //     child: Stack(
                    //       children: <Widget>[
                    //         Center(
                    //           child: ModalTile(
                    //             title: "File Exceeds Limit",
                    //             subtitle: "Please reduce your file size",
                    //             icon: Icons.tab,
                    //             onTap: () async {
                    //               Navigator.maybePop(context);
                    //             },
                    //           ),
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // backgroundColor: TwitterColor.mystic,
      // appBar: CheckoutAppBar('Back', 'Place Order', this.checkoutAddress),
      body: SafeArea(
        child: Stack(
          children: [
            ThemeMode.system == ThemeMode.light
                ? frostedYellow(
                    Container(
                      height: fullHeight(context),
                      width: fullWidth(context),
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
                    ),
                  )
                : Container(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              child: Form(
                key: _formKey,
                // autovalidate: autoValidate,
                child: SizedBox(
                  width: fullWidth(context),
                  height: fullHeight(context),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 20,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                margin: const EdgeInsets.only(top: 30),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.grey.withOpacity(.3),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  child: Text(
                                    'Shipping Address',
                                    style: TextStyle(
                                        fontSize: 25.0,
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.w100),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              animateContainers(),
                              selectedAddress == null
                                  ? Container()
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Fulfilment By',
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                letterSpacing: 1.0,
                                                fontWeight: FontWeight.bold)),
                                        ListTile(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10.0,
                                                    vertical: 10.0),
                                            leading: const Icon(
                                                Icons.local_shipping),
                                            title: const Text(
                                              'Beitq',
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const <Widget>[
                                                SizedBox(height: 3.0),
                                                Text(
                                                  'Arrives in 14 days outside Vendors location',
                                                  style:
                                                      TextStyle(fontSize: 16.0),
                                                ),
                                                Text(
                                                  '(1-3days within Vendors location)',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.green,
                                                      fontSize: 16.0),
                                                )
                                              ],
                                            ),
                                            trailing: Radio(
                                              value: 'Beitq',
                                              groupValue:
                                                  selectedShippingMethod,
                                              onChanged: (dynamic value) {
                                                setState(() {
                                                  // initializeCodes();
                                                  selectedShippingMethod =
                                                      'Beitq';
                                                });
                                              },
                                            )),
                                        ref
                                            .watch(
                                                getinitPaymentDatabaseProvider(
                                                    widget
                                                        .currentUser!.userId!))
                                            .when(
                                                data: (data) {
                                                  userPayment =
                                                      InitPaymentModel.fromJson(
                                                          data);
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Container(
                                                      // width:
                                                      //    Get.width * 0.3,
                                                      decoration: BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                                offset:
                                                                    const Offset(
                                                                        0, 11),
                                                                blurRadius: 11,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.06))
                                                          ],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: CupertinoColors
                                                              .lightBackgroundGray),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Text(
                                                          NumberFormat.currency(
                                                                  name: widget.currentUser
                                                                              ?.location ==
                                                                          'Nigeria'
                                                                      ? '₦'
                                                                      : '£')
                                                              .format(int.parse(
                                                                  data['totalPrice']
                                                                      .toString())),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            fontSize:
                                                                Get.height *
                                                                    0.05,
                                                          )),
                                                    ),
                                                  );
                                                },
                                                error: (error, stackTrace) =>
                                                    ErrorText(
                                                      error: error.toString(),
                                                    ),
                                                loading: () =>
                                                    const LoaderAll()),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(children: [
                                            Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () async {
                                                    await setOrderData();
                                                    ref
                                                        .read(
                                                            productControllerProvider
                                                                .notifier)
                                                        .placeNewOrder(
                                                          orderDetails!,
                                                          widget.currentUser
                                                              ?.userId,
                                                          widget.sellerId,
                                                          product:
                                                              widget.product,
                                                          ref,
                                                          context: context,
                                                        );
                                                    // _clear();
                                                    // _startAfreshCharge();
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Container(
                                                      width: Get.height * 0.15,
                                                      height: Get.height * 0.12,
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                              image: AssetImage(
                                                                  'assets/creditCards.png'),
                                                              fit:
                                                                  BoxFit.cover),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                offset:
                                                                    const Offset(
                                                                        0, 11),
                                                                blurRadius: 11,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.06))
                                                          ],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(18),
                                                          color: CupertinoColors
                                                              .white),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    await setOrderData();

                                                    // _clear();
                                                    _startAfreshCharge();
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            5.0),
                                                    child: Container(
                                                        // width:
                                                        //    Get.width * 0.3,
                                                        decoration: BoxDecoration(
                                                            boxShadow: [
                                                              BoxShadow(
                                                                  offset:
                                                                      const Offset(
                                                                          0, 11),
                                                                  blurRadius:
                                                                      11,
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.06))
                                                            ],
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        18),
                                                            color: CupertinoColors
                                                                .activeOrange),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5.0),
                                                        child: Text(
                                                          'Pay with New Card',
                                                          style: TextStyle(
                                                              color: CupertinoColors
                                                                  .darkBackgroundGray,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900),
                                                        )),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // Obx(() => Row(
                                            //       children:
                                            //           userCartController.card
                                            //               .map(
                                            //                 (cards) => Column(
                                            //                   children: [
                                            //                     GestureDetector(
                                            //                       onTap:
                                            //                           () async {
                                            //                         await setOrderData();
                                            //                         EasyLoading.show(
                                            //                             dismissOnTap:
                                            //                                 true,
                                            //                             status:
                                            //                                 'Viewducting');
                                            //                         await feedState.addNewCard(
                                            //                             authState
                                            //                                 .userId,
                                            //                             userPayment!
                                            //                                 .totalPrice
                                            //                                 .toString(),
                                            //                             userPayment!
                                            //                                 .initData
                                            //                                 .toString(),
                                            //                             authorize:
                                            //                                 'authorize',
                                            //                             authorizationCode:
                                            //                                 cards.authorization_code);
                                            //                         // await _verifyOnServer(reference.toString());
                                            //                         await signoutCheckout(
                                            //                             authState
                                            //                                 .userId,
                                            //                             userPayment!
                                            //                                 .initData
                                            //                                 .toString());

                                            //                         // return _clear(ref: reference.toString());

                                            //                         // // _clear();
                                            //                         // _startAfreshCharge();
                                            //                       },
                                            //                       child:
                                            //                           Padding(
                                            //                         padding:
                                            //                             const EdgeInsets.all(
                                            //                                 5.0),
                                            //                         child:
                                            //                             Stack(
                                            //                           children: [
                                            //                             Container(
                                            //                               width:
                                            //                                   Get.height * 0.15,
                                            //                               height:
                                            //                                   Get.height * 0.12,
                                            //                               decoration: BoxDecoration(
                                            //                                   image: DecorationImage(
                                            //                                       image: cards.card_type == 'visa'
                                            //                                           ? AssetImage(
                                            //                                               'assets/visa.png',
                                            //                                             )
                                            //                                           : cards.card_type == 'mastercard'
                                            //                                               ? AssetImage(
                                            //                                                   'assets/mastercard.png',
                                            //                                                 )
                                            //                                               : cards.card_type == 'verve'
                                            //                                                   ? AssetImage(
                                            //                                                       'assets/verve.png',
                                            //                                                     )
                                            //                                                   : AssetImage('assets/creditCards.png'),
                                            //                                       fit: BoxFit.cover),
                                            //                                   boxShadow: [
                                            //                                     BoxShadow(offset: const Offset(0, 11), blurRadius: 11, color: Colors.black.withOpacity(0.06))
                                            //                                   ],
                                            //                                   borderRadius: BorderRadius.circular(18),
                                            //                                   color: CupertinoColors.white),
                                            //                               padding:
                                            //                                   const EdgeInsets.all(5.0),
                                            //                             ),
                                            //                             Positioned(
                                            //                                 right:
                                            //                                     0,
                                            //                                 top:
                                            //                                     0,
                                            //                                 child: GestureDetector(
                                            //                                     onTap: () async {
                                            //                                       _showDialogs(cards.authorization_code.toString());
                                            //                                     },
                                            //                                     child: Icon(CupertinoIcons.xmark_circle_fill)))
                                            //                           ],
                                            //                         ),
                                            //                       ),
                                            //                     ),
                                            //                     Padding(
                                            //                       padding:
                                            //                           const EdgeInsets
                                            //                                   .all(
                                            //                               5.0),
                                            //                       child:
                                            //                           Container(
                                            //                         // width:
                                            //                         //    Get.width * 0.3,
                                            //                         decoration: BoxDecoration(
                                            //                             boxShadow: [
                                            //                               BoxShadow(
                                            //                                   offset: const Offset(0, 11),
                                            //                                   blurRadius: 11,
                                            //                                   color: Colors.black.withOpacity(0.06))
                                            //                             ],
                                            //                             borderRadius:
                                            //                                 BorderRadius.circular(
                                            //                                     18),
                                            //                             color: CupertinoColors
                                            //                                 .darkBackgroundGray),
                                            //                         padding:
                                            //                             const EdgeInsets.all(
                                            //                                 5.0),
                                            //                         child: Row(
                                            //                             children: [
                                            //                               Text(
                                            //                                 '***${cards.last4}',
                                            //                                 style:
                                            //                                     const TextStyle(color: CupertinoColors.white, fontWeight: FontWeight.w400),
                                            //                               ),
                                            //                               SizedBox(
                                            //                                 width:
                                            //                                     10,
                                            //                               ),
                                            //                               Container(
                                            //                                 decoration:
                                            //                                     BoxDecoration(boxShadow: [
                                            //                                   BoxShadow(offset: const Offset(0, 11), blurRadius: 11, color: Colors.black.withOpacity(0.06))
                                            //                                 ], borderRadius: BorderRadius.circular(18), color: CupertinoColors.lightBackgroundGray),
                                            //                                 padding:
                                            //                                     const EdgeInsets.all(5.0),
                                            //                                 child:
                                            //                                     Text(
                                            //                                   'Pay with',
                                            //                                   style: Theme.of(context).textTheme.caption!.copyWith(color: Colors.black),
                                            //                                 ),
                                            //                               ),
                                            //                             ]),
                                            //                       ),
                                            //                     ),
                                            //                   ],
                                            //                 ),
                                            //               )
                                            //               .toList(),
                                            //     )),
                                            // userCartController.userChipperCash
                                            //             .value.status ==
                                            //         'Authorizing'
                                            //     ? GestureDetector(
                                            //         onTap: () {},
                                            //         child: Column(
                                            //           children: [
                                            //             Padding(
                                            //               padding:
                                            //                   const EdgeInsets
                                            //                       .all(5.0),
                                            //               child: Container(
                                            //                 width: Get.height *
                                            //                     0.2,
                                            //                 height: Get.height *
                                            //                     0.2,
                                            //                 decoration:
                                            //                     BoxDecoration(
                                            //                         image: DecorationImage(
                                            //                             image: AssetImage(
                                            //                                 'assets/chippercash.png'),
                                            //                             fit: BoxFit
                                            //                                 .cover),
                                            //                         boxShadow: [
                                            //                           BoxShadow(
                                            //                               offset: const Offset(0,
                                            //                                   11),
                                            //                               blurRadius:
                                            //                                   11,
                                            //                               color: Colors
                                            //                                   .black
                                            //                                   .withOpacity(0.06))
                                            //                         ],
                                            //                         borderRadius:
                                            //                             BorderRadius.circular(
                                            //                                 18),
                                            //                         color: CupertinoColors
                                            //                             .white),
                                            //                 padding:
                                            //                     const EdgeInsets
                                            //                         .all(5.0),
                                            //               ),
                                            //             ),
                                            //             Padding(
                                            //               padding:
                                            //                   const EdgeInsets
                                            //                       .all(5.0),
                                            //               child: Container(
                                            //                   // width:
                                            //                   //    Get.width * 0.3,
                                            //                   decoration: BoxDecoration(
                                            //                       boxShadow: [
                                            //                         BoxShadow(
                                            //                             offset: const Offset(
                                            //                                 0,
                                            //                                 11),
                                            //                             blurRadius:
                                            //                                 11,
                                            //                             color: Colors
                                            //                                 .black
                                            //                                 .withOpacity(0.06))
                                            //                       ],
                                            //                       borderRadius:
                                            //                           BorderRadius
                                            //                               .circular(
                                            //                                   18),
                                            //                       color: CupertinoColors
                                            //                           .inactiveGray),
                                            //                   padding:
                                            //                       const EdgeInsets
                                            //                           .all(5.0),
                                            //                   child: Text(
                                            //                     'ChipperCash',
                                            //                     style: TextStyle(
                                            //                         color: CupertinoColors
                                            //                             .darkBackgroundGray,
                                            //                         fontWeight:
                                            //                             FontWeight
                                            //                                 .w900),
                                            //                   )),
                                            //             ),
                                            //           ],
                                            //         ),
                                            //       )
                                            //     : Container(),
                                          ]),
                                        ),
                                      ],
                                    ),
                              SizedBox(
                                width: Get.width,
                                height: Get.height * 0.3,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: Get.height * 0.2,
                                        backgroundColor: Colors.transparent,
                                        child:
                                            Image.asset('assets/paystack.png'),
                                      ),
                                      // CircleAvatar(
                                      //   radius:
                                      //       Get.width * 0.1,
                                      //   backgroundColor:
                                      //       Colors
                                      //           .transparent,
                                      //   child: Image.asset(
                                      //       'assets/mastercard.png'),
                                      // ),
                                    ],
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShippingAddressInput extends StatefulWidget {
  final HashMap addressValues;
  final void Function() validateInput;

  const ShippingAddressInput(this.addressValues, this.validateInput, {Key? key})
      : super(key: key);
  @override
  _ShippingAddressInputState createState() => _ShippingAddressInputState();
}

class _ShippingAddressInputState extends State<ShippingAddressInput> {
  HashMap addressValues = HashMap();

  InputDecoration customBorder(String hintText, IconData textIcon) {
    return InputDecoration(
      // enabledBorder: const OutlineInputBorder(
      //   borderSide: BorderSide(color: Colors.black),
      // ),
      // focusedBorder:
      //     const OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent)),
      focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent)),
      hintText: hintText,
      prefixIcon: Icon(textIcon),
    );
  }

  @override
  Widget build(BuildContext context) {
    Validator _validateService = Validator();
    return Column(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width / 1.2,
          margin: const EdgeInsets.only(top: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.grey.withOpacity(.3),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: TextFormField(
                style: const TextStyle(fontSize: 16.0),
                decoration: customBorder('Full Name', Icons.person),
                keyboardType: TextInputType.text,
                validator: (value) => _validateService.isEmptyField(value!),
                onSaved: (String? val) => widget.addressValues['name'] = val),
          ),
        ),
        const SizedBox(height: 8.0),
        SizedBox(
          height: 80.0,
          child: Container(
            width: MediaQuery.of(context).size.width / 1.2,
            margin: const EdgeInsets.only(top: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.grey.withOpacity(.3),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Theme(
                  child: TextFormField(
                      style: const TextStyle(fontSize: 16.0),
                      decoration: customBorder('Mobile number', Icons.call),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        // WhitelistingTextInputFormatter(RegExp(r"^[^._]+$")),
                        LengthLimitingTextInputFormatter(10)
                      ],
                      validator: (value) =>
                          _validateService.isEmptyField(value!),
                      onSaved: (String? val) =>
                          widget.addressValues['contact'] = val),
                  data: Theme.of(context).copyWith(primaryColor: Colors.black)),
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        // SizedBox(
        //   height: 80.0,
        //   child: Container(
        //     width: MediaQuery.of(context).size.width / 1.2,
        //     margin: const EdgeInsets.only(top: 30),
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(25),
        //       color: Colors.grey.withOpacity(.3),
        //     ),
        //     child: Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        //       child: Theme(
        //         child: TextFormField(
        //             style: const TextStyle(fontSize: 16.0),
        //             decoration: customBorder('PIN code', Icons.code),
        //             keyboardType: TextInputType.number,
        //             inputFormatters: [
        //               //  WhitelistingTextInputFormatter(RegExp(r"^[^._]+$")),
        //               LengthLimitingTextInputFormatter(6)
        //             ],
        //             validator: (value) => _validateService.isEmptyField(value!),
        //             onSaved: (String? val) =>
        //                 widget.addressValues['pinCode'] = val),
        //         data: Theme.of(context).copyWith(primaryColor: Colors.black),
        //       ),
        //     ),
        //   ),
        // ),
        // const SizedBox(height: 8.0),
        SizedBox(
          height: 80.0,
          child: Container(
            width: MediaQuery.of(context).size.width / 1.2,
            margin: const EdgeInsets.only(top: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.grey.withOpacity(.3),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Theme(
                child: TextFormField(
                    style: const TextStyle(fontSize: 16.0),
                    decoration:
                        customBorder('Flat, House no, Apartment', Icons.home),
                    keyboardType: TextInputType.text,
                    validator: (value) => _validateService.isEmptyField(value!),
                    onSaved: (String? val) =>
                        widget.addressValues['address'] = val),
                data: Theme.of(context).copyWith(primaryColor: Colors.black),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        SizedBox(
          height: 80.0,
          child: Container(
            width: MediaQuery.of(context).size.width / 1.2,
            margin: const EdgeInsets.only(top: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.grey.withOpacity(.3),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Theme(
                child: TextFormField(
                    style: const TextStyle(fontSize: 16.0),
                    decoration: customBorder('Street', Icons.location_city),
                    keyboardType: TextInputType.text,
                    validator: (value) => _validateService.isEmptyField(value!),
                    onSaved: (String? val) =>
                        widget.addressValues['area'] = val),
                data: Theme.of(context).copyWith(primaryColor: Colors.black),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        SizedBox(
          height: 80.0,
          child: Container(
            width: MediaQuery.of(context).size.width / 1.2,
            margin: const EdgeInsets.only(top: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.grey.withOpacity(.3),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Theme(
                child: TextFormField(
                    decoration: customBorder('Country', Icons.location_city),
                    style: const TextStyle(fontSize: 16.0),
                    keyboardType: TextInputType.text,
                    validator: (value) => _validateService.isEmptyField(value!),
                    onSaved: (String? val) =>
                        widget.addressValues['country'] = val),
                data: Theme.of(context).copyWith(primaryColor: Colors.black),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        SizedBox(
          height: 80.0,
          child: Container(
            width: MediaQuery.of(context).size.width / 1.2,
            margin: const EdgeInsets.only(top: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.grey.withOpacity(.3),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Theme(
                child: TextFormField(
                    decoration: customBorder('City', Icons.location_city),
                    style: const TextStyle(fontSize: 16.0),
                    keyboardType: TextInputType.text,
                    validator: (value) => _validateService.isEmptyField(value!),
                    onSaved: (String? val) =>
                        widget.addressValues['city'] = val),
                data: Theme.of(context).copyWith(primaryColor: Colors.black),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        SizedBox(
          height: 80.0,
          child: Container(
            width: MediaQuery.of(context).size.width / 1.2,
            margin: const EdgeInsets.only(top: 30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.grey.withOpacity(.3),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Theme(
                child: TextFormField(
                    decoration: customBorder('State', Icons.location_city),
                    style: const TextStyle(fontSize: 16.0),
                    keyboardType: TextInputType.text,
                    validator: (value) => _validateService.isEmptyField(value!),
                    onSaved: (String? val) =>
                        widget.addressValues['state'] = val),
                data: Theme.of(context).copyWith(primaryColor: Colors.black),
              ),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.25,
          margin: const EdgeInsets.only(top: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.grey.withOpacity(.3),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: ButtonTheme(
              minWidth: MediaQuery.of(context).size.width / 3.2,
              child: GestureDetector(
                onTap: () {
                  widget.validateInput();
                },
                child: const Text(
                  'Save',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
                // borderSide: const BorderSide(color: Colors.black, width: 1.8),
                // shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(5.0)),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class CheckoutAppBar extends StatefulWidget with PreferredSizeWidget {
  final String leftButtonText;
  final String rightButtonText;
  final void Function() rightButtonFunction;

  CheckoutAppBar(
      this.leftButtonText, this.rightButtonText, this.rightButtonFunction,
      {Key? key})
      : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  _CheckoutAppBarState createState() => _CheckoutAppBarState();
}

class _CheckoutAppBarState extends State<CheckoutAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Text(
              widget.leftButtonText,
              style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          GestureDetector(
            onTap: () {
              widget.rightButtonFunction();
            },
            child: Text(widget.rightButtonText,
                style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          )
        ],
      ),
    );
  }
}

class CheckoutOderMethods extends StatefulWidget {
  const CheckoutOderMethods({Key? key}) : super(key: key);

  @override
  _CheckoutOderMethodsState createState() => _CheckoutOderMethodsState();
}

class _CheckoutOderMethodsState extends State<CheckoutOderMethods> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final _verticalSizeBox = const SizedBox(height: 20.0);
  final _horizontalSizeBox = const SizedBox(width: 10.0);
  FeedModel user = FeedModel();
  final _border = Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.red,
  );
  Map<String, dynamic>? orderDetails;
  String backendUrl = 'https://api.paystack.co';
  //final FeedState _checkoutService = FeedState();
  var publicKey = "pk_test_f7271f2c383423b470f90cfa9748d27be47b88bd";
  int? _radioValue = 0;
  CheckoutMethod? _method;
  List<dynamic> bagItemList = <dynamic>[];
  bool _inProgress = false;
  String? _cardNumber;
  String? _cvv;
  int? _expiryMonth = 0;
  int? _expiryYear = 0;
  late String selectedPaymentCard, totalPrice;

  String? finalPrice;
  late String shippingfeeKg;

  late String totalWeight;

  void listBagItems() async {
    List data;
    // = await _checkoutService.listProductsInCart(user);
    Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    setState(() {
      // bagItemList = data;
      // totalPrice = setTotalPrice(data);
      // totalWeight = setTotalWeight(data);
      // shippingfeeKg = setTotalShippingPrice(data);
      // finalPrice = setFinalPrice(data);
    });
  }

  String setTotalPrice(List items) {
    int totalPrice = 0;
    for (var item in items) {
      totalPrice =
          (totalPrice + (int.parse(item['price']) * item['quantity'] as int));
    }
    return totalPrice.toString();
  }

  String setFinalPrice(List items) {
    int finalPrice = 0;
    for (var item in items) {
      finalPrice =
          finalPrice + (int.parse(shippingfeeKg) + int.parse(totalPrice)) * 100;
    }
    return finalPrice.toString();
  }

  String setTotalShippingPrice(List items) {
    int shippingfeeKg = 100;
    for (var item in items) {
      shippingfeeKg =
          shippingfeeKg * (int.parse(totalWeight) * item['quantity'] as int);
    }
    return shippingfeeKg.toString();
  }

  String setTotalWeight(List items) {
    int totalWeight = 0;
    for (var item in items) {
      totalWeight =
          totalWeight + (int.parse(item['weight']) * item['quantity'] as int);
    }
    return totalWeight.toString();
  }

  @override
  void initState() {
    super.initState();
    //PaystackPlugin.initialize(publicKey: publicKey);
    listBagItems();
  }

  setOrderData() {
    // setState(() {
    //   orderDetails =
    //       ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    // });
    // String shippingAndCheckout = '{"price":"$finalPrice"}';

    // orderDetails = jsonDecode(shippingAndCheckout);
    // final Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;

    // setState(() {
    //   orderDetails = args;
    // });
  }

  @override
  Widget build(BuildContext context) {
    // setOrderData();
    // var price = ("${orderDetails['price']}");

    // cprint(price);
    cprint(publicKey);
    return Scaffold(
      key: _scaffoldKey,
      appBar: CheckoutAppBar('back', 'Checkout', () {}),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Expanded(
                      child: Text('Initalize transaction from:'),
                    ),
                    Expanded(
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            RadioListTile<int>(
                              value: 0,
                              groupValue: _radioValue,
                              onChanged: _handleRadioValueChanged,
                              title: const Text('Local'),
                            ),
                            RadioListTile<int>(
                              value: 1,
                              groupValue: _radioValue,
                              onChanged: _handleRadioValueChanged,
                              title: const Text('Server'),
                            ),
                          ]),
                    )
                  ],
                ),
                _border,
                _verticalSizeBox,
                TextFormField(
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Card number',
                  ),
                  onSaved: (String? value) => _cardNumber = value,
                ),
                _verticalSizeBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'CVV',
                        ),
                        onSaved: (String? value) => _cvv = value,
                      ),
                    ),
                    _horizontalSizeBox,
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Expiry Month',
                        ),
                        onSaved: (String? value) =>
                            _expiryMonth = int.tryParse(value!),
                      ),
                    ),
                    _horizontalSizeBox,
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Expiry Year',
                        ),
                        onSaved: (String? value) =>
                            _expiryYear = int.tryParse(value!),
                      ),
                    )
                  ],
                ),
                _verticalSizeBox,
                Theme(
                  data: Theme.of(context).copyWith(
                    accentColor: green,
                    primaryColorLight: Colors.white,
                    primaryColorDark: navyBlue,
                    textTheme: Theme.of(context).textTheme.copyWith(
                          bodyText2: const TextStyle(
                            color: lightBlue,
                          ),
                        ),
                  ),
                  child: Builder(
                    builder: (context) {
                      return _inProgress
                          ? Container(
                              alignment: Alignment.center,
                              height: 50.0,
                              child: Platform.isIOS
                                  ? const CupertinoActivityIndicator()
                                  : const CircularProgressIndicator(),
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                _getPlatformButton(
                                    'Charge Card', () => _startAfreshCharge()),
                                _verticalSizeBox,
                                _border,
                                const SizedBox(
                                  height: 40.0,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Flexible(
                                      flex: 3,
                                      child: DropdownButtonHideUnderline(
                                        child: InputDecorator(
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            isDense: true,
                                            hintText: 'Checkout method',
                                          ),
                                          isEmpty: _method == null,
                                          child: DropdownButton<CheckoutMethod>(
                                            value: _method,
                                            isDense: true,
                                            onChanged: (CheckoutMethod? value) {
                                              setState(() {
                                                _method = value;
                                              });
                                            },
                                            items: banks.map((String value) {
                                              return DropdownMenuItem<
                                                  CheckoutMethod>(
                                                value:
                                                    _parseStringToMethod(value),
                                                child: Text(value),
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                    _horizontalSizeBox,
                                    Flexible(
                                      flex: 2,
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: _getPlatformButton(
                                          'Charge Card',
                                          () => _startAfreshCharge(),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleRadioValueChanged(int? value) =>
      setState(() => _radioValue = value);

  _startAfreshCharge() async {
    _formKey.currentState!.save();
    // var auth = Provider.of<AuthState>(context, listen: false);
    Charge charge = Charge();
    charge.card = _getCardFromUI();

    setState(() => _inProgress = true);

    if (_isLocal) {
      // Set transaction params directly in app (note that these params
      // are only used if an access_code is not set. In debug mode,
      // setting them after setting an access code would throw an exception

      charge
        ..amount = 10000 // In base currency
        ..email = 'authState.user!.email'
        ..reference = _getReference()
        ..putCustomField('Charged From', 'Flutter SDK');
      _chargeCard(charge);
    } else {
      // Perform transaction/initialize on Paystack server to get an access code
      // documentation: https://developers.paystack.co/reference#initialize-a-transaction
      charge.accessCode = await _fetchAccessCodeFrmServer(_getReference());
      _chargeCard(charge);
    }
  }

  _chargeCard(Charge charge) async {
    // final response = await PaystackPlugin.chargeCard(context, charge: charge);

    // final reference = response.reference;

    // // Checking if the transaction is successful
    // if (response.status) {
    //   _verifyOnServer(reference);
    //   return;
    // }

    // // The transaction failed. Checking if we should verify the transaction
    // if (response.verify) {
    //   _verifyOnServer(reference);
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

  PaymentCard _getCardFromUI() {
    // Using just the must-required parameters.
    return PaymentCard(
      number: _cardNumber,
      cvc: _cvv,
      expiryMonth: _expiryMonth,
      expiryYear: _expiryYear,
    );

    // Using Cascade notation (similar to Java's builder pattern)
//    return PaymentCard(
//        number: cardNumber,
//        cvc: cvv,
//        expiryMonth: expiryMonth,
//        expiryYear: expiryYear)
//      ..name = 'Segun Chukwuma Adamu'
//      ..country = 'Nigeria'
//      ..addressLine1 = 'Ikeja, Lagos'
//      ..addressPostalCode = '100001';

    // Using optional parameters
//    return PaymentCard(
//        number: cardNumber,
//        cvc: cvv,
//        expiryMonth: expiryMonth,
//        expiryYear: expiryYear,
//        name: 'Ismail Adebola Emeka',
//        addressCountry: 'Nigeria',
//        addressLine1: '90, Nnebisi Road, Asaba, Deleta State');
  }

  Widget _getPlatformButton(String string, Function() function) {
    // is still in progress
    Widget widget;
    if (Platform.isIOS) {
      widget = CupertinoButton(
        onPressed: function,
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        color: CupertinoColors.activeBlue,
        child: Text(
          string,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    } else {
      widget = ElevatedButton(
        onPressed: function,
        // color: Colors.blueAccent,
        // textColor: Colors.white,
        // padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 10.0),
        child: Text(
          string.toUpperCase(),
          style: const TextStyle(fontSize: 17.0),
        ),
      );
    }
    return widget;
  }

  Future<String?> _fetchAccessCodeFrmServer(String reference) async {
    //String url = '$backendUrl/hx7w42v1q12e8hg';
    String? accessCode;

    try {
      // cprint("Access code url = $url");
//      http.Response response = await http.get(url);
      //  accessCode = 'hx7w42v1q12e8hg';
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

  _updateStatus(String? reference, String message) {
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

  bool get _isLocal => _radioValue == 0;
}

var banks = ['Selectable', 'Bank', 'Card'];

CheckoutMethod _parseStringToMethod(String string) {
  CheckoutMethod method = CheckoutMethod.selectable;
  switch (string) {
    case 'Bank':
      method = CheckoutMethod.bank;
      break;
    case 'Card':
      method = CheckoutMethod.card;
      break;
  }
  return method;
}

class MyLogo extends StatelessWidget {
  const MyLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black,
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      child: const Text(
        "ViewDucts",
        style: TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

const Color green = Color(0xFF3db76d);
const Color lightBlue = Color(0xFF34a5db);
const Color navyBlue = Color(0xFF031b33);

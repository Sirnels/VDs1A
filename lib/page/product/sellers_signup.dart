// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_paystack_payment/flutter_paystack_payment.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:status_alert/status_alert.dart';
import 'package:viewducts/helper/enum.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/chatModel.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/frosted.dart';
import 'package:viewducts/widgets/newWidget/customLoader.dart';

// ignore: must_be_immutable
class SellersSignup extends StatefulWidget {
  final VoidCallback? loginCallback;

  SellersSignup({Key? key, this.loginCallback}) : super(key: key);

  @override
  State<SellersSignup> createState() => _SellersSignupState();
}

class _SellersSignupState extends State<SellersSignup> {
  late SharedPreferences prefs;

  String phoneCode = '+234';

  final storage = const FlutterSecureStorage();

  User? currentUser;

  late String verificationId;

  var isLoading = false.obs;

  var isLoggedIn = false.obs;

  CustomLoader loader = CustomLoader();

  final _formKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String? bankName;
  String? bankCode;
  String? bankCountry;
  String? businessCategory;
  double? commission;
  var userState;
  int index = 0;
  int stateIndex = 0;
  InitPaymentModel? userPayment;
  Rx<KeyViewducts> keysView = KeyViewducts().obs;
  @override
  void initState() {
    super.initState();
    plugin.initialize(publicKey: publicKey.toString());
    allUser();
    // userCartController.userChipperCashAccount();

    // userCartController.changeCartTotalPrice();
    // userCartController.changeCartTotalWeight();
    // listPaymentMethod();
    // listBagItems();
    // initializeCodes();
  }

  @override
  void dispose() {
    super.dispose();
    allUser();
  }

  allUser() async {
    try {
      final database = Databases(
        clientConnect(),
      );
      await database
          .listDocuments(
        databaseId: databaseId,
        collectionId: sectionCollection,
//   queries: [
//  query.Query.equal('userId',model.)
//       ]
      )
          .then((data) {
        // Map map = data.toMap();

        var value =
            data.documents.map((e) => CategoryModel.fromJson(e.data)).toList();
        //data.documents;
        feedState.categoryModel!.value = value;
        // cprint('${data.documents.map((e) => FeedModel.fromJson(e.data))}');
        //cprint('${feedState.feedlist?.value.map((e) => e.key)}');
      });
      await database
          .getDocument(
              databaseId: databaseId,
              collectionId: initPayment,
              documentId: authState.appUser!.$id)
          .then((doc) {
        // setState(() {
        userPayment = InitPaymentModel.fromJson(doc.data);
        // });
      });
      userCartController.listenToAllBanks(
          viewBanks: userCartController.viewBanks);
      await database
          .getDocument(
              databaseId: databaseId,
              collectionId: 'keyViewducts',
              documentId: 'keysViewKeys')
          .then((doc) {
        keysView.value = KeyViewducts.fromSnapshot(doc.data);
      });
    } on AppwriteException catch (e) {
      cprint('$e signupPage');
    }
  }

  final plugin = PaystackPayment();
  String backendUrl = 'https://api.paystack.co';
  var publicKey = userCartController.wasabiAws.value.payStackPublickey;
  int indexes = 0;
  int indxs = 0;
  _clear({String? ref}) async {
    // var auth = Provider.of<AuthState>(context, listen: false);
    //setState(() => _inProgress = true);
    _formKey.currentState?.save();

    await _submitForm(ref.toString()).then((value) async {
      await EasyLoading.dismiss();
      //  chatState.boughtItemMessageNotification(sellersInfo.value);
      StatusAlert.show(Get.context!,
          duration: const Duration(seconds: 2),
          // backgroundColor: Colors.red,
          title: 'Payment Sucessful',
          // subtitle: "${product.productName} already added to your cart",
          configuration: const IconConfiguration(icon: Icons.done));
    }).then((value) => Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
          //   _sucessPaymentAlertBox(context);
        }));
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
      return _clear(ref: reference.toString());
    }

    // The transaction failed. Checking if we should verify the transaction
    if (response.verify) {
      //  EasyLoading.show(status: 'Viewducting');
      await _verifyOnServer(reference.toString());
      // await feedState.addNewCard(authState.userId,
      //     userPayment?.totalPrice.toString(), reference.toString(),
      //     authorizationCode: '');
      _clear(ref: reference.toString());
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
    String url = '$backendUrl/$access';
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
      _updateStatus(
          reference,
          'There was a problem getting a new access code form'
          ' the backend: $e');
    }

    return accessCode;
  }

  _verifyOnServer(String reference) async {
    _updateStatus(reference, 'Verifying...');
    String url = '$backendUrl/verify/$reference';
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

  _startAfreshCharge() async {
    // dismissLoadingWidget();
    FToast().init(Get.context!);
    if (userCartController.venDor.value.active == false) {
      _formKey.currentState!.save();
      // int amt = await int.tryParse(userPayment?.totalPrice.toString() ?? '0') ?? 0;
      // Charge charge = Charge();
      Charge charge = Charge()
        ..amount = int.tryParse(userPayment!.totalPrice!.toString())! * 100
        ..reference = _getReference()
        ..accessCode = await _fetchAccessCodeFrmServer(_getReference())
        // or ..accessCode = _getAccessCodeFrmInitialization()
        ..email = authState.userModel?.email;

      // charge.card = _getCardFromUI();
      // charge.accessCode = await _fetchAccessCodeFrmServer(_getReference());
      _chargeCard(charge);
    } else {
      if (
          // bankName == null ||
          authState.businessAccount!.text.isEmpty ||
              authState.businessAddress?.text == null ||
              businessCategory == null ||
              authState.lastName.text.isEmpty ||
              authState.nameController!.text.isEmpty) {
        FToast().showToast(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                  // width:
                  //    Get.width * 0.3,
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
                  child: Text(
                    'Fill all the info correctly',
                    style: TextStyle(
                        color: CupertinoColors.darkBackgroundGray,
                        fontWeight: FontWeight.w900),
                  )),
            ),
            gravity: ToastGravity.TOP_RIGHT,
            toastDuration: Duration(seconds: 4));
        //customSnackBar(_scaffoldKey, 'Please fill form carefully');
        return;
      }
      _formKey.currentState!.save();
      // int amt = await int.tryParse(userPayment?.totalPrice.toString() ?? '0') ?? 0;
      // Charge charge = Charge();
      Charge charge = Charge()
        ..amount = int.tryParse(userPayment!.totalPrice!.toString())! * 100
        ..reference = _getReference()
        ..accessCode = await _fetchAccessCodeFrmServer(_getReference())
        // or ..accessCode = _getAccessCodeFrmInitialization()
        ..email = authState.userModel?.email;

      // charge.card = _getCardFromUI();
      // charge.accessCode = await _fetchAccessCodeFrmServer(_getReference());
      _chargeCard(charge);
    }
  }

  Widget _body(BuildContext? context) {
    return ListBody(
      children: [
        Container(
          height: fullHeight(Get.context!) * 0.9,
          padding: const EdgeInsets.only(left: 20, right: 20, top: 80),
          child: Form(
            key: _formKey,
            child: frostedWhite(
              SingleChildScrollView(
                child: userCartController.venDor.value.active == false
                    ? Column(
                        children: [
                          frostedYellow(
                            Container(
                              height: Get.height * 0.3,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        offset: const Offset(0, 11),
                                        blurRadius: 11,
                                        color: Colors.black.withOpacity(0.06))
                                  ],
                                  borderRadius: BorderRadius.circular(5),
                                  color: CupertinoColors.lightBackgroundGray),
                              padding: const EdgeInsets.all(5.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      offset:
                                                          const Offset(0, 11),
                                                      blurRadius: 11,
                                                      color: Colors.black
                                                          .withOpacity(0.06))
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                                color: CupertinoColors
                                                    .systemYellow),
                                            padding: const EdgeInsets.all(5.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                // Navigator.maybePop(context);
                                              },
                                              child: Text(
                                                'USD ${userCartController.subscriptionModel.firstWhere((data) => data.subType == 'basic', orElse: () => SubscriptionViewDuctsModel()).price ?? ''}/year',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w200),
                                              ),
                                            )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Container(
                                            decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                      offset:
                                                          const Offset(0, 11),
                                                      blurRadius: 11,
                                                      color: Colors.black
                                                          .withOpacity(0.06))
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: userCartController.venDor
                                                            .value.active ==
                                                        false
                                                    ? CupertinoColors.systemRed
                                                    : CupertinoColors.white),
                                            padding: const EdgeInsets.all(5.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                // Navigator.maybePop(context);
                                              },
                                              child: Text(
                                                userCartController.venDor.value
                                                            .active ==
                                                        false
                                                    ? 'Click the button down bellow to renew your yearly subscription'
                                                    : 'Offer your Service with us and create more jobs for the unemployed,One Year Subscripton of your business in ViewDucts.',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w200),
                                              ),
                                            )),
                                      ),
                                      // authState.appPlayStore
                                      //         .where((data) => data.operatingSystem == 'IOS')
                                      //         .isNotEmpty
                                      //     ?

                                      //: Container(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Divider(height: 30),
                          _submitButton(Get.context),
                          const Divider(height: 20),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _entryFeild('First Name*',
                              controller: authState.nameController),
                          _entryFeild('Last Name*',
                              controller: authState.lastName),
                          _entryFeild('input Your Business Name*',
                              controller: authState.businessName),
                          _entryFeild('input Business Address*',
                              controller: authState.businessAddress),
                          // _entryFeild('Contact',
                          //     controller: authState.contact, isNumber: true),
                          GestureDetector(
                            onTap: () {
                              showCupertinoModalPopup(
                                  context: Get.context!,
                                  builder: (context) => CupertinoActionSheet(
                                        actions: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Obx(
                                              () => SizedBox(
                                                height: Get.height * 0.3,
                                                child: CupertinoPicker(
                                                    looping: true,
                                                    itemExtent:
                                                        Get.height * 0.1,
                                                    onSelectedItemChanged:
                                                        (indexess) {
                                                      setState(() {
                                                        indxs = indexess;
                                                        businessCategory =
                                                            feedState
                                                                .categoryModel![
                                                                    indxs]
                                                                .section
                                                                .toString();
                                                        commission = feedState
                                                            .categoryModel![
                                                                indxs]
                                                            .categoryCommission;
                                                      });
                                                      //  bankName = value[];
                                                    },
                                                    children: feedState
                                                        .categoryModel!
                                                        .map((data) => Center(
                                                            child: Text(data
                                                                .section
                                                                .toString())))
                                                        .toList()),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ));
                            },
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: Get.width / 1.2,
                                    margin: const EdgeInsets.only(top: 30),
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              offset: const Offset(0, 11),
                                              blurRadius: 11,
                                              color: Colors.black
                                                  .withOpacity(0.06))
                                        ],
                                        borderRadius: BorderRadius.circular(5),
                                        color: CupertinoColors
                                            .lightBackgroundGray),
                                    padding: const EdgeInsets.all(5.0),
                                    // decoration: BoxDecoration(
                                    //   borderRadius: BorderRadius.circular(25),
                                    //   color: Colors.grey.withOpacity(.3),
                                    // ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.blue.withOpacity(.3),
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                                'Select Business Category*',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ),
                                        ),
                                        // ignore: unnecessary_null_comparison, invalid_use_of_protected_member
                                        businessCategory == null
                                            ? Container()
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 12),
                                                // ignore: unnecessary_null_comparison
                                                child: businessCategory == null
                                                    ? const Text(
                                                        'Select Business Category')
                                                    : Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                            Text(
                                                                '${businessCategory ?? ''}'),

                                                            // Text(bankName!.value),
                                                            // Text(bankCode!.value)
                                                          ])),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          authState.userModel!.location != 'Nigeria'
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(Get.context!)
                                              .size
                                              .width /
                                          1.2,
                                      margin: const EdgeInsets.only(top: 30),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.grey.withOpacity(.3),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 4),
                                        child: TextField(
                                          controller: authState.businessAccount,
                                          // keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                              //   icon: Icon(Icons.bank),
                                              fillColor: Colors.white,
                                              border: InputBorder.none,
                                              hintText: "PayPal Acount"),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(Get.context!)
                                              .size
                                              .width /
                                          1.2,
                                      margin: const EdgeInsets.only(top: 30),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.grey.withOpacity(.3),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 4),
                                        child: TextField(
                                          controller: authState.businessAccount,
                                          // keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                              //   icon: Icon(Icons.bank),
                                              fillColor: Colors.white,
                                              border: InputBorder.none,
                                              hintText:
                                                  "Business Account Number*"),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                          authState.userModel!.location != 'Nigeria'
                              ? Container()
                              : GestureDetector(
                                  onTap: () {
                                    showCupertinoModalPopup(
                                        context: Get.context!,
                                        builder: (context) =>
                                            CupertinoActionSheet(
                                              actions: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Obx(
                                                    () => SizedBox(
                                                      height: Get.height * 0.3,
                                                      child: CupertinoPicker(
                                                          looping: true,
                                                          itemExtent:
                                                              Get.height * 0.1,
                                                          onSelectedItemChanged:
                                                              (index) {
                                                            setState(() {
                                                              indexes = index;

                                                              bankName =
                                                                  userCartController
                                                                      .viewBanks
                                                                      .value
                                                                      .allBanks![
                                                                          indexes]
                                                                      .name!;
                                                              bankCountry =
                                                                  userCartController
                                                                      .viewBanks
                                                                      .value
                                                                      .allBanks![
                                                                          indexes]
                                                                      .country!;
                                                              bankCode =
                                                                  userCartController
                                                                      .viewBanks
                                                                      .value
                                                                      .allBanks![
                                                                          indexes]
                                                                      .code!;
                                                            });

                                                            //  bankName = value[];
                                                          },
                                                          children:
                                                              userCartController
                                                                  .viewBanks
                                                                  .value
                                                                  .allBanks!
                                                                  .map((data) =>
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            bankName =
                                                                                data.name!;
                                                                            bankCode =
                                                                                data.code!;
                                                                          });
                                                                        },
                                                                        child: Center(
                                                                            child:
                                                                                Text(data.name.toString())),
                                                                      ))
                                                                  .toList()),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: MediaQuery.of(Get.context!)
                                                .size
                                                .width /
                                            1.2,
                                        margin: const EdgeInsets.only(top: 30),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: CupertinoColors
                                              .lightBackgroundGray,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color:
                                                    Colors.blue.withOpacity(.3),
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text('Sellect Bank*',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                              ),
                                            ),
                                            bankName == null
                                                ? Container()
                                                : Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 12,
                                                        vertical: 12),
                                                    // ignore: unnecessary_null_comparison
                                                    child: bankName == null
                                                        ? const Text(
                                                            'Sellect Bank')
                                                        : SingleChildScrollView(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                      bankName ??
                                                                          ''),

                                                                  // Text(bankName!),
                                                                  // Text(bankCode!)
                                                                ]),
                                                          )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        offset: const Offset(0, 11),
                                        blurRadius: 11,
                                        color: Colors.black.withOpacity(0.06))
                                  ],
                                  borderRadius: BorderRadius.circular(5),
                                  color: CupertinoColors.lightBackgroundGray),
                              padding: const EdgeInsets.all(5.0),
                              child: customText(
                                'Business Country:${authState.userModel?.location}',
                                style: const TextStyle(
                                    color: CupertinoColors.darkBackgroundGray,
                                    fontFamily: 'Roboto-Regular',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        offset: const Offset(0, 11),
                                        blurRadius: 11,
                                        color: Colors.black.withOpacity(0.06))
                                  ],
                                  borderRadius: BorderRadius.circular(5),
                                  color: CupertinoColors.lightBackgroundGray),
                              padding: const EdgeInsets.all(5.0),
                              child: customText(
                                'Business State:${authState.userModel?.state}',
                                style: const TextStyle(
                                    color: CupertinoColors.darkBackgroundGray,
                                    fontFamily: 'Roboto-Regular',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const Divider(height: 30),

                          _submitButton(Get.context),
                          const Divider(height: 20),

                          // Divider(height: 30),
                          // SizedBox(height: 30),
                          // // _googleLoginButton(Get.context),
                          // GoogleLoginButton(
                          //   loginCallback: widget.loginCallback,
                          //   loader: loader,
                          // ),
                          // SizedBox(height: 30),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _entryFeild(String hint,
      {TextEditingController? controller,
      bool isPassword = false,
      bool isEmail = false,
      bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        //margin: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          // color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextField(
          controller: controller,
          keyboardType: isNumber
              ? TextInputType.phone
              : isEmail
                  ? TextInputType.emailAddress
                  : TextInputType.text,
          style: const TextStyle(
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.normal,
          ),
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            border: InputBorder.none,
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(30.0),
              ),
              borderSide: BorderSide(color: Colors.blueGrey[600]!),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          ),
        ),
      ),
    );
  }

  Widget _submitButton(BuildContext? context) {
    return frostedOrange(
      TextButton(
        //  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        // color: TwitterColor.dodgetBlue,
        // color: Colors.blueGrey[100],
        onPressed: () => _startAfreshCharge()
        //_submitForm()
        //  openvDuctbottomSheet(context!);
        ,
        //_submitForm,
        // padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Container(
          // padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 11),
                    blurRadius: 11,
                    color: Colors.black.withOpacity(0.06))
              ],
              borderRadius: BorderRadius.circular(5),
              color: CupertinoColors.systemGreen),
          padding: const EdgeInsets.all(5.0),
          child: customTitleText(
              userCartController.venDor.value.active == false
                  ? 'Subscribe'
                  : 'Request',
              colors: CupertinoColors.lightBackgroundGray),
        ),
        //  Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: <Widget>[
        //     const Icon(CupertinoIcons.back),
        //     Text(
        //       'Sign up',
        //       style: TextStyle(
        //         color: Colors.blueGrey[700],
        //       ),
        //     ),
        //     const Icon(CupertinoIcons.forward),
        //   ],
        // ),
      ),
    );
  }

  _submitForm(String ref) async {
    // Navigator.pop(Get.context!);
    // if (authState.emailController!.text.isEmpty) {
    //   Get.snackbar("Email", 'Please enter email',
    //       snackPosition: SnackPosition.BOTTOM, colorText: Colors.red
    //       //backgroundColor: Colors.red.shade100
    //       );
    //   // customSnackBar(_scaffoldKey, 'Please enter name');
    //   return;
    // }
    // if (bankCountry?.toString() == null) {
    //   Get.snackbar("Country", 'Please enter country',
    //       snackPosition: SnackPosition.BOTTOM, colorText: Colors.red
    //       //backgroundColor: Colors.red.shade100
    //       );
    //   // customSnackBar(_scaffoldKey, 'Please enter name');
    //   return;
    // }
    // if (userState == null) {
    //   Get.snackbar("State", 'Please enter state',
    //       snackPosition: SnackPosition.BOTTOM, colorText: Colors.red
    //       //backgroundColor: Colors.red.shade100
    //       );
    //   // customSnackBar(_scaffoldKey, 'Please enter name');
    //   return;
    // }
    // if (authState.emailController!.text.length > 27) {
    //   Get.snackbar("Email", 'Name length cannot exceed 27 character',
    //       snackPosition: SnackPosition.BOTTOM, colorText: Colors.red
    //       //backgroundColor: Colors.red.shade100
    //       );
    //   // customSnackBar(_scaffoldKey, 'Name length cannot exceed 27 character');
    //   return;
    // }

    // else if (authState.passwordController!.text !=
    //     authState.confirmController!.text) {
    //   Get.snackbar("Password", 'Password and confirm pasword did not match',
    //       snackPosition: SnackPosition.BOTTOM, colorText: Colors.red
    //       //backgroundColor: Colors.red.shade100
    //       );
    //   // customSnackBar(
    //   //     _scaffoldKey, 'Password and confirm password did not match');
    //   return;
    // }

    VendorModel vendor = VendorModel(
        bank: bankName,
        businessAccount: authState.businessAccount!.text,
        businessAddress: authState.businessAddress!.text,
        storeType: businessCategory,
        businessName: authState.businessName!.text,
        firstName: authState.nameController!.text,
        lastName: authState.lastName.text,
        country: authState.userModel!.location,
        state: authState.userModel!.state,
        vendorId: authState.appUser!.$id,
        storeActiveState: 'paid',
        active: true,
        reference: ref,
        commission: commission);
    await userCartController.sellersSignUp(vendor);
    Navigator.pop(Get.context!);
  }

  void openvDuctbottomSheet(
    BuildContext context, {
    DuctType? type,
  }) async {
    var appSize = MediaQuery.of(context).size;
    await showDialog(
      // backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Stack(
          children: [
            Positioned(
              top: appSize.width * 0.5,
              left: 50,
              right: 50,
              child: frostedYellow(
                Container(
                  padding: const EdgeInsets.only(top: 5, bottom: 0),
                  height: 130,
                  width: fullWidth(context),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blueGrey[50],
                    gradient: LinearGradient(
                      colors: [
                        Colors.black87.withOpacity(0.1),
                        Colors.black87.withOpacity(0.2),
                        Colors.black87.withOpacity(0.3)
                        // Color(0xfffbfbfb),
                        // Color(0xfff7f7f7),
                      ],
                      // begin: Alignment.topCenter,
                      // end: Alignment.bottomCenter,
                    ),
                  ),
                  // decoration: BoxDecoration(
                  //   color: Theme.of(context).bottomSheetTheme.backgroundColor,
                  //   borderRadius: BorderRadius.only(
                  //     topLeft: Radius.circular(20),
                  //     topRight: Radius.circular(20),
                  //   ),
                  // ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var appSize = MediaQuery.of(Get.context!).size;

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            ThemeMode.system == ThemeMode.light
                ? frostedBlueGray(
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
                  )
                : Container(),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _body(Get.context),
                ],
              ),
            ),
            Positioned(
              top: 10,
              left: 1,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    // color: Colors.black,
                    icon: const Icon(CupertinoIcons.back),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 11),
                                blurRadius: 11,
                                color: Colors.black.withOpacity(0.06))
                          ],
                          borderRadius: BorderRadius.circular(5),
                          color: CupertinoColors.darkBackgroundGray),
                      padding: const EdgeInsets.all(5.0),
                      child: customText(
                        'Business View Setup',
                        style: const TextStyle(
                            color: CupertinoColors.lightBackgroundGray,
                            fontFamily: 'Roboto-Regular',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

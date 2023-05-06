// ignore_for_file: file_names, prefer_typing_uninitialized_variables, invalid_use_of_protected_member, empty_catches

import 'package:appwrite/appwrite.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:status_alert/status_alert.dart';
import 'package:viewducts/encryption/encryption.dart';
import 'package:viewducts/helper/constant.dart';
import 'package:appwrite/appwrite.dart' as query;
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:uuid/uuid.dart';

import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/chatModel.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/page/message/local_database.dart';
import 'package:viewducts/state/serverApi.dart';

import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/theme/colorText.dart';

class ChatViewController extends GetxController {
  var statusInit;
  bool? locked, hidden;
  @override
  void onInit() async {
    super.onInit();
    // chatState.messageListing.bindStream(chatState.getchatDetailAsync(
    //     authState.user.uid, chatState.chatUser.userId));
    // chatState.databaseInit(chatState.chatUser!.userId, authState.user!.uid);
    // await chatState.getchatDetailAsync(
    //     chatState.chatUser!.userId!, authState.user!.uid);
    // chatState.messageList;
    // chatState.messageListing!.value;
    // // chatState.setIsActive(authState.user.uid, chatState.chatUser.userId);
    // chatState.onlineOfflineChatStatus(
    //     authState.user!.uid, chatState.chatUser!.userId!);
    // // await chatState.setReadMessages(
    // //     authState.user.uid, chatState.chatUser.userId);
    // chatState.unreadChatMSGCount(
    //     authState.user!.uid, chatState.chatUser!.userId!);

    // if (authState.userModel != null && chatState.chatUser != null) {
    //   hidden = authState.userModel!.hidden != null &&
    //       authState.userModel!.hidden!.contains(chatState.chatUser!.userId);
    //   locked = authState.userModel!.locked != null &&
    //       authState.userModel!.locked!.contains(chatState.chatUser!.userId);
    // }
    // chatState.getStatus(authState.user.uid, chatState.chatUser.userId);
    // statusInit = await chatState.getStatus(
    //     authState.user.uid, chatState.chatUser.userId);
  }

  @override
  void onClose() async {
    super.onClose();
    // statusInit = await chatState.getStatus(
    //     authState.user!.uid, chatState.chatUser!.userId!);
    // chatState.setLastSeen(
    //     statusInit, authState.user!.uid, chatState.chatUser!.userId!);
    //chatState.messageListing!.value.close();
  }
}

class PaymentController extends GetxController {
  var price = "".obs;

  bossMemberPlan(String name, String interval, int price) async {
    // String uid;
    await vDatabase.collection('subscription').doc('bossMember').set({
      // 'id': uid,
      'name': name,
      'interval': interval,
      'price': price,
      'state': 'create'
    });
    cprint('$name added');
  }

  Future<String> bossMemberPlanList() async {
    List orderList = List.empty(growable: true);

    DocumentSnapshot orders =
        await vDatabase.collection('subscription').doc('bossMember').get();
    price.value = orders['price'].toString();

    orderList.add(price);

    cprint('$price added');
    return price.value;
  }

  bossMemberPlanId() async {
    String id;

    DocumentSnapshot ids =
        await vDatabase.collection('subscription').doc('bossMember').get();
    id = ids['id'].toString();

    cprint('bossMember id $id added');
    return id;
  }

  bossMemberPlanUpdate(
    String name,
    String interval,
    int price,
  ) async {
    await vDatabase.collection('subscription').doc('bossMember').set({
      // 'id': uid,
      'name': name,
      'interval': interval,
      'price': price,
      'state': 'update'
    });

    cprint('$name updated');
  }

  babyVendorPlan(String name, String interval, int price) async {
    await vDatabase.collection('subscription').doc('babyVendor').set({
      // 'id': uid,
      'name': name,
      'interval': interval,
      'price': price,
      'state': 'create'
    });
    cprint('$name added');
  }

  babyVendorUpdate(
    String name,
    String interval,
    int price,
  ) async {
    await vDatabase.collection('subscription').doc('babyVendor').set({
      // 'id': uid,
      'name': name,
      'interval': interval,
      'price': price,
      'state': 'update'
    });

    cprint('$name updated');
  }

  Future<String> babyVendorPlanList() async {
    String price;
    List orderList = List.empty(growable: true);

    DocumentSnapshot orders =
        await vDatabase.collection('subscription').doc('babyVendor').get();
    price = orders['price'].toString();

    orderList.add(price);

    cprint('babyVendor $price added');
    return price;
  }

  Future<String> babyVendorPlanId() async {
    String id;

    DocumentSnapshot ids =
        await vDatabase.collection('subscription').doc('babyVendor').get();
    id = ids['id'].toString();

    cprint('babyVendor id $id added');
    return id;
  }

  bossVendorPlan(String name, String interval, int price) async {
    await vDatabase.collection('subscription').doc('bossVendor').set({
      // 'id': uid,
      'name': name,
      'interval': interval,
      'price': price,
      'state': 'create'
    });
    cprint('$name added');
  }

  bossVendorUpdate(
    String name,
    String interval,
    int price,
  ) async {
    await vDatabase.collection('subscription').doc('bossVendor').set({
      // 'id': uid,
      'name': name,
      'interval': interval,
      'price': price,
      'state': 'update'
    });

    cprint('$name updated');
  }

  Future<String> bossVendorPlanList() async {
    String price;
    List orderList = List.empty(growable: true);

    DocumentSnapshot orders =
        await vDatabase.collection('subscription').doc('bossVendor').get();
    price = orders['price'].toString();

    orderList.add(price);

    cprint('bossVendor $price added');
    return price;
  }

  Future<String> bossVendorPlanId() async {
    String id;

    DocumentSnapshot ids =
        await vDatabase.collection('subscription').doc('bossVendor').get();
    id = ids['id'].toString();

    cprint('bossVendor id $id added');
    return id;
  }

  Future<void> subInitializeTrasanction(String userName, String uid,
      String subId, String email, String plan, String price) async {
    try {
      await vDatabase.collection('subInit').doc(uid).set({
        'subState': subId,
        'email': email,
        'userName': userName,
        'plan': plan,
        'price': price,
        'userId': uid
      }, SetOptions(merge: true));
      // .then((value) async {
      //   await vDatabase
      //       .collection('bossbaby')
      //       .doc(uid)
      //       .collection('subscription')
      //       .doc(subid)
      //       .set({'userId': initialize}, SetOptions(merge: true));
      // });
    } catch (e) {
      cprint(e);
    }
  }

  Future<void> verifySubTrasanction(
    String uid,
    String subId,
  ) async {
    try {
      await vDatabase.collection('subInit').doc(uid).set({
        'subState': subId,
      }, SetOptions(merge: true));
    } catch (e) {
      cprint(e);
    }
  }

  Future<String?> subInitAccessGet(String userId) async {
    QuerySnapshot access = await vDatabase
        .collection('subInit')
        .where('userId', isEqualTo: userId)
        .get();
    String? accessCode;
    for (var docRef in access.docs) {
      accessCode = docRef['initData'].toString();
    }
    cprint('acces $accessCode king');
    return accessCode;
  }
}

class ChatListViewController extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    // chatState.getUserchatList(authState.userId.toString());
    // if (authState.userId != null) {
    //   chatState.getUserchatList(authState.userId);

    //   chatState.chatMessageList
    //       .bindStream(chatState.getUserchatLists(authState.userId));
    // }
  }

  // @override
  // void onClose() async {
  //   super.onClose();
  // }
}

class UserCartViewController extends GetxController {
  static UserCartViewController instance = Get.find<UserCartViewController>();
  RxList<dynamic> bagItemList = [].obs;
  Rx<ViewProduct> cart = ViewProduct(products: []).obs;
  RxList<Atm> card = RxList<Atm>();
  Rx<ViewBanks> viewBanks = ViewBanks(allBanks: []).obs;
  Rx<ViewProduct> sellersUsercart = ViewProduct(products: []).obs;
  Rx<UserBankAccountCommissionModel> commission =
      UserBankAccountCommissionModel(amount: []).obs;
  Rx<UserBankAccountModel> account = UserBankAccountModel(amount: []).obs;
  Rx<ChipperCash> userChipperCash = ChipperCash().obs;
  RxList<OrderViewProduct> orders = RxList<OrderViewProduct>();
  RxList<UnPaidCommission> unPaidCommission = RxList<UnPaidCommission>();
  RxList<PaidCommission> paidCommission = RxList<PaidCommission>();
  Rx<UserMonthPayCommission> monthCommPay = UserMonthPayCommission().obs;
  Rx<TransactionModel> initcode = TransactionModel().obs;
  Rx<CartItemModel> productCart = CartItemModel().obs;
  Rx<PaymentMethodsModel> paymentMethods = PaymentMethodsModel().obs;
  Rx<CartSeen> userSeenCart = CartSeen().obs;
  Rx<AwsWasabiStorageModel> wasabiAws = AwsWasabiStorageModel().obs;
  Rx<AdminPaymentActivate> adminpaymentActiv = AdminPaymentActivate().obs;
  // RxList<AdminOrdersModel> orderState = RxList<AdminOrdersModel>();
  RxList<CartItemModel> shoppingCart = RxList<CartItemModel>();
  RxList<CartItemModel> shoppingCartAppState = [CartItemModel()].obs;
  RxList<ChatMessage> chatListUnreadMessage = [ChatMessage()].obs;
  // RxList<AdminOrdersModel> adminUserOrders = RxList<AdminOrdersModel>();
  RxList<AdminOrdersModel> staffprocessedUserOrders =
      RxList<AdminOrdersModel>();
  RxList<Contact> contact = RxList<Contact>();
  RxList<ViewductsUser>? listChatUser = RxList<ViewductsUser>();
  RxList<AnouncementText> announce = RxList<AnouncementText>();
  RxList<VirtualSignUpAccountModel> fincraVitualAccount =
      RxList<VirtualSignUpAccountModel>();
  Rx<UserBankAccountModel> useraccounts = UserBankAccountModel(amount: []).obs;
  Rx<VendorModel> venDor = VendorModel().obs;
  Rx<SectionModel> categorySection = SectionModel().obs;

  RxList<ExchangeRateModel> exchangeRate = RxList<ExchangeRateModel>();
  RxList<SubscriptionViewDuctsModel> subscriptionModel =
      RxList<SubscriptionViewDuctsModel>();
  RxList<PolicyModel> policyModel = RxList<PolicyModel>();
  RxList<OficialViewductsStoreNameModel> storeNameViewductsOficial =
      RxList<OficialViewductsStoreNameModel>();
  RxList<ProductReviewModel> productReviewModelComment =
      RxList<ProductReviewModel>();
  RxList<StaffUserModel> staff = RxList<StaffUserModel>();
  List<dynamic> itemList = [];
  Rx<double> totalCartPrice = 0.0.obs;
  Rx<double> totalCommissionAmount = 0.0.obs;
  Rx<double> totalPaidCommissionAmount = 0.0.obs;
  Rx<double> totalCartWeight = 0.0.obs;
  Rx<double> totalCartShipping = 0.0.obs;
  late String selectedSize,
      selectedColor,
      totalPrice,
      subTotalPrice,
      shippingfeeKg;
  RxInt quantity = 1.obs;
  final _totalWeight = "".obs;
  String? get totalWeight {
    return _totalWeight.value;
  }

  // var accessCode;

  // var itemDetails;

  Rx<FeedModel> user = FeedModel().obs;
  //var playstate;
  @override
  void onReady() async {
    super.onReady();
    listenToOrders();
    // ever(cart, changeCartTotalPrice);
    // ever(commission, changeComissionAmount);
    // ever(cart, changeCartTotalWeight);
    // ever(cart, changeCartTotalShipping);
    // initListOrdershistory(authState.userId);
    // initcode.bindStream(listenInittransaction());
    // announce.bindStream(anouncement());
    // userSeenCart.bindStream(listenToSeenCart());
    // adminpaymentActiv.bindStream(adminUserPaymentActivate());

    // // List data = await feedState.listProductsInCart(user.value);
    // // String? accessdata =
    // //     await feedState.initialzeCredentials(authState.user!.uid);
    // cart.bindStream(listenToCart());
    // listenToCart();

    listenToPaymentMethod(payment: 'fincra');
    // listenToCard(authState.appUser?.$id);
    // orders.bindStream(listenToOrders());

    // orderState.bindStream(listenOrderState());
    // adminUserOrders.bindStream(listenAdminUserOrders());

    //accessCode = accessdata;
    // bagItemList = data.obs;
    // totalPrice = setTotalPrice(data);
    // _totalWeight.value = setTotalWeight();
    // shippingfeeKg = setTotalShippingPrice(data);
    // subTotalPrice = setFinalPrice(data);
    // shoppingCart.bindStream(subscribe());
  }

  RealtimeSubscription? subscriptions;
  sellersSignUp(VendorModel vendor) async {
    try {
      FToast().init(Get.context!);
      final database = Databases(
        clientConnect(),
      );

      await database.createDocument(
          databaseId: databaseId,
          collectionId: sellersVendors,
          documentId: authState.appUser!.$id,
          data: vendor.toJson());
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
                    color: CupertinoColors.activeGreen),
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  'Store setup completed',
                  style: TextStyle(
                      color: CupertinoColors.darkBackgroundGray,
                      fontWeight: FontWeight.w900),
                )),
          ),
          gravity: ToastGravity.TOP_LEFT,
          toastDuration: Duration(seconds: 3));
    } on AppwriteException catch (e) {
      cprint('$e sellersSignUp');
    }
  }

  subscribe() {
    final realtime = Realtime(clientConnect());
    subscriptions =
        realtime.subscribe(["collections.$shoppingCartCollection.documents"]);
    subscriptions?.stream.listen((data) {
      if (data.payload.isNotEmpty) {
        switch (data.events) {
          case ["database.documents.create"]:
            shoppingCart.add(CartItemModel.fromMap(data.payload));

            break;
          case ["database.documents.deletes"]:
            shoppingCart
                .removeWhere((datas) => datas.key == data.payload['key']);

            break;

          default:
        }
      }
    });
    return subscriptions!.stream.cast<CartItemModel>();
  }

  // @override
  // void onClose() async {
  //   super.onClose();
  // }
  deletCard(String documentId) async {
    try {
      final database = Databases(
        clientConnect(),
      );
      await database.deleteDocument(
          databaseId: databaseId,
          collectionId: cdarPay,
          documentId: documentId);
      cprint('card deleted deletCard');
    } on AppwriteException catch (e) {
      cprint('$e deletCard');
    }
  }

  deleteDuctStory(String documentId) async {
    try {
      final database = Databases(
        clientConnect(),
      );
      await database.deleteDocument(
          databaseId: databaseId,
          collectionId: storyCollId,
          documentId: documentId);
      cprint('deleteDuctStory deleted deletCard');
    } on AppwriteException catch (e) {
      cprint('$e deleteDuctStory');
    }
  }

  String setTotalPrice(List items) {
    int totalPrice = 0;
    // items.forEach((item) {
    //   totalPrice =
    //       totalPrice + (int.parse(item['price']) * item['quantity'] as int);
    // });
    return totalPrice.toString();
  }

  String setFinalPrice(List items) {
    int subTotalPrice = 0;
    // items.forEach((item) {
    //   subTotalPrice =
    //       subTotalPrice + int.parse(shippingfeeKg) + int.parse(totalPrice);
    // });
    return subTotalPrice.toString();
  }

  String setTotalShippingPrice(List items) {
    int shippingfeeKg = 100;
    // items.forEach((item) {
    //   shippingfeeKg = shippingfeeKg *
    //       (int.parse(_totalWeight.value) * item['quantity'] as int);
    // });
    return shippingfeeKg.toString();
  }

  String setTotalWeight() {
    int _totalWeight = 0;
    // bagItemList.forEach((item) {
    //   _totalWeight =
    //       _totalWeight + (int.parse(item['weight']) * item['quantity'] as int);
    // });
    return _totalWeight.toString();
  }

  void removeItem(item, context) async {
    // var authState = Provider.of<AuthState>(context, listen: false);
    bagItemList.removeWhere((items) => items['id'] == item['id']);
    await feedState.remove(item['id'], authState.userId);

    bagItemList = bagItemList;

    // Navigator.of(context, rootNavigator: true).pop();
  }

  void initListOrdershistory(String? user) async {
    // List data = await feedState.listPlacedOrder(user);

    // itemList = data;
  }

  cartSeen() => kDatabase
      .child('cartState/${authState.userId}')
      .set({'state': 'seen', "uid": authState.userId});
  listbanks() =>
      vDatabase.collection('banks').doc('bank').set({'banks': 'yes'});
  userRequestPayment(String? id, String? amount, String? month) async {
    try {
      FToast().init(Get.context!);
      final database = Databases(
        clientConnect(),
      );
      await database.listDocuments(
          databaseId: databaseId,
          collectionId: monthlycommisionPayment,
          queries: [query.Query.equal('monthPay', month)]).then((data) async {
        if (data.documents.isEmpty) {
          await database.createDocument(
            databaseId: databaseId,
            collectionId: monthlycommisionPayment,
            documentId: '$id$month',
            data: {
              'userId': id,
              'monthPay': month,
              'amount': amount,
              //  'reference': ref,
              'paymentState': 'requested'
            },
          );
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
                        color: CupertinoColors.activeGreen),
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      '$month Commission ₦$amount requested',
                      style: TextStyle(
                          color: CupertinoColors.darkBackgroundGray,
                          fontWeight: FontWeight.w900),
                    )),
              ),
              gravity: ToastGravity.TOP_LEFT,
              toastDuration: Duration(seconds: 3));
        } else {
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
                      '$month Commission ₦$amount requested Already',
                      style: TextStyle(
                          color: CupertinoColors.darkBackgroundGray,
                          fontWeight: FontWeight.w900),
                    )),
              ),
              gravity: ToastGravity.TOP_LEFT,
              toastDuration: Duration(seconds: 3));
        }
      });
      // if (_isCommissionRequestAlreadyAdded(month)) {
      //   Get.snackbar(
      //     "Commission",
      //     "Request is already sent",
      //     backgroundColor: AppColors.red,
      //     icon: Container(
      //       height: 100,
      //       width: 100,
      //       decoration: BoxDecoration(
      //           borderRadius: BorderRadius.circular(100),
      //           image: const DecorationImage(
      //               image: AssetImage('assets/tuscany.png'))),
      //     ),
      //   );
      // } else {
      //   vDatabase.collection('userBankAccount').doc(id).set({
      //     "amount": FieldValue.arrayUnion([
      //       {
      //         'monthPay': month,
      //         'amount': amount,
      //         //  'reference': ref,
      //         'paymentState': 'requested'
      //       },
      //     ]),
      //   }, SetOptions(merge: true)).then(
      //       (value) => vDatabase.collection('commission').doc(id).set(
      //             {
      //               "amount": FieldValue.arrayRemove([]),
      //             },
      //           ));
      //   vDatabase.collection('monthCommPay').doc(id).set({
      //     'monthPay': month,
      //     'amount': amount,
      //     //  'reference': ref,
      //     'paymentState': 'requested'
      //   }, SetOptions(merge: true));
      //   kDatabase.child('monthCommPay').child(id.toString()).set({
      //     'monthPay': month,
      //     'amount': amount,
      //     //  'reference': ref,
      //     'paymentState': 'requested'
      //   });
      //   Get.snackbar(
      //     "Comissision Payment",
      //     "Payment requested",
      //     icon: Container(
      //       height: Get.width * 0.1,
      //       width: Get.width * 0.1,
      //       decoration: BoxDecoration(
      //           borderRadius: BorderRadius.circular(100),
      //           image: const DecorationImage(
      //               image: AssetImage('assets/tuscany.png'))),
      //     ),
      //   );
      // }
    } on AppwriteException catch (e) {
      cprint('$e');
    }
  }

  adminPaymentproccessed(String? id, int? amount, String? month, String? state,
      {UserAccountAmount? money, String? otp}) {
    try {
      // if (_ispaymenproccessedAlready(month)) {
      //   Get.snackbar(
      //     "Commission",
      //     "Request is already sent",
      //     backgroundColor: AppColors.red,
      //     icon: Container(
      //       height: 100,
      //       width: 100,
      //       decoration: BoxDecoration(
      //           borderRadius: BorderRadius.circular(100),
      //           image: const DecorationImage(
      //               image: AssetImage('assets/tuscany.png'))),
      //     ),
      //   );
      // } else {
      vDatabase.collection('monthCommPay').doc(id).set({
        'otp': otp,
        //  'reference': ref,
        'paymentState': 'init'
      }, SetOptions(merge: true));
      vDatabase
          .collection('userBankAccount')
          .doc(id)
          .set({
            "amount": FieldValue.arrayRemove([
              {
                'monthPay': month,
                'amount': amount,
                'paymentState': money!.paymentState
              },
            ])
          }, SetOptions(merge: true))
          .then((value) => vDatabase.collection('userBankAccount').doc(id).set({
                "amount": FieldValue.arrayUnion([
                  {'monthPay': month, 'amount': amount, 'paymentState': state},
                ]),
              }, SetOptions(merge: true)))
          .then((value) => vDatabase.collection('commission').doc(id).set(
                {
                  "amount": FieldValue.arrayRemove([]),
                },
              ));

      Get.snackbar(
        "Comissision Payment",
        "Payment proccessed",
        backgroundColor: Colors.cyan,
        icon: Container(
          height: Get.width * 0.1,
          width: Get.width * 0.1,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              image: const DecorationImage(
                  image: AssetImage('assets/tuscany.png'))),
        ),
      );
      //  }
    } catch (e) {
      cprint(e);
    }
  }

  staffSalary(String? id, int? amount, String? month) {
    try {
      if (_isSalaryRequestAlreadyAdded(month)) {
        Get.snackbar(
          "Salary",
          "Salary already paid",
          backgroundColor: AppColors.red,
          icon: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                image: const DecorationImage(
                    image: AssetImage('assets/tuscany.png'))),
          ),
        );
      } else {
        vDatabase.collection('staffAccount').doc(id).set({
          "amount": FieldValue.arrayUnion([
            {'month': month, 'amount': amount, 'paymentState': 'paid'},
          ]),
        }, SetOptions(merge: true));
        Get.snackbar(
          "Salary Payment",
          "Salary Paid",
          icon: Container(
            height: Get.width * 0.1,
            width: Get.width * 0.1,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                image: const DecorationImage(
                    image: AssetImage('assets/tuscany.png'))),
          ),
        );
      }
    } catch (e) {
      cprint(e);
    }
  }

  adminUserPaymentActivate(
      {Rx<AdminPaymentActivate>? adminpaymentActivState}) async {
    try {
      final database = Databases(
        clientConnect(),
      );
      await database.listDocuments(
          databaseId: databaseId,
          collectionId: paymentActivate,
          queries: [
            query.Query.equal(
                'date', DateFormat("MMMyyy").format(DateTime.now())),
            query.Query.equal('paymentStatus', 'activate')
          ]).then((data) async {
        if (data.documents.isNotEmpty) {
          await database
              .getDocument(
            databaseId: databaseId,
            collectionId: paymentActivate,
            documentId: '${DateFormat("MMMyyy").format(DateTime.now())}',
          )
              .then((data) {
            adminpaymentActivState!.value =
                AdminPaymentActivate.fromSnapshot(data.data);
            //   //  setState(() {
            //  // viewBanks!.value = ViewBanks.fromSnapshot(data.data);
            //   // });
          });
        }
        // RxList<AdminPaymentActivate> value = data.documents
        //     .map((e) => AdminPaymentActivate.fromSnapshot(e.data))
        //     .toList()
        //     .obs;
        // adminpaymentActiv = value;
      });
      // return shoppingCart;
    } on AppwriteException catch (e) {
      cprint('$e adminUserPaymentActivate');
    }
  }

  //  =>
  //     kDatabase.child('paymentActivate/paymentActivate').onValue.map((event) {
  //       // var map = <String, dynamic>{};
  //       if (event.snapshot.value == null) {
  //         return AdminPaymentActivate.fromSnapshot({});
  //       }
  //       return AdminPaymentActivate.fromSnapshot(event.snapshot.value as Map);
  //     });
  //  vDatabase
  //     .collection('paymentActivate')
  //     .doc('paymentActivate')
  //     .snapshots()
  //     .map((snapshot) => AdminPaymentActivate.fromSnapshot(snapshot.data()));
  Stream<Anouncement> anouncement() =>
      kDatabase.child('anouncements/anouncements').onValue.map((event) {
        if (event.snapshot.value == null) {
          return Anouncement.fromSnapshot({});
        }
        return Anouncement.fromSnapshot(event.snapshot.value as Map);
      });
  //  vDatabase
  //     .collection('anouncements')
  //     .doc('anouncements')
  //     .snapshots()
  //     .map((snapshot) => Anouncement.fromSnapshot(snapshot.data()));
  listenToCart(String? seller) async {
    try {
      final database = Databases(
        clientConnect(),
      );
      await database.listDocuments(
          databaseId: databaseId,
          collectionId: shoppingCartCollection,
          queries: [query.Query.equal('vendorId', seller)]).then((data) {
        RxList<CartItemModel> value = data.documents
            .map((e) => CartItemModel.fromMap(e.data))
            .toList()
            .obs;

        shoppingCart = value;
        shoppingCart.bindStream(value.stream);
      });
      return shoppingCart;
    } on AppwriteException catch (e) {
      cprint('$e listen to Cart');
    }
  }

  // => vDatabase
  //     .collection('bags')
  //     .doc(authState.userId)
  //     .snapshots()
  //     .map((snapshot) => ViewProduct.fromSnapshot(snapshot.data()));
  listenToCard(String? id) async {
    try {
      final database = Databases(
        clientConnect(),
      );
      await database
          .listDocuments(
        databaseId: databaseId,
        collectionId: cdarPay,
        //queries: [query.Query.equal('userId', id)]
      )
          .then((data) {
        RxList<Atm> value =
            data.documents.map((e) => Atm.fromSnapshot(e.data)).toList().obs;

        card = value;
      });
    } catch (e) {}
  }

  //  => vDatabase
  //     .collection('payment')
  //     .doc(id)
  //     .collection('cards')
  //     .doc(id)
  //     .snapshots()
  //     .map((snapshot) => AtmCardModel.fromSnapshot(snapshot.data()));
  Stream<CartSeen> listenToSeenCart() =>
      kDatabase.child('cartState/${authState.userId}').onValue.map((event) {
        // var map = <String, dynamic>{};
        if (event.snapshot.value == null) {
          return CartSeen.fromSnapshot({});
        }
        return CartSeen.fromSnapshot(event.snapshot.value as Map);
      });
  // vDatabase
  //     .collection('cartState')
  //     .doc(authState.userId)
  //     .snapshots()
  //     .map((snapshot) => CartSeen.fromSnapshot(snapshot.data()));
  listenToAllBanks({Rx<ViewBanks>? viewBanks}) async {
    try {
      final database = Databases(
        clientConnect(),
      );
      await database
          .getDocument(
        databaseId: databaseId,
        collectionId: 'banks',
        documentId: 'viewBanks',
      )
          .then((data) {
        //  setState(() {
        viewBanks!.value = ViewBanks.fromSnapshot(data.data);
        // });
      });
    } on AppwriteException catch (e) {
      cprint('$e listenToAllBanks');
    }
  }

  //  => vDatabase
  //     .collection('banks')
  //     .doc('bank')
  //     .snapshots()
  //     .map((snapshot) => ViewBanks.fromSnapshot(snapshot.data()));
  addChipperCashAccount(String? name, String? account,
      {String? authorize, String? pin}) {
    try {
      final database = Databases(
        clientConnect(),
      );
      if (authorize != null) {
        database
            .listDocuments(
          databaseId: databaseId,
          collectionId: chipperCash,
        )
            .then((data) async {
          if (data.documents.isNotEmpty) {
            await database.updateDocument(
              databaseId: databaseId,
              collectionId: chipperCash,
              documentId: '${authState.appUser?.$id}',
              data: {
                'status': authorize,
                'AuthorizedId': pin,
              },
            );
          }
          ;
        });
      } else {
        database
            .listDocuments(
          databaseId: databaseId,
          collectionId: chipperCash,
        )
            .then((data) async {
          if (data.documents.isNotEmpty) {
            await database.updateDocument(
              databaseId: databaseId,
              collectionId: chipperCash,
              documentId: '${authState.appUser?.$id}',
              data: {
                'fullName': name,
                'chipperCashTag': account,
                'userId': '${authState.appUser?.$id}',
                'status': 'New',
              },
            );
          } else {
            await database.createDocument(
              databaseId: databaseId,
              collectionId: chipperCash,
              documentId: '${authState.appUser?.$id}',
              data: {
                'fullName': name,
                'chipperCashTag': account,
                'userId': '${authState.appUser?.$id}',
                'status': 'New',
              },
            );
          }
        });
      }
    } catch (e) {
      cprint(e);
    }
  }

  userBankAccounts(
    String? name,
    String? account,
    String? bank,
    String? bankCode,
    String? country,
    String? bvn,
  ) {
    try {
      final database = Databases(
        clientConnect(),
      );
      database
          .listDocuments(
        databaseId: databaseId,
        collectionId: bankAccounts,
      )
          .then((data) async {
        if (data.documents.isNotEmpty) {
          await database.updateDocument(
            databaseId: databaseId,
            collectionId: bankAccounts,
            documentId: '${authState.appUser?.$id}',
            data: {
              'name': name,
              'account': account,
              'bvn': bvn,
              'country': country,
              'bankCode': bankCode,
              'bank': bank,
              'status': 'updated',
              'email': '${authState.appUser?.email}',
              'phoneNumber': '${authState.userModel?.contact}',
              'userId': '${authState.appUser?.$id}',
              'CountryCode': '${authState.userModel?.countryCode}',
            },
          );
        } else {
          await database.createDocument(
            databaseId: databaseId,
            collectionId: bankAccounts,
            documentId: '${authState.appUser?.$id}',
            data: {
              'name': name,
              'account': account,
              'bvn': bvn,
              'country': country,
              'bankCode': bankCode,
              'status': 'New',
              'bank': bank,
              'userId': '${authState.appUser?.$id}',
              'email': '${authState.appUser?.email}',
              'phoneNumber': '${authState.userModel?.contact}',
              'CountryCode': '${authState.userModel?.countryCode}',
            },
          );
        }
      });

      // vDatabase.collection('userBankAccount').doc(id).set({
      //   'account_name': name,
      //   'bank': bank,
      //   'account_number': account,

      //   'id': id,
      //   'country': country,

      //   'bvn': bvn,
      //   'bank_code': bankCode,
      //   'status': 'added'
      // }, SetOptions(merge: true));
    } catch (e) {
      cprint(e);
    }
  }

  listenToUserBankAccount({Rx<UserBankAccountModel>? bankAccountState}) {
    try {
      final database = Databases(
        clientConnect(),
      );

      database.listDocuments(
          databaseId: databaseId,
          collectionId: bankAccounts,
          queries: [
            //  query.Query.equal('userId', '${authState.appUser?.$id}')
          ]).then((doc) async {
        if (doc.documents.isNotEmpty) {
          database
              .getDocument(
            databaseId: databaseId,
            collectionId: bankAccounts,
            documentId: '${authState.appUser?.$id}',
          )
              .then((doc) async {
            if (doc.data.isNotEmpty) {
              UserBankAccountModel.fromSnapshot(doc.data);
              bankAccountState!.value =
                  UserBankAccountModel.fromSnapshot(doc.data);
            } else {}
            ;
          });
        } else {}
        ;
      });
    } on AppwriteException catch (e) {
      cprint('$e listenToUserBankAccount');
    }
  }

  userChipperCashAccount({Rx<ChipperCash>? chipperState}) {
    try {
      final database = Databases(
        clientConnect(),
      );

      database.listDocuments(
          databaseId: databaseId,
          collectionId: chipperCash,
          queries: [
            query.Query.equal('userId', '${authState.appUser?.$id}')
          ]).then((doc) async {
        if (doc.documents.isNotEmpty) {
          database
              .getDocument(
            databaseId: databaseId,
            collectionId: chipperCash,
            documentId: '${authState.appUser?.$id}',
          )
              .then((doc) async {
            if (doc.data.isNotEmpty) {
              ChipperCash.fromMap(doc.data);
              chipperState!.value = ChipperCash.fromMap(doc.data);
            } else {}
            ;
          });
        } else {}
        ;
      });

      // vDatabase.collection('userBankAccount').doc(id).set({
      //   'account_name': name,
      //   'bank': bank,
      //   'account_number': account,
      //   'id': id,
      //   'country': country,
      //   'bvn': bvn,

      //   'bank_code': bankCode,
      //   'status': 'added'
      // }, SetOptions(merge: true));
    } on AppwriteException catch (e) {
      cprint('$e userChipperCashAccount');
    }
  }

  listenUserCommission(String? userId,
      {RxList<UnPaidCommission>? unPaidCommissionState}) async {
    try {
      final database = Databases(
        clientConnect(),
      );
      await database.listDocuments(
          databaseId: databaseId,
          collectionId: unPaidcommision,
          queries: [query.Query.equal('paidState', 'unpaid')]).then((data) {
        var value = data.documents
            .map((e) => UnPaidCommission.fromSnapshot(e.data))
            .toList();

        unPaidCommissionState?.value = value;
      });

      database.listDocuments(
          databaseId: databaseId,
          collectionId: profileUserColl,
          queries: [query.Query.equal('key', userId.toString())]
          //  queries: [query.Query.equal('key', ductId)]
          ).then((data) {
        if (data.documents.isNotEmpty) {
          var value = data.documents
              .map((e) => ViewductsUser.fromJson(e.data))
              .toList();

          searchState.userlist == value;
        }
      });
    } on AppwriteException catch (e) {
      cprint('$e listen to Cart');
    }
  }

  listenUserPaidCommission(String? userId,
      {RxList<PaidCommission>? paidCommissionState}) async {
    try {
      final database = Databases(
        clientConnect(),
      );
      await database.listDocuments(
          databaseId: databaseId,
          collectionId: unPaidcommision,
          queries: [query.Query.equal('paidState', 'paid')]).then((data) {
        var value = data.documents
            .map((e) => PaidCommission.fromSnapshot(e.data))
            .toList();

        paidCommissionState?.value = value;
      });
    } on AppwriteException catch (e) {
      cprint('$e listenUserPaidCommission');
    }
  }

  // =>
  //   vDatabase.collection('commission').doc(userId).snapshots().map(
  //       (snapshot) =>
  //           UserBankAccountCommissionModel.fromSnapshot(snapshot.data()));
  Stream<ViewProduct> listenToMyCart(String? buyerId, String? sellerId) =>
      vDatabase
          .collection('chatUsers')
          //  reference
          .doc(buyerId)
          .collection('messages')
          .doc(sellerId)
          // .collection('bags')
          // .doc(authState.userId)
          .snapshots()
          .map((snapshot) => ViewProduct.fromSnapshot(snapshot.data()));
  Stream<ViewProduct> sellersBuyersCart(String? buyerId, String? sellerId) =>
      vDatabase
          .collection('chatUsers')
          //  reference
          .doc(buyerId)
          .collection('messages')
          .doc(sellerId)
          // .collection('bags')

          // .doc(authState.userId)
          .snapshots()
          .map((snapshot) => ViewProduct.fromSnapshot(snapshot.data()));
  Stream<List<AdminOrdersModel>> listenOrderState() => kDatabase
      .child('orders')
      .orderByChild('orderState')
      .equalTo('New')
      .onValue
      .map((event) => event.snapshot.children
          .map((p) => AdminOrdersModel.fromMap(p.value as Map))
          .toList());

  // vDatabase
  //     .collection('orders')
  //     .where('orderState', isEqualTo: 'New')
  //     .snapshots()
  //     .map((query) => query.docs
  //         .map((item) => AdminOrdersModel.fromMap(item.data()))
  //         .toList());
  //Stream<List<AdminOrdersModel>>

  // => kDatabase
  //     .child('orders')
  //     // .orderByChild('orderState')
  //     // .equalTo('New')
  //     .onValue
  //     .map((event) => event.snapshot.children
  //         .map((p) => AdminOrdersModel.fromMap(p.value as Map))
  //         .toList());
  // Stream<List<AdminOrdersModel>> listenStaffprocessedOrders(String? userId) =>
  //     kDatabase
  //         .child('orders')
  //         // .orderByChild('staff')
  //         // .equalTo(userId)
  //         .onValue
  //         .map((event) => event.snapshot.children
  //             .map((p) => AdminOrdersModel.fromMap(p.value as Map))
  //             .toList());
  listenToOrders({RxList<OrderViewProduct>? order}) async {
    try {
      final database = Databases(
        clientConnect(),
      );
      await database.listDocuments(
          databaseId: databaseId,
          collectionId: userOrdersCollection,
          queries: [
            query.Query.orderDesc('placedDate'),
          ]).then((data) {
        var value = data.documents
            .map((e) => OrderViewProduct.fromSnapshot(e.data))
            .toList();

        order?.value = value.obs;
        orders = value.obs;
      });
      await database
          .getDocument(
              databaseId: databaseId,
              collectionId: wasabiAcesss,
              documentId: 'wasabiAwas123')
          .then((data) {
        wasabiAws.value = AwsWasabiStorageModel.fromJson(data.data);
      });
      await database
          .listDocuments(
        databaseId: databaseId,
        collectionId: staffColl,
      )
          .then((data) {
        var value = data.documents
            .map((e) => StaffUserModel.fromSnapshot(e.data))
            .toList();

        staff.value = value.obs;
      });
    } on AppwriteException catch (e) {
      cprint('$e listenToOrders');
    }
  }

  listenToPaymentMethod({Rx<PaymentMethodsModel>? pay, String? payment}) async {
    try {
      final database = Databases(
        clientConnect(),
      );
      await database.listDocuments(
          databaseId: databaseId,
          collectionId: paymentsMethods,
          queries: [
            query.Query.equal('method', payment.toString())
          ]).then((doc) async {
        if (doc.documents.isNotEmpty) {
          database
              .getDocument(
            databaseId: databaseId,
            collectionId: paymentsMethods,
            documentId: '$payment',
          )
              .then((doc) async {
            if (doc.data.isNotEmpty) {
              PaymentMethodsModel.fromJson(doc.data);
              pay?.value = PaymentMethodsModel.fromJson(doc.data);
            } else {}
            ;
          });
        } else {}
        ;
      });
    } on AppwriteException catch (e) {
      cprint('$e listenToPaymentMethod');
    }
  }

  listenToOrdersBySellers(String? seller) async {
    try {
      final database = Databases(
        clientConnect(),
      );
      await database.listDocuments(
          databaseId: databaseId,
          collectionId: userOrdersCollection,
          queries: [query.Query.equal('sellerId', seller)]).then((data) {
        var value = data.documents
            .map((e) => OrderViewProduct.fromSnapshot(e.data))
            .toList();

        orders = value.obs;
      });
    } on AppwriteException catch (e) {
      cprint('$e listen to OrdersBySeller');
    }
  }

  //  => kDatabase
  //     .child('orders/${authState.userId}/myOrders')
  //     .onValue
  //     .map((event) => event.snapshot.children
  //         .map((p) => OrderViewProduct.fromSnapshot(p.value as Map))
  //         .toList());
  Stream<List<UserMonthPayCommission>> listenToMonthPayCommission(
          {String? id}) =>
      vDatabase
          .collection('monthCommPay')
          .doc(id)
          .collection('commission')
          .snapshots()
          .map((query) => query.docs
              .map((item) => UserMonthPayCommission.fromSnapshot(item.data()))
              .toList());
  Stream<UserMonthPayCommission> listenInitializeCommissionTransaction(
          {String? id}) =>
      vDatabase.collection('monthCommPay').doc(id).snapshots().map(
          (snapshot) => UserMonthPayCommission.fromSnapshot(snapshot.data()));
  Stream<List<OrderViewProduct>> usersOrders(String? id, String? sellerId) =>
      kDatabase
          .child('orders/$id/myOrders')
          // .orderByChild('orderState')
          // .equalTo('processing')
          .orderByChild('sellerId')
          .equalTo(sellerId)
          .onValue
          .map((event) => event.snapshot.children
              .map((p) => OrderViewProduct.fromSnapshot(p.value as Map))
              .toList());
  Stream<List<OrderViewProduct>> adminUsersOrders(String? id) => kDatabase
      .child('orders/$id/myOrders')
      .orderByChild('orderState')
      .equalTo('processing')
      .onValue
      .map((event) => event.snapshot.children
          .map((p) => OrderViewProduct.fromSnapshot(p.value as Map))
          .toList());
  // vDatabase
  //     .collection('orders')
  //     .doc(id)
  //     .collection('myOrders')
  //     //.orderBy('placedDate')
  //     .where('orderState', isNotEqualTo: 'delivered')
  //     .snapshots()
  //     .map((query) => query.docs
  //         .map((item) => OrderViewProduct.fromSnapshot(item.data()))
  //         .toList());
  // Stream<List<OrderViewProduct>> adminAllUsersOrders(String? id) => kDatabase
  //     .child('orders/$id/myOrders')
  //     .onValue
  //     .map((event) => event.snapshot.children
  //         .map((p) => OrderViewProduct.fromSnapshot(p.value as Map))
  //         .toList());
  // vDatabase
  //     .collection('orders')
  //     .doc(id)
  //     .collection('myOrders')
  //     //.orderBy('placedDate')
  //     //.where('orderState', isNotEqualTo: 'delivered')
  //     .snapshots()
  //     .map((query) => query.docs
  //         .map((item) => OrderViewProduct.fromSnapshot(item.data()))
  //         .toList());
  adminUsersOrdersStateUpdate(
      String? id, String? state, String? orderId, String? staffId) async {
    final databases = Databases(
      clientConnect(),
    );
    try {
      await databases.updateDocument(
        databaseId: databaseId,
        collectionId: userOrdersCollection,
        documentId: '$orderId',
        data: {
          'orderState': '$state',
          'staff': '$staffId',
        },
      );
      await databases.listDocuments(
          databaseId: databaseId,
          collectionId: profileUserColl,
          queries: [query.Query.equal('key', '$id')]
          //  queries: [query.Query.equal('key', ductId)]
          ).then((data) {
        if (data.documents.isNotEmpty) {
          var value = data.documents
              .map((e) => ViewductsUser.fromJson(e.data))
              .toList();

          searchState.viewUserlist.value = value;
          chatState.chatUser ==
              value
                  .firstWhere((data) => data.key == '$id',
                      orElse: () => ViewductsUser())
                  .obs;
          chatState.confirmedOrderStateNotification(
              model: chatState.chatUser, orderState: state, orderId: orderId);
        }
      });
    } on AppwriteException catch (e) {
      cprint('$e listen to allOrders');
    }
  }

  //     =>
  // kDatabase.child('orders/$id/myOrders/$orderId')
  //     // vDatabase
  //     //     .collection('orders')
  //     //     .doc(id)
  //     //     .collection('myOrders')
  //     //     .doc(orderId)

  //     .update(
  //   {'orderState': state, 'staff': staffId},
  // ).then((value) => kDatabase.child('orders/$id')
  //             // vDatabase
  //             //         .collection('orders')
  //             //         .doc(id)
  //             .update(
  //           {'orderState': 'handled'},
  //         ));
  // adminStaffOrdersUpdate(
  //   String? orderId,
  //   String? staffId,
  // ) =>
  //     kDatabase.child('orders/$orderId')
  //         // vDatabase
  //         //     .collection('orders')
  //         //     .doc(orderId)
  //         .update(
  //       {'staff': staffId},
  //     );
  adminAnouncement() async {
    try {
      final database = Databases(
        clientConnect(),
      );
      await database
          .listDocuments(
        databaseId: databaseId,
        collectionId: announcementColl,
      )
          .then((data) {
        var value = data.documents
            .map((e) => AnouncementText.fromSnapshot(e.data))
            .toList();

        announce.value = value.obs;
      });
    } on AppwriteException catch (e) {
      cprint('$e adminAnouncement');
    }
  }

  Stream<TransactionModel> listenInittransaction() => vDatabase
      .collection('cards')
      .doc(authState.userId)
      .snapshots()
      .map((snapshot) => TransactionModel.fromSnapshot(snapshot.data()));
  // .map((snapshot) => OrderViewProduct.fromSnapshot(snapshot.data()));
  updateUserData(Map<dynamic, dynamic> data, String? sellerId,
      String? commissionUser) async {
    logger.i("UPDATED");
    try {
      final database = Databases(
        clientConnect(),
      );
      await database.updateDocument(
        databaseId: databaseId,
        collectionId: shoppingCartCollection,
        documentId: sellerId.toString(),
        data: data,
      );
    } on AppwriteException catch (e) {
      cprint('$e listenInittransaction');
    }
    // var timestamps = Timestamp.now().toDate().toUtc().toString();
    // kDatabase.child('chatUsers/$sellerId/messages/${authState.userId}').update({
    //   'orderState': null,
    //   'userId': authState.userId,
    //   'message': '',
    //   'created_at': timestamps,
    //   'sender_id': authState.userId,
    //   'receiverId': sellerId,
    //   "sellerId": sellerId,
    //   'imageKey': null,
    //   'imagePath': null,
    //   'seen': chatState.onlineStatus.value.chatOnlineChatStatus == true
    //       ? true
    //       : false,
    //   'type': 2,
    //   'timeStamp': DateTime.now().toUtc().millisecondsSinceEpoch,
    //   'senderName': authState.user!.displayName,
    // });

    // vDatabase
    //     .collection('chatUsers')
    //     .doc(sellerId)
    //     .collection('messages')
    //     .doc(authState.userId)
    //     // .collection('bags')
    //     // .doc(authState.userId)
    //     .set(data, SetOptions(merge: true));
    // vDatabase
    //     .collection('chatUsers')
    //     .doc(authState.userId)
    //     .collection('messages')
    //     .doc(sellerId)
    //     // .collection('bags')
    //     // .doc(authState.userId)
    //     .set(data, SetOptions(merge: true));
  }

  addItemToCart(
      FeedModel? product, String? commissionUser, String? color, String? size,
      {Rx<ViewductsUser>? ductUser}
      // String? size,
      // String? color,
      // String? userId,
      // String? vendorId,
      // String? name,
      // String? store,
      // String? image,
      // String? price
      ) async {
    EasyLoading.show(status: 'Adding to Cart', dismissOnTap: true);
    await serverApi.createConversation(
        authState.appUser!.$id.toString(), product!.userId.toString());
    final database = Databases(
      clientConnect(),
    );

    final id =
        '${authState.appUser?.$id.splitByLength((authState.appUser!.$id.toString().length) ~/ 2)[0]}_${product.key.toString().splitByLength((product.key.toString().length) ~/ 2)[0]}';

    try {
      database
          .listDocuments(
              databaseId: databaseId, collectionId: shoppingCartCollection)
          .then((data) async {
        if (data.documents.isEmpty) {
          ChatMessage message;
          var timestamps = DateTime.now().toUtc().toString();
          final encrypted = await TextEncryptDecrypt.encryptAES(
              'I am intrested in buying ${product.productName}');
          var key = Uuid().v1();
          String _multiChannelName;
          // List<String> list = [
          //   authState.userModel!.key!.substring(4, 15),
          //   ductUser!.value.key!.substring(4, 15)
          // ];
          // list.sort();
          _multiChannelName =
              '${authState.userModel!.key!.substring(4, 15)}-${product.userId!.substring(4, 15)}';
          // ignore: prefer_const_constructors
          var commissionId = Uuid().v1();
          //  var timestamps = DateTime.now().toUtc().toString();
          cprint('${feedState.dataBaseChatsId?.value} add to cart');
          // var chatId = const Uuid().v1();
          await database.createDocument(
            databaseId: databaseId,
            collectionId: shoppingCartCollection,
            documentId: id,
            data: {
              'key': id,
              'id': product.key,
              'productId': product.key,
              'size': size.toString(),
              'color': color.toString(),
              'quantity': 1,
              'commissionId': commissionId,
              'vendorId': product.userId,
              'name': product.productName,
              'store': product.store,
              'price': product.price,
              'commissionUser': commissionUser,
              'commissionPrice': product.commissionPrice.toString()
            },
          );

          message = ChatMessage(
              message: encrypted,
              key: key,
              newChats: 'true',
              productName: ' ${product.productName}',
              imageKey: product.key,
              createdAt: timestamps,
              receiverId: product.userId,
              chatlistKey: feedState.dataBaseChatsId?.value,
              senderId: authState.appUser?.$id,
              userId: authState.userModel!.userId,
              seen: chatState.onlineStatus.value.chatOnlineChatStatus == true
                  ? 'true'
                  : 'false',
              type: 2,
              timeStamp: DateTime.now().toUtc().millisecondsSinceEpoch,
              senderName: authState.userModel?.displayName);
          await SQLHelper.createLocalMessages(message);
          await database.listDocuments(
              databaseId: databaseId.toString(),
              collectionId: chatsColl.toString(),
              queries: [
                query.Query.equal('chatlistKey', message.chatlistKey.toString())
              ]).then((data) async {
            message.key = _multiChannelName.toString();
            if (data.documents.isNotEmpty) {
              await database.updateDocument(
                databaseId: databaseId,
                collectionId: chatsColl,
                documentId: _multiChannelName.toString(),
                data: message.toJson(),
              );
              cprint('message updated for cart');
            } else if (data.documents.isEmpty) {
              await database.createDocument(
                databaseId: databaseId.toString(),
                collectionId: chatsColl.toString(),
                documentId: _multiChannelName.toString(),
                data: message.toJson(),
              );
              cprint('message created online for cart');
            } else {}
          });

          chatState.sendAndRetrieveMessage(message);

          // await chatState.onMessageSubmitted(
          //     message,
          //     authState.userModel!.key.toString(),
          //     ductUser.value.key.toString(),
          //     instMsg);
          EasyLoading.dismiss();
          // kDatabase
          //     .child('cartState/${authState.userId}')
          //     .set({'state': 'added', "uid": authState.userId});
          // updateUserData({
          //   'orderState': null,
          //   'userId': authState.userId,
          //   'message': '',
          //   'created_at': timestamps,
          //   'sender_id': authState.userId,
          //   'receiverId': product.user!.userId,
          //   'sellerId': product.userId,
          //   'imageKey': null,
          //   'imagePath': null,
          //   'seen': chatState.onlineStatus.value.chatOnlineChatStatus == true
          //       ? true
          //       : false,
          //   'type': 2,
          //   'timeStamp': DateTime.now().toUtc().millisecondsSinceEpoch,
          //   'senderName': authState.user!.displayName,
          //   "products": FieldValue.arrayUnion([
          //     {
          //       'id': product.key,
          //       'size': size,
          //       'color': color,
          //       'quantity': 1,
          //       'commissionId': commissionId,
          //       'vendorId': product.userId,
          //       'name': product.productName,
          //       'store': product.store,
          //       'price': product.price,
          //       'commissionUser': commissionUser,
          //       'commissionPrice': product.commissionPrice
          //     },
          //   ]),
          // }, product.user!.userId, commissionUser);

          StatusAlert.show(Get.context!,
              duration: const Duration(seconds: 2),
              title: 'Cart',
              subtitle: "${product.productName} was added to your cart",
              configuration: const IconConfiguration(
                  icon: CupertinoIcons.cart_badge_plus));
          // Get.snackbar(
          //   "Item added",
          //   "${product.productName} was added to your cart",
          //   icon: Container(
          //     height: Get.width * 0.1,
          //     width: Get.width * 0.1,
          //     decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(100),
          //         image: const DecorationImage(
          //             image: AssetImage('assets/carts.png'))),
          //   ),
          // );
        } else {
          StatusAlert.show(Get.context!,
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.red,
              title: 'Cart',
              subtitle: "${product.productName} already added to your cart",
              configuration: const IconConfiguration(
                  icon: CupertinoIcons.cart_badge_plus));
          // Get.snackbar(
          //   "Check your cart",
          //   "${product.productName} is already added",
          //   backgroundColor: AppColors.red,
          //   icon: Container(
          //     height: 100,
          //     width: 100,
          //     decoration: BoxDecoration(
          //         borderRadius: BorderRadius.circular(100),
          //         image: const DecorationImage(
          //             image: AssetImage('assets/carts.png'))),
          //   ),
          // );
        }
      });
    } catch (e) {
      Get.snackbar("Error", "Cannot add this item");
      cprint(e.toString());
    }
  }

  changeComissionAmount(RxList<UnPaidCommission> unPaidCommissions) {
    totalCommissionAmount.value = 0;
    if (unPaidCommissions.isNotEmpty) {
      for (var cartItem in unPaidCommissions) {
        totalCommissionAmount += int.parse(unPaidCommissions
            .firstWhere((data) => data.commisionUser == cartItem.commisionUser)
            .amount
            .toString());
      }
    }
  }

  changePaidComissionAmount(RxList<PaidCommission> paidCommissions) {
    totalPaidCommissionAmount.value = 0;
    if (paidCommissions.isNotEmpty) {
      for (var cartItem in paidCommissions) {
        totalPaidCommissionAmount += int.parse(paidCommissions
            .firstWhere((data) => data.commisionUser == cartItem.commisionUser)
            .amount
            .toString());
      }
    }
  }

  changeCartTotalPrice() {
    totalCartPrice.value = 0;
    if (shoppingCart.isNotEmpty) {
      // for (var cartItem in shoppingCart) {
      //   totalCartPrice += ((int.parse(feedState.productlist!
      //           .firstWhere((e) => e.key == cartItem.id)
      //           .price
      //           .toString()) *
      //       int.parse(cartItem.quantity.toString())));
      // }
    }
  }

  changeCartTotalWeight() {
    totalCartWeight.value = 0;
    if (shoppingCart.isNotEmpty) {
      for (var cartItem in shoppingCart) {
        totalCartWeight += (int.parse(feedState.productlist!
                .firstWhere((e) => e.key == cartItem.id)
                .weight
                .toString()) *
            int.parse(cartItem.quantity.toString()));
      }
    }
  }

  changeCartTotalShipping() {
    totalCartShipping.value = 0;
    if (shoppingCart.isNotEmpty) {
      for (var cartItem in shoppingCart) {
        totalCartShipping += ((int.parse(feedState.productlist!
                    .firstWhere((e) => e.key == cartItem.id)
                    .weight
                    .toString()) *
                int.parse(cartItem.quantity.toString())) *
            100);
      }
    }
  }

  removeCartItem(CartItemModel cartItem) async {
    try {
      final database = Databases(
        clientConnect(),
      );
      cprint(cartItem.key.toString());
      await database.deleteDocument(
        databaseId: databaseId,
        collectionId: shoppingCartCollection,
        documentId: cartItem.key.toString(),
      );
      //   updateUserData(cartItem.toJson(), cartItem.key, cartItem.key);
    } catch (e) {
      Get.snackbar("Error", "Cannot remove this item");
      //  debugPrint(e.message);
    }
  }

  // changeCartTotalPrice(UserModel userModel) {
  //   totalCartPrice.value = 0.0;
  //   if (userModel.cart.isNotEmpty) {
  //     userModel.cart.forEach((cartItem) {
  //       totalCartPrice += cartItem.cost;
  //     });
  //   }
  // }

  bool _isSalaryRequestAlreadyAdded(String? month) =>
      adminStaffController.account.value.amount!
          .where((item) => item.month == month)
          .isNotEmpty;
  decreaseQuantity(CartItemModel item) async {
    if (item.quantity == 1) {
      await removeCartItem(item);
    } else {
      // removeCartItem(item);
      item.quantity = (item.quantity! - 1);
      await updateUserData({
        'key': item.key,
        'id': item.id,
        'size': item.size,
        'color': item.color,
        'quantity': item.quantity,
        'vendorId': item.vendorId,
        'name': item.name,
        'store': item.store,
        'price': item.price,
        'commissionUser': item.commissionUser,
        'commissionPrice': item.commissionPrice,
        'commissionId': Uuid().v1().toString()
      }, item.key, item.key);
    }
  }

  increaseQuantity(CartItemModel item) async {
    // removeCartItem(item);
    item.quantity = (item.quantity! + 1);
    logger.i({"quantity": item.quantity});

    await updateUserData(
      {
        'key': item.key,
        'id': item.id,
        'size': item.size,
        'color': item.color,
        'quantity': item.quantity,
        'vendorId': item.vendorId,
        'name': item.name,
        'store': item.store,
        'price': item.price,
        'commissionUser': item.commissionUser,
        'commissionPrice': item.commissionPrice,
        'commissionId': Uuid().v1().toString()
      },
      item.key,
      item.key,
    );
  }
}

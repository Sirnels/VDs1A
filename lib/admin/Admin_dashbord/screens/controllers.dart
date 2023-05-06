import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_appwrite/dart_appwrite.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:viewducts/helper/showingLoading.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/state/appState.dart';
import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:appwrite/appwrite.dart' as query;

class AdminStaffUserController extends AppState {
  static AdminStaffUserController instance =
      Get.find<AdminStaffUserController>();
  //late Rx<User?> firebaseUser;
  RxBool isLoggedIn = false.obs;
  RxList<AdminOrdersModel> staffprocessedUserOrders =
      RxList<AdminOrdersModel>();
  RxList<AdminOrdersModel> orderState = RxList<AdminOrdersModel>();
  RxList<AdminOrdersModel> adminUserOrders = RxList<AdminOrdersModel>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController role = TextEditingController();
  RxList<StaffUserModel> staff = RxList<StaffUserModel>();

  RxList<RequestedCommissionState> commissionRequested =
      RxList<RequestedCommissionState>();
  Rx<StaffProfileModel> cart = StaffProfileModel(amount: []).obs;
  Rx<StaffUserModel> staffRole = StaffUserModel().obs;
  String usersCollection = "staff";
  Rx<StaffUserModel> userModel = StaffUserModel().obs;
  RxList<OrderViewProduct> orders = RxList<OrderViewProduct>();
  RxList<OrderViewProduct> proccessedorders = RxList<OrderViewProduct>();
  FirebaseAuth auth = FirebaseAuth.instance;
  Rx<StaffProfileModel> account = StaffProfileModel(amount: []).obs;
  Rx<UserBankAccountModel> useraccounts = UserBankAccountModel(amount: []).obs;
  Rx<UserBankAccountCommissionModel> commission =
      UserBankAccountCommissionModel(amount: []).obs;
  @override
  void onReady() {
    super.onReady();
    viewductsStaffActivd();
    // firebaseUser = Rx<User>(auth.currentUser!);
    // staff.bindStream(listenToUser());
    // staffRole.bindStream(listenToUserRole());
  }

  viewductsStaffActivd() async {
    try {
      final database = Databases(
        serverApi.serverClientConnect(),
      );

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
      await database.listDocuments(
          databaseId: databaseId,
          collectionId: profileUserColl,
          queries: [query.Query.equal('key', authState.appUser?.$id.toString())]
          //  queries: [query.Query.equal('key', ductId)]
          ).then((data) {
        if (data.documents.isNotEmpty) {
          var value = data.documents
              .map((e) => ViewductsUser.fromJson(e.data))
              .toList();

          searchState.viewUserlistChatList = value.obs;
          chatState.chatUser ==
              value
                  .firstWhere((data) => data.key == authState.appUser?.$id,
                      orElse: () => ViewductsUser())
                  .obs;
        }
      });
    } on AppwriteException catch (e) {
      cprint('$e listenToOrders');
    }
  }

  userConfirmCommissionPayment(String? userId, String? month) async {
    try {
      final database = Databases(
        serverApi.serverClientConnect(),
      );
      await database.listDocuments(
          databaseId: databaseId,
          collectionId: monthlycommisionPayment,
          queries: [query.Query.equal('monthPay', month)]).then((data) async {
        if (data.documents.isEmpty) {
          await database.createDocument(
            databaseId: databaseId,
            collectionId: monthlycommisionPayment,
            documentId: '$userId$month',
            data: {
              'userId': userId,
              'monthPay': month,

              //  'reference': ref,
              'paymentState': 'paid'
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
                      '$month Commission  paid',
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
                      '$month Commission  piad Already',
                      style: TextStyle(
                          color: CupertinoColors.darkBackgroundGray,
                          fontWeight: FontWeight.w900),
                    )),
              ),
              gravity: ToastGravity.TOP_LEFT,
              toastDuration: Duration(seconds: 3));
        }
      });
    } on AppwriteException catch (e) {
      print(e);
    }
  }

  Stream<StaffProfileModel> listenToAccount(String? id) => vDatabase
      .collection('staffAccount')
      .doc(id)
      .snapshots()
      .map((snapshot) => StaffProfileModel.fromSnapshot(snapshot.data()));
  Stream<UserBankAccountModel> listenToUserBankAccount(String? id) => vDatabase
      .collection('userBankAccount')
      .doc(id.toString())
      .snapshots()
      .map((snapshot) => UserBankAccountModel.fromSnapshot(snapshot.data()));
  adminStaffAccount(
    String? id,
    String? bank,
    String? account,
  ) =>
      vDatabase.collection('staffAccount').doc(id).set(
          {'bank': bank, 'account': account, 'id': id},
          SetOptions(merge: true));
  generalAnouncement(String? userId, String? announcement) async {
    try {
      final database = Databases(
        clientConnect(),
      );
      await database.createDocument(
          databaseId: databaseId,
          collectionId: chatsColl,
          documentId: 'unique()',
          data: {'announce': announcement.toString()});
    } on AppwriteException catch (e) {
      cprint('$e adminAnouncement');
    }
  }

  userBankAccount(String? id, String? bank, String? account, String? country,
      String? name, int? bvn, String? bankCode) {
    try {
      vDatabase.collection('userBankAccount').doc(id).set({
        'account_name': name,
        'bank': bank,
        'account_number': account,
        'id': id,
        'country': country,
        'bvn': bvn,
        'bank_code': bankCode,
        'status': 'added'
      }, SetOptions(merge: true));
    } catch (e) {
      cprint(e);
    }
  }

  listenAdminUserOrders() async {
    try {
      final database = Databases(
        serverApi.serverClientConnect(),
      );
      await database
          .listDocuments(
        databaseId: databaseId,
        collectionId: orderStateCollection,
        //userOrdersCollection,
      )
          .then((data) {
        var value = data.documents
            .map((e) => AdminOrdersModel.fromMap(e.data))
            .toList();

        adminUserOrders.value = value;
      });
    } on AppwriteException catch (e) {
      cprint('$e listen to AdminUserOrders');
    }
  }

  addUnpaidCommissionAmount(String? commissionuserId, String? ammount,
      String? productId, String? commissionId) async {
    try {
      FToast().init(Get.context!);
      final database = Databases(
        serverApi.serverClientConnect(),
      );
      await database.listDocuments(
          databaseId: databaseId,
          collectionId: unPaidcommision,
          queries: [
            query.Query.equal('commissionId', commissionId)
          ]).then((data) async {
        if (data.documents.isEmpty) {
          await database.createDocument(
            databaseId: databaseId,
            collectionId: unPaidcommision,
            documentId: commissionId!,
            permissions: [Permission.read(Role.user('$commissionuserId'))],
            data: {
              'month': DateFormat("MMM yyy").format(DateTime.now()),
              'amount': ammount,
              'productId': productId,
              'commissionId': commissionId,
              'commisionUser': commissionuserId,
              'paidState': 'unpaid',
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
                      '${DateFormat("MMM yyy").format(DateTime.now())} Commission ₦$ammount',
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
                      '${DateFormat("MMM yyy").format(DateTime.now())} Commission ₦$ammount Added Already',
                      style: TextStyle(
                          color: CupertinoColors.darkBackgroundGray,
                          fontWeight: FontWeight.w900),
                    )),
              ),
              gravity: ToastGravity.TOP_LEFT,
              toastDuration: Duration(seconds: 3));
        }
      });
      // if (_isCommissionAlreadyAdded(commissionId)) {
      //   Get.snackbar(
      //     "Commission",
      //     "$ammount is already added",
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

      //   Get.snackbar(
      //     "Comissision",
      //     "$ammount was added to comission account",
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
      cprint('$e addCommissionAmount');
    }
  }

  adminPaymentActivate(String? status, String? date) async {
    FToast().init(Get.context!);
    try {
      final database = await Databases(
        serverApi.serverClientConnect(),
      );
      await database.listDocuments(
          databaseId: databaseId,
          collectionId: '630eb73a077165fd31f0',
          queries: [
            query.Query.equal('date', date),
          ]).then((data) async {
        if (data.documents.isEmpty) {
          await database.createDocument(
            databaseId: databaseId,
            collectionId: '630eb73a077165fd31f0',
            documentId: date.toString(),
            permissions: [Permission.read(Role.users())],
            data: {
              'paymentStatus': status,
              'staff': authState.userId,
              'date': date,
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
                        color: status == 'activate'
                            ? CupertinoColors.activeGreen
                            : CupertinoColors.systemRed),
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      '${DateFormat("MMM yyy").format(DateTime.now())} Payment $status',
                      style: TextStyle(
                          color: CupertinoColors.darkBackgroundGray,
                          fontWeight: FontWeight.w900),
                    )),
              ),
              gravity: ToastGravity.TOP_LEFT,
              toastDuration: Duration(seconds: 3));
        } else {
          await database.updateDocument(
            databaseId: databaseId,
            collectionId: '630eb73a077165fd31f0',
            documentId: date.toString(),
            permissions: [Permission.read(Role.users())],
            data: {
              'paymentStatus': status,
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
                        color: status == 'activate'
                            ? CupertinoColors.activeGreen
                            : CupertinoColors.systemRed),
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      '${DateFormat("MMM yyy").format(DateTime.now())} Payment $status',
                      style: TextStyle(
                          color: CupertinoColors.darkBackgroundGray,
                          fontWeight: FontWeight.w900),
                    )),
              ),
              gravity: ToastGravity.TOP_LEFT,
              toastDuration: Duration(seconds: 3));
        }
      });
    } on AppwriteException catch (e) {
      cprint('$e adminPaymentActivate');
    }
  }

  //  =>
  //     kDatabase.child('paymentActivate/paymentActivate').set({
  //       'paymentStatus': status,
  //       'staff': authState.userId,
  //       'date': date,
  //     });
  adminIndividualUsersOrders(String? id) async {
    try {
      final database = Databases(
        serverApi.serverClientConnect(),
      );
      await database.listDocuments(
          databaseId: databaseId,
          collectionId: userOrdersCollection,
          queries: [
            query.Query.equal('userId', '$id'),
            query.Query.equal('staff', authState.appUser?.$id.toString()),
          ]).then((data) {
        var value = data.documents
            .map((e) => OrderViewProduct.fromSnapshot(e.data))
            .toList();
        proccessedorders.value = value;
        orders.value = value;
      });
    } on AppwriteException catch (e) {
      cprint('$e listen to adminIndividualUsersOrders');
    }
  }

  listenStaffprocessedOrders(String? userId) async {
    try {
      final database = Databases(
        serverApi.serverClientConnect(),
      );
      await database.listDocuments(
          databaseId: databaseId,
          collectionId: userOrdersCollection,
          queries: [
            query.Query.equal('staff', authState.appUser?.$id.toString()),
          ]).then((data) {
        var value = data.documents
            .map((e) => AdminOrdersModel.fromMap(e.data))
            .toList();

        staffprocessedUserOrders.value = value;
      });
    } on AppwriteException catch (e) {
      cprint('$e listen to listenStaffprocessedOrders');
    }
  }

  allOrders() async {
    try {
      final database = Databases(
        serverApi.serverClientConnect(),
      );
      await database.listDocuments(
          databaseId: databaseId,
          collectionId: userOrdersCollection,
          queries: [
            query.Query.orderDesc('placedDate'),
            query.Query.equal('orderState', 'processing'),
          ]).then((data) {
        var value = data.documents
            .map((e) => AdminOrdersModel.fromMap(e.data))
            .toList();

        orderState.value = value;
      });
    } on AppwriteException catch (e) {
      cprint('$e listen to allOrders');
    }
  }

  adminUsersOrdersStateUpdates(
      String? id, String? state, String? orderId, String? staffId) async {
    final databases = Databases(
      serverApi.serverClientConnect(),
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

  adminStaffOrdersUpdate(String? orderId, String? staffId,
      {ViewductsUser? user, String? orderState, String? buyerId}) async {
    try {
      final database = Databases(
        serverApi.serverClientConnect(),
      );
      await database.updateDocument(
        databaseId: databaseId,
        collectionId: userOrdersCollection,
        documentId: '$orderId',
        data: {
          'orderState': 'confirm',
          'staff': '$staffId',
        },
      );
      await database.listDocuments(
          databaseId: databaseId,
          collectionId: profileUserColl,
          queries: [query.Query.equal('key', '$buyerId')]
          //  queries: [query.Query.equal('key', ductId)]
          ).then((data) {
        if (data.documents.isNotEmpty) {
          var value = data.documents
              .map((e) => ViewductsUser.fromJson(e.data))
              .toList();

          searchState.viewUserlist.value = value;
          chatState.chatUser ==
              value
                  .firstWhere((data) => data.key == '$buyerId',
                      orElse: () => ViewductsUser())
                  .obs;
          chatState.confirmedOrderStateNotification(
              model: chatState.chatUser,
              orderState: orderState,
              orderId: orderId);
        }
      });
    } on AppwriteException catch (e) {
      cprint('$e listen to allOrders');
    }
  }

  addCommissionAmount(String? commissionuserId, String? ammount,
      String? productId, String? commissionId) async {
    try {
      final database = Databases(
        serverApi.serverClientConnect(),
      );
      await database.createDocument(
        databaseId: databaseId,
        collectionId: userOrdersCollection,
        documentId: '$commissionId',
        data: {
          'month': DateTime.now(),
          'amount': ammount,
          'productId': productId,
          'commissionId': commissionId
        },
      );
    } on AppwriteException catch (e) {
      cprint('$e listen to allOrders');
    }
  }

  void signIn() async {
    try {
      //showLoading();
      await auth
          .signInWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim())
          .then((result) {
        _clearControllers();
      });
    } catch (e) {
      debugPrint(e.toString());
      Get.snackbar("Sign In Failed", "Try again");
    }
  }

  void signUp(String? userId, String? profilePic, String? fcm) async {
    //showLoading();
    try {
      await _addUserToFirestore(userId, profilePic, fcm);
      _clearControllers();
    } catch (e) {
      dismissLoadingWidget();
      debugPrint(e.toString());
      Get.snackbar("Sign In Failed", "Try again");
    }
  }

  void signOut() async {
    // auth.signOut();
  }

  _addUserToFirestore(String? userId, String? profilePic, String? fcm) async {
    final database = Databases(
      serverApi.serverClientConnect(),
    );
    await database.createDocument(
        databaseId: databaseId,
        collectionId: staffColl,
        documentId: userId.toString(),
        data: {
          "name": name.text.trim(),
          "id": userId,
          "email": email.text.trim(),
          "role": role.text.trim(),
          "country": country.text.trim(),
          "state": state.text.trim(),
          "profilePic": profilePic,
          "fcm": fcm
        });
    // vDatabase.collection('staff').doc(userId).set({
    //   "name": name.text.trim(),
    //   "id": userId,
    //   "email": email.text.trim(),
    //   "role": role.text.trim(),
    //   "country": country.text.trim(),
    //   "state": state.text.trim(),
    //   //"cart": []
    // });
    // kDatabase.child('staff/$userId').update({
    //   "name": name.text.trim(),
    //   "id": userId,
    //   "email": email.text.trim(),
    //   "role": role.text.trim(),
    //   "country": country.text.trim(),
    //   "state": state.text.trim(),
    //   //"cart": []
    // });
  }

  _clearControllers() {
    name.clear();
    email.clear();
    password.clear();
    role.clear();
    country.clear();
    state.clear();
  }

  // updateUserData(Map<String, dynamic> data) {
  //   logger.i("UPDATED");
  //   vDatabase
  //       .collection(usersCollection)
  //       .doc(firebaseUser.value!.uid)
  //       .update(data);
  // }

  Stream<List<StaffUserModel>> listenToUser() =>
      kDatabase.child('staff').onValue.map((event) => event.snapshot.children
          .map((p) => StaffUserModel.fromSnapshot(p.value as Map))
          .toList());
  //  vDatabase
  //     .collection('staff')
  //     // .doc(firebaseUser.value!.uid)
  //     .snapshots()
  //     .map((query) => query.docs
  //         .map((item) => StaffUserModel.fromSnapshot(item.data()))
  //         .toList());
}

Stream<StaffUserModel> listenToUserRole() => vDatabase
    .collection('staff')
    .doc()
    .snapshots()
    .map((snapshot) => StaffUserModel.fromSnapshot(snapshot.data()));

class AuthenticationScreen extends StatefulWidget {
  final ViewductsUser? user;

  const AuthenticationScreen({Key? key, this.user}) : super(key: key);
  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.width / 3),
            customImage(context, widget.user?.profilePic.toString(),
                height: 200),
            // Image.asset(
            //   'assets/delicious.png',
            //   width: 200,
            // ),
            SizedBox(height: MediaQuery.of(context).size.width / 5),
            // Visibility(
            //     visible: _appController.isLoginWidgetDisplayed.value,
            //     child: LoginWidget()),
            RegistrationWidget(user: widget.user)
            // Visibility(
            //     visible: !_appController.isLoginWidgetDisplayed.value,
            //     child: RegistrationWidget(user: widget.user)),
            // const SizedBox(
            //   height: 10,
            // ),
            // Visibility(
            //   visible: _appController.isLoginWidgetDisplayed.value,
            //   child: BottomTextWidget(
            //     onTap: () {
            //       _appController.changeDIsplayedAuthWidget();
            //     },
            //     text1: "Don\'t have an account?",
            //     text2: "Create account!",
            //   ),
            // ),
            // Visibility(
            //   visible: !_appController.isLoginWidgetDisplayed.value,
            //   child: BottomTextWidget(
            //     onTap: () {
            //       _appController.changeDIsplayedAuthWidget();
            //     },
            //     text1: "Already have an account?",
            //     text2: "Sign in!!",
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class AdminAppController extends GetxController {
  static AdminAppController instance = Get.find<AdminAppController>();
  RxBool isLoginWidgetDisplayed = true.obs;

  changeDIsplayedAuthWidget() {
    isLoginWidgetDisplayed.value = !isLoginWidgetDisplayed.value;
  }
}

class BottomTextWidget extends StatelessWidget {
  final Function? onTap;
  final String? text1;
  final String? text2;

  const BottomTextWidget({Key? key, this.onTap, this.text1, this.text2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap!(),
      child: RichText(
          text: TextSpan(children: [
        TextSpan(text: text1, style: const TextStyle(color: Colors.black)),
        TextSpan(text: " $text2", style: const TextStyle(color: Colors.blue))
      ])),
    );
  }
}

class LoginWidget extends StatelessWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.5),
              blurRadius: 10,
            )
          ],
          borderRadius: BorderRadius.circular(20)),
      child: Wrap(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                margin: const EdgeInsets.only(top: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.grey.withOpacity(.3),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: TextField(
                    controller: adminStaffController.email,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.email_outlined),
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        hintText: "Email"),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                margin: const EdgeInsets.only(top: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.grey.withOpacity(.3),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: TextField(
                    controller: adminStaffController.password,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.lock),
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        hintText: "Password"),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: CustomButton(
                text: "Login",
                onTap: () {
                  adminStaffController.signIn();
                }),
          )
        ],
      ),
    );
  }
}

class RegistrationWidget extends StatelessWidget {
  final ViewductsUser? user;

  const RegistrationWidget({Key? key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.5),
              blurRadius: 10,
            )
          ],
          borderRadius: BorderRadius.circular(20)),
      child: Wrap(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                margin: const EdgeInsets.only(top: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.grey.withOpacity(.3),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: TextField(
                    controller: adminStaffController.name,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        hintText: "Name"),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                margin: const EdgeInsets.only(top: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.grey.withOpacity(.3),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: TextField(
                    controller: adminStaffController.role,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        hintText: "Role"),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                margin: const EdgeInsets.only(top: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.grey.withOpacity(.3),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: TextField(
                    controller: adminStaffController.country,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        hintText: "Country"),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                margin: const EdgeInsets.only(top: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.grey.withOpacity(.3),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: TextField(
                    controller: adminStaffController.state,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        hintText: "State"),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                margin: const EdgeInsets.only(top: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.grey.withOpacity(.3),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: TextField(
                    controller: adminStaffController.email,
                    decoration: const InputDecoration(
                        icon: Icon(Icons.email_outlined),
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        hintText: "Email"),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: CustomButton(
                text: "Register",
                onTap: () {
                  adminStaffController.signUp(
                      user?.userId, user?.profilePic, user?.fcmToken);
                }),
          )
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String? text;
  final Color? txtColor;
  final Color? bgColor;
  final Color? shadowColor;
  final Function? onTap;

  const CustomButton(
      {Key? key,
      @required this.text,
      this.txtColor,
      this.bgColor,
      this.shadowColor,
      @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap!(),
      child: PhysicalModel(
        color: Colors.grey.withOpacity(.4),
        elevation: 2,
        borderRadius: BorderRadius.circular(20),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: bgColor ?? Colors.black,
            ),
            child: Container(
              margin: const EdgeInsets.all(14),
              alignment: Alignment.center,
              child: CustomText(
                text: text,
                color: txtColor ?? Colors.white,
                size: 22,
                weight: FontWeight.normal,
              ),
            )),
      ),
    );
  }
}

class CustomText extends StatelessWidget {
  final String? text;
  final double? size;
  final Color? color;
  final FontWeight? weight;

  const CustomText({Key? key, this.text, this.size, this.color, this.weight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      style: TextStyle(
          fontSize: size ?? 16,
          color: color ?? Colors.black,
          fontWeight: weight ?? FontWeight.normal),
    );
  }
}

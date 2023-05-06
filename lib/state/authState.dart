// ignore_for_file: unnecessary_null_comparison, invalid_return_type_for_catch_error, void_checks, body_might_complete_normally_nullable, file_names, unused_field, unused_element
import 'dart:async';
import 'dart:convert';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'dart:io';
import 'package:appwrite/models.dart' as appModels;
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:appwrite/appwrite.dart' as query;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:viewducts/helper/enum.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/chatModel.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/page/Auth/phoneprofile.dart';
import 'package:viewducts/page/Auth/welcomePage.dart';
import 'package:viewducts/page/homePage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:viewducts/page/message/local_database.dart';
import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/duct/ductStoryPage.dart';
import 'appState.dart';
import 'package:appwrite/appwrite.dart';

import 'package:uni_links/uni_links.dart';

class AuthState extends AppState {
  static AuthState instance = Get.find<AuthState>();
  RxBool isLoggedIn = false.obs;
  User? user;
  appModels.Session? session;
  appModels.Account? appUser;
  Rx<AuthStatus> authStatus = AuthStatus.NOT_DETERMINED.obs;
  bool isSignInWithGoogle = false;
  RxList<ViewductsUser> profileData = RxList<ViewductsUser>([]);
  String? userId;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  RxString networkConnectionState = ''.obs;
  // ignore: prefer_typing_uninitialized_variables
  var _profileQuery;
  //ViewductsUser? userModel;
  Rx<List<ViewductsUser?>>? _profileUserModelList =
      Rx<List<ViewductsUser?>>([]);
  //= RxList<ViewductsUser>([]);
  ViewductsUser? _userModel;
  Rx<ViewductsUser> profileUser = ViewductsUser().obs;

  //= ViewductsUser().obs;
  Function? onSuccess;
  User? get users => user;
  RxString locationIpAdress = ''.obs;
  RxString logginType = ''.obs;
  ViewductsUser? get userModel => profileUser.value;
  final TextEditingController lastName = TextEditingController();
  TextEditingController? nameController = TextEditingController();
  TextEditingController? accountNumber = TextEditingController();

  TextEditingController? emailController = TextEditingController();
  final TextEditingController? country = TextEditingController();
  final TextEditingController? state = TextEditingController();
  final TextEditingController? contact = TextEditingController();
  final TextEditingController? bank = TextEditingController();
  final TextEditingController? businessCategory = TextEditingController();
  final TextEditingController? businessName = TextEditingController();
  final TextEditingController? businessAddress = TextEditingController();
  final TextEditingController? businessAccount = TextEditingController();
  TextEditingController? passwordController = TextEditingController();
  TextEditingController? displayName = TextEditingController();
  TextEditingController? confirmController = TextEditingController();
  RxList<AppPlayStoreModel> appPlayStore = RxList<AppPlayStoreModel>();
  Uri? _initialUri;
  Uri? _latestUri;
  Object? _err;
  StreamSubscription? _sub;
  Rx<String> deepApplinkProductKey = "".obs;
  Rx<String>? deepApplinkProductCommUser = "".obs;
  Rx<FeedModel>? deepApplinkProductmodel;
  RemoteMessage messageFirebase = RemoteMessage();
  RxList<AuthModel> authType = RxList<AuthModel>();
  bool isFlutterLocalNotificationsInitialized = false;
  PendingDynamicLinkData? initialLink;
  RxList<ChatMessage> seenChatPage = RxList<ChatMessage>();
  Rx<bool> acceptCookies = false.obs;
  @override
  void onReady() async {
    super.onReady();

    //  handleIncomingLinks();
    // final client = Client();
    // client
    //         .setEndpoint('http://10.0.2.2/v1') // Your Appwrite Endpoint
    //         .setProject('6294ee161c2975bd19ba') // Your project ID
    //     // Use only on dev mode with a self-signed SSL cert
    //     ;

    //cprint(userModel?.profilePic.toString());
    // user = (firebaseAuth.currentUser);
    // user.obs.bindStream(firebaseAuth.userChanges());
    // //timer();
    // databaseInit(client);

    // appUser.obs.bindStream(databaseInit(client));

    // ever(appUser.obs, setInitialScreen(client));
  }

// Handle incoming links - the ones that the app will recieve from the OS
  /// while already started.
  handleIncomingLinks() {
    if (!kIsWeb) {
      // It will handle app links while the app is already started - be it in
      // the foreground or in the background.
      _sub = uriLinkStream.listen((Uri? uri) {
        if (uri != null) {
          setInitialScreenWeb(clientConnect, uri);
        } else {
          setInitialScreen(clientConnect());
        }
        // if (!mounted) return;
        // print('got uri: $uri');

        //   _latestUri = uri;
        //   _err = null;
      }, onError: (Object err) {
        // if (!mounted) return;
        print('got err: $err');
        // setState(() {
        _latestUri = null;
        if (err is FormatException) {
          _err = err;
        } else {
          _err = null;
        }
      });
      //  });
    } else {
      setInitialScreen(clientConnect());
    }
  }

  getUserProfileOnline(client) async {
    try {
      final account = Account(client);

      appUser = await account.get(); //

      session = await account.getSession(sessionId: 'current');
      userId = appUser?.$id;
      await getProfileUser(userProfileId: appUser?.$id);
      await databaseInit(client);
      authStatus.value == AuthStatus.LOGGED_IN;
    } on AppwriteException catch (e) {
      cprint('$e login Auth');
    }
  }

  setInitialScreen(client) async {
    try {
      final account = Account(client);

      appUser = await account.get(); //

      session = await account.getSession(sessionId: 'current');
      userId = appUser?.$id;
      await getProfileUser(userProfileId: appUser?.$id);
      // if (userId == null) {
      //   authStatus.value == AuthStatus.NOT_LOGGED_IN;
      //   //_userModel.obs.bindStream(databaseInit(client));
      //   Get.offAll(
      //     () => const WelcomePage(),
      //   );
      // } else {
      await databaseInit(client);
      authStatus.value == AuthStatus.LOGGED_IN;

      //_userModel.obs.bindStream(databaseInit(client));
      Get.offAll(
        () => HomePage(),
      );
      // }

    } on AppwriteException catch (e) {
      if (e == 401) {
        try {
          authStatus.value == await AuthStatus.NOT_LOGGED_IN;
          Get.offAll(
            () => const WelcomePage(),
          );
        } on AppwriteException catch (e) {
          if (kDebugMode) {
            cprint('$e login Auth');
          }
        }
        ;
      }
    }
  }

  setInitialScreenWeb(client, Uri uri) async {
    try {
      final account = Account(client);

      appUser = await account.get(); //

      session = await account.getSession(sessionId: 'current');
      userId = appUser?.$id;
      if (userId == null) {
        authStatus.value == AuthStatus.NOT_LOGGED_IN;
        //_userModel.obs.bindStream(databaseInit(client));
        Get.offAll(
          () => const WelcomePage(),
        );
      } else {
        databaseInit(client);
        authStatus.value == AuthStatus.LOGGED_IN;
        Rx<String?> key = uri.queryParameters['id'].obs;
        Rx<String?> comusr = uri.queryParameters['comusr'].obs;
        Rx<FeedModel> model =
            feedState.productlist!.where((data) => data.key == key).first.obs;

        //_userModel.obs.bindStream(databaseInit(client));
        Get.offAll(
          () => HomePage(),
        )!
            .then((value) => Get.to(() => ProductStoryView(
                  model: model.value,
                  commissionUser: comusr.value,
                )));
      }
      //  else {
      //   // databaseInit(client);
      //   authStatus.value == await AuthStatus.NOT_LOGGED_IN;
      //   //_userModel.obs.bindStream(databaseInit(client));
      //   Get.offAll(
      //     () => const WelcomePage(),
      //   );
      // }
    } on AppwriteException catch (e) {
      if (e == 401) {
        try {
          authStatus.value == await AuthStatus.NOT_LOGGED_IN;
          Get.offAll(
            () => const WelcomePage(),
          );
        } on AppwriteException catch (e) {
          if (kDebugMode) {
            cprint('$e login Auth');
          }
        }
        ;
      }
    }
  }

  // late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  ViewductsUser? get profileUserModel {
    if (_profileUserModelList != null &&
        _profileUserModelList!.value.isNotEmpty) {
      return _profileUserModelList!.value.last;
    } else {
      return null;
    }
  }

  void removeLastUser() {
    _profileUserModelList!.value.removeLast();
  }

  /// Logout from device
  logoutCallback() async {
    // final client = Client();
    // client
    //         .setEndpoint('http://10.0.2.2/v1') // Your Appwrite Endpoint
    //         .setProject('6294ee161c2975bd19ba') // Your project ID
    //     // Use only on dev mode with a self-signed SSL cert
    //     ;
    //  showLoading();
    await appUser == null;
    appState.setpageIndex = 0.obs;
    //  authStatus.value = AuthStatus.NOT_LOGGED_IN;
    final account = Account(clientConnect());

    await account.deleteSessions();

    authStatus.value = AuthStatus.NOT_LOGGED_IN;
    userId = '';
    _userModel = null;
    user = null;
    _profileUserModelList = null;
    // if (user == null) {
    Get.off(() => const WelcomePage(), transition: Transition.upToDown);
    // } else {
    //   Get.off(() => HomePage(), transition: Transition.upToDown);
    // }
    if (isSignInWithGoogle) {
      googleSignIn.signOut();
      logEvent('google_logout');
    }
    firebaseAuth.signOut();

    // Get.offAll(() => WelcomePage());
    update();
  }

  /// Alter select auth method, login and sign up page
  void openSignUpPage() {
    authStatus.value = AuthStatus.NOT_LOGGED_IN;
    userId = '';
    update();
  }

  databaseInit(client) async {
    try {
      // cprint(_userModel?.contact.toString());
      // final client = Client();
      // client
      //     .setEndpoint('http://10.0.2.2/v1') // Your Appwrite Endpoint
      //     .setProject('6294ee161c2975bd19ba'); // Your project ID
      // Use only on dev mode with a self-signed SSL cert
      //final id = appUser!.$id;
      // final realtime = Realtime(client);
      final base = Databases(
        clientConnect(),
      );
      final doc = await base.getDocument(
          databaseId: databaseId,
          collectionId: profileUserColl,
          documentId: appUser!.$id);

      profileUser.value = ViewductsUser.fromJson(doc.data);
      //  updateFCMToken(user: profileUser.value);
      //  _profileUserModelList?.value.last = ViewductsUser.fromJson(doc.data);
      // if (_profileUserModelList != null) {
      //   _profileUserModelList?.value.last == doc.data;
      // }
      // realtime
      //     .subscribe(['collection.629518cacd3dcc355c56.document.$id'])
      //     .stream
      //     .listen((event)
      //         //=> ViewductsUser.fromJson(event.payload)

      //         {
      //       ViewductsUser.fromJson(event.payload);
      //       _userModel!.toJson() == event.payload;
      //       // event.payload.map(_userModel!.toJson());
      //       // event.payload.map(userModel!.toJson());
      //       // cprint(_userModel!.contact.toString());
      //       if (_profileUserModelList != null) {
      //         _profileUserModelList?.value.last == event.payload;
      //       }
      //   });

      // _profileQuery ??= vDatabase
      //     .collection("profile")
      //     .where(user!.uid)
      //     .snapshots()
      //     .listen((event) {
      //   for (var element in event.docChanges) {
      //     if (element.type == DocumentChangeType.modified) {
      //       _onProfileChanged(element);
      //     }
      //   }
      // });
      // cprint('${_userModel?.contact}');
      // return _profileQuery;

    } catch (error) {
      cprint(error, errorIn: 'databaseInit');
      Get.snackbar("Database Reject", "try again");
    }
  }

//   phoneSignIn(String phone, String password, String displayname,
//       {GlobalKey<ScaffoldState>? scaffoldKey}) async {
//     final account = Account(clientConnect());

//     account.createPhoneSession(userId: "unique()", phone: phone).then((data){
// data.
//     });
//   }
  empty() {}
  isWEbSignin(String email, String password,
      {GlobalKey<ScaffoldState>? scaffoldKey}) async {
    try {
      FToast().init(Get.context!);
      EasyLoading.show(status: 'Viewducting', dismissOnTap: true);
      // final client = Client();
      // client
      //         .setEndpoint('http://10.0.2.2/v1') // Your Appwrite Endpoint
      //         .setProject('6294ee161c2975bd19ba') // Your project ID
      //     // Use only on dev mode with a self-signed SSL cert
      //     ;
      //  showLoading();
      final account = Account(clientConnect());

      loading = true;

      await account
          .createEmailSession(email: email, password: password)
          .then((value) async {
        cprint("${value.current}");
        //  if (value.current == true) {
        appUser = await account.get();
        userId = appUser!.$id;
        await databaseInit(clientConnect());
        // await SQLHelper.db();
        // final storage = const FlutterSecureStorage();
        // final profileData = json.encode(authState.userModel);
        // await storage.write(key: 'profile', value: profileData);
        // cprint('local profile created');
        emailController!.clear();
        passwordController!.clear();
        EasyLoading.dismiss();

        // if (deepApplinkProductKey.value != "") {
        //   Get.offAll(
        //     () => HomePage(),
        //   )!
        //       .then((value) {
        //     return Get.to(() => ProductStoryView(
        //           model: deepApplinkProductmodel!.value,
        //           commissionUser: deepApplinkProductCommUser!.value,
        //         ));
        //   });
        // } else {
        Get.offAll(
          () => HomePage(),
        );
        // }

        // }
      });
      // firebaseAuth.signInWithEmailAndPassword(
      //     email: email, password: password);

      // return appUser!.$id;
      //  showLoading();

    } on AppwriteException catch (e) {
      if (e.code == 401) {
        try {
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
                      'Wrong login details',
                      style: TextStyle(
                          color: CupertinoColors.darkBackgroundGray,
                          fontWeight: FontWeight.w900),
                    )),
              ),
              gravity: ToastGravity.TOP_LEFT,
              toastDuration: Duration(seconds: 3));
        } on AppwriteException catch (e) {
          AppwriteException("$e");
          cprint(e, errorIn: 'signIn');
          cprint(e, errorIn: '$e');
          kAnalytics.logLogin(loginMethod: 'email_login');
        }
      }
      EasyLoading.dismiss();
      //dismissLoadingWidget();

      // logoutCallback();
      // return null;
    }
  }

  /// Verify user's credentials for login
  Future<String?> signIn(String email, String password,
      {GlobalKey<ScaffoldState>? scaffoldKey}) async {
    try {
      FToast().init(Get.context!);
      EasyLoading.show(status: 'Viewducting', dismissOnTap: true);
      // final client = Client();
      // client
      //         .setEndpoint('http://10.0.2.2/v1') // Your Appwrite Endpoint
      //         .setProject('6294ee161c2975bd19ba') // Your project ID
      //     // Use only on dev mode with a self-signed SSL cert
      //     ;
      //  showLoading();
      final account = Account(clientConnect());

      loading = true;
      //  await firebaseAuth.signInWithEmailAndPassword(
      //           email: email,
      //           password: password,
      //         );
      await account
          .createEmailSession(email: email, password: password)
          .then((value) async {
        cprint("${value.current}");
        //  if (value.current == true) {
        appUser = await account.get();
        userId = appUser!.$id;
        await databaseInit(clientConnect());
        await SQLHelper.db();
        final storage = const FlutterSecureStorage();
        final profileData = json.encode(authState.userModel);
        await storage.write(key: 'profile', value: profileData);
        cprint('local profile created');
        emailController!.clear();
        passwordController!.clear();
        EasyLoading.dismiss();

        // if (deepApplinkProductKey.value != "") {
        //   Get.offAll(
        //     () => HomePage(),
        //   )!
        //       .then((value) {
        //     return Get.to(() => ProductStoryView(
        //           model: deepApplinkProductmodel!.value,
        //           commissionUser: deepApplinkProductCommUser!.value,
        //         ));
        //   });
        // } else {
        Get.offAll(
          () => HomePage(),
        );
        // }

        // }
      });
      // firebaseAuth.signInWithEmailAndPassword(
      //     email: email, password: password);

      // return appUser!.$id;
      //  showLoading();

    } on AppwriteException catch (e) {
      if (e.code == 401) {
        try {
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
                      'Wrong login details',
                      style: TextStyle(
                          color: CupertinoColors.darkBackgroundGray,
                          fontWeight: FontWeight.w900),
                    )),
              ),
              gravity: ToastGravity.TOP_LEFT,
              toastDuration: Duration(seconds: 3));
        } on AppwriteException catch (e) {
          AppwriteException("$e");
          cprint(e, errorIn: 'signIn');
          cprint(e, errorIn: '$e');
          kAnalytics.logLogin(loginMethod: 'email_login');
        }
      }
      EasyLoading.dismiss();
      //dismissLoadingWidget();

      // logoutCallback();
      // return null;
    }
  }

  /// Create user from `google login`
  /// If user is new then it create a new user
  /// If user is old then it just `authenticate` user and return firebase user data
  Future<User?> handleGoogleSignIn() async {
    try {
      /// Record log in firebase kAnalytics about Google login
      kAnalytics.logLogin(loginMethod: 'google_login');
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google login cancelled by user');
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      user = (await firebaseAuth.signInWithCredential(credential)).user;
      authStatus.value = AuthStatus.LOGGED_IN;
      userId = user!.uid;
      isSignInWithGoogle = true;
      createUserFromGoogleSignIn(user!);
      update();
      return user;
    } on PlatformException catch (error) {
      user = null;
      authStatus.value = AuthStatus.NOT_LOGGED_IN;
      cprint(error, errorIn: 'handleGoogleSignIn');
      return null;
    } on Exception catch (error) {
      user = null;
      authStatus.value = AuthStatus.NOT_LOGGED_IN;
      cprint(error, errorIn: 'handleGoogleSignIn');
      return null;
    } catch (error) {
      user = null;
      authStatus.value = AuthStatus.NOT_LOGGED_IN;
      cprint(error, errorIn: 'handleGoogleSignIn');
      return null;
    }
  }

  /// Create user profile from google login
  createUserFromGoogleSignIn(User user) {
    var diff = DateTime.now().difference(user.metadata.creationTime!);
    // Check if user is new or old
    // If user is new then add new user to firebase realtime kDatabase
    if (diff < const Duration(seconds: 15)) {
      ViewductsUser model = ViewductsUser(
        bio: 'Edit profile to update bio',
        dob: DateTime(1950, DateTime.now().month, DateTime.now().day + 3)
            .toString(),
        location: 'Somewhere in universe',
        profilePic: user.photoURL,
        displayName: user.displayName,
        email: user.email,
        key: user.uid,
        userId: user.uid,
        contact: int.parse(user.phoneNumber!),
        isVerified: user.emailVerified,
      );
      createUser(model, newUser: true);
    } else {
      cprint('Last login at: ${user.metadata.lastSignInTime}');
    }
  }

  _clearControllers() {
    lastName.clear();
    nameController!.clear();
    emailController!.clear();
    country!.clear();
    state!.clear();
    contact!.clear();
    passwordController!.clear();
    confirmController!.clear();
  }

  phoneAuth(ViewductsUser userss, String keysView,
      {GlobalKey<ScaffoldState>? scaffoldKey, String? userId}) async {
    FToast().init(Get.context!);
    try {
      final account = Account(clientConnect());

      appUser = await account.get();
      _userModel = userss;
      _userModel!.key = appUser!.$id;
      _userModel!.userId = appUser!.$id;
      userId = appUser!.$id;

      userId = appUser!.$id;
      await createUser(userss);
      //  await databaseInit(clientConnect());
      // await createUser(_userModel!, newUser: true);
      await feedState.viewUser(appUser!.$id, viewductUser: appUser!.$id);
      await feedState.viewUser(appUser!.$id, viewductUser: keysView);
      //  authStatus.value = AuthStatus.LOGGED_IN;

      Get.offAll(() => PhoneProfile()
          // HomePage(),
          );
    } on AppwriteException catch (error) {
      cprint(error, errorIn: 'signUp');
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
                  'Connection Timeout',
                  style: TextStyle(
                      color: CupertinoColors.darkBackgroundGray,
                      fontWeight: FontWeight.w900),
                )),
          ),
          gravity: ToastGravity.TOP_LEFT,
          toastDuration: Duration(seconds: 3));
      return 'Error in signing up';
    }
  }

  /// Create new user's profile in db
  Future<String?> signUp(ViewductsUser usersModel, String keysView,
      {GlobalKey<ScaffoldState>? scaffoldKey, required String password}) async {
    try {
      // final client = Client();
      // client
      //         .setEndpoint('http://10.0.2.2/v1') // Your Appwrite Endpoint
      //         .setProject('6294ee161c2975bd19ba') // Your project ID
      //     // Use only on dev mode with a self-signed SSL cert
      //     ;
      //  showLoading();
      final account = Account(clientConnect());

      EasyLoading.show(status: 'Viewducting');
      Future appClient = account.create(
          userId: "unique()",
          email: usersModel.email.toString(),
          password: password,
          name: usersModel.displayName.toString());
      // cprint('$appClient');
      appClient.then((user) async {
        _userModel = usersModel;
        _userModel!.key = user.$id;
        _userModel!.userId = user.$id;
        userId = user.$id;
        cprint(user.$id.toString());
        final sessionId = await account.createEmailSession(
          email: usersModel.email.toString(),
          password: password,
        );

        _userModel!.session = sessionId.$id;
        _firebaseMessaging.getToken().then((String? token) async {
          assert(token != null);
          _userModel!.fcmToken = token;
          await createUser(_userModel!, newUser: true);
        });

        await feedState.viewUser(appUser!.$id, viewductUser: appUser!.$id);
        await feedState.viewUser(appUser!.$id, viewductUser: keysView);
      });
      // if (usersModel.email.toString() != 'viewducts@gmail.com') {
      //   await database.listDocuments(collectionId: profileUserColl, queries: [
      //     query.Query.equal('email', 'viewducts@gmail.com')
      //   ]).then((data) async {
      //     if (data.documents.isNotEmpty) {
      //       var value = data.documents
      //           .map((e) => ViewductsUser.fromJson(e.data))
      //           .toList();
      //       await feedState.viewUser(appUser!.$id,
      //           viewductUser: value
      //               .firstWhere((data) => data.email == 'viewducts@gmail.com')
      //               .key
      //               .toString());
      //     }
      //   });
      // }
      // ;
      // var result = await firebaseAuth.createUserWithEmailAndPassword(
      //   email: usersModel.email!,
      //   password: password,
      // );
      //  user = result.user;
      authStatus.value = AuthStatus.LOGGED_IN;
      // kAnalytics.logSignUp(signUpMethod: 'register');
      // await result.user!.updateDisplayName(
      //   usersModel.displayName,
      // );
      // await result.user!.updatePhotoURL(usersModel.profilePic);
      // await result.user.updateProfile(
      //     displayName: userModel.displayName, photoURL: userModel.profilePic);
      // _userModel = usersModel;
      // _userModel!.key = user!.uid;
      // _userModel!.userId = user!.uid;
      // createUser(_userModel!, newUser: true);
      // _clearControllers();
      EasyLoading.dismiss();
      // dismissLoadingWidget();
      // return user!.uid;
    } on AppwriteException catch (error) {
      EasyLoading.dismiss();
      // dismissLoadingWidget();
      cprint(error, errorIn: 'signUp');
      Get.snackbar("Connection", "$error" 'signUp');
      return 'Error in signing up';
    }
  }

  /// `Create` and `Update` user
  /// IF `newUser` is true new user is created
  /// Else existing user will update with new values
  createUser(ViewductsUser user, {bool newUser = false}) async {
    try {
      // final client = Client();
      // client
      //         .setEndpoint('http://10.0.2.2/v1') // Your Appwrite Endpoint
      //         .setProject('6294ee161c2975bd19ba') // Your project ID
      //     // Use only on dev mode with a self-signed SSL cert
      //     ;

      final database = Databases(
        clientConnect(),
      );
      // if (newUser) {
      // Create username by the combination of name and id
      user.userName = getUserName(id: user.userId!, name: user.displayName!);
      // kAnalytics.logEvent(name: 'create_newUser');

      // Time at which user is created
      user.createdAt = DateTime.now().toUtc().toString();
      user.lastSeen = DateTime.now().toUtc().toString();
      database.listDocuments(
          databaseId: databaseId,
          collectionId: profileUserColl,
          queries: [
            query.Query.equal('key', '${appUser?.$id}')
          ]).then((value) async {
        if (value.documents.isEmpty) {
          // await account.updatePrefs(prefs: {"newDevice": true});
          await database.createDocument(
              databaseId: databaseId,
              collectionId: profileUserColl,
              documentId: '${appUser?.$id}',
              data: user.toMap(),
              permissions: [Permission.read(Role.users())]);
          final doc = await database.getDocument(
              databaseId: databaseId,
              collectionId: profileUserColl,
              documentId: '${appUser?.$id}');
          profileUser.value = ViewductsUser.fromJson(doc.data);

          _userModel = ViewductsUser.fromJson(doc.data);
        } else {
          // await account.updatePrefs(prefs: {"newDevice": true});
          await database.updateDocument(
              databaseId: databaseId,
              collectionId: profileUserColl,
              documentId: user.key.toString(),
              data: {
                "secret": true,
                "newDevice": true,
                "contact": user.contact,
                "location": user.location
              },
              permissions: [
                Permission.read(Role.users())
              ]);
          final doc = await database.getDocument(
              databaseId: databaseId,
              collectionId: profileUserColl,
              documentId: '${appUser?.$id}');
          profileUser.value = ViewductsUser.fromJson(doc.data);
          _userModel = ViewductsUser.fromJson(doc.data);
        }
      });

      // } else {

      // }
    } on AppwriteException catch (e) {
      cprint('$e createUser');
    }
  }

  Stream<ViewductsUser> firebaseChatUsers({String? userId}) => vDatabase
      .collection('profile')
      .doc(userId)
      .snapshots()
      .map((p) => ViewductsUser.fromJson(p.data()));
  security(String? secId, Map<String, String> data) {
    vDatabase
        .collection('profile')
        .doc(secId)
        .set(data, SetOptions(merge: true))
        .then((_) {
      ViewDucts.toast('Done!');
    });
  }

  void setUserState({required String userId, required UserState userState}) {
    int stateNum = Utils.stateToNum(userState);

    vDatabase.collection('profile').doc(userId).update({
      "onlineStatus": stateNum,
    });
  }

  /// Fetch current user profile
  getCurrentUser() async {
    try {
      // showLoading();
      logEvent('get_currentUser');
      // user = firebaseAuth.currentUser;
      if (session?.current == true) {
        authStatus.value = AuthStatus.LOGGED_IN;
        userId = appUser?.$id;
        getProfileUser();
      } else if (session?.current == false) {
        authStatus.value = AuthStatus.NOT_LOGGED_IN;
      }
      // dismissLoadingWidget();
      return appUser;
    } catch (error) {
      // dismissLoadingWidget();
      cprint(error, errorIn: 'getCurrentUser 1');
      authStatus.value = AuthStatus.NOT_DETERMINED;
    }
  }

  /// Reload user to get refresh user data
  reloadUser() async {
    //await user.reload();
    user = firebaseAuth.currentUser;
    if (user!.emailVerified) {
      _userModel?.isVerified = true;
      // If user verifed his email
      // Update user in firebase realtime kDatabase
      createUser(_userModel!);
      cprint('ViewductsUser email verification complete');
      logEvent('email_verification_complete',
          parameter: {_userModel?.userName: user?.email});
    }
  }

  /// Send email verification link to email2
  Future<void> sendEmailVerification(
      GlobalKey<ScaffoldState> scaffoldKey) async {
    User user = firebaseAuth.currentUser!;
    user.sendEmailVerification().then((_) {
      logEvent('email_verifcation_sent',
          parameter: {_userModel!.displayName: user.email});
      Get.snackbar(
          "Connection", "An email verification link is send to your email.");
    }).catchError((error) {
      cprint(error.message, errorIn: 'sendEmailVerification');
      logEvent('email_verifcation_block',
          parameter: {_userModel!.displayName: user.email});
      Get.snackbar("Connection", "${error.message}");
    });
  }

  /// Check if user's email is verified
  Future<bool> emailVerified() async {
    User user = firebaseAuth.currentUser!;
    return user.emailVerified;
  }

  /// Send password reset link to email
  Future<void> forgetPassword(String email,
      {GlobalKey<ScaffoldState>? scaffoldKey, String? url}) async {
    try {
      if (kDebugMode) {
        cprint(url.toString());
      }

      FToast().init(Get.context!);
      await firebaseAuth.sendPasswordResetEmail(email: email).then((value) {
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
                    "A reset password link is sent yo your mail.You can reset your password from there.",
                    style: TextStyle(
                        color: CupertinoColors.darkBackgroundGray,
                        fontWeight: FontWeight.w900),
                  )),
            ),
            gravity: ToastGravity.TOP_LEFT,
            toastDuration: Duration(seconds: 3));

        logEvent('forgot+password');
      }).catchError((error) {
        cprint(error.message);
        return false;
      });

      // final Account account = Account(clientConnect());
      // account.createRecovery(email: email, url: url!).then((value) {

      //   // Get.back();

      //   // swipeMessage(message);
      //   // setState(() {});
      //   // textFieldFocus.nextFocus();
      // }).onError((error, stackTrace) {
      //   if (kDebugMode) {
      //     cprint(error.toString());
      //   }
      // });

    } catch (error) {
      if (kDebugMode) {
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
                    "Connection $error",
                    style: TextStyle(
                        color: CupertinoColors.darkBackgroundGray,
                        fontWeight: FontWeight.w900),
                  )),
            ),
            gravity: ToastGravity.TOP_LEFT,
            toastDuration: Duration(seconds: 3));
        cprint(error.toString());
      }

      return Future.value(false);
    }
  }

  /// `Update user` profile
  Future<void> updateUserProfile(ViewductsUser usersModel,
      {File? image}) async {
    try {
      final database = Databases(
        clientConnect(),
      );

      await database.updateDocument(
          databaseId: databaseId,
          collectionId: profileUserColl,
          documentId: usersModel.key.toString(),
          data: usersModel.toMap(),
          permissions: [Permission.read(Role.users())]
          // read: [
          //   'role:all',
          // ],
          // write: [
          //   'user:${usersModel.key}',
          // ],
          );
      logEvent('update_user');
    } catch (error) {
      cprint(error, errorIn: 'updateUserProfile');
    }
  }

  /// `Fetch` user `detail` whoose userId is passed
  Future<ViewductsUser?> getuserDetail(String? userId) async {
    ViewductsUser user;
    var snapshot = await vDatabase.collection('profile').doc(userId).get();
    if (snapshot.data != null) {
      var map = snapshot.data;
      user = ViewductsUser.fromJson(map());
      user.key = snapshot.id;
      return user;
    } else {
      return null;
    }
  }

  locaSecureProfile() async {
    try {
      final storage = const FlutterSecureStorage();

      final data = await storage.read(key: 'profile');
      final profileData = json.decode(data.toString());
      _userModel = await ViewductsUser.fromJson(profileData);
      profileUser.value = await ViewductsUser.fromJson(profileData);
      authStatus.value == AuthStatus.LOGGED_IN;
      authState.logginType.value = 'local';
      Get.offAll(
        () => HomePage(),
      );
    } catch (e) {
      cprint(e.toString());
    }
  }

  /// Fetch user profile
  /// If `userProfileId` is null then logged in user's profile will fetched
  getProfileUser({String? userProfileId}) {
    try {
      // showLoading();
      if (_profileUserModelList == null) {
        _profileUserModelList?.value = [];
      }

      userProfileId = userProfileId ?? appUser!.$id;
      // vDatabase
      //     .collection("profile")
      //     .doc(userProfileId)
      //     .get()
      // final client = Client();
      // client
      //     .setEndpoint('http://10.0.2.2/v1') // Your Appwrite Endpoint
      //     .setProject('6294ee161c2975bd19ba'); // Your project ID
      //  Use only on dev mode with a self-signed SSL cert
      //final id = appUser!.$id;
      // final realtime = Realtime(client);
      final base = Databases(
        clientConnect(),
      );
      base
          .getDocument(
              databaseId: databaseId,
              collectionId: profileUserColl,
              documentId: appUser!.$id)
          .then((snapshot) {
        if (snapshot.data != null) {
          var map = snapshot.data;
          if (map != null) {
            _profileUserModelList?.value.add((ViewductsUser.fromJson(map)));
            if (userProfileId == user?.uid) {
              _userModel = _profileUserModelList?.value.last;
              _userModel?.isVerified = user?.emailVerified;
              if (!user!.emailVerified) {
                // Check if logged in user verified his email address or not
                reloadUser();
              }
              // if (_userModel?.fcmToken == null) {
              updateFCMToken();
              // }
            }

            logEvent('get_profile');
          }
        }
        // dismissLoadingWidget();
      });
    } catch (error) {
      // dismissLoadingWidget();
      cprint(error, errorIn: 'getProfileUser 2');
    }
  }

  /// if firebase token not available in profile
  /// Then get token from firebase and save it to profile
  /// When someone sends you a message FCM token is used
  updateFCMToken({ViewductsUser? user}) {
    if (user == null) {
      return;
    }
    //AEPfE8T85zWhrh0bh1Q8K8A6W9E2
    // getProfileUser();
    _firebaseMessaging.getToken().then((String? token) async {
      assert(token != null);

      user.fcmToken = token;

      // await createUser(user);
    });
  }

  /// Follow / Unfollow user
  ///
  /// If `removeFollower` is true then remove user from follower list
  ///
  /// If `removeFollower` is false then add user to follower list
  followUser(String? viewer, {bool removeFollower = false}) {
    /// `usersModel` is user who is looged-in app.
    /// `profileUserModel` is user whoose profile is open in app.
    try {
      if (removeFollower) {
        /// If logged-in user `alredy follow `profile user then
        /// 1.Remove logged-in user from profile user's `follower` list
        /// 2.Remove profile user from logged-in user's `viewing` list
        // profileUserModel!.viewersList!.remove(_userModel!.userId);

        // /// Remove profile user from logged-in user's viewing list
        // _userModel!.viewingList!.remove(viewer
        //     //profileUserModel.userId
        //     );
        // // update profile user's user follower count
        // profileUserModel!.viewers = profileUserModel!.viewersList!.length;
        // // update logged-in user's viewing count
        // _userModel!.viewing = _userModel!.viewingList!.length;
        // // profileUserModel.viewers -= 1;
        // // _userModel.viewing -= 1;
        // vDatabase.collection('profile').doc(viewer).set(
        //     {
        //       'viewersList': FieldValue.arrayRemove(
        //         [_userModel!.userId],
        //       ),
        //       'viewers': profileUserModel!.viewers
        //     },
        //     SetOptions(
        //       merge: true,
        //     ));

        // vDatabase.collection('profile').doc(_userModel!.userId).set(
        //     {
        //       'viewingList': FieldValue.arrayRemove(
        //         [viewer],
        //       ),
        //       'viewing': _userModel!.viewing
        //     },
        //     SetOptions(
        //       merge: true,
        //     ));

        cprint('user removed from viewing list', event: 'remove_follow');
      } else {
        /// if logged in user is `not viewing` profile use++++++++++r then
        /// 1.Add logged in user to profile user's `follower` list
        /// 2. Add profile user to logged in user's `viewing` list
        // if (profileUserModel!.viewersList == null) {
        //   profileUserModel!.viewersList = [];
        // }
        // profileUserModel!.viewersList!.add(_userModel!.userId);
        // // Adding profile user to logged-in user's viewing list
        // if (_userModel!.viewingList == null) {
        //   _userModel!.viewingList = [];
        // }
        // _userModel!.viewingList!.add(viewer);
        // // update profile user's user follower count
        // profileUserModel!.viewers = profileUserModel!.viewersList!.length;
        // // update logged-in user's viewing count
        // _userModel!.viewing = _userModel!.viewingList!.length;
        // // profileUserModel.viewers += 1;
        // // _userModel.viewing += 1;
        // vDatabase.collection('profile').doc(viewer).set(
        //     {
        //       'viewersList': FieldValue.arrayUnion(
        //         [_userModel!.userId],
        //       ),
        //       'viewers': profileUserModel!.viewers
        //     },
        //     SetOptions(
        //       merge: true,
        //     ));

        // vDatabase.collection('profile').doc(_userModel!.userId).set(
        //     {
        //       'viewingList': FieldValue.arrayUnion(
        //         [viewer],
        //       ),
        //       'viewing': _userModel!.viewing
        //     },
        //     SetOptions(
        //       merge: true,
        //     ));

        cprint('user added to viewing list', event: 'add_viwer');
      }

      update();
    } catch (error) {
      cprint(error, errorIn: 'viewUser');
    }
  }

  /// Trigger when logged-in user's profile change or updated
  /// Firebase event callback for profile update
  void _onProfileChanged(DocumentChange event) {
    final updatedUser =
        ViewductsUser.fromJson(event.doc.data() as Map<dynamic, dynamic>?);
    if (updatedUser.userId == user!.uid) {
      _userModel = updatedUser;
    }
    cprint('ViewductsUser Updated');
    update();
  }
}

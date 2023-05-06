// ignore_for_file: deprecated_member_use

import 'dart:math';
import 'package:appwrite/appwrite.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:viewducts/common/common.dart';
import 'package:viewducts/common/policy_link_widget.dart';
import 'package:viewducts/core/utils.dart';
import 'package:viewducts/features/auth/controller/auth_controller.dart';
import 'package:viewducts/features/country/country_controller.dart';

import 'package:viewducts/helper/constant.dart';
import 'package:viewducts/helper/enum.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/page/homePage.dart';
import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/duct/ductStoryPage.dart';
import 'package:viewducts/widgets/frosted.dart';
import 'package:viewducts/widgets/newWidget/customLoader.dart';
import 'package:viewducts/E2EE/e2ee.dart' as e2ee;
import 'package:viewducts/widgets/newWidget/title_text.dart';

// ignore: must_be_immutable
class Signup extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => HomePage(
            // loginCallback:
            //     getCurrentUser
            ),
      );
  final VoidCallback? loginCallback;

  Signup({Key? key, this.loginCallback}) : super(key: key);

  @override
  ConsumerState<Signup> createState() => _SignupState();
}

class _SignupState extends ConsumerState<Signup> {
  late SharedPreferences prefs;
  TextEditingController? nameController = TextEditingController();
  TextEditingController? contact = TextEditingController();
  TextEditingController? emailController = TextEditingController();
  TextEditingController? passwordController = TextEditingController();
  TextEditingController? confirmController = TextEditingController();
  final TextEditingController? country = TextEditingController();
  final TextEditingController? state = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController!.dispose();
    passwordController!.dispose();
    confirmController!.dispose();
    country!.dispose();
    state!.dispose();
    contact!.dispose();
    emailController!.dispose();
  }

  void onSignUp(ViewductsUser userModel) {
    ref.read(authControllerProvider.notifier).signUp(
          email: userModel.email.toString(),
          password: passwordController!.text,
          context: context,
          userModel: userModel,
        );
  }

  String? phoneCode;

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
  var userState;
  int index = 0;
  int stateIndex = 0;
  Rx<KeyViewducts> keysView = KeyViewducts().obs;
//   allUser() async {
//     try {
//       final database = Databases(
//         clientConnect(),
//       );
//       await database
//           .listDocuments(
//         databaseId: databaseId,
//         collectionId: countryColl,
// //   queries: [
// //  query.Query.equal('userId',model.)
// //       ]
//       )
//           .then((data) {
//         // Map map = data.toMap();

//         var value = data.documents
//             .map((e) => CountryModel.fromSnapshot(e.data))
//             .toList();
//         //data.documents;
//         feedState.country!.value = value;
//         // cprint('${data.documents.map((e) => FeedModel.fromJson(e.data))}');
//         //cprint('${feedState.feedlist?.value.map((e) => e.key)}');
//       });
//       await database
//           .getDocument(
//               databaseId: databaseId,
//               collectionId: 'keyViewducts',
//               documentId: 'keysViewKeys')
//           .then((doc) {
//         keysView.value = KeyViewducts.fromSnapshot(doc.data);
//       });
//       // database
//       //     .getDocument(collectionId: countryColl, documentId: countryId)
//       //     .then((item) {
//       //   // Map map = data.toMap();

//       //   // var value =
//       //   //     data.data.map((e) => ViewductsUser.fromJson(e.data));
//       //   //data.documents;

//       //   feedState.country.value = CountryModel.fromSnapshot(item.data);
//       //   // cprint('${item.toMap()}');
//       //   // cprint('${feedState.keywords.value.keywords?.map((e) => e.keyword)}');
//       // });
//     } on AppwriteException catch (e) {
//       cprint('$e signupPage');
//     }
//   }

  Widget _body(BuildContext context, List<CountryModel> countryLocation) {
    final isloading = ref.watch(authControllerProvider);
    return ListBody(
      children: [
        Container(
          height: Get.height * 0.9,
          padding: const EdgeInsets.only(left: 20, right: 20, top: 80),
          child: Form(
            key: _formKey,
            child: frostedWhite(
              SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              // _entryFeild('Display Name', controller: nameController),
                              _entryFeild('Phone Number',
                                  controller: contact, isNumber: true),
                              GestureDetector(
                                onTap: () {
                                  showCupertinoModalPopup(
                                      context: context,
                                      builder: (context) =>
                                          CupertinoActionSheet(
                                            actions: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  height: Get.height * 0.3,
                                                  child: CupertinoPicker(
                                                      looping: true,
                                                      itemExtent:
                                                          Get.height * 0.1,
                                                      onSelectedItemChanged:
                                                          (index) {
                                                        setState(() {
                                                          this.index = index;
                                                        });
                                                        setState(() {
                                                          phoneCode =
                                                              countryLocation[
                                                                      this.index]
                                                                  .dial_code;
                                                          bankCountry =
                                                              countryLocation[
                                                                      this.index]
                                                                  .country;
                                                        });
                                                      },
                                                      children: countryLocation
                                                          .map((data) => Center(
                                                              child: Text(data
                                                                  .country
                                                                  .toString())))
                                                          .toList()),
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
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color:
                                                CupertinoColors.inactiveGray),
                                        padding: const EdgeInsets.all(5.0),
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
                                                color: CupertinoColors
                                                    .systemYellow,
                                              ),
                                              child: const Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text('Country',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                              ),
                                            ),
                                            // ignore: unnecessary_null_comparison, invalid_use_of_protected_member
                                            country?.value == null
                                                ? Container()
                                                : Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 12,
                                                        vertical: 12),
                                                    // ignore: unnecessary_null_comparison
                                                    child: bankCountry
                                                                ?.toString() ==
                                                            null
                                                        ? const Text(
                                                            'Select country')
                                                        : Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                                Text(
                                                                    '${countryLocation[index].country ?? ''}'),
                                                              ])),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              bankCountry == null
                                  ? Container()
                                  : _entryFeild('Enter email',
                                      controller: emailController,
                                      isEmail: true),

                              bankCountry == null
                                  ? Container()
                                  : _entryFeild('Enter password',
                                      controller: passwordController,
                                      isPassword: true),
                              bankCountry == null
                                  ? Container()
                                  : _entryFeild('Confirm password',
                                      controller: confirmController,
                                      isPassword: true),
                              const Divider(height: 30),
                            ],
                          ),
                        ),
                        isloading
                            ? frostedWhite(
                                Container(
                                  height: 350,
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                    // borderRadius: BorderRadius.circular(100),
                                    //color: Colors.blueGrey[50]
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        Colors.transparent,
                                        Colors.transparent
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
                      ],
                    ),
                    emailController?.text == null ||
                            contact == null ||
                            country == null ||
                            emailController!.text.isEmpty ||
                            passwordController?.text == null ||
                            passwordController!.text.isEmpty ||
                            confirmController?.text == null
                        ? Container()
                        : _submitButton(Get.context),
                    const Divider(height: 20),
                    emailController?.text == null ||
                            contact == null ||
                            country == null ||
                            emailController!.text.isEmpty ||
                            passwordController?.text == null ||
                            passwordController!.text.isEmpty ||
                            confirmController?.text == null
                        ? Container()
                        : isloading
                            ? Container()
                            : Container(
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
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Text(
                                      'Be sure that your info is correct to avoid lossing of comissions earned',
                                      style: TextStyle(color: Colors.white)),
                                ))
                  ],
                ),
              ),
            ),
          ),
        ),
        PolicyLinkWidget()
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
    final isloading = ref.watch(authControllerProvider);
    return isloading
        ? TextButton(
            onPressed: () {},
            child: Container(
              height: 30,
              width: 120,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 11),
                        blurRadius: 11,
                        color: Colors.black.withOpacity(0.06))
                  ],
                  borderRadius: BorderRadius.circular(18),
                  color: CupertinoColors.lightBackgroundGray),
              padding: const EdgeInsets.all(5.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    TitleText('Signing Up...'),
                    Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Loader()

                        // : const CircularProgressIndicator(
                        //     strokeWidth: 2,
                        //   ),
                        // Image.asset(
                        //   'assets/cool.png',
                        //   height: 30,
                        //   width: 30,
                        // )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        : TextButton(
            onPressed: () {
              _submitForm();
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
              child: customTitleText('Sign Up'),
            ),
          );
  }

  void _submitForm() async {
    if (emailController?.text == null ||
        contact == null ||
        country == null ||
        emailController!.text.isEmpty ||
        passwordController?.text == null ||
        passwordController!.text.isEmpty ||
        confirmController?.text == null) {
      showSnackBar(context, 'Please fill in the form carefully');

      return;
    } else if (passwordController!.text != confirmController!.text) {
      showSnackBar(context, 'Password and confirm pasword did not match');
      //cprint('Password and confirm pasword did not match');
      // customSnackBar(
      //     _scaffoldKey, 'Password and confirm password did not match');
      return;
    }

    Random random = Random();
    int randomNumber = random.nextInt(8);

    // User? firebaseUser;
    prefs = await SharedPreferences.getInstance();
    final pair = await const e2ee.X25519().generateKeyPair();
    await storage.write(key: PRIVATE_KEY, value: pair.secretKey.toBase64());

    ViewductsUser user = ViewductsUser(
      email: emailController!.text.toLowerCase(),
      bio: 'Edit your profile',
      firstName: 'Your First Name',
      lastName: 'Your Last Name',
      contact: int.parse(contact!.text),
      displayName: getNameFromEmail(emailController!.text.toLowerCase()),
      dob: 'Date of Birth',
      location: bankCountry,
      state: userState,
      profilePic: dummyProfilePicList[randomNumber],
      countryCode: phoneCode,

      //contact: phoneNo,
      publicKey: pair.publicKey.toBase64(),
      // countryCode: phoneCode,
      authenticationType: AuthenticationType.passcode.index,
      isVerified: false,
    );
    onSignUp(user);
  }

  @override
  Widget build(BuildContext context) {
    // final isloading = ref.watch(authControllerProvider);
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            ThemeMode.system == ThemeMode.light
                ? frostedBlueGray(
                    Container(
                      height: Get.height,
                      width: Get.width,
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
            // isloading
            //     ? Loader()
            //     :

            SingleChildScrollView(
              child: Column(
                  children: ref.watch(getCountryProvider).when(
                      data: (country) {
                        return [
                          _body(context, country),
                        ];
                      },
                      error: (error, stackTrace) {
                        return [
                          ErrorText(
                            error: error.toString(),
                          ),
                        ];
                      },
                      loading: () => [])

                  // <Widget>[

                  //   _body(context),
                  // ],
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
                  Material(
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 3),
                              child: customTitleText('ViewDucts'),
                            ),
                          ],
                        ),
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

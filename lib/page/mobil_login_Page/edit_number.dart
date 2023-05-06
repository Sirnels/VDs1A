import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:viewducts/app_theme/colors_pallete.dart';
import 'package:viewducts/page/mobil_login_Page/select_country.dart';
import 'package:viewducts/page/responsiveView.dart';
import 'package:viewducts/page/settings/accountSettings/policy.dart';
import 'package:viewducts/src/app.dart';
import 'package:viewducts/widgets/newWidget/title_text.dart';

class EditNumber extends StatefulWidget {
  const EditNumber({Key? key}) : super(key: key);

  @override
  _EditNumberState createState() => _EditNumberState();
}

class _EditNumberState extends State<EditNumber> {
  var _enterPhoneNumber = TextEditingController();
  Map<String, dynamic> data = {"name": "Nigeria", "code": "+234"};
  Map<String, dynamic>? dataResult;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  Widget privacyPolicyLinkAndTermsOfService() {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 11),
                blurRadius: 11,
                color: Colors.black.withOpacity(0.06))
          ],
          borderRadius: BorderRadius.circular(4),
          color: Pallete.scafoldBacgroundColor
          // Color.fromARGB(255, 236, 179, 21)
          ),
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      child: Center(
          child: Text.rich(TextSpan(
              text: 'By continuing, you agree to our ',
              style: TextStyle(
                fontSize: 18,
              ),
              children: <TextSpan>[
            TextSpan(
                text: 'Terms of Service',
                style: TextStyle(
                  fontSize: 18,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Get.to(() => Policy(
                          mdFileName: 'term_condition',
                          name: "Terms of Service",
                        ));
                    // code to open / launch terms of service link here
                  }),
            TextSpan(
                text: ' and ',
                style: TextStyle(
                  fontSize: 18,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                          fontSize: 18, decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.to(() => Policy(
                                mdFileName: 'privacy_policy',
                                name: "Privacy policy",
                              ));
                          // code to open / launch privacy policy link here
                        })
                ])
          ]))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Text("Edit Number"),
          previousPageTitle: "Back",
        ),
        child: Form(
          key: _formKey,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Material(
                          color: Colors.yellow[50],
                          elevation: 20,
                          borderRadius: BorderRadius.circular(100),
                          shadowColor: Colors.yellow[100],
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Image.asset('assets/delicious.png'),
                            radius: context.responsiveValue(
                                mobile: Get.height * 0.04,
                                tablet: Get.height * 0.06,
                                desktop: Get.height * 0.06),
                          ),
                        ),
                        TitleText(
                          'View',
                          color: Colors.blueGrey[100],
                          fontSize: context.responsiveValue(
                              mobile: Get.height * 0.06,
                              tablet: Get.height * 0.08,
                              desktop: Get.height * 0.08),
                        ),
                        TitleText(
                          'Ducts',
                          color: Colors.blueGrey[300],
                          fontSize: context.responsiveValue(
                              mobile: Get.height * 0.06,
                              tablet: Get.height * 0.08,
                              desktop: Get.height * 0.08),
                        ),
                      ],
                    ),
                  ),
                  Text('Social, Shop And Get Paid ',

                      //  'Global Market at Your Door Step ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: context.responsiveValue(
                            mobile: Get.height * 0.02,
                            tablet: Get.height * 0.025,
                            desktop: Get.height * 0.025),
                      )
                      //color: Colors.blueGrey[700],
                      ),
                  const SizedBox(
                    height: 16,
                  ),
                  // Text("Enter your phone number",
                  //     style: TextStyle(
                  //         color: CupertinoColors.systemGrey.withOpacity(0.7),
                  //         fontSize: 30)),
                  // CupertinoListTile(
                  //   onTap: () async {
                  //     dataResult = await Navigator.push(
                  //         context,
                  //         CupertinoPageRoute(
                  //             builder: (context) => SelectCountry()));
                  //     setState(() {
                  //       if (dataResult != null) data = dataResult!;
                  //     });
                  //   },
                  //   title: Text(data['name'],
                  //       style: TextStyle(color: Color(0xFF08C187))),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Text(data['code'],
                            style: TextStyle(
                              fontSize: 25,
                            )),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      offset: const Offset(0, 11),
                                      blurRadius: 11,
                                      color: Colors.black.withOpacity(0.06))
                                ],
                                borderRadius: BorderRadius.circular(18),
                                color: CupertinoColors.white),
                            child: TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'You must enter a phone number';
                                }
                                if (value.length < 7) {
                                  return 'phone number must not be >11';
                                }
                                return value;
                              },
                              decoration: const InputDecoration(
                                hintStyle: TextStyle(color: Colors.blueGrey

                                    //color: UniversalVariables.greyColor,
                                    ),
                                hintText: "Phone Number",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(50.0),
                                    ),
                                    borderSide: BorderSide.none),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                filled: true,

                                //fillColor: UniversalVariables.separatorColor,
                              ),
                              controller: _enterPhoneNumber,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                  fontSize: 25, color: CupertinoColors.black),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Text("You will receive an activation code in short time",
                      style: TextStyle(
                          color: CupertinoColors.systemGrey, fontSize: 15)),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: CupertinoButton.filled(
                        child: Text("Countinue"),
                        onPressed: () {
                          FToast().init(Get.context!);
                          if (data['name'] == 'Nigeria') {
                            if (_enterPhoneNumber.text.length == 11) {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          VerifyPhonePageResponsiveView(
                                            country: data['name'],
                                            code: data['countrycode'],
                                            number: data['code']! +
                                                _enterPhoneNumber.text,
                                            phoneNoCode: _enterPhoneNumber.text,
                                          )));
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
                                                  color: Colors.black
                                                      .withOpacity(0.06))
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            color: CupertinoColors.systemRed),
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          'Number must be 11 digit',
                                          style: TextStyle(
                                              color: CupertinoColors
                                                  .darkBackgroundGray,
                                              fontWeight: FontWeight.w900),
                                        )),
                                  ),
                                  gravity: ToastGravity.TOP_LEFT,
                                  toastDuration: Duration(seconds: 5));
                            }
                          } else {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        VerifyPhonePageResponsiveView(
                                          country: data['name'],
                                          code: data['countrycode'],
                                          number: data['code']! +
                                              _enterPhoneNumber.text,
                                          phoneNoCode: _enterPhoneNumber.text,
                                        )));
                          }
                        }),
                  )
                ],
              ),
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Column(
                    children: [
                      // Wrap(
                      //   alignment: WrapAlignment.center,
                      //   crossAxisAlignment: WrapCrossAlignment.center,
                      //   children: <Widget>[
                      //     Text(
                      //       'or use Email to',
                      //       style: TextStyle(
                      //         fontSize: context.responsiveValue(
                      //             mobile: Get.height * 0.02,
                      //             tablet: Get.height * 0.02,
                      //             desktop: Get.height * 0.02),
                      //         fontWeight: FontWeight.w300,
                      //       ),
                      //     ),
                      //     InkWell(
                      //       onTap: () {
                      //         Get.to(
                      //             () => SignIn(
                      //                   loginCallback: authState.getCurrentUser,
                      //                   phoneAuth: true,
                      //                 ),
                      //             transition: Transition.leftToRightWithFade);
                      //       },
                      //       child: Padding(
                      //         padding: EdgeInsets.symmetric(
                      //             horizontal: 2, vertical: 10),
                      //         child: TitleText(
                      //           ' Log in',
                      //           fontSize: context.responsiveValue(
                      //               mobile: Get.height * 0.02,
                      //               tablet: Get.height * 0.02,
                      //               desktop: Get.height * 0.02),
                      //           color: TwitterColor.dodgetBlue,
                      //           fontWeight: FontWeight.w300,
                      //         ),
                      //       ),
                      //     )
                      //   ],
                      // ),
                      privacyPolicyLinkAndTermsOfService(),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

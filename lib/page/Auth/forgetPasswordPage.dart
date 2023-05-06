// ignore_for_file: deprecated_member_use, file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/frosted.dart';

class ForgetPasswordPage extends StatefulWidget {
  final VoidCallback? loginCallback;

  const ForgetPasswordPage({Key? key, this.loginCallback}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  FocusNode? _focusNode;
  TextEditingController? _emailController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    _focusNode = FocusNode();
    _emailController = TextEditingController();
    _emailController!.text = '';
    _focusNode!.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode!.dispose();
    super.dispose();
  }

  Widget _body(BuildContext context) {
    return Container(
        height: fullHeight(context),
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _label(),
            const SizedBox(
              height: 50,
            ),
            _entryFeild('Enter email', controller: _emailController),
            // SizedBox(height: 10,),
            _submitButton(context),
          ],
        ));
  }

  Widget _entryFeild(String hint,
      {TextEditingController? controller, bool isPassword = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
          color: Colors.grey.shade200, borderRadius: BorderRadius.circular(30)),
      child: TextField(
        focusNode: _focusNode,
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(
            fontStyle: FontStyle.normal, fontWeight: FontWeight.normal),
        obscureText: isPassword,
        decoration: InputDecoration(
            hintText: hint,
            border: InputBorder.none,
            focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                borderSide: BorderSide(color: Colors.blue)),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 15, horizontal: 10)),
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 15),
        width: MediaQuery.of(context).size.width,
        child: TextButton(
          // shape:
          //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          // color: Colors.yellow[500],
          onPressed: _submit,
          // padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: const Text('Submit', style: TextStyle(color: Colors.white)),
        ));
  }

  Widget _label() {
    return Column(
      children: <Widget>[
        customText('Forget Password',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: customText(
              'Enter your email address below to receive password reset instruction',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54),
              textAlign: TextAlign.center),
        )
      ],
    );
  }

  void _submit() {
    if (_emailController!.text.isEmpty) {
      customSnackBar(_scaffoldKey, 'Email field cannot be empty');
      return;
    }
    var isValidEmail = validateEmal(
      _emailController!.text,
    );
    if (!isValidEmail) {
      customSnackBar(_scaffoldKey, 'Please enter valid email address');
      return;
    }

    _focusNode!.unfocus();
    //var state = Provider.of<AuthState>(context, listen: false);
    authState.forgetPassword(_emailController!.text,
        scaffoldKey: _scaffoldKey, url: "www.viewducts.com");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // appBar: AppBar(
      //   backgroundColor: Colors.yellow[500],
      //   title: customText('Forget Password',
      //       context: context, style: const TextStyle(fontSize: 20)),
      //   centerTitle: true,
      // ),
      body: SafeArea(
        child: Stack(
          children: [
            _body(context),
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

// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/frosted.dart';
import 'package:viewducts/widgets/newWidget/emptyList.dart';
import 'package:viewducts/widgets/newWidget/title_text.dart';

class VerifyEmailPage extends HookWidget {
  final VoidCallback? loginCallback;

  VerifyEmailPage({Key? key, this.loginCallback}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _body(BuildContext context) {
    //var state = Provider.of<AuthState>(context, listen: false);
    return Container(
      height: fullHeight(context),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: authState.appUser?.emailVerification == true
            ? <Widget>[
                const NotifyText(
                  title: 'Your email address is verified',
                  subTitle:
                      'You have got your aprove sign on your name. Cheers !!',
                ),
              ]
            : <Widget>[
                NotifyText(
                  title: 'Verify your email address',
                  subTitle:
                      'Send email verification email link to ${authState.appUser?.email} to verify address',
                ),
                const SizedBox(
                  height: 30,
                ),
                _submitButton(context),
              ],
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: Wrap(
        children: <Widget>[
          MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            color: Colors.yellow[50],
            onPressed: _submit,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: const TitleText(
              'Send Link',
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  void _submit() {
    // var state = Provider.of<AuthState>(context, listen: false);
    authState.sendEmailVerification(_scaffoldKey);
  }

  @override
  Widget build(BuildContext context) {
    var appSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: [
            frostedYellow(
              Container(
                height: appSize.height,
                width: appSize.width,
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
            ),
            Positioned(
                top: appSize.width * 0.2,
                left: 10,
                right: 10,
                child: _body(context)),
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
                              child: customTitleText('Email Verification'),
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

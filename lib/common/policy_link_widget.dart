import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:viewducts/app_theme/app_theme_constant.dart';
import 'package:viewducts/page/settings/accountSettings/policy.dart';

class PolicyLinkWidget extends StatelessWidget {
  static route() => MaterialPageRoute(
        builder: (context) =>
            Policy(mdFileName: 'privacy_policy', name: "Privacy policy"),
      );
  const PolicyLinkWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
                  color: CupertinoColors.systemBlue,
                  fontSize: 18,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(context, PolicyLinkWidget.route());

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
                          color: CupertinoColors.systemBlue,
                          fontSize: 18,
                          decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(context, PolicyLinkWidget.route());
                          // code to open / launch privacy policy link here
                        })
                ])
          ]))),
    );
  }
}

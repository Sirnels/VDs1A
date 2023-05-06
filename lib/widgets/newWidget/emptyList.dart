// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viewducts/widgets/newWidget/title_text.dart';
import '../customWidgets.dart';

class EmptyList extends StatelessWidget {
  const EmptyList(this.title, {Key? key, this.subTitle}) : super(key: key);

  final String? subTitle;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: fullHeight(context) - 135,
        child: NotifyText(
          title: title,
          subTitle: subTitle,
        ));
  }
}

class NotifyText extends StatelessWidget {
  final String? subTitle;
  final String? title;
  const NotifyText({Key? key, this.subTitle, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Wrap(
          children: [
            TitleText(title, fontSize: 20, textAlign: TextAlign.center),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Wrap(
          children: [
            Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 11),
                        blurRadius: 11,
                        color: Colors.black.withOpacity(0.06))
                  ],
                  borderRadius: BorderRadius.circular(5),
                  color: CupertinoColors.lightBackgroundGray),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TitleText(
                  subTitle,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: CupertinoColors.darkBackgroundGray,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

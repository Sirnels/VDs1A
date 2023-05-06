// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:viewducts/helper/theme.dart';
import 'package:viewducts/widgets/newWidget/customCheckBox.dart';

class SettingRowWidget extends StatelessWidget {
  const SettingRowWidget(this.title,
      {Key? key,
      this.navigateTo,
      this.subtitle,
      this.textColor,
      this.onPressed,
      this.vPadding = 0,
      this.showDivider = true,
      this.visibleSwitch,
      this.showCheckBox,
      this.fontSize = 16,
      this.fontWeight,
      this.subtextColor})
      : super(key: key);
  final bool? visibleSwitch, showDivider, showCheckBox;
  final String? navigateTo;
  final String? subtitle, title;
  final Color? textColor;
  final Function? onPressed;
  final double vPadding;
  final double fontSize;
  final FontWeight? fontWeight;
  final Color? subtextColor;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
            contentPadding:
                EdgeInsets.symmetric(vertical: vPadding, horizontal: 18),
            onTap: () {
              if (onPressed != null) {
                onPressed!();
                return;
              }
              if (navigateTo == null) {
                return;
              }
              Navigator.pushNamed(context, '/$navigateTo');
            },
            title: title == null
                ? null
                : Text(
                    title ?? '',
                    style: TextStyle(
                        fontSize: fontSize,
                        color: textColor,
                        fontWeight: fontWeight),
                  ),
            subtitle: subtitle == null
                ? null
                : Text(
                    subtitle ?? '',
                    style: const TextStyle(
                        color: TwitterColor.paleSky,
                        fontWeight: FontWeight.w400),
                  ),
            trailing: CustomCheckBox(
              isChecked: showCheckBox,
              visibleSwitch: visibleSwitch,
            )),
        !showDivider! ? const SizedBox() : const Divider(height: 0)
      ],
    );
  }
}

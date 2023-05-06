// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:viewducts/theme/colorText.dart';

class TitleText extends StatelessWidget {
  final String? text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  const TitleText(
      {Key? key,
      this.text,
      this.fontSize = 18,
      this.color = LightColor.titleTextColor,
      this.fontWeight = FontWeight.w800})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(text!, style: const TextStyle());
  }
}

class TabText extends StatelessWidget {
  final String? text;
  final double fontSize;
  final Color? color;
  final FontWeight fontWeight;
  final Function? onTapTab;
  final bool isSelected;
  const TabText(
      {Key? key,
      this.text,
      this.isSelected = false,
      this.onTapTab,
      this.fontSize = 18,
      this.color,
      this.fontWeight = FontWeight.w800})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapTab as void Function()?,
      child: Container(
        decoration: !isSelected
            ? const BoxDecoration()
            : BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.black54,
                // gradient: LinearGradient(
                //   colors: [
                //     Colors.black.withOpacity(0.1),
                //     Colors.black.withOpacity(0.2),
                //     Colors.black.withOpacity(0.3)
                //   ],
                //   // begin: Alignment.topCenter,
                //   // end: Alignment.bottomCenter,
                // )
              ),
        child: Padding(
          padding: !isSelected
              ? const EdgeInsets.all(0.0)
              : const EdgeInsets.all(4.0),
          child: Text(
            text!,
            style: isSelected
                ? const TextStyle(color: Colors.yellow)
                : defaultTabText,
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: deprecated_member_use, file_names

import 'package:flutter/material.dart';

class RippleButton extends StatelessWidget {
  final Widget? child;
  final Function? onPressed;
  final BorderRadius borderRadius;
  final Color? splashColor;
  const RippleButton(
      {Key? key,
      this.child,
      this.onPressed,
      this.borderRadius = const BorderRadius.all(Radius.circular(0)),
      this.splashColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        child!,
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
          child: TextButton(
              // splashColor: splashColor,
              // shape: RoundedRectangleBorder(borderRadius: borderRadius),
              onPressed: () {
                if (onPressed != null) {
                  onPressed!();
                }
              },
              child: Container()),
        )
      ],
    );
  }
}

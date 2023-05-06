import 'package:flutter/material.dart';

extension OnPressed on Widget {
  Widget ripple(Function onPressed,
          {BorderRadiusGeometry borderRadius =
              const BorderRadius.all(Radius.circular(5))}) =>
      Stack(
        children: <Widget>[
          this,
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            // ignore: deprecated_member_use
            child: TextButton(
                // shape: RoundedRectangleBorder(borderRadius: borderRadius),
                onPressed: () {
                  onPressed();
                },
                child: Container()),
          )
        ],
      );
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viewducts/apis/auth_api.dart';
import 'package:viewducts/widgets/customWidgets.dart';

class ViewDialogs {
  Future<Object?> customeDialog(BuildContext context,
      {required double height,
      required double width,
      required Widget body,
      required double dx,
      required double dy,
      required double horizontal,
      required double vertical,
      WidgetRef? ref,
      bool? isCart,
      bool? isDuct}) {
    return showGeneralDialog(
      barrierDismissible: true,
      barrierLabel: 'Duct Now',
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        Tween<Offset> tween;
        tween = Tween(begin: Offset(dx, dy), end: Offset.zero);
        return SlideTransition(
          position: tween.animate(
              CurvedAnimation(parent: animation, curve: Curves.bounceIn)),
          child: child,
        );
      },
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        // switch (expand) {
        //   case true:
        //     Container(
        //       clipBehavior: Clip.hardEdge,
        //       height: height,
        //       width: width,
        //       padding: const EdgeInsets.all(10.0),
        //       margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.all(Radius.circular(20)),
        //         color: Colors.transparent,
        //       ),
        //       child: Scaffold(
        //         backgroundColor: Colors.transparent,
        //         body: body,
        //       ),
        //     );

        //     break;
        //   case false:
        //     Container(
        //       clipBehavior: Clip.hardEdge,
        //       height: height,
        //       width: width,
        //       padding: const EdgeInsets.all(10.0),
        //       margin: EdgeInsets.symmetric(
        //           horizontal: horizontal,
        //           vertical: fullHeight(context) * vertical),
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.all(Radius.circular(20)),
        //         color: Colors.transparent,
        //       ),
        //       child: Scaffold(
        //         backgroundColor: Colors.transparent,
        //         body: body,
        //       ),
        //     );

        //     break;
        //   default:
        // }
        return Container(
          clipBehavior: Clip.hardEdge,
          height: height,
          width: width,
          padding: const EdgeInsets.all(10.0),
          margin: isDuct == true
              ? EdgeInsets.symmetric(horizontal: 0, vertical: 0)
              : isCart == true
                  ? EdgeInsets.only(top: vertical)
                  : EdgeInsets.symmetric(
                      horizontal: horizontal,
                      vertical: fullHeight(context) * vertical),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.transparent,
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: body,
          ),
        );
      },
    );
  }
}

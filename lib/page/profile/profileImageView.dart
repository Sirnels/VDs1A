// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';

import 'package:viewducts/widgets/customWidgets.dart';

class ProfileImageView extends HookWidget {
  final String? profileImage;

  const ProfileImageView({Key? key, this.profileImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var authstate = Provider.of<AuthState>(context, listen: false);
    return Scaffold(
      //  backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Hero(
            tag: 'profilePic',
            child: Center(
              child: Container(
                alignment: Alignment.center,
                width: fullWidth(context),
                height: fullHeight(context),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: customAdvanceNetworkImage('${profileImage}'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          // Row(
          //   children: [
          //     IconButton(
          //         icon: const Icon(Icons.menu),
          //         onPressed: () {
          //           _opTions(
          //             context,
          //           );
          //         }),
          //   ],
          // ),
          Positioned(
            top: Get.height * 0.1,
            left: 5,
            child: Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 11),
                        blurRadius: 11,
                        color: Colors.black.withOpacity(0.06))
                  ],
                  borderRadius: BorderRadius.circular(100),
                  color: CupertinoColors.inactiveGray),
              padding: const EdgeInsets.all(5.0),
              height: fullWidth(context) * 0.1,
              //width: fullWidth(context) * 0.3,
              child: Center(
                child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(CupertinoIcons.back)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

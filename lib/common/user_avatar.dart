import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viewducts/helper/enum.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/page/responsiveView.dart';
import 'package:viewducts/widgets/customWidgets.dart';

class UserAvater extends ConsumerWidget {
  final ViewductsUser userModel;
  final ProfileType profileType;
  const UserAvater({
    super.key,
    required this.userModel,
    required this.profileType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OpenContainer(
                      closedBuilder: (context, action) {
                        return ProfileResponsiveView(
                          profileId: userModel.userId,
                          profileType: profileType,
                        );
                      },
                      openBuilder: (context, action) {
                        return ProfileResponsiveView(
                          profileId: userModel.userId,
                          profileType: profileType,
                        );
                      },
                    )));
      },
      child: Stack(
        children: [
          Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0, 11),
                      blurRadius: 11,
                      color: Colors.black.withOpacity(0.06))
                ],
                borderRadius: BorderRadius.circular(100),
              ),
              child: customImage(context, userModel.profilePic, height: 50)),
          Positioned(
            right: 0,
            bottom: 0,
            child: userModel.isVerified == true
                ? Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(100),
                    child: CircleAvatar(
                      radius: 9,
                      backgroundColor: Colors.transparent,
                      child: Image.asset('assets/delicious.png'),
                    ),
                  )
                : Container(),
          )
        ],
      ),
    );
  }
}

// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:viewducts/helper/constant.dart';
import 'package:viewducts/helper/theme.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/newWidget/rippleButton.dart';
import 'package:viewducts/widgets/newWidget/title_text.dart';

class UserListWidget extends StatelessWidget {
  final List<ViewductsUser>? list;
  final String? emptyScreenText;
  final String? emptyScreenSubTileText;
  const UserListWidget({
    Key? key,
    this.list,
    this.emptyScreenText,
    this.emptyScreenSubTileText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var state = Provider.of<AuthState>(context, listen: false);
    String? myId = authState.userModel!.key;
    return ListView.separated(
      itemBuilder: (context, index) {
        return UserTile(
          user: list![index],
          myId: myId,
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(
          height: 0,
        );
      },
      itemCount: list!.length,
    );
    // : LinearProgressIndicator();
  }
}

class UserTile extends StatelessWidget {
  const UserTile({Key? key, this.user, this.myId}) : super(key: key);
  final ViewductsUser? user;
  final String? myId;

  /// Return empty string for default bio
  /// Max length of bio is 100
  String? getBio(String? bio) {
    if (bio != null && bio.isNotEmpty && bio != "Edit profile to update bio") {
      if (bio.length > 100) {
        bio = bio.substring(0, 100) + '...';
        return bio;
      } else {
        return bio;
      }
    }
    return null;
  }

  /// Check if user followerlist contain your or not
  /// If your id exist in follower list it mean you are following him
  bool isFollowing() {
    // if (user!.viewersList != null && user!.viewersList!.any((x) => x == myId)) {
    //   return true;
    // } else
    {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isFollow = isFollowing();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: TwitterColor.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            onTap: () {
              //  Navigator.of(context).pushNamed('/ProfilePage/' + user?.userId!);
            },
            leading: RippleButton(
              onPressed: () {
                //   Navigator.of(context).pushNamed('/ProfilePage/' + user?.userId!);
              },
              borderRadius: const BorderRadius.all(Radius.circular(60)),
              child: customImage(context, user!.profilePic, height: 55),
            ),
            title: Row(
              children: <Widget>[
                ConstrainedBox(
                  constraints: BoxConstraints(
                      minWidth: 0, maxWidth: fullWidth(context) * .4),
                  child: TitleText(user!.displayName,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      overflow: TextOverflow.ellipsis),
                ),
                const SizedBox(width: 3),
                user!.isVerified!
                    ? customIcon(
                        context,
                        icon: AppIcon.blueTick,
                        istwitterIcon: true,
                        iconColor: AppColor.primary,
                        size: 13,
                        paddingIcon: 3,
                      )
                    : const SizedBox(width: 0),
              ],
            ),
            subtitle: Text(user!.userName!),
            trailing: RippleButton(
              onPressed: () {},
              splashColor: TwitterColor.dodgetBlue_50.withAlpha(100),
              borderRadius: BorderRadius.circular(25),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isFollow ? 15 : 20,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color:
                      isFollow ? TwitterColor.dodgetBlue : TwitterColor.white,
                  border: Border.all(color: TwitterColor.dodgetBlue, width: 1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  isFollow ? 'Following' : 'Follow',
                  style: TextStyle(
                    color: isFollow ? TwitterColor.white : Colors.blue,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          getBio(user!.bio) == null
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(left: 90),
                  child: Text(
                    getBio(user!.bio)!,
                  ),
                )
        ],
      ),
    );
  }
}

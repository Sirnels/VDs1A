// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:viewducts/helper/enum.dart';
import 'package:viewducts/helper/theme.dart';
import 'package:viewducts/model/feedModel.dart';

class UnavailableDuct extends StatelessWidget {
  const UnavailableDuct({Key? key, this.snapshot, this.type}) : super(key: key);

  final AsyncSnapshot<FeedModel>? snapshot;
  final DuctType? type;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: EdgeInsets.only(
          right: 16,
          top: 5,
          left: type == DuctType.Duct || type == DuctType.ParentDuct ? 70 : 16),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: AppColor.extraLightGrey.withOpacity(.3),
        border: Border.all(color: AppColor.extraLightGrey, width: .5),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: snapshot!.connectionState == ConnectionState.waiting
          ? SizedBox(
              height: 2,
              child: LinearProgressIndicator(
                backgroundColor: AppColor.extraLightGrey,
                valueColor: AlwaysStoppedAnimation(
                  AppColor.darkGrey.withOpacity(.3),
                ),
              ),
            )
          : Text('This Duct is unavailable', style: userNameStyle),
    );
  }
}

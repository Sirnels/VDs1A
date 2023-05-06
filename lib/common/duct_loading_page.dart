import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viewducts/widgets/customWidgets.dart';

class DuctLoadingPage extends StatelessWidget {
  const DuctLoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: fullHeight(context),
      width: fullWidth(context),
      child: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          Expanded(
              child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(80),
                    color:
                        CupertinoColors.lightBackgroundGray.withOpacity(0.2)),
                padding: const EdgeInsets.all(2.0),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: CupertinoColors.lightBackgroundGray
                                .withOpacity(0.2)),
                        padding: const EdgeInsets.all(2.0),
                        width: 60,
                        height: 20,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: CupertinoColors.lightBackgroundGray
                              .withOpacity(0.2)),
                      padding: const EdgeInsets.all(2.0),
                      width: 80,
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: CupertinoColors.lightBackgroundGray
                                .withOpacity(0.2)),
                        padding: const EdgeInsets.all(2.0),
                        width: 100,
                        height: 20,
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
          RotationTransition(
            turns: AlwaysStoppedAnimation(5 / 360),
            child: Container(
              height: fullHeight(context) * 0.35,
              width: fullWidth(context) * 0.8,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: CupertinoColors.lightBackgroundGray.withOpacity(0.1)),
              padding: const EdgeInsets.all(2.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color:
                          CupertinoColors.lightBackgroundGray.withOpacity(0.2)),
                  padding: const EdgeInsets.all(2.0),
                  width: 150,
                  height: 150,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: CupertinoColors.lightBackgroundGray
                                  .withOpacity(0.2)),
                          padding: const EdgeInsets.all(2.0),
                          width: 80,
                          height: 20,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: CupertinoColors.lightBackgroundGray
                                .withOpacity(0.2)),
                        padding: const EdgeInsets.all(2.0),
                        width: 80,
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: CupertinoColors.lightBackgroundGray
                                  .withOpacity(0.2)),
                          padding: const EdgeInsets.all(2.0),
                          width: 100,
                          height: 20,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

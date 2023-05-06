import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:viewducts/widgets/customWidgets.dart';

class ChatLoadingPage extends StatelessWidget {
  const ChatLoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        height: fullHeight(context) * 0.7,
        width: fullWidth(context) * 0.8,
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Expanded(
                child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: fullWidth(context) * 0.8,
                  height: 100,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 50,
                      backgroundColor:
                          CupertinoColors.lightBackgroundGray.withOpacity(0.2),
                    ),
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                color: CupertinoColors.lightBackgroundGray
                                    .withOpacity(0.2)),
                            padding: const EdgeInsets.all(2.0),
                            width: 150,
                            height: 50,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
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
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )),
            Expanded(
                child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: fullWidth(context) * 0.8,
                  height: 100,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 50,
                      backgroundColor:
                          CupertinoColors.lightBackgroundGray.withOpacity(0.2),
                    ),
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                color: CupertinoColors.lightBackgroundGray
                                    .withOpacity(0.2)),
                            padding: const EdgeInsets.all(2.0),
                            width: 120,
                            height: 50,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
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
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )),
            Expanded(
                child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: fullWidth(context) * 0.8,
                  height: 100,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 50,
                      backgroundColor:
                          CupertinoColors.lightBackgroundGray.withOpacity(0.2),
                    ),
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                color: CupertinoColors.lightBackgroundGray
                                    .withOpacity(0.2)),
                            padding: const EdgeInsets.all(2.0),
                            width: 150,
                            height: 50,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
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
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )),
            Expanded(
                child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: fullWidth(context) * 0.8,
                  height: 100,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 50,
                      backgroundColor:
                          CupertinoColors.lightBackgroundGray.withOpacity(0.2),
                    ),
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                color: CupertinoColors.lightBackgroundGray
                                    .withOpacity(0.2)),
                            padding: const EdgeInsets.all(2.0),
                            width: 150,
                            height: 50,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
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
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

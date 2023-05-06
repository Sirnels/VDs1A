import 'dart:ui';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/chatModel.dart';
import 'package:viewducts/page/responsive.dart';
import 'package:viewducts/page/responsiveView.dart';
import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/frosted.dart';

class Policy extends HookWidget {
  final String? mdFileName;
  final String? name;
  final bool? active;
  Policy({this.active, this.name, this.mdFileName, super.key});
  //  : assert(mdFileName!.contains('.md'));

  @override
  Widget build(BuildContext context) {
    //final policyState = useState(policyModel);
    Rx<PolicyModel> policyMod = PolicyModel().obs;
    policy() async {
      final database = Databases(
        clientConnect(),
      );
      await database.listDocuments(
          databaseId: databaseId,
          collectionId: policyColl,
          queries: [Query.equal('topic', mdFileName.toString())]).then((data) {
        if (data.documents.isNotEmpty) {
          var value =
              data.documents.map((e) => PolicyModel.fromJson(e.data)).toList();

          userCartController.policyModel.value = value;
        }
      });
    }

    useEffect(
      () {
        policy();

        return () {};
      },
      [userCartController.policyModel],
    );
    return Scaffold(
      body: SafeArea(
          child: Responsive(
        mobile: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      active == true
                          ? Container()
                          : IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(CupertinoIcons.back),
                            ),
                      Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(10),
                        child: frostedOrange(
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 3),
                            child: customTitleText('$name'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    flex: 20,
                    child: Obx(
                      () => userCartController.policyModel
                                  .firstWhere(
                                      (data) =>
                                          data.topic == mdFileName.toString(),
                                      orElse: () => policyMod.value)
                                  .body ==
                              null
                          ? Center(
                              child: SizedBox(
                              width: Get.height * 0.2,
                              height: Get.height * 0.2,
                              child: LoadingIndicator(
                                  indicatorType: Indicator.ballTrianglePath,

                                  /// Required, The loading type of the widget
                                  colors: const [
                                    Colors.pink,
                                    Colors.green,
                                    Colors.blue
                                  ],

                                  /// Optional, The color collections
                                  strokeWidth: 0.5,

                                  /// Optional, The stroke of the line, only applicable to widget which contains line
                                  backgroundColor: Colors.transparent,

                                  /// Optional, Background of the widget
                                  pathBackgroundColor: Colors.blue

                                  /// Optional, the stroke backgroundColor
                                  ),
                            )
                              //  CircularProgressIndicator
                              //     .adaptive()
                              )
                          : Markdown(
                              data:
                                  '${userCartController.policyModel.firstWhere((data) => data.topic == mdFileName.toString(), orElse: () => policyMod.value).body ?? ''}'),
                    )

                    // FutureBuilder(
                    //   future:
                    //       Future.delayed(Duration(milliseconds: 60)).then((value) {
                    //     return userCartController.policyModel
                    //         .firstWhere((data) => data.topic == mdFileName.toString())
                    //         .body
                    //         .toString();
                    //     //rootBundle.loadString('assets/policy/$mdFileName');
                    //   }),
                    //   builder: (context, snapshot) {
                    //     if (snapshot.hasData) {
                    //       return Markdown(data: snapshot.data as String);
                    //     }
                    //     return Center(
                    //         child: SizedBox(
                    //       width: Get.height * 0.2,
                    //       height: Get.height * 0.2,
                    //       child: LoadingIndicator(
                    //           indicatorType: Indicator.ballTrianglePath,

                    //           /// Required, The loading type of the widget
                    //           colors: const [Colors.pink, Colors.green, Colors.blue],

                    //           /// Optional, The color collections
                    //           strokeWidth: 0.5,

                    //           /// Optional, The stroke of the line, only applicable to widget which contains line
                    //           backgroundColor: Colors.transparent,

                    //           /// Optional, Background of the widget
                    //           pathBackgroundColor: Colors.blue

                    //           /// Optional, the stroke backgroundColor
                    //           ),
                    //     )
                    //         //  CircularProgressIndicator
                    //         //     .adaptive()
                    //         );
                    //   },
                    // )

                    )
              ],
            )
          ],
        ),
        tablet: Stack(
          children: [
            Row(
              children: [
                Expanded(
                    child: Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(CupertinoIcons.back),
                          ),
                          Material(
                            elevation: 10,
                            borderRadius: BorderRadius.circular(10),
                            child: frostedOrange(
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 3),
                                child: customTitleText('$name'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        flex: 20,
                        child: Obx(
                          () => userCartController.policyModel
                                      .firstWhere(
                                          (data) =>
                                              data.topic ==
                                              mdFileName.toString(),
                                          orElse: () => policyMod.value)
                                      .body ==
                                  null
                              ? Center(
                                  child: SizedBox(
                                  width: Get.height * 0.2,
                                  height: Get.height * 0.2,
                                  child: LoadingIndicator(
                                      indicatorType: Indicator.ballTrianglePath,

                                      /// Required, The loading type of the widget
                                      colors: const [
                                        Colors.pink,
                                        Colors.green,
                                        Colors.blue
                                      ],

                                      /// Optional, The color collections
                                      strokeWidth: 0.5,

                                      /// Optional, The stroke of the line, only applicable to widget which contains line
                                      backgroundColor: Colors.transparent,

                                      /// Optional, Background of the widget
                                      pathBackgroundColor: Colors.blue

                                      /// Optional, the stroke backgroundColor
                                      ),
                                )
                                  //  CircularProgressIndicator
                                  //     .adaptive()
                                  )
                              : Markdown(
                                  data:
                                      '${userCartController.policyModel.firstWhere((data) => data.topic == mdFileName.toString(), orElse: () => policyMod.value).body ?? ''}'),
                        )

                        // FutureBuilder(
                        //   future:
                        //       Future.delayed(Duration(milliseconds: 60)).then((value) {
                        //     return userCartController.policyModel
                        //         .firstWhere((data) => data.topic == mdFileName.toString())
                        //         .body
                        //         .toString();
                        //     //rootBundle.loadString('assets/policy/$mdFileName');
                        //   }),
                        //   builder: (context, snapshot) {
                        //     if (snapshot.hasData) {
                        //       return Markdown(data: snapshot.data as String);
                        //     }
                        //     return Center(
                        //         child: SizedBox(
                        //       width: Get.height * 0.2,
                        //       height: Get.height * 0.2,
                        //       child: LoadingIndicator(
                        //           indicatorType: Indicator.ballTrianglePath,

                        //           /// Required, The loading type of the widget
                        //           colors: const [Colors.pink, Colors.green, Colors.blue],

                        //           /// Optional, The color collections
                        //           strokeWidth: 0.5,

                        //           /// Optional, The stroke of the line, only applicable to widget which contains line
                        //           backgroundColor: Colors.transparent,

                        //           /// Optional, Background of the widget
                        //           pathBackgroundColor: Colors.blue

                        //           /// Optional, the stroke backgroundColor
                        //           ),
                        //     )
                        //         //  CircularProgressIndicator
                        //         //     .adaptive()
                        //         );
                        //   },
                        // )

                        )
                  ],
                )),
              ],
            ),
          ],
        ),
        desktop: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(
                color: (Colors.white12).withOpacity(0.1),
              ),
            ),
            Row(
              children: [
                // Once our width is less then 1300 then it start showing errors
                // Now there is no error if our width is less then 1340

                Expanded(
                  flex: Get.width > 1340 ? 3 : 5,
                  child: PlainScaffold(),
                ),
                Expanded(
                    flex: Get.width > 1340 ? 8 : 10,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(CupertinoIcons.back),
                              ),
                              Material(
                                elevation: 10,
                                borderRadius: BorderRadius.circular(10),
                                child: frostedOrange(
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 3),
                                    child: customTitleText('$name'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            flex: 20,
                            child: Obx(
                              () => userCartController.policyModel
                                          .firstWhere(
                                              (data) =>
                                                  data.topic ==
                                                  mdFileName.toString(),
                                              orElse: () => policyMod.value)
                                          .body ==
                                      null
                                  ? Center(
                                      child: SizedBox(
                                      width: Get.height * 0.2,
                                      height: Get.height * 0.2,
                                      child: LoadingIndicator(
                                          indicatorType:
                                              Indicator.ballTrianglePath,

                                          /// Required, The loading type of the widget
                                          colors: const [
                                            Colors.pink,
                                            Colors.green,
                                            Colors.blue
                                          ],

                                          /// Optional, The color collections
                                          strokeWidth: 0.5,

                                          /// Optional, The stroke of the line, only applicable to widget which contains line
                                          backgroundColor: Colors.transparent,

                                          /// Optional, Background of the widget
                                          pathBackgroundColor: Colors.blue

                                          /// Optional, the stroke backgroundColor
                                          ),
                                    )
                                      //  CircularProgressIndicator
                                      //     .adaptive()
                                      )
                                  : Markdown(
                                      data:
                                          '${userCartController.policyModel.firstWhere((data) => data.topic == mdFileName.toString(), orElse: () => policyMod.value).body ?? ''}'),
                            )

                            // FutureBuilder(
                            //   future:
                            //       Future.delayed(Duration(milliseconds: 60)).then((value) {
                            //     return userCartController.policyModel
                            //         .firstWhere((data) => data.topic == mdFileName.toString())
                            //         .body
                            //         .toString();
                            //     //rootBundle.loadString('assets/policy/$mdFileName');
                            //   }),
                            //   builder: (context, snapshot) {
                            //     if (snapshot.hasData) {
                            //       return Markdown(data: snapshot.data as String);
                            //     }
                            //     return Center(
                            //         child: SizedBox(
                            //       width: Get.height * 0.2,
                            //       height: Get.height * 0.2,
                            //       child: LoadingIndicator(
                            //           indicatorType: Indicator.ballTrianglePath,

                            //           /// Required, The loading type of the widget
                            //           colors: const [Colors.pink, Colors.green, Colors.blue],

                            //           /// Optional, The color collections
                            //           strokeWidth: 0.5,

                            //           /// Optional, The stroke of the line, only applicable to widget which contains line
                            //           backgroundColor: Colors.transparent,

                            //           /// Optional, Background of the widget
                            //           pathBackgroundColor: Colors.blue

                            //           /// Optional, the stroke backgroundColor
                            //           ),
                            //     )
                            //         //  CircularProgressIndicator
                            //         //     .adaptive()
                            //         );
                            //   },
                            // )

                            )
                      ],
                    )),
                Expanded(
                  flex: Get.width > 1340 ? 2 : 4,
                  child: PlainScaffold(),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}

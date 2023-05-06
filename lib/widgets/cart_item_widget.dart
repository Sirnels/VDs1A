import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:viewducts/helper/constant.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/duct/ductStoryPage.dart';
import 'package:viewducts/widgets/frosted.dart';

class CartItemWidget extends StatelessWidget {
  final CartItemModel? cartItem;

  const CartItemWidget({Key? key, this.cartItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Storage storage = Storage(clientConnect());
    Image? url;
    if (feedState.productlist!
            .firstWhere((e) => e.key == cartItem!.id)
            .imagePath ==
        null) {
    } else {
      storage
          .getFileView(
              bucketId: productBucketId,
              fileId: feedState.productlist!
                      .firstWhere((e) => e.key == cartItem!.id)
                      .imagePath ??
                  '')
          .then((bytes) {
        url = Image.memory(bytes);
      });
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.blueGrey[50],
              gradient: LinearGradient(
                colors: [
                  Colors.yellow.withOpacity(0.1),
                  Colors.white60.withOpacity(0.2),
                  Colors.orange.shade200.withOpacity(0.3)
                ],
                // begin: Alignment.topCenter,
                // end: Alignment.bottomCenter,
              )),
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.only(
          //       topLeft: Radius.circular(20),
          //       topRight: Radius.circular(20),
          //       bottomRight: Radius.circular(0),
          //       bottomLeft: Radius.circular(20)),
          //),
          child: frostedOrange(
            Stack(
              children: [
                ListTile(
                  onTap: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.red,
                        // bounce: true,
                        context: context,
                        builder: (context) => ProductStoryView(
                            model: feedState.productlist!
                                .firstWhere((e) => e.key == cartItem!.id)));
                    // showBarModalBottomSheet(
                    //     backgroundColor: Colors.red,
                    //     bounce: true,
                    //     context: context,
                    //     builder: (context) => Container(
                    //             child: DuctStoryView(
                    //           model: model,
                    //         )
                    //         ));
                  },
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.transparent,
                    child: FutureBuilder(
                        future: storage.getFileView(
                            bucketId: productBucketId,
                            fileId: feedState.productlist!
                                .firstWhere((e) => e.key == cartItem!.id)
                                .imagePath
                                .toString()),
                        builder: (context, snap) {
                          return url?.image != null
                              ? Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      image: DecorationImage(
                                          image: url?.image ??
                                              customAdvanceNetworkImage(
                                                  dummyProfilePic),
                                          fit: BoxFit.cover),
                                      color: Colors.blueGrey[50],
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.yellow.withOpacity(0.1),
                                          Colors.white60.withOpacity(0.2),
                                          Colors.pink.withOpacity(0.3)
                                        ],
                                        // begin: Alignment.topCenter,
                                        // end: Alignment.bottomCenter,
                                      )),
                                )
                              : SizedBox();
                        }),
                  ),
                  //  customImage(
                  //     context,
                  //     feedState.productlist!
                  //         .firstWhere((e) => e.key == cartItem!.id)
                  //         .imagePath,
                  //     height: Get.width * 0.15),
                  title: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.blueGrey[50],
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.1),
                                  Colors.white.withOpacity(0.2),
                                  Colors.white.withOpacity(0.3)
                                  // Color(0xfffbfbfb),
                                  // Color(0xfff7f7f7),
                                ],
                                // begin: Alignment.topCenter,
                                // end: Alignment.bottomCenter,
                              ),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: cartItem!.name!.length > 10
                                    ? customTitleText(
                                        '${feedState.productlist!.firstWhere((e) => e.key == cartItem!.id).productName!.substring(0, 8)}...')
                                    : customTitleText(
                                        feedState.productlist!
                                            .firstWhere(
                                                (e) => e.key == cartItem!.id)
                                            .productName,
                                      ))),
                      ],
                    ),
                  ),
                  subtitle:
                      //  cartItem!.vendorId == authState.userId
                      //     ? Container()
                      //     :
                      SizedBox(
                    width: fullWidth(context) * 0.3,
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () async {
                            userCartController.decreaseQuantity(cartItem!);
                          },
                          child: const Icon(
                            CupertinoIcons.minus_circled,
                            size: 30,
                            color: Colors.black,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(cartItem!.quantity.toString(),
                              style: const TextStyle(color: Colors.black)),
                        ),
                        GestureDetector(
                          onTap: () async {
                            userCartController.increaseQuantity(cartItem!);
                          },
                          child: const Icon(
                            CupertinoIcons.add_circled_solid,
                            size: 30,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: Container(
                      padding: const EdgeInsets.all(0),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.yellow),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: customTitleText(NumberFormat.currency(name: 'N ')
                            .format(int.parse(feedState.productlist!
                                    .firstWhere((e) => e.key == cartItem!.id)
                                    .price
                                    .toString()) *
                                int.parse(cartItem!.quantity.toString()))),
                      )),
                ),
              ],
            ),
          ),
        ),

        cartItem!.size == null || cartItem!.size!.isEmpty
            ? Container()
            : Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blueGrey[50],
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.white.withOpacity(0.2),
                        Colors.white.withOpacity(0.3)
                        // Color(0xfffbfbfb),
                        // Color(0xfff7f7f7),
                      ],
                      // begin: Alignment.topCenter,
                      // end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: customText(
                      'Size : ${cartItem!.size}',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ),
        // item['color'] == null
        //     ? Container()
        //     :
        cartItem!.color == null || cartItem!.color!.isEmpty
            ? Container()
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blueGrey[50],
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.2),
                      Colors.white.withOpacity(0.3)
                      // Color(0xfffbfbfb),
                      // Color(0xfff7f7f7),
                    ],
                    // begin: Alignment.topCenter,
                    // end: Alignment.bottomCenter,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: customText(
                    'Color : ${cartItem!.color}',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}

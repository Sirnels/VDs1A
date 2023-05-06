// ignore_for_file: file_names

// import 'dart:html' as html;
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:cached_memory_image/cached_image_base64_manager.dart';
import 'package:cached_memory_image/cached_memory_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/page/responsiveView.dart';
import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/theme/colorText.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/theme/ext.dart';
import 'frosted.dart';

extension CompactMap<T> on Iterable<T?> {
  Iterable<T> compactMap<E>([E? Function(T?)? transform]) =>
      map(transform ?? (e) => e).where((e) => e != null).cast();
}

class FarmsMenu extends HookWidget {
  final bool isWelcomePage;
  final FarmCategoryModel? products;
  final ValueChanged<FarmCategoryModel?>? onSelected;
  final ViewductsUser user;
  const FarmsMenu({
    Key? key,
    this.products,
    this.onSelected,
    required this.isWelcomePage,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Storage storage = Storage(clientConnect());

    return Container(
      decoration: const BoxDecoration(
        color: LightColor.background,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Material(
        borderRadius: BorderRadius.circular(50),
        color: Colors.yellow[100],
        elevation: 20,
        child: frostedOrange(
          Material(
            elevation: 50,
            color: Colors.white.withOpacity(0.8),
            child: frostedOrange(Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
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
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  FutureBuilder(
                    future: storage.getFileView(
                        bucketId: productBucketId,
                        fileId: products!
                            .image), //works for both public file and private file, for private files you need to be logged in
                    builder: (context, snapshot) {
                      return snapshot.hasData && snapshot.data != null
                          ? Image.memory(snapshot.data as Uint8List,
                              width: Get.height * 0.3,
                              height: Get.height * 0.4,
                              fit: BoxFit.cover)
                          : Center(
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
                              );
                    },
                  ),
                  // SizedBox.expand(
                  //   child: snapShotImage.data,
                  // ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: frostedBlueGray(
                      Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 11),
                                  blurRadius: 11,
                                  color: Colors.black.withOpacity(0.06))
                            ],
                            borderRadius: BorderRadius.circular(5),
                            color: CupertinoColors.systemYellow),
                        padding: const EdgeInsets.all(5.0),
                        child: customText(products!.farmCategory,
                            style: const TextStyle(fontSize: 20)),
                      ),
                    ),
                  )
                ],
              ),
            ).ripple(() {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ShopItemPageResponsive(
                    isWelcomePage: isWelcomePage,
                    product: 'product',
                    category: products!.farmCategory,
                    location: authState.userModel?.location,
                    state: authState.userModel?.state,
                    section: 'Farms',
                  ),
                ),
              );
              onSelected!(products);
            }, borderRadius: const BorderRadius.all(Radius.circular(20)))),
          ),
        ),
      ),
    );
  }
}

class BooksMenu extends HookWidget {
  final bool isWelcomePage;
  final BooksCategoryModel? products;
  final ValueChanged<BooksCategoryModel?>? onSelected;
  final ViewductsUser user;
  const BooksMenu({
    Key? key,
    this.products,
    this.onSelected,
    required this.isWelcomePage,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Storage storage = Storage(clientConnect());

    return Container(
      decoration: const BoxDecoration(
        color: LightColor.background,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Material(
        borderRadius: BorderRadius.circular(50),
        color: Colors.yellow[100],
        elevation: 20,
        child: frostedOrange(
          Material(
            elevation: 50,
            color: Colors.white.withOpacity(0.8),
            child: frostedOrange(Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
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
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  FutureBuilder(
                    future: storage.getFileView(
                        bucketId: productBucketId,
                        fileId: products!
                            .image), //works for both public file and private file, for private files you need to be logged in
                    builder: (context, snapshot) {
                      return snapshot.hasData && snapshot.data != null
                          ? Image.memory(snapshot.data as Uint8List,
                              width: Get.height * 0.3,
                              height: Get.height * 0.4,
                              fit: BoxFit.cover)
                          : Center(
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
                              );
                    },
                  ),
                  // SizedBox.expand(
                  //   child: snapShotImage.data,
                  // ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: frostedBlueGray(
                      Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 11),
                                  blurRadius: 11,
                                  color: Colors.black.withOpacity(0.06))
                            ],
                            borderRadius: BorderRadius.circular(5),
                            color: CupertinoColors.systemYellow),
                        padding: const EdgeInsets.all(5.0),
                        child: customText(products!.booksCategory,
                            style: const TextStyle(fontSize: 20)),
                      ),
                    ),
                  )
                ],
              ),
            ).ripple(() {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ShopItemPageResponsive(
                    isWelcomePage: isWelcomePage,
                    product: 'product',
                    category: products!.booksCategory,
                    location: authState.userModel?.location,
                    state: authState.userModel?.state,
                    section: 'Books',
                  ),
                ),
              );
              onSelected!(products);
            }, borderRadius: const BorderRadius.all(Radius.circular(20)))),
          ),
        ),
      ),
    );
  }
}

class HousingMenu extends HookWidget {
  final bool isWelcomePage;
  final HousingCategoryModel? products;
  final ValueChanged<HousingCategoryModel?>? onSelected;
  final ViewductsUser user;
  const HousingMenu({
    Key? key,
    this.products,
    this.onSelected,
    required this.isWelcomePage,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Storage storage = Storage(clientConnect());
    imageStream() async {
      return CachedMemoryImage(
        uniqueKey: '${products!.image}',
        fit: BoxFit.cover,
        bytes: await storage.getFilePreview(
            bucketId: productBucketId, fileId: products!.image),
      );
    }

    final future = useMemoized(() => imageStream());
    final snapShotImage = useFuture(future);
    return Container(
      decoration: const BoxDecoration(
        color: LightColor.background,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Material(
        borderRadius: BorderRadius.circular(50),
        color: Colors.yellow[100],
        elevation: 20,
        child: frostedOrange(
          Material(
            elevation: 50,
            color: Colors.white.withOpacity(0.8),
            child: frostedOrange(Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
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
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  SizedBox.expand(
                    child: snapShotImage.data,
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: frostedBlueGray(
                      Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 11),
                                  blurRadius: 11,
                                  color: Colors.black.withOpacity(0.06))
                            ],
                            borderRadius: BorderRadius.circular(5),
                            color: CupertinoColors.systemYellow),
                        padding: const EdgeInsets.all(5.0),
                        child: customText(products!.housingCategory,
                            style: const TextStyle(fontSize: 20)),
                      ),
                    ),
                  )
                ],
              ),
            ).ripple(() {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ShopItemPageResponsive(
                    isWelcomePage: isWelcomePage,
                    product: 'product',
                    category: products!.housingCategory,
                    location: authState.userModel?.location,
                    state: authState.userModel?.state,
                    section: 'Housing',
                  ),
                ),
              );
              onSelected!(products);
            }, borderRadius: const BorderRadius.all(Radius.circular(20)))),
          ),
        ),
      ),
    );
  }
}

class CarsMenu extends HookWidget {
  final bool isWelcomePage;
  final CarsCategoryModel? products;
  final ValueChanged<CarsCategoryModel?>? onSelected;
  final ViewductsUser user;
  const CarsMenu({
    Key? key,
    this.products,
    this.onSelected,
    required this.isWelcomePage,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Storage storage = Storage(clientConnect());

    return Container(
      decoration: const BoxDecoration(
        color: LightColor.background,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Material(
        borderRadius: BorderRadius.circular(50),
        color: Colors.yellow[100],
        elevation: 20,
        child: frostedOrange(
          Material(
            elevation: 50,
            color: Colors.white.withOpacity(0.8),
            child: frostedOrange(Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
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
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  FutureBuilder(
                    future: storage.getFileView(
                        bucketId: productBucketId,
                        fileId: products!
                            .image), //works for both public file and private file, for private files you need to be logged in
                    builder: (context, snapshot) {
                      return snapshot.hasData && snapshot.data != null
                          ? Image.memory(snapshot.data as Uint8List,
                              width: Get.height * 0.3,
                              height: Get.height * 0.4,
                              fit: BoxFit.cover)
                          : Center(
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
                              );
                    },
                  ),
                  // SizedBox.expand(
                  //   child: snapShotImage.data,
                  // ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: frostedBlueGray(
                      Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 11),
                                  blurRadius: 11,
                                  color: Colors.black.withOpacity(0.06))
                            ],
                            borderRadius: BorderRadius.circular(5),
                            color: CupertinoColors.systemYellow),
                        padding: const EdgeInsets.all(5.0),
                        child: customText(products!.carsCategory,
                            style: const TextStyle(fontSize: 20)),
                      ),
                    ),
                  )
                ],
              ),
            ).ripple(() {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ShopItemPageResponsive(
                    isWelcomePage: isWelcomePage,
                    product: 'product',
                    category: products!.carsCategory,
                    location: authState.userModel?.location,
                    state: authState.userModel?.state,
                    section: 'Cars',
                  ),
                ),
              );
              onSelected!(products);
            }, borderRadius: const BorderRadius.all(Radius.circular(20)))),
          ),
        ),
      ),
    );
  }
}

class FashionMenu extends HookWidget {
  final bool isWelcomePage;
  final FashionCategoryModel? products;
  final ValueChanged<FashionCategoryModel?>? onSelected;
  final ViewductsUser user;
  const FashionMenu({
    required this.user,
    Key? key,
    this.products,
    this.onSelected,
    required this.isWelcomePage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Storage storage = Storage(clientConnect());

    return Container(
      decoration: const BoxDecoration(
        color: LightColor.background,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Material(
        borderRadius: BorderRadius.circular(50),
        color: Colors.yellow[100],
        elevation: 20,
        child: frostedOrange(
          Material(
            elevation: 50,
            color: Colors.white.withOpacity(0.8),
            child: frostedOrange(Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
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
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  FutureBuilder(
                    future: storage.getFileView(
                        bucketId: productBucketId,
                        fileId: products!
                            .image), //works for both public file and private file, for private files you need to be logged in
                    builder: (context, snapshot) {
                      return snapshot.hasData && snapshot.data != null
                          ? Image.memory(snapshot.data as Uint8List,
                              width: Get.height * 0.3,
                              height: Get.height * 0.4,
                              fit: BoxFit.cover)
                          : Center(
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
                              );
                    },
                  ),
                  // SizedBox.expand(
                  //   child: snapShotImage.data,
                  // ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: frostedBlueGray(
                      Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 11),
                                  blurRadius: 11,
                                  color: Colors.black.withOpacity(0.06))
                            ],
                            borderRadius: BorderRadius.circular(5),
                            color: CupertinoColors.systemYellow),
                        padding: const EdgeInsets.all(5.0),
                        child: customText(products!.fashionCategory,
                            style: const TextStyle(fontSize: 20)),
                      ),
                    ),
                  )
                ],
              ),
            ).ripple(() {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ShopItemPageResponsive(
                    isWelcomePage: isWelcomePage,
                    product: 'product',
                    category: products!.fashionCategory,
                    location: authState.userModel?.location,
                    state: authState.userModel?.state,
                    section: 'Adult Fashion',
                  ),
                ),
              );
              onSelected!(products);
            }, borderRadius: const BorderRadius.all(Radius.circular(20)))),
          ),
        ),
      ),
    );
  }
}

class GroceryMenu extends HookWidget {
  final bool isWelcomePage;
  final GroceryCategoryModel? products;
  final ViewductsUser user;
  final ValueChanged<GroceryCategoryModel?>? onSelected;
  const GroceryMenu({
    required this.user,
    Key? key,
    this.products,
    this.onSelected,
    required this.isWelcomePage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Storage storage = Storage(clientConnect());

    return Container(
      decoration: const BoxDecoration(
        color: LightColor.background,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Material(
        borderRadius: BorderRadius.circular(50),
        color: Colors.yellow[100],
        elevation: 20,
        child: frostedYellow(
          Material(
            elevation: 50,
            color: Colors.white.withOpacity(0.8),
            child: frostedYellow(Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
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
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  FutureBuilder(
                    future: storage.getFileView(
                        bucketId: productBucketId,
                        fileId: products!
                            .image), //works for both public file and private file, for private files you need to be logged in
                    builder: (context, snapshot) {
                      return snapshot.hasData && snapshot.data != null
                          ? Image.memory(snapshot.data as Uint8List,
                              width: Get.height * 0.3,
                              height: Get.height * 0.4,
                              fit: BoxFit.cover)
                          : Center(
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
                              );
                    },
                  ),
                  // SizedBox.expand(
                  //   child: snapShotImage.data,
                  // ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: frostedBlueGray(
                      Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 11),
                                  blurRadius: 11,
                                  color: Colors.black.withOpacity(0.06))
                            ],
                            borderRadius: BorderRadius.circular(5),
                            color: CupertinoColors.systemYellow),
                        padding: const EdgeInsets.all(5.0),
                        child: customText(products!.groceryCategory,
                            style: const TextStyle(fontSize: 20)),
                      ),
                    ),
                  )
                ],
              ),
            ).ripple(() {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ShopItemPageResponsive(
                    isWelcomePage: isWelcomePage,
                    product: 'product',
                    category: products!.groceryCategory,
                    location: authState.userModel?.location,
                    state: authState.userModel?.state,
                    section: 'Grocery',
                  ),
                ),
              );
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => ShopItemPageResponsive(),
              //   ),
              // );
              onSelected!(products);
            }, borderRadius: const BorderRadius.all(Radius.circular(20)))),
          ),
        ),
      ),
    );
  }
}

class ElectronicsMenu extends HookWidget {
  final ElectronicsCategoryModel? products;
  final ViewductsUser user;
  final bool? isWelcome;
  final bool isWelcomePage;
  final ValueChanged<ElectronicsCategoryModel?>? onSelected;
  const ElectronicsMenu(
      {Key? key,
      this.products,
      this.onSelected,
      this.isWelcome,
      required this.isWelcomePage,
      required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Storage storage = Storage(clientConnect());

    imageStream() async {
      final cachedImage = CachedImageBase64Manager.instance();

      return cachedImage.cacheBytes(
        '${products!.image}',
        maxAge: Duration(days: 10),
        await storage.getFilePreview(
            bucketId: productBucketId, fileId: products!.image),
      );
      // CachedMemoryImage(
      //   uniqueKey: '${products!.data['image']}',
      //   fit: BoxFit.cover,
      //   bytes: await storage.getFilePreview(
      //       bucketId: productBucketId, fileId: products!.data['image']),
      // );
    }

    final future = useMemoized(() => imageStream());
    final snapShotImage = useFuture(future);
    useEffect(
      () {
        future;
        snapShotImage;
        return () {};
      },
      [],
    );
    return Container(
      decoration: const BoxDecoration(
        color: LightColor.background,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      // margin:
      //     EdgeInsets.symmetric(vertical: !widget.products.isSelected ? 20 : 0),
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Material(
        borderRadius: BorderRadius.circular(50),
        color: Colors.yellow[100],
        elevation: 20,
        child: frostedWhite(
          Material(
            elevation: 50,
            color: Colors.white.withOpacity(0.8),
            child: frostedGreen(Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
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
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  FutureBuilder(
                    future: storage.getFileView(
                        bucketId: productBucketId,
                        fileId: products!
                            .image), //works for both public file and private file, for private files you need to be logged in
                    builder: (context, snapshot) {
                      return snapshot.hasData && snapshot.data != null
                          ? Image.memory(snapshot.data as Uint8List,
                              width: Get.height * 0.3,
                              height: Get.height * 0.4,
                              fit: BoxFit.cover)
                          : Center(
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
                              );
                    },
                  ),
                  // SizedBox.expand(
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       borderRadius:
                  //           const BorderRadius.all(Radius.circular(10)),
                  //       image: DecorationImage(
                  //           image: FileImage(
                  //               dio.File('${snapShotImage.data?.path}')),
                  //           fit: BoxFit.cover),
                  //     ),
                  //   ),
                  //   // Text(snapShotImage.data?.path.toString()),
                  // ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: frostedBlueGray(
                      Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  offset: const Offset(0, 11),
                                  blurRadius: 11,
                                  color: Colors.black.withOpacity(0.06))
                            ],
                            borderRadius: BorderRadius.circular(5),
                            color: CupertinoColors.systemYellow),
                        padding: const EdgeInsets.all(5.0),
                        child: customText(products!.electronicsCategory,
                            style: const TextStyle(fontSize: 20)),
                      ),
                    ),
                  )
                ],
              ),
            ).ripple(() {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ShopItemPageResponsive(
                    isWelcomePage: isWelcomePage,
                    product: 'product',
                    category: products!.electronicsCategory,
                    location: user.location,
                    state: user.state,
                    section: 'Electronics',
                  ),
                ),
              );
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => ShopItemPageResponsive(),
              //   ),
              // );
              onSelected!(products);
            }, borderRadius: const BorderRadius.all(Radius.circular(20)))),
          ),
        ),
      ),
    );
  }
}

class ChildrenMenu extends StatelessWidget {
  final ChildrenCategoryModel? products;
  final ValueChanged<ChildrenCategoryModel?>? onSelected;
  final ViewductsUser user;
  final bool isWelcomePage;
  const ChildrenMenu({
    Key? key,
    this.products,
    this.onSelected,
    required this.user,
    required this.isWelcomePage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var appSize = MediaQuery.of(context).size;

    Storage storage = Storage(clientConnect());

    return Container(
      decoration: const BoxDecoration(
        color: LightColor.background,
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Material(
          borderRadius: BorderRadius.circular(20),
          elevation: 20,
          child: frostedYellow(
              // FutureBuilder(
              //   future: storage.getFilePreview(
              //       bucketId: productBucketId, fileId: products?.data['image']),
              //   builder: (context, snap) {
              //     return snap.hasData
              //         ?
              Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                // image: DecorationImage(
                //     image: snapShotImage.data?.image ??
                //         AssetImage('assets/delicious.png'),
                //     fit: BoxFit.cover),
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
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                FutureBuilder(
                  future: storage.getFileView(
                      bucketId: productBucketId,
                      fileId: products!
                          .image), //works for both public file and private file, for private files you need to be logged in
                  builder: (context, snapshot) {
                    return snapshot.hasData && snapshot.data != null
                        ? Image.memory(snapshot.data as Uint8List,
                            width: Get.height * 0.3,
                            height: Get.height * 0.4,
                            fit: BoxFit.cover)
                        : Center(
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
                            );
                  },
                ),
                // SizedBox.expand(
                //   child: Container(
                //     decoration: BoxDecoration(
                //       borderRadius: const BorderRadius.all(Radius.circular(10)),
                //       image: DecorationImage(
                //           image: FileImage(
                //               dio.File('${snapShotImage.data?.path}')),
                //           fit: BoxFit.cover),
                //     ),
                //   ),
                //   // Text(snapShotImage.data?.path.toString()),
                // ),
                // SizedBox.expand(
                //   child: Container(
                //     decoration: BoxDecoration(
                //       borderRadius: const BorderRadius.all(Radius.circular(10)),
                //       image: DecorationImage(
                //           image: FileImage(
                //               dio.File('${snapShotImage.data?.path}')),
                //           fit: BoxFit.cover),
                //     ),
                //   ),
                // Text(snapShotImage.data?.path.toString()),
                //),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: frostedBlueGray(
                    Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(0, 11),
                                blurRadius: 11,
                                color: Colors.black.withOpacity(0.06))
                          ],
                          borderRadius: BorderRadius.circular(5),
                          color: CupertinoColors.systemYellow),
                      padding: const EdgeInsets.all(5.0),
                      child: customText(products!.childrenCategory,
                          style: const TextStyle(fontSize: 20)),
                    ),
                  ),
                )
              ].compactMap().toList(),
            ),
          ).ripple(() {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShopItemPageResponsive(
                    isWelcomePage: isWelcomePage,
                    product: 'product',
                    category: products!.childrenCategory,
                    //country: authState.userModel!.location,
                    state: user.state,

                    location: user.location,
                    section: 'Children',
                  ),
                ));
            // Get.to(
            //     () => ShopItemPageResponsive(
            //           product: 'product',
            //           category: products!.childrenCategory,
            //           //country: authState.userModel!.location,
            //           state: authState.userModel?.state,

            //           location: authState.userModel?.location,
            //           section: 'Children',
            //         ),
            //     transition: Transition.downToUp);

            onSelected!(products);
          }, borderRadius: const BorderRadius.all(Radius.circular(20)))
              // : Center(
              //     child: LoadingIndicator(
              //         indicatorType: Indicator.ballTrianglePath,

              //         /// Required, The loading type of the widget
              //         colors: const [
              //           Colors.pink,
              //           Colors.green,
              //           Colors.blue
              //         ],

              //         /// Optional, The color collections
              //         strokeWidth: 0.5,

              //         /// Optional, The stroke of the line, only applicable to widget which contains line
              //         backgroundColor: Colors.transparent,

              //         /// Optional, Background of the widget
              //         pathBackgroundColor: Colors.blue

              //         /// Optional, the stroke backgroundColor
              //         )
              //     //  CircularProgressIndicator
              //     //     .adaptive()
              //     );

              )),
    );
  }
}

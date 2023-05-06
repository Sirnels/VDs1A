import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:status_alert/status_alert.dart';
import 'package:uuid/uuid.dart';
import 'package:viewducts/apis/auth_api.dart';
import 'package:viewducts/apis/country_api.dart';
import 'package:viewducts/apis/products_api.dart';
import 'package:viewducts/core/utils.dart';
import 'package:viewducts/model/chatModel.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';

import '../../helper/utility.dart';

final productControllerProvider =
    StateNotifierProvider<CountryController, bool>(
  (ref) {
    return CountryController(
      // ref: ref,
      productApi: ref.watch(productAPIProvider),
    );
  },
);
final getProductProvider = FutureProvider((ref) {
  final productController = ref.watch(productControllerProvider.notifier);
  return productController.getProducts();
});
final getChildernCategoryProvider = FutureProvider((ref) {
  final productController = ref.watch(productControllerProvider.notifier);
  return productController.getChildrenCategory();
});
final getElectronicsCategoryProvider = FutureProvider((ref) {
  final productController = ref.watch(productControllerProvider.notifier);
  return productController.getElectronicsCategory();
});
final getFashionCategoryProvider = FutureProvider((ref) {
  final productController = ref.watch(productControllerProvider.notifier);
  return productController.getFashionCategory();
});
final getHousingProvider = FutureProvider((ref) {
  final productController = ref.watch(productControllerProvider.notifier);
  return productController.getHousingCategory();
});
final getFarmsProvider = FutureProvider((ref) {
  final productController = ref.watch(productControllerProvider.notifier);
  return productController.getFarmCategory();
});
final getCarsProvider = FutureProvider((ref) {
  final productController = ref.watch(productControllerProvider.notifier);
  return productController.getCarsCategory();
});
final getBookstProvider = FutureProvider((ref) {
  final productController = ref.watch(productControllerProvider.notifier);
  return productController.getBooksCategory();
});
final getGroceryCategoryProvider = FutureProvider((ref) {
  final productController = ref.watch(productControllerProvider.notifier);
  return productController.getGroceryCategory();
});
final getSectionProvider = FutureProvider((ref) {
  final productController = ref.watch(productControllerProvider.notifier);
  return productController.getSection();
});
final getProductCategoriesProvider =
    FutureProvider.family.autoDispose((ref, ProductCategoryInput data) {
  final productController = ref.watch(productControllerProvider.notifier);
  return productController.getProductsCategories(data);
});
final getProductRatingProvider =
    FutureProvider.family.autoDispose((ref, RatingModel data) {
  final productController = ref.watch(productControllerProvider.notifier);
  return productController.getProductRating(data);
});
final getProductInCartProvider =
    FutureProvider.family.autoDispose((ref, String data) {
  final productController = ref.watch(productControllerProvider.notifier);
  return productController.getProductsInCart(data);
});
final getGroupOfProductsByVendorsProvider =
    FutureProvider.family.autoDispose((ref, String data) {
  final productController = ref.watch(productControllerProvider.notifier);
  return productController.getGroupOfProductsByVendors(data);
});
final getProductsInCartByVendorsProvider =
    FutureProvider.family.autoDispose((ref, String data) {
  final productController = ref.watch(productControllerProvider.notifier);
  return productController.getProductsInCartByVendors(data);
});
final getDataApiKeywasabiAwsProvider = FutureProvider((ref) {
  final productController = ref.watch(productControllerProvider.notifier);
  return productController.getDataApiKeywasabiAws();
});
final getOneProductProvider =
    FutureProvider.family.autoDispose((ref, String productId) {
  final productController = ref.watch(productControllerProvider.notifier);
  return productController.getOneProduct(productId);
});
final getShippingAdressProvider = FutureProvider((
  ref,
) {
  final productController = ref.watch(productControllerProvider.notifier);
  return productController.listShippingAddress();
});
final getUserOrdersProvider =
    FutureProvider.family.autoDispose((ref, String data) {
  final productController = ref.watch(productControllerProvider.notifier);
  return productController.getUserOrder(data);
});
final getinitPaymentDatabaseProvider =
    FutureProvider.family.autoDispose((ref, String data) {
  final productController = ref.watch(productControllerProvider.notifier);
  return productController.initPaymentDatabase(data);
});
final getCartStreamProvider =
    StreamProvider.family.autoDispose((ref, String data) {
  final productController = ref.watch(productAPIProvider);
  return productController.getCartStream(data);
});

class CountryController extends StateNotifier<bool> {
  final ProductAPI _productApi;
  CountryController({
    required ProductAPI productApi,
  })  : _productApi = productApi,
        super(false);
  Future<List<FeedModel>> getProducts() async {
    final getProducts = await _productApi.getProduct();
    return getProducts.map((data) => FeedModel.fromJson(data.data)).toList();
  }

  Future<List<ChildrenCategoryModel>> getChildrenCategory() async {
    final getChildrenCategory = await _productApi.getKidsCategory();
    return getChildrenCategory
        .map((data) => ChildrenCategoryModel.fromMap(data.data))
        .toList();
  }

  Future<List<ElectronicsCategoryModel>> getElectronicsCategory() async {
    final getElectronicsCategory = await _productApi.getElectronicsCategory();
    return getElectronicsCategory
        .map((data) => ElectronicsCategoryModel.fromMap(data.data))
        .toList();
  }

  Future<List<FashionCategoryModel>> getFashionCategory() async {
    final getFashionCategory = await _productApi.getFashionCategory();
    return getFashionCategory
        .map((data) => FashionCategoryModel.fromMap(data.data))
        .toList();
  }

  Future<List<GroceryCategoryModel>> getGroceryCategory() async {
    final getGroceryCategory = await _productApi.getGroceryCategory();
    return getGroceryCategory
        .map((data) => GroceryCategoryModel.fromMap(data.data))
        .toList();
  }

  Future<List<FarmCategoryModel>> getFarmCategory() async {
    final getFarmCategory = await _productApi.getFarmCategory();
    return getFarmCategory
        .map((data) => FarmCategoryModel.fromMap(data.data))
        .toList();
  }

  Future<List<HousingCategoryModel>> getHousingCategory() async {
    final getHousingCategory = await _productApi.getHousingCategory();
    return getHousingCategory
        .map((data) => HousingCategoryModel.fromMap(data.data))
        .toList();
  }

  Future<List<CarsCategoryModel>> getCarsCategory() async {
    final getCarsCategory = await _productApi.getCarsCategory();
    return getCarsCategory
        .map((data) => CarsCategoryModel.fromMap(data.data))
        .toList();
  }

  Future<List<BooksCategoryModel>> getBooksCategory() async {
    final getBooksCategory = await _productApi.getBooksCategory();
    return getBooksCategory
        .map((data) => BooksCategoryModel.fromMap(data.data))
        .toList();
  }

  Future<List<SectionModel>> getSection() async {
    final getSection = await _productApi.getSection();
    return getSection.map((data) => SectionModel.fromJson(data.data)).toList();
  }

  Future<List<FeedModel>> getProductsCategories(data) async {
    final getProductCategory = await _productApi.getProductCategories(data);
    return getProductCategory
        .map((data) => FeedModel.fromJson(data.data))
        .toList();
  }

  Future<int> getProductRating(data) async {
    final getProductCategory = await _productApi.getProductRating(data);
    return getProductCategory;
    //RatingModel.fromMap(getProductCategory.d);

    // getProductCategory
    //     .map((data) => RatingModel.fromMap(data.data))
    //     ;
  }

  Future<List<CartItemModel>> getProductsInCart(data) async {
    final getProductsInCart = await _productApi.getProductsInCart(data);
    return getProductsInCart
        .map((data) => CartItemModel.fromMap(data.data))
        .toList();
  }

  Future<List<FeedModel>> getGroupOfProductsByVendors(data) async {
    final getProductsByVendors =
        await _productApi.getGroupOfProductsByVendors(data);
    return getProductsByVendors
        .map((data) => FeedModel.fromJson(data.data))
        .toList();
  }

  Future<List<CartItemModel>> getProductsInCartByVendors(data) async {
    final getProductsInCart =
        await _productApi.getProductsInCartByVendors(data);
    return getProductsInCart
        .map((data) => CartItemModel.fromMap(data.data))
        .toList();
  }

  Future<AwsWasabiStorageModel> getDataApiKeywasabiAws() async {
    final getProductsInCart = await _productApi.getDataApiKeywasabiAws();
    return AwsWasabiStorageModel.fromJson(getProductsInCart.data);
  }

  Future<FeedModel> getOneProduct(String productId) async {
    final getProductsInCart = await _productApi.getOneProduct(productId);
    return FeedModel.fromJson(getProductsInCart.data);
  }

  Future<List<OrderViewProduct>> getUserOrder(String data) async {
    final getuserOrders = await _productApi.userOrders(data);
    return getuserOrders
        .map((orders) => OrderViewProduct.fromSnapshot(orders.data))
        .toList();
  }

  void initializePayment(double totalPrice, String? userId, String? sellerId,
      String? currency, BuildContext context, String? currentUserEmail) async {
    state = true;
    final res = await _productApi.initializePayment(
        totalPrice, userId, sellerId, currency, currentUserEmail);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      cprint('initialize');
      // _notificationController.createNotification(
      //   text: '${user.name} liked your tweet!',
      //   postId: tweet.id,
      //   notificationType: NotificationType.like,
      //   uid: tweet.uid,
      // );
    });
  }

  void placeNewOrder(
      Map orderDetails, String? userId, String? sellerId, WidgetRef ref,
      {List<CartItemModel>? product,
      String? refs,
      required BuildContext context}) async {
    FToast().init(context);
    state = true;
    final res = await _productApi.placeNewOrder(orderDetails, userId, sellerId,
        product: product, ref: refs);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      cprint('order placed');
      Navigator.pop(context);
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: 'Your order has been placed',
        // toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP_LEFT,
        timeInSecForIosWeb: 8,
        backgroundColor: Colors.cyan,
      );
      ref.read(numberProvider.notifier).state = 4;
      //   Navigator.pop(context);
      // _notificationController.createNotification(
      //   text: '${user.name} liked your tweet!',
      //   postId: tweet.id,
      //   notificationType: NotificationType.like,
      //   uid: tweet.uid,
      // );
    });
  }

  listShippingAddress() async {
    final getlistShippingAddress = await _productApi.listShippingAddress();
    return getlistShippingAddress;
  }

  initPaymentDatabase(String userId) async {
    final getinitPaymentDatabase =
        await _productApi.initPaymentDatabase(userId);
    return (getinitPaymentDatabase.data);
  }

  newShippingAddress(Map address, String? userId, BuildContext context) async {
    state = true;
    final res = await _productApi.newShippingAddress(address, userId);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      cprint('Address Added');
      // _notificationController.createNotification(
      //   text: '${user.name} liked your tweet!',
      //   postId: tweet.id,
      //   notificationType: NotificationType.like,
      //   uid: tweet.uid,
      // );
    });
  }

  addProductReviews(
      String reviewComment,
      int rating,
      String productId,
      String senderName,
      // String _multiChannelName,
      ViewductsUser currentUser,
      BuildContext context) async {
    FToast().init(context);
    String _multiChannelName;

    // List<String> list = [
    //   currentUser.substring(4, 15),
    //   secondUser.substring(4, 15)
    // ];
    // list.sort();
    _multiChannelName =
        '${currentUser.userId!.substring(4, 15)}-${productId.substring(4, 15)}';
    state = true;
    final res = await _productApi.addProductReviews(reviewComment, rating,
        productId, senderName, _multiChannelName, currentUser);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      cprint('review Added');
      FToast().showToast(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
                // width:
                //    Get.width * 0.3,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(0, 11),
                          blurRadius: 11,
                          color: Colors.black.withOpacity(0.06))
                    ],
                    borderRadius: BorderRadius.circular(18),
                    color: CupertinoColors.lightBackgroundGray),
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  'Your Review is been added thanks!',
                  style: TextStyle(
                      color: CupertinoColors.darkBackgroundGray,
                      fontWeight: FontWeight.w900),
                )),
          ),
          gravity: ToastGravity.TOP_RIGHT,
          toastDuration: Duration(seconds: 4));

      // _notificationController.createNotification(
      //   text: '${user.name} liked your tweet!',
      //   postId: tweet.id,
      //   notificationType: NotificationType.like,
      //   uid: tweet.uid,
      // );
    });
  }

  adminUsersOrdersStateUpdate(String? id, String? states, String? orderId,
      String? staffId, BuildContext context) async {
    FToast().init(context);

    state = true;
    final res = await _productApi.adminUsersOrdersStateUpdate(
        id, states, orderId, staffId);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      FToast().showToast(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
                // width:
                //    Get.width * 0.3,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(0, 11),
                          blurRadius: 11,
                          color: Colors.black.withOpacity(0.06))
                    ],
                    borderRadius: BorderRadius.circular(18),
                    color: CupertinoColors.systemBlue),
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  'Orders Confirm',
                  style: TextStyle(
                      color: CupertinoColors.lightBackgroundGray,
                      fontWeight: FontWeight.w900),
                )),
          ),
          gravity: ToastGravity.TOP_RIGHT,
          toastDuration: Duration(seconds: 3));
      // _notificationController.createNotification(
      //   text: '${user.name} liked your tweet!',
      //   postId: tweet.id,
      //   notificationType: NotificationType.like,
      //   uid: tweet.uid,
      // );
    });
  }

  void addProductToCart(
      {FeedModel? product,
      String? commissionUser,
      String? color,
      String? size,
      ViewductsUser? ductUser,
      required BuildContext context,
      String? uniqueId}) async {
    state = true;
    final res = await _productApi.addProductToCart(
        context: context,
        product: product,
        commissionUser: commissionUser,
        color: color,
        size: size,
        ductUser: ductUser,
        uniqueId: uniqueId);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => StatusAlert.show(context,
          duration: const Duration(seconds: 3),
          backgroundColor: CupertinoColors.lightBackgroundGray,
          title: 'Cart',
          subtitle: "${product!.productName} added to your cart",
          configuration:
              const IconConfiguration(icon: CupertinoIcons.cart_badge_plus)),
    );
  }

  decreaseQuantity(CartItemModel item) async {
    if (item.quantity == 1) {
      await _productApi.removeCartItem(item);
    } else {
      // removeCartItem(item);
      item.quantity = (item.quantity! - 1);
      await _productApi.updateProductInCartQuntity({
        'key': item.key,
        'id': item.id,
        'size': item.size,
        'color': item.color,
        'quantity': item.quantity,
        'vendorId': item.vendorId,
        'name': item.name,
        'store': item.store,
        'price': item.price,
        'commissionUser': item.commissionUser,
        'commissionPrice': item.commissionPrice,
        'commissionId': Uuid().v1().toString()
      }, item.key, item.key);
    }
  }

  increaseQuantity(CartItemModel item) async {
    // removeCartItem(item);
    item.quantity = (item.quantity! + 1);
    // logger.i({"quantity": item.quantity});

    await _productApi.updateProductInCartQuntity(
      {
        'key': item.key,
        'id': item.id,
        'size': item.size,
        'color': item.color,
        'quantity': item.quantity,
        'vendorId': item.vendorId,
        'name': item.name,
        'store': item.store,
        'price': item.price,
        'commissionUser': item.commissionUser,
        'commissionPrice': item.commissionPrice,
        'commissionId': Uuid().v1().toString()
      },
      item.key,
      item.key,
    );
  }
}

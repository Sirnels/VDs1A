import 'package:get/get.dart';
import 'dart:async';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/state/appState.dart';
import 'package:viewducts/state/stateController.dart';

class ProductController extends AppState {
  static ProductController instance = Get.find();
  RxList<ProductModel> products = RxList<ProductModel>([]);
  Rx<ViewProduct> productViewModel = ViewProduct(products: []).obs;
  RxList<ViewProduct> productList = <ViewProduct>[].obs;
  String collection = "product";
  RxList<FeedModel>? productItem = RxList<FeedModel>([]);

  List<FeedModel>? productListing(
      ViewductsUser? userModel,
      String? product,
      String? section,
      String? category,
      String? location,
      String? country,
      String? culture) {
    if (userModel == null) {
      return null;
    }

    List<FeedModel>? list;

    if (productItem != null && productItem!.isNotEmpty) {
      list = productItem!.where((x) {
        /// If Duct is a comment then no need to add it in duct list
        if (x.parentkey != null &&
            x.childVductkey == null &&
            x.user!.userId != userModel.userId) {
          return false;
        }

        /// Only include Ducted Products
        if (x.caption == product &&
                (x.productCategory == category &&
                    x.section == section &&
                    x.productLocation == country)
            //     ||

            ) {
          return true;
        } else {
          return false;
        }
      }).toList();
      if (list.isEmpty) {
        list = null;
      }
    }
    return list;
  }

  Stream<List<ProductModel>> getAllProducts(
          {String? uid, String? section, String? category}) =>
      vDatabase.collection(collection).snapshots().map((query) =>
          query.docs.map((item) => ProductModel.fromMap(item.data())).toList());
  Stream<ViewProduct> getProduct(
          {String? uid, String? section, String? category}) =>
      vDatabase
          .collection(collection)
          .doc(uid)
          .collection('$section')
          .doc(category)
          .snapshots()
          .map((snapshot) => ViewProduct.fromSnapshot(snapshot.data()));

  Future<ViewProduct> getProductViews(
          {String? uid, String? section, String? category}) =>
      vDatabase
          .collection(collection)
          .doc(authState.userId)
          .collection('$section')
          .doc(category)
          .get()
          .then((snapshot) {
        return ViewProduct.fromSnapshot(snapshot.data()!['products']);
      });
  getProductFromDatabase() {
    try {
      // isBusy = true;
      productItem = null;
      update();
      var data = vDatabase.collection('product').limit(15);

      data.snapshots().listen((snapshot) {
        productItem = RxList<FeedModel>.empty();
        if (snapshot.docs.isNotEmpty) {
          var map = snapshot.docs;

          for (var value in map) {
            var model = (FeedModel.fromJson(value.data())).obs;
            model.value.key = value.id;

            if (model.value.isValidDuct) {
              productItem!.add(model.value);
            }
          }

          /// Sort Duct by time
          /// It helps to display newest Duct first.
          productItem!.sort((x, y) => DateTime.parse(x.createdAt!)
              .compareTo(DateTime.parse(y.createdAt!)));
        } else {
          productItem = null;
        }
        // isBusy = false;
        update();
      });
    } catch (error) {
      // isBusy = false;
      cprint(error, errorIn: 'getDataFromDatabase');
    }
  }
}

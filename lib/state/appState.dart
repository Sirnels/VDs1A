// ignore_for_file: file_names

import 'package:viewducts/model/product.dart';
import 'package:viewducts/model/repo.dart';
import 'package:get/get.dart';

class AppState extends GetxController {
  static AppState instance = Get.find<AppState>();
  RxDouble totalCartPrice = 0.0.obs;
  RxBool isLoginWidgetDisplayed = true.obs;

  changeDIsplayedAuthWidget() {
    isLoginWidgetDisplayed.value = !isLoginWidgetDisplayed.value;
  }
  // @override
  // void onReady() {
  //   super.onReady();
  //   // user = Rx<User>(_firebaseAuth.currentUser);
  //   // user.bindStream(_firebaseAuth.userChanges());
  //    ever(authState.userModel setpageIndex);
  // }

  // All the available products.
  List<Product>? _availableProducts;

  // The currently selected category of products.
  Category _selectedCategory = Category.all;

  // The IDs and quantities of products currently in the cart.
  final Map<int, int> _productsInCart = <int, int>{};

  Map<int, int> get productsInCart => Map<int, int>.from(_productsInCart);

  // Total number of items in the cart.
  int get totalCartQuantity =>
      _productsInCart.values.fold(0, (int v, int e) => v + e);

  Category get selectedCategory => _selectedCategory;

  // // Totaled prices of the items in the cart.
  // double get subtotalCost {
  //   return _productsInCart.keys
  //       .map((int id) => _availableProducts[id].price * _productsInCart[id])
  //       .fold(0.0, (double sum, int e) => sum + e);
  // }

  // // Total shipping cost for the items in the cart.
  // double get shippingCost {
  //   return _shippingCostPerItem *
  //       _productsInCart.values.fold(0.0, (num sum, int e) => sum + e);
  // }

  // // Sales tax for the items in the cart
  // double get tax => subtotalCost * _salesTaxRate;

  // // Total cost to order everything in the cart.
  // double get totalCost => subtotalCost + shippingCost + tax;

  // Returns a copy of the list of available products, filtered by category.
  List<Product> getProducts() {
    if (_availableProducts == null) {
      return <Product>[];
    }

    if (_selectedCategory == Category.all) {
      return List<Product>.from(_availableProducts!);
    } else {
      return _availableProducts!
          .where((Product p) => p.category == _selectedCategory)
          .toList();
    }
  }

  // Adds a product to the cart.
  void addProductToCart(int productId) {
    if (!_productsInCart.containsKey(productId)) {
      _productsInCart[productId] = 1;
    } else {
      //  _productsInCart[productId]++;
    }

    // notifyListeners();
  }

  // Removes an item from the cart.
  void removeItemFromCart(int productId) {
    if (_productsInCart.containsKey(productId)) {
      if (_productsInCart[productId] == 1) {
        _productsInCart.remove(productId);
      } else {
        // _productsInCart[productId]--;
      }
    }

    // notifyListeners();
  }

  // Returns the Product instance matching the provided id.
  Product getProductById(int id) {
    return _availableProducts!
        .firstWhere((Product product) => product.id == id);
  }

  // Removes everything from the cart.
  void clearCart() {
    _productsInCart.clear();
    // notifyListeners();
  }

  // Loads the list of available products from the repo.
  void loadProducts() {
    _availableProducts = ProductsRepository.loadProducts(Category.all);
    // notifyListeners();
  }

  void setCategory(Category newCategory) {
    _selectedCategory = newCategory;
    // notifyListeners();
  }

  List<Product> search(String searchProducts) {
    return getProducts().where((product) {
      return product.name.toLowerCase().contains(searchProducts.toLowerCase());
    }).toList();
  }

  bool? _isBusy;
  bool? get isbusy => _isBusy;
  set loading(bool value) {
    _isBusy = value;
    update();
    // notifyListeners();
  }

  var _pageIndex = 0.obs;
  int get pageIndex {
    return _pageIndex.value;
  }

  set setpageIndex(var index) {
    _pageIndex = index;
    update();
    // notifyListeners();
  }

  // @override
  // String toString() {
  //   return 'AppState(totalCost: $totalCost)';
  // }
}

// class AppStates extends GetxController {
//   bool _isBusy;
//   bool get isbusy => _isBusy;
//   set loading(bool value) {
//     _isBusy = value;
//     listeners;
//   }

//   var _pageIndex = 0.obs;
//   RxInt get pageIndex {
//     return _pageIndex;
//   }

//   set setpageIndex(RxInt index) {
//     _pageIndex = index;
//     listeners;
//   }
// }

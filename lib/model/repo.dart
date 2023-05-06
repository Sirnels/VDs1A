import 'package:viewducts/model/product.dart';

class ProductsRepository {
  static List<Product> loadProducts(Category category) {
    List<Product> allProducts = <Product>[
      Product(
        category: Category.accessories,
        id: 2,
        productQuantity: 10,
        isFeatured: false,
        isSelected: false,
        isliked: false,
        image: 'assets/shooe_tilt_1.png',
        name: 'Whitney belt',
        price: 35,
      ),
      Product(
        category: Category.accessories,
        id: 3,
        productQuantity: 8,
        isFeatured: true,
        isliked: false,
        name: 'Nike Air Max 200',
        image: 'assets/jacket.png',
        price: 98,
      ),
      Product(
        category: Category.accessories,
        id: 4,
        productQuantity: 64,
        isFeatured: false,
        isliked: false,
        name: 'Strut earrings',
        image: 'assets/watch.png',
        price: 34,
      ),
      Product(
        category: Category.home,
        id: 16,
        productQuantity: 10,
        isFeatured: true,
        isliked: false,
        name: 'Succulent planters',
        image: 'assets/small_tilt_shoe_2.png',
        price: 16,
      ),
      Product(
        category: Category.home,
        id: 17,
        productQuantity: 21,
        isFeatured: false,
        isliked: false,
        name: 'Nike Air Max 97',
        image: 'assets/small_tilt_shoe_1.png',
        price: 175,
      ),
      Product(
        category: Category.home,
        id: 18,
        productQuantity: 5,
        isFeatured: true,
        isliked: false,
        image: 'assets/show_1.png',
        name: 'Kitchen quattro',
        price: 129,
      ),
      Product(
        category: Category.clothing,
        image: 'assets/show_1.png',
        id: 34,
        productQuantity: 9,
        isFeatured: false,
        isliked: false,
        name: 'Shoulder rolls tee',
        price: 27,
      ),
      Product(
        category: Category.clothing,
        id: 35,
        productQuantity: 14,
        isFeatured: false,
        isliked: false,
        name: 'Grey slouch tank',
        image: 'assets/shoe_tilt_2.png',
        price: 24,
      ),
      Product(
        category: Category.clothing,
        id: 36,
        productQuantity: 11,
        isFeatured: false,
        isliked: false,
        name: 'Sunshirt dress',
        image: 'assets/shooe_tilt_1.png',
        price: 58,
      ),
      Product(
        category: Category.clothing,
        id: 37,
        isFeatured: true,
        productQuantity: 23,
        isliked: false,
        name: 'Fine lines tee',
        image: 'assets/shooe_tilt_1.png',
        price: 58,
      ),
    ];
    if (category == Category.all) {
      return allProducts;
    } else {
      return allProducts.where((Product p) => p.category == category).toList();
    }
  }

  static List<ChildrenCategory> childrenCategory = [
    ChildrenCategory(),
    ChildrenCategory(
        id: 1,
        name: "Sneakers",
        image: 'assets/shoe_thumb_2.png',
        isSelected: true),
    ChildrenCategory(id: 2, name: "Jacket", image: 'assets/jacket.png'),
    ChildrenCategory(id: 3, name: "Watch", image: 'assets/watch.png'),
    ChildrenCategory(id: 4, name: "Watch", image: 'assets/watch.png'),
  ];
}

class ChildrenOption {
  static List<ChildrenCategory> productList = [
    ChildrenCategory(
        id: 1,
        name: 'Nike Air Max 200',
        price: 240.00,
        isSelected: true,
        isliked: false,
        image: 'assets/shooe_tilt_1.png',
        category: "Trending Now"),
    ChildrenCategory(
        id: 2,
        name: 'Nike Air Max 97',
        price: 300.00,
        isliked: false,
        image: 'assets/small_tilt_shoe_2.png',
        category: "Trending Now"),
  ];
  static List<ChildrenCategory> childrenCategory = [
    ChildrenCategory(),
    ChildrenCategory(
        id: 1,
        name: "Sneakers",
        image: 'assets/shoe_thumb_2.png',
        isSelected: true),
    ChildrenCategory(id: 2, name: "Jacket", image: 'assets/jacket.png'),
    ChildrenCategory(id: 3, name: "Watch", image: 'assets/watch.png'),
    ChildrenCategory(id: 4, name: "Watch", image: 'assets/watch.png'),
  ];
}

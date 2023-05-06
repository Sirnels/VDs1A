enum Category {
  all,
  accessories,
  clothing,
  home,
}

class Product {
  Product({
    this.isSelected = false,
    this.productQuantity,
    required this.isliked,
    required this.category,
    required this.id,
    required this.isFeatured,
    required this.name,
    required this.price,
    required this.image,
  });

  final Category category;
  final int id;
  final bool isFeatured;
  final String name;
  final int price;
  bool isliked;
  bool isSelected;
  final String image;
  final int? productQuantity;
  String get assetName => '$id-0.jpg';
  String get assetPackage => 'shrine_images';

  @override
  String toString() => '$name (id=$id)';
}

class ChildrenCategory {
  final int? id;
  final String? slug;
  final int? taxonId;
  final String? title;
  final String? name;
  final String? displayPrice;
  final String? costPrice;
  final double? price;
  final String? currencySymbol;
  final String? image;
  final double? avgRating;
  final String? reviewsCount;
  final int? totalOnHand;
  final String? category;
  bool? isliked;
  bool isSelected;
  final bool? isOrderable;
  final bool? isBackOrderable;
  final bool? hasVariants;
  // final List<Products> variants;
  // final List<OptionValue> optionValues;
  // final List<OptionType> optionTypes;
  String? description;
  final int? reviewProductId;
  final bool? favoritedByUser;

  ChildrenCategory(
      {this.taxonId,
      this.isliked,
      this.isSelected = false,
      this.category,
      this.id,
      this.slug,
      this.title,
      this.name,
      this.displayPrice,
      this.costPrice,
      this.price,
      this.image,
      this.avgRating,
      this.reviewsCount,
      this.totalOnHand,
      this.isOrderable,
      this.isBackOrderable,
      // this.variants,
      this.hasVariants,
      this.description,
      // this.optionValues,
      this.reviewProductId,
      // this.optionTypes,
      this.currencySymbol,
      this.favoritedByUser});
}

class ElectronicsCategory {
  final String? name;
  final String? image;
  final int? id;
  bool? isChecked;
  final int? parentId;
  bool isSelected;

  ElectronicsCategory(
      {this.name,
      this.isSelected = false,
      this.image,
      this.id,
      this.parentId,
      this.isChecked});
}

class GroceryCategory {
  final String? name;
  final String? image;
  final int? id;
  bool? isChecked;
  final int? parentId;
  bool isSelected;

  GroceryCategory(
      {this.name,
      this.isSelected = false,
      this.image,
      this.id,
      this.parentId,
      this.isChecked});
}

class ProductQuantity {
  int quantity;

  ProductQuantity(this.quantity);

  void changeQuantity(int newQuantity) {
    quantity = newQuantity;
  }
}

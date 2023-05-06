import 'package:appwrite/models.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:viewducts/common/common.dart';
import 'package:viewducts/features/products/product_controller.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/widgets/categoryManu.dart';
import 'package:viewducts/widgets/frosted.dart';

Widget fashionCategoryWidget(
    WidgetRef ref, ViewductsUser user, bool isWelcomePage) {
  return frostedYellow(
    SizedBox(
        // margin: EdgeInsets.symmetric(vertical: 10),
        width: Get.width * 0.83,
        height: Get.width * 0.7,
        child: ref.watch(getFashionCategoryProvider).when(
            data: (fashion) {
              return GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 4 / 3,
                    mainAxisSpacing: 30,
                    crossAxisSpacing: 20),
                padding: const EdgeInsets.only(left: 20),
                scrollDirection: Axis.horizontal,
                children: fashion
                    .map(
                      (product) => FashionMenu(
                        user: user,
                        isWelcomePage: isWelcomePage,
                        products: product,
                        onSelected: (model) {},
                      ),
                    )
                    .toList(),
              );
            },
            error: (error, stackTrace) => ErrorText(
                  error: error.toString(),
                ),
            loading: () => const LoaderAll())),
  );
}

Widget carsCategoryWidget(
    WidgetRef ref, ViewductsUser user, bool isWelcomePage) {
  return frostedYellow(
    SizedBox(
        // margin: EdgeInsets.symmetric(vertical: 10),
        width: Get.width * 0.83,
        height: Get.width * 0.7,
        child: ref.watch(getCarsProvider).when(
            data: (cars) {
              return GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 4 / 3,
                    mainAxisSpacing: 30,
                    crossAxisSpacing: 20),
                padding: const EdgeInsets.only(left: 20),
                scrollDirection: Axis.horizontal,
                children: cars
                    .map(
                      (product) => CarsMenu(
                        user: user,
                        isWelcomePage: isWelcomePage,
                        products: product,
                        onSelected: (model) {
                          //  setState(() {
                          // ProductsRepository.loadProducts(Category.all)
                          //     .forEach((item) {
                          //   item.isSelected = false;
                          // });
                          // model.isSelected = true;
                          // });
                        },
                      ),
                    )
                    .toList(),
              );
            },
            error: (error, stackTrace) => ErrorText(
                  error: error.toString(),
                ),
            loading: () => const LoaderAll())),
  );
}

Widget housingCategoryWidget(
    WidgetRef ref, ViewductsUser user, bool isWelcomePage) {
  return frostedYellow(
    SizedBox(
        // margin: EdgeInsets.symmetric(vertical: 10),
        width: Get.width * 0.83,
        height: Get.width * 0.7,
        child: ref.watch(getHousingProvider).when(
            data: (housing) {
              return GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 4 / 3,
                    mainAxisSpacing: 30,
                    crossAxisSpacing: 20),
                padding: const EdgeInsets.only(left: 20),
                scrollDirection: Axis.horizontal,
                children: housing
                    .map(
                      (product) => HousingMenu(
                        user: user,
                        isWelcomePage: isWelcomePage,
                        products: product,
                        onSelected: (model) {
                          // setState(() {
                          // ProductsRepository.loadProducts(Category.all)
                          //     .forEach((item) {
                          //   item.isSelected = false;
                          // });
                          // model.isSelected = true;
                          //});
                        },
                      ),
                    )
                    .toList(),
              );
            },
            error: (error, stackTrace) => ErrorText(
                  error: error.toString(),
                ),
            loading: () => const LoaderAll())),
  );
}

Widget booksCategoryWidget(
    WidgetRef ref, ViewductsUser user, bool isWelcomePage) {
  return frostedYellow(
    SizedBox(
        // margin: EdgeInsets.symmetric(vertical: 10),
        width: Get.width * 0.83,
        height: Get.width * 0.7,
        child: ref.watch(getBookstProvider).when(
            data: (books) {
              return GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 4 / 3,
                    mainAxisSpacing: 30,
                    crossAxisSpacing: 20),
                padding: const EdgeInsets.only(left: 20),
                scrollDirection: Axis.horizontal,
                children: books
                    .map(
                      (product) => BooksMenu(
                        user: user,
                        isWelcomePage: isWelcomePage,
                        products: product,
                        onSelected: (model) {
                          // setState(() {
                          // ProductsRepository.loadProducts(Category.all)
                          //     .forEach((item) {
                          //   item.isSelected = false;
                          // });
                          // model.isSelected = true;
                          //  });
                        },
                      ),
                    )
                    .toList(),
              );
            },
            error: (error, stackTrace) => ErrorText(
                  error: error.toString(),
                ),
            loading: () => const LoaderAll())),
  );
}

Widget farmsCategoryWidget(
    WidgetRef ref, ViewductsUser user, bool isWelcomePage) {
  return frostedYellow(
    SizedBox(
        // margin: EdgeInsets.symmetric(vertical: 10),
        width: Get.width * 0.83,
        height: Get.width * 0.7,
        child: ref.watch(getFarmsProvider).when(
            data: (farms) {
              return GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 4 / 3,
                    mainAxisSpacing: 30,
                    crossAxisSpacing: 20),
                padding: const EdgeInsets.only(left: 20),
                scrollDirection: Axis.horizontal,
                children: farms
                    .map(
                      (product) => FarmsMenu(
                        user: user,
                        isWelcomePage: isWelcomePage,
                        products: product,
                        onSelected: (model) {
                          // setState(() {
                          // ProductsRepository.loadProducts(Category.all)
                          //     .forEach((item) {
                          //   item.isSelected = false;
                          // });
                          // model.isSelected = true;
                          // });
                        },
                      ),
                    )
                    .toList(),
              );
            },
            error: (error, stackTrace) => ErrorText(
                  error: error.toString(),
                ),
            loading: () => const LoaderAll())),
  );
}

Widget groceyCategoryWidget(
    WidgetRef ref, ViewductsUser user, bool isWelcomePage) {
  return frostedYellow(
    SizedBox(
        // margin: EdgeInsets.symmetric(vertical: 10),
        width: Get.width * 0.83,
        height: Get.width * 0.7,
        child: ref.watch(getGroceryCategoryProvider).when(
            data: (grocery) {
              return GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 4 / 3,
                    mainAxisSpacing: 30,
                    crossAxisSpacing: 20),
                padding: const EdgeInsets.only(left: 20),
                scrollDirection: Axis.horizontal,
                children: grocery
                    .map(
                      (product) => GroceryMenu(
                        user: user,
                        isWelcomePage: isWelcomePage,
                        products: product,
                        onSelected: (model) {
                          // setState(() {
                          //   ProductsRepository.loadProducts(Category.all)
                          //       .forEach((item) {
                          //     item.isSelected = false;
                          //   });
                          //   //   model.isSelected = true;
                          // });
                        },
                      ),
                    )
                    .toList(),
              );
            },
            error: (error, stackTrace) => ErrorText(
                  error: error.toString(),
                ),
            loading: () => const LoaderAll())),
  );
}

Widget electronicsCategoryWidget(
    WidgetRef ref, ViewductsUser user, bool isWelcomePage) {
  return frostedYellow(
    SizedBox(
        // margin: EdgeInsets.symmetric(vertical: 10),
        width: Get.width * 0.83,
        height: Get.width * 0.7,
        child: ref.watch(getElectronicsCategoryProvider).when(
            data: (electronics) {
              return GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 4 / 3,
                    mainAxisSpacing: 30,
                    crossAxisSpacing: 20),
                padding: const EdgeInsets.only(left: 20),
                scrollDirection: Axis.horizontal,
                children: electronics
                    .map(
                      (product) => ElectronicsMenu(
                        user: user,
                        isWelcomePage: isWelcomePage,
                        products: product,
                        onSelected: (model) {
                          // ProductsRepository.loadProducts(Category.all)
                          //     .forEach((item) {
                          //   item.isSelected = false;
                          // });
                          // model.isSelected = true;
                        },
                      ),
                    )
                    .toList(),
              );
            },
            error: (error, stackTrace) => ErrorText(
                  error: error.toString(),
                ),
            loading: () => const LoaderAll())),
  );
}

Widget childrenCategoryWidget(
    WidgetRef ref, ViewductsUser user, bool isWelcomePage) {
  return frostedYellow(
    SizedBox(
        // margin: EdgeInsets.symmetric(vertical: 10),
        width: Get.width * 0.9,
        height: Get.height * 0.7,
        child: ref.watch(getChildernCategoryProvider).when(
            data: (children) {
              return GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 4 / 3,
                    mainAxisSpacing: 30,
                    crossAxisSpacing: 20),
                padding: const EdgeInsets.only(left: 20),
                scrollDirection: Axis.horizontal,
                children: children
                    .map(
                      (product) => ChildrenMenu(
                        products: product,
                        onSelected: (model) {},
                        user: user,
                        isWelcomePage: isWelcomePage,
                      ),
                    )
                    .toList(),
              );
            },
            error: (error, stackTrace) => ErrorText(
                  error: error.toString(),
                ),
            loading: () => const LoaderAll())),
  );
}

List<Widget> getOption(
    RxInt index, WidgetRef ref, ViewductsUser user, bool isWelcomePage) {
  return [
    [childrenCategoryWidget(ref, user, isWelcomePage)],
    [electronicsCategoryWidget(ref, user, isWelcomePage)],
    [groceyCategoryWidget(ref, user, isWelcomePage)],
    [fashionCategoryWidget(ref, user, isWelcomePage)],
    [housingCategoryWidget(ref, user, isWelcomePage)],
    [farmsCategoryWidget(ref, user, isWelcomePage)],
    [carsCategoryWidget(ref, user, isWelcomePage)],
    [booksCategoryWidget(ref, user, isWelcomePage)]
  ][index.value];
}

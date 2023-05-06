import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:status_alert/status_alert.dart';
import 'package:uuid/uuid.dart';
import 'package:viewducts/constants/constants.dart';
import 'package:viewducts/core/core.dart';
import 'package:viewducts/core/providers.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/chatModel.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';

final productAPIProvider = Provider((ref) {
  return ProductAPI(
    db: ref.watch(appwriteDatabaseProvider),
    realtime: ref.watch(appwriteRealtimeProvider),
  );
});

abstract class IProductAPI {
  Future<List<Document>> getProduct();
  Future<Document> getOneProduct(String productId);
  Future<List<Document>> getProductCategories(ProductCategoryInput data);
  Future<List<Document>> getKidsCategory();
  Future<List<Document>> getElectronicsCategory();
  Future<List<Document>> getGroceryCategory();
  Future<List<Document>> getFashionCategory();
  Future<List<Document>> getHousingCategory();
  Future<List<Document>> getFarmCategory();
  Future<List<Document>> getBooksCategory();
  Future<List<Document>> getCarsCategory();
  Future<List<Document>> getSection();
  Future<int> getProductRating(RatingModel rating);
  Future<List<Document>> getProductsInCart(String userId);
  Future<List<Document>> getGroupOfProductsByVendors(String vendorId);
  Future<List<Document>> getProductsInCartByVendors(String vendorsId);
  Future<Document> getDataApiKeywasabiAws();
  Future<List<Document>> userOrders(String userId);

  Future<Document> initPaymentDatabase(String userId);
  Future<List<Document>> listShippingAddress();
  FutureEitherVoid addProductToCart(
      {required FeedModel? product,
      required String? commissionUser,
      required String? color,
      required String? size,
      required BuildContext context,
      required ViewductsUser? ductUser,
      required String? uniqueId});
  Stream<RealtimeMessage> getCartStream(String userId);
  FutureEitherVoid updateProductInCartQuntity(
      Map<dynamic, dynamic> data, String? sellerId, String? commissionUser);
  FutureEitherVoid adminUsersOrdersStateUpdate(
      String? id, String? state, String? orderId, String? staffId);
  FutureEitherVoid removeCartItem(CartItemModel cartItem);
  FutureEitherVoid addProductReviews(
      String reviewComment,
      int rating,
      String productId,
      String senderName,
      String _multiChannelName,
      ViewductsUser currentUser);
  // addProductReviews
  FutureEitherVoid placeNewOrder(
      Map orderDetails, String? userId, String? sellerId,
      {RxList<CartItemModel>? product, String? ref});
  FutureEitherVoid newShippingAddress(Map address, String? shippingAddress);
  FutureEitherVoid initializePayment(double totalPrice, String? userId,
      String? sellerId, String? currency, String? currentUserEmail);
}

class ProductAPI implements IProductAPI {
  final Databases _db;
  final Realtime _realtime;
  ProductAPI({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;

  @override
  Future<List<Document>> getProduct() async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.procold,
      queries: [
        //  Query.orderDesc('createdAt'),
      ],
    );
    return documents.documents;
  }

  @override
  Future<List<Document>> getBooksCategory() async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.booksCollection,
      queries: [
        //  Query.orderDesc('createdAt'),
      ],
    );
    return documents.documents;
  }

  @override
  Future<List<Document>> getElectronicsCategory() async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.electronicsCollection,
      queries: [
        //  Query.orderDesc('createdAt'),
      ],
    );
    return documents.documents;
  }

  @override
  Future<List<Document>> getFarmCategory() async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.farmCollection,
      queries: [
        //  Query.orderDesc('createdAt'),
      ],
    );
    return documents.documents;
  }

  @override
  Future<List<Document>> getFashionCategory() async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.fashionCollection,
      queries: [
        //  Query.orderDesc('createdAt'),
      ],
    );
    return documents.documents;
  }

  @override
  Future<List<Document>> getGroceryCategory() async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.groceryCollection,
      queries: [
        //  Query.orderDesc('createdAt'),
      ],
    );
    return documents.documents;
  }

  @override
  Future<List<Document>> getHousingCategory() async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.housingCollection,
      queries: [
        //  Query.orderDesc('createdAt'),
      ],
    );
    return documents.documents;
  }

  @override
  Future<List<Document>> getKidsCategory() async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.childrenCollection,
      queries: [
        //  Query.orderDesc('createdAt'),
      ],
    );
    return documents.documents;
  }

  @override
  Future<List<Document>> getSection() async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.sectionCollection,
      queries: [
        //  Query.orderDesc('createdAt'),
      ],
    );
    return documents.documents;
  }

  @override
  Future<List<Document>> getCarsCategory() async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.carsCollection,
      queries: [
        //  Query.orderDesc('createdAt'),
      ],
    );
    return documents.documents;
  }

  @override
  Future<List<Document>> getProductCategories(ProductCategoryInput data) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.procold,
      queries: [
        //  Query.orderDesc('createdAt'),
        Query.equal('section', data.section),
        Query.equal('productCategory', data.category),
        Query.equal('productLocation', data.country),

        //Query.limit(10),
      ],
    );
    return documents.documents;
  }

  @override
  Future<int> getProductRating(RatingModel rating) async {
    final finalRatingValue = rating.ratingValue / rating.productReveiwLength;

    return await finalRatingValue.toInt();
  }

  @override
  Future<List<Document>> getProductsInCart(String userId) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.shoppingCartCollection,
      queries: [
        //  Query.orderDesc('createdAt'),
      ],
    );
    return documents.documents;
  }

  @override
  Future<List<Document>> getProductsInCartByVendors(String vendorsId) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.shoppingCartCollection,
      queries: [Query.equal('vendorId', vendorsId)],
    );
    return documents.documents;
  }

  @override
  Future<List<Document>> getGroupOfProductsByVendors(String vendorId) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.procold,
      queries: [Query.equal('userId', vendorId)],
    );
    return documents.documents;
  }

  @override
  Future<Document> getDataApiKeywasabiAws() async {
    final documents = await _db.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.profileUserColl,
      documentId: 'wasabiAwas123',
    );
    return documents;
  }

  @override
  Future<List<Document>> userOrders(String userId) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.userOrdersCollection,
      queries: [
        Query.orderDesc('placedDate'),
      ],
    );
    return documents.documents;
  }

  @override
  FutureEitherVoid addProductToCart(
      {required FeedModel? product,
      required String? commissionUser,
      required String? color,
      required String? size,
      required BuildContext context,
      required ViewductsUser? ductUser,
      required String? uniqueId}) async {
    try {
      // _db
      //     .listDocuments(
      //   databaseId: AppwriteConstants.databaseId,
      //   collectionId: AppwriteConstants.shoppingCartCollection,
      // )
      //     .then((data) async {
      //   if (data.documents.isEmpty) {
      var commissionId = Uuid().v1();

      await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.shoppingCartCollection,
        documentId: uniqueId.toString(),
        data: {
          'key': uniqueId.toString(),
          'id': uniqueId.toString(),
          'productId': product!.key,
          'size': size.toString(),
          'color': color.toString(),
          'quantity': 1,
          'commissionId': commissionId,
          'vendorId': product.userId,
          'name': product.productName,
          'store': product.store,
          'price': product.price,
          'commissionUser': commissionUser,
          'commissionPrice': product.commissionPrice.toString()
        },
      );
      //   } else {
      //     StatusAlert.show(context,
      //         duration: const Duration(seconds: 2),
      //         backgroundColor: CupertinoColors.systemRed,
      //         title: 'Cart',
      //         subtitle: "${product!.productName} already added to your cart",
      //         configuration: const IconConfiguration(
      //             icon: CupertinoIcons.cart_badge_plus));
      //   }
      // });

      return right(null);
    } on AppwriteException catch (e, stackTrace) {
      return left(
        Failure(e.message ?? 'Some unexpected error occurred', stackTrace),
      );
    } catch (e, stackTrace) {
      return left(
        Failure(e.toString(), stackTrace),
      );
    }
  }

  @override
  Stream<RealtimeMessage> getCartStream(String userId) {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.shoppingCartCollection}.documents'
    ]).stream;
  }

  @override
  Future<Document> getOneProduct(String productId) async {
    final documents = await _db.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.procold,
      documentId: productId,
    );
    return documents;
  }

  @override
  FutureEitherVoid updateProductInCartQuntity(
      Map data, String? sellerId, String? commissionUser) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.shoppingCartCollection,
        documentId: sellerId.toString(),
        data: {
          //  'following': user.following,
        },
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEitherVoid removeCartItem(CartItemModel cartItem) async {
    try {
      await _db.deleteDocument(
        databaseId: databaseId,
        collectionId: AppwriteConstants.shoppingCartCollection,
        documentId: cartItem.key.toString(),
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEitherVoid initializePayment(
      double totalPrice,
      String? userId,
      String? sellerId,
      //String? initialize,
      String? currency,
      String? currentUserEmail) async {
    try {
      await _db
          .listDocuments(
        databaseId: databaseId,
        collectionId: initPayment,
      )
          .then((data) async {
        if (data.documents.isNotEmpty) {
          await _db.updateDocument(
            databaseId: databaseId,
            collectionId: AppwriteConstants.initPayment,
            documentId: '$userId',
            data: {'totalPrice': totalPrice.toStringAsFixed(0)},
          );
        } else {
          await _db.createDocument(
            databaseId: databaseId,
            collectionId: AppwriteConstants.initPayment,
            documentId: '$userId',
            data: {'totalPrice': totalPrice},
          );
        }
      });
      await _db
          .listDocuments(
        databaseId: databaseId,
        collectionId: AppwriteConstants.initPayment,
      )
          .then((data) async {
        if (data.documents.isNotEmpty) {
          await _db.updateDocument(
            databaseId: databaseId,
            collectionId: AppwriteConstants.initPayment,
            documentId: '$userId',
            data: {
              'initialize': true,
              'userId': userId,
              'custId': 'New',
              'email': currentUserEmail.toString(),
              "cartType": "cart",
              "currency": currency,
              "authorization": ""
              // 'initData': '$id'
            },
          );
        } else {
          await _db.createDocument(
            databaseId: databaseId,
            collectionId: AppwriteConstants.initPayment,
            documentId: '$userId',
            data: {
              'initialize': true,
              'userId': userId,
              'custId': 'New',
              'email': currentUserEmail.toString(),
              "cartType": "cart",
              "currency": currency, "authorization": ""
              //'initData': '$id'
            },
          );
        }
      });
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<List<Document>> listShippingAddress() async {
    final documents = await _db.listDocuments(
      databaseId: databaseId,
      collectionId: AppwriteConstants.shippingAdress,
      //  queries: [query.Query.equal('key', ductId)]
    );

    return documents.documents;
  }

  @override
  FutureEitherVoid newShippingAddress(
      Map address, String? shippingAddress) async {
    try {
      await _db.createDocument(
        databaseId: databaseId,
        collectionId: AppwriteConstants.shippingAdress,
        documentId: 'unique()',
        data: address,
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  Future<Document> initPaymentDatabase(String userId) async {
    final document = await _db.getDocument(
        databaseId: databaseId,
        collectionId: AppwriteConstants.initPayment,
        documentId: userId);

    return document;
  }

  @override
  FutureEitherVoid placeNewOrder(
      Map orderDetails, String? userId, String? sellerId,
      {List<CartItemModel>? product, String? ref}) async {
    try {
      var timeStamp = DateTime.now().toUtc().toString();
      var key = Uuid().v1();

      await _db.createDocument(
          databaseId: databaseId,
          collectionId: AppwriteConstants.orderStateCollection,
          documentId: userId.toString(),
          data: {
            'orderState': 'New',
            'userId': userId.toString(),
            'placedDate': timeStamp,
            'state': orderDetails['city'],
            'country': orderDetails['country'],
          }).onError((error, stackTrace) => _db.updateDocument(
              databaseId: databaseId,
              collectionId: orderStateCollection,
              documentId: userId.toString(),
              data: {
                'orderState': 'New',
                'userId': userId.toString(),
                'placedDate': timeStamp,
                'state': orderDetails['city'],
                'country': orderDetails['country'],
              }));

      await _db.createDocument(
        databaseId: databaseId,
        collectionId: AppwriteConstants.userOrdersCollection,
        documentId: '$key',
        data: {
          'userId': userId.toString(),
          'items': json.encode(product?.map((data) => data.toJson()).toList()),
          'shippingAddress':
              '${orderDetails['name']},${orderDetails['contact']},${orderDetails['address']} ${orderDetails['area']} ${orderDetails['city']},${orderDetails['state']} ${orderDetails['country']}',
          'state': orderDetails['city'],
          'country': orderDetails['country'],
          'shippingMethod': orderDetails['shippingMethod'],
          'totalPrice': double.parse("${orderDetails['price']}"),
          'orderState': 'processing',
          'sellerId': sellerId,
          'key': key,
          //'paymentCard': orderDetails['selectedCard'],
          'placedDate': timeStamp,
          'accessCode': ref
        },
      );
      product?.forEach((data) async {
        await _db.deleteDocument(
            databaseId: databaseId,
            collectionId: AppwriteConstants.shoppingCartCollection,
            documentId: data.key.toString());
        cprint('deleted');
      });
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEitherVoid addProductReviews(
      String reviewComment,
      int rating,
      String productId,
      String senderName,
      String _multiChannelName,
      ViewductsUser currentUser) async {
    try {
      //  _multiChannelName =
      //       '${authState.appUser?.$id.substring(4, 15)}-${productId.substring(4, 15)}';
      //   final database = Databases(
      //     clientConnect(),
      //   );
      _db.listDocuments(
          databaseId: databaseId,
          collectionId: productReviews,
          queries: [
            Query.equal('key', _multiChannelName.toString())
          ]).then((data) async {
        if (data.documents.isNotEmpty) {
          await _db.updateDocument(
            databaseId: databaseId,
            collectionId: productReviews,
            documentId: _multiChannelName.toString(),
            data: {
              'reviewComment': reviewComment,
              'rating': rating,
              'productId': productId,
              'senderName': senderName,
              'userId': currentUser.userId.toString(),
              'key': _multiChannelName.toString()
            },
          );
        } else {
          await _db.createDocument(
            databaseId: databaseId,
            collectionId: productReviews,
            documentId: _multiChannelName.toString(),
            data: {
              'reviewComment': reviewComment,
              'rating': rating,
              'productId': productId,
              'senderName': senderName,
              'userId': currentUser.userId.toString(),
              'key': _multiChannelName.toString()
            },
          );
        }
      });
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEitherVoid adminUsersOrdersStateUpdate(
      String? id, String? state, String? orderId, String? staffId) async {
    try {
      await _db.updateDocument(
        databaseId: databaseId,
        collectionId: userOrdersCollection,
        documentId: '$orderId',
        data: {
          'orderState': '$state',
          'staff': '$staffId',
        },
      );

      return right(null);
    } on AppwriteException catch (e, st) {
      return left(
        Failure(
          e.message ?? 'Some unexpected error occurred',
          st,
        ),
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }
}

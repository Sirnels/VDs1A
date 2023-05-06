import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viewducts/constants/constants.dart';
import 'package:viewducts/core/providers.dart';

final businessStoreAPIProvider = Provider((ref) {
  return BusinessAPI(
    db: ref.watch(appwriteDatabaseProvider),
  );
});

abstract class IBusinessAPI {
  Future<List<Document>> getStaff(String userId);
  Future<List<Document>> getExchangeRate(String currency);
  Future<List<Document>> getVendorBusinessStatus(String userId);
  Future<List<Document>> getProductReviewComment(String productId);
  Future<Document> wasabiAwsApi();
}

class BusinessAPI implements IBusinessAPI {
  final Databases _db;

  BusinessAPI({
    required Databases db,
  }) : _db = db;

  @override
  Future<List<Document>> getVendorBusinessStatus(String vendorId) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.countryColl,
      queries: [
        Query.equal('vendorId', vendorId),
      ],
    );
    return documents.documents;
  }

  @override
  Future<List<Document>> getExchangeRate(String currency) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.exchangeRateColl,
      queries: [
        Query.equal('currency', currency),
      ],
    );
    return documents.documents;
  }

  @override
  Future<List<Document>> getProductReviewComment(String productId) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.productReviews,
      queries: [
        Query.equal('productId', productId),
      ],
    );
    return documents.documents;
  }

  @override
  Future<List<Document>> getStaff(String userId) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.staffColl,
      queries: [
        Query.equal('id', userId),
      ],
    );
    return documents.documents;
  }

  @override
  Future<Document> wasabiAwsApi() async {
    final document = await _db.getDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.wasabiAcesss,
        documentId: 'wasabiAwas123');

    return document;
  }
}

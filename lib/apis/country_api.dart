import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viewducts/constants/constants.dart';
import 'package:viewducts/core/providers.dart';

final countryAPIProvider = Provider((ref) {
  return CountryAPI(
    db: ref.watch(appwriteDatabaseProvider),
  );
});

abstract class ICountryAPI {
  Future<List<Document>> getCountryLocation();
  Future<List<Document>> getCountryStateCity(String country);
}

class CountryAPI implements ICountryAPI {
  final Databases _db;

  CountryAPI({
    required Databases db,
  }) : _db = db;

  @override
  Future<List<Document>> getCountryLocation() async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.countryColl,
      queries: [
        //  Query.orderDesc('createdAt'),
      ],
    );
    return documents.documents;
  }

  @override
  Future<List<Document>> getCountryStateCity(String country) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.countryColl,
      queries: [
        Query.equal('country', country),
      ],
    );
    return documents.documents;
  }
}

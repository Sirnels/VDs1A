import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:viewducts/constants/constants.dart';
import 'package:viewducts/core/core.dart';
import 'package:viewducts/core/providers.dart';
import 'package:viewducts/model/user.dart';

final userAPIProvider = Provider((ref) {
  return UserAPI(
    db: ref.watch(appwriteDatabaseProvider),
    realtime: ref.watch(appwriteRealtimeProvider),
  );
});

abstract class IUserAPI {
  FutureEitherVoid saveUserData(ViewductsUser userModel);
  Future<Document> getUserData(String uid);
  Future<List<Document>> searchUserByName(String name);
  FutureEitherVoid updateUserData(ViewductsUser userModel);
  Stream<RealtimeMessage> getLatestUserProfileData();
  FutureEitherVoid followUser(ViewductsUser user);
  FutureEitherVoid addToFollowing(ViewductsUser user);
}

class UserAPI implements IUserAPI {
  final Databases _db;
  final Realtime _realtime;
  UserAPI({
    required Databases db,
    required Realtime realtime,
  })  : _realtime = realtime,
        _db = db;

  @override
  FutureEitherVoid saveUserData(ViewductsUser userModel) async {
    try {
      await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.profileUserColl,
        documentId: userModel.userId.toString(),
        data: userModel.toJson(),
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
  Future<Document> getUserData(String uid) async {
    final document = await _db.getDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.profileUserColl,
      documentId: uid,
    );
    return document;
  }

  @override
  Future<List<Document>> searchUserByName(String name) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.profileUserColl,
      queries: [
        Query.search('name', name),
      ],
    );

    return documents.documents;
  }

  @override
  FutureEitherVoid updateUserData(ViewductsUser userModel) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.profileUserColl,
        documentId: userModel.userId!,
        data: userModel.toJson(),
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
  Stream<RealtimeMessage> getLatestUserProfileData() {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.profileUserColl}.documents'
    ]).stream;
  }

  @override
  FutureEitherVoid followUser(ViewductsUser user) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.profileUserColl,
        documentId: user.userId!,
        data: {
          //  'followers': user.followers,
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
  FutureEitherVoid addToFollowing(ViewductsUser user) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.profileUserColl,
        documentId: user.userId!,
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
}

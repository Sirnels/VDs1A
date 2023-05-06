// import 'package:appwrite/appwrite.dart';
// import 'package:appwrite/models.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:fpdart/fpdart.dart';
// import 'package:viewducts/constants/constants.dart';
// import 'package:viewducts/core/core.dart';
// import 'package:viewducts/core/providers.dart';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:viewducts/constants/constants.dart';
import 'package:viewducts/core/core.dart';
import 'package:viewducts/core/providers.dart';
import 'package:viewducts/core/type_defs.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/page/message/local_database.dart';

final ductAPIProvider = Provider((ref) {
  return DuctsAPI(
    db: ref.watch(appwriteDatabaseProvider),
    realtime: ref.watch(appwriteRealtimeProvider),
  );
});

abstract class IDuctsAPI {
  FutureEither<Document> creatDuct(
    FeedModel model, {
    String? key,
  });
  Future<List<Document>> getDucts();
  Stream<RealtimeMessage> getLatestDucts();
  Stream<RealtimeMessage> getLatestDuctStory();
  FutureEither<Document> likeDuctsStory(
      {required FeedModel model, required DuctStoryModel ductStory});
  FutureEither<Document> viewPinDuctsStory(
      {required FeedModel model, required DuctStoryModel ductStory});
  FutureEither<Document> pinDuctsStory({required DuctStoryModel ductStory});
  FutureEither<Document> reSharePinDuct(FeedModel model,
      {String? key, DuctStoryModel? story});
  FutureEither<Document> updatePinDuct(FeedModel model,
      {String? key, DuctStoryModel? story});
  // FutureEither<Document> updateReshareCount(Tweet tweet);
  // Future<List<Document>> getRepliesToTweet(Tweet tweet);
  Future<List<Document>> getStoryByUserId(String userId);
  // Future<List<Document>> getUserTweets(String uid);
  // Future<List<Document>> getTweetsByHashtag(String hashtag);
}

class DuctsAPI implements IDuctsAPI {
  final Databases _db;
  final Realtime _realtime;
  DuctsAPI({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;

  @override
  FutureEither<Document> creatDuct(FeedModel model,
      {String? key, DuctStoryModel? story}) async {
    try {
      // await SQLHelper.createLocalDucts(model);
      final document = await _db.listDocuments(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.dctCollid,
          queries: [Query.equal('key', key.toString())]).then((data) async {
        if (data.documents.isNotEmpty) {
          await _db.updateDocument(
            databaseId: AppwriteConstants.databaseId,
            collectionId: AppwriteConstants.dctCollid,
            documentId: key.toString(),
            data: model.toJson(),
          );
        } else {
          await _db.createDocument(
            databaseId: AppwriteConstants.databaseId,
            collectionId: AppwriteConstants.dctCollid,
            documentId: key.toString(),
            data: model.toJson(),
          );
        }
      });
      await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.storyCollId,
        documentId: story!.key.toString(),
        permissions: [Permission.read(Role.users())],
        data: story.toJson(),
      );
      return right(document);
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
  Future<List<Document>> getDucts() async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.dctCollid,
      queries: [
        Query.orderDesc('createdAt'),
      ],
    );
    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestDucts() {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.dctCollid}.documents'
    ]).stream;
  }

  @override
  FutureEither<Document> likeDuctsStory(
      {required FeedModel model, required DuctStoryModel ductStory}) async {
    try {
      final document = await _db.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.storyCollId,
          documentId: ductStory.key.toString(),
          data: {
            'hearts': ductStory.hearts
          }).then((value) => _db.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.dctCollid,
          documentId: model.key.toString(),
          data: {'likeList': model.likeList}));

      cprint('just did it');
      return right(document);
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
  Future<List<Document>> getStoryByUserId(String userId) async {
    final documents = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.storyCollId,
      queries: [
        Query.equal('userId', userId),
      ],
    );
    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestDuctStory() {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.storyCollId}.documents'
    ]).stream;
  }

  @override
  FutureEither<Document> viewPinDuctsStory(
      {required FeedModel model, required DuctStoryModel ductStory}) async {
    try {
      final document = await _db.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.storyCollId,
          documentId: ductStory.key.toString(),
          data: {
            'userViwed': ductStory.userViwed
          }).then((value) => _db.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.dctCollid,
          documentId: model.key.toString(),
          data: {'userSeen': model.userSeen}));

      cprint('just saw it');
      return right(document);
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
  FutureEither<Document> pinDuctsStory(
      {required DuctStoryModel ductStory}) async {
    try {
      final document = await _db.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.storyCollId,
          documentId: ductStory.key.toString(),
          data: {'pinDuct': ductStory.pinDuct});

      cprint('just saw it');
      return right(document);
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
  FutureEither<Document> reSharePinDuct(FeedModel model,
      {String? key, DuctStoryModel? story}) async {
    try {
      final document = await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.dctCollid,
        documentId: key.toString(),
        data: model.toJson(),
      );
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.storyCollId,
        documentId: story!.key.toString(),
        permissions: [Permission.read(Role.users())],
        data: story.toJson(),
      );
      cprint('resharing done');
      return right(document);
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
  FutureEither<Document> updatePinDuct(FeedModel model,
      {String? key, DuctStoryModel? story}) async {
    try {
      final document = await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.storyCollId,
        documentId: story!.key.toString(),
        permissions: [Permission.read(Role.users())],
        data: story.toJson(),
      );
      cprint('resharing done');
      return right(document);
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

  // @override
  // FutureEither<Document> shareTweet(Tweet tweet) async {
  //   try {
  //     final document = await _db.createDocument(
  //       databaseId: AppwriteConstants.databaseId,
  //       collectionId: AppwriteConstants.dctCollid,
  //       documentId: ID.unique(),
  //       data: tweet.toMap(),
  //     );
  //     return right(document);
  //   } on AppwriteException catch (e, st) {
  //     return left(
  //       Failure(
  //         e.message ?? 'Some unexpected error occurred',
  //         st,
  //       ),
  //     );
  //   } catch (e, st) {
  //     return left(Failure(e.toString(), st));
  //   }
  // }

  // @override
  // Future<List<Document>> getTweets() async {
  //   final documents = await _db.listDocuments(
  //     databaseId: AppwriteConstants.databaseId,
  //     collectionId: AppwriteConstants.dctCollid,
  //     queries: [
  //       Query.orderDesc('tweetedAt'),
  //     ],
  //   );
  //   return documents.documents;
  // }

  // @override
  // Stream<RealtimeMessage> getLatestTweet() {
  //   return _realtime.subscribe([
  //     'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.tweetsCollection}.documents'
  //   ]).stream;
  // }

  // @override
  // FutureEither<Document> likeTweet(Tweet tweet) async {
  //   try {
  //     final document = await _db.updateDocument(
  //       databaseId: AppwriteConstants.databaseId,
  //       collectionId: AppwriteConstants.dctCollid,
  //       documentId: tweet.id,
  //       data: {
  //         'likes': tweet.likes,
  //       },
  //     );
  //     return right(document);
  //   } on AppwriteException catch (e, st) {
  //     return left(
  //       Failure(
  //         e.message ?? 'Some unexpected error occurred',
  //         st,
  //       ),
  //     );
  //   } catch (e, st) {
  //     return left(Failure(e.toString(), st));
  //   }
  // }

  // @override
  // FutureEither<Document> updateReshareCount(Tweet tweet) async {
  //   try {
  //     final document = await _db.updateDocument(
  //       databaseId: AppwriteConstants.databaseId,
  //       collectionId: AppwriteConstants.dctCollid,
  //       documentId: tweet.id,
  //       data: {
  //         'reshareCount': tweet.reshareCount,
  //       },
  //     );
  //     return right(document);
  //   } on AppwriteException catch (e, st) {
  //     return left(
  //       Failure(
  //         e.message ?? 'Some unexpected error occurred',
  //         st,
  //       ),
  //     );
  //   } catch (e, st) {
  //     return left(Failure(e.toString(), st));
  //   }
  // }

  // @override
  // Future<List<Document>> getRepliesToTweet(Tweet tweet) async {
  //   final document = await _db.listDocuments(
  //     databaseId: AppwriteConstants.databaseId,
  //     collectionId: AppwriteConstants.dctCollid,
  //     queries: [
  //       Query.equal('repliedTo', tweet.id),
  //     ],
  //   );
  //   return document.documents;
  // }

  // @override
  // Future<Document> getTweetById(String id) async {
  //   return _db.getDocument(
  //     databaseId: AppwriteConstants.databaseId,
  //     collectionId: AppwriteConstants.dctCollid,
  //     documentId: id,
  //   );
  // }

  // @override
  // Future<List<Document>> getUserTweets(String uid) async {
  //   final documents = await _db.listDocuments(
  //     databaseId: AppwriteConstants.databaseId,
  //     collectionId: AppwriteConstants.dctCollid,
  //     queries: [
  //       Query.equal('uid', uid),
  //     ],
  //   );
  //   return documents.documents;
  // }

  // @override
  // Future<List<Document>> getTweetsByHashtag(String hashtag) async {
  //   final documents = await _db.listDocuments(
  //     databaseId: AppwriteConstants.databaseId,
  //     collectionId: AppwriteConstants.dctCollid,
  //     queries: [
  //       Query.search('hashtags', hashtag),
  //     ],
  //   );
  //   return documents.documents;
  // }
}

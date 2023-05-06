// ignore_for_file: file_names

import 'package:appwrite/appwrite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/state/stateController.dart';

class FashionCategoryService {
  String fashionRef = 'fashionCategories';

  void createFashionCategory(String name, String imagePath) async {
    // var id = const Uuid();
    // String fashioncategoryId = id.v1();

    // vDatabase.collection(fashionRef).doc(fashioncategoryId).set(
    //     {'image': imagePath, 'fashionCategory': name, 'key': authState.userId});
    final database = Databases(
      clientConnect(),
    );

    await database.createDocument(
      databaseId: databaseId,
      collectionId: fashionCollection,
      documentId: "unique()",
      data: {
        'image': imagePath,
        'fashionCategory': name,
        'key': authState.userId
      },
    );
  }

  Future<List<DocumentSnapshot>> getFashionCategories() =>
      vDatabase.collection(fashionRef).get().then((snaps) {
        if (kDebugMode) {
          print(snaps.docs.length);
        }

        return snaps.docs;
      });

  Future<List<DocumentSnapshot>> getFashionSuggestions(String suggestion) =>
      vDatabase
          .collection(fashionRef)
          .where('fashionCategory', isEqualTo: suggestion)
          .get()
          .then((snap) {
        return snap.docs;
      });
}

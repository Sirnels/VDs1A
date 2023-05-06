// ignore_for_file: file_names

import 'package:appwrite/appwrite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/state/stateController.dart';

class GroceryCategoryService {
  String groceriesRef = 'groceryCategories';

  void createGroceriesCategory(String name, String imagePath) async {
    // var id = const Uuid();
    // String grocerycategoryId = id.v1();

    // vDatabase.collection(groceriesRef).doc(grocerycategoryId).set(
    //     {'image': imagePath, 'groceryCategory': name, 'key': authState.userId});
    final database = Databases(
      clientConnect(),
    );

    await database.createDocument(
      databaseId: databaseId,
      collectionId: groceryCollection,
      documentId: "unique()",
      data: {
        'image': imagePath,
        'groceryCategory': name,
        'key': authState.userModel?.key
      },
    );
  }

  Future<List<DocumentSnapshot>> getGroceriesCategories() =>
      vDatabase.collection(groceriesRef).get().then((snaps) {
        if (kDebugMode) {
          print(snaps.docs.length);
        }

        return snaps.docs;
      });

  Future<List<DocumentSnapshot>> getGroceriesSuggestions(String suggestion) =>
      vDatabase
          .collection(groceriesRef)
          .where('groceryCategory', isEqualTo: suggestion)
          .get()
          .then((snap) {
        return snap.docs;
      });
}

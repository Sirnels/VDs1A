// ignore_for_file: file_names

import 'package:appwrite/appwrite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/state/stateController.dart';

class ElctronicsCategoryService {
  String electronicsRef = 'electronicsCategories';

  void createElectronicsCategory(String name, String imagePath) async {
    // var id = const Uuid();
    // String electronicscategoryId = id.v1();

    // vDatabase.collection(electronicsRef).doc(electronicscategoryId).set({
    //   'image': imagePath,
    //   'electronicsCategory': name,
    //   'key': authState.userId
    // });
    final database = Databases(
      clientConnect(),
    );

    await database.createDocument(
      databaseId: databaseId,
      collectionId: electronicsCollection,
      documentId: "unique()",
      data: {
        'image': imagePath,
        'electronicsCategory': name,
        'key': authState.userModel?.key
      },
    );
  }

  Future<List<DocumentSnapshot>> getElectronicsCategories() =>
      vDatabase.collection(electronicsRef).get().then((snaps) {
        if (kDebugMode) {
          print(snaps.docs.length);
        }

        return snaps.docs;
      });

  Future<List<DocumentSnapshot>> getElectronicsSuggestions(String suggestion) =>
      vDatabase
          .collection(electronicsRef)
          .where('electronicsCategory', isEqualTo: suggestion)
          .get()
          .then((snap) {
        return snap.docs;
      });
}

// ignore_for_file: file_names

import 'package:appwrite/appwrite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/state/stateController.dart';

class ChildrenCategoryService {
  String childreRef = 'childrenCategories';

  void createChildrenCategory(String name, String imagePath) async {
    //  var id = const Uuid();
    //  String childrencategoryId = id.v1();
    final database = Databases(
      clientConnect(),
    );

    await database.createDocument(
      databaseId: databaseId,
      collectionId: childrenCollection,
      documentId: "unique()",
      data: {
        'image': imagePath,
        'childrenCategory': name,
        'key': authState.userModel?.key
      },
    ).then((value) => EasyLoading.dismiss());

    // vDatabase.collection(childreRef).doc(childrencategoryId).set({
    //   'image': imagePath,
    //   'childrenCategory': name,
    //   'key': authState.userId
    // });
  }

  Future<List<DocumentSnapshot>> getChildrenCategories() =>
      vDatabase.collection(childreRef).get().then((snaps) {
        if (kDebugMode) {
          print(snaps.docs.length);
        }

        return snaps.docs;
      });

  Future<List<DocumentSnapshot>> getChildrenSuggestions(String suggestion) =>
      vDatabase
          .collection(childreRef)
          .where('childrenCategory', isEqualTo: suggestion)
          .get()
          .then((snap) {
        return snap.docs;
      });
}

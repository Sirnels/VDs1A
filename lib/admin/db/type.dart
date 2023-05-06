import 'package:appwrite/appwrite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/state/stateController.dart';

class TypeService {
  String tyepRef = 'type';

  void createType(String name) async {
    // var id = const Uuid();
    // String typeId = id.v1();

    // vDatabase
    //     .collection(tyepRef)
    //     .doc(typeId)
    //     .set({'type': name, 'key': authState.userId});
    final database = Databases(
      clientConnect(),
    );

    await database.createDocument(
      databaseId: databaseId,
      collectionId: typeCollection,
      documentId: "unique()",
      data: {'type': name, 'key': authState.userModel?.key},
    );
  }

  Future<List<DocumentSnapshot>> getTypes() =>
      vDatabase.collection(tyepRef).get().then((snaps) {
        if (kDebugMode) {
          print(snaps.docs.length);
        }
        return snaps.docs;
      });

  Future<List<DocumentSnapshot>> getSuggestions(String suggestion) => vDatabase
          .collection(tyepRef)
          .where('type', isEqualTo: suggestion)
          .get()
          .then((snap) {
        return snap.docs;
      });
}

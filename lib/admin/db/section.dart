import 'package:appwrite/appwrite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/state/stateController.dart';

class SectionService {
  String sectionRef = 'section';

  void createSection(
    String name,
  ) async {
    // var id = const Uuid();
    // String sectionId = id.v1();

    // vDatabase
    //     .collection(sectionRef)
    //     .doc(sectionId)
    //     .set({'section': name, 'key': authState.userId});
    final database = Databases(
      clientConnect(),
    );

    await database.createDocument(
      databaseId: databaseId,
      collectionId: sectionCollection,
      documentId: "unique()",
      data: {'section': name, 'key': authState.userModel?.key},
    );
  }

  Future<List<DocumentSnapshot>> getSections() =>
      vDatabase.collection(sectionRef).get().then((snaps) {
        return snaps.docs;
      });

  Future<List<DocumentSnapshot>> getSuggestions(String suggestion) => vDatabase
          .collection(sectionRef)
          .where('section', isEqualTo: suggestion)
          .get()
          .then((snap) {
        return snap.docs;
      });
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:viewducts/helper/utility.dart';

class ProductService {
  String ref = 'duct';

  void uploadProduct(Map<String, dynamic> data) {
    var id = const Uuid();
    String productId = id.v1();
    data["id"] = productId;
    vDatabase.collection(ref).doc(productId).set(data);
  }

  Future<List<DocumentSnapshot>> getProductList() =>
      vDatabase.collection(ref).get().then((snaps) {
        if (kDebugMode) {
          print(snaps.docs.length);
        }
        return snaps.docs;
      });
}

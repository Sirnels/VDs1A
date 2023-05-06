// ignore_for_file: non_constant_identifier_names, file_names, prefer_const_constructors

import 'dart:convert';

import 'package:azlistview/azlistview.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import 'package:viewducts/model/chatModel.dart';
import 'package:viewducts/model/user.dart';

var id = Uuid();
// @immutable
// class FeedModel {
//   final String key;
//   final String ductId;
//   final String timeDifference;
//   final String audioTag;
//   final List<dynamic> shoeSize;
//   final String productName;
//   final String reservedFee;
//   final String productImage;
//   final String keyword;
//   final String caption;
//   final String type;
//   final String cProduct;
//   final String videoPath;
//   final String productDescription;
//   final String productCategory;
//   final String section;
//   final String price;
//   final int salePrice;
//   final int commissionPrice;
//   final String store;
//   final String commissionUser;
//   final int weight;
//   final int stockQuantity;
//   final List<dynamic> colors;
//   final List<dynamic> productimagePath;
//   final List<dynamic> sizes;
//   final String culture;
//   final String productLocation;
//   final String productState;
//   final String brand;
//   final String parentkey;
//   final String childVductkey;
//   final String ductComment;
//   final String userId;
//   final int likeCount;
//   final List<String> likeList;
//   final int commentCount;
//   final int vductCount;
//   final String createdAt;
//   final String imagePath;
//   final List<String> tags;
//   final List<String> replyDuctKeyList;
//   final String ads;
//   final String thumbPath;
//   final String duration;
//   final int shippingFee;
//   final String activeState;
//   final String reference;
//   final String selllingPrice;
//   final int sellersSalesPrice;
//   final String paymentDate;
//   final String erroMessage;
//   FeedModel({
//     required this.key,
//     required this.ductId,
//     required this.timeDifference,
//     required this.audioTag,
//     required this.shoeSize,
//     required this.productName,
//     required this.reservedFee,
//     required this.productImage,
//     required this.keyword,
//     required this.caption,
//     required this.type,
//     required this.cProduct,
//     required this.videoPath,
//     required this.productDescription,
//     required this.productCategory,
//     required this.section,
//     required this.price,
//     required this.salePrice,
//     required this.commissionPrice,
//     required this.store,
//     required this.commissionUser,
//     required this.weight,
//     required this.stockQuantity,
//     required this.colors,
//     required this.productimagePath,
//     required this.sizes,
//     required this.culture,
//     required this.productLocation,
//     required this.productState,
//     required this.brand,
//     required this.parentkey,
//     required this.childVductkey,
//     required this.ductComment,
//     required this.userId,
//     required this.likeCount,
//     required this.likeList,
//     required this.commentCount,
//     required this.vductCount,
//     required this.createdAt,
//     required this.imagePath,
//     required this.tags,
//     required this.replyDuctKeyList,
//     required this.ads,
//     required this.thumbPath,
//     required this.duration,
//     required this.shippingFee,
//     required this.activeState,
//     required this.reference,
//     required this.selllingPrice,
//     required this.sellersSalesPrice,
//     required this.paymentDate,
//     required this.erroMessage,
//   });
// // final ViewductsUser  user;

//   FeedModel copyWith({
//     String? key,
//     String? ductId,
//     String? timeDifference,
//     String? audioTag,
//     List<dynamic>? shoeSize,
//     String? productName,
//     String? reservedFee,
//     String? productImage,
//     String? keyword,
//     String? caption,
//     String? type,
//     String? cProduct,
//     String? videoPath,
//     String? productDescription,
//     String? productCategory,
//     String? section,
//     String? price,
//     int? salePrice,
//     int? commissionPrice,
//     String? store,
//     String? commissionUser,
//     int? weight,
//     int? stockQuantity,
//     List<dynamic>? colors,
//     List<dynamic>? productimagePath,
//     List<dynamic>? sizes,
//     String? culture,
//     String? productLocation,
//     String? productState,
//     String? brand,
//     String? parentkey,
//     String? childVductkey,
//     String? ductComment,
//     String? userId,
//     int? likeCount,
//     List<String>? likeList,
//     int? commentCount,
//     int? vductCount,
//     String? createdAt,
//     String? imagePath,
//     List<String>? tags,
//     List<String>? replyDuctKeyList,
//     String? ads,
//     String? thumbPath,
//     String? duration,
//     int? shippingFee,
//     String? activeState,
//     String? reference,
//     String? selllingPrice,
//     int? sellersSalesPrice,
//     String? paymentDate,
//     String? erroMessage,
//   }) {
//     return FeedModel(
//       key: key ?? this.key,
//       ductId: ductId ?? this.ductId,
//       timeDifference: timeDifference ?? this.timeDifference,
//       audioTag: audioTag ?? this.audioTag,
//       shoeSize: shoeSize ?? this.shoeSize,
//       productName: productName ?? this.productName,
//       reservedFee: reservedFee ?? this.reservedFee,
//       productImage: productImage ?? this.productImage,
//       keyword: keyword ?? this.keyword,
//       caption: caption ?? this.caption,
//       type: type ?? this.type,
//       cProduct: cProduct ?? this.cProduct,
//       videoPath: videoPath ?? this.videoPath,
//       productDescription: productDescription ?? this.productDescription,
//       productCategory: productCategory ?? this.productCategory,
//       section: section ?? this.section,
//       price: price ?? this.price,
//       salePrice: salePrice ?? this.salePrice,
//       commissionPrice: commissionPrice ?? this.commissionPrice,
//       store: store ?? this.store,
//       commissionUser: commissionUser ?? this.commissionUser,
//       weight: weight ?? this.weight,
//       stockQuantity: stockQuantity ?? this.stockQuantity,
//       colors: colors ?? this.colors,
//       productimagePath: productimagePath ?? this.productimagePath,
//       sizes: sizes ?? this.sizes,
//       culture: culture ?? this.culture,
//       productLocation: productLocation ?? this.productLocation,
//       productState: productState ?? this.productState,
//       brand: brand ?? this.brand,
//       parentkey: parentkey ?? this.parentkey,
//       childVductkey: childVductkey ?? this.childVductkey,
//       ductComment: ductComment ?? this.ductComment,
//       userId: userId ?? this.userId,
//       likeCount: likeCount ?? this.likeCount,
//       likeList: likeList ?? this.likeList,
//       commentCount: commentCount ?? this.commentCount,
//       vductCount: vductCount ?? this.vductCount,
//       createdAt: createdAt ?? this.createdAt,
//       imagePath: imagePath ?? this.imagePath,
//       tags: tags ?? this.tags,
//       replyDuctKeyList: replyDuctKeyList ?? this.replyDuctKeyList,
//       ads: ads ?? this.ads,
//       thumbPath: thumbPath ?? this.thumbPath,
//       duration: duration ?? this.duration,
//       shippingFee: shippingFee ?? this.shippingFee,
//       activeState: activeState ?? this.activeState,
//       reference: reference ?? this.reference,
//       selllingPrice: selllingPrice ?? this.selllingPrice,
//       sellersSalesPrice: sellersSalesPrice ?? this.sellersSalesPrice,
//       paymentDate: paymentDate ?? this.paymentDate,
//       erroMessage: erroMessage ?? this.erroMessage,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     final result = <String, dynamic>{};

//     result.addAll({'key': key});
//     result.addAll({'ductId': ductId});
//     result.addAll({'timeDifference': timeDifference});
//     result.addAll({'audioTag': audioTag});
//     result.addAll({'shoeSize': shoeSize});
//     result.addAll({'productName': productName});
//     result.addAll({'reservedFee': reservedFee});
//     result.addAll({'productImage': productImage});
//     result.addAll({'keyword': keyword});
//     result.addAll({'caption': caption});
//     result.addAll({'type': type});
//     result.addAll({'cProduct': cProduct});
//     result.addAll({'videoPath': videoPath});
//     result.addAll({'productDescription': productDescription});
//     result.addAll({'productCategory': productCategory});
//     result.addAll({'section': section});
//     result.addAll({'price': price});
//     result.addAll({'salePrice': salePrice});
//     result.addAll({'commissionPrice': commissionPrice});
//     result.addAll({'store': store});
//     result.addAll({'commissionUser': commissionUser});
//     result.addAll({'weight': weight});
//     result.addAll({'stockQuantity': stockQuantity});
//     result.addAll({'colors': colors});
//     result.addAll({'productimagePath': productimagePath});
//     result.addAll({'sizes': sizes});
//     result.addAll({'culture': culture});
//     result.addAll({'productLocation': productLocation});
//     result.addAll({'productState': productState});
//     result.addAll({'brand': brand});
//     result.addAll({'parentkey': parentkey});
//     result.addAll({'childVductkey': childVductkey});
//     result.addAll({'ductComment': ductComment});
//     result.addAll({'userId': userId});
//     result.addAll({'likeCount': likeCount});
//     result.addAll({'likeList': likeList});
//     result.addAll({'commentCount': commentCount});
//     result.addAll({'vductCount': vductCount});
//     result.addAll({'createdAt': createdAt});
//     result.addAll({'imagePath': imagePath});
//     result.addAll({'tags': tags});
//     result.addAll({'replyDuctKeyList': replyDuctKeyList});
//     result.addAll({'ads': ads});
//     result.addAll({'thumbPath': thumbPath});
//     result.addAll({'duration': duration});
//     result.addAll({'shippingFee': shippingFee});
//     result.addAll({'activeState': activeState});
//     result.addAll({'reference': reference});
//     result.addAll({'selllingPrice': selllingPrice});
//     result.addAll({'sellersSalesPrice': sellersSalesPrice});
//     result.addAll({'paymentDate': paymentDate});
//     result.addAll({'erroMessage': erroMessage});

//     return result;
//   }

//   factory FeedModel.fromMap(Map<String, dynamic> map) {
//     return FeedModel(
//       key: map['key'] ?? '',
//       ductId: map['ductId'] ?? '',
//       timeDifference: map['timeDifference'] ?? '',
//       audioTag: map['audioTag'] ?? '',
//       shoeSize: List<dynamic>.from(map['shoeSize']),
//       productName: map['productName'] ?? '',
//       reservedFee: map['reservedFee'] ?? '',
//       productImage: map['productImage'] ?? '',
//       keyword: map['keyword'] ?? '',
//       caption: map['caption'] ?? '',
//       type: map['type'] ?? '',
//       cProduct: map['cProduct'] ?? '',
//       videoPath: map['videoPath'] ?? '',
//       productDescription: map['productDescription'] ?? '',
//       productCategory: map['productCategory'] ?? '',
//       section: map['section'] ?? '',
//       price: map['price'] ?? '',
//       salePrice: map['salePrice']?.toInt() ?? 0,
//       commissionPrice: map['commissionPrice']?.toInt() ?? 0,
//       store: map['store'] ?? '',
//       commissionUser: map['commissionUser'] ?? '',
//       weight: map['weight']?.toInt() ?? 0,
//       stockQuantity: map['stockQuantity']?.toInt() ?? 0,
//       colors: List<dynamic>.from(map['colors']),
//       productimagePath: List<dynamic>.from(map['productimagePath']),
//       sizes: List<dynamic>.from(map['sizes']),
//       culture: map['culture'] ?? '',
//       productLocation: map['productLocation'] ?? '',
//       productState: map['productState'] ?? '',
//       brand: map['brand'] ?? '',
//       parentkey: map['parentkey'] ?? '',
//       childVductkey: map['childVductkey'] ?? '',
//       ductComment: map['ductComment'] ?? '',
//       userId: map['userId'] ?? '',
//       likeCount: map['likeCount']?.toInt() ?? 0,
//       likeList: List<String>.from(map['likeList']),
//       commentCount: map['commentCount']?.toInt() ?? 0,
//       vductCount: map['vductCount']?.toInt() ?? 0,
//       createdAt: map['createdAt'] ?? '',
//       imagePath: map['imagePath'] ?? '',
//       tags: List<String>.from(map['tags']),
//       replyDuctKeyList: List<String>.from(map['replyDuctKeyList']),
//       ads: map['ads'] ?? '',
//       thumbPath: map['thumbPath'] ?? '',
//       duration: map['duration'] ?? '',
//       shippingFee: map['shippingFee']?.toInt() ?? 0,
//       activeState: map['activeState'] ?? '',
//       reference: map['reference'] ?? '',
//       selllingPrice: map['selllingPrice'] ?? '',
//       sellersSalesPrice: map['sellersSalesPrice']?.toInt() ?? 0,
//       paymentDate: map['paymentDate'] ?? '',
//       erroMessage: map['erroMessage'] ?? '',
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory FeedModel.fromJson(String source) =>
//       FeedModel.fromMap(json.decode(source));

//   @override
//   String toString() {
//     return 'FeedModel(key: $key, ductId: $ductId, timeDifference: $timeDifference, audioTag: $audioTag, shoeSize: $shoeSize, productName: $productName, reservedFee: $reservedFee, productImage: $productImage, keyword: $keyword, caption: $caption, type: $type, cProduct: $cProduct, videoPath: $videoPath, productDescription: $productDescription, productCategory: $productCategory, section: $section, price: $price, salePrice: $salePrice, commissionPrice: $commissionPrice, store: $store, commissionUser: $commissionUser, weight: $weight, stockQuantity: $stockQuantity, colors: $colors, productimagePath: $productimagePath, sizes: $sizes, culture: $culture, productLocation: $productLocation, productState: $productState, brand: $brand, parentkey: $parentkey, childVductkey: $childVductkey, ductComment: $ductComment, userId: $userId, likeCount: $likeCount, likeList: $likeList, commentCount: $commentCount, vductCount: $vductCount, createdAt: $createdAt, imagePath: $imagePath, tags: $tags, replyDuctKeyList: $replyDuctKeyList, ads: $ads, thumbPath: $thumbPath, duration: $duration, shippingFee: $shippingFee, activeState: $activeState, reference: $reference, selllingPrice: $selllingPrice, sellersSalesPrice: $sellersSalesPrice, paymentDate: $paymentDate, erroMessage: $erroMessage)';
//   }

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;

//     return other is FeedModel &&
//         other.key == key &&
//         other.ductId == ductId &&
//         other.timeDifference == timeDifference &&
//         other.audioTag == audioTag &&
//         listEquals(other.shoeSize, shoeSize) &&
//         other.productName == productName &&
//         other.reservedFee == reservedFee &&
//         other.productImage == productImage &&
//         other.keyword == keyword &&
//         other.caption == caption &&
//         other.type == type &&
//         other.cProduct == cProduct &&
//         other.videoPath == videoPath &&
//         other.productDescription == productDescription &&
//         other.productCategory == productCategory &&
//         other.section == section &&
//         other.price == price &&
//         other.salePrice == salePrice &&
//         other.commissionPrice == commissionPrice &&
//         other.store == store &&
//         other.commissionUser == commissionUser &&
//         other.weight == weight &&
//         other.stockQuantity == stockQuantity &&
//         listEquals(other.colors, colors) &&
//         listEquals(other.productimagePath, productimagePath) &&
//         listEquals(other.sizes, sizes) &&
//         other.culture == culture &&
//         other.productLocation == productLocation &&
//         other.productState == productState &&
//         other.brand == brand &&
//         other.parentkey == parentkey &&
//         other.childVductkey == childVductkey &&
//         other.ductComment == ductComment &&
//         other.userId == userId &&
//         other.likeCount == likeCount &&
//         listEquals(other.likeList, likeList) &&
//         other.commentCount == commentCount &&
//         other.vductCount == vductCount &&
//         other.createdAt == createdAt &&
//         other.imagePath == imagePath &&
//         listEquals(other.tags, tags) &&
//         listEquals(other.replyDuctKeyList, replyDuctKeyList) &&
//         other.ads == ads &&
//         other.thumbPath == thumbPath &&
//         other.duration == duration &&
//         other.shippingFee == shippingFee &&
//         other.activeState == activeState &&
//         other.reference == reference &&
//         other.selllingPrice == selllingPrice &&
//         other.sellersSalesPrice == sellersSalesPrice &&
//         other.paymentDate == paymentDate &&
//         other.erroMessage == erroMessage;
//   }

//   @override
//   int get hashCode {
//     return key.hashCode ^
//         ductId.hashCode ^
//         timeDifference.hashCode ^
//         audioTag.hashCode ^
//         shoeSize.hashCode ^
//         productName.hashCode ^
//         reservedFee.hashCode ^
//         productImage.hashCode ^
//         keyword.hashCode ^
//         caption.hashCode ^
//         type.hashCode ^
//         cProduct.hashCode ^
//         videoPath.hashCode ^
//         productDescription.hashCode ^
//         productCategory.hashCode ^
//         section.hashCode ^
//         price.hashCode ^
//         salePrice.hashCode ^
//         commissionPrice.hashCode ^
//         store.hashCode ^
//         commissionUser.hashCode ^
//         weight.hashCode ^
//         stockQuantity.hashCode ^
//         colors.hashCode ^
//         productimagePath.hashCode ^
//         sizes.hashCode ^
//         culture.hashCode ^
//         productLocation.hashCode ^
//         productState.hashCode ^
//         brand.hashCode ^
//         parentkey.hashCode ^
//         childVductkey.hashCode ^
//         ductComment.hashCode ^
//         userId.hashCode ^
//         likeCount.hashCode ^
//         likeList.hashCode ^
//         commentCount.hashCode ^
//         vductCount.hashCode ^
//         createdAt.hashCode ^
//         imagePath.hashCode ^
//         tags.hashCode ^
//         replyDuctKeyList.hashCode ^
//         ads.hashCode ^
//         thumbPath.hashCode ^
//         duration.hashCode ^
//         shippingFee.hashCode ^
//         activeState.hashCode ^
//         reference.hashCode ^
//         selllingPrice.hashCode ^
//         sellersSalesPrice.hashCode ^
//         paymentDate.hashCode ^
//         erroMessage.hashCode;
//   }
// }
@immutable
class RatingModel {
  final int ratingValue;
  final int productReveiwLength;
  RatingModel({
    required this.ratingValue,
    required this.productReveiwLength,
  });

  RatingModel copyWith({
    int? ratingValue,
    int? productReveiwLength,
  }) {
    return RatingModel(
      ratingValue: ratingValue ?? this.ratingValue,
      productReveiwLength: productReveiwLength ?? this.productReveiwLength,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'ratingValue': ratingValue});
    result.addAll({'productReveiwLength': productReveiwLength});

    return result;
  }

  factory RatingModel.fromMap(Map<String, dynamic> map) {
    return RatingModel(
      ratingValue: map['ratingValue']?.toInt() ?? 0,
      productReveiwLength: map['productReveiwLength']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory RatingModel.fromJson(String source) =>
      RatingModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'RatingModel(ratingValue: $ratingValue, productReveiwLength: $productReveiwLength)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RatingModel &&
        other.ratingValue == ratingValue &&
        other.productReveiwLength == productReveiwLength;
  }

  @override
  int get hashCode => ratingValue.hashCode ^ productReveiwLength.hashCode;
}

@immutable
class ProductCategoryInput {
  final String section;
  final String category;
  final String country;
  ProductCategoryInput({
    required this.section,
    required this.category,
    required this.country,
  });

  ProductCategoryInput copyWith({
    String? section,
    String? category,
    String? country,
  }) {
    return ProductCategoryInput(
      section: section ?? this.section,
      category: category ?? this.category,
      country: country ?? this.country,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'section': section});
    result.addAll({'category': category});
    result.addAll({'country': country});

    return result;
  }

  factory ProductCategoryInput.fromMap(Map<String, dynamic> map) {
    return ProductCategoryInput(
      section: map['section'] ?? '',
      category: map['category'] ?? '',
      country: map['country'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductCategoryInput.fromJson(String source) =>
      ProductCategoryInput.fromMap(json.decode(source));

  @override
  String toString() =>
      'ProductCategoryInput(section: $section, category: $category, country: $country)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductCategoryInput &&
        other.section == section &&
        other.category == category &&
        other.country == country;
  }

  @override
  int get hashCode => section.hashCode ^ category.hashCode ^ country.hashCode;
}

class FeedModel {
  String? key;
  String? ductId;
  String? storyId;
  String? timeDifference;
  String? productVendorId;
  String? audioTag;
  List<dynamic>? shoeSize;
  String? productName;
  String? reservedFee;
  String? productImage;
  String? keyword;
  String? caption;
  String? type;
  String? cProduct;
  String? videoPath;
  String? productDescription;
  String? productCategory;
  String? section;
  String? price;
  int? salePrice;
  int? commissionPrice;
  String? store;
  String? commissionUser;
  int? weight;
  int? stockQuantity;
  List<dynamic>? colors;
  List<dynamic>? productimagePath;
  List<dynamic>? sizes;
  String? culture;
  String? productLocation;
  String? productState;
  String? brand;
  String? parentkey;
  String? childVductkey;
  String? ductComment;
  String? userId;
  int? likeCount;
  List<dynamic>? likeList;
  List<String>? userSeen = [];
  int? commentCount;
  int? vductCount;
  String? createdAt;
  String? imagePath;
  List<String?>? tags;
  List<String?>? replyDuctKeyList;
  String? ads;
  String? thumbPath;
  String? duration;
  int? shippingFee;
  String? activeState;
  String? reference;
  String? selllingPrice;
  int? sellersSalesPrice;
  String? paymentDate;
  String? erroMessage;
  int? ductType;
  ViewductsUser? user;
  FeedModel(
      {this.key,
      this.ductType,
      this.ductId,
      this.audioTag,
      this.storyId,
      this.activeState,
      this.timeDifference,
      this.productImage,
      this.userSeen,
      this.productName,
      this.shoeSize,
      this.keyword,
      this.salePrice,
      this.reservedFee,
      this.productimagePath,
      this.sizes,
      this.productLocation,
      this.stockQuantity,
      this.productState,
      this.section,
      this.productDescription,
      this.type,
      this.ductComment,
      this.userId,
      this.likeCount,
      this.brand,
      this.caption,
      this.productCategory,
      this.colors,
      this.culture,
      this.price,
      this.shippingFee,
      this.commentCount,
      this.vductCount,
      this.createdAt,
      this.imagePath,
      this.likeList,
      this.tags,
      this.user,
      this.replyDuctKeyList,
      this.parentkey,
      this.ads,
      this.sellersSalesPrice,
      this.cProduct,
      this.videoPath,
      this.thumbPath,
      this.duration,
      this.childVductkey,
      this.commissionPrice,
      this.commissionUser,
      this.store,
      this.reference,
      this.selllingPrice,
      this.paymentDate,
      this.erroMessage,
      this.productVendorId,
      this.weight});
  toJson() {
    return {
      'key': key,
      "ductType": ductType,
      "productImage": productImage,
      "storyId": storyId,
      "ductId": ductId, "paymentDate": paymentDate,
      "audioTag": audioTag,
      "activeState": activeState,
      "timeDifference": timeDifference,
      "productVendorId": productVendorId,
      "selllingPrice": selllingPrice,
      "reservedFee": reservedFee,
      "keyword": keyword,
      "shoeSize": shoeSize,
      "productName": productName, "erroMessage": erroMessage,
      "section": section,
      "videoPath": videoPath,
      "cProduct": cProduct,
      "salePrice": salePrice,
      "thumbPath": thumbPath,
      "brand": brand,
      "productDescription": productDescription,
      "price": price,
      "sizes": sizes,
      "colors": colors,
      "duration": duration,
      "imagePath": imagePath,
      "stockQuantity": stockQuantity,

      "userSeen": userSeen,
      "type": type,
      "productCategory": productCategory,
      "culture": culture,
      "productLocation": productLocation,
      "productState": productState,
      "caption": caption,
      "userId": userId,
      "ductComment": ductComment,
      "likeCount": likeCount,
      "commentCount": commentCount ?? 0,
      "vductCount": vductCount ?? 0,
      "createdAt": createdAt,
      "shippingFee": shippingFee,
      "likeList": likeList,
      "tags": tags,
      "ads": ads, "reference": reference,
      "commissionPrice": commissionPrice,
      "store": store,
      "commissionUser": commissionUser,
      "weight": weight,
      "replyDuctKeyList": replyDuctKeyList,
      //"user": user == null ? null : user!.toJson(),
      "parentkey": parentkey,
      "childVductkey": childVductkey, "sellersSalesPrice": sellersSalesPrice
    };
  }

  FeedModel.fromJson(Map<dynamic, dynamic>? data) {
    final map = json.decode(json.encode(data)) as Map<String, dynamic>?;
    ductId = map?['ductId'];
    erroMessage = map?["erroMessage"];
    storyId = map?["storyId"];
    productVendorId = map?["productVendorId"];
    ductType = map?["ductType"];
    key = map?['key'];
    productImage = map?["productImage"];
    paymentDate = map?["paymentDate"];
    audioTag = map?["audioTag"];
    selllingPrice = map?["selllingPrice"];
    activeState = map?["activeState"];
    shippingFee = map?["shippingFee"];
    sizes = map?['sizes'];
    reservedFee = map?["reservedFee"];
    timeDifference = map?['timeDifference'];
    shoeSize = map?['shoeSize'];
    ductComment = map?['ductComment'];
    userId = map?['userId'];
    price = map?['price'];
    sellersSalesPrice = map?["sellersSalesPrice"];
    commissionPrice = map?['commissionPrice'];
    store = map?['store'];
    weight = map?['weight'];
    keyword = map?['keyword'];
    commissionUser = map?['commissionUser'];
    salePrice = map?['salePrice'];
    videoPath = map?['videoPath'];
    productName = map?['productName'];
    stockQuantity = map?['stockQuantity'];
    colors = map?['colors'];

    cProduct = map?['cProduct'];
    productCategory = map?['productCategory'];
    section = map?['section'];
    culture = map?['culture'];
    thumbPath = map?['thumbPath'];
    productLocation = map?['productLocation'];
    productState = map?['productState'];
    productDescription = map?['productDescription'];
    caption = map?['caption'];
    brand = map?['brand'];
    ads = map?['ads'];
    duration = map?['duration'];
    type = map?['type'];
    reference = map?["reference"];
    //  productName = map['productName'];
    //  profilePic = map['profilePic'];
    likeCount = map?['likeCount'] ?? 0;
    commentCount = map?['commentCount'];
    vductCount = map?["vductCount"] ?? 0;
    imagePath = map?['imagePath'];
    createdAt = map?['createdAt'];
    productimagePath = map?['productimagePath'];
    //  username = map['username'];
    //user = ViewductsUser.fromJson(map?['user']);
    parentkey = map?['parentkey'];
    childVductkey = map?['childVductkey'];

    // if (map?['productimagePath'] != null) {
    //   tags = <String>[];
    //   map?['productimagePath'].forEach((value) {
    //     tags!.add(value);
    //   });
    // }

    if (map?['userSeen'] != null) {
      tags = <String>[];
      map?['userSeen'].forEach((value) {
        tags!.add(value);
      });
    }
    if (map?['tags'] != null) {
      tags = <String>[];
      map?['tags'].forEach((value) {
        tags!.add(value);
      });
    }
    if (map?["likeList"] != null) {
      likeList = <String?>[];

      final list = map?['likeList'];

      /// In new tweet db schema likeList is stored as a List<String>()
      ///
      if (list is List) {
        map?['likeList'].forEach((value) {
          if (value is String) {
            likeList!.add(value);
          }
        });
        likeCount = likeList!.length;
      }

      /// In old database tweet db schema likeList is saved in the form of map
      /// like list map is removed from latest code but to support old schema below code is required
      /// Once all user migrated to new version like list map support will be removed
      else if (list is Map) {
        list.forEach((key, value) {
          likeList!.add(value["userId"]);
        });
        likeCount = list.length;
      }
    } else {
      likeList = [];
      likeCount = 0;
    }
    if (map?["likeList"] != null) {
      likeList = <String?>[];

      final list = map?['likeList'];

      /// In new tweet db schema likeList is stored as a List<String>()
      ///
      if (list is List) {
        map?['likeList'].forEach((value) {
          if (value is String) {
            likeList!.add(value);
          }
        });
        likeCount = likeList!.length;
      }

      /// In old database tweet db schema likeList is saved in the form of map
      /// like list map is removed from latest code but to support old schema below code is required
      /// Once all user migrated to new version like list map support will be removed
      else if (list is Map) {
        list.forEach((key, value) {
          likeList!.add(value["userId"]);
        });
        likeCount = list.length;
      }
    } else {
      likeList = [];
      likeCount = 0;
    }
    if (map?['replyDuctKeyList'] != null) {
      map?['replyDuctKeyList'].forEach((value) {
        replyDuctKeyList = <String?>[];
        map['replyDuctKeyList'].forEach((value) {
          replyDuctKeyList!.add(value);
        });
      });
      commentCount = replyDuctKeyList?.length;
    } else {
      replyDuctKeyList = [];
      commentCount = 0;
    }
  }

  bool get isValidDuct {
    bool isValid = false;
    if (
        // ductComment != null &&
        //   ductComment!.isNotEmpty &&
        user != null && user!.userName != null && user!.userName!.isNotEmpty) {
      isValid = true;
    } else {
      if (kDebugMode) {
        print("Invalid Tweet found. Id:- $key");
      }
    }
    return isValid;
  }
}

class SalesData {
  final String year;
  final double sales;

  SalesData(this.year, this.sales);
}

class SubscriptionModel {
  String? id;
  String? interval;
  int? price;
  String? state;
  SubscriptionModel(this.id, this.interval, this.price, this.state);
  toJson() {
    return {
      'id': id,
      'interval': interval,
      'price': price,
      'state': state,
    };
  }

  SubscriptionModel.fromJson(Map<dynamic, dynamic> map) {
    id = map['id'];
    interval = map['interval'];
    price = map['price'];
    state = map['state'];
  }
}

class KeyWordModel {
  String? keyword;

  KeyWordModel(this.keyword);
  Map toJson() => {
        'keyword': keyword,
      };

  KeyWordModel.fromMap(String map) {
    keyword = map;
  }
}

class CountryKeyWordModel {
  String? state;

  CountryKeyWordModel(this.state);
  Map toJson() => {
        'state': state,
      };

  CountryKeyWordModel.fromMap(Map<String, dynamic>? map) {
    state = map!['state'];
  }
}

class KeyWordDuctModel {
  String? keyword;
  //List<KeyWordModel>? keywords = <KeyWordModel>[];

  KeyWordDuctModel({this.keyword});
  KeyWordDuctModel.fromSnapshot(Map<String, dynamic>? data) {
    //Map data = snapshot.data() as Map;
    keyword = data!['keyword'];
    // keywords = _convertProductItems(data?['keywords'] ?? []);
  }
  Map toJson() => {
        'keyword': keyword,
      };
  // List<KeyWordModel> _convertProductItems(List productFromDB) {
  //   List<KeyWordModel> _result = [];
  //   if (productFromDB.isNotEmpty) {
  //     for (var data in productFromDB) {
  //       _result.add(KeyWordModel.fromMap(data));
  //     }
  //   }

  //   return _result;
  // }

  //List productItemsToJson() => keywords!.map((item) => item.toJson()).toList();
}

class CountryModel {
  String? country;
  String? code;
  String? dial_code;
  List<CountryKeyWordModel>? states = <CountryKeyWordModel>[];

  CountryModel({this.country, this.states, this.dial_code, this.code});
  CountryModel.fromSnapshot(Map<String, dynamic>? data) {
    //Map data = snapshot.data() as Map;
    country = data?['country'];
    dial_code = data?['dial_code'];
    code = data?['code'];
    states = _convertProductItems(json.decode(data?['states']));
  }
  List<CountryKeyWordModel> _convertProductItems(List productFromDB) {
    List<CountryKeyWordModel> _result = [];
    if (productFromDB.isNotEmpty) {
      for (var data in productFromDB) {
        _result.add(CountryKeyWordModel.fromMap(data));
      }
    }
    // if (productFromDB.isNotEmpty) {
    //   for (var data in productFromDB) {
    //     jsonStringToMap(data) {
    //       List<String> str = data
    //           .replaceAll("{", "")
    //           .replaceAll("}", "")
    //           .replaceAll("\"", "")
    //           .replaceAll("'", "")
    //           .split(",");
    //       Map<String, dynamic> result = {};
    //       for (int i = 0; i < str.length; i++) {
    //         List<String> s = str[i].split(":");
    //         result.putIfAbsent(s[0].trim(), () => s[1].trim());
    //       }
    //       return result;
    //     }

    //     _result.add(CountryKeyWordModel.fromMap(jsonStringToMap(data)));
    //   }
    // }

    return _result;
  }

  List productItemsToJson() => states!.map((item) => item.toJson()).toList();
}

class ProductModel {
  String? key = id.v1();
  String? productName;
  String? type;
  String? seller;
  String? commissionUser;
  String? brand;
  int? weight;
  int? stockQuantity;
  List<dynamic>? colors;
  String? imagePath;
  List<String>? sizes;
  String? videoPath;
  String? productDescription;
  String? productCategory;
  String? section;
  String? price;
  String? duration;
  int? salePrice;
  int? commissionPrice;
  ProductModel({
    this.key,
    this.price,
    this.duration,
    this.brand,
    this.commissionPrice,
    this.productCategory,
    this.videoPath,
    this.productDescription,
    this.type,
    this.commissionUser,
    this.colors,
    this.productName,
    this.imagePath,
    this.salePrice,
    this.section,
    this.seller,
    this.sizes,
    this.stockQuantity,
    this.weight,
  });
  Map toJson() => {
        'key': key,
        "productName": productName,
        "section": section,
        "videoPath": videoPath,
        "salePrice": salePrice,
        "brand": brand,
        "productDescription": productDescription,
        "price": price,
        "sizes": sizes,
        "colors": colors,
        "duration": duration,
        "imagePath": imagePath,
        "stockQuantity": stockQuantity,
        "type": type,
        "productCategory": productCategory,
        "commissionPrice": commissionPrice,
        "commissionUser": commissionUser,
        "weight": weight,
      };

  ProductModel.fromMap(Map<dynamic, dynamic> map) {
    key = map['key'];

    price = map['price'];
    commissionPrice = map['commissionPrice'];

    weight = map['weight'];
    commissionUser = map['commissionUser'];
    salePrice = map['salePrice'];
    videoPath = map['videoPath'];
    productName = map['productName'];
    stockQuantity = map['stockQuantity'];
    colors = map['colors'];
    productCategory = map['productCategory'];
    section = map['section'];

    productDescription = map['productDescription'];

    brand = map['brand'];

    duration = map['duration'];

    imagePath = map['imagePath'];
  }
}

class ViewBanks {
  //static const PRODUCTS = "products";

  String? banks;

  List<BankDetails>? allBanks = <BankDetails>[];
  ViewBanks({
    this.allBanks,
    this.banks,
  });
//  Map toJson() => {''=};
  ViewBanks.fromSnapshot(Map<dynamic, dynamic>? map) {
    final data = json.decode(json.encode(map)) as Map<String, dynamic>?;
    //  Map data = snapshot.data() as Map;
    allBanks = _convertProductItems(json.decode(map?['allBanks']) ?? []);
    banks = data?['banks'];
  }
  List<BankDetails> _convertProductItems(List productFromDB) {
    List<BankDetails> _result = [];
    if (productFromDB.isNotEmpty) {
      for (var data in productFromDB) {
        _result.add(BankDetails.fromMap(data));
      }
    }
    //   if (productFromDB.isNotEmpty) {
    //   for (var data in productFromDB) {
    //     jsonStringToMap(data) {
    //       List<String> str = data
    //           .replaceAll("{", "")
    //           .replaceAll("}", "")
    //           .replaceAll("\"", "")
    //           .replaceAll("'", "")
    //           .split(",");
    //       Map<String, dynamic> result = {};
    //       for (int i = 0; i < str.length; i++) {
    //         List<String> s = str[i].split(":");
    //         result.putIfAbsent(s[0].trim(), () => s[1].trim());
    //       }
    //       return result;
    //     }

    //     _result.add(BankDetails.fromMap(jsonStringToMap(data)));
    //   }
    // }

    return _result;
  }

  List productItemsToJson() => allBanks!.map((item) => item.toJson()).toList();
}

class ViewProduct {
  //static const PRODUCTS = "products";
  double? totalPrice;
  String? userId;
  String? shippingMethod;
  String? shippingAdress;
  String? placedDate;
  String? receiverId;
  int? totalItem;
  List<CartItemModel>? products = <CartItemModel>[];
  ViewProduct(
      {this.products,
      this.userId,
      this.totalPrice,
      this.receiverId,
      this.placedDate,
      this.totalItem,
      this.shippingAdress,
      this.shippingMethod});
//  Map toJson() => {''=};
  ViewProduct.fromSnapshot(Map<String, dynamic>? data) {
    //  Map data = snapshot.data() as Map;
    products = _convertProductItems(data?['products'] ?? []);
    totalPrice = data?['totalPrice'];
    receiverId = data?['receiverId'];
    shippingAdress = data?['shippingAdress'];
    shippingMethod = data?['shippingMethod'];
    placedDate = data?['placedDate'];
    totalItem = data?['totalItem'];
    userId = data?['userId'];
  }
  List<CartItemModel> _convertProductItems(List productFromDB) {
    List<CartItemModel> _result = [];
    if (productFromDB.isNotEmpty) {
      for (var data in productFromDB) {
        _result.add(CartItemModel.fromMap(data));
      }
    }

    return _result;
  }

  List productItemsToJson() => products!.map((item) => item.toJson()).toList();
}

class OrderViewProduct {
  //static const PRODUCTS = "products";
  int? totalPrice;
  String? key;
  String? userId;
  String? shippingMethod;
  String? shippingAddress;
  String? staff;
  Timestamp? placedDate;
  int? totalItem;
  String? orderState;
  String? sellerId;
  List<OrderItemModel>? items = <OrderItemModel>[];
  OrderViewProduct(
      {this.items,
      this.userId,
      this.key,
      this.staff,
      this.totalPrice,
      this.placedDate,
      this.totalItem,
      this.orderState,
      this.sellerId,
      this.shippingAddress,
      this.shippingMethod});
//  Map toJson() => {''=};
  OrderViewProduct.fromSnapshot(Map<dynamic, dynamic>? data) {
    final map = json.decode(json.encode(data)) as Map<String, dynamic>?;
    // Map data = snapshot.data() as Map;

    items = _convertProductItems(json.decode(data?['items']));
    totalPrice = map?['totalPrice'];
    staff = map?['staff'];
    orderState = map?['orderState'];
    sellerId = map?["sellerId"];
    shippingAddress = map?['shippingAddress'];
    shippingMethod = map?['shippingMethod'];
    placedDate = Timestamp.fromDate(
        DateTime.parse(map?['placedDate'] ?? '2022-07-15 09:26:56.215217Z'));
    totalItem = map?['totalItem'];
    userId = map?['userId'];
    key = map?['key'];
  }
  List<OrderItemModel> _convertProductItems(List productFromDB) {
    List<OrderItemModel> _result = [];
    if (productFromDB.isNotEmpty) {
      for (var data in productFromDB) {
        _result.add(OrderItemModel.fromMap(data));
      }
    }

    return _result;
  }

  List productItemsToJson() => items!.map((item) => item.toJson()).toList();
}

class UserAccountModel {
  //static const PRODUCTS = "products";
  double? totalPrice;
  String? userId;
  List<AccountValueModel>? accounts = <AccountValueModel>[];
  UserAccountModel({this.accounts, this.userId, this.totalPrice});
//  Map toJson() => {''=};
  UserAccountModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map data = snapshot.data() as Map;
    accounts = _convertProductItems(data['products'] ?? []);
    totalPrice = data['totalPrice'];
    userId = data['userId'];
  }
  List<AccountValueModel> _convertProductItems(List productFromDB) {
    List<AccountValueModel> _result = [];
    if (productFromDB.isNotEmpty) {
      for (var data in productFromDB) {
        _result.add(AccountValueModel.fromSnapshot(data));
      }
    }

    return _result;
  }

  List productItemsToJson() => accounts!.map((item) => item.toJson()).toList();
}

class AccountValueModel {
  int? balance;
  int? withdrawed;
  int? sales;

  AccountValueModel({this.balance, this.withdrawed, this.sales});
  Map toJson() =>
      {'balance': balance, 'withdrawed': withdrawed, 'sales': sales};

  AccountValueModel.fromSnapshot(Map<dynamic, dynamic>? data) {
    //Map data = snapshot.data() as Map;
    balance = data?['balance'];
    withdrawed = data?['withdrawed'];
    sales = data?['sales'];
  }
}

class TransactionModel {
  //static const PRODUCTS = "products";

  String? userId;
  // List<InitialTransactionModel>? data;
  String? initData;
  TransactionModel({
    // this.data,
    this.userId,
    this.initData,
  });
//  Map toJson() => {''=};
  TransactionModel.fromSnapshot(Map<String, dynamic>? snapshot) {
    //  Map datas = snapshot.data() as Map;
    //  data = _convertProductItems(snapshot?['data'] ?? []);

    userId = snapshot?['userId'];
    initData = snapshot?['initData'];
  }
}

class Anouncement {
  //static const PRODUCTS = "products";

  List<AnouncementText>? anouncement = <AnouncementText>[];
  Anouncement({
    this.anouncement,
  });
//  Map toJson() => {''=};
  Anouncement.fromSnapshot(Map<dynamic, dynamic>? snapshot) {
    final data = json.decode(json.encode(snapshot)) as Map<String, dynamic>?;
    //  Map datas = snapshot.data() as Map;

    anouncement = _convertProductItems(data?['anouncement'] ?? []);

    // initData = snapshot?['initData'];
  }
  List<AnouncementText> _convertProductItems(List productFromDB) {
    List<AnouncementText> _result = [];
    if (productFromDB.isNotEmpty) {
      for (var data in productFromDB) {
        _result.add(AnouncementText.fromSnapshot(data));
      }
    }

    return _result;
  }

  List productItemsToJson() =>
      anouncement!.map((item) => item.toJson()).toList();
}

class AnouncementText {
  //static const PRODUCTS = "products";

  String? announce;
  AnouncementText({
    this.announce,
  });
//  Map toJson() => {''=};
  AnouncementText.fromSnapshot(Map<String, dynamic>? snapshot) {
    //  Map datas = snapshot.data() as Map;
    announce = snapshot?['announce'];

    // initData = snapshot?['initData'];
  }
  Map toJson() => {
        'announce': announce,
      };
}

class InitialTransactionModel {
  //static const PRODUCTS = "products";

  String? message;
  bool? status;
  List<InitModel>? data;
  InitialTransactionModel({
    this.data,
    this.message,
    this.status,
  });
//  Map toJson() => {''=};
  InitialTransactionModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map datas = snapshot.data() as Map;
    data = _convertProductItems(datas['data'] ?? []);

    message = datas['message'];
    status = datas['status'];
  }
  List<InitModel> _convertProductItems(List productFromDB) {
    List<InitModel> _result = [];
    if (productFromDB.isNotEmpty) {
      for (var data in productFromDB) {
        _result.add(InitModel.fromMap(data));
      }
    }

    return _result;
  }

  // List productItemsToJson() => story!.map((item) => item.toJson()).toList();
}

class BankDetails {
  bool? active;
  String? code;
  String? country;
  String? createdAt;
  bool? pay_with_bank;
  bool? is_deleted;
  String? longcode;

  String? currency;
  String? name;
  String? type;
  BankDetails({
    this.name,
    this.code,
    this.active,
    this.country,
    this.createdAt,
    this.currency,
    this.is_deleted,
    this.longcode,
    this.pay_with_bank,
    this.type,
  });

  BankDetails.fromMap(Map<String, dynamic> data) {
    name = data['name'];
    code = data['code'];
    active = data['active'];
    country = data['country'];
    createdAt = data['createdAt'];
    currency = data['currency'];
    is_deleted = data['is_deleted'];
    longcode = data['longcode'];
    pay_with_bank = data['pay_with_bank'];
    type = data['type'];
  }

  Map toJson() => {
        'name': name,
        'code': code,
        'active': active,
        'country': country,
        'createdAt': createdAt,
        'currency': currency,
        'is_deleted': is_deleted,
        'longcode': longcode,
        'pay_with_bank': pay_with_bank,
        'type': type
      };
}

class ChipperCash {
  String? fullName;
  String? chipperCashTag;
  String? status;
  String? currency;
  bool? isVerified;
  String? grantedState;
  ChipperCash({
    this.fullName,
    this.status,
    this.currency,
    this.isVerified,
    this.grantedState,
    this.chipperCashTag,
  });

  ChipperCash.fromMap(Map<String, dynamic> data) {
    fullName = data['fullName'];
    status = data['status'];
    currency = data['currency'];
    isVerified = data['isVerified'];
    grantedState = data['grantedState'];
    chipperCashTag = data['chipperCashTag'];
  }

  Map toJson() => {
        'fullName': fullName,
        'status': status,
        'currency': currency,
        'isVerified': isVerified,
        'grantedState': grantedState,
        'chipperCashTag': chipperCashTag,
      };
}

class CartItemModel {
  // ignore: constant_identifier_names
  static const ID = "id";
  // ignore: constant_identifier_names
  static const VENDORID = "vendorId";
  // ignore: constant_identifier_names
  static const COLOR = "color";
  // ignore: constant_identifier_names
  static const QUANTITY = "quantity";
  // ignore: constant_identifier_names
  static const SIZE = "size";
  // ignore: constant_identifier_names
  static const PRICE = "price";
  // ignore: constant_identifier_names
  static const STORE = "store";
  // ignore: constant_identifier_names
  static const NAME = "name";
  String? key;
  String? id;
  String? productId;
  String? vendorId;
  String? color;
  int? quantity;
  String? commissionId;
  String? size;
  String? commissionUser;
  String? price;
  String? store;
  String? name;
  String? commissionPrice;
  CartItemModel(
      {this.id,
      this.key,
      this.name,
      this.productId,
      this.commissionPrice,
      this.commissionUser,
      this.vendorId,
      this.commissionId,
      this.color,
      this.quantity,
      this.size,
      this.price,
      this.store});

  CartItemModel.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    productId = data['productId'];
    key = data['key'];
    commissionPrice = data['commissionPrice'];
    commissionUser = data['commissionUser'];
    commissionId = data['commissionId'];
    vendorId = data[VENDORID];
    color = data[COLOR];
    quantity = data[QUANTITY];
    size = data[SIZE];

    price = data[PRICE];
    store = data[STORE];
    name = data[NAME];
  }

  Map toJson() => {
        'id': id,
        // key: key,
        'productId': productId,
        VENDORID: vendorId,
        COLOR: color,
        SIZE: size,
        STORE: store,
        QUANTITY: quantity,
        PRICE: price,
        NAME: name,
        'commissionId': commissionId,
        'commissionUser': commissionUser,
        'commissionPrice': commissionPrice
      };
}

class AdminOrdersModel {
  // ignore: constant_identifier_names
  static const USERID = "userId";
  // ignore: constant_identifier_names
  static const ORDERSTATE = "orderState";
  // ignore: constant_identifier_names
  static const PLACEDDATE = "placedDate";
  // ignore: constant_identifier_names
  static const STAFF = "staff";

  String? userId;
  String? key;
  String? orderState;
  String? staff;
  Timestamp? placedDate;
  String? state;
  String? country;

  AdminOrdersModel(
      {this.userId,
      this.state,
      this.country,
      this.staff,
      this.orderState,
      this.placedDate,
      this.key});

  AdminOrdersModel.fromMap(Map<dynamic, dynamic>? map) {
    final data = json.decode(json.encode(map)) as Map<String, dynamic>?;
    userId = data?[USERID];
    state = data?['state'];
    country = data?['country'];
    key = data?['key'];
    staff = data?[STAFF];
    orderState = data?[ORDERSTATE];
    placedDate = Timestamp.fromDate(DateTime.parse(data?[PLACEDDATE]));
  }

  Map toJson() => {
        USERID: userId,
        ORDERSTATE: orderState,
        PLACEDDATE: placedDate,
        'key': key,
        STAFF: staff,
        'state': state,
        'country': country,
      };
}

class OrderItemModel {
  // ignore: constant_identifier_names
  static const ID = "id";
  // ignore: constant_identifier_names
  static const VENDORID = "vendorId";
  // ignore: constant_identifier_names
  static const COLOR = "color";
  // ignore: constant_identifier_names
  static const QUANTITY = "quantity";
  // ignore: constant_identifier_names
  static const SIZE = "size";
  // ignore: constant_identifier_names
  static const IMAGE = "image";
  // ignore: constant_identifier_names
  static const PRICE = "price";
  // ignore: constant_identifier_names
  static const STORE = "store";
  // ignore: constant_identifier_names
  static const NAME = "name";
  // ignore: constant_identifier_names
  static const WEIGHT = "weight";

  String? id;
  String? key;
  String? productId;
  String? vendorId;
  String? color;
  int? quantity;
  String? size;
  String? image;
  String? price;
  String? store;
  String? name;
  String? weight;
  String? commissionUser;
  String? commissionPrice;
  String? commissionId;
  OrderItemModel(
      {this.id,
      this.key,
      this.weight,
      this.productId,
      this.name,
      this.commissionPrice,
      this.vendorId,
      this.commissionId,
      this.commissionUser,
      this.color,
      this.quantity,
      this.size,
      this.image,
      this.price,
      this.store});

  OrderItemModel.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    productId = data['productId'];
    key = data['key'];
    commissionUser = data['commissionUser'];
    vendorId = data[VENDORID];
    commissionPrice = data['commissionPrice'];
    commissionId = data['commissionId'];
    color = data[COLOR];
    quantity = data[QUANTITY];
    size = data[SIZE];
    image = data[IMAGE];
    price = data[PRICE];
    store = data[STORE];
    name = data[NAME];
    weight = data[WEIGHT];
  }

  Map toJson() => {
        'id': id,
        'key': key,
        'productId': productId,
        VENDORID: vendorId,
        COLOR: color,
        SIZE: size,
        STORE: store,
        QUANTITY: quantity,
        PRICE: price,
        WEIGHT: weight,
        IMAGE: image,
        NAME: name,
        'commissionPrice': commissionPrice,
        'commissionUser': commissionUser,
        'commissionId': commissionId,
      };
}

class DuctStoryModel {
  String? key;
  int? storyType;
  String? userId;
  String? audioTag;
  String? reservedFee;
  String? cProduct;
  String? videoPath;
  String? duration;
  String? commissionUser;
  String? profilePic;
  String? ductComment;
  String? displayName;
  String? createdAt;
  String? imagePath;
  String? date;
  String? pinDuct;
  String? timeDifference;
  List<dynamic>? userViwed = [];
  List<dynamic>? hearts;
  List<ChatStoryModel>? chats;

  DuctStoryModel(
      {this.key,
      this.userId,
      this.date,
      this.audioTag,
      this.storyType,
      this.reservedFee,
      this.displayName,
      this.profilePic,
      this.ductComment,
      this.createdAt,
      this.imagePath,
      this.cProduct,
      this.videoPath,
      this.timeDifference,
      this.duration,
      this.commissionUser,
      this.userViwed,
      this.chats,
      this.pinDuct,
      this.hearts});
  toJson() {
    return {
      'key': key,
      'date': date,
      'pinDuct': pinDuct,
      "audioTag": audioTag,
      "reservedFee": reservedFee,
      'timeDifference': timeDifference,
      'storyType': storyType,
      "videoPath": videoPath,
      "userId": userId,
      "displayName": displayName,
      "profilePic": profilePic,
      "cProduct": cProduct,
      "duration": duration,
      "ductComment": ductComment,
      "createdAt": createdAt,
      "imagePath": imagePath,
      "commissionUser": commissionUser,
      "userViwed": userViwed,
    };
  }

  DuctStoryModel.fromMap(Map<dynamic, dynamic>? snapshot) {
    final map = json.decode(json.encode(snapshot)) as Map<String, dynamic>?;
    cProduct = map?['cProduct'];
    key = map?['key'];
    storyType = map?['storyType'];
    reservedFee = map?["reservedFee"];
    ductComment = map?['ductComment'];
    audioTag = map?["audioTag"];
    timeDifference = map?['timeDifference'];
    userId = map?['userId'];
    profilePic = map?['profilePic'];
    displayName = map?['displayName'];
    commissionUser = map?['commissionUser'];
    date = map?['date'];
    videoPath = map?['videoPath'];
    pinDuct = map?["pinDuct"];
    cProduct = map?['cProduct'];

    duration = map?['duration'];

    imagePath = map?['imagePath'];
    createdAt = map?['createdAt'];
    userViwed = map?['userViwed'];
    chats = _convertCartItems(map?['chats'] ?? []);
    hearts = (map?['hearts'] ?? []);
  }
  List<ChatStoryModel> _convertCartItems(List cartFomDb) {
    List<ChatStoryModel> _result = [];
    if (cartFomDb.isNotEmpty) {
      for (var element in cartFomDb) {
        _result.add(ChatStoryModel.fromJson(element));
      }
    }
    return _result;
  }

  List cartItemsToJsons() => chats!.map((item) => item.toJson()).toList();
  List<HeartViewsModel> _convertCartItem(List cartFomDb) {
    List<HeartViewsModel> _result = [];
    if (cartFomDb.isNotEmpty) {
      for (var element in cartFomDb) {
        _result.add(HeartViewsModel.fromJson(element));
      }
    }
    return _result;
  }

  // List cartItemsToJson() => hearts!.map((item) => item.toJson()).toList();
  // bool get isValidDuct {
  //   // bool isValid = false;
  //   // if (
  //   //     this.user != null &&
  //   //     this.user!.userName != null &&
  //   //     this.user!.userName!.isNotEmpty
  //   //     ) {
  //   //   isValid = true;
  //   // } else {
  //   //   print("Invalid Tweet found. Id:- $key");
  //   // }
  //   // return isValid;
  // }
}

class InitModel {
  String? access_code;
  int? authorization_url;
  String? reference;

  InitModel({
    this.reference,
    this.access_code,
    this.authorization_url,
  });
  toJson() {
    return {
      'reference': reference,
      'access_code': access_code,
      "authorization_url": authorization_url,
    };
  }

  InitModel.fromMap(Map<dynamic, dynamic> map) {
    reference = map['reference'];
    access_code = map['access_code'];
    authorization_url = map['authorization_url'];
  }

  // bool get isValidDuct {
  //   // bool isValid = false;
  //   // if (
  //   //     this.user != null &&
  //   //     this.user!.userName != null &&
  //   //     this.user!.userName!.isNotEmpty
  //   //     ) {
  //   //   isValid = true;
  //   // } else {
  //   //   print("Invalid Tweet found. Id:- $key");
  //   // }
  //   // return isValid;
  // }
}

class StaffUserModel {
  // ignore: constant_identifier_names
  static const ID = "id";
  // ignore: constant_identifier_names
  static const NAME = "name";
  // ignore: constant_identifier_names
  static const EMAIL = "email";
  // ignore: constant_identifier_names
  static const CART = "cart";
  // ignore: constant_identifier_names
  static const ROLE = "role";
  // ignore: constant_identifier_names
  static const COUNTRY = "country";
  // ignore: constant_identifier_names
  static const STATE = "state";

  String? id;
  String? name;
  String? email;
  String? role;
  String? country;
  String? fcm;
  String? state;
  String? profilePic;
  List<CartItemModel>? cart;

  StaffUserModel(
      {this.id,
      this.name,
      this.fcm,
      this.email,
      this.cart,
      this.profilePic,
      this.country,
      this.role,
      this.state});

  StaffUserModel.fromSnapshot(Map<dynamic, dynamic>? snapshot) {
    final data = json.decode(json.encode(snapshot)) as Map<String, dynamic>?;
    name = data?[NAME];
    email = data?[EMAIL];
    fcm = data?["fcm"];
    id = data?[ID];
    profilePic = data?['profilePic'];
    country = data?[COUNTRY];
    role = data?[ROLE];
    state = data?[STATE];
    cart = _convertCartItems(data?[CART] ?? []);
  }

  List<CartItemModel> _convertCartItems(List cartFomDb) {
    List<CartItemModel> _result = [];
    if (cartFomDb.isNotEmpty) {
      for (var element in cartFomDb) {
        _result.add(CartItemModel.fromMap(element));
      }
    }
    return _result;
  }

  List cartItemsToJson() => cart!.map((item) => item.toJson()).toList();
}

class StaffProfileModel {
  String? id;
  String? bank;
  String? account;
  List<StaffAccountAmount>? amount;

  StaffProfileModel({
    this.id,
    this.bank,
    this.account,
    this.amount,
  });
  toJson() {
    return {
      'id': id,
      'bank': bank,
      "account": account,
      "amount": amount,
    };
  }

  StaffProfileModel.fromSnapshot(Map<String, dynamic>? data) {
    bank = data?['bank'];
    account = data?['account'];
    id = data?['id'];

    amount = _convertCartItems(data?['amount'] ?? []);
  }
  List<StaffAccountAmount> _convertCartItems(List cartFomDb) {
    List<StaffAccountAmount> _result = [];
    if (cartFomDb.isNotEmpty) {
      for (var element in cartFomDb) {
        _result.add(StaffAccountAmount.fromSnapshot(element));
      }
    }
    return _result;
  }

  List cartItemsToJson() => amount!.map((item) => item.toJson()).toList();
}

class UserBankAccountModel {
  String? userId;
  String? bank;
  String? account;
  String? country;
  String? name;
  String? status;
  List<UserAccountAmount>? amount;

  UserBankAccountModel({
    this.userId,
    this.bank,
    this.account,
    this.amount,
    this.country,
    this.status,
    this.name,
  });
  toJson() {
    return {
      'userId': userId,
      'bank': bank,
      'name': name,
      'country': country,
      "account": account,
      'status': status,
      "amount": amount,
    };
  }

  UserBankAccountModel.fromSnapshot(Map<String, dynamic>? data) {
    bank = data?['bank'];
    status = data?['status'];
    account = data?['account'];
    name = data?['name'];
    userId = data?['userId'];
    country = data?['country'];

    amount = _convertCartItems(data?['amount'] ?? []);
  }
  List<UserAccountAmount> _convertCartItems(List cartFomDb) {
    List<UserAccountAmount> _result = [];
    if (cartFomDb.isNotEmpty) {
      for (var element in cartFomDb) {
        _result.add(UserAccountAmount.fromSnapshot(element));
      }
    }
    return _result;
  }

  List cartItemsToJson() => amount!.map((item) => item.toJson()).toList();
}

class UserBankAccountCommissionModel {
  String? id;
  String? bank;
  String? account;
  String? country;
  List<UserAccountAmount>? amount;

  UserBankAccountCommissionModel({
    this.id,
    this.bank,
    this.account,
    this.amount,
    this.country,
  });
  toJson() {
    return {
      'id': id,
      'bank': bank,
      'country': country,
      "account": account,
      "amount": amount,
    };
  }

  UserBankAccountCommissionModel.fromSnapshot(Map<String, dynamic>? data) {
    bank = data?['bank'];
    account = data?['account'];
    id = data?['id'];
    country = data?['country'];

    amount = _convertCartItems(data?['amount'] ?? []);
  }
  List<UserAccountAmount> _convertCartItems(List cartFomDb) {
    List<UserAccountAmount> _result = [];
    if (cartFomDb.isNotEmpty) {
      for (var element in cartFomDb) {
        _result.add(UserAccountAmount.fromSnapshot(element));
      }
    }
    return _result;
  }

  List cartItemsToJson() => amount!.map((item) => item.toJson()).toList();
}

class StaffAccountAmount {
  String? month;
  int? amount;

  StaffAccountAmount({
    this.month,
    this.amount,
  });
  Map toJson() => {
        "month": month,
        "amount": amount,
      };

  StaffAccountAmount.fromSnapshot(Map<String, dynamic>? data) {
    month = data?['month'];

    amount = data?['amount'];
  }
}

class UserAccountAmount {
  String? monthPay;
  int? amount;
  String? productId;
  String? commissionId;
  String? paymentState;

  UserAccountAmount({
    this.monthPay,
    this.amount,
    this.productId,
    this.commissionId,
    this.paymentState,
  });
  toJson() {
    return {
      "monthPay": monthPay,
      "amount": amount,
      "commissionId": commissionId,
      "productId": productId,
      "paymentState": paymentState,
    };
  }

  UserAccountAmount.fromSnapshot(Map<String, dynamic>? data) {
    monthPay = data?['monthPay'];
    productId = data?['productId'];
    amount = data?['amount'];
    commissionId = data?['commissionId'];
    paymentState = data?["paymentState"];
  }
}

class RequestedCommissionState {
  String? monthPay;
  String? amount;
  String? userId;

  String? paymentState;

  RequestedCommissionState({
    this.monthPay,
    this.amount,
    this.userId,
    this.paymentState,
  });
  toJson() {
    return {
      "monthPay": monthPay,
      "amount": amount,
      "userId": userId,
      "paymentState": paymentState,
    };
  }

  RequestedCommissionState.fromSnapshot(Map<String, dynamic>? data) {
    monthPay = data?['monthPay'];
    userId = data?['userId'];
    amount = data?['amount'];

    paymentState = data?["paymentState"];
  }
}

class UserMonthPayCommission {
  String? monthPay;
  int? amount;
  String? productId;
  String? commissionId;
  String? paymentState;
  String? reference;

  UserMonthPayCommission({
    this.monthPay,
    this.amount,
    this.productId,
    this.commissionId,
    this.paymentState,
    this.reference,
  });
  toJson() {
    return {
      "monthPay": monthPay,
      "amount": amount,
      "commissionId": commissionId,
      "productId": productId,
      "paymentState": paymentState,
      "reference": reference
    };
  }

  UserMonthPayCommission.fromSnapshot(Map<String, dynamic>? data) {
    monthPay = data?['monthPay'];
    productId = data?['productId'];
    amount = data?['amount'];
    commissionId = data?['commissionId'];
    paymentState = data?["paymentState"];
    reference = data?["reference"];
  }
}

class AdminPaymentActivate {
  String? paymentStatus;
  String? date;

  AdminPaymentActivate({this.paymentStatus, this.date});
  toJson() {
    return {"paymentStatus": paymentStatus, "date": date};
  }

  AdminPaymentActivate.fromSnapshot(Map<dynamic, dynamic>? snapshot) {
    final data = json.decode(json.encode(snapshot)) as Map<String, dynamic>?;
    paymentStatus = data?['paymentStatus'];
    date = data?['date'];
  }
}

class CartSeen {
  String? state;
  String? uid;
  CartSeen({this.state, this.uid});
  toJson() {
    return {"state": state, "uid": uid};
  }

  CartSeen.fromSnapshot(Map<dynamic, dynamic>? snapshot) {
    final data = json.decode(json.encode(snapshot)) as Map<String, dynamic>?;
    state = data?['state'];
    uid = data?['uid'];
  }
}

class AtmCardModel {
  String? userId;
  String? message;
  String? ref;

  AtmCardModel({
    this.ref,
    this.userId,
    this.message,
  });
  toJson() {
    return {"ref": ref, "userId": userId, "message": message};
  }

  AtmCardModel.fromSnapshot(Map<dynamic, dynamic>? data) {
    userId = data?["userId"];
    message = data?["message"];
  }
}

class Atm {
  String? card_type;
  String? last4;
  String? channel;
  String? authorization_code;
  String? paymentState;

  Atm({
    this.card_type,
    this.last4,
    this.channel,
    this.authorization_code,
    this.paymentState,
  });
  toJson() {
    return {
      "card_type": card_type,
      "last4": last4,
      "authorization_code": authorization_code,
      "channel": channel,
      "paymentState": paymentState,
    };
  }

  Atm.fromSnapshot(Map<String, dynamic>? data) {
    card_type = data?['card_type'];
    channel = data?['channel'];
    last4 = data?['last4'];
    authorization_code = data?['authorization_code'];
    paymentState = data?["paymentState"];
  }
}

class HeartViewsModel {
  String? viewerId;
  String? userId;
  String? storyId;
  HeartViewsModel({this.viewerId, this.storyId, this.userId});

  factory HeartViewsModel.fromJson(Map<dynamic, dynamic> json) =>
      HeartViewsModel(
          storyId: json["storyId"],
          viewerId: json["viewerId"],
          userId: json["userId"]);

  Map<String, dynamic> toJson() => {
        "viewerId": viewerId,
        "storyId": storyId,
        "userId": userId,
      };
}

class InitPaymentModel {
  bool? initialize;
  String? cartType;
  String? userId;
  String? custId;
  int? totalPrice;
  String? initData;
  InitPaymentModel(
      {this.initialize,
      this.cartType,
      this.initData,
      this.totalPrice,
      this.custId,
      this.userId});

  factory InitPaymentModel.fromJson(Map<dynamic, dynamic> json) =>
      InitPaymentModel(
          initialize: json["initialize"],
          cartType: json["cartType"],
          custId: json["custId"],
          totalPrice: json["totalPrice"],
          initData: json["initData"],
          userId: json["userId"]);

  Map<String, dynamic> toJson() => {
        "initialize": initialize,
        "cartType": cartType,
        "custId": custId,
        "initData": initData,
        "totalPrice": totalPrice,
        "userId": userId,
      };
}

class PaymentMethodsModel {
  bool? state;
  String? method;

  PaymentMethodsModel({
    this.state,
    this.method,
  });

  factory PaymentMethodsModel.fromJson(Map<dynamic, dynamic> json) =>
      PaymentMethodsModel(state: json["state"], method: json["method"]);

  Map<String, dynamic> toJson() => {
        "state": state,
        "method": method,
      };
}

class OrderTransactionModel {
  String? message;
  String? ref;

  OrderTransactionModel({
    this.message,
    this.ref,
  });

  factory OrderTransactionModel.fromJson(Map<dynamic, dynamic> json) =>
      OrderTransactionModel(message: json["message"], ref: json['ref']);

  Map<String, dynamic> toJson() => {
        "message": message,
        "ref": ref,
      };
}

class UnPaidCommission {
  String? month;
  String? amount;
  String? productId;
  String? commissionId;
  String? commisionUser;

  UnPaidCommission({
    this.month,
    this.amount,
    this.productId,
    this.commissionId,
    this.commisionUser,
  });
  toJson() {
    return {
      "month": month,
      "amount": amount,
      "commissionId": commissionId,
      "productId": productId,
      "commisionUser": commisionUser,
    };
  }

  UnPaidCommission.fromSnapshot(Map<String, dynamic>? data) {
    month = data?['month'];
    productId = data?['productId'];
    amount = data?['amount'];
    commissionId = data?['commissionId'];
    commisionUser = data?["commisionUser"];
  }
}

class PaidCommission {
  String? month;
  String? amount;
  String? productId;
  String? commissionId;
  String? commisionUser;
  String? paidState;

  PaidCommission({
    this.month,
    this.amount,
    this.productId,
    this.commissionId,
    this.commisionUser,
    this.paidState,
  });
  toJson() {
    return {
      "month": month,
      "amount": amount,
      "commissionId": commissionId,
      "productId": productId,
      "commisionUser": commisionUser,
      "paidState": paidState,
    };
  }

  PaidCommission.fromSnapshot(Map<String, dynamic>? data) {
    month = data?['month'];
    productId = data?['productId'];
    amount = data?['amount'];
    commissionId = data?['commissionId'];
    commisionUser = data?["commisionUser"];
    paidState = data?["paidState"];
  }
}

class Bible {
  String? theme;
  String? topic;
  String? text;
  String? body;
  String? videoPath;

  Bible({
    this.theme,
    this.topic,
    this.text,
    this.body,
    this.videoPath,
  });
  toJson() {
    return {
      "theme": theme,
      "topic": topic,
      "text": text,
      "body": body,
      "videoPath": videoPath
    };
  }

  Bible.fromSnapshot(Map<String, dynamic>? data) {
    theme = data?['theme'];
    topic = data?['topic'];
    text = data?['text'];
    body = data?['body'];
    videoPath = data?["videoPath"];
  }
}

class KeyViewducts {
  String? viewductKey;

  KeyViewducts({
    this.viewductKey,
  });
  toJson() {
    return {
      "viewductKey": viewductKey,
    };
  }

  KeyViewducts.fromSnapshot(Map<String, dynamic>? data) {
    viewductKey = data?['viewductKey'];
  }
}

class OficialViewductsStoreNameModel {
  String? name;

  OficialViewductsStoreNameModel({
    this.name,
  });
  toJson() {
    return {
      "name": name,
    };
  }

  OficialViewductsStoreNameModel.fromSnapshot(Map<String, dynamic>? data) {
    name = data?['name'];
  }
}

class VirtualSignUpAccountModel {
  String? key;
  bool? success;
  String? fincraId;
  int? businessTag;
  String? name;
  String? email;
  int? mobile;
  String? country;
  String? parentBusiness;
  String? business;
  int? ledgerBalance;
  int? availableBalance;
  int? lockedBalance;
  int? walletNumber;
  String? currency;
  String? walletStatus;
  String? walletId;
  bool? isKYCApproved;
  int? businessId;

  VirtualSignUpAccountModel({
    this.key,
    this.success,
    this.fincraId,
    this.businessTag,
    this.name,
    this.email,
    this.mobile,
    this.country,
    this.parentBusiness,
    this.business,
    this.ledgerBalance,
    this.availableBalance,
    this.lockedBalance,
    this.walletNumber,
    this.currency,
    this.walletStatus,
    this.walletId,
    this.isKYCApproved,
    this.businessId,
  });
  toJson() {
    return {
      "key": key,
      "success": success,
      "fincraId": fincraId,
      "businessTag": businessTag,
      "name": name,
      "email": email,
      "mobile": mobile,
      "country": country,
      "parentBusiness": parentBusiness,
      "business": business,
      "ledgerBalance": ledgerBalance,
      "availableBalance": availableBalance,
      "lockedBalance": lockedBalance,
      "walletNumber": walletNumber,
      "currency": currency,
      "walletStatus": walletStatus,
      "walletId": walletId,
      "isKYCApproved": isKYCApproved,
      "businessId": businessId,
    };
  }

  VirtualSignUpAccountModel.fromSnapshot(Map<String, dynamic>? data) {
    key = data?['key'];
    success = data?['success'];
    fincraId = data?['fincraId'];
    businessTag = data?['businessTag'];
    name = data?['name'];
    email = data?['email'];
    mobile = data?['mobile'];
    country = data?['country'];
    parentBusiness = data?['parentBusiness'];
    availableBalance = data?['availableBalance'];
    lockedBalance = data?['lockedBalance'];
    walletNumber = data?['walletNumber'];
    currency = data?['currency'];
    walletStatus = data?['currency'];
    walletId = data?['walletId'];
    isKYCApproved = data?['isKYCApproved'];
    businessId = data?['businessId'];
  }
}

class ProductReviewModel {
  String? reviewComment;
  int? rating;
  String? productId;
  String? senderName;
  String? key;
  String? userId;

  ProductReviewModel({
    this.reviewComment,
    this.rating,
    this.productId,
    this.senderName,
    this.key,
    this.userId,
  });
  toJson() {
    return {
      "reviewComment": reviewComment,
      "rating": rating,
      "productId": productId,
      "senderName": senderName,
      "key": key,
      "userId": userId,
    };
  }

  ProductReviewModel.fromSnapshot(Map<String, dynamic>? data) {
    reviewComment = data?['reviewComment'];
    rating = data?['rating'];
    productId = data?['productId'];
    senderName = data?['senderName'];
    key = data?["key"];
    userId = data?["userId"];
  }
}

class ContactModel extends ISuspensionBean {
  final String name;
  final String tag;
  ContactModel({
    required this.name,
    required this.tag,
  });

  @override
  String getSuspensionTag() => tag;
}

class FarmCategoryModel {
  final String key;
  final String image;
  final String farmCategory;
  FarmCategoryModel({
    required this.key,
    required this.image,
    required this.farmCategory,
  });

  FarmCategoryModel copyWith({
    String? key,
    String? image,
    String? farmCategory,
  }) {
    return FarmCategoryModel(
      key: key ?? this.key,
      image: image ?? this.image,
      farmCategory: farmCategory ?? this.farmCategory,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'key': key});
    result.addAll({'image': image});
    result.addAll({'farmCategory': farmCategory});

    return result;
  }

  factory FarmCategoryModel.fromMap(Map<String, dynamic> map) {
    return FarmCategoryModel(
      key: map['key'] ?? '',
      image: map['image'] ?? '',
      farmCategory: map['farmCategory'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory FarmCategoryModel.fromJson(String source) =>
      FarmCategoryModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'FarmCategoryModel(key: $key, image: $image, farmCategory: $farmCategory)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FarmCategoryModel &&
        other.key == key &&
        other.image == image &&
        other.farmCategory == farmCategory;
  }

  @override
  int get hashCode => key.hashCode ^ image.hashCode ^ farmCategory.hashCode;
}

class ChildrenCategoryModel {
  final String key;
  final String image;
  final String childrenCategory;
  ChildrenCategoryModel({
    required this.key,
    required this.image,
    required this.childrenCategory,
  });

  ChildrenCategoryModel copyWith({
    String? key,
    String? image,
    String? childrenCategory,
  }) {
    return ChildrenCategoryModel(
      key: key ?? this.key,
      image: image ?? this.image,
      childrenCategory: childrenCategory ?? this.childrenCategory,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'key': key});
    result.addAll({'image': image});
    result.addAll({'childrenCategory': childrenCategory});

    return result;
  }

  factory ChildrenCategoryModel.fromMap(Map<String, dynamic> map) {
    return ChildrenCategoryModel(
      key: map['key'] ?? '',
      image: map['image'] ?? '',
      childrenCategory: map['childrenCategory'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ChildrenCategoryModel.fromJson(String source) =>
      ChildrenCategoryModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'ChildrenCategoryModel(key: $key, image: $image, childrenCategory: $childrenCategory)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChildrenCategoryModel &&
        other.key == key &&
        other.image == image &&
        other.childrenCategory == childrenCategory;
  }

  @override
  int get hashCode => key.hashCode ^ image.hashCode ^ childrenCategory.hashCode;
}

class CarsCategoryModel {
  final String key;
  final String image;
  final String carsCategory;
  CarsCategoryModel({
    required this.key,
    required this.image,
    required this.carsCategory,
  });

  CarsCategoryModel copyWith({
    String? key,
    String? image,
    String? carsCategory,
  }) {
    return CarsCategoryModel(
      key: key ?? this.key,
      image: image ?? this.image,
      carsCategory: carsCategory ?? this.carsCategory,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'key': key});
    result.addAll({'image': image});
    result.addAll({'carsCategory': carsCategory});

    return result;
  }

  factory CarsCategoryModel.fromMap(Map<String, dynamic> map) {
    return CarsCategoryModel(
      key: map['key'] ?? '',
      image: map['image'] ?? '',
      carsCategory: map['carsCategory'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory CarsCategoryModel.fromJson(String source) =>
      CarsCategoryModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'CarsCategoryModel(key: $key, image: $image, carsCategory: $carsCategory)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CarsCategoryModel &&
        other.key == key &&
        other.image == image &&
        other.carsCategory == carsCategory;
  }

  @override
  int get hashCode => key.hashCode ^ image.hashCode ^ carsCategory.hashCode;
}

class FashionCategoryModel {
  final String key;
  final String image;
  final String fashionCategory;
  FashionCategoryModel({
    required this.key,
    required this.image,
    required this.fashionCategory,
  });

  FashionCategoryModel copyWith({
    String? key,
    String? image,
    String? fashionCategory,
  }) {
    return FashionCategoryModel(
      key: key ?? this.key,
      image: image ?? this.image,
      fashionCategory: fashionCategory ?? this.fashionCategory,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'key': key});
    result.addAll({'image': image});
    result.addAll({'fashionCategory': fashionCategory});

    return result;
  }

  factory FashionCategoryModel.fromMap(Map<String, dynamic> map) {
    return FashionCategoryModel(
      key: map['key'] ?? '',
      image: map['image'] ?? '',
      fashionCategory: map['fashionCategory'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory FashionCategoryModel.fromJson(String source) =>
      FashionCategoryModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'FashionCategoryModel(key: $key, image: $image, fashionCategory: $fashionCategory)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FashionCategoryModel &&
        other.key == key &&
        other.image == image &&
        other.fashionCategory == fashionCategory;
  }

  @override
  int get hashCode => key.hashCode ^ image.hashCode ^ fashionCategory.hashCode;
}

class ElectronicsCategoryModel {
  final String key;
  final String image;
  final String electronicsCategory;
  ElectronicsCategoryModel({
    required this.key,
    required this.image,
    required this.electronicsCategory,
  });

  ElectronicsCategoryModel copyWith({
    String? key,
    String? image,
    String? electronicsCategory,
  }) {
    return ElectronicsCategoryModel(
      key: key ?? this.key,
      image: image ?? this.image,
      electronicsCategory: electronicsCategory ?? this.electronicsCategory,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'key': key});
    result.addAll({'image': image});
    result.addAll({'electronicsCategory': electronicsCategory});

    return result;
  }

  factory ElectronicsCategoryModel.fromMap(Map<String, dynamic> map) {
    return ElectronicsCategoryModel(
      key: map['key'] ?? '',
      image: map['image'] ?? '',
      electronicsCategory: map['electronicsCategory'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ElectronicsCategoryModel.fromJson(String source) =>
      ElectronicsCategoryModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'ElectronicsCategoryModel(key: $key, image: $image, electronicsCategory: $electronicsCategory)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ElectronicsCategoryModel &&
        other.key == key &&
        other.image == image &&
        other.electronicsCategory == electronicsCategory;
  }

  @override
  int get hashCode =>
      key.hashCode ^ image.hashCode ^ electronicsCategory.hashCode;
}

class BooksCategoryModel {
  final String key;
  final String image;
  final String booksCategory;
  BooksCategoryModel({
    required this.key,
    required this.image,
    required this.booksCategory,
  });

  BooksCategoryModel copyWith({
    String? key,
    String? image,
    String? booksCategory,
  }) {
    return BooksCategoryModel(
      key: key ?? this.key,
      image: image ?? this.image,
      booksCategory: booksCategory ?? this.booksCategory,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'key': key});
    result.addAll({'image': image});
    result.addAll({'booksCategory': booksCategory});

    return result;
  }

  factory BooksCategoryModel.fromMap(Map<String, dynamic> map) {
    return BooksCategoryModel(
      key: map['key'] ?? '',
      image: map['image'] ?? '',
      booksCategory: map['booksCategory'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory BooksCategoryModel.fromJson(String source) =>
      BooksCategoryModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'BooksCategoryModel(key: $key, image: $image, booksCategory: $booksCategory)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BooksCategoryModel &&
        other.key == key &&
        other.image == image &&
        other.booksCategory == booksCategory;
  }

  @override
  int get hashCode => key.hashCode ^ image.hashCode ^ booksCategory.hashCode;
}

class HousingCategoryModel {
  final String key;
  final String image;
  final String housingCategory;
  HousingCategoryModel({
    required this.key,
    required this.image,
    required this.housingCategory,
  });

  HousingCategoryModel copyWith({
    String? key,
    String? image,
    String? housingCategory,
  }) {
    return HousingCategoryModel(
      key: key ?? this.key,
      image: image ?? this.image,
      housingCategory: housingCategory ?? this.housingCategory,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'key': key});
    result.addAll({'image': image});
    result.addAll({'housingCategory': housingCategory});

    return result;
  }

  factory HousingCategoryModel.fromMap(Map<String, dynamic> map) {
    return HousingCategoryModel(
      key: map['key'] ?? '',
      image: map['image'] ?? '',
      housingCategory: map['housingCategory'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory HousingCategoryModel.fromJson(String source) =>
      HousingCategoryModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'HousingCategoryModel(key: $key, image: $image, housingCategory: $housingCategory)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HousingCategoryModel &&
        other.key == key &&
        other.image == image &&
        other.housingCategory == housingCategory;
  }

  @override
  int get hashCode => key.hashCode ^ image.hashCode ^ housingCategory.hashCode;
}

class GroceryCategoryModel {
  final String key;
  final String image;
  final String groceryCategory;
  GroceryCategoryModel({
    required this.key,
    required this.image,
    required this.groceryCategory,
  });

  GroceryCategoryModel copyWith({
    String? key,
    String? image,
    String? groceryCategory,
  }) {
    return GroceryCategoryModel(
      key: key ?? this.key,
      image: image ?? this.image,
      groceryCategory: groceryCategory ?? this.groceryCategory,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'key': key});
    result.addAll({'image': image});
    result.addAll({'groceryCategory': groceryCategory});

    return result;
  }

  factory GroceryCategoryModel.fromMap(Map<String, dynamic> map) {
    return GroceryCategoryModel(
      key: map['key'] ?? '',
      image: map['image'] ?? '',
      groceryCategory: map['groceryCategory'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory GroceryCategoryModel.fromJson(String source) =>
      GroceryCategoryModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'GroceryCategoryModel(key: $key, image: $image, groceryCategory: $groceryCategory)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GroceryCategoryModel &&
        other.key == key &&
        other.image == image &&
        other.groceryCategory == groceryCategory;
  }

  @override
  int get hashCode => key.hashCode ^ image.hashCode ^ groceryCategory.hashCode;
}

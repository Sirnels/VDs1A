// ignore_for_file: unnecessary_cast, file_names, unnecessary_null_comparison, iterable_contains_unrelated_type, overridden_fields, list_remove_unrelated_type, prefer_is_empty, body_might_complete_normally_nullable, avoid_function_literals_in_foreach_calls, prefer_function_declarations_over_variables, library_prefixes

import 'dart:async';
import 'dart:convert';
import 'package:appwrite/appwrite.dart' as query;
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:viewducts/helper/enum.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/chatModel.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/state/stateController.dart';

import 'appState.dart';

extension SplitString on String {
  List<String> splitByLength(int length) =>
      [substring(0, length), substring(length)];
}

// import 'authState.dart';
double _salesTaxRate = 0.06;
double _shippingCostPerItem = 7.0;

class FeedState extends AppState {
  static FeedState instance = Get.find<FeedState>();
  @override
  RxDouble totalCartPrice = 0.0.obs;

  // ViewductsUser userService;
  bool isBusy = false;
  Map<String?, RxList<FeedModel>?> ductReplyMap = {};
  Rx<FeedModel?>? _ductToReplyModel;

  bool hasMoredata = true;
  final RxList<FeedModel> _commentlist = RxList<FeedModel>([]);
  RxList<FeedModel>? feedlist = [FeedModel()].obs;
  RxList<FeedModel>? localDucts = [FeedModel()].obs;
  RxList<FeedModel>? productlist = RxList<FeedModel>([]);
  RxList<FeedModel>? feedListProductlist = RxList<FeedModel>([]);
  RxList<DuctStoryModel> storylist = RxList<DuctStoryModel>([]);
  Rx<FeedModel> storyId = FeedModel().obs;
  RxList<ChatStoryModel> storyChats = RxList<ChatStoryModel>([]);
  RxList<ViewsModel> viewsNumber = RxList<ViewsModel>([]);
  RxList<HeartViewsModel> heartsView = RxList<HeartViewsModel>([]);
  RxList<HeartViewsModel> heartsViewLikesNumber = RxList<HeartViewsModel>([]);
  RxList<MainUserViewsModel> mainUserViers = [MainUserViewsModel()].obs;
  RxList<MainUserViewsModel> userViers = [MainUserViewsModel()].obs;
  final RxList<FeedModel> _secondFeedlist = RxList<FeedModel>([]);
  final RxList<FeedModel> _thirdFeedlist = RxList<FeedModel>([]);
  RxList<KeyWordDuctModel> keywords = RxList<KeyWordDuctModel>([]);
  RxList<CountryModel>? country = RxList<CountryModel>([]);
  RxList<CategoryModel>? categoryModel = RxList<CategoryModel>([]);
  Rx<CountryModel> state = CountryModel(states: []).obs;
  Rx<AccountValueModel> accountBalance = AccountValueModel().obs;
  RxList<FeedModel?>? _ductDetailModelList = RxList<FeedModel?>([]);
  final RxList<FeedModel> _userfollowingList = RxList<FeedModel>([]);
  RxList<FeedModel> get viewingList => _userfollowingList;
  Rx<String>? dataBaseChatsId = ''.obs;
  RxList<FeedModel?>? get ductDetailModel => _ductDetailModelList;
  @override
  void onReady() {
    super.onReady();
    // getChildrenCategories();
    // getElectronicsCategories();
    // getFashionCategories();
    // getGroceriesCategories();
    // // getDataFromDatabase();
    // // user = Rx<User>(_firebaseAuth.currentUser);

    // feedlist!.bindStream(getDataFromDatabase());
    // productlist!.bindStream(getProductFromDatabase());
    // keywords.bindStream(getKeyword());
    // accountBalance.bindStream(getAccBalance());
    // country.bindStream(getCountryKeyword());
    //ever(authState.userModel.obs, getDataFromDatabase());
    getDatas();
    // getData();
  }

  getDatas({String? pageIndex}) async {
    try {
      final account = query.Account(clientConnect());
      authState.appUser = await account.get();
      account.get().then((data) async {
        if (data.status == true) {
          final database = Databases(
            clientConnect(),
          );
          await database.listDocuments(
              databaseId: databaseId,
              collectionId: chatsColl,
              queries: [
                query.Query.orderDesc('createdAt'),
              ]).then((data) async {
            //   if (data.documents.isNotEmpty) {
            var value = data.documents
                .map((e) => ChatMessage.fromJson(e.data))
                .toList();

            chatState.chatUserList?.value = value;
            // } else {}
          });
          await database.listDocuments(
              databaseId: databaseId,
              collectionId: mainUserViews,
              queries: [
                query.Query.orderDesc('createdAt'),
                query.Query.equal('viewerId', authState.appUser?.$id),
              ]).then((data) {
            var value = data.documents
                .map((e) => MainUserViewsModel.fromJson(e.data))
                .toList();
            mainUserViers.value = value.obs;
          });

          await database.listDocuments(
              databaseId: databaseId,
              collectionId: dctCollid,
              queries: [
                query.Query.orderDesc('createdAt'),
                query.Query.equal('userId',
                    mainUserViers.map((data) => data.viewductUser).toList())
              ]).then((data) {
            var value =
                data.documents.map((e) => FeedModel.fromJson(e.data)).toList();

            feedlist = value
                .where((feedData) {
                  if (
                      // mainUserViersState.value
                      //       .where((data) => data.viewductUser == feedData.key)
                      //       .isNotEmpty &&
                      DateTime.now()
                              .toUtc()
                              .difference(
                                  DateTime.parse(feedData.createdAt.toString()))
                              .inHours <
                          24) {
                    return true;
                  } else {
                    return false;
                  }
                })
                .toList()
                .obs;
          }).onError((error, stackTrace) {
            cprint('$error  searchState.viewUserlistChatList');
          });
          // await database.listDocuments(
          //     databaseId: databaseId,
          //     collectionId: procold,
          //     queries: [
          //       query.Query.equal(
          //           'key', feedlist!.map((data) => data.cProduct).toList())
          //     ]).then((data) {
          //   feedListProductlist = data.documents
          //       .map((e) => FeedModel.fromJson(e.data))
          //       .toList()
          //       .obs;
          // });

          //snap.documents;
          // await database.listDocuments(
          //     databaseId: databaseId,
          //     collectionId: profileUserColl,
          //     queries: [
          //       query.Query.equal(
          //           'key', feedlist!.map((data) => data.userId).toList())
          //     ]
          //     //  queries: [query.Query.equal('key', ductId)]
          //     ).then((data) {
          //   if (data.documents.isNotEmpty) {
          //     var value = data.documents
          //         .map((e) => ViewductsUser.fromJson(e.data))
          //         .toList();

          //     //searchState.viewUserlist.value = value;
          //     chatState.chatUser ==
          //         value
          //             .firstWhere((data) => data.key == authState.appUser?.$id,
          //                 orElse: () => ViewductsUser())
          //             .obs;
          //   }
          // });

          await database.listDocuments(
              databaseId: databaseId,
              collectionId: profileUserColl,
              queries: [
                // query.Query.orderDesc('createdAt'),
                // query.Query.limit(10),
                query.Query.equal(
                    'key',
                    chatState.chatUserList!
                        .map((data) => data.sellerId.toString())
                        .toList())
              ]
              //  queries: [query.Query.equal('key', ductId)]
              ).then((data) {
            var value = data.documents
                .map((e) => ViewductsUser.fromJson(e.data))
                .toList();

            searchState.viewUserlistChatList = value.obs;
          }).onError((error, stackTrace) {
            cprint('$error  searchState.viewUserlistChatList');
          });
        }
      });
    } on AppwriteException catch (e) {
      cprint("$e");
    }
  }

  // getData() async {
  //   try {
  //     final database = Databases(
  //       clientConnect(),
  //     );
  //     await database
  //         .listDocuments(
  //       databaseId: databaseId,
  //       collectionId: procold,
  //     )
  //         .then((data) {
  //       productlist =
  //           data.documents.map((e) => FeedModel.fromJson(e.data)).toList().obs;
  //     });

  // await database
  //     .listDocuments( databaseId: databaseId,
  //   collectionId: dctCollid,
  //   //  queries: [query.Query.equal('key', ductId)]
  // )
  //     .then((data) {
  //   // Map map = data.toMap();

  //   var value =
  //       data.documents.map((e) => FeedModel.fromJson(e.data)).toList();
  //   //data.documents;
  //   feedlist = value.obs;
  //   // cprint('${data.documents.map((e) => FeedModel.fromJson(e.data))}');
  //   //cprint('${feedState.feedlist?.value.map((e) => e.key)}');
  // });

  //snap.documents;
  //   } on AppwriteException catch (e) {
  //     cprint("$e");
  //   }
  // }
  // getData() async {
  //   try {
  //     final database =  Databases(clientConnect(), databaseId: databaseId,);

  //     final snap = await database
  //         .listDocuments( databaseId: databaseId,collectionId: "6296c5c55b5a1d7ffc9a", queries: [
  //       // Query.equal('productLocation', widget.location.toString()),
  //       // Query.equal('productState', widget.state.toString()),
  //       // Query.equal('section', widget.section.toString()),
  //       // Query.equal('productCategory', widget.category.toString())
  //     ]);
  //     cprint('${snap.toMap()}');
  //     return productlist?.map((e) => snap.toMap());

  //     // cprint('${snap.toMap()}');
  //     //snap.documents;
  //   } on AppwriteException catch (e) {
  //     cprint("$e");
  //   }
  // }

  /// `feedlist` always [contain all ducts] fetched from firebase database
  // RxList<FeedModel> get feedlist {
  //   if (feedlist == null) {
  //     return null;
  //   } else {
  //     return List.from(feedlist.reversed).obs;
  //   }
  // }

  RxList<FeedModel>? get secondFeedlist {
    // if (_secondFeedlist == null) {
    //   return null;
    // } else {
    //
    // }
    return List.from(_secondFeedlist.reversed) as RxList<FeedModel>;
  }

  Rx<FeedModel?>? get ductToReplyModel => _ductToReplyModel;
  set setDuctToReply(Rx<FeedModel?> model) {
    _ductToReplyModel = model;
  }

  RxList<FeedModel>? get thirdFeedlist {
    if (_thirdFeedlist == null) {
      return null;
    } else {
      return List.from(_thirdFeedlist.reversed) as RxList<FeedModel>;
    }
  }

  changeCartTotalPrice(ViewductsUser userModel) {}
//   List<ViewductsUser> getVendors(String location) {
//     if (location == null) {
//       return null;
//     }
//     List<ViewductsUser> list;
//     if (!isBusy && _userlist != null && _userlist.isNotEmpty) {
//       list = _userlist.where((x) {
//         if (x.vendor == true && x.location == location) {
//           return true;
//         } else {
//           return false;
//         }
//         // if (userIds.contains(x.key)) {
//         //   return true;
//         // } else {
//         //   return false;
//         // }
//       }).toList();
//       if (list.isEmpty) {
//         list = null;
//       }
//     }
//     return list;
//   }
// }

  RxList<FeedModel>? ductComments(List<String?>? comments) {
    if (comments == null) {
      return null;
    }

    RxList<FeedModel>? list;

    if (!isBusy && feedlist != null && feedlist!.isNotEmpty) {
      list = feedlist!
          .where((x) {
            /// If Duct is a comment then no need to add it in duct list
            if (x.replyDuctKeyList == null
                // x.parentkey != null ||
                //   x.childVductkey == null && x.user.userId != userModel.userId
                ) {
              return false;
            }

            /// Only include Ducts of logged-in user's and his following user's
            if (x.replyDuctKeyList!.contains(comments)
                // x.user.userId == userModel.userId ||
                //   (userModel?.viewingList != null &&
                //       userModel.viewingList.contains(x.user.userId))
                ) {
              return true;
            } else {
              return false;
            }
          })
          .take(2)
          .toList() as RxList<FeedModel>?;
      if (list!.isEmpty) {
        list = null;
      }
    }
    return list;
  }

  /// contain duct list for home page
  List<FeedModel>? getDuctList(ViewductsUser? userModel) {
    if (userModel == null) {
      return null;
    }

    List<FeedModel>? list;

    if (!isBusy && feedlist != null && feedlist!.isNotEmpty) {
      list = feedlist!
          .where((x) {
            /// If Duct is a comment then no need to add it in duct list
            if (x.parentkey != null &&
                x.childVductkey == null &&
                x.user!.userId != userModel.userId) {
              return false;
            }

            /// Only include Ducts of logged-in user's and his following user's
            if (x.user!.userId == userModel.userId
                // ||
                //     (userModel.viewingList != null &&
                //             userModel.viewingList!.contains(x.user!.userId) ||
                //         userModel.viewersList != null &&
                //             userModel.viewersList!.contains(x.user!.userId))
                ) {
              return true;
            } else {
              return false;
            }
          })
          .take(2)
          .toList();
      if (list.isEmpty) {
        list = null;
      }
    }
    return list;
  }

  List<FeedModel>? getAllDuctList(ViewductsUser? userModel) {
    if (userModel == null) {
      return null;
    }

    List<FeedModel>? list;

    if (!isBusy && feedlist != null && feedlist!.isNotEmpty) {
      list = feedlist!
          .where((x) {
            /// If Duct is a comment then no need to add it in duct list
            if (x.parentkey != null &&
                x.childVductkey == null &&
                x.user!.userId != userModel.userId) {
              return false;
            }
            return true;
          })
          .take(2)
          .toList();
      if (list.isEmpty) {
        list = null;
      }
    }
    return list;
  }

  List<FeedModel>? getSecondDuctList(ViewductsUser? userModel) {
    if (userModel == null) {
      return null;
    }

    List<FeedModel>? list;

    if (!isBusy && feedlist != null && feedlist!.isNotEmpty) {
      list = feedlist!
          .where((x) {
            /// If Duct is a comment then no need to add it in duct list
            if (x.parentkey != null &&
                x.childVductkey == null &&
                x.user!.userId != userModel.userId) {
              return false;
            }
            return true;
          })
          .skip(2)
          .take(4)
          .toList();
      if (list.isEmpty) {
        list = null;
      }
    }
    return list;
  }

  List<FeedModel>? getThirdDuctList(ViewductsUser? userModel) {
    if (userModel == null) {
      return null;
    }

    List<FeedModel>? list;

    if (!isBusy && feedlist != null && feedlist!.isNotEmpty) {
      list = feedlist!
          .where((x) {
            /// If Duct is a comment then no need to add it in duct list
            if (x.parentkey != null &&
                x.childVductkey == null &&
                x.user!.userId != userModel.userId) {
              return false;
            }
            return true;
          })
          .skip(7)
          .take(2)
          .toList();
      if (list.isEmpty) {
        list = null;
      }
    }
    return list;
  }

  List<FeedModel>? getFourthDuctList(ViewductsUser userModel) {
    if (userModel == null) {
      return null;
    }

    List<FeedModel>? list;

    if (!isBusy && feedlist != null && feedlist!.isNotEmpty) {
      list = feedlist!
          .where((x) {
            /// If Duct is a comment then no need to add it in duct list
            if (x.parentkey != null &&
                x.childVductkey == null &&
                x.user!.userId != userModel.userId) {
              return false;
            }
            return true;
          })
          .skip(9)
          .take(6)
          .toList();
      if (list.isEmpty) {
        list = null;
      }
    }
    return list;
  }

  List<FeedModel>? getTopDuctList(ViewductsUser userModel) {
    if (userModel == null) {
      return null;
    }

    List<FeedModel>? list;

    if (!isBusy && feedlist != null && feedlist!.isNotEmpty) {
      list = feedlist!.where((x) {
        /// If Duct is a comment then no need to add it in duct list
        if (x.parentkey != null &&
            x.childVductkey == null &&
            x.user!.userId != userModel.userId) {
          return false;
        }

        /// Only include Ducts of logged-in user's and his following user's
        if (x.likeList != null && x.likeCount! > 1) {
          return true;
        } else {
          return false;
        }
      }).toList()
          // .reduce((v, e) => v.likeCount > e.likeCount ? v : e)
          // .toJson()
          ;
      if (list.isEmpty) {
        list = null;
      }
    }
    return list;
  }

  List<FeedModel>? getTrendingProduct(ViewductsUser userModel) {
    if (userModel == null) {
      return null;
    }

    List<FeedModel>? list;

    if (!isBusy && feedlist != null && feedlist!.isNotEmpty) {
      list = feedlist!.where((x) {
        /// If Duct is a comment then no need to add it in duct list
        if (x.parentkey != null &&
            x.childVductkey == null &&
            x.user!.userId != userModel.userId) {
          return false;
        }

        /// Only include Ducts of logged-in user's and his following user's
        if (x.user!.userId == userModel.userId
            //  ||
            //     (userModel.viewingList != null &&
            //         userModel.viewingList!.contains(x.user!.userId))

            ) {
          return true;
        } else {
          return false;
        }
      }).toList();
      if (list.isEmpty) {
        list = null;
      }
    }
    return list;
  }

  List<FeedModel>? getProductOnSale(ViewductsUser userModel) {
    if (userModel == null) {
      return null;
    }

    List<FeedModel>? list;

    if (!isBusy && feedlist != null && feedlist!.isNotEmpty) {
      list = feedlist!.where((x) {
        /// If Duct is a comment then no need to add it in duct list
        if (x.parentkey != null &&
            x.childVductkey == null &&
            x.user!.userId != userModel.userId) {
          return false;
        }

        /// Only include Ducts of logged-in user's and his following user's
        if (x.user!.userId == userModel.userId
            //  ||
            //     (userModel.viewingList != null &&
            //         userModel.viewingList!.contains(x.user!.userId))
            ) {
          return true;
        } else {
          return false;
        }
      }).toList();
      if (list.isEmpty) {
        list = null;
      }
    }
    return list;
  }

  List<FeedModel>? getAds(ViewductsUser? userModel) {
    if (userModel == null) {
      return null;
    }

    List<FeedModel>? list;

    if (!isBusy && feedlist != null && feedlist!.isNotEmpty) {
      list = feedlist!.where((x) {
        /// If Duct is a comment then no need to add it in duct list
        if (x.parentkey != null &&
            x.childVductkey == null &&
            x.user!.userId != userModel.userId) {
          return false;
        }

        /// Only include Ducts of logged-in user's and his following user's
        if (x.ads == 'vAds') {
          return true;
        } else {
          return false;
        }
      }).toList();
      if (list.isEmpty) {
        list = null;
      }
    }
    return list;
  }

  List<FeedModel>? commissionProducts(
      ViewductsUser? userModel, String? ductId) {
    if (userModel == null) {
      return null;
    }

    List<FeedModel>? list;

    if (!isBusy && productlist != null && productlist!.isNotEmpty) {
      list = productlist!.where((x) {
        /// If Duct is a comment then no need to add it in duct list
        if (x.parentkey != null &&
            x.childVductkey == null &&
            x.user!.userId != userModel.userId) {
          return false;
        }

        /// Only include Ducts of logged-in user's and his following user's
        if (x.key == ductId) {
          return true;
        } else {
          return false;
        }
      }).toList();
      if (list.isEmpty) {
        list = null;
      }
    }
    return list;
  }

  List<FeedModel>? getProductListing(ViewductsUser? userModel) {
    if (userModel == null) {
      return null;
    }

    List<FeedModel>? list;

    if (!isBusy && feedlist != null && feedlist!.isNotEmpty) {
      list = feedlist!.where((x) {
        /// If Duct is a comment then no need to add it in duct list
        if (x.parentkey != null &&
            x.childVductkey == null &&
            x.user!.userId != userModel.userId) {
          return false;
        }

        /// Only include Ducts of logged-in user's and his following user's
        if (x.ads == 'listing' || x.caption == 'product') {
          return true;
        } else {
          return false;
        }
      }).toList();
      if (list.isEmpty) {
        list = null;
      }
    }
    return list;
  }

  List<FeedModel>? getFeaturedProduct(ViewductsUser? userModel) {
    if (userModel == null) {
      return null;
    }

    List<FeedModel>? list;

    if (!isBusy && feedlist != null && feedlist!.isNotEmpty) {
      list = feedlist!.where((x) {
        /// If Duct is a comment then no need to add it in duct list
        if (x.parentkey != null &&
            x.childVductkey == null &&
            x.user!.userId != userModel.userId) {
          return false;
        }

        /// Only include Ducts of logged-in user's and his following user's
        if (x.ads == 'featured' && x.caption == 'product') {
          return true;
        } else {
          return false;
        }
      }).toList();
      if (list.isEmpty) {
        list = null;
      }
    }
    return list;
  }

  /// set duct for detail duct page
  /// Setter call when duct is tapped to view detail
  /// Add Duct detail is added in _ductDetailModelList
  /// It makes `ViewDuct` to view nested Ducts
  set setFeedModel(FeedModel? model) {
    if (_ductDetailModelList == null) {}

    /// [Skip if any duplicate duct already present]
    if (_ductDetailModelList!.length >= 0) {
      _ductDetailModelList!.add(model);
      cprint("Detail Duct added. Total Duct: ${_ductDetailModelList!.length}");
      update();
    }
  }

  /// `remove` last Duct from duct detail page stack
  /// Function called when navigating back from a Duct detail
  /// `_ductDetailModelList` is map which contain lists of commment Duct list
  /// After removing Duct from Duct detail Page stack its commnets duct is also removed from `_ductDetailModelList`
  void removeLastDuctDetail(String? ductKey) {
    if (_ductDetailModelList != null && _ductDetailModelList!.isNotEmpty) {
      // var index = _ductDetailModelList.in
      Rx<FeedModel?> removeDuct =
          _ductDetailModelList!.lastWhere((x) => x!.key == ductKey).obs;
      _ductDetailModelList!.remove(removeDuct);
      ductReplyMap.removeWhere((key, value) => key == ductKey);
      cprint(
          "Last Duct removed from stack. Remaining Duct: ${_ductDetailModelList!.length}");
    }
  }

  /// [clear all ducts] if any duct present in duct detail page or comment duct
  void clearAllDetailAndReplyDuctStack() {
    if (_ductDetailModelList != null) {
      _ductDetailModelList!.clear();
    }
    ductReplyMap.clear();
    cprint('Empty ducts from stack');
  }

  /// [Subscribe Ducts] firebase Database
  Future<bool>? databaseInit() {
    // Stream<QuerySnapshot> _feedQuery;
    // try {
    //   if (_feedQuery == null) {
    //     _feedQuery = vDatabase.collection("duct").snapshots();
    //     _feedQuery.listen((event) {
    //       event.docChanges.forEach((element) {
    //         if (element.type == DocumentChangeType.added) {
    //           _onDuctAdded(element);
    //         } else if (element.type == DocumentChangeType.modified) {
    //           _onDuctChanged(element);
    //         } else if (element.type == DocumentChangeType.removed) {
    //           _onDuctRemoved(element);
    //         }
    //       });
    //     });

    //     // _feedQuery.onChildAdded.listen(_onDuctAdded);
    //     // _feedQuery.onValue.listen(_onDuctChanged);
    //     // _feedQuery.onChildRemoved.listen(_onDuctRemoved);
    //   }

    //  return Future(true);
    // } catch (error) {
    //   cprint(error, errorIn: 'databaseInit');
    //   return Future(false);
    // }
  }

  ///get products in ViewDucts matkets

  List<FeedModel>? getProductList(
      ViewductsUser? userModel,
      String? product,
      String? section,
      String? category,
      String? location,
      String? country,
      String? culture) {
    if (userModel == null) {
      return null;
    }

    List<FeedModel>? list;

    if (!isBusy && feedlist != null && feedlist!.isNotEmpty) {
      list = feedlist!.where((x) {
        /// If Duct is a comment then no need to add it in duct list
        if (x.parentkey != null &&
            x.childVductkey == null &&
            x.user!.userId != userModel.userId) {
          return false;
        }
        // if (x.caption == product
        // // &&
        // //     (x.productCategory == category &&
        // //         x.section == section &&
        // //         x.productLocation == country)

        //         ) {
        //   return true;
        // }

        /// Only include Ducted Products
        if (x.caption == product &&
                (x.productCategory == category &&
                    x.section == section &&
                    x.productLocation == country)
            //     ||
            //     x.productState == location ||
            //     x.culture == culture ||
            //     x.productLocation == country
            // //  ||
            //     (userModel?.viewingList != null &&
            //         userModel.viewingList.contains(x.user.userId))

            ) {
          return true;
        } else {
          return false;
        }
      }).toList();
      if (list.isEmpty) {
        list = null;
      }
    }
    return list;
  }

  /// get individual products in there store
  List<FeedModel>? getStoreProductList(String? userModel) {
    if (userModel == null) {
      return null;
    }

    List<FeedModel>? list;

    if (!isBusy && feedlist != null && feedlist!.isNotEmpty) {
      list = feedlist!.where((x) {
        /// If Duct is a comment then no need to add it in duct list
        if (x.parentkey != null &&
            x.childVductkey == null &&
            x.user!.userId != userModel) {
          return false;
        }

        /// Only include Ducts of logged-in user's and his following user's
        if (x.caption == 'product' && x.user!.userId == userModel
            //  ||
            //     (userModel?.viewingList != null &&
            //         userModel.viewingList.contains(x.user.userId))

            ) {
          return true;
        } else {
          return false;
        }
      }).toList();
      if (list.isEmpty) {
        list = null;
      }
    }
    return list;
  }

  List<FeedModel>? getAllProductList(String? userModel) {
    if (userModel == null) {
      return null;
    }

    List<FeedModel>? list;

    if (!isBusy && feedlist != null && feedlist!.isNotEmpty) {
      list = feedlist!.where((x) {
        /// If Duct is a comment then no need to add it in duct list
        if (x.parentkey != null &&
            x.childVductkey == null &&
            x.user!.userId != userModel) {
          return false;
        }

        /// Only include Ducts of logged-in user's and his following user's
        if (x.caption == 'product'
            //  ||
            //     (userModel?.viewingList != null &&
            //         userModel.viewingList.contains(x.user.userId))

            ) {
          return true;
        } else {
          return false;
        }
      }).toList();
      if (list.isEmpty) {
        list = null;
      }
    }
    return list;
  }

  List<FeedModel>? getSearchProductList(String? userModel) {
    if (userModel == null) {
      return null;
    }

    List<FeedModel>? list;

    if (!isBusy && feedlist != null && feedlist!.isNotEmpty) {
      list = feedlist!.where((x) {
        /// If Duct is a comment then no need to add it in duct list
        if (x.parentkey != null && x.childVductkey == null) {
          return false;
        }

        /// Only include Ducts of logged-in user's and his following user's
        if (x.productName == userModel && x.caption == 'product'
            //  ||
            //     (userModel?.viewingList != null &&
            //         userModel.viewingList.contains(x.user.userId))

            ) {
          return true;
        } else {
          return false;
        }
      }).toList();
      if (list.isEmpty) {
        list = null;
      }
    }
    return list;
  }

  Stream<AccountValueModel> getAccBalance()
      //{
      =>
      vDatabase
          .collection('accounts')
          .doc('${authState.userId}')
          .snapshots()
          .map((snapshot) => AccountValueModel.fromSnapshot(snapshot.data()));

  Stream<CountryModel> getCountryKeyword()
      //{
      =>
      vDatabase
          .collection('country')
          .doc('country')
          .snapshots()
          .map((snapshot) => CountryModel.fromSnapshot(snapshot.data()));
  Stream<KeyWordDuctModel> getKeyword()
      //{
      =>
      vDatabase
          .collection('keyWord')
          .doc('keyword')
          .snapshots()
          .map((snapshot) => KeyWordDuctModel.fromSnapshot(snapshot.data()));
  Stream<FeedModel> getStoryId(String? id) => vDatabase
      .collection('products')
      .doc(id)
      .snapshots()
      .map((snapshot) => FeedModel.fromJson(snapshot.data() as Map));
  getStoryChatsFromDatabase(String? storyId) async {
    final database = Databases(
      clientConnect(),
    );
    return database.listDocuments(
        databaseId: databaseId,
        collectionId: storyChtsId,
        queries: [query.Query.equal('storyId', storyId)]).then((data) {
      var value =
          data.documents.map((e) => ChatStoryModel.fromJson(e.data)).toList();
      storyChats = value.obs;
    });

    // kDatabase.child('storyChats/$storyId').endBefore('createdAt').onValue.map(
    //     (event) => event.snapshot.children
    //         .map((story) => ChatStoryModel.fromJson(story.value as Map))
    //         .toList());
  }

  getViews(String? storyId, String? userId) async {
    try {
      final database = Databases(
        clientConnect(),
      );
      await database.listDocuments(
          databaseId: databaseId,
          collectionId: storyuserviews,
          queries: [
            // query.Query.equal('userId', userId),
            query.Query.equal('storyId', storyId)
          ]).then((data) {
        var value =
            data.documents.map((e) => ViewsModel.fromJson(e.data)).toList();
        viewsNumber = value.obs;
      });
    } on query.AppwriteException catch (e) {
      cprint('$e');
    }

    // kDatabase.child('userViwed/$userId/$storyId').onValue.map((event) => event
    //     .snapshot.children
    //     .map((story) => ViewsModel.fromJson(story.value as Map))
    //     .toList());
  }

  getHeatLikes(String? storyId, String? userId) async {
    final database = Databases(
      clientConnect(),
    );
    await database.listDocuments(
        databaseId: databaseId,
        collectionId: heartLikes,
        queries: [
          //query.Query.equal('userId', storyId),
          query.Query.equal('storyId', storyId)
        ]).then((data) {
      var value =
          data.documents.map((e) => HeartViewsModel.fromJson(e.data)).toList();
      heartsView = value.obs;
    });
  }

  getHeatLikesNumber(String? storyId, String? userId) async {
    final database = Databases(
      clientConnect(),
    );
    return await database.listDocuments(
        databaseId: databaseId,
        collectionId: heartLikes,
        queries: [
          query.Query.equal('storyId', storyId),
          query.Query.equal('viewerId', userId),
        ]).then((data) {
      var value =
          data.documents.map((e) => HeartViewsModel.fromJson(e.data)).toList();
      heartsViewLikesNumber = value.obs;
    });
  }

  getMainUserViews(String? viewerId, String? viewductUser) async {
    final database = Databases(
      clientConnect(),
    );
    return await database.listDocuments(
        databaseId: databaseId,
        collectionId: mainUserViews,
        queries: [
          query.Query.equal('viewerId', viewerId),
          query.Query.equal('viewductUser', viewductUser),
        ]).then((data) {
      var value = data.documents
          .map((e) => MainUserViewsModel.fromJson(e.data))
          .toList();
      mainUserViers = value.obs;
    });

    //     =>
    // kDatabase.child('mainViews/$userId/$storyId').onValue.map((event) => event
    //     .snapshot.children
    //     .map((story) => MainUserViewsModel.fromJson(story.value as Map))
    //     .toList());
  }

  itsViewing(String? viewerId, String? viewductUser) async {
    final database = Databases(
      clientConnect(),
    );
    return await database.listDocuments(
        databaseId: databaseId,
        collectionId: mainUserViews,
        queries: [
          query.Query.equal('viewerId', viewerId),
          query.Query.equal('viewductUser', viewductUser),
        ]).then((data) {
      var value = data.documents
          .map((e) => MainUserViewsModel.fromJson(e.data))
          .toList();
      userViers = value.obs;
    });

    //     =>
    // kDatabase.child('mainViews/$userId/$storyId').onValue.map((event) => event
    //     .snapshot.children
    //     .map((story) => MainUserViewsModel.fromJson(story.value as Map))
    //     .toList());
  }

  Stream<List<DuctStoryModel>> getStoryFromDatabase(String? userId) => kDatabase
      .child('duct/$userId/ductStory/$userId/story')
      .orderByChild('date')
      .equalTo(DateFormat("E MMM d y")
          .format(Timestamp.now().toDate()
              // DateTime.fromMicrosecondsSinceEpoch(
              //   Timestamp.now().microsecondsSinceEpoch)
              )
          .toString())
      .onValue
      .map((event) => event.snapshot.children
          .map((story) => DuctStoryModel.fromMap(story.value as Map))
          .toList());
  // vDatabase
  //     .collection('ductStory')
  //     .doc(authState.userId)
  //     .collection('story')
  //     .orderBy('createdAt', descending: true)
  //     //  .doc()
  //     .snapshots()
  //     .map((query) => query.docs
  //         .map((item) => DuctStoryModel.fromMap(item.data()))
  //         .toList());
  //.map((snapshot) => StoryDuctViewModel.fromSnapshot(snapshot));
  Stream<List<FeedModel>> getProductFromDatabase()
      //{
      =>
      vDatabase.collection('products').snapshots().map((query) => query.docs
          .map((item) => FeedModel.fromJson(item.data() as Map))
          .toList());
  Stream<List<FeedModel>> getProductSelectionFromDatabase(
          String? country, String? state, String? section, String? category)
      //{
      =>
      vDatabase
          .collection('products')
          .where('productLocation', isEqualTo: country)
          .where('productState', isEqualTo: state)
          .where('section', isEqualTo: section)
          .where('productCategory', isEqualTo: category)
          .snapshots()
          .map((query) => query.docs
              .map((item) => FeedModel.fromJson(item.data()))
              .toList());
  Stream<List<FeedModel>> getViewductProductFromDatabase(
    String? keyword,
  )
      //{
      =>
      vDatabase
          .collection('products')
          .where('keyword', isEqualTo: keyword)
          .snapshots()
          .map((query) => query.docs
              .map((item) => FeedModel.fromJson(item.data()))
              .toList());
  Stream<List<ViewductsUser>> getadminProfileFromDatabase(
    String? keyword,
  )
      //{
      =>
      vDatabase
          .collection('profile')
          .where('displayName', isEqualTo: keyword)
          .limit(10)
          .snapshots()
          .map((query) {
        if (query.docs.isEmpty) {
          return query.docs.map((item) => ViewductsUser.fromJson({})).toList();
        }
        return query.docs
            .map((item) => ViewductsUser.fromJson(item.data()))
            .toList();
      });
  Stream<List<ViewductsUser>> getContactFromDatabase(
    String? keyword,
  )
      //{
      =>
      vDatabase
          .collection('profile')
          .where('displayName', isEqualTo: keyword)
          .snapshots()
          .map((query) {
        if (query.docs.isEmpty) {
          return query.docs.map((item) => ViewductsUser.fromJson({})).toList();
        }
        return query.docs
            .map((item) => ViewductsUser.fromJson(item.data()))
            .toList();
      });

  /// get [Duct list] from firebase realtime database
  Stream<List<FeedModel>> getDataFromDatabase()
      //{
      =>
      kDatabase
          .child('duct')
          .orderByChild('state')
          .equalTo(authState.userModel?.state)
          .onValue
          .map((event) => event.snapshot.children
              .map((p) => FeedModel.fromJson(p.value as Map))
              .toList());
  //     =>
  //     vDatabase.collection('duct').snapshots().map((query) =>
  //         query.docs.map((item) => FeedModel.fromJson(item.data())).toList());
  // // try {
  //   isBusy = true;
  //   feedlist = null;
  //   update();
  //   var data = vDatabase.collection('duct').limit(15);

  //   // if (_lastDuct != null) {
  //   //   data = data.startAfterDocument(_lastDuct);
  //   // }
  //   // if (!hasMoredata) return;

  //   data.snapshots().map((query) =>
  //       query.docs.map((item) => FeedModel.fromJson(item.data())).toList());
  // //   .listen((snapshot) {
  // //     feedlist = RxList<FeedModel>.empty();
  // //     if (snapshot.docs.isNotEmpty) {
  // //       var map = snapshot.docs;

  // //       map.forEach((value) {
  // //         var model = (FeedModel.fromJson(value.data())).obs;
  // //         model.value.key = value.id;

  // //         if (model.value.isValidDuct) {
  // //           feedlist!.add(model.value);
  // //         }
  // //       });

  // //       /// Sort Duct by time
  // //       /// It helps to display newest Duct first.
  // //       feedlist!.sort((x, y) => DateTime.parse(x.createdAt!)
  // //           .compareTo(DateTime.parse(y.createdAt!)));
  // //     } else {
  // //       feedlist = null;
  // //     }
  // //     isBusy = false;
  // //     update();
  // //   });

  // } catch (error) {
  //   isBusy = false;
  //   cprint(error, errorIn: 'getDataFromDatabase');
  // }

//  }

  void requestMoredata() => getDataFromDatabase();

  /// get [Duct Detail] from firebase realtime vDatabase
  /// If model is null then fetch duct from firebase
  /// [getpostDetailFromDatabase] is used to set prepare Ductr to display Duct detail
  /// After getting duct detail fetch duct coments from firebase
  void getpostDetailFromDatabase(String? ductID, {FeedModel? model}) async {
    try {
      FeedModel? _ductDetail;
      if (model != null) {
        // set duct data from duct list data.
        // No need to fetch duct from firebase db if data already present in duct list
        _ductDetail = model;
        setFeedModel = _ductDetail;
        ductID = model.key;
      } else {
        // Fetch duct data from firebase
        vDatabase.collection('duct').doc(ductID).get().then((snapshot) {
          var map = snapshot.data;
          _ductDetail = FeedModel.fromJson(map()!);
          _ductDetail!.key = snapshot.id;
          setFeedModel = _ductDetail;
        });
      }

      if (_ductDetail != null) {
        // Fetch comment ducts
        _commentlist;
        // Check if parent duct has reply ducts or not
        if (_ductDetail!.replyDuctKeyList != null &&
            _ductDetail!.replyDuctKeyList!.isNotEmpty) {
          _ductDetail!.replyDuctKeyList!.forEach((x) {
            if (x == null) {
              return;
            }
            vDatabase.collection('duct').doc(x).get().then((snapshot) {
              if (snapshot.data != null) {
                var commentmodel = (FeedModel.fromJson(snapshot.data()!)).obs;
                var key = snapshot.id;
                commentmodel.value.key = key;

                /// add comment duct to list if duct is not present in [comment duct ]list
                /// To reduce duplicacy
                if (!_commentlist.any((x) => x.key == key)) {
                  _commentlist.add(commentmodel.value);
                }
              } else {}
              if (x == _ductDetail!.replyDuctKeyList!.last) {
                /// Sort comment by time
                /// It helps to display newest Duct first.
                _commentlist.sort((x, y) => DateTime.parse(y.createdAt!)
                    .compareTo(DateTime.parse(x.createdAt!)));
                ductReplyMap.putIfAbsent(ductID, () => _commentlist);
                update();
              }
            });
          });
        } else {
          ductReplyMap.putIfAbsent(ductID, () => _commentlist);
          update();
        }
      }
    } catch (error) {
      cprint(error, errorIn: 'getpostDetailFromDatabase');
    }
  }

  /// Fetch `Vduct` model from firebase realtime vDatabase.
  /// Vduct itself  is a type of `Duct`
  Future<FeedModel> fetchDuct(String? ductID) async {
    late Rx<FeedModel> _ductDetail;

    /// If duct is availabe in feedlist then no need to fetch it from firebase
    if (feedlist!.any((x) => x.key == ductID)) {
      _ductDetail = feedlist!.firstWhere((x) => x.key == ductID).obs;
    }

    /// If duct is not available in feedlist then need to fetch it from firebase
    else {
      cprint("Fetched from DB: " + ductID!);
      dynamic model = await vDatabase.collection('duct').doc(ductID).get().then(
        (snapshot) {
          var map = snapshot.data;
          _ductDetail = (FeedModel.fromJson(map()!)).obs;
          _ductDetail.value.key = snapshot.id;
          if (kDebugMode) {
            print(_ductDetail.value.ductComment);
          }
        },
      );
      if (model != null) {
        _ductDetail = model;
      } else {
        cprint("Fetched null value from  DB");
      }
    }
    return _ductDetail.value;
  }

  addProductReviews(String reviewComment, int rating, String productId,
      String senderName) async {
    FToast().init(Get.context!);
    try {
      String _multiChannelName;

      // List<String> list = [
      //   currentUser.substring(4, 15),
      //   secondUser.substring(4, 15)
      // ];
      // list.sort();
      _multiChannelName =
          '${authState.appUser?.$id.substring(4, 15)}-${productId.substring(4, 15)}';
      final database = Databases(
        clientConnect(),
      );
      database.listDocuments(
          databaseId: databaseId,
          collectionId: productReviews,
          queries: [
            query.Query.equal('key', _multiChannelName.toString())
          ]).then((data) async {
        if (data.documents.isNotEmpty) {
          await database.updateDocument(
            databaseId: databaseId,
            collectionId: productReviews,
            documentId: _multiChannelName.toString(),
            data: {
              'reviewComment': reviewComment,
              'rating': rating,
              'productId': productId,
              'senderName': senderName,
              'userId': authState.appUser?.$id.toString(),
              'key': _multiChannelName.toString()
            },
          );
          FToast().showToast(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                    // width:
                    //    Get.width * 0.3,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 11),
                              blurRadius: 11,
                              color: Colors.black.withOpacity(0.06))
                        ],
                        borderRadius: BorderRadius.circular(18),
                        color: CupertinoColors.lightBackgroundGray),
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Your Review is been Updated',
                      style: TextStyle(
                          color: CupertinoColors.systemOrange,
                          fontWeight: FontWeight.w900),
                    )),
              ),
              gravity: ToastGravity.TOP_RIGHT,
              toastDuration: Duration(seconds: 4));
        } else {
          await database.createDocument(
            databaseId: databaseId,
            collectionId: productReviews,
            documentId: _multiChannelName.toString(),
            data: {
              'reviewComment': reviewComment,
              'rating': rating,
              'productId': productId,
              'senderName': senderName,
              'userId': authState.appUser?.$id.toString(),
              'key': _multiChannelName.toString()
            },
          );
          FToast().showToast(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                    // width:
                    //    Get.width * 0.3,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 11),
                              blurRadius: 11,
                              color: Colors.black.withOpacity(0.06))
                        ],
                        borderRadius: BorderRadius.circular(18),
                        color: CupertinoColors.lightBackgroundGray),
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Your Review is been added thanks!',
                      style: TextStyle(
                          color: CupertinoColors.darkBackgroundGray,
                          fontWeight: FontWeight.w900),
                    )),
              ),
              gravity: ToastGravity.TOP_RIGHT,
              toastDuration: Duration(seconds: 4));
        }
      });
    } on AppwriteException catch (e) {
      cprint(e);
    }
  }

  /// create [New Duct]
  createDuct(FeedModel model, {String? key}) async {
    ///  Create duct in [Firebase vDatabase]
    isBusy = true;
    update();
    try {
      final database = Databases(
        clientConnect(),
      );
      database.listDocuments(
          databaseId: databaseId,
          collectionId: dctCollid,
          queries: [
            query.Query.equal('key', key.toString())
          ]).then((data) async {
        if (data.documents.isNotEmpty) {
          await database.updateDocument(
            databaseId: databaseId,
            collectionId: dctCollid,
            documentId: key.toString(),
            data: model.toJson(),
          );
        } else {
          await database.createDocument(
            databaseId: databaseId,
            collectionId: dctCollid,
            documentId: key.toString(),
            data: model.toJson(),
          );
        }
      });

      // kDatabase.child('duct/${authState.userId}').update(model.toJson());
      // vDatabase.runTransaction((transaction) async {
      //   CollectionReference reference = vDatabase.collection('duct');
      //   await reference.doc(authState.userId).set(model.toJson());
      // });
    } on AppwriteException catch (error) {
      cprint(error, errorIn: 'createDuct');
    }
    isBusy = false;
    update();
  }

  removeDuct() async {
    try {
      //var key = kDatabase.child('ductStory/$secondUser/story/$storyId').key;
      kDatabase.child('duct/${authState.userId}').remove();
      kDatabase.child('userheartLikes/${authState.userId}').remove();
      kDatabase.child('userViwed/${authState.userId}/$storyId').remove();
    } catch (error) {
      cprint(error);
    }
  }

  createProDuctItems(FeedModel model, {String? key}) async {
    ///  Create duct in [Firebase vDatabase]
    isBusy = true;
    update();
    try {
      final database = Databases(
        clientConnect(),
      );

      await database.createDocument(
        databaseId: databaseId,
        collectionId: procold,
        documentId: key.toString(),
        permissions: [Permission.read(Role.users())],
        data: model.toJson(),
      );
      await database.listDocuments(
          databaseId: databaseId,
          collectionId: keyWordsColl,
          queries: [
            query.Query.equal('keyword', model.keyword),
          ]).then((data) async {
        if (data.documents.isEmpty) {
          await database.createDocument(
            databaseId: databaseId,
            collectionId: keyWordsColl,
            documentId: 'unique()',
            data: ({
              "keyword": model.keyword,
            }),
          );
        } else {}
      });
      // vDatabase.runTransaction((transaction) async {
      //   vDatabase.collection('products').doc('$key').set(model.toJson());
      //   // .then((doc) {
      //   //   vDatabase.collection('products').doc(doc.id).update({'key': doc.id});
      //   // });
      // });
    } catch (error) {
      cprint(error, errorIn: 'createProDuct');
    }
    isBusy = false;
    update();
  }

  updateProDuctItems(FeedModel model, {String? key}) async {
    ///  Create duct in [Firebase vDatabase]
    isBusy = true;
    update();
    try {
      final database = Databases(
        clientConnect(),
      );

      await database.updateDocument(
        databaseId: databaseId,
        collectionId: procold,
        documentId: key.toString(),
        permissions: [Permission.read(Role.users())],
        data: model.toJson(),
      );

      // vDatabase.runTransaction((transaction) async {
      //   vDatabase.collection('products').doc('$key').set(model.toJson());
      //   // .then((doc) {
      //   //   vDatabase.collection('products').doc(doc.id).update({'key': doc.id});
      //   // });
      // });
    } catch (error) {
      cprint(error, errorIn: 'createProDuct');
    }
    isBusy = false;
    update();
  }

  createDuctStory(DuctStoryModel model, {String? key}) async {
    ///  Create duct in [Firebase vDatabase]
    isBusy = true;
    update();
    // ignore: prefer_const_constructors
    // var id = Uuid().v1();
    try {
      final database = Databases(
        clientConnect(),
      );

      await database.createDocument(
        databaseId: databaseId,
        collectionId: storyCollId,
        documentId: key.toString(),
        permissions: [Permission.read(Role.users())],
        data: model.toJson(),
      );
      // var key = kDatabase
      //     .child(
      //         'duct/${authState.userId}/ductStory/${authState.userId}/story/$id')
      //     .key;
      // kDatabase
      //     .child(
      //         'duct/${authState.userId}/ductStory/${authState.userId}/story/$key')
      //     //.push()
      //     .update(model.toJson());
      // kDatabase
      //     .child(
      //         'duct/${authState.userId}/ductStory/${authState.userId}/story/$key')
      //     //.push()
      //     .update({
      //   'key': key,
      // });
      // vDatabase.runTransaction((transaction) async {
      //   CollectionReference reference = vDatabase.collection('ductStory');
      //   await reference
      //       .doc(authState.userId)
      //       .collection('story')
      //       .doc(model.key)
      //       .set(model.toJson());
      //   //       .set({
      //   //     'userId': authState.userId,
      //   //     "products": FieldValue.arrayUnion([model.toJson()]),
      //   //   }, SetOptions(merge: true));
      // });
    } on AppwriteException catch (error) {
      cprint(error, errorIn: 'createDuct');
    }
    isBusy = false;
    update();
  }

  createSearchKeyWord(String? model) {
    ///  Create duct in [Firebase vDatabase]
    isBusy = true;
    update();
    try {
      vDatabase.runTransaction((transaction) async {
        CollectionReference reference = vDatabase.collection('keyWord');
        await reference.doc('keyword').set(
            {
              'key': FieldValue.arrayUnion([model])
            },
            SetOptions(
              merge: true,
            ));
        //       .set({
        //     'userId': authState.userId,
        //     "products": FieldValue.arrayUnion([model.toJson()]),
        //   }, SetOptions(merge: true));
      });
    } catch (error) {
      cprint(error, errorIn: 'createDuct');
    }
    isBusy = false;
    update();
  }

  addUserSeenStoryView(String? storyId, String? userId) async {
    ///  Create duct in [Firebase vDatabase]
    // isBusy = true;
    // update();
    // String _multiChannelName;
    // var id = Uuid().v1();
    // // List<String> list = [
    // //   currentUser.substring(4, 15),
    // //   secondUser.substring(4, 15)
    // // ];
    // // list.sort();
    // _multiChannelName =
    //     '${authState.appUser!.$id.substring(4, 15)}-${storyId!.substring(4, 15)}';
    try {
      final database = Databases(
        clientConnect(),
      );
      database.listDocuments(
          databaseId: databaseId,
          collectionId: storyuserviews,
          queries: [
            query.Query.equal('storyId', storyId.toString()),
            query.Query.equal('senderId', authState.appUser!.$id.toString()),
          ]).then((data) async {
        if (data.documents.isEmpty) {
          await database.createDocument(
            databaseId: databaseId,
            collectionId: storyuserviews,
            documentId: 'unique()',
            data: ({
              "storyId": storyId,
              "userId": userId,
              "senderId": authState.userModel?.userId,
              "senderName": authState.userModel!.displayName,
              "senderImage": authState.userModel!.profilePic
            }),
          );
          cprint('story seen by me $storyId');
        } else {
          cprint('story seen already $storyId');
        }
      });

      // var key = kDatabase.child('ductStory/$storyDuctId/story/$id').key;
      // kDatabase.child('ductStory/$storyDuctId/story/$key')
      //     //.push()
      //     .update({
      //   'userViwed': [authState.userId]
      // });
      // kDatabase.child('userViwed/$userId/$storyId/${authState.userId}')
      //     //.push()
      //     .update({
      //   "senderid": authState.userModel?.userId,
      //   "senderName": authState.userModel!.displayName,
      //   "senderImage": authState.userModel!.profilePic
      // });
      // vDatabase.runTransaction((transaction) async {
      //   CollectionReference reference = vDatabase.collection('keyWord');
      //   await reference.doc('keyword').set(
      //       {
      //         'key': FieldValue.arrayUnion([id])
      //       },
      //       SetOptions(
      //         merge: true,
      //       ));
      //   //       .set({
      //   //     'userId': authState.userId,
      //   //     "products": FieldValue.arrayUnion([model.toJson()]),
      //   //   }, SetOptions(merge: true));
      // });
    } on query.AppwriteException catch (error) {
      cprint(error, errorIn: 'userViewd');
    }
    // isBusy = false;
    // update();
  }

  viewUser(String? viewerId, {String? viewductUser}) async {
    ///  Create duct in [Firebase vDatabase]
    isBusy = true;
    update();
    try {
      final id =
          '${viewerId?.splitByLength((viewerId.length) ~/ 2)[0]}_${viewductUser?.splitByLength((viewductUser.length) ~/ 2)[0]}';
      final database = Databases(
        clientConnect(),
      );
      await database.listDocuments(
          databaseId: databaseId,
          collectionId: mainUserViews,
          queries: [
            query.Query.equal('key', id),
            // query.Query.equal('userId', secondUser)
          ]).then((data) async {
        if (data.documents.isEmpty) {
          await database.createDocument(
            databaseId: databaseId,
            collectionId: mainUserViews,
            documentId: id,
            permissions: [Permission.read(Role.users())],
            data: ({
              "key": id,
              "viewerId": authState.userModel?.userId,
              "viewductUser": viewductUser,
              "createdAt": Timestamp.now().toDate().toString(),
            }),
          );
        }
      });

      // kDatabase.child('mainViews/$viewrId/${authState.userId}')
      //     //.push()
      //     .update({
      //   "viewerId": authState.userModel?.userId,
      // });
    } catch (error) {
      cprint(error, errorIn: 'viewUser');
    }
    isBusy = false;
    update();
  }

  addHearts(
    String? storyId,
    String? secondUser,
  ) async {
    try {
      final id =
          '${storyId!.splitByLength((storyId.length) ~/ 2)[0]}_${secondUser!.splitByLength((secondUser.length) ~/ 2)[0]}';
      final database = Databases(
        clientConnect(),
      );

      await database.listDocuments(
          databaseId: databaseId,
          collectionId: heartLikes,
          queries: [
            query.Query.equal('storyId', storyId),
            query.Query.equal('userId', secondUser)
          ]).then((data) async {
        if (data.documents.isEmpty) {
          await database.createDocument(
            databaseId: databaseId,
            collectionId: heartLikes,
            documentId: '$id',
            permissions: [Permission.read(Role.users())],
            data: ({
              "viewerId": '${authState.userModel?.userId}',
              "storyId": '$storyId',
              "userId": '$secondUser',
            }),
          );
        }
      });
      //var key = kDatabase.child('ductStory/$secondUser/story/$storyId').key;
      // kDatabase.child('userheartLikes/$secondUser/$storyId/${authState.userId}')
      //     //.push()
      //     .update({'viewerId': authState.userId});
    } on AppwriteException catch (error) {
      cprint('$error addHearts');
    }
  }

  removeHearts(
    String? storyId,
    String? secondUser,
  ) async {
    try {
      final id =
          '${storyId!.splitByLength((storyId.length) ~/ 2)[0]}_${secondUser!.splitByLength((secondUser.length) ~/ 2)[0]}';
      final database = Databases(
        clientConnect(),
      );

      await database.deleteDocument(
        databaseId: databaseId,
        collectionId: heartLikes,
        documentId: '$id',
      );
      // kDatabase
      //     .child('userheartLikes/$secondUser/$storyId/${authState.userId}')
      //     .remove();
    } catch (error) {
      cprint(error);
    }
  }

  deletViewUser(String? viewerId, ViewductsUser? user) async {
    FToast().init(Get.context!);
    final id =
        '${authState.appUser!.$id.splitByLength((authState.appUser!.$id.length) ~/ 2)[0]}_${viewerId!.splitByLength((viewerId.length) ~/ 2)[0]}';
    isBusy = true;
    update();
    try {
      final database = Databases(
        clientConnect(),
      );
      await database.deleteDocument(
          databaseId: databaseId, collectionId: mainUserViews, documentId: id);
      FToast().showToast(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
                // width:
                //    Get.width * 0.3,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          offset: const Offset(0, 11),
                          blurRadius: 11,
                          color: Colors.black.withOpacity(0.06))
                    ],
                    borderRadius: BorderRadius.circular(18),
                    color: CupertinoColors.systemRed),
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  'You Stoped Viewing ${user!.displayName}',
                  style: TextStyle(
                      color: CupertinoColors.darkBackgroundGray,
                      fontWeight: FontWeight.w900),
                )),
          ),
          gravity: ToastGravity.TOP_LEFT,
          toastDuration: Duration(seconds: 3));
    } on AppwriteException catch (error) {
      cprint(error, errorIn: 'deletViewUser');
    }
    isBusy = false;
    update();
  }

  createCountry(
    String? id,
    String? model,
  ) {
    ///  Create duct in [Firebase vDatabase]
    isBusy = true;
    update();
    try {
      vDatabase.runTransaction((transaction) async {
        CollectionReference reference = vDatabase.collection('country');
        await reference.doc('country').set(
            {
              'userId': id,
              'country': FieldValue.arrayUnion([model])
            },
            SetOptions(
              merge: true,
            ));
        //       .set({
        //     'userId': authState.userId,
        //     "products": FieldValue.arrayUnion([model.toJson()]),
        //   }, SetOptions(merge: true));
      });
    } catch (error) {
      cprint(error, errorIn: 'createDuct');
    }
    isBusy = false;
    update();
  }

  createAccountValues({int? balance, int? withdrawed, int? sales}) {
    ///  Create duct in [Firebase vDatabase]
    isBusy = true;
    update();
    try {
      vDatabase.runTransaction((transaction) async {
        CollectionReference reference = vDatabase.collection('accounts');
        await reference.doc(authState.userId).set(
            {'balance': balance, 'withdrawed': withdrawed, 'sales': sales},
            SetOptions(
              merge: true,
            ));
        //       .set({
        //     'userId': authState.userId,
        //     "products": FieldValue.arrayUnion([model.toJson()]),
        //   }, SetOptions(merge: true));
      });
    } catch (error) {
      cprint(error, errorIn: 'createDuct');
    }
    isBusy = false;
    update();
  }

  createProduct(ProductModel productModel, String? uid, String? section,
      String? category) {
    ///  Create duct in [Firebase vDatabase]
    isBusy = true;
    update();
    try {
      vDatabase.runTransaction((transaction) async {
        CollectionReference reference = vDatabase.collection('product');
        await reference.doc(uid).collection('$section').doc(category).set(
            {
              'products': FieldValue.arrayUnion([productModel.toJson()])
            },
            SetOptions(
              merge: true,
            ));
      });
    } catch (error) {
      cprint(error, errorIn: 'createProduct');
    }
    isBusy = false;
    update();
  }

  ///  It will create duct in [Firebase vDatabase] just like other normal duct.
  ///  update Vduct count for Vduct model
  createvDuct(FeedModel model) {
    try {
      createDuct(model);
      //  _ductToReplyModel!.value!.vductCount += 1;
      updateDuct(_ductToReplyModel!.value);
      cprint("vDucted this Product");
    } catch (error) {
      cprint(error, errorIn: 'createReDuct');
    }
  }

  /// [Delete duct] in Firebase vDatabase
  /// Remove Duct if present in home page Duct list
  /// Remove Duct if present in Duct detail page or in comment
  deleteDuct(String? ductId, DuctType type, {String? parentkey}) {
    try {
      /// Delete duct if it is in nested duct detail page
      vDatabase.runTransaction((transaction) async {
        await vDatabase.collection('duct').doc(ductId).delete().then((_) {
          if (type == DuctType.Detail &&
              _ductDetailModelList != null &&
              _ductDetailModelList!.isNotEmpty) {
            // var deletedDuct =
            //     _ductDetailModelList.firstWhere((x) => x.key == ductId);
            _ductDetailModelList!.remove(_ductDetailModelList);
            if (_ductDetailModelList!.isEmpty) {
              _ductDetailModelList = null;
            }

            cprint('Duct deleted from nested duct detail page duct');
          }
          return;
        });
      });
    } catch (error) {
      cprint(error, errorIn: 'deleteDuct');
    }
  }

  /// upload [file] to firebase storage and return its  path url
  Future<String?> uploadFile(File file) async {
    try {
      // isBusy = true;
      // update();
      // Reference storageReference = FirebaseStorage.instance
      //     .ref()
      //     .child('productImage${Path.basename(file.path)}');
      // UploadTask uploadTask = storageReference.putFile(file);
      // var snapshot = await uploadTask;
      // if (snapshot != null) {
      //   var url = await storageReference.getDownloadURL();
      //   if (url != null) {
      //     return url;
      //   }
      // }
    } catch (error) {
      cprint(error, errorIn: 'uploadFile');
      return null;
    }
  }

  Future<String?> uploadChatFile(File file) async {
    try {
      // isBusy = true;
      // update();
      // Reference storageReference = FirebaseStorage.instance
      //     .ref()
      //     .child('chatImage${Path.basename(file.path)}');
      // UploadTask uploadTask = storageReference.putFile(file);
      // var snapshot = await uploadTask;
      // if (snapshot != null) {
      //   var url = await storageReference.getDownloadURL();
      //   if (url != null) {
      //     return url;
      //   }
      // }
    } catch (error) {
      cprint(error, errorIn: 'uploadFile');
      return null;
    }
  }

  /// [Delete file] from firebase storage
  Future<void> deleteFile(String url, String baseUrl) async {
    try {
      String filePath = url.replaceAll(
          RegExp(
              r'https://firebasestorage.googleapis.com/v0/b/twitter-clone-4fce9.appspot.com/o/'),
          '');
      filePath = filePath.replaceAll(RegExp(r'%2F'), '/');
      filePath = filePath.replaceAll(RegExp(r'(\?alt).*'), '');
      //  filePath = filePath.replaceAll('productImage/', '');
      //  cprint('[path]'+filePath);
      Reference storageReference = FirebaseStorage.instance.ref();
      await storageReference.child(filePath).delete().catchError((val) {
        cprint('[Error]' + val);
      }).then((_) {
        cprint('[Sucess] Image deleted');
      });
    } catch (error) {
      cprint(error, errorIn: 'deleteFile');
    }
  }

  /// [update] duct
  updateDuct(FeedModel? model) async {
    vDatabase.runTransaction((transaction) async {
      DocumentReference reference =
          vDatabase.collection('duct').doc(model!.key);
      transaction.set(
          reference,
          model.toJson(),
          SetOptions(
            merge: true,
          ));
    });
  }

  /// Add/Remove like on a Duct
  /// [postId] is duct id, [userId] is user's id who like/unlike Duct
  addLikeToDuct(FeedModel duct, String? userId, String? key) {
    try {
      if (duct.likeList != null &&
          duct.likeList!.isNotEmpty &&
          duct.likeList!.any((id) => id == userId)) {
        // If user wants to undo/remove his like on duct
        duct.likeList!.removeWhere((id) => id == userId);
        duct.likeCount = duct.likeList!.length;
        //duct.likeCount -= 1;
      } else {
        // If user like Duct
        duct.likeList ??= [];
        duct.likeList!.add(userId);
        duct.likeCount = duct.likeList!.length;
        //duct.likeCount += 1;
      }
      // update likelist of a duct
      vDatabase.runTransaction((transaction) async {
        CollectionReference reference = vDatabase.collection('duct');
        await reference.doc(key).update(
          {'likeList': duct.likeList, 'likeCount': duct.likeCount},
          // SetOptions(
          //   merge: true,
          // )
        );
      });

      // Sends notification to user who created duct
      // ViewductsUser owner can see notification on notification page
      vDatabase.runTransaction((transaction) async {
        // CollectionReference reference = vDatabase.collection('notification');
        // await reference.
        vDatabase.collection('notification').doc('$key').set(
            {
              key.toString(): {
                'type': duct.likeList!.isEmpty
                    ? null
                    : NotificationType.Like.toString(),
                'updatedAt': duct.likeList!.isEmpty
                    ? null
                    : DateTime.now().toUtc().toString(),
              }
            },
            SetOptions(
              merge: true,
            ));
      });
    } catch (error) {
      cprint(error, errorIn: 'addLikeToDuct');
    }
  }

  /// Add [new comment duct] to any duct
  /// Comment is a Duct itself
  addcommentToPost(FeedModel replyDuct) {
    try {
      isBusy = true;
      update();
      if (_ductToReplyModel != null) {
        Rx<FeedModel> duct = feedlist!
            .firstWhere((x) => x.key == _ductToReplyModel!.value!.key)
            .obs;
        var json = replyDuct.toJson();
        vDatabase.runTransaction((transaction) async {
          CollectionReference reference = vDatabase.collection('duct');
          await reference.doc(replyDuct.ductId).set(json).then((value) {
            duct.value.replyDuctKeyList!.add(feedlist!.last.key);
            updateDuct(duct.value);
          });
        });
      }
    } catch (error) {
      cprint(error, errorIn: 'addcommentToPost');
    }
    isBusy = false;
    update();
  }

  ///adding products by sellers
  String childreRef = 'childrenCategories';

  // void createChildrenCategory(String name) {
  //   var id = const Uuid();
  //   String childrencategoryId = id.v1();

  //   vDatabase
  //       .collection(childreRef)
  //       .doc(childrencategoryId)
  //       .set({'childrenCategory': name, 'key': authState.userId});
  // }

  getChildrenCategories() async {
    try {
      final database = Databases(
        clientConnect(),
      );
      final snap = await database.listDocuments(
          databaseId: databaseId, collectionId: childrenCollection);
      return snap.documents;
    } on AppwriteException catch (e) {
      cprint('$e.code');

      //}
    }
  }

  // =>
  //     vDatabase.collection(childreRef).get().then((snaps) {
  //       if (kDebugMode) {
  //         print(snaps.docs.length);
  //       }

  //       return snaps.docs;
  //     });

  Future<List<DocumentSnapshot>> getChildrenSuggestions(String suggestion) =>
      vDatabase
          .collection(childreRef)
          .where('childrenCategory', isEqualTo: suggestion)
          .get()
          .then((snap) {
        return snap.docs;
      });
  String electronicsRef = 'electronicsCategories';

  void createElectronicsCategory(String name) {
    var id = const Uuid();
    String electronicscategoryId = id.v1();

    vDatabase
        .collection(electronicsRef)
        .doc(electronicscategoryId)
        .set({'electronicsCategory': name, 'key': authState.userId});
  }

  getElectronicsCategories() async {
    try {
      final database = Databases(
        clientConnect(),
      );
      final snap = await database.listDocuments(
          databaseId: databaseId, collectionId: electronicsCollection);
      return snap.documents;
    } on AppwriteException catch (e) {
      cprint('$e');
    }
  }
  //=>
  // vDatabase.collection(electronicsRef).get().then((snaps) {
  //   if (kDebugMode) {
  //     print(snaps.docs.length);
  //   }

  //   return snaps.docs;
  // });

  Future<List<DocumentSnapshot>> getElectronicsSuggestions(String suggestion) =>
      vDatabase
          .collection(electronicsRef)
          .where('electronicsCategory', isEqualTo: suggestion)
          .get()
          .then((snap) {
        return snap.docs;
      });
  String fashionRef = 'fashionCategories';

  void createFashionCategory(String name) {
    var id = const Uuid();
    String fashioncategoryId = id.v1();

    vDatabase
        .collection(fashionRef)
        .doc(fashioncategoryId)
        .set({'fashionCategory': name, 'key': authState.userId});
  }

  getFashionCategories() async {
    try {
      final database = Databases(
        clientConnect(),
      );
      final snap = await database.listDocuments(
          databaseId: databaseId, collectionId: fashionCollection);
      return snap.documents;
    } on AppwriteException catch (e) {
      cprint('$e');
    }
  }
  //  =>
  //   vDatabase.collection(fashionRef).get().then((snaps) {
  //     if (kDebugMode) {
  //       print(snaps.docs.length);
  //     }

  //     return snaps.docs;
  //   });

  Future<List<DocumentSnapshot>> getFashionSuggestions(String suggestion) =>
      vDatabase
          .collection(fashionRef)
          .where('fashionCategory', isEqualTo: suggestion)
          .get()
          .then((snap) {
        return snap.docs;
      });

  String groceriesRef = 'groceryCategories';

  void createGroceriesCategory(String name) {
    var id = const Uuid();
    String grocerycategoryId = id.v1();

    vDatabase
        .collection(groceriesRef)
        .doc(grocerycategoryId)
        .set({'groceryCategory': name, 'key': authState.userId});
  }

  getGroceriesCategories() async {
    try {
      final database = Databases(
        clientConnect(),
      );
      final snap = await database.listDocuments(
          databaseId: databaseId, collectionId: groceryCollection);
      return snap.documents;
    } on AppwriteException catch (e) {
      cprint('$e');
    }
  }

  //  =>
  //     vDatabase.collection(groceriesRef).get().then((snaps) {
  //       if (kDebugMode) {
  //         print(snaps.docs.length);
  //       }

  //       return snaps.docs;
  //     });

  Future<List<DocumentSnapshot>> getGroceriesSuggestions(String suggestion) =>
      vDatabase
          .collection(groceriesRef)
          .where('groceryCategory', isEqualTo: suggestion)
          .get()
          .then((snap) {
        return snap.docs;
      });

  String booksRef = 'booksCategories';

  void createBooksCategory(String name, String imagePath) async {
    // var id = const Uuid();
    // String bookscategoryId = id.v1();

    // vDatabase.collection(booksRef).doc(bookscategoryId).set(
    //     {'image': imagePath, 'booksCategory': name, 'key': authState.userId});
    final database = Databases(
      clientConnect(),
    );

    await database.createDocument(
      databaseId: databaseId,
      collectionId: booksCollection,
      documentId: "unique()",
      permissions: [Permission.read(Role.users())],
      data: {
        'image': imagePath,
        'booksCategory': name,
        'key': authState.userId
      },
    );
  }

  getBooksCategories() async {
    try {
      final database = Databases(
        clientConnect(),
      );
      final snap = await database.listDocuments(
          databaseId: databaseId, collectionId: booksCollection);
      return snap.documents;
    } on query.AppwriteException catch (e) {
      cprint('$e');
    }
  }
  //  =>
  //     vDatabase.collection(booksRef).get().then((snaps) {
  //       if (kDebugMode) {
  //         print(snaps.docs.length);
  //       }

  //       return snaps.docs;
  //     });

  Future<List<DocumentSnapshot>> getBooksSuggestions(String suggestion) =>
      vDatabase
          .collection(booksRef)
          .where('booksCategory', isEqualTo: suggestion)
          .get()
          .then((snap) {
        return snap.docs;
      });
  String housingRef = 'housingCategories';

  void createHousingCategory(String name, String imagePath) async {
    // var id = const Uuid();
    // String housingcategoryId = id.v1();

    // vDatabase.collection(housingRef).doc(housingcategoryId).set(
    //     {'image': imagePath, 'housingCategory': name, 'key': authState.userId});
    final database = Databases(
      clientConnect(),
    );

    await database.createDocument(
      databaseId: databaseId,
      collectionId: housingCollection,
      documentId: "unique()",
      permissions: [Permission.read(Role.users())],
      data: {
        'image': imagePath,
        'housingCategory': name,
        'key': authState.userId
      },
    );
  }

  getCarsCategories() async {
    try {
      final database = Databases(
        clientConnect(),
      );
      final snap = await database.listDocuments(
          databaseId: databaseId, collectionId: carsCollection);
      return snap.documents;
    } on query.AppwriteException catch (e) {
      cprint('$e');
    }
  }

  void createCarsCategory(String name, String imagePath) async {
    // var id = const Uuid();
    // String farmcategoryId = id.v1();

    // vDatabase.collection(farmRef).doc(farmcategoryId).set(
    //     {'image': imagePath, 'farmCategory': name, 'key': authState.userId});
    final database = Databases(
      clientConnect(),
    );

    await database.createDocument(
      databaseId: databaseId,
      collectionId: carsCollection,
      documentId: "unique()",
      permissions: [Permission.read(Role.users())],
      data: {'image': imagePath, 'carsCategory': name, 'key': authState.userId},
    );
  }

  getHousingCategories() async {
    try {
      final database = Databases(
        clientConnect(),
      );
      final snap = await database.listDocuments(
          databaseId: databaseId, collectionId: housingCollection);
      return snap.documents;
    } on query.AppwriteException catch (e) {
      cprint('$e');
    }
  }
  // =>
  //     vDatabase.collection(housingRef).get().then((snaps) {
  //       if (kDebugMode) {
  //         print(snaps.docs.length);
  //       }

  //       return snaps.docs;
  //     });

  Future<List<DocumentSnapshot>> getHousingSuggestions(String suggestion) =>
      vDatabase
          .collection(housingRef)
          .where('housingCategory', isEqualTo: suggestion)
          .get()
          .then((snap) {
        return snap.docs;
      });
  String farmRef = 'farmCategories';

  void createFarmCategory(String name, String imagePath) async {
    // var id = const Uuid();
    // String farmcategoryId = id.v1();

    // vDatabase.collection(farmRef).doc(farmcategoryId).set(
    //     {'image': imagePath, 'farmCategory': name, 'key': authState.userId});
    final database = Databases(
      clientConnect(),
    );

    await database.createDocument(
      databaseId: databaseId,
      collectionId: farmCollection,
      documentId: "unique()",
      permissions: [Permission.read(Role.users())],
      data: {'image': imagePath, 'farmCategory': name, 'key': authState.userId},
    );
  }

  getFarmCategories() async {
    try {
      final database = Databases(
        clientConnect(),
      );
      final snap = await database.listDocuments(
          databaseId: databaseId, collectionId: farmCollection);
      return snap.documents;
    } on query.AppwriteException catch (e) {
      cprint('$e');
    }
  }
  // =>
  //     vDatabase.collection(farmRef).get().then((snaps) {
  //       if (kDebugMode) {
  //         print(snaps.docs.length);
  //       }

  //       return snaps.docs;
  //     });

  Future<List<DocumentSnapshot>> getFarmSuggestions(String suggestion) =>
      vDatabase
          .collection(farmRef)
          .where('farmCategory', isEqualTo: suggestion)
          .get()
          .then((snap) {
        return snap.docs;
      });
  String sectionRef = 'section';

  void createSection(String name) async {
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
      permissions: [Permission.read(Role.users())],
      data: {'section': name, 'key': authState.userId},
    );
  }

  getSections() async {
    try {
      final database = Databases(
        clientConnect(),
      );
      final snap = await database.listDocuments(
          databaseId: databaseId, collectionId: sectionCollection);
      return snap.documents;
    } on AppwriteException catch (e) {
      cprint('$e');
    }
  }
  //  =>
  //     vDatabase.collection(sectionRef).get().then((snaps) {
  //       if (kDebugMode) {
  //         print(snaps.docs.length);
  //       }
  //       return snaps.docs;
  //     });

  Future<List<DocumentSnapshot>> getSuggestions(String suggestion) => vDatabase
          .collection(sectionRef)
          .where('section', isEqualTo: suggestion)
          .get()
          .then((snap) {
        return snap.docs;
      });
  String tyepRef = 'type';

  void createType(String name) {
    var id = const Uuid();
    String typeId = id.v1();

    vDatabase
        .collection(tyepRef)
        .doc(typeId)
        .set({'type': name, 'key': authState.userId});
  }

  getTypes() async {
    final database = Databases(
      clientConnect(),
    );
    final snap = await database.listDocuments(
        databaseId: databaseId, collectionId: typeCollection);
    return snap.documents;
  }
  //  =>
  //     vDatabase.collection(tyepRef).get().then((snaps) {
  //       if (kDebugMode) {
  //         print(snaps.docs.length);
  //       }
  //       return snaps.docs;
  //     });

  Future<List<DocumentSnapshot>> getTypeSuggestions(String suggestion) =>
      vDatabase
          .collection(tyepRef)
          .where('type', isEqualTo: suggestion)
          .get()
          .then((snap) {
        return snap.docs;
      });

  ///products

  final Map<int, int> _productsInCart = <int, int>{};

  @override
  Map<int, int> get productsInCart => Map<int, int>.from(_productsInCart);

  // Total number of items in the cart.
  @override
  int get totalCartQuantity =>
      _productsInCart.values.fold(0, (int v, int e) => v + e);

  // Removes everything from the cart.
  @override
  void clearCart() {
    _productsInCart.clear();
    update();
  }

  void productToCart(FeedModel ductId) {
    if (!_productsInCart.containsKey(ductId)) {
      _productsInCart[ductId.key!.length] = 1;
    } else {
      //_productsInCart[ductId.key!.length]++;
    }

    update();
  }

  /// Adds a product to the cart.
  @override
  void addProductToCart(productId) {
    if (!_productsInCart.containsKey(productId)) {
      _productsInCart[productId] = 1;
    } else {
      //  _productsInCart[productId]++;
    }

    update();
  }

  @override
  void removeItemFromCart(int productId) {
    if (_productsInCart.containsKey(productId)) {
      if (_productsInCart[productId] == 1) {
        _productsInCart.remove(productId);
      } else {
        // _productsInCart[productId]--;
      }
    }

    update();
  }

  productById(int id) {
    return feedlist!.firstWhere((product) => product.key!.length == id);
  }

  // Totaled prices of the items in the cart.
  double get subtotalCost {
    return _productsInCart.keys
        .map((int id) => feedlist![id].price! * _productsInCart[id]!)
        .fold(0.0, (sum, e) => sum + int.parse(e));
  }

  // Total shipping cost for the items in the cart.
  double get shippingCost {
    return _shippingCostPerItem *
        _productsInCart.values.fold(0.0, (num sum, int e) => sum + e);
  }

  // Sales tax for the items in the cart
  double get tax => subtotalCost * _salesTaxRate;

  // Total cost to order everything in the cart.
  double get totalCost => subtotalCost + shippingCost + tax;
//  Product getProductById(int id) {
//     return _availableProducts.firstWhere((Product product) => product.id == id);
//   }
  /// [Subscribe Ducts] firebase Database
  @override
  String toString() {
    return 'FeedState(totalCost: $totalCost)';
  }

  Future<String> updateProductIncart(String? productId, String? size,
      String? color, int? quantity, QuerySnapshot bagItems) async {
    String? documentId;
    String msg;
    List productItems = bagItems.docs.map((doc) {
      documentId = doc.id;
      return doc['products'];
    }).toList()[0];
    List product =
        productItems.where((test) => test['id'] == productId).toList();
    if (product.isNotEmpty) {
      productItems.forEach((items) {
        if (items['id'] == productId) {
          items['size'] = size;
          items['color'] = color;
          items['quantity'] = quantity;
        }
      });
      msg = "Product updated in shopping bag";
    } else {
      productItems.add({
        'id': productId,
        'size': size,
        'color': color,
        'quantity': quantity
      });
      msg = 'Product added to shopping bag';
    }
    await vDatabase
        .collection('bags')
        .doc(documentId)
        .set({'products': productItems}, SetOptions(merge: true));
    return msg;
  }

  Future<String> addProductTocart(String? productId, String? size,
      String? color, int? quantity, String? userId, String? vendorId) async {
    String msg;
    QuerySnapshot data = await vDatabase
        .collection('bags')
        .where("userId", isEqualTo: userId)
        .get();
    if (data.docs.isEmpty) {
      await vDatabase.collection('bags').doc(userId).set({
        'userId': userId,
        'products': [
          {
            'id': productId,
            'size': size,
            'color': color,
            'quantity': quantity,
            'vendorId': vendorId
          }
        ]
      }, SetOptions(merge: true));
      Get.snackbar("Item!", "This product added your cart");
      msg = "Product added to shopping bag";
      cprint(msg);
    } else {
      msg = await updateProductIncart(productId, size, color, quantity, data);
    }
    return msg;
  }

  Future<String?> addProductIncartTotalPrice(
      double totalPrice, String? userId, String? sellerId) async {
    String? msg;
    try {
      final database = Databases(
        clientConnect(),
      );
      await database
          .listDocuments(
        databaseId: databaseId,
        collectionId: initPayment,
      )
          .then((data) async {
        if (data.documents.isNotEmpty) {
          await database.updateDocument(
            databaseId: databaseId,
            collectionId: initPayment,
            documentId: '$userId',
            data: {'totalPrice': totalPrice.toStringAsFixed(0)},
          );
        } else {
          await database.createDocument(
            databaseId: databaseId,
            collectionId: initPayment,
            documentId: '$userId',
            data: {'totalPrice': totalPrice},
          );
        }
      });
    } catch (e) {
      EasyLoading.dismiss();
      cprint('$e addProductIncartTotalPrice');
    }
    // await vDatabase
    //     .collection('chatUsers')
    //     //  reference
    //     .doc(authState.userId)
    //     .collection('messages')
    //     .doc(sellerId)
    //     .set({'totalPrice': totalPrice}, SetOptions(merge: true));
    // await vDatabase.collection('bags').doc(userId).set(
    //     {'totalPrice': totalPrice, 'userId': userId}, SetOptions(merge: true));

    msg = "totall cost updated in shopping bag";

    // else {
    //   msg = await updateProductIncart(productId, size, color, quantity, data);
    // }
    return msg;
  }

  Future<List> listProductsInCart(FeedModel productInCart) async {
    RxList bagItemsList = List.empty(growable: true).obs;
    List? itemDetails;
    String? buyerId;
    List productIdList = List.empty(growable: true);
    //String uid = await userService.getUserId();
    //String uid = userService.userId;
    QuerySnapshot docRef = await vDatabase
        .collection('bags')
        .where("userId", isEqualTo: productInCart.userId)
        .get();
    int itemLength = docRef.docs.length;
    if (itemLength != 0) {
      itemDetails = docRef.docs.map((doc) {
        return doc['products'];
      }).toList()[0];
      buyerId = docRef.docs.map((doc) {
        return doc['userId'];
      }).toList()[0];
      productIdList = itemDetails!.map((value) => value['id']).toList();
    }

    for (int i = 0; i < productIdList.length; i++) {
      Map mapProduct = {};
      DocumentSnapshot productRef =
          await vDatabase.collection('duct').doc(productIdList[i]).get();
      mapProduct['id'] = productRef.id;
      // mapProduct['name'] = productRef['productName'];
      // mapProduct['image'] = productRef['imagePath'];
      // mapProduct['vendorId'] = productRef['userId'];
      // mapProduct['description'] = productRef['productDescription'];
      // mapProduct['vendor'] = productRef['user']['storeName'];
      // mapProduct['weight'] = productRef['weight'].toString();
      // mapProduct['price'] = productRef['price'].toString();
      // mapProduct['color'] = productRef['colors'].cast<String>().toList();
      // mapProduct['size'] = productRef['sizes'].cast<String>().toList();
      mapProduct['selectedSize'] = itemDetails![i]['size'];
      mapProduct['selectedColor'] = itemDetails[i]['color'];
      mapProduct['quantity'] = itemDetails[i]['quantity'];
      mapProduct['buyerId'] = buyerId;
      // mapProduct['id'] = productRef.map((doc) => doc.id);
      //     mapProduct['name'] = productRef.map((doc) => doc['productName']);
      //     mapProduct['image'] = productRef.map((doc) => doc['imagePath']);
      //     mapProduct['vendorId'] = productRef.map((doc) => doc['userId']);
      //     mapProduct['description'] =
      //         productRef.map((doc) => doc['productDescription']);
      //     mapProduct['vendor'] = productRef.map((doc) => doc['user']['storeName']);
      //     mapProduct['weight'] = productRef.map((doc) => doc['weight'].toString());
      //     mapProduct['price'] = productRef.map((doc) => doc['price'].toString());
      //     mapProduct['color'] =
      //         productRef.map((doc) => doc['colors'].cast<String>().toList());
      //     mapProduct['size'] =
      //         productRef.map((doc) => doc['sizes'].cast<String>().toList());
      bagItemsList.add(mapProduct);
    }
    return bagItemsList;
  }

  Future<void> remove(String? id, String? uid) async {
    // String uid = await userService.getUserId();
    //String uid = userService.userId;
    await vDatabase
        .collection('bags')
        .where('userId', isEqualTo: uid)
        .get()
        .then((QuerySnapshot doc) {
      doc.docs.forEach((docRef) async {
        List products = docRef['products'];
        if (products.length == 1) {
          await vDatabase.collection('bags').doc(docRef.id).delete();
        } else {
          products.removeWhere((productData) => productData['id'] == id);
          await vDatabase
              .collection('bags')
              .doc(docRef.id)
              .set({'products': products}, SetOptions(merge: true));
        }
      });
    });
  }

  Future<void> deleteProductInCart(String? user, String? sellerId) async {
    // String uid = await userService.getUserId();
//String uid = userService.userId;
    QuerySnapshot bagItems = await vDatabase
        .collection('chatUsers')
        .doc('$sellerId')
        .collection('messages')

        // .collection('bags')
        .where('userId', isEqualTo: user)
        // .collection('bags')
        // .where('userId', isEqualTo: user)
        .get();
    String shoppingBagItemId = bagItems.docs[0].id;

    final TransactionHandler deleteTransaction = (Transaction tx) async {
      final DocumentSnapshot ds = await tx.get(vDatabase
          .collection('chatUsers')
          .doc('$sellerId')
          .collection('messages')
          .doc(shoppingBagItemId));
      tx.delete(ds.reference);
    };

    await vDatabase.runTransaction(deleteTransaction);
  }

  Map mapAddressValues(Map values) {
    Map addressValues = {};
    addressValues['area'] = values['area'];
    addressValues['city'] = values['city'];
    addressValues['landmark'] = values['landmark'];
    addressValues['state'] = values['state'];
    addressValues['address'] = values['address'];
    addressValues['name'] = values['name'];
    addressValues['mobileNumber'] = values['mobileNumber'];
    addressValues['pinCode'] = values['pinCode'];
    return addressValues;
  }

  Future<void> updateAddressData(
      QuerySnapshot addressData, Map newAddress) async {
    String documentId = addressData.docs[0].id;
    List savedAddress = addressData.docs[0]['address'];
    savedAddress.add(newAddress);
    await vDatabase
        .collection('shippingAddress')
        .doc(documentId)
        .update({'address': savedAddress});
  }

  Future<void> newShippingAddress(Map address, String? shippingAddress) async {
    try {
      final database = Databases(
        clientConnect(),
      );
      await database.createDocument(
        databaseId: databaseId,
        collectionId: shippingAdress,
        documentId: 'unique()',
        // read: [
        //   'user:${message.senderId}',
        // ],
        // write: [
        //   'user:${message.senderId}',
        // ],
        data: address,
      );
    } on query.AppwriteException catch (e) {
      cprint('$e newShippingAddress');
    }
    // QuerySnapshot data = await vDatabase
    //     .collection('shippingAddress')
    //     .where("userId", isEqualTo: shippingAddress)
    //     .get();
    // if (data.docs.isEmpty) {
    //   await vDatabase.collection('shippingAddress').doc(shippingAddress).set({
    //     'userId': shippingAddress,
    //     'address': [mapAddressValues(address)]
    //   }, SetOptions(merge: true));
    //   cprint('Address Added!');
    // } else {
    //   await updateAddressData(data, address);
    // }
  }

  listShippingAddress(FeedModel shippingAddress) async {
    List<Document>? addressList = [];
    final database = Databases(
      clientConnect(),
    );
    await database
        .listDocuments(
      databaseId: databaseId,
      collectionId: shippingAdress,
      //  queries: [query.Query.equal('key', ductId)]
    )
        .then((data) {
      // Map map = data.toMap();
      if (data.documents.isNotEmpty) {
        addressList = data.documents;
      }
      // var value =
      //     data.documents.map((e) => ViewductsUser.fromJson(e.data)).toList();
      //data.documents;

      // cprint('${data.documents.map((e) => FeedModel.fromJson(e.data))}');
      // cprint('${searchState.viewUserlist.value.map((e) => e.key)}');
    });
    // QuerySnapshot docRef = await vDatabase
    //     .collection('shippingAddress')
    //     .where('userId', isEqualTo: authState.userId)
    //     .get();
    // if (docRef.docs.isNotEmpty) {
    //   addressList = docRef.docs[0]['address'];
    //   cprint('Getting Shipping Adress');
    // }
    return addressList;
  }

  Future<void> initializeTrasanction(
      String? initialize, String? currency) async {
    try {
      //  var id = Uuid().v1();
      final database = Databases(
        clientConnect(),
      );
      await database
          .listDocuments(
        databaseId: databaseId,
        collectionId: initPayment,
      )
          .then((data) async {
        if (data.documents.isNotEmpty) {
          await database.updateDocument(
            databaseId: databaseId,
            collectionId: initPayment,
            documentId: '$initialize',
            data: {
              'initialize': true,
              'userId': initialize,
              'custId': 'New',
              'email': authState.userModel?.email.toString(),
              "cartType": "cart",
              "currency": currency,
              "authorization": ""
              // 'initData': '$id'
            },
          );
        } else {
          await database.createDocument(
            databaseId: databaseId,
            collectionId: initPayment,
            documentId: '$initialize',
            data: {
              'initialize': true,
              'userId': initialize,
              'custId': 'New',
              'email': authState.userModel?.email.toString(),
              "cartType": "cart",
              "currency": currency, "authorization": ""
              //'initData': '$id'
            },
          );
        }
      });
    } catch (e) {
      EasyLoading.dismiss();
      cprint('$e initializeTrasanction');
    }
  }

  Future<void> initializeCartValue(
    String? initialize,
  ) async {
    try {
      //  var id = Uuid().v1();
      final database = Databases(
        clientConnect(),
      );
      await database
          .listDocuments(
        databaseId: databaseId,
        collectionId: initPayment,
      )
          .then((data) async {
        if (data.documents.isNotEmpty) {
          await database.updateDocument(
            databaseId: databaseId,
            collectionId: initPayment,
            documentId: '$initialize',
            data: {
              'initialize': true,
              'userId': initialize,
              'custId': 'New',
              'email': authState.userModel?.email.toString(),
              "cartType": "initCart"
              // 'initData': '$id'
            },
          );
        } else {
          // await database.createDocument(
          //   databaseId: databaseId,
          //   collectionId: initPayment,
          //   documentId: '$initialize',
          //   data: {
          //     'initialize': true,
          //     'userId': initialize,
          //     'custId': 'New',
          //     'Email': authState.appUser!.email,
          //     //'initData': '$id'
          //   },
          // );
        }
      });
    } catch (e) {
      EasyLoading.dismiss();
      cprint('$e initializeTrasanction');
    }
  }

  Future<void> addNewCard(String? userId, String? amount, String? ref,
      {String? authorize, String? authorizationCode}) async {
    try {
      final id =
          '${userId!.splitByLength((userId.length) ~/ 2)[0]}_${ref!.splitByLength((ref.length) ~/ 2)[0]}';
      final database = Databases(
        clientConnect(),
      );
      if (authorize == 'authorize') {
        await database.createDocument(
            databaseId: databaseId,
            collectionId: orderTransactionModel,
            documentId: '$id',
            data: {
              'card': 'authorize',
              'key': "$id",
              'userId': userId,
              "authorization": authorizationCode,
              'ordered': ref,
              'email': authState.userModel?.email,
              "amount": amount,
              "currency": authState.userModel?.location == 'Nigeria'
                  ? 'USD'
                  : authState.userModel?.location == 'Ghana'
                      ? 'GHS'
                      : 'USD'
            });
      } else {
        await database.createDocument(
            databaseId: databaseId,
            collectionId: orderTransactionModel,
            documentId: '$id',
            data: {
              'card': 'New',
              'key': "$id",
              "authorization": '',
              'userId': userId,
              'ref': ref,
              'email': authState.userModel?.email,
              "amount": amount,
              "currency": authState.userModel?.location == 'Nigeria'
                  ? 'USD'
                  : authState.userModel?.location == 'Ghana'
                      ? 'GHS'
                      : 'USD'
            });
      }
      // await vDatabase
      //     .collection('payment')
      //     .doc(initialize)
      //     .set({'card': 'New', 'userId': initialize, 'ref': ref});
      // .then((value) async {
      //   await vDatabase
      //       .collection('cards')
      //       .doc(initialize)
      //       .collection('initialize')
      //       .doc(initialize)
      //       .set({'userId': initialize}, SetOptions(merge: true));
      // });
    } catch (e) {
      cprint('$e');
    }
  }

  Future<String?> initialzeCredentials(String? accessCodes) async {
    QuerySnapshot access = await vDatabase
        .collection('cards')
        .doc(accessCodes)
        .collection('initialize')
        .where('userId', isEqualTo: accessCodes)
        .get();
    String? accessCode;
    access.docs.forEach((docRef) {
      accessCode = docRef['initData']['access_code'].toString();
    });
    return accessCode;
  }

  Future<void> newCreditCardDetails(String cardNumber, String expiryDate,
      String cardHolderName, String? credit) async {
    QuerySnapshot creditCardData = await vDatabase
        .collection('cards')
        .where("cardNumber", isEqualTo: cardNumber)
        .get();

    if (creditCardData.docs.isEmpty) {
      await vDatabase.collection('cards').doc(credit).set({
        'cardNumber': cardNumber,
        'expiryDate': expiryDate,
        'cardHolderName': cardHolderName,
        'userId': credit
      }, SetOptions(merge: true));
    }
  }

  Future<List> listCreditCardDetails(FeedModel creditCardDetails) async {
    List<String> cardNumberList = <String>[];
    QuerySnapshot cardData = await vDatabase
        .collection('cards')
        .where('userId', isEqualTo: creditCardDetails.userId)
        .get();
    String cardNumber;
    cardData.docs.forEach((docRef) {
      cardNumber =
          docRef['cardNumber'].toString().replaceAll(RegExp(r"\s+\b|\b\s"), '');
      cardNumberList.add(cardNumber.substring(cardNumber.length - 4));
    });
    return cardNumberList;
  }

  Future<void> placeNewOrder(Map orderDetails, String? userId, String? sellerId,
      {RxList<CartItemModel>? product, String? ref}) async {
    try {
      var timeStamp = DateTime.now().toUtc().toString();
      var key = Uuid().v1();
      final database = Databases(
        clientConnect(),
      );
      await database
          .listDocuments(
        databaseId: databaseId,
        collectionId: orderStateCollection,
      )
          .then((data) async {
        if (data.documents.isNotEmpty) {
          await database.updateDocument(
              databaseId: databaseId,
              collectionId: orderStateCollection,
              documentId: '${authState.appUser!.$id}',
              data: {
                'orderState': 'New',
                'userId': '${authState.appUser!.$id}',
                'placedDate': timeStamp,
                'state': orderDetails['city'],
                'country': orderDetails['country'],
              });
        } else {
          await database.createDocument(
              databaseId: databaseId,
              collectionId: orderStateCollection,
              documentId: '${authState.appUser!.$id}',
              data: {
                'orderState': 'New',
                'userId': '${authState.appUser!.$id}',
                'placedDate': timeStamp,
                'state': orderDetails['city'],
                'country': orderDetails['country'],
              });
        }
      });
      await database.createDocument(
        databaseId: databaseId,
        collectionId: userOrdersCollection,
        documentId: '$key',
        data: {
          'userId': '${authState.appUser!.$id}',
          'items': json.encode(product!.map((data) => data.toJson()).toList()),
          'shippingAddress':
              '${orderDetails['name']},${orderDetails['contact']},${orderDetails['address']} ${orderDetails['area']} ${orderDetails['city']},${orderDetails['state']} ${orderDetails['country']}',
          'state': orderDetails['city'],
          'country': orderDetails['country'],
          'shippingMethod': orderDetails['shippingMethod'],
          'totalPrice': double.parse("${orderDetails['price']}"),
          'orderState': 'processing',
          'sellerId': sellerId,
          'key': key,
          //'paymentCard': orderDetails['selectedCard'],
          'placedDate': timeStamp,
          'accessCode': ref
        },
      );
      product.forEach((data) {
        database.deleteDocument(
            databaseId: databaseId,
            collectionId: shoppingCartCollection,
            documentId: data.key.toString());
      });
    } on AppwriteException catch (e) {
      cprint(' placeNewOrder $e');
    }

    // await deleteProductInCart(userId, sellerId);
  }

  Future<List> listPlacedOrder(String? user) async {
    List orderList = [];
    List? itemDetails;
    List productIdList = List.empty(growable: true);
    QuerySnapshot orders = await vDatabase
        .collection('orders')
        .doc(user)
        .collection('myOrders')
        .orderBy('placedDate', descending: true)
        .where('userId', isEqualTo: user)
        .get();

    // orderMap['orderDetails'] = orderData;
    // orderList.add(orderData);
    for (DocumentSnapshot order in orders.docs) {
      // Map orderMap = new Map();

      int itemLength = orders.docs.length;
      if (itemLength != 0) {
        itemDetails = orders.docs.map((doc) {
          return doc['items'];
        }).toList()[0];
        productIdList = itemDetails!.map((value) => value['id']).toList();
      }
      //    Map orderMap = new Map();
      // orderMap['orderDate'] = order['placedDate'];
      //List orderData = new List();
      for (int i = 0; i < productIdList.length; i++) {
        Map tempOrderData = {};

        DocumentSnapshot docRef =
            await vDatabase.collection('duct').doc(productIdList[i]).get();
        // tempOrderData['orderDate'] = docRef['placedDate'];
        tempOrderData['orderDate'] = order['placedDate'];
        tempOrderData['totalPrice'] = order['totalPrice'];
        tempOrderData['shippingMethod'] = order['shippingMethod'];
        tempOrderData['shippingAddress'] = order['shippingAddress'];
        // tempOrderData['quantity'] = docRef['quantity'];
        //  tempOrderData['image'] = docRef['imagePath'];
        tempOrderData['name'] = docRef['productName'];
        tempOrderData['price'] = docRef['price'];
        tempOrderData['id'] = docRef.id;
        orderList.add(tempOrderData);
      }
      //   List orderData = new List();
      //   for (int i = 0; i < order['items'].length; i++) {
      //     Map tempOrderData = new Map();
      //     tempOrderData['quantity'] = order['items'][i]['quantity'];
      //     DocumentSnapshot docRef = await vDatabase
      //         .collection('duct')
      //         .doc(order['items'][i]['id'])
      //         .get();
      //     tempOrderData['image'] = docRef['productImage'];
      //     tempOrderData['name'] = docRef['productName'];
      //     tempOrderData['price'] = docRef['price'];
      //     orderData.add(tempOrderData);
      //   }
      //   orderMap['orderDetails'] = orderData;
      //   orderList.add(orderMap);
    }
    return orderList;
  }

  bossMemberPlan(String name, String interval, int? price) async {
    // String uid;
    await vDatabase.collection('subscription').doc('bossMember').set({
      // 'id': uid,
      'name': name,
      'interval': interval,
      'price': price,
      'state': 'create'
    });
    cprint('$name added');
  }

  Future<String> bossMemberPlanList() async {
    String price;
    List orderList = List.empty(growable: true);

    DocumentSnapshot orders =
        await vDatabase.collection('subscription').doc('bossMember').get();
    price = orders['price'].toString();

    orderList.add(price);

    cprint('$price added');
    return price;
  }

  Future<String> bossMemberPlanId() async {
    String id;

    DocumentSnapshot ids =
        await vDatabase.collection('subscription').doc('bossMember').get();
    id = ids['id'].toString();

    cprint('bossMember id $id added');
    return id;
  }

  bossMemberPlanUpdate(
    String name,
    String interval,
    int? price,
  ) async {
    await vDatabase.collection('subscription').doc('bossMember').set({
      // 'id': uid,
      'name': name,
      'interval': interval,
      'price': price,
      'state': 'update'
    });

    cprint('$name updated');
  }

  babyVendorPlan(String name, String interval, int? price) async {
    await vDatabase.collection('subscription').doc('babyVendor').set({
      // 'id': uid,
      'name': name,
      'interval': interval,
      'price': price,
      'state': 'create'
    });
    cprint('$name added');
  }

  babyVendorUpdate(
    String name,
    String interval,
    int? price,
  ) async {
    await vDatabase.collection('subscription').doc('babyVendor').set({
      // 'id': uid,
      'name': name,
      'interval': interval,
      'price': price,
      'state': 'update'
    });

    cprint('$name updated');
  }

  Future<String> babyVendorPlanList() async {
    String price;
    List orderList = List.empty(growable: true);

    DocumentSnapshot orders =
        await vDatabase.collection('subscription').doc('babyVendor').get();
    price = orders['price'].toString();

    orderList.add(price);

    cprint('babyVendor $price added');
    return price;
  }

  Future<String> babyVendorPlanId() async {
    String id;

    DocumentSnapshot ids =
        await vDatabase.collection('subscription').doc('babyVendor').get();
    id = ids['id'].toString();

    cprint('babyVendor id $id added');
    return id;
  }

  bossVendorPlan(String name, String interval, int? price) async {
    await vDatabase.collection('subscription').doc('bossVendor').set({
      // 'id': uid,
      'name': name,
      'interval': interval,
      'price': price,
      'state': 'create'
    });
    cprint('$name added');
  }

  bossVendorUpdate(
    String name,
    String interval,
    int? price,
  ) async {
    await vDatabase.collection('subscription').doc('bossVendor').set({
      // 'id': uid,
      'name': name,
      'interval': interval,
      'price': price,
      'state': 'update'
    });

    cprint('$name updated');
  }

  Future<String> bossVendorPlanList() async {
    String price;
    List orderList = List.empty(growable: true);

    DocumentSnapshot orders =
        await vDatabase.collection('subscription').doc('bossVendor').get();
    price = orders['price'].toString();

    orderList.add(price);

    cprint('bossVendor $price added');
    return price;
  }

  Future<String> bossVendorPlanId() async {
    String id;

    DocumentSnapshot ids =
        await vDatabase.collection('subscription').doc('bossVendor').get();
    id = ids['id'].toString();

    cprint('bossVendor id $id added');
    return id;
  }

  Future<void> subInitializeTrasanction(String? userName, String uid,
      String subId, String? email, String? plan, String? price) async {
    try {
      await vDatabase.collection('subInit').doc(uid).set({
        'subState': subId,
        'email': email,
        'userName': userName,
        'plan': plan,
        'price': price,
        'userId': uid
      }, SetOptions(merge: true));
      // .then((value) async {
      //   await vDatabase
      //       .collection('bossbaby')
      //       .doc(uid)
      //       .collection('subscription')
      //       .doc(subid)
      //       .set({'userId': initialize}, SetOptions(merge: true));
      // });
    } catch (e) {
      cprint(e);
    }
  }

  Future<void> verifySubTrasanction(
    String uid,
    String? subId,
  ) async {
    try {
      await vDatabase.collection('subInit').doc(uid).set({
        'subState': subId,
      }, SetOptions(merge: true));
    } catch (e) {
      cprint(e);
    }
  }

  Future<String?> subInitAccessGet(String userId) async {
    QuerySnapshot access = await vDatabase
        .collection('subInit')
        .where('userId', isEqualTo: userId)
        .get();
    String? accessCode;
    access.docs.forEach((docRef) {
      accessCode = docRef['initData'].toString();
    });
    cprint('acces $accessCode king');
    return accessCode;
  }
}

// ignore_for_file: unnecessary_null_comparison, overridden_fields, file_names

import 'package:get/get.dart';
import 'package:viewducts/helper/enum.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/user.dart';
import 'appState.dart';

class BossBabyState extends AppState {
  static BossBabyState instance = Get.find<BossBabyState>();
  @override
  RxDouble totalCartPrice = 0.0.obs;
  var venCategory = 'Children'.obs;
  @override
  void onReady() {
    super.onReady();
    // user = Rx<User>(_firebaseAuth.currentUser);
    // user.bindStream(_firebaseAuth.userChanges());
    //  getDataFromDatabase();
    //ever(authState.userModel.obs, getDataFromDatabase());
  }

  bool isBusy = false;
  SortUser sortBy = SortUser.ByMaxFollower;
  List<Vendors>? _userFilterlist;
  List<Vendors>? _userlist;

  List<Vendors>? get userlist {
    if (_userFilterlist == null) {
      return null;
    } else {
      return List.from(_userFilterlist!);
    }
  }

  /// get [Vendors list] from firebase realtime Database
  getDataFromDatabase() {
    try {
      isBusy = true;
      vDatabase.collection('bossbaby').snapshots().listen(
        (snapshot) {
          _userlist = <Vendors>[];
          _userFilterlist = <Vendors>[];
          if (snapshot.docs != null) {
            var map = snapshot.docs;
            for (var value in map) {
              var model = Vendors.fromJson(value.data());
              model.key = value.id;
              _userlist!.add(model);
              _userFilterlist!.add(model);
            }
          } else {
            _userlist = null;
          }
          isBusy = false;
        },
      );
      // .get().then(
      //   (QuerySnapshot snapshot) {

      // );
    } catch (error) {
      isBusy = false;
      cprint(error, errorIn: 'getDataFromDatabase');
    }
  }

  /// It will reset filter list
  /// If user has use search filter and change screen and came back to search screen It will reset user list.
  /// This function call when search page open.
  // void resetFilterList() {
  //   if (_userlist != null && _userlist.length != _userFilterlist.length) {
  //     _userFilterlist = List.from(_userlist);
  //     _userFilterlist.sort((x, y) => y.viewers.compareTo(x.viewers));
  //      notifyListeners();
  //   }
  // }

  /// This function call when search fiels text change.
  /// Vendors list on  search field get filter by `name` string
  // void filterByUsername(String name) {
  //   if (name.isEmpty &&
  //       _userlist != null &&
  //       _userlist.length != _userFilterlist.length) {
  //     _userFilterlist = List.from(_userlist);
  //   }
  //   // return if userList is empty or null
  //   if (_userlist == null && _userlist.isEmpty) {
  //     print("Empty userList");
  //     return;
  //   }
  //   // sortBy userlist on the basis of username
  //   else if (name != null) {
  //     _userFilterlist = _userlist
  //         .where((x) =>
  //             x.userName != null &&
  //             x.userName.toLowerCase().contains(name.toLowerCase()))
  //         .toList();
  //   }
  //    notifyListeners();
  // }

  /// Sort user list on search user page.
  set updateUserSortPrefrence(SortUser val) {
    sortBy = val;
  }

  // String get selectedFilter {
  //   switch (sortBy) {
  //     case SortUser.ByAlphabetically:
  //       _userFilterlist.sort((x, y) => x.displayName.compareTo(y.displayName));
  //        notifyListeners();
  //       return "alphabetically";

  //     case SortUser.ByMaxFollower:
  //       _userFilterlist.sort((x, y) => y.viewers.compareTo(x.viewers));
  //        notifyListeners();
  //       return "Vendors with max viewers";

  //     case SortUser.ByNewest:
  //       _userFilterlist.sort((x, y) =>
  //           DateTime.parse(y.createdAt).compareTo(DateTime.parse(x.createdAt)));
  //        notifyListeners();
  //       return "Newest user first";

  //     case SortUser.ByOldest:
  //       _userFilterlist.sort((x, y) =>
  //           DateTime.parse(x.createdAt).compareTo(DateTime.parse(y.createdAt)));
  //        notifyListeners();
  //       return "Oldest user first";

  //     case SortUser.ByVerified:
  //       _userFilterlist.sort((x, y) =>
  //           y.isVerified.toString().compareTo(x.isVerified.toString()));
  //        notifyListeners();
  //       return "Verified user first";

  //     default:
  //       return "Unknown";
  //   }
  // }

  /// Return user list relative to provided `userIds`
  /// Method is used on
  // List<Vendors> userList = [];
  List<Vendors> getuserDetail(List<String> userIds) {
    final list = _userlist!.where((x) {
      if (userIds.contains(x.key)) {
        return true;
      } else {
        return false;
      }
    }).toList();
    return list;
  }

  List<Vendors>? getVendors(String? location, String category) {
    if (location == null && category == null) {
      return null;
    }
    List<Vendors>? list;
    if (!isBusy && _userlist != null && _userlist!.isNotEmpty) {
      list = _userlist!.where((x) {
        if (x.location == location && x.vendorCategory == category) {
          return true;
        } else {
          return false;
        }
        // if (userIds.contains(x.key)) {
        //   return true;
        // } else {
        //   return false;
        // }
      }).toList();
      if (list.isEmpty) {
        list = null;
      }
    }
    return list;
  }
}

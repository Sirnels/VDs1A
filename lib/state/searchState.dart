// ignore_for_file: invalid_use_of_protected_member, unnecessary_null_comparison, file_names

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:viewducts/helper/enum.dart';
import 'package:viewducts/helper/utility.dart';
import 'package:viewducts/model/user.dart';

class SearchState extends GetxController {
  static SearchState instance = Get.find<SearchState>();

  @override
  void onReady() {
    super.onReady();
    //  getDataFromDatabase();
    // user = Rx<User>(_firebaseAuth.currentUser);
    // userlist.bindStream(getDataFromDatabase());
    // _userFilterlist.bindStream(getDataFromDatabase());
    //ever(authState.userModel.obs, getDataFromDatabase());
  }

  bool isBusy = false;
  SortUser? sortBy = SortUser.ByMaxFollower;
  RxList<ViewductsUser>? _userFilterlist;
  Rx<List<ViewductsUser>>? _userlist;

  List<ViewductsUser>? get userlist {
    if (_userFilterlist == null) {
      return null;
    } else {
      return _userFilterlist!.value;
    }
  }

  RxList<ViewductsUser> viewUserlist = RxList<ViewductsUser>();
  RxList<ViewductsUser> viewUserlistChatList = RxList<ViewductsUser>();
  RxList<ViewductsUser> vendorOrdersCountry = RxList<ViewductsUser>();
  Rx<ViewductsUser> initUserlist = ViewductsUser().obs;
  //  {
  //   // if (_userFilterlist == null) {
  //   //   return ;
  //   // } else {
  //   return _userFilterlist!;
  //   //}
  // }

  /// get [ViewductsUser list] from firebase realtime Database
  void getDataFromDatabase() {
    try {
      isBusy = true;
      vDatabase.collection('profile').snapshots().listen(
        (snapshot) {
          _userlist = Rx<List<ViewductsUser>>([]);
          _userFilterlist = RxList<ViewductsUser>([]);
          if (snapshot.docs != null) {
            var map = snapshot.docs;
            for (var value in map) {
              var model = (ViewductsUser.fromJson(value.data())).obs;
              model.value.key = value.id;
              _userlist!.value.add(model.value);
              _userFilterlist!.value.add(model.value);
            }
            // _userFilterlist!.value
            //     .sort((x, y) => y.viewers!.compareTo(x.viewers!));
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
  void resetFilterList() {
    if (_userlist != null &&
        _userlist!.value.length != _userFilterlist!.value.length) {
      _userFilterlist!.value = List.from(_userlist!.value);
      //// _userFilterlist!.value.sort((x, y) => y.viewers!.compareTo(x.viewers!));
    }
  }

  /// This function call when search fiels text change.
  /// ViewductsUser list on  search field get filter by `name` string
  void filterByUsername(String name) {
    if (name.isEmpty &&
        _userlist!.value.length != _userFilterlist!.value.length) {
      _userFilterlist!.value = List.from(_userlist!.value);
    }
    // return if userList is empty or null
    if (_userlist!.value == null && _userlist!.value.isEmpty) {
      if (kDebugMode) {
        print("Empty userList");
      }
      return;
    }
    // sortBy userlist on the basis of username
    else {
      _userFilterlist!.value = _userlist!.value
          .where((x) =>
              x.userName != null &&
              x.userName!.toLowerCase().contains(name.toLowerCase()))
          .toList();
    }
  }

  /// Sort user list on search user page.
  set updateUserSortPrefrence(SortUser? val) {
    sortBy = val;
  }

  String get selectedFilter {
    switch (sortBy) {
      case SortUser.ByAlphabetically:
        _userFilterlist!.value
            .sort((x, y) => x.displayName!.compareTo(y.displayName!));

        return "alphabetically";

      case SortUser.ByMaxFollower:
        // _userFilterlist!.value.sort((x, y) => y.viewers!.compareTo(x.viewers!));

        return "ViewductsUser with max viewers";

      case SortUser.ByNewest:
        _userFilterlist!.value.sort((x, y) => DateTime.parse(y.createdAt!)
            .compareTo(DateTime.parse(x.createdAt!)));

        return "Newest user first";

      case SortUser.ByOldest:
        _userFilterlist!.value.sort((x, y) => DateTime.parse(x.createdAt!)
            .compareTo(DateTime.parse(y.createdAt!)));

        return "Oldest user first";

      case SortUser.ByVerified:
        _userFilterlist!.value.sort((x, y) =>
            y.isVerified.toString().compareTo(x.isVerified.toString()));

        return "Verified user first";

      default:
        return "Unknown";
    }
  }

  /// Return user list relative to provided `userIds`
  /// Method is used on
  List<ViewductsUser> userList = [];
  List<ViewductsUser> getuserDetail(List<String?>? userIds) {
    final list = _userlist!.value.where((x) {
      if (userIds!.contains(x.key)) {
        return true;
      } else {
        return false;
      }
    }).toList();
    return list;
  }

  List<ViewductsUser>? getVendors(String? location) {
    if (location == null) {
      return null;
    }
    List<ViewductsUser>? list;
    if (!isBusy && _userlist!.value.isNotEmpty) {
      list = _userlist!.value.where((x) {
        // if (x.location == location && x.vendor == true) {
        //   return true;
        // } else
        {
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

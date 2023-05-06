// ignore_for_file: invalid_use_of_protected_member

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:viewducts/admin/Admin_dashbord/screens/admin_users.dart';
import 'package:viewducts/helper/showingLoading.dart';
import 'package:viewducts/helper/theme.dart';
import 'package:viewducts/model/feedModel.dart';
import 'package:viewducts/model/user.dart';
import 'package:viewducts/page/message/item_Search_bar.dart';
import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/frosted.dart';
import '../../../constants.dart';

class RecentFiles extends HookWidget {
  const RecentFiles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    data() async {
      await adminStaffController.allOrders();
      // await adminStaffController.adminIndividualUsersOrders(id);
    }

    useEffect(
      () {
        data();

        return () {};
      },
      [],
    );
    return frostedBlueGray(
      Container(
        padding: const EdgeInsets.all(defaultPadding),
        decoration: const BoxDecoration(
          // color: secondaryColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Recent Orders",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Obx(
              () => SizedBox(
                width: Get.width,
                height: Get.height * 0.5,
                child: DataTable2(
                    columnSpacing: defaultPadding,
                    minWidth: Get.width,
                    columns: const [
                      DataColumn(
                        label: Text("User"),
                      ),
                      DataColumn(
                        label: Text("Date"),
                      ),
                      DataColumn(
                        label: Text("OrderState"),
                      ),
                    ],
                    rows: adminStaffController.orderState.value
                        .map((user) => recentFileDataRow(user.obs, context))
                        .toList()
                    // List.generate(
                    //   demoRecentFiles.length,
                    //   (index) => recentFileDataRow(demoRecentFiles[index]),
                    // ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

DataRow recentFileDataRow(Rx<AdminOrdersModel> fileInfo, BuildContext context) {
  // final database = Databases(
  //   clientConnect(),
  // );
  // database.listDocuments(
  //     databaseId: databaseId,
  //     collectionId: profileUserColl,
  //     queries: [Query.equal('key', fileInfo.value.userId.toString())]
  //     //  queries: [query.Query.equal('key', ductId)]
  //     ).then((data) {
  //   if (data.documents.isNotEmpty) {
  //     var value =
  //         data.documents.map((e) => ViewductsUser.fromJson(e.data)).toList();

  //     searchState.userlist == value;
  //   }
  // });
  return DataRow(
    //  selected: fileInfo.value.staff == null ? false : true,
    cells: [
      DataCell(
        // Obx(
        //   () =>
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.blueGrey[50],
                  gradient: LinearGradient(
                    colors: [
                      Colors.yellow.withOpacity(0.1),
                      Colors.white60.withOpacity(0.2),
                      Colors.orange.withOpacity(0.3)
                    ],
                    // begin: Alignment.topCenter,
                    // end: Alignment.bottomCenter,
                  )),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ViewDuctMenuHolder(
                  blurBackgroundColor: Colors.black12,
                  onPressed: () {},
                  menuItems: <DuctFocusedMenuItem>[
                    authState.userModel?.admin == true
                        ? DuctFocusedMenuItem(
                            backgroundColor: Colors.black,
                            title: const Text(
                              'Admin',
                              style: TextStyle(
                                //fontSize: Get.width * 0.03,
                                color: AppColor.darkGrey,
                              ),
                            ),
                            onPressed: () async {
                              Get.to(
                                () => AdminUserOrdersDetails(
                                  id: fileInfo.value.userId,
                                ),
                              );

                              //  Get.to(() => SettingsAndPrivacyPage());
                            },
                            trailingIcon: const Icon(CupertinoIcons.person))
                        : DuctFocusedMenuItem(
                            title: Container(), onPressed: () {}),
                    DuctFocusedMenuItem(
                        backgroundColor: Colors.black,
                        title: fileInfo.value.staff == null
                            ? const Text(
                                'Take Order',
                                style: TextStyle(
                                  //fontSize: Get.width * 0.03,
                                  color: AppColor.darkGrey,
                                ),
                              )
                            : Text(
                                'Handled by ${searchState.userlist!.firstWhere((user) => user.userId == fileInfo.value.staff).displayName.toString()}',
                                style: const TextStyle(
                                  //fontSize: Get.width * 0.03,
                                  color: AppColor.darkGrey,
                                ),
                              ),
                        onPressed: () async {
                          if (fileInfo.value.staff != null
                              // ||
                              //   authState.userModel!.admin == true
                              // authState.userModel!.admin == true
                              ) {
                            Get.to(
                              () => AdminUserOrdersDetails(
                                id: fileInfo.value.userId,
                              ),
                            );
                          } else {
                            showLoading();
                            await adminStaffController.adminStaffOrdersUpdate(
                                fileInfo.value.key, authState.userId,
                                buyerId: fileInfo.value.userId);
                            dismissLoadingWidget();
                            Get.to(
                              () => AdminUserOrdersDetails(
                                id: fileInfo.value.userId,
                              ),
                            );
                          }
                          //  Get.to(() => SettingsAndPrivacyPage());
                        },
                        trailingIcon: const Icon(CupertinoIcons.shopping_cart)),
                  ],
                  child:
                      // customInkWell(
                      //   context: context,
                      //   onPressed: () {
                      //     Get.to(
                      //       () => AdminUserOrdersDetails(
                      //         id: fileInfo.value.userId,
                      //       ),
                      //     );
                      //     // Get.to(() => ProfilePage(
                      //     //       profileId: authState.user!.uid,
                      //     //     ));
                      //     //_opTions(context);
                      //     //  widget.scaffoldKey.currentState.openDrawer();
                      //   },
                      //   child:
                      customImage(
                          context,
                          searchState.userlist
                              ?.firstWhere(
                                  (user) =>
                                      user.userId == fileInfo.value.userId,
                                  orElse: () => ViewductsUser())
                              .profilePic
                              .toString(),
                          height: 30),
                ),
              ),
            ),
            // SvgPicture.asset(
            //   fileInfo.value.icon!,
            //   height: 30,
            //   width: 30,
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Text(''
                  // searchState.userlist!
                  //     .firstWhere(
                  //         (user) => user.userId == fileInfo.value.userId)
                  //     .displayName
                  //     .toString(),
                  ),
            ),
          ],
        ),
        // ),
      ),
      DataCell(
        Obx(
          () => ViewDuctMenuHolder(
            blurBackgroundColor: Colors.black12,
            onPressed: () {},
            menuItems: <DuctFocusedMenuItem>[
              DuctFocusedMenuItem(
                  backgroundColor: Colors.black,
                  title: fileInfo.value.staff == null
                      ? const Text(
                          'Take Order',
                          style: TextStyle(
                            //fontSize: Get.width * 0.03,
                            color: AppColor.darkGrey,
                          ),
                        )
                      : Text(
                          'Handled by ${searchState.userlist!.firstWhere((user) => user.userId == fileInfo.value.staff).displayName.toString()}',
                          style: const TextStyle(
                            //fontSize: Get.width * 0.03,
                            color: AppColor.darkGrey,
                          ),
                        ),
                  onPressed: () async {
                    if (fileInfo.value.staff != null
                        // ||
                        //     authState.userModel!.admin == true
                        ) {
                      Get.to(
                        () => AdminUserOrdersDetails(
                          id: fileInfo.value.userId,
                        ),
                      );
                    } else {
                      showLoading();
                      await adminStaffController.adminStaffOrdersUpdate(
                          fileInfo.value.key, authState.userId,
                          buyerId: fileInfo.value.userId);
                      dismissLoadingWidget();
                      Get.to(
                        () => AdminUserOrdersDetails(
                          id: fileInfo.value.userId,
                        ),
                      );
                    }
                    //  Get.to(() => SettingsAndPrivacyPage());
                  },
                  trailingIcon: const Icon(CupertinoIcons.shopping_cart)),
            ],
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Text(DateFormat.yMMMd()
                      .add_jm()
                      .format(fileInfo.value.placedDate!.toDate())),
                  Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              offset: const Offset(0, 11),
                              blurRadius: 11,
                              color: Colors.black.withOpacity(0.06))
                        ],
                        borderRadius: BorderRadius.circular(18),
                        color: CupertinoColors.lightBackgroundGray),
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                      children: [
                        Text(
                          fileInfo.value.state.toString(),
                          style: const TextStyle(
                              // color: CupertinoColors.systemYellow,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(fileInfo.value.country.toString(),
                            style: const TextStyle(
                                // color: CupertinoColors.systemYellow,
                                fontWeight: FontWeight.w200)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      DataCell(Obx(
        () => ViewDuctMenuHolder(
            blurBackgroundColor: Colors.black12,
            onPressed: () {},
            menuItems: <DuctFocusedMenuItem>[
              DuctFocusedMenuItem(
                  backgroundColor: Colors.black,
                  title: fileInfo.value.staff == null
                      ? const Text(
                          'Take Order',
                          style: TextStyle(
                            //fontSize: Get.width * 0.03,
                            color: AppColor.darkGrey,
                          ),
                        )
                      : Text(
                          'Handled by ${searchState.userlist!.firstWhere((user) => user.userId == fileInfo.value.staff).displayName.toString()}',
                          style: const TextStyle(
                            //fontSize: Get.width * 0.03,
                            color: AppColor.darkGrey,
                          ),
                        ),
                  onPressed: () async {
                    if (fileInfo.value.staff != null
                        //  ||
                        //         authState.userModel!.admin == true
                        // authState.userModel!.admin == true
                        ) {
                      Get.to(
                        () => AdminUserOrdersDetails(
                          id: fileInfo.value.userId,
                        ),
                      );
                    } else {
                      showLoading();
                      await adminStaffController
                        ..adminStaffOrdersUpdate(
                            fileInfo.value.key, authState.userId,
                            buyerId: fileInfo.value.userId);
                      dismissLoadingWidget();
                      Get.to(
                        () => AdminUserOrdersDetails(
                          id: fileInfo.value.userId,
                        ),
                      );
                    }
                    //  Get.to(() => SettingsAndPrivacyPage());
                  },
                  trailingIcon: const Icon(CupertinoIcons.shopping_cart)),
            ],
            child: Text(fileInfo.value.orderState!.toString())),
      )),
    ],
  );
}

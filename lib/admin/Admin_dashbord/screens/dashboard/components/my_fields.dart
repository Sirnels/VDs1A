import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:viewducts/admin/Admin_dashbord/models/MyFiles.dart';
import 'package:viewducts/admin/Admin_dashbord/responsive.dart';
import 'package:viewducts/admin/Admin_dashbord/screens/admin_users.dart';
import 'package:viewducts/page/message/item_Search_bar.dart';
import 'package:viewducts/state/stateController.dart';
import 'package:viewducts/widgets/customWidgets.dart';
import 'package:viewducts/widgets/frosted.dart';

import '../../../constants.dart';
import 'file_info_card.dart';

class MyFiles extends StatelessWidget {
  const MyFiles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Staff Dashboard",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            authState.userModel?.email == 'viewducts@gmail.com'
                ? ViewDuctMenuHolder(
                    onPressed: () {},
                    menuItems: <DuctFocusedMenuItem>[
                      DuctFocusedMenuItem(
                          backgroundColor: CupertinoColors.darkBackgroundGray,
                          title: const Text(
                            'Activate',
                            style: TextStyle(
                                color: CupertinoColors.lightBackgroundGray),
                          ),
                          onPressed: () async {
                            adminStaffController.adminPaymentActivate(
                                'activate',
                                DateFormat("MMMyyy").format(DateTime.now()));
                            //  Get.to(() => SettingsAndPrivacyPage());
                          },
                          trailingIcon: const Icon(
                            CupertinoIcons.person,
                            color: CupertinoColors.lightBackgroundGray,
                          )),
                      DuctFocusedMenuItem(
                          backgroundColor: CupertinoColors.darkBackgroundGray,
                          title: const Text(
                            'Deactivate',
                            style: TextStyle(
                                color: CupertinoColors.lightBackgroundGray),
                          ),
                          onPressed: () async {
                            adminStaffController.adminPaymentActivate(
                                'deactivate',
                                DateFormat("MMMyyy").format(DateTime.now()));
                            // Navigator.pushNamed(context, '/ChatScreenPage');
                            //  Get.to(() => SettingsAndPrivacyPage());
                          },
                          trailingIcon: const Icon(CupertinoIcons.chat_bubble,
                              color: CupertinoColors.lightBackgroundGray)),
                      DuctFocusedMenuItem(
                          backgroundColor: CupertinoColors.darkBackgroundGray,
                          title: const Text(
                            'Bank Listing',
                            style: TextStyle(
                                color: CupertinoColors.lightBackgroundGray),
                          ),
                          onPressed: () async {
                            userCartController.listbanks();
                            // Navigator.pushNamed(context, '/ChatScreenPage');
                            //  Get.to(() => SettingsAndPrivacyPage());
                          },
                          trailingIcon: const Icon(CupertinoIcons.bandage,
                              color: CupertinoColors.lightBackgroundGray)),
                    ],
                    child: frostedYellow(
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 3),
                        decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.circular(10)),
                        child: customTitleText('Activate Option'),
                      ),
                    )
                    //  ElevatedButton.icon(
                    //   style: TextButton.styleFrom(
                    //     padding: EdgeInsets.symmetric(
                    //       horizontal: defaultPadding * 1.5,
                    //       vertical: defaultPadding /
                    //           (Responsive.isMobile(context) ? 2 : 1),
                    //     ),
                    //   ),
                    //   onPressed: () {
                    //     // Get.to(() => const AdminAddStaff());
                    //   },
                    //   icon: const Icon(Icons.add),
                    //   label: const Text("Activate Comm.."),
                    // ),
                    )
                : Container()
          ],
        ),
        const SizedBox(height: defaultPadding),
        Responsive(
          mobile: FileInfoCardGridView(
            crossAxisCount: _size.width < 650 ? 2 : 4,
            childAspectRatio: _size.width < 650 && _size.width > 350 ? 1.3 : 1,
          ),
          tablet: const FileInfoCardGridView(),
          desktop: FileInfoCardGridView(
            childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
      ],
    );
  }
}

class FileInfoCardGridView extends StatelessWidget {
  const FileInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;
  Widget _user() {
    return GestureDetector(
        onTap: () {
          Get.to(() => AdminUsers());
        },
        child: FileInfoCard(info: demoMyFiles[0]));
  }

  Widget _userPaymentRequest() {
    return GestureDetector(
        onTap: () {
          Get.to(() => AdminUsersRequestPayment());
        },
        child: FileInfoCard(info: demoMyFiles[6]));
  }

  Widget _orders() {
    return GestureDetector(
        onTap: () {
          Get.to(() => const AdminUserOrders());
        },
        child: FileInfoCard(info: demoMyFiles[1]));
  }

  Widget _addProduct() {
    return GestureDetector(
        onTap: () {
          Get.to(() => const AdminAddProduct());
        },
        child: FileInfoCard(info: demoMyFiles[2]));
  }

  Widget _marketCategory() {
    return GestureDetector(
        onTap: () {
          Get.to(() => const AdminMarketCategory());
        },
        child: FileInfoCard(info: demoMyFiles[4]));
  }

  // Widget _sales() {
  //   return GestureDetector(
  //       onTap: () {
  //         Get.to(() => const AdminUsers());
  //       },
  //       child: FileInfoCard(info: demoMyFiles[3]));
  // }

  Widget _staffs() {
    return GestureDetector(
        onTap: () {
          Get.to(() => const AdminStaff());
        },
        child: FileInfoCard(info: demoMyFiles[5]));
  }

  Widget _processedOrders() {
    return GestureDetector(
        onTap: () {
          Get.to(() => AdminUserProccessedOrders());
        },
        child: FileInfoCard(info: demoMyFiles[3]));
  }

  List<Widget> getOption(index) {
    return [
      [
        authState.userModel?.email == 'viewducts@gmail.com'
            ? _user()
            : Container(),
        authState.userModel?.email == 'valentineemelumonye@viewducts.com'
            ? _user()
            : Container()
      ],
      [_orders()],
      [
        userCartController.staff
                    .firstWhere((id) => id.id == authState.appUser?.$id)
                    .role ==
                'General Manager'
            ? _addProduct()
            : Container(),
        userCartController.staff
                    .firstWhere((id) => id.id == authState.appUser?.$id)
                    .role ==
                'owner'
            ? _addProduct()
            : Container()
      ],
      [_processedOrders()],
      // [_sales()],
      [
        userCartController.staff
                    .firstWhere((id) => id.id == authState.appUser?.$id)
                    .role ==
                'General Manager'
            ? _marketCategory()
            : Container(),
        userCartController.staff
                    .firstWhere((id) => id.id == authState.appUser?.$id)
                    .role ==
                'owner'
            ? _marketCategory()
            : Container()
      ],
      [
        authState.userModel?.email == 'viewducts@gmail.com'
            ? _staffs()
            : Container(),
        authState.userModel?.email == 'valentineemelumonye@viewducts.com'
            ? _staffs()
            : Container()
      ],
      [
        authState.userModel?.email == 'viewducts@gmail.com'
            ? _userPaymentRequest()
            : Container(),
        authState.userModel?.email == 'valentineemelumonye@viewducts.com'
            ? _userPaymentRequest()
            : Container(),
        userCartController.staff
                    .firstWhere((id) => id.id == authState.appUser?.$id)
                    .role ==
                'General Manager'
            ? _userPaymentRequest()
            : Container()
      ],
      // [_childrenCategory()],
      // [_electronicsCategory()],
      // [_groceyCategory()],
      // [_fashionCategory()],
    ][index];
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 7,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => SingleChildScrollView(
        child: Column(
          children: getOption(index),
        ),
      ),
    );
  }
}

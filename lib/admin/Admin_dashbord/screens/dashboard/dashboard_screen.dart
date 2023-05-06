import 'package:flutter/material.dart';
import 'package:viewducts/admin/Admin_dashbord/responsive.dart';
import 'package:viewducts/admin/Admin_dashbord/screens/dashboard/components/my_fields.dart';
import 'package:viewducts/state/stateController.dart';

import '../../constants.dart';
import 'components/header.dart';

import 'components/recent_files.dart';
import 'components/storage_details.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    adminStaffController.allOrders();
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            const Header(),
            const SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const MyFiles(),
                      const SizedBox(height: defaultPadding),
                      const RecentFiles(),
                      // if (Responsive.isMobile(context))
                      //   SizedBox(height: defaultPadding),
                      // if (Responsive.isMobile(context)) StarageDetails(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  const SizedBox(width: defaultPadding),
                // On Mobile means if the screen is less than 850 we dont want to show it
                if (!Responsive.isMobile(context))
                  const Expanded(
                    flex: 2,
                    child: StarageDetails(),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

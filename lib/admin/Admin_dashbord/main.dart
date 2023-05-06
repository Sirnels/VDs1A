import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:viewducts/admin/Admin_dashbord/controllers/MenuController.dart';
import 'package:viewducts/admin/Admin_dashbord/screens/main/main_screen.dart';

class DashAdmin extends StatelessWidget {
  const DashAdmin({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(
        //   create: (context) => MenuController(),
        // ),
      ],
      child: const MainScreen(),
    );
    // MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   title: 'Admin Panel',
    //   // theme: ThemeData.dark().copyWith(
    //   //   scaffoldBackgroundColor: bgColor,
    //   //   textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
    //   //       .apply(bodyColor: Colors.white),
    //   //   canvasColor: secondaryColor,
    //   // ),
    //   home: MultiProvider(
    //     providers: [
    //       ChangeNotifierProvider(
    //         create: (context) => MenuController(),
    //       ),
    //     ],
    //     child: const MainScreen(),
    //   ),
    // );
  }
}

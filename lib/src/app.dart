// ignore_for_file: must_be_immutable

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:viewducts/app_theme/app_theme_constant.dart';
import 'package:viewducts/common/common.dart';
import 'package:viewducts/features/auth/controller/auth_controller.dart';
import 'package:viewducts/page/Auth/welcomePage.dart';
import 'package:viewducts/page/common/splash.dart';
import 'package:viewducts/page/homePage.dart';

/// The Widget that configures your application.
class MyApp extends ConsumerWidget {
  PendingDynamicLinkData? initialLink;
  MyApp({
    Key? key,
    this.initialLink,
  }) : super(key: key);

  // final SettingsController settingsController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'ViewDucts',
      theme: MainAppTheme.lightThemeData(context),
      home: ref.watch(currentUserAccountProvider).when(
            data: (user) {
              if (user != null) {
                return HomePage();
              }
              return const WelcomePage();
            },
            error: (error, st) => ErrorPage(
              error: error.toString(),
            ),
            loading: () => const SplashPage(),
          ),
      debugShowCheckedModeBanner: false,
    );

    //   GetMaterialApp(
    //       initialBinding: AppBindings(),
    //       builder: EasyLoading.init(),
    //       navigatorObservers: [seoRouteObserver],
    //       title: 'ViewDucts',
    //       defaultTransition: Transition.downToUp,
    //       theme: MainAppTheme.lightThemeData(context),
    //       getPages: [
    //         GetPage(name: "/splash", page: () => const SplashPage()),
    //         GetPage(name: "/marketplace", page: () => const WebMarketPlace()),
    //         GetPage(name: "/", page: () => const WelcomePage()),
    //         GetPage(name: "/policy", page: () => const AboutPageResponsiveView()),
    //         GetPage(
    //             name: "/signin", page: () => const EditPhonePageResponsiveView()),
    //         // GetPage(name: "/ducts", page: () => FeedPage()),
    //       ],
    //       debugShowCheckedModeBanner: false,
    //       initialRoute: kIsWeb ? "/" : "/splash");

    // }
  }

// ThemeData lightThemeData(BuildContext context) {
//   return ThemeData.light().copyWith(
//     primaryColor: kPrimaryColor,
//     scaffoldBackgroundColor: scafoldBacgroundColor,
//     appBarTheme: appBarTheme,
//     iconTheme: IconThemeData(color: kContentColorLightTheme),
//     textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme).apply(
//       bodyColor: kContentColorLightTheme,
//     ),
//     colorScheme: ColorScheme.light(
//       primary: kPrimaryColor,
//       secondary: kSecondaryColor,
//       error: kErrorColor,
//     ),
//     bottomNavigationBarTheme: BottomNavigationBarThemeData(
//       backgroundColor: Colors.white,
//       selectedItemColor: kContentColorLightTheme.withOpacity(0.7),
//       unselectedItemColor: kContentColorLightTheme.withOpacity(0.32),
//       selectedIconTheme: IconThemeData(color: kPrimaryColor),
//       showUnselectedLabels: true,
//     ),
//   );
// }

// ThemeData darkThemeData(BuildContext context) {
//   // Bydefault flutter provie us light and dark theme
//   // we just modify it as our need
//   return ThemeData.dark().copyWith(
//     primaryColor: kPrimaryColor,
//     scaffoldBackgroundColor: kContentColorLightTheme,
//     appBarTheme: appBarTheme,
//     iconTheme: IconThemeData(color: kContentColorDarkTheme),
//     textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
//         .apply(bodyColor: kContentColorDarkTheme),
//     colorScheme: ColorScheme.dark().copyWith(
//       primary: kPrimaryColor,
//       secondary: kSecondaryColor,
//       error: kErrorColor,
//     ),
//     bottomNavigationBarTheme: BottomNavigationBarThemeData(
//       backgroundColor: kContentColorLightTheme,
//       selectedItemColor: Colors.white70,
//       unselectedItemColor: kContentColorDarkTheme.withOpacity(0.32),
//       selectedIconTheme: IconThemeData(color: kPrimaryColor),
//       showUnselectedLabels: true,
//     ),
//   );
// }

// final appBarTheme = AppBarTheme(centerTitle: false, elevation: 0);
// const kPrimaryColor = Color(0xFFFE9901);
// const kSecondaryColor = Color(0xFFFE9901);
// const scafoldBacgroundColor = Color.fromARGB(255, 193, 187, 169);
// const kContentColorLightTheme = Colors.black;
// const kContentColorDarkTheme = Color.fromARGB(255, 246, 182, 8);
// const kWarninngColor = Color.fromARGB(255, 236, 179, 21);
// const kErrorColor = Color(0xFFF03738);

// const kDefaultPadding = 20.0;
}

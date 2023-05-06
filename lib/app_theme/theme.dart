import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:viewducts/app_theme/colors_pallete.dart';

class MainAppTheme {
  static ThemeData lightThemeData(BuildContext context) {
    return ThemeData.light().copyWith(
      useMaterial3: true,
      primaryColor: Pallete.kPrimaryColor,
      scaffoldBackgroundColor: Pallete.scafoldBacgroundColor,
      appBarTheme: Pallete.appBarTheme,
      iconTheme: IconThemeData(color: Pallete.kContentColorLightTheme),
      textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme).apply(
        bodyColor: Pallete.kContentColorLightTheme,
      ),
      colorScheme: ColorScheme.light(
        primary: Pallete.kPrimaryColor,
        secondary: Pallete.kSecondaryColor,
        error: Pallete.kErrorColor,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Pallete.kContentColorLightTheme.withOpacity(0.7),
        unselectedItemColor: Pallete.kContentColorLightTheme.withOpacity(0.32),
        selectedIconTheme: IconThemeData(color: Pallete.kPrimaryColor),
        showUnselectedLabels: true,
      ),
    );
  }

  static ThemeData darkThemeData(BuildContext context) {
    // Bydefault flutter provie us light and dark theme
    // we just modify it as our need
    return ThemeData.dark().copyWith(
      useMaterial3: true,
      primaryColor: Pallete.kPrimaryColor,
      scaffoldBackgroundColor: Pallete.kContentColorLightTheme,
      appBarTheme: Pallete.appBarTheme,
      iconTheme: IconThemeData(color: Pallete.kContentColorDarkTheme),
      textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
          .apply(bodyColor: Pallete.kContentColorDarkTheme),
      colorScheme: ColorScheme.dark().copyWith(
        primary: Pallete.kPrimaryColor,
        secondary: Pallete.kSecondaryColor,
        error: Pallete.kErrorColor,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Pallete.kContentColorLightTheme,
        selectedItemColor: Colors.white70,
        unselectedItemColor: Pallete.kContentColorDarkTheme.withOpacity(0.32),
        selectedIconTheme: IconThemeData(color: Pallete.kPrimaryColor),
        showUnselectedLabels: true,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intelligenz/core/constants/color_constant.dart';

final ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: klBackgroundColor,
  primaryColor: klPrimaryColor,
  colorScheme: ColorScheme.light(
    primary: klPrimaryColor,
    secondary: klAccentColor,
    surface: klBackgroundColor,
    onPrimary: Colors.white,
  ),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: GoogleFonts.dmSans(color: klTextHint, fontSize: 14),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kButtonColor,
      foregroundColor: kButtonTextColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),
  ),
);
// class TAppTheme {
//   TAppTheme._();
//   static ThemeData lightTheme = ThemeData(
//     useMaterial3: true,
//     fontFamily: GoogleFonts.dmSans().fontFamily,
//     brightness: Brightness.light,
//     primaryColor: klPrimaryColor,
//     scaffoldBackgroundColor: klBackgroundColor,
//   );
//   static ThemeData darkTheme = ThemeData();
// }

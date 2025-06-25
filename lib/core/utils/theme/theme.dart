import 'package:flutter/material.dart';
import 'package:intelligenz/core/constants/color_constant.dart';
import 'package:intelligenz/core/utils/theme/elevated_btn_theme.dart';
import 'package:intelligenz/core/utils/theme/outline_btn_theme.dart';
import 'package:intelligenz/core/utils/theme/text_field_theme.dart';
import 'package:intelligenz/core/utils/theme/text_theme.dart';

// final ThemeData appTheme = ThemeData(
//   scaffoldBackgroundColor: klBackgroundColor,
//   primaryColor: klPrimaryColor,
//   colorScheme: ColorScheme.light(
//     primary: klPrimaryColor,
//     secondary: klAccentColor,
//     surface: klBackgroundColor,
//     onPrimary: Colors.white,
//   ),
//   inputDecorationTheme: InputDecorationTheme(
//     hintStyle: GoogleFonts.dmSans(color: klTextHint, fontSize: 14),
//     filled: true,
//     fillColor: Colors.white,
//     contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.circular(8),
//       borderSide: BorderSide.none,
//     ),
//   ),
//   elevatedButtonTheme: ElevatedButtonThemeData(
//     style: ElevatedButton.styleFrom(
//       backgroundColor: kButtonColor,
//       foregroundColor: kButtonTextColor,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
//     ),
//   ),
// );
class TAppTheme {
  TAppTheme._();
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: klPrimaryColor,
    scaffoldBackgroundColor: klBackgroundColor,
    textTheme: TTextTheme.lightTextTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: TOutlineButtonTheme.lightOutlineButtonTheme,
    inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
    // radioTheme: TRadioFormFieldTheme.lightRadioTheme,
  );
  static ThemeData darkTheme = ThemeData();
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intelligenz/core/constants/color_constant.dart';
import 'package:intelligenz/core/constants/size_constant.dart';

class TOutlineButtonTheme {
  TOutlineButtonTheme._();

  static OutlinedButtonThemeData lightOutlineButtonTheme =
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          elevation: 0,
          backgroundColor: kSkyBlue1000,
          foregroundColor: kSkyBlue300,
          disabledForegroundColor: kButtonTextColor,
          disabledBackgroundColor: kSkyBlue300,
          side: const BorderSide(color: kSkyBlue300),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          textStyle: GoogleFonts.dmSans(
            fontSize: SizeConstants.size500,
            color: kSkyBlue300,
            fontWeight: FontWeight.w700,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SizeConstants.size100),
          ),
        ),
      );

  // static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme();
}

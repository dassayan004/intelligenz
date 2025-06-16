import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intelligenz/core/constants/color_constant.dart';

class TTextFormFieldTheme {
  TTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    hintStyle: GoogleFonts.dmSans(color: klTextHint, fontSize: 14),
    filled: true,
    fillColor: kNeutralWhite,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
  );

  // static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme();
}

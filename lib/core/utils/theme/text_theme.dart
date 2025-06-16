import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intelligenz/core/constants/color_constant.dart';
import 'package:intelligenz/core/constants/size_constant.dart';

/// Custom Class for Light & Dark Text Themes
class TTextTheme {
  TTextTheme._(); // To avoid creating instances

  /// Customizable Light Text Theme
  static TextTheme lightTextTheme = GoogleFonts.dmSansTextTheme().copyWith(
    headlineLarge: GoogleFonts.dmSans(
      fontSize: SizeConstants.size800,
      fontWeight: FontWeight.bold,
      color: klTextDark,
    ),
    headlineMedium: GoogleFonts.dmSans(
      fontSize: SizeConstants.size600,
      fontWeight: FontWeight.w600,
      color: klTextDark,
    ),
    headlineSmall: GoogleFonts.dmSans(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: klTextDark,
    ),
    titleLarge: GoogleFonts.dmSans(
      fontSize: SizeConstants.size400,
      fontWeight: FontWeight.w600,
      color: klTextDark,
    ),
    titleMedium: GoogleFonts.dmSans(
      fontSize: SizeConstants.size400,
      fontWeight: FontWeight.w500,
      color: klTextDark,
    ),
    titleSmall: GoogleFonts.dmSans(
      fontSize: SizeConstants.size400,
      fontWeight: FontWeight.w400,
      color: klTextDark,
    ),
    bodyLarge: GoogleFonts.dmSans(
      fontSize: SizeConstants.size300,
      fontWeight: FontWeight.w500,
      color: klTextDark,
    ),
    bodyMedium: GoogleFonts.dmSans(
      fontSize: SizeConstants.size300,
      fontWeight: FontWeight.normal,
      color: klTextDark,
    ),
    bodySmall: GoogleFonts.dmSans(
      fontSize: SizeConstants.size300,
      fontWeight: FontWeight.w500,
      color: klTextHint,
    ),
    labelLarge: GoogleFonts.dmSans(
      fontSize: SizeConstants.size200,
      fontWeight: FontWeight.normal,
      color: klTextDark,
    ),
    labelMedium: GoogleFonts.dmSans(
      fontSize: SizeConstants.size200,
      fontWeight: FontWeight.w500,
      color: klTextMedium,
    ),
    labelSmall: GoogleFonts.dmSans(
      fontSize: SizeConstants.size200,
      fontWeight: FontWeight.normal,
      color: klTextHint,
    ),
  );

  /// Customizable Dark Text Theme
  static TextTheme darkTextTheme = TextTheme();
}

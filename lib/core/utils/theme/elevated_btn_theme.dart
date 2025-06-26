import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intelligenz/core/constants/color_constant.dart';
import 'package:intelligenz/core/constants/size_constant.dart';

/* -- Light & Dark Elevated Button Themes -- */
class TElevatedButtonTheme {
  TElevatedButtonTheme._(); //To avoid creating instances

  /* -- Light Theme -- */
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: kButtonColor,
      foregroundColor: kButtonTextColor,
      disabledForegroundColor: kButtonTextColor,
      disabledBackgroundColor: kNeutralGrey700,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      textStyle: GoogleFonts.dmSans(
        fontSize: SizeConstants.size500,
        color: kNeutralWhite,
        fontWeight: FontWeight.w700,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeConstants.size100),
      ),
    ),
  );
  static final lightSecondaryElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: kSkyBlue900,
      foregroundColor: kSkyBlue300,
      disabledForegroundColor: kButtonTextColor,
      disabledBackgroundColor: kNeutralGrey700,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      textStyle: GoogleFonts.dmSans(
        fontSize: SizeConstants.size500,
        fontWeight: FontWeight.w700,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeConstants.size100),
      ),
    ),
  );
  static final btnInsideInput = ElevatedButton.styleFrom(
    elevation: 0,
    backgroundColor: kSkyBlue1000,
    foregroundColor: kSkyBlue300,
    disabledForegroundColor: kButtonTextColor,
    disabledBackgroundColor: kNeutralGrey700,
    side: const BorderSide(color: kSkyBlue300),
    padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 15),
    textStyle: GoogleFonts.dmSans(
      fontSize: SizeConstants.size200,
      color: kSkyBlue300,
      fontWeight: FontWeight.w400,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(SizeConstants.size100),
    ),
  );
  /* -- Dark Theme -- */
  // static final darkElevatedButtonTheme = ElevatedButtonThemeData(
  //   style: ElevatedButton.styleFrom(
  //     elevation: 0,
  //     foregroundColor: TColors.light,
  //     backgroundColor: TColors.primary,
  //     disabledForegroundColor: TColors.darkGrey,
  //     disabledBackgroundColor: TColors.darkerGrey,
  //     side: const BorderSide(color: TColors.primary),
  //     padding: const EdgeInsets.symmetric(vertical: TSizes.buttonHeight),
  //     textStyle: const TextStyle(
  //       fontSize: 16,
  //       color: TColors.textWhite,
  //       fontWeight: FontWeight.w600,
  //     ),
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(TSizes.buttonRadius),
  //     ),
  //   ),
  // );
}

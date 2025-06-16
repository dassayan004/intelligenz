import 'package:flutter/material.dart';
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
      disabledBackgroundColor: kSkyBlue300,
      side: const BorderSide(color: kButtonColor),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      textStyle: const TextStyle(
        fontSize: SizeConstants.size500,
        color: kNeutralWhite,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeConstants.size100),
      ),
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

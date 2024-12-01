import 'package:flutter/material.dart';
import 'package:flutter_demo/core/utils/size_utils-new.dart';
import 'package:flutter_demo/theme/theme_helper-new.dart';

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.

class CustomTextStyles {
  // Label text style
  static get labelLargeBluegray400 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.blueGray400,
      );
  static get labelLargeDMSansWhiteA70001 =>
      theme.textTheme.labelLarge!.dMSans.copyWith(
        color: appTheme.whiteA70001.withOpacity(0.64),
      );
  static get labelLargeInterGray400 =>
      theme.textTheme.labelLarge!.inter.copyWith(
        color: appTheme.gray400,
        fontWeight: FontWeight.w600,
      );
  static get labelLargeInterWhiteA70001 =>
      theme.textTheme.labelLarge!.inter.copyWith(
        color: appTheme.whiteA70001,
        fontWeight: FontWeight.w600,
      );
  static get labelLargePurple300 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.purple300,
      );
  static get labelLargeRed600 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.red600,
      );
  // Poppins text style
  static get poppinsBlack900 => TextStyle(
        color: appTheme.black900,
        fontSize: 7.fSize,
        fontWeight: FontWeight.w500,
      ).poppins;
  static get poppinsBluegray400 => TextStyle(
        color: appTheme.blueGray400,
        fontSize: 6.fSize,
        fontWeight: FontWeight.w400,
      ).poppins;
  static get poppinsBluegray400Medium => TextStyle(
        color: appTheme.blueGray400,
        fontSize: 7.fSize,
        fontWeight: FontWeight.w500,
      ).poppins;
  static get poppinsBluegray400Medium7 => TextStyle(
        color: appTheme.blueGray400,
        fontSize: 7.fSize,
        fontWeight: FontWeight.w500,
      ).poppins;
  // Title text style
  static get titleSmallDMSansGray500 =>
      theme.textTheme.titleSmall!.dMSans.copyWith(
        color: appTheme.gray500,
      );
  static get titleSmallDMSansPurple300 =>
      theme.textTheme.titleSmall!.dMSans.copyWith(
        color: appTheme.purple300,
      );
  static get titleSmallPurple300 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.purple300,
      );
}

extension on TextStyle {
  TextStyle get inter {
    return copyWith(
      fontFamily: 'Inter',
    );
  }

  TextStyle get poppins {
    return copyWith(
      fontFamily: 'Poppins',
    );
  }

  TextStyle get dMSans {
    return copyWith(
      fontFamily: 'DM Sans',
    );
  }
}

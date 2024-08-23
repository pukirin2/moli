import 'package:flutter/material.dart';
import 'package:moli/utils/color_res.dart';

// const kSemiBoldWhiteTextStyle = TextStyle(
//   color: ColorRes.white,
//   fontFamily: AssetRes.fnProductSansMedium,
//   fontSize: 23,
// );

// const context.bodyMedium!.copyWith(fontWeight: FontWeight.w300) = TextStyle(
//   color: ColorRes.neroDark,
//   fontFamily: AssetRes.fnProductSansMedium,
//   fontSize: 17,
// );

// const context.bodyMedium!.copyWith(fontWeight: FontWeight.w300) = TextStyle(
//   color: context.colorScheme.primary,
//   fontFamily: AssetRes.fnProductSansMedium,
//   fontSize: 17,
// );
// const kMediumWhiteTextStyle = TextStyle(
//   color: ColorRes.white,
//   fontFamily: AssetRes.fnProductSansMedium,
//   fontSize: 20,
// );

// const context.bodyMedium = TextStyle(
//   color: ColorRes.neroDark,
//   fontFamily: AssetRes.fnProductSansMedium,
//   fontSize: 20,
// );

// const kMediumThemeTextStyle = TextStyle(
//   color: context.colorScheme.primary,
//   fontFamily: AssetRes.fnProductSansMedium,
//   fontSize: 20,
// );

// const kBoldWhiteTextStyle = TextStyle(
//   color: ColorRes.white,
//   fontFamily: AssetRes.fnProductSansBold,
//   fontSize: 23,
// );

// const context.bodyMedium!.copyWith(                                              fontWeight: FontWeight.bold) = TextStyle(
//   color: context.colorScheme.primary,
//   fontFamily: AssetRes.fnProductSansBold,
//   fontSize: 20,
// );

// const kBlackWhiteTextStyle = TextStyle(
//   color: ColorRes.white,
//   fontFamily: AssetRes.fnProductSansBlack,
//   fontSize: 22,
// );

// const kRegularWhiteTextStyle = TextStyle(
//   color: ColorRes.white,
//   fontFamily: AssetRes.fnProductSansRegular,
//   fontSize: 16,
// );

// const context.bodyMedium = TextStyle(
//   color: ColorRes.neroDark,
//   fontFamily: AssetRes.fnProductSansRegular,
//   fontSize: 16,
// );

// const context.bodyMedium = TextStyle(
//   color: context.colorScheme.outline,
//   fontFamily: AssetRes.fnProductSansRegular,
//   fontSize: 16,
// );
// const kRegularThemeTextStyle = TextStyle(
//   color: context.colorScheme.primary,
//   fontFamily: AssetRes.fnProductSansRegular,
//   fontSize: 16,
// );

// const context.bodyMedium = TextStyle(
//   color: ColorRes.white,
//   fontFamily: AssetRes.fnProductSansLight,
//   fontSize: 14,
// );

// const context.bodyMedium = TextStyle(
//   color: ColorRes.white,
//   fontFamily: AssetRes.fnProductSansThin,
//   fontSize: 14,
// );

// const kBlackButtonTextStyle = TextStyle(
//   color: ColorRes.black,
//   fontFamily: AssetRes.fnProductSansRegular,
//   fontSize: 16,
// );

// const kThemeButtonTextStyle = TextStyle(
//   color: context.colorScheme.primary,
//   fontFamily: AssetRes.fnProductSansRegular,
//   fontSize: 16,
// );

ButtonStyle kButtonWhiteStyle = ButtonStyle(
  backgroundColor: WidgetStateProperty.all(ColorRes.white),
  shape: WidgetStateProperty.all(
    const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))),
  ),
  overlayColor: WidgetStateProperty.all(ColorRes.transparent),
);

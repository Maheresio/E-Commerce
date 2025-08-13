import '../helpers/extensions/context_extensions.dart';
import '../responsive/responsive_font_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../global/themes/light/app_colors_light.dart';

abstract class AppStyles {
  static TextStyle font10BlackRegular(BuildContext context) => TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w400,
    color: context.color.primaryFixed,
  );

  static TextStyle font10BlackSemiBold(BuildContext context) => TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w600,
    color: context.color.primaryFixed,
  );
  static TextStyle font10WhiteSemiBold(BuildContext context) => TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w600,
    color: context.color.onSecondary,
  );

  static TextStyle font11BlackRegular(BuildContext context) => TextStyle(
    fontSize: responsiveFontSize(context, mobile: 11, tablet: 22),
    fontWeight: FontWeight.w400,
    color: context.color.primaryFixed,
  );
  static TextStyle font11GreyRegular(BuildContext context) => TextStyle(
    fontSize: responsiveFontSize(context, mobile: 11, tablet: 22),
    fontWeight: FontWeight.w400,
    color: AppColorsLight.kGrey,
  );
  static TextStyle font11GreyMedium(BuildContext context) => TextStyle(
    fontSize: responsiveFontSize(context, mobile: 11, tablet: 22),
    fontWeight: FontWeight.w500,
    color: AppColorsLight.kGrey,
  );

  static TextStyle font11BlackSemiBold(BuildContext context) => TextStyle(
    fontSize: responsiveFontSize(context, mobile: 11, tablet: 22),
    fontWeight: FontWeight.w600,
    color: context.color.primaryFixed,
  );
  static TextStyle font11BlackMedium(BuildContext context) => TextStyle(
    fontSize: responsiveFontSize(context, mobile: 11, tablet: 22),
    fontWeight: FontWeight.w500,
    color: context.color.primaryFixed,
  );
  static TextStyle font11WhiteSemiBold(BuildContext context) => TextStyle(
    fontSize: responsiveFontSize(context, mobile: 11, tablet: 22),
    fontWeight: FontWeight.w600,
    color: context.color.onSecondary,
  );
  static TextStyle font12BlackMedium(BuildContext context) => TextStyle(
    fontSize: responsiveFontSize(context, mobile: 12, tablet: 24),
    fontWeight: FontWeight.w500,
    color: context.color.primaryFixed,
  );
  static TextStyle font12GreyMedium(BuildContext context) => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: AppColorsLight.kGrey,
  );



static TextStyle font13BlackMedium(BuildContext context) => TextStyle(
    fontSize: responsiveFontSize(context, mobile: 13, tablet: 28),
    fontWeight: FontWeight.w500,
    color: context.color.primaryFixed,
  );
  static TextStyle font13BlackRegular(BuildContext context) => TextStyle(
    fontSize: responsiveFontSize(context, mobile: 13, tablet: 28),
    fontWeight: FontWeight.w400,
    color: context.color.primaryFixed,
  );

  static TextStyle font14BlackRegular(BuildContext context) => TextStyle(
    fontSize: responsiveFontSize(context, mobile: 14, tablet: 28),
    fontWeight: FontWeight.w400,
    color: context.color.primaryFixed,
  );
  static TextStyle font14WhiteMedium(BuildContext context) => TextStyle(
    fontSize: responsiveFontSize(context, mobile: 14, tablet: 28),
    fontWeight: FontWeight.w500,
    color: context.color.onSecondary,
  );
  static TextStyle font14BlackMedium(BuildContext context) => TextStyle(
    fontSize: responsiveFontSize(context, mobile: 14, tablet: 28),
    fontWeight: FontWeight.w500,
    color: context.color.primaryFixed,
  );
  static TextStyle font14GreyMedium(BuildContext context) => TextStyle(
    fontSize: responsiveFontSize(context, mobile: 14, tablet: 28),
    fontWeight: FontWeight.w500,
    color: AppColorsLight.kGrey,
  );
  static TextStyle font14PrimaryMedium(BuildContext context) => TextStyle(
    fontSize: responsiveFontSize(context, mobile: 14, tablet: 28),
    fontWeight: FontWeight.w500,
    color: AppColorsLight.kPrimary,
  );
  static TextStyle font14GreenMedium(BuildContext context) => TextStyle(
    fontSize: responsiveFontSize(context, mobile: 14, tablet: 28),
    fontWeight: FontWeight.w500,
    color: AppColorsLight.kSuccessColor,
  );

  static TextStyle font14BlackSemiBold(BuildContext context) => TextStyle(
    fontSize: responsiveFontSize(context, mobile: 14, tablet: 28),
    fontWeight: FontWeight.w600,
    color: context.color.primaryFixed,
  );
  static TextStyle font14WhiteSemiBold(BuildContext context) => TextStyle(
    fontSize: responsiveFontSize(context, mobile: 14, tablet: 28),
    fontWeight: FontWeight.w600,
    color: context.color.onSecondary,
  );

  static TextStyle font14GreyRegular(BuildContext context) => TextStyle(
    fontSize: responsiveFontSize(context, mobile: 14, tablet: 28),
    fontWeight: FontWeight.w500,
    color: context.color.secondary,
  );

  static TextStyle font14LightBlackRegular(BuildContext context) => TextStyle(
    fontSize: responsiveFontSize(context, mobile: 14, tablet: 28),
    fontWeight: FontWeight.w400,
    color: AppColorsLight.kLightBlack,
  );

  static TextStyle font15BlackSemiBold(BuildContext context) => TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w600,
    color: context.color.primaryFixed,
  );

  static TextStyle font16BlackRegular(BuildContext context) => TextStyle(
    fontSize: responsiveFontSize(context, mobile: 16, tablet: 28),
    fontWeight: FontWeight.w400,
    color: context.color.primaryFixed,
  );
  static TextStyle font16BlackMedium(BuildContext context) => TextStyle(
    fontSize: responsiveFontSize(context, mobile: 16, tablet: 28),
    fontWeight: FontWeight.w500,
    color: context.color.primaryFixed,
  );
  static TextStyle font16WhiteMedium(BuildContext context) => TextStyle(
    fontSize: responsiveFontSize(context, mobile: 16, tablet: 28),
    fontWeight: FontWeight.w500,
    color: context.color.onSecondary,
  );
  static TextStyle font16GreyRegular(BuildContext context) => TextStyle(
    fontSize: responsiveFontSize(context, mobile: 16, tablet: 28),
    fontWeight: FontWeight.w400,
    color: AppColorsLight.kGrey,
  );

  static TextStyle font16BlackSemiBold(BuildContext context) => TextStyle(
    fontSize: responsiveFontSize(context, mobile: 16, tablet: 28),
    fontWeight: FontWeight.w600,
    color: context.color.primaryFixed,
  );
  static TextStyle font16PrimarySemiBold(BuildContext context) => TextStyle(
    fontSize: responsiveFontSize(context, mobile: 16, tablet: 28),
    fontWeight: FontWeight.w600,
    color: AppColorsLight.kPrimary,
  );

  static TextStyle font18BlackSemiBold(BuildContext context) => TextStyle(
    fontSize: responsiveFontSize(context, mobile: 18,tablet: 28) ,
    fontWeight: FontWeight.w600,
    color: context.color.primaryFixed,
  );
  static TextStyle font18PrimarySemiBold(BuildContext context) => TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: AppColorsLight.kPrimary,
  );

  static TextStyle font24BlackSemiBold(BuildContext context) => TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    color: context.color.primaryFixed,
  );
  static TextStyle font24WhiteSemiBold(BuildContext context) => TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    color: context.color.onSecondary,
  );

  static TextStyle font34BlackBold(BuildContext context) => TextStyle(
    fontSize: responsiveFontSize(context, mobile: 34, tablet: 70),
    fontWeight: FontWeight.w700,
    color: context.color.primaryFixed,
  );
  static TextStyle font34WhiteBlack(BuildContext context) => TextStyle(
    fontSize: responsiveFontSize(context, mobile: 34, tablet: 70),
    fontWeight: FontWeight.w900,
    color: context.color.onSecondary,
  );

  static TextStyle font44BlackSemiBold(BuildContext context) => TextStyle(
    fontSize: 44.sp,
    fontWeight: FontWeight.w600,
    color: context.color.primaryFixed,
  );

  static TextStyle font48BlackBold(BuildContext context) => TextStyle(
    fontSize: 48.sp,
    fontWeight: FontWeight.w700,
    color: context.color.primaryFixed,
  );
}

//   /// Extra-light.== w200 
//   /// Light. == w300 
//   /// Normal / regular / plain.==== w400 
//   /// Medium.== w500 
//   /// Semi-bold.== w600 
//   /// Bold.== w700 
//   /// Extra-bold.== w800
//   /// Black, the most thick.== w900



// 10 regular /semibold
// 11 regular /semibold
// 14 medium / regular / semibold
// 15 semibold
// 16 semibold / regular
// 18 semibold 
// 24 semibold
// 34 bold
// 44 semibold
// 48 bold






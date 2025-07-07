import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/app_styles.dart';
import 'app_colors_light.dart';

ThemeData lightTheme(BuildContext context) => ThemeData(
  fontFamily: 'Metropolis',
  colorScheme: ColorScheme.light(
    primary: AppColorsLight.kPrimary,
    onPrimary: AppColorsLight.kLightBlack,
    secondary: AppColorsLight.kGrey,
    onSecondary: AppColorsLight.kwhite,
    error: AppColorsLight.kErrorColor,
    onTertiary: AppColorsLight.kSuccessColor,
    primaryFixed: AppColorsLight.kBlack,
    surface: AppColorsLight.kBackgroundColor,
    tertiary: AppColorsLight.kAmber,
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColorsLight.kwhite,
    labelStyle: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: AppColorsLight.kGrey,
    ),

    floatingLabelStyle: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: AppColorsLight.kGrey,
    ),
    border: UnderlineInputBorder(borderSide: BorderSide.none),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColorsLight.kPrimary),
    ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColorsLight.kErrorColor),
    ),
    focusedErrorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColorsLight.kErrorColor),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      padding: WidgetStateProperty.all(
        EdgeInsets.symmetric(horizontal: 0, vertical: 16),
      ),
      textStyle: WidgetStateProperty.all(
        TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColorsLight.kBlack,
          letterSpacing: 0.5,
        ),
      ),
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.pressed)
            ? AppColorsLight.kPrimary
            : AppColorsLight.kBlack;
      }),
      overlayColor: WidgetStateProperty.all(Colors.transparent),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      fixedSize: Size(double.maxFinite, 48.h),
      animationDuration: const Duration(milliseconds: 200),
      backgroundColor: AppColorsLight.kPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      foregroundColor: AppColorsLight.kwhite,
      textStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: AppColorsLight.kBlack,
        letterSpacing: 0.5,
      ),

      overlayColor: Colors.redAccent,
    ),
  ),

  //for the text fields value
  textTheme: TextTheme(
    bodyLarge: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: AppColorsLight.kBlack,
    ),
  ),
);

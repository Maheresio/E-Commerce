import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors_light.dart';

ThemeData lightTheme(BuildContext context) => ThemeData(
  fontFamily: 'Metropolis',
  colorScheme: const ColorScheme.light(
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
    border: const UnderlineInputBorder(borderSide: BorderSide.none),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: AppColorsLight.kPrimary),
    ),
    errorBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: AppColorsLight.kErrorColor),
    ),
    focusedErrorBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: AppColorsLight.kErrorColor),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(vertical: 16),
      ),
      textStyle: WidgetStateProperty.all(
        TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColorsLight.kBlack,
          letterSpacing: 0.5,
        ),
      ),
      foregroundColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) => states.contains(WidgetState.pressed)
            ? AppColorsLight.kPrimary
            : AppColorsLight.kBlack),
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

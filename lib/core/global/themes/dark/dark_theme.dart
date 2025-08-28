import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors_dark.dart';

ThemeData darkTheme(BuildContext context) => ThemeData(
  fontFamily: 'Metropolis',
  colorScheme: const ColorScheme.dark(
    primary: AppColorsDark.kPrimary,
    onPrimary: AppColorsDark.kLightWhite,
    secondary: AppColorsDark.kGrey,
    onSecondary: AppColorsDark.kBlack,
    error: AppColorsDark.kErrorColor,
    onTertiary: AppColorsDark.kSuccessColor,
    primaryFixed: AppColorsDark.kLightWhite,
    surface: AppColorsDark.kBackgroundColor,
    tertiary: AppColorsDark.kSuccessColor,
  ),

  scaffoldBackgroundColor: AppColorsDark.kBackgroundColor,

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColorsDark.kBlack,
    labelStyle: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: AppColorsDark.kGrey,
    ),
    floatingLabelStyle: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: AppColorsDark.kGrey,
    ),
    border: const UnderlineInputBorder(borderSide: BorderSide.none),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: AppColorsDark.kPrimary),
    ),
    errorBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: AppColorsDark.kErrorColor),
    ),
    focusedErrorBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: AppColorsDark.kErrorColor),
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
          color: AppColorsDark.kLightWhite,
          letterSpacing: 0.5,
          inherit: false,
        ),
      ),
      foregroundColor: WidgetStateProperty.resolveWith(
        (Set<WidgetState> states) =>
            states.contains(WidgetState.pressed)
                ? AppColorsDark.kPrimary
                : AppColorsDark.kLightWhite,
      ),
      overlayColor: WidgetStateProperty.all(Colors.transparent),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      fixedSize: Size(double.maxFinite, 48.h),
      animationDuration: const Duration(milliseconds: 200),
      backgroundColor: AppColorsDark.kPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      foregroundColor: AppColorsDark.kLightWhite,
      textStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: AppColorsDark.kLightWhite,
        letterSpacing: 0.5,
      ),
      overlayColor: Colors.redAccent,
    ),
  ),

  textTheme: TextTheme(
    bodyLarge: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: AppColorsDark.kLightWhite,
    ),
  ),
);

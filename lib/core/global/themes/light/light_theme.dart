import 'package:flutter/material.dart';

import '../../../utils/app_styles.dart';
import 'app_colors_light.dart';

ThemeData get lightTheme => ThemeData(
  fontFamily: 'Metropolis',
  scaffoldBackgroundColor: AppColorsLight.kBackgroundColor,
  colorScheme: ColorScheme.light(
    primary: AppColorsLight.kPrimary,
    error: AppColorsLight.kErrorColor,
    onPrimary: AppColorsLight.kLightBlack,
    secondary: AppColorsLight.kGrey,
    onSecondary: AppColorsLight.kwhite,
    onTertiary: AppColorsLight.kSuccessColor,
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColorsLight.kwhite,
    labelStyle: AppStyles.font14GreyRegular,

    floatingLabelStyle: AppStyles.font14GreyRegular,
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
        AppStyles.font14BlackRegular.copyWith(letterSpacing: 0.5),
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
      animationDuration: const Duration(milliseconds: 200),
      backgroundColor: AppColorsLight.kPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      foregroundColor: AppColorsLight.kwhite,
      textStyle: AppStyles.font14BlackMedium.copyWith(letterSpacing: 0.5),
      overlayColor: Colors.redAccent,
    ),
  ),
);

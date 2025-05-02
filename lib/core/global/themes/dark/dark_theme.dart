import 'package:flutter/material.dart';

import 'app_colors_dark.dart';

ThemeData get darkTheme => ThemeData.dark().copyWith(
  textTheme: ThemeData.dark().textTheme.apply(fontFamily: 'Metropolis'),
  scaffoldBackgroundColor: AppColorsDark.kBackgroundColor,

  colorScheme: ColorScheme.light(
    primary: AppColorsDark.kPrimary,
    error: AppColorsDark.kErrorColor,
    onPrimary: AppColorsDark.kLightWhite,
    secondary: AppColorsDark.kGrey,
  ),
);

// lib/core/theme/app_theme_context.dart
import 'package:e_commerce/core/responsive/responsive_provider.dart';
import 'package:flutter/material.dart';
import '../../responsive/device_type.dart';

class AppThemeContext {
  static late ThemeData theme;
  static late ColorScheme color;
  static late TextTheme text;
  static late DeviceType deviceType;
}

class ThemeContextInitializer extends StatelessWidget {
  final Widget child;

  const ThemeContextInitializer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    AppThemeContext.theme = Theme.of(context);
    AppThemeContext.color = Theme.of(context).colorScheme;
    AppThemeContext.text = Theme.of(context).textTheme;
    AppThemeContext.deviceType = ResponsiveProvider.of(context);

    return child;
  }
}

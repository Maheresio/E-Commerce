import 'package:flutter/material.dart';

import '../../global/themes/app_theme_context.dart';
import '../../responsive/device_type.dart';

extension AppThemeAccess on BuildContext {
  ThemeData get theme => AppThemeContext.theme;
  ColorScheme get color => AppThemeContext.color;
  TextTheme get text => AppThemeContext.text;
  DeviceType get deviceType => AppThemeContext.deviceType;
}

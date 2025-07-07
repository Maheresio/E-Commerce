import 'package:e_commerce/core/responsive/device_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' hide DeviceType;

double responsiveFontSize(
  BuildContext context, {
  required double mobile,
  double? tablet,
  double? desktop,
  double? largeDesktop,
}) {
  final width = MediaQuery.of(context).size.width;
  final deviceType = getDeviceTypeFromWidth(width);

  final base = switch (deviceType) {
    DeviceType.mobile => mobile,
    DeviceType.tablet => tablet ?? mobile,
    DeviceType.desktop => desktop ?? tablet ?? mobile,
    DeviceType.largeDesktop => largeDesktop ?? desktop ?? tablet ?? mobile,
  };

  return base.sp;
}

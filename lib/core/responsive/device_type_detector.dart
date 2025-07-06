import 'package:flutter/material.dart';
import 'device_type.dart';

DeviceType getDeviceTypeFromContext(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final orientation = MediaQuery.of(context).orientation;

  final double logicalWidth = orientation == Orientation.portrait
      ? size.width
      : size.height; // prevents treating phones in landscape as tablets

  if (logicalWidth >= 1600) return DeviceType.largeDesktop;
  if (logicalWidth >= 1100) return DeviceType.desktop;
  if (logicalWidth >= 600) return DeviceType.tablet;

  return DeviceType.mobile;
}

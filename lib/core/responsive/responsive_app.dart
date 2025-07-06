import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../responsive/device_type_detector.dart';
import '../responsive/device_type_holder.dart';

class ResponsiveApp extends StatelessWidget {
  final Widget Function(BuildContext context) builder;
  final Size designSize;

  const ResponsiveApp({
    super.key,
    required this.builder,
    this.designSize = const Size(375, 812),
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: designSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, _) {
        return Builder(
          builder: (context) {
            final deviceType = getDeviceTypeFromContext(context);
            DeviceTypeHolder.init(deviceType);
            return builder(context);
          },
        );
      },
    );
  }
}

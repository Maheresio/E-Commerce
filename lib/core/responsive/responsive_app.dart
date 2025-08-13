import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'device_type.dart';
import 'responsive_provider.dart';

class ResponsiveApp extends StatelessWidget {

  const ResponsiveApp({
    super.key,
    required this.builder,
    this.designSize = const Size(375, 812),
  });
  final WidgetBuilder builder;
  final Size designSize;

  @override
  Widget build(BuildContext context) => ScreenUtilInit(
      designSize: designSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final deviceType = getDeviceTypeFromWidth(width);

            return ResponsiveProvider(
              deviceType: deviceType,
              child: Builder(builder: builder),
            );
          },
        );
      },
    );
}

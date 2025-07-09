import 'package:flutter/widgets.dart';
import 'responsive_provider.dart';
import 'device_type.dart';

T responsiveValue<T>({
  required BuildContext context,
  required T mobile,
  T? tablet,
  T? desktop,
  T? largeDesktop,
}) {
  final type = ResponsiveProvider.of(context);

  switch (type) {
    case DeviceType.largeDesktop:
      return largeDesktop ?? desktop ?? tablet ?? mobile;
    case DeviceType.desktop:
      return desktop ?? tablet ?? mobile;
    case DeviceType.tablet:
      return tablet ?? mobile;
    case DeviceType.mobile:
      return mobile;
  }
}

extension ResponsiveX on BuildContext {
  T responsive<T>({required T mobile, T? tablet, T? desktop, T? largeDesktop}) {
    return responsiveValue(
      context: this,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      largeDesktop: largeDesktop,
    );
  }
}

// lib/core/responsive/responsive_value.dart
import 'device_type_holder.dart';
import 'device_type.dart';

T responsiveValue<T>({
  required T mobile,
  T? tablet,
  T? desktop,
  T? largeDesktop,
}) {
  final type = DeviceTypeHolder.value;

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

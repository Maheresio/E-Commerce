import 'package:flutter/widgets.dart';
import 'device_type.dart';

class ResponsiveProvider extends InheritedWidget {
  final DeviceType deviceType;

  const ResponsiveProvider({
    super.key,
    required this.deviceType,
    required super.child,
  });

  static DeviceType of(BuildContext context) {
    final inherited =
        context.dependOnInheritedWidgetOfExactType<ResponsiveProvider>();
    assert(inherited != null, 'ResponsiveProvider not found in widget tree');
    return inherited!.deviceType;
  }

  @override
  bool updateShouldNotify(ResponsiveProvider oldWidget) {
    return oldWidget.deviceType != deviceType;
  }
}

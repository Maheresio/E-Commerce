import 'package:flutter/widgets.dart';
import 'device_type.dart';

class ResponsiveProvider extends InheritedWidget {

  const ResponsiveProvider({
    super.key,
    required this.deviceType,
    required super.child,
  });
  final DeviceType deviceType;

  static DeviceType of(BuildContext context) {
    final ResponsiveProvider? inherited =
        context.dependOnInheritedWidgetOfExactType<ResponsiveProvider>();
    assert(inherited != null, 'ResponsiveProvider not found in widget tree');
    return inherited!.deviceType;
  }

  @override
  bool updateShouldNotify(ResponsiveProvider oldWidget) => oldWidget.deviceType != deviceType;
}

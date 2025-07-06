import 'device_type.dart';

class DeviceTypeHolder {
  static DeviceType? _deviceType;

  static void init(DeviceType type) {
    _deviceType = type;
  }

  static DeviceType get value {
    if (_deviceType == null) {
      throw Exception('DeviceTypeHolder not initialized');
    }
    return _deviceType!;
  }
}

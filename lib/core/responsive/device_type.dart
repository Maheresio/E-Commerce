enum DeviceType { mobile, tablet, desktop, largeDesktop }

DeviceType getDeviceTypeFromWidth(double width) {
  if (width >= 1600) return DeviceType.largeDesktop;
  if (width >= 1100) return DeviceType.desktop;
  if (width >= 600) return DeviceType.tablet;
  return DeviceType.mobile;
}

import 'failure.dart';

class PermissionFailure extends Failure {
  const PermissionFailure(super.message);

  factory PermissionFailure.fromCode(String code) {
    switch (code) {
      case 'camera-permission-denied':
        return const PermissionFailure(
          'Camera permission is required to take photos. Please enable it in settings.',
        );
      case 'storage-permission-denied':
        return const PermissionFailure(
          'Storage permission is required to save files. Please enable it in settings.',
        );
      case 'location-permission-denied':
        return const PermissionFailure(
          'Location permission is required for this feature. Please enable it in settings.',
        );
      case 'notification-permission-denied':
        return const PermissionFailure(
          'Notification permission is required to receive updates. Please enable it in settings.',
        );
      case 'microphone-permission-denied':
        return const PermissionFailure(
          'Microphone permission is required for this feature. Please enable it in settings.',
        );
      case 'contacts-permission-denied':
        return const PermissionFailure(
          'Contacts permission is required to access your contacts. Please enable it in settings.',
        );
      case 'calendar-permission-denied':
        return const PermissionFailure(
          'Calendar permission is required to access your calendar. Please enable it in settings.',
        );
      case 'photo-library-permission-denied':
        return const PermissionFailure(
          'Photo library permission is required to select images. Please enable it in settings.',
        );
      case 'biometric-permission-denied':
        return const PermissionFailure(
          'Biometric authentication permission is required. Please enable it in settings.',
        );
      case 'permission-permanently-denied':
        return const PermissionFailure(
          'Permission was permanently denied. Please go to app settings to enable it manually.',
        );
      default:
        return const PermissionFailure(
          'Permission is required for this feature. Please check your device settings.',
        );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ToastType { success, error, warning, info }

class ElegantToast {
  static void show({
    required BuildContext context,
    required String message,
    required ToastType type,
    Duration duration = const Duration(seconds: 2),
  }) {
    final OverlayState overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder:
          (BuildContext context) => _ToastWidget(
            message: message,
            type: type,
            onDismiss: () => overlayEntry.remove(),
          ),
    );

    overlay.insert(overlayEntry);

    // Auto dismiss after duration
    Future.delayed(duration, () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}

class _ToastWidget extends HookWidget {

  const _ToastWidget({
    required this.message,
    required this.type,
    required this.onDismiss,
  });
  final String message;
  final ToastType type;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final AnimationController controller = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );

    final AnimationController dragController = useAnimationController(
      duration: const Duration(milliseconds: 200),
    );

    final Animation<Offset> slideAnimation = useMemoized(
      () => Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut)),
      <Object?>[controller],
    );

    final Animation<double> opacityAnimation = useMemoized(
      () => Tween<double>(
        begin: 0,
        end: 1,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut)),
      <Object?>[controller],
    );

    final Animation<Offset> dragAnimation = useMemoized(
      () => Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(1.5, 0),
      ).animate(CurvedAnimation(parent: dragController, curve: Curves.easeIn)),
      <Object?>[dragController],
    );

    final Animation<Offset> dragAnimationLeft = useMemoized(
      () => Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(-1.5, 0),
      ).animate(CurvedAnimation(parent: dragController, curve: Curves.easeIn)),
      <Object?>[dragController],
    );

    final Animation<double> dragOpacityAnimation = useMemoized(
      () => Tween<double>(
        begin: 1,
        end: 0,
      ).animate(CurvedAnimation(parent: dragController, curve: Curves.easeIn)),
      <Object?>[dragController],
    );

    final ValueNotifier<double> dragDirection = useState(1); // 1.0 for right, -1.0 for left

    useEffect(() {
      controller.forward();
      return null;
    }, <Object?>[]);

    void handleDismiss() {
      dragController.forward().then((_) => onDismiss());
    }

    final _ToastConfig config = _getToastConfig(type);

    return Positioned(
      bottom: 50.h,
      left: 20.w,
      right: 20.w,
      child: AnimatedBuilder(
        animation: Listenable.merge(<Listenable?>[controller, dragController]),
        builder: (BuildContext context, Widget? child) => SlideTransition(
            position: slideAnimation,
            child: SlideTransition(
              position:
                  dragDirection.value > 0 ? dragAnimation : dragAnimationLeft,
              child: FadeTransition(
                opacity: opacityAnimation,
                child: FadeTransition(
                  opacity: dragOpacityAnimation,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      // Update drag animation based on horizontal movement
                      final dragDistance =
                          details.delta.dx / MediaQuery.of(context).size.width;
                      final newValue = (dragController.value +
                              dragDistance.abs() * 2)
                          .clamp(0.0, 1.0);
                      dragController.value = newValue;

                      // Track drag direction
                      if (details.delta.dx > 0) {
                        dragDirection.value = 1.0; // Right
                      } else if (details.delta.dx < 0) {
                        dragDirection.value = -1.0; // Left
                      }
                    },
                    onPanEnd: (details) {
                      // If dragged more than 30% or with sufficient velocity, dismiss
                      if (dragController.value > 0.3 ||
                          details.velocity.pixelsPerSecond.dx.abs() > 300) {
                        handleDismiss();
                      } else {
                        // Reset to original position
                        dragController.reverse();
                      }
                    },
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: config.backgroundColor,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              config.icon,
                              color: config.iconColor,
                              size: 20.sp,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                message,
                                style: TextStyle(
                                  color: config.textColor,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ),
    );
  }

  static _ToastConfig _getToastConfig(ToastType type) {
    switch (type) {
      case ToastType.success:
        return const _ToastConfig(
          title: 'Success',
          icon: Icons.check_circle_outline,
          backgroundColor: Color(0xFF4CAF50),
          iconColor: Colors.white,
          textColor: Colors.white,
        );
      case ToastType.error:
        return const _ToastConfig(
          title: 'Error',
          icon: Icons.error_outline,
          backgroundColor: Color(0xFFE53E3E),
          iconColor: Colors.white,
          textColor: Colors.white,
        );
      case ToastType.warning:
        return const _ToastConfig(
          title: 'Warning',
          icon: Icons.warning_amber_outlined,
          backgroundColor: Color(0xFFFF9800),
          iconColor: Colors.white,
          textColor: Colors.white,
        );
      case ToastType.info:
        return const _ToastConfig(
          title: 'Info',
          icon: Icons.info_outline,
          backgroundColor: Color(0xFF2196F3),
          iconColor: Colors.white,
          textColor: Colors.white,
        );
    }
  }
}

class _ToastConfig {

  const _ToastConfig({
    required this.title,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.textColor,
  });
  final String title;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;
}

// Convenience methods for easy usage
void showSuccessToast(BuildContext context, String message) {
  ElegantToast.show(
    context: context,
    message: message,
    type: ToastType.success,
  );
}

void showErrorToast(BuildContext context, String message) {
  ElegantToast.show(
    context: context,
    message: message,
    type: ToastType.error,
    duration: const Duration(seconds: 3),
  );
}

void showWarningToast(BuildContext context, String message) {
  ElegantToast.show(
    context: context,
    message: message,
    type: ToastType.warning,
  );
}

void showInfoToast(BuildContext context, String message) {
  ElegantToast.show(
    context: context,
    message: message,
    type: ToastType.info,
  );
}

// Backward compatibility with existing code
Widget errorToast(BuildContext context, String message) {
  showErrorToast(context, message);
  return const SizedBox.shrink();
}

Widget successToast(BuildContext context, String message) {
  showSuccessToast(context, message);
  return const SizedBox.shrink();
}

Widget warningToast(BuildContext context, String message) {
  showWarningToast(context, message);
  return const SizedBox.shrink();
}

Widget infoToast(BuildContext context, String message) {
  showInfoToast(context, message);
  return const SizedBox.shrink();
}

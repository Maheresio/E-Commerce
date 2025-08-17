import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StyledSocialButton extends StatelessWidget {
  const StyledSocialButton({
    super.key,
    required this.image,
    required this.onTap,
    this.backgroundColor,
    this.iconColor,
    this.size,
  });

  final String image;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? iconColor;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final buttonSize = size ?? 64.w;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
                backgroundColor != null
                    ? [
                      backgroundColor!,
                      backgroundColor!.withValues(alpha: 0.9),
                    ]
                    : [
                      theme.primaryColor,
                      theme.primaryColor.withValues(alpha: 0.9),
                    ],
          ),
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: (backgroundColor ?? theme.primaryColor).withValues(
                alpha: 0.25,
              ),
              blurRadius: 16,
              offset: const Offset(0, 6),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18.r),
            onTap: onTap,
            splashColor: Colors.white.withValues(alpha: 0.1),
            highlightColor: Colors.white.withValues(alpha: 0.05),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.r),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  image,
                  width: buttonSize * 0.4,
                  height: buttonSize * 0.4,
                  colorFilter: ColorFilter.mode(
                    iconColor ?? Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

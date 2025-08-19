import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Wrap any child to get the same shimmer palette
/// as your CachedImageWidget placeholder.
class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
  });

  /// Defaults to Colors.grey[300]
  final Color? baseColor;

  /// Defaults to Colors.grey[100]
  final Color? highlightColor;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? Colors.grey[300]!,
      highlightColor: highlightColor ?? Colors.grey[100]!,
      // We render the child as-is; make sure leaf boxes are white
      // so the shimmer reads like your CachedImageWidget.
      child: child,
    );
  }
}

/// Simple rectangular shimmer block.
/// Defaults to a white fill so the shimmer overlay reads clearly.
class ShimmerContainer extends StatelessWidget {
  const ShimmerContainer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
    this.color,
  });

  final double width;
  final double height;
  final double borderRadius;

  /// Fill color under the shimmer. Defaults to white to match your example.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

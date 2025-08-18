import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({
    super.key,
    required this.width,
    required this.height,
    this.radius = 8.0,
    this.margin = EdgeInsets.zero,
    this.color,
    this.delay = const Duration(milliseconds: 0),
  });

  final double width;
  final double height;
  final double radius;
  final EdgeInsets margin;
  final Color? color;
  final Duration delay;

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading> {
  bool _isVisible = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.delay.inMilliseconds > 0) {
      _timer = Timer(widget.delay, () {
        if (mounted) {
          setState(() => _isVisible = true);
        }
      });
    } else {
      _isVisible = true;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        margin: widget.margin,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.radius),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            period: const Duration(milliseconds: 1500),

            direction: ShimmerDirection.ltr,
            child: Container(
              width: widget.width,
              height: widget.height,
              color: widget.color ?? Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class ProductShimmerItem extends StatelessWidget {
  const ProductShimmerItem({
    super.key,
    required this.width,
    required this.height,
    this.padding = const EdgeInsets.all(8.0),
  });

  final double width;
  final double height;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          ShimmerLoading(
            width: double.infinity,
            height: height * 0.6,
            radius: 12.0,
          ),
          const SizedBox(height: 12),
          // Title placeholder
          ShimmerLoading(
            width: width * 0.8,
            height: 16,
            radius: 4.0,
            margin: const EdgeInsets.only(bottom: 8),
          ),
          // Subtitle placeholder
          ShimmerLoading(
            width: width * 0.6,
            height: 14,
            radius: 4.0,
            margin: const EdgeInsets.only(bottom: 12),
          ),
          ShimmerLoading(
            width: width * 0.6,
            height: 14,
            radius: 4.0,
            margin: const EdgeInsets.only(bottom: 12),
          ),
          // Price and button row
          ShimmerLoading(width: width * 0.3, height: 16, radius: 4.0),
        ],
      ),
    );
  }
}

class HorizontalShimmerList extends StatelessWidget {
  const HorizontalShimmerList({
    super.key,
    required this.itemCount,
    required this.itemWidth,
    required this.itemHeight,
    this.itemMargin = 8.0,
    this.padding = EdgeInsets.zero,
  });

  final int itemCount;
  final double itemWidth;
  final double itemHeight;
  final double itemMargin;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: itemHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        padding: padding,
        itemCount: itemCount,
        separatorBuilder: (_, _) => SizedBox(width: itemMargin),
        itemBuilder:
            (_, index) => ProductShimmerItem(
              key: ValueKey('shimmer_$index'),
              width: itemWidth,
              height: itemHeight,
            ),
      ),
    );
  }
}

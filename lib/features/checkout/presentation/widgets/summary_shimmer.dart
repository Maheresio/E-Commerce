import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/shimmer.dart';

class SummarySectionShimmer extends StatelessWidget {
  const SummarySectionShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      spacing: 14,
      children: <Widget>[
        // Order shimmer tile
        SummaryPriceTileShimmer(
          titleWidth: 50, // "Order:"
          priceWidth: 80, // "$123.45"
        ),
        // Delivery shimmer tile
        SummaryPriceTileShimmer(
          titleWidth: 65, // "Delivery:"
          priceWidth: 60, // "$5.99"
        ),
        // Summary shimmer tile
        SummaryPriceTileShimmer(
          titleWidth: 70, // "Summary:"
          priceWidth: 90, // "$129.44"
        ),
      ],
    );
  }
}

class SummaryPriceTileShimmer extends StatelessWidget {
  const SummaryPriceTileShimmer({
    super.key,
    required this.titleWidth,
    required this.priceWidth,
  });

  final double titleWidth;
  final double priceWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Title shimmer (e.g., "Order:", "Delivery:", "Summary:")
        ShimmerWidget(
          child: ShimmerContainer(
            width: titleWidth.w,
            height: 16.h, // Height for font14 text
            borderRadius: 4,
          ),
        ),
        // Price shimmer (e.g., "$123.45", "$5.99")
        ShimmerWidget(
          child: ShimmerContainer(
            width: priceWidth.w,
            height: 20.h, // Height for font18 text
            borderRadius: 4,
          ),
        ),
      ],
    );
  }
}

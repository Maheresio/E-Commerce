import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helpers/extensions/context_extensions.dart';
import '../../../../core/utils/app_styles.dart';

import '../../../home/domain/entities/product_entity.dart';

/// Widget to display rating overview with breakdown bars
class RatingOverviewWidget extends StatelessWidget {
  const RatingOverviewWidget({super.key, required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) => Row(
    spacing: 28.w,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Overall rating display
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            product.rating.toString(),
            style: AppStyles.font44BlackSemiBold(context).copyWith(height: 1.2),
          ),
          Text(
            '${product.reviewCount} ratings',
            style: AppStyles.font14GreyRegular(context),
          ),
        ],
      ),

      // Rating breakdown bars
      Expanded(
        child: Column(
          children: List.generate(
            5,
            (index) => RatingBarWidget(
              product: product,
              starCount: 5 - index,
              ratingCount: product.ratingsBreakdown[5 - index] ?? 0,
              totalRating: product.rating,
            ),
          ),
        ),
      ),
    ],
  );
}

class RatingBarWidget extends StatelessWidget {
  const RatingBarWidget({
    super.key,
    required this.product,
    required this.starCount,
    required this.ratingCount,
    required this.totalRating,
  });

  final int starCount;
  final int ratingCount;
  final double totalRating;
  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    // First, calculate the total number of ratings
    int getTotalRatingsCount() {
      return product.ratingsBreakdown.values.fold(
        0,
        (sum, count) => sum + count,
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 15.w,
      children: [
        // Stars
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: List.generate(
              starCount,
              (i) =>
                  Icon(Icons.star, color: context.color.tertiary, size: 15.w),
            ),
          ),
        ),

        // Progress bar
        Expanded(
          flex: 2,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              alignment: AlignmentDirectional.centerStart,
              height: 8.h,
              width: (ratingCount / getTotalRatingsCount()) * 200.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.r),

                color: context.color.primary,
              ),
            ),
          ),
        ),

        // Count
        Expanded(
          flex: 1,
          child: Text(
            ratingCount.toString(),
            style: AppStyles.font14BlackMedium(context),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

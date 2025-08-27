import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/extensions/context_extensions.dart';
import '../../../../core/widgets/shimmer.dart';

class ShippingAddressCardShimmer extends StatelessWidget {
  const ShippingAddressCardShimmer({super.key, this.isEditable = false});

  final bool isEditable;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: context.color.onSecondary,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: context.color.primary.withValues(alpha: 0.12),
          spreadRadius: 1.5,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 18.h),
      child: ShimmerWidget(
        child: Column(
          spacing: 7,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name and Edit/Change button row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerContainer(width: 120.w, height: 16.h, borderRadius: 4),
                ShimmerContainer(
                  width: isEditable ? 40.w : 60.w,
                  height: 16.h,
                  borderRadius: 4,
                ),
              ],
            ),

            // Address lines (street, city, state, zip)
            ShimmerContainer(
              width: double.infinity,
              height: 14.h,
              borderRadius: 4,
            ),
            ShimmerContainer(
              width: 0.7.sw, // 70% of screen width
              height: 14.h,
              borderRadius: 4,
            ),

            // Checkbox for default address (only if editable)
            if (isEditable) ...[
              SizedBox(height: 4.h),
              Row(
                children: [
                  ShimmerContainer(width: 18.w, height: 18.h, borderRadius: 3),
                  SizedBox(width: 8.w),
                  ShimmerContainer(width: 140.w, height: 14.h, borderRadius: 4),
                ],
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

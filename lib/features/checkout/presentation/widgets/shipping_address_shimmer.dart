import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/extensions/context_extensions.dart';
import '../../../../core/widgets/shimmer.dart';

class ShippingAddressListShimmer extends StatelessWidget {
  const ShippingAddressListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 3, // Show 3 shimmer address cards
      itemBuilder: (BuildContext context, int index) {
        return const ShippingAddressCardShimmer(isEditable: true);
      },
      separatorBuilder: (BuildContext context, int index) => SizedBox(height: 24.h),
    );
  }
}

class ShippingAddressCardShimmer extends StatelessWidget {
  const ShippingAddressCardShimmer({super.key, this.isEditable = false});

  final bool isEditable;

  @override
  Widget build(BuildContext context) {
    final theme = context.color;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.onSecondary,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: theme.primary.withValues(alpha: 0.12),
            spreadRadius: 1.5,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 18.h),
        child: Column(
          spacing: 7,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row - Name and Edit/Change button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Name shimmer
                ShimmerWidget(
                  child: ShimmerContainer(
                    width: 120.w, // Typical name length
                    height: 16.h, // Height for font14 text
                    borderRadius: 4,
                  ),
                ),
                // Edit/Change button shimmer
                ShimmerWidget(
                  child: ShimmerContainer(
                    width: isEditable ? 40.w : 60.w, // "Edit" vs "Change"
                    height: 16.h, // Height for font14 text
                    borderRadius: 4,
                  ),
                ),
              ],
            ),

            // Address text shimmer - Two lines
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Street address line
                ShimmerWidget(
                  child: ShimmerContainer(
                    width: double.infinity, // Full width for street
                    height: 16.h, // Height for font14 text
                    borderRadius: 4,
                  ),
                ),
                SizedBox(height: 4.h), // Small gap between address lines
                // City, State, Zip line
                ShimmerWidget(
                  child: ShimmerContainer(
                    width: 0.7.sw, // 70% width for city/state/zip
                    height: 16.h, // Height for font14 text
                    borderRadius: 4,
                  ),
                ),
              ],
            ),

            // Default checkbox (only if editable)
            if (isEditable) ...[
              SizedBox(height: 4.h), // Small gap before checkbox
              Row(
                children: [
                  // Checkbox shimmer
                  ShimmerWidget(
                    child: ShimmerContainer(
                      width: 18.w,
                      height: 18.h,
                      borderRadius: 3,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  // Checkbox label shimmer
                  ShimmerWidget(
                    child: ShimmerContainer(
                      width: 140.w, // "Use as shipping address"
                      height: 14.h,
                      borderRadius: 4,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
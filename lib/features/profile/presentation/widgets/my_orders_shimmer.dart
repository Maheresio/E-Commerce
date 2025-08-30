import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/extensions/context_extensions.dart';
import '../../../../core/widgets/shimmer.dart';

class MyOrdersListShimmer extends StatelessWidget {
  const MyOrdersListShimmer({super.key, required this.horizontalPadding});
  
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: ListView.separated(
        itemBuilder: (_, index) => const MyOrdersListViewItemShimmer(),
        separatorBuilder: (_, __) => const SizedBox(height: 28),
        itemCount: 4, // Show 4 shimmer order items
      ),
    );
  }
}

class MyOrdersListViewItemShimmer extends StatelessWidget {
  const MyOrdersListViewItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColors = context.color;
    
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 2.h,
          children: [
            // Header Row - Order Code and Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Order Code shimmer (e.g., "Order №1947034")
                ShimmerWidget(
                  child: ShimmerContainer(
                    width: 120.w,
                    height: 18.h, // Height for font16 text
                    borderRadius: 4,
                  ),
                ),
                // Date shimmer (e.g., "05-12-2019")
                ShimmerWidget(
                  child: ShimmerContainer(
                    width: 80.w,
                    height: 16.h, // Height for font14 text
                    borderRadius: 4,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Order Details Column
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tracking Number Row
                Row(
                  children: [
                    // "Tracking number:" label shimmer
                    ShimmerWidget(
                      child: ShimmerContainer(
                        width: 100.w,
                        height: 16.h, // Height for font14 text
                        borderRadius: 4,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    // Tracking number value shimmer
                    ShimmerWidget(
                      child: ShimmerContainer(
                        width: 90.w,
                        height: 16.h,
                        borderRadius: 4,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h), // Small gap between tracking and quantity/amount row
                
                // Quantity and Total Amount Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Quantity section
                    Row(
                      children: [
                        // "Quantity:" label shimmer
                        ShimmerWidget(
                          child: ShimmerContainer(
                            width: 60.w,
                            height: 16.h,
                            borderRadius: 4,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        // Quantity value shimmer
                        ShimmerWidget(
                          child: ShimmerContainer(
                            width: 20.w,
                            height: 16.h,
                            borderRadius: 4,
                          ),
                        ),
                      ],
                    ),
                    // Total Amount section
                    Row(
                      children: [
                        // "Total Amount" label shimmer
                        ShimmerWidget(
                          child: ShimmerContainer(
                            width: 80.w,
                            height: 16.h,
                            borderRadius: 4,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        // Amount value shimmer
                        ShimmerWidget(
                          child: ShimmerContainer(
                            width: 50.w,
                            height: 16.h,
                            borderRadius: 4,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Bottom Row - Details Button and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Details Button Shimmer
                Container(
                  width: 100.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: themeColors.primaryFixed.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                    color: themeColors.onSecondary,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Center(
                    child: ShimmerWidget(
                      child: ShimmerContainer(
                        width: 50.w,
                        height: 14.h,
                        borderRadius: 4,
                      ),
                    ),
                  ),
                ),
                // Status shimmer (e.g., "Delivered", "Processing")
                ShimmerWidget(
                  child: ShimmerContainer(
                    width: 70.w,
                    height: 16.h,
                    borderRadius: 4,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
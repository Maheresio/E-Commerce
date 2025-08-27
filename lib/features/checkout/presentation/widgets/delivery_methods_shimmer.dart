import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/extensions/context_extensions.dart';
import '../../../../core/widgets/shimmer.dart';

class DeliveryMethodsShimmer extends StatelessWidget {
  const DeliveryMethodsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColors = context.color;

    return SingleChildScrollView(
      clipBehavior: Clip.none,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: SizedBox(
        height: 105.h,
        child: Row(
          spacing: 12.w,
          children: List.generate(
            3, // Show 3 shimmer items
            (index) {
              // Vary the shimmer items - make first one look "selected"
              final isFirstItem = index == 0;

              return Container(
                width: 110.w,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isFirstItem ? 0.15 : 0.1,
                      ),
                      blurRadius: isFirstItem ? 12 : 8,
                      spreadRadius: isFirstItem ? 2 : 1,
                      offset: Offset(0, isFirstItem ? 6 : 4),
                    ),
                  ],
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors:
                        isFirstItem
                            ? [
                              themeColors.primary.withValues(alpha: 0.2),
                              themeColors.primary.withValues(alpha: 0.1),
                            ]
                            : [Colors.white, Colors.grey.shade50],
                  ),
                  border:
                      isFirstItem
                          ? Border.all(color: themeColors.primary, width: 2)
                          : null,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon container - matches the original structure
                      Container(
                        width: double.infinity * .9,
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: themeColors.primary.withValues(
                            alpha: isFirstItem ? 0.2 : 0.1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      // Individual shimmer for the duration text
                      ShimmerWidget(
                        child: ShimmerContainer(
                          width: index == 0 ? 70.w : (index == 1 ? 55.w : 65.w),
                          height: 12.h,
                          borderRadius: 4,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

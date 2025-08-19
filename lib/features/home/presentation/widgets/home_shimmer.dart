import '../../../../core/responsive/responsive_value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_constants.dart';
import '../../../../core/widgets/shimmer.dart';

// Shimmer for Header Section

// Individual Product Item Shimmer for Horizontal List
class HomeHorizontalListItemShimmer extends StatelessWidget {
  const HomeHorizontalListItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWidget(
      child: SizedBox(
        width: context.responsive(mobile: 150.w, tablet: 250.w),
        child: Column(
          spacing: 8,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Shimmer with favorite icon
            Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                  child: AspectRatio(
                    aspectRatio: context.responsive(mobile: 0.8, tablet: 1),
                    child: const ShimmerContainer(
                      width: double.infinity,
                      height: double.infinity,
                      borderRadius: 10,
                    ),
                  ),
                ),
                // Favorite icon shimmer
                Positioned.directional(
                  textDirection: TextDirection.ltr,
                  bottom: 0,
                  end: 0,
                  child: ShimmerContainer(
                    width: context.responsive(mobile: 32.w, tablet: 60.w),
                    height: context.responsive(mobile: 32.h, tablet: 60.h),
                    borderRadius: context.responsive(mobile: 16, tablet: 30),
                  ),
                ),
                // Discount badge shimmer (positioned like the original)
                Positioned.directional(
                  textDirection: TextDirection.ltr,
                  top: context.responsive(mobile: 16.h, tablet: 24.h),
                  start: context.responsive(mobile: 16.w, tablet: 24.w),
                  child: ShimmerContainer(
                    width: context.responsive(mobile: 40.w, tablet: 80.w),
                    height: context.responsive(mobile: 24.h, tablet: 50.h),
                    borderRadius: 29,
                  ),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: context.responsive(mobile: 8, tablet: 12),
                children: [
                  // Rating and review shimmer
                  Row(
                    children: [
                      // Rating stars shimmer
                      Row(
                        children: List.generate(5, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 2),
                            child: ShimmerContainer(
                              width: context.responsive(
                                mobile: 16.w,
                                tablet: 32.w,
                              ),
                              height: context.responsive(
                                mobile: 16.w,
                                tablet: 32.w,
                              ),
                              borderRadius: context.responsive(
                                mobile: 8,
                                tablet: 16,
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(width: 4),
                      // Review count shimmer
                      ShimmerContainer(
                        width: 30.w,
                        height: 12.h,
                        borderRadius: 6,
                      ),
                    ],
                  ),

                  // Brand shimmer
                  ShimmerContainer(width: 60.w, height: 12.h, borderRadius: 6),

                  // Product name shimmer (2 lines)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerContainer(
                        width: 130.w,
                        height: 16.h,
                        borderRadius: 8,
                      ),
                      SizedBox(height: 4.h),
                      ShimmerContainer(
                        width: 100.w,
                        height: 16.h,
                        borderRadius: 8,
                      ),
                    ],
                  ),

                  // Price shimmer
                  ShimmerContainer(width: 80.w, height: 14.h, borderRadius: 7),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Complete Horizontal List Shimmer
class HomeHorizontalListViewShimmer extends StatelessWidget {
  const HomeHorizontalListViewShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 6,
      children: [
        Flexible(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double itemHeight = constraints.maxHeight;

              return ListView.separated(
                scrollDirection: Axis.horizontal,
                physics:
                    const NeverScrollableScrollPhysics(), // no scroll for shimmer
                itemBuilder: (context, index) {
                  final item = SizedBox(
                    height: itemHeight, // lock item to available height
                    child: const HomeHorizontalListItemShimmer(),
                  );

                  // Add left padding only to the first item
                  if (index == 0) {
                    return Padding(
                      padding: EdgeInsetsDirectional.only(
                        start: AppConstants.horizontalPadding16,
                      ),
                      child: item,
                    );
                  }
                  // Add right padding only to the last item (3 items)
                  if (index == 2) {
                    return Padding(
                      padding: EdgeInsetsDirectional.only(
                        end: AppConstants.horizontalPadding16,
                      ),
                      child: item,
                    );
                  }

                  return item;
                },
                separatorBuilder: (_, __) => SizedBox(width: 0.w),
                itemCount: 3, // Show 3 shimmer items
              );
            },
          ),
        ),
      ],
    );
  }
}

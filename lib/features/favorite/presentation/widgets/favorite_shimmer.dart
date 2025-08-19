import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/shimmer.dart';

// Shimmer for individual Favorite List Item
class FavoriteListItemShimmer extends StatelessWidget {
  const FavoriteListItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: const Key('shimmer_dismissible'),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(10.r),
        ),
        alignment: AlignmentDirectional.centerEnd,
        padding: EdgeInsets.only(right: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShimmerContainer(width: 24.w, height: 24.h, borderRadius: 12),
            SizedBox(height: 4.h),
            ShimmerContainer(width: 40.w, height: 12.h, borderRadius: 6),
          ],
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
            child: Container(
              height: 130.h,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                spacing: 10.w,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Product Image Shimmer - Dedicated shimmer for image area
                  Expanded(
                    flex: 2,
                    child: ClipRRect(
                      borderRadius: BorderRadiusDirectional.only(
                        topStart: Radius.circular(8.r),
                        bottomStart: Radius.circular(8.r),
                      ),
                      child: ShimmerWidget(
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
                  ),

                  // Content Section Shimmer - Dedicated shimmer for content area
                  Expanded(
                    flex: 4,
                    child: ShimmerWidget(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.h,
                          horizontal: 4.w,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product name and close icon row
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Product name shimmer blocks
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // First line of product name
                                      Container(
                                        width: double.infinity,
                                        height: 18.h,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(
                                            4.r,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      // Second line of product name (shorter)
                                      Container(
                                        width: 0.7.sw,
                                        height: 18.h,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(
                                            4.r,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                // Close icon shimmer
                                Container(
                                  width: 20.w,
                                  height: 20.h,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 8.h),

                            // Brand name shimmer
                            Container(
                              width: 80.w,
                              height: 14.h,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),

                            SizedBox(height: 8.h),

                            // Rating and review shimmer
                            Row(
                              children: [
                                // Rating stars shimmer
                                ...List.generate(
                                  5,
                                  (index) => Container(
                                    margin: EdgeInsets.only(right: 3.w),
                                    width: 16.w,
                                    height: 16.h,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(3.r),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                // Review count shimmer
                                Container(
                                  width: 40.w,
                                  height: 14.h,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 8.h),

                            // Price section shimmer
                            Row(
                              children: [
                                // Current price
                                Container(
                                  width: 60.w,
                                  height: 18.h,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                // Original price (strikethrough)
                                Container(
                                  width: 50.w,
                                  height: 16.h,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                // Discount badge
                                Container(
                                  width: 35.w,
                                  height: 16.h,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Shopping bag icon shimmer (positioned at bottom right)
          Positioned.directional(
            textDirection: TextDirection.ltr,
            bottom: 0,
            end: 0,
            child: ShimmerWidget(
              child: Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 20.w,
                    height: 20.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Shimmer for the entire SliverList
class FavoriteListShimmer extends StatelessWidget {
  const FavoriteListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemBuilder: (context, index) => const FavoriteListItemShimmer(),
      itemCount: 6, // Show 6 shimmer items
    );
  }
}

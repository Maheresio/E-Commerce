// File: see_all_grid_view_shimmer.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/shimmer.dart';

class SeeAllGridViewShimmer extends StatelessWidget {
  const SeeAllGridViewShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 16.w, end: 16.w, top: 16.h),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: .52,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16,
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) => const HomeGridViewShimmerItem(),
        itemCount: 6, // Show 6 shimmer items
      ),
    );
  }
}

class HomeGridViewShimmerItem extends StatelessWidget {
  const HomeGridViewShimmerItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWidget(
      child: SizedBox(
        width: 150.w,
        child: Column(
          spacing: 8,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Shimmer
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              child: const AspectRatio(
                aspectRatio: 0.8,
                child: ShimmerContainer(
                  width: double.infinity,
                  height: double.infinity,
                  borderRadius: 10,
                ),
              ),
            ),

            // Favorite icon shimmer
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  // Rating stars shimmer
                  Row(
                    children: [
                      Row(
                        children: List.generate(5, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 2),
                            child: ShimmerContainer(
                              width: 16.w,
                              height: 16.w,
                              borderRadius: 8,
                            ),
                          );
                        }),
                      ),
                      const SizedBox(width: 4),
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
                        width: double.infinity,
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

// File: see_all_list_view_shimmer.dart
class SeeAllListViewShimmer extends StatelessWidget {
  const SeeAllListViewShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16),
      child: ListView.separated(
        itemBuilder: (context, index) => const SeeAllListViewShimmerItem(),
        separatorBuilder: (context, index) => const SizedBox(height: 26),
        itemCount: 5, // Show 5 shimmer items
      ),
    );
  }
}

class SeeAllListViewShimmerItem extends StatelessWidget {
  const SeeAllListViewShimmerItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130.h,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        spacing: 10.w,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image block (shimmer ONLY here)
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(8.r),
                bottomStart: Radius.circular(8.r),
              ),
              child: const ShimmerWidget(
                // <- moved here
                child: ShimmerContainer(
                  width: double.infinity,
                  height: double.infinity,
                  borderRadius: 0,
                ),
              ),
            ),
          ),

          // Content block (wrap the whole column so inner blocks get tinted)
          Expanded(
            flex: 4,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: ShimmerWidget(
                // <- moved here
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ShimmerContainer(
                      width: double.infinity,
                      height: 16.h,
                      borderRadius: 8,
                    ),
                    SizedBox(height: 4.h),
                    ShimmerContainer(
                      width: 120.w,
                      height: 16.h,
                      borderRadius: 8,
                    ),
                    SizedBox(height: 8.h),
                    ShimmerContainer(
                      width: 80.w,
                      height: 12.h,
                      borderRadius: 6,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Row(
                          children: List.generate(
                            5,
                            (_) => Padding(
                              padding: const EdgeInsets.only(right: 2),
                              child: ShimmerContainer(
                                width: 16.w,
                                height: 16.w,
                                borderRadius: 8,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        ShimmerContainer(
                          width: 30.w,
                          height: 12.h,
                          borderRadius: 6,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ShimmerContainer(
                      width: 100.w,
                      height: 14.h,
                      borderRadius: 7,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

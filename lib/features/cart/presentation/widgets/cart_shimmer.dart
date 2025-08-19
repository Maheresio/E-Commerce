import 'package:e_commerce/core/widgets/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartListViewShimmer extends StatelessWidget {
  const CartListViewShimmer({super.key});

  @override
  Widget build(BuildContext context) => ListView.separated(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: 6, // Show 5 shimmer items
    itemBuilder: (context, index) => const CartListViewItemShimmer(),
    separatorBuilder: (context, index) => SizedBox(height: 10.h),
  );
}

// cart_list_view_item_shimmer.dart
class CartListViewItemShimmer extends StatelessWidget {
  const CartListViewItemShimmer({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 150.h,
    width: double.infinity,
    child: Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image shimmer - separate shimmer effect
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                topLeft: Radius.circular(12),
              ),
              child: ShimmerWidget(child: Container(color: Colors.grey[300])),
            ),
          ),
          // Content shimmer - separate shimmer effect
          Expanded(
            flex: 3,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                color: Theme.of(context).cardColor,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                child: ShimmerWidget(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                spacing: 8.h,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Product name shimmer - two lines
                                  Container(
                                    height: 18.h,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  Container(
                                    height: 18.h,
                                    width: 180.w,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  // Color and Size shimmer
                                  Row(
                                    spacing: 13.w,
                                    children: [
                                      // Color shimmer
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 13.h,
                                              width: 35.w,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ),
                                            SizedBox(width: 4.w),
                                            Container(
                                              height: 13.h,
                                              width: 25.w,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Size shimmer
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 13.h,
                                              width: 25.w,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ),
                                            SizedBox(width: 4.w),
                                            Container(
                                              height: 13.h,
                                              width: 15.w,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[300],
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // More icon shimmer
                            Container(
                              height: 24.w,
                              width: 6.w,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Bottom row shimmer (quantity and price)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Quantity controls shimmer - looks like buttons
                          Row(
                            children: [
                              Container(
                                height: 24.h,
                                width: 24.w,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Container(
                                height: 18.h,
                                width: 15.w,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Container(
                                height: 24.h,
                                width: 24.w,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ],
                          ),
                          // Price shimmer
                          Container(
                            height: 18.h,
                            width: 50.w,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// cart_promo_field_shimmer.dart
class CartPromoFieldShimmer extends StatelessWidget {
  const CartPromoFieldShimmer({super.key});

  @override
  Widget build(BuildContext context) => Stack(
    alignment: Alignment.center,
    children: [
      // Text field background - separate shimmer
      ShimmerWidget(
        child: Material(
          elevation: 1,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 48.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 16.w, right: 50.w),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 14.h,
                  width: 120.w,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      // Arrow button - separate shimmer
      Align(
        alignment: Alignment.centerRight,
        child: ShimmerWidget(
          child: Container(
            margin: EdgeInsets.only(right: 8.w),
            height: 32.w,
            width: 32.w,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    ],
  );
}

// summary_price_tile_shimmer.dart
class SummaryPriceTileShimmer extends StatelessWidget {
  const SummaryPriceTileShimmer({super.key});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      // Title shimmer
      ShimmerWidget(
        child: Container(
          height: 14.h,
          width: 90.w,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      // Price shimmer
      ShimmerWidget(
        child: Container(
          height: 18.h,
          width: 60.w,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    ],
  );
}

// checkout_button_shimmer.dart
class CheckoutButtonShimmer extends StatelessWidget {
  const CheckoutButtonShimmer({super.key});

  @override
  Widget build(BuildContext context) => ShimmerWidget(
    child: Container(
      height: 48.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Container(
          height: 16.h,
          width: 80.w,
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    ),
  );
}

// cart_page_shimmer.dart - Complete page shimmer
class CartPageShimmer extends StatelessWidget {
  const CartPageShimmer({super.key});

  @override
  Widget build(BuildContext context) => SliverList(
    delegate: SliverChildListDelegate([
      const CartListViewShimmer(),
      const SizedBox(height: 15),
      const Column(
        spacing: 15,
        children: [
          CartPromoFieldShimmer(),
          SummaryPriceTileShimmer(),
          CheckoutButtonShimmer(),
        ],
      ),
      SizedBox(height: 20.h),
    ]),
  );
}

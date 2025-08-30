import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/extensions/context_extensions.dart';
import '../../../../core/widgets/shimmer.dart';

class PaymentMethodsShimmer extends StatelessWidget {
  const PaymentMethodsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWidget(
      child: Row(
        spacing: 17.w,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: context.color.onSecondary,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
              child: ShimmerContainer(
                width: 24.w, // Approximate icon width
                height: 16.h, // Approximate icon height
                borderRadius: 4,
              ),
            ),
          ),

          ShimmerContainer(
            width: 140.w, // Width for "**** **** **** 1234"
            height: 16.h,
            borderRadius: 4,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/helpers/extensions/context_extensions.dart';
import '../../../../core/helpers/methods/date_time_parser.dart';
import '../../../../core/routing/app_route_constants.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/widgets/circular_elevated_button.dart';
import '../../../checkout/domain/entities/order_entity.dart';

class MyOrdersListViewItem extends StatelessWidget {
  final OrderEntity order;
  const MyOrdersListViewItem({super.key, required this.order});

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.kOrderCode.replaceAll('%s', order.code),
                  style: AppStyles.font16BlackSemiBold(context),
                ),
                Text(
                  parseDateTime(order.date),
                  style: AppStyles.font14GreyRegular(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${AppStrings.kTrackingNumber}:  ',
                        style: AppStyles.font14GreyRegular(context),
                      ),
                      TextSpan(
                        text: order.trackingNumber,
                        style: AppStyles.font14BlackMedium(context),
                      ),
                    ],
                  ),
                  style: AppStyles.font14GreyRegular(context),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${AppStrings.kQuantity}:  ',
                            style: AppStyles.font14GreyRegular(context),
                          ),
                          TextSpan(
                            text: '${order.quantity}',
                            style: AppStyles.font14BlackMedium(context),
                          ),
                        ],
                      ),
                      style: AppStyles.font14GreyRegular(context),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${AppStrings.kTotalAmount}  ',
                            style: AppStyles.font14GreyRegular(context),
                          ),
                          TextSpan(
                            text: '\$${order.totalAmount.toStringAsFixed(2)}',
                            style: AppStyles.font14BlackMedium(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100.w,
                  height: 40.h,
                  child: CircularElevatedButton(
                    onPressed:
                        () => context.push(
                          AppRoutes.orderDetails,
                          extra: order,
                        ),
                    text: AppStrings.kDetails,
                    borderColor: themeColors.primaryFixed,
                    borderWidth: 1.5,
                    textColor: themeColors.primaryFixed,
                    color: themeColors.onSecondary,
                  ),
                ),
                Text(
                  order.status.name.replaceFirst(
                    order.status.name[0],
                    order.status.name[0].toUpperCase(),
                  ),
                  style: AppStyles.font14GreenMedium(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

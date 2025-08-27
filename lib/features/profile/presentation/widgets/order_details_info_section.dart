import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../checkout/domain/entities/order_entity.dart';
import '../../../../core/utils/app_images.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrderDetailsInfoSection extends StatelessWidget {
  final OrderEntity order;
  const OrderDetailsInfoSection({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Text(
          AppStrings.kOrderInformation,
          style: AppStyles.font15BlackSemiBold(context),
        ),
        Row(
          spacing: 10.w,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 130.w,
              child: Text(
                '${AppStrings.kShippingAddress}:',
                style: AppStyles.font14GreyRegular(context),
              ),
            ),
            Expanded(
              child: Text(
                '${order.shippingAddress.street}, ${order.shippingAddress.city}, ${order.shippingAddress.state}, ${order.shippingAddress.zipCode}, ${order.shippingAddress.country}',
                style: AppStyles.font14BlackMedium(context),
              ),
            ),
          ],
        ),
        Row(
          spacing: 10.w,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 130.w,
              child: Text(
                '${AppStrings.kpaymentMethod}:',
                style: AppStyles.font14GreyRegular(context),
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 10.w,
                children: [
                  SvgPicture.asset(
                    AppImages.mastercard,
                    height: 40.h,
                    fit: BoxFit.cover,
                  ),
                  Expanded(
                    child: Text(
                      AppStrings.kCardEndingIn.replaceAll(
                        '%s',
                        order.paymentMethod.last4,
                      ),
                      style: AppStyles.font14BlackMedium(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          spacing: 10.w,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 130.w,
              child: Text(
                '${AppStrings.kDeliveryMethod}:',
                style: AppStyles.font14GreyRegular(context),
              ),
            ),
            Expanded(
              child: Text(
                AppStrings.kDeliveryMethodInfo
                    .replaceAll('%s', order.deliveryMethod.name)
                    .replaceAll('%s', order.deliveryMethod.duration)
                    .replaceAll(
                      '%s',
                      '\$${order.deliveryMethod.cost.toStringAsFixed(2)}',
                    ),
                style: AppStyles.font14BlackMedium(context),
              ),
            ),
          ],
        ),
        Row(
          spacing: 10.w,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 130.w,
              child: Text(
                '${AppStrings.kDiscount}:',
                style: AppStyles.font14GreyRegular(context),
              ),
            ),
            Expanded(
              child: Text(
                order.deliveryMethod.discount == 0
                    ? AppStrings.kNoDiscount
                    : AppStrings.kPersonalPromoCode.replaceAll(
                      '%s',
                      order.deliveryMethod.discount.toString(),
                    ),
                style: AppStyles.font14BlackMedium(context),
              ),
            ),
          ],
        ),
        Row(
          spacing: 10.w,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 130.w,
              child: Text(
                '${AppStrings.kTotalAmount}:',
                style: AppStyles.font14GreyRegular(context),
              ),
            ),
            Expanded(
              child: Text(
                '\$${order.totalAmount.toStringAsFixed(2)}',
                style: AppStyles.font14BlackMedium(context),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

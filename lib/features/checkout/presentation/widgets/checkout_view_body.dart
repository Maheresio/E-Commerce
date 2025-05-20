import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/helpers/extensions/theme_color.extension.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/widgets/summary_price.dart';
import '../../data/models/delivery_method_model.dart';
import 'shipping_address_card.dart';

class CheckoutViewBody extends StatelessWidget {
  const CheckoutViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24),
      child: const Column(
        spacing: 50,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShippingAddressSection(),
          PaymentSection(),
          DeliveryMethodSection(),
          SummarySection(),
        ],
      ),
    );
  }
}

class ShippingAddressSection extends StatelessWidget {
  const ShippingAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        Text(AppStrings.kShippingAddress, style: AppStyles.font16BlackSemiBold),
        ShippingAddressCard(),
      ],
    );
  }
}

class PaymentSection extends StatelessWidget {
  const PaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,

      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppStrings.kPayment, style: AppStyles.font16BlackSemiBold),
            Padding(
              padding: EdgeInsetsDirectional.only(end: 24.w),
              child: InkWell(
                onTap: () {},
                child: Text(
                  AppStrings.kChange,
                  style: AppStyles.font14PrimaryMedium,
                ),
              ),
            ),
          ],
        ),
        Row(
          spacing: 17.w,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: context.color.onSecondary,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
                child: SvgPicture.asset(AppImages.mastercard),
              ),
            ),

            Text('**** **** **** 1234', style: AppStyles.font14BlackMedium),
          ],
        ),
      ],
    );
  }
}

class DeliveryMethodSection extends StatelessWidget {
  const DeliveryMethodSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,

      children: [
        Text(AppStrings.kDeliveryMethod, style: AppStyles.font16BlackSemiBold),

        SingleChildScrollView(
          child: Row(
            children:
                deliveryMethods
                    .map(
                      (element) => Expanded(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Image.asset(element.image,),
                              Text(element.duration),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),
      ],
    );
  }
}

class SummarySection extends StatelessWidget {
  const SummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 14,
      children: [
        SummaryPriceTile(title: AppStrings.kOrder, price: 50),
        SummaryPriceTile(title: AppStrings.kDelivery, price: 50),
        SummaryPriceTile(title: AppStrings.kSummary, price: 50),
      ],
    );
  }
}

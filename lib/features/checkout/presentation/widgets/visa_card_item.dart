import '../../domain/entities/visa_card_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';
import '../controller/visa_card/visa_card_notifier.dart';
import 'shipping_check_box.dart';

class VisaCardItem extends StatelessWidget {
  const VisaCardItem(this.card, {super.key, this.isChecked = false});
  final bool isChecked;
  final VisaCardEntity card;
  @override
  Widget build(BuildContext context) => Column(
    spacing: 16,
    children: [
      Opacity(
        opacity: isChecked ? 0.5 : 1,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 30.h),
          height: 216.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: const DecorationImage(
              image: AssetImage(AppImages.visa),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(AppImages.chip),
              const SizedBox(height: 29),
              Text(
                '**** **** **** ${card.last4}',
                style: AppStyles.font24WhiteSemiBold(
                  context,
                ).copyWith(letterSpacing: 3.5),
              ),
              const Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Opacity(
                        opacity: 0.8,
                        child: Text(
                          AppStrings.kCardHolderName,
                          style: AppStyles.font10WhiteSemiBold(context),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        card.holderName,
                        style: AppStyles.font14WhiteSemiBold(context),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Opacity(
                        opacity: 0.8,
                        child: Text(
                          AppStrings.kExpiyDate,
                          style: AppStyles.font10WhiteSemiBold(context),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${card.expMonth}/${card.expYear}',
                        style: AppStyles.font14WhiteSemiBold(context),
                      ),
                    ],
                  ),
                  SvgPicture.asset(AppImages.mastercard, fit: BoxFit.cover),
                ],
              ),
            ],
          ),
        ),
      ),

      Consumer(
        builder: (context, ref, child) {
          return StyledCheckbox(
            text: AppStrings.kUseAsDefaultPaymentMethod,
            isChecked: card.isDefault,
            onChanged: (value) async {
              final customerId =
                  await ref
                      .read(visaCardNotifierProvider.notifier)
                      .getOrCreateCustomer();
              await ref
                  .read(visaCardNotifierProvider.notifier)
                  .setDefaultCard(
                    customerId: customerId,
                    paymentMethodId: card.id,
                  );
            },
          );
        },
      ),
    ],
  );
}

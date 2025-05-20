import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';
import 'shipping_check_box.dart';

class VisaCardItem extends StatelessWidget {
  const VisaCardItem({super.key, this.isChecked = false});
  final bool isChecked;
  @override
  Widget build(BuildContext context) {
    return Column(
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
              image: DecorationImage(
                image: AssetImage(AppImages.visa),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(AppImages.chip),
                SizedBox(height: 29),
                Text(
                  '**** **** **** 1234',
                  style: AppStyles.font24WhiteSemiBold.copyWith(
                    letterSpacing: 3.5,
                  ),
                ),
                Spacer(),

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
                            style: AppStyles.font10WhiteSemiBold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text('John Doe', style: AppStyles.font14WhiteSemiBold),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Opacity(
                          opacity: 0.8,
                          child: Text(
                            AppStrings.kExpiyDate,
                            style: AppStyles.font10WhiteSemiBold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text('05/25', style: AppStyles.font14WhiteSemiBold),
                      ],
                    ),
                    SvgPicture.asset(AppImages.mastercard, fit: BoxFit.cover),
                  ],
                ),
              ],
            ),
          ),
        ),

        ShippingCheckbox(text: AppStrings.kUseAsDefaultPaymentMethod),
      ],
    );
  }
}

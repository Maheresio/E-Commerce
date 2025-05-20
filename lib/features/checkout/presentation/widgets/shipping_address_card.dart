import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/extensions/theme_color.extension.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';
import 'shipping_check_box.dart';

class ShippingAddressCard extends StatelessWidget {
  const ShippingAddressCard({super.key, this.hasCheckBox = false});

  final bool hasCheckBox;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.color.onSecondary,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 18.h),
        child: Column(
          spacing: 7,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('John Doe', style: AppStyles.font14BlackSemiBold),
                InkWell(
                  onTap: () {},
                  child: Text(
                    AppStrings.kChange,
                    style: AppStyles.font14PrimaryMedium,
                  ),
                ),
              ],
            ),

            Opacity(
              opacity: 0.8,
              child: Text(
                '123 Main St, Springfield, IL 62704\nPhone: (123) 456-7890',
                style: AppStyles.font14BlackMedium,
              ),
            ),

            if (hasCheckBox)
              ShippingCheckbox(text: AppStrings.kUseAsShippingAddress),
          ],
        ),
      ),
    );
  }
}

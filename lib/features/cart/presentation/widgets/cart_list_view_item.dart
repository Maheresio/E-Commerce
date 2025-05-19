import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';
import 'cart_item_quantity.dart';

class CartListViewItem extends StatelessWidget {
  const CartListViewItem({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110.h,
      width: double.infinity,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  topLeft: Radius.circular(12),
                ),
                child: Image.asset(AppImages.homeBanner, fit: BoxFit.cover),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'PullOver',
                              style: AppStyles.font18BlackSemiBold,
                            ),
                            Row(
                              spacing: 13.w,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    text: '${AppStrings.kColor}: ',
                                    style: AppStyles.font11GreyRegular,
                                    children: [
                                      TextSpan(
                                        text: 'Black',
                                        style: AppStyles.font11BlackRegular,
                                      ),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    text: '${AppStrings.kSize}: ',
                                    style: AppStyles.font11GreyRegular,
                                    children: [
                                      TextSpan(
                                        text: 'L',
                                        style: AppStyles.font11BlackRegular,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Icon(Icons.more_vert_outlined),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CartItemQuantity(),
                        Text('50\$', style: AppStyles.font14BlackMedium),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


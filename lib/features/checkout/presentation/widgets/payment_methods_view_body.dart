import 'package:e_commerce/core/utils/app_strings.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'visa_card_item.dart';

class PaymentMethodsViewBody extends StatelessWidget {
  const PaymentMethodsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 30),
      child: Column(
        spacing: 24,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.kYourPaymentCards,
            style: AppStyles.font16BlackSemiBold,
          ),
          Expanded(
            child: ListView.separated(
              itemBuilder: (_, index) => VisaCardItem(),

              separatorBuilder: (_, index) => SizedBox(height: 30),
              itemCount: 4,
            ),
          ),
        ],
      ),
    );
  }
}

import '../../../../core/helpers/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';

class ShopSummerSales extends StatelessWidget {
  const ShopSummerSales({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: context.color.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28.0),
        child: Column(
          children: [
            Text(
              AppStrings.kSummerSales.toUpperCase(),
              style: AppStyles.font24WhiteSemiBold(context),
            ),
            Text(
              AppStrings.kUpTo50PercentOff,
              style: AppStyles.font14WhiteMedium(context),
            ),
          ],
        ),
      ),
    ),
  );
}

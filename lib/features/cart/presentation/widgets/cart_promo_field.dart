import 'package:flutter/material.dart';

import '../../../../core/helpers/extensions/context_extensions.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';

class CartPromoField extends StatelessWidget {
  const CartPromoField({super.key});

  @override
  Widget build(BuildContext context) {
     final themeColors = context.color;
    return Stack(
    alignment: Alignment.center,
    children: [
      Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: TextField(
            style: AppStyles.font14BlackMedium(context),
            decoration: InputDecoration(
              hintText: AppStrings.kEnterPromoCode,
              hintStyle: AppStyles.font14BlackMedium(context),
            ),
          ),
        ),
      ),
      Align(
        alignment: Alignment.centerRight,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: themeColors.primaryFixed,
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.arrow_forward_outlined,
              color: themeColors.onSecondary,
            ),
          ),
        ),
      ),
    ],
  );
  }
}

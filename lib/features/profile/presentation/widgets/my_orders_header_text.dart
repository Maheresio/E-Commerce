import 'package:flutter/material.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/app_strings.dart';

class MyOrdersHeaderText extends StatelessWidget {
  final double horizontalPadding;
  const MyOrdersHeaderText({super.key, required this.horizontalPadding});

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
    child: Text(
      AppStrings.kMyOrders,
      style: AppStyles.font34BlackBold(context),
    ),
  );
}

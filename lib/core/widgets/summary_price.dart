import 'package:flutter/material.dart';

import '../utils/app_styles.dart';

class SummaryPriceTile extends StatelessWidget {
  const SummaryPriceTile({super.key, required this.title, required this.price});
  final String title;
  final double price;
  @override
  Widget build(BuildContext context) => Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$title:', style: AppStyles.font14GreyMedium(context)),
        Text('$price\$', style: AppStyles.font18BlackSemiBold(context)),
      ],
    );
}

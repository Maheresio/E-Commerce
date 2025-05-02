import 'package:flutter/material.dart';

import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/app_styles.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key, required this.text});

  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(AppStrings.kLogin, style: AppStyles.font34BoldBlack);
  }
}
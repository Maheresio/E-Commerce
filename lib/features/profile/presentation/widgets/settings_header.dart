import 'package:flutter/material.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/app_strings.dart';

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      AppStrings.kSettings,
      style: AppStyles.font34BlackBold(context),
    );
  }
}

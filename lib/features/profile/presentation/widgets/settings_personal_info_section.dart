import 'package:flutter/material.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/app_strings.dart';

class SettingsPersonalInfoSection extends StatelessWidget {
  const SettingsPersonalInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.kPersonalInformation,
          style: AppStyles.font16BlackSemiBold(context),
        ),
        const TextField(
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(labelText: AppStrings.kFullName),
        ),
        // ... add more fields as needed ...
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../../core/utils/app_images.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/app_styles.dart';
import 'styled_social_button.dart';

class SocialSection extends StatelessWidget {
  const SocialSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      children: [
        Text(
          AppStrings.kSignUpWithSocialAccount,
          style: AppStyles.font14BlackRegular,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            StyledSocialButton(image: AppImages.google, onTap: () {}),
            StyledSocialButton(image: AppImages.facebook, onTap: () {}),
          ],
        ),
      ],
    );
  }
}

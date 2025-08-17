import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/app_images.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/app_styles.dart';
import '../bloc/auth_bloc.dart';
import 'styled_social_button.dart';

class SocialSection extends StatelessWidget {
  const SocialSection({super.key});

  @override
  Widget build(BuildContext context) => Column(
    spacing: 12,
    children: [
      Text(
        AppStrings.kSignUpWithSocialAccount,
        style: AppStyles.font14BlackMedium(context),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 16,
        children: [
          StyledSocialButton(
            image: AppImages.google,
            onTap: () {
              context.read<AuthBloc>().add(const GoogleSignInRequested());
            },
          ),
          StyledSocialButton(
            image: AppImages.facebook,
            onTap: () {
              context.read<AuthBloc>().add(const FacebookSignInRequested());
            },
          ),
        ],
      ),
    ],
  );
}

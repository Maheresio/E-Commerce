import 'package:flutter/material.dart';

import '../../../../../core/utils/app_strings.dart';
import '../../../shared/domain/entity/email_validation.dart';
import '../../../shared/domain/entity/password_validation.dart';
import '../../../shared/presentation/widgets/styled_text_form_field.dart';

class LoginInputSection extends StatelessWidget {
  const LoginInputSection({
    super.key,
    required this.emailController,
    required this.passwordController,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      children: [
        StyledTextFormField(
          controller: emailController,
          text: AppStrings.kEmail,
          autofillHints: [AutofillHints.email],
          validator: (value) {
            final emailValidation = EmailValidation(value).value;
            return emailValidation.fold(
              (failure) => failure.message,
              (_) => null,
            );
          },

          keyboardType: TextInputType.emailAddress,
        ),
        StyledTextFormField(
          isPassword: true,
          controller: passwordController,
          text: AppStrings.kPassword,
          autofillHints: [AutofillHints.password],
          validator: (value) {
            final passwordValidation = PasswordValidation(value).value;
            return passwordValidation.fold(
              (failure) => failure.message,
              (_) => null,
            );
          },

          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }
}

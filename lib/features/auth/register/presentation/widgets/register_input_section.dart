import 'package:flutter/material.dart';

import '../../../../../core/utils/app_strings.dart';
import '../../../shared/domain/entity/email_validation.dart';
import '../../../shared/domain/entity/name_validation.dart';
import '../../../shared/domain/entity/password_validation.dart';
import '../../../../../core/widgets/styled_text_form_field.dart';

class RegisterInputSection extends StatelessWidget {
  const RegisterInputSection({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      children: [
        StyledTextFormField(
          text: AppStrings.kName,
          controller: nameController,
          validator: (value) {
            final validation = NameValidation(value).value;
            return validation.fold((failure) => failure.message, (_) => null);
          },

          keyboardType: TextInputType.name,
        ),
        StyledTextFormField(
          controller: emailController,
          text: AppStrings.kEmail,
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

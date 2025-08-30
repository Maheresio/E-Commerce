import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/helpers/methods/styled_snack_bar.dart';
import '../../../../../core/routing/app_route_constants.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../../../core/utils/app_styles.dart';
import '../../../shared/presentation/widgets/navigation_button.dart';
import '../../../shared/presentation/widgets/submit_button.dart';
import '../bloc/register_bloc.dart';
import 'register_input_section.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    this.onPressed,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Title
      Text(AppStrings.kSignUp, style: AppStyles.font34BlackBold(context)),
      const SizedBox(height: 70),

      // Input Section
      RegisterInputSection(
        nameController: nameController,
        emailController: emailController,
        passwordController: passwordController,
      ),

      // Navigation Button
      Align(
        alignment: AlignmentDirectional.centerEnd,
        child: NavigationButton(
          text: AppStrings.kAlreadyHaveAccount,
          onPressed: () => context.go(AppRoutes.login),
        ),
      ),
      const SizedBox(height: 20),

      // Submit Button with BlocConsumer
      BlocConsumer<RegisterBloc, RegisterState>(
        listenWhen: (previous, current) {
          return current is RegisterSuccess || current is RegisterFailure;
        },
        listener: (context, state) {
          if (state is RegisterSuccess) {
            openStyledSnackBar(
              context,
              text: AppStrings.kSuccessRegister,
              type: SnackBarType.success,
            );
            Future.delayed(const Duration(seconds: 2), () {
              if (!context.mounted) return;
              context.go(AppRoutes.navBar);
            });
          } else if (state is RegisterFailure) {
            openStyledSnackBar(
              context,
              text: state.message,
              type: SnackBarType.error,
            );
          }
        },
        buildWhen: (previous, current) {
          return (previous is RegisterLoading) != (current is RegisterLoading);
        },
        builder: (context, state) {
          if (state is RegisterLoading) {
            return const SubmitButton(
              isLoading: true,
              text: AppStrings.kSignUp,
            );
          }
          return SubmitButton(text: AppStrings.kSignUp, onPressed: onPressed);
        },
      ),
    ],
  );
}

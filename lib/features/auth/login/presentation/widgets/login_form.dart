import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/helpers/methods/styled_snack_bar.dart';
import '../../../../../core/routing/app_route_constants.dart';
import '../../../../../core/utils/app_strings.dart';
import '../../../shared/presentation/widgets/header_section.dart';
import '../../../shared/presentation/widgets/navigation_button.dart';
import '../../../shared/presentation/widgets/submit_button.dart';
import '../bloc/login_bloc.dart';
import 'login_input_section.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    this.submit,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final void Function()? submit;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const HeaderSection(text: AppStrings.kLogin),
      const SizedBox(height: 70),
      LoginInputSection(
        emailController: emailController,
        passwordController: passwordController,
      ),

      Align(
        alignment: AlignmentDirectional.centerEnd,
        child: NavigationButton(
          text: AppStrings.kForgotPassword,
          onPressed: () {},
        ),
      ),
      const SizedBox(height: 20),

      BlocConsumer<LoginBloc, LoginState>(
        listenWhen: (previous, current) {
          return current is LoginSuccess || current is LoginFailure;
        },
        listener: (context, state) {
          if (state is LoginSuccess) {
            openStyledSnackBar(
              context,
              text: AppStrings.kSuccessLogin,
              type: SnackBarType.success,
            );
            Future.delayed(const Duration(seconds: 2), () {
              if (!context.mounted) return;
              context.go(AppRoutes.navBar);
            });
          } else if (state is LoginFailure) {
            openStyledSnackBar(
              context,
              text: state.message,
              type: SnackBarType.error,
            );
          }
        },
        buildWhen: (previous, current) {
          return (previous is LoginLoading) != (current is LoginLoading);
        },
        builder: (context, state) {
          if (state is LoginLoading) {
            return const SubmitButton(isLoading: true, text: AppStrings.kLogin);
          }
          return SubmitButton(text: AppStrings.kLogin, onPressed: submit);
        },
      ),
      Align(
        alignment: AlignmentDirectional.center,
        child: NavigationButton(
          text: AppStrings.kDontHaveAccount,
          onPressed: () {
            context.go(AppRoutes.register);
          },
        ),
      ),
    ],
  );
}

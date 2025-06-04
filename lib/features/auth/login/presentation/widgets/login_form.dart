import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/helpers/methods/styled_snack_bar.dart';
import '../../../../../core/routing/app_router.dart';
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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderSection(text: AppStrings.kLogin),
        SizedBox(height: 70),
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
        SizedBox(height: 20),

        BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              openStyledSnackBar(
                context,
                text: AppStrings.kSuccessLogin,
                type: SnackBarType.success,
              );
              Future.delayed(Duration(seconds: 2), () {
                if (!context.mounted) return;
                GoRouter.of(context).go(AppRouter.kHome);
              });
            } else if (state is LoginFailure) {
              openStyledSnackBar(
                context,
                text: state.message,
                type: SnackBarType.error,
              );
            }
          },
          builder: (context, state) {
            if (state is LoginLoading) {
              return const SubmitButton(
                isLoading: true,
                text: AppStrings.kLogin,
              );
            }
            return SubmitButton(text: AppStrings.kLogin, onPressed: submit);
          },
        ),
        Align(
          alignment: AlignmentDirectional.center,
          child: NavigationButton(
            text: AppStrings.kDontHaveAccount,
            onPressed: () {
              GoRouter.of(context).go(AppRouter.kRegister);
            },
          ),
        ),
      ],
    );
  }
}

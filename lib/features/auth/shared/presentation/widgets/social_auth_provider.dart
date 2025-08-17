import 'package:e_commerce/core/helpers/methods/styled_snack_bar.dart';
import 'package:e_commerce/core/widgets/styled_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/routing/app_route_constants.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/social_section.dart';

class SocialAuthProvider extends StatelessWidget {
  const SocialAuthProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) {
        return current is AuthSuccess || current is AuthFailure;
      },
      listener: (context, state) {
        if (state is AuthSuccess) {
          openStyledSnackBar(
            context,
            text: 'Welcome ${state.user.name}!',
            type: SnackBarType.success,
          );

          Future.delayed(const Duration(seconds: 2), () {
            if (!context.mounted) return;
            context.go(AppRoutes.navBar);
          });
        } else if (state is AuthFailure) {
          openStyledSnackBar(
            context,
            text: state.message,
            type: SnackBarType.error,
          );
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        buildWhen: (previous, current) {
          return (previous is AuthLoading) != (current is AuthLoading);
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: StyledLoading());
          }
          return const SocialSection();
        },
      ),
    );
  }
}

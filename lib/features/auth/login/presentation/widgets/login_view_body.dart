import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/presentation/widgets/social_section.dart';
import '../bloc/login_bloc.dart';
import 'login_form.dart';

class LoginViewBody extends HookWidget {
  const LoginViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: AutofillGroup(
            child: Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: LoginForm(
                        emailController: emailController,
                        passwordController: passwordController,
                        submit: () {
                          if (formKey.currentState!.validate()) {
                            BlocProvider.of<LoginBloc>(context).add(
                              LoginButtonPressed(
                                email: emailController.text,
                                password: passwordController.text,
                              ),
                            );
                            TextInput.finishAutofillContext();
                          }
                        },
                      ),
                    ),
                    SocialSection(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

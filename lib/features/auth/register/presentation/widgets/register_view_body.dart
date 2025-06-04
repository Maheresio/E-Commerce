import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/presentation/widgets/social_section.dart';
import '../bloc/register_bloc.dart';
import 'register_form.dart';

class RegisterViewBody extends HookWidget {
  const RegisterViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final nameController = useTextEditingController();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 50),
        child: Form(
          key: formKey,
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: RegisterForm(
                        nameController: nameController,
                        emailController: emailController,
                        passwordController: passwordController,
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            BlocProvider.of<RegisterBloc>(context).add(
                              RegisterButtonPressed(
                                email: emailController.text,
                                name: nameController.text,
                                password: passwordController.text,
                              ),
                            );
                          }
                        },
                      ),
                    ),

                    SocialSection(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

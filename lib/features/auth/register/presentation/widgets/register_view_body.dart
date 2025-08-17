import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../shared/presentation/widgets/social_auth_provider.dart';
import '../bloc/register_bloc.dart';
import 'register_form.dart';

class RegisterViewBody extends HookWidget {
  const RegisterViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = useMemoized(GlobalKey<FormState>.new);
    final TextEditingController emailController = useTextEditingController();
    final TextEditingController passwordController = useTextEditingController();
    final TextEditingController nameController = useTextEditingController();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 50),
        child: Form(
          key: formKey,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
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

                    const SocialAuthProvider(),
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

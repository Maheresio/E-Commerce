import 'package:flutter/material.dart';

import '../widgets/login_view_body.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
    resizeToAvoidBottomInset: false,
    body: SafeArea(child: LoginViewBody()),
  );
}

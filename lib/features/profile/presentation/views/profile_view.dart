import '../widgets/profile_view_body.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: SafeArea(child: ProfileViewBody()));
}

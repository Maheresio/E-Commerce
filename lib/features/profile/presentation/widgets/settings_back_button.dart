import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsBackButton extends StatelessWidget {
  const SettingsBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pop(),
      child: const Icon(Icons.arrow_back_ios, size: 28),
    );
  }
}

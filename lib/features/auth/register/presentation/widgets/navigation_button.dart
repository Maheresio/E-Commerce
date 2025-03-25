import 'package:flutter/material.dart';

import '../../../../../core/utils/app_strings.dart';

class NavigationButton extends StatelessWidget {
  const NavigationButton({super.key, this.onPressed, required this.text});

  final void Function()? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: onPressed, child: Text(text));
  }
}

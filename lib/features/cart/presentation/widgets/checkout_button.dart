import 'package:flutter/material.dart';

import '../../../../core/utils/app_strings.dart';

class CheckoutButton extends StatelessWidget {
  const CheckoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Text(AppStrings.kCheckout.toUpperCase()),
    );
  }
}
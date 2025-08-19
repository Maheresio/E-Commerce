import '../../../../core/routing/app_router.dart';
import '../../../../core/widgets/circular_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_strings.dart';

class CheckoutButton extends StatelessWidget {
  const CheckoutButton(this.cartTotal, {super.key});
  final double cartTotal;
  @override
  Widget build(BuildContext context) => CircularElevatedButton(
    onPressed: () {
      context.push(AppRouter.kCheckout, extra: cartTotal);
    },
    text: AppStrings.kCheckout.toUpperCase(),
  );
}

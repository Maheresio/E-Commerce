import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/app_route_constants.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/widgets/circular_elevated_button.dart';

class CheckoutButton extends StatelessWidget {
  const CheckoutButton(this.cartTotal, {super.key});
  final double cartTotal;
  @override
  Widget build(BuildContext context) => CircularElevatedButton(
    onPressed: () {
      context.push(AppRoutes.checkout, extra: cartTotal);
    },
    text: AppStrings.kCheckout.toUpperCase(),
  );
}

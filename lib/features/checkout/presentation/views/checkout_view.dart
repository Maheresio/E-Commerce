import 'package:flutter/material.dart';

import '../../../../core/utils/app_strings.dart';
import '../widgets/styled_app_bar.dart';
import '../widgets/checkout_view_body.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView(this.cartTotal, {super.key});
  final double cartTotal;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: styledAppBar(context, title: AppStrings.kCheckout),
    body: CheckoutViewBody(cartTotal),
  );
}

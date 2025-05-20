import 'package:flutter/material.dart';

import '../../../../core/utils/app_strings.dart';
import '../widgets/checkout_app_bar.dart';
import '../widgets/checkout_view_body.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: checkoutAppBar(context, AppStrings.kCheckout),
      body: CheckoutViewBody(),
    );
  }

 
}

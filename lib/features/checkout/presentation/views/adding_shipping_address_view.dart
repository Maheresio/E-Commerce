import 'package:flutter/material.dart';

import '../../../../core/utils/app_strings.dart';
import '../widgets/adding_shipping_address_view_body.dart';
import '../widgets/checkout_app_bar.dart';

class AddingShippingAddressView extends StatelessWidget {
  const AddingShippingAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: checkoutAppBar(context, AppStrings.kAdddingShippingAddress),
      body: const AddingShippingAddressViewBody(),
    );
  }
}

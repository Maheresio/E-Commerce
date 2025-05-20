import 'package:flutter/material.dart';

import '../../../../core/utils/app_strings.dart';
import '../widgets/add_floating_action_button.dart';
import '../widgets/checkout_app_bar.dart';
import '../widgets/shipping_address_view_body.dart';

class ShippingAddressView extends StatelessWidget {
  const ShippingAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: addFloatingButton(context),
      appBar: checkoutAppBar(context, AppStrings.kShippingAddresses),
      body: ShippingAddressViewBody(),
    );
  }

  
}

import 'package:e_commerce/core/utils/app_strings.dart';
import 'package:e_commerce/features/checkout/presentation/widgets/add_floating_action_button.dart';
import 'package:e_commerce/features/checkout/presentation/widgets/checkout_app_bar.dart';
import 'package:e_commerce/features/checkout/presentation/widgets/payment_methods_view_body.dart';
import 'package:flutter/material.dart';

import '../widgets/add_visa_card_bottom_sheet.dart';

class PaymentMethodsView extends StatelessWidget {
  const PaymentMethodsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: checkoutAppBar(context, AppStrings.kpaymentMethods),
      body: PaymentMethodsViewBody(),
      floatingActionButton: Builder(
        builder: (context) {
          return addFloatingButton(
            context,
            onPressed: () async => await _showAddCardBottomSheet(context),
          );
        },
      ),
    );
  }

  Future _showAddCardBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      showDragHandle: true,
      enableDrag: true,
      isScrollControlled: true,

      elevation: 10,
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (context) => AddVisaCardBottomSheet(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../../core/widgets/styled_modal_barrier.dart';
import '../controller/visa_card/visa_card_notifier.dart';
import '../widgets/add_floating_action_button.dart';
import '../widgets/add_visa_card_bottom_sheet.dart';
import '../widgets/payment_methods_view_body.dart';
import '../widgets/styled_app_bar.dart';

class PaymentMethodsView extends ConsumerWidget {
  const PaymentMethodsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isLoading = ref.watch(visaCardLoadingState);
    return Scaffold(
      appBar: styledAppBar(context, title: AppStrings.kpaymentMethods),
      body: Stack(
        children: <Widget>[
          const PaymentMethodsViewBody(),
          if (isLoading) const StyledModalBarrier(),
        ],
      ),
      floatingActionButton: Builder(
        builder:
            (BuildContext context) => addFloatingButton(
              context,
              onPressed: () async => await _showAddCardBottomSheet(context),
            ),
      ),
    );
  }

  Future _showAddCardBottomSheet(BuildContext context) => showModalBottomSheet(
    showDragHandle: true,
    enableDrag: true,
    isScrollControlled: true,

    elevation: 10,
    context: context,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    builder: (context) => const AddVisaCardBottomSheet(),
  );
}

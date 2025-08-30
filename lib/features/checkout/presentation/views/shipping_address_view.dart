import 'package:e_commerce/core/routing/app_route_constants.dart';

import '../../../../core/widgets/styled_modal_barrier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_strings.dart';
import '../controller/shipping_address/shipping_address_providers.dart';
import '../widgets/add_floating_action_button.dart';
import '../widgets/styled_app_bar.dart';
import '../widgets/shipping_address_view_body.dart';

class ShippingAddressView extends ConsumerWidget {
  const ShippingAddressView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool loading = ref.watch(shippingAddressLoadingProvider);
    return Scaffold(
      floatingActionButton: addFloatingButton(
        context,
        onPressed: () => context.push(AppRoutes.addShippingAddress),
      ),
      appBar: styledAppBar(context, title: AppStrings.kShippingAddresses),
      body: Stack(
        children: <Widget>[
          const ShippingAddressViewBody(),

          if (loading) const StyledModalBarrier(),
        ],
      ),
    );
  }
}

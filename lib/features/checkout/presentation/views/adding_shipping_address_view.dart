import '../controller/shipping_address/shipping_address_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../../core/widgets/styled_modal_barrier.dart';
import '../../domain/entities/shipping_address_entity.dart';
import '../widgets/adding_shipping_address_view_body.dart';
import '../widgets/styled_app_bar.dart';

class AddingShippingAddressView extends ConsumerWidget {
  const AddingShippingAddressView({super.key, this.address});

  final ShippingAddressEntity? address;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool loading = ref.watch(shippingAddressLoadingProvider);
    return Scaffold(
      appBar: styledAppBar(context, title: AppStrings.kAdddingShippingAddress),
      body: Stack(
        children: <Widget>[
          AddingShippingAddressViewBody(address),
          if (loading) const StyledModalBarrier(),
        ],
      ),
    );
  }
}

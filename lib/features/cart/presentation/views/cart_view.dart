import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/styled_modal_barrier.dart';
import '../controller/cart_provider.dart';
import '../widgets/cart_view_body.dart';

class CartView extends ConsumerWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool quantityLoadingState = ref.watch(quantityLoadingProvider);

    return Scaffold(
      body: SafeArea(
        child:
            quantityLoadingState
                ? const Stack(
                  children: <Widget>[CartViewBody(), StyledModalBarrier()],
                )
                : const CartViewBody(),
      ),
    );
  }
}

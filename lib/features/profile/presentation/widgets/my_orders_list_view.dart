import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../checkout/domain/entities/order_entity.dart';
import '../../../checkout/presentation/controller/order/order_notifier.dart';
import 'my_orders_list_view_item.dart';
import 'my_orders_shimmer.dart';

class MyOrdersListView extends ConsumerWidget {
  final double horizontalPadding;
  const MyOrdersListView({super.key, required this.horizontalPadding});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<OrderEntity>> ordersAsync = ref.watch(
      orderNotifierProvider,
    );
    return Expanded(
      child: ordersAsync.when(
        data:
            (orders) =>
                orders.isEmpty
                    ? const Center(
                      child: Text(
                        AppStrings.kNoOrdersFound,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                    : Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: horizontalPadding,
                      ),
                      child: ListView.separated(
                        itemBuilder:
                            (_, index) =>
                                MyOrdersListViewItem(order: orders[index]),
                        separatorBuilder: (_, __) => const SizedBox(height: 28),
                        itemCount: orders.length,
                      ),
                    ),
        error:
            (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.kErrorLoadingOrders.replaceAll(
                      '%s',
                      error.toString(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.refresh(orderNotifierProvider),
                    child: const Text(AppStrings.kRetry),
                  ),
                ],
              ),
            ),
        loading:
            () => MyOrdersListShimmer(horizontalPadding: horizontalPadding),
      ),
    );
  }
}

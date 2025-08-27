import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../checkout/domain/entities/order_entity.dart';
import 'order_details_header.dart';
import 'order_details_cart_items.dart';
import 'order_details_info_section.dart';
import 'order_details_actions.dart';

class OrderDetailsViewBody extends StatelessWidget {
  const OrderDetailsViewBody(this.order, {super.key});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    child: SingleChildScrollView(
      child: Column(
        spacing: 25,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          OrderDetailsHeader(order: order),
          OrderDetailsCartItems(cartItems: order.cartItems),
          OrderDetailsInfoSection(order: order),
          const SizedBox(height: 4),
          const OrderDetailsActions(),
          const SizedBox(height: 30),
        ],
      ),
    ),
  );
}

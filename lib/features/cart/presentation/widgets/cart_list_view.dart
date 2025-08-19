import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../domain/entities/cart_item_entity.dart';
import 'cart_list_view_item.dart';

class CartListView extends StatelessWidget {
  const CartListView({super.key, required this.cartItems});
  final List<CartItemEntity> cartItems;
  @override
  Widget build(BuildContext context) => ListView.separated(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: cartItems.length,
    itemBuilder: (context, index) {
      return CartListViewItem(cartItem: cartItems[index]);
    },
    separatorBuilder: (context, index) => SizedBox(height: 10.h),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'cart_list_view_item.dart';


class CartListView extends StatelessWidget {
  const CartListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      itemCount: 4,
    
      itemBuilder: (context, index) {
        return CartListViewItem();
      },
      separatorBuilder: (context, index) => SizedBox(height: 10.h),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../../core/widgets/summary_price.dart';
import 'cart_header.dart';
import 'cart_list_view.dart';
import 'cart_promo_field.dart';
import 'checkout_button.dart';

class CartViewBody extends StatelessWidget {
  const CartViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20),
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: CartHeader()),

          CartListView(),

          SliverToBoxAdapter(
            child: Column(
              spacing: 15,
              children: [
                SizedBox(height: 5),
                CartPromoField(),
                SummaryPriceTile(price: 50, title: AppStrings.kTotalAmount),

                CheckoutButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

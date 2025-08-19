import 'package:e_commerce/features/cart/presentation/widgets/cart_shimmer.dart';
import 'package:e_commerce/features/checkout/presentation/controller/visa_card/visa_card_providers.dart';

import '../../../../core/utils/app_styles.dart';
import '../controller/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../../core/widgets/summary_price.dart';
import '../../../../core/widgets/text_header.dart';
import 'cart_list_view.dart';
import 'cart_promo_field.dart';
import 'checkout_button.dart';

class CartViewBody extends StatelessWidget {
  const CartViewBody({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: 12.w),
    child: CustomScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 60.h),
              const TextHeader(title: AppStrings.kMyCart),
            ],
          ),
        ),

        // Use Consumer to control the whole sliver body
        Consumer(
          builder: (context, ref, child) {
            final userId = ref.read(currentUserServiceProvider).currentUserId;
            final state = ref.watch(cartControllerProvider(userId!));

            final cartTotal = ref.watch(cartTotalProvider(userId));

            return state.when(
              loading: () => const CartPageShimmer(),
              error:
                  (error, _) => SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: Text(error.toString())),
                  ),
              data: (data) {
                if (data.isEmpty) {
                  return SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        AppStrings.kNoItemsInCart,
                        style: AppStyles.font18PrimarySemiBold(context),
                      ),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildListDelegate([
                    CartListView(cartItems: data),

                    const SizedBox(height: 15),
                    Column(
                      spacing: 15,
                      children: [
                        const CartPromoField(),
                        SummaryPriceTile(
                          price: cartTotal.when(
                            data: (value) => value,
                            loading: () => 0.0,
                            error: (_, __) => 0.0,
                          ),
                          title: AppStrings.kTotalAmount,
                        ),
                        CheckoutButton(
                          cartTotal.whenData((value) => value).valueOrNull ??
                              0.0,
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                  ]),
                );
              },
            );
          },
        ),
      ],
    ),
  );
}

import 'package:e_commerce/core/helpers/methods/styled_snack_bar.dart';
import 'package:e_commerce/core/widgets/cached_image_widget.dart';
import 'package:e_commerce/features/checkout/presentation/controller/visa_card/visa_card_providers.dart';

import '../../../../core/helpers/extensions/context_extensions.dart';
import '../controller/cart_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';
import '../../domain/entities/cart_item_entity.dart';
import 'cart_item_quantity.dart';

class CartListViewItem extends StatelessWidget {
  const CartListViewItem({super.key, required this.cartItem});

  final CartItemEntity cartItem;
  @override
  Widget build(BuildContext context) {
    final themeColors = context.color;
    return SizedBox(
      height: 150.h,
      width: double.infinity,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  topLeft: Radius.circular(12),
                ),
                child: CachedImageWidget(imgUrl: cartItem.imageUrl),
              ),
            ),
            Expanded(
              flex: 3,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  color: themeColors.onSecondary,
                ),

                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.h,
                    horizontal: 10.w,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                spacing: 8.h,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    cartItem.name,
                                    style: AppStyles.font18BlackSemiBold(
                                      context,
                                    ).copyWith(height: 1),
                                  ),
                                  Row(
                                    spacing: 13.w,
                                    children: [
                                      Expanded(
                                        child: Text.rich(
                                          maxLines: 1,
                                          TextSpan(
                                            text: '${AppStrings.kColor}: ',
                                            style: AppStyles.font13BlackRegular(
                                              context,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: cartItem.selectedColor,
                                                style:
                                                    AppStyles.font13BlackMedium(
                                                      context,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text.rich(
                                          maxLines: 1,
                                          TextSpan(
                                            text: '${AppStrings.kSize}: ',
                                            style: AppStyles.font13BlackRegular(
                                              context,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: cartItem.selectedSize,
                                                style:
                                                    AppStyles.font13BlackMedium(
                                                      context,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Consumer(
                              builder: (context, ref, child) {
                                return GestureDetector(
                                  onTap: () {
                                    _cartItemDropDown(context, ref);
                                  },
                                  child: Icon(
                                    Icons.more_vert_outlined,
                                    color: themeColors.secondary,
                                    size: 24.w,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CartItemQuantity(cartItem: cartItem),
                          Text(
                            '${cartItem.price} \$',
                            style: AppStyles.font15BlackSemiBold(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _cartItemDropDown(BuildContext context, WidgetRef ref) {
    final themeColors = context.color;
    return showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 0, 0),
      items: [
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.favorite_border, color: themeColors.secondary),
              SizedBox(width: 8.w),
              Text(
                AppStrings.kAddToFavorites,
                style: AppStyles.font16BlackMedium(context),
              ),
            ],
          ),
          onTap: () async {
            final result = await ref
                .read(
                  cartControllerProvider(
                    FirebaseAuth.instance.currentUser!.uid,
                  ).notifier,
                )
                .addToFavorite(cartItem.productId);

            if (context.mounted) {
              result.fold(
                (failure) {
                  openStyledSnackBar(
                    context,
                    text: AppStrings.kFailedToAddToFavorites,
                    type: SnackBarType.error,
                  );
                },
                (success) {
                  openStyledSnackBar(
                    context,
                    text: AppStrings.kItemAddedToTheCart,
                    type: SnackBarType.success,
                  );
                },
              );
            }
          },
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.delete_outline, color: themeColors.error),
              SizedBox(width: 8.w),
              Text(
                AppStrings.kDeleteFromList,
                style: AppStyles.font16BlackMedium(context),
              ),
            ],
          ),
          onTap: () async {
            final currentUserId =
                ref.read(currentUserServiceProvider).currentUserId;
            await ref
                .read(cartControllerProvider(currentUserId!).notifier)
                .remove(cartItem.id);
          },
        ),
      ],
    );
  }
}

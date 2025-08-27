import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/cached_image_widget.dart';
import '../../../../core/helpers/extensions/context_extensions.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../cart/domain/entities/cart_item_entity.dart';

class OrderDetailsCartItems extends StatelessWidget {
  final List<CartItemEntity> cartItems;
  const OrderDetailsCartItems({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 18,
      children: [
        Text(
          '${cartItems.length} ${AppStrings.kItems}',
          style: AppStyles.font14BlackMedium(context),
        ),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: cartItems.length,
          itemBuilder: (context, index) {
            final cartItem = cartItems[index];
            return Container(
              height: 130.h,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: context.color.onPrimary.withValues(alpha: 0.2),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
                color: context.color.onSecondary,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 2,
                    child: ClipRRect(
                      borderRadius: BorderRadiusDirectional.only(
                        topStart: Radius.circular(8.r),
                        bottomStart: Radius.circular(8.r),
                      ),
                      child: CachedImageWidget(imgUrl: cartItem.imageUrl),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 8.h,
                        horizontal: 10.w,
                      ),
                      child: Column(
                        spacing: 4,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cartItem.name,
                            style: AppStyles.font16BlackSemiBold(context),
                          ),
                          Text(
                            AppStrings.kBrandLabel.replaceAll(
                              '%s',
                              cartItem.brand,
                            ),
                            style: AppStyles.font11GreyMedium(context),
                          ),
                          Row(
                            spacing: 16.w,
                            children: [
                              Expanded(
                                child: Text.rich(
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${AppStrings.kColor}: ',
                                        style: AppStyles.font11GreyMedium(
                                          context,
                                        ),
                                      ),
                                      TextSpan(
                                        text: cartItem.selectedColor,
                                        style: AppStyles.font11BlackMedium(
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
                                  overflow: TextOverflow.ellipsis,
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${AppStrings.kSize}: ',
                                        style: AppStyles.font11GreyMedium(
                                          context,
                                        ),
                                      ),
                                      TextSpan(
                                        text: cartItem.selectedSize,
                                        style: AppStyles.font11BlackMedium(
                                          context,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${AppStrings.kUnits}: ',
                                      style: AppStyles.font11GreyMedium(
                                        context,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '${cartItem.quantity}',
                                      style: AppStyles.font11BlackMedium(
                                        context,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '\$${cartItem.price.toStringAsFixed(2)}',
                                style: AppStyles.font14BlackSemiBold(context),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          separatorBuilder: (_, index) => const SizedBox(height: 24),
        ),
      ],
    );
  }
}

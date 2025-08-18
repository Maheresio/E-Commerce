import 'package:e_commerce/core/routing/app_route_constants.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/app_styles.dart';
import '../../domain/entities/product_entity.dart';
import 'home_list_view_item.dart';

class ProductDetailsInfo extends StatelessWidget {
  const ProductDetailsInfo({super.key, required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.brand,
                  overflow: TextOverflow.visible,

                  style: AppStyles.font24BlackSemiBold(
                    context,
                  ).copyWith(height: 1),
                ),
                const SizedBox(height: 4),
                Text(
                  product.name,
                  style: AppStyles.font12GreyMedium(context),
                  overflow: TextOverflow.visible,
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () {
                    context.push(AppRoutes.review, extra: product);
                  },
                  child: RatingAndReview(
                    rating: product.rating.floor(),
                    reviewCount: product.reviewCount,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            child: FittedBox(
              child: Text(
                '\$${product.price}',
                style: AppStyles.font24BlackSemiBold(context),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      Text(
        product.description,
        textAlign: TextAlign.start,
        style: AppStyles.font14BlackMedium(context).copyWith(height: 1.5),
      ),
    ],
  );
}

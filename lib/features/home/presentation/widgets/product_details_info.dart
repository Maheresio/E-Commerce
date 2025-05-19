import 'package:flutter/material.dart';

import '../../../../core/utils/app_styles.dart';
import '../../domain/entities/product_entity.dart';
import 'home_list_view_item.dart';

class ProductDetailsInfo extends StatelessWidget {
  const ProductDetailsInfo({super.key, required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    product.category,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.font24BlackSemiBold.copyWith(height: 1),
                  ),
                ),
                SizedBox(height: 4),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    product.title,
                    style: AppStyles.font11GreyRegular,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 8),
                RatingAndReview(
                  rating: product.rate,
                  reviewCount: product.reviewCount,
                ),
              ],
            ),
            Flexible(
              child: FittedBox(
                child: Text(
                  '\$${product.price}',
                  style: AppStyles.font24BlackSemiBold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Text(
          'Short dress in soft cotton jersey with decorative buttons down the front and a wide, frill-trimmed square neckline with concealed elastication. Elasticated seam under the bust and short puff sleeves with a small frill trim.',
          textAlign: TextAlign.start,
          style: AppStyles.font14BlackRegular.copyWith(height: 1.5),
        ),
      ],
    );
  }
}

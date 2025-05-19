import 'package:e_commerce/core/helpers/extensions/theme_color.extension.dart';
import 'package:e_commerce/core/utils/app_router.dart';
import 'package:e_commerce/core/utils/app_styles.dart';
import 'package:e_commerce/features/home/domain/entities/product_entity.dart';
import 'package:e_commerce/features/home/presentation/controller/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class HomeListViewItem extends StatelessWidget {
  const HomeListViewItem(this.product, {super.key});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRouter.kProductDetails, extra: product),
      child: SizedBox(
        height: 260.h,
        width: 150.w,
        child: Stack(
          children: [
            ProductItem(product),
            if (product.discountValue != 0)
              Positioned(
                top: 8,
                left: 8,
                child: DiscountText(product.discountValue),
              ),
            Positioned(
              right: 0,
              bottom: 105,
              child: HomeFavoriteWidget(
                id: product.id,
                isFavorite: product.isFavorite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  const ProductItem(this.product, {super.key});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductImage(product.imgUrl),
        SizedBox(height: 7),

        RatingAndReview(rating: product.rate, reviewCount: product.reviewCount),
        SizedBox(height: 6),
        HomeProductInfo(title: product.title, category: product.category),
        SizedBox(height: 3),
        ProductPrice(
          price: product.price,
          discountValue: product.discountValue,
        ),
      ],
    );
  }
}

class HomeProductInfo extends StatelessWidget {
  const HomeProductInfo({
    super.key,
    required this.title,
    required this.category,
  });

  final String title;
  final String category;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category,
          style: AppStyles.font11GreyMedium.copyWith(height: 1),

          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 5),
        Text(
          title,
          style: AppStyles.font16BlackSemiBold.copyWith(height: 1.2),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ],
    );
  }
}

class ProductPrice extends StatelessWidget {
  const ProductPrice({
    super.key,
    required this.price,
    required this.discountValue,
  });

  final double price;
  final int discountValue;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: '${price.toStringAsFixed(2)}\$ ',
        style: AppStyles.font14GreyMedium.copyWith(
          decoration:
              discountValue != 0
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
        ),
        children: [
          if (discountValue != 0)
            TextSpan(
              text:
                  '${(price - (price * discountValue / 100)).toStringAsFixed(2)}\$',
              style: AppStyles.font14PrimaryMedium.copyWith(
                decoration: TextDecoration.none,
              ),
            ),
        ],
      ),
    );
  }
}

class RatingAndReview extends StatelessWidget {
  const RatingAndReview({
    super.key,
    required this.rating,
    required this.reviewCount,
  });

  final int rating;
  final int reviewCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: List.generate(rating, (index) {
            return Icon(Icons.star, color: Colors.amber, size: 16);
          }),
        ),
        SizedBox(width: 4),
        Text('($reviewCount)', style: AppStyles.font11BlackRegular),
      ],
    );
  }
}

class ProductImage extends StatelessWidget {
  const ProductImage(this.imgUrl, {super.key});

  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 184.h,
      width: 148.w,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(imgUrl, fit: BoxFit.cover),
      ),
    );
  }
}

class DiscountText extends StatelessWidget {
  const DiscountText(this.discountValue, {super.key});

  final int discountValue;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      width: 40,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.color.primary,
          borderRadius: BorderRadius.circular(29),
        ),
        child: Center(
          child: Text(
            '-$discountValue%',
            style: AppStyles.font11WhiteSemiBold,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class HomeFavoriteWidget extends ConsumerWidget {
  const HomeFavoriteWidget({
    super.key,
    required this.id,
    required this.isFavorite,
  });
  final bool isFavorite;
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(
          updateProductProvider(
            UpdateParams(id: id, data: {'isFavorite': !isFavorite}),
          ),
        );
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.color.onSecondary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              isFavorite
                  ? Icon(Icons.favorite, color: context.color.primary)
                  : Icon(Icons.favorite_border, color: context.color.secondary),
        ),
      ),
    );
  }
}

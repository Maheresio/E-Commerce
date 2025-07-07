import 'package:e_commerce/core/responsive/responsive_value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/helpers/extensions/context_extensions.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/utils/app_styles.dart';
import '../../domain/entities/product_entity.dart';
import '../controller/home_provider.dart';

class HomeListViewItem extends StatelessWidget {
  const HomeListViewItem(this.product, {super.key});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRouter.kProductDetails, extra: product),
      child: SizedBox(
        width: responsiveValue(mobile: 150.w, tablet: 250.w),
        child: Stack(
          children: [
            ProductItem(product),
            if (product.discountValue != 0)
              Positioned.directional(
                textDirection: TextDirection.ltr,
                top: responsiveValue(mobile: 16.h, tablet: 24.h),
                start: responsiveValue(mobile: 16.w, tablet: 24.w),
                child: DiscountText(product.discountValue),
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
      spacing: 8,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ProductImage(product.imageUrls.entries.first.value.first),

            Positioned.directional(
              textDirection: TextDirection.ltr,
              bottom: 0,
              end: 0,
              child: HomeFavoriteWidget(
                id: product.id,
                isFavorite: product.isFavorite,
              ),
            ),
          ],
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            RatingAndReview(
              rating: product.rating.floor(),
              reviewCount: product.reviewCount,
            ),
            SizedBox(height: 6),
            HomeProductInfo(title: product.name, category: product.category),
            SizedBox(height: 3),
            ProductPrice(
              price: product.price,
              discountValue: product.discountValue,
            ),
          ],
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
          style: AppStyles.font11GreyMedium(context).copyWith(height: 1),

          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 5),
        Text(
          title,
          style: AppStyles.font16BlackSemiBold(context).copyWith(height: 1.2),
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
        style:
            discountValue != 0
                ? AppStyles.font14GreyMedium(
                  context,
                ).copyWith(decoration: TextDecoration.lineThrough)
                : AppStyles.font14PrimaryMedium(context),
        children: [
          if (discountValue != 0)
            TextSpan(
              text:
                  '${(price - (price * discountValue / 100)).toStringAsFixed(2)}\$',
              style: AppStyles.font14PrimaryMedium(
                context,
              ).copyWith(decoration: TextDecoration.none),
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
            return Icon(
              Icons.star,
              color: context.color.tertiary,
              size: responsiveValue(mobile: 16.w, tablet: 32.w),
            );
          }),
        ),
        SizedBox(width: 4),
        Text('($reviewCount)', style: AppStyles.font11BlackRegular(context)),
      ],
    );
  }
}

class ProductImage extends StatelessWidget {
  const ProductImage(this.imgUrl, {super.key});

  final String imgUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: AspectRatio(
        aspectRatio: responsiveValue(mobile: .8, tablet: 1),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(imgUrl, fit: BoxFit.cover),
        ),
      ),
    );
  }
}

class DiscountText extends StatelessWidget {
  const DiscountText(this.discountValue, {super.key});

  final int discountValue;
  @override
  Widget build(BuildContext context) {
    //  height: 24.h,
    //   width: 40,
    return SizedBox(
      height: responsiveValue(mobile: 24.h, tablet: 50.h),
      width: responsiveValue(mobile: 40.w, tablet: 80.w),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.color.primary,
          borderRadius: BorderRadius.circular(29),
        ),
        child: Center(
          child: Text(
            '-$discountValue%',
            style: AppStyles.font11WhiteSemiBold(context),
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
        debugPrint('Favorite tapped for product ID: $id');
        ref.read(
          updateProductProvider(
            UpdateParams(id: id, data: {'isFavorite': !isFavorite}),
          ),
        );
      },
      child: Container(
        width: responsiveValue(mobile: 32.w, tablet: 60.w),
        height: responsiveValue(mobile: 32.h, tablet: 60.h),
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
        child: FittedBox(
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child:
                isFavorite
                    ? Icon(Icons.favorite, color: context.color.primary)
                    : Icon(
                      Icons.favorite_border,
                      color: context.color.secondary,
                    ),
          ),
        ),
      ),
    );
  }
}

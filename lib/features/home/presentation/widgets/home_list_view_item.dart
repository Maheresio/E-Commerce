import 'package:e_commerce/core/routing/app_route_constants.dart';
import 'package:e_commerce/features/checkout/presentation/controller/visa_card/visa_card_providers.dart';

import '../../../../core/responsive/responsive_value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/helpers/extensions/context_extensions.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../favorite/presentation/controller/favorite_controller.dart';
import '../../domain/entities/product_entity.dart';

class HomeListViewItem extends StatelessWidget {
  const HomeListViewItem(this.product, {super.key, this.favoriteIcon = true});

  final ProductEntity product;
  final bool favoriteIcon;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => context.push(AppRoutes.productDetails, extra: product),
    child: SizedBox(
      width: context.responsive(mobile: 150.w, tablet: 250.w),
      child: Stack(
        children: [
          ProductItem(product, favoriteIcon: favoriteIcon),
          if (product.discountValue != 0)
            Positioned.directional(
              textDirection: TextDirection.ltr,
              top: context.responsive(mobile: 16.h, tablet: 24.h),
              start: context.responsive(mobile: 16.w, tablet: 24.w),
              child: DiscountText(product.discountValue),
            ),
        ],
      ),
    ),
  );
}

class ProductItem extends StatelessWidget {
  const ProductItem(this.product, {super.key, this.favoriteIcon = true});

  final ProductEntity product;
  final bool favoriteIcon;

  @override
  Widget build(BuildContext context) => Column(
    spacing: 8,
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Stack(
        children: [
          ProductImage(product.imageUrls.entries.first.value.first),

          if (favoriteIcon)
            Positioned.directional(
              textDirection: TextDirection.ltr,
              bottom: 0,
              end: 0,
              child: HomeFavoriteWidget(product: product),
            ),
        ],
      ),

      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: context.responsive(mobile: 8, tablet: 12),
        children: [
          RatingAndReview(
            rating: product.rating.floor(),
            reviewCount: product.reviewCount,
          ),
          HomeProductInfo(title: product.name, category: product.brand),
          ProductPrice(
            price: product.price,
            discountValue: product.discountValue,
          ),
        ],
      ),
    ],
  );
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
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        category,
        style: AppStyles.font11GreyMedium(context).copyWith(height: 1),

        overflow: TextOverflow.ellipsis,
      ),
      SizedBox(height: context.responsive(mobile: 8, tablet: 12)),
      Text(
        title,
        style: AppStyles.font16BlackSemiBold(context).copyWith(height: 1.2),
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    ],
  );
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
  Widget build(BuildContext context) => Text.rich(
    style: const TextStyle(height: 1),
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

class RatingAndReview extends StatelessWidget {
  const RatingAndReview({
    super.key,
    required this.rating,
    required this.reviewCount,
  });

  final int rating;
  final int reviewCount;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Row(
        children: List.generate(rating, (index) {
          return Icon(
            Icons.star,
            color: context.color.tertiary,
            size: context.responsive(mobile: 16.w, tablet: 32.w),
          );
        }),
      ),
      const SizedBox(width: 4),
      Text('($reviewCount)', style: AppStyles.font11GreyMedium(context)),
    ],
  );
}

class ProductImage extends StatelessWidget {
  const ProductImage(this.imgUrl, {super.key});

  final String imgUrl;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
    child: AspectRatio(
      aspectRatio: context.responsive(mobile: .8, tablet: 1),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(imgUrl, fit: BoxFit.cover),
      ),
    ),
  );
}

class DiscountText extends StatelessWidget {
  const DiscountText(this.discountValue, {super.key});

  final int discountValue;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.responsive(mobile: 24.h, tablet: 50.h),
      width: context.responsive(mobile: 40.w, tablet: 80.w),
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
  const HomeFavoriteWidget({super.key, required this.product});
  final ProductEntity product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColors = context.color;
    final String userId = ref.read(currentUserServiceProvider).currentUserId!;

    final bool? favoritesAsync = ref.watch(
      favoritesControllerProvider(userId).select(
        (AsyncValue<List<ProductEntity>> async) => async.when(
          data:
              (List<ProductEntity> favorites) =>
                  favorites.any((ProductEntity fav) => fav.id == product.id),
          loading: () => null,
          error: (_, _) => false,
        ),
      ),
    );

    final FavoritesController provider = ref.read(
      favoritesControllerProvider(userId).notifier,
    );

    return GestureDetector(
      onTap: () async {
        final List<ProductEntity> currentFavorites =
            ref.read(favoritesControllerProvider(userId)).value ??
            <ProductEntity>[];
        final bool isFavorite = currentFavorites.any(
          (ProductEntity fav) => fav.id == product.id,
        );

        if (isFavorite) {
          await provider.removeFavorite(product.id);
        } else {
          await provider.addFavorite(product);
        }
      },
      child: Container(
        width: context.responsive(mobile: 32.w, tablet: 60.w),
        height: context.responsive(mobile: 32.h, tablet: 60.h),
        decoration: BoxDecoration(
          color: themeColors.onSecondary,
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: FittedBox(
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child:
                  favoritesAsync == null
                      ? Icon(
                        Icons.favorite_outline,
                        key: const ValueKey('loading_heart'),
                        color: themeColors.primary.withValues(alpha: 0.5),
                      )
                      : favoritesAsync
                      ? Icon(
                        Icons.favorite,
                        key: const ValueKey('filled_heart'),
                        color: themeColors.primary,
                      )
                      : Icon(
                        Icons.favorite_border,
                        key: const ValueKey('outlined_heart'),
                        color: themeColors.secondary,
                      ),
            ),
          ),
        ),
      ),
    );
  }
}

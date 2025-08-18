import 'package:e_commerce/core/helpers/methods/styled_snack_bar.dart';

import '../../../cart/domain/entities/cart_item_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/helpers/extensions/context_extensions.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/widgets/product_info_tile.dart';
import '../../../cart/presentation/controller/cart_provider.dart';
import '../../../favorite/presentation/controller/favorite_controller.dart';
import '../../domain/entities/product_entity.dart';
import '../controller/product_details_provider.dart';
import 'product_details_image_slider.dart';
import 'product_details_info.dart';
import 'size_color_favorite_selector.dart';

class ProductDetailsViewBody extends StatelessWidget {
  const ProductDetailsViewBody(this.product, {super.key});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ProductDetailsImageSlider(product: product),

        const SizedBox(height: 12),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizeColorFavoriteSelector(product: product),

              const SizedBox(height: 22),
              ProductDetailsInfo(product: product),
              const SizedBox(height: 16),
              AddToCartButton(product: product),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ProductInfoTile(title: AppStrings.kShippingInfo, onTap: () {}),
        ProductInfoTile(title: AppStrings.kSupport, onTap: () {}),
        const SizedBox(height: 16),
      ],
    ),
  );
}

class AddToCartButton extends ConsumerWidget {
  const AddToCartButton({super.key, required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ProductSelection selected = ref.watch(productSelectionProvider);
    return ElevatedButton(
      onPressed: () async {
        if (selected.color != AppStrings.kColor &&
            selected.size != AppStrings.kSize) {
          final ProductSelection params = ref.read(productSelectionProvider);
          await ref
              .read(
                cartControllerProvider(
                  FirebaseAuth.instance.currentUser!.uid,
                ).notifier,
              )
              .addOrUpdate(
                CartItemEntity(
                  id: const Uuid().v4(),
                  productId: product.id,
                  quantity: 1, // This will be handled by smartAddOrUpdate
                  selectedSize: params.size,
                  selectedColor: params.color,
                  imageUrl: product.imageUrls[selected.color]!.first,
                  name: product.name,
                  price: product.price,
                  brand: product.brand,
                ),
              );

          ref.read(productSelectionProvider.notifier).reset();
          if (context.mounted) {
            openStyledSnackBar(
              context,
              text: AppStrings.kItemAddedToTheCart,
              type: SnackBarType.success,
            );
          }
        } else {
          openStyledSnackBar(
            context,
            text: AppStrings.kSelectColorAndSizeBeforeAdd,
            type: SnackBarType.error,
          );
        }
      },
      child: Text(AppStrings.kAddToCart.toUpperCase()),
    );
  }
}

class ProductDetailsFavoriteWidget extends ConsumerWidget {
  const ProductDetailsFavoriteWidget({super.key, required this.product});
  final ProductEntity product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    final themeColors = context.color;

    // Use select to optimize stream listening for this specific product

    final bool? isFavoriteAsync = ref.watch(
      favoritesControllerProvider(userId).select(
        (AsyncValue<List<ProductEntity>> async) => async.when(
          data:
              (List<ProductEntity> favorites) =>
                  favorites.any((ProductEntity fav) => fav.id == product.id),
          loading: () => null,
          error: (_, __) => false,
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

        // Optimistic update for immediate UI feedback
        if (isFavorite) {
          await provider.removeFavorite(product.id);
        } else {
          await provider.addFavorite(product);
        }
      },
      child: DecoratedBox(
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
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: FittedBox(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child:
                  isFavoriteAsync == null
                      ? Icon(
                        Icons.favorite_outline,
                        key: const ValueKey('loading_heart'),
                        color: themeColors.primary.withValues(alpha: 0.5),
                      )
                      : isFavoriteAsync
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

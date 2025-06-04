import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/extensions/theme_color.extension.dart';
import '../../../../core/helpers/methods/product_lists.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/widgets/product_info_tile.dart';
import '../../domain/entities/product_entity.dart';
import '../controller/home_provider.dart';
import 'product_details_image_slider.dart';
import 'product_details_info.dart';
import 'size_color_favorite_selector.dart';

class ProductDetailsViewBody extends StatelessWidget {
  const ProductDetailsViewBody(this.product, {super.key});

  final ProductEntity product;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductDetailsImageSlider(product: product),

          SizedBox(height: 12),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                SizeColorFavoriteSelector(sizes: sizes, product: product),

                SizedBox(height: 22),
                ProductDetailsInfo(product: product),
                SizedBox(height: 16),
                AddToCartButton(),
              ],
            ),
          ),
          SizedBox(height: 16),
          ProductInfoTile(title: AppStrings.kShippingInfo, onTap: () {}),
          ProductInfoTile(title: AppStrings.kSupport, onTap: () {}),
        ],
      ),
    );
  }
}

class AddToCartButton extends StatelessWidget {
  const AddToCartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Text(AppStrings.kAddToCart.toUpperCase()),
    );
  }
}

class ProductDetailsFavoriteWidget extends ConsumerStatefulWidget {
  const ProductDetailsFavoriteWidget({
    super.key,
    required this.id,
    required this.isFavorite,
  });
  final bool isFavorite;
  final String id;

  @override
  ConsumerState<ProductDetailsFavoriteWidget> createState() =>
      _FavoriteWidgetState();
}

class _FavoriteWidgetState extends ConsumerState<ProductDetailsFavoriteWidget> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ref.read(
          updateProductProvider(
            UpdateParams(id: widget.id, data: {'isFavorite': !isFavorite}),
          ),
        );
        setState(() {
          isFavorite = !isFavorite;
        });
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

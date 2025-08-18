import '../controller/product_details_provider.dart';
import 'select_field.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_strings.dart';
import '../../domain/entities/product_entity.dart';
import 'product_details_view_body.dart';

class SizeColorFavoriteSelector extends ConsumerWidget {
  const SizeColorFavoriteSelector({super.key, required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ProductSelection selection = ref.watch(productSelectionProvider);
    return Row(
      spacing: 16.w,
      children: <Widget>[
        Expanded(
          child: SelectField(
            value: selection.size,
            title: AppStrings.kSelectSize,
            options: product.sizes,
            infoTitle: AppStrings.kSizeInfo,
            onSelected: (String size) {
              ref.read(productSelectionProvider.notifier).updateSize(size);
            },
            selectedOption: selection.size,
            onInfoTap: () {},
          ),
        ),

        Expanded(
          child: SelectField(
            value: selection.color,
            title: AppStrings.kSelectColor,
            options: product.colors,
            infoTitle: AppStrings.kColorInfo,
            onSelected: (String color) {
              ref.read(productSelectionProvider.notifier).updateColor(color);
            },
            selectedOption: selection.color,
          ),
        ),
        ProductDetailsFavoriteWidget(product: product),
      ],
    );
  }
}
